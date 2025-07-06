OnAnyLoad
{
	function( triggerArgs )

		local objId = CreateScreenObstacle({ Name = "rectangle01", X = 600, Y = 300 })
		SetColor({ Id = objId, Color = {0, 0, 0, 0} })

		local logBoxes = {}
		local count = 0

		-- CreateTextBox({
		-- 	Id = objId,
		-- 	Text = "first block 12",
		-- 	FontSize = 10,
		-- 	Color = {1, 1, 1, 1},
		-- 	Justification = "Left",
		-- OffsetX = -100,
		-- OffsetY = -130,
		-- })

		function logToFile(message)
			local logMessage = string.format("%s\n", message)
			local file, err = io.open('C:\\Program Files (x86)\\Steam\\steamapps\\common\\Hades\\Content\\ScriptsNmaLog.log', "a")
			if file then
				file:write(logMessage)
				file:close()
			else
				ShowNewLog("无法写入日志:", err)
			end
		end

		function ShowNewLog(content)
			local newId = CreateScreenObstacle({ Name = "rectangle01" })
			SetScaleX({ Id = newId, Fraction = 500 / 300 })
			SetScaleY({ Id = newId, Fraction = 20 / 267 })
			SetColor({ Id = newId, Color = {0.5, 0.5, 0.5, 0.2 }})

			CreateTextBox({
				Id = newId,
				Text = content,
				FontSize = 10,
				Color = {1, 1, 1, 1},
				Justification = "Left",
				OffsetX = -280
			})
			table.insert(logBoxes, newId)

			while (#logBoxes > 20) do
				Destroy({ Ids = { table.remove(logBoxes, 1) } })
			end

			for i=1,#logBoxes do
				Attach({ Id = logBoxes[i], DestinationId = objId, OffsetY = 25*i })
			end

		end

		function safeConcat(t, sep)
			local result = {}
			local n = 0
			
			for _, v in ipairs(t) do
				if v ~= nil then
					n = n + 1
					result[n] = tostring(v)
				end
			end
			
			return table.concat(result, sep or ", ")
		end

		ShowNewLog("Logs (" .. objId .. "):")

		function OnChooseLoot(eligibleLootNames, newLootName)
			if (eligibleLootNames) then
				ShowNewLog("ChooseLoot: " .. safeConcat(eligibleLootNames, ", ") .. "  -> " .. newLootName)
			else
				ShowNewLog("ChooseLoot: empty loot list")
			end
			-- ModifyTextBox({ Id = objId, Text = table.concat(NmaLogContent, "\r\n") });
		end

		function OnGetReward( rewardName )
			ShowNewLog("Reroll: " .. rewardName)
		end

		function NmaLog(content)
			local log = tostring(content)
			ShowNewLog('info: ' .. log)
		end
	end
}