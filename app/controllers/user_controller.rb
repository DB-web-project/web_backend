class UserController < ApplicationController
  def register
    ActiveRecord::Base.transaction do # 两个表的数据要么同时成功，要么同时失败
      user = User.new(user_params)
      if user.save
        preference = Preference.create
        render json: {
          id: user.id,
          preference: preference.id,
          avator: '/path/to/default/avator.jpg'
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
