# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'login_github', :to => 'github_authorize#index'
get 'github_authorize/authenticate_user', :to => 'github_authorize#authenticate_user'