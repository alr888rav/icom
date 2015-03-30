unit main;

{$I ver.inc }

interface

uses
  Controls,
  Windows, Messages, SysUtils, Classes, Graphics, Forms,
  Menus, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  ClipBrd, DBCtrls, ImgList, ShellApi, SyncObjs, jpeg,
  AppEvnts, ExtDlgs,
  types, variants, strutils,
  RVEdit, RVStyle, RVItem, RVTypes, RVScroll, RVLinear, RVDragDrop, CRVData, RVRVData,
  ActiveX, api, RichView,
  Grids, Dialogs,
  JvAnimatedImage, JvGIFCtrl,
  userslist, JvExStdCtrls, JvCombobox, JvColorCombo, mplayer,
  pngimage,
  icomView, language, icomNet, icomplugins, setting, icomchannels, icomuserbox,
  psAPI, JvComponentBase,
  JvXPCore, JvXPButtons,
  Vcl.OleCtrls, SHDocVw
  ,myPageControl;

const
  WM_POWERBROADCAST = $0218;
  PBT_APMRESUMESUSPEND = $0007;
  PBT_APMRESUMESTANDBY = $0008;
  PBT_APMRESUMEAUTOMATIC = $0012;
  WM_AFTER_CREATE = WM_USER + 301;
  WM_IN = WM_USER + 302;
  WM_OUT = WM_USER + 303;
  WM_CLOSE_CHANNEL = WM_USER + 304;

type
  TmainForm = class(TForm, IPluginInterface)
    Panel_user_box: TPanel;
    MainPanel: TPanel;
    StatusMenu1: TPopupMenu;
    ExitMenu: TMenuItem;
    PageControl1: TPageControl;
    OpenDialog1: TOpenDialog;
    Timer1sek: TTimer;
    PopupUserlist: TPopupMenu;
    ApplicationEvents1: TApplicationEvents;
    ChannelList: TImageList;
    StatusList_: TImageList;
    Splitter1: TSplitter;
    ClearallMenu3: TPopupMenu;
    ClearAll: TMenuItem;
    trafmenu: TPopupMenu;
    CutMenu: TMenuItem;
    PasteMenu: TMenuItem;
    N12: TMenuItem;
    memoinmenu: TPopupMenu;
    MemoinCopy: TMenuItem;
    MemoinCut: TMenuItem;
    MemoinPasteMenu: TMenuItem;
    RestartMenu: TMenuItem;
    CopyTextMenu: TMenuItem;
    N19: TMenuItem;
    ClearTrafMenu: TMenuItem;
    Sendfl: TMenuItem;
    Splitter2: TSplitter;
    N21: TMenuItem;
    UserRefr: TMenuItem;
    SavePictMenu: TMenuItem;
    SavePictureDialog1: TSavePictureDialog;
    CopyPictMenu: TMenuItem;
    iconList: TImageList;
    ChPopupMenu: TPopupMenu;
    ColorDialog1: TColorDialog;
    MemoinPanel: TPanel;
    N6: TMenuItem;
    PersonalList: TImageList;
    AddUserMenu: TPopupMenu;
    RefreshMenu: TMenuItem;
    ClearAllMenu_wopersonal: TMenuItem;
    N1: TMenuItem;
    BlockUserMnu: TMenuItem;
    DelUserMnu: TMenuItem;
    NewUserMnu: TMenuItem;
    N3: TMenuItem;
    MemoinClear: TMenuItem;
    OnoffusersMenu: TMenuItem;
    N7: TMenuItem;
    ScrollMenu: TMenuItem;
    MenuList: TImageList;
    N2: TMenuItem;
    N4: TMenuItem;
    PersMenu: TMenuItem;
    N5: TMenuItem;
    ButtonList2: TImageList;
    OpenPictureDialog1: TOpenPictureDialog;
    DefaultAvatar: TImage;
    PanelFont: TPanel;
    WideFontBtn: TSpeedButton;
    ItalicFontBtn: TSpeedButton;
    btnUnderline: TSpeedButton;
    btnStrike: TSpeedButton;
    PanelFontColor: TSpeedButton;
    FontComboBox1: TJvFontComboBox;
    ComboBox_size: TJvComboBox;
    PanelTools1: TPanel;
    StatusBar1: TPanel;
    PluginPanel: TPanel;
    LogPanel: TPanel;
    InOutPanel: TImage;
    MenuPanel: TPanel;
    MenuButton: TSpeedButton;
    RightPanel: TPanel;
    procedure FreeRes;
    function SetUserStatus(FromIP: string; sl: TstringList): boolean;
    procedure memoinDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure memoinDropFiles(Sender: TCustomRichViewEdit; Files: TStrings; var FileAction: TRVDropFileAction;
      var DoDefault: boolean);
    procedure memoinOleDrop(Sender: TCustomRichView; const DataObject: IDataObject; Shift: TShiftState; X, Y: Integer;
      PossibleDropEffects: TRVOleDropEffects; var DropEffect: TRVOleDropEffect; var DoDefault: boolean);
    Procedure MigIcon(mode: Integer);
    procedure InsertFileImage(file_name: string);
    function InsertFileAsIcon(file_name: string): boolean;
    function InsertFromBrowser(url: string): boolean;
    function LastInput: DWord;
    procedure in_label(mode: boolean);
    procedure out_label(mode: boolean);
    function show_on_off: boolean;
    procedure NewLog(msg: string);
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SenDBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FontComboBox1Change(Sender: TObject);
    procedure memoinKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure ExitMenuClick(Sender: TObject);
    procedure SmileBtn3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure AllBtnClick(Sender: TObject);
    procedure Timer1sekTimer(Sender: TObject);
    procedure FileBtnClick(Sender: TObject);
    procedure SetupBtnClick(Sender: TObject);
    procedure PluginBtnClick(Sender: TObject);
    procedure ComboBox_sizeChange(Sender: TObject);
    procedure HistoryButton1Click(Sender: TObject);
    procedure memoinMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure ClearAllClick(Sender: TObject);
    procedure CutMenuClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure memoinStyleConversion(Sender: TCustomRichViewEdit; StyleNo, UserData: Integer; AppliedToText: boolean;
      var NewStyleNo: Integer);
    procedure MemoinCopyClick(Sender: TObject);
    procedure MemoinCutClick(Sender: TObject);
    procedure MemoinPasteMenuClick(Sender: TObject);
    procedure RestartMenuClick(Sender: TObject);
    procedure CopyTextMenuClick(Sender: TObject);
    procedure memoinParaStyleConversion(Sender: TCustomRichViewEdit; StyleNo, UserData: Integer; AppliedToText: boolean;
      var NewStyleNo: Integer);
    procedure WideFontBtnClick(Sender: TObject);
    procedure memoinCurTextStyleChanged(Sender: TObject);
    procedure ClearTrafMenuClick(Sender: TObject);
    procedure btnStrikeClick(Sender: TObject);
    procedure ApplicationEvents1Message(var msg: tagMSG; var Handled: boolean);
    procedure TrayIconClick(Sender: TObject);
    procedure SendflClick(Sender: TObject);
    procedure ExBtnClick(Sender: TObject);
    procedure UserRefrClick(Sender: TObject);
    procedure SavePictMenuClick(Sender: TObject);
    procedure trafmenuPopup(Sender: TObject);
    procedure PageControl1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: boolean);
    procedure memoinSaveImage2(Sender: TCustomRichView; Graphic: TGraphic; SaveFormat: TRVSaveFormat;
      const Path, ImagePrefix: String; var ImageSaveNo: Integer; var Location: String; var DoDefault: boolean);
    procedure HTML1BeforeNavigate2(ASender: TObject;
          const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
          Headers: OleVariant; var Cancel: WordBool);
    procedure CopyPictMenuClick(Sender: TObject);
    procedure PanelTools1Resize(Sender: TObject);
    function NewTab(TabName: string; ForceSwitch: boolean; NewTag: Integer): Integer;
    procedure chMenuClick(Sender: TObject);
    procedure Edit_snapClick(Sender: TObject);
    procedure Edit_snapKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Aboutclick(Sender: TObject);
    procedure memoinChange(Sender: TObject);
    procedure memoinPaste(Sender: TCustomRichViewEdit; var DoDefault: boolean);
    procedure AddUserMenuClick(Sender: TObject);
    procedure memoinClick(Sender: TObject);
    procedure bLangClick(Sender: TObject);
    procedure RefreshMenuClick(Sender: TObject);
    procedure PageControl1DrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: boolean);
    procedure ClearAllMenu_wopersonalClick(Sender: TObject);
    procedure BlockUserMnuClick(Sender: TObject);
    procedure DelUserMnuClick(Sender: TObject);
    procedure NewUserMnuClick(Sender: TObject);
    procedure MemoinClearClick(Sender: TObject);
    procedure OnoffusersMenuClick(Sender: TObject);
    procedure ScrollMenuClick(Sender: TObject);
    procedure FontSetupButtonClick(Sender: TObject);
    procedure PopupUserlistPopup(Sender: TObject);
    procedure SmileBtn1Click(Sender: TObject);
    procedure SmileBtn2Click(Sender: TObject);
    procedure TrayIconStartup(Sender: TObject; var ShowMainForm: boolean);
    procedure HideTaskBarIcon;
    procedure PanelFontColorClick(Sender: TObject);
    procedure CitBtnClick(Sender: TObject);
    procedure PersMenuClick(Sender: TObject);
    procedure IcomButtonClick(Sender: TObject);
    procedure WebBrowser1NavigateError(ASender: TObject; const pDisp: IDispatch;
      const URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
    procedure WebBrowser1DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure MainMenuClick(Sender: TObject);
    procedure FontButtonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TabsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MenuButtonClick(Sender: TObject);
  private
    mainmenu: TPopupMenu;
    RVStyle2: TRVStyle;
    procedure WMQueryEndSession(var msg: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure WMPowerBroadcast(var msg: TMessage); message WM_POWERBROADCAST;
    procedure WMCloseChannel(var msg: TMessage); message WM_CLOSE_CHANNEL;
    Procedure ChangeIcon(mode: Integer);
    Procedure PageRefresh(change: boolean = false);
    procedure ActivatePage;
    procedure WmAfterCreate(var msg: TMessage); message WM_AFTER_CREATE;
    procedure WmIn(var msg: TMessage); message WM_IN;
    procedure WmOut(var msg: TMessage); message WM_OUT;
    Procedure SetMyStatus;
    Function ShowHPanel: TPanel;
    procedure UnknownAddClick(user2add: string; Auto:boolean=false);
    Procedure SelfMsg(ChName: string; komu: string; msg: string);
    Function HtmlIn: string;
    Procedure NewTraf(limit_hours: Integer);
    procedure setPanelFont;
    Procedure LoadButtons;
    Procedure SetOwnFont;
    Procedure DrawFontSetupButton(fi: TFontInfo);
    procedure IcomNavigate(ASender: TObject; url: string; var Cancel: wordbool);
    procedure IcomSenD(files: TStringList);
    Procedure SizeIcom;
    Procedure PosIcom;
    procedure restart2;
    procedure gotoend(var memo: TRichViewEdit);
    function TestMsgLang(txt:string):boolean;
    function TestReadOnly:boolean;
    function TestChannel:boolean;
    function TestAndSelectPersonal:boolean;
    procedure TestAvatar;
    procedure TestOffline;
    function Memoin2Html:string;
    procedure ClearTemp;
    procedure ClearCacheHTML;
    procedure ClearCacheImages(days: Integer=1);
    Procedure AutoAddUnknown;
    procedure BalloonClick(Sender: TObject);
    procedure ShowIcom(Sender: TObject);
    procedure NewChannel;
    procedure ClearOnExit;
    procedure NextTab;
    procedure PrevTab;
    procedure CloseForms;
  public
    ClearBtn: TspeedButton;
    SendBtn: TspeedButton;
    FileBtn: TspeedButton;
    CitBtn: TspeedButton;
    FontSetupButton: TspeedButton;
    SmileBtn1: TspeedButton;
    SmileBtn2: TspeedButton;
    SmileBtn3: TspeedButton;
    TrayIcon: TTrayIcon;
    memoin: TRichViewEdit;

    function getvar(name: widestring): variant; stdcall;
    function plugin_button(plugin_name: WideString): WideString; stdcall;
    function plugin_panel(plugin_name: widestring): widestring; stdcall;
    function create_control(plugin_name, type_name, parent_name: widestring): widestring; stdcall;
    procedure SetCaption(plugin_name, control_name, text: widestring); stdcall;
    procedure SetText(plugin_name, control_name, text: widestring); stdcall;
    procedure SetAlign(plugin_name, control_name: widestring; Align: Talign); stdcall;
    procedure SetWindow(plugin_name, control_name: widestring; left, top, width, Height: Integer); stdcall;
    procedure SetVisible(plugin_name, control_name: widestring; visible: boolean); stdcall;
    procedure SetOnclick(plugin_name, control_name: WideString; proc: pointer); stdcall;
    procedure InsertText(text: widestring); stdcall;
    Procedure InsertImage(image: pointer); stdcall;
    Procedure SetGlyphStream(plugin_name, control_name: widestring; image: pointer); stdcall;
    Procedure SetGlyphFile(plugin_name, control_name, image: WideString); stdcall;
    function GetFreePos: Integer; stdcall;
    Procedure SetFreePos(ps: Integer); stdcall;
    procedure SetChecked(plugin_name, control_name: widestring; check: boolean); stdcall;
    function GetText(plugin_name, control_name: widestring): widestring; stdcall;
    procedure SetFlat(plugin_name, control_name: widestring; flats: boolean); stdcall;
    function GetChecked(plugin_name, control_name: widestring): boolean; stdcall;
    procedure SetOnKeyDown(plugin_name, control_name: widestring; proc: pointer); stdcall;
    procedure SetHint(plugin_name, control_name, hint_text: widestring); stdcall;
    function GetApiVer: widestring; stdcall;
    function Download(url: widestring): widestring; stdcall;
    function DownloadLocal(url: widestring): widestring; stdcall;
    procedure ShowPage(tab_name, file_name: widestring); stdcall;
    function GetInput: widestring; stdcall;
    procedure SetVar(name: widestring; value: variant); stdcall;
    procedure addToPopup(plugin_name, control_name, caption: widestring; proc: pointer); stdcall;
    function GetPluginHeight: Integer; stdcall;
    procedure SetWindowHeight(plugin_name, control_name: widestring; Height: Integer); stdcall;
    procedure SetWindowWidth(plugin_name, control_name: widestring; width: Integer); stdcall;
    function GetUserList: widestring; stdcall;
    function GetPort: integer; stdcall;
    function GetUserStatus(ip:widestring):integer; stdcall;
    function empty1: boolean; stdcall;
    Procedure SendRAW(package: widestring); stdcall;
    function FindPlugin(name:widestring):boolean; stdcall;
    Procedure TCPSend(ip, package:widestring); stdcall;
    function GetIP: widestring; stdcall;
    procedure SendFileV2(ip, FileName:widestring); stdcall;
    procedure StartHttp; stdcall;
    function GetUserPlugins(ip:widestring):widestring; stdcall;
    procedure icomlog(msg: WideString); stdcall;
    function GetSelectedUser:widestring; stdcall;
    procedure addSimpleMessage(msg:widestring); stdcall;
    ///
    procedure CreateMainMenu(parent:TObject);
    Function CheckFreeSpace(drive: string; minimum: Integer = 5; showm: boolean = false): boolean;
    Procedure showballon(head, text: string; show_time: Integer);
    Procedure MemoInsertPicture(pic: TGraphic);
    Function GetCurTextStyleNo: Integer;
    Procedure SetCurTextStyleNo(style: Integer);
    Procedure MemoInsertText(txt: string);
    Procedure ApplySetup;
    Procedure MySetFocus(Sender: TWinControl; force:boolean=false);
    procedure DelFonts(Obj: TJvFontComboBox);
    procedure SaveTraf;
   protected
  end;

var
  mainForm: TmainForm;
  // список неизвестных пользователей (нет в списке)
  unknown_user: TstringList;
  // список пользователей
  user_list: TUsers;
  // список пользователй отображение
  user_box:TUserBox;
  // настройки
  Setup: TSetupClass;
  // плагины
  Plugins: TPlugins;
  // версия икома
  ver: string;
  // версия виндовс
  winver: string;
  winver_num: string;
  // список плагинов
  PluginList: TstringList;
  // локализация
  lang: TLangClass;
  // сеть
  NetWork: TNetWork;
  // Каналы икома
  Channels: TChannels;
  // минимальная высота строки списка пользователей
  hmin: Integer;
  // размер аватарки
  minisize: Integer;
  // язык пароля
  psw_ra: Array [0 .. $FFF] of char;
  psw_lang: hkl;
  // тек язык
  icom_ra: Array [0 .. $FFF] of char;
  icom_lang: hkl;
  // темы включены
  ThemesActive:boolean;
  // посылать/не посылать статус
  flip: Boolean;
  // список пользователей в процессе обновления
  inUpdate: boolean;
  // время старта
  start_time: Tdatetime;
  // флаг повторного запуска
  one_copy: boolean;

 function green:string;
 function blue:string;
 function red:string;

implementation

uses smile,
  htmllib, Commonlib,
  vers, about, icomClipboard, wtsapi,
  UPageControl, newuser, Global, ulog, api_works, desktop, tray,
  extentions, sform, wbpopup, reslib;

{$R *.DFM}

const
  TEXT_BOLD = 1;
  TEXT_ITALIC = 2;
  TEXT_UNDERLINE = 3;
  TEXT_STRIKE = -4;
  TEXT_APPLYFONTNAME = 4;
  TEXT_APPLYFONT = 5;
  TEXT_APPLYFONTSIZE = 6;
  TEXT_COLOR = 7;
  TEXT_BACKCOLOR = 8;

var
  // отправляемые из собщения файлы(картинки)
  sendfiles: TstringList;
  // поток для onimagerequest
  mstream: TMemoryStream;
  // флаг запущенного
  CheckEvent: Tevent;
  // рабочий стол заблокирован
  Locked: boolean;
  // время последней активности
  last_time: Tdatetime;
  // всего ошибок с начала работы
  err_count: Integer;
  // 1 секунда
  one_sek: double;
  // 1 час
  one_hour: double;
  // время простоя
  idle_time: Integer;
  // последний вывод в лог(статусбар)
  Last_log: Tdatetime;
  // вслывающее сообщение в трее
  msg: TTrayMessage;
  // для блокировки спама
  last_out_message: string;
  // надо спросить пароль
  need_psw: boolean;
  // время последнего сообщения
  last_send: Tdatetime;
  // выходить из программы или скрыть
  NeedExit: boolean;
  //
  lastDrawed: integer;

function green:string;
begin
  Result := lang.Get('green');
end;
function blue:string;
begin
  Result := lang.Get('blue');
end;
function red:string;
begin
  Result := lang.Get('red');
end;

procedure TmainForm.FontButtonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Shift = [ssRight]) then
    SetOwnFont;
end;

// закрыть канал
procedure TmainForm.WMCloseChannel(var msg: TMessage);
var
  TabIndex: integer;
begin
  try
    TabIndex := msg.WParam;
    if (Setup.confirmclosepage) and (not AnsiSameText(trim(PageControl1.Pages[TabIndex].caption), 'HELP')) then
      if messagedlg(lang.get('close') + ' ' + trim(PageControl1.Pages[TabIndex].caption) + '?', mtconfirmation, [mbYes, mbNo], 0) <> mrYes then
        exit;
    Channels.Channel[PageControl1.Pages[TabIndex].caption].SaveToFile(htmldir+trim(PageControl1.Pages[TabIndex].caption)+'.html');
    Channels.Channel[PageControl1.Pages[TabIndex].caption].Blink := false;
    Channels.delete(PageControl1.Pages[TabIndex].caption);
    PageControl1.ActivePageIndex := 0;
    PageRefresh(true);
    MigIcon(0);
  except
    on E: Exception do
      log('pageclose ' + E.Message);
  end;
end;


// индикатор приема
procedure TmainForm.WmIn(var msg: TMessage);
var
  bgColor: TColor;
begin
  bgColor := PluginPanel.Color;
  if msg.WParam = 1 then
  begin
    InOutPanel.Canvas.Pen.Color := bgColor;
    InOutPanel.Canvas.Brush.Color := bgColor;
    InOutPanel.Canvas.FillRect(InOutPanel.ClientRect);
    InOutPanel.Canvas.Brush.Color := clGreen;
    InOutPanel.Canvas.Rectangle(30,4,42,16);
  end
  else
  begin
    InOutPanel.Canvas.Pen.Color := bgColor;
    InOutPanel.Canvas.Brush.Color := bgColor;
    InOutPanel.Canvas.FillRect(InOutPanel.ClientRect);
  end;
  Application.ProcessMessages;
end;

// индикатор отправки
procedure TmainForm.WmOut(var msg: TMessage);
var
  bgColor: TColor;
begin
  bgColor := PluginPanel.Color;
  if msg.WParam = 1 then
  begin
    InOutPanel.Canvas.Pen.Color := bgColor;
    InOutPanel.Canvas.Brush.Color := bgColor;
    InOutPanel.Canvas.FillRect(InOutPanel.ClientRect);
    InOutPanel.Canvas.Brush.Color := clred;
    InOutPanel.Canvas.Rectangle(50,4,62,16);
  end
  else
  begin
    InOutPanel.Canvas.Pen.Color := bgColor;
    InOutPanel.Canvas.Brush.Color := bgColor;
    InOutPanel.Canvas.FillRect(InOutPanel.ClientRect);
  end;
  Application.ProcessMessages;
end;

// загрузим плагины (надо выполнять когда application.mainform уже присвоено)
procedure TmainForm.WmAfterCreate(var msg: TMessage);
begin
  try
    Plugins := TPlugins.Create;
    Plugins.LoadPlugins;
    self.refresh;
  except
    on E: Exception do
      log('Plugins - ' + E.Message);
  end;
end;

Procedure TmainForm.MemoInsertText(txt: string);
begin
  memoin.CurTextStyleNo := 0; // черный текст
  memoin.InsertText(txt, false);
  memoin.reformat;
end;

Procedure TmainForm.SetCurTextStyleNo(style: Integer);
begin
  memoin.CurTextStyleNo := style;
end;

Function TmainForm.GetCurTextStyleNo: Integer;
begin
  result := memoin.CurTextStyleNo;
end;

Procedure TmainForm.MemoInsertPicture(pic: TGraphic);
begin
  memoin.InsertPicture('', pic, rvvaBaseline);
end;

procedure TmainForm.setPanelFont;
begin
  WideFontBtn.Flat := true;
  ItalicFontBtn.Flat := true;
  btnUnderline.Flat := true;
  btnStrike.Flat := true;
  PanelFontColor.Flat := true;
end;

Procedure TmainForm.ApplySetup;
var
  i: Integer;
  fi: TFontInfo;
begin
  LoadButtons;
  if Setup.checktraf then
    NewTraf(Setup.traflimit);
  ClearCacheImages;

  // цвета
  PanelTools1.Color := clWindow;
  PanelFont.Color := clWindow;
  MenuPanel.Color := clWindow;
  PluginPanel.Color := clWindow;
  LogPanel.Color := clWindow;
  in_label(false);
  MenuButton.Flat := ThemesActive;

  // иконки для трея
  TrayIcon.icons := iconList;
  // панель кнопок
  setPanelFont;
  hmin := 24;
  minisize := 32;

  PageControl1.MultiLine := Setup.MultirowPages;
  PageControl1.TabHeight := 30;
  MenuPanel.Height := 30+4;  // +3D border?
  MenuPanel.BevelEdges := [];
  RightPanel.Width := ScrollBar;

  PanelTools1Resize(nil);
  fi := TFontInfo.Create(nil);
  fi.FontName := Setup.myFont.name;
  fi.color := Setup.myFont.color;
  fi.style := Setup.myFont.style;
  fi.Size := Setup.myFont.Size;
  DrawFontSetupButton(fi);
  fi.Free;

  // запомненные размеры формы
  if TwindowState(Setup.State) = wsmaximized then
  begin
    self.WindowState := wsmaximized;
    self.Repaint;
  end
  else
  begin
    self.top := Setup.myTop;
    self.left := Setup.MyLeft;
    self.width := Setup.MyWidth;
    self.Height := Setup.MyHeight;
  end;
  MemoinPanel.Height := Setup.inHeight;

  Panel_user_box.width := Setup.MyWidth - Setup.TrafWidth - (2 * WindowBorder);

  memoin.BackgroundStyle := bsNoBitmap;
  memoin.color := Setup.Wincolor;

  for i := 0 to ComboBox_size.Items.Count - 1 do
    if Setup.myFont.Size = strtoint(ComboBox_size.Items[i]) then
    begin
      ComboBox_size.ItemIndex := i;
      break;
    end;

  WideFontBtn.AllowAllUp := true;
  ItalicFontBtn.AllowAllUp := true;
  if Setup.Bstyle then
  begin
    Setup.myFont.style := [fsBold];
    WideFontBtn.down := true;
  end
  else
  begin
    Setup.myFont.style := [];
    WideFontBtn.down := false;
  end;
  if Setup.Istyle then
  begin
    Setup.myFont.style := Setup.myFont.style + [fsItalic];
    ItalicFontBtn.down := true;
  end
  else
  begin
    ItalicFontBtn.down := false;
  end;
  for i := 0 to FontComboBox1.Items.Count - 1 do
  begin
    if FontComboBox1.Items[i] = Setup.myFont.name then
      FontComboBox1.ItemIndex := i;
  end;

  WideFontBtn.Flat := flt;
  ItalicFontBtn.Flat := flt;
  btnUnderline.Flat := flt;
  btnStrike.Flat := flt;
  //
  PageControl1.ShowHint := false;
  //
  Channels.ChannelIcons := Setup.Channelicons;
  Channels.SetChannelIcons(Setup.Channelicons);
  //
  SetOwnFont;
  // стартовый язык RU
  case Setup.Startlang of
    1:
      LoadKeyboardLayout('00000409', KLF_ACTIVATE); // англ
    2:
      LoadKeyboardLayout('00000419', KLF_ACTIVATE); // русский
    3:
      LoadKeyboardLayout('00000422', KLF_ACTIVATE); // укр
  end;
end;

Procedure TmainForm.showballon(head, text: string; show_time: Integer);
begin
  if text > '' then
  begin
    myFreeAndNil(msg);
    msg := TTrayMessage.Create(TrayIcon);
    try
      if head>'' then
        msg.Title := head
      else
        msg.Title := lang.Get('ititle');
      msg.text := text;
      msg.TimeOut := show_time;
      msg.Show;
    except
      on e: exception do
      log('showballon: '+e.Message);
    end;
  end;
end;

// переключим туда-сюда чтобы заработало отображение (баг ownerdraw)
Procedure TmainForm.PageRefresh(change: boolean = false);
var
  old: Integer;
begin
  if change then
  begin
    old := PageControl1.ActivePageIndex;
    PageControl1.ActivePageIndex := -1;
    PageControl1.ActivePageIndex := old;
  end;
  PageControl1.Repaint;
end;

// возможно будут запоминать вход-выход
procedure TmainForm.NewLog(msg: string);
begin
  LogPanel.Caption := msg;
  StatusBar1.Refresh;
  Last_log := now;
end;

procedure TmainForm.DelFonts(Obj: TJvFontComboBox);
var
  i: Integer;
  ss: string;
begin
  i := 0;
  while i <= Obj.Items.Count - 1 do
  begin
    ss := Obj.Items[i];
    if (Pos('@', ss) <> 0) or (Pos(' CE', ss) <> 0) or (Pos(' Greek', ss) <> 0) or (Pos(' CYR', ss) <> 0) or
      (Pos(' TUR', ss) <> 0) or (Pos(' Baltic', ss) <> 0) or (Pos(' Arabic', ss) <> 0) or (Pos('UPC', ss) <> 0) or
      (Pos('LiU', ss) <> 0) then
    begin
      Obj.Items.delete(i);
      i := i - 1;
    end;
    i := i + 1;
  end;
end;

// не показываем откл/подкл после 1мин рестарта
function TmainForm.show_on_off: boolean;
begin
  if now - start_time < 60 * one_sek then
    result := false
  else
    result := true;
end;

// вкл/выкл индикаторы
procedure TmainForm.in_label(mode: boolean);
begin
  if mode then
    SendMessage(mainform.Handle, WM_IN, 1, 0)
  else
    SendMessage(mainform.Handle, WM_IN, 0, 0);
end;

procedure TmainForm.out_label(mode: boolean);
begin
  if mode then
    SendMessage(mainform.Handle, WM_OUT, 1, 0)
  else
    SendMessage(mainform.Handle, WM_OUT, 0, 0);
end;


Function TmainForm.CheckFreeSpace(drive: string; minimum: Integer = 5; showm: boolean = false): boolean;
var
  d: byte;
const
  alpha = 'ABCDEFGHJIKLMNOPQRSTUVWZYZ';
begin
  result := true;
  d := Pos(drive[1], alpha);
  if diskFree(d) / 1024 / 1024 < minimum then
  begin
    if showm then
    begin
      if (not isfullscreen) then
      begin
        showballon(lang.get('att'), lang.get('enough') + ' ' + drive[1], 5);
        if (Setup.soundon) and (Setup.s5on) then
          mysound(Setup.sndin);
      end;
      result := false;
    end
  end
end;

Procedure TmainForm.MySetFocus(Sender: TWinControl; force:boolean=false);
begin
  try
    if (GetForegroundWindow=mainform.handle) and IsWindowVisible(Application.Handle) and (application.Active) and (self.visible) and (Sender.Showing) and (Sender.visible) and (Sender.Enabled) then
    begin
      if force then
        ActiveControl:=nil; // забрать фокус у IE
      Sender.setfocus;
    end;
  except
  end;
end;

// сколько мсек находится в idle
function TmainForm.LastInput: DWord;
var
  LInput: TLastInputInfo;
begin
  LInput.cbSize := SizeOf(TLastInputInfo);
  GetLastInputInfo(LInput);
  result := GetTickCount - LInput.dwTime;
end;

// мигание иконки
procedure TmainForm.MenuButtonClick(Sender: TObject);
begin
  CreateMainMenu(sender);
end;

Procedure TmainForm.MigIcon(mode: Integer);
begin
  try
    if NeedExit then
      exit;
    // вкл
    if mode = 1 then
    begin
      if not Setup.stoptray then
        TrayIcon.Animate := true;
    end
    else
    begin // выкл
      TrayIcon.Animate := false;
      ChangeIcon(0);
      TrayIcon.icons := iconList;
      // выкл миг активного канала
      if assigned(PageControl1.activepage) then
        Channels.Channel[PageControl1.activepage.caption].Blink := false;
      // восст иконку канала
      Channels.SetChannelIcons(Setup.Channelicons);
    end;
  except
    on E: Exception do
      log('MigIcon: ' + E.Message);
  end;
end;

procedure TmainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

// свое состояние
Procedure TmainForm.SetMyStatus;
begin
  user_list[Setup.Myip].time := now;
  user_list[Setup.Myip].winver := winver;
  user_list[Setup.Myip].oname := Setup.Myname;
  user_list[Setup.Myip].idletime := LastInput div 1000;
  user_list[Setup.Myip].time := now;
  user_list[Setup.Myip].ver := vers.delbuild(ver);
  user_list[Setup.Myip].winver := winver;
  user_list[Setup.Myip].idletime := LastInput div 1000;
  if assigned(Plugins) then
    user_list[Setup.myIP].plugins := plugins.PluginsList;
end;

// Установить статус для IP
function TmainForm.SetUserStatus(FromIP: string; sl: TstringList): boolean;
var
  i: Integer;
  st2: Integer;
  todayYear, todayMonth, todayDay: Word;
  msg: string;
begin
  result := false;
  try
    st2 := toint(getsl(sl, 'STATUS'));
    if Assigned(user_list) then
    begin
      for i := 0 to user_list.Count - 1 do
      begin
        DecodeDate(now, todayYear, todayMonth, todayDay);
        if user_list[i].ip = FromIP then
        begin
          user_list[i].male := toint(getsl(sl, 'MALE'));
          user_list[i].dr := getsl(sl, 'DR');
          user_list[i].time := now;
          user_list[i].ver := getsl(sl, 'VER');
          user_list[i].winver := getsl(sl, 'WINVER');
          user_list[i].ex_status := URLdecode(getsl(sl, 'EXSTATUS'));
          user_list[i].oname := URLdecode(getsl(sl, 'NICKNAME'));
          user_list[i].idletime := toint(getsl(sl, 'LASTINPUT'));
          user_list[i].Channels := URLdecode(getsl(sl, 'CHLIST'));
          user_list[i].file_protocol := toint(getsl(sl, 'FILE_VER'));
          user_list[i].plugins := getsl(sl, 'PLUGINS');
          if Setup.setnick then
            user_list[i].name := user_list[i].oname;
          //
          if user_list[i].status = st2 then
          begin
            result := false;
          end
          else
          begin // была смена статуса
            if (user_list[i].status = OFFLINE) and (st2 <> OFFLINE) then
            begin
              if (not NetWork.TestLocalIP(FromIP)) and (user_list[i].dr > '') and
                (todayDay = toint(copy(user_list[i].dr, 1, 2))) and (todayMonth = toint(copy(user_list[i].dr, 3, 2))) then
                Channels.Channel[lang.Get('green')].AddSysText('', lang.Get('green'), timetostr(time) + ' ' + lang.get('birthday') + ' ' +
                  user_list[i].name + '!', 'Red');
              msg := timetostr(time) + ' ' + lang.get('user_in'+inttostr(user_list[i].male)) + ' [' + user_list[i].name + ']';
              if show_on_off then
                NewLog(msg);
              if (Setup.trayonoff) and (show_on_off) then
              begin
                showballon('', msg, 3);
                if (Setup.soundon) and (Setup.s1on) then
                  mysound(Setup.sndonline);
              end;
              Log(msg);
            end;
            result := true;
          end;
          user_list[i].status := st2; // новый статус
          break;
        end;
      end;
    end;
  except
    on E: Exception do
      log('Setstatus - ' + E.Message);
  end;
end;


// удалим старый трафик
Procedure TmainForm.NewTraf(limit_hours: Integer);
var
  d1: Tdatetime;
  i: Integer;
  mg: boolean;
  ChName: string;
  sr: TsearchRec;
  Res: Integer;
begin
  try
    if HTMLdir='' then
       Exit;
    // почистим старые html
    deletefile(htmldir + lang.Get('update_page') + '.html');
    begin
      Res := findFirst(htmldir + '*.html', faAnyFile, sr);
      while Res = 0 do
      begin
        d1 := filedatetodatetime(sr.time);
        if (Setup.checktraf) and (now - d1 > limit_hours * one_hour) then
        begin // устарел
          deletefile(htmldir + sr.name);
        end;
        Res := FindNext(sr);
      end;
      FindClose(sr);
    end;
    //
    for i := 0 to PageControl1.PageCount - 1 do
    begin
      if (PageControl1.Pages[i].tag >= 0) then
      begin
        ChName := trim(PageControl1.Pages[i].caption);
        if now - Channels.Channel[ChName].LastUpdate > limit_hours * one_hour then
        begin
          Channels.Channel[ChName].Clear;
          Channels.Channel[ChName].Blink := false;
          Channels.SetChannelIcons(Setup.Channelicons);
        end;
      end;
    end;
    mg := false;
    for i := 0 to PageControl1.PageCount - 1 do
      mg := mg or Channels.Channel[PageControl1.Pages[i].caption].Blink;
    if not mg then
      MigIcon(0);
  except
    on E: Exception do
      log('newtraf - ' + E.Message);
  end;
end;

Procedure TmainForm.DrawFontSetupButton(fi: TFontInfo);
begin
  if not assigned(FontSetupButton) then
    exit;
  FontSetupButton.font.color := fi.color;
  FontSetupButton.font.name := fi.FontName;
  FontSetupButton.font.style := fi.style;
  FontSetupButton.font.Size := fi.Size;
  FontSetupButton.Refresh;
end;

procedure TmainForm.TrayIconStartup(Sender: TObject; var ShowMainForm: boolean);
begin
  ShowMainForm := false;
end;

{
procedure TMainForm.Rmenu(right:boolean);
var
   mii: TMenuItemInfo;
   MainMenu: hMenu;
   Buffer: array[0..79] of Char;
begin
   MainMenu := Self.Menu.Handle;

   mii.cbSize := SizeOf(mii) ;
   mii.fMask := MIIM_TYPE;
   mii.dwTypeData := Buffer;
   mii.cch := SizeOf(Buffer) ;
   GetMenuItemInfo(MainMenu, IcomMenu.Command, false, mii) ;

   if right then
     mii.fType := mii.fType or MFT_RIGHTJUSTIFY
   else
     mii.fType := MFT_STRING;
   SetMenuItemInfo(MainMenu, IcomMenu.Command, false, mii) ;
end;
}

procedure TmainForm.FormCreate(Sender: TObject);
const
  NOTIFY_FOR_THIS_SESSION = 0;
  KLF_SETFORPROCESS = $0000010;
var
  i: integer;
begin
  self.scaled := false;
  self.doublebuffered := false;
  if not IsSmallFonts then
    UpdateFonts;
  ThemesActive := isThemesActive;
  // поле ввода
  RVStyle2 := TRVStyle.Create(mainForm);
  RVStyle2.TextStyles.AddFont('Arial', 10, clWindowText, clNone, []);
  RVStyle2.TextStyles.AddFont('Arial', 10, clred, clNone, []);
  RVStyle2.TextStyles.AddFont('Arial', 10, clBlue, clNone, []);
  //
  memoin := TRichViewEdit.Create(MemoinPanel);
  memoin.Name := 'memoin';
  memoin.Parent := MemoinPanel;
  memoin.Align := alClient;
  memoin.OnChange := memoinChange;
  memoin.OnClick := memoinClick;
  memoin.OnCurTextStyleChanged := memoinCurTextStyleChanged;
  memoin.OnKeyDown := memoinKeyDown;
  memoin.OnParaStyleConversion := memoinParaStyleConversion;
  memoin.OnPaste := memoinPaste;
  memoin.OnSaveImage2 := memoinSaveImage2;
  memoin.OnStyleConversion := memoinStyleConversion;
  memoin.OnDropFiles := memoinDropFiles;
  memoin.OnOleDrop := memoinOleDrop;
  memoin.OnDragDrop := memoinDragDrop;
  memoin.PopupMenu := memoinmenu;
  memoin.style := RVStyle2;
  memoin.BorderStyle := bsNone;
  memoin.animationMode := rvaniOnFormat;
  memoin.EditorOptions := memoin.EditorOptions + [rvoClearTagOnStyleApp];
  memoin.visible := true;
  // спрятать
  PanelFont.Visible := false;
  // иконка в трей
  TrayIcon := TTrayIcon.Create(mainForm);
  TrayIcon.AnimateInterval := 700;
  TrayIcon.icons := iconList;
  iconList.GetIcon(0, TrayIcon.Icon);
  TrayIcon.OnClick := nil; // пока без действия
  TrayIcon.PopupMenu := StatusMenu1;
  TrayIcon.OnBalloonClick := BalloonClick;
  TrayIcon.Visible := false;
  HideTaskBarIcon;

  // будем получать сведения о сессии виндовс
  RegisterSessionNotification(mainForm.Handle, NOTIFY_FOR_THIS_SESSION);
  //
  need_psw := false;
  last_time := now;
  Last_log := 0;
  start_time := now;
  SetProgramLocale;
  //
  for i := 0  to  pagecontrol1.PageCount-1 do
    pagecontrol1.Pages[0].Free;
  PageControl1.doublebuffered := true;  // need!
  PanelTools1.doublebuffered := true;

  PageControl1.OnMouseDown := PageControl1MouseDown;
  PageControl1.RaggedRight := false;

  // константы
  one_sek := strtotime('0:0:1');
  one_hour := 3600 * one_sek;
  idle_time := 0;
  // версии
  ver := vers.GetVersion(application.exename);
  winver := GetWindowsVersion(winver_num);
  // создаем нужные объекты
  Channels := TChannels.Create(PageControl1);
  Channels.ChannelsForm := mainForm;
  mstream := TMemoryStream.Create;
  unknown_user := TstringList.Create;
  sendfiles := TstringList.Create;
  err_count := 0;
  // удалим старый лог
  dellog;
  //
  Randomize;
  Timer1sek.Enabled := false;
  Timer1sek.Interval := 2000;

  inUpdate := false;
  NeedExit := false;

  // отображение пользователей
  User_box:=TUserBox.Create(Panel_user_box);
  User_box.UserList:=user_list;
  User_box.Display.PopupMenu:=PopupUserList; // wbpopup

  // флаг уже запущено
  CheckEvent := Tevent.Create(nil, false, true, 'ICOM');
  If (CheckEvent.WaitFor(10) <> wrSignaled) then
  begin
    if not TestMode then
    begin
      showmessage('One copy only');
      one_copy := true;
      application.Terminate;
      exit;
    end
    else if Setup.IcomPort = default_port then
      Setup.IcomPort := Setup.IcomPort + 2;
  end;
  self.caption := '';
  // установка иконки в трэй
  ChangeIcon(0);
  // удалить ненужные шрифты
  if AnsiSameText(copy(Setup.icomlang,2), 'RU') or AnsiSameText(copy(Setup.icomlang,2), 'EN') then
  begin
    DelFonts(FontComboBox1);
  end;

  SetMyStatus;
  User_box.UpdateBox(true);
  // активный зеленый (изначально -1)
  PageControl1.ActivePageIndex := 0;
  PageRefresh(true); // переключим туда-сюда чтобы заработало отображение
  PluginPanel.Caption := '';
  PluginPanel.Width := 0;
  log('formCreate');
end;

function myiplink: string;
var
  nn: int64;
begin
  nn := GetTickCount;
  result := inttostr(nn) + '_';
end;

// сообщение себе в трафик (если цвет не указан, то просто сообщение)
Procedure TmainForm.SelfMsg(ChName: string; komu: string; msg: string);
var
  dt: string;
begin
  if user_list.getID(ChName) >= 0 then
    dt := datetostr(date) + ' '
  else
    dt := '';

  msg := AddSmiles(msg);
  NetWork.Collapse(msg);

 if empty(msg) then
    exit;

  Channels.Channel[ChName].AddSysText(Setup.Myname, trim(ChName), dt + timetostr(time) + ' [' + Setup.Myname + ']' +
    user_list[Setup.Myip].ex_status + komu, HTMLColor(Setup.sysFont.color));
  Channels.Channel[ChName].AddText('', trim(ChName), msg);
  if Setup.autoscroll then
    Channels.Channel[ChName].GoEnd;
  if Setup.saveTraf then
    SaveTraf;
end;

// отправляемое в виде html
Function TmainForm.HtmlIn: string;
var
  buf: TstringList;
const
  infile = 'input.html';
begin
  buf := TstringList.Create;
  try
    if fileexists(htmldir + infile) then
      buf.LoadFromFile(htmldir + infile);
    result := buf.text;
  finally
    myFreeAndNil(buf);
    deletefile(htmldir + infile);
  end;
end;

procedure TmainForm.IcomButtonClick(Sender: TObject);
var
  x: integer;
begin
  CreateMainMenu(chPopupMenu);
  x := self.Left +  Panel_user_box.left + WindowBorder;
  chPopupMenu.Popup(x, self.top + WindowTitle + TWinControl(Sender).top + TWinControl(Sender).Height + WindowBorder);
end;

function TMainform.Memoin2Html:string;
const
  infile = 'input.html';
var
  i: integer;
  txt: string;
  item: tcustomrviteminfo;
  AName: TRVAnsiString;
  Actrl: TControl;
  AVAlign: TRVVAlign;
  ATag: TRVTag;
  Agr: TGraphic;
  Offs, Offs2: Integer;
  TmpStr: string;
begin
  memoin.BeginUpdate;
  // заменим < на &lt;  > на &gt & на &amp;
  i := 0;
  while i <= memoin.ItemCount - 1 do
  begin
    txt := memoin.GetItemTextW(i);
    txt := Spec2text(txt);
    memoin.SetItemTextW(i, txt);
    i := i + 1;
  end;
  // список картинок
  sendfiles.clear;
  // обработаем смайлики (заменим на текст)
  memoin.Deselect;
  i := 0;
  while i <= memoin.ItemCount - 1 do
  begin
    item := memoin.GetItem(i);
    if item.StyleNo = -5 then  // смайлики
    begin
      memoin.getcontrolinfo(i, AName, Actrl, AVAlign, ATag);
      if Pos('ANI', uppercase(string(AName))) <> 0 then
        TjvGifAnimator(Actrl).Animate := false;
      Offs := memoin.GetOffsAfterItem(i);
      memoin.SetSelectionBounds(i, Offs, i, Offs);
      memoin.InsertText('<' + uppercase(string(AName)) + '>', false);
      // произвольный gif и свои доп. смайлики
      if Pos('.GIF', uppercase(string(AName))) <> 0 then
        sendfiles.Add(lowercase(htmldir + string(AName)))
    end
    else if item.StyleNo = -3 then // файл в виде иконки (картинки игнорим, они запишутся savehtml !!)
    begin
      memoin.GetPictureInfo(i, TRVAnsiString(AName), Agr, AVAlign, ATag);
      if fileexists(string(AName)) then
      begin
        Offs := memoin.GetOffsBeforeItem(i);
        Offs2 := memoin.GetOffsAfterItem(i);
        memoin.SetSelectionBounds(i, Offs, i, Offs2);
        memoin.InsertText('', false);
        sendfiles.Add(lowercase(string(AName)));
      end;
    end;
    i := i + 1;
  end;
  memoin.EndUpdate;
  // готовое сообщение в виде rtf (с анимацией)
  memoin.Selectall;
  // выгрузка в html
  for i := 0 to RVStyle2.TextStyles.Count - 1 do
    RVStyle2.TextStyles[i].Options := [rvteoHTMLCode];
  // sendfiles.Clear; чистим выше при замене контролов!
  memoin.SaveHTMLEx(htmldir + infile, 'vvod', ImgName + '_' + myiplink, '', '', '', [rvsoMiddleOnly, rvsoInlineCSS]);
  // готовый html
  TmpStr := HtmlIn;
  // упрощение html
  TmpStr := SimpleHTML(TmpStr);
  //
  TmpStr := stringreplace(TmpStr, lang.get('cit_start'), '<blockquote>', [rfreplaceall, rfIgnoreCase]);
  TmpStr := stringreplace(TmpStr, lang.get('cit_end'), '</blockquote>', [rfreplaceall, rfIgnoreCase]);
  // защита от удаления закрывающего тега
  if Pos('</BLOCKQUOTE>', uppercase(TmpStr)) = 0 then
  begin
    TmpStr := stringreplace(TmpStr, '<blockquote>', '', [rfreplaceall, rfIgnoreCase]);
  end;
  result:= '<div>' + TmpStr + '</div>';
end;

// отправка сообщения
procedure TmainForm.IcomSenD(files: TStringList);
var
  i: Integer;
  TmpStrHTML: String;
  ch: Integer;
  id: Integer;
  komu: string;
  sendcount: Integer;
  ext: string;
  ch_name: string;
  name: string;
  ips: TStringList;
  msg: string;
Begin
  if (PageControl1.ActivePageIndex < 0) then
    exit; // -1 нет активной страницы
  try // except
    // свободный канал
    if (PageControl1.activepage.tag = FREE_CH) then
    begin
      ch_name := trim(PageControl1.activepage.caption);
      ch := FREE_CH;
      // выделены все или никто = всем
      if (user_box.SelCount = 0) or (user_box.SelCount = user_box.Count) then
      begin
        komu := ' - [' + lang.get('to_all') + ']';
        sendcount := 0;
      end
      else // групповое
      begin
        sendcount := user_box.Count;
        komu := ' - [';
        for i := 0 to user_box.Count - 1 do
        begin
          name := user_box.UserBox(i);
          if user_box.Selected(name) then
          begin
            id := user_list.getID(name);
            if user_list[id].ip>'' then
            begin
              komu := komu + ' ' + user_list[id].name;
            end;
          end;
        end;
        komu := komu + ']';
      end;
    end // личные
    else if user_list.getID(PageControl1.activepage.caption) >= 0 then
    begin
      sendcount := 1;
      ch := PERSONAL_CH;
      ch_name := trim(PageControl1.activepage.caption);
      komu := ' - [' + ch_name + ']';
    end;

    if files.Count = 0 then // обычное сообщение
    begin
      TmpStrHTML := Memoin2html;
      memoin.Clear;
      SetOwnFont;
      // теперь отправим всем картинки из сообщения файлами
      for i := 0 to sendfiles.Count - 1 do
      begin
        ips := user_box.GetSelectedIP;
        NetWork.SendGroupFile(ch, lang.toDefaultLang(ch_name), ips, sendcount, sendfiles.Strings[i]);
        ips.Free;
        ext := uppercase(extractfileext(sendfiles.Strings[i]));
        if (ext <> '.GIF') and (ext <> '.PNG') and (ext <> '.JPG') and (ext <> '.BMP') then
          SelfMsg(PageControl1.activepage.caption, komu, lang.get('send_file')+': <a href="' + LNK_FILE +
            sendfiles.Strings[i] + '">' + extractfilename(sendfiles.Strings[i]) + '</a></font>');
      end;
      if empty(TmpStrHTML) then
        exit;
      if (last_out_message = TmpStrHTML)and(TmpStrHTML <> '')and(abs(now-last_send)<5*one_sek) then
      begin
        newlog('AntiSpan');
        exit;
      end;
      last_out_message := TmpStrHTML;
      SelfMsg(ch_name, komu, TmpStrHTML);
      ips := user_box.GetSelectedIP;
      NetWork.SendGroupMsg(ch, lang.toDefaultLang(ch_name), ips, sendcount, TmpStrHTML);
      ips.Free;
    end
    else // файлы
    begin
      TmpStrHTML := '';
      memoin.Clear;
      SetOwnFont;
      ips := user_box.GetSelectedIP;
      for i := 0 to files.Count-1 do
      begin
        if myfilesize(files[i]) > MAX_FILE_SIZE_V2 then
        begin
          msg := lang.get('error') + ' ' + lang.get('big_file');
          SelfMsg(ch_name, komu, msg);
        end
        else
        begin
          msg := lang.get('send_file') + ': <a href="' + LNK_FILE + files[i] + '">' + extractfilename(files[i]) + '</a>';
          SelfMsg(ch_name, komu, msg);
          NetWork.SendGroupFile(ch, lang.toDefaultLang(ch_name), ips, sendcount, files[i]);
        end;
      end;
      ips.Free;
    end;
  except
    on E: Exception do
      log('IcomSend ' + E.Message);
  end;
end;

// скрываем мемо приp начале работы с ним чтоб не видно было изменений
Function TmainForm.ShowHPanel: TPanel;
var
  hpanel: TPanel;
begin
  hpanel := TPanel.Create(MemoinPanel);
  hpanel.visible := false;
  hpanel.Parent := MemoinPanel;
  hpanel.caption := '';
  hpanel.BevelInner := bvNone;
  hpanel.BevelOuter := bvNone;
  hpanel.BorderStyle := bsNone;
  hpanel.cursor := crHourGlass;
  hpanel.top := memoin.top;
  hpanel.left := memoin.left;
  hpanel.width := memoin.width;
  hpanel.Height := memoin.Height;
  hpanel.color := Setup.Wincolor;
  hpanel.visible := true;
  application.processmessages;
  result := hpanel;
end;

function TMainform.TestMsgLang(txt:string):boolean;
var
  lang_1, lang_2: boolean;
  i:integer;
const
  alpha = 'ABCDEFGHJIKLMNOPQRSTUVWZYZ';
  alpha_ru = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЫЪЬЭЮЯ';
begin
  lang_1 := false;
  lang_2 := false;
  for i := 1 to length(txt) do
  begin
    if (Pos(txt[i], alpha) <> 0) or (Pos(txt[i], alpha_ru) <> 0) then
    // проверяем только буквы
    begin
      if (Setup.Startlang = 1) then // en
      begin
        if Pos(txt[i], alpha_ru) <> 0 then
          lang_2 := true
        else
          lang_1 := true;
      end
      else if (Setup.Startlang = 2) then // ru
      begin
        if Pos(txt[i], alpha) <> 0 then
          lang_2 := true
        else
          lang_1 := true;
      end
    end;
  end;
  result:=true;
  if (Setup.warnLang) and (not lang_1) and (lang_2) then
  begin
    if messagedlg(lang.get('correct') + #13 + lang.get('resend'), mtwarning, [mbYes, mbNo], 0) <> mrYes then
      result:=false;
  end;
end;

function TMainform.TestReadOnly:boolean;
begin
  if PageControl1.ActivePageIndex < 0 then
    result:=true
  else if PageControl1.activepage.tag < 0 then
    result:=true
  else
    result:=false;
end;

function TMainform.TestChannel:boolean;
var
  id:integer;
begin
  // выделен 1 и не его личный канал
  if (User_box.SelCount = 1) and (not AnsiSameText(trim(PageControl1.activepage.caption), user_box.seluser)) then
  begin
    id := user_list.getID(user_box.seluser);
    if user_list.get(id).status = OFFLINE then
    begin
      showmessage(lang.get('off_line'));
      result:=false;
    end
    else if AnsiSameText(user_list[Setup.Myip].name, user_box.seluser) then
    begin
      showmessage(lang.get('self'));
      result:=false;
    end
    else
      result:=true;
  end
  else
    result:=true;
end;

function TMainform.TestAndSelectPersonal:boolean;
begin
  result := true;
  if Channels.Channel[PageControl1.activepage.caption].tag=PERSONAL_CH then
  begin
    User_box.Select(PageControl1.activepage.caption);
    if user_box.Status(PageControl1.activepage.caption)=OFFLINE then
    begin
      showmessage(lang.get('off_line'));
      result := false;
    end;
    if User_box.SelCount <> 1 then
    begin
      showmessage('error');
      result := false;
    end;
  end;
end;

// отправка сообщения
procedure TmainForm.SenDBtnClick(Sender: TObject);
var
  txt: string;
  hpanel: TPanel;
Begin
  PanelFont.visible := false;
  try
    SendBtn.Enabled := false;
    out_label(true);
    inUpdate := true; // блокировка

    if TestReadOnly then
      exit;
    if not TestChannel then
      exit;
    // new personal?
    if (user_box.SelCount=1)and(not AnsiSameText(trim(PageControl1.activepage.caption),User_box.SelUser)) then
    begin
      if messagedlg(lang.get('personal') + ' ' + user_box.seluser + '?', mtconfirmation, [mbYes, mbNo], 0) = mrYes then
        NewTab(user_box.SelUser, true, PERSONAL_CH)
      else
        exit;
    end;
    if not TestAndSelectPersonal then
      exit;
    // проверим на ошибочный язык
    if AnsiSameText(Setup.icomlang, default_lang) then
    begin
      memoin.Selectall;
      txt := ansiuppercase(memoin.getseltext);
      if not TestMsgLang(txt) then
        exit;
    end;
    memoin.BeginUndoGroup(rvutCustom);
    memoin.SetUndoGroupMode(True);
    try
      try
        hpanel := ShowHPanel;
        IcomSend(TStringList.Create);
      except
        memoin.Undo;
      end;
    finally
      memoin.SetUndoGroupMode(False);
      myFreeAndNil(hpanel);
    end;
    if (Setup.soundon) and (Setup.s4on) then
      mysound(Setup.sndout);

     // персональные каналы - убрать выделение
    if user_list.getID(trim(PageControl1.activepage.caption)) >= 0 then
      user_box.SelectAll;
  finally
    out_label(false);
    MySetFocus(memoin);
    SetOwnFont;
    SendBtn.Enabled := true;
    application.processmessages;
    inUpdate := false;
    last_send:= now;
  end;
end;

procedure TmainForm.ClearCacheHTML;
var
  sr: TsearchRec;
  Res: Integer;
begin
  log('ClearCacheHTML');
  if htmldir>'' then
  begin
    Res := findFirst(htmldir + '*.html', faAnyFile, sr);
    while Res = 0 do
    begin
      deletefile(htmldir + sr.name);
      Res := FindNext(sr);
    end;
    FindClose(sr);
  end;
end;

procedure TmainForm.ClearCacheImages(days: Integer=1);
var
  sr: TsearchRec;
  Res: Integer;
  df: Tdatetime;
  ext: string;
begin
  log('ClearCacheImages');
  deletefile('screen.jpg');
  if htmldir>'' then
  begin
    Res := findFirst(htmldir + '*.*', faAnyFile, sr);
    while Res = 0 do
    begin
      ext := UpperCase(ExtractFileExt(sr.name));
      if (ext<>'.HTML')and(sr.attr<>faDirectory) then
      begin
        df := filedatetime(htmldir + sr.name);
        if now - df > days then
          deletefile(htmldir + sr.name);
      end;
      Res := FindNext(sr);
    end;
    FindClose(sr);
  end;
end;

// clear temp dir
procedure TmainForm.ClearTemp;
var
  sr: TsearchRec;
  Res: Integer;
begin
  log('ClearTemp');
  if CacheDir>'' then
  begin
    Res := findFirst(cachedir + '*.*', faAnyFile, sr);
    while Res = 0 do
    begin
      deletefile(cachedir + sr.name);
      res:=FindNext(sr);
    end;
    FindClose(sr);
  end;
end;

// освобождение ресурсов
procedure TmainForm.FreeRes;
begin
  try
    log('freeres');
    UnRegisterSessionNotification(self.Handle);
    myFreeAndNil(sendfiles);
    begin
      while Channels.Count <> 0 do
        Channels.Delete(0);
      myFreeAndNil(Channels);
    end;
    myFreeAndNil(RVStyle2);
    myFreeAndNil(memoin);
    myFreeAndNil(unknown_user);
    myFreeAndNil(sendfiles);
    myFreeAndNil(CheckEvent);
    myFreeAndNil(mstream);
    myFreeAndNil(user_list);
    myFreeAndNil(Setup);
    myFreeAndNil(lang);
    myFreeAndNil(PluginList);
    if assigned(Plugins) then
    begin
      Plugins.FreePlugins;
      myFreeAndNil(Plugins);
    end;
    myFreeAndNil(CheckEvent);
    log('end freeres');
  except
    on E: Exception do
      log('freeres: ' + E.Message);
  end;
end;

procedure Tmainform.ClearOnExit;
begin
  try
    log('ClearOnExit 1');
    if assigned(NetWork) then
      NetWork.Stop;
    Timer1sek.Enabled := false;
    ClearAllClick(nil);
    Setup.SaveSetup;
    Setup.DeleteHotKey;
    FreeRes;
    ClearCacheHTML;
    ClearCacheImages;
    ClearTemp;
  except
    on E: Exception do
      log('ClearOnExit: ' + E.Message);
  end;
end;

procedure TmainForm.SaveTraf;
var
  i:integer;
  ChName: string;
begin
  log('SaveTraf');
  try
    for i := 0 to PageControl1.PageCount - 1 do
    begin
      if (PageControl1.Pages[i].tag >= 0) then
      begin
        ChName := trim(PageControl1.Pages[i].caption);
        Channels.Channel[ChName].SaveToFile(htmldir + ChName + '.html');
      end;
    end;
  except
    on e: exception do
      log('savetraf: '+e.Message);
  end;
end;

// сохранение по выходу
procedure TmainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // отключим
  ApplicationEvents1.free;
  Timer1sek.Enabled := false;
  SaveTraf;
  ClearOnExit;
end;

procedure TmainForm.FontComboBox1Change(Sender: TObject);
begin
  memoin.ApplyStyleConversion(TEXT_APPLYFONTNAME);
  MySetFocus(memoin);
end;

procedure TmainForm.FontSetupButtonClick(Sender: TObject);
begin
  PanelFont.visible := not PanelFont.visible;
  PanelFont.refresh;
  application.processmessages;
end;

// отправка по ентер
procedure TmainForm.memoinKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = ord('A')) and (Shift = [ssCtrl]) then
    memoin.Selectall
  else if (Key = ord('B')) and (Shift = [ssCtrl]) then
  begin
    WideFontBtn.down := not WideFontBtn.down;
    WideFontBtnClick(WideFontBtn);
  end
  else if (Key = ord('T')) and (Shift = [ssCtrl]) then
  begin
    ItalicFontBtn.down := not ItalicFontBtn.down;
    WideFontBtnClick(ItalicFontBtn);
    Key := 0;
  end
  else if (Key = ord('U')) and (Shift = [ssCtrl]) then
  begin
    btnUnderline.down := not btnUnderline.down;
    WideFontBtnClick(btnUnderline);
  end
  else if Key = VK_RETURN then
  begin
    if not Setup.entermode2 then
    begin
      if Shift <> [ssCtrl] then
      begin
        Key := 0;
        SenDBtnClick(NIL);
      end;
    end
    else
    begin // наоборот
      if Shift = [ssCtrl] then
      begin
        Key := 0;
        SenDBtnClick(NIL);
      end;
    end;
  end;
  PanelFont.Visible := false;
end;

// переход на страницу с непрочитанным сообщением, приоритет личные-rgb-прочие
procedure TmainForm.ActivatePage;
var
  i: Integer;
  pg: Integer;
  ts: TTabSheet;
begin
  pg := -1;
  // 1 личные
  for i := 0 to PageControl1.PageCount - 1 do
  begin
    ts := PageControl1.Pages[i];
    if (Channels.Channel[ts.caption].Blink) and (ts.tag = PERSONAL_CH) and (trim(ts.caption) <> green) and
      (trim(ts.caption) <> blue) and (trim(ts.caption) <> red) then
    begin
      pg := i;
      break;
    end;
  end;
  if pg < 0 then
  begin
    // 2 основные
    for i := 0 to PageControl1.PageCount - 1 do
    begin
      ts := PageControl1.Pages[i];
      if (Channels.Channel[ts.caption].Blink) and ((trim(ts.caption) = green) or (trim(ts.caption) = blue) or
        (trim(ts.caption) = red)) then
      begin
        pg := i;
        break;
      end;
    end;
  end;
  if pg < 0 then
  begin // 3 фри каналы
    for i := 0 to PageControl1.PageCount - 1 do
    begin
      ts := PageControl1.Pages[i];
      if (Channels.Channel[ts.caption].Blink) and (ts.tag = FREE_CH) then
        pg := i;
    end
  end;
  if (pg >= 0) and (PageControl1.Pages[pg].tabvisible) then
  begin
    PageRefresh;
    PageControl1.ActivePageIndex := pg;
  end;
end;

// старт
procedure TmainForm.FormActivate(Sender: TObject);
begin
  memoin.color := Setup.Wincolor;
  MySetFocus(memoin);
  MigIcon(0);
  if Setup.checktraf then
    NewTraf(Setup.traflimit);
  CheckFreeSpace(Path, 3, true);
  SizeIcom;
  PosIcom;
  log('formActivate');
end;

// очистка трафика
procedure TmainForm.ClearBtnClick(Sender: TObject);
begin
  try
    if TestReadOnly then
      exit; 

    if not(Setup.confirmdelete) then
    begin
      Channels.Channel[PageControl1.activepage.caption].clear;
      Channels.Channel[PageControl1.activepage.caption].Blink := false;
    end
    else if messagedlg(lang.get('clear_traffic'), mtwarning, [mbYes, mbNo], 0) = mrYes then
    begin
      Channels.Channel[PageControl1.activepage.caption].clear;
      Channels.Channel[PageControl1.activepage.caption].Blink := false;
    end;
    if Setup.saveTraf then
      SaveTraf;
  finally
    Channels.SetChannelIcons(Setup.Channelicons);
    MySetFocus(memoin);
  end;
end;

// выход по меню
procedure TmainForm.ExitMenuClick(Sender: TObject);
begin
  try
    ClearCacheImages(0);
    application.processmessages;
    NeedExit := true;
    Network.SendExit;
  finally
    Close;
  end;
end;

// запрос аватарок каких нет еще
procedure Tmainform.TestAvatar;
var
  i:integer;
begin
  for i := 0 to user_list.Count - 1 do
  begin
    if user_list[i].status <> OFFLINE then
    begin
      if not fileexists(CacheDir+inttostr(user_list[i].randId)+'.jpg') then
      begin
        if now - user_list[i].big_time > 5 * one_sek then
        begin
          NetWork.GetAvatar(user_list[i].ip);
          user_list[i].big_time := now;
        end;
      end;
    end;
  end;
end;

// тем кто не присылает статус >60 сек поставим оффлайн
procedure TMainform.TestOffline;
var
  i:integer;
  msg:string;
begin
  for i := 0 to user_list.Count - 1 do
  begin
    if (abs((now - user_list[i].time) / one_sek) > 60) then
    begin
      if (user_list[i].status <> OFFLINE) and (user_list[i].name > '') then
      begin
        msg := timetostr(time) + ' ' + lang.get('user_out'+inttostr(user_list[i].male)) + ' [' + user_list[i].name + ']';
        log(msg);
        if show_on_off then
          NewLog(msg);
        if (Setup.trayonoff) and (show_on_off) then
        begin
          if (abs((now - user_list[i].time) / one_sek) < 300) then
          // отключился вчера (если из спящего >300сек не показываем сообщ)
          begin
            showballon(timetostr(time), lang.Get('user_out'+inttostr(user_list[i].male)) + ' [' + user_list[i].name + ']', 3);
            if (Setup.soundon) and (Setup.s2on) then
              mysound(Setup.sndoffline);
          end;
        end;
        user_list.SetOffline(i);
      end;
    end;
  end;
end;

procedure TmainForm.Timer1sekTimer(Sender: TObject);
var
  i: Integer;
  act1, act2: boolean;
begin
  try
    Network.Decode;
    // delphi bug, splitter lost position
    if Splitter1.top > MemoinPanel.top then
      Splitter1.top := MemoinPanel.top - 3;
    if Splitter2.left > Panel_user_box.left then
      Splitter2.left := Panel_user_box.left - 3;
    // очистим лог
    if (now - Last_log > 15 * one_sek) then
      NewLog('');
    idle_time := LastInput div 1000;
    // автовыход
    if (Setup.checkexit) and (idle_time >= Setup.idleexit * 3600) then
    begin
      Timer1sek.Enabled := false;
      log('Max idle auto exit');
      ExitMenuClick(nil);
      exit;
    end;
    // статус по простою
    // или если запущен хранитель экрана или комп. заблокирован = ушел
    if (idle_time > Setup.idlemax) or (ScreenSaver) or (Locked) then
    begin
      if self.visible then
      begin
        SmileForm.Close;
        Application.Minimize;
      end;
      user_list[Setup.Myip].status := OFF;
      TrayIcon.Animate := false;
      if not TrayIcon.Animate then
        ChangeIcon(1);
      if idle_time > 60 then
        need_psw := true;
    end
    else
    begin
      // включать ли после простоя мигалку?
      // если были сообщения в общих каналах - мигаем
      act1 := false;
      for i := 0 to PageControl1.PageCount - 1 do
      begin
        if (Channels.Channel[PageControl1.Pages[i].caption].Blink) and
          (Channels.Channel[PageControl1.Pages[i].caption].tag = FREE_CH) then
          act1 := true;
      end;
      if (act1) and (not TrayIcon.Animate) and (not Setup.stoptray) then
        TrayIcon.Animate := act1;
      // если были сообщения в личных - мигаем
      act2 := false;
      for i := 0 to PageControl1.PageCount - 1 do
      begin
        if (Channels.Channel[PageControl1.Pages[i].caption].Blink) and
          (Channels.Channel[PageControl1.Pages[i].caption].tag = PERSONAL_CH) and (not Setup.stoptray) then
          act2 := true;
      end;
      if (act2) and (not TrayIcon.Animate) then
        TrayIcon.Animate := act2;
      // восстановим иконку если не мигаем
      if not TrayIcon.Animate then
        ChangeIcon(0);
      user_list[Setup.Myip].status := ONLINE;
    end;
    // послать статус
    if flip then
    begin
      SetMyStatus;
      NetWork.SendStatus(user_list[Setup.Myip]);
    end;
    flip := not flip;

    TestAvatar;
    TestOffline;
    AutoAddUnknown;
    // последняя активность
    last_time := now;
    user_box.UpdateBox(false);
    Application.ProcessMessages;
  except
    on e: exception do
      log('1sek '+e.message);
  end;
end;

procedure TmainForm.SmileBtn1Click(Sender: TObject);
var
  tempGif: TjvGifAnimator;
  url, nm: string;
begin
  url := 'smi080.gif';
  tempGif := TjvGifAnimator.Create(nil);
  tempGif.image.LoadFromFile(htmldir + 'Smiles\' + url);
  tempGif.Animate := true;
  tempGif.AutoSize := true;
  nm := copy(extractfilename(url), 1, Pos('.GIF', extractfilename(uppercase(url))) - 1);
  memoin.InsertControl(ansistring(nm), tempGif, rvvaBaseline);
end;

procedure TmainForm.SmileBtn2Click(Sender: TObject);
var
  tempGif: TjvGifAnimator;
  url, nm: string;
begin
  url := 'smi081.gif';
  tempGif := TjvGifAnimator.Create(nil);
  tempGif.image.LoadFromFile(htmldir + 'Smiles\' + url);
  tempGif.Animate := true;
  tempGif.AutoSize := true;
  nm := copy(extractfilename(url), 1, Pos('.GIF', extractfilename(uppercase(url))) - 1);
  memoin.InsertControl(ansistring(nm), tempGif, rvvaBaseline);
end;

procedure TmainForm.SmileBtn3Click(Sender: TObject);
begin
  if SmileForm = NIL then
    application.CreateForm(TSmileForm, SmileForm);
  SmileForm.ShowModal;
end;

procedure TmainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if NeedExit then
    CanClose := true
  else
  begin
    CanClose := false;
    Application.Minimize;
  end;
end;

procedure TmainForm.AllBtnClick(Sender: TObject);
begin
  user_box.SelectAll;
  user_box.UpdateBox();
end;

// выбор файла для передачи
procedure TmainForm.FileBtnClick(Sender: TObject);
var
  i: Integer;
  file_name: string;
  us: string;
  fl: TStringList;
begin
  try
    inUpdate := true;
    if TestReadOnly then
      exit;
    if not TestChannel then
      exit;
    if (user_box.SelCount=1)and(trim(PageControl1.activepage.caption)<>User_box.SelUser) then
    begin
      if messagedlg(lang.get('personal') + ' ' + user_box.seluser + '?', mtconfirmation, [mbYes, mbNo], 0) = mrYes then
        NewTab(user_box.seluser, true, PERSONAL_CH)
      else
        exit;
    end;
    if not TestAndSelectPersonal then
      exit;

    try // opendialog может вылетать на некоторых файлах
      if (Pos(Path, OpenDialog1.FileName) <> 0) or (Pos(Path, OpenDialog1.Initialdir) <> 0) or (OpenDialog1.FileName = '')
        or (OpenDialog1.Initialdir = '') then
      begin
        OpenDialog1.FileName := '*.*';
        OpenDialog1.Initialdir := Path;
      end;
      OpenDialog1.filter := 'All |*.*';
      OpenDialog1.FilterIndex := 0;
      if not OpenDialog1.Execute then
        exit;
    except
      on E: Exception do
      begin
        log('filebtn: ' + E.Message);
        exit;
      end;
    end;

    us := trim(PageControl1.activepage.caption);
    if OpenDialog1.Files.Count = 1 then
      file_name := OpenDialog1.FileName;
    if messagedlg(lang.get('send_files') + ' ' + extractfilename(file_name) + ' ' + us + '?', mtconfirmation,
      [mbYes, mbNo], 0) <> mrYes then
      exit;

    // отправка
    fl := TStringList.Create;
    for i:=0 to OpenDialog1.Files.Count-1 do
      fl.Add(OpenDialog1.Files[i]);
    IcomSenD(fl);
    fl.Free;
    if (Setup.soundon) and (Setup.s4on) then
      mysound(Setup.sndout);

    if user_list.getID(PageControl1.activepage.caption) >= 0 then
      user_box.SelectAll;
  finally
    application.processmessages;
    inUpdate := false;
   MySetFocus(memoin);
  end;
end;

procedure TmainForm.ComboBox_sizeChange(Sender: TObject);
begin
  MySetFocus(memoin);
  memoin.ApplyStyleConversion(TEXT_APPLYFONTSIZE);
end;

procedure TmainForm.HistoryButton1Click(Sender: TObject);
var
  ex: Integer;
const
  ChName = 'Help';
  hf = ChName + '.html';
begin
  try
    ShowIcom(Sender);
    reslib.logo;
    deletefile(htmldir + '\' + hf);
    ex := NewTab(ChName, true, READONLY_CH);
    if ex >= 0 then
    begin
      extractHelp(htmldir + '\' + hf);
      Channels.Channel[ChName].LoadFromFile(htmldir + hf);
      Channels.Channel[ChName].GoBegin;
    end;
  except
    on E: Exception do
      log('Help - ' + E.Message);
  end;
end;

procedure TmainForm.memoinMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MigIcon(0);
end;


// перекодировка нажатой клавиши для передачи в другой контрол
function recodeKEY(Key: Word): Word;
const
  re: array [1 .. 2] of string = ('1234567890qwertyuiop[]asdfghjkl;''zxcvbnm,./',
    '1234567890йцукенгшщзхъфывапролджэячсмитьбю.');
var
  i: Integer;
  Layout: string;
  RA: Array [0 .. $FFF] of char;
  kk: string;
begin
  GetKeyboardLayoutName(RA);
  Layout := StrPas(RA);
  case Key of
    VK_NUMPAD0: kk := '0';
    VK_NUMPAD1: kk := '1';
    VK_NUMPAD2: kk := '2';
    VK_NUMPAD3: kk := '3';
    VK_NUMPAD4: kk := '4';
    VK_NUMPAD5: kk := '5';
    VK_NUMPAD6: kk := '6';
    VK_NUMPAD7: kk := '7';
    VK_NUMPAD8: kk := '8';
    VK_NUMPAD9: kk := '9';
    VK_DIVIDE: kk := '/';
    VK_MULTIPLY: kk := '*';
    VK_SUBTRACT: kk := '-';
    VK_ADD: kk := '+';
    VK_DECIMAL: kk := '.';
    VK_OEM_MINUS: kk := '-';
    VK_OEM_PLUS: kk := '+';
    VK_OEM_COMMA: kk := ',';
    VK_OEM_PERIOD: kk := '.';
    VK_OEM_1: kk := ';';
    VK_OEM_2: kk := ' ';  // ?
    VK_OEM_3: kk := ' ';
    VK_OEM_4: kk := '[';
    VK_OEM_5: kk := ' '; // /
    VK_OEM_6: kk := ']';
    VK_OEM_7: kk := chr(39);
    VK_F2, VK_F3, VK_F4, VK_F5, VK_F6, VK_F7, VK_F8, VK_F9, VK_F10, VK_F11, vk_f12: kk := ' ';
    VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_INSERT, VK_DELETE, VK_HOME, VK_END, VK_PRIOR, VK_NEXT: kk := ' ';
  else
    kk := chr(Key);
    kk := lowercase(kk);
  end;
  if Layout = '00000409' then
    result := Word(ord(kk[1]))
  else
  begin  // не английский
    result := 0;
    for i := 1 to length(re[1]) do
    begin
      if copy(re[1], i, 1) = kk then
      begin
        kk := copy(re[2], i, 1);
        result := Word(ord(kk[1]));
      end;
    end;
  end;
end;

procedure TmainForm.restart2;
begin
  try
    try
      log('restart');
      ApplicationEvents1.free;
      if Timer1sek <> nil then
        Timer1sek.Enabled := false;
      SaveTraf;
      Setup.SaveSetup;
      FreeRes;
    except
      on E: Exception do
        log('restart - ' + E.Message);
    end;
  finally
    // new copy
    RunProcess(application.exename, '/restart');
    myFreeAndNil(CheckEvent);
    Application.Terminate;
  end;
end;

procedure TmainForm.ApplicationEvents1Exception(Sender: TObject; E: Exception);
const
  max_errors = 2;
begin
  if (Setup.soundon) and (Setup.s6on) then
    mysound(Setup.snderror);
  log('Error: ' + E.Message);
  // crash after start
  if now - start_time < 10 * one_sek then
  begin
    showmessage(lang.get('start') + ': ' + E.Message);
    log('error start');
    halt(1);
  end;
  if (Pos('ACCESS VIOLATION', uppercase(E.Message)) <> 0) or
     (Pos('EXTERNAL EXCEPTION', uppercase(E.Message)) <> 0) or
     (Pos('INVALID POINTER OPERATION', uppercase(E.Message)) <> 0) or
     (Pos('CANVAS DOES NOT ALLOW DRAWING', uppercase(E.Message)) <> 0) or
     (Pos('CONNECT TIMED OUT', uppercase(E.Message)) <> 0)then
    err_count := err_count + 1;

  if  err_count >= max_errors  then
  begin
    log(E.Message + ' - auto restart');
    restart2;
  end;

end;

procedure TmainForm.HideTaskBarIcon;
begin
  self.Hide;
  Showwindow(application.Handle, SW_HIDE);
end;

procedure Tmainform.CloseForms;
begin
  while setupform.Visible do
  begin
    SetupForm.ModalResult := mrCancel;
    setupform.Visible := false;
    sleep(100);
    Application.ProcessMessages;
  end;
  while SmileForm.Visible do
  begin
    SmileForm.ModalResult := mrCancel;
    SmileForm.Visible := false;
    sleep(100);
    Application.ProcessMessages;
  end;
end;

procedure TmainForm.ApplicationEvents1Minimize(Sender: TObject);
begin
  log('Events1Minimize');
  CloseForms;
  HideTaskBarIcon;
  mainForm.Hide;
  unknown_user.clear;
  if idle_time > Setup.idlemax then
    // автоматическое сворачивание
  else
    MigIcon(0);
end;

procedure TmainForm.gotoend(var memo: TRichViewEdit);
var
  ItemNo, Offs: Integer;
begin
  memo.reformat;
  ItemNo := memo.ItemCount - 1;
  Offs := memo.GetOffsAfterItem(ItemNo);
  memo.SetSelectionBounds(ItemNo, Offs, ItemNo, Offs);
  memo.reformat;
end;

procedure TmainForm.CitBtnClick(Sender: TObject);
var
  fraza: string;
  start: Integer;
  Count: Integer;
  text: string;
begin
  try
    if Channels.Channel[PageControl1.activepage.caption].SelText > '' then
    begin
      text := Channels.Channel[PageControl1.activepage.caption].SelText;
      if (Pos(#13, text) <> 0) and (Pos(#13, text) < Pos(string(' ]'), text)) then
      begin
        showmessage(lang.get('overq'));
        exit;
      end;
      Count := 0;
      fraza := text;
      start := 1;
      while posex(' ]', fraza, start) <> 0 do
      begin
        Count := Count + 1;
        start := posex(' ]', fraza, start) + 1;
      end;
      if Count > 1 then
      begin
        showmessage(lang.get('overq'));
        exit;
      end;

      fraza := stringreplace(fraza, #10, '', [rfreplaceall]);
      fraza := stringreplace(fraza, lang.get('msgok'), '', [rfreplaceall, rfIgnoreCase]);
      fraza := stringreplace(fraza, '- [' + lang.get('to_all') + ']', '', [rfreplaceall, rfIgnoreCase]);
      fraza := stringreplace(fraza, '[' + lang.get('to_all') + ']', '', [rfreplaceall, rfIgnoreCase]);
      fraza := html2text(fraza);
      fraza := stringreplace(fraza, #13, '[br]', [rfreplaceall]);
      DeleteDouble('[br]', fraza);
      fraza := DeleteBR(true, true, fraza);
      try
        if trim(fraza) = '' then
          exit;
        memoin.clear;
        memoin.AddNL(lang.get('cit_start'), 0, 0);
        gotoend(memoin);
        memoin.AddNL('', 0, 0);
        gotoend(memoin);
        memoin.Add(fraza, 0);
        memoin.Deselect;
        memoin.AddNL(lang.get('cit_end'), 0, 0);
        memoin.AddNL('', 0, 0);
        gotoend(memoin);
        MySetFocus(memoin);
      finally
        SetOwnFont;
      end;
    end;
  except
    on E: Exception do
      log('Cit ' + E.Message);
  end;

end;

procedure TmainForm.ClearAllClick(Sender: TObject);
var
  i: Integer;
begin
  log('ClearAllClick');
  if (Sender <> nil) and (messagedlg(lang.get('clear_all'), mtwarning, [mbYes, mbNo], 0) <> mrYes) then
    exit;
  for i := 0 to PageControl1.PageCount - 1 do
    Channels.Channel[PageControl1.Pages[i].caption].clear;
  ClearCacheImages(0);
  MigIcon(0);
end;

procedure TmainForm.ClearAllMenu_wopersonalClick(Sender: TObject);
var
  i: Integer;
begin
  if (Sender <> nil) and (messagedlg(lang.get('clear_all'), mtwarning, [mbYes, mbNo], 0) <> mrYes) then
    exit;
  for i := 0 to PageControl1.PageCount - 1 do
  begin
    if (user_list.getID(trim(PageControl1.Pages[i].caption)) < 0) then
    begin
      Channels.Channel[PageControl1.Pages[i].caption].clear;
    end;
  end;
  MigIcon(0);
end;

procedure TmainForm.CutMenuClick(Sender: TObject);
begin
  ClearBtnClick(NIL);
end;

procedure TmainForm.PluginBtnClick(Sender: TObject);
var
  ps: TStringList;
begin
  ps := TStringList.Create;
  ps.Text := Plugins.HtmlList;
  ps.SaveToFile(htmldir + 'plugin.html');
  ps.Free;
  NewTab(lang.get('Plugin'), true, READONLY_CH);
  Channels.Channel[lang.get('plugin')].LoadFromFile(htmldir + 'plugin.html');
  Channels.Channel[lang.get('plugin')].GoBegin;
end;

procedure TmainForm.SetupBtnClick(Sender: TObject);
begin
  SetupForm.Caption := Lang.get('setup');
  SetupForm.ShowModal;
end;

procedure TmainForm.PageControl1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  TabIndex : integer;
begin
if GetIndexTab(Sender as TCustomTabControl, X, Y, TabIndex) then
  begin
    SendMessage(self.Handle, WM_CLOSE_CHANNEL, TabIndex, 0);
  end;
end;

procedure TmainForm.TabsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
 i: integer;
 r: TRect;
begin
  for i := 1 to PageControl1.PageCount-1 do
  begin
    r := GetButtonRect(PageControl1, i);
    if (x>=r.Left)and(x<=r.Right)and(y>=r.Top)and(y<=r.Bottom) then
    begin
      upagecontrol.drawCloseButton(pageControl1, r, true);
      lastDrawed := i;
      Break;
    end
    else if (lastDrawed<>0)and(lastDrawed<>PageControl1.ActivePageIndex) then
    begin
      upagecontrol.drawCloseButton(pageControl1, GetButtonRect(PageControl1, lastDrawed), false);
      lastDrawed := 0;
    end;
  end;
end;

procedure TmainForm.PageControl1Changing(Sender: TObject; var AllowChange: boolean);
begin
  try
    if not SendBtn.Enabled then
    begin
      AllowChange := false;
      exit;
    end;
    // channel before
    Channels.Channel[PageControl1.activepage.caption].Blink := false;

    if User_box.SelCount = 1 then
    begin
      User_box.SelectAll;
      User_box.Refresh;
    end;
  except
    on E: Exception do
      log('pagechanging ' + E.Message);
  end;
end;

procedure TmainForm.PageControl1Change(Sender: TObject);
begin
  try
    MigIcon(0);
    // channel after
    Channels.Channel[PageControl1.activepage.caption].Blink := false;
    Channels.SetChannelIcons(Setup.Channelicons);
    if Setup.autoscroll then
      Channels.Channel[PageControl1.activepage.caption].GoEnd;
    //
    MySetFocus(memoin);
    application.processmessages;
  except
    on E: Exception do
      log('pagechange ' + E.Message);
  end;
end;

// изменить текущий шрифт
procedure TmainForm.memoinStyleConversion(Sender: TCustomRichViewEdit; StyleNo, UserData: Integer;
  AppliedToText: boolean; var NewStyleNo: Integer);
var
  FontInfo: TFontInfo;
begin
  FontInfo := TFontInfo.Create(nil);
  try
    FontInfo.Assign(RVStyle2.TextStyles[StyleNo]);
    case UserData of
      TEXT_BOLD:
        if WideFontBtn.down then
          FontInfo.style := FontInfo.style + [fsBold]
        else
          FontInfo.style := FontInfo.style - [fsBold];
      TEXT_ITALIC:
        if ItalicFontBtn.down then
          FontInfo.style := FontInfo.style + [fsItalic]
        else
          FontInfo.style := FontInfo.style - [fsItalic];
      TEXT_UNDERLINE:
        if btnUnderline.down then
          FontInfo.style := FontInfo.style + [fsUnderline]
        else
          FontInfo.style := FontInfo.style - [fsUnderline];
      TEXT_STRIKE:
        if btnStrike.down then
          FontInfo.style := FontInfo.style + [fsStrikeOut]
        else
          FontInfo.style := FontInfo.style - [fsStrikeOut];
      TEXT_APPLYFONTNAME:
        FontInfo.FontName := FontComboBox1.text;
      TEXT_APPLYFONTSIZE:
        FontInfo.Size := strtoint(ComboBox_size.text);
      TEXT_APPLYFONT:
        FontInfo.Assign(Setup.myFont);
      TEXT_COLOR:
        FontInfo.color := PanelFontColor.font.color;
      TEXT_BACKCOLOR:
        FontInfo.BackColor := Setup.Wincolor;
    end;
    NewStyleNo := RVStyle2.TextStyles.FindSuchStyle(StyleNo, FontInfo, RVAllFontInfoProperties);
    if NewStyleNo = -1 then
    begin
      RVStyle2.TextStyles.Add;
      NewStyleNo := RVStyle2.TextStyles.Count - 1;
      RVStyle2.TextStyles[NewStyleNo].Assign(FontInfo);
      RVStyle2.TextStyles[NewStyleNo].Standard := false;
    end;
  finally
    myFreeAndNil(FontInfo);
  end;
  PanelFontColor.Repaint;
end;

procedure TmainForm.MemoinCopyClick(Sender: TObject);
begin
  memoin.copy;
end;

procedure TmainForm.MemoinCutClick(Sender: TObject);
begin
  if not memoin.SelectionExists then
    memoin.clear
  else
    memoin.DeleteSelection;
end;

procedure TmainForm.MemoinPasteMenuClick(Sender: TObject);
begin
  memoin.Paste;
end;

procedure TmainForm.RestartMenuClick(Sender: TObject);
begin
  restart2;
end;

procedure TmainForm.CopyTextMenuClick(Sender: TObject);
var
  st: string;
begin
  try
    st := Channels.Channel[PageControl1.activepage.caption].SelText;
    PutStringIntoClipBoard(st);
  except
    on E: Exception do
      log('copy text ' + E.Message);
  end;
end;

procedure TmainForm.memoinParaStyleConversion(Sender: TCustomRichViewEdit; StyleNo, UserData: Integer;
  AppliedToText: boolean; var NewStyleNo: Integer);
var
  ParaInfo: TParaInfo;
const
  PARA_ALIGNMENT = 1;
  PARA_INDENTINC = 2;
  PARA_INDENTDEC = 3;
  PARA_COLOR = 4;
begin
  ParaInfo := TParaInfo.Create(nil);
  try
    ParaInfo.Assign(RVStyle2.ParaStyles[StyleNo]);
    case UserData of
      PARA_ALIGNMENT:
        ParaInfo.Alignment := rvaLeft;
      PARA_INDENTINC:
        begin
          ParaInfo.LeftIndent := ParaInfo.LeftIndent + 20;
          if ParaInfo.LeftIndent > 200 then
            ParaInfo.LeftIndent := 200;
        end;
      PARA_INDENTDEC:
        begin
          ParaInfo.LeftIndent := ParaInfo.LeftIndent - 20;
          if ParaInfo.LeftIndent < 0 then
            ParaInfo.LeftIndent := 0;
        end;
      PARA_COLOR:
        ParaInfo.Background.color := Setup.Wincolor;
    end;
    NewStyleNo := RVStyle2.ParaStyles.FindSuchStyle(StyleNo, ParaInfo, RVAllParaInfoProperties);
    if NewStyleNo = -1 then
    begin
      RVStyle2.ParaStyles.Add;
      NewStyleNo := RVStyle2.ParaStyles.Count - 1;
      RVStyle2.ParaStyles[NewStyleNo].Assign(ParaInfo);
      RVStyle2.ParaStyles[NewStyleNo].Standard := false;
    end;
  finally
    myFreeAndNil(ParaInfo);
  end;
end;

// срабатывает после navigate (нет - после refresh)
procedure TmainForm.WebBrowser1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  MySetFocus(memoin);
end;

procedure TmainForm.WebBrowser1NavigateError(ASender: TObject;
  const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
begin
  TIcomViewer(ASender).GoBack;
end;

procedure TmainForm.WideFontBtnClick(Sender: TObject);
var
  Button: TSpeedButton;
begin
  Button := Sender as TSpeedButton;
  memoin.ApplyStyleConversion(Button.tag);
end;

// установка кнопок и списков  по текущему стилю текста
procedure TmainForm.memoinCurTextStyleChanged(Sender: TObject);
var
  fi: TFontInfo;
  i: Integer;
begin
  fi := RVStyle2.TextStyles[memoin.CurTextStyleNo];
  FontComboBox1.ItemIndex := FontComboBox1.Items.IndexOf(fi.FontName);
  for i := 0 to ComboBox_size.Items.Count - 1 do
    if fi.Size = strtoint(ComboBox_size.Items[i]) then
    begin
      ComboBox_size.ItemIndex := i;
      break;
    end;
  PanelFontColor.font.color := fi.color;
  WideFontBtn.down := fsBold in fi.style;
  ItalicFontBtn.down := fsItalic in fi.style;
  btnUnderline.down := fsUnderline in fi.style;
  btnStrike.down := fsStrikeOut in fi.style;
  DrawFontSetupButton(fi);
end;

Procedure TmainForm.SetOwnFont;
begin
  PanelFontColor.font := Setup.myFont;
  memoin.Canvas.font := Setup.myFont;
  memoin.ApplyStyleConversion(TEXT_APPLYFONT);
  memoinCurTextStyleChanged(NIL);
  PanelFontColor.Repaint;
  MySetFocus(memoin);
end;

procedure TmainForm.ClearTrafMenuClick(Sender: TObject);
begin
  ClearBtnClick(NIL);
end;

procedure TmainForm.btnStrikeClick(Sender: TObject);
var
  Button: TSpeedButton;
begin
  Button := Sender as TSpeedButton;
  memoin.ApplyStyleConversion(Button.tag);
end;

// в applicationevents это сообщение не приходит
procedure TmainForm.WMPowerBroadcast(var msg: TMessage);
begin
  if (msg.wParam = PBT_APMRESUMESUSPEND) or (msg.wParam = PBT_APMRESUMESTANDBY) or (msg.wParam = PBT_APMRESUMEAUTOMATIC)
  then
  begin
    if now - start_time > 60*one_sek then // только одно сообщение при пробуждении
    begin
      log('power wake up');
      Timer1sek.Enabled := false;
      start_time := now;
      if Setup.checktraf then
        NewTraf(Setup.traflimit);
      ClearCacheImages;
      if (Setup.checkexit) and (idle_time > Setup.idleexit * 3600) then
        Application.Terminate
      else
        Restart2;
    end;
  end;
end;

procedure Tmainform.NextTab;
var
  i:integer;
begin
    i := PageControl1.ActivePageIndex + 1;
    if i >= PageControl1.PageCount then
      i := 0;
    while true do
    begin
      if PageControl1.Pages[i].tabvisible then
      begin
        PageControl1.ActivePageIndex := i;
        break;
      end;
      i := i + 1;
      if i >= PageControl1.PageCount then
        i := 0;
    end;
end;

procedure Tmainform.PrevTab;
var
  i:integer;
begin
    i := PageControl1.ActivePageIndex - 1;
    if i < 0 then
      i := PageControl1.PageCount - 1;
    while true do
    begin
      if PageControl1.Pages[i].tabvisible then
      begin
        PageControl1.ActivePageIndex := i;
        break;
      end;
      i := i - 1;
      if i < 0 then
        i := PageControl1.PageCount - 1;
    end;
end;

procedure TmainForm.ApplicationEvents1Message(var msg: tagMSG; var Handled: boolean);
var
  sp:integer;
  WC:TWinControl;
begin
  if msg.message = WM_MOUSEWHEEL then
  begin
    WC:=FindVCLWindow(msg.pt);
    if (WC is TWebBrowser) then
    begin
      sp:=Channels.Channel[pagecontrol1.ActivePage.Caption].Browser.ScrollPos;
      if short(HIWORD(msg.wparam))>0 then
        sp:=sp-50
      else
        sp:=sp+50;
      Channels.Channel[pagecontrol1.ActivePage.Caption].Browser.ScrollPos:=sp;
      Handled := true;
    end;
  end
  else if Msg.message = WM_KEYDOWN then
  begin
    if Msg.wParam = VK_ESCAPE then
    begin
      if SmileForm.Visible or setupform.visible then
      begin
        SmileForm.Close;
        setupform.close;
      end
      else
        Application.Minimize;
      Handled := true;
    end
    else if Msg.wParam = VK_F1 then
    begin
      HistoryButton1Click(nil);
      Handled := True;
    end
    else if (Msg.wParam = VK_TAB) and (CtrlDown) then
    begin
      NextTab;
      Handled := True;
    end
    else if (Msg.wParam = VK_TAB) and (ShiftDown) and (CtrlDown) then
    begin
      PrevTab;
      Handled := True;
    end
    else if (not memoin.Focused)and(application.ActiveFormHandle=self.Handle)and(not CtrlDown)and(not AltDown) then
    begin
      mySetFocus(memoin, true);
      sendmessage(memoin.Handle, WM_CHAR, recodeKEY(Msg.wParam), 0);
      Handled := True;
    end;
  end
  else if (msg.Message = WM_HOTKEY) then
    if msg.wParam = Setup.atm then
    begin
      TrayIconClick(nil);
      Handled := true;
    end
    else
      Handled := Plugins.ExecPluginHotKey(msg)
  else if msg.Message = WM_WTSSESSION_CHANGE then
  begin
    case msg.wParam of
      WTS_SESSION_LOCK:
        Locked := true;
      WTS_SESSION_UNLOCK:
        Locked := false;
    end;
  end
end;

procedure TmainForm.BalloonClick(Sender: TObject);
begin
  ShowIcom(Sender);
end;

procedure TmainForm.ShowIcom(Sender: TObject);
begin
  if self.visible then
    exit;
  if PageControl1.ActivePageIndex <0 then
    PageControl1.ActivePageIndex := 0;

  user_list[Setup.Myip].status := ONLINE;
  user_list[Setup.Myip].modified := true;
  user_box.UpdateBox(false);
  if Setup.actpage then
    ActivatePage;
  if (Channels.Count<>0)and(Setup.autoscroll) then
    Channels.Channel[PageControl1.activepage.caption].GoEnd;
  Application.Restore;
  self.Show;
  SetForegroundWindow(Application.Handle);

  MySetFocus(memoin);
  FormActivate(NIL);
  self.refresh;
end;

procedure TmainForm.TrayIconClick(Sender: TObject);
begin
  if self.visible then
     Application.Minimize
  else
    ShowIcom(Sender);
end;

// выбор из меню пользователей - "файл"
procedure TmainForm.SendflClick(Sender: TObject);
var
  us: string;
begin
  us := user_box.SelUser;
  if (us='')or(trim(ansiuppercase(Setup.Myname)) = trim(ansiuppercase(us))) then
    exit;
  NewTab(us, true, PERSONAL_CH);
  FileBtnClick(NIL);
end;

// доп.статус
procedure TmainForm.ExBtnClick(Sender: TObject);
var
  ss: string;
begin
  ss := user_list[Setup.Myip].ex_status;
  ss := stringreplace(ss, '[', '', [rfreplaceall]);
  ss := stringreplace(ss, ']', '', [rfreplaceall]);
  ss := InputBox('', lang.get('enter_stat'), ss);
  user_list[Setup.Myip].ex_status := ss;
end;

// принудительное обновление списка
procedure TmainForm.UserRefrClick(Sender: TObject);
begin
  TestAvatar;
  user_list[Setup.myIP].big_time := Now;
  user_box.SelectAll;
  user_box.UpdateBox(true);
end;

// имя последней записанной картинки
function GetLastFileName(const ImagesPrefix, Path, ext: String; const imgNo: Integer): String;
var
  FullPath: String;
  Nom: Integer;
begin
  if Pos(':', ImagesPrefix) > 0 then
    FullPath := ImagesPrefix
  else
    FullPath := Path + ImagesPrefix;
  Nom := imgNo;
  while true do
  begin
    result := FullPath + inttostr(Nom) + ext;
    if not fileexists(result) then
      exit;
    inc(Nom);
  end;
end;

procedure TmainForm.memoinSaveImage2(Sender: TCustomRichView; Graphic: TGraphic; SaveFormat: TRVSaveFormat;
  const Path, ImagePrefix: String; var ImageSaveNo: Integer; var Location: String; var DoDefault: boolean);
var
  ss: string;
  nn: int64;
begin
  DoDefault := true;
  nn := GetTickCount;
  if nn > maxint then
    nn := nn - maxint;
  ImageSaveNo := nn;
  ss := GetLastFileName(ImagePrefix, Path, '.jpg', ImageSaveNo + 1);
  sendfiles.Add(ss);
end;

procedure TmainForm.IcomNavigate(ASender: TObject; url: string; var Cancel: wordbool);
var
  doc: TstringList;
  i: Integer;
  lbl: string;
  fraza, nik: string;
  ps1, ps2: Integer;
  bCancel: boolean;
  key: string;
  ChName: string;
  eUrl: string;
begin
  try
    eUrl := url;
    url := urldecode(url);
    url := delLast(url);

    bCancel := true;
    chName := trim(PageControl1.activepage.caption);
    if Pos(uppercase(LNK_FILE), uppercase(url)) <> 0 then
    begin
      url := stringreplace(url, #$a0, ' ', [rfreplaceall]);
      url := copy(url, length(LNK_FILE)+1, length(url) - (length(LNK_FILE)-1));
    end;
    if url > '' then
    begin
      // настройки поагинов
      if Pos('PLUGIN:', uppercase(url)) = 1 then
      begin
        Plugins.ExecSetup(copy(url,10));
        bCancel := true;
      end
      // открыть канал
      else if Pos('NEW:', uppercase(url)) = 1 then
      begin
        url := copy(url, 7, length(url) - 6);
        NewTab(url, true, FREE_CH);
        bCancel := true;
      end
      // цитировать сообщение
      else if Pos('ICOM6:', uppercase(url)) = 1 then
      begin
        try
          // обработаем
          lbl := copy(url, 9, length(url) - 8);
          // исходник html
          doc := TStringList.Create;
          doc.Text := Channels[ChName].getmessage(lbl);
          // выделение цитаты
          key := 'nick=';
          for i := 0 to doc.Count - 1 do
          begin
            if Pos(url, doc.Strings[i]) <> 0 then
            begin
              // ник между кавычками
              fraza := doc.Strings[i];
              ps1 := Pos(key, fraza);
              ps2 := Posex('"',fraza,ps1+length(key)+1);
              if (ps1 <> 0) and (ps2 <> 0) and (ps2 > ps1) then
                nik := copy(fraza, ps1 + length(key)+1, ps2 - ps1 - length(key)-1)
              else
                nik := '';
              break;
            end;
          end;
          fraza := '';
          for i := 0 to doc.Count - 1 do
          begin
            if (fraza>'')or(Pos('id='+'m'+copy(lbl,2), doc.Strings[i]) <> 0) then
            begin
              fraza := fraza + doc.Strings[i];
            end;
          end;
          fraza := htmlcode2text(fraza);
          myFreeAndNil(doc);
          // удалить лишнее
          fraza := trim(fraza);
          fraza := stringreplace(fraza, lang.get('msgok'), '', [rfreplaceall, rfIgnoreCase]);
          fraza := stringreplace(fraza, '<br>', '[br]', [rfreplaceall, rfIgnoreCase]);
          fraza := html2text(fraza);
          fraza := stringreplace(fraza, '[br][br]', '[br]', [rfreplaceall, rfIgnoreCase]);
          fraza := DeleteBR(true, true, fraza);
          // вставка в поле ввода
          try
            if trim(fraza) = '' then
              exit;
            nik := trim(nik);
            memoin.clear;
            if (nik > '') then
              memoin.AddNL(lang.get('cit_start') + '[' + nik + '][hr]', 0, 0)
            else
              memoin.AddNL(lang.get('cit_start'), 0, 0);
            gotoend(memoin);
            memoin.AddNL('', 0, 0);
            gotoend(memoin);
            memoin.Add(fraza, 0);
            memoin.Deselect;
            memoin.AddNL(lang.get('cit_end'), 0, 0);
            memoin.AddNL('', 0, 0);
            gotoend(memoin);
            MySetFocus(memoin);
          finally
            SetOwnFont;
          end;
          bCancel := true;
          //
        except
         on e: exception do
           log('quote error: '+e.Message);
        end;
      end
      else if plugins.ExecUrl(eUrl) then
        bCancel := true
      else // файлы и картинки
      begin
        url := URLdecode(url);
        SafeExec(URLdecode(url));
        bCancel := true;
      end;
    end;
  finally
    Cancel := bCancel;
  end;
end;

// клик по ссылке
procedure TmainForm.HTML1BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
var
  base: string;
  url2: string;
begin
  base := TIcomViewer(ASender).base;
  url2 := URL;
  if (url = 'about:blank#')or(url = 'javascript:void(0)') then
    cancel := true
  else
    IcomNavigate(ASender, url2, Cancel);
end;

// меню трафика
procedure TmainForm.trafmenuPopup(Sender: TObject);
begin
  if Channels.Channel[PageControl1.activepage.caption].SelText > '' then
    CopyTextMenu.Enabled := true
  else
    CopyTextMenu.Enabled := false;
  if Setup.autoscroll then
    ScrollMenu.caption := lang.get('auto_scroll') + ': ' + lang.get('on')
  else
    ScrollMenu.caption := lang.get('auto_scroll') + ': ' + lang.get('off');
  if wbPopup.image_href > '' then
  begin
    CopyPictMenu.Enabled := true;
    SavePictMenu.Enabled := true;
  end
  else
  begin
    CopyPictMenu.Enabled := false;
    SavePictMenu.Enabled := false;
  end;
end;

procedure TmainForm.SavePictMenuClick(Sender: TObject);
begin
  try
    if not fileexists(copy(wbPopup.image_href,9)) then
      exit;
    if SavePictureDialog1.Execute then
      mycopyfile(copy(wbPopup.image_href,9), SavePictureDialog1.FileName);
  except
    on E: Exception do
      log('save pic error: ' + E.Message);
  end;
end;

procedure TmainForm.CopyPictMenuClick(Sender: TObject);
var
  pic :TPicture;
begin
  try
    if not fileexists(copy(wbPopup.image_href,9)) then
      exit;
    pic := TPicture.Create;
    pic.LoadFromFile(copy(wbPopup.image_href,9));
    Clipboard.Assign(pic.Graphic);
    pic.Free;
  except
    on E: Exception do
      log('copy pic error: ' + E.Message);
  end;
end;

Procedure TmainForm.PosIcom;
begin
  if self.WindowState <> wsmaximized then
  begin
    if (self.left < -30) then
      self.left := 0;
    if (self.left >= screen.width) then
      self.left := screen.width - 100;
    if (self.top < -30) then
      self.top := 0;
    if (self.top >= screen.Height) then
      self.top := screen.Height - 100;
  end;
end;

// размер не больше размера экрана
Procedure TmainForm.SizeIcom;
var
  p: Tpos;
begin
  if self.WindowState <> wsmaximized then
  begin
    p := TaskbarPos;
    case p of
      POSLEFT, POSRIGHT:
        if self.width - (2 * WindowBorder) > screen.width - 40 then
          self.width := screen.width - Taskbar;
      POSTOP, POSBOTTOM:
        if self.Height - (2 * WindowBorder) > screen.Height - Taskbar then
          self.Height := screen.Height - Taskbar
    end;
  end;
end;

// завершение виндовс
procedure TmainForm.WMQueryEndSession(var msg: TWMQueryEndSession);
begin
  inherited;
  msg.result := 1; // ready
  application.processmessages;
  ClearOnexit;
end;

procedure TmainForm.PanelTools1Resize(Sender: TObject);
const
  Size = 24;
  Space = 6;
  Margin = 20;
begin
  SmileBtn3.left := (PanelTools1.Width div 2) - (2 * size);
  begin
    if SmileBtn3.left < FontSetupbutton.Left + FontSetupbutton.Width + Space + SmileBtn1.Width + Space + SmileBtn2.Width + Space then
      SmileBtn3.left := FontSetupbutton.Left + FontSetupbutton.Width + Space + SmileBtn1.Width + Space + SmileBtn2.Width + Space;
    SmileBtn2.left := SmileBtn3.Left - Space - SmileBtn2.Width;
    SmileBtn1.left := SmileBtn2.Left - Space - SmileBtn1.Width;
  end;
  CitBtn.left := SmileBtn3.left + SmileBtn3.width + Space;
  FileBtn.left := CitBtn.left + CitBtn.width + Space;
  ClearBtn.left := FileBtn.left + FileBtn.width + Space;
  SendBtn.left := PanelTools1.width - SendBtn.width - Margin - ScrollBar;
  if SendBtn.left <  ClearBtn.left + ClearBtn.width +Space then
    SendBtn.left := ClearBtn.left + ClearBtn.width +Space
end;

// вставить файл как иконку
function TmainForm.InsertFileAsIcon(file_name: string): boolean;
var
  bt: TBitmap;
begin
  try
    if fileexists(file_name) then
    begin
      bt := TBitmap.Create;
      bt.Height := 32;
      bt.width := 32;
      GetIcon(file_name, bt);
      memoin.InsertPicture(ansistring(file_name), bt, rvvaBaseline);
      memoin.reformat;
      result := true;
    end;
  except
    result := false;
  end;
end;

// вставить картинку
procedure TmainForm.InsertFileImage(file_name: string);
var
  pic: TPicture;
  tempGif: TjvGifAnimator;
  ext: string;
begin
  ext := uppercase(extractfileext(file_name));
  if (ext = '.PNG') or (ext = '.JPG') or (ext = '.JPEG') or (ext = '.BMP') or (ext = '.ICO') then
  begin
    mycopyfile(file_name, htmldir + ImgName + '_' + extractfilename(file_name));
    pic := TPicture.Create;
    try
      pic.LoadFromFile(file_name);
      memoin.InsertPicture(ansistring(ImgName + '_' + extractfilename(file_name)), pic.Graphic, rvvaBaseline);
    except
      on e: exception do
        log('bad picture: '+e.Message);
    end;
  end
  else if (ext = '.GIF') then
  begin
    mycopyfile(file_name, htmldir + Aniname + '_' + extractfilename(file_name));
    tempGif := TjvGifAnimator.Create(nil);
    tempGif.image.LoadFromFile(file_name);
    tempGif.Animate := true;
    tempGif.AutoSize := true;
    memoin.InsertControl(ansistring(Aniname + '_' + extractfilename(file_name)), tempGif, rvvaBaseline);
  end;
  memoin.reformat;
end;

// при перетаскивании из браузера
// url - строка http:// .......
function TmainForm.InsertFromBrowser(url: string): boolean;
// возвращает DoDefault
var
  DoDefault: boolean;
  file_name: string;
  tempGif: TjvGifAnimator;
  img: TJpegImage;
  ext: string;
  bm: TBitmap;
  png: TImage;
  file_name_new: string;
begin
  DoDefault := true;
  try
    try
      url := utf8tostring(urldecode(url));  // %xx%xx%xx%xx -> unicode -> string
      file_name := NetWork.MyDownload(url);
      if not fileexists(file_name) then
        exit;
      ext := Uppercase(extentions.GetExt(file_name)); // wrong extention
      if ext='' then
        ext := uppercase(extractfileext(file_name));
      file_name_new:=ChangeFileExt(file_name, ext);
      if not AnsiSameText(file_name, file_name_new) then
      begin
        if ext='.GIF' then
        begin
          file_name_new := htmldir + Aniname + '_' + extractfilename(file_name_new);
          renamefile(file_name, file_name_new);
        end
        else if (ext = '.PNG') or (ext = '.JPG') or (ext = '.JPEG') or (ext = '.BMP') or (ext = '.ICO') then
        begin
          file_name_new := htmldir + ImgName+'_' + extractfilename(file_name_new);
          renamefile(file_name, file_name_new);
        end
        else
          RenameFile(file_name, file_name_new);
      end;
      if not fileexists(file_name_new) then
        exit;
      if ((Pos('FILE:///', uppercase(url)) = 1) or (Pos('HTTP://', uppercase(url)) = 1)) and (ext = '.GIF') then
      begin
        tempGif := TjvGifAnimator.Create(nil);
        tempGif.image.LoadFromFile(file_name_new);
        tempGif.Animate := true;
        tempGif.AutoSize := true;
        memoin.InsertControl(ansistring(extractfilename(file_name_new)), tempGif, rvvaBaseline);
        memoin.reformat;
        DoDefault := false;
      end
      else if ((Pos('FILE:///', uppercase(url)) = 1) or (Pos('HTTP://', uppercase(url)) = 1)) and
        ((ext = '.JPG') or (ext = '.JPEG')) then
      begin
        img := TJpegImage.Create;
        img.LoadFromFile(htmldir + extractfilename(file_name_new));
        memoin.InsertPicture(ansistring(extractfilename(file_name_new)), img, rvvaBaseline);
        memoin.reformat;
        DoDefault := false;
      end
      else if ((Pos('FILE:///', uppercase(url)) = 1) or (Pos('HTTP://', uppercase(url)) = 1)) and (ext = '.PNG') then
      begin
        png := TImage.Create(nil);
        try
          png.picture.LoadFromFile(htmldir + extractfilename(file_name_new));
          bm := TBitmap.Create;
          bm.Transparent := true;
          bm.Assign(png.picture.Graphic);
          memoin.InsertPicture(ansistring(extractfilename(file_name_new)), bm, rvvaBaseline);
          memoin.reformat;
          DoDefault := false;
        finally
          myFreeAndNil(png);
        end;
      end
      else if (Pos('FILE:///', uppercase(url)) = 1) then
      begin
        DoDefault := not InsertFileAsIcon(file_name_new);
      end
      else
      begin
        DoDefault := true;
      end;
    except
      on E: Exception do
        log('insertfrombrowser - ' + E.Message);
    end;
  finally
    result := DoDefault;
  end;
end;


function TmainForm.NewTab(TabName: string; ForceSwitch: boolean; NewTag: Integer): Integer;
var
  ex: Integer;
  TabFile: string;
  i: Integer;
  ts: TTabSheet;
  NewHtml: TIcomViewer;
begin
  ex := -1;
  try
    try
      // уже существует?
      TabName := lang.toMyLang(TabName);
      ex := Channels.FindTab(TabName);
      if ex < 0 then
      begin
        Channels.Add(PageControl1, TabName, NewTag);
        ts := Channels.Channel[TabName].TabSheet;
        ts.visible := ForceSwitch;
        // сортировка зел-син-красн
        if TabName = green then
        begin
          ts.PageIndex := 0;
          ex := 0;
        end
        else if TabName = blue then
        begin
          ts.PageIndex := 1;
          ex := 1;
        end
        else if (TabName = red) then
        begin
          if Channels.Find(blue) >= 0 then
          begin
            ts.PageIndex := 2;
            ex := 2;
          end
          else // нет - после зеленого
          begin
            ts.PageIndex := 1;
            ex := 1;
          end;
        end
        else
          ex := PageControl1.PageCount - 1;
        //
        NewHtml := Channels.Channel[TabName].browser;
        NewHtml.TabStop :=false;
        NewHtml.Align := alClient;
        NewHtml.DefFontName := 'Arial';
        NewHtml.ScrollBars := ssBoth;
        NewHtml.PopupMenu := trafmenu;
        NewHtml.ImageCacheCount := 5;
        NewHtml.OnBeforeNavigate2 := HTML1BeforeNavigate2;
        NewHtml.OnNavigateError := WebBrowser1NavigateError;
        NewHtml.OnDocumentComplete := WebBrowser1DocumentComplete;
        // загрузить после подключения всех обработчиков
        TabFile := htmldir + trim(TabName) + '.html';
        if fileexists(TabFile) then
          Channels.Channel[TabName].LoadFromFile(TabFile);
        if Setup.autoscroll then
          Channels.Channel[TabName].GoEnd;
        ///Channels.Channel[TabName].Reload(Setup.autoscroll);
        Channels.SetChannelIcons(Setup.Channelicons);
        for i:=0 to PageControl1.PageCount-1 do
          PageControl1.Pages[0].OnMouseMove := TabsMouseMove;
      end;
      PageRefresh(true);
      if ForceSwitch then
      begin
        PageControl1.refresh;
        application.processmessages;
        for i := 1 to 5 do // переключение на новую вкладку с ожиданием
        begin
          PageControl1.ActivePageIndex := ex;
          PageControl1.Invalidate;
          sleep(500);
          if PageControl1.ActivePageIndex = ex then
            break;
        end;
      end;
    except
      on E: Exception do
        log('NewTab - ' + E.Message);
    end;
  finally
    application.processmessages;
    MySetFocus(memoin);
    result := ex;
  end;
end;

procedure Tmainform.NewChannel;
var
  ChName: string;
  ex: Integer;
  msg: string;
  ips: TStringList;
begin
    ChName := '';
    ChName := InputBox('', lang.get('new_channel'), '');
    if ChName > '' then
    begin
      ChName := delsym(ChName);
      ChName := ansiuppercase(ChName[1]) + ansilowercase(copy(ChName, 2, length(ChName) - 1));
      ex := NewTab(ChName, true, FREE_CH);
      if ex >= 0 then
      begin
        msg :=  lang.get('new_channel') + ' <a href="new://' + ChName + '">' + ChName + '</a>';
        ips := user_box.GetSelectedIP;
        NetWork.SendGroupMsg(FREE_CH, lang.Get('green'), ips, 0, msg);
        ips.free;
      end;
    end;
end;

function LastPos(subtxt,txt:string):integer;
var
  ps: integer;
begin
  ps := pos(subtxt,txt);
  while posex(subtxt,txt, ps+1)<>0 do
    ps := posex(subtxt,txt, ps+1);
  result := ps;
end;

// выбор пункта из меню каналов
procedure TmainForm.chMenuClick(Sender: TObject);
var
  ChName: string;
begin
  ShowIcom(sender);
  if TMenuItem(Sender).caption = lang.get('new_channel') then
  begin
    NewChannel;
  end
  else if TMenuItem(Sender).caption <> '-' then
  begin
    ChName := stringreplace(TMenuItem(Sender).caption, '&', '', [rfreplaceall]);
    if Pos('(', ChName) <> 0 then
      ChName := copy(ChName, 1, LastPos('(', ChName) - 1);
    NewTab(ChName, true, FREE_CH);
  end;
end;


// нажатие кнопки каналов
procedure TmainForm.CreateMainMenu(parent:TObject);
var
  mn, mn2: TMenuItem;
  i, j: Integer;
  all_channel_list: TstringList;
  user_channel_list: array [0 .. max] of string;
  user_channel_count: array [0 .. max] of Integer;
  channel_list: TstringList;
  ss: string;
  ps: integer;
  us, ip: string;
  pt: Tpoint;
begin
  if not Assigned(mainmenu) then
  begin
    MainMenu := TPopupMenu.Create(self);
    mainmenu.Images := MenuList;
  end;
  mainmenu.Items.Clear;
  // свободные
  if Setup.showrgb then
  begin
    mn := TMenuItem.Create(mainMenu);
    mn.OnClick := chMenuClick;
    mn.caption := green;
    mn.Hint := '';
    mn.tag := FREE_CH;
    mn.ImageIndex := 1;
    mainMenu.Items.Add(mn);
    mn := TMenuItem.Create(mainMenu);
    mn.OnClick := chMenuClick;
    mn.caption := blue;
    mn.Hint := '';
    mn.tag := FREE_CH;
    mn.ImageIndex := 0;
    mainMenu.Items.Add(mn);
    mn := TMenuItem.Create(mainMenu);
    mn.OnClick := chMenuClick;
    mn.caption := red;
    mn.Hint := '';
    mn.tag := FREE_CH;
    mn.ImageIndex := 2;
    mainMenu.Items.Add(mn);
    mn := TMenuItem.Create(mainMenu);
    mn.OnClick := nil;
    mn.caption := '-';
    mainMenu.Items.Add(mn);
  end;
  // создадим список доступных каналов
  channel_list := TstringList.Create;
  all_channel_list := TstringList.Create;
  try
    for i := 0 to user_list.Count - 1 do
    begin
      if (user_list[i].status <> OFFLINE) and (user_list[i].Channels > '') then
      begin
        ss := user_list[i].Channels;
        ss := stringreplace(ss, '>', LF, [rfreplaceall]);
        channel_list.text := ss;
        for j := 0 to channel_list.Count - 1 do
        begin
          ss := lang.toMyLang(channel_list[j]);
          if not Setup.showrgb then
          begin
            if all_channel_list.IndexOf(ss) = -1 then
              all_channel_list.Add(ss);
          end
          else // чтоб не было дублей
          begin
            if (not lang.isGreen(ss)) and (not lang.isBlue(ss)) and (not lang.isRed(ss)) and
              (all_channel_list.IndexOf(ss) = -1) and (Pos('#', ss) = 0) then
              all_channel_list.Add(ss);
          end;
        end;
      end;
    end;
    // кто в канале
    for i := 0 to length(user_channel_list) - 1 do
    begin
      user_channel_list[i] := '';
      user_channel_count[i] := 0;
    end;
    for i := 0 to all_channel_list.Count - 1 do
    begin
      for j := 0 to user_list.Count - 1 do
      begin
        if Pos(lang.toDefaultLang(all_channel_list.Strings[i]), user_list[j].Channels) <> 0 then
          // польз. в канале
          if Pos(user_list[j].name, user_channel_list[i]) = 0 then
          begin
            user_channel_list[i] := user_channel_list[i] + ' ' + user_list[j].name;
            user_channel_count[i] := user_channel_count[i] + 1;
          end;
      end;
    end;
    // меню
    for i := 0 to all_channel_list.Count - 1 do
    begin
      mn := TMenuItem.Create(mainMenu);
      mn.OnClick := chMenuClick;
      if user_channel_count[i] = 1 then
        mn.caption := all_channel_list[i] + ' (' + trim(user_channel_list[i]) + ')'
      else
        mn.caption := all_channel_list[i] + ' (' + inttostr(user_channel_count[i]) + ')';
      mn.Hint := '';
      mn.tag := FREE_CH;
      mainMenu.Items.Add(mn);
    end;
  finally
    myFreeAndNil(all_channel_list);
    myFreeAndNil(channel_list);
  end;
  // новый
  mn := TMenuItem.Create(mainMenu);
  mn.OnClick := nil;
  mn.caption := '-';
  mainMenu.Items.Add(mn);
  mn := TMenuItem.Create(mainMenu);
  mn.OnClick := chMenuClick;
  mn.caption := lang.get('new_channel');
  mn.Hint := '';
  mn.ImageIndex := 3;
  mainMenu.Items.Add(mn);
  // остальное постоянное меню: настройки, расширенный статус
  mn := TMenuItem.Create(mainMenu);
  mn.OnClick := nil;
  mn.caption := '-';
  mainMenu.Items.Add(mn);
  // юзеры для добавления
  mn := TMenuItem.Create(mainMenu);
  mn.OnClick := nil;
  mn.caption := lang.get('waitadd')+' ('+inttostr(unknown_user.Count)+')';
  mn.Hint := '';
  mn.ImageIndex := -1;
  if unknown_user.Count = 0 then
    mn.Visible := false
  else
    mn.Visible := true;
  mainMenu.Items.Add(mn);
  mn.Clear;
  for i := 0 to unknown_user.Count - 1 do
  begin
    mn2 := TMenuItem.Create(mn);
    mn2.OnClick := AddUserMenuClick;
    ps := Pos('/', unknown_user.Strings[i]);
    us := copy(unknown_user.Strings[i], 1, ps - 1);
    ip := copy(unknown_user.Strings[i], ps + 1, length(unknown_user.Strings[i]) - ps);
    mn2.caption := us;
    mn.Add(mn2);
  end;

  mn := TMenuItem.Create(mainMenu);
  mn.OnClick := SetupBtnClick;
  mn.caption := lang.get('setup_menu');
  mn.Hint := '';
  mn.ImageIndex := 4;
  mainMenu.Items.Add(mn);

  mn := TMenuItem.Create(mainMenu);
  mn.OnClick := PluginBtnClick;
  mn.caption := lang.get('plugin');
  mn.Hint := '';
  mn.ImageIndex := 7;
  mainMenu.Items.Add(mn);

  mn := TMenuItem.Create(mainMenu);
  mn.OnClick := ExBtnClick;
  mn.caption := lang.get('extstat_menu');
  mn.Hint := '';
  mainMenu.Items.Add(mn);

  mn := TMenuItem.Create(mainMenu);
  mn.OnClick := HistoryButton1Click;
  mn.caption := lang.get('help_menu');
  mn.Hint := '';
  mainMenu.Items.Add(mn);
  pt.x := Panel_user_box.left+TSpeedButton(parent).left-(MenuWidth(mainmenu)-TSpeedButton(parent).Width);
  pt.y := TSpeedButton(parent).Top+TSpeedButton(parent).height;
  pt := ClientToScreen(pt);
  mainmenu.Popup(pt.X, pt.y);
end;

function TmainForm.empty1: boolean; stdcall;
begin
  result := false;
end;

procedure TmainForm.icomlog(msg: widestring); stdcall;
begin
  log(msg);
end;

procedure TmainForm.Edit_snapClick(Sender: TObject);
begin
  LoadKeyboardLayout('00000409', KLF_ACTIVATE); // англ
end;

procedure TmainForm.Edit_snapKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
    (Sender as TEdit).text := 'F1'
  else if Key = VK_F2 then
    (Sender as TEdit).text := 'F2'
  else if Key = VK_F3 then
    (Sender as TEdit).text := 'F3'
  else if Key = VK_F4 then
    (Sender as TEdit).text := 'F4'
  else if Key = VK_F5 then
    (Sender as TEdit).text := 'F5'
  else if Key = VK_F6 then
    (Sender as TEdit).text := 'F6'
  else if Key = VK_F7 then
    (Sender as TEdit).text := 'F7'
  else if Key = VK_F8 then
    (Sender as TEdit).text := 'F8'
  else if Key = VK_F9 then
    (Sender as TEdit).text := 'F9'
  else if Key = VK_F10 then
    (Sender as TEdit).text := 'F10'
  else if Key = VK_F11 then
    (Sender as TEdit).text := 'F11'
  else if Key = VK_F12 then
    (Sender as TEdit).text := 'F12'
  else if Key = VK_LEFT then
    (Sender as TEdit).text := 'LEFT'
  else if Key = VK_RIGHT then
    (Sender as TEdit).text := 'RIGHT'
  else if Key = VK_UP then
    (Sender as TEdit).text := 'UP'
  else if Key = VK_DOWN then
    (Sender as TEdit).text := 'DOWN'
  else if Key = VK_SPACE then
    (Sender as TEdit).text := 'SPACE'
  else if Key = VK_SNAPSHOT then
    (Sender as TEdit).text := 'PRINT'
  else if (Key > ord(' ')) and (Key < ord('Z')) then
  begin
    Key := 0;
    (Sender as TEdit).text := chr(Key);
  end
  else
  begin
    Key := 0;
    (Sender as TEdit).text := '';
  end;
end;

procedure TmainForm.PanelFontColorClick(Sender: TObject);
begin
  ColorDialog1.color := RVStyle2.TextStyles[memoin.CurTextStyleNo].color;
  if ColorDialog1.Execute then
  begin
    PanelFontColor.font.color := ColorDialog1.color;
    memoin.ApplyStyleConversion(TEXT_COLOR);
  end;
  PanelFontColor.down := false;
  PanelFontColor.Repaint;
  MySetFocus(memoin);
end;

procedure TmainForm.Aboutclick(Sender: TObject);
begin
  fmAbout.ShowModal;
end;

procedure TmainForm.memoinChange(Sender: TObject);
begin
  if ((memoin.Canvas.font.name <> Setup.myFont.name) or (memoin.Canvas.font.Size <> Setup.myFont.Size) or
    (memoin.Canvas.font.color <> Setup.myFont.color) or (memoin.Canvas.font.style <> Setup.myFont.style)) and
    (RVLinear.RVGetTextLength(memoin) = 0) then
    SetOwnFont;
  MigIcon(0);
end;

procedure TmainForm.memoinPaste(Sender: TCustomRichViewEdit; var DoDefault: boolean);
begin
  try
    DoDefault := MyPaste
  except
    on E: Exception do
      log('mypaste ' + E.Message);
  end;
end;

procedure TmainForm.PersMenuClick(Sender: TObject);
var
  us: string;
begin
  us := user_box.SelUser;
  if (us = '')or(trim(ansiuppercase(Setup.Myname)) = trim(ansiuppercase(us))) then
    exit;
  NewTab(us, true, PERSONAL_CH);
end;

// добавим нового польз.
procedure TmainForm.UnknownAddClick(user2add: string; Auto:boolean=false);
var
  i, j, ps: Integer;
  ss: string;
  uu, ip: string;
  ad: boolean;
begin
  user2add := stringreplace(user2add, '&', '', [rfreplaceall]);
  ps := -1; // найдем строку имя/ip
  for j := 0 to unknown_user.Count - 1 do
  begin
    if (Pos(user2add, unknown_user.Strings[j]) = 1) or (Pos('/' + user2add, unknown_user.Strings[j]) <> 0) then
    begin
      ps := j;
      break
    end;
  end;
  if (ps < 0) then
    exit;
  ss := unknown_user.Strings[ps];
  ps := Pos('/', ss);
  uu := copy(ss, 1, ps - 1);
  ip := copy(ss, ps + 1, length(ss) - ps);
  // проверим нет ли такого уже
  ad := false;
  for i := 0 to user_list.Count - 1 do
  begin
    if (ansiuppercase(user_list[i].name) = ansiuppercase(uu)) or (user_list[i].ip = ip) then
    begin
      if (not auto)and(messagedlg(uu + ' ' + lang.get('overwrite'), mtconfirmation, [mbYes, mbNo], 0) <> mrYes) then
        exit;
      user_list[i].name := uu;
      user_list[i].ip := ip;
      ad := true;
    end;
  end;
  if not ad then
  begin
    // добавим в конец списка
    user_list.AddUser(uu, ip);
  end;
  user_list.user[ip].Status := ONLINE;
  user_box.UpdateBox();
  Setup.SaveSetup;
  unknown_user.clear;
  PageRefresh;
  PageControl1.ActivePageIndex := 0;
end;

procedure TmainForm.AddUserMenuClick(Sender: TObject);
var
  uname: string;
begin
  uname := TMenuItem(Sender).caption;
  if messagedlg(lang.get('add_user') + ' ' + uname, mtconfirmation, [mbYes, mbNo], 0) = mrYes then
    UnknownAddClick(uname);
end;

Procedure TmainForm.ChangeIcon(mode: Integer);
begin
  if TrayIcon.IconIndex <> mode then
    TrayIcon.IconIndex := mode;
end;

procedure TmainForm.memoinClick(Sender: TObject);
begin
  MigIcon(0);
end;

procedure TmainForm.MemoinClearClick(Sender: TObject);
begin
  memoin.clear;
  memoin.format;
  SetOwnFont;
end;

procedure TmainForm.ScrollMenuClick(Sender: TObject);
begin
  Setup.autoscroll := not Setup.autoscroll;
  if (Setup.autoscroll) and (PageControl1.ActivePageIndex >= 0) then
  begin
    Channels.Channel[PageControl1.activepage.caption].GoEnd;
  end;
end;

procedure TmainForm.OnoffusersMenuClick(Sender: TObject);
begin
  Setup.showOffline := not Setup.showOffline;
  user_box.UpdateBox(true);
end;

procedure TmainForm.bLangClick(Sender: TObject);
const
  en = 'qwertyuiop[]asdfghjkl;''zxcvbnm,./';
  ru = 'йцукенгшщзхъфывапролджэячсмитьбю.,';
var
  txt: string;
  i, ps1, ps2: Integer;
begin
  if not memoin.SelectionExists then
  begin
    memoin.Selectall;
    txt := memoin.getseltext;
    memoin.Deselect;
  end
  else
    txt := memoin.getseltext;
  for i := 1 to length(txt) do
  begin
    ps1 := Pos(txt[i], en);
    ps2 := Pos(txt[i], ru);
    if ps1 <> 0 then
      txt[i] := ru[ps1]
    else if ps2 <> 0 then
      txt[i] := en[ps2]
  end;
  if not memoin.SelectionExists then
    memoin.SetCurrentItemText(txt)
  else
    memoin.InsertText(txt);
end;

procedure TmainForm.RefreshMenuClick(Sender: TObject);
begin
  SaveTraf;
  Channels.Channel[PageControl1.activepage.caption].Reload(Setup.autoscroll);
end;

procedure TmainForm.PageControl1DrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect;
  Active: boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

procedure TmainForm.BlockUserMnuClick(Sender: TObject);
var
  us, ip: string;
begin
  if messagedlg(lang.get('block')+' '+user_box.SelUser+'?', mtconfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  us := user_box.SelUser;
  ip := user_list.Getip(us);
  if (ip > '') and (Setup.BlackList.IndexOf(ip) = -1) then
  begin
    Setup.blacklist.Add(ip);
    user_list.SetOFFLINE(ip);
    user_box.UpdateBox();
  end;
end;

procedure TmainForm.DelUserMnuClick(Sender: TObject);
var
  us, ip: string;
begin
  if user_box.SelUser = '' then
    exit;
  if messagedlg(lang.get('delete')+' '+user_box.SelUser+'?', mtconfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  us := user_box.SelUser;
  ip := user_list.Getip(us);
  if ip > '' then
  begin
    user_list.DeleteUser(ip);
    user_box.UpdateBox();
  end;
end;

procedure TmainForm.NewUserMnuClick(Sender: TObject);
var
  ad: boolean;
  uu, ip: string;
  i: Integer;
begin
  fmNewUser.Label_nik.caption := lang.get('nick');
  fmNewUser.Label_ip.caption := lang.get('ip');
  fmNewUser.Edit1.clear;
  fmNewUser.Edit2.clear;
  fmNewUser.ShowModal;
  if fmNewUser.ModalResult = mrOK then
  begin
    uu := trim(fmNewUser.Edit1.text);
    ip := trim(fmNewUser.Edit2.text);
    // проверим нет ли такого уже
    ad := false;
    for i := 0 to user_list.Count - 1 do
    begin
      if (ansiuppercase(user_list[i].name) = ansiuppercase(uu)) or (user_list[i].ip = ip) then
      begin
        if messagedlg(uu + ' ' + lang.get('overwrite'), mtconfirmation, [mbYes, mbNo], 0) <> mrYes then
          exit;
        user_list[i].name := uu;
        user_list[i].ip := ip;
        ad := true;
      end;
    end;
    if not ad then
    begin
      // добавим в конец списка
      user_list.AddUser(uu, ip);
      user_box.UpdateBox();
    end;
  end;
end;

procedure TmainForm.PopupUserlistPopup(Sender: TObject);
begin
  if Setup.showOffline then
    OnoffusersMenu.caption := lang.get('show_off') + ': ' + lang.get('on')
  else
    OnoffusersMenu.caption := lang.get('show_off') + ': ' + lang.get('off');
end;

// перетаскивание (не броузер)
procedure TmainForm.memoinDropFiles(Sender: TCustomRichViewEdit; Files: TStrings; var FileAction: TRVDropFileAction;
  var DoDefault: boolean);
var
  ext: string;
  i: Integer;
  file_name: string;
begin
  if (Files <> nil) then
  begin
    for i := 0 to Files.Count - 1 do
    begin
      file_name := uppercase(Files.Strings[i]);
      ext := uppercase(extractfileext(file_name));
      if (ext = '.GIF') or (ext = '.PNG') or (ext = '.JPG') or (ext = '.JPEG') or (ext = '.BMP') or (ext = '.ICO') then
        InsertFileImage(file_name)
      else
        InsertFileAsIcon(file_name); // вставим файлы в виде иконок
    end;
    DoDefault := false;
  end;
end;

// тут перетаскивание в мемо gif, jpg, png из браузера
procedure TmainForm.memoinOleDrop(Sender: TCustomRichView; const DataObject: IDataObject; Shift: TShiftState;
  X, Y: Integer; PossibleDropEffects: TRVOleDropEffects; var DropEffect: TRVOleDropEffect; var DoDefault: boolean);
var
  FDropTarget: TRVDropTarget;
  url: TRVAnsiString;
  bt: TPicture;
begin
  FDropTarget := TRVDropTarget.Create(nil);
  if FDropTarget.HasFormat(DataObject, CF_TEXT) and FDropTarget.GetAsTextA(DataObject, CF_TEXT, url) then
  begin
    DoDefault := InsertFromBrowser(url);
  end;
  if (DoDefault) and (FDropTarget.HasFormat(DataObject, CF_DIB)) then
  begin
    bt := TPicture.Create;
    bt.Graphic := FDropTarget.GetAsBitmap(DataObject, true);
    memoin.InsertPicture('', bt.Graphic, rvvaBaseline);
    DoDefault := false;
  end;
end;

procedure TmainForm.memoinDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.Assign(TImage(Source).picture.bitmap);
  memoin.InsertPicture('', bmp, rvvaBaseline);
end;

Procedure TmainForm.AutoAddUnknown;
begin
  if (setup.autoconnect) and (unknown_user.count <> 0) then
  begin
    UnknownAddClick(unknown_user.Strings[0], true);
    log('auto add');
  end;
end;

Procedure TmainForm.LoadButtons;
var
  Size: Integer;
  btop: Integer;
begin
  PanelTools1.Height := 34;
  Size := 30;
  btop := 0;
  if not assigned(FontSetupButton) then
  begin
    FontSetupButton := TspeedButton.Create(PanelTools1);
    FontSetupButton.Parent := PanelTools1;
  end;
  FontSetupButton.Flat := False;
  FontSetupButton.left := 20;
  FontSetupButton.top := btop;
  FontSetupButton.Height := size;
  FontSetupButton.Width := Trunc(1.2*size);
  FontSetupbutton.caption := 'Aa';
  FontSetupButton.OnClick := FontSetupbuttonClick;
  FontSetupButton.OnMouseDown := FontButtonMouseDown;
  FontSetupbutton.Refresh;
  if not assigned(SmileBtn3) then
  begin
    SmileBtn3 := TspeedButton.Create(PanelTools1);
    SmileBtn3.Parent := PanelTools1;
  end;
  SmileBtn3.Flat := False;
  SmileBtn3.left := (PanelTools1.Width div 2) - (2 * size);
  SmileBtn3.top := btop;
  SmileBtn3.Height := size;
  SmileBtn3.Width := size;
  SmileBtn3.Glyph.Canvas.Brush.Color := clBtnFace;
  SmileBtn3.Glyph.Canvas.FillRect(SmileBtn3.ClientRect);
  ButtonList2.GetBitmap(5, SmileBtn3.Glyph);
  SmileBtn3.OnClick := SmileBtn3Click;
  SmileBtn3.Refresh;

  if not assigned(CitBtn) then
  begin
    CitBtn := TspeedButton.Create(PanelTools1);
    CitBtn.Parent := PanelTools1;
  end;
  CitBtn.Flat := False;
  CitBtn.left := SmileBtn3.left + SmileBtn3.width + 6;
  CitBtn.top := btop;
  CitBtn.Height := size;
  CitBtn.Width := size;
  CitBtn.Glyph.Canvas.Brush.Color := clBtnFace;
  CitBtn.Glyph.Canvas.FillRect(CitBtn.ClientRect);
  ButtonList2.GetBitmap(2, CitBtn.Glyph);
  CitBtn.OnClick := CitBtnClick;

  if not assigned(FileBtn) then
  begin
    FileBtn := TspeedButton.Create(PanelTools1);
    FileBtn.Parent := PanelTools1;
  end;
  FileBtn.Flat := False;
  FileBtn.left := CitBtn.left + CitBtn.width + 6;
  FileBtn.top := btop;
  FileBtn.Height :=size;
  FileBtn.Width := size;
  FileBtn.Glyph.Canvas.Brush.Color := clBtnFace;
  FileBtn.Glyph.Canvas.FillRect(FileBtn.ClientRect);
  ButtonList2.GetBitmap(4, FileBtn.Glyph);
  FileBtn.OnClick := FileBtnClick;

  if not assigned(ClearBtn) then
  begin
    ClearBtn := TspeedButton.Create(PanelTools1);
    ClearBtn.Parent := PanelTools1;
  end;
  ClearBtn.Flat := False;
  ClearBtn.left := FileBtn.left + FileBtn.width + 6;
  ClearBtn.top := btop;
  ClearBtn.Height := size;
  ClearBtn.Width := size;
  ClearBtn.Glyph.Canvas.Brush.Color := clBtnFace;
  ClearBtn.Glyph.Canvas.FillRect(ClearBtn.ClientRect);
  ButtonList2.GetBitmap(3, ClearBtn.Glyph);
  ClearBtn.PopupMenu := ClearallMenu3;
  ClearBtn.OnClick := ClearBtnClick;

  if not assigned(SendBtn) then
  begin
    SendBtn := TspeedButton.Create(PanelTools1);
    SendBtn.Parent := PanelTools1;
  end;
  Sendbtn.Flat := False;
  SendBtn.top := btop;
  SendBtn.Height := size;
  SendBtn.Width := Trunc(1.2*size);
  SendBtn.Glyph.Canvas.Brush.Color := clBtnFace;
  SendBtn.Glyph.Canvas.FillRect(SendBtn.ClientRect);
  ButtonList2.GetBitmap(6, SendBtn.Glyph);
  SendBtn.OnClick := SendBtnClick;
  // мал кнопки со смайликами
  if Setup.quickSmiles then
  begin
    if not assigned(SmileBtn2) then
    begin
      SmileBtn2 := TspeedButton.Create(PanelTools1);
      SmileBtn2.Parent := PanelTools1;
    end;
    SmileBtn2.Flat := false;
    SmileBtn2.visible := true;
    SmileBtn2.top := btop;
    SmileBtn2.left := SmileBtn3.left - Size - 6;
    SmileBtn2.Height := size;
    SmileBtn2.Width := size;
    ButtonList2.GetBitmap(1, SmileBtn2.Glyph);
    SmileBtn2.OnClick := SmileBtn2Click;

    if not assigned(SmileBtn1) then
    begin
      SmileBtn1 := TspeedButton.Create(PanelTools1);
      SmileBtn1.Parent := PanelTools1;
    end;
    SmileBtn1.Flat := False;
    SmileBtn1.visible := true;
    SmileBtn1.top := btop;
    SmileBtn1.left := SmileBtn2.left - Size - 6;
    SmileBtn1.Height := size;
    SmileBtn1.Width := size;
    ButtonList2.GetBitmap(0, SmileBtn1.Glyph);
    SmileBtn1.OnClick := SmileBtn1Click;
  end
  else
  begin
    if not assigned(SmileBtn2) then
    begin
      SmileBtn2 := TspeedButton.Create(PanelTools1);
      SmileBtn2.Parent := PanelTools1;
      SmileBtn2.Flat := False;
    end;
    SmileBtn2.visible := false;
    if not assigned(SmileBtn1) then
    begin
      SmileBtn1 := TspeedButton.Create(PanelTools1);
      SmileBtn1.Parent := PanelTools1;
      SmileBtn1.Flat := false;
    end;
    SmileBtn1.visible := false;
  end;
  CitBtn.hint := lang.get('cit_hint');
  FileBtn.hint := lang.get('file_hint');
  ClearBtn.hint := lang.get('clear_hint');
  SendBtn.hint := lang.get('send_hint');
  FontSetupButton.hint := lang.get('font_hint');
  SmileBtn3.hint := lang.get('smile_hint');

  application.processmessages;
end;

procedure TmainForm.MainMenuClick(Sender: TObject);
begin
end;

/// API ////////////////////////
procedure TmainForm.SendFileV2(ip, FileName:widestring); stdcall;
var
 sl: TStringList;
begin
  sl := TStringList.Create;
  sl.Add(ip);
  NetWork.SendGroupFile(PERSONAL_CH, '', sl, 1, FileName);
  myFreeAndNil(sl);
end;

function TmainForm.GetIP: widestring; stdcall;
begin
  result := widestring(Setup.myIP);
end;

Procedure TmainForm.SendRAW(package: widestring); stdcall;
begin
  NetWork.SendUDPPKG(package);
end;

function TmainForm.FindPlugin(name:widestring):boolean; stdcall;
begin
  result := api_works.FindPlugin(name);
end;

Procedure TmainForm.TCPSend(ip, package:widestring); stdcall;
begin
  NetWork.TCPsend(ip, package, false, true);
end;


function TmainForm.plugin_panel(plugin_name: widestring): widestring; stdcall;
begin
  result := api_works.plugin_panel(plugin_name);
end;

function TmainForm.plugin_button(plugin_name: WideString): WideString; stdcall;
begin
  result := api_works.plugin_button(plugin_name);
end;

procedure TmainForm.SetCaption(plugin_name, control_name, text: widestring); stdcall;
begin
  api_works.SetCaption(plugin_name, control_name, text);
end;

procedure TmainForm.SetText(plugin_name, control_name, text: widestring); stdcall;
begin
  api_works.SetText(plugin_name, control_name, text);
end;

function TmainForm.create_control(plugin_name, type_name, parent_name: widestring): widestring; stdcall;
begin
  result := api_works.create_control(plugin_name, type_name, parent_name);
end;

function TmainForm.getvar(name: widestring): variant; stdcall;
begin
  result := api_works.getvar(name);
end;

procedure TmainForm.SetVar(name: widestring; value: variant); stdcall;
begin
  api_works.SetVar(name, value);
end;

procedure TmainForm.addToPopup(plugin_name, control_name, caption: widestring; proc: pointer); stdcall;
begin
  api_works.addToPopup(plugin_name, control_name, caption, proc);
end;

function TmainForm.GetPluginHeight: Integer; stdcall;
begin
  result := api_works.GetPluginHeight;
end;


// высота
procedure TmainForm.SetWindowHeight(plugin_name, control_name: widestring; Height: Integer); stdcall;
begin
  api_works.SetWindowHeight(plugin_name, control_name, Height);
end;

// ширина
procedure TmainForm.SetWindowWidth(plugin_name, control_name: widestring; width: Integer); stdcall;
begin
  api_works.SetWindowWidth(plugin_name, control_name, width);
end;

function Tmainform.GetUserList: widestring; stdcall;
var
 ss:string;
begin
  ss := api_works.GetUserList;
  result := widestring(ss);
end;

function Tmainform.GetPort: integer; stdcall;
begin
  result := api_works.GetPort;
end;

function Tmainform.GetUserStatus(ip:widestring):integer; stdcall;
begin
  result := api_works.GetUserStatus(ip);
end;

// выравнивание
procedure TmainForm.SetAlign(plugin_name, control_name: widestring; Align: Talign); stdcall;
begin
  api_works.SetAlign(plugin_name, control_name, Align);
end;

// положение и размеры
procedure TmainForm.SetWindow(plugin_name, control_name: widestring; left, top, width, Height: Integer); stdcall;
begin
  api_works.SetWindow(plugin_name, control_name, left, top, width, Height);
end;

// видимость
procedure TmainForm.SetVisible(plugin_name, control_name: widestring; visible: boolean); stdcall;
begin
  api_works.SetVisible(plugin_name, control_name, visible);
end;

// назначение onclick
procedure TmainForm.SetOnclick(plugin_name, control_name: WideString; proc: pointer); stdcall;
begin
  api_works.SetOnclick(plugin_name, control_name, proc);
end;

// вставить текст в поле ввода
procedure TmainForm.InsertText(text: widestring); stdcall;
begin
  api_works.InsertText(text);
end;

// вставить картинку в поле ввода
Procedure TmainForm.InsertImage(image: pointer); stdcall;
begin
  api_works.InsertImage(image);
end;

// картинку на кнопку
Procedure TmainForm.SetGlyphStream(plugin_name, control_name: widestring; image: pointer); stdcall;
begin
  api_works.SetGlyphStream(plugin_name, control_name, image);
end;

// картинку на кнопку
Procedure TmainForm.SetGlyphFile(plugin_name, control_name, image: WideString); stdcall;
begin
  api_works.SetGlyphFile(plugin_name, control_name, image);
end;

function TmainForm.GetFreePos: Integer; stdcall;
begin
  result := api_works.GetFreePos;
end;

Procedure TmainForm.SetFreePos(ps: Integer); stdcall;
begin
  api_works.SetFreePos(ps);
end;

procedure TmainForm.SetChecked(plugin_name, control_name: widestring; check: boolean); stdcall;
begin
  api_works.SetChecked(plugin_name, control_name, check);
end;

function TmainForm.GetText(plugin_name, control_name: widestring): widestring; stdcall;
begin
  result := api_works.GetText(plugin_name, control_name);
end;

procedure TmainForm.SetFlat(plugin_name, control_name: widestring; flats: boolean); stdcall;
begin
  api_works.SetFlat(plugin_name, control_name, flats);
end;

function TmainForm.GetChecked(plugin_name, control_name: widestring): boolean; stdcall;
begin
  result := api_works.GetChecked(plugin_name, control_name);
end;

procedure TmainForm.SetOnKeyDown(plugin_name, control_name: widestring; proc: pointer); stdcall;
begin
  api_works.SetOnKeyDown(plugin_name, control_name, proc);
end;

procedure TmainForm.SetHint(plugin_name, control_name, hint_text: widestring); stdcall;
begin
  api_works.SetHint(plugin_name, control_name, hint_text);
end;

function TmainForm.GetApiVer: widestring; stdcall;
begin
  result := api_works.GetApiVer;
end;

function TmainForm.Download(url: widestring): widestring; stdcall;
begin
  result := api_works.Download(url);
end;

function TmainForm.DownloadLocal(url: widestring): widestring; stdcall;
begin
  result := api_works.Download(url);
end;

procedure TmainForm.ShowPage(tab_name, file_name: widestring); stdcall;
begin
  api_works.ShowPage(tab_name, file_name);
end;

function TmainForm.GetInput: widestring; stdcall;
begin
  result := api_works.GetInput;
end;

// deprecated
procedure Tmainform.StartHttp; stdcall;
begin
end;

function Tmainform.GetUserPlugins(ip:widestring):widestring; stdcall;
begin
  result := widestring(user_list[string(ip)].plugins);
end;

function Tmainform.GetSelectedUser:widestring; stdcall;
begin
  result := user_list.GetIP(user_box.SelUser);
end;

procedure TmainForm.addSimpleMessage(msg:widestring); stdcall;
var
  ch: string;
begin
  ch := lang.Get('green');
  Channels.Channel[ch].AddText('', ch, msg);
end;

initialization

  // ОБЯЗАТЕЛЬНО в секции initialization регистрировать все классы которые выводишь в richedit
  RegisterClass(TjvGifAnimator);
  RegisterClass(TImage);

finalization

end.
