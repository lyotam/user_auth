class User < ApplicationRecord
  encryption_key = ENV['ENCRYPT_KEY']
  attr_encrypted :password, key: encryption_key
  attr_encrypted :token, key: encryption_key
  
  validates :first_name, :last_name, :email, :password, presence: true
  validates :email,
  format: { with: /\A(.+)@(.+)\z/, message: "Email invalid" },
            uniqueness: { case_sensitive: false },
            length: { minimum: 4, maximum: 254 } 
end