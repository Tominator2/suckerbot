object SelectJoystickForm: TSelectJoystickForm
  Left = 398
  Top = 193
  Width = 292
  Height = 206
  Caption = 'Select Joystick'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 86
    Height = 13
    Caption = 'Choose a joystick:'
  end
  object ListBox1: TListBox
    Left = 8
    Top = 40
    Width = 265
    Height = 81
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object ButtonOK: TButton
    Left = 104
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    Enabled = False
    TabOrder = 1
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 200
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = ButtonCancelClick
  end
  object HidCtl: TJvHidDeviceController
    OnArrival = HidCtlArrival
    Left = 248
    Top = 8
  end
end
