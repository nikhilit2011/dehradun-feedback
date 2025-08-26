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
    get 'schools/index'
    get 'schools/new'
    get 'schools/create'
    get 'schools/edit'
    get 'schools/update'
    get 'schools/destroy'
    get 'districts/index'
    get 'districts/new'
    get 'districts/create'
    get 'districts/edit'
    get 'districts/update'
    get 'districts/destroy'
    resources :users
    resources :districts
    resources :schools
  end

  resources :reports, only: [:index]  # optional reports page

  # Public-facing JSON endpoint for school dropdowns
  resources :districts, only: [] do
    resources :schools, only: :index  # /districts/:district_id/schools.json
  end
end
