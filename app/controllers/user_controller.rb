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

  def extract_preferences(preference)
    [preference.preference1, preference.preference2, preference.preference3, preference.preference4,
     preference.preference5]
  end

  private

  def user_params
    {
      name: params[:name],
      email: params[:email],
      password: params[:password]
    }
  end
end
