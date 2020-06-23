module Actions
  class Duel
    class Checker
      @@dead = Array(NamedTuple(user_id: Int64, chat_id: Int64, dead_until: Int64)).new

      def self.add(user_id : Int64, chat_id : Int64, seconds : Int64)
        @@dead << {user_id: user_id, chat_id: chat_id, dead_until: Time.utc.to_unix + seconds}
      end

      def self.check(message, bot_id)
        return unless Tourmaline::ChatMember.from_user(message.chat.id, bot_id).can_delete_messages

        message.from.try do |user|
          user_id = user.id
          chat_id = message.chat.id

          @@dead.each do |hash|
            next if hash[:user_id] != user_id
            next if hash[:chat_id] != chat_id

            if hash[:dead_until] >= Time.utc.to_unix
              message.delete
            else  
              @@dead.delete(hash)
            end
          end
        end
      end
    end
  end
end
