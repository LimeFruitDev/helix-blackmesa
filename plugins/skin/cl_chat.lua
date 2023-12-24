
chat.enableSound = chat.enableSound or ix.option.Get("enableChatSound", true)

function chat.PlaySound()
	if chat.enableSound then
		chat.sound = chat.sound == 1 and 2 or 1
		surface.PlaySound("limefruit/chat" .. chat.sound .. ".wav")
	end
end
