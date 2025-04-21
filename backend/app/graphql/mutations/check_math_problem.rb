module Mutations
  class CheckMathProblem < Mutations::BaseMutation
    description "Check the correctness of a customer's math problem solution"

    argument :customer_id, String, required: true, description: "ID of the customer solving the problem"
    argument :left_value, Float, required: true, description: "Left value of the expression"
    argument :operator, String, required: true, description: "Operator (div, mult, add, sub)"
    argument :right_value, Float, required: true, description: "Right value of the expression"
    argument :answer, Float, required: true, description: "Customer's answer to the problem"

    field :correct, Boolean, null: false, description: "Whether the answer was correct"

    def resolve(customer_id:, left_value:, operator:, right_value:, answer:)
      if is_correct?(left_value, operator, right_value, answer)
        client = ::Api::Smile.new(api_key: Rails.application.credentials.smile.private_key)
        response = client.solve_math_problem(customer_id)
        Rails.logger.info("Solve math problem response: #{response.inspect}")
        raise response.inspect unless response['activity']

        { correct: true }
      else
        { correct: false }
      end
    rescue StandardError => e
      Rails.logger.error("Error in CheckMathProblem mutation: #{e.message}")
      { correct: false }
    end

    private

    def is_correct?(left_value, operator, right_value, answer)
      correct_answer = 
        case operator
          when 'div'
            left_value / right_value
          when 'mult'
            left_value * right_value
          when 'add'
            left_value + right_value
          when 'sub'
            left_value - right_value
          else
            raise ArgumentError, "Invalid operator: #{operator}"
          end

      Rails.logger.info("Correct answer: #{correct_answer}; provided answer: #{answer}")

      # Allow for small floating point differences (e.g., 0.1 + 0.2 might not equal 0.3 exactly)
      (answer - correct_answer).abs < 0.0001
    end
  end
end 