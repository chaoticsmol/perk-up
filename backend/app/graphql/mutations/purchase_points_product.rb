module Mutations
  class PurchasePointsProduct < Mutations::BaseMutation
    description "Purchase a points product using customer points"

    # Define the arguments (inputs) for this mutation
    argument :product_id, String, required: true, description: "ID of the points product to purchase"
    argument :customer_id, String, required: true, description: "ID of the customer making the purchase"
    argument :points_amount, Integer, required: true, description: "Number of points to spend on this purchase"

    # Define the return fields
    field :success, Boolean, null: false, description: "Whether the purchase was successful"
    field :message, String, null: true, description: "Success or error message"
    field :reward, Types::RewardType, null: true, description: "The reward that was earned"

    # Define the resolve method
    def resolve(product_id:, customer_id:, points_amount:)
      client = ::Api::Smile.new(api_key: Rails.application.credentials.smile.private_key)
      response = client.purchase_points_product(product_id, customer_id, points_amount)
      {
        success: true,
        message: "Successfully purchased points product",
        reward: response['points_purchase']['reward_fulfillment']
      }
    rescue StandardError => e
      # Handle errors from the API call
      {
        success: false,
        message: "Error: #{e.message}",
        reward: nil
      }
    end
  end
end 