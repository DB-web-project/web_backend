class AdminController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[register login]

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

  def login
    admin = Admin.find_by(name: params[:name])
    if admin&.authenticate(params[:password])
      preference = Preference.find_by(preferable: admin)
      render json: {
        id: admin.id,
        email: admin.email,
        preference: extract_preferences(preference),
        avator: admin.avator
      }, status: :ok
    else
      render json: {
        errors: 'Invalid email or password'
      }, status: :not_found
    end
  end

  def extract_preferences(preference)
    [preference.preference1, preference.preference2, preference.preference3, preference.preference4,
     preference.preference5]
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
