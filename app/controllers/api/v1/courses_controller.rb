class Api::V1::CoursesController < Api::V1::ApiController

  def index
    @courses = Course.all
    render json: @courses
      .as_json(except: [:id, :created_at, :updated_at, :instructor_id], 
               include: :instructor)
  end

  def show
    @course = Course.find_by!(code: params[:code])
    render json: @course
  end

  def create
    @course = Course.new(course_params)
    @course.save!
    render json: @course, status: :created
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end

  def update
    @course = Course.find_by!(code: params[:code])
    @course.update!(course_params)
    render json: @course
  end

  private

  def course_params
    params
      .require(:course)
      .permit(:name, :description, :code, :price, :instructor_id,
              :enrollment_deadline, :banner)
  end
end