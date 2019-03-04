# frozen_string_literal: true
#dota2-autochess discord bot

require 'rest-client'
require 'discordrb'
require 'dotenv/load'
require 'sinatra'

require './player.rb'

$bot_token = ENV['BOTTOKEN']



bot = Discordrb::Commands::CommandBot.new token: $bot_token, prefix: '!'

bot.command(:rank) do |event|
	event.user.pm event.user.mention+'TODO'
	event.respond event.user.mention+'TODO: Pawn-1'
end


bot.command(:ping) do |event|
	event.respond 'Pong!'
end
bot.command(:pong) do |event|
	event.respond 'Pong!'
end

bot.command(:eval, help_available: false) do |event, *code|
  puts 'eval' + code.join(' ')
  break unless event.user.id == 288604027220918272 # Replace number with your ID

  begin
    eval code.join(' ')
  rescue StandardError
    'An error occurred 😞'
  end
end




bot.run(true)

get '/' do
  redirect bot.invite_url
end

get '/stop/bot' do
  puts "Stoppe Bot!"
  bot.kill
end

get '/start/bot' do
  puts "Starte Bot!"
  bot.run(true)
  redirect bot.invite_url
end





#bot2 = Discordrb::Commands::CommandBot.new token: ENV['BOTTOKEN'], prefix: '!'
=begin






#c_embed = { url: 'https://dotachess.xyz/', title: 'Dota 2 Auto Chess Rank', type: 'link'.to_sym, description: 'desc', color: '3447003'}
#m_embed Discordrb::Embed.new( c_embed, 'message data')

bot.message(content: '!ping') do |event|
  event.respond 'Pong!'
#  res = RestClient.get 'https://dotachess.xyz/player/rank/?id=76561197988139759'
#  event.respond res.body
#  event.respond m_embed

puts event.user.inspect

event.channel.send_embed do |embed|
  embed.colour = 0x19196f
  embed.url = "https://discordapp.com"
  embed.timestamp = Time.at(1551453042)

  embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://dotachess.xyz/static/images/player_icons/h133.png")
  embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "Tim Herold", icon_url: "https://cdn.discordapp.com/embed/avatars/0.png")
  embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "last update", icon_url: "https://dotachess.xyz/static/favicon.ico")

  embed.add_field(name: "Name", value: "POLYLUX1337")
  embed.add_field(name: "Rank", value: " KNIGHT-2 ~~(1 MMR)~~", inline: true)
  embed.add_field(name: "Candy", value: "34", inline: true)
  embed.add_field(name: "Matches", value: "134", inline: true)
  embed.add_field(name: "Avatars", value: "`!!todo`", inline: true)
end

end

bot.run





#bot2.run
=end




