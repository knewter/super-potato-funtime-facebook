# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :admin?
  include HoptoadNotifier::Catcher

  # protect_from_forgery # :secret => '1a79f15df4042e05028a2ddc96820df3'
  ensure_authenticated_to_facebook

  attr_accessor :current_facebook_user
  before_filter :set_current_facebook_user

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

  def set_current_facebook_user
    self.current_facebook_user = FacebookUser.for(facebook_session.user.to_i, facebook_session)
  end
end
