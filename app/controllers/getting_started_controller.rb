class GettingStartedController < ApplicationController
  def add_facebook_application
    respond_to do |format|
      format.fbml
    end
  end
end
