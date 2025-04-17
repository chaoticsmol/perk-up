import "./PointsProduct.css";
import { PointsProduct as PointsProductType } from "@/api/smile";

interface PointsProductProps {
  product: PointsProductType;
}

const PointsProduct = ({ product }: PointsProductProps) => {
  return (
    <div className="points-product">
      {product.reward.imageUrl && (
        <div className="product-image-container">
          <img src={product.reward.imageUrl} alt={product.name} className="product-image" />
        </div>
      )}
      <div className="product-info">
        <h3 className="product-name">{product.reward.name}</h3>
        {product.reward.description && <p className="product-description">{product.reward.description}</p>}
        <div className="product-price">
          <span className="price-label">Price:</span>
          <span className="price-value">{product.pointsPrice}</span>
          <span className="price-label">points</span>
        </div>
        <button className="redeem-button">Redeem</button>
      </div>
    </div>
  );
};

export default PointsProduct; 