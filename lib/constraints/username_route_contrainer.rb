module Constraints
  class UsernameRouteConstrainer
      def matches?(request)
          # Get our username from the route params
          username = request.params[:user_id] || request.params[:id]
          return if username.blank?
          # Check if this name exists for any users
          User.where(username: username).any?
      end
  end
end