class TokenBlackList < ApplicationRecord
  validates :jti, presence: true
  validates :exp, presence: true
end
