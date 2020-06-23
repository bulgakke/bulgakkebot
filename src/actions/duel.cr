module Actions
  class Duel
    DEATH_TIME = 33_i64
    @chat_id : Int64

    def initialize(bot : BulgakkeBot, user : Tourmaline::User, target : Tourmaline::User, ctx : Tourmaline::CommandHandler::Context)
      @bot_status = :uninitialized
      @ctx = ctx
      @bot = bot
      @user = user
      @target = target
      @chat_id = ctx.message.chat.id

      set_bot_status
      set_the_tone

      if @user.id == @target.id
        self_duel
      elsif @target.id == bot.get_me.id
        bot_duel
      else
        normal_duel
      end
    end

    def set_bot_status
      bot_member = Tourmaline::ChatMember.from_user(@ctx.message.chat.id, @bot.get_me.id)

      if bot_member.can_restrict_members
        user_status = Tourmaline::ChatMember.from_user(@ctx.message.chat.id, @user).status
        target_status = Tourmaline::ChatMember.from_user(@ctx.message.chat.id, @target).status
        if user_status != "creator" && user_status != "administrator"
          if target_status != "creator" && target_status != "administrator"
            @bot_status = :can_mute 
            return
          end
        end
      end

      if bot_member.can_delete_messages
        @bot_status = :can_delete
        return
      end

      @bot_status = :cannot_kill
    end

    def set_the_tone
      @ctx.message.respond("Preparing illegal firearms...")
      sleep 1
      @ctx.message.respond("Loading bullets...")
      sleep 1
      @ctx.message.respond("Fire!")
      sleep 0.5
    end

    def self_duel
      text = "#{Tools.form_user_link(@user)} wants to kill themselves for some reason. All right..."
      
      kill(@user, DEATH_TIME)  
      @ctx.message.respond(text+text_add, parse_mode: "HTML")
    end

    def text_add
      if @bot_status == :cannot_kill
        return "Please pretend to be dead for a while."
      else
        return "Commencing revival... Please wait for #{DEATH_TIME} seconds."
      end
    end

    def bot_duel
      text = "#{Tools.form_user_link(@user)} thinks they can try and shoot me. Stoopid hoomans... "
      
      kill(@user, DEATH_TIME)  
      @ctx.message.respond(text+text_add, parse_mode: "HTML")
    end

    def normal_duel
      user_dead = rand(2) == 0 ? true : false
      target_dead = rand(2) == 0 ? true : false

      if user_dead && target_dead
        kill(@user, DEATH_TIME)
        kill(@target, DEATH_TIME)
        text = "#{Tools.form_user_link(@user)} and #{Tools.form_user_link(@target)} have just killed each other! Nice! "
      elsif user_dead && !target_dead
        kill(@user, DEATH_TIME)
        text = "#{Tools.form_user_link(@target)} wins! #{Tools.form_user_link(@user)} is dead now. "
      elsif !user_dead && target_dead
        kill(@target, DEATH_TIME)
        text = "#{Tools.form_user_link(@user)} wins! #{Tools.form_user_link(@target)} is dead now. "
      else
        text = "None of them landed their shots, everyone is alive. We can try again, though :3 "
      end
      text = text + text_add unless !user_dead && !target_dead
      @ctx.message.respond(text, parse_mode: "HTML")
    end

    def kill(user, seconds)
      case @bot_status
      when :can_delete
        Actions::Duel::Checker.add(user.id, @chat_id, seconds)
      when :can_mute
        @bot.restrict_chat_member(@chat_id, user, {can_send_messages: false}, until_date: Time.utc.to_unix + seconds)
      end
    end
  end
end
