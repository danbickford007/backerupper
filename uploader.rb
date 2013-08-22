require 'rest_client'
RestClient.post('http://localhost:5000/backups', 
                  :file => File.new((`pwd`.gsub(/\n/, '')) + '/myTarGz.tar.gz'))
