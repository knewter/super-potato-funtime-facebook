class InvitationsController < ApplicationController
  def new
    if should_update_profile?
      update_profile
    end
    @from_user_id = facebook_session.user.to_s
    respond_to do |format|
      format.fbml
    end
  end

  def create
    @sent_to_ids = params[:ids]
    respond_to do |format|
      format.fbml
    end
  end

  protected
  def should_update_profile?
    params[:from]
  end

  def update_profile
    @user = facebook_session.user
    @user.profile_fbml = render_to_string(:partial => 'profile', :locals => { :from => params[:from] })
  end
end
