class CoursesController < ApplicationController
  before_action :set_course, only: %i[show edit update destroy enroll]

  def index
    @courses = Course.all
  end

  def show
  end

  def new
    @instructors = Instructor.all
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to @course
    else
      @instructors = Instructor.all
      render :new
    end
  end

  def edit
    @instructors = Instructor.all
  end

  def update
    @course.update(course_params)
    redirect_to @course, notice: t('.success')
  end

  def destroy
    @course.destroy
    redirect_to courses_path, notice: 'Curso apagado com sucesso'
  end

  def enroll
    current_user.enrollments.create(course: @course, price: @course.price)
    redirect_to my_courses_courses_path, notice: 'Curso comprado com sucesso'
  end

  def my_courses
    @enrollments = current_user.enrollments
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params
      .require(:course)
      .permit(:name, :description, :code, :price, :instructor_id,
              :enrollment_deadline, :banner)
  end
end