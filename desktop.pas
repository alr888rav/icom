unit desktop;

interface

uses menus;

type
  Tpos = (POSLEFT, POSRIGHT, POSTOP, POSBOTTOM);

Function Taskbar: integer;
Function TaskbarPos: Tpos;
function WindowTitle: integer;
function WindowBorder: integer;
function SysButtonWidth: integer;
function SysButtonHeight: integer;
function isThemesActive:boolean;
function GetLayoutShortName: String;
function MenuWidth(menu:TPopupMenu):integer;
function MenuHeight: integer;
function ScrollBar: integer;

implementation

uses windows, forms, messages, classes, sysutils, graphics, StdCtrls, ExtCtrls,
  Global;

{$WARNINGS OFF}
function GetLayoutShortName: String;
var
  LayoutName: array [0 .. KL_NAMELENGTH + 1] of Char;
  LangName: array [0 .. 1024] of Char;
begin
  Result := '??';
  if GetKeyboardLayoutName(@LayoutName) then
  begin
    if GetLocaleInfo(StrToInt('$' + StrPas(LayoutName)),  LOCALE_SABBREVLANGNAME,  @LangName, SizeOf(LangName) - 1) <> 0 then
      Result := StrPas(LangName);
  end;
  Result := AnsiUpperCase(Copy(Result, 1, 2));
end;
{$WARNINGS ON}

function isThemesActiveOLD:boolean;
begin
  if windowBorder >= 8 then
    result := true
  else
    result := false;
end;
{$WARNINGS OFF}
function isThemesActive:boolean;
type
  func=function:boolean;
var
  lib: THandle;
  OSVerInfo: TOSVersionInfo;
  ver:string;
  pgetn:func;
begin
  OSVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(OSVerInfo);
  ver := inttostr(OSVerInfo.dwMajorVersion)+'.'+inttostr(OSVerInfo.dwMinorVersion);
  if ver >= '6.2'  then
    result := true
  else if ver <= '5.0'  then
    result := false
  else
  begin
    try
      lib := SafeLoadLibrary(pchar('UxTheme.dll'));
      try
        pgetn := GetProcAddress(lib, 'IsAppThemed');
        if addr(pgetn) = nil then
          result := isThemesActiveOLD
        else
          result := pgetn;
      finally
        freelibrary(lib);
      end;
    except
      result := true;
    end;
  end;
end;
{$WARNINGS ON}

function ScrollBar: integer;
begin
  result := GetSystemMetrics(SM_CXHSCROLL);
end;


function SysButtonWidth: integer;
begin
  result := GetSystemMetrics(SM_CXSIZE);
end;

function SysButtonHeight: integer;
begin
  result := GetSystemMetrics(SM_CYSIZE);
end;

function WindowBorder: integer;
begin
  result := GetSystemMetrics(SM_CXFRAME);
end;

function MenuHeight: integer;
begin
  result := GetSystemMetrics(SM_CYMENU);
end;

function WindowTitle: integer;
begin
  result := GetSystemMetrics(SM_CYCAPTION);
end;

// на переднем плане?
function IsTop(title: string): boolean;
var
  wnd: hwnd;
  buff: array [0 .. 500] of char;
  list: TStringList;
begin
  list := TStringList.Create;
  try
    wnd := GetWindow(GetTopWindow(GetDesktopWindow), gw_HWndFirst);
    while wnd <> 0 DO
    begin
      if IsWindowVisible(wnd) then
      begin
        GetWindowText(wnd, buff, length(buff));
        list.Add(inttostr(wnd) + ' ' + buff);
      end;
      wnd := GetWindow(wnd, gw_hWndNext);
    end;
    if Pos(title + ' ', list[1]) <> 0 then
      result := true
    else
      result := false;
  finally
    myFreeAndNil(list);
  end;
end;

function tostr(msg: PCHAR):string;
var
  tmp: String;
  i: integer;
begin
  tmp := '';
  for i:= 1 to 256 do
    if msg[i-1] = #0 then
      break
    else
      tmp := tmp + msg[i-1];
  result := trim(tmp);
end;
{$WARNINGS OFF}
Procedure GetMenuFont(var Size:integer; var Name:string);
var
 nonClientMetrics: TNONCLIENTMETRICS;
begin
  FillChar(nonClientMetrics, SizeOf(nonClientMetrics), 0);
  nonClientMetrics.cbSize := nonClientMetrics.SizeOf;
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, nonClientMetrics.cbSize, addr(nonClientMetrics), 0);
  size := nonClientMetrics.lfMenuFont.lfHeight;
  name := tostr(nonClientMetrics.lfMenuFont.lfFaceName);
end;
{$WARNINGS ON}

function MenuWidth(menu:TPopupMenu):integer;
var
  Val,Biggest: Integer;
  i: integer;
  bm: TBitmap;
  fsize: integer;
  fname:string;
  bsize: integer;
//const
//  spaces = 5;
begin
 if assigned(menu.Images) then
   bsize := menu.Images.Width
 else
   bsize := 0;
 GetMenuFont(fSize, fname);
   Biggest := 0;
 bm := TBitmap.Create;
 try
   bm.Width := 500;
   bm.Height := 100;
   bm.canvas.Font.size := fsize;
   bm.Canvas.Font.Name := fname;
   for i:= 0 to Menu.Items.Count - 1 do
   begin
     Val := bm.Canvas.TextWidth(Menu.Items[i].Caption);
     if Val > Biggest then
       Biggest := Val;
   end;
 finally
   bm.Free;
   result := Biggest + bsize;
 end;
end;

// где панель задач?
{$WARNINGS OFF}
Function TaskbarPos: Tpos;
var
  r: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, addr(r), 0);
  if (r.left <> 0) then
    result := POSLEFT
  else if (r.top <> 0) then
    result := POSTOP
  else if (r.right <> screen.width) then
    result := POSRIGHT
  else
    result := POSBOTTOM;
end;

// "высота" панели задач, с учетом расположения
Function Taskbar: integer;
var
  r: TRect;
  p: Tpos;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, addr(r), 0);
  p := TaskbarPos;
  case p of
    POSLEFT:
      result := r.left;
    POSRIGHT:
      result := screen.width - r.right;
    POSTOP:
      result := r.top;
  else
    result := screen.Height - r.Bottom;
  end;
end;
{$WARNINGS ON}

end.
