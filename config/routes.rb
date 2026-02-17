Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resource :session, only: [:new, :create, :destroy]
  resources :passwords, only: [:new, :create, :edit, :update], param: :token
  resources :users, only: [:new, :create]
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "admin/disputes#index"
  namespace :admin do
    resources :disputes do
      resources :evidences, only: [:new, :create, :destroy]
      member do
        patch :request_evidence
        patch :submit_evidence
        patch :decide_won
        patch :decide_lost
        patch :reopen
      end
    end

    get "reports/daily_volume", to: "reports#daily_volume"
    get "reports/time_to_decision", to: "reports#time_to_decision"
  end

  namespace :webhooks do
    post "disputes", to: "disputes#create"
  end

end
