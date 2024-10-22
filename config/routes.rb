# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :workforce_configurations

get '/workforce/custom_fields', to: 'workforce/custom_fields#index'
