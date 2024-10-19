class AdminController < ApplicationController
  def register
    ActiveRecord::Base.transaction do
      admin = Admin.new(admin_params)
      if admin.save
        preference = Preference.create(preferable: admin)
        admin.update(preference: preference, avator: '/path/to/default/avator.jpg')
        render json: {
          id: admin.id,
          preference: admin.preference.id,
          avator: admin.avator
        }, status: :created
      else
        render json: {
          errors: admin.errors.full_messages.to_s
        }, status: :bad_request
      end
    end
  end

  private

  def admin_params
    {
      name: params[:name],
      email: params[:email],
      password: params[:password]
    }
  end
end
