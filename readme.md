## OneShotCalibration2D
Camera calibration using one shot of checkerboard target and various correction modes
### Description
Calibrating a camera using one shot of a checkerboard calibration target.
Correcting the image by rectification using different correction modes.
OneShot calibration makes a calibration model that is valid within
the plane of the calibration target. The model produced can typically
not be used for other things than measurements within this plane.
### How to Run
Starting this sample is possible either by running the App (F5) or
debugging (F7+F10). Setting breakpoint on the first row inside the 'main'
function allows debugging step-by-step after 'Engine.OnStarted' event.
Results can be seen in the image viewer on the DevicePage.
To run this sample a device with SICK Algorithm API is necessary.
For example InspectorP or SIM4000 with latest firmware. Alternatively the
Emulator on AppStudio 2.2 or higher can be used. The images can be seen in the
image viewer on the DevicePage.
### More Information
Tutorial "Algorithms - Calibration2D"

### Topics
Algorithm, Image-2D, Calibration, Sample, SICK-AppSpace