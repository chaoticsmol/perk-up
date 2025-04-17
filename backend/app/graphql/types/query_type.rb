module Types
  class QueryType < Types::BaseObject
    field :customer, Types::CustomerType, null: true do
      description "Find a customer by ID"
      argument :id, ID, required: true
    end

    def customer(id:)
      client = ::Api::Smile.new(api_key: Rails.application.credentials.smile.private_key)
      client.customer(id)['customer']
    end
  end
end 