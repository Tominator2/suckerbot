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

program Suckerbot;

uses
  Forms,
  ControlForm in 'ControlForm.pas' {MainForm},
  ChooseJoystick in 'ChooseJoystick.pas' {SelectJoystickForm},
  Settings in 'Settings.pas' {SettingsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Suckerbot';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSelectJoystickForm, SelectJoystickForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.Run;
end.
