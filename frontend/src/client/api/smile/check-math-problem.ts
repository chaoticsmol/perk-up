import { MathProblemResponse } from "./types";
import getConfig from "../../config";

type Operator = 'div' | 'mult' | 'add' | 'sub';

const CHECK_MATH_PROBLEM_MUTATION = `
  mutation CheckMathProblem($input: CheckMathProblemInput!) {
    checkMathProblem(input: $input) {
      correct
    }
  }
`;

const checkMathProblem = async (
  customerId: string,
  leftValue: number,
  operator: Operator,
  rightValue: number,
  answer: number
): Promise<MathProblemResponse> => {
  const { perkUpAPI } = getConfig();
  
  try {
    const response = await fetch(`${perkUpAPI}/graphql`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        query: CHECK_MATH_PROBLEM_MUTATION,
        variables: {
          input: {
            customerId,
            leftValue,
            operator,
            rightValue,
            answer
          }
        }
      })
    });

    const data = await response.json();
    
    if (data.errors) {
      console.error('Error checking math problem:', data.errors);
      throw new Error('Error checking math problem');
    }
  
    return data.data.checkMathProblem;
  } catch (error) {
    console.error('Error checking math problem:', error);
    throw new Error('Error checking math problem');
  }
};

export { checkMathProblem }; 