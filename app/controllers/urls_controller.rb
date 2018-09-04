class UrlsController < ApplicationController
  def create
    if urls_params.try(:permitted?) == false
      render status: :bad_request
    else
      @url = Url.new urls_params

      render json: {
        short_url:  @url.short_url,
        url:        @url.full_url
      }
    end
  end

  def show
    @url = Url.find params[:id]
    if @url.nil?
      render status: :not_found
    else
      redirect_to @url, status: 301
    end
  end

  private

  def urls_params
    params.fetch(:url)
  end
end
