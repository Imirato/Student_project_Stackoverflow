require 'rails_helper'

feature 'User can delete his question' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated' do
    scenario 'user tries to delete his question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete the question'

      expect(page).to have_content 'Your question was successfully deleted.'
    end

    scenario 'user tries to delete the question of other user' do
      another_user = create(:user)

      sign_in(another_user)
      visit question_path(question)

      expect(page).not_to have_content 'Delete the question'
    end
  end
end