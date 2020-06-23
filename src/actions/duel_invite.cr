module Actions
  class Duel
    class Invite
      def initialize(ctx)
        ctx.message.reply_message.try do |target_message|
          target_message.from.try do |target|
            target_message.reply("Do you accept the duel?")
            
          end
        end
      end
    end
  end
end
