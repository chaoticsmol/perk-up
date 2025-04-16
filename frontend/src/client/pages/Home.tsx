import useSmile from "../hooks/use-smile";

function Home() {
  const { isSmileReady } = useSmile();

  return (
    <div className="home-container">
      <h1>Welcome to Perk Up!</h1>
      <p>Do cool things and earn rewards!</p>
      { isSmileReady && (
        <p>Smile is ready</p>
      )}
    </div>
  );
}

export default Home; 
