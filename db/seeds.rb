# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create Categories
categories = [
  { name: 'Vegetarian' },
  { name: 'Non-Vegetarian' },
  { name: 'Paneer' }
]

categories.each do |category|
  Category.create!(name: category[:name])
end

# Create Pizzas
veg_category = Category.find_by(name: 'Vegetarian')
non_veg_category = Category.find_by(name: 'Non-Vegetarian')
paneer_category = Category.find_by(name: 'Paneer')
pizzas = [
  { name: 'Deluxe Veggie', category_id: veg_category.id, prices: { regular: 150, medium: 200, large: 325 } },
  { name: 'Cheese and Corn', category_id: veg_category.id, prices: { regular: 175, medium: 375, large: 475 } },
  { name: 'Paneer Tikka', category_id: veg_category.id, prices: { regular: 160, medium: 290, large: 340 } },
  { name: 'Non-Veg Supreme', category_id: non_veg_category.id, prices: { regular: 190, medium: 325, large: 425 } },
  { name: 'Chicken Tikka', category_id: non_veg_category.id, prices: { regular: 210, medium: 370, large: 500 } },
  { name: 'Pepper Barbecue Chicken', category_id: non_veg_category.id,
    prices: { regular: 220, medium: 380, large: 525 } }
]

pizzas.each do |pizza|
  Pizza.create!(
    name: pizza[:name],
    category_id: pizza[:category_id],
    price_regular: pizza[:prices][:regular],
    price_medium: pizza[:prices][:medium],
    price_large: pizza[:prices][:large]
  )
end

puts '✅ Pizzas added!'

# Create Crusts
crusts = ['New Hand Tossed', 'Wheat Thin Crust', 'Cheese Burst', 'Fresh Pan Pizza']

crusts.each do |crust|
  Crust.create!(name: crust)
end

puts '✅ Crusts added!'

# Create Toppings
toppings = [
  { name: 'Black Olive', category_id: veg_category.id, price: 20 },
  { name: 'Capsicum', category_id: veg_category.id, price: 25 },
  { name: 'Paneer', category_id: paneer_category.id, price: 35 },
  { name: 'Mushroom', category_id: veg_category.id, price: 30 },
  { name: 'Fresh Tomato', category_id: veg_category.id, price: 10 },
  { name: 'Chicken Tikka', category_id: non_veg_category.id, price: 35 },
  { name: 'Barbeque Chicken', category_id: non_veg_category.id, price: 45 },
  { name: 'Grilled Chicken', category_id: non_veg_category.id, price: 40 },
  { name: 'Extra Cheese', category_id: non_veg_category.id, price: 35 }
]

toppings.each do |topping|
  Topping.create!(name: topping[:name], category_id: topping[:category_id], price: topping[:price])
end

puts '✅ Toppings added!'

# Create Sides
sides = [
  { name: 'Cold Drink', price: 55 },
  { name: 'Mousse Cake', price: 90 }
]

sides.each do |side|
  Side.create!(name: side[:name], price: side[:price])
end

puts '✅ Sides added!'
