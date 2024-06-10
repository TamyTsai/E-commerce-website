class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # See https://github.com/omniauth/omniauth/wiki/FAQ#rails-session-is-clobbered-after-callback-on-developer-strategy
    skip_before_action :verify_authenticity_token, only: :facebook
  
    def google_oauth2
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env["omniauth.auth"])
  
      if @user.persisted? # 若使用者已經存在，就登入且轉址
        sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
      else
        session["devise.google_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
        # 要用什麼名字來存放session（可隨便取）
        redirect_to new_user_registration_url
      end
    end
  
    def failure # 失敗就會回首頁
      redirect_to root_path
    end
  end

# https://github.com/heartcombo/devise/wiki/OmniAuth%3A-Overview
# Now we just add the file app/controllers/users/omniauth_callbacks_controller.rb:
# class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
# end
# The callback should be implemented as an action with the same name as the provider. Here is an example action for our facebook provider that we could add to our controller:
# class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
#   # See https://github.com/omniauth/omniauth/wiki/FAQ#rails-session-is-clobbered-after-callback-on-developer-strategy
#   skip_before_action :verify_authenticity_token, only: :facebook

#   def facebook
#     # You need to implement the method below in your model (e.g. app/models/user.rb)
#     @user = User.from_omniauth(request.env["omniauth.auth"])

#     if @user.persisted?
#       sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
#       set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
#     else
#       session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
#       redirect_to new_user_registration_url
#     end
#   end

#   def failure
#     redirect_to root_path
#   end
# end

# 在google develop console的憑證 設定已授權的URI
# 同意以第三方平台登入後 要轉址的路徑： /users/auth/google_oauth2/callback
# user_google_oauth2_omniauth_authorize   GET|POST   /users/auth/google_oauth2(.:format)                      users/omniauth_callbacks#passthru
# user_google_oauth2_omniauth_callback   GET|POST   /users/auth/google_oauth2/callback(.:format)              users/omniauth_callbacks#google_oauth2
# google可以放本機端網址，fb不行