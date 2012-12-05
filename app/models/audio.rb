require "fileutils"

class Audio
  attr_accessor :filename
  attr_accessor :path

  def initialize(filename = "", type = "", day = "", hour = "")
    @filename = filename
    base_path = File.join(AppConfig.first.dropbox_path, type, day, hour)
    @path =  File.join(base_path, filename)
  end

  def to_jq_upload
    {
        "name" => @filename,
        "size" => File.size(@path),
        "delete_url" => "/tracks/delete?filepath=" +  @path,
        "delete_type" => "DELETE"
    }
  end


  def self.mkdir(type, day, hour)
    conf = AppConfig.first
    path = File.join conf.dropbox_path, type, day, hour
    FileUtils.mkdir_p path unless Dir.exist? path
  end

  def self.all(type, day, hour)
    dir_path = File.join(AppConfig.first.dropbox_path, type, day, hour)

    files = Dir.exists?(dir_path) ? Dir.entries(dir_path) : Array.new
    files.delete_if { |f| f == '.' or f == '..' }

    files.map { |f| Audio.new(f, type, day, hour) }
  end

  def save(from_bytes)
    File.open(@path, 'wb') {|f| f.write(from_bytes) }
    # FileUtils.copy(from, @path)
    c = AppConfig.first
    FileUtils.chmod(0666, @path)
    FileUtils.chown(c.owner_member, c.owner_group, @path)
  end

end