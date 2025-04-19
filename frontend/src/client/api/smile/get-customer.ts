import getConfig from '../../config';
import { Customer } from './types';

const CUSTOMER_QUERY = `
  query GetCustomer($id: ID!) {
    customer(id: $id) {
      id
      firstName
      lastName
      email
      dateOfBirth
      pointsBalance
      referralUrl
      state
      vipTierId
      createdAt
      updatedAt
    }
  }
`;

export async function getCustomer(id: string): Promise<Customer> {
  const { perkUpAPI } = getConfig();
  const response = await fetch(`${perkUpAPI}/graphql`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      query: CUSTOMER_QUERY,
      variables: { id },
    }),
  });

  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }

  const { data, errors } = await response.json();

  if (errors) {
    throw new Error(errors[0].message);
  }

  return data.customer;
}
