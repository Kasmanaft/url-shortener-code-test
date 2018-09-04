class Url
  # include ActiveModel::ForbiddenAttributesProtection

  def initialize(params)
    # super params
    # params
  end

  def short_url
    '/abc123'
  end

  def url
    'http://www.farmdrop.com'
  end
end
