require 'drb'
require 'securerandom'

def register_service(uri)
  DRbObject.new_with_uri(uri)
end

DRb.start_service
puts "URIを入力してください"
print '> '
uri = gets.strip
health_check = ""
until health_check == "healthy!" do
  begin
    service = register_service(uri)
    health_check = service.health_check
  rescue DRb::DRbBadURI
    puts "URIが正しくありません!!!"
    puts "URIを入力してください"
    uri = gets.strip
  end
end

name_initialized = false
until name_initialized do
  puts "チャットネームを入れてください"
  print '> '
  name = gets.strip
  puts "このチャットネームでよろしいですか？ (y/n): " + name
  print '> '
  reply = gets.strip
  name_initialized = reply.size != 0 && 'y' == reply[0].downcase
end

puts "あなたのチャットネームは" + name + "です"

uuid = SecureRandom.uuid
service.register(uuid, name)

puts "チャットルームにジョインしました \(^o^)/"
puts "（チャットの内容はサーバーサイドにのみ表示されます）"
puts "（exitと打つと終了します）"

while true do
  print '> '
  comment = gets.strip
  break if "exit" == comment
  service.chat(uuid, comment)
end

puts ""
puts "Bye...!!"
puts ""
