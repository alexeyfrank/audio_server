# encoding: utf-8
class TracksController < ApplicationController
  def init_params
    @audio_types = [ ['Музыка', "music"], ['Реклама', "adv"] ]

    @days = [
        ["Понедельник", "monday"],
        ["Вторник", "tuesday"],
        ["Среда", "wednesday"],
        ["Четверг", "thursday"],
        ["Пятница", "friday"],
        ["Суббота", "saturday"],
        ["Воскресенье", "sunday"],
    ]

    @hours = Array.new(24) { |i|
      prefixFrom = i < 10 ? "0" : ""
      prefixTo = i < 9 ? "0" : ""
      str = "#{ prefixFrom + i.to_s }:00 - #{ prefixTo + (i + 1).to_s }:00"
      [ str , i.to_s]
    }

    @audio_type = params[:audio_type]
    @day = params[:day]
    @hour = params[:hour]

  end

  def index
    init_params
  end

  def filter
    init_params

    Audio.mkdir @audio_type, @day, @hour
    @files = Audio.all(@audio_type, @day, @hour)

    @form_model = Audio.new

    respond_to do |format|
      format.html # index.html.slim
      format.json { render json: @files.map{|f| f.to_jq_upload } }
    end
  end

  def upload
    init_params
    upload = params[:upload]
    file = Audio.new(upload.original_filename, @audio_type, @day, @hour)
    file.save(params[:upload].read)
    render json: [file.to_jq_upload, upload.tempfile.path, params[:upload]].to_json
  end

  def delete
    path = params[:filepath]
    if File.exist? path
      File.delete path
      render json: 'success'
    else
      render json: 'File not found!'
    end
  end

end
