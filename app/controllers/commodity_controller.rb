class CommodityController < ApplicationController
  def register
    ActiveRecord::Base.transaction do
      commodity = Commodity.new(commodity_params)
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
