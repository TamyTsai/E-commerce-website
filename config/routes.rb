Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'products#index' # 首頁設定在 商品列表頁面
  # products控制器 index action、views > products > index.html.erb
  # root    GET    /    products#index

  resources :products, only: [:index, :show]
  # products是前台才會使用到的路徑 而前台只要可以 列出商品清單 及可查看單一商品內頁 即可
  # products    GET    /products(.:format)                products#index
  # product     GET    /products/:id(.:format)            products#show
  
end
