require "tourmaline"
require "./actions.cr"
require "./tools.cr"
require "../lib/tourmaline/src/tourmaline/extra/stage.cr"

class TestBot < Tourmaline::Client
  @[Command("duel")]
  def duel_invite(ctx)
    Tools.must_be_reply(ctx) do
      target = ctx.message.reply_message.not_nil!.from.not_nil!
      user = ctx.message.from.not_nil!
      initial_context = { :wait_until => Time.utc.to_unix + 15, :target_id => ctx.message.reply_message.not_nil!.from.not_nil!.id, :declined => 0 }
      stage = DuelInvite.enter(self, chat_id: ctx.message.chat.id, context: initial_context)

      stage.on_exit do |answer|
        if answer[:declined] == 0
          #
          puts "THE DUEL HAPPENED"
          ctx.message.reply("THE DUEL HAPPENED")
          #
        else
          ctx.message.respond("#{Tools.form_user_link(target)} cowardly rejects the duel. Too bad!", parse_mode: "HTML")
        end
      end
    end
  end

  class DuelInvite(T) < Tourmaline::Stage(T)
    @[Step(:accept, initial: true)]
    def invite(client)
      client.send_message(self.chat_id, "Do you accept the duel? Answer with /yes@bkke_bot or /no@bkke_bot")
      
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

end

bot = TestBot.new(ENV["TG_API_KEY"])
bot.poll