class UserController < ApplicationController
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

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
