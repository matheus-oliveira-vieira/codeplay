require 'rails_helper'

describe 'Student view courses on homepage' do
  it 'courses with enrollment still available' do
    instructor = Instructor.create!(name: 'Fulano Sicrano',
                                    email: 'fulano@codeplay.com.br')
    available_course = Course.create!(name: 'Ruby', description: 'Um curso de Ruby',
                            code: 'RUBYBASIC', price: 10,
                            enrollment_deadline: 1.month.from_now, instructor: instructor)

    unavailable_course = Course.create!(name: 'HTML', description: 'Um curso de HTML',
                          code: 'HTMLBASIC', price: 12,
                          enrollment_deadline: 1.day.ago, instructor: instructor)

    visit root_path

    expect(page).to have_content('Ruby')
    expect(page).to have_content(available_course.description)
    expect(page).to have_content('R$ 10,00')
    expect(page).not_to have_content('HTML')
    expect(page).not_to have_content(unavailable_course.description)
    expect(page).not_to have_content('R$ 12,00')
  end

  it 'and view enrollment link' do
    instructor = Instructor.create!(name: 'Fulano Sicrano',
                                    email: 'fulano@codeplay.com.br')
    available_course = Course.create!(name: 'Ruby', description: 'Um curso de Ruby',
                            code: 'RUBYBASIC', price: 10,
                            enrollment_deadline: 1.month.from_now, instructor: instructor)

    student_login
    visit root_path
    click_on 'Ruby'

    expect(page).to have_link 'Comprar'
  end

  xit 'and does not view enrollment if deadline is over' do
    # curso com data limite ultrapassada mas com usuario logado não deve exibir o link
  end

  it 'must be signed in to enroll' do
    instructor = Instructor.create!(name: 'Fulano Sicrano',
                                    email: 'fulano@codeplay.com.br')
    available_course = Course.create!(name: 'Ruby', description: 'Um curso de Ruby',
                            code: 'RUBYBASIC', price: 10,
                            enrollment_deadline: 1.month.from_now, instructor: instructor)

    visit root_path
    click_on 'Ruby'

    expect(page).not_to have_link 'Comprar'
    expect(page).to have_content 'Faça login para comprar este curso'
    expect(page).to have_link 'login', href: new_user_session_path
  end

  it 'and buy a course' do
    user = User.create!(email: 'jane@test.com.br', password: '123456')
    instructor = Instructor.create!(name: 'Fulano Sicrano',
                                    email: 'fulano@codeplay.com.br')
    available_course = Course.create!(name: 'Ruby', description: 'Um curso de Ruby',
                            code: 'RUBYBASIC', price: 10,
                            enrollment_deadline: 1.month.from_now, instructor: instructor)
    other_course = Course.create!(name: 'Elixir', description: 'Um curso de programação funcional',
                            code: 'ELIXIRBASIC', price: 20,
                            enrollment_deadline: 1.month.from_now, instructor: instructor)

    student_login
    visit root_path
    click_on 'Ruby'
    click_on 'Comprar'

    expect(page).to have_content 'Curso comprado com sucesso'
    expect(current_path).to eq my_courses_courses_path
    expect(page).to have_content 'Ruby'
    expect(page).to have_content 'R$ 10,00'
    expect(page).not_to have_content 'Elixir'
    expect(page).not_to have_content 'R$ 20,00'
  end

  it 'and cannot buy a course twice' do
    student = student_login
    instructor = Instructor.create!(name: 'Fulano Sicrano',
                                    email: 'fulano@codeplay.com.br')
    available_course = Course.create!(name: 'Ruby', description: 'Um curso de Ruby',
                            code: 'RUBYBASIC', price: 10,
                            enrollment_deadline: 1.month.from_now, instructor: instructor)
    Lesson.create!(name: 'Monkey Patch', course: available_course, duration: 20,
                   content: 'Uma aula legal')
    Enrollment.create!(student: student, course: available_course)

    visit root_path
    click_on 'Ruby'

    expect(page).to_not have_link 'Comprar'
    expect(page).to have_link 'Monkey Patch'
  end
end