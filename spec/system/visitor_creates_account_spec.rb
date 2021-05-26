require 'rails_helper'

describe 'Visitor create account' do
  it 'with email and password' do
    visit root_path
    click_on 'Registrar'
    fill_in 'Email', with: 'jane@doe.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmação de Senha', with: '123456'
    click_on 'Criar Conta'

    expect(page).to have_text('Login efetuado com sucesso')
    expect(page).to have_link('Cursos')
    expect(page).to have_link('Sair')
    expect(page).to_not have_link('Registrar')

  end
end