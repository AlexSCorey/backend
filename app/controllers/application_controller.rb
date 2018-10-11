class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
   
    helper_method :current_user
    helper_method :admin_user
    helper_method :owner
    helper_method :manager

    private

    def admin_user
        @calendar.users.owners.include?(current_user) || @calendar.users.managers.include?(current_user)
    end

    def owner
        @calendar.users.owners.include?(current_user)
    end

    def manager
        @calendar.users.managers.include?(current_user)
    end

    def current_user
        authenticate_with_http_token do |token, options|
            
            return User.find_by_api_token(token)
        end
    end
end
