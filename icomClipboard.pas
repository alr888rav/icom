unit icomClipboard;

interface

uses windows, SysUtils, clipbrd, Graphics, dialogs;

function myPaste: Boolean;
function GetStringFromClipboard: String;
procedure PutStringIntoClipBoard(const Str: WideString);

implementation

uses main, htmllib;

procedure PutStringIntoClipBoard(const Str: WideString);
var
  Size: Integer;
  Data: THandle;
  DataPtr: Pointer;
begin
  Size := Length(Str);
  if Size = 0 then
    exit;
  if not IsClipboardFormatAvailable(CF_UNICODETEXT) then
    Clipboard.AsText := Str
  else
  begin
    Size := Size shl 1 + 2;
    Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, Size);
    try
      DataPtr := GlobalLock(Data);
      try
        {$WARNINGS OFF}
        Move(Pointer(Str)^, DataPtr^, Size);
        {$WARNINGS ON}
        Clipboard.SetAsHandle(CF_UNICODETEXT, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  end;
end;

function badstring(ss: string): Boolean;
var
  i: Integer;
  cnt: Integer;
begin
  cnt := 0;
  result := true;
  for i := 1 to Length(ss) do
  begin
    if (ss[i] <> '?') and (ss[i] <> ' ') then // вопросы, пробелы
      result := false;
    if (ss[i] = '?') then
      cnt := cnt + 1;
  end;
  if (cnt > Length(ss) div 4) or (cnt > 20) then // >25% вопросов
    result := true;
end;

// из внешних программ
function GetStringFromClipboard: String;
var
  count, i: Integer;
  formatlist: array of cardinal;
  wstr: PWideChar;
  astr: PAnsiChar;
  format: cardinal;

  function WindowsVersion: String;
  var
    OSVerInfo: TOSVersionInfo;
  begin
    OSVerInfo.dwOSVersionInfoSize := sizeof(TOSVersionInfo);
    if GetVersionEx(OSVerInfo) then
      result := inttostr(OSVerInfo.dwMajorVersion) + '.' + inttostr(OSVerInfo.dwMinorVersion) + '.' +
        inttostr(OSVerInfo.dwBuildNumber)
    else
      result := '0';
  end;

  function InFormatList(fmt: cardinal): Integer;
  var
    i: Integer;
  begin
    result := -1;
    for i := low(formatlist) to high(formatlist) do
      if formatlist[i] = fmt then
        result := i;
  end;

begin
  try
    OpenClipboard(mainform.Handle);
    try
      count := CountClipboardFormats();
      SetLength(formatlist, count);
      formatlist[0] := EnumClipboardFormats(0);
      For i := 1 to count - 1 do
        formatlist[i] := EnumClipboardFormats(formatlist[i - 1]);
      format := GetPriorityClipboardFormat(formatlist[0], count);
      // попытка получить из htmlviewer
      if (InFormatList(49370) <> -1) or (InFormatList(7) <> -1) then // в хр текст как оем
      begin
        astr := PAnsiChar(GetClipboardData(CF_TEXT));
        if not badstring(string(astr)) then
        begin
          result := string(astr);
          exit;
        end
      end;
      if format = CF_UNICODETEXT then
      Begin
        wstr := PWideChar(GetClipboardData(format));
        result := wstr;
      end
      else if format = CF_TEXT then
      Begin
        astr := PAnsiChar(GetClipboardData(format));
        result := string(astr);
      end
      else if format = 49161 then // из IE, Word .....
      begin
        astr := PAnsiChar(GetClipboardData(CF_TEXT));
        result := string(astr);
      end
      else
        result := '';
    finally
      CloseClipboard();
    end;
  except
    result := '';
  end;
end;

// true-проверка на подходящий текстовый формат иначе проверка на картинку
function TestClipboardFormat: Boolean;
var
  i, count: Integer;
  formatlist: array of Integer;
begin
  result := false;
  OpenClipboard(mainform.Handle);
  try
    count := CountClipboardFormats();
    SetLength(formatlist, count);
    formatlist[0] := EnumClipboardFormats(0);
    For i := 1 to count - 1 do
      formatlist[i] := EnumClipboardFormats(formatlist[i - 1]);
    for i := 0 to count - 1 do
    begin
      if ((formatlist[i] = CF_BITMAP) or (formatlist[i] = CF_DIB) or (formatlist[i] = CF_DIBV5)) then
        result := true;
    end;
  finally
    CloseClipboard();
  end;
end;

function myPaste: Boolean;
var
  ss: string;
  ps: Integer;
  stl: Integer;
  file_name, ext: string;
  DoDefault: Boolean;
  pic: tpicture;
begin
  try
    DoDefault := true;
    try
      if TestClipboardFormat then // картинка - действие по умолчанию
      begin
        pic := tpicture.create;
        try
          pic.Assign(Clipboard);
          mainform.memoInsertPicture(pic.Graphic);
        finally
          // pic.Free; не освобождать
          DoDefault := false;
        end;
      end
      else
      begin
        ss := GetStringFromClipboard;
        file_name := ss;
        // в буфере ссылка на файл?
        if (ss > '') and (pos('HTTP://', uppercase(ss)) = 1) then
        begin
          ext := uppercase(ExtractFileExt(file_name));
          if (ext = '.GIF') or (ext = '.PNG') or (ext = '.JPG') or (ext = '.JPEG') or (ext = '.BMP') or (ext = '.ICO')
          then
            DoDefault := mainform.InsertFromBrowser(file_name);
        end
        else
          // в буфере ссылка на файл?
          if (ss > '') and (pos('file://', uppercase(ss)) = 1) or (fileexists(ss)) then
          begin
            if mainform.InsertFileAsIcon(file_name) then
              DoDefault := false;
          end
          // в буфере просто текст
          else if (ss > '') then
          begin
            // обрежем все что перед <body
            ps := pos('<BODY', uppercase(ss));
            if ps <> 0 then
            begin
              ss := copy(ss, ps, Length(ss) - ps);
            end;
            ss := stringreplace(ss, #$09, '    ', [rfReplaceAll]) + ' ';
            ss := html2text(ss); // только текст
            ss := trim(ss);
            stl := mainform.GetCurTextStyleNo; // сохраним стиль
            ss := Spec2text(ss);
            mainform.MemoInsertText(ss);
            mainform.SetCurTextStyleNo(stl); // восстановим
            DoDefault := false;
          end
          else
          begin // вставка если не текст
            DoDefault := true;
          end;
      end;
    finally
      result := DoDefault;
    end;
  except
    on e: exception do
      result := true;
  end;
end;

end.
