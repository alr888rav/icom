unit icomNET;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls, IdTCPConnection, IdTCPClient, IdBaseComponent,
  IdTCPServer, Sockets, IdUDPClient, IdUDPBase,
  IdUDPServer, IdSocketHandle, IdCoder, IdCoderMIME,
  stdctrls, comctrls,
  IdCustomTCPServer,
  idContext, idGlobal,
  IdAntiFreeze, IdHTTP, wininet,
  WinSock, StrUtils, dialogs, userslist,
  urlmon;

type
  TIdTcpServer = class(IdTCPServer.TIdTCPServer)
    public
      procedure stopListening;
  end;

  TNetWork = class(TObject)
  private
    { Private declarations }
    Last_in_message: string;
    busy: boolean;
    msgin: TstringList;
    IdAntiFreeze1: TIdAntiFreeze;
    UDPclient: TIdUDPClient;
    UDPserver: TIdUDPServer;
    TCPclient: TIdTCPClient;
    TCPserver: TIdTCPServer;
    procedure TCPServerExecute(AContext: TIdContext);
    procedure UDPServerUDPRead(AThread: TIdUDPListenerThread; AData: TArray<System.Byte>; ABinding: TIdSocketHandle);
    procedure DataDecode;
    Procedure Migalka(ChName: string);
    Procedure ShowTrayMsg(FromIP: string; ChName, Packet: string; UserCount: string);
    Procedure FreeMsg(FromIP: string; ChName: string; Packet: string; UserCount: string);
    Procedure PersonalMsg(FromIP: string; ChName: string; Packet: string);
    function Base64Encode(const Text: String): String;
    function Base64Decode(const Text: String): String;
    function GetIP(site: string): string;
    function GetSiteName(url: string): string;
    function LocalAddr(ip: string): boolean;
    function LocalDownload(url: string; fname: string): boolean;
    function InetDownload(url: string; fname: string): boolean;
    //function inputproxyuser(var user_name, password: string): boolean;
    Procedure EncodeV2(var tmpstr: string; sign: string; data: string; Channel, users: integer; file_name, channel_name: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddMsg(msg:string);
    //procedure GetProxy;
    procedure SetProxy(proxy: string);
    function TempFileName(ext: string): string;
    Function TestLocalIP(testip: string): boolean;
    Procedure GetAvatar(ip: string);
    function MyDownload(url: string): string;
    Procedure Collapse(var Packet: string);
    function Start:boolean;
    Procedure Stop;
    procedure TCPsend(ip, buff: string; ShowError: boolean = true; myself: boolean=false);
    procedure UDPsend(ip, buff: string);
    Procedure SendExit;
    Procedure SendStatus(i_am: Tuser);
    Procedure SendAvatar(ip: string; i_am: Tuser);
    Procedure SendUDPPKG(package: string);
    Procedure SendGroupMsg(ch: integer; ch_name: string; users:TstringList; UserCount:integer; msg: string);
    Procedure SendGroupFile(ch: integer; ch_name: string; users:TstringList; UserCount:integer; file_name: string);
    function GetBusy:boolean;
    procedure DeCode;
  end;

implementation

uses commonLib, icomplugins, setting, Global, ulog, language, main, htmllib,
  icomchannels, desktop;

const
  netbufsize = 16384;
  maxmsg = 1000;

{$WARNINGS OFF}
procedure TIdTCPServer.StopListening;
var
  LListenerThreads: TList;
  i: integer;
begin
  i := 0;
  LListenerThreads := FListenerThreads.LockList;
  try
    while LListenerThreads.Count > 0 do
    begin
      with TIdListenerThread(LListenerThreads[0]) do
      begin
        // Stop listening
        Terminate;
        Binding.CloseSocket;
        // Tear down Listener thread
        WaitFor;
        Free;
      end;
      LListenerThreads.Delete(0); // RLebeau 2/17/2006
      if i>100 then
        break;
    end;
  finally
    FListenerThreads.UnlockList;
  end;
end;
{$WARNINGS ON}

procedure TNetwork.AddMsg(msg:string);
begin
  msgin.Add(msg);
end;

procedure TNetwork.Decode;
begin
  if not Busy then
    DataDecode;
end;

function TNetwork.GetBusy:boolean;
begin
  result := busy;
end;

Procedure TNetWork.Stop;
begin
  try
    log('NetWork.Stop');
    TCPserver.Active := false;
    TCPserver.stopListening;
    TCPserver.OnExecute := nil;
    UDPserver.OnUDPRead := nil;
    myFreeAndNil(TCPserver);
    myFreeAndNil(UDPserver);
    myFreeAndNil(TCPclient);
    myFreeAndNil(UDPclient);
    myFreeAndNil(IdAntiFreeze1);
    msgin.Clear;
    myFreeAndNil(msgin);
  except
    on e: exception do
      log('NetStop - ' + e.Message);
  end;
end;

Procedure TNetWork.EncodeV2(var tmpstr: string; sign: string; data: string; Channel, users: integer; file_name, channel_name: string);
var
 fs: int64;
begin
  if fileexists(file_name) then
    fs := myFileSize(file_name)
  else
    fs := 0;
  tmpstr := sign + LF + LF +
    '#CHANNEL_NAME' + LF + urlencode(channel_name) + LF +
    '#CHANNEL' + LF + inttostr(Channel) + LF +
    '#FILE' + LF + urlencode(extractfilename(file_name)) + LF +
    '#USERS' + LF + inttostr(users) + LF +
    '#FROM' + LF + 'ip' + LF +
    '#MSG' + LF + Base64Encode(data) + LF +
    '#FILESIZE' + LF + inttostr(fs) + LF +
    // новые строки вставлять сюда
    '#END';
end;

// http://имя_сайта/имя_картинки
// выделяем имя сайта
function TNetWork.GetSiteName(url: string): string;
var
  Start, I: integer;
begin
  Start := Pos('://', url);
  if Start = 0 then
    Start := 1
  else
    Start := Start + 3;
  result := '';
  for I := Start to length(url) do
    if url[I] = '/' then
    begin
      result := Copy(url, Start, I - Start);
      Break;
    end;
end;

// определяет относится ли адрес к локальной сети
function TNetWork.LocalAddr(ip: string): boolean;
begin
  if (Copy(ip, 1, 3) = '10.') or (Copy(ip, 1, 3) = '172') or (Copy(ip, 1, 3) = '192') then
    result := true
  else
    result := false;
end;

// определяет ip по имени
function TNetWork.GetIP(site: string): string;
var
  WSAData: TWSAData;
  p: PHostEnt;
const
  WINSOCK_VERSION = $0101;
begin
  if (Pos('www.', LowerCase(site)) <> 0) or (Pos('.com', LowerCase(site)) <> 0) or (Pos('.ru', LowerCase(site)) <> 0) or
    (Pos('.ua', LowerCase(site)) <> 0) or (Pos('.net', LowerCase(site)) <> 0) or (Pos('.org', LowerCase(site)) <> 0) or
    (Pos('.gov', LowerCase(site)) <> 0) or (Pos('.biz', LowerCase(site)) <> 0) or (Pos('.edu', LowerCase(site)) <> 0)
  then
  // из инета не определяем ip (это для ускорения работы)
  begin
    result := ''
  end
  else
  begin
    WSAStartup(WINSOCK_VERSION, WSAData);
    p := GetHostByName(pansichar(ansistring(site)));
    if p <> nil then
      {$WARNINGS OFF}
      result := string(inet_ntoa(PInAddr(p.h_addr_list^)^))
      {$WARNINGS ON}
    else
      result := '';
    WSACleanup;
  end;
end;

function TNetWork.Base64Encode(const Text: String): String;
var
  Encoder: TIdEncoderMime;
begin
  Encoder := TIdEncoderMime.Create(nil);
  try
    result := Encoder.EncodeString(Text, TEncoding.ANSI);
  finally
    myFreeAndNil(Encoder);
  end
end;

function TNetWork.Base64Decode(const Text: String): String;
var
  Decoder: TIdDecoderMime;
begin
  Decoder := TIdDecoderMime.Create(nil);
  try
    try
      result := Decoder.DecodeString(Text, TEncoding.ANSI);
    except
      result := '';
    end;
  finally
    myFreeAndNil(Decoder)
  end
end;

procedure TNetWork.SetProxy(proxy: string);
var
  proxy_info: PInternetProxyInfo;
begin
  {$WARNINGS OFF}
  New (proxy_info);
  proxy_info^.dwAccessType := INTERNET_OPEN_TYPE_PROXY;
  proxy_info^.lpszProxy := PAnsiChar(AnsiString(proxy));
  proxy_info^.lpszProxyBypass := PAnsiChar('');
  UrlMkSetSessionOption(INTERNET_OPTION_PROXY, proxy_info, SizeOf(Internet_Proxy_Info), 0);
  Dispose(proxy_info);
  {$WARNINGS ON}
end;

// загрузить файл из лок. сети
function TNetWork.LocalDownload(url: string; fname: string): boolean;
var
  F: TFileStream;
  srcfile: string;
  IdHTTP1: TIdHTTP;
begin
  try
    IdHTTP1 := TIdHTTP.Create;
    try
      if Pos('FILE://', uppercase(url)) = 1 then // локальный файл просто скопировать
      begin
        srcfile := Copy(url, 9, length(url) - 8);
        srcfile := stringreplace(srcfile, '/', '\', [rfReplaceall]);
        srcfile := URLdecode(srcfile);
        mycopyfile(srcfile, fname);
      end
      else
      begin
        F := TFileStream.Create(fname, fmCreate);
        try
          IdHTTP1.ProxyParams.ProxyServer := '';
          IdHTTP1.ProxyParams.ProxyPort := 0;
          IdHTTP1.ProxyParams.ProxyUsername := '';
          IdHTTP1.ProxyParams.ProxyPassword := '';
          IdHTTP1.Get(url, F);
        finally
          myFreeAndNil(F);
        end;
      end;
    finally
      result := true;
      myFreeAndNil(IdHTTP1);
    end;
  except
    on e: exception do
    begin
      log('LocalDownload - ' + e.message + ' url=' + url + ' file=' + fname);
      result := false;
    end;
  end;
end;

// загрузить файл из инета
function TNetWork.InetDownload(url: string; fname: string): boolean;
var
  F: TFileStream;
  srcfile: string;
  IdHTTP1: TIdHTTP;
  I: integer;
begin
  try
    IdHTTP1 := TIdHTTP.Create;
    try
      result := true;
      if Pos('FILE:///', uppercase(url)) = 1 then // локальный файл просто скопировать
      begin
        srcfile := Copy(url, 9, length(url) - 8);
        srcfile := stringreplace(srcfile, '/', '\', [rfReplaceall]);
        srcfile := URLdecode(srcfile);
        mycopyfile(srcfile, fname);
      end
      else
      begin
        // далее из интернет загрузка
        F := TFileStream.Create(fname, fmCreate);
        try
          IdHTTP1.ProxyParams.BasicAuthentication := false;
          // пробуем загрузить файл
          for I := 1 to 3 do
          begin
            try
              IdHTTP1.Get(url, F);
            except
              on e: exception do
              begin
                result := false;
              end;
            end;
            Break;
          end;
        finally
          myFreeAndNil(F);
        end;
      end;
    finally
      myFreeAndNil(IdHTTP1);
    end;
  except
    on e: exception do
    begin
      log('InetDownload - ' + e.message);
      result := false;
    end;
  end;
end;

// временный файл куда скачаем
function TNetWork.TempFileName(ext: string): string;
var
  I: integer;
  fname: string;
  Add: string;
  nn: int64;
begin
  if uppercase(ext) = '.GIF' then
    Add := aniname + '_'
  else
    Add := '';
  nn := GetTickCount;
  if nn > maxint then
    nn := nn - maxint;

  for I := nn to nn + 1000 do
  begin
    if not fileexists(htmldir +  Add + 'inet_' + inttostr(I) + ext) then
    begin
      fname := htmldir + Add + 'inet_' + inttostr(I) + ext;
      Break;
    end;
  end;
  result := fname;
end;

// загрузить файл
function TNetWork.MyDownload(url: string): string;
var
  site: string;
  ip_site: string;
  fname: string;
  ext: string;
begin
  result := '';
  ext := extractfileext(url);
  if Length(ext)>5 then
    ext := '.html';
  fname := TempFileName(ext);
  site := GetSiteName(url);
  ip_site := GetIP(site);
  if LocalAddr(ip_site) then
  begin
    if LocalDownload(url, fname) then
      result := fname;
  end
  else
  begin
    if InetDownload(url, fname) then
      result := fname;
  end;
end;

Procedure TNetWork.SendGroupMsg(ch: integer; ch_name: string; users:TstringList; UserCount:integer; msg: string);
var
  TmpStrHTML: string;
  i: integer;
begin
  log('sendgroup');
  if (ch=PERSONAL_CH)and(UserCount<>1) then
  begin
    Log('Error send personal usercount='+inttostr(usercount));
    exit;
  end;
  EncodeV2(TmpStrHTML, '#PACKET', msg, ch, UserCount, '', ch_name);
  for i := 0 to Users.count - 1 do
  begin
    TCPsend(users.Strings[i], TmpStrHTML);
    log('ch=' + ch_name + ' send to ' + user_list[users.strings[i]].name);
  end;
end;

Procedure TNetWork.SendGroupFile(ch: integer; ch_name: string; users:TstringList; UserCount:integer; file_name: string);
var
  i: integer;
  FStream: TFileStream;
  blocksize: integer;
  tmpstr: string;
  MyStream: TMemoryStream;
  SStream: TStringStream;
  TmpStrHTML: string;
  TmpStrFile2: string;
  fp:integer;
begin
  log('sendgroupfile');
  if (ch=PERSONAL_CH)and(UserCount<>1) then
  begin
    Log('Error send personal usercount='+inttostr(usercount));
    exit;
  end;
  if not fileexists(file_name) then
    exit;

  tmpstr := '';
  EncodeV2(tmpstr, '#FILEDATAV2', '', ch, UserCount, file_name, ch_name);
  FStream := TFileStream.Create(file_name, fmOpenRead + fmShareDenyNone);
  try
    for i := 0 to Users.count - 1 do
    begin
      if (users.Strings[i] = Setup.myIP) then
        continue;
      fp := user_list[users.Strings[i]].file_protocol;
      if fp >= 2 then
      begin
        try
          TCPclient.Host := users.Strings[i];
          TCPclient.Port := Setup.IcomPort;
          TCPclient.ReadTimeout := 2000;
          TCPclient.ConnectTimeout := 2000;
          TCPclient.Connect;
          try
            TCPclient.IOHandler.WriteLN(tmpstr);
            FStream.Position := 0;
            while FStream.Position<FStream.Size do
            begin
              if FStream.Size-FStream.Position>10*MB then
                blocksize := 10*MB
              else
                blocksize := FStream.Size-FStream.Position;
             TCPclient.IOHandler.Write(FStream, blocksize);
            end;
          finally
            TCPclient.Disconnect;
          end;
        except
          on e: exception do
          log('sendfile '+e.message);
        end;
        log('v2 ch=' + ch_name + ' sendfile to ' + user_list[users.strings[i]].name);
      end
      else // для старых версий
      begin
        if MyFileSize(file_name) <= MAX_FILE_SIZE_V1 then
        begin
          if fileexists(file_name) then
          begin
            MyStream := TMemoryStream.Create;
            SStream := TStringStream.Create('');
            try
              try
                MyStream.LoadFromFile(file_name);
                if MyStream.Size = 0 then
                begin
                  log('mySend - empty file');
                  exit;
                end;
              except
                on e: exception do
                begin
                  showmessage(e.message);
                  exit;
                end;
              end;
              MyStream.position := 0;
              SStream.CopyFrom(MyStream, MyStream.Size);
              TmpStrFile2 := SStream.DataString;
            finally
              myFreeAndNil(MyStream);
              myFreeAndNil(SStream);
            end;
          end
          else
            exit;
          file_name := extractfilename(file_name);
          file_name := urlencode(file_name);
          EncodeV2(TmpStrHTML, '#FILEDATA', TmpStrFile2, ch, UserCount, file_name, ch_name);
          TCPsend(users.Strings[i], TmpStrHTML);
          log('ch=' + ch_name + ' send to ' + user_list[users.strings[i]].name);
        end
        else
          log('v1 error big file');
      end;
    end;
  finally
    myFreeAndNil(FStream);
  end;
end;

// нижний уровень
procedure TNetWork.UDPsend(ip, buff: string);
var
  I: integer;
begin
  try
    if Assigned(UDPclient) then
    begin
      // в пустоту и себе не шлем
      if (ip = '') then
        exit;
      //if (not Testmode) and (TestLocalIP(ip)) then
      //  exit;
      // в черный список не шлем
      for I := 0 to Setup.blacklist.count - 1 do
      begin
        if ip = Setup.blacklist.strings[I] then
          exit;
      end;
      UDPclient.Host := ip;
      UDPclient.Send(buff);
    end;
  except
    on e: exception do
      log('udpsend: '+e.Message);
  end;
end;

// нижний уровень
procedure TNetWork.TCPsend(ip, buff: string; ShowError: boolean = true; myself: boolean=false);
var
  ss: string;
  I: integer;
begin
  try
    if (ip = '') then
      exit;
    if (not myself) and (not Testmode) and (TestLocalIP(ip)) then
      exit;
    // в черный список не шлем
    for I := 0 to Setup.blacklist.count - 1 do
    begin
      if ip = Setup.blacklist.strings[I] then
        exit;
    end;
    if TCPclient.Connected then
      TCPclient.Disconnect;
    // отправка
    TCPclient.Host := ip;
    TCPclient.Port := Setup.IcomPort;
    TCPclient.ReadTimeout := 2000;
    TCPclient.ConnectTimeout := 2000;
    TCPclient.Connect;
    try
      TCPclient.IOHandler.Write(buff);
    finally
      TCPclient.Disconnect;
    end;
  except
    on e: exception do
    begin
      ss := '';
      if (Pos('TIMED OUT', uppercase(e.message)) <> 0) or (Pos('CONNECTION REFUSED', uppercase(e.message)) <> 0) then
        ss := '<br><font size=-1 color=gray>' + timetostr(time) + ' ' + lang.Get('no_send') + ' ' +
          user_list.GetNickName(ip) + '</font>'
      else if (Pos('THREAD CREATION ERROR', uppercase(e.message)) <> 0) or
        (Pos('OUT OF MEMORY', uppercase(e.message)) <> 0) then
        ss := '<br><font size=-1 color=gray>' + timetostr(time) + ' ' + lang.Get('no_send') +
          ' - Out of system resources/Out of memory</font>';
      if (ss > '') and (ShowError) then
      begin
        Channels.Channel[mainform.PageControl1.ActivePage.caption]
          .AddText('', mainform.PageControl1.ActivePage.caption, ss);
      end;
      log('tcpsend: (' + user_list.GetNickName(ip) + ') ' + e.message);
    end;
  end;
end;

// проверка на локальный IP
Function TNetWork.TestLocalIP(testip: string): boolean;
var
  I: integer;
begin
  result := false;
  if Setup.localip = nil then
    exit;
  for I := 0 to Setup.localip.count - 1 do
    if testip = Setup.localip.strings[I] then
    begin
      result := true;
      Break;
    end;
end;

// послать всем сообщение о выходе
Procedure TNetWork.SendExit;
var
  I: integer;
  tmpstr: String;
Begin
  try
    log('SendExit');
    tmpstr := '#EXIT' + LF;
    for I := 0 to user_list.count - 1 do
    begin
      if (user_list[I].status > OFFLINE) and (not TestLocalIP(user_list[I].ip)) then
      begin
        UDPsend(user_list[I].ip, tmpstr);
      end;
    end;
  except
    on e: exception do
      log('SendExit: ' + e.message);
  end;
end;

// послать всем сообщение о статусе
Procedure TNetWork.SendStatus(i_am: Tuser);
var
  I: integer;
  tmpstr: String;
  chlist: string;
Begin
  try
    tmpstr := '#STATUS' + LF + inttostr(i_am.status) + LF +
              '#VER' + LF + i_am.ver + LF +
              '#WINVER' + LF + i_am.winver + LF +
              '#EXSTATUS' + LF + urlencode(i_am.ex_status) + LF +
              '#NICKNAME' + LF + urlencode(i_am.name) + LF +
              '#FROM' + LF + 'hidden ip' + LF +
              '#EMPTY' + LF + LF +
              '#VISIBLE' + LF + LF +
              '#LASTINPUT' + LF + inttostr(mainform.lastInput div 1000) + LF +
              '#DR' + LF + i_am.dr + LF +
              '#MALE' + LF + inttostr(i_am.male) + LF +
              '#FILE_VER' + LF + inttostr(i_am.file_protocol) + LF +
              '#PLUGINS' + LF + i_am.plugins + LF;
    // список свободных каналов
    chlist := '';
    for I := 0 to mainform.PageControl1.PageCount - 1 do
    begin
      if (mainform.PageControl1.Pages[I].Tag = FREE_CH) then
        chlist := chlist + urlencode(trim(lang.toDefaultLang(mainform.PageControl1.Pages[I].caption))) + '>';
    end;
    tmpstr := tmpstr + '#CHLIST' + LF + chlist + LF;

    for I := 0 to user_list.count - 1 do
    begin
      UDPsend(user_list[I].ip, tmpstr);
    end;
  except
    on e: exception do
      log('SendStatus: ' + e.message);
  end;
end;

// общее управление мигалками
Procedure TNetWork.Migalka(ChName: string);
begin
  if (Channels.Channel[ChName].Tag = FREE_CH) then
    mainform.MigIcon(1);
  if (Channels.Channel[ChName].Tag = PERSONAL_CH) then
    mainform.MigIcon(1);
  Channels.StartBlink;
end;

Procedure TNetWork.ShowTrayMsg(FromIP: string; ChName, Packet: string; UserCount: string);
var
  mmtx: string;
  Personal: string;
  otkogo: string;
begin
  try
    if (Setup.showballon) and (Packet > '') and (user_list[Setup.myIp].status <> OFF) then
    begin
      mmtx := html2text(htmlcode2text(Packet));  // unicode to text
      mmtx := urlDecode(mmtx);                   // urlencoded to text
      otkogo := user_list.GetNickName(FromIP);
      mmtx := Plugins.ExecBefore(otkogo, ChName, mmtx);
      mmtx := mmtx + #0;
    end;
    if notext(mmtx) then
      exit;
    if UserCount = '0' then
      Personal := ' [' + ChName + ']'
    else if UserCount = '1' then
      Personal := ' [' + lang.Get('personal2') + ']'
    else
      Personal := ' [' + ChName + ' ' + lang.Get('group') + ']';
    if (mmtx > '') and (not mainform.Visible) and (not isfullscreen) then
      mainform.showballon('[' + user_list.GetNickName(FromIP) + '] ' + Personal, mmtx, 5);
  except
    on e: exception do
      log('show balloon: ' + e.message);
  end;
end;

Procedure TNetWork.FreeMsg(FromIP: string; ChName: string; Packet: string; UserCount: string);
var
  otkogo: string;
  TabFile: string;
  Personal: string;
  hChannel: TChannel;
begin
  chName := lang.toMyLang(ChName);
  if UserCount = '0' then
    Personal := ''
  else
    Personal := ' [' + lang.Get('group') + ']';
  otkogo := user_list.GetNickName(FromIP);
  log('Free ' + ChName + ' from ' + user_list.GetNickName(FromIP));
  if Setup.autofree then // автоприем и открытие
    mainform.NewTab(ChName, false, FREE_CH);
  if Channels.Find(ChName) >= 0 then
  begin
    Collapse(Packet);
    Channels.Channel[ChName].AddSysText(trim(otkogo), ChName, timetostr(time) + ' [' + user_list.GetNickName(FromIP) +
      ' ]' + user_list[FromIP].ex_status + Personal, HTMLColor(Setup.sysfont.color));
    Channels.Channel[ChName].AddText(trim(otkogo), ChName, AddSmiles(Packet));
    ///Channels.Channel[ChName].Reload(Setup.autoscroll);
    if Setup.autoscroll then
      Channels.Channel[ChName].GoEnd;
    Channels.Channel[ChName].Blink := true;
    Migalka(ChName);
    ShowTrayMsg(FromIP, ChName, Packet, UserCount);
    mainform.CheckFreeSpace(Path, 3, true);
    if Setup.saveTraf then
      mainForm.SaveTraf;
  end
  else
  begin // только скрытый прием
    TabFile := htmldir + trim(ChName) + '.html';
    hChannel := TChannel.Create(nil);
    hChannel.LoadFromFile(TabFile);
    hChannel.AddSysText(trim(otkogo), ChName, timetostr(time) + ' [' + user_list.GetNickName(FromIP) + ' ]' +
      user_list[FromIP].ex_status + Personal, HTMLColor(Setup.sysfont.color));
    hChannel.AddText(trim(otkogo), ChName, AddSmiles(Packet));
    hChannel.SaveToFile(TabFile);
    myFreeAndNil(hChannel);
  end;
  mainform.newlog(ChName + ' ' + ansilowercase(lang.Get('message')) + ' ' + lang.Get('from') + ' ' + otkogo);
end;

Procedure TNetWork.PersonalMsg(FromIP: string; ChName: string; Packet: string);
var
  FromName: string;
  Personal: string;
begin
  Personal := ' [' + lang.Get('personal2') + ']';
  FromName := trim(user_list.GetNickName(FromIP));
  log(Personal + ' from ' + user_list.GetNickName(FromIP));
  mainform.NewTab(FromName, false, PERSONAL_CH);
  Channels.Channel[FromName].AddSysText(user_list.GetNickName(FromIP), FromName, datetostr(date) + ' ' + timetostr(time)
    + ' [' + user_list.GetNickName(FromIP) + ' ]' + user_list[FromIP].ex_status + Personal,
    HTMLColor(Setup.sysfont.color));
  Channels.Channel[FromName].AddText(FromName, FromName, AddSmiles(Packet));
  ///Channels.Channel[FromName].Reload(Setup.autoscroll);
  if Setup.autoscroll then
    Channels.Channel[FromName].GoEnd;
  if Channels.Channel[FromName].Tag >= 0 then
    Channels.Channel[FromName].Blink := true;
  mainform.TrayIcon.IconIndex := 0;
  mainform.TrayIcon.Icons := mainform.PersonalList;
  Migalka(FromName);
  ShowTrayMsg(FromIP, ChName, Packet, '1');
  if Setup.saveTraf then
    mainForm.SaveTraf;
  mainform.newlog(lang.Get('message') + ' ' + lang.Get('from') + ' ' + FromName);
end;

// свертка длинного
Procedure TNetWork.Collapse(var Packet: string);
var
  Packet3: string;
  lbl: string;
  ps: integer;
const
  maxLength=750;
  tailLength=maxLength div 10;
  notBefore=maxLength div 2;
begin
  if (Setup.collapselong) and (length(html2text(Packet)) > maxLength) then
  begin
    lbl := inttostr(GetTickCount);
    ps := findBR(ansiuppercase(Packet), notBefore);
    if (ps <> 0) and (length(html2text(copy(Packet,ps))) > tailLength) then
    begin
      Packet3 := LF + '<div style="display: ;" id=' + lbl + '_1>' + twintag(stringreplace(Copy(Packet, 1, ps),'</blockquote>','',[rfIgnoreCase,rfreplaceall]))
                    + ' <a href="javascript:void(0)" onclick="togglemsg('#39 + lbl + #39')">дальше</a></div>';
      // дальше оригинал для расшифровки
      Packet := Packet3 + LF + '<div style="display: none;" id=' + lbl + '_2>' + Packet
                + ' <a href="javascript:void(0)" onclick="togglemsg('#39 + lbl + #39')">свернуть</a></div>';
    end;
  end;
end;

// обработка поступивших пакетов
procedure TNetWork.DataDecode;
var
  signature: string;
  Packet: string;
  I: integer;
  id: integer;
  sl: TstringList;
  FromIP: string;
  ch: integer;
  urlfname, fname: string;
  fl_text: textfile;
  _block: string;
  ss: string;
  ChName: string;
  emsg: string;
  black: Boolean;
  ext: string;
  updmsg: boolean;
begin
  try
    busy := true;
    sl := TstringList.Create;
    try { finally }
      while true do
      begin
        application.ProcessMessages;
        if (msgin = NIL) or (msgin.count = 0) then
          exit; // ничего на входе
        sl.Text := msgin.strings[0];
        msgin.delete(0);
        // от кого
        FromIP := getsl(sl, 'REALIP');
        if FromIP = '' then
          continue;
        // тип пакета
        signature := sl.strings[0];

        // черный список
        if Setup.blacklist <> nil then
        begin
          black := false;
          for I := 0 to Setup.blacklist.count - 1 do
          begin
            if FromIP = Setup.blacklist.strings[I] then
            begin
              black := true;
              break;
            end;
          end;
          if black then
            continue;
        end;
        // не обрабатываем с неизвестных ip
        if (unknown_user <> nil) and (not TestLocalIP(FromIP)) then
        begin
          id := user_list.GetID(FromIP);
          if id < 0 then
          begin
            if (signature = '#STATUS') then // накопим неизвестные ip
            begin
              if unknown_user.IndexOf(URLdecode(getsl(sl, 'NICKNAME')) + '/' + FromIP) = -1 then
              begin
                ss := URLdecode(getsl(sl, 'NICKNAME'));
                if ss > '' then
                  unknown_user.Add(ss + '/' + FromIP);
              end;
            end;
            continue;
          end;
        end;

        // обработка
        if signature = '#STATUS' then
        begin
          mainform.SetUserStatus(FromIP, sl);
        end
        else if signature = '#EXIT' then
        begin // отключился
          if mainform.show_on_off then
            mainform.newlog(timetostr(time) + ': ' + lang.get('user_out'+inttostr(user_list[FromIP].male)) + ' [' +
              user_list.GetNickName(FromIP) + ']');
          if (Setup.trayonoff) and (mainform.show_on_off) then
          begin
            mainform.showballon(timetostr(time), lang.get('user_out'+inttostr(user_list[FromIP].male)) + ' [' + user_list.GetNickName(FromIP)
              + ']', 3);
            if (Setup.soundon) and (Setup.s2on) then
              mysound(Setup.sndoffline);
          end;
          id := user_list.GetID(FromIP);
          user_list.SetOFFLINE(id);
        end
        else if signature = '#ERROR' then
        begin
          log(signature + ' ' + user_list.GetNickName(FromIP) + ' ' + URLdecode(getsl(sl, 'MSG')));
        end
        else if signature = '#AVATAR' then
        begin
          SendAvatar(FromIP, user_list[Setup.myIp]);
        end
        else if signature = '#BIG' then
        begin
          try
            fname := CacheDir + inttostr(user_list[FromIP].randId) + '.jpg';
            assignfile(fl_text, fname);
            rewrite(fl_text);
            _block := Base64Decode(getsl(sl, 'MSG'));
            write(fl_text, _block);
            CloseFile(fl_text);
            //user_list[FromIP].big.LoadFromFile(fname);
            user_list[FromIP].modified := true;
          except
            on e: exception do
              log('bad avatar 1: '+e.Message);
          end;
        end
        else if signature = '#UPDATEDATA' then
        begin
          updmsg := false;
          fname := getsl(sl, 'FILE');
          if (fname = '') or (fname = '*') then
            continue;
          try
            assignfile(fl_text, Setup.myPath + fname);
            rewrite(fl_text); // сохраним файл
            _block := Base64Decode(getsl(sl, 'MSG'));
            write(fl_text, _block);
            CloseFile(fl_text);
            _block := '';
            // пришел апдейт попытаемся обновиться и рестарт
            ext := extractfileext(uppercase(fname));
            if  ext = '.EXE' then
            begin
              deletefile(application.exename + '.old');
              // текущий в old
              renamefile(application.exename, application.exename + '.old');
              // загруженный в текущий
              mycopyfile(Setup.myPath + fname, application.exename);
              updmsg := true;
            end
            else if ext = '.DLL' then
            begin
              if FileExists(path + 'Plugins\' + fname) then  // if plugin exists - update
              begin
                deletefile(path + 'Plugins\' + fname + '.old');
                renamefile(path + 'Plugins\' + fname, path + 'Plugins\' + fname + '.old');
                mycopyfile(Setup.myPath + fname, path + 'Plugins\' + fname);
                updmsg := true;
              end;
            end;
            log('update: ' + fname);
            if updmsg then
            begin
              ChName := lang.Get('update_page');
              mainform.NewTab(ChName, true, READONLY_CH);
              Channels.Channel[ChName].AddText('', ChName,
                '<br><font size=-1><font color=' + HTMLColor(Setup.sysfont.color) + '>' + timetostr(time) + ' ' +
                lang.Get('update_ok') + ': ' + fname + ' <font color=red>' + lang.Get('need_restart') +
                '</font></font>');
              ///Channels.Channel[ChName].reload(true);
              if Setup.autoscroll then
                Channels.Channel[ChName].GoEnd;
            end;
          except
            on e: exception do
            begin
              Channels.Channel[lang.Get('update_page')].AddText('', lang.Get('update_page'),
                '<br><font size=-1 color=red>' + timetostr(time) + ' ' + lang.Get('update_err') + ': ' + e.message +
                '</font>');
              log('try update ' + e.message);
            end;
          end;
        end
        else if signature = '#FILEDATA' then // прием файла v1
        begin
          urlfname := urlencode(getsl(sl, 'FILE'));
          fname := URLdecode(getsl(sl, 'FILE'));
          ch := strtoint(getsl(sl, 'CHANNEL'));
          ChName := URLdecode(getsl(sl, 'CHANNEL_NAME'));
          ChName := lang.toMyLang(ChName);
          if (fname = '') or (fname = '*') then
            continue;
          mainform.in_label(true);
          try
            try
              if InternalFile(fname) then
                assignfile(fl_text, htmldir + fname) // картинки из сообщения (скрываем приход)
              else
                assignfile(fl_text, Setup.myPath + fname); // обычный файл
              rewrite(fl_text);
              _block := Base64Decode(getsl(sl, 'MSG'));
              write(fl_text, _block);
              CloseFile(fl_text);
              _block := '';
            except
              on e: exception do
              begin
                log('file decode: ' + e.message);
                emsg := DecodeErr(e.message);
                if emsg > '' then
                  Channels.Channel[GREEN].AddText('', GREEN, emsg);
              end;
            end;
          finally
            mainform.in_label(false);
          end;
          if InternalFile(fname) then
          begin
            Continue; // без сообщения
          end;
          // обычный файл
          fname := stringreplace(fname, ' ', #$a0, [rfReplaceall]);
          Packet := '<font color="black">' + lang.Get('file1') + ': </font> <a href="' + LNK_FILE + Setup.myPath + urlfname +
            '">' + Setup.myPath + fname + '</a>';
          // свободные
          if (ch = FREE_CH) or (ChName = GREEN) or (ChName = blue) or (ChName = red) then
            FreeMsg(FromIP, ChName, Packet, getsl(sl, 'USERS'))
            // личные каналы
          else if (ch = PERSONAL_CH) and (not InternalFile(fname)) then
            PersonalMsg(FromIP, ChName, Packet)
          else
          begin
            log('decode mistake file from (' + user_list.GetNickName(FromIP) + ') count=' + getsl(sl, 'USERS') +
              ' ch=' + ChName);
          end;
          if (Setup.soundon) and (Setup.s3on) then
            mysound(Setup.sndfile);
        end
        else if signature = '#PACKET' then
        begin
          mainform.in_label(true);
          try
            // канал
            ch := strtoint(getsl(sl, 'CHANNEL'));
            ChName := URLdecode(getsl(sl, 'CHANNEL_NAME')); // 12
            ChName := lang.toMyLang(ChName);
            // блок данных
            Packet := Base64Decode(getsl(sl, 'MSG'));
            // проверка на пустые сообщения
            if empty(Packet) then
              continue;
            // свободные
            if (ch = FREE_CH) or (ChName = GREEN) or (ChName = blue) or (ChName = red) then
              FreeMsg(FromIP, ChName, Packet, getsl(sl, 'USERS'))
            // личные каналы
            else if ch = PERSONAL_CH then
              PersonalMsg(FromIP, ChName, Packet)
            else // все прочее (с ошибками)
            begin
              log('decode mistake message from (' + user_list.GetNickName(FromIP) + ') count=' + getsl(sl, 'USERS') +
                ' ch=' + ChName);
            end;
            if Channels.Find(ChName) >= 0 then
              if (Setup.soundon) and (Setup.s5on) then
                mysound(Setup.sndin);
          finally
            mainform.in_label(false);
          end;
        end
        else
          Plugins.ExecDataDecode(widestring(sl.Text));
      end;
    finally
      myFreeAndNil(sl);
      Packet := '';
      busy := false;
    end;
  except
    on e: exception do
      log('Datadecode ' + signature + ' ' + e.message);
  end;
end;

// начальные установки
function TNetWork.Start:boolean;
var
  I: integer;
  port: Integer;
begin
  try
    log('init - 1');
    port := Setup.IcomPort;
    for I := 1 to 3 do
    begin
      try
        TCPserver.Active := false;
        TCPserver.DefaultPort := port;
        TCPserver.Active := true;
        TCPclient.Port := port;
        Break;
      except
        Delay(3000);
      end;
    end;
    // udp
    UDPclient.Active := false;
    UDPclient.BufferSize := netbufsize;
    UDPclient.Port := port;
    UDPclient.Active := true;
    UDPserver.Active := false;
    UDPserver.BufferSize := netbufsize;
    UDPserver.DefaultPort := port;
    UDPserver.Active := true;
    log('init - 2');
    Result := True;
  except
    on e: exception do
    begin
      log('Init ' + e.message);
      Result := false;
      if Pos('ALREADY IN USE', uppercase(e.message)) <> 0 then
        mainForm.FreeRes;
    end;
  end;
end;

Constructor TNetWork.Create;
begin
  inherited Create;
  IdAntiFreeze1 := TIdAntiFreeze.Create(Mainform);
  IdAntiFreeze1.Active := true;
  IdAntiFreeze1.ApplicationHasPriority := true;
  if not assigned(UDPclient) then
  begin
    UDPclient := TIdUDPClient.Create(NIL);
    UDPclient.BufferSize := netbufsize;
  end;
  if not assigned(UDPserver) then
  begin
    UDPserver := TIdUDPServer.Create(NIL);
    UDPserver.OnUDPRead := UDPServerUDPRead;
    UDPserver.BufferSize := netbufsize;
  end;
  if not assigned(TCPclient) then
  begin
    TCPclient := TIdTCPClient.Create(NIL);
    TCPclient.ConnectTimeout := 1000;
  end;
  if not assigned(TCPserver) then
  begin
    TCPserver := TIdTCPServer.Create(NIL);
    TCPserver.OnExecute := TCPServerExecute;
    TCPServer.TerminateWaitTime := 2000;
  end;
  busy := false;
  msgin := TstringList.Create;
end;

Procedure TNetWork.GetAvatar(ip: string);
var
  tmpstr: String;
Begin
  tmpstr := '#AVATAR' + LF;
  UDPsend(ip, tmpstr);
end;

// indy10
procedure TNetWork.TCPServerExecute(AContext: TIdContext);
var
  tmp, tmpstr: string;
  FStream: TFileStream;
  fname: string;
  fsize: int64;
  ch, ch_name, usercount: string;
  blocksize:integer;
  sl: TStringlist;
begin
  try
    try
      with AContext.Connection do
      begin
        tmp := AContext.Connection.IOHandler.ReadLn;
        if tmp = '#FILEDATAV2' then
        begin
          mainform.in_label(true);
          try
            // остаток данных
            tmpstr := tmp + LF;
            while tmp <> '#END' do
            begin
              tmp := AContext.Connection.IOHandler.ReadLn;
              tmpstr := tmpstr + tmp + LF;
            end;
            sl := TStringList.Create;
            sl.Text := tmpstr;
            //
            fname := urldecode(getsl(sl,'FILE'));
            fsize := strtoint(getsl(sl, 'FILESIZE'));
            if AContext.Binding.PeerIP = Setup.myIP then
              FStream := TFileStream.Create(Setup.myPath + fname, fmCreate)
            else if (InternalFile(fname)) then
              FStream := TFileStream.Create(htmldir + fname, fmCreate) // картинки из сообщения
            else
              FStream := TFileStream.Create(Setup.myPath + fname, fmCreate); // обычный файл
            ch := getsl(sl, 'CHANNEL');
            ch_name := urldecode(getsl(sl, 'CHANNEL_NAME'));
            UserCount := getsl(sl,'USERS');
            while FStream.Size<fsize do
            begin
              if fsize-FStream.Size>10*MB then
                blocksize:=10*MB
              else
                blocksize:=fsize-FStream.Size;
              AContext.Connection.IOHandler.ReadStream(FStream, blocksize, false);
              delay(100);
            end;
            myFreeAndNil(FStream);
            myFreeAndNil(sl);
          finally
            mainform.in_label(false);
          end;
          if (InternalFile(fname))and(lowercase(extractfileext(fname))='.gif') then
            gif2jpg(htmldir + fname);
          if (ch_name > '')and(not InternalFile(fname)) then
          begin
            tmpstr := '<font color="black">' + lang.Get('file1') + ': </font><a href="'+LNK_FILE+urlencode(Setup.myPath+fname)+'">'+fname+'</a> ';
            EncodeV2(tmpstr, '#PACKET', tmpstr, strtoint(Ch), strtoint(usercount), '', ch_name);
          end;
        end
        else
          tmpstr := tmp + AContext.Connection.IOHandler.AllData;
        if last_in_message = tmpstr then
        begin
          //  AntiSpam
          exit;
        end;
        if msgin.count > maxmsg then
        begin
          msgin.delete(0);
        end
        else
        begin
          if tmpstr > '' then
          begin
            tmpstr := tmpstr + LF + '#REALIP' + LF + AContext.Binding.PeerIP;
            msgin.Add(tmpstr);
            //log('tcpread: '+AContext.Binding.PeerIP+' '+copy(tmpstr,1,Pos(LF, tmpstr)));
          end;
        end;
      end;
      last_in_message := tmpstr;
    except
      on e: exception do
      begin
        log('TCPServerExecute: ' + e.message);
        AContext.Connection.IOHandler.Close;
      end;
    end;
  finally
    mainform.in_label(false);
    application.ProcessMessages;
    TCPserver.Active := true;
  end;
end;

procedure TNetWork.UDPServerUDPRead(AThread: TIdUDPListenerThread; AData: TArray<System.Byte>;
  ABinding: TIdSocketHandle);
var
  tmpstr: String;
begin
  tmpstr := BytesToString(AData);
  tmpstr := tmpstr + LF + '#REALIP' + LF + ABinding.PeerIP; // добавим откуда пришло
  if msgin.count > maxmsg then
  begin
    msgin.delete(0);
  end
  else
  begin
    if tmpstr > '' then
    begin
      msgin.Add(tmpstr);
    end;
  end;
end;

// передать аватар по указанному ip
Procedure TNetWork.SendAvatar(ip: string; i_am: Tuser);
var
  st: Tstringstream;
  avStr: string;
  tmpstr: string;
  fl: string;
begin
  st := Tstringstream.Create('');
  try
    fl :=  CacheDir + IntToStr(user_list[Setup.myip].randId) + '.jpg';
    if not FileExists(fl) then
      exit;
    //i_am.big.SaveToStream(st);
    st.LoadFromFile(fl);
    st.Position := 0;
    avStr := st.DataString;
    // данные для передачи
    EncodeV2(tmpstr, '#BIG', avStr, 0, 1, '', '');
    TCPsend(ip, tmpstr, false);
  finally
    myFreeAndNil(st);
  end;
end;

// готовый пакет послать всем
Procedure TNetWork.SendUDPPKG(package: string);
var
  I: integer;
begin
  for I := 0 to user_list.count - 1 do
  begin
    if (user_list[I].status <> OFFLINE) then
    begin
      UDPsend(user_list[I].ip, package);
    end;
  end;
end;

destructor TNetWork.Destroy;
begin
end;

end.
