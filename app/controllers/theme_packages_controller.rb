class ThemePackagesController < ApplicationController
  before_filter :login_required

  before_filter :load_theme_packages, :only => [:index]
  before_filter :load_theme_package,  :only => [:show, :edit, :update, :destroy, :update, :choose_background, :add_widget, :remove_widget]
  before_filter :load_new_theme_package, :only => [:new, :create]
  before_filter :load_potato_backgrounds, :only => [:choose_background]
  before_filter :load_widgets, :only => [:add_widget]

  protected
  def load_theme_packages
    @theme_packages = ThemePackage.find :all
  end

  def load_theme_package
    @theme_package = ThemePackage.find params[:id]
  end

  def load_new_theme_package
    @theme_package = current_user.theme_packages.build( params[:theme_package] )
  end

  def load_potato_backgrounds
    @potato_backgrounds = PotatoBackground.find :all
  end

  def load_widgets
    @widgets = Widget.find :all
  end

  public
  def index
  end

  def new
  end

  def update
    @theme_package.update_attributes( params[:theme_package] )
    flash[:notice] = "Theme package updated."
    redirect_to theme_packages_url
  end

  def create
    if @theme_package.save!
      flash[:notice] = "Theme Package saved successfully."
      redirect_to theme_package_path(@theme_package)
    else
      flash.now[:error] = "There was a problem saving the theme package."
      render :action => 'new'
    end
  end

  def choose_background
    if params[:potato_background_id]
      # attach the background and hit the next step
      @theme_package.potato_background_id = params[:potato_background_id]
      @theme_package.save
      flash[:notice] = "Background chosen, yo."
      redirect_to theme_package_path(@theme_package)
    else
      # let the user choose from the available backgrounds
    end
  end

  def add_widget
    if params[:widget_id]
      # attach the widget and hit the next step
      @theme_package.add_widget(params[:widget_id])
      flash[:notice] = "Widget added, el capitan."
      redirect_to theme_package_path(@theme_package)
    else
      # let the user choose from the available widgets
    end
  end

  def remove_widget
    if params[:widget_id]
      # attach the widget and hit the next step
      @theme_package.remove_widget(params[:widget_id])
      flash[:notice] = "Widget removed, turdnugget."
    end
    redirect_to theme_package_path(@theme_package)
  end
end
