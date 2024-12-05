class PostController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[post] # Disable CSRF protection for these actions
  def post
    if (params[:publisher_type] == 'User' && User.find_by(id: params[:publisher])) ||
       (params[:publisher_type] == 'Admin' && Admin.find_by(id: params[:publisher])) ||
       (params[:publisher_type] == 'Business' && Business.find_by(id: params[:publisher]))
       if params[:image].present?
          uploaded_file = params[:image]
          uploads_dir = Rails.root.join('public', 'uploads')
          FileUtils.mkdir_p(uploads_dir)
          file_path = uploads_dir.join(uploaded_file.original_filename)
          File.open(file_path, 'wb') do |file|
            file.write(uploaded_file.read)
          end
          relative_path = "uploads/#{uploaded_file.original_filename}"
          image_url = URI.join(request.base_url, relative_path).to_s
          post = Post.new(post_params)
          post.likes = 0
          post.url = image_url
          post.date = Time.now
          if post.save
            render json: { id: post.id }, status: :created
          else
            render json: { errors: post.errors.full_messages }, status: :bad_request
          end
      else
        render json: { errors: 'No picture uploaded' }, status: :bad_request
      end
    else
      render json: { errors: 'publisher not found' }, status: :not_found
    end
  end

  def find_by_id
    post = Post.find_by(id: params[:id])
    if post
      render json: {
        id: post.id,
        publisher: post.publisher,
        publisher_type: post.publisher_type,
        date: post.date,
        likes: post.likes,
        content: post.content,
        title: post.title,
        picture: post.url
      }, status: :ok
    else
      render json: { errors: 'post not found' }, status: :not_found
    end
  end

  def delete_by_id
    post = Post.find_by(id: params[:id])
    if post
      post.destroy
      render json: { message: 'Post deleted' }, status: :ok
    else
      render json: { error: 'post not found' }, status: :not_found
    end
  end

  def sum
    num = params[:num].to_i
    if Post.all.length >= num
      posts = Post.all.sample(num)
      ids = []
      posts.each do |post|
        ids.push(post.id)
      end
      render json: { ids: ids }, status: :ok
    else
      render json: { errors: 'not enough posts' }, status: :not_found
    end
  end

  def find_by_publisher
    id = params[:id]
    if Post.find_by(publisher: id)
      posts = Post.where(publisher: id)
      ids = []
      posts.each do |post|
        ids.push(post.id)
      end
      render json: { ids: ids }, status: :ok
    else
      render json: { errors: 'no posts found' }, status: :not_found
    end
  end

  private

  def post_params
    {
      publisher: params[:publisher],
      publisher_type: params[:publisher_type],
      date: params[:date],
      content: params[:content],
      title: params[:title],
      image: params[:image]
    }
  end
end
