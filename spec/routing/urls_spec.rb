require 'rails_helper'

describe 'url routing', type: :routing do
  it { expect(post: '/').to route_to 'urls#create' }
  it { expect(get: '/abc123').to route_to 'urls#show', id: 'abc123' }
end
