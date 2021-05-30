class ChangeNullOnCourse < ActiveRecord::Migration[6.1]
  def change
    change_column_null :courses, :instructor_id, false
  end
end
