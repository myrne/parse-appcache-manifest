module.exports = (manifest) ->
  entries = 
    cache: []
    network: []
    fallback: {}
  handleEntryFrom = 
    CACHE: (line) -> entries.cache.push line
    NETWORK: (line) -> entries.network.push line
    FALLBACK: (line) -> 
      bits = line.split " "
      entries.fallback[bits[0]] = bits[1]
  currentSection = "CACHE"
  lines = manifest.split(/\r\n|\r|\n/)
  firstLine = lines.shift()
  unless lines.length > 1
    throw new Error("Manifest only has one line.")
  unless startswith firstLine, "CACHE MANIFEST"
    throw new Error("Invalid cache manifest header: #{firstLine}")
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

sectionNames = ["NETWORK", "CACHE", "FALLBACK"]
findSection = (line) ->   
  return name for name in sectionNames when startswith line, "#{name}:"
  return null