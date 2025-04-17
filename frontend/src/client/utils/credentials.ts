export type Credentials = {
  smile: SmileCredentials;
};

export type SmileCredentials = {
  channel_key: string;
  customer_identity_jwt: string;
  user_id: string;
  user_email: string;
};

// Since we do not want to build an entire user service, I will encode the relatively safe credentials here.
export const defaultCredentials: Credentials = {
  smile: {
    // Taken from Smile Admin Settings.
    channel_key: 'channel_0Dv3zyX08OAUYygj0cWEn835',
    // Produced with the `tools/generate_customer_jwt.rb` script.
    // Expires 21 days from 2025-04-16.
    customer_identity_jwt: 'eyJhbGciOiJIUzI1NiJ9.eyJjdXN0b21lcl9pZGVudGl0eSI6eyJkaXN0aW5jdF9pZCI6IjgxNzYzODczOTE3MjAifSwiZXhwIjoxNzQ2NjU2NDkzfQ.ETKDTU33InCWUbBg-4yMcvPG-7IoGvaH5Ugn3-nR82k',

    // Hard-coding these results from window.Smile.fetchCustomer().
    // Per discussion in Slack, I was not able to get `window.Smile` working properly, so I will depend on the API more.
    user_id: '2791121573',
    user_email: 'asher.builds.software@gmail.com'
  },
};
