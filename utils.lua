local utils = {}

function utils.shuffleTable(temp)
	local n = table.getn(temp)
		
	for i = 1, n do
		local k = math.random(n)
		temp[n], temp[k] = temp[k], temp[n]
		n = n - 1
	end
		
	return temp
end

return utils
