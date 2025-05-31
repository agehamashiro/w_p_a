class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      Rails.logger.info ">>> google_oauth2 callback called!"
  
      auth = request.env['omniauth.auth']
      Rails.logger.info "Auth info: #{auth.inspect}"
  
      @user = User.from_omniauth(auth)
  
      if @user.persisted?
        Rails.logger.info "User found or created: #{@user.email}"
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
      else
        Rails.logger.warn "User NOT persisted. Registration needed."
        session['devise.google_data'] = auth.except(:extra)
        redirect_to new_user_registration_url, alert: 'Googleログインに失敗しました'
      end
    end
  end