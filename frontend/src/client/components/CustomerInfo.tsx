import { Customer } from "@/api/smile";
import "./CustomerInfo.css";

interface CustomerInfoProps {
  customer: Customer;
}

const CustomerInfo = ({ customer }: CustomerInfoProps) => {
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