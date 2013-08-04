 # http://www.whatwg.org/specs/web-apps/current-work/multipage/offline.html#parsing-cache-manifests
 
 module.exports = (manifest, opts={}) ->
  lines = manifest.split /\r\n|\r|\n/

  firstLine = lines.shift().trim()
  if firstLine.indexOf('CACHE MANIFEST') isnt 0
    throw new Error("Invalid cache manifest header: #{firstLine}")

  currentSection = 'CACHE'

  if opts.tokenize
    mode = 'explicit'
    entries = [ { type: 'magic signature', value: 'CACHE MANIFEST' } ]
    for line in lines
      line = line.trim()
      if !line.length
        entries.push { type: 'newline' }
      else if line.indexOf('#') is 0
        entries.push { type: 'comment', value: line.substring(1) }
      else if [ 'CACHE:', 'FALLBACK:', 'NETWORK:', 'SETTINGS:' ].indexOf(line) >= 0
        mode = line.substring 0, (line.length - 1)
        entries.push { type: 'mode', value: mode }
      else if line.indexOf(':') is (line.length - 1)
        mode = 'unknown'
        entries.push { type: 'mode', value: mode, raw: line }
      else
        # This is either a data line or it is syntactically incorrect.
        tokens = line.split /[ ]+/
        entries.push { type: 'data', tokens: tokens}
  else
    entries = 
      cache: []
      network: []
      fallback: {}
      settings : {}

    handleEntryFrom = 
      CACHE: (line) -> entries.cache.push line
      NETWORK: (line) -> entries.network.push line
      FALLBACK: (line) -> 
        bits = line.split " "
        entries.fallback[bits[0]] = bits[1]
    
    for line in lines
      line = line.trim()
      if foundSection = findSection line
        currentSection = foundSection
        continue
      continue if line is ""
      continue if line[0] is "#"
      handleEntryFrom[currentSection] line
  entries

startswith = (str, prefix) ->
  str.indexOf(prefix) is 0

findSection = (line) ->  
  sectionNames = ["NETWORK", "CACHE", "FALLBACK"] 
  return name for name in sectionNames when startswith line, "#{name}:"
  null
