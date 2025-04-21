import { getCustomer } from './get-customer';
import { getPointsProducts } from './get-points-products';
import { purchasePointsProduct } from './purchase-points-product';
import { checkMathProblem } from './check-math-problem';
import { adjustPointsBalance } from './adjust-points-balance';
import { 
  type Customer, 
  type PointsProduct, 
  type Reward, 
  type MathProblemResponse,
  type AdjustPointsBalanceResponse 
} from './types';

export { 
  getCustomer, 
  getPointsProducts, 
  purchasePointsProduct, 
  checkMathProblem,
  adjustPointsBalance,
  type Customer, 
  type PointsProduct, 
  type Reward,
  type MathProblemResponse,
  type AdjustPointsBalanceResponse
};