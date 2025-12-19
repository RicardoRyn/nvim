local asciiArts = require("utils.ascii_arts")

local M = {}

M.asciiImg = asciiArts.frames["static"][1]

local function getColorForStage(stageName, colors)
  if stageName == "static" then
    return colors.blue
  else
    local random = math.random()
    if random < 0.75 then
      return colors.blue
    elseif random < 0.9 then
      return colors.yellow
    else
      return colors.red
    end
  end
end

local function updateHighlightColor(color)
  vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = color, bold = true })
end

local function playStage(stageName, duration, reverse, colors, nextCallback)
  local frames = asciiArts.frames[stageName]
  local totalFrames = #frames

  require("snacks").animate(1, totalFrames + 1, function(value, _)
    local index = math.floor(value)
    if reverse then
      M.asciiImg = frames[math.max(1, totalFrames - index + 1)]
    else
      M.asciiImg = frames[math.min(index, totalFrames)]
    end

    local currentColor = getColorForStage(stageName, colors)
    updateHighlightColor(currentColor)

    Snacks.dashboard.update()

    if value >= totalFrames + 1 then
      if nextCallback then
        nextCallback()
      end
    end
  end, {
    duration = duration,
  })
end

M.theAnimation = function(callback, colors)
  playStage("static", 50, false, colors, function()
    playStage("glitch", 20, false, colors, function()
      playStage("static", 200, false, colors, function()
        playStage("glitch", 10, true, colors, function()
          playStage("static", 250, false, colors, function()
            if callback then
              M.theAnimation(callback, colors)
            end
          end)
        end)
      end)
    end)
  end)
end

return M
