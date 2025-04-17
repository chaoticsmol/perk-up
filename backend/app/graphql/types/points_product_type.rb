module Types
  class PointsProductType < Types::BaseObject
    field :id, ID, null: false
    field :exchange_type, String, null: false
    field :exchange_description, String, null: false
    field :points_price, Integer, null: true
    field :variable_points_step, Integer, null: true
    field :variable_points_step_reward_value, Integer, null: true
    field :variable_points_max, Integer, null: true
    field :reward, Types::RewardType, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end