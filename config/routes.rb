ActionController::Routing::Routes.draw do |map|

  map.root :controller => "highlights", :action=>"new"
  map.resources :highlights
  map.resources :screenshots

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
