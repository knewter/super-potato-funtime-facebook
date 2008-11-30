ActionController::Routing::Routes.draw do |map|
  map.resources :invitations
  map.resources :pages
  map.resources :potato_backgrounds
  map.resources :widgets
  map.resources :potato_men, :member => [:choose_theme_package, :feature] do |potato_man|
    potato_man.resources :widget_instances, :member => [:reposition, :remove]
  end
  map.remove_all_widgets '/potato_men/:id/remove_all_widgets', :controller => 'potato_men', :action => 'remove_all_widgets'
  map.resources :public_potato_men, :collection => [:popular]

  # <login-related-stuff>
  map.open_id_complete 'session', :controller => 'sessions', :action => 'create', :requirements => { :method => :get }
  map.resource  :session

  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'

  map.resources :theme_packages, :member => [:choose_background, :add_widget, :remove_widget]
  map.resources :widgets
  # </login-related-stuff>

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => "pages", :action => "home"
end
