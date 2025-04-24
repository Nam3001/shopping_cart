FactoryBot.define do
  factory :user do
    username { 'namnguyen' }
    address { 'tp Hue' }
    email_address { 'nam2@gmail.com' }
    password { '123456' }
    fullname { 'Nguyen Van Nam' }
    role { :user }

    trait :admin? do 
      role { :admin }
    end
  end
end