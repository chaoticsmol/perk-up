import React, { useState } from 'react';
import { PointsProduct as PointsProductType, type Reward } from '@/api/smile';
import { purchasePointsProduct } from '@/api/smile/purchase-points-product';
import getConfig from "@/config";
import './ConfirmRedemption.css';
import FlexibleRedemptionPrice from './FlexibleRedemptionPrice';

interface ConfirmRedemptionProps {
  product: PointsProductType;
  onConfirm: (reward: Reward) => void;
  onCancel: () => void;
}

const ConfirmRedemption: React.FC<ConfirmRedemptionProps> = ({ 
  product, 
  onConfirm, 
  onCancel 
}) => {
  const [isProcessing, setIsProcessing] = useState(false);
  const [price, setPrice] = useState(product.exchangeType === "fixed" ? product.pointsPrice : product.variablePointsMin);
  const { user_id } = getConfig();

  const handleConfirm = () => {
    setIsProcessing(true);
    // Make API call to purchase the points product
    purchasePointsProduct(product.id, user_id, price)
      .then((reward) => {
        setIsProcessing(false);
        onConfirm(reward);
      })
      .catch((error) => {
        console.error('Error purchasing product:', error);
        setIsProcessing(false);
      });
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
          {product.exchangeType === "fixed" && (
            <p className="redemption-price">{product.pointsPrice} points</p>
          )}
          {product.exchangeType === "variable" && (
            <FlexibleRedemptionPrice product={product} setPrice={setPrice} />
          )}
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