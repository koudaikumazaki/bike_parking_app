class CreateParkings < ActiveRecord::Migration[6.1]
  def change
    create_table :parkings do |t|
      t.text :name
      t.text :address
      t.timestamps
      t.references :user, foreign_key: true
    end
  end
end
