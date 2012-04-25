class User < ActiveRecord::Base
  has_many :tasks
  attr_accessible :admin, :email, :name, :password_digest
  has_secure_password
end
