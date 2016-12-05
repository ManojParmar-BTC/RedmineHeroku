Redmine::Plugin.register :login_github do
  name 'login github'
  author 'Manoj parmar'
  description 'This plugin helps to login redmine user in github'
  version '0.0.1'
  url 'https://github.com/ManojParmar-BTC'
  author_url 'http://example.com/about'
end

Redmine::Plugin.register :redmine_login_github do
  permission :login_github, { :github_authorize => [:index] }, :public => true
  menu :project_menu, :login_github, { :controller => 'github_authorize', :action => 'index' }, :caption => 'Github Login', :after => :activity, :param => :project_id
end