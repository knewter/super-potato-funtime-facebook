class InvitationsController < ApplicationController
  def new
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
end
