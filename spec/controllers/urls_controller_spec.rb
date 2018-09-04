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

  describe '#show' do
    it 'should return error http status if path not found' do
      get :show, params: { id: 'something-not-a-6-symbol' }
      expect(response).to have_http_status(:not_found)
    end

    it 'should return redirect status 301 if url was found' do
      post :create, params: {"url": 'http://www.farmdrop144.com'}, as: 'json'
      short_url = JSON.parse(response.body)['short_url']
      get :show, params: { id: short_url.reverse.chop.reverse }
      expect(response).to have_http_status(301)
    end

    it 'should redirect to found url if everything is ok' do
      post :create, params: {"url": 'http://www.farmdrop144.com'}, as: 'json'
      short_url = JSON.parse(response.body)['short_url']
      expect(
        get :show, params: { id: short_url.reverse.chop.reverse }
      ).to redirect_to('http://www.farmdrop144.com')
    end
  end
end
