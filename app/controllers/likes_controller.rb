class LikesController < ApplicationController
  before_action :set_like, only: %i[ show edit update destroy ]

  # GET /likes or /likes.json
  def index
    @likes = Like.all
  end

  # GET /likes/1 or /likes/1.json
  def show
  end

  # GET /likes/new
  def new
    @like = Like.new
  end

  # GET /likes/1/edit
  def edit
  end

  # POST /likes or /likes.json
  def create
    @like = Like.new(like_params)

    respond_to do |format|
      if @like.save
        format.html { redirect_to @like, notice: "Like was successfully created." }
        format.json { render :show, status: :created, location: @like }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /likes/1 or /likes/1.json
  def update
    respond_to do |format|
      if @like.update(like_params)
        format.html { redirect_to @like, notice: "Like was successfully updated." }
        format.json { render :show, status: :ok, location: @like }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/1 or /likes/1.json
  def destroy
    @like.destroy!

    respond_to do |format|
      format.html { redirect_to likes_path, status: :see_other, notice: "Like was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def check
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
      render json: { liked: 1 }, status: :ok
    else
      render json: { liked: 0 }, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def like_params
      params.require(:like).permit(:user_id, :comment_id)
    end
end
