class CommodityController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[register update_by_id delete_by_id find_by_id]
  def register
    ActiveRecord::Base.transaction do
      commodity = Commodity.new(commodity_params_register)
      commodity.score = 0
      commodity.rating_count = 0
      commodity.url = '/path/to/default/homepage.png'
      if commodity.save
        render json: {
          id: commodity.id,
          score: 10,
          homepage: commodity.url
        }, status: :created
      else
        render json: {
          errors: commodity.errors.full_messages.to_s
        }, status: :bad_request
      end
    end
  end

  def find_by_id
    commodity = Commodity.find_by(id: params[:id])
    if commodity
      render json: {
        id: commodity.id,
        name: commodity.name,
        price: commodity.price,
        score: commodity.score,
        introduction: commodity.introduction,
        business_id: commodity.business_id,
        homepage: commodity.url
      }, status: :ok
    else
      render json: {
        errors: 'Commodity not found'
      }, status: :not_found
    end
  end

  def delete_by_id
    commodity = Commodity.find_by(id: params[:id])
    if commodity
      commodity.destroy
      render json: {
        message: 'Commodity deleted'
      }, status: :ok
    else
      render json: {
        errors: 'Commodity not found'
      }, status: :not_found
    end
  end

  def update_by_id
    commodity = Commodity.find_by(id: params[:id]) # params是整体的传参hash
    if commodity
      commodity.update(commodity_params_update)
      render json: {
        message: 'Commodity updated'
      }, status: :ok
    else
      render json: {
        errors: 'Commodity not found'
      }, status: :not_found
    end
  end

  # 随机选取num个商品, 返回他们的id
  def sum
    num = params[:num].to_i
    if Commodity.all.length >= num
      commodities = Commodity.all.sample(num)
      ids = []
      commodities.each do |commodity|
        ids.push(commodity.id)
      end
      render json: {
        ids: ids
      }, status: :ok
    else
      render json: {
        errors: 'Not enough commodities'
      }, status: :not_found
    end
  end

  def elvaluate
    commodity = Commodity.find_by(id: params[:id])
    if commodity
      commodity.score = (commodity.score * commodity.rating_count + params[:score].to_i) / (commodity.rating_count + 1)
      commodity.rating_count += 1
      commodity.save
      render json: {
        score: commodity.score
      }, status: :ok
    else
      render json: {
        errors: 'Commodity not found'
      }, status: :not_found
    end
  end

  def find_by_business
    id = params[:id]
    if Commodity.find_by(business_id: id)
      commodities = Commodity.where(business_id: id)
      ids = []
      commodities.each do |commodity|
        ids.push(commodity.id)
      end
      render json: {
        ids: ids
      }, status: :ok
    else
      render json: {
        errors: 'No commodities found'
      }, status: :not_found
    end
  end

  def upload_homepage
    @commodity = Commodity.find_by(id: params[:id])
    if @commodity
      if params[:homepage].present?
        uploaded_file = params[:homepage]
        uploads_dir = Rails.root.join('public', 'uploads')
        FileUtils.mkdir_p(uploads_dir)
        file_path = uploads_dir.join(uploaded_file.original_filename)
        File.open(file_path, 'wb') do |file|
          file.write(uploaded_file.read)
        end
        relative_path = "uploads/#{uploaded_file.original_filename}"
        image_url = URI.join(request.base_url, relative_path).to_s
        if @commodity.update_column(:url, image_url)
          render json: { homepage: image_url }, status: :ok
        else
          render json: { errors: 'Commodity Update Failed!' }, status: :unprocessable_entity
        end
      else
        render json: { errors: 'No picture uploaded' }, status: :bad_request
      end
    else
      render json: { errors: 'Commodity not found' }, status: :not_found
    end
  end

  def get_homepage
    @commodity = Commodity.find_by(id: params[:id])
    if @commodity
      render json: { homepage: @commodity.url }, status: :ok
    else
      render json: { errors: 'Commodity not found' }, status: :not_found
    end
  end

  private # 定义不同的方法来过滤参数

  def commodity_params_register
    params.permit(:name, :price, :introduction, :business_id)
  end

  def commodity_params_update
    params.permit(:name, :price, :introduction)
  end
end
