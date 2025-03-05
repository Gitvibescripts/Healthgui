local Utils = {}

function Utils.getHealthStatus(health, maxHealth)
    local healthPercentage = health / maxHealth
    
    if healthPercentage <= 0.25 then
        return 1 -- Critical
    elseif healthPercentage <= 0.5 then
        return 2 -- Low
    else
        return 3 -- Healthy
    end
end

function Utils.formatNumber(number)
    return math.floor(number * 10) / 10
end

function Utils.calculateHealthBarSize(health, maxHealth, maxWidth)
    local percentage = health / maxHealth
    return UDim2.new(0, maxWidth * percentage, 1, 0)
end

return Utils

