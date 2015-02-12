// ��������� ����� � ������ ��������
unit UPageControl;

interface

uses
  windows, ComCtrls, Types, graphics, controls, sysutils;

function GetIndexTab(Control:TCustomTabControl; X, Y: Integer; var Index:Integer):Boolean;
procedure DrawTab(Control:TCustomTabControl; Index:Integer; Rect:Trect; State:Boolean);
function GetButtonRect(Control:TCustomTabControl; Index:integer):TRect;
procedure drawCloseButton(control:TCustomTabControl; rect: Trect; State: boolean);

implementation

uses
  Math, Buttons, Classes, imglist, main, desktop;

function GetButtonRect(Control:TCustomTabControl; Index:integer):TRect;
begin
  with Control.TabRect(Index) do
  begin
    Result.Right:=Right-5;
    Result.Top:=Top+5;
    Result.Bottom:=Result.Top+Control.Canvas.TextHeight('0');
    Result.Left:=Result.Right-(Result.Bottom-Result.Top);
  end;
end;

function GetIndexTab(Control:TCustomTabControl; X, Y: Integer; var Index:Integer):Boolean;
begin
  Result:=false;
  Index:=Control.IndexOfTabAt(X, Y);
  if (Index>0) then  // ��� 0 ������� ��� ������
    Result:=PtInRect(GetButtonRect(Control, Index), Point(X, Y));
end;

procedure drawCloseButton(control:TCustomTabControl; rect: Trect; State: boolean);
begin
  with DrawButtonFace(Control.Canvas, Rect, 1, bsAutoDetect, true, true, false) do
  begin
    with control.Canvas do
    begin
      // �������� ������
      if state then
      begin
        Brush.color:=clMaroon; //$2C43B8;
        fillrect(rect);
      end
      else
      begin
        brush.color:=clSilver;
        fillrect(rect);
      end;
      // ������� ������
      Pen.Color:=IfThen(State, clWhite, clWhite);
      Pen.Width:=2;
      MoveTo(Left+1, Top+1);
      LineTo(Right-3, Bottom-3);
      MoveTo(Right-3, Top+1);
      LineTo(Left+1, Bottom-3);
    end;
  end;
end;

// ��������� ��������
procedure DrawTab(Control:TCustomTabControl; Index:Integer; Rect:Trect; State:Boolean);
var
 bm:tbitmap;
 lf, tp:integer;
 dl:integer;
 inactive_color:TColor;
 rt:TRect;
const
 active_color= clActiveCaption; //clMenuHighlight;
begin
  if ThemesActive then
    inactive_color := clWindow
  else
    inactive_color := clBtnFace;
  with Control.Canvas do
  begin
    lock;
    try
      // ��� �������
      if state then
      begin
         brush.color:=Active_color;
         rect.Bottom := rect.Bottom - 1;
         fillrect(rect);
      end
      else
      begin
         brush.color:=inactive_color;
         pen.Width := 1;
         pen.color := $e3e3e3;
         if TPageControl(Control).TabPosition=tpTop then
         begin
           rt:=rect;
           moveto(rt.Left-4, rt.Top+1);
           lineto(rt.Left-4, rt.Bottom+2);
           pen.color := clWhite;
           moveto(rt.Left-3, rt.Top+1);
           lineto(rt.Left-3, rt.Bottom+2);
           rt.left:=rt.left-3;
           fillrect(rt);
         end
         else
         begin
           pen.color := clWhite;
           moveto(rect.Left-3, rect.Top-2);
           lineto(rect.Left-3, rect.Bottom-2);
           fillrect(rect);
         end;
      end;
      bm:=tbitmap.create;
      try
        if TPageControl(Control).TabPosition=tpTop then
          dl:=1
        else
          dl:=-1;
        if not state then
          dl:=dl+2;
        bm.transparent:=true;
        // ��������� ��������
        if (Tpagecontrol(control).pages[index].imageindex>=0)
        and(Tpagecontrol(control).pages[index].imageindex<Tpagecontrol(control).Images.count) then
        begin
          // ��� ���������� �������� � ��� �� � ��� ���7
          bm.Height:=mainform.Pagecontrol1.Images.Height;
          bm.Width:=mainform.Pagecontrol1.Images.Width;
          mainform.Pagecontrol1.Images.draw(bm.Canvas, 0, 0, Tpagecontrol(control).pages[index].imageindex, dsnormal, itmask);
          mainform.Pagecontrol1.Images.draw(bm.Canvas, 0, 0, Tpagecontrol(control).pages[index].imageindex, dsnormal, itimage);
          bm.TransParentColor := BM.Canvas.pixels[1,1];
        end;
        // ��������
        Font.Color:=clblack;
        font.Size:=8;
        lf:=Rect.Left+bm.width+3;
        tp:=Rect.top+((Rect.bottom-Rect.Top)div 2)-(TextHeight('A') div 2);
        Brush.Style := bsClear;  // ����� �� ���������� ����
        TextRect(Rect, lf, tp+dl, TPageControl(Control).Pages[Index].Caption);
        // ������ ��������
        if not bm.Empty then
        begin
          bm.TransparentMode := tmAuto;
          draw(rect.left+2, rect.top+(((rect.bottom-rect.top)-bm.height)div 2)+dl, bm);
        end
      finally
        bm.free;
      end;
      // ������ ������
      Pen.Mode:=pmCopy;
      if index<>0 then
      begin
        Rect:=GetButtonRect(Control, Index);
        drawCloseButton(Control, rect, state);
      end;
    finally
      unlock;
    end;
  end;
end;

end.