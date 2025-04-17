import useSmile from "../hooks/use-smile";
import getConfig from "../../config";
import { getCustomer } from "../api/smile";

function Home() {
  const { isSmileReady } = useSmile();
  const { user_id } = getConfig();

  if (isSmileReady) {
    getCustomer(user_id).then((customer) => {
      console.log(customer);
    });
  }

  return (
    <div className="home-container">
      { isSmileReady ? (
        <p>Smile is ready</p>
      ) : (
        <p>Please wait while we prepare your rewards...</p>
      ) }
    </div>
  );
}

export default Home; 
