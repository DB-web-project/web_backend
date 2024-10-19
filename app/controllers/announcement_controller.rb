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

  def find_by_id
    announcement = Announcement.find_by(id: params[:id])
    if announcement
      render json: {
        id: announcement.id,
        date: announcement.date,
        content: announcement.content,
        publisher: announcement.publisher
      }, status: :ok
    else
      render json: { message: 'Announcement not found' }, status: :not_found
    end
  end

  private

  def announcement_params
    params.require(:announcement).permit(:date, :content, :publisher)
  end
end
