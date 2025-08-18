module PasswordResetsHelper
    def masked_email(email)
      name, domain = email.split('@')
      return email if name.length < 2
  
      name[0] + '***' + name[-1] + '@' + domain
    end
  
    def formatted_reset_time(time)
      time.strftime("%B %d, %Y at %I:%M %p")
    end
  end
  