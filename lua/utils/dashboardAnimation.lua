local M = {}

local asciiArts = require("utils.ascii_arts")

M.asciiImg = asciiArts.frames["static"][1]

local function updateHighlightColor(color)
  vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = color, bold = true })
end

local function getColorForStage(stageName)
  if stageName == "static" then
    return "#1E66F5"
  else
    local random = math.random()
    if random < 0.75 then
      return "#1E66F5"
    elseif random < 0.9 then
      return "#DF8E1D"
    else
      return "#D20F39"
    end
  end
end

local function playStage(stageName, duration, reverse, nextCallback)
  local frames = asciiArts.frames[stageName]
  local totalFrames = #frames

  require("snacks").animate(1, totalFrames + 1, function(value, _)
    local index = math.floor(value)
    if reverse then
      M.asciiImg = frames[math.max(1, totalFrames - index + 1)]
    else
      M.asciiImg = frames[math.min(index, totalFrames)]
    end

    local currentColor = getColorForStage(stageName)
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

M.theAnimation = function(callback)
  playStage("static", 50, false, function()
    playStage("glitch", 20, false, function()
      playStage("static", 200, false, function()
        playStage("glitch", 10, true, function()
          playStage("static", 250, false, function()
            if callback then
              M.theAnimation(callback)
            end
          end)
        end)
      end)
    end)
  end)
end

return M
