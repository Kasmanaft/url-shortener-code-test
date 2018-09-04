class Url
  @@urls_store = {}

  attr_accessor :short_url
  attr_accessor :full_url

  def initialize(url)
    self.full_url = normalize url
  end

  def normalize(url)
    url.downcase!
    unless url.start_with?('http://') || url.start_with?('https://')
      url = "http://#{url}"
    end
    url
  end

  def full_url=(url)
    @full_url = url
    if @@urls_store[url].nil?
      @@urls_store[url] = "/#{SecureRandom.urlsafe_base64(6, false)[0..5]}"
    end
    @short_url = @@urls_store[url]
  end
end
