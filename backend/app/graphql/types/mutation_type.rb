module Types
  class MutationType < Types::BaseObject
    description "The mutation root of this schema"

    field :purchase_points_product, mutation: Mutations::PurchasePointsProduct, 
      description: "Purchase a points product using customer points"
      
    field :check_math_problem, mutation: Mutations::CheckMathProblem,
      description: "Check the correctness of a customer's math problem solution"
      
    field :adjust_points_balance, mutation: Mutations::AdjustPointsBalance,
      description: "Adjust a customer's points balance"
  end
end 