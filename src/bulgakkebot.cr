require "tourmaline"
require "./actions.cr"

class BulgakkeBot < Tourmaline::Client
  @[Command("start")]
  def start(ctx)
    ctx.message.reply("Вечер в палату, пациенты!")
  end

  @[Command("alternate")]
  def alternate(ctx)
    ctx.message.reply_message.try do |target|
      target.text.try do |target_text|
        text = Actions.alternate(target_text)
        target.reply(text)
      end
    end
  end

  @[Command("greet")]
  def greet(ctx)
    ctx.message.from.try do |user|
      ctx.message.reply("Hello, #{user.first_name}")
    end
  end

  

end

bot = BulgakkeBot.new(ENV["TG_API_KEY"])
bot.poll