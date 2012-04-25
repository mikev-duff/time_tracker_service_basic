class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :project_name
      t.string :task_name
      t.date :performed_on
      t.float :hours
      t.text :notes
      t.references :user

      t.timestamps
    end
    add_index :tasks, :user_id
  end
end
