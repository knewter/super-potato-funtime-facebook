class PotatoMenController < ApplicationController
  before_filter :admin_required, :only => [:feature]
  before_filter :login_or_become_anon_coward
  before_filter :load_potato_men, :only => [:index]
  before_filter :load_potato_man, :only => [:show, :edit, :update, :destroy, :choose_background, :choose_theme_package, :remove_all_widgets, :feature]
  before_filter :load_new_potato_man, :only => [:new, :create]
  before_filter :load_potato_backgrounds, :only => [:choose_background]
  before_filter :load_theme_packages, :only => [:choose_theme_package]

  protected
  def load_potato_men
    if( logged_in? )
      @potato_men = current_user.potato_men
    else
      @potato_men = []
    end
  end

  def load_potato_man
    @potato_man = PotatoMan.find params[:id]
    if( @potato_man.creator != current_user && !admin? )
      flash[:error] = "Sorry, champ, but you can't edit other peoples' potato men! #{current_user.id}"
      redirect_to potato_men_path 
    end
  end

  def load_new_potato_man
    @potato_man = current_user.potato_men.build(params[:potato_man])
  end

  def load_potato_backgrounds
    @potato_backgrounds = PotatoBackground.find :all
  end

  def load_theme_packages
    @theme_packages = ThemePackage.find :all
  end

  public
  def index
  end

  def new
  end

  def show
  end

  def update
    if( request.xhr? )
      @potato_man.update_attributes(params[:potato_man])
      # Also see if widgets were repositioned
      if( params[:widget_instances] && params[:widget_instances].is_a?(Array) )
        widgets = params[:widget_instances]
        # Value is a csv list describing: widget_instace_id, x, y, z
        widgets.each do |widget|
          value_array = widget.split(',')
          instance_id = value_array[0]
          instance_x  = value_array[1]
          instance_y  = value_array[2]
          instance_z  = value_array[3]
          instance = @potato_man.widget_instances.find(instance_id) rescue nil
          if( instance )
            instance.update_attributes(:top => instance_y, :left => instance_x, :z_index => instance_z)
          else
            @potato_man.widget_instances.create(:top => instance_y, :left => instance_x, :z_index => instance_z)
          end
        end

      end
      render :update do |page|
        page.replace_html :page_title, "Potato Man: " + @potato_man.name
        page << "jQuery('#page_title').effect('highlight', {}, 15000);"
      end
    end
  end


  def feature
    @potato_man.feature!
    flash[:notice] = "You featured a potato man!"
    redirect_to public_potato_men_path
  end

  def choose_background
    if params[:potato_background_id]
      # attach the background and hit the next step
      @potato_man.potato_background_id = params[:potato_background_id]
      @potato_man.save
      flash[:notice] = "Hurray, he has a body."
      redirect_to potato_man_path(@potato_man)
    else
      # let the user choose from the available backgrounds
    end
  end

  def choose_theme_package
    if params[:theme_package_id]
      # attach the theme package and hit the next step
      @potato_man.theme_package_id = params[:theme_package_id]
      @potato_man.save
      @potato_man.write_preview!
      flash[:notice] = "Hurray, you pick themes super good!"
      redirect_to potato_man_path(@potato_man)
    else
      # let the user choose from the available themes
    end
  end

  def create
    if @potato_man.save
      flash[:notice] = "Potato Man created successfully."
      redirect_to choose_theme_package_potato_man_path(@potato_man)
    else
      flash.now[:error] = "There was a problem creating the Potato Man."
      render :action => 'new'
    end
  end

  def destroy
    @potato_man.destroy
    flash[:notice] = "Potato Man removed."
    redirect_to potato_men_path 
  end

  def remove_all_widgets
    @potato_man.widget_instances.delete_all
    render :nothing => true
  end

end
