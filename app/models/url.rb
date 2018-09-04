class Url
  @@urls_store = {}

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

  def short_url
    "/#{@short_url}"
  end

  def full_url=(url)
    @full_url = url
    @short_url = @@urls_store[url]
    if @short_url.nil?
      begin
        @short_url = generate_new_short_url
      end while @@urls_store.value?(@short_url)
      @@urls_store[url] = @short_url
    end
  end

  def generate_new_short_url
    SecureRandom.urlsafe_base64(6, false)[0..5]
  end

  def self.find(short_url)
    @@urls_store.key(short_url)
  end
end
