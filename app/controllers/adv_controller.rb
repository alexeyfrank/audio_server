# encoding: utf-8
class AdvController < ApplicationController
  include ApplicationHelper, AdvHelper

  def index
  end

  def file_upload_window
    @base_path = params[:base]
    render :layout => nil
  end

  def upload
    @base_path = params[:base_path]
    upload = params[:upload]
    new_file_path = File.join @base_path, upload.original_filename

    is_uploaded = false
    unless File.exist? new_file_path
      FileUtils.cp upload.tempfile.path, new_file_path
      c = AppConfig.first
      FileUtils.chmod(0666, new_file_path)
      FileUtils.chown(c.owner_member, c.owner_group, new_file_path)
      is_uploaded = true
    end

    render :json => [
        {
          :name => upload.original_filename,
          :size => File.size(new_file_path),
          :delete_url => '',
          :delete_type => 'DELETE',
          :path => new_file_path,
          :is_uploaded => is_uploaded
          #:debug => {
          #  :new_file_path => new_file_path,
          #  :is_uploaded => is_uploaded,
          #  :base_path => @base_path
          #}
        }
    ]
  end


  def recursive_get_filetree(base_node, base_path)
    (Dir.entries(base_path) - ['.', '..']).each do |e|
      path = File.join(base_path, e)

      temp = {
          :data => {
            :title => e,
            :attr => { :"data-path" => path.gsub("'", "\'") }
          },
          :children => []
      }

      if File.directory? path
        temp[:data][:attr][:"data-type"] = :folder
        recursive_get_filetree(temp, path)
      else
        temp[:data][:attr][:"data-type"] = :file
      end
      base_node[:children] << temp
      #return temp
    end

  end

  def file_tree
    base = AppConfig.first.dropbox_adv_path
    FileUtils.mkdir_p base unless Dir.exist? base
    @data = {
      :data => {
        :title => 'Реклама',
        :attr => {
          :"data-path" => base,
          :"data-type" => :folder
        }
      },
      :children => []
    }

    recursive_get_filetree @data, base

    respond_to do |format|
      format.json { render :json => @data }
    end
  end


  def adv_blocks_list
    c = AppConfig.first

    @adv_blocks_path = File.join c.dropbox_path, 'adv_blocks'
    Dir.mkdir adv_blocks_path unless Dir.exist? @adv_blocks_path

    @days_dict = {
        :monday => 'Понедельник',
        :tuesday => 'Вторник',
        :wednesday => 'Среда',
        :thursday => 'Четверг',
        :friday => 'Пятница',
        :saturday => 'Суббота',
        :sunday => 'Воскресенье'
    }

    @adv_block_ext = '.advblock'
    adv_blocks_count = 4
    @days = []

    @days_dict.each do |key, val|
      day_path = File.join @adv_blocks_path, key.to_s
      Dir.mkdir day_path unless Dir.exist? day_path

      day = {
          :name => key,
          :title => val,
          :path => day_path,
          :blocks => []
      }

      (0...adv_blocks_count).each do |block_index|
        block_file_path = File.join day_path, (block_index.to_s + @adv_block_ext)
        FileUtils.touch block_file_path unless File.exist? block_file_path
        block = { :files => [] }

        files = File.open(block_file_path).read().gsub(/\r\n?/, "\n")

        files.each_line do |file|
          next if file.blank?
          block[:files] << {
              :path => file,
              :name => File.basename(file)
          }
        end

        day[:blocks] << block
      end
      @days << day
    end

    #@days = [
    #  {
    #    :name => 'monday',
    #    :path => File.join(adv_blocks_path, 'monday'),
    #    :title => 'Понедельник',
    #    :blocks => [
    #        {
    #            :files => [
    #                { :path => 'path/to/file', :name => 'file_name' },
    #                { :path => 'path/to/file', :name => 'file_name' },
    #                { :path => 'path/to/file', :name => 'file_name' },
    #            ]
    #        },
    #        {
    #            :files => [
    #                { :path => 'path/to/file', :name => 'file_name' },
    #                { :path => 'path/to/file', :name => 'file_name' },
    #                { :path => 'path/to/file', :name => 'file_name' },
    #            ]
    #        },
    #    ]
    #  },
    #  {
    #    :name => 'thuesday',
    #    :path => File.join(adv_blocks_path, 'thuesday'),
    #    :title => 'Вторник',
    #    :blocks => [
    #        {
    #            :files => [
    #                { :path => 'path/to/file', :name => 'file_name' },
    #                { :path => 'path/to/file', :name => 'file_name' },
    #                { :path => 'path/to/file', :name => 'file_name' },
    #            ]
    #        },
    #        {
    #            :files => [
    #                { :path => 'path/to/file', :name => 'file_name' },
    #                { :path => 'path/to/file', :name => 'file_name' },
    #                { :path => 'path/to/file', :name => 'file_name' },
    #            ]
    #        },
    #    ]
    #  }
    #]

    render :layout => nil


  end

  def refresh_adv_block

    dropbox_path = AppConfig.first.dropbox_path

    file = params[:adv_block_file]
    new_files = params[:files]

    File.open file, 'w' do |f|
      new_files.each do |new_file|
        new_file.slice!(dropbox_path)
        f.puts (new_file)
      end
    end

    render :json => new_files

  end

















end