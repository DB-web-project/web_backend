class CommentController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:post]

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

  private

  def comment_params
    params.require(:comment).permit(:post_id, :publisher, :publisher_type, :date, :content)
  end
end
