require "tourmaline"
require "./actions.cr"
require "./tools.cr"
require "../lib/tourmaline/src/tourmaline/extra/stage.cr"

class BulgakkeBot < Tourmaline::Client
  @[On(:message, group: :dead)]
  def check_dead(ctx)
    ctx.message.try do |message|
      Actions::Duel::Checker.check(message, get_me.id)
    end
  end

  @[Command("swaston")]
  def swastonize(ctx)
    if ctx.text.size <= 10
      ctx.message.reply(Actions.swastonize(ctx.text), parse_mode: "MarkdownV2")
    else
      ctx.message.reply("Your text is too long")
    end
  end

  @[Command("duel")]
  def duel_invite(ctx)
    unless ctx.message.reply_message
      ctx.message.reply("Use this as a reply to someone's message.")
      return
    end

    ctx.message.reply_message.try do |target_message|
      target_message.from.try do |target|
        ctx.message.from.try do |user|
          initial_context = { :target_message => target_message.message_id, :wait_until => Time.utc.to_unix + 15, :target_id => target.id, :declined => 0 }
          stage = DuelInvite.enter(self, chat_id: ctx.message.chat.id, context: initial_context)

          stage.on_exit do |answer|
            if answer[:declined] == 0
              Actions::Duel.new(self, user, target, ctx)
            else
              ctx.message.respond("#{Tools.form_user_link(target)} cowardly rejects the duel. Too bad!", parse_mode: "HTML")
            end
          end
        end
      end
    end
  end

  class DuelInvite(T) < Stage(T)
    @[Step(:accept, initial: true)]
    def invite(client)
      client.send_message(self.chat_id, "Do you accept the duel? Answer with /yes@bkke_bot or /no@bkke_bot", reply_to_message: context[:target_message])
      
      self.await_response do |update|
        text = update.message.try &.text
        if message = update.message
          message.from.try do |potential_target|
            if (text == "/yes@bkke_bot" && potential_target.id == context[:target_id]) || Time.utc.to_unix >= context[:wait_until] 
              self.exit
            elsif text == "/no@bkke_bot" && potential_target.id == context[:target_id]
              context[:declined] = 1
              self.exit
            end
          end
        end
      end
    end
  end

  @[Command("run_code_rb")]
  def run_code_rb(ctx)
    Tools.must_be_owner(ctx) do 
      if ctx.message.reply_message
        code = ctx.message.reply_message.not_nil!.text
      else
        code = ctx.text
      end

      result = code ? Actions.run_code_rb(code) : "Something went wrong"
      ctx.message.reply("```\n#{result}```", parse_mode: ParseMode::MarkdownV2)
    end
  end

  @[Command("run_code_cr")]
  def run_code_cr(ctx)
    Tools.must_be_owner(ctx) do 
      if ctx.message.reply_message
        code = ctx.message.reply_message.not_nil!.text
      else
        code = ctx.text
      end

      result = code ? Actions.run_code_cr(code) : "Something went wrong"
      ctx.message.reply("```\n#{result}```", parse_mode: ParseMode::MarkdownV2)
    end
  end

  @[Command("start")]
  def start(ctx)
    ctx.message.reply("Вечер в палату, пациенты!")
  end

  @[Command("about")]
  def about(ctx)
    ctx.message.reply("Language used: <a href='https://crystal-lang.org/'>Crystal</a> 
Framework used: <a href='https://tourmaline.dev/'>Tourmaline</a>
Easy step-by-step guide: <a href='https://youtu.be/dQw4w9WgXcQ'>YouTube</a>
Source code: <a href='https://github.com/bulgakke/bulgakkebot'>Github</a>", parse_mode: "HTML")
  end

  @[Command("alternate")]
  def alternate(ctx)
    ctx.message.reply_message.try do |target_message|
      target_message.text.try do |target_text|
        text = Actions.alternate(target_text)
        target_message.reply(text)
      end
    end
  end
end

bot = BulgakkeBot.new(ENV["TG_API_KEY"])
bot.poll
