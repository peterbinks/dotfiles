Portal::Engine.routes.draw do
  root "policies#index", as: "portal_root"
end
