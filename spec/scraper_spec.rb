# spec/scraper_spec.rb
require_relative '../scraper'  
require_relative '../car'

RSpec.describe Scraper do
  let(:valid_url) { 'https://www.otomoto.pl/osobowe/' }
  let(:invalid_url) { 'invalid-url' }
  let(:brand) { 'audi' }
  let(:limit) { 2 }
  let(:scraper) { Scraper.new(valid_url, brand, limit) }

  describe '#initialize' do
    it 'initializes with a link, brand, and limit' do
      expect(scraper.link).to eq(valid_url)
      expect(scraper.brand).to eq(brand)
      expect(scraper.limit).to eq(limit)
    end
  end

  describe '#valid_url?' do
    it 'returns true for a valid URL' do
      expect(scraper.valid_url?(valid_url)).to be true
    end

    it 'returns false for an invalid URL' do
      expect(scraper.valid_url?(invalid_url)).to be false
    end
  end

  describe '#scrape_data' do
    context 'with a valid URL' do
      before do
        fake_response = instance_double(HTTParty::Response, code: 200, body: '<html></html>')
        allow(HTTParty).to receive(:get).and_return(fake_response)
        fake_document = Nokogiri::HTML('<div><article></article></div>')
        allow(Nokogiri).to receive(:HTML).and_return(fake_document)
      end

      it 'returns an array of Car objects' do
        cars = scraper.scrape_data
        expect(cars).to be_an(Array)
        expect(cars.all? { |car| car.is_a?(Car) }).to be true
      end
    end

    context 'with an invalid URL' do
      let(:scraper_with_invalid_url) { Scraper.new(invalid_url, brand, limit) }

      it 'raises an ArgumentError' do
        expect { scraper_with_invalid_url.scrape_data }.to raise_error(ArgumentError, 'Invalid URL provided')
      end
    end
  end
end

