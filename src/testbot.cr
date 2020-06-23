require "tourmaline"
require "./actions.cr"
require "./tools.cr"

class TestBot < Tourmaline::Client
  @[Command("start")]
  def start(ctx)
    ctx.message.reply("Inline mode active")
  end

  @[OnInlineQuery()]
  def on_inline_query(ctx)
    results = InlineQueryResult.build do
      article(
        id: "swastonize",
        title: "Swastonize",
        input_message_content: InputTextMessageContent.new(message_text: Actions.swastonize(ctx.query.query), parse_mode: ParseMode::MarkdownV2),
        description: "Makes a Swaston from your text"
      )
      
      article(
        id: "alternate",
        title: "Alternate",
        input_message_content: InputTextMessageContent.new(Actions.alternate(ctx.query.query)),
        description: "AlTeRnAtEs CaSe"
      )
    end

    ctx.query.answer(results)
  end
end

bot = TestBot.new(ENV["TG_API_KEY"])
bot.poll