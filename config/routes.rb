# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

scope 'workforce' do
  resource :project_configuration, controller: 'workforce', only: [:create, :update], as: 'workforce_project_configuration'
  get 'audit', to: 'workforce#audit', as: 'workforce_audit'
end
