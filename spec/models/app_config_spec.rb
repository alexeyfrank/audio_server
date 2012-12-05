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

require 'spec_helper'

describe AppConfig do
  pending "add some examples to (or delete) #{__FILE__}"
end
