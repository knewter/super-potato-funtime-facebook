class WidgetInstancesController < ApplicationController
  before_filter :login_required
  # This controllwe will always be nested under a PotatoMan
  before_filter :load_potato_man
  before_filter :load_new_widget_instance, :only => [:new, :create]
  before_filter :load_widget_instance, :only => [:edit, :update, :reposition, :remove]
  before_filter :load_widgets, :only => [:new]
  before_filter :load_widget_categories, :only => [:new]

  protected
  def load_potato_man
    @potato_man = PotatoMan.find params[:potato_man_id]
  end

  def load_widget_instance
    @widget_instance = WidgetInstance.find( params[:id] )
  end

  def load_new_widget_instance
    @widget_instance = @potato_man.widget_instances.build(params[:widget_instance])
    if params[:widget_id]
      @widget_instance.widget_id = params[:widget_id]
    end
  end

  # NOTE: This is being run even when not choosing a widget, which is a
  # tad wasteful.  Breaking new into two distinct actions would be 
  # ideal imo -ja
  def load_widgets
    if params[:all_widgets]
      @widgets = Widget.find(:all)
    else
      @widgets = @potato_man.theme_package.widgets
    end
  end

  def load_widget_categories
    @widget_categories = @widgets.map(&:widget_category).uniq
  end

  public
  def new
    if @widget_instance.widget_id
      @widget_instance.save
      render :json => @widget_instance.to_json
      # The user chose a widget.
      # Let the user choose a left, top, and z_index, then submit to create
    else
      # show the list of widgets
      render :action => 'widget_chooser', :layout => false
    end
  end

  def create
    if @widget_instance.save
      flash[:notice] = "Widget Instance created successfully."
      redirect_to @potato_man
    else
      flash.now[:error] = "There was a problem creating your widget instance."
      render :action => 'new'
    end
  end

  def update
    if @widget_instance.update_attributes(params[:widget_instance])
      flash[:notice] = "The Widget Instance was updated successfully."
      respond_to do |format|
        format.html{ redirect_to potato_man_path(@potato_man) }
        format.js{}
      end
    else
      flash.now[:error] = "There was a problem updating the widget instance."
      respond_to do |format|
        format.html{ render :action => 'edit' }
        format.js{}
      end
    end
  end

  def reposition
    @widget_instance.update_attributes(:z_index => params[:z_index], :top => params[:top], :left => params[:left])
    render :nothing => true
  end

  def remove
    if( @widget_instance.potato_man.creator == current_user )
      @widget_instance.destroy
      render :nothing => true
    else
      render :update do |page|
        page << "alert('You can't remove widgets from this potato man!');"
      end
    end
  end
end
