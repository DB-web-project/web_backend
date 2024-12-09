class ScoresController < ApplicationController
  before_action :set_score, except: [:index, :new, :create, :check]

  # GET /scores or /scores.json
  def index
    @scores = Score.all
  end

  # GET /scores/1 or /scores/1.json
  def show
  end

  # GET /scores/new
  def new
    @score = Score.new
  end

  # GET /scores/1/edit
  def edit
  end

  # POST /scores or /scores.json
  def create
    @score = Score.new(score_params)

    respond_to do |format|
      if @score.save
        format.html { redirect_to @score, notice: "Score was successfully created." }
        format.json { render :show, status: :created, location: @score }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scores/1 or /scores/1.json
  def update
    respond_to do |format|
      if @score.update(score_params)
        format.html { redirect_to @score, notice: "Score was successfully updated." }
        format.json { render :show, status: :ok, location: @score }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scores/1 or /scores/1.json
  def destroy
    @score.destroy!

    respond_to do |format|
      format.html { redirect_to scores_path, status: :see_other, notice: "Score was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /scores/check
  def check
    user_id = params[:user_id]
    commodity_id = params[:commodity_id]

    if user_id.nil? || commodity_id.nil?
      render json: { error: 'Missing user_id or commodity_id' }, status: :bad_request
      return
    end

    user = User.find_by(id: user_id)
    commodity = Commodity.find_by(id: commodity_id)

    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    if commodity.nil?
      render json: { error: 'Commodity not found' }, status: :not_found
      return
    end

    score_record = Score.find_by(user_id: user_id, commodity_id: commodity_id)
    average_score = Score.where(commodity_id: commodity_id).average(:score)

    if score_record
      render json: { score: score_record.score }, status: :ok
    else
      render json: { score: -1}, status: :ok
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_score
    @score = Score.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def score_params
    params.require(:score).permit(:user_id, :commodity_id, :score)
  end
end