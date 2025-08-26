Rails.application.routes.draw do
  devise_for :users

  # Public landing
  root "feedbacks#new"

  resources :feedbacks, only: [:index, :new, :create] do
    collection do
      get :admin_dashboard   # Admin / RTO / School user dashboard
    end
  end
  
  namespace :admin do
    resources :users
  end

  resources :reports, only: [:index]  # optional reports page

  resources :districts, only: [] do
    resources :schools, only: :index  # /districts/:district_id/schools.json
  end
end
