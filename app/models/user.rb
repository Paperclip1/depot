
  require 'digest'

class User < ActiveRecord::Base
   attr_accessible :email, :hashed_password, :password
   attr_accessor :password
   before_save :encrypt_password
   has_many :products

   def self.authenticate(email, password)
     user = find_by_email(email)
     return user if user && user.authenticated?(password)
   end
   def authenticated?(password)
     self.hashed_password == encrypt(password)
   end

   protected
    def encrypt_password
      return if password.blank?
      self.hashed_password = encrypt(password)
    end
    def encrypt(string)
      Digest::SHA1.hexdigest(string)
    end
  end
