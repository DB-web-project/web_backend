class UserController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[register login update_by_id update_preference_by_id] # Disable CSRF protection for these actions

  def register
    ActiveRecord::Base.transaction do
      user = User.new(user_params)
      if user.save
        preference = Preference.create(preferable: user)
        user.update(preference: preference, url: '/path/to/default/avator.jpg')
        render json: {
          id: user.id,
          preference: user.preference.id,
          avator: user.url
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
        avator: user.url
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
        avator: user.url
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

  def update_by_id
    user = User.find_by(id: params[:id])
    if user
      user.update(user_params)
      render json: {
        message: 'User updated'
      }, status: :ok # 200
    else
      render json: {
        errors: 'User not found'
      }, status: :not_found # 404
    end
  end

  def update_preference_by_id # by user id
    preference = Preference.find_by(preferable_type: 'User', preferable_id: params[:id])
    if preference
      preference.update(update_preference_by_id_params)
      render json: {
        message: 'Preference updated'
      }, status: :ok # 200
    else
      render json: {
        errors: 'User not found'
      }, status: :not_found # 404
    end
  end

  def upload_avatar
    @user = User.find_by(id: params[:id])
    if @user
      if params[:avatar].present?
        uploaded_file = params[:avatar]
        uploads_dir = Rails.root.join('public', 'uploads')
        FileUtils.mkdir_p(uploads_dir)
        file_path = uploads_dir.join(uploaded_file.original_filename)
        File.open(file_path, 'wb') do |file|
          file.write(uploaded_file.read)
        end
        relative_path = "uploads/#{uploaded_file.original_filename}"
        image_url = URI.join(request.base_url, relative_path).to_s
        if @user.update_column(:url, image_url)
          render json: { avatar: @user.url }, status: :ok
        else
          render json: { errors: 'User Update Failed!' }, status: :unprocessable_entity
        end
      else
        render json: { errors: 'No picture uploaded' }, status: :bad_request
      end
    else
      render json: { errors: 'User not found' }, status: :not_found
    end
  end

  def get_avatar
    user = User.find_by(id: params[:id])
    if user
      render json: {
        avatar: user.url
      }, status: :ok
    else
      render json: {
        errors: 'User not found'
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
