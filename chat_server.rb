require 'drb'

class ChatService
  def initialize(stub)
    @local_stub = stub
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
    @local_stub.chat(@users[uri], comment)
  end
end

class Stub
  def chat(name, comment)
    puts name + ": " + comment
  end
end

stub = Stub.new
service = ChatService.new(stub)
DRb.start_service('druby://localhost:54300', service)
sleep
