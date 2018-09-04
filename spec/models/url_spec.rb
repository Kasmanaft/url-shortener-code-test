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
  end
end
