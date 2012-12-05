class RemoteFileSystem

  config:
    base_url: ''
    actions:
      create_folder: 'create-folder'


  constructor: (base_controller_url) ->
    @config.base_url = base_controller_url

  sync: (action, params, callback) ->
    $.ajax "#{ @config.base_url }/#{ action }",
      dataType: 'json'
      data: params
      success: callback

  create_folder: (where, name, callback) ->
    this.sync(
      @config.actions.create_folder,
        base: where,
        name: name
      callback
    )

this.RemoteFileSystem = RemoteFileSystem