class PagesController < ApplicationController
  def home
    # Get the newest potato men that are at least 10 minutes old. We don't want potato men currently being built show here
    @recent_potato_men = PotatoMan.active.find(:all, :conditions => ["created_at < ?", 15.minutes.ago], :order => "created_at DESC", :limit => 3)
  end
end
