require 'rails_helper'

feature 'User can write an answer to the question' do
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to write an answer' do
      fill_in 'Body', with: 'text text text'
      click_on 'Post'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'text text text'
    end

    scenario 'tries to write an answer with errors' do
      click_on 'Post'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to write an answer with attached files' do
      fill_in 'Body', with: 'text text text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Post'

      expect(page).to have_content 'rails_helper.rb'
      expect(page).to have_content 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to write an answer' , js: true do
    visit question_path(question)
    click_on 'Post'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
