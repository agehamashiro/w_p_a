class User < ApplicationRecord
  has_secure_password validations: false

  has_many :reviews, dependent: :destroy  # 追加

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, if: -> { password_digest.blank? }
end