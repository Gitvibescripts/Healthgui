local Config = require(script.Parent.Config)
local Utils = require(script.Parent.Utils)

local StatusManager = {}

function StatusManager.new()
    local self = {}
    
    function self.updateStatus(statusText, health, maxHealth)
        local status = Utils.getHealthStatus(health, maxHealth)
        statusText.Text = Config.STATUS_TEXTS[status]
        statusText.TextColor3 = Config.HEALTH_COLORS[status]
    end
    
    function self.updatePlayerInfo(nameLabel, player)
        local displayName = player.DisplayName
        local userName = player.Name
        
        if displayName ~= userName then
            nameLabel.Text = string.format("%s (@%s)", displayName, userName)
        else
            nameLabel.Text = userName
        end
    end
    
    return self
end

return StatusManager

