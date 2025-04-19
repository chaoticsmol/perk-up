module Types
  class MutationType < Types::BaseObject
    description "The mutation root of this schema"

    field :purchase_points_product, mutation: Mutations::PurchasePointsProduct, 
      description: "Purchase a points product using customer points"
  end
end 