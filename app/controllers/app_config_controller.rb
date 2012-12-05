# encoding: utf-8
class AppConfigController < ApplicationController

  def edit
    if AppConfig.count == 0
      @msg = "Конфигурация не настроена"
      @conf = AppConfig.new(
          :dropbox_path => "введите абсолютный путь к папке Dropbox сюда",
          :dropbox_adv_path => "adv",
          :dropbox_music_path => "music",
          :dropbox_log_path => "log"
      )
      @conf.save
    end
    @conf = AppConfig.first
  end

  def update
    @conf = AppConfig.first

    if @conf.update_attributes params[:app_config]
      flash[:success] = 'Данные успешно сохранены'
    else
      flash[:error] = 'Данные не сохранены. Обратитесь в службу тех. поддержки для решения данного вопроса'
    end
    redirect_to config_path
  end

end
