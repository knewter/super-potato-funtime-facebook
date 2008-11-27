class PotatoBackgroundsController < ApplicationController
  before_filter :login_required
  before_filter :load_potato_backgrounds, :only => [:index]
  before_filter :load_potato_background,  :only => [:show, :edit, :update, :destroy]
  before_filter :load_new_potato_background, :only => [:new, :create]

  protected
  def load_potato_backgrounds
    @potato_backgrounds = PotatoBackground.find(:all)
  end

  def load_potato_background
    @potato_background = PotatoBackground.find(params[:id])
  end

  def load_new_potato_background
    @potato_background = PotatoBackground.new(params[:potato_background])
  end

  public
  def index
  end

  def new
  end

  def create
    if @potato_background.save
      flash[:notice] = "Background was created successfully."
      redirect_to potato_backgrounds_path
    else
      flash.now[:error] = "There was a problem creating the background."
      render :action => 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
