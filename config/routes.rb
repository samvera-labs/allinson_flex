# frozen_string_literal: true

FlexibleMetadata::Engine.routes.draw do
  resources :profiles, except: :update do
    collection { post :import }
    member { post :unlock }
    get 'export'
  end
end
