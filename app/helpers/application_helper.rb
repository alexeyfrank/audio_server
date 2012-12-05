module ApplicationHelper

  def ul_open_tag(p = {})
    "<ul class='#{ p[:class] }'>"
  end

  def ul_close_tag
    "</ul>"
  end

  def li_open_tag
     "<li>"
  end

  def li_close_tag
    "</li>"
  end

  def a_tag(params = {})
    "<a href='#' data-path='#{ params[:path] }' data-type='#{ params[:type] }'>#{ params[:name] }</a>"
  end
end
