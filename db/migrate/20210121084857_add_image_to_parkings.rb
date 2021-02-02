class AddImageToParkings < ActiveRecord::Migration[6.1]
  def change
    add_column :parkings, :image, :string
  end
end
