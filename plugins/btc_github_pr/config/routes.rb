# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'pull_requests', to: 'pull_requests#index'
get 'pull_requests/view_changed_files/:id', to: 'pull_requests#view_changed_files', as: "view_changed_files" 
post 'pull_requests/github_hook', :to => 'pull_requests#github_hook'