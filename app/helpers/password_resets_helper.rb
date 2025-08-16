module PasswordResetsHelper
    # Optional: mask part of the user's email for privacy
    def masked_email(email)
        name, domain = email.split("@")
        masked_name = name[0] + "***" + name[-1]
        "#{masked_name}@#{domain}"
    end

    # Optional: format timestamp for reset_sent_at
    def formatted_reset_time(time)
        time.strftime("%B %d, %Y at %I:%M %p")
    end
end
