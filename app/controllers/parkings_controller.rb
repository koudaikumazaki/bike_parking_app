class ParkingsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :destroy, :update, :search, :favorites]
  before_action :permit_update_delete, only: [:edit, :destroy, :update]
  before_action :permit_show, only: :show
  before_action :parking, only: [:new, :create, :show, :edit, :update, :destroy]
  before_action :favorite_parkings, only: :favorites

  def index
    @parkings = Parking.approval.paginate(params).order("updated_at DESC")
  end

  def new; end

  def create
    if form.save
      flash[:notice] = "管理者に承認されるまでは表示されません。承認されるまでに編集・削除を行う場合にはユーザー情報の、投稿した駐輪場から操作をお願いいたします。"
      redirect_to root_path
    else
      render '/parkings/new'
    end
  end

  def show
    gon.latitude = parking.latitude
    gon.longitude = parking.longitude
  end

  def edit; end

  def update
    if form.save
      flash[:notice] = "「#{parking.name}」の情報が更新されました!"
      redirect_to root_path
    else
      render "/parkings/edit"
    end
  end

  def destroy
    parking.delete
    flash[:notice] = "「#{parking.name}」の情報を削除しました!"
    redirect_to root_path
  end

  def favorites; end

  def search
    results ||= parking_query.search
    if results.empty?
      flash[:notice] = "検索結果が見つかりませんでした。"
      redirect_to root_path
    else
      @parkings ||= results.paginate(params).order("updated_at DESC")
    end
  end

  private

  def form
    @form ||= ::Parkings::Form.new(parking, current_user.id, form_params)
  end

  def parking_query
    @parking_query ||= ::Parkings::QueryBuilder.new(search_params)
  end

  def search_params
    params.permit(::Parkings::QueryBuilder::SEARCH_PARAMS)
  end

  def form_params
    params.require(:parking).permit(
      :name,
      :address,
      :fee,
      :time,
      :capacity,
      :others,
      :image,
      :image_cache,
      :latitude,
      :longitude,
      :fee_per_hour,
      :approval
    )
  end

  def parking
    @parking ||= Parking.find_or_initialize_by(id: params[:id])
  end

  def favorite_parkings
    @favorite_parkings ||= current_user.favorite_parkings
                                       .approval
                                       .paginate(params)
                                       .order("updated_at DESC")
  end

  def permit_update_delete
    unless posted_parking?
      flash[:notice] = "投稿者以外の編集・削除はできません。"
      redirect_to root_path
    end
  end

  def permit_show
    unless user_signed_in? && posted_parking? || parking.approval == true
      flash[:notice] = '投稿が未承認のため、閲覧できません。'
      redirect_to root_path
    end
  end

  def posted_parking?
    parking.user_id == current_user.id
  end
end
