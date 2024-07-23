require 'bundler/setup'
require 'wicked_pdf'
require 'logger'

require_relative 'car'

#  WickedPdf configuration
WickedPdf.config = {
  exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')
}

# PDF_Generator class to handle PDF generation
class PDF_Generator

  # Initializes a new PDF_Generator instance. Also create logger instance for loggs
  #
  def initialize
    @logger = Logger.new('./logs/pdf_generator.log')
		@logger.level = Logger::DEBUG 
  end

  # Generates HTML content from a template and a list of cars
  # 
  # @param cars [Array<Car>] an array of car objects
  # @return [String] the rendered HTML content
  def generate_content(cars)
     # Define the path to your ERB template
     template_path = './html_templates/template.erb'

     begin
      # Read the template file
      template = File.read(template_path)
     rescue
      @logger.warn("Error while opening file")
     end
 
     # Create an ERB instance with the template
     erb = ERB.new(template)
 
     # Render the HTML with the data
     return html_content = erb.result(binding)
  end

  # Generates a PDF file from a list of cars
  #
  # @param cars [Array<Car>] an array of car objects
  # @return [void]
  def generate_pdf(cars)
    html_content = generate_content(cars)
    begin
    pdf_content = WickedPdf.new.pdf_from_string(html_content)
    File.open('cars.pdf', 'wb') do |file|
      file << pdf_content
    end
    rescue
      @logger.warn("Error while saving data to pdf")
    end
    @logger.info("PDF is successfully generated!")
  end

  # Generates HTML content for a table from a template and a list of cars
  #
  # @param cars [Array<Car>] an array of car objects
  # @return [String] the rendered HTML content for the table
  def generate_content_table(cars)
    # Define the path to your ERB template
    template_path = './html_templates/template_table.html.erb'

    begin
    # Read the template file
    template = File.read(template_path)
    rescue
      @logger.warn("Error while opening file")
    end


    # Create an ERB instance with the template
    erb = ERB.new(template)

    # Render the HTML with the data
    return html_content = erb.result(binding)
  end 

  # Generates a PDF file with a table from a list of cars
  #
  # @param cars [Array<Car>] an array of car objects
  # @return [void]
  def generate_pdf_table(cars)
    html_content = generate_content_table(cars)
    begin
      pdf_content = WickedPdf.new.pdf_from_string(html_content)
      File.open('simple_pdf.pdf', 'wb') do |file|
        file << pdf_content
      end
    rescue 
      @logger.warn("Error while saving data to pdf")
    end
    @logger.info("PDF is successfully generated!")
  end
end
