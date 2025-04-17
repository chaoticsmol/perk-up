import { useState, useEffect } from "react";
import { Customer, getCustomer } from "@/api/smile";
import "./CustomerInfo.css";

interface CustomerInfoProps {
  customer_id: string;
}

const CustomerInfo = ({ customer_id }: CustomerInfoProps) => {
  const [customer, setCustomer] = useState<Customer | null>(null);

  useEffect(() => {
    getCustomer(customer_id).then((customer: Customer) => {
      setCustomer(customer);
    });
  }, [customer_id]);

  if (!customer) {
    return <div>Loading customer info...</div>;
  }

  const name = customer.firstName ? customer.firstName : customer.email;

  return (
    <div className="customer-info">
      <p className="customer-greeting">
        <strong>Hey {name}!</strong>
      </p>
      <p className="customer-points">
        You have earned <strong>{customer.pointsBalance}</strong> points.
      </p>
    </div>
  );
};

export default CustomerInfo;