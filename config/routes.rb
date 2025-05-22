Portal::Engine.routes.draw do
  namespace :v2 do
    root "policies#index"
  end
end
