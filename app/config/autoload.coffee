fs = require 'fs'
path = require 'path'
_  = require 'underscore'
_.str = require 'underscore.string'
_.mixin _.str.exports()

# user_model.coffee => UserModel
filenameToModulename = (filename) ->
  _(filename).chain().words('.').first().camelize().capitalize().value()

# recursively search dir for files to require and add to app.locals
autoload = (app, dir) ->
  return unless fs.existsSync dir

  dirsToLoad = []

  for filename in fs.readdirSync(dir)
    pathname = path.join dir, filename

    if fs.lstatSync(pathname).isDirectory()
      dirsToLoad.push(pathname)
    else
      loadedModule = require(pathname)?(app)
      modulename = filenameToModulename filename
      app.locals[modulename] = loadedModule

  for dir in dirsToLoad
    autoload app, dir

module.exports = (app) ->
  (dir) ->
    autoload app, dir
