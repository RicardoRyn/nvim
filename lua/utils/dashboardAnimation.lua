local M = {}

local asciiArts = require("utils.ascii_arts")

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
  local sequence = {
    { stage = "static", duration = 50, reverse = false },
    { stage = "glitch", duration = 20, reverse = false },
    { stage = "static", duration = 200, reverse = false },
    { stage = "glitch", duration = 10, reverse = true },
    { stage = "static", duration = 250, reverse = false },
  }

  local function playSequence(index)
    if index > #sequence then
      if callback then
        M.theAnimation(callback, colors)
      end
      return
    end

    local current = sequence[index]
    playStage(current.stage, current.duration, current.reverse, colors, function()
      playSequence(index + 1)
    end)
  end

  playSequence(1)
end

return M
