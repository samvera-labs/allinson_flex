# frozen_string_literal: true

AllinsonFlex::Engine.routes.draw do
  resources :profiles, except: :update do
    collection { post :import }
    member { post :unlock }
    get 'export'
  end
end
