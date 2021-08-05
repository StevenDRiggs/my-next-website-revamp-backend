Rails.application.routes.draw do
  resources :users
  resources :blog_entries, except: [:show, :update, :destroy]

  post '/admin_login', to: 'users#admin_login'
  get '/blog_entries/:slug', to: 'blog_entries#show', as: 'blog_entry'
  patch '/blog_entries/:slug', to: 'blog_entries#update'
  delete '/blog_entries/:slug', to: 'blog_entries#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
