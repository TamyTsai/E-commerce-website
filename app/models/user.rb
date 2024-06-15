class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  
  has_many :orders
  # 每個使用者 可有多筆訂單

  
  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
    # find_or_create_by(provider: auth.provider, uid: auth.uid)： 用provider及uid欄位當查詢條件，找不到就用猜的，找第一個或建新的
      user.email = auth.info.email # 從omniauth打回來收到的email
      user.password = Devise.friendly_token[0, 20] # 隨便給一組密碼
      user.name = auth.info.name   # assuming the user model has a name 名字，將從omniauth打回來收到的name，塞到users資料表中的name欄位
      user.avatar = auth.info.image # assuming the user model has an image 大頭照，將從omniauth打回來收到的image（圖片路徑），塞到users資料表中的avatar欄位
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

end

# https://github.com/heartcombo/devise/wiki/OmniAuth%3A-Overview
# After configuring your strategy, you need to make your model (e.g. app/models/user.rb) omniauthable:
# devise :omniauthable, omniauth_providers: %i[facebook]

# After the controller is defined, we need to implement the from_omniauth method in our model (e.g. app/models/user.rb):
# def self.from_omniauth(auth)
#     find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
#       user.email = auth.info.email
#       user.password = Devise.friendly_token[0, 20]
#       user.name = auth.info.name   # assuming the user model has a name
#       user.image = auth.info.image # assuming the user model has an image
#       # If you are using confirmable and the provider(s) you use validate emails, 
#       # uncomment the line below to skip the confirmation emails.
#       # user.skip_confirmation!
#     end
#   end