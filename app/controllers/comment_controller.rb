class CommentController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[post update_likes]

  def post
    if (params[:publisher_type] == 'User' && User.find_by_id(params[:publisher])) ||
       (params[:publisher_type] == 'Business' && Business.find_by_id(params[:publisher])) ||
       (params[:publisher_type] == 'Admin' && Admin.find_by_id(params[:publisher]))
      if Post.find_by_id(params[:post_id])
        comment = Comment.new(comment_params)
        comment.likes = 0
        if comment.save
          render json: { id: comment.id }, status: 200
        else
          render json: { error: 'Failed to save comment' }, status: 500
        end
      else
        render json: { error: 'Post not found' }, status: 404
      end
    else
      render json: { error: 'Publisher not found' }, status: 404
    end
  end

  def find_by_post_id
    comments = Comment.where(post_id: params[:id])
    if comments.any?
      render json: comments.map { |comment|
        {
          id: comment.id,
          post_id: comment.post_id,
          publisher: comment.publisher,
          publisher_type: comment.publisher_type,
          date: comment.date,
          content: comment.content,
          likes: comment.likes
        }
      }, status: :ok
    else
      render json: { error: 'Comments not found' }, status: :not_found
    end
  end

  def delete_by_id
    comment = Comment.find_by_id(params[:id])
    if comment
      comment.destroy
      render json: { message: 'Comment deleted' }, status: :ok
    else
      render json: { error: 'Comment not found' }, status: :not_found
    end
  end

  def update_likes
    comment = Comment.find_by_id(params[:id])
    if comment
      comment.likes = params[:likes]
      if comment.save
        render json: { 
            message: 'Comment Updated',
        }, status: :ok
      else
        render json: { errors: 'Failed to update comment' }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'Comment not found' }, status: :not_found
    end
  end

  def increase_likes
    user_id = params[:user_id]
    comment_id = params[:comment_id]

    if user_id.nil? || comment_id.nil?
      render json: { error: 'Missing user_id or comment_id' }, status: :bad_request
      return
    end

    user = User.find_by(id: user_id)
    comment = Comment.find_by(id: comment_id)

    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    if comment.nil?
      render json: { error: 'Comment not found' }, status: :not_found
      return
    end

    like = Like.find_or_initialize_by(user_id: user_id, comment_id: comment_id)

    if like.new_record?
      like.save
      # 统计点赞总数
      total_likes = Like.where(comment_id: comment_id).count
      comment.update(likes: total_likes)
      render json: { likes: total_likes }, status: :ok
    else
      render json: { error: 'Already liked' }, status: :unprocessable_entity
    end
  end

  def cancel_likes
    user_id = params[:user_id]
    comment_id = params[:comment_id]

    if user_id.nil? || comment_id.nil?
      render json: { error: 'Missing user_id or comment_id' }, status: :bad_request
      return
    end

    user = User.find_by(id: user_id)
    comment = Comment.find_by(id: comment_id)

    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    if comment.nil?
      render json: { error: 'Comment not found' }, status: :not_found
      return
    end

    like = Like.find_by(user_id: user_id, comment_id: comment_id)

    if like
      like.destroy
      # 统计点赞总数
      total_likes = Like.where(comment_id: comment_id).count
      comment.update(likes: total_likes)
      render json: { likes: total_likes }, status: :ok
    else
      render json: { error: 'Like not found' }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :publisher, :publisher_type, :date, :content)
  end
end
