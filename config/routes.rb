Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "matches#index"

  get '/individual_rankings/:weight', to: 'wrestlers#individual_rankings', as: 'individual_rankings'

  get '/matches/preview', to: 'matches#preview', as: 'preview'
  get '/matches/:id', to: 'matches#edit', as: 'match'
  patch '/matches/:id', to: 'matches#update', as: 'update_match'

  get '/colleges', to: 'colleges#index', as: 'colleges'
  get '/colleges/:id', to: 'colleges#show', as: 'college'
end
