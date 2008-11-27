# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :admin?
  include HoptoadNotifier::Catcher

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '1a79f15df4042e05028a2ddc96820df3'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  #

  protected
  def admin?
    logged_in? &&current_user.admin?
  end

  def admin_required
    if( !admin? )
      flash[:error] = "Only an admin can do that."
      redirect_to '/'
    end
  end

  def login_required 
    if( !logged_in? )
      flash[:error] = "You need to be logged in to do that!"
      redirect_to '/'
    end
  end

  def login_or_become_anon_coward
    if( !logged_in? )
      self.current_user = User.create_anonymous_user
    end
  end

end
