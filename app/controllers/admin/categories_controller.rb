# $ rails g controller admin/categories

class Admin::CategoriesController < Admin::BaseController

    def index # 商品分類 列表 頁面 對應的 action
    end

    def new # 新建商品分類 頁面 對應的 action
        @category = Category.new
    end

    def create
        @category = Category.new(category_params) # 洗過的參數之後才寫得進去

        if @category.save
            redirect_to admin_categories_path, notice: '新增商品分類成功'
        else # 若 寫入失敗（格式不對、驗證沒過...）（在model做後端驗證（進資料庫前的驗證））          
            render :new 
        end

        # rails c
            # [5] pry(main)> Category.all
            #   Category Load (1.5ms)  SELECT "categories".* FROM "categories" WHERE "categories"."deleted_at" IS NULL
            #   => [#<Category:0x000000012d614fa8 id: 1, name: "本日精選", deleted_at: nil, position: 1, created_at: Wed, 12 Jun 2024 07:13:48.870323000 UTC +00:00, updated_at: Wed, 12 Jun 2024 07:13:48.870323000 UTC +00:00>]
            #  #<Category:0x000000013b203320 id: 2, name: "人氣推薦", deleted_at: nil, position: 2, created_at: Wed, 12 Jun 2024 07:15:37.077307000 UTC +00:00, updated_at: Wed, 12 Jun 2024 07:15:37.077307000 UTC +00:00>]
            # position欄位的值 為acts as list套件自動幫我們加的
    end

    private

    def category_params
        params.require(:category).permit(:name)
        # 排序跟刪除欄位不是給使用者輸入的 所以不需讓這些欄位在強參數可通過
    end
end
