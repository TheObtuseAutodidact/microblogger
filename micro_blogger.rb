require 'jumpstart_auth'
require 'pry'
require 'bitly'

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

  def everyones_last_tweet
    puts "tweet ** Sorry this feature needs to be updated along side the Twitter API ** tweet"
    # friends = @client.friends
    #   friends.each do |friend|
    # end
  end

  def shorten(original_url)
    Bitly.use_api_version_3
    bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
    puts "Shortening this URL: #{original_url}"
    return bitly.shorten(original_url).short_url
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
        when "elt" then everyones_last_tweet
        when "s" then shorten(parts[1])
        when "turl" then tweet parts[1..-2].join(" ") + " " + shorten(parts[-1])
        else
          puts "Sorry, I don't know how to #{command}"
      end
    end
  end

end

blogger = MicroBlogger.new
blogger.run
#tweet("Experiment: this tweet of exactly 140 characters is testing a method in my app".rjust(140, "*"))
