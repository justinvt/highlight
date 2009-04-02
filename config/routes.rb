ActionController::Routing::Routes.draw do |map|

  map.root :controller => "highlights", :action=>"new"
  map.resources :highlights#, :as=>"h"
  map.resources :screenshots
  map.connect ":id", :controller=>"highlights", :action=>"show", :id=>/[0-9]+/
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
