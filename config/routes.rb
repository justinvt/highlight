ActionController::Routing::Routes.draw do |map|
  map.connect ":id", :controller=>"highlights", :action=>"show", :id=>/[0-9]+/
  map.root :controller => "highlights", :action=>"new"
  map.resources :highlights, :as=>"h"
  map.resources :screenshots
  map.connect "h/:id/screenshot.:format", :controller=>"screenshots", :action=>"show"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
