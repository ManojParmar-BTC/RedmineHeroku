class CreateUserAuthentications < ActiveRecord::Migration
  def change
    create_table :user_authentications do |t|
      t.string :provider
      t.string :token
      t.string :secret
      t.references :user
    end
  end
end
