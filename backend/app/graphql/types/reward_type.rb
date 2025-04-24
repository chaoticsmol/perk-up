module Types
  class RewardType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String, null: true
    field :image_url, String, null: true
    field :code, String, null: true
    field :action_text, String, null: true
    field :action_url, String, null: true
    field :usage_instructions, String, null: true
    field :terms_and_conditions, String, null: true
    field :expires_at, GraphQL::Types::ISO8601DateTime, null: true
    field :used_at, GraphQL::Types::ISO8601DateTime, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end