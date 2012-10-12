unit AnalogDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TAnalogCheckForm = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetMessage(Message: String);
    function Warn(): Boolean;
  end;

var
  AnalogCheckForm: TAnalogCheckForm;

implementation

{$R *.dfm}

procedure TAnalogCheckForm.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;


procedure TAnalogCheckForm.FormShow(Sender: TObject);
begin
  if CheckBox1.Checked then
    begin
      ModalResult := mrOK;
    end;
end;


procedure TAnalogCheckForm.SetMessage(Message: String);
begin
  Label1.caption := Message;
end;


{ Check to see if we should "warn" the user again } 
function TAnalogCheckForm.Warn(): Boolean;
begin
  Result := not Checkbox1.Checked;
end;

end.
