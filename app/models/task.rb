class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :hours, :notes, :performed_on, :project_name, :task_name
end
