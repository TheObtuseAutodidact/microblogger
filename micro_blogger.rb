require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing MicroBlogger"
    @client = JumpstartAuth.twitter
  end

  def tweet(message)
    if message.length <= 140
      @client.update(message)
    else
      puts "Warning: Message > 140 characters. This will not post to Twitter."
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
        else
          puts "Sorry, I don't know how to #{command}"
      end
    end
  end

end

blogger = MicroBlogger.new
blogger.run
#tweet("Experiment: this tweet of exactly 140 characters is testing a method in my app".rjust(140, "*"))
