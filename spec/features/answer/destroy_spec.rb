require 'rails_helper'

feature 'User can delete his answer to the question' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user' do

    scenario 'tries to delete his answer', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete the answer'

      expect(page).not_to have_content answer.body
    end

    scenario "tries to delete other user's answer" do
      another_user = create(:user)
      sign_in(another_user)
      visit question_path(question)

      expect(page).not_to have_content 'Delete the answer'
    end
  end

  scenario 'Unauthenticated user tries to delete the answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete the answer'
  end
end
