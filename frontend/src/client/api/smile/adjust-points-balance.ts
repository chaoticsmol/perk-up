import { AdjustPointsBalanceResponse } from "./types";
import getConfig from "../../config";

const ADJUST_POINTS_BALANCE_MUTATION = `
  mutation AdjustPointsBalance($input: AdjustPointsBalanceInput!) {
    adjustPointsBalance(input: $input) {
      success
    }
  }
`;

const adjustPointsBalance = async (
  customerId: string,
  amount: number
): Promise<AdjustPointsBalanceResponse> => {
  const { perkUpAPI } = getConfig();
  
  try {
    const response = await fetch(`${perkUpAPI}/graphql`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        query: ADJUST_POINTS_BALANCE_MUTATION,
        variables: {
          input: {
            customerId,
            amount
          }
        }
      })
    });

    const data = await response.json();
    
    if (data.errors) {
      console.error('Error adjusting points balance:', data.errors);
      throw new Error('Error adjusting points balance');
    }
  
    return data.data.adjustPointsBalance;
  } catch (error) {
    console.error('Error adjusting points balance:', error);
    throw new Error('Error adjusting points balance');
  }
};

export { adjustPointsBalance }; 