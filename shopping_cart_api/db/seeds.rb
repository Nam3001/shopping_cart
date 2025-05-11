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
unit = Unit.create!(unit_name: 'Chiếc')
category = Category.create!(name: 'Đồ điện tử')
prod = Product.create!(product_name: 'Gao', thumbnail: File.open(Rails.root.join('spec', 'fixtures', 'files', 'valid_image.png')), quantity: 100, price: 20000, unit:, category:)
od = Order.create!(status: 0, user: user)
OrderItem.create!(order: od, product: prod, quantity: 2, price: 20000, promotion: 0)
CartItem.create!(user: user, product: prod, quantity: 2)