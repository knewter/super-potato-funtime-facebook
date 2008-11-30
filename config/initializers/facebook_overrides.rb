ActionController::AbstractRequest.class_eval do
  def request_method_with_facebook_overrides 
    @request_method ||= begin  
      case
        when parameters[:_method]
          parameters[:_method].downcase.to_sym
        when parameters[:fb_sig_request_method]
          parameters[:fb_sig_request_method].downcase.to_sym
        else
          request_method_without_facebook_overrides
      end
    end
  end
  alias_method_chain:request_method,:facebook_overrides
end
