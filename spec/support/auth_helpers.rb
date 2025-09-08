module AuthHelpers
    def log_in_as(user)
      post login_path, params: { 
        session: { email: user.email, password: "password" } 
      }
      follow_redirect! if response.redirect?
    end
end
  