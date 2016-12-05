class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :token
      t.string :secret
      t.integer :user_id
    end
  end
end
