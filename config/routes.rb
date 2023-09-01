Rails.application.routes.draw do
  namespace :olympics do
    resources :teams
    resources :matches, only: [:index, :update]

    get "/scoreboard", to: "scoreboard#scoreboard"
    get "/generate_brackets", to: "scoreboard#generate_form"
    post "/generate_brackets", to: "scoreboard#generate_brackets"
    get "/fetch_now_playing" => 'scoreboard#fetch_now_playing', as: 'fetch_now_playing'
    get "/fetch_on_deck" => 'scoreboard#fetch_on_deck'
    get "/fetch_rankings" => 'scoreboard#fetch_rankings'
    get "/fetch_tiebreaker" => 'scoreboard#fetch_tiebreaker'
    get "/fetch_latest_updated_at" => 'scoreboard#fetch_latest_updated_at'
  end

  namespace :advocate do
    get "/schedule", to: "schedule#show"
    get "/employees", to: "employee#index"
    get "/staffing_data", to: "schedule#staffing_data"
  end

  namespace :etoh do
    get "/drinks", to: "drinks#index"
    post "/drinks", to: "drinks#create"
    get "/delete_drink", to: "drinks#destroy"
  end

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get "/users/sign_out", to: "devise/sessions#destroy"
  end
  get "/access_denied", to: "application#access_denied"

  #### <Wrestling>
  root "matches#index"

  get "/individual_rankings/:weight", to: "wrestlers#individual_rankings", as: "individual_rankings"

  get "/matches/preview", to: "matches#preview", as: "preview"
  get "/matches/:id", to: "matches#edit", as: "match"
  patch "/matches/:id", to: "matches#update", as: "update_match"

  get "/colleges", to: "colleges#index", as: "colleges"
  get "/colleges/:id", to: "colleges#show", as: "college"
  #### </Wrestling>
end
