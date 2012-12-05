class LogController < ApplicationController
  def index
    @logs = ShopLog.all
  end

  def show
    filename = params[:filename] + ".txt"
    @log = ShopLog.get(filename)

    respond_to do |format|
      format.text {
        render 'show.html', :layout => 'application', :content_type => 'text/html'
      }
    end
  end
end
