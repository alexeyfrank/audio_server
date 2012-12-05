class AppConfigChmodFields < ActiveRecord::Migration
  def up
    add_column :app_configs, :mode, :string
    add_column :app_configs, :owner_member, :string
    add_column :app_configs, :owner_group, :string
  end

  def down
    remove_column :app_configs, :mode
    remove_column :app_configs, :owner_member
    remove_column :app_configs, :owner_group
  end
end
