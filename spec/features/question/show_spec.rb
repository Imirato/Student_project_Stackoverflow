require 'rails_helper'

feature 'User can view a question and answers' do
  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 3, question: question) }

  scenario 'User tries to view a question and answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body}
  end
end
