Suckerbot v0.4
March 15, 2013

This is the software for my entry in the African Robotics Network (AFRON) $10 Robot Design Challenge (see http://www.robotics-africa.org/design_challenge.html). Suckerbot is a submission in the tethered robot category.  The robot is connected to a computer via a USB cable where both the computing and the programming take place.  

You can find more details online at: 

http://www.tomtilley.net/projects/suckerbot/ 

Suckerbot is Open Source and the code is released under the GNU Public License. You can download the source at:

https://code.google.com/p/suckerbot/

Quick Start:
------------
- Plug in the USB cable of your robot
- Start the program 
- Select the joystick and then choose a mode
- In "Drive Mode" you can control the robot using the (use 'A', 
  & 'D' keys)
- In "Bump Mode" try flicking the Chupa Chup bump sensor.
- Open the settings panel to choose sound effects

Troubleshooting:
----------------
- If the program cannot create log files make sure that the 'Logs/'   directory is not read only.

Changelog:
---------
v0.4:
-----
- The line sensor was not being read in joysticks that do not report
  the state of the analog button. This is now fixed and a warning will
  be displayed to turn the analog mode on if the state cannot be     determined from the hardware.  
  
v0.3:
-----
- Numerous changes to the source code
- Simple bump mode implemented

v0.2
----
Joystick selection and interface are now more robust:  
- Mode buttons are diasbled until the joystcik is selected.
- Joystick can be plugged in after the program has started.
- Select joystick button disabled after successful selection.
- Removed the unused GraphicEx and JPEG library dependencies from 
  ControlForm.pas