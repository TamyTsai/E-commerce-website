# $ rails g controller admin/vendors

class Admin::VendorsController < Admin::BaseController

    before_action :find_vendor, only: [:edit, :update, :destroy]

    def index # 對應廠商列表頁面
        @vendors = Vendor.all
        # 透過.all類別方法，將 當前所有廠商資料（vendors資料表的所有資料），指定給實體變數@vendors （因為撈了多筆資料，所用複數型）
        # ORM基本操作之R
            # Story.all 列出所有候選人（物件、model、資料表中的一筆資料）資料
            # Story.select('title') 同上，只選取title欄位
            # Story.where(title: 'Ruby') 找出所有title欄位是Ruby的資料
            # Story.order('age DESC') 依照年齡大小反向排序
            # Story.order(age: :desc) 同上
            # Story.limit(5) 只取出5筆資料
    end

    def new # 對應新建廠商頁面
        @vendor = Vendor.new
        # 做一個vendor物件，到時候可以 用 實體變數 的 形式 塞給view
    end

    def create # 對應 用POST方法傳送新建廠商頁面資料 的 action
        # admin_vendors   POST   /admin/vendors(.:format)         admin/vendors#create {:expect=>[:show]}
        @vendor = Vendor.new(vendor_params)

        if @vendor.save # 若 成功 將 新建廠商頁面 輸入框中 的 資料 寫入資料庫
            redirect_to admin_vendors_path, notice: "成功新增廠商!"
            # 跳回 廠商列表頁
            # 要提示的訊息 需要透過view呈現在畫面（轉址頁面）
            # 在離開頁面時，給一個flash，flash的key為notice
            # 失敗的話可以用alert這個key
            # notice與alert為特化版的key # 舊版rails沒有這種寫法
        else # 若 寫入失敗（格式不對、驗證沒過...）（在model做後端驗證（進資料庫前的驗證））          
            # redirect_to new_story_path
            # 就不跳回文章列表頁，而是停留在本頁面（新建文章頁面），但此寫法會轉回全新頁面，導致所有資料都要重填
            # http沒有所謂的狀態，這頁寫好的東西，轉址後的網頁不會知道
            render :new 
            # 去new這個頁面，重新渲染一次（不是重新執行new方法（action）），是請view中的new頁面重畫一次
            # 本質上還是在create這個action中，並非執行new action
            # render就是要借new.html檔案來用
            # new.html檔案需要＠vendor 實體變數（所以才會在create action中，也寫一個跟new action中相同的 ＠vendor實體變數）（但也有 沒 這麼剛好（有同名實體變數）的狀況）
            # 這裡抓到的 ＠vendor實體變數 已經不像new action中是新創出來的，是裡頭已經有料（vendor_params）的 物件、model
        end
    end

    def edit # 編輯已建立之廠商資料 的 action
        # 要先找出特定廠商（before action已做）
    end

    def update # 對應以PATCH動詞（事實上是POST PATCH是模擬的）進入的/admin/vendors/:id路徑（admin_vendor_path）（將 進入 編輯已建立的廠商資料頁面 後，所更新的文章資料 儲存）
        #  admin_vendor     PATCH    /admin/vendors/:id(.:format)            admin/vendors#update {:expect=>[:show]}
        
        if @vendor.update(vendor_params) # 成功更新資料時
            # ORM基本操作之U
            # update()
            # update_attributes()
            # update_all()
            # 給一包清洗過的資料
            redirect_to edit_admin_vendor_path(@vendor), notice: '廠商資料更新成功'
            # 看起來停在原地 但其實是轉出去又轉回來
        else
            render :edit
            # 去edit這個頁面，重新渲染一次（不是重新執行edit方法（action）），是請view中的edit頁面重畫一次
        end
    end

    def destroy # 對應以DELETE動詞（事實上是GET DELETE是模擬的）進入的/admin/vendors/:id路徑（admin_vendor_path）（刪除已建立的廠商）
        # admin_vendor   DELETE   /admin/vendors/:id(.:format)          admin/vendors#destroy {:expect=>[:show]}

        @vendor.destroy
        # ORM基本操作之D
        # delete （直接刪掉）
        # destroy （會經歷一連串callback）（真的把資料刪除，救不回來，由資料庫中抹除） 
        # destroy_all(condition = nil)

        # flash[:notice] = "廠商已刪除!"
        # redirect_to admin_vendor_path # 回廠商列表頁

        # 軟刪除：廠商下面有很多訂單、商品等，直接將廠商資料用destroy方法 由資料庫抹除，會導致商品訂單沒有所屬的廠商
        # @vendor.update(deleted: True) 
        # @vendor.update(deleted_at: Time.now) # 將當下的時間寫到vendors資料表中的deleted_at欄位
        # 但這樣寫不太直覺，所以這種軟刪除的慣用手法 是 去覆寫destroy方法（去Vendor model覆寫）
        # 最好的方法是用paranoia套件，會把當下時間寫入刪除時間欄位，且讀取資料時，會直接幫你篩選出 沒有紀錄刪除時間的資料（就不用自己寫default scope（預設查詢範圍）where篩）
        # 安裝套件後，幫vendors資料表加入deleted_at欄位，並至Vendor model寫acts_as_paranoid

        redirect_to admin_vendors_path, notice: "廠商已刪除!"

        # 抓資料（before action已做，這裡直接有抓到特定廠商的實體變數可以用）
        # 刪資料
        # 跳提示
        # 重新導向頁面
    end

    private
    def vendor_params # 幫廠商資料做資料清洗（限定可通過的欄位）
        params.require(:vendor).permit(:title, :description, :online) #省略return之寫法
        # return可適時省略，會自動 回傳 最後一行 的 執行結果
        # 只允許:title, :description, :online過來
    end

    def find_vendor
        # 抓特定廠商資料
        @vendor = Vendor.find(params[:id])
        # params[:id]廠商編號
        # 撈 廠商編號為id 之 廠商資料 給 實體變數vendor
        # Vendor.find(1) 找到id = 1 的資料（出問題直接噴例外：ActiveRecor::RecordNotFound）
        # 找不到資料很常見，所以直接在ApplicationController層級做例外處理（本controller 繼承自 ApplicationController（始祖類別））

        # ORM基本操作之R
            # Candidate.first 找出第一筆候選人（物件、model、資料表中的一筆資料）資料
            # Candidate.last 找到最後一筆資料
            # Candidate.find(1) 找到id = 1 的資料（出問題直接噴例外）：在 開發模式 下 會噴 ActiveRecord::RecordNotFound，正式機 會噴500
            # Candidate.find_by(id: 1) 找到id = 1 的資料（找不到時 給nil）（undefined method `name' for nil:NilClass）（nil沒有name方法）
            # Candidate.find_by_sql("SQL語法") 
            # Candidate.first_each do |candidate|   ....  end
    end

end
