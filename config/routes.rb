Rails.application.routes.draw do
  root "dashboard#index"
  resources :perangkat_daerahs
  resources :pegawais
  get "kendaraan_dinas", to: "kendaraan_dinas#index", as: :kendaraan_dinas_index
  post "kendaraan_dinas", to: "kendaraan_dinas#create"
  get "kendaraan_dinas/new", to: "kendaraan_dinas#new", as: :new_kendaraan_dinas
  get "kendaraan_dinas/:id/edit", to: "kendaraan_dinas#edit", as: :edit_kendaraan_dinas
  get "kendaraan_dinas/:id", to: "kendaraan_dinas#show", as: :show_kendaraan
  patch "kendaraan_dinas/:id", to: "kendaraan_dinas#update"
  put "kendaraan_dinas/:id", to: "kendaraan_dinas#update"
  delete "kendaraan_dinas/:id", to: "kendaraan_dinas#destroy"

  namespace :api do
    namespace :v1 do
      resources :perangkat_daerahs
      resources :pegawais
      resources :kendaraan_dinas
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
