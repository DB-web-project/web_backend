class BusinessController < ApplicationController
  def register
    ActiveRecord::Base.transaction do
      business = Business.new(business_params)
      if business.save
        preference = Preference.create(preferable: business) # 选择外键为business
        tag = Tag.create
        business.update(preference: preference, avator: '/path/to/default/avator.jpg', tag: tag)
        render json: {
          id: business.id,
          tag: business.tag.id,
          score: 10,
          preference: business.preference.id,
          avator: business.avator
        }, status: :created
      else
        render json: {
          errors: business.errors.full_messages.to_s
        }, status: :bad_request
      end
    end
  end

  private

  def business_params
    {
      name: params[:name],
      email: params[:email],
      password: params[:password]
    }
  end
end
