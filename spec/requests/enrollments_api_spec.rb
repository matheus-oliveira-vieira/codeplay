require 'rails_helper'

describe 'Enrollments API' do
  context 'GET /api/v1/courses' do
    it 'should view all enrollments' do
      student = User.create!(email: 'jane@test.com.br', password: '123456')
      instructor = Instructor.create!(name: 'Fulano Sicrano',
                                      email: 'fulano@codeplay.com.br')
      available_course = Course.create!(name: 'Ruby', description: 'Um curso de Ruby',
                                        code: 'RUBYBASIC', price: 10,
                                        enrollment_deadline: 1.year.from_now, instructor: instructor)
      Enrollment.create!(user: student, course: available_course)

      get '/api/v1/enrollments', params: { user_id: student.id }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body[0]['name']).to eq(available_course.name)
      expect(parsed_body[0]['code']).to eq('RUBYBASIC')
      expect(parsed_body[0]['price']).to eq('10.0')
    end

    it 'returns no enrollments' do
      get '/api/v1/enrollments'

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to be_empty      
    end

  end
end