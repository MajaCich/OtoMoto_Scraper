# Scraper
Scraper, który wyciąga informacje o samochodach z serwisi otomoto.pl \
Do tworzenia pdf'ów wykorzystany został 'wicked-pdf' \ 

# Uruchomienie

Przed uruchomieniem trzeba zainstalować potrzebne gemy za pomocą komendy: bundle install \
Następnie za pomocą: bundle exec ruby script.rb \
Można uruchomić program, który wyciaga informacje z ogłoszeń sprzedaży samochodu, a następnie zapisuje te dane w pliku pdf. \
Możliwe jest wygenerowanie, także pliku .csv zawierającego dane \ 

# Testy
Testy znajdują się w folderze '/spec' \
Raport z testów znajduję się w "/spec/rspec_results.html" \
Testy można uruchomić poprzez komendę 'rspec' w folderze projektu \
Uruchomić testy można także komendą "bundle exec rspec'

# Dokumentacja 
Dokumentacja (stworzona za pomoca yard) znajdują sie w foldrze '/doc' \
Dokumentacja tworzona jest za pomocą komendy:  bundle exec yard doc scraper.rb pdf_generator.rb script.rb  car.rb ./spec/*spec.rb --plugin rspec

# Logi
Logi są zapisywane w folderze '/logs'

