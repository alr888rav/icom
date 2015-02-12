unit ithreads;

interface

uses
  Classes, dialogs;

type
  TiThread = class(TThread)
  private
    url: string;
    procedure DoVisual;
  protected
  public
    constructor Create(adr:string);
    procedure Execute; override;
  end;

implementation

constructor TiThread.Create(adr:string);
begin
  url := adr;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TiThread.DoVisual;
begin
  showmessage(url);
end;

procedure TiThread.Execute;
begin
  showmessage('start');
  Synchronize(DoVisual);
  showmessage('end');
end;


end.
