require 'rails_helper'

describe UrlsController, type: :controller do
  describe '#create' do
    context 'everythin is ok' do
      it 'should return 200' do
        post :create, params: {"url": 'http://www.farmdrop.com'}, as: 'json'
        expect(response).to have_http_status(:success)
      end

      it 'should return json' do
        post :create, params: {"url": 'http://www.farmdrop.com'}, as: 'json'
        expect(response.content_type).to eq("application/json")
      end

      it 'should return back url' do
        post :create, params: {"url": 'http://www.farmdrop.com'}, as: 'json'
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["url"]).to eq('http://www.farmdrop.com')
      end

      it 'should return back shortened url' do
        post :create, params: {"url": 'http://www.farmdrop.com'}, as: 'json'
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["short_url"]).to match /^\/[a-zA-Z0-9\-_]{6}$/
      end

      it 'should return different shortened url for different urls' do
        post :create, params: {"url": 'http://www.farmdrop.com'}, as: 'json'
        parsed_first_body = JSON.parse(response.body)
        post :create, params: {"url": 'http://www.farmdrop0.com'}, as: 'json'
        parsed_second_body = JSON.parse(response.body)
        expect(parsed_first_body["short_url"]).not_to eq(parsed_second_body["short_url"])
      end

      it 'should return the same different shortened url for same urls' do
        post :create, params: {"url": 'http://www.farmdrop.com'}, as: 'json'
        parsed_first_body = JSON.parse(response.body)
        post :create, params: {"url": 'http://www.farmdrop.com'}, as: 'json'
        parsed_second_body = JSON.parse(response.body)
        expect(parsed_first_body["short_url"]).to eq(parsed_second_body["short_url"])
      end

      it 'should return the same different shortened url for same urls, even if we have letters in different cases' do
        post :create, params: {"url": 'http://www.farmdrop.com'}, as: 'json'
        parsed_first_body = JSON.parse(response.body)
        post :create, params: {"url": 'http://www.fArMDrop.com'}, as: 'json'
        parsed_second_body = JSON.parse(response.body)
        expect(parsed_first_body["short_url"]).to eq(parsed_second_body["short_url"])
      end
    end

    it 'should return error http status on error' do
      post :create, params: {"wrongurl": 'http://www.farmdrop.com'}, as: 'json'
      expect(response).to have_http_status(:bad_request)
    end
  end
end
