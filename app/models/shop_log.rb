require "fileutils"

class ShopLog

  attr_accessor :address, :date, :logs, :filename

  def initialize(filename, address, date, logs)
    @filename = filename
    @address = address
    @date = date
    @logs = logs
  end

  def self.all
    dir_path = AppConfig.first.dropbox_log_path

    # if log directory not exists - create directory
    unless Dir.exist? dir_path
      Dir.mkdir dir_path
    end

    files = Dir.entries dir_path
    files.delete_if { |f| f == '.' || f == '..' }


    files.map { |f|
      fullpath = File.join(dir_path, f)
      text=File.open(fullpath).read
      text.gsub!(/\r\n?/, "\n")

      index = 0
      addr, date = ""
      logs = []
      text.each_line do |line|
        case index
          when 0
            addr = line
          when 1
            date = line
          else
            logs.push line
        end

        index += 1
      end
      #addr = text[0]
      #date = text[1]
      #logs = text.to_s

      ShopLog.new(f, addr, date, logs)
    }

  end

  def self.get(file)

    fullpath = File.join(AppConfig.first.dropbox_log_path, file)
    unless File.exist? fullpath
      throw Exception.new("File not found! " + fullpath)
    end

    text=File.open(fullpath).read
    text.gsub!(/\r\n?/, "\n")

    index = 0
    addr, date = ""
    logs = []
    text.each_line do |line|
      case index
        when 0
          addr = line
        when 1
          date = line
        else
          logs.push line
      end

      index += 1
    end

    ShopLog.new(file, addr, date, logs)

  end
end