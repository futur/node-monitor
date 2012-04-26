Plugin =
  name: 'filesize'
  command: ''
  type: 'poll'
  files: {}

@name = Plugin.name
@type = Plugin.type

@poll = (utilities, callback) ->
  
  self = this
  self.utilities = utilities
  
  self.utilities.parseFileAtNewlineAndEquals Plugin.name + '_config', (contents) ->
    
    # File name, size (in KB)
    for key of contents
      Plugin.files[contents[key]] = Number contents[key]
    
    for file of Plugin.files
      fs.stat file, (error, stat) ->
        
        if Number stat.size > Number Plugin.files[file]
          console.log 'Emptying file ' + file.name + ', exceeds limit in config'
          self.utilities.emptyFile file ->
        else 
          console.log 'Filesize for ' + file + ' is Ok!'
        
        callback Plugin.name, 'FileSize-' + file, 'Kilobytes', stat.size