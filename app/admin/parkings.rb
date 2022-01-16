ActiveAdmin.register Parking do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :address, :user_id, :fee, :capacity, :others, :image, :latitude, :longitude, :time, :price, :approval
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :address, :user_id, :fee, :capacity, :others, :image, :latitude, :longitude, :time, :price]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  index do
    selectable_column
    column(:id)
    column(:name)
    column(:user_id)
    column(:approval)
    actions
  end

  filter :approval
  filter :id
  filter :user_id
end
