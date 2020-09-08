require 'drb'

class ChatService
  def initialize(local_io)
    @local_io = local_io
    @users = Hash.new
  end

  def health_check
    "healthy!"
  end

  def register(uuid, name)
    @users[uuid] = name
    puts "===== 「" + name + "」さんがルームにジョインしました！！ ====="
  end

  def chat(uri, comment)
    @local_io.chat(@users[uri], comment)
  end
end

class LocalIO
  def chat(name, comment)
    puts name + ": " + comment
  end
end

io = LocalIO.new
service = ChatService.new(io)
DRb.start_service('druby://localhost:54300', service)
sleep
