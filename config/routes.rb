Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "matches#index"

  get '/individual_rankings/:weight', to: 'wrestlers#individual_rankings', as: 'individual_rankings'

  get '/colleges/preview_form', to: 'colleges#preview_form', as: 'preview_form'
  post '/colleges/preview', to: 'colleges#preview', as: 'preview'
  get '/colleges/preview', to: 'colleges#preview'
  resources :colleges
end
