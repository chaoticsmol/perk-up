require "jwt"

# asher.builds.software
CUSTOMER_ID = "8176387391720"
EXPIRATION = Time.now.to_i + (60 * 60 * 24 * 21) # 21 days
PRIVATE_KEY = ENV.fetch("SMILE_PRIVATE_KEY", nil)

if PRIVATE_KEY.nil?
  puts "You must provide a SMILE_PRIVATE_KEY environment variable."
  exit(1)
end

payload = {
  customer_identity: {
    distinct_id: CUSTOMER_ID,
  },
  exp: EXPIRATION,
}

signed_jwt = JWT.encode(payload, PRIVATE_KEY, "HS256")

puts signed_jwt
