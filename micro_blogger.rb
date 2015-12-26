require 'jumpstart_auth'
require 'pry'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing MicroBlogger"
    @client = JumpstartAuth.twitter
  end

  def followers_list
    screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name.downcase }
  end

  def spam_my_followers(message)
    followers_list.each  { |follower| dm(follower, message) }
  end


  def tweet(message)
    if message.length <= 140
      @client.update(message)
    else
      puts "Warning: Message > 140 characters. This will not post to Twitter."
    end
  end

  def dm(target, message)
    puts "Trying to send #{target} this direct message:"
    screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name.downcase } #added downcase to render case insensitive
    if screen_names.include?(target)
      puts message
      message = "d @#{target} #{message}"
      tweet(message)
    else
      puts "Sorry, you can only DM people who follow you."
    end
  end

  def run
    puts "Welcome to the JSL Twitter CLient!"
    command = ''
    while command != "q"
      printf "enter command: "
      input = gets.chomp
      parts = input.split
      command = parts[0]
      case command
        when "q" then puts "Goodbye!"
        when "t" then tweet parts[1..-1].join(" ")
        when "dm" then dm(parts[1], parts[2..-1].join(" "))
        when "spam" then spam_my_followers parts[1..-1].join(" ")
        else
          puts "Sorry, I don't know how to #{command}"
      end
    end
  end

end

blogger = MicroBlogger.new
blogger.run
#tweet("Experiment: this tweet of exactly 140 characters is testing a method in my app".rjust(140, "*"))
