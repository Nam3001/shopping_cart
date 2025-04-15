class User < ApplicationRecord
    has_secure_password

    has_many :cart_items, dependent: :restrict_with_exception
    has_many :products, through: :cart_items, source: :product
    has_many :orders, dependent: :restrict_with_exception

    validates :username, presence: true, length: { minimum: 6 }
    validates :password, presence: true, length: { minimum: 6 }
    validates :address, presence: true
    validates :email_address, presence: true, uniqueness: { case_sensitive: true }, format: URI::MailTo::EMAIL_REGEXP
    validates :fullname, presence: true
end
