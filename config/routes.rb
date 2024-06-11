Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # https://github.com/heartcombo/devise/wiki/OmniAuth%3A-Overview
  # By clicking on the above link/button, the user will be redirected to Facebook. (If this link doesn't exist, try restarting the server.) 
  # After inserting their credentials, they will be redirected back to your application's callback method.
  # To implement a callback, the first step is to go back to our config/routes.rb file and tell Devise in which controller we will implement Omniauth callbacks:
  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # controllers: { omniauth_callbacks: 'users/omniauth_callbacks' } 表示 使用者透過第三方平台同意登入後 要打回來到哪個controller

  root 'products#index' # 首頁（ / ）設定在 商品列表頁面
  # products控制器 index action、views > products > index.html.erb
  # root    GET    /    products#index

  resources :products, only: [:index, :show]
  # products是前台才會使用到的路徑 而前台只要可以 列出商品清單 及可查看單一商品內頁 即可
  # products    GET    /products(.:format)                products#index
  # product     GET    /products/:id(.:format)            products#show

  # 若在routes裡想要有 階層 的寫法 可以用namespace
  # namespace :admin 都放 後台 相關路徑
  namespace :admin do
    root 'products#index' # admin首頁（後台的首頁：/admin）設定在 商品列表頁面
    # 本namespace的首頁

    resources :products, except: [:show]
    #  admin_products     GET      /admin/products(.:format)              admin/products#index
    #                     POST     /admin/products(.:format)              admin/products#create
    #   new_admin_product GET      /admin/products/new(.:format)          admin/products#new
    #  edit_admin_product GET      /admin/products/:id/edit(.:format)     admin/products#edit
    #                     PATCH    /admin/products/:id(.:format)          admin/products#update
    #                     PUT      /admin/products/:id(.:format)          admin/products#update
    #                     DELETE   /admin/products/:id(.:format)          admin/products#destroy


    resources :vendors, except: [:show] # 不需要 顯示單一廠商資料的頁面（因為欄位很少，內容也不長，所以有index所有廠商資料列表就夠了）
    # 多開路徑會浪費額外資源，且會有資安風險

  end

end
