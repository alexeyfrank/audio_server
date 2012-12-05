class CreateAppConfigs < ActiveRecord::Migration
  def change
    create_table :app_configs do |t|
      t.string :dropbox_path
      t.string :dropbox_adv_path
      t.string :dropbox_music_path
      t.string :dropbox_log_path
    end
  end
end
