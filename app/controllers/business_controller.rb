class BusinessController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[register login update_by_id update_preference_by_id] # Disable CSRF protection for these actions

  def register
    ActiveRecord::Base.transaction do
      business = Business.new(business_params)
      if business.save
        preference = Preference.create(preferable: business) # 选择外键为business
        tag = Tag.create
        business.update(preference: preference, url: '/path/to/default/avator.jpg', tag: tag, score: 10)
        render json: {
          id: business.id,
          tag: business.tag.id,
          score: 10,
          preference: business.preference.id,
          avator: business.url
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
        avator: business.url
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
        avator: business.url
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

  def update_by_id
    business = Business.find_by(id: params[:id])
    if business
      business.update(business_params)
      render json: {
        message: 'Business updated'
      }, status: :ok
    else
      render json: {
        errors: 'Business not found'
      }, status: :not_found
    end
  end

  def update_preference_by_id
    preference = Preference.find_by(preferable_type: 'Business', preferable_id: params[:id])
    if preference
      preference.update(update_preference_by_id_params)
      render json: {
        message: 'Preference updated'
      }, status: :ok
    else
      render json: {
        errors: 'Preference not found'
      }, status: :not_found
    end
  end

  def update_tag_by_id
    tag = Tag.find_by(business_id: params[:id]) # tag belongs to business, so use business_id to find tag
    puts
    if tag
      tag.update(update_tag_by_id_params)
      render json: {
        message: 'Tag updated'
      }, status: :ok
    else
      render json: {
        errors: 'Tag not found'
      }, status: :not_found
    end
  end

  def upload_avatar
    @business = Business.find_by(id: params[:id])
    if @business
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
        if @business.update_column(:url, image_url)
          render json: { avatar: image_url }, status: :ok
        else
          render json: { errors: 'Business Update Failed!' }, status: :unprocessable_entity
        end
      else
        render json: { errors: 'No picture uploaded' }, status: :bad_request
      end
    else
      render json: { errors: 'Business not found' }, status: :not_found
    end
  end

  def get_avatar
    business = Business.find_by(id: params[:id])
    if business
      render json: { avatar: business.url }, status: :ok
    else
      render json: { errors: 'Business not found' }, status: :not_found
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

  def update_tag_by_id_params
    tags_array = params[:tags]
    {
      tag1: tags_array[0],
      tag2: tags_array[1],
      tag3: tags_array[2],
      tag4: tags_array[3],
      tag5: tags_array[4]
    }.compact
  end
end
