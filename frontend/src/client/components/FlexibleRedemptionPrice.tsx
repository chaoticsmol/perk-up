import React, { useState } from 'react';
import { PointsProduct } from '@/api/smile';
import './FlexibleRedemptionPrice.css';

interface FlexibleRedemptionPriceProps {
  product: PointsProduct;
  setPrice: (price: number) => void;
}

const FlexibleRedemptionPrice: React.FC<FlexibleRedemptionPriceProps> = ({ product, setPrice }) => {
  const [increment, setIncrement] = useState(0);

  const spend = () => product.variablePointsMin + increment * product.variablePointsStep;

  const handleDecrease = () => {
    if (increment > 0) {
      setIncrement(increment - 1);
      setPrice(spend());
    }
  };

  const handleIncrease = () => {
    if (spend() < product.variablePointsMax) {
      setIncrement(increment + 1);
      setPrice(spend());
    }
  };

  return (
    <div className="flexible-redemption-price">
      <button
        onClick={handleDecrease}
        disabled={increment <= 1}
      >
        -
      </button>
      <span>{spend()} points</span>
      <button
        onClick={handleIncrease}
        disabled={spend() >= product.variablePointsMax}
      >
        +
      </button>
    </div>
  );
};

export default FlexibleRedemptionPrice;
