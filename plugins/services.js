/**
 * services.js A plugin for monitoring running applications.
 */
var Modules, Plugin, fs;
Modules = void 0;
Plugin = void 0;
fs = require("fs");
Modules = {
  net: "net"
};
Plugin = {
  name: "services",
  command: "",
  type: "poll"
};
this.name = Plugin.name;
this.type = Plugin.type;
Plugin.format = function(status, name) {
  var response;
  response = void 0;
  response = {
    service: name,
    status: status
  };
  return JSON.stringify(response);
};
Plugin.evaluateDeps = function(self) {
  var name;
  for (name in Modules) {
    eval("var " + name + " = require('" + Modules[name] + "')");
  }
  return self.net = net;
};
this.poll = function(constants, utilities, logger, callback) {
  var buffer, self, services;
  self = this;
  self.constants = constants;
  self.utilities = utilities;
  self.logger = logger;
  Plugin.evaluateDeps(self);
  services = [];
  buffer = [];
  return fs.readFile(self.name + "_config", function(error, fd) {
    var Service, i, service;
    Service = function(name, port) {
      this.name = name;
      return this.port = port;
    };
    if (error) {
      self.utilities.exit("Error reading " + self.name + " plugin config file");
    }
    buffer = fd.toString().split("\n");
    i = 0;
    while (i < buffer.length) {
      service = void 0;
      service = buffer[i].split("=");
      if (!self.utilities.isEmpty(service[0]) && !self.utilities.isEmpty(service[1])) {
        self.logger.write(self.constants.levels.INFO, "Checking for service " + service[0] + ", port: " + service[1]);
        services.push(new Service(service[0], Number(service[1])));
      } else {
        if (!self.utilities.isEmpty(service[0])) {
          self.logger.write(self.constants.levels.INFO, "Checking for service " + service[0]);
          services.push(new Service(service[0], 0));
        }
      }
      i++;
    }
    return services.forEach(function(service) {
      var exec, status;
      exec = void 0;
      status = void 0;
      if (service.port !== 0) {
        Plugin.command = "lsof -i :" + service.port;
      } else {
        Plugin.command = "ps ax | grep -v grep | grep -v tail | grep " + service.name;
      }
      return self.utilities.run(Plugin.command, function(response) {
        self.logger.write(self.constants.levels.INFO, "Response: " + response);
        if (self.utilities.isEmpty(response)) {
          status = "0";
          self.logger.write(self.constants.levels.INFO, service.name + " is NOT running");
        } else {
          status = "1";
          self.logger.write(self.constants.levels.INFO, service.name + " is running");
        }
        return callback(Plugin.name, "RunningProcess-" + service.name, "None", status, Plugin.format(status, service.name));
      });
    });
  });
};