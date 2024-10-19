class UserController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[register login] # Disable CSRF protection for these actions

  def register
    ActiveRecord::Base.transaction do
      user = User.new(user_params)
      if user.save
        preference = Preference.create(preferable: user)
        user.update(preference: preference, avator: '/path/to/default/avator.jpg')
        render json: {
          id: user.id,
          preference: user.preference.id,
          avator: user.avator
        }, status: :created
      else
        render json: {
          errors: user.errors.full_messages.to_s
        }, status: :bad_request
      end
    end
  end

  def login
    user = User.find_by(name: params[:name])
    if user&.authenticate(params[:password])
      preference = Preference.find_by(preferable: user)
      render json: {
        id: user.id,
        email: user.email,
        preference: extract_preferences(preference),
        avator: user.avator
      }, status: :ok # 200
    else
      render json: {
        errors: 'Invalid name or password'
      }, status: :not_found # 404
    end
  end

  def find_by_id
    user = User.find_by(id: params[:id])
    if user
      preference = Preference.find_by(preferable: user)
      render json: {
        id: user.id,
        name: user.name,
        email: user.email,
        preference: extract_preferences(preference),
        avator: user.avator
      }, status: :ok # 200
    else
      render json: {
        errors: 'User not found'
      }, status: :not_found # 404
    end
  end

  def delete_by_id
    user = User.find_by(id: params[:id])
    if user
      user.destroy
      render json: {
        message: 'User deleted'
      }, status: :ok # 200
    else
      render json: {
        error: 'User not found'
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

  def user_params
    {
      name: params[:name],
      email: params[:email],
      password: params[:password]
    }
  end
end
