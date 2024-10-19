class CommodityController < ApplicationController
  def register
    ActiveRecord::Base.transaction do
      commodity = Commodity.new(commodity_params)
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

  private

  def commodity_params
    {
      name: params[:name],
      price: params[:price],
      introduction: params[:introduction],
      business_id: params[:business_id]
    }
  end
end
