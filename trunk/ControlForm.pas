{   Copyright 2012 Thomas Tilley.
    http://www.tomtilley.net/projects/suckerbot/

    This file is part of Suckerbot.

    Suckerbot is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Suckerbot is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Suckerbot.  If not, see <http://www.gnu.org/licenses/>. }

{ To Do
  ---------------
  - Can we turn on the analog mode via software?

  - Why do we sometimes get empty log files - opened but with no header info?

  - Line Following Mode }

unit ControlForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvHidControllerClass, DateUtils, ExtCtrls, MPlayer,
  TeeProcs, TeEngine, Chart, Series, Math;

type
  MotorInstr = array [0..7] of Byte;
  TCommand = (cmdUnknown, cmdLeft, cmdRight, cmdForward, cmdSeekLeft,
    cmdSeekRight);
  TMainForm = class(TForm)
    DriveButton:      TButton;
    LineFollowButton: TButton;
    BumpModeButton:   TButton;
    SetupButton:      TButton;
    GroupBox1: TGroupBox;
    BlackLineRadioButton: TRadioButton;
    WhiteLineRadioButton: TRadioButton;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    HidController1: TJvHidDeviceController;
    LogTimer: TTimer;
    ChooseJoystickButton: TButton;
    FrontImage:        TImage;
    TopImage:          TImage;
    Image1:            TImage;
    FrontRefImage:     TImage;
    TopRefImage:       TImage;
    TopPressedImage:   TImage;
    FrontPressedImage: TImage;
    ChartJoyLeft:  TChart;
    ChartJoyRight: TChart;
    Label2: TLabel;
    Label3: TLabel;
    SeriesLy: TFastLineSeries;
    SeriesLx: TFastLineSeries;
    SeriesRy: TFastLineSeries;
    SeriesRx: TFastLineSeries;
    MotorTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure DriveButtonClick(Sender: TObject);
    procedure SetupButtonClick(Sender: TObject);
    procedure LineFollowButtonClick(Sender: TObject);
    procedure BumpModeButtonClick(Sender: TObject);
    procedure LogTimerTimer(Sender: TObject);
    procedure ChooseJoystickButtonClick(Sender: TObject);
    procedure HidController1DeviceData(HidDev: TJvHidDevice;
      ReportID: Byte; const Data: Pointer; Size: Word);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MotorTimerTimer(Sender: TObject);

  private
    { Private declarations }
    LogFile: TextFile;
    BaseDirectory: String;
    Mode: (mUndefined, mDrive, mFollow, mBump);
    Command:     TCommand;
    LastCommand: TCommand;
    ButtonPressed:   array [1..19] of Boolean; // store button states
    LastButtonState: array [1..19] of Boolean; // store previous button states
    MotorL, MotorR: Cardinal;
    AnalogJoyValues: array [0..3] of Integer; //[left-X, left-Y, right-X, right-Y]
    StartTime: TDateTime;
    UsbVid: Integer;  // USB vendor
    UsbPid: Integer;  // USB roduct info
    UsbDev: TJvHidDevice;     // this USB device is the robot
    UsbParams: TStrings;      // for passing selected joystick details
    ButtonMask: array [1..16] of Cardinal;
    LastData:   array[0..7]  of Cardinal;
    TxInstr:    MotorInstr;
    PowerInstr: MotorInstr;
    OffInstr:   MotorInstr; // USB motor instructions
    TopRobotImage:   array [1..19] of TRect;  // areas to copy for button images
    FrontRobotImage: array [1..19] of TRect;  // areas to copy for button images
    GraphDelay:    Integer;
    LineThreshold: Integer;
    PlayedSuccessSound: Boolean; // flag so we only play this sound once
    Bumped: Boolean;    // flag so we only process each bump once
    procedure OpenLogFile();
    procedure LogData();
    function  InstrToStr(instr: MotorInstr): String;
    procedure WriteInstr(instr: MotorInstr);
    procedure TxMotorInstruction();
    procedure SetBothMotorsPower(power: Integer);
    procedure SetLeftMotorPower(power: Integer; now: Boolean);
    procedure SetRightMotorPower(power: Integer; now: Boolean);
    procedure UpdateImages();
    procedure UpdateGraphs();
    function  ToRect(x, y, width, height: Integer): TRect;
    procedure FollowLine();
    function PulseMotors(leftPower, rightPower: Cardinal;
      milliSec: Cardinal): Boolean;
    procedure EnableButtons(state: Boolean);
    procedure StartMode();
    procedure StopMode();
    procedure StopBumpMode();
    procedure CheckForBump();
    procedure DriveOverSound();

  public
    { Public declarations }
    DebugCount: Integer;
    Processing: Boolean;
  end;

var
  MainForm: TMainForm;

const
  LOG_DIR = 'logs'; // directory for storing log files

  // Constants used for determining joystick and button values
  NORTH_EAST = $01; // NE
  SOUTH_EAST = $03; // SE
  SOUTH_WEST = $05; // SW
  NORTH_WEST = $07; // NW
  ANALOG_STICKS  = $40; // analog mode is on
  DIGITAL_STICKS = $C0; // analog mode is off
  STICK_MIN = $00;  // LEFT or UP
  STICK_MID = $7F;  // CENTERED
  STICK_MAX = $FF;  // RIGHT or DOWN

implementation

uses ChooseJoystick, Settings, AnalogDialog;

{$R *.dfm}


{ This is the main form and telemetry display for Suckerbot }

{ Create the form and initialise array values, etc. }
procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin

  MainForm.DoubleBuffered := true; // reduces screen flicker

  Randomize; // intialise random seed generator from clock

  Mode := mUndefined; // Current robot mode
  Command     := cmdUnknown;
  LastCommand := cmdUnknown;

  DebugCount := 0;

  // flag so we only play a sound once when we find a dark/light spot on the
  // floor (and not the whole time we are over the spot)
  PlayedSuccessSound:= False;

  // store the working directory so we can reset it after opening
  // sound files
  BaseDirectory := GetCurrentDir;

  // create log directory if it does not already exist
  if not DirectoryExists('.\' + LOG_DIR) then
    if not CreateDir('.\' + LOG_DIR) then
      raise Exception.Create('Cannot create log file directory:' + LOG_DIR);

  // initialise button and motor telemetry values
  for I := 1 to 19 do
    ButtonPressed[I] := False;

  // initialise motor power levels
  MotorL := 0;
  MotorR := 0;

  // initialise analog joystick values
  for I := 0 to 3 do
    AnalogJoyValues[I] := 127;

  GraphDelay := 0;

   // this amount of variation triggers white or black line loss
   LineThreshold := 15;

  // initialise previous values for GUI image updating
  for I := 1 to 19 do
    LastButtonState[I] := True;  // force initial update of values

  // Create bit masks for each button value - byte 5 is shifted
  // left by 8 bits and or'ed with byte 6 from the joystick data
  ButtonMask[1]  := $1000;
  ButtonMask[2]  := $2000;
  ButtonMask[3]  := $4000;
  ButtonMask[4]  := $8000;
  ButtonMask[5]  := $0001;
  ButtonMask[6]  := $0002;
  ButtonMask[7]  := $0004;
  ButtonMask[8]  := $0008;
  ButtonMask[9]  := $0010;
  ButtonMask[10] := $0020;
  ButtonMask[11] := $0040;
  ButtonMask[12] := $0080;

  // Direction pad keys - note that N + S and E + W are not possible
  ButtonMask[13] := $00; // North
  ButtonMask[14] := $02; // East
  ButtonMask[15] := $04; // South
  ButtonMask[16] := $06; // West

  // create motor instruction arrays

  // $00 51 00 00 00 00 00 00 - motor power levels
  PowerInstr[0] := $00;
  PowerInstr[1] := $51;
  for I := 2 to 7 do
    PowerInstr[I] := $00;

  // $00 fa fe 00 00 00 00 00 - TX levels
  TxInstr[0] := $00;
  TxInstr[1] := $fa;
  TxInstr[2] := $fe;
  for I := 3 to 7 do
    TxInstr[I] := $00;

  // $00 f3 00 00 00 00 00 00 - stop
  OffInstr[0] := $00;
  OffInstr[1] := $f3;
  for I := 2 to 7 do
    OffInstr[I] := $00;

  // Define rectangles around the pressed button images for both the top and
  // front views (including the analog mode LED)
  // Copy a small unchanged area (e.g. background) for buttons that
  // don't appear in both views.
  TopRobotImage[1]    :=   rect( 69,137, 92,159);
  FrontRobotImage[1]  :=   rect( 68, 22, 89, 29);
  TopRobotImage[2]    := ToRect( 42,113, 24, 22);
  FrontRobotImage[2]  := ToRect( 46, 23, 22,  7);
  TopRobotImage[3]    := ToRect( 68, 87, 23, 24);
  FrontRobotImage[3]  := ToRect( 90, 21,  7,  7);
  TopRobotImage[4]    := ToRect( 95,112, 24, 23);
  FrontRobotImage[4]  := ToRect( 98, 21, 22,  9);
  TopRobotImage[7]    := ToRect(  0,  0,  5,  5); // no top view
  FrontRobotImage[7]  := ToRect(254, 76, 45, 43);
  TopRobotImage[8]    := ToRect(  0,  0,  5,  5); // no top view
  FrontRobotImage[8]  := ToRect( 48, 77, 46, 43);
  TopRobotImage[5]    := ToRect(242,180, 41, 11);
  FrontRobotImage[5]  := ToRect(255, 40, 45, 24);
  TopRobotImage[6]    := ToRect( 65,182, 41, 10);
  FrontRobotImage[6]  := ToRect( 47, 40, 46, 24);
  TopRobotImage[9]    := ToRect(195,117, 17, 11);
  FrontRobotImage[9]  := ToRect(195, 24, 16,  9);
  TopRobotImage[10]   := ToRect(135,118, 19, 11);
  FrontRobotImage[10] := ToRect(136, 25, 18,  9);
  TopRobotImage[11]   := ToRect(199, 50, 47, 48);
  FrontRobotImage[11] := ToRect(198,  7, 37, 12);
  TopRobotImage[12]   := ToRect(102, 52, 48, 46);
  FrontRobotImage[12] := ToRect(114,  7, 39, 12);
  TopRobotImage[13]   := ToRect(261,128, 18, 20);
  FrontRobotImage[13] := ToRect(259, 18, 19,  9);
  TopRobotImage[14]   := ToRect(243,114, 21, 19);
  FrontRobotImage[14] := ToRect(241, 20, 18,  7);
  TopRobotImage[15]   := ToRect(261, 97, 18, 21);
  FrontRobotImage[15] := ToRect(  0,  0,  5,  5); // no front view
  TopRobotImage[16]   := ToRect(276,115, 21, 18);
  FrontRobotImage[16] := ToRect(278, 20, 15,  8);
  TopRobotImage[17]   := ToRect(169, 76, 13,  6);
  FrontRobotImage[17] := ToRect(  0,  0,  5,  5); // no front view
  TopRobotImage[19]   := ToRect(  7, 21, 18, 71);  //left wheel (right motor)
  FrontRobotImage[19] := ToRect( 30, 90, 18, 53);
  TopRobotImage[18]   := ToRect(319, 22, 18, 71);  //right wheel (left motor)
  FrontRobotImage[18] := ToRect(301, 90, 18, 53);

  // add initial values to chart data
  for I := 0 to 100 do
    begin
      ChartJoyLeft.SeriesList.Series[0].AddY(0);
      ChartJoyLeft.SeriesList.Series[1].AddY(0);
      ChartJoyRight.SeriesList.Series[0].AddY(0);
      ChartJoyRight.SeriesList.Series[1].AddY(0);
    end;

  // disable the mode buttons until we have a joystick selected
  EnableButtons(False);

end;


{ Start/stop drive mode }
procedure TMainForm.DriveButtonClick(Sender: TObject);
begin
  if Mode <> mDrive then
    begin
      Mode := mDrive;
      DriveButton.Caption := 'Stop Driving';
      StartMode();
      DriveButton.Enabled := True;
      SettingsForm.PlaySuccessSound();
    end
  else
    begin
      StopMode();
      DriveButton.Caption := 'Drive';
    end;
end;


{ Show the settings form }
procedure TMainForm.SetupButtonClick(Sender: TObject);
begin
  // open settings form
  SettingsForm.EnableDetectButtons(usbDev <> nil);
  SettingsForm.ShowModal;
end;


{ Start stop line following mode }
procedure TMainForm.LineFollowButtonClick(Sender: TObject);
begin
  if Mode <> mFollow then
    begin
      // If the joystick is not in analog mode or if we can't detect value
      // of the analog button then "warn" the user to check
      if not ButtonPressed[17] then
        begin
          AnalogCheckForm.SetMessage('Please check that the joystick''s red ' +
            '"ANALOG" LED is on then click "Follow" again.');
          if AnalogCheckForm.Warn then
            AnalogCheckForm.ShowModal;
        end;  

      Mode := mFollow;
      LineFollowButton.Caption := 'Stop Following';
      StartMode();
      LineFollowButton.Enabled := True;
      FollowLine();
    end
  else
    begin
      LineFollowButton.Caption := 'Follow';
      StopMode();
    end;
end;


{ Start/stop bump mode }
procedure TMainForm.BumpModeButtonClick(Sender: TObject);
begin
  if Mode <> mBump then
    begin
      // If the joystick is not in analog mode or if we can't detect value
      // of the analog button then "warn" the user to check
      if not ButtonPressed[17] then
        begin
          AnalogCheckForm.SetMessage('Please check that the joystick''s red ' +
            '"ANALOG" LED is on then click "Bump Mode" again.');
          if AnalogCheckForm.Warn then
            AnalogCheckForm.ShowModal;
        end;

      Mode := mBump;
      BumpModeButton.Caption := 'Stop Bumping';
      StartMode();
      BumpModeButton.Enabled := True;
    end
  else
      StopBumpMode();
end;


{ This is a convenience method so that the bump mode can be easily stopped -
  perhaps from within bump mode itself if the robot hits something }
procedure TMainForm.StopBumpMode();
begin
  StopMode();
  BumpModeButton.Caption := 'Bump Mode';
end;


{ Create and initialise the log file }
procedure TMainForm.OpenLogFile();
var
  LogFilename: String;
  Header: String;
  I: integer;
  //Year, Month, Day, Hour, Min, Sec, MilliSec: Word;
begin
  case Mode of
    mDrive:  logFilename := 'drive';
    mFollow: logFilename := 'follow';
    mBump:   logFilename := 'bump';
  else
    LogFilename:= 'undefined';
  end;

  LogFilename := LogFilename + '.csv';
  //DecodeDateTime(Now, Year, Month, Day, Hour, Min, Sec, MilliSec);
  //logFilename := LOG_DIR + '\' + IntToStr(Year) + '-' + IntToStr(Month) + '-' +
  //               IntToStr(Day) + '--' + IntToStr(Hour) + '-' +
  //               IntToStr(Min) + '-' + IntToStr(Sec) + '-'+ logFilename;

  LogFilename := LOG_DIR + '\' +
    FormatDateTime('yyyy-mm-dd--hh-mm-ss-am/pm', Now) + '-' + LogFilename;

  // change back to initial working directory in case we have opened any dialogs
  // which may have changed our location  (e.g. choosing sounds)
  SetCurrentDir(BaseDirectory);
  AssignFile(LogFile, LogFilename);
  Rewrite(LogFile);

  //Writeln(logFile, FormatDateTime('yyyy-mm-dd--hh-mm-ss-am/pm', Now));
  // Header for CSV?
  // Include the Date? - already encoded in filename

  Header := 'mSec';

  for I := 1 to 12 do
    Header := Header + ',B' + IntToStr(I);


  Header := Header + ',Up,Right,Down,Left,Analog'
    + ',JoyL-X,JoyL-Y,JoyR-X,JoyR-Y,MotorL,MotorR';

  // use this command to write a line to the log file
  Writeln(LogFile, Header);

  StartTime := Time;  // store the time at the start of this run
end;


{ Write the telemetry data to the log file in comma separated value (CSV)
  format }
procedure TMainForm.LogData();
var
  Data: String;
  I: integer;
begin

  if not SettingsForm.UseLogFile then
    exit;

  // How to best store useful time information?
  // millisec since starting?
  Data := IntToStr(MilliSecondsBetween(Time, StartTime));

  // write formatted time info first
  //data := FormatDateTime('hh:mm:ss.zzz', Now);

  for I := 1 to 17 do
    begin
      if ButtonPressed[I] then
        Data := Data + ', 1'  // Could use 'On' and 'Off'
      else
        Data := Data + ', 0';
    end;

  for I := 0 to 3 do
    Data := Data + ',' + IntToStr(AnalogJoyValues[I]);

  // swap motor values if "Swap Motors" is checked
  if SettingsForm.SwapMotors then
    Data := Data + ',' + IntToStr(MotorR) + ',' + IntToStr(MotorL)
  else
    Data := Data + ',' + IntToStr(MotorL) + ',' + IntToStr(MotorR);

  Writeln(LogFile, Data);
end;


{ Write data to the log every second }
procedure TMainForm.LogTimerTimer(Sender: TObject);
begin
  LogData();
end;


{ Open the form to select the robot's joystick }
procedure TMainForm.ChooseJoystickButtonClick(Sender: TObject);
begin

  // USB values for PID and VID are passed back via
  // this string list
  usbParams := TStringList.Create;

  if SelectJoystickForm.Show(usbParams) = mrOK then
    begin
      EnableButtons(True);
      usbVid := StrToIntDef(usbParams.Strings[0],0);
      usbPid := StrToIntDef(usbParams.Strings[1],0);
      HidController1.CheckOutByID(usbDev,usbVid,usbPid);
      // Disable the "Joystick Select" button to prevent double loading
      ChooseJoystickButton.Enabled := False;
      //ShowMessage('Report byte length = ' + IntToStr(usbDev.Caps.OutputReportByteLength));
      //WriteInstr(offInstr); // TX off command
    end
  else
    begin
      EnableButtons(False);
      usbVid := -1;
      usbPid := -1;
      usbDev := nil;
    end;

  //ShowMessage(IntToStr(usbVid) + ',' + IntToStr(usbPid)); // trace
  usbParams.Destroy;

end;


{ This method is called when the joystick has data (button pressses etc.)
  the data is decoded and stored in a number of arrays for convenience }
procedure TMainForm.HidController1DeviceData(HidDev: TJvHidDevice;
  ReportID: Byte; const Data: Pointer; Size: Word);
var
  ButtonValue: Cardinal;
  DpadValue:   Cardinal;
  I:           Integer;
  DataChanged: Boolean;
begin

  DataChanged := False;

  // check to see if there is any new data
  // should this only be applied for logging?
  for I := 0 to 7 do
    if (LastData[I] <> Cardinal(PChar(Data)[I])) and
        (I <> 2) then       // the value of Data[2] drifts
      begin
        DataChanged := True;
      end;

  if DataChanged then
    begin

      // Make a copy of the current device data
      for I := 0 to 7 do
        LastData[I] := Cardinal(PChar(Data)[I]);

      // check button states
      ButtonValue := (Cardinal(PChar(Data)[5]) shl 8) or
        Cardinal(PChar(Data)[6]);

      for I := 1 to 12 do
        if (ButtonValue and ButtonMask[I]) = ButtonMask[I] then
          ButtonPressed[I] := True
        else
          ButtonPressed[I] := False;

    // Check joystick & D-Pad data

    // Read Left thumbstick values (scale by adding -127)
    AnalogJoyValues[0] := Cardinal(PChar(Data)[0]);
    AnalogJoyValues[1] := Cardinal(PChar(Data)[1]);

    if Cardinal(PChar(Data)[7]) = ANALOG_STICKS then
      begin
        ButtonPressed[17] := True; // set the analog button state

        // check D-pad states in Data[5] by masking out the buttons in top most
        // 4 bits
        DpadValue := (Cardinal(PChar(Data)[5])) and  $0F;

        for I := 13 to 16 do
          if ButtonMask[I] = DpadValue then
            ButtonPressed[I] := True
          else
            ButtonPressed[I] := False;

        // need to check for compass corners too - NE, SE, SW, NW
        if DpadValue = NORTH_EAST then
          begin
            ButtonPressed[13] := True; // N
            ButtonPressed[14] := True; // E
          end
        else if DpadValue = SOUTH_EAST then
          begin
            ButtonPressed[15] := True; // S
            ButtonPressed[14] := True; // E
          end
        else if DpadValue = SOUTH_WEST then
          begin
            ButtonPressed[15] := True; // S
            ButtonPressed[16] := True; // W
          end
        else if DpadValue = NORTH_WEST then
          begin
            ButtonPressed[13] := True; // N
            ButtonPressed[16] := True; // W
          end;

        // Read right thumbstick analog values
        AnalogJoyValues[2] := Cardinal(PChar(Data)[3]);
        AnalogJoyValues[3] := Cardinal(PChar(Data)[4]);

      end
    else if Cardinal(PChar(Data)[7]) = DIGITAL_STICKS then
      begin
        ButtonPressed[17] := False;
        // are these values useful/worth reading?  Unless the thumb sticks
        // are in analog mode we have analog values on Lx axis and a reduced
        // range (approx $52..$89) on on Ry axis when readining Data[2]
        //
        // Data[0] gives Lx digital values ($00 - $7F - $FF) and Data[1] the
        // same for Ly.
        //
        // The right thumbstick Data[5] maps U, D, L, R into buttons 1, 2, 3, 4
        // respectively (binary addition gives corners similarly to D-Pad
        // buttons).

      end;


    // Check for bumps and spots on the floor here but all other control
    // should start with an initial command that then decides what to do next
    // after the timeout of a motor pulse command (see MotorTimerTimer).
    if Mode <> mUndefined then
      begin
        LogData();
        DriveOverSound();
        CheckForBump();
      end;

    // update line sensor values and analog button state for the SetttingsForm
    SettingsForm.leftSensorValue  :=
      AnalogJoyValues[SettingsForm.getLeftSensorMap];
    SettingsForm.rightSensorValue :=
      AnalogJoyValues[SettingsForm.getRightSensorMap];
    SettingsForm.AnalogButtonOn := ButtonPressed[17];

    UpdateImages();

  end;

  UpdateGraphs();

end;


{ Key down handling for the drive mode
  (uses FPS style 'A', 'W', 'D' keys for left, forward, and right. }
procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Mode = mDrive then
    begin
      // handle keypresses for left and right steering   ('a' and 'd')
      // should we handle up as driving both motors?
      //    - what happens then if you are holding forwward and you press left
      //      or right to turn?
      if Key = Ord('A') then
        begin
          SetLeftMotorPower(255, True);  // TX full power to left motor
        end
      else if Key = Ord('D') then
        begin
          SetRightMotorPower(255, True); // TX full power to right motor
        end
      else if Key = Ord('W') then
        begin
          SetBothMotorsPower(255);  // TX full power to both motors
        end
    end;
end;


{ Key up handling for the drive mode }
procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Mode = mDrive then
    begin
      if Key = Ord('A') then
        begin
          SetLeftMotorPower(0, True);  // TX stop to left motor
        end
      else if  Key = Ord('D') then
        begin
          SetRightMotorPower(0, True); // TX stop to right motor
        end
      else if  Key = Ord('W') then
        begin
          SetBothMotorsPower(0);       // TX stop for both motors
        end
    end;
end;


{ Constructs a motor power level instruction and sends it to the
  joystick's motors }
procedure TMainForm.TxMotorInstruction();
begin

 // write to USB
  if (MotorL > 0)  or (MotorR > 0) then
    begin
      WriteInstr(powerInstr);
      WriteInstr(txInstr);
    end
  else
    writeInstr(offInstr);

  UpdateImages();
  LogData();

end;


{ Convenience method for converting motor instructions to strings for
  debugging }
function TMainForm.InstrToStr(instr: MotorInstr): String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to 7 do
    begin
      Result := Result + ' ' + Format('%.2x', [instr[I]]);
    end;
end;


{ Write the instruction to the USB device }
procedure TMainForm.WriteInstr(instr: MotorInstr);
var
  Written: Cardinal;
  ToWrite: Cardinal;
  Err: DWORD;
begin
    // check that we have a USB device available
    if usbDev = nil then
      exit;

    // should this be tested elsewhere?
    ToWrite := usbDev.Caps.OutputReportByteLength;
    if not usbDev.WriteFile(instr, ToWrite, Written) then
    begin
      Err := GetLastError;
      ShowMessage(Format('WRITE ERROR: %s (%x)', [SysErrorMessage(Err), Err]));
    end
end;


{ Set both motors to the same power level (0..255) and send the command
  to the joystick immediately }
procedure TMainForm.SetBothMotorsPower(power: Integer);
begin
    SetLeftMotorPower(power, False);
    SetRightMotorPower(power, False);
    TxMotorInstruction();
end;


{ Set the left motor's power level (0..255)
  setting 'now' to True will send the message to the joystick striaght away
  setting 'now' to False will create a motor instruction with the correct
  power level but it won't be sent until TxMotorInstruction() is called }
procedure TMainForm.SetLeftMotorPower(power: Integer; now: Boolean);
var
   buttonNo: Integer;
   instrNo:  Integer;
begin

  // swap the motors?
  if SettingsForm.CheckBoxSwapMotors.Checked then
    begin
      buttonNo  := 19;
      instrNo := 3;
    end
  else
    begin
      buttonNo := 18;
      instrNo  := 5;
    end;

  MotorL := power;

  if power > 0 then
    begin
      ButtonPressed[buttonNo] := True; // set "button" state for image update
      powerInstr[instrNo] := power;
    end
  else
    begin
      ButtonPressed[buttonNo] := False; // set "button" state for image update
      powerInstr[instrNo] := $00;
    end;

    if now then
      TxMotorInstruction();
end;


{ Set the right motor's power level (0..255)
  setting 'now' to True will send the message to the joystick straight away
  setting 'now' to False will create a motor instruction with the correct
  power level but it won't be sent until TxMotorInstruction() is called. }
procedure TMainForm.SetRightMotorPower(power: Integer; now: Boolean);
var
   buttonNo: Integer;
   instrNo:  Integer;
begin

  // swap the motors?
  if SettingsForm.CheckBoxSwapMotors.Checked then
    begin
      buttonNo := 18;
      instrNo  := 5;
    end
  else
    begin
      buttonNo  := 19;
      instrNo := 3;
    end;

  MotorR := power;

  if power > 0 then
    begin
      ButtonPressed[buttonNo] := True; // set "button" state for image update
      powerInstr[instrNo] := power;
    end
  else
    begin
      ButtonPressed[buttonNo] := False; // set "button" state for image update
      powerInstr[instrNo] := $00;
    end;

  if now then
    TxMotorInstruction();

end;


{ Update the joystick button and wheel images }
procedure TMainForm.UpdateImages();
var
  I: Integer;
begin

  // update buttons on joystick display
  for I := 1 to 19 do
    if LastButtonState[I] <> ButtonPressed[I] then
      begin
        if ButtonPressed[I] then
          begin
            //copy image rectangles from the pressed button image
            TopImage.Canvas.CopyRect(TopRobotImage[I],
              TopPressedImage.Picture.Bitmap.Canvas, TopRobotImage[I]);
            FrontImage.Canvas.CopyRect(FrontRobotImage[I],
              FrontPressedImage.Picture.Bitmap.Canvas, FrontRobotImage[I]);
          end
        else
          begin
            //copy image rectangles from the normal image
            TopImage.Canvas.CopyRect(TopRobotImage[I],
              TopRefImage.Picture.Bitmap.Canvas,  TopRobotImage[I]);
            FrontImage.Canvas.CopyRect(FrontRobotImage[I],
              FrontRefImage.Picture.Bitmap.Canvas, FrontRobotImage[I]);
          end;
        LastButtonState[I] := ButtonPressed[I];
      end;

      // Note that this also updates the wheel images but the wheel "Button"
      // values are set from within SetLeftMotorPower and SetRightMotorPower

end;


{ Update the analog thumbstick graphs }
procedure TMainForm.UpdateGraphs();
begin
  // Update joystick graphs
  // counter used to only display every 2nd or 3rd update if need be
  Inc(GraphDelay);
  if GraphDelay >= 2 then
    begin
      GraphDelay := 0;

      With SeriesLx do
        begin
          Delete(0);
          AddXY(XValues.Last + 1, AnalogJoyValues[0] - 127);
        end;

      With SeriesRx do
        begin
          Delete(0);
          AddXY(XValues.Last + 1, AnalogJoyValues[2] - 127);
        end;

      With SeriesLy do
        begin
          Delete(0);
          AddXY(XValues.Last + 1, AnalogJoyValues[1] - 127);
        end;

      With SeriesRy do
        begin
          Delete(0);
          AddXY(XValues.Last + 1, AnalogJoyValues[3] - 127);
        end;
  end;

end;


{ Convenience funtion to create a rectangle for copying pressed button images
  (using the format in the status bar of IrfanView). }
function TMainForm.ToRect(x, y, width, height: Integer): TRect;
begin
  Result := Rect(x, y, x + width, y + height);
end;


{ First simple attempt at line following
  This method is called once and the it relies on the motor timer to
  to call it again after a motor pulse
  Currently it ignores the line color radio button }
procedure TMainForm.FollowLine();
var
  leftLineThreshold:  Extended;
  rightLineThreshold: Extended;
  leftSensor:  Cardinal;
  rightSensor: Cardinal;
  pulseTime:   Cardinal;
begin

  // check to see if we are already in a pulse
  if MotorTimer.Enabled then
    Exit;

  // these could be set initially and updated whenever the SettingsForm is closed
  // currently doesn't respect white or black radio buttons
  leftLineThreshold  := SettingsForm.getLeftBlackLevel  + LineThreshold;
  rightLineThreshold := SettingsForm.getRightBlackLevel + LineThreshold;

  pulseTime := 25;  // 50 mSec

  leftSensor  := AnalogJoyValues[SettingsForm.getLeftSensorMap];
  rightSensor := AnalogJoyValues[SettingsForm.getRightSensorMap];

  // if both on line -> move forward
  if (leftSensor  < leftLineThreshold) and
    (rightSensor < rightLineThreshold) then
    begin
      PulseMotors(255, 255, pulseTime);
      Command := cmdForward;
    end
  // if only left sensor off the line -> turn right
  else if (leftSensor  >= leftLineThreshold) and
    (rightSensor < rightLineThreshold) then
    begin
      PulseMotors(0, 255, pulseTime);
      Command := cmdRight
    end
  // if only right sensor off the line -> turn left
  else if (leftSensor < leftLineThreshold) and
    (rightSensor >= rightLineThreshold) then
    begin
      PulseMotors(255, 0, pulseTime);
      Command := cmdLeft;
    end
  // if both sensors off the line -> lost the line!
  // keep turning right!
  // But should seek left or right dependingon which side we lost the line on
  // or implement a left-right scanning mode in successively bigger sweeps?
  else if (leftSensor  >= leftLineThreshold) and
    (rightSensor >= rightLineThreshold) then
    begin
      PulseMotors(0, 255, 50);
    end;

end;


{ Turn the motors on for a set period (in milliSec).
  Note that any additional calls to this method while it is still in a pulse
  are ignored and the Boolean return value indicates if the request was
  successful or not!
  To control the motors immediatley (e.g. to stop both motors RIGHT NOW use
  SetBothMotors(0); instead) or SetLeftMotorPower or SetRightMotorPower with the
  second parameter set to True, e.g. SetLeftMotorPower(255, True); }
function TMainForm.PulseMotors(leftPower, rightPower: Cardinal;
   milliSec: Cardinal): Boolean;
begin

  If MotorTimer.Enabled then
    begin;
      Result := False;
      exit;  // already in a pulse so this request will be ignored!
    end;

  SetLeftMotorPower(leftPower, False);
  SetRightMotorPower(rightPower, False);
  TxMotorInstruction();

  // start timer
  MotorTimer.Interval := milliSec;
  MotorTimer.Enabled := True;
  Result := True;

end;


{ Callback method for the motor timer
  turn the motors off, disable the timer and then process the
  next command based on the current mode. }
procedure TMainForm.MotorTimerTimer(Sender: TObject);
begin
  MotorTimer.Enabled := False;
  SetBothMotorsPower(0);

    LastCommand := Command;

    if Mode = mFollow then
      FollowLine()
    else if Mode = mBump then
      begin
        if (LastCommand = cmdLeft) or (LastCommand = cmdRight) then
          begin
            Command := cmdForward;
            PulseMotors(255, 255, 1500);
          end;
      end;



end;


{ Convenince method to enable/disable all the mode buttons }
procedure TMainForm.EnableButtons(state: Boolean);
begin
      BumpModeButton.Enabled       := state;
      //LineFollowButton.Enabled     := state;  // not implemented
      //BlackLineRadioButton.Enabled := state;  // not implemented
      //WhiteLineRadioButton.Enabled := state;  // not implemented
      DriveButton.Enabled          := state;
      SetupButton.Enabled          := state;
end;


{ Perform some common functions when beginning a new mode }
procedure TMainForm.StartMode();
begin
  EnableButtons(False);
  if SettingsForm.UseLogFile then
    OpenLogFile();
  //usbDev.OnData := HidController1DeviceData;  // start listening for USB data
end;


{ Perform some common functions when exiting a mode }
procedure TMainForm.StopMode();
begin
  Mode := mUndefined;
  MotorTimer.Enabled := False; // stop any current motor pulse
  SetBothMotorsPower(0);
  EnableButtons(True);
  if SettingsForm.UseLogFile then
    CloseFile(logFile);
  //usbDev.OnData := nil; // stop listening for USB data
end;


{ Check for joystick bump deflection }
procedure TMainForm.CheckForBump();
begin
  if Mode = mBump then
    begin
      // check Y-axis for bump
      if (AnalogJoyValues[1] > (127 + SettingsForm.getBumpLevel)) or
        (AnalogJoyValues[1] < (127 - SettingsForm.getBumpLevel)) then
        begin
          if not Bumped then
            begin
              SettingsForm.PlayBumpSound();
              Bumped := True;  // set flag
              SetBothMotorsPower(0);
              // do something bumpy here - turn and drive away!!
              Command := cmdLeft;
              PulseMotors(255, 0, 1500);  // turn left
              // calling this pulsed motor command hands control
              // for successive commands over to MotorTimerTimer
            end;
        end
      else
        Bumped := False; // joystick re-centerd so reset the bump flag
    end;

end;


{ Play a sound once if either line detector drops below the white level
  threshold.  It only resets once the levels rise back up above the white
  threshold.  This prevents multiple/continuous sound playing while driving
  over a black area. }
procedure TMainForm.DriveOverSound();
begin
  if (AnalogJoyValues[SettingsForm.getLeftSensorMap()] <
    (SettingsForm.getLeftWhiteLevel() - LineThreshold)) or
    (AnalogJoyValues[SettingsForm.getRightSensorMap()] <
    (SettingsForm.getRightWhiteLevel() - LineThreshold)) then
    begin
      if not PlayedSuccessSound then
        begin
          SettingsForm.PlaySuccessSound();
          PlayedSuccessSound := True;  // set flag
          // of the robot is searching for a spot on the ground then
          // we could stop the motors and end the mode here
        end;
      end
    else  // must be over white so reset the flag
      PlayedSuccessSound := False;
end;


end.
