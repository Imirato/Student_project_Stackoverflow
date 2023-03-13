class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[edit update destroy mark_as_best destroy_attached_file]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      redirect_to question_path(@answer.question)
    end
  end

  def mark_as_best
    @last_best_answers = @answer.question.best_answer
    @answer.question.update(best_answer_id: @answer.id)
  end

  def destroy_attached_file
    if current_user.author_of?(@answer)
      @file = ActiveStorage::Attachment.find(params[:file_id])
      @file.purge
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
