module Types
  class QueryType < Types::BaseObject
    field :test_field, String, null: false,
      description: "An example field added to the schema"
    def test_field
      "Hello GraphQL API!"
    end
  end
end 