# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create!(username: 'Nam3001', password: '123456', address: 'hue', email_address: 'nam@gmail.com', fullname: 'Nguyen Van Nam', role: 0)
unit = Unit.create!(unit_name: 'kg', unit_description: 'kilogram')
prod = Product.create!(product_name: 'Gao', thumbnail: 'https://example.com/thumbnail.jpg', quantity: 100, price: 20000, unit: unit)
od = Order.create!(status: 0, user: user)
OrderItem.create!(order: od, product: prod, quantity: 2, price: 20000, promotion: 0)
CartItem.create!(user: user, product: prod, quantity: 2)