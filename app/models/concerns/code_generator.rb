# 模組名稱 與 檔案名稱 要對應
module CodeGenerator
    extend ActiveSupport::Concern

    # Rails 有提供 Concern 的功能，可以把「共同的行為」集中起來，有需要的再「引入」，而不使用繼承。就是「不要為了想要會飛就去當鳥的小孩」的概念
    # 其實 Concern 就是 Ruby 裡 Module 的概念

    included do # 引入本模組者 就會自動執行以下程式碼
        extend FriendlyId # 擴充 FriendlyId模組 中的方法，變成 類別方法（Product類別 的 方法）
        # friendly_id :name, use: :slugged
        # 用name欄位 產生slug，預設寫入 slug欄位
        friendly_id :code_generator, use: :slugged, slug_column: :code
        # 用code_generator方法產生slug，寫入 code欄位
        # friendly id功能不只商品會用到，廠商等也會用到，所以將 整段程式碼 整理到concerns，讓程式碼可以不用重覆寫，提升再用性
        # 想要使用friendly id的資料，就新增code欄位，並include此模組
    end

    private # 模組也是一種類別 所以也有private方法可以用

    def code_generator
      SecureRandom.hex(10) # 隨機跳20碼16進位數字
      # 最多有16的20次方數字組合可用（可以在rails c 用 16 ** 20 來算出16的20次方）  
      # rails c
        # [1] pry(main)> SecureRandom.hex(5) 隨機跳10碼16進位數字
        # => "9801b8a884"
        # [2] pry(main)> SecureRandom.hex(6) 隨機跳12碼16進位數字
        # => "663d6af0c30a"
        # [3] pry(main)> SecureRandom.hex(7) 隨機跳14碼16進位數字
        # => "9265190fc59d95"
    end
    # friendly id功能不只商品會用到，廠商等也會用到，所以將 整段程式碼 整理到concerns，讓程式碼可以不用重覆寫，提升再用性

end


# module Profileable
#   extend ActiveSupport::Concern # extend ActiveSupport::Concern 這個 內建模組
#   extend 這個模組後 就會有幾個特異功能

#   included do  # included do ... end 裡面放的是 當這個 Module （Profileable）被 include（引入） 的時候會做的事。（自動設定has_one 與 before_create）
#     has_one :profile
#     before_create :encrypt_user_password
#   end

#   module ClassMethods  # ClassMethod 這個 Module 裡面可以定義 方法，但 定義的方法 在 被include 之後 會變成 類別方法。
#   end

#   def show_gender  # show_gender 方法被 include 之後就會變成 該類別的 實體方法。
#     if gender == 1
#       "男"
#     else
#       "女 "
#     end
#   end

#   private
#   def encrypt_user_password
#     # 對使用者輸入的密碼加密...
#   end
# end