class AddColumnToParkings < ActiveRecord::Migration[6.1]
  def change
    add_column :parkings, :price, :integer
  end
end
