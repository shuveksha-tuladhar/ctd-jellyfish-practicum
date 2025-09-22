module ApplicationHelper
    def color_for_user(user_id)
      colors = [
        "#1d917a", "#2a9d8f", "#264653", "#6cae75","#4d908e", "#8ab17d", "#9c89b8", "#577590"
      ]
      colors[user_id % colors.size] 
    end
end
