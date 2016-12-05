class GithubAuthorizeController < ApplicationController
  unloadable
  before_action :github_auth, only: [:index, :authenticate_user]

  def index
    redirect_to @github.authorize_url scope: 'repo'
  end

  def authenticate_user
    token = @github.get_token(params[:code]).token
    user_authentication = UserAuthentication.find_or_create_by(user_id: User.current.id)
    user_authentication.update_attributes(provider: "gihub", token: token)
    flash[:notice] = "Authentication process from github complete."
    redirect_to home_path
  end

  private
    def github_auth
      @github = Github.new client_id: '8609a0c6649b15094da8', client_secret: 'e946dd9a7c800f883c3a64a5e015a98003835b03'
    end
end
