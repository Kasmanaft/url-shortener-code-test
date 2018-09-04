require 'rails_helper'

describe UrlsController, type: :controller do
  describe '#create' do
    it 'should return 200 when everything is ok' do
      post :create, params: {"url": 'http://www.farmdrop.com'}, as: 'json'
      expect(response).to have_http_status(:success)
    end

    it 'should return error http status on error' do
      post :create, params: {"wrongurl": 'http://www.farmdrop.com'}, as: 'json'
      expect(response).to have_http_status(:error)
    end
  end
end
