Portal::Engine.routes.draw do
  resources :policies, only: :show do
    resource :documents, only: [:create]
    resource :credit_card, only: [:create, :edit, :update] do
      get :success
      get :error
      post :process_card_payment
    end
    resources :billing_transactions, only: [:show] do
      member do
        get :download_receipt
      end
    end
  end

  root "home#index", as: "portal_root"
end
