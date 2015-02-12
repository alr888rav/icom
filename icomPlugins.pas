unit icomPlugins;

interface

uses CommonLib,
  forms, windows, sysutils, classes, ExtCtrls, Buttons,
  graphics, controls, StdCtrls, ActnCtrls, ComCtrls,
  Grids, CheckLst, Menus;

type
  // Процедурные типы для хранения ссылок на функции плагинов
  TGethotkeyProc = procedure(var hot1, hot2, hot3: widestring);
  ThotkeyProc = procedure;
  TSetupProc = procedure;
  TClick = procedure;
  TKeyDown = procedure(var Key: Word; Shift: TShiftState);
  TPluginImage = function: Pointer;
  TInit = function(app: Tapplication):boolean;
  TInit2 = function(app: Integer; scr:Integer):boolean;
  TDone = procedure;
  TGetNameProc = function: widestring;
  TGetVerProc = function: widestring;
  TBeforeProc = procedure(FromName: widestring; ChName: widestring; var msg: widestring);
  TBeforeSysProc = procedure(FromName: widestring; ChName: widestring; var msg: widestring);
  TuserDrawItemProc = Procedure(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
  TuserMeasureItemProc = Procedure(Control: TWinControl; Index: Integer; var Height: Integer);
  TdatadecodeProc = Procedure(Packet: widestring);
  TUrlProc = function(url:widestring):boolean;

  // Информация об отдельном плагине
  TPlugin = class
  public
    Name: string;
    Ver: string;
    Filename: string;
    Handle: Integer;
    Size: Integer;
    hot1, hot2, hot3: widestring; // хоткей
    atm: ATOM; // атом для хоткея

    GetHotKeyProc: TGethotkeyProc; // получить хоткей
    HotKeyProc: ThotkeyProc; // действие по хоткею
    SetupProc: TSetupProc; // вызов формы настроек плагина
    BeforeProc: TBeforeProc; // до сообщения
    BeforeSysProc: TBeforeSysProc; // до системного сообщения
    userDrawItemProc: TuserDrawItemProc; // рисование строки списка пользователей
    userMeasureItemProc: TuserMeasureItemProc; // измерение высоты строки списка пользователей
    datadecodeProc: TdatadecodeProc;  // декодирование данных плагина
    urlProc: TurlProc;  // обработка своих ссылок плагина
    DoneProc: TDone;
  end;

  // Список загруженных плагинов
  TPlugins = class
  private
    FItems: TstringList;
    function GetPlugin(Index: Integer): TPlugin;
    procedure SetPlugin(Index: Integer; NewPlugin: TPlugin);
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Add(NewPlugin: TPlugin);
    function FindPluginName(dll_name: widestring): string;
    function GetPluginVer(plugin_name: string): String;
    function FindPluginFile(plugin_name: widestring): string;
    function FindPluginID(plugin_name: widestring): Integer;
    procedure LoadPlugins;
    procedure FreePlugins;
    // вызовы из плагина
    Function ExecBefore(FromName, ChName, msg: widestring): string;
    Function ExecBeforeSys(FromName, ChName, msg: widestring): string;
    Function ExecPluginHotKey(msg: tagMSG): boolean;
    Procedure ExecDataDecode(Packet: widestring);
    procedure ExecSetup(pname: string);
    function ExecUrl(url: widestring):boolean;
    function HTMLList: string;
    //
    property Items[Index: Integer]: TPlugin read GetPlugin write SetPlugin; default;
    property Count: Integer read GetCount;
    function PluginsList: string;
  end;

implementation

uses
  ulog, api_works, htmllib, Global;

const
  left_pos = 0;


function TPlugins.GetPlugin(Index: Integer): TPlugin;
begin
  result := TPlugin(FItems.Objects[index]);
end;

procedure TPlugins.SetPlugin(Index: Integer; NewPlugin: TPlugin);
begin
  FItems.Objects[Index] := NewPlugin;
end;

function TPlugins.GetCount: Integer;
begin
  result := FItems.Count;
end;

procedure TPlugins.Add(NewPlugin: TPlugin);
begin
  FItems.AddObject(string(NewPlugin.Name), NewPlugin);
end;

procedure TPlugins.Clear;
begin
  while FItems.Count <> 0 do
  begin
    if FItems.Objects[0]<>nil then
      FItems.Objects[0].Free;
    FItems.Delete(0);
  end;
end;

constructor TPlugins.Create;
begin
  inherited Create;
  //
  FItems := TstringList.Create;
end;

destructor TPlugins.Destroy;
begin
  Clear;
  myFreeAndNil(FItems);
  //
  inherited Destroy;
end;

{$WARNINGS OFF}
// обработка ссылок плагинами
function TPlugins.ExecUrl(url: widestring):boolean;
var
  i: Integer;
  pUrlProc: TUrlProc;
begin
  result := false;
  try
    for i := 0 to Count - 1 do
    begin
      if addr(Items[i].urlProc) <> nil then
      begin
        pUrlProc := Items[i].urlProc;
        result := pUrlProc(url);
      end;
    end;
  except
    on e: exception do
      log('PlugUrl - ' + e.message);
  end;
end;

// обработка горячих кнопок плагинов
Function TPlugins.ExecPluginHotKey(msg: tagMSG): boolean;
var
  i: Integer;
begin
  result := false;
  try
    for i := 0 to Count - 1 do
    begin
      if msg.wParam = Items[i].atm then
      begin
        if addr(Items[i].HotKeyProc) <> nil then
        begin
          Items[i].HotKeyProc;
          result := true;
        end;
      end;
    end;
  except
    on e: exception do
      log('PlugClick - ' + e.message);
  end;
end;

// вызов BeforeMessage из всех плагинов
Function TPlugins.ExecBefore(FromName, ChName, msg: widestring): string;
var
  i: Integer;
  pBeforeProc: TBeforeProc;
begin
  try
    try
      for i := 0 to Count - 1 do
      begin
        if addr(Items[i].BeforeProc) <> nil then
        begin
          pBeforeProc := Items[i].BeforeProc;
          pBeforeProc(FromName, ChName, msg);
        end;
      end;
    except
      on e: exception do
        log('PlugClick - ' + e.message);
    end;
  finally
    result := msg;
  end;
end;

// вызов BeforeSysMessage из всех плагинов
Function TPlugins.ExecBeforeSys(FromName, ChName, msg: widestring): string;
var
  i: Integer;
  pBeforeSysProc: TBeforeSysProc;
begin
  try
    try
      for i := 0 to Count - 1 do
      begin
        if addr(Items[i].BeforeSysProc) <> nil then
        begin
          pBeforeSysProc := Items[i].BeforeSysProc;
          pBeforeSysProc(FromName, ChName, msg);
        end;
      end;
    except
      on e: exception do
        log('PlugClick - ' + e.message);
    end;
  finally
    result := msg;
  end;
end;

// вызов datadecode из всех плагинов
Procedure TPlugins.ExecDataDecode(Packet: widestring);
var
  i: Integer;
  pDataDecodeProc: TDataDecodeProc;
begin
  try
    for i := 0 to Count - 1 do
    begin
      if addr(Items[i].datadecodeProc) <> nil then
      begin
        pDataDecodeProc := Items[i].datadecodeProc;
        pDataDecodeProc(Packet);
      end;
    end;
  except
    on e: exception do
      log('PlugDataDecode - ' + e.message);
  end;
end;
{$WARNINGS ON}

// уберем пробелы
function NoSpace(text: string): string;
begin
  result := uppercase(stringreplace(text, ' ', '_', [rfreplaceall]));
end;

procedure TPlugins.ExecSetup(pname: string);
var
  index: integer;
begin
  index := FindPluginID(pname);
  if index >= 0 then
    Items[index].SetupProc;
end;
{$WARNINGS OFF}
// список в настройках
function TPlugins.HTMLList: string;
var
  i: Integer;
  plugin: TPlugin;
  ht: Tstringlist;
begin
  ht := Tstringlist.Create;
  ht.Add(htmlBegin);
  for i := 0 to Count - 1 do
  begin
    plugin := Items[i];
    ht.Add('<div style="height: 20px; background: silver">'+plugin.name+'</div>');
    ht.Add('<div style="height: 60px;">');
    ht.Add('<br>Ver: ' + plugin.Ver);
    ht.Add(' ' + plugin.Filename);
    if addr(plugin.SetupProc) <> nil then
      ht.Add(' <a href=plugin://'+NoSpace(plugin.Name)+'>Setup</a> ');
    ht.add('</div>');
  end;
  ht.Add(htmlEnd);
  result := ht.Text;
  myFreeAndNil(ht);
end;
{$WARNINGS ON}

{$WARNINGS OFF}
// загрузим все плагины
procedure TPlugins.LoadPlugins;
var
  sr: TSearchRec;
  lib: THandle;
  rz: boolean;
  path: string;
  FPlugin: TPlugin;
  pInit: TInit;
  pInit2: TInit2;
  pgetn: TGetNameProc;
  pgetver: TGetVerProc;
begin
  try
    SetFreePos(left_pos); // нижняя панель для плагинов
    path := extractfilepath(application.ExeName);
    if FindFirst(path + '\Plugins\*.dll', faAnyFile, sr) = 0 then
    begin
      repeat
        lib := SafeLoadLibrary(path + '\Plugins\' + sr.Name);
        if lib <> 0 then
        begin
          pgetn := GetProcAddress(lib, 'PluginName');
          if addr(pgetn) = nil then
            continue // Hе плагин
          else
          begin
            FPlugin := TPlugin.Create;
            FPlugin.Filename := sr.Name;
            FPlugin.Handle := lib;
            FPlugin.Name := pgetn;
            // версия
            pgetver := GetProcAddress(lib, 'PluginVer');
            FPlugin.Ver := pgetver;
            // процедура инициализации
            pInit := GetProcAddress(lib, 'Init');
            pInit2 := GetProcAddress(lib, 'Init2');
            // завершение
            FPlugin.DoneProc := nil;
            FPlugin.DoneProc := GetProcAddress(lib, 'Done');
            // настройки
            FPlugin.SetupProc := nil;
            FPlugin.SetupProc := GetProcAddress(lib, 'Setup');
            // обработчики событий
            FPlugin.BeforeProc := GetProcAddress(lib, 'BeforeMessage');
            FPlugin.BeforeSysProc := GetProcAddress(lib, 'BeforeSysMessage');
            FPlugin.datadecodeProc := GetProcAddress(lib, 'DataDecode');
            // хоткеи
            FPlugin.GetHotKeyProc := GetProcAddress(lib, 'GetHotKey');
            FPlugin.HotKeyProc := GetProcAddress(lib, 'HotKey');
            // обработчик своих ссылок
            FPlugin.UrlProc := GetProcAddress(lib, 'UrlProc');
            // теперь инициализация - application, список пользователей
            rz := false;
            if addr(pInit2) <> nil then
            begin
              try
                rz := pInit2(Integer(application), Integer(screen)); // инициализация v2
              except
                rz := false;
              end;
            end;
            if not rz then
            begin
              try
                rz := pInit(application); // инициализация v1
              except
                rz := false;
              end;
            end;
            if rz then
            begin
              // назначим хоткей если надо
              if (addr(FPlugin.GetHotKeyProc) <> nil) and (addr(FPlugin.HotKeyProc) <> nil) then
              begin
                FPlugin.GetHotKeyProc(FPlugin.hot1, FPlugin.hot2, FPlugin.hot3);
                if not AddHK(FPlugin.atm, FPlugin.hot1, FPlugin.hot2, FPlugin.hot3) then
                  log('Hot key not set - ' + FPlugin.Name);
              end;
              // все готово - добавим в список
              Add(FPlugin);
            end
            else
              myFreeAndNil(FPlugin);
          end;
        end;
      until FindNext(sr) <> 0;
    end;
    sysutils.FindClose(sr);
  finally
    application.ProcessMessages;
  end;
end;
{$WARNINGS ON}

{$WARNINGS OFF}
// выгрузим плагины
procedure TPlugins.FreePlugins;
var
  i: Integer;
begin
  log('FreePlugins - 1');
  try
    // выгрузить dll
    for i := 0 to Count - 1 do
    begin
      if TPlugin(Items[i]).Handle <> 0 then
      begin
        if Addr(TPlugin(Items[i]).DoneProc) <> nil then
          TPlugin(Items[i]).DoneProc;
        freelibrary(TPlugin(Items[i]).Handle);
      end;
    end;
    FItems.Clear;
  except
    on e: exception do
      log('FreePlugins - ' + e.Message);
  end;
end;
{$WARNINGS ON}

// версия загруженного плагина по имени
function TPlugins.GetPluginVer(plugin_name: string): String;
var
  i: Integer;
begin
  result := '';
  for i := 0 to Count - 1 do
  begin
    if (ansiuppercase(TPlugin(Items[i]).Name) = ansiuppercase(plugin_name)) or
      (ansiuppercase(TPlugin(Items[i]).Filename) = ansiuppercase(plugin_name)) then
      result := TPlugin(Items[i]).Ver;
  end;
end;

// имя файла плагина по имени плагина
function TPlugins.FindPluginFile(plugin_name: widestring): string;
var
  i: Integer;
  pn: string;
begin
  pn := ansiuppercase(trim(plugin_name));
  result := '';
  for i := 0 to Count - 1 do
  begin
    if ansiuppercase(TPlugin(Items[i]).Name) = pn then
      result := TPlugin(Items[i]).Filename;
  end;
end;

// имя плагина по имени файла
function TPlugins.FindPluginName(dll_name: widestring): string;
var
  i: Integer;
  dl: string;
begin
  dl := ansiuppercase(trim(dll_name));
  result := '';
  for i := 0 to Count - 1 do
  begin
    if ansiuppercase(TPlugin(Items[i]).Filename) = dl then
      result := TPlugin(Items[i]).Name;
  end;
end;

// номер плагина по имени
function TPlugins.FindPluginID(plugin_name: widestring): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
  begin
    if NoSpace(TPlugin(Items[i]).Name) = NoSpace(plugin_name) then
      result := i;
  end;
end;

// список плагинов
function TPlugins.PluginsList: string;
var
  i: Integer;
begin
  result := '';
  for i := 0 to Count - 1 do
  begin
    result := result + TPlugin(Items[i]).Name+' ';
  end;
end;

end.
