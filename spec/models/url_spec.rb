require 'rails_helper'

describe Url do
  describe '#normalize' do
    it 'should convert string to lower case' do
      url = Url.new('')
      expect(url.normalize('http://AaBbCc99')).to eq('http://aabbcc99')
    end

    it 'should add missing http:// part' do
      url = Url.new('')
      expect(url.normalize('AaBbCc99')).to eq('http://aabbcc99')
    end

    it 'should not add http:// part for https://' do
      url = Url.new('')
      expect(url.normalize('https://AaBbCc99')).to eq('https://aabbcc99')
    end
  end

  describe '#full_url=' do
    it 'should create new short_url with 6 symbols, if full_url was not seen before' do
      url = Url.new('http://abcd.efg')
      expect(url.short_url).to match /^\/[a-zA-Z0-9\-_]{6}$/
    end

    it 'should return different short_url, for different full_url' do
      url = Url.new('http://abcd.efg')
      seen_url = url.short_url
      url = Url.new('http://abcdassasas.efg')
      expect(url.short_url).not_to eq(seen_url)
    end

    it 'should return same short_url, if full_url was seen before' do
      url = Url.new('http://abcd.efg')
      seen_url = url.short_url
      url = Url.new('http://abcd.efg')
      expect(url.short_url).to eq(seen_url)
    end

    it 'should call #generate_new_short_url when the same short_url already exists' do
      @url = Url.new('http://abcd.efg.klm')
      fire_method = @url.method(:generate_new_short_url)
      @fired = 0
      @previous_url = @url.short_url[1..-1]
      expect(@url).to receive(:generate_new_short_url) do
        if @fired < 3
          @fired += 1
          @previous_url
        else
          fire_method.call
        end
      end.exactly(4).times
      @url.full_url = 'http://something.new'
    end
  end

  describe '#generate_new_short_url' do
    it 'should create string with 6 symbols' do
      url = Url.new('')
      expect(url.generate_new_short_url).to match /^[a-zA-Z0-9\-_]{6}$/
    end
  end
end
