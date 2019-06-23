# frozen_string_literal: true
#dota2-autochess discord bot

require 'sinatra'
require 'rbnacl/libsodium'
require 'discordrb'
require 'discordrb/webhooks'
require 'rest-client'
require 'json'
require 'dotenv/load'


require './player.rb'

p_table =   {	288604027220918272 => "76561198078021630", # "Tim" 
				398229945328992259 => "76561197988139759", # "Manu"
				421321668124868608 => "76561197983989974", # "Matze"
				398242678212657155 => "76561197966075971",# "Daniel"
				325726907922645002 => "76561198033375103", # "Roman"
				149111705031409664 => "76561197988139759", #Josef
				399183290847723530 => "76561197968282922", # Flo
				343807543652384778 => "76561197976783316" # Antonio
				}
				
				


				
def mmr2str r
	r += 1
	ut = ["Pawn", "Knight", "Bishop", "Rook", "King", "Queen"]
	uts= ["\u2659", "\u2658", "\u2657", "\u2656", "\u2654", "\u2655"]
	upper = (r / 10)
	lower = (r % 10)
	uts[upper] + " " + ut[upper] + "-" + lower.to_s
end

$bot_token = ENV['BOTTOKEN']


bot = Discordrb::Commands::CommandBot.new token: $bot_token, prefix: '!'

bot.command(:play) do |event|
    bot.voice_connect(event.user.on(event.server).voice_channel)
	event.voice.play_io(open('https://odota.github.io/media/chatwheel/dota_chatwheel_111003.mp3'))
	event.voice.destroy 
end

bot.command(:link) do |event|
	event.user.pm event.user.mention+'TODO'
end


bot.command(:list) do |event|
	event.user.pm event.user.mention+' Dieser Befehl wurde noch nicht implementiert.'
#	event.user.pm event.server.member(288604027220918272).mention+' TODO: impl !list command //wieder ein depp der versucht hat den befehl auszufuehren!'
#	event.server.member(288604027220918272).pm event.user.mention+' TODO: impl !list command //wieder ein depp der versucht hat den befehl auszufuehren!'
	c = event.channel
	r = c.delete_message(event.message)
end


WEBHOOK_URL = 'https://discordapp.com/api/webhooks/563984353592344576/0xXLgM5Fepgp_HwdxPRQZwyFECTyzm7j5zFIN4bQ_ShnR9JmpbyiFP2Nn54f7pvXcIgR'

client = Discordrb::Webhooks::Client.new(url: WEBHOOK_URL)

bot.command(:rank, channels: ["552233269412757514","563984267160322058"],  allowed_roles: ["552240698011811851","564037096659222539"]) do |event|
	
	res = JSON.parse RestClient.get "https://dotachess.xyz/player/find/?id="+p_table[event.user.id]

	event.channel.send_embed do |embed|
	  embed.colour = 0xab7dea

	  embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://dotachess.xyz/static/images/player_icons/"+ res["user_info"]["onduty_hero"].split("_")[0] +".png")
	  
	  embed.add_field(name: "Player", value: event.user.mention, inline: true)
	  embed.add_field(name: "Rank (intern)", value: "`todo`", inline: true)
	  embed.add_field(name: "Level", value: mmr2str( res["user_info"][ "mmr_level"] ), inline: true)
	  embed.add_field(name: "Candy", value: res["user_info"]["candy"].to_s, inline: true)
	end
	
	client.execute do |builder|
  builder.content = 'Hello world!'
  builder.add_embed do |embed|
	  embed.colour = 0xab7dea

	  embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://dotachess.xyz/static/images/player_icons/"+ res["user_info"]["onduty_hero"].split("_")[0] +".png")

	end
	  builder.add_embed do |embed|
	  embed.colour = 0xab7dea

	  embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://dotachess.xyz/static/images/player_icons/"+ res["user_info"]["onduty_hero"].split("_")[0] +".png")
	end
	end
	
end




bot.command(:release, channels: ["552233269412757514"],  required_roles: ["552240698011811851","398234793936158720"]) do |event|
	
	event.channel.send_embed("In diesem Channel k\u00f6nnt ihr euren Dota2 AutoChess Rank abfragen!") do |embed|
	  embed.title = "D2Chess Bot ```Release``` "
	  embed.colour = 0xff0000
	  embed.url = "https://dota2-autochess.herokuapp.com/"
	  embed.description = "Falls der Bot 30 Minuten lang nicht benutzt wurde legt er sich schlafen und kann \u00fcber diesen Link wieder geweckt werden:\n[wake up!](https://dota2-autochess.herokuapp.com/)"
	  embed.timestamp = Time.at(1551905193)

	  embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://cdn.discordapp.com/attachments/552233269412757514/552410356287275008/Dota-Auto-Chess-Dota-2.jpeg")
	  embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "Tim Herold", icon_url: "https://cdn.discordapp.com/avatars/288604027220918272/581aa8a6de1936adb3d6c22d14d1074f.png")
	  embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "version 0.2", icon_url: "https://cdn.discordapp.com/attachments/552233269412757514/552410356287275008/Dota-Auto-Chess-Dota-2.jpeg")

	  embed.add_field(name: "Befehl", value: "!rank\n!link StemID64\n!list\n!release", inline: true)
	  embed.add_field(name: "Beschreibung", value: "Gibt dein Rank aus.\nVerbindet Discord mit Steam.\nZeigt interne Rangliste an.\n`Admin only`", inline: true)
	end
end


bot.command(:clean) do |event, amount|
	break unless event.user.id == 288604027220918272 # nur Tim
	c = event.channel
	r = c.delete_messages(c.history(amount.succ))
	event.user.pm "Es wurden #{r} Nachrichten geloescht!"
end


bot.command(:ping) do |event|
	event.respond 'Pong!'
end
bot.command(:pong) do |event|
	event.respond 'Ping!'
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




