import { useState } from 'react';
import { Customer } from '@/api/smile';
import { adjustPointsBalance } from '@/api/smile/adjust-points-balance';
import './PointsAdjuster.css';

interface PointsAdjusterProps {
  customer: Customer;
}

const PointsAdjuster: React.FC<PointsAdjusterProps> = ({ customer }: PointsAdjusterProps) => {
  const [amount, setAmount] = useState<string>('');
  const [isSuccess, setIsSuccess] = useState<boolean | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!amount || isNaN(Number(amount))) {
      return;
    }
    
    setIsLoading(true);
    setIsSuccess(null);
    
    try {
      const result = await adjustPointsBalance(customer.id, Number(amount));
      setIsSuccess(result.success);
    } catch (error) {
      setIsSuccess(false);
      console.error('Failed to adjust points balance:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleAmountChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;
    if (!isNaN(Number(value))) {
      setAmount(value);
    }
    setIsSuccess(null);
  };

  return (
    <div className="points-adjuster">
      <h3>Adjust Points Balance</h3>
      <p>Add points to this customer's balance or remove points by entering a negative number.</p>
      
      <form onSubmit={handleSubmit}>
        <input
          type="number"
          value={amount}
          onChange={handleAmountChange}
          placeholder="Enter amount (use negative to deduct)"
          className="points-input"
        />
        <button 
          type="submit" 
          disabled={isLoading || !amount}
          className="submit-button"
        >
          {isLoading ? 'Processing...' : 'Update Balance'}
        </button>
      </form>
      
      {isSuccess !== null && (
        <div className={`result ${isSuccess ? 'success' : 'error'}`}>
          {isSuccess 
            ? `Successfully ${Number(amount) >= 0 ? 'added' : 'removed'} ${Math.abs(Number(amount))} points`
            : 'Failed to adjust points balance'}
        </div>
      )}
    </div>
  );
};

export default PointsAdjuster; 