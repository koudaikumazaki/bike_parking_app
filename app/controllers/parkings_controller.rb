class ParkingsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :destroy, :update, :search, :favorites]
  before_action :permit_update_delete, only: [:edit, :destroy, :update]
  before_action :permit_show, only: [:show]

  # FIXME: parkingメソッドにまとめる。インスタンス変数使わない。
  def index
    @parkings = Parking.approval.paginate(params).order("updated_at DESC")
  end

  def new
    @parking = Parking.new
  end

  def create
    @parking = Parking.new(parking_params)
    @parking.user_id = current_user.id

    if @parking.save
      # 改行コード使えば良いのでは？？
      flash[:notice] = "「#{@parking.name}」の情報が投稿されました!"
      flash[:notice] = "管理者に承認されるまでは表示されません。承認されるまでに編集・削除を行う場合にはユーザー情報の、投稿した駐輪場から操作をお願いいたします。"
      redirect_to root_path
    else
      render '/parkings/new'
    end
  end

  def show
    gon.latitude = @parking.latitude
    gon.longitude = @parking.longitude
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
    @parkings = current_user.favorite_parkings
    @parkings = @parkings.approval.paginate(params).order("updated_at DESC")
  end

  # FIXME: クエリビルダーに切り出す。
  def search
    results = Geocoder.search(params[:location])
    if results.empty?
      flash[:notice] = "検索フォームに文字が入っていないか、位置情報を取得できる値でない可能性があります。"
      redirect_to root_path
    else
      selection = params[:keyword]
      latitude = results.first.coordinates[0]
      longitude = results.first.coordinates[1]
      parkings = Parking.approval.within_box(1, latitude, longitude)
      case selection
      when 'near'
        @parkings = Parking.approval.near(results.first.coordinates, 1).paginate(params)
      when 'inexpensive'
        @parkings = parkings.order(price: :asc).paginate(params)
      when 'capacity'
        @parkings = parkings.order(capacity: :desc).paginate(params)
      else
        @parkings = parkings.paginate(params)
      end
    end
  end

  private
  # 横に並べない。
  def parking_params
    params.require(:parking).permit(:name, :address, :fee, :time, :capacity, :others, :image, :image_cache, :latitude, :longitude, :price, :approval)
  end

  def permit_update_delete
    parking = Parking.find(params[:id])
    unless parking.user_id == current_user.id
      flash[:notice] = "投稿者以外の編集・削除はできません。"
      redirect_to root_path
    end
  end

  def permit_show
    @parking = Parking.find(params[:id])
    unless user_signed_in? && @parking.user_id == current_user.id || @parking.approval == true
      flash[:notice] = '投稿が未承認のため、閲覧できません。'
      redirect_to root_path
    end
  end
end
