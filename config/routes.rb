Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'home#index'
  get '/contest/:ccode' => 'contest#index', as: 'contest'
  get '/contest/:ccode/:pcode' => 'contest#problem', as: 'problem'
  post '/submit/:code' => 'submission#verify_submission', as: 'submit'
  get 'submission' => 'submission#index'
  get 'submission/contest/:ccode' => 'submission#index'
  get 'submission/contest/:ccode/:pcode' => 'submission#index'
  get 'submission/user/:user_id' => 'submission#index'
  get 'submission/contest/:ccode/user/:user_id' => 'submission#index'
  get 'submission/contest/:ccode/:pcode/user/:user_id' => 'submission#index'
end
