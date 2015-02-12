unit about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, shellapi;

type
  TfmAbout = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    sLabel1: TLabel;
    sLabel2: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAbout: TfmAbout;

implementation

uses main, Global, VERS;

{$R *.dfm}

procedure TfmAbout.FormCreate(Sender: TObject);
begin
  self.scaled:=false;
  fmabout.caption:=ititle;
  label1.caption:='Version '+delbuild(ver);
  slabel2.caption:=chr($a9)+' '+slabel2.caption;
  if FileExists(htmldir+'smiles\logo.gif') then
    Image1.Picture.LoadFromFile(htmldir+'smiles\logo.gif');
end;

end.
