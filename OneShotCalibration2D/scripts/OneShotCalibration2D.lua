
--Start of Global Scope---------------------------------------------------------

-- Delay in ms between visualization steps for demonstration purpose
local DELAY = 2000

-- Creating viewer
local viewer = View.create()

-- Text decoration object to display some feedback
local text = View.TextDecoration.create():setColor(0, 255, 0)
text:setPosition(25, 50) -- In pixels before origin is set in world coord
text:setSize(40) -- In pixels before sizes are defined in mm

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------
local function main()
  local checkerBoard = Image.load('resources/pose.bmp') -- Calibration target
  viewer:clear()
  viewer:addImage(checkerBoard)
  viewer:addText('Input image', text)
  viewer:present()
  Script.sleep(DELAY) -- For demonstration purpose only

  -- Specifying the size of a square in the world (for example 166 mm / 11 squares)
  local squareSize = 166.0 / 11 -- mm

  -- Performing a one-shot calibration
  local cameraModel, error = Image.Calibration.Pose.estimateOneShot(checkerBoard, {squareSize}, 'COORDINATE_CODE')
  print('Camera calibrated with average error: ' .. (math.floor(error * 100)) / 100 .. ' px')

  -- Undistort mode removes lens distortion effects, but keeps perspective
  local correction = Image.Calibration.Correction.create()
  correction:setUndistortMode(cameraModel, 'VALID') -- Only intrinsic parameters, and crop to inner (no black bars)
  local correctedImage = correction:apply(checkerBoard)
  viewer:clear()
  viewer:addImage(correctedImage)
  viewer:addText('Undistort mode', text)
  viewer:present()
  Script.sleep(DELAY) -- For demonstration purpose only

  -- Untilt mode removes perspective and lens distortion and converts pixels to mm
  correction:setUntiltMode(cameraModel, 'FULL') -- Remove tilt, keep all pixels (black bars)
  correctedImage = correction:apply(checkerBoard)

  -- From here positions are in mm
  text:setPosition(0, squareSize)
  text:setSize(10)

  -- Display results
  viewer:clear()
  viewer:addImage(correctedImage)
  viewer:addText('Untilt mode', text)
  viewer:present()
  Script.sleep(DELAY) -- For demonstration purpose only

  -- Align mode removes perspective and lens distortion effects and aligns to a world rectangle
  local cxy = squareSize * 6 -- Selected center point for aligned image in both x and y
  local sxy = squareSize * 13 -- Select the size of the alignment region in both x and y
  local worldRectangle = Shape.createRectangle(Point.create(cxy, cxy), sxy, sxy)
  correction:setAlignMode(cameraModel, worldRectangle)
  correctedImage = correction:apply(checkerBoard)

  viewer:addImage(correctedImage)
  viewer:addText('Align mode', text)
  viewer:present()

  print('App finished.')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
