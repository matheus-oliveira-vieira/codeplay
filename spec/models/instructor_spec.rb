require 'rails_helper'

describe Instructor do
  it { should have_many(:courses) }
  it { should validate_presence_of(:name).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:email).with_message('não pode ficar em branco') }

  context 'display_name' do
    it 'should display name and email with hyphen' do
      instructor = Instructor.new(name: 'Fulano',
                                  email: 'fulano@email.com')
      expect(instructor.display_name).to eq('Fulano - fulano@email.com')
    end

    it 'should display name and email with multiple names' do
      instructor = Instructor.new(name: 'Fulano Sicrano',
                                  email: 'fulano@email.com')
      expect(instructor.display_name).to eq('Fulano Sicrano - fulano@email.com')
    end

    it 'should display even with empty values' do
      instructor = Instructor.new(name: '',
                                  email: 'fulano@email.com')
      expect(instructor.display_name).to eq(' - fulano@email.com')
    end
  end
end