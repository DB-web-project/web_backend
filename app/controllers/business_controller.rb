class BusinessController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[register login]

  def register
    ActiveRecord::Base.transaction do
      business = Business.new(business_params)
      if business.save
        preference = Preference.create(preferable: business) # 选择外键为business
        tag = Tag.create
        business.update(preference: preference, avator: '/path/to/default/avator.jpg', tag: tag, score: 10)
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

  def login
    business = Business.find_by(name: params[:name])
    if business&.authenticate(params[:password])
      preference = Preference.find_by(preferable: business)
      tag = Tag.find_by(business: business)
      render json: {
        id: business.id,
        tag: extract_tags(tag),
        score: business.score,
        email: business.email,
        preference: extract_preferences(preference),
        avator: business.avator
      }, status: :ok
    else
      render json: {
        errors: 'Invalid email or password'
      }, status: :not_found
    end
  end

  def find_by_id
    business = Business.find_by(id: params[:id])
    if business
      preference = Preference.find_by(preferable: business)
      tag = Tag.find_by(business: business)
      render json: {
        id: business.id,
        name: business.name,
        email: business.email,
        tag: extract_tags(tag),
        score: business.score,
        preference: extract_preferences(preference),
        avator: business.avator
      }, status: :ok
    else
      render json: {
        errors: 'Business not found'
      }, status: :not_found
    end
  end

  def delete_by_id
    business = Business.find_by(id: params[:id])
    if business
      business.destroy
      render json: {
        message: 'Business deleted successfully'
      }, status: :ok
    else
      render json: {
        errors: 'Business not found'
      }, status: :not_found
    end
  end

  private

  def extract_preferences(preference)
    if preference
      [preference.preference1, preference.preference2, preference.preference3, preference.preference4,
       preference.preference5].compact
    else
      []
    end
  end

  def extract_tags(tag)
    if tag
      [tag.tag1, tag.tag2, tag.tag3, tag.tag4, tag.tag5].compact
    else
      []
    end
  end

  def business_params
    {
      name: params[:name],
      email: params[:email],
      password: params[:password]
    }
  end
end
