class AddTimeToParkings < ActiveRecord::Migration[6.1]
  def change
    add_column :parkings, :time, :integer
  end
end
