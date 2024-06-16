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

  resources :categories, only: [:show]
  # 點進top menu個別商品分類後 要顯示的畫面的路徑

  # resource :cart
  # 單數resource寫法 會長出不帶id的網址，因為購物車只要一台就好，所以不需要用id來辨別哪一台購物車
  # new_cart  GET      /cart/new(.:format)                   carts#new
  # edit_cart GET      /cart/edit(.:format)                  carts#edit
  # cart      GET      /cart(.:format)                       carts#show
  #           PATCH    /cart(.:format)                       carts#update
  #           PUT      /cart(.:format)                       carts#update
  #           DELETE   /cart(.:format)                       carts#destroy
  #           POST     /cart(.:format)                       carts#create
  resource :cart, only: [:show, :destroy] do#只需要 看購物車裡面有什麼的頁面 跟 清空購物車的功能
  # cart GET      /cart(.:format)                            carts#show
  #      DELETE   /cart(.:format)                            carts#destroy
    collection do # 不用id
      get :checkout
      # http動詞 :action（cart controller中）
      # checkout_cart    GET      /cart/checkout(.:format)         carts#checkout
    end 
  end

  resources :orders, except: [:new, :edit, :update, :destroy] do # 結帳畫面 取代order new的頁面
  # orders   GET      /orders(.:format)               orders#index
  #          POST     /orders(.:format)               orders#create
  # order    GET      /orders/:id(.:format)           orders#show
  # GET 讀取、POST 新增、PUT修改
    collection do # 不用id
      get :confirm
      #  confirm_orders      GET      /orders/confirm(.:format)                     orders#confirm
    end 

    member do # 帶id
      delete :cancel # /orders/8/cancel
      # delete 或 post 皆可
      # cancel_order     DELETE   /orders/:id/cancel(.:format)            orders#cancel
    end
  end


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

    resources :categories, except: [:show] do
      collection do # collection直接長後面 member還會帶id
        put :sort
        # html動詞 :網址後面要接的（也會是action）
        # sort_admin_categories    PUT      /admin/categories/sort(.:format)          admin/categories#sort
      end
    end

  end

  namespace :api do
    namespace :v1 do # 這樣之後有v2時，可以跟v1共存
      post 'subscribe', to: 'utils#subscribe'
      # 用post動詞 到utils controller的subscribe action
      #  api_v1_subscribe    POST     /api/v1/subscribe(.:format)     api/v1/utils#subscribe
      post 'cart', to: 'utils#cart'
    end
  end

end

