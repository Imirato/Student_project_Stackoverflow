require 'rails_helper'

feature 'User can delete his answer' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated' do
    scenario 'user tries to delete his answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete the answer'

      expect(page).to have_content 'Your answer was successfully deleted.'
    end

    scenario 'user tries to delete the answer of other user' do
      another_user = create(:user)

      sign_in(another_user)
      visit question_path(question)

      expect(page).to have_no_link('Delete the answer', href: answer_path(answer))
    end
  end

  scenario 'Unauthenticated user tries to delete the answer' do
    visit question_path(question)

    expect(page).to have_no_link('Delete the answer', href: answer_path(answer))
  end
end
