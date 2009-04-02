class ApplicationController < ActionController::Base
  #helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include ErrorLogger

  # filter_parameter_logging :password
  
  before_filter :set_page_atts
  
  def set_page_atts
   # @page_id = "page_id"#{}"#{@controller.controller_name}_#{@controller.action_name}"
   # @page_css = "page_class"#{}"c_#{@controller.controller_name} a_#{@controller.action_name} l_#{@controller.layout}"
  end

  
end
