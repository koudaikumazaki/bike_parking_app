class FavoritesController < ApplicationController
  # before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_parking, only: [:create, :destroy]

  def create
    @favorite = Favorite.create(user_id: current_user.id, parking_id: @parking.id)
    @favorite.save
  end

  def destroy
    favorite = Favorite.find_by(user_id: current_user.id, parking_id: @parking.id)
    favorite.destroy
  end

  private

  def set_parking
    @parking = Parking.find(params[:parking_id])
  end
end