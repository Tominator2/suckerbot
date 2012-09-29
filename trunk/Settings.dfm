object SettingsForm: TSettingsForm
  Left = 252
  Top = 128
  Width = 556
  Height = 353
  Caption = 'Settings'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 19
    Top = 203
    Width = 94
    Height = 13
    Caption = 'Bump Threshold +/-'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 265
    Height = 185
    Caption = 'Sounds'
    TabOrder = 0
    object Label1: TLabel
      Left = 11
      Top = 58
      Width = 27
      Height = 13
      Caption = 'Bump'
    end
    object Label2: TLabel
      Left = 11
      Top = 90
      Width = 41
      Height = 13
      Caption = 'Success'
    end
    object Label3: TLabel
      Left = 11
      Top = 122
      Width = 31
      Height = 13
      Caption = 'Failure'
    end
    object Label4: TLabel
      Left = 11
      Top = 152
      Width = 22
      Height = 13
      Caption = 'Error'
    end
    object Edit1: TEdit
      Left = 57
      Top = 56
      Width = 89
      Height = 21
      Color = clScrollBar
      ReadOnly = True
      TabOrder = 0
      Text = 'Choose a file...'
    end
    object BitBtn1: TBitBtn
      Left = 153
      Top = 54
      Width = 25
      Height = 25
      Hint = 'Play the sound'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = BitBtn1Click
      Glyph.Data = {
        06030000424D060300000000000036000000280000000D000000120000000100
        180000000000D002000000000000000000000000000000000000D8E9ECD8E9EC
        D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
        D8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9ECD8E9EC4B4B4B4B4B4BD8E9ECD8
        E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F0000DF
        0000BF2A4B4B4BD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9EC007F0000DF0000DF0000BF2A4B4B4BD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9EC007F0000DF0000DF0000DF0000BF2A4B4B4BD8E9EC
        D8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F0000DF0000FF0900DF0000
        DF0000BF2A4B4B4BD8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F0000FF
        2A00DF0000FF0900DF0000DF0000BF2A4B4B4BD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9EC007F0055FF0000FF2A00DF0000FF0900DF0000DF0000BF2A4B4B4BD8E9
        EC00D8E9ECD8E9ECD8E9EC007F0055FFAA00FF0900FF2A00DF0000FF0900DF00
        00DF00007F00D8E9EC00D8E9ECD8E9ECD8E9EC007F0055FFAA00FF0900FF0900
        FF2A00DF0055FFAA007F00D8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F00AAFF
        2A00FF0900FF0900FF0900FF2A007F00D8E9ECD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9EC007F00AAFF2A00FF0900FF09AAFF2A007F00D8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9EC007F00AAFFAA00FF09AAFF2A007F00D8E9ECD8E9EC
        D8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F00AAFFAAAAFFAA007F00D8
        E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F00AAFF
        AA007F00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9ECD8E9EC007F00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
        D8E9ECD8E9ECD8E9EC00}
    end
    object Button1: TButton
      Left = 185
      Top = 54
      Width = 72
      Height = 25
      Caption = 'Choose...'
      TabOrder = 2
      OnClick = Button1Click
    end
    object BitBtn2: TBitBtn
      Left = 153
      Top = 86
      Width = 25
      Height = 25
      Hint = 'Play the sound'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = BitBtn2Click
      Glyph.Data = {
        06030000424D060300000000000036000000280000000D000000120000000100
        180000000000D002000000000000000000000000000000000000D8E9ECD8E9EC
        D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
        D8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9ECD8E9EC4B4B4B4B4B4BD8E9ECD8
        E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F0000DF
        0000BF2A4B4B4BD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9EC007F0000DF0000DF0000BF2A4B4B4BD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9EC007F0000DF0000DF0000DF0000BF2A4B4B4BD8E9EC
        D8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F0000DF0000FF0900DF0000
        DF0000BF2A4B4B4BD8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F0000FF
        2A00DF0000FF0900DF0000DF0000BF2A4B4B4BD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9EC007F0055FF0000FF2A00DF0000FF0900DF0000DF0000BF2A4B4B4BD8E9
        EC00D8E9ECD8E9ECD8E9EC007F0055FFAA00FF0900FF2A00DF0000FF0900DF00
        00DF00007F00D8E9EC00D8E9ECD8E9ECD8E9EC007F0055FFAA00FF0900FF0900
        FF2A00DF0055FFAA007F00D8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F00AAFF
        2A00FF0900FF0900FF0900FF2A007F00D8E9ECD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9EC007F00AAFF2A00FF0900FF09AAFF2A007F00D8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9EC007F00AAFFAA00FF09AAFF2A007F00D8E9ECD8E9EC
        D8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F00AAFFAAAAFFAA007F00D8
        E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F00AAFF
        AA007F00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9ECD8E9EC007F00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
        D8E9ECD8E9ECD8E9EC00}
    end
    object Edit2: TEdit
      Left = 57
      Top = 88
      Width = 89
      Height = 21
      Color = clScrollBar
      ReadOnly = True
      TabOrder = 4
      Text = 'Choose a file...'
    end
    object Button2: TButton
      Left = 185
      Top = 86
      Width = 72
      Height = 25
      Caption = 'Choose...'
      TabOrder = 5
      OnClick = Button2Click
    end
    object Edit3: TEdit
      Left = 57
      Top = 120
      Width = 89
      Height = 21
      Color = clScrollBar
      ReadOnly = True
      TabOrder = 6
      Text = 'Choose a file...'
    end
    object Button3: TButton
      Left = 185
      Top = 118
      Width = 72
      Height = 25
      Caption = 'Choose...'
      TabOrder = 7
      OnClick = Button3Click
    end
    object BitBtn3: TBitBtn
      Left = 153
      Top = 118
      Width = 25
      Height = 25
      Hint = 'Play the sound'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnClick = BitBtn3Click
      Glyph.Data = {
        06030000424D060300000000000036000000280000000D000000120000000100
        180000000000D002000000000000000000000000000000000000D8E9ECD8E9EC
        D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
        D8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9ECD8E9EC4B4B4B4B4B4BD8E9ECD8
        E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F0000DF
        0000BF2A4B4B4BD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9EC007F0000DF0000DF0000BF2A4B4B4BD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9EC007F0000DF0000DF0000DF0000BF2A4B4B4BD8E9EC
        D8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F0000DF0000FF0900DF0000
        DF0000BF2A4B4B4BD8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F0000FF
        2A00DF0000FF0900DF0000DF0000BF2A4B4B4BD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9EC007F0055FF0000FF2A00DF0000FF0900DF0000DF0000BF2A4B4B4BD8E9
        EC00D8E9ECD8E9ECD8E9EC007F0055FFAA00FF0900FF2A00DF0000FF0900DF00
        00DF00007F00D8E9EC00D8E9ECD8E9ECD8E9EC007F0055FFAA00FF0900FF0900
        FF2A00DF0055FFAA007F00D8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F00AAFF
        2A00FF0900FF0900FF0900FF2A007F00D8E9ECD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9EC007F00AAFF2A00FF0900FF09AAFF2A007F00D8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9EC007F00AAFFAA00FF09AAFF2A007F00D8E9ECD8E9EC
        D8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F00AAFFAAAAFFAA007F00D8
        E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F00AAFF
        AA007F00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9ECD8E9EC007F00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
        D8E9ECD8E9ECD8E9EC00}
    end
    object BitBtn4: TBitBtn
      Left = 153
      Top = 148
      Width = 25
      Height = 25
      Hint = 'Play the sound'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnClick = BitBtn4Click
      Glyph.Data = {
        06030000424D060300000000000036000000280000000D000000120000000100
        180000000000D002000000000000000000000000000000000000D8E9ECD8E9EC
        D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
        D8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9ECD8E9EC4B4B4B4B4B4BD8E9ECD8
        E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F0000DF
        0000BF2A4B4B4BD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9EC007F0000DF0000DF0000BF2A4B4B4BD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9EC007F0000DF0000DF0000DF0000BF2A4B4B4BD8E9EC
        D8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F0000DF0000FF0900DF0000
        DF0000BF2A4B4B4BD8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F0000FF
        2A00DF0000FF0900DF0000DF0000BF2A4B4B4BD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9EC007F0055FF0000FF2A00DF0000FF0900DF0000DF0000BF2A4B4B4BD8E9
        EC00D8E9ECD8E9ECD8E9EC007F0055FFAA00FF0900FF2A00DF0000FF0900DF00
        00DF00007F00D8E9EC00D8E9ECD8E9ECD8E9EC007F0055FFAA00FF0900FF0900
        FF2A00DF0055FFAA007F00D8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F00AAFF
        2A00FF0900FF0900FF0900FF2A007F00D8E9ECD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9EC007F00AAFF2A00FF0900FF09AAFF2A007F00D8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9EC007F00AAFFAA00FF09AAFF2A007F00D8E9ECD8E9EC
        D8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F00AAFFAAAAFFAA007F00D8
        E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9ECD8E9EC007F00AAFF
        AA007F00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC00D8E9ECD8E9EC
        D8E9ECD8E9EC007F00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
        EC00D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
        D8E9ECD8E9ECD8E9EC00}
    end
    object Edit4: TEdit
      Left = 57
      Top = 149
      Width = 89
      Height = 21
      Color = clScrollBar
      ReadOnly = True
      TabOrder = 10
      Text = 'Choose a file...'
    end
    object Button4: TButton
      Left = 185
      Top = 148
      Width = 72
      Height = 25
      Caption = 'Choose...'
      TabOrder = 11
      OnClick = Button4Click
    end
  end
  object Button5: TButton
    Left = 224
    Top = 280
    Width = 113
    Height = 25
    Caption = 'Close'
    Default = True
    TabOrder = 1
    OnClick = Button5Click
  end
  object GroupBox4: TGroupBox
    Left = 288
    Top = 8
    Width = 251
    Height = 257
    Caption = 'Line Detectors'
    TabOrder = 2
    object GroupBox2: TGroupBox
      Left = 8
      Top = 16
      Width = 234
      Height = 113
      Caption = 'Left Sensor'
      TabOrder = 0
      object Label5: TLabel
        Left = 10
        Top = 24
        Width = 57
        Height = 13
        Caption = 'White Level'
      end
      object Label6: TLabel
        Left = 10
        Top = 54
        Width = 56
        Height = 13
        Caption = 'Black Level'
      end
      object Label11: TLabel
        Left = 11
        Top = 85
        Width = 58
        Height = 13
        Caption = 'Choose Axis'
      end
      object Button6: TButton
        Left = 124
        Top = 19
        Width = 95
        Height = 25
        Caption = 'Detect level'
        TabOrder = 0
        OnClick = Button6Click
      end
      object Button7: TButton
        Left = 124
        Top = 50
        Width = 95
        Height = 25
        Caption = 'Detect level'
        TabOrder = 1
        OnClick = Button7Click
      end
      object ComboBox2: TComboBox
        Left = 81
        Top = 82
        Width = 137
        Height = 21
        ItemHeight = 13
        TabOrder = 2
        Text = 'ComboBox2'
        Items.Strings = (
          'Left   X-axis'
          'Left   Y-axis'
          'Right X-axis'
          'Right Y-axis')
      end
      object EditLeftBlack: TEdit
        Left = 81
        Top = 52
        Width = 29
        Height = 21
        MaxLength = 3
        TabOrder = 3
        Text = '128'
        OnKeyPress = EditLeftWhiteKeyPress
      end
      object EditLeftWhite: TEdit
        Left = 81
        Top = 21
        Width = 29
        Height = 21
        MaxLength = 3
        TabOrder = 4
        Text = '150'
        OnKeyPress = EditLeftWhiteKeyPress
      end
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 136
      Width = 234
      Height = 113
      Caption = 'Right Sensor'
      TabOrder = 1
      object Label7: TLabel
        Left = 10
        Top = 24
        Width = 57
        Height = 13
        Caption = 'White Level'
      end
      object Label8: TLabel
        Left = 10
        Top = 54
        Width = 56
        Height = 13
        Caption = 'Black Level'
      end
      object Label10: TLabel
        Left = 11
        Top = 85
        Width = 58
        Height = 13
        Caption = 'Choose Axis'
      end
      object Button8: TButton
        Left = 126
        Top = 19
        Width = 95
        Height = 25
        Caption = 'Detect level'
        TabOrder = 0
        OnClick = Button8Click
      end
      object Button9: TButton
        Left = 126
        Top = 50
        Width = 95
        Height = 25
        Caption = 'Detect level'
        TabOrder = 1
        OnClick = Button9Click
      end
      object ComboBox1: TComboBox
        Left = 81
        Top = 82
        Width = 140
        Height = 21
        ItemHeight = 13
        TabOrder = 2
        Text = 'ComboBox1'
        Items.Strings = (
          'Left   X-axis'
          'Left   Y-axis'
          'Right X-axis'
          'Right Y-axis')
      end
      object EditRightBlack: TEdit
        Left = 81
        Top = 51
        Width = 29
        Height = 21
        MaxLength = 3
        TabOrder = 3
        Text = '128'
        OnKeyPress = EditLeftWhiteKeyPress
      end
      object EditRightWhite: TEdit
        Left = 81
        Top = 20
        Width = 29
        Height = 21
        MaxLength = 3
        TabOrder = 4
        Text = '150'
        OnKeyPress = EditLeftWhiteKeyPress
      end
    end
  end
  object MediaPlayer1: TMediaPlayer
    Left = 496
    Top = 272
    Width = 253
    Height = 30
    Visible = False
    TabOrder = 3
  end
  object CheckBoxLog: TCheckBox
    Left = 19
    Top = 253
    Width = 129
    Height = 17
    Caption = 'Write data to log file'
    TabOrder = 4
  end
  object CheckBoxSwapMotors: TCheckBox
    Left = 20
    Top = 228
    Width = 97
    Height = 17
    Caption = 'Swap motors'
    TabOrder = 5
  end
  object CheckBoxAudio: TCheckBox
    Left = 19
    Top = 32
    Width = 113
    Height = 17
    Caption = 'Use sound effects'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object EditBumpLevel: TEdit
    Left = 120
    Top = 200
    Width = 29
    Height = 21
    MaxLength = 3
    TabOrder = 7
    Text = '40'
    OnKeyPress = EditLeftWhiteKeyPress
  end
  object OpenDialog1: TOpenDialog
    Left = 464
    Top = 272
  end
end
