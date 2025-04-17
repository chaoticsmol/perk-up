import React, { useState } from 'react';
import { PointsProduct as PointsProductType } from '@/api/smile';
import './ConfirmRedemption.css';

interface ConfirmRedemptionProps {
  product: PointsProductType;
  onConfirm: () => void;
  onCancel: () => void;
}

const ConfirmRedemption: React.FC<ConfirmRedemptionProps> = ({ 
  product, 
  onConfirm, 
  onCancel 
}) => {
  const [isProcessing, setIsProcessing] = useState(false);

  const handleConfirm = () => {
    setIsProcessing(true);
    // Simulate API call
    setTimeout(() => {
      setIsProcessing(false);
      onConfirm();
    }, 1500);
  };

  return (
    <div className="confirm-redemption">
      <h2 className="redemption-title">Confirm Redemption</h2>
      
      <div className="redemption-product-info">
        <img 
          src={product.reward.imageUrl || '/default-reward.png'} 
          alt={product.reward.name} 
          className="redemption-product-image" 
        />
        <div className="redemption-details">
          <h3>{product.reward.name}</h3>
          <p className="redemption-price">{product.pointsPrice} points</p>
        </div>
      </div>
      
      <div className="redemption-description">
        <p>{product.reward.description || 'Are you sure you want to redeem this reward?'}</p>
      </div>
      
      <div className="redemption-actions">
        <button 
          className="redemption-cancel" 
          onClick={onCancel}
          disabled={isProcessing}
        >
          Cancel
        </button>
        <button 
          className="redemption-confirm" 
          onClick={handleConfirm}
          disabled={isProcessing}
        >
          {isProcessing ? 'Processing...' : 'Confirm Redemption'}
        </button>
      </div>
    </div>
  );
};

export default ConfirmRedemption; 