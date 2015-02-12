unit newuser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfmNewUser = class(TForm)
    Label_nik: TLabel;
    Label_ip: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmNewUser: TfmNewUser;

implementation

uses CommonLib, MAIN, language;

{$R *.dfm}

procedure TfmNewUser.BitBtn1Click(Sender: TObject);
begin
 if trim(edit1.Text)='' then exit;
 if not testip(trim(edit2.text)) then
 begin
    showmessage(Lang.Get('bad_ip'));
    edit2.setfocus;
 end
 else
    self.modalresult:=mrok;
end;

procedure TfmNewUser.FormActivate(Sender: TObject);
begin
  self.modalresult:=mrcancel;
end;

end.
