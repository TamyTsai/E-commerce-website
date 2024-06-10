# $ rails g migration AddOmniauthToUsers provider:string uid:string
# 對現存Users資料表 新增 串接第三方登入資訊（Oauth開放授權） 之 欄位
# AddOmniauthTo...  Rails 會自動猜你要加欄位到...資料表

class AddOmniauthToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :provider, :string # 對 現存Users資料表 新增 provider（使用者透過哪個第三方登入） 欄位，資料型態為字串
    add_column :users, :uid, :string # 對 現存Users資料表 新增 uid（使用者在該第三方平台的 唯一識別碼） 欄位，資料型態為字串
  end
end


# $ rails db:migrate
# == 20240609232110 AddOmniauthToUsers: migrating ===============================
# -- add_column(:users, :provider, :string)
# -> 0.0023s
# -- add_column(:users, :uid, :string)
# -> 0.0006s
# == 20240609232110 AddOmniauthToUsers: migrated (0.0030s) ======================
