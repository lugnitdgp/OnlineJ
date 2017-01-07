Rails.application.routes.draw do
  get '/users/update' => 'user#update', as: 'force_update'
  get '/users/update_form' => 'user#update_form' 
  post '/users/update_form' => 'user#save_update'
  get '/users/profile' => 'user#profile'
  post '/users/checkusr' => 'user#checkusr'

  require 'sidekiq/web'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'home#index'
  get '/contest/:ccode' => 'contest#index', as: 'contest'
  get '/contest/:ccode/:pcode' => 'contest#problem', as: 'problem'
  post '/submit/:code' => 'submission#verify_submission', as: 'submit'
  get 'submission' => 'submission#index' , as: 'submission'
  get 'submission/contest/:ccode' => 'submission#index', as: 'submission_contest'
  get 'submission/contest/:ccode/:pcode' => 'submission#index', as: 'submission_problem'
  get 'submission/user/:user_id' => 'submission#index', as: 'submission_user'
  get 'submission/contest/:ccode/user/:user_id' => 'submission#index', as: 'submission_contest_user'
  get 'submission/contest/:ccode/:pcode/user/:user_id' => 'submission#index', as: 'submission_problem_user'
  get 'get_submission_data' => 'submission#get_submission_data', as: 'get_submission_data'
end
