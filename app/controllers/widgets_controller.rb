class WidgetsController < ApplicationController
  before_filter :login_required
  before_filter :load_widgets, :only => [:index]
  before_filter :load_widget,  :only => [:show, :edit, :update, :destroy]
  before_filter :load_new_widget, :only => [:new, :create]
  before_filter :load_widget_categories, :only => [:new]

  protected
  def load_widgets
    @widgets = Widget.find :all
  end

  def load_widget
    @widget = Widget.find params[:id]
  end

  def load_new_widget
    @widget = Widget.new(params[:widget])
  end

  def load_widget_categories
    @widget_categories = WidgetCategory.find(:all).map{|wc| [wc.name, wc.id] }
  end

  public
  def index
  end

  def new
  end

  def create
    if @widget.save
      flash[:notice] = "Widget saved successfully."
      redirect_to widgets_path
    else
      flash.now[:error] = "There was a problem saving the widget."
      render :action => 'new'
    end
  end
end
