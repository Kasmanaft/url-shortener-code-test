require 'rails_helper'

describe 'url routing', type: :routing do
  it { expect(post: '/').to route_to 'urls#create' }
end
