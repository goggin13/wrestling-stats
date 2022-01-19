Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "matches#index"

  get '/individual_rankings/:weight', to: 'wrestlers#individual_rankings', as: 'individual_rankings'

  get '/matches/preview', to: 'matches#preview', as: 'preview'

  get '/colleges', to: 'colleges#index', as: 'colleges'
end
