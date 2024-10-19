class AnnouncementController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:post]

  def post
    if Admin.find_by(id: params[:publisher])
      announcement = Announcement.new(announcement_params)
      if announcement.save
        render json: { id: announcement.id }
      else
        render json: { message: 'Announcement creation failed' }
      end
    else
      render json: { message: 'Invalid publisher' }
    end
  end

  private

  def announcement_params
    params.require(:announcement).permit(:title, :content, :publisher)
  end
end
