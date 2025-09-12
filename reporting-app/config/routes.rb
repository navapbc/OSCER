Rails.application.routes.draw do
  resources :activity_report_application_forms do
    resources :activities, only: [ :show, :new, :create, :edit, :update, :destroy ] do
      member do
        get :documents
        post :upload_documents
        delete :destroy_document
      end
    end
    member do
      get :review
      post :submit
    end
  end

  get "/dashboard", to: "dashboard#index"

  scope path: "/staff" do
    resources :certifications

    resources :activity_report_cases do
      collection do
        get :closed
      end

      member do
        get :tasks
        get :documents
        get :notes
      end
    end

    resources :tasks, only: [ :index, :show, :update ] do
      collection do
        post :pick_up_next_task
      end
    end

    resources :review_activity_report_tasks, only: [ :update ]
  end

  get "/staff", to: "staff#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "health" => "rails/health#show", as: :rails_health_check
  # Keep the default /up rails endpoint.
  get "up" => "rails/health#show"

  mount Lookbook::Engine, at: "/lookbook" if ENV["ENABLE_LOOKBOOK"].present?

  # Support locale prefixes for these routes:
  localized do
    # Defines the root path route ("/")
    root "home#index"

    # Session management
    devise_for :users, controllers: { sessions: "users/sessions" }
    devise_scope :user do
      get "sessions/challenge" => "users/sessions#challenge", as: :session_challenge
      post "sessions/challenge" => "users/sessions#respond_to_challenge", as: :respond_to_session_challenge
    end

    # Registration and account management
    namespace :users do
      resources :registrations, only: [ :create ]
      get "registrations" => "registrations#new", as: :new_registration

      resources :mfa, only: [ :new, :create ]
      get "mfa/preference" => "mfa#preference", as: :mfa_preference
      post "mfa/preference" => "mfa#update_preference", as: :update_mfa_preference
      delete "mfa" => "mfa#destroy", as: :disable_mfa

      get "forgot-password" => "passwords#forgot"
      post "forgot-password" => "passwords#send_reset_password_instructions"
      get "reset-password" => "passwords#reset"
      post "reset-password" => "passwords#confirm_reset"

      get "verify-account" => "registrations#new_account_verification"
      post "verify-account" => "registrations#create_account_verification"
      post "resend-verification" => "registrations#resend_verification_code"

      get "account" => "accounts#edit"
      patch "account/email" => "accounts#update_email"
    end

    # Development-only sandbox
    namespace :dev do
      get "sandbox"
      post "send_email"
    end
  end
end
