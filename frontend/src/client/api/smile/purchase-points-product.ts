import { Reward } from "./types"
import getConfig from "../../config"

const PURCHASE_POINTS_PRODUCT_MUTATION = `
  mutation PurchasePointsProduct($input: PurchasePointsProductInput!) {
    purchasePointsProduct(input: $input) {
      success
      message
      reward {
        id
        name
        code
        imageUrl
        actionText
        actionUrl
        usageInstructions
        termsAndConditions
        expiresAt
      }
    }
  }
`;

const purchasePointsProduct = async (productId: string, customerId: string, pointsAmount: number): Promise<Reward> => {
  const { perkUpAPI } = getConfig();
  
  try {
    const response = await fetch(`${perkUpAPI}/graphql`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        query: PURCHASE_POINTS_PRODUCT_MUTATION,
        variables: {
          input: {
            productId,
            customerId,
            pointsAmount
          }
        }
      })
    });

    const data = await response.json();
    
    if (data.errors) {
      console.error('Error purchasing points product:', data.errors);
      throw new Error('Error purchasing points product');
    }
  
    console.log('Purchase points product response:', data);
    return data.data.purchasePointsProduct.reward;
  } catch (error) {
    console.error('Error purchasing points product:', error);
    throw new Error('Error purchasing points product');
  }
};

export { purchasePointsProduct };