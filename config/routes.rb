Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true, except: [:show, :index] do
      member do
        post :mark_as_best
      end
    end
  end

  root to: 'questions#index'
end
