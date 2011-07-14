/**
 * node-monitor 
 */
 
var fs = require('fs'); 
 
var dependencies = {
	
	tls: 'tls',
	websock: '../lib/websocket-server',
	net: 'net'
	
}; 
 
var modules = {

	loggingManager: '../modules/logging-manager.js',
	filehandlerManager: '../modules/filehandler-manager.js',
	daoManager: '../modules/dao-manager.js',
	wellnessManager: '../modules/wellness-manager.js',
	bulkpostManager: '../modules/bulkpost-manager.js',
	pluginsManager: '../modules/plugins-manager.js',
	credentialManager: '../modules/credential-manager.js'
	
};

var childDeps = {
		
	stack: '../lib/long-stack-traces',
	utilitiesManager: '../modules-children/utilities-manager.js',  
	constantsManager: '../modules-children/constants-manager.js',
	cloudsandra: '../modules-children/node-cloudsandra',
	cloudwatch: '../modules-children/node-cloudwatch',	
	config: '../config/config'

};

for (var name in dependencies) {
	eval('var ' + name + '= require(\'' + dependencies[name] + '\')');
}

for (var name in modules) {
	eval('var ' + name + '= require(\'' + modules[name] + '\')');
}

for (var name in childDeps) {
	eval('var ' + name + '= require(\'' + childDeps[name] + '\')');
}

var utilities = new utilitiesManager.UtilitiesManagerModule();
var constants = new constantsManager.ConstantsManagerModule();
var logger = new loggingManager.LoggingManagerModule(childDeps);
var dao = new daoManager.DaoManagerModule(childDeps);
var filehandler = new filehandlerManager.FilehandlerManagerModule(childDeps);
var credentials = new credentialManager.CredentialManagerModule(childDeps);

var NodeMonitor = {

	init: false,
	serverConnection: false,
	plugins: {},
	logsToMonitor: [],
	websocketServer: websock.createServer({debug: false})
	
};

NodeMonitor.start = function() {

	credentials.check();

	logger.write(constants.levels.INFO, 'Starting Node Monitor');
	
	if (config.alerts)	
		logger.write(constants.levels.INFO, 'Alerts enabled');

	try {
		filehandler.empty('nohup.out');
	} catch (Exception) {
		logger.write(constants.levels.WARNING, 'Error emptying nohup.out file: ' + Exception);
	}
	
	try {
		filehandler.empty(config.logFile);
	} catch (Exception) {
		logger.write(constants.levels.WARNING, 'Error emptying nohup.out file: ' + Exception);
	}			
	
	// dao.storeSelf(constants.api.CLIENTS, config.clientIP, config.externalIP);
	
	NodeMonitor.startPolling();
	
	try {
		NodeMonitor.serverConnect();
	} catch (Exception) {
		logger.write(constants.levels.WARNING, 'Error connection to Monitoring Server: ' + Exception);
	}
	
	if (config.websocket)
		NodeMonitor.openWebsocket();
		
};

NodeMonitor.startPolling = function() {	

	var keepalive = new wellnessManager.WellnessManagerModule(childDeps);
	var bulkpost = new bulkpostManager.BulkpostManagerModule(NodeMonitor, childDeps);
	var plugins = new pluginsManager.PluginsManagerModule(NodeMonitor, childDeps);

	keepalive.start();
	bulkpost.start();
	plugins.start();
			
	//var logMonitorModule = require('../modules/log-manager');
	//new logMonitorModule.LogMonitorModule(this);
	
};

NodeMonitor.setInit = function() {
	
	NodeMonitor.init = true;
	
	logger.write(constants.levels.INFO, 'We have initialized the connection to the Monitoring Server');
	
};

NodeMonitor.onConnect = function (serverAddress) {

	NodeMonitor.serverConnection.connected = true;
	NodeMonitor.serverConnection.setEncoding('utf-8');
	
	logger.write(constants.levels.INFO, 'Connected to Monitoring Server at ' + serverAddress + ':' + config.clientToServerPort);
		
	if (NodeMonitor.reconnecting)
		NodeMonitor.reconnecting = false;
	
	if (NodeMonitor.init == false) {
		NodeMonitor.setInit();
	} else {
		logger.write(constants.levels.INFO, 'Skipping polling actions on re-connect, they are already established');
	}
	
};

NodeMonitor.serverReconnect = function() {	

	NodeMonitor.reconnecting = true;
	
	logger.write(constants.levels.INFO, 'Attempting reconnect to server in ' + config.serverReconnectTime + ' seconds');
	
	setTimeout(
		function() {
			logger.write(constants.levels.WARNING, 'Tried to reconnect');
			NodeMonitor.serverConnect();
		}, 
		config.serverReconnectTime
	);
	
};

NodeMonitor.handleConnectionError = function (exception) {

	logger.write(constants.levels.SEVERE, 'A connection issue has arisen: ' + exception.message);
	
	if (!NodeMonitor.init)
		logger.write(constants.levels.WARNING, 'Error on initial connection to server, load plugins anyway and write server requests to commit_log locally');

	NodeMonitor.serverReconnect();
};

NodeMonitor.handleTimeoutError = function() {

	logger.write(constants.levels.SEVERE, 'A connection to the Monitoring Server timed out');
	
	if (!NodeMonitor.reconnecting)
		NodeMonitor.serverReconnect();
		
};

NodeMonitor.serverConnect = function() {

	var serverAddress;
	if (config.onEC2) {
		logger.write(constants.levels.INFO, 'Configuring Monitoring Server IP as internal');
		serverAddress = config.serverIP;
	} else {
		logger.write(constants.levels.INFO, 'Configuring Monitoring Server IP as external');
		serverAddress = config.serverExternalIP;
	}

	if (config.ssl) {
		logger.write(constants.levels.INFO, 'SSL enabled');
		
		var certPem = fs.readFileSync('../ssl/test-cert.pem', encoding='ascii');
		var caPem = fs.readFileSync('../ssl/test-cert.pem', encoding='ascii');
		var options = {
			cert: certPem, 
			ca: caPem 
		};
		
		NodeMonitor.serverConnection = tls.connect(config.clientToServerPort, serverAddress, options, function() {			
			if (NodeMonitor.serverConnection.authorizationError) {
			   	logger.write(constants.levels.WARNING, 'Authorization Error: ' + NodeMonitor.serverConnection.authorizationError);
			} else {
			     logger.write(constants.levels.INFO, 'Authorized a Secure SSL/TLS Connection');
			     NodeMonitor.onConnect(serverAddress);
			}
		});
		
		NodeMonitor.serverConnection.on('data', 
			function() {
				logger.write(constants.levels.INFO, 'Received a message from the server: ' + data);
				clientApi.handleDataRequest(data);
			}
		);
	} else {
		logger.write(constants.levels.INFO, 'No SSL support, trying connection on: ' + serverAddress);
		
		NodeMonitor.serverConnection = net.createConnection(config.clientToServerPort, serverAddress);	
		
		NodeMonitor.serverConnection.on('connect', 
			function() {
			 	NodeMonitor.onConnect(serverAddress);
			}
		);	
	}
	
	NodeMonitor.serverConnection.on('error', 
		function(exception) {
			NodeMonitor.handleConnectionError(exception);
		}
	);
	
	NodeMonitor.serverConnection.on('timeout', 
		function() {
			NodeMonitor.handleTimeoutError();
		}
	);
	
};

/**
*
* Handle simple key, column value data being stored.
* CFUTF8Type ['rowKey'][IP] = '{data}'
*/
NodeMonitor.sendDataLookup = function (key, data) {

	var jsonString = utilities.formatLookupBroadcastData(key, utilities.generateEpocTime(), data, config.clientIP);
	
	logger.write(constants.levels.INFO, 'Data string being sent for lookup: ' + jsonString);
	
	NodeMonitor.storeData(jsonString);
	
};

/**
*
* Handle time based data being stored.
* CFLongType ['rowKey:YYYY:MM:DD'][EPOC] = '{data}'
*/
NodeMonitor.sendData = function (name, key, data) {	

	var jsonString = utilities.formatBroadcastData(name, key, utilities.generateEpocTime(), data, config.clientIP);
	
	logger.write(constants.levels.INFO, 'Data string being sent for date queries: ' + jsonString);
	
	NodeMonitor.storeData(jsonString);
	
};

/**
*
* Handle how often data is stored, e.g. always bulk post for heavy nodes,
* or post in realtime for better alerting on lighter, but important, nodes
*/
NodeMonitor.storeData = function (jsonString) {

	var assertObject = utilities.dataChecker(jsonString);
	
	if (assertObject.assert) { 	
	
		logger.write(constants.levels.INFO, 'Assert returned true, storing this data');
		
		if (config.realtime) {
			dao.handleDataStorage(assertObject);
		} else {
			failsafe.commit(jsonString);
			NodeMonitor.websocketServer.broadcast(jsonString);
		}
	} else {
		logger.write(constants.levels.WARNING, 'Assert failed, not storing this data');
	}	
	
};

/**
* Handle requests/changes from server
*/
NodeMonitor.messageHandler = function() {

	/*
	if (this.serverConnection.readyState != 'open' && this.serverConnection.readyState != 'writeOnly') {
		logger.write(constants.levels.INFO, 'Error: socket not ready, skipping transmission and writing to commit_log');
		if (!NodeMonitor.reconnecting)
			NodeMonitor.serverReconnect();
			
		if (NodeMonitor.reconnecting)
			failsafe.commit(jsonString);
			
		return;
	} 

	this.serverConnection.write(config.startDelimiter + jsonString + config.endDelimiter, 'utf8');
	*/
	
};

/** 
 * Push all data to UI if requested, TLS by default
 */
NodeMonitor.openWebsocket = function() {

	NodeMonitor.websocketServer.addListener('connection', function(conn) {
	
		logger.write(constants.levels.INFO, 'Listening for websocket connections on: ' + NodeMonitor.config.websocketRealtimePort);
		logger.write(constants.levels.INFO, 'Opened websocket connection to UI: ' + conn.id);
	 
 		conn.addListener('message', function(jsonObject) {
 			/**
 			* Do nothing with this connection but push data
 			*/
 		});
	});
	
	NodeMonitor.websocketServer.on('error', function (exception) {
		logger.write(constants.levels.WARNING, 'Catching a websocket exception: ' + exception);
	});
	
	NodeMonitor.websocketServer.listen(config.websocketRealtimePort);
		
	NodeMonitor.websocketServer.addListener('close', function(conn) {
		logger.write(constants.levels.INFO, 'Closed websocket connection to UI: ' + conn.id);
	});
	
};


NodeMonitor.start();