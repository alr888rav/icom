unit icomchannels;

interface

uses windows, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.forms, ActiveX, SHDocVw, Classes, Sysutils, vcl.buttons,
 IcomView, Vcl.Controls, dialogs, Vcl.Graphics, vcl.stdctrls, vcl.menus,
 commonlib, MSHTML_TLB;

type
  TChannel = class
  private
    fLastUpdate: TDateTime;
    fhtml: TStringList;
    fmodified: boolean;
    lastId: string;
    function GetHtml: string;
    function GetReady: boolean;
    procedure SetHtml(value:string);
  public
    style: Integer;
    Browser: TIcomViewer;
    TabSheet: TTabSheet;
    Name: string;
    Tag: integer;
    Blink: Boolean;
    FileName: string;
    property LastUpdate: TDateTime read fLastUpdate;
    property Ready: boolean read GetReady;
    property html: string read GetHtml write SetHtml;
    procedure GoBegin;
    procedure GoEnd;
    procedure Reload(toEnd:boolean);
    procedure Refresh;
    procedure Clear;
    procedure LoadFromFile(fname: string);
    procedure SaveToFile(fname:string);
    procedure AddSysText(FromName, chname: string; msg: string; color: string);
    procedure AddText(FromName, chname, msg: string);
    procedure AddHtml(msg:string; divtype:Integer=0);   // 0-нет 1-sys 2-text
    procedure addHtmlDirect(msg:string);
    constructor Create(Acontrol: TwinControl);
    destructor Destroy; override;
    function SelText:string;
    procedure Hide;
    procedure Show;
    function GetMessage(id:string):string;
  end;

  TChannels = class
  private
    PageControl: TPageControl;
    FChannels: TStringlist;
    Function GetCount: integer;
    procedure SetChannel(chname: string; NewChannel: TChannel);
    function GetId(chname: string): integer;
    procedure BlinkTimerTimer(Sender: TObject);
    function chname2index(ch: string): integer;
  public
    //green, blue, red: string;
    ChannelIcons: integer;
    ChannelsForm: TForm;
    BlinkTimer: TTimer;
    constructor Create(Acontrol: TwinControl);
    destructor Destroy; override;
    procedure Add(Acontrol: TwinControl; chname: string; Tag: integer);
    procedure Delete(chname: string); overload;
    procedure Delete(index: integer); overload;
    property Count: integer read GetCount;
    function Find(chname: string): integer;
    function FindTab(TabName: string): integer;
    Procedure StartBlink;
    Procedure SetChannelIcons(icons_mode: integer);
    function getChannel(id: Integer):TChannel; overload;
    function GetChannel(chname: string): TChannel; overload;
    property Channel[chname: string]: TChannel read GetChannel write SetChannel; default;
  end;

implementation

uses htmllib, main, Global;

function TChannel.GetMessage(id:string):string;
var
  h1,h2: IDispatch;
  t1, t2: string;
begin
  h1 := browser.GetElementById(id);
  if h1 <> nil then
    t1 := IHTMLElement(h1).outerHTML
  else
    t1 := '';
  h2 := browser.GetElementById('m'+copy(id,2));
  if h2 <> nil then
    t2 := IHTMLElement(h2).outerHTML
  else
    t2 := '';
  result := t1 + #13#10 + t2;
end;

function TChannel.GetReady: boolean;
var
  i:integer;
begin
  if Assigned(Browser) then
  begin
    result := false;
    for i:=0 to 50 do
    begin
      if Browser.Ready then
      begin
        result:=true;
        break;
      end;
      sleepex(100, false);
      Application.ProcessMessages;
    end;
  end
  else
    result:=false;
end;

procedure TChannel.Hide;
begin
  if assigned(TabSheet) then
    TabSheet.TabVisible := false;
end;

procedure TChannel.Show;
begin
  if assigned(TabSheet) then
    TabSheet.TabVisible := true;
end;

function TChannel.SelText:string;
begin
  if Assigned(browser)and(Ready) then
    result := Browser.SelText;
end;

procedure TChannel.Clear;
begin
  if (assigned(Browser))and(Ready) then
  begin
    fLastUpdate := Now;
    fHtml.Text := NewHtml;
    ReLoad(true);
    Blink := false;
    fmodified := True;
  end;
end;

procedure TChannel.AddHtml(msg:string; divtype:Integer=0);   // 0-нет 1-sys 2-text
var
  i:integer;
begin
  fLastUpdate := Now;
  for i := fhtml.count - 1 downto 0 do
  begin
    if Pos('</BODY>', UpperCase(fhtml.Strings[i])) <> 0 then
    begin
      msg := DetectURL(msg);
      if Setup.zoom then
        msg := ImgSize(msg);
      // уберем рамку картинок
      msg := stringreplace(msg, '<img ', '<img border="0" ', [rfReplaceall, rfIgnoreCase]);
      fhtml.insert(i, msg);
      addHtmlDirect(msg);
      break;
    end;
  end;
  fmodified := True;
end;

procedure TChannel.addHtmlDirect(msg:string);
begin
  if Assigned(browser) then
    Browser.Append(msg);
end;

procedure TChannel.AddText(FromName, chname, msg: string);
begin
  AddHTML(AddText2HTML2(FromName, chname, msg, lastId), 2);
end;

procedure TChannel.AddSysText(FromName, chname: string; msg: string; color: string);
begin
  lastId := inttostr(GetTickCount);
  AddHTML(AddSysText2HTML2(FromName, chname, msg, color, lastId), 1);
end;

procedure TChannel.LoadFromFile(fname: string);
begin
  if fileexists(fname) then
  begin
    fLastUpdate := Now;
    fhtml.LoadFromFile(fname);
    if assigned(browser) then
      browser.LoadFromFile(fname);
    FileName := fname;
    Blink := false;
  end;
  fmodified := false;
end;

procedure TChannel.SaveToFile(fname:string);
begin
  if assigned(browser) then
    Browser.SaveHtml(fname)
  else
    fhtml.SaveToFile(fname);
end;

function TChannel.GetHtml: string;
begin
  result := fHtml.text;
end;

procedure TChannel.SetHtml(value:string);
begin
  fhtml.text := value;
end;

Procedure TChannel.GoEnd;
begin
  if (assigned(Browser))and(Ready) then
    Browser.GoEnd;
  application.ProcessMessages;
end;

Procedure TChannel.GoBegin;
begin
  if (assigned(Browser))and(Ready) then
    Browser.GoBegin;
end;

procedure TChannel.Refresh;
begin
  if (assigned(Browser))and(Ready) then
    Browser.Refresh;
  fmodified := False;
end;

procedure TChannel.Reload(toEnd:boolean);
var
  y: Integer;
begin
  if assigned(Browser)and(Ready) then
  begin
    y := Browser.ScrollPos;
    Browser.LoadFromString(fhtml.Text);
    Browser.ScrollPos := y;
    if toEnd then
      Browser.GoEnd;
  end;
  if assigned(Application.MainForm) then
    mainform.MySetFocus(mainform.memoin, true);
  fmodified := False;
end;

constructor TChannel.Create(Acontrol: TwinControl);
begin
  inherited Create;
  lastId := inttostr(GetTickCount);
  fhtml := TStringList.Create;
  fhtml.Text := NewHtml;
  if assigned(Acontrol) then
  begin
    TabSheet := TTabSheet.Create(Acontrol.parent);
    TabSheet.PageControl := TPageControl(Acontrol);
    Browser := TIcomViewer.Create(TabSheet);
  end;
end;

destructor TChannel.Destroy;
begin
    myFreeAndNil(Browser);
    myFreeAndNil(TabSheet);
    myFreeAndNil(fhtml);
end;

// поставим иконки каналов
Procedure TChannels.SetChannelIcons(icons_mode: integer);
var
  i, num: integer;
  chname: string;
begin
  for i := 0 to PageControl.PageCount - 1 do
  begin
    chname := trim(PageControl.Pages[i].caption);
    num := chname2index(chname);
    if (num >= 0) and (num <= 2) then
    begin
      if (not Channel[chname].Blink) and (PageControl.Pages[i].ImageIndex <> icons_mode * 4 + num) then
        PageControl.Pages[i].ImageIndex := icons_mode * 4 + num
    end
    else
    begin
      if (not Channel[chname].Blink) and (PageControl.Pages[i].ImageIndex <> icons_mode * 4 + 3) then
        PageControl.Pages[i].ImageIndex := icons_mode * 4 + 3;
    end;
  end;
end;

Procedure TChannels.StartBlink;
begin
  if not BlinkTimer.enabled then
    BlinkTimer.enabled := true;
end;

function TChannels.chname2index(ch: string): integer;
begin
  ch := trim(ch);
  if ch = green then
    result := 0
  else if ch = blue then
    result := 1
  else if ch = red then
    result := 2
  else
    result := 3;
end;

// мигаем иконками каналов
procedure TChannels.BlinkTimerTimer(Sender: TObject);
var
  i, num: integer;
  TS: TTabSheet;
  mig_exists: Boolean;
begin
  // не мигаем...
  if not Application.Mainform.Visible then
    exit;
  mig_exists := false;
  // мигалка
  for i := 0 to PageControl.PageCount - 1 do
  begin
    if Channel[PageControl.Pages[i].caption].Blink then
    begin
      mig_exists := true;
      TS := TTabSheet(PageControl.Pages[i]);
      num := chname2index(trim(TS.caption));
      // основные каналы
      if (trim(TS.caption) = green) or (trim(TS.caption) = blue) or (trim(TS.caption) = red) then
      begin
        if TS.ImageIndex = 12 then
          TS.ImageIndex := ChannelIcons * 4 + num
        else
          TS.ImageIndex := 12;
      end
      else // личные каналы
      begin
        if TS.ImageIndex < ChannelIcons * 4 + 3 then
          TS.ImageIndex := ChannelIcons * 4 + 3
        else
          TS.ImageIndex := ChannelIcons * 4 + 3 - 3;
      end;
    end;
  end;
  BlinkTimer.enabled := mig_exists;
end;

constructor TChannels.Create(Acontrol: TwinControl);
begin
  inherited Create;
  PageControl := TPageControl(Acontrol);
  FChannels := TStringlist.Create;
  BlinkTimer := TTimer.Create(self.PageControl);
  BlinkTimer.enabled := false;
  BlinkTimer.Interval := 750;
  BlinkTimer.ontimer := BlinkTimerTimer;
end;

destructor TChannels.Destroy;
begin
  myFreeAndNil(FChannels);
end;

Function TChannels.GetCount: integer;
begin
  result := FChannels.Count;
end;

function TChannels.Find(chname: string): integer;
begin
  result := GetId(chname);
end;

function TChannels.GetId(chname: string): integer;
var
  i: integer;
begin
  result := -1;
  chname := trim(chname);
  for i := 0 to FChannels.Count - 1 do
    if (ansiuppercase(TChannel(FChannels.objects[i]).Name) = ansiuppercase(chname)) then
    begin
      result := i;
      break;
    end;
end;
function TChannels.GetChannel(id: Integer): TChannel;
begin
  if (id >= 0) and (id < FChannels.Count) then
    result := TChannel(FChannels.objects[id])
  else
    raise Exception.Create('GetChannel: '+inttostr(id));
end;

function TChannels.GetChannel(chname: string): TChannel;
var
  id: integer;
begin
  id := GetId(chname);
  if (id >= 0) and (id < FChannels.Count) then
    result := TChannel(FChannels.objects[id])
  else
    raise Exception.Create('GetChannel: '+chname);
end;

procedure TChannels.SetChannel(chname: string; NewChannel: TChannel);
var
  id: integer;
begin
  id := GetId(chname);
  if (id >= 0) and (id < FChannels.Count) then
    FChannels.objects[id] := NewChannel;
end;

function TChannels.FindTab(TabName: string): integer;
var
  i, ex: integer;
begin
  ex := -1;
  for i := 0 to PageControl.PageCount - 1 do
  begin
    if (trim(PageControl.Pages[i].caption) = trim(TabName)) or (trim(PageControl.Pages[i].hint) = trim(TabName)) then
      ex := i;
  end;
  result := ex;
end;

procedure TChannels.Add(Acontrol: TwinControl; chname: string; Tag: integer);
var
  ch: TChannel;
begin
  chname := trim(chname);
  if assigned(Acontrol) then
    PageControl := TPageControl(Acontrol);
  ch := TChannel.Create(Acontrol);
  ch.Name := chname;
  ch.Tag := Tag;
  ch.Blink := false;
  if assigned(ch.TabSheet) then
  begin
    ch.TabSheet.Tag := Tag;
    ch.TabSheet.caption := chname + '       '; // добавим пробелы чтобы сдвинуть кнопку закрытия вправо
  end;
  FChannels.AddObject(chname, ch);
end;

procedure TChannels.Delete(chname: string);
var
  i: integer;
begin
  chname := trim(chname);
  for i := 0 to FChannels.Count - 1 do
    if (ansiuppercase(TChannel(FChannels.objects[i]).Name) = ansiuppercase(chname)) or
      (TChannel(FChannels.objects[i]).Name = chname) then
    begin
      FChannels.objects[i].Free;
      FChannels.Delete(i);
      break;
    end;
end;

procedure TChannels.Delete(index: integer);
begin
  if (index >= 0) and (index < FChannels.Count) then
  begin
    FChannels.objects[index].Free;
    FChannels.Delete(index);
  end;
end;

end.
