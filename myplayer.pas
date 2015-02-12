unit myplayer;

interface

uses windows, forms, classes, sysutils, Vcl.Controls, vcl.mplayer;

type
  TPlayer = class(TMediaPlayer)
    procedure PlayerNotify(Sender: TObject);
  end;

implementation

procedure TPlayer.PlayerNotify(Sender: TObject);
begin
  with Sender as TMediaPlayer do
  begin
    Notify := True;
    Self.Free;
  end;
end;

end.
