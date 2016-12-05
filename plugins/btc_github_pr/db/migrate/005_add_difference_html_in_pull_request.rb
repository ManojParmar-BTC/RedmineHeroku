class AddDifferenceHtmlInPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :difference_html, :string
  end
end
