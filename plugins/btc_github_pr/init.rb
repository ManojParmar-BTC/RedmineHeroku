Redmine::Plugin.register :btc_github_pr do
  name 'Pull Request plugin'
  author 'Manoj parmar'
  description 'This is a plugin for displaying pull requests'
  version '0.0.1'
  url 'https://github.com/ManojParmar-BTC/pull_request'
  author_url 'https://github.com/ManojParmar-BTC'

end

Redmine::Plugin.register :redmine_pull_requests do
  permission :pull_requests, { :pull_requests => [:index] }, :public => true
  menu :project_menu, :pull_requests, { :controller => 'pull_requests', :action => 'index' }, :caption => 'Pull Requests', :after => :activity, :param => :project_id
end
