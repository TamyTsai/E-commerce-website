Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # https://github.com/heartcombo/devise/wiki/OmniAuth%3A-Overview
  # By clicking on the above link/button, the user will be redirected to Facebook. (If this link doesn't exist, try restarting the server.) 
  # After inserting their credentials, they will be redirected back to your application's callback method.
  # To implement a callback, the first step is to go back to our config/routes.rb file and tell Devise in which controller we will implement Omniauth callbacks:
  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # controllers: { omniauth_callbacks: 'users/omniauth_callbacks' } 表示 使用者透過第三方平台同意登入後 要打回來到哪個controller

  root 'products#index' # 首頁設定在 商品列表頁面
  # products控制器 index action、views > products > index.html.erb
  # root    GET    /    products#index

  resources :products, only: [:index, :show]
  # products是前台才會使用到的路徑 而前台只要可以 列出商品清單 及可查看單一商品內頁 即可
  # products    GET    /products(.:format)                products#index
  # product     GET    /products/:id(.:format)            products#show
  
end
