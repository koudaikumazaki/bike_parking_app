class AddColumnToParking < ActiveRecord::Migration[6.1]
  def change
    add_column :parkings, :fee, :string
    add_column :parkings, :capacity, :string
    add_column :parkings, :others, :text
  end
end
