ActionController::Routing::Routes.draw do |map|
  map.connect '', :controller => 'getting_started', :action => 'add_facebook_application'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
