l =
  select_parent_dir: 'Выберите родительский каталог'
  cannot_create_subfolder_in_file: 'Нельзя создать папку в файле'
  cannot_upload_files_in_file: 'Нельзя загружать файлы в файл'

config =
  tree_config:
    plugins: [ "themes", "json_data", "ui","crrm", "dnd" ]
    themes:
      theme: 'apple'
      url: 'assets/jstree/apple/style.css'

  attrs:
    data_path: 'data-path'
    data_type: 'data-type'

  tree: '#file-tree'
  add_files_btn: '#add-files-btn'
  add_files_modal: '#add-files-modal'
  create_folder_btn: '#create-folder-btn'
  create_folder_path: '/filemanager/create-folder'
  file_upload_wnd_path: '/adv/file-upload-wnd'
  files_path: '/filemanager/files'

create_test_ajax_tree = () ->
  $(config.tree).jstree({
    plugins : config.tree_config.plugins
    themes: config.tree_config.themes
    json_data:
      ajax:
        url: config.files_path

    crrm:
      move:
        check_move: (m) -> false

    dnd:
      drop_check: (data) -> data.o.find('a').first().attr(config.attrs.data_type) != 'folder'

      drop_finish: (data) ->
        draggable_obj_a = $(data.o).find('a').first()
        name = draggable_obj_a.text()
        path = draggable_obj_a.attr config.attrs.data_path


        unless $(data.r).hasClass('tracks-accordion')
          ul = $(data.r).closest('ul')
        else
          ul = $(data.r).find('ul')

        li = "<li>#{name}<a data-path=\"#{ path }\" class='remove-track-from-adv-block' href='#'><i class='icon-remove' style='float:right' /></a></li>"
        ul.append(li)
        ul.trigger('tracklist.refresh')
  })
    .bind(
      'create.jstree',
      (e, data) ->
        return if data.rslt.parent == -1
        parent = $(data.rslt.parent).find('a').first()
        obj = $(data.rslt.obj).find('a').first()

        data_path = "#{ parent.attr config.attrs.data_path }/#{ data.rslt.name }"
        obj.attr config.attrs.data_path, data_path
        obj.attr config.attrs.data_type, $(data.rslt.obj).attr(config.attrs.data_type)

        $.post(config.create_folder_path,
          {
            base: parent.attr config.attrs.data_path
            name: data.rslt.name
          },
          null,
          'json');
    )

$ =>
  create_test_ajax_tree()

  $(config.create_folder_btn).click () ->
    selected = $(config.tree).jstree('get_selected')
    if selected.length == 0
      return alert l.select_parent_dir
    if selected.find('a').first().attr('data-type') == 'file'
      return alert l.cannot_create_subfolder_in_file
    $(config.tree).jstree(
      "create", null, 'inside',
      attr:
        "data-type": 'folder'
      () ->
      false
    )

  $(config.add_files_btn).click () ->
    selected = $(config.tree).jstree('get_selected')
    if selected.length == 0
      return alert l.select_parent_dir
    if selected.find('a').first().attr('data-type') == 'file'
      return alert l.cannot_upload_files_in_file

    $.get(
      config.file_upload_wnd_path,
      {
        base: $(selected).find('a').first().attr config.attrs.data_path
      },
      (html) ->
        $(config.add_files_modal + ' .modal-body').html html
        $(config.add_files_modal).modal 'show'

        $('#fileupload')
          .fileupload()
          .bind('fileuploaddone', (e, data) ->
            data = data.result[0]

            return if not data.is_uploaded

            console.log data
            $(config.tree).jstree(
              "create",
              null,
              'inside',
              {
                data:
                  title: data.name
                  attr:
                    "data-type": 'file'
                    'data-path': data.path
              },
              () -> ,
              true
            )
          );
    )

  $.get(
    '/adv/blocks', {},
    (html) ->
      $('#blocks-box').html html
      $('.accordion .accordion-body').collapse({ toggle: true })

      $('.remove-track-from-adv-block').live 'click', () ->
        ul = $(this).closest 'ul'
        $(this).closest('li').remove()
        ul.trigger('tracklist.refresh')
        false

      $('.tracks-list').bind(
        'tracklist.refresh',
        () ->
          data = []
          $(this).find('a').each((i, el) -> data.push($(el).attr(config.attrs.data_path)))
          console.log data

          $.post(
            '/adv/block/refresh',
            {
              adv_block_file: $(this).attr(config.attrs.data_path),
              files: data
            }, null, 'json')

      )
    'html'
  )



