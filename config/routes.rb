Rails.application.routes.draw do
  resources :blog_entries, except: :show

  get '/blog_entries/:slug', to: 'blog_entries#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
