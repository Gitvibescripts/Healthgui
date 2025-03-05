local TweenService = game:GetService("TweenService")
local Config = require(script.Parent.Config)

local AnimationHandler = {}

function AnimationHandler.new()
    local self = {}

    function self.tweenHealthBar(healthBar, targetSize)
        local tweenInfo = TweenInfo.new(
            Config.TWEEN_SPEED,
            Config.TWEEN_STYLE,
            Config.TWEEN_DIRECTION
        )

        local tween = TweenService:Create(healthBar, tweenInfo, {
            Size = targetSize
        })
        tween:Play()
        return tween
    end

    function self.tweenColor(object, targetColor)
        local tweenInfo = TweenInfo.new(
            Config.TWEEN_SPEED,
            Config.TWEEN_STYLE,
            Config.TWEEN_DIRECTION
        )

        local tween = TweenService:Create(object, tweenInfo, {
            BackgroundColor3 = targetColor
        })
        tween:Play()
        return tween
    end

    function self.tweenTransparency(object, targetTransparency)
        local tweenInfo = TweenInfo.new(
            Config.TWEEN_SPEED,
            Config.TWEEN_STYLE,
            Config.TWEEN_DIRECTION
        )

        local tween = TweenService:Create(object, tweenInfo, {
            BackgroundTransparency = targetTransparency
        })
        tween:Play()
        return tween
    end

    function self.pulseAnimation(object)
        local tweenInfo = TweenInfo.new(
            0.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1, -- Infinite repeats
            true -- Reverse
        )

        local tween = TweenService:Create(object, tweenInfo, {
            TextTransparency = 0.5
        })
        tween:Play()
        return tween
    end

    return self
end

return AnimationHandler
