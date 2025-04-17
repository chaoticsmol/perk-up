import { useState, useEffect } from "react";
import { getPointsProducts } from "@/api/smile";
import PointsProduct from "./PointsProduct";
import "./PointsProductsList.css";

const PointsProductsList = () => {
  const [products, setProducts] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getPointsProducts().then((pointsProducts) => {
      setProducts(pointsProducts);
      setLoading(false);
    });
  }, []);

  if (loading) {
    return <div>Loading rewards...</div>;
  }

  return (
    <div className="points-products-list">
      {products.length === 0 ? (
        <p className="no-products">No rewards available at this time.</p>
      ) : (
        <div className="products-grid">
          {products.map((product) => (
            <PointsProduct key={product.id} product={product} />
          ))}
        </div>
      )}
    </div>
  );
};

export default PointsProductsList; 