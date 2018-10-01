class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
   
    helper_method :current_user





    private

    def current_user
        authenticate_with_http_token do |token, options|
            
            return User.find_by_api_token(token)
        end
    end
end
