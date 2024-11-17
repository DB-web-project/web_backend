class PostController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[post] # Disable CSRF protection for these actions
  def post
    if (params[:publisher_type] == 'User' && User.find_by(id: params[:publisher])) ||
       (params[:publisher_type] == 'Admin' && Admin.find_by(id: params[:publisher])) ||
       (params[:publisher_type] == 'Business' && Business.find_by(id: params[:publisher]))
      post = Post.new(post_params)
      post.likes = 0
      if post.save
        render json: { id: post.id }, status: :created
      else
        render json: { errors: post.errors.full_messages }, status: :bad_request
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
        title: post.title
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

  private

  def post_params
    {
      publisher: params[:publisher],
      publisher_type: params[:publisher_type],
      date: params[:date],
      content: params[:content],
      title: params[:title]
    }
  end
end
