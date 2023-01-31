require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: question } }

    it 'associates answer with question' do
      expect(assigns(:answer).question).to eq question
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 'render new view again' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }

        expect(response).to render_template :show
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      let(:new_answer_body) { 'new body' }

      it 'assigns the requested answer to @answer' do
        post :update, params: { id: answer, answer: attributes_for(:answer) }

        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: new_answer_body } }
        answer.reload

        expect(answer.body).to eq new_answer_body
      end

      it 'redirects to updated answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }

        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'MyText'
      end

      it 'render edit view again' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, user: author) }

    context 'user is author of answer' do
      before { login(author) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'user is not author of answer' do
      before { login(user) }

      it 'not deletes the question' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Question, :count)
      end

      it 'redirects to question page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
