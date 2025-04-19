import { useState } from "react";
import "./PointsProduct.css";
import { PointsProduct as PointsProductType, type Reward } from "@/api/smile";
import Popup from "./Popup";
import ConfirmRedemption from "./ConfirmRedemption";

interface PointsProductProps {
  product: PointsProductType;
}

const PointsProduct = ({ product }: PointsProductProps) => {
  const [showPopup, setShowPopup] = useState(false);
  const [redeemed, setRedeemed] = useState(false);
  const [redeemedReward, setRedeemedReward] = useState<Reward | null>(null);

  const handleRedeem = () => {
    setShowPopup(true);
  };

  const handleConfirm = (reward: Reward) => {
    setRedeemedReward(reward);
    setRedeemed(true);
    setShowPopup(false);
  };

  const handleCancel = () => {
    setShowPopup(false);
  };

  return (
    <>
      <div className="points-product">
        {product.reward.imageUrl && (
          <div className="product-image-container">
            <img src={product.reward.imageUrl} alt={product.reward.name} className="product-image" />
          </div>
        )}
        <div className="product-info">
          <h3 className="product-name">{product.reward.name}</h3>
          {product.reward.description && <p className="product-description">{product.reward.description}</p>}
          {redeemed && redeemedReward?.code && (
            <div className="reward-code-container">
              <p className="reward-code-label">Your redemption code:</p>
              <p className="reward-code">{redeemedReward.code}</p>
            </div>
          )}
          <div className="product-price">
            {product.exchangeType === "fixed" && (
              <>
                <span className="price-label">Price:</span>
                <span className="price-value">{product.pointsPrice}</span>
                <span className="price-label">points</span>
              </>
            )}
            {product.exchangeType === "variable" && (
              <>
                <span className="price-label">Price:</span>
                <span className="price-value">flex</span>
              </>
            )}
          </div>
          <button 
            className={`redeem-button ${redeemed ? "redeemed" : ""}`} 
            onClick={handleRedeem}
            disabled={redeemed}
          >
            {redeemed ? "Redeemed!" : "Redeem"}
          </button>
        </div>
      </div>

      <Popup isOpen={showPopup} onClose={handleCancel}>
        <ConfirmRedemption 
          product={product} 
          onConfirm={handleConfirm} 
          onCancel={handleCancel} 
        />
      </Popup>
    </>
  );
};

export default PointsProduct; 