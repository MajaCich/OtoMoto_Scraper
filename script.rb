require './scraper.rb'
require 'csv'
require './pdf_generator.rb'

#Read user input
puts "Podaj markę samochodu:"
brand = gets.chomp # Wczytuje wejście użytkownika i usuwa znak nowej linii
brand = brand.downcase # Zamienia wszystkie litery na małe
puts "Proszę czekać . . ."

# Initializes a new instance of the Scraper class and scrapes data from the specified URL.
#
# @example
#   scraper = Scraper.new('https://www.otomoto.pl/osobowe/', 'audi', 1)
#   cars = scraper.scrape_data()
#
# @param url [String] The URL of the page to scrape.
# @param brand [String] The brand of cars to scrape.
# @param page_number [Integer] The page number to scrape.
# @return [Array<Car>] An array of car objects scraped from the website.
scraper = Scraper.new('https://www.otomoto.pl/osobowe/', brand, 2)

#scrape data
cars = scraper.scrape_data()

# Initializes a new instance of the PDF_Generator class and generates a PDF with the scraped car data.
#
# @example
#   generator = PDF_Generator.new()
#   generator.generate_pdf(cars)
#
# @param cars [Array<Car>] An array of car objects to include in the PDF.
# @return [void]
generator = PDF_Generator.new()

#generate pdf
generator.generate_pdf(cars)

#scrape data and save to csv 
# param [String] the filename 
#scraper.scrape_and_save_to_csv("test.csv")


