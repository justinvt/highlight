# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def page_title
    "Highlig.ht"
  end
  
  def frontend_styles
    stylesheet_link_tag "base", "type", "layout", "style"
  end
  
  def editor_js
    javascript_include_tag "jquery", "jcrop", "application"
  end
  
  def home_js
    javascript_include_tag "min"
  end
  
  def meta_tags
%{
  
}
  
  end
  
end
