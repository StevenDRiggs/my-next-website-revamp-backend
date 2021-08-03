Rails.application.routes.draw do
  resources :users
  resources :blog_entries, except: [:show, :update]

  post '/admin_login', to: 'users#admin_login'
  get '/blog_entries/:slug', to: 'blog_entries#show'
  patch '/blog_entries/:slug', to: 'blog_entries#update'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
