{
The contents of this file are subject to the GNU General Public License, version 3
http://opensource.org/licenses/gpl-3.0.html
}

unit upassword;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfmPassword = class(TForm)
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPassword: TfmPassword;

implementation

{$R *.dfm}

uses desktop, main;

procedure TfmPassword.FormShow(Sender: TObject);
begin
  if strpas(psw_ra) > '' then
  begin
    psw_lang := LoadKeyboardLayout(psw_ra, KLF_ACTIVATE);
    ActivateKeyboardLayout(psw_lang, 0);
  end;
  BringToFront;
  edit1.SetFocus;
  Timer1Timer(nil);
end;

procedure TfmPassword.Timer1Timer(Sender: TObject);
begin
  label1.Caption := GetLayoutShortName;
  label1.Hint := label1.Caption;
end;

end.
