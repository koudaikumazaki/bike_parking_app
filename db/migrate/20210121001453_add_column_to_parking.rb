class AddColumnToParking < ActiveRecord::Migration[6.1]
  def change
    add_column :parkings, :fee, :integer
    add_column :parkings, :capacity, :integer
    add_column :parkings, :others, :text
  end
end
