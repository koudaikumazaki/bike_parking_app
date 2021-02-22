class AddApprovalToParkings < ActiveRecord::Migration[6.1]
  def change
    add_column :parkings, :approval, :boolean, default: false
  end
end
