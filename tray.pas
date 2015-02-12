unit tray;

interface

uses Vcl.ExtCtrls, shellapi, windows, messages, Vcl.Controls, System.Variants, sysutils;

type

  TTrayMessage = Class
  private
    hidetimer: TTimer;
    tray: TTrayIcon;
    procedure HideTimerTimer(Sender: TObject);
  public
    Title: string;
    Text: string;
    TimeOut: integer; // sek
    procedure Show;
    procedure Hide;
    constructor Create(CoolTray: TTrayIcon);
    destructor Destroy; override;
  End;

implementation

type
  pclick=procedure(sender:TObject);

procedure TTrayMessage.Show;
begin
  tray.BalloonHint := Text;
  tray.BalloonTitle := Title;
  tray.ShowBalloonHint;
  hidetimer.Interval := TimeOut * 1000;
  hidetimer.Enabled := true;
end;

procedure TTrayMessage.Hide;
begin
  hidetimer.Enabled := false;
  Tray.BalloonHint := '';
  Tray.BalloonTitle := '';
  Tray.ShowBalloonHint;
end;

procedure TTrayMessage.HideTimerTimer(Sender: TObject);
begin
  hide;
end;

Constructor TTrayMessage.Create(CoolTray: TTrayIcon);
begin
  inherited Create;
  hidetimer := TTimer.Create(CoolTray);
  hidetimer.Enabled := false;
  hidetimer.OnTimer := HideTimerTimer;
  tray := CoolTray;
end;

destructor TTrayMessage.Destroy;
begin
  freeandnil(hidetimer);
  inherited Destroy;
end;

end.
