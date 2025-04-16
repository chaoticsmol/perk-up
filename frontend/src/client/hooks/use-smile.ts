import { useEffect, useState } from "react";
import { defaultCredentials, Credentials } from "../utils/credentials";

export type Smile = {
  isSmileReady: boolean;
};

const useSmile = (credentials: Credentials = defaultCredentials): Smile => {
  const [isSmileReady, setIsSmileReady] = useState(false);

  useEffect(() => {
    let checkSmileLoaded: number | null = null;
    let cleanup: (() => void) | null = null;

    const setupSmileUI = () => {
      // Initialize SmileUI
      window.SmileUI.init({
        channel_key: credentials.smile.channel_key,
        customer_identity_jwt: credentials.smile.customer_identity_jwt
      });
      setIsSmileReady(true);
    };

    const initializeSmile = () => {
      if (window.SmileUI) {
        setupSmileUI();
      } else {
        // If SmileUI is not available yet, wait for it to load
        checkSmileLoaded = window.setInterval(() => {
          if (window.SmileUI) {
            window.clearInterval(checkSmileLoaded!);
            setupSmileUI();
          }
        }, 100);
        
        // Clean up interval if component unmounts before SmileUI loads
        cleanup = () => {
          if (checkSmileLoaded) {
            window.clearInterval(checkSmileLoaded);
          }
        };
      }
    };

    initializeSmile();

    // Return cleanup function if it was created
    return cleanup || undefined;
  }, [credentials]);

  return {
    isSmileReady,
  };
};

export default useSmile;