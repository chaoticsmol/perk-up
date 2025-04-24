module Types
  class CustomerType < Types::BaseObject
    field :id, ID, null: false
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :email, String, null: true
    field :date_of_birth, GraphQL::Types::ISO8601Date, null: true
    field :points_balance, Integer, null: true
    field :referral_url, String, null: true
    field :state, String, null: true
    field :vip_tier_id, ID, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end 