unit commonlib;

interface

uses controls, classes, sysutils, Graphics, windows, jpeg, mmsystem, forms, mplayer, JvGIFCtrl, shellapi, dialogs,
 Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, myplayer;

procedure mysound(snd: string);
function notext(msg: string): boolean;
procedure GetImageSize(fn: String; var x, y: word);
function delsym(msg: string): string;
function urlEncode(Value: string; Force: boolean = false): string;
function urlDecode(Value: string): string;
Function AddHK(var atm: ATOM; hot1, hot2, hot3: string): boolean;
function LeftDown: boolean;
function CtrlDown: boolean;
function ShiftDown : Boolean;
function AltDown : Boolean;
function MyFileSize(FileName: string): Longint;
function FileDateTime(FileName: string): TDateTime;
function isfullscreen: boolean;
Function ScreenSaver: boolean;
function testIP(ip: string): boolean;
function DecodeErr(e_message: string): string;
procedure DeleteFolder(FolderName: string);
function IsSmallFonts: boolean;
procedure UpdateFonts;
function toint(ss: string): integer;
function GetWindowsVersion(var ver_num: string): String;
procedure SetProgramLocale();
function GetIcon(fname: string; var bmp: Graphics.Tbitmap): int64;
Procedure RunProcess(exe: string; param: string = '');
function getsl(List: TStringList; name: string): string;
procedure Delay(msecs: Longint);
procedure SafeExec(url:string);
procedure Exec(url:string);
function IIF(expr:boolean; value_true, value_false:variant):variant;
function InternalFile(fname: string):boolean;
function Darker(Color:TColor; Percent:Byte):TColor;
function Lighter(Color:TColor; Percent:Byte):TColor;
function isImage(filename: string):boolean;
procedure myCopyfile(source, target: string);

implementation

uses MAIN, ulog, global;

procedure myCopyfile(source, target: string);
begin
  copyfile(PChar(source), PChar(target), False);
end;

function isImage(filename: string):boolean;
var
  ext: string;
begin
  ext := uppercase(extractfileext(filename));
  if (ext='.GIF') or (ext = '.PNG') or (ext = '.JPG') or (ext = '.JPEG') or (ext = '.BMP') or (ext = '.ICO')then
    result := true
  else
    result := false;
end;

// картинки из сообщения
function InternalFile(fname: string):boolean;
begin
  if (Copy(uppercase(fname), 1, 4) = ImgName+'_') or (Copy(uppercase(fname), 1, 4) = AniName+'_') then
    result := true
  else
    result := false;
end;

function IIF(expr:boolean; value_true, value_false:variant):variant;
begin
  if expr then
    result:=value_true
  else
    result:=value_false;
end;

procedure Delay(msecs: Longint);
begin
  Sleep(msecs);
end;

function getsl(List: TStringList; name: string): string;
var
  I: integer;
begin
  result := '';
  if (name > '') then // сначала по имени
  begin
    name := '#' + name;
    for I := 0 to List.count - 1 do
      if List.strings[I] = name then
      begin
        result := List.strings[I + 1];
        Break;
      end;
  end;
end;

procedure SafeExec(url:string);
const
  saveExt:array[1..5]of string=('EXE','COM','BAT','CMD','REG');
var
  i:integer;
  safe:boolean;
  ext: string;
begin
  ext := uppercase(ExtractFileExt(url));
  safe := true;
  for i:=1 to length(saveExt) do
    if pos(ext, '.'+saveExt[i])<>0 then
    begin
      safe := false;
      break;
    end;
  if safe then
    exec(url)
  else
  begin
    if messagedlg(lang.Get('not_safe'), mtConfirmation, [mbYes, mbNo], 0)=mrYes then
      exec(url)
  end;
end;

procedure Exec(url:string);
var
  rz: Windows.HINST;
begin
  rz := ShellExecute(application.Handle, 'open', pchar(url), nil, nil, SW_SHOW);
  if (rz = SE_ERR_NOASSOC) or (rz = SE_ERR_ASSOCINCOMPLETE) then
    // нет ассоциации - вызов окна открыть с помощью
    ShellExecute(application.Handle, 'open', pchar('rundll32.exe'), pchar('shell32.dll,OpenAs_RunDLL ' + url),
      nil, SW_SHOWNORMAL);
end;

  // запуск ехе с поиском в path
Procedure RunProcess(exe: string; param: string = '');
var
  buf: array [0 .. 255] of char;
  buf2: pchar;
begin
  if SearchPath(nil, pchar(exe), nil, length(buf), buf, buf2) > 0 then
    exe := StrPas(buf);
  ShellExecute(0, nil, pchar('"' + exe + '"'), pchar(param), pchar(extractfilepath(exe)), SW_SHOW);
end;

// иконка файла
function GetIcon(fname: string; var bmp: Graphics.Tbitmap): int64;
var
  Icon: TIcon;
  shInfo: TSHFileInfo;
  sFileType: string;
  bt1, bt: Graphics.Tbitmap;
begin
  Icon := TIcon.Create;
  bt := Graphics.Tbitmap.Create;
  bt1 := Graphics.Tbitmap.Create;
  try
    // get details about file type from SHGetFileInfo
    SHGetFileInfo(pchar(fname), 0, shInfo, SizeOf(shInfo), SHGFI_USEFILEATTRIBUTES or SHGFI_ICON or SHGFI_SMALLICON or SHGFI_SYSICONINDEX);
    sFileType := shInfo.szTypeName;
    // assign icon
    bt1.Width := 16;
    bt1.Height := 16;
    bt.Width := bmp.Width;
    bt.Height := bmp.Height;
    result := trunc(shInfo.hIcon);
    if shInfo.hIcon <> 0 then
    begin
      Icon.Handle := shInfo.hIcon;
      bt1.Canvas.Draw(0, 0, Icon); // сначала с иконки 16х16
      bt.Canvas.StretchDraw(rect(0, 0, bt.Width, bt.Height), bt1); // потом растянем
    end
    else
    begin
      bt.Canvas.Brush.Color := clBtnFace;
      bt.Canvas.FillRect(rect(0, 0, bt.Width, bt.Height));
    end;
    bmp.Assign(bt);
  finally
    myFreeAndNil(Icon);
    myFreeAndNil(bt);
    myFreeAndNil(bt1);
  end;
end;

// узнаем кодовую страницу, которая указана в региональных настройках системы для неюникодных программ и устанавливаем для текущей программы
procedure SetProgramLocale();
var
  sLocale: string;
begin
  with SysLocale do
    sLocale := (Format('%.4x', [DefaultLCID]));
  SetThreadLocale(StrToInt('$' + sLocale));
end;

// 32 или 64 бит
function Is64BitWindows: boolean;
var
  IsWow64Process: function(hProcess: THandle; out Wow64Process: Bool): Bool; stdcall;
  Wow64Process: Bool;
begin
  IsWow64Process := GetProcAddress(GetModuleHandle(Kernel32), 'IsWow64Process');

  Wow64Process := false;
  if Assigned(IsWow64Process) then
    Wow64Process := IsWow64Process(GetCurrentProcess, Wow64Process) and Wow64Process;

  result := Wow64Process;
end;

// версия windows
function GetWindowsVersion(var ver_num: string): String;
var
  OSVerInfo: TOSVersionInfo;
  bits: string;
begin
  OSVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(OSVerInfo) then
  begin
    if Is64BitWindows then
      bits := ' x64'
    else
      bits := '';
    case OSVerInfo.dwPlatformId of
      VER_PLATFORM_WIN32_WINDOWS:
        if (OSVerInfo.dwMajorVersion = 4) AND (OSVerInfo.dwBuildNumber = 950) then
          result := 'Windows 95'
        else if (OSVerInfo.dwMajorVersion = 4) AND (OSVerInfo.dwMinorVersion = 10) AND (OSVerInfo.dwBuildNumber = 1998)
        then
          result := 'Windows 98'
        else if (OSVerInfo.dwMinorVersion = 90) then
          result := 'Windows Me';

      VER_PLATFORM_WIN32_NT:
        if OSVerInfo.dwMajorVersion = 3 then
          result := 'Windows NT 3.51'
        else if OSVerInfo.dwMajorVersion = 4 then
          result := 'Windows NT 4.0'
        else if OSVerInfo.dwMajorVersion = 5 then
        begin
          if OSVerInfo.dwMinorVersion = 0 then
            result := 'Windows 2000'
          else if OSVerInfo.dwMinorVersion = 1 then
            result := 'Windows XP'
          else if OSVerInfo.dwMinorVersion = 2 then
            result := 'Windows XP x64'
        end
        else if OSVerInfo.dwMajorVersion = 6 then
        begin
          if OSVerInfo.dwMinorVersion = 0 then
            result := 'Windows Vista' + bits
          else if OSVerInfo.dwMinorVersion = 1 then
            result := 'Windows 7' + bits
          else if OSVerInfo.dwMinorVersion = 2 then
            result := 'Windows 8' + bits
          else if OSVerInfo.dwMinorVersion = 3 then
            result := 'Windows 8.1' + bits
          else if OSVerInfo.dwMinorVersion = 4 then
            result := 'Windows 10' + bits;
        end;
      VER_PLATFORM_WIN32s:
        result := 'Win32s';
    end;
  end
  else
    result := 'Windows ' + inttostr(OSVerInfo.dwMajorVersion) + '.' + inttostr(OSVerInfo.dwMinorVersion) + bits;
  ver_num := inttostr(OSVerInfo.dwMajorVersion) + '.' + inttostr(OSVerInfo.dwMinorVersion) + '.' +
    inttostr(OSVerInfo.dwBuildNumber);
end;

procedure UpdateFonts;
var
  i,j:Integer;
  f:Tform;
begin
  Screen.MenuFont.Name := 'Arial';
  for i := 0 to Application.ComponentCount-1 do
    if Application.Components[i] is TForm then
    begin
      f := TForm(Application.Components[i]);
      f.Scaled := False;
      for j := 0 to  f.ComponentCount-1 do
      begin
        if f.Components[j] is TLabel then
          Tlabel(f.Components[j]).ParentFont := true
        else if f.Components[j] is TPanel then
          Tpanel(f.Components[j]).ParentFont := true
        else if f.Components[j] is TPanel then
          Tpanel(f.Components[j]).ParentFont := true
        else if f.Components[j] is TButton then
          TButton(f.Components[j]).ParentFont := true
        else if f.Components[j] is TSpeedButton then
          TSpeedButton(f.Components[j]).ParentFont := true
        else if f.Components[j] is TBitBtn then
          TBitBtn(f.Components[j]).ParentFont := true
        else if f.Components[j] is TCheckBox then
          TCheckBox(f.Components[j]).ParentFont := true
        else if f.Components[j] is TRadioButton then
          TRadioButton(f.Components[j]).ParentFont := true
        else if f.Components[j] is TComboBox then
          TComboBox(f.Components[j]).ParentFont := true
      end;
      f.Font.Name := 'Arial';
      f.Refresh;
    end;
end;

// настройка windows - размер шрифта
function IsSmallFonts: boolean;
var
  DC: HDC;
begin
  DC := GetDC(0);
  result := (GetDeviceCaps(DC, LOGPIXELSX) = 96); // крупный шрифт 120
  ReleaseDC(0, DC);
end;

{$WARNINGS off}

// windows specific
procedure DeleteFolder(FolderName: string);
var
  SR: TSearchRec;
  Len: integer;
begin
  Len := length(FolderName);
  if FolderName[Len] = '\' then
    FolderName := Copy(FolderName, 1, Len - 1);
  if FindFirst(FolderName + '\*.*', faAnyFile, SR) = 0 then
  begin
    repeat
      if SR.Name = '.' then
        Continue;
      if SR.Name = '..' then
        Continue;
      FileSetAttr(FolderName + '\' + SR.Name, SR.Attr and faDirectory);
      if SR.Attr and faDirectory <> 0 then
        DeleteFolder(FolderName + '\' + SR.Name)
      else
        sysutils.DeleteFile(FolderName + '\' + SR.Name);
    until FindNext(SR) <> 0;
    sysutils.FindClose(SR);
  end;
  RemoveDir(FolderName);
end;
{$WARNINGS on}

function DecodeErr(e_message: string): string;
begin
  if pos('I/O ERROR 32', uppercase(e_message)) <> 0 then
    result := 'Error accessing file'
  else if pos('I/O ERROR 112', uppercase(e_message)) <> 0 then
    result := 'Not enough disk space'
  else
    result := e_message;
end;

// проверка IP
function testIP(ip: string): boolean;
var
  i, ii: integer;
  ps: array [1 .. 3] of integer;
  ok: boolean;
begin
  ok := True;
  ii := 1;
  // точки
  for i := 1 to length(ip) do
  begin
    if ((ip[i] >= '0') and (ip[i] <= '9')) or (ip[i] = '.') and (ii <= 3) then
    begin
      if ip[i] = '.' then
      begin
        ps[ii] := i;
        ii := ii + 1;
      end;
    end
    else
      ok := false;
  end;
  if ii - 1 < 3 then
    ok := false;
  result := ok;
end;

Function ScreenSaver: boolean;
var
  s: array [0 .. 255] of char;
begin
  GetClassName(GetForegroundWindow, s, length(s));
  result := (uppercase(s) = 'WINDOWSSCREENSAVERCLASS');
end;

// проверка на полноэкранные приложения
function isfullscreen: boolean;
var
  p, q: TPoint;
begin
  // координаты левой нижней точки
  p.x := Screen.Width - 1;
  p.y := Screen.Height - 1;
  // координаты правой верхней точки
  q.x := 1;
  q.y := 1;
  // сравнение полученных объектов экрана, которым пренадлежат точки p и q
  if WindowFromPoint(p) = WindowFromPoint(q) then
    result := True
  else
    result := false;
end;

function FileDateTime(FileName: string): TDateTime;
var
  Fage: TDateTime;
begin
  if not FileAge(FileName, Fage) then
    result := 0
  else
    result := Fage;
end;

function MyFileSize(FileName: string): Longint;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then
    result := SearchRec.Size
  else
    result := -1;
  sysutils.FindClose(SearchRec);
end;

// Функция перевода шестнадцетиричного символа в число
function HexToInt(CH: char): integer;
begin
  result := 0;
  case CH of
    '0' .. '9':
      result := Ord(CH) - Ord('0');
    'A' .. 'F':
      result := Ord(CH) - Ord('A') + 10;
    'a' .. 'f':
      result := Ord(CH) - Ord('a') + 10;
  end;
end;

// Функция перевода шестнадцетиричного символа в число
function ToHex(Value: integer): string;
var
  stb, mlb: integer;
const
  hex = '0123456789ABCDEF';
begin
  stb := Value div 16;
  mlb := Value - 16 * stb;
  result := hex[stb + 1] + hex[mlb + 1];
end;

{
// Преобразует строку в URLencoded
function urlEncodeNew(Value: string; Force: boolean = false): string;
var
  i: integer;
  CH: ansichar;
  ss: string;
  aValue: Utf8String;
begin
  aValue := UTF8String(value);
  ss := '';
  if length(aValue) <> 0 then
    for i := 1 to length(aValue) do
    begin
      CH := aValue[i];
      if Ord(CH) >= 128 then // русские
      begin
        ss := ss + '%' + ToHex(Ord(byte(CH)));
      end
      else if Ord(CH) = $20 then
        ss := ss + '+'
      else if Force then // все символы перекодировать
        ss := ss + '%' + ToHex(Ord(CH))
      else
        ss := ss + char(CH);
    end;
  result := ss;
end;   }

function urlEncode(Value: string; Force: boolean = false): string;
var
  i: integer;
  CH: ansichar;
  ss: string;
  aValue: ansistring;
begin
 //result := urlEncode2(Value, force);
// Exit;
  aValue := ansistring(Value);
  ss := '';
  if length(aValue) <> 0 then
    for i := 1 to length(aValue) do
    begin
      CH := aValue[i];
      if Ord(CH) >= 128 then // русские
      begin
        ss := ss + '%' + ToHex(Ord(byte(CH)));
      end
      else if Ord(CH) = $20 then
        ss := ss + '+'
      else if Force then // все символы перекодировать
        ss := ss + '%' + ToHex(Ord(CH))
      else
        ss := ss + char(CH);
    end;
  result := ss;
end;

// Преобразует символы, записанные в виде URLencoded
function urlDecode(Value: string): string;
var
  i, L: integer;
  utf: string;
begin
  if Value > '' then
  begin
    utf := '';
    L := 0;
    for i := 1 to length(Value) do
    begin
      if (Value[i] <> '%') and (Value[i] <> '+') and (L < 1) then
      begin
        utf := utf + string(Value[i]);
      end
      else
      begin
        if (Value[i] = '+') then
          utf := utf + ' '
        else if (Value[i] = '%') then
        begin
          L := 2;
          if (i < length(Value) - 1) then
          begin
            utf := utf + string(ansichar(HexToInt(Value[i + 1]) * 16 + HexToInt(Value[i + 2])));
          end;
        end
        else
          Dec(L);
      end;
    end;
    result := utf;
  end
  else
    result := '';
end;

{function urlDecodeNew(Value: string): string;
var
  i: integer;
  utf: string;
  ut: Boolean;
begin
  if Value > '' then
  begin
    utf := '';
    i := 1;
    while i<=length(Value) do
    begin
      if (value[i] = '%')and(i<=length(value)-2) then
      begin
        utf := utf + string(ansichar(StrToInt('0x'+copy(Value,i+1,2))));
        i := i+3;
      end
      else if (Value[i] = '+') then
      begin
          utf := utf + ' ';
          i := i+1;
      end
      else
      begin
        utf := utf + string(Value[i]);
        i:=i+1;
      end
    end;
    ut := False;
    for i := 0 to Length(utf) do
    begin
      if ord(utf[i])>255 then
        ut := True;
    end;
    if ut then
      result := UTF8Toansi(RawByteString(utf));
    if ((Result='')or(Length(utf)<>length(result))or((pos(char(65533), utf)=0)and(pos(char(65533), result)<>0))) then
      result := utf;
  end
  else
    result := '';
end;}

// удаление запрещенных символов
function delsym(msg: string): string;
const
  todel = '><|?*/\:"=;#()[]';
var
  i: integer;
  ss: string;
begin
  ss := '';
  for i := 1 to length(msg) do
  begin
    if pos(msg[i], todel) = 0 then
      ss := ss + msg[i];
  end;
  result := ss;
end;

// определить размеры картинки
procedure GetImageSize(fn: String; var x, y: word);
var
  pic: TPicture;
  jp: Tjpegimage;
  tempGif: TjvGIFAnimator;
  ext: string;
begin
  if fileexists(fn) then
  begin
    ext := uppercase(extractfileext(fn));
    if (ext = '.JPG') or (ext = '.JPEG') then
    begin
      jp := Tjpegimage.Create;
      try
        try
          jp.LoadFromFile(fn);
          x := jp.Width;
          y := jp.Height;
        except
          x := 0;
          y := 0;
        end;
      finally
        myFreeAndNil(jp);
      end;
    end
    else if (ext = '.PNG') then
    begin
      pic := TPicture.Create;
      try
        try
          pic.LoadFromFile(fn);
          x := pic.Bitmap.Width;
          y := pic.Bitmap.Height;
        except
          x := 0;
          y := 0;
        end;
      finally
        myFreeAndNil(pic);
      end;
    end
    else if (ext = '.GIF') then
    begin
      tempGif := TjvGIFAnimator.Create(nil);
      try
        try
          tempGif.Image.LoadFromFile(fn);
          x := tempGif.Width;
          y := tempGif.Height;
        except
          x := 0;
          y := 0;
        end;
      finally
        myFreeAndNil(tempGif);
      end;
    end
  end
  else
  begin
    x := 0;
    y := 0;
  end;
end;


procedure mysound(snd: string);
var
  ext: string;
  mp: Tplayer;
begin
  try
    if (fileexists(snd)) and (Application.mainform<>nil) then
    begin
      ext := uppercase(extractfileext(snd));
      if ext = '.WAV' then
        playsound(pchar(snd), 0, SND_FILENAME + SND_ASYNC)
      else
      begin
        mp := Tplayer.Create(Application.mainform);
        mp.OnNotify := mp.PlayerNotify;
        mp.visible := false;
        mp.Parent := Application.mainform;
        mp.FileName := snd;
        mp.Shareable := True;
        mp.AutoRewind := false;
        mp.wait := false;
        mp.Open;
        mp.Play;
      end;
    end;
  except
  end;
end;

function notext(msg: string): boolean;
var
  txt: boolean;
  i: integer;
begin
  txt := false;
  for i := 1 to length(msg) do
    if msg[i] > ' ' then
      txt := True;
  result := not txt;
end;

// определение клавиши
function key(ss: string): UINT;
begin
  ss := uppercase(ss);
  if ss = 'CTRL' then
    result := MOD_CONTROL
  else if ss = 'ALT' then
    result := MOD_ALT
  else if ss = 'SHIFT' then
    result := MOD_SHIFT
  else if ss = 'WIN' then
    result := MOD_WIN
  else if ss = 'F1' then
    result := VK_F1
  else if ss = 'F2' then
    result := VK_F2
  else if ss = 'F3' then
    result := VK_F3
  else if ss = 'F4' then
    result := VK_F4
  else if ss = 'F5' then
    result := VK_F5
  else if ss = 'F6' then
    result := VK_F6
  else if ss = 'F7' then
    result := VK_F7
  else if ss = 'F8' then
    result := VK_F8
  else if ss = 'F9' then
    result := VK_F9
  else if ss = 'F10' then
    result := VK_F10
  else if ss = 'F11' then
    result := VK_F11
  else if ss = 'F12' then
    result := VK_F12
  else if ss = 'RIGHT' then
    result := VK_RIGHT
  else if ss = 'LEFT' then
    result := VK_LEFT
  else if ss = 'UP' then
    result := VK_UP
  else if ss = 'DOWN' then
    result := VK_DOWN
  else if ss = 'SPACE' then
    result := VK_SPACE
  else if ss = 'SHIFT' then
    result := VK_SHIFT
  else if ss = 'PRINT' then
    result := VK_SNAPSHOT
  else if ss > '' then
    result := Ord(ss[1])
  else
    result := 0;
end;

// регистрируем глобальную клавишу
Function AddHK(var atm: ATOM; hot1, hot2, hot3: string): boolean;
var
  hk: UINT;
begin
  // комбинация клавиш для грабилка экрана
  hk := key(hot1) + key(hot2);
  GlobalDeleteAtom(atm);
  atm := GlobalAddAtom(pchar('Icom Hot Key ' + inttostr(random(100))));
  unRegisterHotKey(application.Handle, atm);
  if not RegisterHotKey(application.Handle, atm, hk, key(hot3)) then
  begin
    result := false;
    log('error hot key: ' + hot1 + ' ' + hot2 + ' ' + hot3);
  end
  else
  begin
    result := True;
  end;
end;

function LeftDown: boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  result := ((State[vk_lbutton] And 128) <> 0);
end;

// нажат ctrl?
function CtrlDown: boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  result := ((State[vk_Control] And 128) <> 0);
end;

function ShiftDown : Boolean;
var
  State : TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Shift] and 128) <> 0);
end;

function AltDown : Boolean;
var
  State : TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Menu] and 128) <> 0);
end;

function toint(ss: string): integer;
begin
  if ss = '' then
    result := 0
  else
  begin
    result := StrToInt(ss);
  end;
end;


function Darker(Color:TColor; Percent:Byte):TColor;
var
  r, g, b: Byte;
begin
  Color:=ColorToRGB(Color);
  r:=GetRValue(Color);
  g:=GetGValue(Color);
  b:=GetBValue(Color);
  r:=r-muldiv(r,Percent,100);  //процент% уменьшения яркости
  g:=g-muldiv(g,Percent,100);
  b:=b-muldiv(b,Percent,100);
  result:=RGB(r,g,b);
end;

function Lighter(Color:TColor; Percent:Byte):TColor;
var
  r, g, b: Byte;
begin
  Color:=ColorToRGB(Color);
  r:=GetRValue(Color);
  g:=GetGValue(Color);
  b:=GetBValue(Color);
  r:=r+muldiv(255-r,Percent,100); //процент% увеличения яркости
  g:=g+muldiv(255-g,Percent,100);
  b:=b+muldiv(255-b,Percent,100);
  result:=RGB(r,g,b);
end;

end.
