require "tourmaline"

class ClearBot < Tourmaline::Client
  @[Command("start")]
  def start(ctx)
    ctx.message.respond("Maintenance mode enabled")
  end
end

bot = ClearBot.new(ENV["TG_API_KEY"])
bot.poll