class ChangeHtmlDifferenceColumnTypeToTextInPullRequests < ActiveRecord::Migration
  def change
    change_column :pull_requests, :difference_html,  :text
  end
end
