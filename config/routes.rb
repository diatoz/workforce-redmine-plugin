# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :workforce_configurations

namespace :workforce do
  get 'custom_fields', to: 'custom_api#custom_fields'
  get 'issues/:id', to: 'custom_api#issues'
  get 'user/:id/token', to: 'custom_api#user_token'
  post 'journals', to: 'custom_api#create_journal'
end
