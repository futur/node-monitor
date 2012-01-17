/* services.js */

/**
 * A plugin for monitoring running applications.
 */
var Modules, Plugin;

var fs = require('fs');
Modules = {
  net: 'net'
};

Plugin = {
  name: 'services',
  command: '',
  type: 'poll'
};

this.name = Plugin.name;
this.type = Plugin.type;

Plugin.format = function (status, name) {
  var response;
  
  response = {
    service: name,
    status: status
  };
  return JSON.stringify(response);
};

Plugin.evaluateDeps = function (self) {
  for (var name in Modules) {
    eval('var ' + name + ' = require(\'' + Modules[name] + '\')');
  }
  self.net = net;
};

this.poll = function (constants, utilities, logger, callback) {
  self = this;
  self.constants = constants;
  self.utilities = utilities;
  self.logger = logger;

  Plugin.evaluateDeps(self);
  
  var services = [], buffer = [];

  /* Allow for dynamic config by reading each poll */
  fs.readFile(self.name + '_config', function (error, fd) {
    if (error)
      self.utilities.exit('Error reading ' + self.name + ' plugin config file');
      
    function Service(name, port) {
      this.name = name;
      this.port = port;
    }
    
    buffer = fd.toString().split('\n');
    for (var i = 0; i < buffer.length; i++) {
      var service;
	  
      service = buffer[i].split('=');
      if (!self.utilities.isEmpty(service[0]) && !self.utilities.isEmpty(service[1])) {
        self.logger.write(self.constants.levels.INFO, 'Checking for service ' + service[0] + ', port: ' + service[1]);
        services.push(new Service(service[0], Number(service[1])));
      } else {
        /* Assign a non-existant port so we know which command to run */
        if (!self.utilities.isEmpty(service[0])) {
          self.logger.write(self.constants.levels.INFO, 'Checking for service ' + service[0]);
          services.push(new Service(service[0], 0));
        }
      }
    }
    services.forEach(function (service) {
      var exec, status;
    	
      if (service.port != 0) {
        Plugin.command = 'lsof -i :' + service.port;
      } else {
        Plugin.command = 'ps ax | grep -v grep | grep -v tail | grep ' + service.name;
      }
        
      self.utilities.run(Plugin.command, function(response) {
    	self.logger.write(self.constants.levels.INFO, 'Response: ' + response);
        if (self.utilities.isEmpty(response)) {
          status = '0';
          self.logger.write(self.constants.levels.INFO, service.name + ' is NOT running');
        } else {
          status = '1';
          self.logger.write(self.constants.levels.INFO, service.name + ' is running');
        }
        callback(Plugin.name, 'RunningProcess-' + service.name, 'None', status, Plugin.format(status, service.name));
      });
    });
  });
};