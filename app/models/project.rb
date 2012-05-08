class Project < ActiveRecord::Base
  has_many :tasks
  attr_accessible :name, :notes
end
