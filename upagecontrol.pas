// рисование табов и кнопок закрытия
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
  if (Index>0) then  // для 0 вкладки нет кнопки
    Result:=PtInRect(GetButtonRect(Control, Index), Point(X, Y));
end;

procedure drawCloseButton(control:TCustomTabControl; rect: Trect; State: boolean);
begin
  with DrawButtonFace(Control.Canvas, Rect, 1, bsAutoDetect, true, true, false) do
  begin
    with control.Canvas do
    begin
      // активная кнопка
      if state then
      begin
        Brush.color:=clMaroon;
        fillrect(rect);
      end
      else
      begin
        brush.color:=clSilver;
        fillrect(rect);
      end;
      // крестик внутри
      Pen.Color:=IfThen(State, clWhite, clWhite);
      Pen.Width:=2;
      MoveTo(Left+1, Top+1);
      LineTo(Right-3, Bottom-3);
      MoveTo(Right-3, Top+1);
      LineTo(Left+1, Bottom-3);
    end;
  end;
end;

// рисование закладки
procedure DrawTab(Control:TCustomTabControl; Index:Integer; Rect:Trect; State:Boolean);
var
 bm:tbitmap;
 lf, tp:integer;
 dl:integer;
 inactive_color:TColor;
 rt:TRect;
const
 active_color= clActiveCaption;
begin
  inactive_color := clWindow;
  with Control.Canvas do
  begin
    lock;
    try
      // фон вкладки
      if state then
      begin
         brush.color:=Active_color;
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
           pen.color := inactive_color;
           moveto(rt.Left-3, rt.Top+1);
           lineto(rt.Left-3, rt.Bottom+2);
           rt.Top := rt.Top - 5;
           rt.left:=rt.left-3;
           fillrect(rt);
         end
         else
         begin
           pen.color := inactive_color;
           moveto(rect.Left-3, rect.Top-2);
           lineto(rect.Left-3, rect.Bottom-2);
           fillrect(rect);
         end;
      end;
      bm:=tbitmap.create;
      try
        if TPageControl(Control).TabPosition=tpTop then
        begin
          if state then
            dl:=1
          else
            dl:=2;
        end
        else
        begin
          if state then
            dl:=-1
          else
            dl:=-2;
        end;
        bm.transparent:=true;
        // получение картинки
        if (Tpagecontrol(control).pages[index].imageindex>=0)
        and(Tpagecontrol(control).pages[index].imageindex<Tpagecontrol(control).Images.count) then
        begin
          // так прозрачная картинка и под хр и под вин7
          bm.Height:=mainform.Pagecontrol1.Images.Height;
          bm.Width:=mainform.Pagecontrol1.Images.Width;
          mainform.Pagecontrol1.Images.draw(bm.Canvas, 0, 0, Tpagecontrol(control).pages[index].imageindex, dsnormal, itmask);
          mainform.Pagecontrol1.Images.draw(bm.Canvas, 0, 0, Tpagecontrol(control).pages[index].imageindex, dsnormal, itimage);
          bm.TransParentColor := BM.Canvas.pixels[1,1];
        end;
        // название
        if (not State)or(ThemesActive) then
          Font.Color:=clBtnText
        else
          Font.Color:=clWindow;
        font.Size:=8;
        lf:=Rect.Left+bm.width+3;
        tp:=Rect.top+((Rect.bottom-Rect.Top)div 2)-(TextHeight('A') div 2);
        Brush.Style := bsClear;  // текст на прозрачном фоне
        TextRect(Rect, lf, tp+dl, TPageControl(Control).Pages[Index].Caption);
        // рисуем картинку
        if not bm.Empty then
        begin
          bm.TransparentMode := tmAuto;
          draw(rect.left+2, rect.top+(((rect.bottom-rect.top)-bm.height)div 2)+dl, bm);
        end
      finally
        bm.free;
      end;
      // рисуем кнопку
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