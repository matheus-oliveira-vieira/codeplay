class Api::V1::EnrollmentsController < Api::V1::ApiController
  def index
    #byebug
    @student = User.find(params[:user_id])
    @courses = @student.courses
    render json: @courses
      .as_json(except: [:id, :created_at, :updated_at, :instructor_id], 
               include: :instructor)
  end
end
