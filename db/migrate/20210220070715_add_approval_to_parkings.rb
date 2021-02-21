class AddApprovalToParkings < ActiveRecord::Migration[6.1]
  def change
    add_column :parkings, :approval, :integer
  end
end
