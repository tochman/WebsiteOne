class AddGithubFields < ActiveRecord::Migration
  def change
    add_column :projects, :github_owner, :string
    add_column :projects, :github_repo, :string
  end
end
