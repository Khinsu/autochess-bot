class Player

	@discord_id = -1
	@name = ""
	@steam_id = -1

  
	def initialize(discord_id, name, steam_id)
		@discord_id = discord_id
		@name = name
		@steam_id = steam_id
	end  
	
	def discord2steam id
		@steam_id if @discord_id == id
		nil
	end
	
	def steam2discord id
		@discord_id if @steam_id == id
		nil
    end

end