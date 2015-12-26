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

end

blogger = MicroBlogger.new
blogger.tweet("Experiment: this tweet of exactly 140 characters is testing a method in my app".rjust(140, "*"))
