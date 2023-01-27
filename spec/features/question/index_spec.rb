require 'rails_helper'

feature 'User can view the list of questions' do

  given!(:question) { create(:question) }
  given!(:question2) { create(:question) }
  given!(:question3) { create(:question) }

  scenario 'User tries to view the list of questions' do
    visit questions_path

    expect(page).to have_content question.title
    expect(page).to have_content question2.title
    expect(page).to have_content question3.title
  end
end