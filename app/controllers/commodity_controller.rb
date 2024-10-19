class CommodityController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[register update_by_id delete_by_id find_by_id]
  def register
    ActiveRecord::Base.transaction do
      commodity = Commodity.new(commodity_params_register)
      commodity.score = 10
      commodity.homepage = '/path/to/default/homepage.html'
      if commodity.save
        render json: {
          id: commodity.id,
          score: 10,
          homepage: '/path/to/default/homepage.html'
        }, status: :created
      else
        render json: {
          errors: commodity.errors.full_messages.to_s
        }, status: :bad_request
      end
    end
  end

  def find_by_id
    commodity = Commodity.find_by(id: params[:id])
    if commodity
      render json: {
        id: commodity.id,
        name: commodity.name,
        price: commodity.price,
        score: commodity.score,
        introduction: commodity.introduction,
        business_id: commodity.business_id,
        homepage: commodity.homepage
      }, status: :ok
    else
      render json: {
        errors: 'Commodity not found'
      }, status: :not_found
    end
  end

  def delete_by_id
    commodity = Commodity.find_by(id: params[:id])
    if commodity
      commodity.destroy
      render json: {
        message: 'Commodity deleted'
      }, status: :ok
    else
      render json: {
        errors: 'Commodity not found'
      }, status: :not_found
    end
  end

  def update_by_id
    commodity = Commodity.find_by(id: params[:id]) # params是整体的传参hash
    if commodity
      commodity.update(commodity_params_update)
      render json: {
        message: 'Commodity updated'
      }, status: :ok
    else
      render json: {
        errors: 'Commodity not found'
      }, status: :not_found
    end
  end

  private # 定义不同的方法来过滤参数

  def commodity_params_register
    params.permit(:name, :price, :introduction, :business_id)
  end

  def commodity_params_update
    params.permit(:name, :price, :introduction)
  end
end
