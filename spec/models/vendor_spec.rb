# $ rails g rspec:model Vendor
# 會長出 專門 測model 的 測試
# 有了測試 就可以透過跑rspec來看哪裡壞掉了（可能無意間動到一些不該動的程式碼）

# Running via Spring preloader in process 83799
# create  spec/models/vendor_spec.rb
# invoke  factory_bot
# create    spec/factories/vendors.rb

# ------------------------ 
# $ rspec
# 會去 跑 spec目錄下 所有 檔名最後為_spec的檔案
# An error occurred while loading ./spec/models/vendor_spec.rb.
# Failure/Error:
#   RSpec.describe Vendor, type: :model do
#     pending "add some examples to (or delete) #{__FILE__}"
#   end

# NameError:
#   uninitialized constant Vendor ：Vendor常數尚不存在
# # ./spec/models/vendor_spec.rb:3:in `<main>'


# Finished in 0.00004 seconds (files took 2.3 seconds to load)
# 0 examples, 0 failures, 1 error occurred outside of examples


# require 'rails_helper'

# ------------------------ 
# 建立 廠商 資料表後 跑測試
# Failures:

# 1) Vendor 驗證廠商名稱 沒有填寫
# Failure/Error: expect(vendor).not_to be_valid
#   expected #<Vendor id: nil, title: nil, description: nil, online: true, created_at: nil, updated_at: nil> not to be valid
#   預期 沒填寫title欄位的話，這筆廠商資料 會 無效，然而 這筆廠商資料 卻有效，所以測試失敗 （因為還沒寫後端驗證 所以不管資料怎麼填 都可以成功寫入資料庫）
# # ./spec/models/vendor_spec.rb:72:in `block (3 levels) in <main>'
# 預設的model在沒有做任何驗證的情況下，把資料寫入是不會失敗的

# Finished in 0.02279 seconds (files took 0.76841 seconds to load)
# 6 examples, 1 failure, 4 pending

# ------------------------ 
# 廠商名稱欄位 有驗證過 要存在（model裡有寫驗證）
# *..*** 每跑一次測試就會有..，所以跑10個測試就會有10個..
# Finished in 0.01271 seconds (files took 0.74077 seconds to load)
# 6 examples, 0 failures, 4 pending

# -------------------------
# 在.rspec檔案加入 --format documentation，會讓 測試結果 格式 比較好看：
# Vendor （什麼測試）
#   驗證廠商名稱 （context）
#     有填寫 （測試項目）
#     沒有填寫
# Finished in 0.01945 seconds (files took 0.80711 seconds to load)
# 6 examples, 0 failures, 4 pending


RSpec.describe Vendor, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # pending 預計要做這件事（還沒有做）
  # 純提醒作用，只要還沒做，就會一直跳提醒

  context "驗證廠商名稱" do # 驗證廠商名稱必填
    it "有填寫" do
      vendor = Vendor.new(title: 'Hello')
      # 目前其實並無Vendor model類別，但在 測試 可以 直接假設他存在，在當作有這個model類別的情況下 去操作
      # 假設中的 vendors資料表 有title欄位（廠商名稱），並填入Hello
      expect(vendor).to be_valid # 預期 這筆廠商資料 有效
    end

    it "沒有填寫" do
      vendor = Vendor.new
      # 純粹於 vendors資料表 加上一筆廠商資料，但未於 title（廠商名稱）欄位 填入值
      expect(vendor).not_to be_valid # 預期 這筆廠商資料 無效
    end

  end

end



