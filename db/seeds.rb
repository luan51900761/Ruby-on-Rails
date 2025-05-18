# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# Clear existing data to prevent duplication
puts "Clearing existing data..."
Purchase.destroy_all
Asset.destroy_all
Creator.destroy_all
Customer.destroy_all
User.destroy_all

# Create Users with different roles
puts "Creating users..."
admin = User.create!(
  email: 'admin@example.com',
  password: 'password',
  name: 'Admin User',
  role: 'admin'
)

# Create creator users
creator_users = [
  {
    email: 'creator1@example.com',
    password: 'password',
    name: 'John Smith',
    role: 'creator'
  },
  {
    email: 'creator2@example.com',
    password: 'password',
    name: 'Sarah Johnson',
    role: 'creator'
  },
  {
    email: 'creator3@example.com',
    password: 'password',
    name: 'Michael Brown',
    role: 'creator'
  }
]

created_creator_users = creator_users.map { |user_attrs| User.create!(user_attrs) }

# Create customer users
customer_users = [
  {
    email: 'customer1@example.com',
    password: 'password',
    name: 'Emma Wilson',
    role: 'customer'
  },
  {
    email: 'customer2@example.com',
    password: 'password',
    name: 'David Miller',
    role: 'customer'
  },
  {
    email: 'customer3@example.com',
    password: 'password',
    name: 'Olivia Davis',
    role: 'customer'
  }
]

created_customer_users = customer_users.map { |user_attrs| User.create!(user_attrs) }

# Create Creators linked to users
puts "Creating creators..."
creators = created_creator_users.map do |user|
  Creator.create!(
    user_id: user.id
  )
end

# Create Customers linked to users
puts "Creating customers..."
customers = created_customer_users.map do |user|
  Customer.create!(
    user_id: user.id
  )
end

# Create Assets for each creator
puts "Creating assets..."

# Assets for Creator 1
creator1_assets = [
  {
    title: "Abstract Digital Painting",
    description: "A vibrant abstract digital painting suitable for modern interiors",
    file_url: "https://example.com/assets/abstract_painting.jpg",
    price: 45.99
  },
  {
    title: "Minimalist Logo Template",
    description: "Clean and modern logo template for brands",
    file_url: "https://example.com/assets/logo_template.psd",
    price: 29.99
  },
  {
    title: "Watercolor Collection",
    description: "Set of 10 watercolor textures and brushes",
    file_url: "https://example.com/assets/watercolor_collection.zip",
    price: 19.99
  }
]

# Assets for Creator 2
creator2_assets = [
  {
    title: "Marketing Strategy E-book",
    description: "Comprehensive guide to digital marketing in 2023",
    file_url: "https://example.com/assets/marketing_ebook.pdf",
    price: 14.99
  },
  {
    title: "Resume Template Pack",
    description: "Professional resume templates for various industries",
    file_url: "https://example.com/assets/resume_templates.zip",
    price: 9.99
  },
  {
    title: "Business Plan Guide",
    description: "Step-by-step guide to creating effective business plans",
    file_url: "https://example.com/assets/business_plan.pdf",
    price: 24.99
  }
]

# Assets for Creator 3
creator3_assets = [
  {
    title: "Ambient Music Pack",
    description: "Collection of 5 royalty-free ambient tracks",
    file_url: "https://example.com/assets/ambient_pack.zip",
    price: 39.99
  },
  {
    title: "Cinematic Sound Effects",
    description: "50 high-quality sound effects for video production",
    file_url: "https://example.com/assets/sound_effects.wav",
    price: 19.99
  },
  {
    title: "Drum Loops Collection",
    description: "120 BPM drum loops in various styles",
    file_url: "https://example.com/assets/drum_loops.zip",
    price: 15.99
  }
]

# Create the assets and associate them with creators
all_assets = []

creator1_assets.each do |asset_attrs|
  all_assets << Asset.create!(asset_attrs.merge(creator_id: creators[0].id))
end

creator2_assets.each do |asset_attrs|
  all_assets << Asset.create!(asset_attrs.merge(creator_id: creators[1].id))
end

creator3_assets.each do |asset_attrs|
  all_assets << Asset.create!(asset_attrs.merge(creator_id: creators[2].id))
end

# Create Purchases
puts "Creating purchases..."

# Generate purchases for customers
customers.each do |customer|
  # Each customer buys 1-3 random assets
  purchase_count = rand(1..3)
  
  purchase_count.times do
    # Pick a random asset that the customer hasn't purchased yet
    available_assets = all_assets.reject do |asset|
      Purchase.exists?(customer_id: customer.id, asset_id: asset.id)
    end
    
    # If there are still assets available to purchase
    if available_assets.any?
      asset = available_assets.sample
      
      Purchase.create!(
        customer_id: customer.id,
        asset_id: asset.id,
        purchase_date: Time.current - rand(1..30).days
      )
    end
  end
end

# Create some additional purchases to make creators have different earnings
5.times do
  customer = customers.sample
  asset = all_assets.sample
  
  # Skip if this customer already purchased this asset
  next if Purchase.exists?(customer_id: customer.id, asset_id: asset.id)
  
  Purchase.create!(
    customer_id: customer.id,
    asset_id: asset.id,
    purchase_date: Time.current - rand(1..60).days
  )
end

puts "Seed data created successfully!"
puts "Created:"
puts "  - #{User.count} users (#{User.where(role: 'admin').count} admin, #{User.where(role: 'creator').count} creators, #{User.where(role: 'customer').count} customers)"
puts "  - #{Creator.count} creator profiles"
puts "  - #{Customer.count} customer profiles"
puts "  - #{Asset.count} assets"
puts "  - #{Purchase.count} purchases"
puts "\nLogin credentials:"
puts "  Admin:     email: admin@example.com,     password: password"
puts "  Creator:   email: creator1@example.com,  password: password"
puts "  Customer:  email: customer1@example.com, password: password"