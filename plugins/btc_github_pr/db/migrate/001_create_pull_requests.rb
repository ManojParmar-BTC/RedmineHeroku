class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.integer :no
      t.integer :git_id
      t.integer :project_id
      t.string :html_url
      t.string :difference_url
      t.string :state
      t.string :title
    end
  end
end
