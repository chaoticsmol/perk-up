interface SmileCredentials {
  channel_key: string;
  customer_identity_jwt: string;
  [key: string]: any;
}

interface SmileUI {
  init: (credentials: SmileCredentials) => void;
  openPanel: () => void;
  closePanel: () => void;
  on: (eventName: string, callback: (data?: any) => void) => void;
  // Add other SmileUI methods as needed
}

interface Window {
  SmileUI: SmileUI;
}