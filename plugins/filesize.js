/* filesize.js */
/**
 * A plugin for monitoring file sizes.
 */
var fs = require('fs');

var Plugin = {
    name: 'filesize',
    command: '',
    type: 'poll'
};

this.name = Plugin.name;
this.type = Plugin.type;

Plugin.format = function (fileName, fileSize) {
    fileName = fileName.replace(/(\r\n|\n|\r)/gm, '');
    fileSize = fileSize.toString().replace(/(\r\n|\n|\r)/gm, '');
    fileSize = Number(fileSize) * 1024;
    data = {
        file: fileName,
        size: fileSize.toString()
    };
    return JSON.stringify(data);
};

this.poll = function (constants, utilities, logger, callback) {
    self = this;
    self.constants = constants;
    self.utilities = utilities;
    self.logger = logger;

    var files = [];
    fs.readFile(self.name + '_config', function (error, fd) {
        if (error) self.utilities.exit('Error reading ' + self.name + ' plugin config file');

        function fileCheck(name, sizeLimit) {
            this.name = name;
            this.sizeLimit = sizeLimit;
        }

        var status;
        var splitBuffer = [];
        splitBuffer = fd.toString().split('\n');
        for (i = 0; i < splitBuffer.length; i++) {
            var aFile = [];
            aFile = splitBuffer[i].split('=');
            self.logger.write(self.constants.levels.INFO, 'Read file: ' + aFile[0] + ' with limit: ' + aFile[1]);
            files.push(new fileCheck(aFile[0], Number(aFile[1])));
        }

        files.forEach(function (file) {
            if (file.sizeLimit != '' && file.name != '') {
                fs.stat(file.name, function (error, stat) {
                    if (error) 
                    	self.logger.write(self.constants.levels.WARNING, 'Error reading filesize for: ' + file.name);
                    
                    if (Number(stat.size) > Number(file.sizeLimit)) {
                        self.logger.write(self.constants.levels.INFO, 'Emptying file ' + file.name + ', ' + file.sizeLimit + ' exceeds limit');
                        fs.writeFile(file.name, '', function (error) {
                            if (error) 
                            	self.logger.write(Module.constants.levels.WARNING, 'Error emptying file: ' + error);

                        });
                    } else {
                        self.logger.write(self.constants.levels.INFO, 'Filesize for ' + file.name + ' is OK');
                    }
                    callback(Plugin.name, 'FileSize-' + file.name, 'Kilobytes', stat.size, Plugin.format(file.name, stat.size));
                });
            }
        });
    });
};