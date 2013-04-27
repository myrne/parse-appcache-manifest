# require("source-map-support").install()

fs = require "fs"
path = require "path"
assert = require "assert"

manifestNames = ["html5-doctor", "html5-rocks", "jake-archibald", "stellarpad"]
parseAppcacheManifest = require "../"

describe "parseAppcacheManifest", ->
  it "parses manifests", ->
    for manifestName in manifestNames
      manifestPath = path.resolve(__dirname, "../fixtures/manifests/#{manifestName}")
      outputPath = path.resolve(__dirname, "../fixtures/results/#{manifestName}")
      contents = fs.readFileSync manifestPath
      result = parseAppcacheManifest contents.toString()
      assert.deepEqual result, require "../fixtures/results/#{manifestName}.json"