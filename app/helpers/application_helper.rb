module ApplicationHelper
  def avatar_url(user, options = { })
    style = options[:style] || :comment
    size  = options[:size]  || 32
    if user.avatar.present?
      user.avatar.url(style)
    else
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    end
  end
end
