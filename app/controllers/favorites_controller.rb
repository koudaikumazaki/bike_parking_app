class FavoritesController < ApplicationController
  before_action :parking, only: [:create, :destroy]

  def create
    favorite.save
  end

  def destroy
    favorite.destroy
  end

  private

  def favorite
    @favorite ||= Favorite.find_or_initialize_by(user_id: current_user.id, parking_id: parking.id)
  end

  def parking
    @parking ||= Parking.find_or_initialize_by(params[:parking_id])
  end
end
