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

  # 🚨 TEMPORARY ROUTE: remove after running once
  get "/make_admin_once", to: proc {
    u = User.find_or_initialize_by(email: "admin@example.com")
    u.password = "Pass@12345"
    u.password_confirmation = "Pass@12345"
    u.role = :admin
    u.save!
    [200, { "Content-Type" => "text/plain" }, ["Admin created: #{u.email} / Pass@12345"]]
  }
end
