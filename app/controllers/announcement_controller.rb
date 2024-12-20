class AnnouncementController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:post]

  def post
    if Admin.find_by(id: params[:publisher])
      announcement = Announcement.new(announcement_params)
      if announcement.save
        render json: { id: announcement.id }, status: :created
      else
        render json: { message: 'Announcement creation failed' }, status: :bad_request
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
        publisher: announcement.publisher,
        title: announcement.title
      }, status: :ok
    else
      render json: { errors: 'Announcement not found' }, status: :not_found
    end
  end

  def find_all
    announcements = Announcement.all
    if announcements
      ids = announcements.map(&:id)
      render json: { ids: ids }, status: :ok
    else
      render json: { message: 'No announcements found' }, status: :not_found
    end
  end

  def delete_by_id
    announcement = Announcement.find_by(id: params[:id])
    if announcement
      announcement.destroy
      render json: { message: 'Announcement deleted' }
    else
      render json: { error: 'Announcement not found' }, status: :not_found
    end
  end

  private

  def announcement_params
    params.require(:announcement).permit(:date, :content, :publisher, :title)
  end
end
