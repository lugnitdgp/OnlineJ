Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  require 'sidekiq/web'
  require 'sidekiq-status/web'
  require 'sidetiq/web'
  authenticate :user, ->(user) { user.has_role?(:admin) || user.has_role?(:setter) } do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    mount Sidekiq::Web => '/sidekiq'
  end
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  get '/contest/:ccode' => 'contest#index', as: 'contest'
  get '/contest/:ccode/:pcode' => 'contest#problem', as: 'problem'
  get '/contest/:ccode/:pcode/:submission_id' => 'contest#problem', as: 'edit_submission'
  get '/comments/:ccode/:pcode' => 'contest#comments', as: 'comments'
  post '/comment/:ccode/:pcode' => 'contest#create_comment', as: 'create_comment'

  get '/get_snippet/:lang_code' => 'contest#get_snippet', as: 'get_snippet'
  post '/submit/:code' => 'submission#verify_submission', as: 'submit'

  get 'submission' => 'submission#index', as: 'submission'
  get 'submission/contest/:ccode' => 'submission#index', as: 'submission_contest'
  get 'submission/contest/:ccode/:pcode' => 'submission#index', as: 'submission_problem'
  get 'submission/user/:username' => 'submission#index', as: 'submission_user'
  get 'submission/contest/:ccode/:pcode/user/:username' => 'submission#index', as: 'submission_problem_user'
  get 'submission/contest/:ccode/user/:username' => 'submission#index', as: 'submission_contest_user'

  get 'get_submission_data' => 'submission#get_submission_data', as: 'get_submission_data'
  get 'get_submission' => 'submission#get_submission', as: 'get_submission'
  get 'get_submission_error' => 'submission#get_submission_error', as: 'get_submission_error'

  get 'rejudge_submission' => 'submission#rejudge_submission', as: 'rejudge_submission'
  get 'rejudge_all_submission' => 'submission#rejudge_all_submission'
  get 'rejudge_all_submission/contest/:ccode' => 'submission#rejudge_all_submission'
  get 'rejudge_all_submission/contest/:ccode/:pcode' => 'submission#rejudge_all_submission'
  get 'rejudge_all_submission/user/:username' => 'submission#rejudge_all_submission'
  get 'rejudge_all_submission/contest/:ccode/:pcode/user/:username' => 'submission#rejudge_all_submission'
  get 'rejudge_all_submission/contest/:ccode/user/:username' => 'submission#rejudge_all_submission'

  get '/users/update_form' => 'user#update_form', as: 'force_update'
  post '/users/update_form' => 'user#save_update', as: ''
  get '/users/profile/:username' => 'user#profile', as: 'users'
  post '/users/checkuser' => 'user#checkuser', as: ''
  post 'users/set_lang/:default_language' => 'user#setLang', as: 'setLang'
  get '/scoreboard/:ccode' => 'scoreboard#index', as: 'scoreboard'
end
