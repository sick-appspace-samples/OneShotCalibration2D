--[[----------------------------------------------------------------------------

  Application Name:
  OneShotCalibration2D

  Summary:
  Camera calibration using one shot of checkerboard target and various correction modes

  Description:
  Calibrating a camera using one shot of a checkerboard calibration target.
  Correcting the image by rectification using different correction modes.
  OneShot calibration makes a calibration model that is valid within
  the plane of the calibration target. The model produced can typically
  not be used for other things than measurements within this plane.

  How to Run:
  Starting this sample is possible either by running the app (F5) or
  debugging (F7+F10). Setting breakpoint on the first row inside the 'main'
  function allows debugging step-by-step after 'Engine.OnStarted' event.
  Results can be seen in the image viewer on the DevicePage.
  To run this sample a device with SICK Algorithm API is necessary.
  For example InspectorP or SIM4000 with latest firmware. Alternatively the
  Emulator on AppStudio 2.2 or higher can be used. The images can be seen in the
  image viewer on the DevicePage.

  More Information:
  Tutorial "Algorithms - Calibration2D".

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------

-- Delay in ms between visualization steps for demonstration purpose
local DELAY = 2000

-- Creating viewer
local viewer = View.create()
viewer:setID('viewer2D')

-- Creating header text and decoration attributes
local text = View.TextDecoration.create()
text:setPosition(25, 25) -- In pixels before origin is set in world coord
text:setSize(40) -- In pixels before sizes are defined in mm
text:setColor(0, 255, 0)

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  local checkerBoard = Image.load('resources/pose.bmp') -- Calibration target
  viewer:view(checkerBoard)
  Script.sleep(DELAY) -- For demonstration purpose only

  -- Specifying the size of a square in the world (for example 166 mm / 11 squares)
  local squareSize = 166.0 / 11 -- mm

  -- Performing a one-shot calibration
  local cameraModel, error = Image.Calibration.Pose.estimateOneShot(checkerBoard, {squareSize}, 'COORDINATE_CODE')
  print('Camera calibrated with average error: ' .. (math.floor(error * 10)) / 10 .. ' px')

  -- Undistort mode removes lens distortion effects, but keeps perspective
  local correction = Image.Calibration.Correction.create()
  correction:setUndistortMode(cameraModel, 'VALID') -- Only intrinsic parameters
  local correctedImage = correction:apply(checkerBoard)
  viewer:add(correctedImage)
  viewer:add('Undistort mode', text)
  viewer:present()
  Script.sleep(DELAY) -- For demonstration purpose only

  -- Untilt mode removes perspective and lens distortion and converts pixels to mm
  correction:setUntiltMode(cameraModel, 'FULL')
  correctedImage = correction:apply(checkerBoard)
  viewer:add(correctedImage)
  text:setPosition(0, 0) -- world origin
  text:setSize(10) -- mm
  viewer:add('Untilt mode', text)
  viewer:present()
  Script.sleep(DELAY) -- For demonstration purpose only

  -- Align mode removes perspective and lens distortion effects and aligns to a world rectangle
  local cxy = squareSize * 6 -- Selected center point for aligned image in both x and y
  local sxy = squareSize * 13 -- Select the size of the alignment region in both x and y
  local worldRectangle = Shape.createRectangle(Point.create(cxy, cxy), sxy, sxy)
  correction:setAlignMode(cameraModel, worldRectangle)
  correctedImage = correction:apply(checkerBoard)
  viewer:add(correctedImage)
  viewer:add('Align mode', text)
  viewer:present()
  print('App finished.')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
