local Config = {
    -- Health Bar Settings
    MAX_HEALTH = 100,
    BAR_WIDTH = 300,
    BAR_HEIGHT = 20,
    CORNER_RADIUS = UDim.new(0, 8),

    -- Colors
    HEALTH_COLORS = {
        [1] = Color3.fromRGB(255, 59, 59),  -- Critical
        [2] = Color3.fromRGB(255, 162, 59), -- Low
        [3] = Color3.fromRGB(130, 255, 59)  -- Healthy
    },
    OUTLINE_COLOR = Color3.fromRGB(255, 255, 255),

    -- Status Text
    STATUS_TEXTS = {
        [1] = "CRITICAL",
        [2] = "LOW HEALTH",
        [3] = "HEALTHY"
    },

    -- Animation Settings
    TWEEN_SPEED = 0.3,
    TWEEN_STYLE = Enum.EasingStyle.Quad,
    TWEEN_DIRECTION = Enum.EasingDirection.Out,

    -- UI Positioning
    SCREEN_OFFSET = UDim2.new(0, 20, 0, 20),
}

return Config
