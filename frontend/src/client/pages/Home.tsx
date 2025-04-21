import { useState, useEffect } from "react";
import useSmile from "../hooks/use-smile";
import getConfig from "../config";
import CustomerInfo from "../components/CustomerInfo";
import { Customer, getCustomer } from "@/api/smile";
import PointsProductsList from "../components/PointsProductsList";
import PointsAdjuster from "../components/PointsAdjuster";
import MathProblem from "../components/MathProblem";
import "./Home.css";

function Home() {
  const { isSmileReady } = useSmile();
  const { user_id } = getConfig();
  const [customer, setCustomer] = useState<Customer | null>(null);

  // When we submit an activity, we don't get any information about the customer's balance, or the ID of the
  // points transaction created, so I'm opting to just poll the customer endpoint every second to get the latest balance.
  useEffect(() => {
    const handler = setInterval(() => {
      getCustomer(user_id).then((customer: Customer) => {
        setCustomer(customer);
      });

      return () => clearInterval(handler);
    }, 1000);

    return () => clearInterval(handler);
  }, [user_id]);

  if (!isSmileReady) {
    return <div className="loading-container">Please wait while we prepare your rewards...</div>;
  }

  if (!customer) {
    return <div className="loading-container">Please wait while we load your information...</div>;
  }

  return (
    <div className="home-container">
      <div className="home-columns">
        <div className="column left-column">
          <CustomerInfo customer={customer} />
          <MathProblem customer={customer} />
          <PointsAdjuster customer={customer} />
        </div>
        <div className="column right-column">
          <PointsProductsList />
        </div>
      </div>
    </div>
  );
}

export default Home; 
