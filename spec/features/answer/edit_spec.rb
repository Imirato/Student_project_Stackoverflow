require 'rails_helper'

feature 'User can edit his answer' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    scenario 'tries to edit his answer', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edit text'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edit text'
        expect(page).to_not have_selector 'textarea'
      end

    end

    scenario 'tries to edit his answer with mistakes' do

    end

    scenario "tries to edit other user's answer" do

    end
  end

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end