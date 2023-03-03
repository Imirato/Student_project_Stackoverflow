require 'rails_helper'

feature 'User can edit his answer' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to edit his answer' do
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
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer" do
      click_on 'Log out'
      user = create(:user)
      sign_in(user)

      visit question_path(question)

      within '.answers' do
        expect(page).to have_no_link('Edit')
      end
    end
  end

  scenario 'Unauthenticated user tries to edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
