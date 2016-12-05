class UserAuthentication < ActiveRecord::Base
  unloadable
  belongs_to :user
end
