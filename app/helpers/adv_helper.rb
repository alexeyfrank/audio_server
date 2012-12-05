module AdvHelper

  def path_to_adv_block_file(base, day, index, ext)
    (File.join(base, day.to_s, index.to_s) + ext)
  end


end