
function PLUGIN:GetHungerText(hunger)
	if (hunger <= 30) then
		return "Satisfied", Color(34, 125, 34, 255)
	elseif (hunger <= 50) then
		return "Slightly Hungry", Color(2, 69, 51, 255)
	elseif (hunger <= 65) then
		return "Hungry", Color(155, 155, 0, 255)
	elseif (hunger <= 80) then
		return "Very Hungry", Color(155, 40, 0, 255)
	elseif (hunger <= 99) then
		return "Starving", Color(155, 80, 0, 255)
	elseif (hunger <= 100) then
		return "Dying of starvation", Color(155, 0, 0, 255)
	end

	return "Unknown", Color(255, 255, 255, 255)
end

function PLUGIN:GetThirstText(thirst)
	if (thirst <= 30) then
		return "Satisfied", Color(34, 125, 34, 255)
	elseif (thirst <= 50) then
		return "Slightly Thirsty", Color(2, 69, 51, 255)
	elseif (thirst <= 65) then
		return "Thirsty", Color(155, 155, 0, 255)
	elseif (thirst <= 80) then
		return "Very Thirsty", Color(155, 40, 0, 255)
	elseif (thirst <= 99) then
		return "Dehydrated", Color(155, 80, 0, 255)
	elseif (thirst <= 100) then
		return "Dying of dehydration", Color(155, 0, 0, 255)
	end

	return "Unknown", Color(255, 255, 255, 255)
end
