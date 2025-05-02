# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :workforce_configurations

namespace :workforce do
  get 'custom_fields', to: 'custom_api#custom_fields'
  get 'issues/:id', to: 'custom_api#issues'
  post 'journals', to: 'custom_api#create_journal'
end
