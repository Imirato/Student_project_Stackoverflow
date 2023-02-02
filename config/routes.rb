Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, except: [:show, :index]
  end

  root to: 'questions#index'
end
