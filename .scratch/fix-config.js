var fs = require('fs')
var path = require('path')

var output = process.argv[2]
output.split('\n').forEach(function(val) {

  if (/MetaCoin\: /.test(val)) {
    var config = {
      address: val.split(': ')[1]
    }
    fs.writeFileSync(path.resolve(__dirname, '../src/js/metacoin-config.js'),'var metacoinConfig = ' + JSON.stringify(config))
  }
})
