require 'httparty' 
require 'nokogiri'
require 'uri'
require 'logger'
require_relative 'car'

# A class responsible for scraping car data from a given URL.
class Scraper 

	# link to the page that contains data to scrape
	# @return [String] the link to the page
	attr_accessor :link
	
	# car brand that will be scraped
	# @return [String] the brand of the cars to be scraped.
	attr_accessor :brand 

	# limits the number of pages to scrape
  # @return [Numeric] the number of pages to scrape
	attr_accessor :limit

  # Initializes a new Scraper instance. Also create logger instance for loggs
  #
  # @param link [String] The base URL for scraping.
  # @param brand [String] The brand of the cars to be scraped.
  # @param limit [Integer] The number of pages to scrape.
	def initialize(link, brand, limit)
		@link = link
		@brand = brand
		@limit = limit
		@logger = Logger.new('./logs/scraper.log')
		@logger.level = Logger::DEBUG   
	end

  # Checks if a given URL is valid.
  #
  # @param url [String] The URL to be validated.
  # @return [Boolean] `true` if the URL is valid, otherwise `false`.
	def valid_url?(url)
		url_regex = /\A#{URI::regexp(['http', 'https'])}\z/
		url_regex.match?(url)
	end

  # Scrapes car data from the specified pages and returns an array of `Car` structs.
  #
  # @return [Array<Car>] An array of `Car` structs containing scraped data.
  # @raise [ArgumentError] if the provided URL is invalid.
	def scrape_data()
		# initializing the list of objects (cars)
		# that will contain the scraped data (cars)
		cars = []
	
		# list of data parameters that will be scraped
		data_parameter_values = ['fuel_type', 'mileage', 'gearbox', 'year']
	
		# checks whether the link is correct
		unless valid_url?(link)
			raise ArgumentError, "Invalid URL provided"
			return nil
		end
		
		#log info 
		@logger.info("Starting to scrape data from #{self.link} for brand #{self.brand}")

		# Define the base URL for pagination by appending '?page=' to the base link
		base_url = self.link + self.brand + '?page='
	
		# Create an array of page URLs to scrape, from page 1 up to the value of `limit`
		pages_to_scrape = []
		
		(1..limit).map do |page_number|
			pages_to_scrape.push("#{base_url}#{page_number}")
		end
	
		# Iterate over each page URL in the array
		pages_to_scrape.each do |page_to_scrape|
			begin
				# retrieving the current page to scrape 
				response = HTTParty.get(page_to_scrape, {
					headers: { "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36" },
				})
	
				if response.code != 200
					@logger.warn("HTTP request failed with code #{response.code} for URL #{page_to_scrape}")
					next
				end
	
				# parsing the HTML document using Nokogiri returned by the server 
				document = Nokogiri::HTML(response.body)
	
				offers = document.xpath('//div[not(@class)]/article')
	
				offers.each do |offer|
					images = offer.xpath('.//img')
					price_html = offer.xpath('.//h3')
					link = offer.xpath('.//a[starts-with(@href, "https://www.otomoto.pl/osobowe/oferta") and @target="_self"]')
					@logger.info("link: #{link}")
					href_value = link.attribute('href').value
					@logger.info("link: #{href_value}")
					model = link.text.strip
					price = price_html.text.strip
	
					image = images[0] ? images[0]['src'] : ''
	
					brand = 'Audi'
	
					car = Car.new(href_value, brand, model, price, image, '', '', '', '')
	
					data_parameter_values.each do |data_parameter_value|
						dd = offer.xpath(".//dd[@data-parameter='#{data_parameter_value}']")
						car[data_parameter_value.to_sym] = dd.text.strip
					end 
					cars.push(car)
				end
			rescue StandardError => e
				@logger.error("Error while scraping page #{page_to_scrape}: #{e.message}")
			end
		end
		@logger.info("Finished scraping data. Total cars scraped: #{cars.size}")
		return cars
	end
	
  # Scrapes data and saves it to a CSV file.
  #
  # @param filename [String] The name of the CSV file to save the data.
  # @return [void]
	def scrape_and_save_to_csv(filename)

		filename += '.csv' unless filename.downcase.end_with?('.csv')

		csv_headers = ['url', 'brand', 'model', 'price', 'image', 'mileage', 'fuel_type', 'gearbox', 'year']

		begin
		# Scrape data.
		cars = scrape_data()

		# Save the data to a CSV file.
		CSV.open(filename, "wb", write_headers: true, headers: csv_headers) do |csv|
			cars.each do |car|
			csv << car.to_a
			end
		end
		@logger.info("Data successfully saved to #{filename}")
		rescue 
			@logger.info("Data successfully saved to #{filename}")
		end
	end 
end 

