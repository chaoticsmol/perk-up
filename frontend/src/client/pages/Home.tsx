import { useState, useEffect } from "react";
import useSmile from "../hooks/use-smile";
import getConfig from "../config";
import CustomerInfo from "../components/CustomerInfo";
import PointsProductsList from "../components/PointsProductsList";
import "./Home.css";

function Home() {
  const { isSmileReady } = useSmile();
  const { user_id } = getConfig();

  if (!isSmileReady) {
    return <div className="loading-container">Please wait while we prepare your rewards...</div>;
  }

  return (
    <div className="home-container">
      <div className="home-columns">
        <div className="column left-column">
          <CustomerInfo customer_id={user_id} />
        </div>
        <div className="column right-column">
          <PointsProductsList />
        </div>
      </div>
    </div>
  );
}

export default Home; 
