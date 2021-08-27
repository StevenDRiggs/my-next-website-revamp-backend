Rails.application.routes.draw do
  resources :users
  resources :blog_entries, except: [:show, :update, :destroy]

  root 'blog_entries#index'

  post '/admin_login', to: 'users#admin_login'

  get '/blog_entries/:slug', to: 'blog_entries#show', as: 'blog_entry'
  patch '/blog_entries/:slug', to: 'blog_entries#update'
  delete '/blog_entries/:slug', to: 'blog_entries#destroy'

  post '/contact', to: 'application#contact'
end
