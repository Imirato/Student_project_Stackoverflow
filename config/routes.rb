Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    member do
      delete :destroy_attached_file
    end

    resources :answers, shallow: true, except: [:show, :index] do
      member do
        post :mark_as_best
        delete :destroy_attached_file
      end
    end
  end

  root to: 'questions#index'
end
