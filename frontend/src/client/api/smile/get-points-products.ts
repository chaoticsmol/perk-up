import getConfig from '../../config';
import { PointsProduct } from './types';

const POINTS_PRODUCTS_QUERY = `
  query GetPointsProducts {
    pointsProducts {
      id
      exchangeType
      exchangeDescription
      pointsPrice
      variablePointsStep
      variablePointsStepRewardValue
      variablePointsMax
      variablePointsMin
      reward {
        id
        name
        description
        imageUrl
      }
    }
  }
`;

export async function getPointsProducts(): Promise<PointsProduct[]> {
  const { perkUpAPI } = getConfig();
  const response = await fetch(`${perkUpAPI}/graphql`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      query: POINTS_PRODUCTS_QUERY,
    }),
  });

  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }

  const { data, errors } = await response.json();

  if (errors) {
    throw new Error(errors[0].message);
  }

  return data.pointsProducts;
}
