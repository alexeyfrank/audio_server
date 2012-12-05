# == Schema Information
#
# Table name: app_configs
#
#  id                 :integer          not null, primary key
#  dropbox_path       :string(255)
#  dropbox_adv_path   :string(255)
#  dropbox_music_path :string(255)
#  dropbox_log_path   :string(255)
#  mode               :string(255)
#  owner_member       :string(255)
#  owner_group        :string(255)
#

class AppConfig < ActiveRecord::Base
  attr_accessible :dropbox_path
  attr_accessible :dropbox_adv_path
  attr_accessible :dropbox_log_path
  attr_accessible :dropbox_music_path
  attr_accessible :mode
  attr_accessible :owner_member
  attr_accessible :owner_group

  before_update do |c|
    c.dropbox_adv_path = File.join c.dropbox_path, 'adv'
    c.dropbox_log_path = File.join c.dropbox_path, 'log'
    c.dropbox_music_path = File.join c.dropbox_path, 'music'
  end
end
