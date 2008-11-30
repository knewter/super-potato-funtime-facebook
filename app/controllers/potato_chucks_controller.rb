class PotatoChucksController < ApplicationController
  before_filter :load_potato_man, :only => [:new, :create]
  before_filter :load_new_potato_chuck, :only => [:new]

  protected
  def load_potato_man
    @potato_man = PotatoMan.find_by_id(params[:potato_man_id])
  end

  def load_new_potato_chuck
    @potato_chuck = PotatoChuck.new
    @potato_chuck.potato_man = @potato_man
    unless @potato_chuck.potato_man
      flash.now[:error] = "You must choose a potato man before you should get to this page."
    end
  end

  public
  def new
  end

  def create
    for id in params[:ids]
      current_facebook_user.chuck(FacebookUser.for(id), @potato_man)
    end
    flash[:notice] = "You've chucked some darn nice potatoes!"
    redirect_to new_potato_chuck_path(:potato_man_id => @potato_man.id)
  end

  def index
  end

end
