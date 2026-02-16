class User < ApplicationRecord
  has_secure_password
  # EUMS
  enum :role, {
    admin: "admin",
    reviewer: "reviewer",
    read_only: "read_only"
  }, validate: true

  # VALIDATIONS
  validates :role, presence: true
  # ASSOCIATIONS
  has_many :sessions, dependent: :destroy
  # Email address normalization
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
