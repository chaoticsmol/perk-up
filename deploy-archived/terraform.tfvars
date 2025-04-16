# Common variables
app_name    = "perk-up"
environment = "dev"
region      = "ca-central-1"

# EC2 configuration
ec2_instance_type = "t2.micro"
ec2_key_name      = "perk-up-dev"

# Database configuration
db_instance_class    = "db.t3.micro"
db_name              = "perkup_production"
db_username          = "perkupuser"
db_password          = "s00p3rs3cure!0" # Replace with a secure password in production
db_allocated_storage = 20

# Repository configuration
repo_url = "https://github.com/chaoticsmol/perk-up.git"

# Rails configuration
rails_master_key = "3d433627e4d2d806a3eed5d0031edbb5" # Uncomment and fill before running terraform apply
