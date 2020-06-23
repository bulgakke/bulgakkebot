module Tools
  def must_be_reply(ctx, &block)
    if ctx.message.reply_message
      yield
    else
      ctx.message.reply("Use this as a reply to someone's message.")
    end
  end
end

