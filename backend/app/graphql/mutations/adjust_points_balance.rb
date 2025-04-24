module Mutations
  class AdjustPointsBalance < Mutations::BaseMutation
    description "Adjust a customer's points balance"

    # Define the arguments (inputs) for this mutation
    argument :customer_id, String, required: true, description: "ID of the customer whose points will be adjusted"
    argument :amount, Integer, required: true, description: "Amount of points to add or subtract (negative for subtraction)"

    # Define the return fields
    field :success, Boolean, null: false, description: "Whether the points adjustment was successful"

    # Define the resolve method
    def resolve(customer_id:, amount:)
      client = ::Api::Smile.new(api_key: Rails.application.credentials.smile.private_key)
      response = client.adjust_points_balance(customer_id, amount: amount)
      
      { success: response.fetch('points_transaction', {}).fetch('points_change', 0) == amount }
    rescue StandardError => e
      Rails.logger.error("Error adjusting points balance: #{e.message}")
      { success: false }
    end
  end
end 