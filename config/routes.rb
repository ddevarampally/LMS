Rails.application.routes.draw do
  get 'users/index'
  post 'users/delete'
  post 'users/add'

  get 'books/index'
  post 'books/image_upload'
  post 'books/delete_uploaded_images'
  post 'books/delete'
  post 'books/subscribe'
  post 'books/add'
  get 'books/activity_logs'

  get 'home/index'
  get 'home/login'        
  get 'home/change_password'
  get 'home/logout'

  post 'home/validate_login'  
  post 'home/change_password'
  post 'home/forgot_password'
  
  root 'home#login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
