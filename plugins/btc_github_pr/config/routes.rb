# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'pull_requests', :to => 'pull_requests#index'
post 'pull_requests/github_hook', :to => 'pull_requests#github_hook'