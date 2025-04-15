Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # GraphQL endpoint
  post "/graphql", to: "graphql#execute"

  # Define your API routes below
  # namespace :api do
  #   namespace :v1 do
  #     resources :your_resources
  #   end
  # end
end
