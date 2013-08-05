 # http://www.whatwg.org/specs/web-apps/current-work/multipage/offline.html#parsing-cache-manifests
 
 module.exports = (manifest) ->
  lines = manifest.split /\r\n|\r|\n/

  # TODO: this is incorrectly parsing the magic signature
  #   MUST start with CACHE
  #   space, tab, or new line MUST follow CACHE MANIFEST
  #   after space or tab, other characters MAY appear and MUST be ignored 
  firstLine = lines.shift().trim()
  if firstLine.indexOf('CACHE MANIFEST') isnt 0
    throw new Error("Invalid cache manifest header: #{firstLine}")

  currentSection = 'CACHE'

  entries = 
    cache: []
    network: []
    fallback: {}
    settings : []
    tokens   : []

  mode = 'CACHE'
  entries.tokens = [ { type: 'magic signature', value: 'CACHE MANIFEST' } ]
  for line in lines
    line = line.trim()
    if !line.length
      entries.tokens.push { type: 'newline' }
    else if line.indexOf('#') is 0
      entries.tokens.push { type: 'comment', value: line.substring(1) }
    else if [ 'CACHE:', 'FALLBACK:', 'NETWORK:', 'SETTINGS:' ].indexOf(line) >= 0
      mode = line.substring 0, (line.length - 1)
      entries.tokens.push { type: 'mode', value: mode }
    else if line.indexOf(':') is (line.length - 1)
      mode = 'unknown'
      entries.tokens.push { type: 'mode', value: mode, raw: line }
    else
      # This is either a data line or it is syntactically incorrect.
      tokens = line.split /[ ]+/
      entries.tokens.push { type: 'data', tokens: tokens }

      if mode is 'FALLBACK'
        entries.fallback[tokens[0]] = tokens[1]
      else if mode isnt 'unknown'
        entries[mode.toLowerCase()].push line
  entries
