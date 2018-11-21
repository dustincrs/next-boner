Rails.application.routes.draw do
	root :to  => 'welcome#index'
	resources :projects
	resources :users
  resources :responses
  
  # Clearance
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  # Google OAuth
  get "/auth/:provider/callback" => "sessions#create_from_omniauth"
  
  # Facebook OAuth
  Rails.application.routes.draw do
    get 'auth/facebook/callback', to: "sessions#create"
    get 'auth/failure', to: redirect('/')
  end

end
