class AdminController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[register login update_by_id update_preference_by_id] # Disable CSRF protection for these actions

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

  def find_by_id
    admin = Admin.find_by(id: params[:id])
    if admin
      preference = Preference.find_by(preferable: admin)
      render json: {
        id: admin.id,
        name: admin.name,
        email: admin.email,
        preference: extract_preferences(preference),
        avator: admin.avator
      }, status: :ok
    else
      render json: {
        errors: 'Admin not found'
      }, status: :not_found
    end
  end

  def delete_by_id
    admin = Admin.find_by(id: params[:id])
    if admin
      admin.destroy
      render json: {
        message: 'Admin deleted successfully'
      }, status: :ok
    else
      render json: {
        error: 'Admin not found'
      }, status: :not_found
    end
  end

  def update_by_id
    admin = Admin.find_by(id: params[:id])
    if admin
      admin.update(admin_params)
      render json: {
        message: 'Admin updated'
      }, status: :ok
    else
      render json: {
        errors: 'Admin not found'
      }, status: :not_found
    end
  end

  def update_preference_by_id
    perference = Preference.find_by(preferable_type: 'Admin', preferable_id: params[:id])
    if perference
      perference.update(update_preference_by_id_params)
      render json: {
        message: 'Preference updated'
      }, status: :ok
    else
      render json: {
        errors: 'Preference not found'
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

  def admin_params
    {
      name: params[:name],
      email: params[:email],
      password: params[:password]
    }
  end

  def update_preference_by_id_params
    preferences_array = params[:preferences]
    {
      preference1: preferences_array[0],
      preference2: preferences_array[1],
      preference3: preferences_array[2],
      preference4: preferences_array[3],
      preference5: preferences_array[4]
    }.compact
  end
end
