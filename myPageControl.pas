unit myPageControl;

interface

uses Windows, Forms, Messages, Classes, SysUtils, ComCtrls, Graphics, CommCtrl, controls;

type
  TPageControl = class(ComCtrls.TPageControl)
  private
    bottom1, bottom2, top1: Integer;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  public
  end;

implementation

uses desktop;

function GetWindowsVersion():real;
var
  OSVerInfo:TOSVersionInfo;
begin
  try
    OSVerInfo.dwOSVersionInfoSize := sizeof(TOSVersionInfo);
    if GetVersionEx(OSVerInfo) then
      Result := OSVerInfo.dwMajorVersion+OSVerInfo.dwMinorVersion/10
    else
      Result := 0;
  except
    Result := 0;                              
  end;
end;

procedure TPageControl.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if GetWindowsVersion >= 6 then  //
  begin
    if isThemesactive() then
    begin
      bottom1:=1;
      bottom2:=-4;
      top1:=-2;
    end
    else
    begin
      bottom1:=1;
      bottom2:=-2;
      top1:=-2;
    end;
  end
  else
  begin
    if isThemesactive() then
    begin
      bottom1:=1;
      bottom2:=-4;
      top1:=-2;
    end
    else
    begin
      bottom1:=1;
      bottom2:=-2;
      top1:=-2;
    end;
  end;
end;

{$WARNINGS OFF}
procedure TPageControl.WndProc(var Message: TMessage);
begin
  if(Message.Msg=TCM_ADJUSTRECT) then
  begin
    Inherited WndProc(Message);
    Case TAbPosition of
      tpTop :
        begin
          PRect(Message.LParam)^.Left:=0;
          PRect(Message.LParam)^.Right:=ClientWidth;
          PRect(Message.LParam)^.Top:=PRect(Message.LParam)^.Top+top1;
          PRect(Message.LParam)^.Bottom:=ClientHeight;
        end;
      tpBottom :
        begin
          PRect(Message.LParam)^.Left:=0;
          PRect(Message.LParam)^.Right:=ClientWidth;
          PRect(Message.LParam)^.Bottom:=PRect(Message.LParam)^.Bottom+bottom1;
          PRect(Message.LParam)^.Top:=bottom2;
        end;
    end;
  end
  else
    Inherited WndProc(Message);
end;
{$WARNINGS ON}

procedure TPageControl.WMPaint(var Message: TWMPaint);
var
  h, h2: HDC;
  N: integer;
begin
  inherited;
  h:= Canvas.Handle;
  h2 := GetDC(Handle);
  N:= SaveDC(h2);
  Canvas.Handle := h2;
  Canvas.Pen.Color := clBtnFace;
  Canvas.Pen.Style := psSolid;

  if self.TabPosition = tpBottom then  // delete 3D
  begin
    Canvas.Pen.Color := clWindow;
    Canvas.Pen.Width := 3;
    Canvas.MoveTo(2, ClientHeight-2);
    Canvas.LIneTo(ClientWidth-2, ClientHeight-2);
  end
  else if self.TabPosition = tpTop then // for better visible
  begin
    Canvas.Pen.Color := clBtnShadow;
    Canvas.Pen.Width := 1;
    Canvas.MoveTo(2, TabHeight+3);
    Canvas.LIneTo(ClientWidth, TabHeight+3);
    Canvas.Pixels[ClientWidth-1, TabHeight+2] := clWindow;
  end;
  Canvas.Handle := h;
  RestoreDC(h2, N);
  DeleteDC(h2);
end;

end.
