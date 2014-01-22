Field = require '../models/field'

class PathExtractor
  constructor: (@store, @translationId, @seedLocale, json, @locale) ->
    @paths = []
    @localeHash = { }
    @walk json
    @locales = (key for key in Object.keys(@localeHash) when key isnt @seedLocale)
  
  walk: (hash, path) =>
    for key, value of hash
      keyPath = [path, key].filter((k) -> !!k).join '.'
      if typeof value is 'object' and not value.field
        @walk value, keyPath
      else
        @addKey keyPath, value
  
  addKey: (path, hash) ->
    hash = $.extend true, { }, hash
    delete hash.field
    @localeHash[key] = true for key, value of hash
    
    @paths.push @store.createRecord 'field',
      id: "#{ @locale or @seedLocale }:#{ path }"
      translation_id: @translationId
      seedLocale: @seedLocale
      locale: @locale
      path: path
      translations: hash

module.exports = PathExtractor