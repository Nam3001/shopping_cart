FactoryBot.define do
  factory :product do
    product_name { 'Sample Product' }
    price { 10.99 }
    quantity { 100 }
    unit
    thumbnail { 
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec/fixtures/files/valid_image.png'), 
        'image/png'
      )
    }
  end
end