module Tools
  def form_user_link(user, full_name = false)
    id = user.id
    first_name = user.first_name
    last_name = user.last_name

    unless full_name && last_name
      return "<a href='tg://user?id=#{id}'>#{HTML.escape(first_name)}</a>"
    end

    "<a href='tg://user?id=#{id}'>#{HTML.escape(first_name)} #{HTML.escape(last_name)}</a>"
  end
end
