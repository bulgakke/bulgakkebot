module Tools
  def must_be_owner(ctx, &block)
    ctx.message.from.try do |user|
      if user.id == Tools::OWNER_ID
        yield
      else
        ctx.message.reply("Sorry, only my owner can do that.")
        end
    end
  end
end
