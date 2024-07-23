# spec/pdf_generator_spec.rb
require 'wicked_pdf'
require 'erb'
require 'fileutils'
require_relative '../pdf_generator'  
require_relative '../car'

RSpec.describe PDF_Generator do
  let(:cars) { [Car.new('url', 'Audi', 'A4', '20000 PLN', 'image_url', '20000 km', 'Diesel', 'Manual', '2020')] }
  let(:pdf_generator) { PDF_Generator.new }

  describe '#generate_content' do
    let(:template_path) { './html_templates/template.erb' }
    let(:template_content) { '<html><body><%= cars.first.model %></body></html>' }
    
    before do
      allow(File).to receive(:read).with(template_path).and_return(template_content)
    end

    it 'generates HTML content from the template and car data' do
      html_content = pdf_generator.generate_content(cars)
      expect(html_content).to include(cars.first.model)
    end
  end

  describe '#generate_pdf' do
    let(:html_content) { '<html><body>Audi A4</body></html>' }
    let(:pdf_content) { '%PDF-1.4' }

    before do
      allow(pdf_generator).to receive(:generate_content).with(cars).and_return(html_content)
      allow_any_instance_of(WickedPdf).to receive(:pdf_from_string).with(html_content).and_return(pdf_content)
    end

    it 'generates a PDF file from the car data' do
      pdf_generator.generate_pdf(cars)
      expect(File.exist?('cars.pdf')).to be true
      expect(File.read('cars.pdf')).to start_with(pdf_content)
    ensure
      FileUtils.rm_f('cars.pdf')
    end
  end

  describe '#generate_content_table' do
    let(:template_path) { './html_templates/template_table.html.erb' }
    let(:template_content) { '<html><body><table><tr><%= cars.first.model %></tr></table></body></html>' }

    before do
      allow(File).to receive(:read).with(template_path).and_return(template_content)
    end

    it 'generates HTML content for a table from the template and car data' do
      html_content = pdf_generator.generate_content_table(cars)
      expect(html_content).to include(cars.first.model)
    end
  end

  describe '#generate_pdf_table' do
    let(:html_content) { '<html><body><table><tr>Audi A4</tr></table></body></html>' }
    let(:pdf_content) { '%PDF-1.4' }

    before do
      allow(pdf_generator).to receive(:generate_content_table).with(cars).and_return(html_content)
      allow_any_instance_of(WickedPdf).to receive(:pdf_from_string).with(html_content).and_return(pdf_content)
    end

    it 'generates a PDF file with a table from the car data' do
      pdf_generator.generate_pdf_table(cars)
      expect(File.exist?('simple_pdf.pdf')).to be true
      expect(File.read('simple_pdf.pdf')).to start_with(pdf_content)
    ensure
      FileUtils.rm_f('simple_pdf.pdf')
    end
  end
end
