class PasswordController < ApplicationController

    def forgot
        @user = User.find_by(email: params[:email])
        if @user.present? 
            @user.generate_password_token!
            UserMailer.with(user: @user).forgot_password.deliver_now
            render json: ('Reset password email sent.'), status: :ok
        else
            render json: ('Email not found.'), status: :unauthorized
        end
    end


    def reset
        token = params[:token].to_s
        @user = User.find_by(reset_password_token: token)
        if @user.present? && @user.password_token_valid?
            if @user.reset_password!(params[:password])
                render json: ("Password successfully changed."), status: :ok
            else
                render json: user.errors, status: :unprocessable_entity
            end
        else
            render json: ("Link not valid or expired, try generating new link"), status: :unauthorized
        end
    end
end
