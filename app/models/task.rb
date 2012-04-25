class Task < ActiveRecord::Base
  belongs_to :user
  attr_accessible :hours, :notes, :performed_on, :project_name, :task_name
end
