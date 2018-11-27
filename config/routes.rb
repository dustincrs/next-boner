Rails.application.routes.draw do
  mount ActionCable.server => '/cable'  
  get 'rooms/show'
  root :to  => 'welcome#index'

  resources :projects
  resources :users
  resources :responses

  get 'badges/:user_id' => 'badges#show', as: 'display_badge'

  get 'reviews/:user_id' => 'reviews#display', as: 'display_reviews'

  get 'users/:id/projects' => 'users#display_projects', as: 'display_projects'

  patch 'projects/:id/complete' => 'projects#complete', as: 'complete_project'

  get 'reviews/:project_id/:user_id/new' => 'reviews#new', as: 'new_review'
  get 'reviews/:review_id' => 'reviews#show', as: 'review'
  post 'reviews/create' => 'reviews#create', as: 'reviews'
  
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
  get 'rooms/show'
    get 'auth/facebook/callback', to: "sessions#create"
    get 'auth/failure', to: redirect('/')
  end

  #chatrooms
  get '/projects/:id/rooms', to: 'rooms#show', as: 'chatroom' 

end
