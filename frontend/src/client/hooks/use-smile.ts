import { useEffect, useState } from "react";
import { defaultCredentials, Credentials } from "../utils/credentials";

export type Smile = {
  isSmileReady: boolean;
};

const useSmile = (credentials: Credentials = defaultCredentials): Smile => {
  const [isSmileReady, setIsSmileReady] = useState(false);

  useEffect(() => {
    let cleanup: (() => void) | null = null;

    const setupSmileUI = () => {
      window.SmileUI.init({
        channel_key: credentials.smile.channel_key,
        customer_identity_jwt: credentials.smile.customer_identity_jwt
      });
      setIsSmileReady(true);
    };

    const initializeSmile = () => {
      const handleSmileUILoaded = () => {
        if (window.SmileUI) {
          setupSmileUI();
        }
      };

      handleSmileUILoaded();

      document.addEventListener('smile-ui-loaded', handleSmileUILoaded);

      cleanup = () => {
        document.removeEventListener('smile-ui-loaded', handleSmileUILoaded);
      };
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