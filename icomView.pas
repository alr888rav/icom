unit icomView;

interface

uses vcl.controls, activex, comobj, variants, classes, IEbrowser;

type
  TIcomViewer = class(TIEBrowser)
  private
  public
    objname: string;
    constructor Create(AOwner: TComponent); override;
  protected
  end;

implementation

constructor TIcomViewer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.Align := alClient;
end;

end.
