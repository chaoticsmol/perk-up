export type Configuration = {
  user_id: string;
  user_email: string;
  perkUpAPI: string;
}

const getConfig = (): Configuration => ({
  // Hard-coding these results from window.Smile.fetchCustomer().
  // Per discussion in Slack, I was not able to get `window.Smile` working properly, so I will depend on the API more.
  user_id: '2791121573',
  user_email: 'asher.builds.software@gmail.com',
  perkUpAPI: 'http://localhost:3000',
})

export default getConfig;