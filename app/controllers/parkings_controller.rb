class ParkingsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :destroy, :update, :search, :favorites]
  before_action :permit_update_delete, only: [:destroy, :update]

  def index
    @parkings = Parking.page(params[:page]).per(10)
  end

  def new
    @parking = Parking.new
  end

  def create
    @parking = Parking.new(parking_params)
    @parking.user_id = current_user.id

    if @parking.save
      flash[:notice] = "「#{@parking.name}」の情報が投稿されました!"
      redirect_to root_path
    else
      render '/parkings/new'
    end
  end

  def show
    @parking = Parking.find(params[:id])
  end

  def edit
    @parking = Parking.find(params[:id])
  end

  def update
    @parking = Parking.find(params[:id])
    @parking.update(parking_params)
    if @parking.save
      flash[:notice] = "「#{@parking.name}」の情報が更新されました!"
      redirect_to root_path
    else
      render "/parkings/edit"
    end
  end

  def destroy
    parking = Parking.find(params[:id])
    parking.delete
    flash[:notice] = "「#{parking.name}」の情報を削除しました!"
    redirect_to root_path
  end

  def favorites
    @parkings = current_user.favorite_parkings.includes(:user)
    @parkings = @parkings.page(params[:page]).per(10)
  end

  def search
    results = Geocoder.search(search_params)
    if results.empty?
      flash[:notice] = "検索フォームに文字が入っていないか、位置情報を取得できる値でない可能性があります。"
      redirect_to root_path
    else
      @parkings = Parking.near(results.first.coordinates, 1)
    end
  end

  def current_spot_search
    latitude = params[:latitude]
    longitude = params[:longitude]
    @parkings = Parking.near(2, origin: [latitude, longitude])
  end

  private

  def parking_params
    params.require(:parking).permit(:name, :address, :fee, :time, :capacity, :others, :image, :image_cache, :latitude, :longitude)
  end

  def permit_update_delete
    parking = Parking.find(params[:id])
    unless parking.user_id == current_user.id
      flash[:notice] = "投稿者以外の編集・削除はできません。"
      redirect_to root_path
    end
  end

  def search_params
    params.require(:parking).permit(:location)
  end
end
