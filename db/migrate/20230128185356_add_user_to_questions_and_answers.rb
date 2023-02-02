class AddUserToQuestionsAndAnswers < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :questions, :user, null: false
    add_belongs_to :answers, :user, null: false
  end
end
