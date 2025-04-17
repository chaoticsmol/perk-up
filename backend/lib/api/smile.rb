require 'httparty'

module Api
  class Smile < BaseClient
    base_uri 'https://api.smile.io/v1'

    def initialize(api_key:)
      @api_key = api_key
      @headers = {
        'Authorization' => "Bearer #{api_key}",
        'Content-Type' => 'application/json'
      }
    end

    def customer(id)
      get("/customers/#{id}", headers: @headers)
    end

    def points_products(page: 1, per_page: 50)
      get("/points_products?page=#{page}&page_size=#{per_page}", headers: @headers)
    end
  end
end