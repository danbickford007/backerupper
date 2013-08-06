module Extractor
  require 'fakefs/safe'
  require 'rubygems/package'
  require 'zlib'

  def open_tar
    @files = []
    FakeFS do 
      tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open('myTarGz.tar.gz'))
      tar_extract.rewind
      tar_extract.each do |entry|
        puts @files << entry.full_name
        if entry.directory?
          FileUtils.mkdir_p(entry.full_name)
        end
        if entry.file?
          f = File.new(entry.full_name, 'w')
          f.puts entry.read
          f.close
        end
        tar_extract.close 
      end
    end
    @files.reject{|x| x if x.split('/').count > 3 }
  end

  def read_file(file_name)
    data = ''
    FakeFS do
      if File.directory? file_name
        p ">>>>>>>>>"
        p Dir.entries(file_name)
        return Dir.entries(file_name)
      end
      file = File.open(file_name, "r")
      data = file.read
      file.close
    end
    data
  end

end
