class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :genre
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
