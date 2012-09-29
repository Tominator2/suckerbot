{   Copyright 2012 Thomas Tilley.
    http://www.tomtilley.net/suckerbot/

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

{ To Do:
  ------
  - If there is only one joystick should we simply choose it?

  - Should we check for more than one joystick?  Perhaps we could hook up a
    second joystick to drive the robot instead of keys. }

unit ChooseJoystick;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvHidControllerClass, StrUtils;

type
  TSelectJoystickForm = class(TForm)
    Label1: TLabel;
    ListBox1: TListBox;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    HidCtl: TJvHidDeviceController;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HidCtlArrival(HidDev: TJvHidDevice);
  private
    { Private declarations }
    function DeviceName(HidDev: TJvHidDevice): string;
  public
    { Public declarations }
    function Show(Params: TStrings): Integer;
  end;

var
  SelectJoystickForm: TSelectJoystickForm;
  LocalParams: TStrings;

implementation

{$R *.dfm}

procedure TSelectJoystickForm.ButtonOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;


procedure TSelectJoystickForm.ButtonCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;


function TSelectJoystickForm.Show(Params: TStrings): Integer;
begin
  LocalParams := Params;
  Result := ShowModal;  //call original show function
end;


procedure TSelectJoystickForm.ListBox1Click(Sender: TObject);
var
  Dev: TJvHidDevice;
begin
  // if valid joystick selected then set pid and vid
  Dev := TJvHidDevice(ListBox1.Items.Objects[ListBox1.ItemIndex]);
  HidCtl.CheckOutByProductName(Dev, ListBox1.Items.Strings[ListBox1.ItemIndex]);
  Dev.NumInputBuffers := 128;
  Dev.NumOverlappedBuffers := 128;
  LocalParams.Insert(0, IntToStr(Dev.Attributes.VendorID));
  LocalParams.Insert(1, IntToStr(Dev.Attributes.ProductID));
  ButtonOK.Enabled := True;
  //Dev.GetV

  //ShowMessage(De);
end;


function TSelectJoystickForm.DeviceName(HidDev: TJvHidDevice): string;
begin
  if HidDev.ProductName <> '' then
    Result := HidDev.ProductName
  else
    Result := Format('Device VID=%.4x PID=%.4x',
      [HidDev.Attributes.VendorID, HidDev.Attributes.ProductID]);
  if HidDev.SerialNumber <> '' then
    Result := Result + Format(' (Serial=%s)', [HidDev.SerialNumber]);
end;


procedure TSelectJoystickForm.FormShow(Sender: TObject);
begin
  if (ListBox1.Items.Count = 0) then
    HidCtl.Enumerate;
end;

procedure TSelectJoystickForm.HidCtlArrival(HidDev: TJvHidDevice);
Var
   N: Integer;
begin
  // Only add joysticks to the list of devices

  // note that according tro Top Level Collections we could use the Usage ID
  // and Usage Page values to identify a Joystick  (ID 0x04, Page, 0x01)
  // but this is not reported by the OKER test joystick via the HIDKomponente
  // UsagesDemo

  if AnsiContainsText(String(HidDev.ProductName),'joy') then
    begin
      N := ListBox1.Items.Add(DeviceName(HidDev));
      ListBox1.Items.Objects[N] := HidDev;
    end

end;

end.
