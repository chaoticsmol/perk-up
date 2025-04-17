import useSmile from "../hooks/use-smile";

function Home() {
  const { isSmileReady } = useSmile();

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
