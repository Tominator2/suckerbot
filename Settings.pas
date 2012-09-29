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
    along with Suckerbot.  If not, see <http://www.gnu.org/licenses/>.  }


{ To Do:
  ------
  Should line detection work on an edge - with one sensor on
  and one off?
  - Should the threshold be lowered closer to the black (e.g. black + 10) rather
    than using the average level between black and white?

  Only non-working setting (apart from Follow and Bump modes) is the  black or
  white line following option.

  Should we be able to choose which is/are the "bump" axis/axes?  Only allowing
  one would preclude 2D sensing from the joystick.
  - Should we update the code so that it uses both within a circle of 'bump
    radius' (or a square? - simpler) to register a bump?

  Should the axis-choice pull-downs be intelligent so that we don't map them all
  to the same axis?  (or is this desireable?)
  - Could add a 'Bump Sensor' GroupBox with the default 'Choose Axis" ComboBox
    set to the Left Y-axis as per the making instructions.

  Ability to Load/Save settings to a file? }

unit Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, MPlayer;

type
  TSettingsForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    Button1: TButton;
    Edit2: TEdit;
    BitBtn2: TBitBtn;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    BitBtn3: TBitBtn;
    Button3: TButton;
    Label4: TLabel;
    Edit4: TEdit;
    BitBtn4: TBitBtn;
    Button4: TButton;
    Button5: TButton;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Button6: TButton;
    Button7: TButton;
    Label6: TLabel;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Button8: TButton;
    Button9: TButton;
    GroupBox4: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    ComboBox1: TComboBox;
    Label11: TLabel;
    ComboBox2: TComboBox;
    MediaPlayer1: TMediaPlayer;
    OpenDialog1: TOpenDialog;
    CheckBoxLog: TCheckBox;
    CheckBoxSwapMotors: TCheckBox;
    CheckBoxAudio: TCheckBox;
    EditLeftWhite: TEdit;
    EditLeftBlack: TEdit;
    EditRightWhite: TEdit;
    EditRightBlack: TEdit;
    EditBumpLevel: TEdit;
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure EditLeftWhiteKeyPress(Sender: TObject; var Key: Char);
  private
    { Private }
    AudioFiles:   array[1..4] of String;
    procedure PlayAudio(AudioFile: String; allowed: Boolean);
    procedure LoadAudio(Index: Integer);
  public
    { Public declarations }
    LeftSensorValue:  Integer;
    RightSensorValue: Integer;
    AnalogButtonOn: Boolean;
    procedure PlayBumpSound();
    procedure PlaySuccessSound();
    procedure PlayFailureSound();
    procedure PlayErrorSound();
    function UseLogFile(): Boolean;
    function SwapMotors(): Boolean;
    procedure EnableDetectButtons(state: Boolean);
    function getLeftWhiteLevel(): Integer;
    function getLeftBlackLevel(): Integer;
    function getRightWhiteLevel(): Integer;
    function getRightBlackLevel(): Integer;
    function getLeftSensorMap(): Integer;
    function getRightSensorMap(): Integer;
    function getBumpLevel(): Integer;
    function DisplayAnalogWarning(): Boolean;

  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

procedure TSettingsForm.Button5Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;


procedure TSettingsForm.PlayAudio(AudioFile: String; allowed: Boolean);
begin
  if ((Length(AudioFile) <> 0) and allowed) then
    begin
      MediaPlayer1.FileName := AudioFile;
      MediaPlayer1.Open;
      MediaPlayer1.Stop;
      MediaPlayer1.Notify := False;
      MediaPlayer1.Play;
    end;
end;



procedure TSettingsForm.LoadAudio(Index: Integer);
begin
  // choose sound file
  OpenDialog1.Filter := 'Wav audio files (*.wav)|*.WAV';
  OpenDialog1.FileName := '';
  OpenDialog1.InitialDir := 'Audio\';
  if OpenDialog1.Execute then
   AudioFiles[Index] := OpenDialog1.FileName;
end;


procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  LoadAudio(1);
  Edit1.Text := ExtractFileName(AudioFiles[1]);
end;


procedure TSettingsForm.Button2Click(Sender: TObject);
begin
  LoadAudio(2);
  Edit2.Text := ExtractFileName(AudioFiles[2]);
end;


procedure TSettingsForm.Button3Click(Sender: TObject);
begin
  LoadAudio(3);
  Edit3.Text := ExtractFileName(AudioFiles[3]);
end;


procedure TSettingsForm.Button4Click(Sender: TObject);
begin
  LoadAudio(4);
  Edit4.Text := ExtractFileName(AudioFiles[4]);
end;


procedure TSettingsForm.BitBtn1Click(Sender: TObject);
begin
    PlayAudio(AudioFiles[1], True);
end;


procedure TSettingsForm.BitBtn2Click(Sender: TObject);
begin
    PlayAudio(AudioFiles[2], True);
end;


procedure TSettingsForm.BitBtn3Click(Sender: TObject);
begin
   PlayAudio(AudioFiles[3], True);
end;


procedure TSettingsForm.BitBtn4Click(Sender: TObject);
begin
   PlayAudio(AudioFiles[4], True);
end;


procedure TSettingsForm.PlayBumpSound();
begin
  PlayAudio(AudioFiles[1], CheckBoxAudio.Checked);
end;


procedure TSettingsForm.PlaySuccessSound();
begin
  PlayAudio(AudioFiles[2], CheckBoxAudio.Checked);
end;


procedure TSettingsForm.PlayFailureSound();
begin
  PlayAudio(AudioFiles[3], CheckBoxAudio.Checked);
end;


procedure TSettingsForm.PlayErrorSound();
begin
  PlayAudio(AudioFiles[4], CheckBoxAudio.Checked);
end;


function TSettingsForm.UseLogFile(): Boolean;
begin
  Result := CheckBoxLog.Checked;
end;


function TSettingsForm.SwapMotors(): Boolean;
begin
  Result := CheckBoxSwapMotors.Checked;
end;


procedure TSettingsForm.FormCreate(Sender: TObject);
begin

  // Set line sensor axis defaults
  ComboBox1.ItemIndex := 3;  // Right Y-axis
  ComboBox2.ItemIndex := 2;  // Right X-axis

  // default line sensor levels at half way
  LeftSensorValue  := 128;
  RightSensorValue := 128;

end;


procedure TSettingsForm.EnableDetectButtons(state: Boolean);
begin
  Button6.Enabled := state;
  Button7.Enabled := state;
  Button8.Enabled := state;
  Button9.Enabled := state;
end;


function TSettingsForm.getLeftWhiteLevel(): Integer;
begin
  Result := StrToInt(EditLeftWhite.Text);
end;


function TSettingsForm.getLeftBlackLevel(): Integer;
begin
  Result := StrToInt(EditLeftBlack.Text);
end;


function TSettingsForm.getRightWhiteLevel(): Integer;
begin
  Result := StrToInt(EditRightWhite.Text);
end;


function TSettingsForm.getRightBlackLevel(): Integer;
begin
  Result := StrToInt(EditRightBlack.Text);
end;


function TSettingsForm.getLeftSensorMap(): Integer;
begin
  Result := ComboBox2.ItemIndex;
end;


function TSettingsForm.getRightSensorMap(): Integer;
begin
  Result := ComboBox1.ItemIndex;
end;


function TSettingsForm.getBumpLevel(): Integer;
begin
  Result := StrToInt(EditBumpLevel.Text);
end;


procedure TSettingsForm.Button6Click(Sender: TObject);
begin
  if (DisplayAnalogWarning()) then
    EditLeftWhite.Text := IntToStr(leftSensorValue);
end;


procedure TSettingsForm.Button7Click(Sender: TObject);
begin
  if (DisplayAnalogWarning) then
    EditLeftBlack.Text := IntToStr(leftSensorValue);
end;


procedure TSettingsForm.Button8Click(Sender: TObject);
begin
  if (DisplayAnalogWarning) then
    EditRightWhite.Text := IntToStr(rightSensorValue);
end;


procedure TSettingsForm.Button9Click(Sender: TObject);
begin
  if (DisplayAnalogWarning) then
    EditRightBlack.Text := IntToStr(rightSensorValue);
end;


// Restrict the TEdits to only accept numbers or backspace for editing
// The MaxLength property of the TEdits is also set to 3 characters.
// How do we restrict it to a valid range, e.g. [0..255] ?
procedure TSettingsForm.EditLeftWhiteKeyPress(Sender: TObject; var Key: Char);
begin
  // allow only digit input & backspace
  if ((Key = #8) or ((Key >= '0') and (Key <= '9'))) then
  else abort;
end;


function TSettingsForm.DisplayAnalogWarning(): Boolean;
begin
  if AnalogButtonOn then
    Result := True
  else
    begin
      MessageDlg('Please press the "Analog" button on the joystick and then ' +
                 'click "Detect Level" again.',
                 mtWarning, [mbOK], 0);
      Result := False;
    end;
end;

end.
