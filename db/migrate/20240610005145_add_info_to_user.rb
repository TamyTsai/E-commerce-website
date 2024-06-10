# $ rails g migration add_info_to_user
# 為了要存放從omniauth打回來收到的name與image（model user.rb），所以要來這裡新增 名字 與 頭貼 欄位

class AddInfoToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_column :users, :avatar, :string # 放照片「路徑」，所以是字串
  end
end