class PublicPotatoMenController < ApplicationController
  before_filter :load_potato_men, :only => [:index]
  before_filter :load_popular_potato_men, :only => [:popular]
  before_filter :load_potato_man, :only => [:show]

  protected
  def load_potato_men
    @potato_men = PotatoMan.active.paginate(:all, :page => params[:page], :order => 'created_at DESC')
  end

  def load_potato_man
    @potato_man = PotatoMan.find params[:id]
  end

  def load_popular_potato_men
    @potato_men = PotatoMan.active.find(:all, :include => [:rates] ).collect {|i| i if i.average_rating.to_i == params[:rating].to_i }.compact
  end

  public
  def index
  end

  def show
  end

  def popular
    render :action => 'index'
  end
end
