module ErrorLogger
  

  def record_error(exception)
    DbError.create(
    :content=>exception.inspect,
    #:user_id=> (logged_in? ? controller.current_user.id.to_s : nil),
    :user_name=> (logged_in? ? self.current_user.name : "anonymous").to_s,
    :file => exception.methods.include?("file_name") ? exception.file_name.to_s : nil, 
    :message=>  exception.message.to_s,
    :line=> exception.methods.include?("line_number") ? exception.line_number.to_s : nil,
    :controller=> request.parameters["controller"].to_s,
    :action=> request.parameters["action"].to_s,
    :session_data=> request.session.instance_variable_get("@data").to_yaml,
    :params=>request.parameters.to_yaml,
    :type=> exception.methods.include?("original_exception") ? exception.original_exception.class.to_s : nil,
    :explain => exception.methods.include?("source_extract") ? exception.source_extract.class.to_s : nil,
    :referrer => request.env['HTTP_REFERER'] #|| nil
    )
  end

  def rescue_action(exception)
    log_error(exception) if logger
    erase_results if performed?
    unless  (['graphics', 'images'].include?(request.parameters["controller"])) or request.parameters["controller"].blank?
      record_error(exception)
    end
    # Let the exception alter the response if it wants.
    # For example, MethodNotAllowed sets the Allow header.
    if exception.respond_to?(:handle_response!)
      exception.handle_response!(response)
    end
    if consider_all_requests_local || local_request?
      rescue_action_locally(exception)
    else
      rescue_action_in_public(exception)
    end
  end

end