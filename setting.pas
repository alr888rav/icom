unit setting;

interface

uses windows, menus, extctrls, buttons, stdctrls, controls, Forms, jpeg, graphics, classes,   SysUtils, Dialogs,
  ComCtrls, messages, Xml.XMLIntf, Xml.Win.msxmldom,
  Xml.XMLDoc, System.TypInfo, system.rtti;

// настройки
type
  TSetupClass = class(TObject)
  private
    savePort: integer;
    FTraf_limit:integer;
    FIdle_limit:integer;
    Fidle_max: integer;
    FStart_lang:integer;
    FMale:integer;
    fNo_send_limit: integer;
    procedure SetTraf_limit(value:integer);
    procedure SetIdle_limit(value:integer);
    procedure SetIdle_max(value:integer);
    procedure SetStart_lang(value:integer);
    procedure SetMale(value:integer);
    procedure SetNo_send_limit(value:integer);
    procedure serializeOther(node: IXMLNode);
    procedure serializeOBJ(node: IXMLNode; Obj: TObject);
  public
    //
    lastVer: string;
    // не мигать иконкой
    stoptray:boolean;
    // разрешить подключаться всем
    autoconnect: boolean;
    // переходить на страницу с непрочитанными сообщениями
    actpage: boolean;
    // кнопка удаления в трафике 0=выкл 1=красная 2=прозрачная
    delbtn: integer;
    // кнопка цитирования в трафике вкл/выкл
    quotebtn: boolean;
    // автоматически создавать свободный канал
    autofree: boolean;
    // сворачивать длинные сообщения
    Collapselong: boolean;
    // показывать инфу о польз.
    showinfo: boolean;
    // для хоткеев
    hot1, hot2, hot3: string;
    // иконки каналов
    channelicons: integer;
    // автоматически чистить траф
    checktraf: boolean;
    // автоматически выходить ....
    checkexit: boolean;
    // Масштабирование картинок
    zoom: boolean;
    zoomMode: integer;
    // звуки
    soundon: boolean;
    s1on: boolean;
    s2on: boolean;
    s3on: boolean;
    s4on: boolean;
    s5on: boolean;
    s6on: boolean;
    sndonline: string;
    sndoffline: string;
    sndin: string;
    sndout: string;
    sndfile: string;
    snderror: string;
    // расположение закладок каналов
    tabspos: integer;
    // кнопка скрола
    autoscroll: boolean;
    // подтверждения открытия ссылки
    //confirmurl: boolean;
    // подтверждать очистку
    confirmdelete: boolean;
    // подтверждать удаление сообщения
    confirmdelmsg: boolean;
    // принимать и устанавливать ли чужой ник
    setnick: boolean;
    // оффлайн в конце
    OfflineEnd: boolean;
    // показывать оффлайн
    ShowOffline: boolean;
    // разделительная линия
    drawlines: boolean;
    // тип списка пользователей
    userboxmode: integer; // ничего-0 иконка слева-1 аватар_слева-2 аватар_справа-3 ничего-4 ничего-5
    // шрифт для системных сообщений
    sysfont: Tfont;
    // свой шрифт
    myFont: Tfont;
    Bstyle, Istyle: boolean;
    // всплыв сообщения
    showballon: boolean;
    // время простоя
    idletime: integer;
    // обратный режим enter-ctrl-enter
    entermode2: boolean;
    // положение и размеры окна
    myTop, MyLeft, Mywidth, MyHeight, TrafWidth: integer;
    state: integer;
    // путь приема файлов
    myPath: string;
    // цвет окна
    WinColor: Tcolor;
    // показывать подкл/откл в трее
    trayonoff: boolean;
    // размер поля ввода
    inheight: integer;
    // игнорлист
    BlackList: Tstringlist;
    // открытые каналы
    ChannelList: Tstringlist;
    // проверять на ошибочный язык
    warnlang: boolean;
    // язык интерфейса
    icomlang: string;
    // показывать в меню зел/син/кр каналы
    showrgb: boolean;
    // вкладки многострочные
    MultirowPages: boolean;
    // подтверждать закрытие каналов
    confirmclosepage: boolean;
    // очищать личные при выходе
    ClearPersonal: boolean;
    // Размер кнопок на главной форме
    //BigButtons: boolean;
    // порт икома
    IcomPort: integer; // 6711;
    // для хоткеев
    atm: ATOM;
    // др
    dr: string;
    // список локальных адресов
    localip: Tstringlist;
    // мой ник
    MyName: string;
    // последний запрос апдейта
    LastReqUpdateTime: TDateTime;
    // сортировать список (по никам)
    userboxsort: boolean;
    // закрывать форму смайликов по клику
    closeSmiles: boolean;
    // сохранять траф
    saveTraf: Boolean;
    // кнопки доп смайликов
    quickSmiles: boolean;
    // время простоя после которого не слать
    property nosendredlimit: integer read fno_send_limit write Setno_send_limit;
    // время до автоматической чистки трафика (часов)
    property traflimit: integer read FTraf_Limit write SetTraf_limit;
    // время до автоматического выхода (часов)
    property idleexit: integer read FIdle_limit write Setidle_limit;
    // время до перехода в красный цвет
    property idlemax: integer read FIdle_max write SetIdle_max;
    // стартовый язык
    property Startlang: integer read Fstart_lang write SetStart_lang;
    // пол
    property male: integer read FMale write SetMale;
    //
    function myIP: string;
    procedure compareOBJ(Obj2: TObject);
    procedure LoadXML;
    procedure SaveXML;
    procedure LoadSetup;
    procedure SaveSetup;
    procedure LoadFree;
    procedure DeleteHotKey;
    function GetKey: string;
    function GetFileKey: string;
    function GetSetupKey: string;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses main, CommonLib, Global, ulog, winnet, simpleEncrypt, htmllib;

const
  i3600 = 3600;
  i1000 = 1000;
  i12 = 12;
  i24 = 24;

procedure TSetupClass.SetNo_send_limit(value:integer);
begin
  if value < 1 then
    fNo_send_limit := 1
  else if value > 24 then
    fNo_send_limit := 24
  else
    fNo_send_limit := value;
end;

procedure TSetupClass.SetTraf_limit(value:integer);
begin
  if value<=0 then
     FTraf_limit:=i12
  else if value>i1000 then
     FTraf_limit:=i1000
  else
     FTraf_limit:=value;
end;

procedure TSetupClass.SetIdle_limit(value:integer);
begin
  if value<=0 then
     FIdle_limit:=i24
  else if value>i1000 then
     FIdle_limit:=i1000
  else
     FIdle_limit:=value;
end;

procedure TSetupClass.SetIdle_max(value:integer);
begin
  if value<=0 then
     FIdle_max:=180
  else if value>i3600 then
     FIdle_max:=i3600
  else
     FIdle_max:=value;
end;

procedure TSetupClass.SetStart_lang(value:integer);
begin
  if value<=0 then
     FStart_lang:=0
  else
     FStart_lang:=value;
end;

procedure TSetupClass.SetMale(value:integer);
begin
  if (value<0)or(value>1) then
     FMale:=0
  else
     FMale:=value;
end;

function TSetupClass.myIP: string;
begin
  if localip.Count <> 0 then
    result := localip.Strings[0]
  else
    result := '127.0.0.1';
end;

function TSetupClass.GetFileKey: string;
const
  sendkey = {$I sendkey.inc }    // in file: 'sample_string';
begin
  result := SendKey;
end;

function TSetupClass.GetSetupKey: string;
const
  setupkey = {$I setupkey.inc }    // in file: 'sample_string';
begin
  result := SetupKey;
end;

function TSetupClass.GetKey: string; deprecated;
begin
  Result := '';
end;

Procedure TSetupClass.DeleteHotKey;
begin
  unRegisterHotKey(application.Handle, atm);
  GlobalDeleteAtom(atm);
end;

procedure TSetupClass.LoadSetup;
begin
  // свои ip
  try
    localip.text := winnet.GetLocalIPs(false); // без
    if localip.text = '' then
      localip.text := winnet.GetLocalIPs(true);
  except
    showmessage('No IP address');
    Halt(1);
  end;

  if FileExists(path + ini_file_xml) then
    LoadXML()
  else
  begin
    // мое имя
    if MyName = '' then
    begin
      MyName := copy(inputbox(iTitle, 'Nick name', ''), 1, 30);
      if MyName = '' then
        Halt(1);
      user_list.AddUser(MyName, myIP);
      user_list[myIp].sortorder := 0;
      user_list[myIp].dr := '';
      user_list[myIp].male := male;
      user_list[myIp].status := ONLINE;
      if fileexists(path + myavatar) then
      begin
        copyfile(PChar(path + myavatar), PChar(cacheDir + inttostr(user_list[myIp].randId) + '.jpg'), false);
{        try
          user_list[myIp].big.LoadFromFile(path + myavatar);
          user_list[myIp].big.SaveToFile(cacheDir + inttostr(user_list[myIp].randId) + '.jpg');
        except
          on e: exception do
            log('bad avatar 3: '+e.Message);
        end; }
      end;
    end;
  end;
  SavePort := IcomPort;
  // освободим и назначим хоткей
  DeleteHotKey;
  if (hot1 > '') and (hot3 > '') then
    AddHK(atm, hot1, hot2, hot3);
  if Bstyle then
    myFont.Style := [fsBold];
  if Istyle then
    myFont.Style := myFont.Style + [fsItalic];
  if copy(myPath, length(myPath), 1) <> '\' then
    myPath := myPath + '\';
  createdir(myPath);
end;


procedure serializeFont(base: IXMLNode; f: Tfont);
var
  n2: IXMLNode;
begin
  n2:= base.AddChild('name');
  n2.Text := f.Name;
  n2:= base.AddChild('size');
  n2.Text := IntToStr(f.Size);
  n2:= base.AddChild('color');
  n2.Text := HTMLColor(f.Color);
  n2:= base.AddChild('bold');
  n2.Text := BoolToStr(fsBold in f.Style, true);
  n2:= base.AddChild('italic');
  n2.Text := BoolToStr(fsItalic in f.Style, true);
end;


procedure TSetupClass.serializeOBJ(node: IXMLNode; Obj: TObject);
var
  LContext: TRttiContext;
  LClass: TRttiInstanceType;
  f: System.Tarray<TRttiField>;
  p: System.Tarray<TRttiProperty>;
  i: integer;
  n: IXMLNode;
begin
  LContext := TRttiContext.Create;
  LClass := LContext.GetType(Obj.ClassType) as TRttiInstanceType;
  f := LClass.GetFields;
  for i := 0 to Length(f)-1 do
  begin
     if f[i].Visibility <> mvPrivate then
     begin
       if f[i].FieldType.TypeKind in [tkUString, tkInteger, tkEnumeration] then
       begin
         n := node.AddChild(LowerCase(f[i].Name));
         if pos('TColor',f[i].FieldType.qualifiedname)<>0 then
           n.Text := HtmlColor(f[i].GetValue(Obj).AsVariant)
         else
           n.Text := f[i].GetValue(Obj).ToString;
       end
     end
  end;
  p := LClass.GetProperties;
  for i := 0 to Length(p)-1 do
  begin
     if p[i].Visibility <> mvPrivate then
     begin
       if p[i].PropertyType.TypeKind in [tkUString, tkInteger, tkEnumeration] then
       begin
         n := node.AddChild(LowerCase(p[i].Name));
         n.Text := p[i].GetValue(Obj).ToString;
       end
     end
  end;
end;

procedure TSetupClass.serializeOther(node: IXMLNode);
var
  i: integer;
  n, n2: IXMLNode;
  s: string;
  sip: string;
  c: TCipher;
begin
  // fonts
  n := node.AddChild('myfont');
  serializefont(n, myFont);
  n := node.AddChild('sysfont');
  serializefont(n, sysfont);
  // blacklist
  c := TCipher.Create;
  n := node.AddChild('blacklist');
  for i := 0 to blackList.Count-1 do
  begin
     s := c.EnCrypt(blacklist[i]);
     n2 := n.AddChild('ip');
     n2.text := s;
  end;
  // users
  n := node.AddChild('users');
  for i := 0 to user_List.Count-1 do
  begin
    if (user_list[i].Name>'')and(user_list[i].ip>'') then
    begin
      // шифруем ip
      sip := c.EnCrypt(user_list[i].ip);
      s := user_list[i].Name + '=' + sip;
      n2 := n.AddChild('ip');
      n2.text := s;
    end;
  end;
  c.Free;
  // open channels
  n := node.AddChild('channels');
  for i := 0 to mainform.pagecontrol1.PageCount - 1 do
  begin
    if (i <= mainform.pagecontrol1.PageCount - 1) and (trim(mainform.pagecontrol1.pages[i].Caption) > '') and
      (mainform.pagecontrol1.pages[i].tag >= 0) and (mainform.pagecontrol1.pages[i].tabvisible) then
    begin
      n2 := n.AddChild('ch');
      n2.text := trim(mainform.pagecontrol1.pages[i].Caption)+'='+inttostr(mainform.pagecontrol1.pages[i].tag);
    end
  end;
end;

procedure TSetupClass.SaveXML;
var
  XMLDoc:TXMLDocument;
  local: IXMLNode;
 // sl : TStringList;
begin
  XMLDoc := TXMLDocument.Create(nil) ;
  try
    XMLDoc.Active := True;
    local := XMLDoc.AddChild('local');
    // все свойства
    serializeObj(local, self);
    serializeOther(local);
    // header + write XML file
    XMLDoc.Encoding := 'UTF-8';
    XMLDoc.Version := '1.0';
    XMLDoc.StandAlone := 'no';
    XMLDoc.SaveToFile(path + ini_file_xml);
    XMLDoc.Active := False;
  finally
    {$HINTS OFF}
    XMLDoc := nil;
  end;
end;
{$HINTS ON}

procedure deSerializeFont(base: IXMLNode; Obj: TFont; name: string);
var
  node2, node3: IXMLNode;
  bl, it: Boolean;
begin
  node2 := base.childnodes.FindNode(name);
  if node2 <> nil then
  begin
    bl := False;
    node3 := node2.childnodes.FindNode('name');
    if node3 <> nil then
      obj.Name := node3.Text;
    node3 := node2.childnodes.FindNode('size');
    if node3 <> nil then
      obj.Size := StrToInt(node3.Text);
    node3 := node2.childnodes.FindNode('color');
    if node3 <> nil then
      obj.Color := HtmlColor2Color(node3.Text);
    node3 := node2.childnodes.FindNode('bold');
    if node3 <> nil then
      bl := StrToBool(node3.Text);
    node3 := node2.childnodes.FindNode('italic');
    if node3 <> nil then
    begin
      it := StrToBool(node3.Text);
      if bl then
        obj.Style := [fsBold];
      if it then
        obj.Style := obj.Style + [fsItalic];
    end;
  end;
end;

procedure TSetupClass.LoadXML;
var
  XMLDoc:IXMLDocument;
  local, node, node2, node3: IXMLNode;
  i: Integer;
  LContext: TRttiContext;
  LClass: TRttiInstanceType;
  f: System.Tarray<TRttiField>;
  p: System.Tarray<TRttiProperty>;
  fl: TRttiField;
  pr: TRttiProperty;
  ss_name, ss_ip: string;
  ad: Boolean;
  value: string;
  tv: TValue;
  c: TCipher;
begin
  LContext := TRttiContext.Create;
  LClass := LContext.GetType(TSetupClass) as TRttiInstanceType;
  f := LClass.GetFields;
  p := LClass.GetProperties;

  XMLDoc := TXMLDocument.Create(nil) ;
  try
    XMLDoc.LoadFromFile(path + ini_file_xml);
    local := XMLDoc.DocumentElement;
    for i:=0 to local.ChildNodes.Count-1 do
    begin
      node := local.ChildNodes.Get(i);
      if node.IsTextElement then
      begin
        fl:=LClass.GetField(node.NodeName);
        if fl <> nil then
        begin
          if fl.fieldtype.typekind in [tkEnumeration] then
          begin
            tv := tv.From<Boolean>(StrToBool(node.text));
            fl.SetValue(Self, tv);
          end
          else if fl.fieldtype.typekind in [tkInteger] then
          begin
            if Pos('TColor',fl.FieldType.QualifiedName)<>0 then
              tv := tv.From<TColor>(HtmlColor2Color(node.text))
            else
              tv := tv.From<Integer>(StrToint(node.text));
            fl.SetValue(Self, tv);
          end
          else if fl.fieldtype.typekind in [tkString, tkUstring] then
          begin
            tv := tv.From<String>(node.text);
            fl.SetValue(Self, tv);
          end;
        end
        else
        begin
          pr:=LClass.GetProperty(node.NodeName);
          if pr <> nil then
          begin
            if pr.PropertyType.typekind in [tkEnumeration] then
            begin
              tv := tv.From<Boolean>(StrToBool(node.text));
              pr.SetValue(Self, tv);
            end
            else if pr.PropertyType.typekind in [tkInteger] then
            begin
              if Pos('TColor',pr.PropertyType.QualifiedName)<>0 then
                tv := tv.From<TColor>(HtmlColor2Color(node.text))
              else
                tv := tv.From<Integer>(StrToint(node.text));
              pr.SetValue(Self, tv);
            end
            else if pr.PropertyType.typekind in [tkString, tkUstring] then
            begin
              tv := tv.From<String>(node.text);
              pr.SetValue(Self, tv);
            end;
          end;
        end;
      end;
    end;
    // шрифты
    deSerializeFont(local, myFont, 'myfont');
    deSerializeFont(local, sysFont, 'sysfont');
    // users
    // свои ip
    try
      localip.text := winnet.GetLocalIPs(false); // без
      if localip.text = '' then
        localip.text := winnet.GetLocalIPs(true);
    except
      showmessage('No IP address');
      Halt(1);
    end;
    // мое имя
    if MyName = '' then
    begin
      MyName := copy(inputbox(iTitle, 'Nick name', ''), 1, 30);
      if MyName = '' then
        Halt(1);
    end;
    // новый список
    user_list.ClearUsers;
    // себя первым
    user_list.AddUser(MyName, myIP);
    user_list[myIp].sortorder := 0;
    user_list[myIp].dr := '';
    user_list[myIp].male := male;
    user_list[myIp].status := ONLINE;
    if fileexists(path + myavatar) then
    begin
      copyfile(PChar(path + myavatar), PChar(cacheDir + inttostr(user_list[myIp].randId) + '.jpg'), false);
{      try
        user_list[myIp].big.LoadFromFile(path + myavatar);
        user_list[myIp].big.SaveToFile(cacheDir + inttostr(user_list[myIp].randId) + '.jpg');
      except
        on e: exception do
          log('bad avatar 3: '+e.Message);
      end; }
    end;
    // список
    node2 := local.childnodes.FindNode('users');
    if node2 <> nil then
    begin
      c := TCipher.Create;
      for i := 0 to node2.ChildNodes.Count-1 do
      begin
        node3 := node2.ChildNodes.Get(i);
        value := node3.NodeValue;
        ss_name := Copy(value, 1, Pos('=', value)-1);
        ss_ip := Copy(value, Pos('=', value)+1);
        // расшифровываем ip
        ss_ip := c.DeCrypt(ss_ip);
        if ss_ip='' then
          ss_ip := Copy(value, Pos('=', value)+1);
        // проверим ip на правильность
        if not testIP(ss_ip) then
          ss_ip := '';
        if ss_name = '' then
          ss_ip := '';
        if ss_ip = myIP then
          continue; // себя не добавляем
        if ss_name > '' then
        begin
          // проверим нет ли такого уже
          ad := false;
          if user_list.GetID(ss_name)>=0 then// если есть - пропустим
            continue;
          //
          user_list.AddUser(ss_name, ss_ip); // добавим элемент (с 0)
          user_list[ss_ip].sortorder := i + 1;
          user_list[ss_ip].dr := '';
          user_list[ss_ip].file_protocol := 1;
        end;
      end;
    end;
    // blacklist
    node2 := local.childnodes.FindNode('blacklist');
    if node2 <> nil then
    begin
      c := TCipher.Create;
      for i := 0 to node2.ChildNodes.Count-1 do
      begin
        node3 := node2.ChildNodes.Get(i);
        value := node3.NodeValue;
        value := c.DeCrypt(value);
        if BlackList.IndexOf(value)<0 then
          BlackList.Add(value);
      end;
    end;
    // open channels
    node2 := local.childnodes.FindNode('channels');
    if node2 <> nil then
    begin
      for i := 0 to node2.ChildNodes.Count-1 do
      begin
        node3 := node2.ChildNodes.Get(i);
        value := node3.NodeValue;
        ChannelList.Add(value);
      end;
    end;
    XMLDoc.Active := False;
    DeleteFile(path + ini_file);
  finally
    {$HINTS OFF}
    XMLDoc := nil;
  end;
end;

// сохранить установки
procedure TSetupClass.SaveSetup;
begin
  myTop := mainForm.Top;
  MyLeft := mainForm.Left;
  Mywidth := mainForm.Width;
  MyHeight := mainForm.Height;
  TrafWidth := mainForm.PageControl1.Width;
  state := Integer(mainForm.WindowState);
  lastVer := ver;
  if TestMode then
    IcomPort := savePort;
  SaveXML;
end;

Procedure TSetupClass.LoadFree;
var
  i: integer;
  value: string;
  ss: string;
  ss_tag: integer;
begin
  mainForm.NewTab(green, true, FREE_CH);
  for i := 0 to ChannelList.Count-1 do
  begin
    value := Trim(ChannelList.Strings[i]);
    ss := Copy(value, 1, Pos('=',value)-1);
    ss_tag := StrToInt(Copy(value, Pos('=', value)+1));
    if ss_tag = READONLY_CH then
      continue;
    if ss <> delsym(ss) then
      continue; // ошибочные имена пропустим
    if (ss_tag<>FREE_CH)and(ss_tag<>PERSONAL_CH) then
      ss_tag := PERSONAL_CH;
    if ss > '' then
      mainform.NewTab(ss, false, ss_tag);
  end;
end;

{$WARNINGS OFF}
function SystemDefaultLang:string;
var
  Buffer : PChar;
  Size : integer;
const
  LCType = LOCALE_SABBREVLANGNAME;
begin
  Size := GetLocaleInfo(LOCALE_USER_DEFAULT, LCType, nil, 0);
  GetMem(Buffer, Size);
  try
    GetLocaleInfo(LOCALE_USER_DEFAULT, LCType, Buffer, Size);
    Result := Copy(string(Buffer),1,2);
  finally
    FreeMem(Buffer);
  end;
end;
{$WARNINGS ON}

constructor TSetupClass.Create;
begin
  inherited Create;
  sysfont := Tfont.Create;
  myFont := Tfont.Create;
  BlackList := Tstringlist.Create;
  ChannelList := Tstringlist.Create;
  localip := Tstringlist.Create;
  // каналы
  showrgb := true;
  autofree := true;
  channelicons := 0;
  // картинки
  zoom := true;
  zoomMode := 2;
  // звуки
  soundon := true;
  s1on := false;
  s2on := true;
  s3on := true;
  s4on := true;
  s5on := true;
  s6on := true;
  sndonline := SoundDir + 'online.mp3';
  sndoffline := SoundDir + 'offline.mp3';
  sndin := SoundDir + 'in.mp3';
  sndout := SoundDir + 'out.mp3';
  sndfile := SoundDir + 'file.mp3';
  snderror := SoundDir + 'error.mp3';
  // hotkey
  hot1 := '';
  hot2 := '';
  hot3 := '';
  // автоматизация
  LastReqUpdateTime := date - 1;
  traflimit := i24;
  idleexit := i24;
  idlemax := 180;
  checktraf := false;
  checkexit := false;
  // паранойя
  stoptray := false;
  nosendredlimit := 3;
  autoconnect := true;
  // прочее
  saveTraf := false;
  closeSmiles := true;
  IcomPort := default_port;
  //BigButtons := true;
  quickSmiles := false;
  autoscroll := true;
  ClearPersonal := true;
  confirmclosepage := true;
  MultirowPages := false;
  warnlang := true;
  Startlang := 0;
  if (SystemDefaultLang = 'RU')or
     (SystemDefaultLang = 'EN')or
     (SystemDefaultLang = 'UA') then
    icomlang := SystemDefaultLang+'.lng'
  else
    icomlang := 'EN.lng';

  actpage := true;
  delbtn := 1;
  quotebtn := false;
  male := 0;
  Collapselong := true;
  showinfo := true;
  dr := '';
  tabspos := 0;
  confirmdelete := true;
  confirmdelmsg := true;
  setnick := true;
  userboxmode := 0;
  userboxsort := false;
  OfflineEnd := false;
  ShowOffline := true;
  drawlines := true;
  showballon := true;
  myTop := 0;
  MyLeft := 0;
  Mywidth := 700;
  MyHeight := 600;
  inheight := 200;
  TrafWidth := 550;
  state := integer(wsNormal);
  entermode2 := false;
  trayonoff := false;
  WinColor := clWhite;
  //
  sysfont.Color := clred;
  sysfont.name := 'Arial';
  sysfont.Size := 12;
  //
  myFont.Color := clBlack;
  myFont.name := 'Arial';
  myFont.Size := 12;
  Bstyle := false;
  Istyle := false;
  myFont.Style := [];
  //
  myPath := 'c:\common\';
  createdir(myPath);
  // свои ip
  try
    localip.text := winnet.GetLocalIPs(false); // без
    if localip.text = '' then
      localip.text := winnet.GetLocalIPs(true);
  except
    showmessage('No IP address');
    Halt(1);
  end;
  // мое имя
  MyName := '';
end;

destructor TSetupClass.Destroy;
begin
  myFreeAndNil(localip);
  myFreeAndNil(BlackList);
  myFreeAndNil(sysfont);
  myFreeAndNil(myFont);
  inherited Destroy;
end;

procedure TSetupClass.compareOBJ(Obj2: TObject);
var
  LContext: TRttiContext;
  LClass, LClass2: TRttiInstanceType;
  f,f2: System.Tarray<TRttiField>;
  p,p2: System.Tarray<TRttiProperty>;
  i: integer;
  n: IXMLNode;
  eq: boolean;
begin
  eq := true;
  LContext := TRttiContext.Create;
  LClass := LContext.GetType(self.ClassType) as TRttiInstanceType;
  LClass2 := LContext.GetType(Obj2.ClassType) as TRttiInstanceType;
  f := LClass.GetFields;
  f2 := LClass2.GetFields;
  for i := 0 to Length(f)-1 do
  begin
     if f[i].Visibility <> mvPrivate then
     begin
       if f[i].FieldType.TypeKind in [tkUString, tkInteger, tkEnumeration] then
       begin
         if (f[i].Name=f2[i].name)and(f[i].GetValue(self).ToString<>f2[i].GetValue(Obj2).ToString) then
           eq := false;
       end
     end
  end;
  p := LClass.GetProperties;
  p2 := LClass2.GetProperties;
  for i := 0 to Length(p)-1 do
  begin
     if p[i].Visibility <> mvPrivate then
     begin
       if p[i].PropertyType.TypeKind in [tkUString, tkInteger, tkEnumeration] then
       begin
         if (p[i].Name=p2[i].name)and(p[i].GetValue(self).ToString<>p2[i].GetValue(Obj2).ToString) then
           eq := false;
       end
     end
  end;
end;

end.
