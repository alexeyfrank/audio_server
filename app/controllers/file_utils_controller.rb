class FileUtilsController < ApplicationController

  def create_folder
    config = AppConfig.first

    base = params[:base]
    name = params[:name]
    new_dir = File.join base, name

    FileUtils.mkdir new_dir if Dir.exist? base and not Dir.exist? new_dir

    # TODO: fix this static int
    #FileUtils.chmod_R(0666, new_dir)
    #FileUtils.chown(config.owner_member, config.owner_group, new_dir)

    respond_to do |format|
      format.json {
        render :json => {
          :status => :success,
          :data => {
            :path => new_dir,
            :name => name,
            :type => :folder
          }
        }
      }
    end
  end
end