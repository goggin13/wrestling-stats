Rails.application.routes.draw do
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
