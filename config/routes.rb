Rails.application.routes.draw do

  root 'static_pages#home'
  root 'static_pages#help'
  root 'static_pages#about'
  root 'static_pages#contact'

  # root "application#hello"
end
