module Types
  class QueryType < Types::BaseObject
    field :customer, Types::CustomerType, null: true do
      description "Find a customer by ID"
      argument :id, ID, required: true
    end

    def customer(id:)
      client.customer(id)['customer']
    end

    field :points_products, [Types::PointsProductType], null: true do
      description "Find all points products"
      argument :page, Integer, required: false, default_value: 1
      argument :per_page, Integer, required: false, default_value: 50
    end

    def points_products(page: 1, per_page: 50)
      client.points_products(page: page, per_page: per_page)['points_products']
    end

    private

    def client
      @client ||= ::Api::Smile.new(api_key: Rails.application.credentials.smile.private_key)
    end
  end
end 