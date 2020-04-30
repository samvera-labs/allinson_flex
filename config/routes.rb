# frozen_string_literal: true

FlexibleMetadata::Engine.routes.draw do
  resources :profiles, except: :update do
    collection { post :import }
    get 'export'
    resources :entries, only: %i[show]
  end
end
