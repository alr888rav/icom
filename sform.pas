unit sform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExStdCtrls, JvCombobox, JvColorCombo,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Imaging.jpeg, Vcl.ComCtrls,
  Vcl.ExtDlgs, Vcl.ImgList, FileCtrl;

type
  Tsetupform = class(TForm)
    ScrollBox1: TScrollBox;
    PageControl2: TPageControl;
    MyTabSheet: TTabSheet;
    Panel14: TPanel;
    Panel15: TPanel;
    Image1: TImage;
    LoadAvBtn: TSpeedButton;
    DelAvBtn: TSpeedButton;
    Panel16: TPanel;
    Panel17: TPanel;
    NickLabel: TLabel;
    Edit_Nick: TEdit;
    Panel18: TPanel;
    Panel19: TPanel;
    BirthdayLabel: TLabel;
    Panel20: TPanel;
    Panel21: TPanel;
    mgRadio1: TRadioButton;
    mgRadio2: TRadioButton;
    InterfaceTabSheet: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    CheckquickSmiles: TCheckBox;
    Panel3: TPanel;
    Panel5: TPanel;
    PagesPosLabel: TLabel;
    PagesIconLabel: TLabel;
    ComboTabs: TComboBox;
    ComboIcons: TComboBox;
    CheckActPage: TCheckBox;
    CheckRGB: TCheckBox;
    CheckPagesOneLine: TCheckBox;
    Panel12: TPanel;
    Panel13: TPanel;
    MemoColor: TControlBar;
    Panel7: TPanel;
    CheckLines: TCheckBox;
    CheckInfo: TCheckBox;
    CheckNick: TCheckBox;
    CheckOffline: TCheckBox;
    Panel6: TPanel;
    CommonSetupTabSheet: TTabSheet;
    Panel26: TPanel;
    Panel27: TPanel;
    ShowIcomLabel: TLabel;
    Combo_snap: TComboBox;
    Edit_snap: TEdit;
    Panel32: TPanel;
    Panel33: TPanel;
    CheckDelete: TCheckBox;
    CheckClosePage: TCheckBox;
    CheckDelMsg: TCheckBox;
    ContactsTabSheet: TTabSheet;
    uListPanel: TPanel;
    UserTitlePanel: TPanel;
    DelUserButton: TSpeedButton;
    AddUserButton: TSpeedButton;
    UpBtn: TSpeedButton;
    DownBtn: TSpeedButton;
    SetupUserBox: TListBox;
    Panel40: TPanel;
    UserBlockTitle: TPanel;
    BlackAdd: TSpeedButton;
    BlackDel: TSpeedButton;
    BlackBox: TListBox;
    TabSheet1: TTabSheet;
    Panel22: TPanel;
    Panel23: TPanel;
    MyFontNameLabel: TLabel;
    MyFontColorLabel: TLabel;
    MyFontAttLabel: TLabel;
    sWideFontBtn: TSpeedButton;
    sItalicFontBtn: TSpeedButton;
    MyFontSizeLabel: TLabel;
    Combo_font: TJvFontComboBox;
    PanelFontColor2: TControlBar;
    ComboBox_size2: TComboBox;
    Panel10: TPanel;
    Panel11: TPanel;
    SysfontNameLabel: TLabel;
    SysFontSizeLabel: TLabel;
    sys_font: TJvFontComboBox;
    sys_font_size: TComboBox;
    PanelSysColor: TControlBar;
    TabSheet3: TTabSheet;
    Panel30: TPanel;
    Panel42: TPanel;
    Check_trayonoff: TCheckBox;
    Check_ballon: TCheckBox;
    TabSheet4: TTabSheet;
    Panel38: TPanel;
    Panel39: TPanel;
    playBtn: TSpeedButton;
    sSpeedButton7: TSpeedButton;
    sSpeedButton8: TSpeedButton;
    sSpeedButton9: TSpeedButton;
    sSpeedButton10: TSpeedButton;
    sSpeedButton11: TSpeedButton;
    wavBtn: TSpeedButton;
    sSpeedButton2: TSpeedButton;
    sSpeedButton3: TSpeedButton;
    sSpeedButton4: TSpeedButton;
    sSpeedButton5: TSpeedButton;
    sSpeedButton6: TSpeedButton;
    CheckSound: TCheckBox;
    Check_s1: TCheckBox;
    Check_s2: TCheckBox;
    Check_s3: TCheckBox;
    Check_s4: TCheckBox;
    Check_s5: TCheckBox;
    Check_s6: TCheckBox;
    Edit_s1: TEdit;
    Edit_s2: TEdit;
    Edit_s3: TEdit;
    Edit_s4: TEdit;
    Edit_s5: TEdit;
    Edit_s6: TEdit;
    TabSheet5: TTabSheet;
    Panel8: TPanel;
    Panel9: TPanel;
    StartLangLabel: TLabel;
    IntLangLabel: TLabel;
    CheckWarnLang: TCheckBox;
    ComboLang: TComboBox;
    ComboLang2: TComboBox;
    TabSheet6: TTabSheet;
    Panel28: TPanel;
    Panel29: TPanel;
    DelBtnLabel: TLabel;
    CheckZoom: TCheckBox;
    ComboZoom: TComboBox;
    ComboDel: TComboBox;
    CheckCollapse: TCheckBox;
    CheckFree: TCheckBox;
    CheckBtnQuote: TCheckBox;
    TabSheet7: TTabSheet;
    Panel24: TPanel;
    Panel25: TPanel;
    HomeDirBtn: TSpeedButton;
    Edit_path: TEdit;
    TabSheet2: TTabSheet;
    Panel4: TPanel;
    Panel31: TPanel;
    IdleLabel: TLabel;
    CheckExit: TCheckBox;
    CheckTraf: TCheckBox;
    Edit_Exit: TEdit;
    Edit_traf: TEdit;
    CheckAutoConnect: TCheckBox;
    Edit_idle: TEdit;
    CheckStopTray: TCheckBox;
    OpenPictureDialog1: TOpenPictureDialog;
    DefaultAvatar: TImage;
    ColorDialog1: TColorDialog;
    OpenDialog1: TOpenDialog;
    SetupList: TImageList;
    Panel34: TPanel;
    Panel35: TPanel;
    Label_ip: TLabel;
    ComboIP: TComboBox;
    Label_port: TLabel;
    Edit_port: TEdit;
    CheckSortMode: TCheckBox;
    CheckOfflineEnd: TCheckBox;
    CheckIcon: TRadioGroup;
    Edit_dr: TEdit;
    SysFontColorLabel: TLabel;
    RadioNot1: TRadioButton;
    RadioNot2: TRadioButton;
    Panel41: TPanel;
    Panel43: TPanel;
    CheckSmiles: TCheckBox;
    Label1: TLabel;
    CheckSaveTraf: TCheckBox;
    lbl1: TLabel;
    procedure LoadAvBtnClick(Sender: TObject);
    procedure DelAvBtnClick(Sender: TObject);
    Procedure LoadAvatar;
    procedure MemoColorClick(Sender: TObject);
    procedure Combo_fontChange(Sender: TObject);
    procedure sWideFontBtnClick(Sender: TObject);
    procedure ComboBox_size2Change(Sender: TObject);
    procedure HomeDirBtnClick(Sender: TObject);
    procedure playBtnClick(Sender: TObject);
    procedure wavBtnClick(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DownBtnClick(Sender: TObject);
    procedure AddUserButtonClick(Sender: TObject);
    procedure DelUserButtonClick(Sender: TObject);
    procedure BlackAddClick(Sender: TObject);
    procedure BlackDelClick(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure BlackBoxClick(Sender: TObject);
    procedure BlackBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure OkBtnClick(Sender: TObject);
    procedure GetSetup;
    procedure PanelFontColor2Click(Sender: TObject);
    procedure MemoColorPaint(Sender: TObject);
    procedure PanelFontColor2Paint(Sender: TObject);
    procedure sys_font_sizeChange(Sender: TObject);
    procedure PanelSysColorClick(Sender: TObject);
    procedure PanelSysColorPaint(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    Procedure SetupButtons;
    procedure FormActivate(Sender: TObject);
    procedure SetupUserBoxClick(Sender: TObject);
    procedure SetupUserBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure PageControl2DrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure sItalicFontBtnClick(Sender: TObject);
    procedure sys_fontChange(Sender: TObject);
private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  setupform: Tsetupform;
  // кнопки дл€ сетапа
  okb, cnb: TBitBtn;

implementation

{$R *.dfm}

uses Global, ulog, commonlib, MAIN, newuser;

procedure TSetupForm.SetupUserBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  SetupUserBox.Canvas.FillRect(Rect);
  SetupUserBox.Canvas.TextOut(Rect.left + 2, Rect.top + 2, copy(SetupUserBox.Items[Index], 1,
    Pos('/', SetupUserBox.Items[Index]) - 1));
end;

procedure TSetupForm.SetupUserBoxClick(Sender: TObject);
begin
  if ScrollBox1.VertScrollBar.Position <> 0 then
    ScrollBox1.VertScrollBar.Position := 0;
end;

// кнопки сохр-отмена настроек
Procedure TSetupForm.SetupButtons;
begin
  okb := TBitbtn.Create(PageControl2);
  okb.Parent := PageControl2;
  okb.left := 10;
  okb.top := 400;
  okb.width := 95;
  okb.Height := 25;
  okb.OnClick := OkBtnClick;
  okb.Refresh;

  cnb := TBitBtn.Create(PageControl2);
  cnb.Parent := PageControl2;
  cnb.left := 10;
  cnb.top := 440;
  cnb.width := 95;
  cnb.Height := 25;
  cnb.OnClick := CancelBtnClick;
  cnb.Refresh;
end;

// ¬ернем настройки
procedure TSetupForm.CancelBtnClick(Sender: TObject);
begin
  GetSetup;
end;

procedure TSetupForm.PanelSysColorPaint(Sender: TObject);
begin
  with PanelSysColor do
  begin
    Canvas.Lock;
    Canvas.Brush.color := MemoColor.color;
    Canvas.FillRect(PanelSysColor.ClientRect);
    Canvas.TextOut(70, 0, '[Abc]');
    Canvas.Unlock;
  end;
end;

procedure TSetupForm.PanelSysColorClick(Sender: TObject);
begin
  ColorDialog1.color := Setup.sysFont.color;
  if ColorDialog1.Execute then
    PanelSysColor.Canvas.font.color := ColorDialog1.color;
  PanelSysColor.Refresh;
end;

procedure Tsetupform.sys_fontChange(Sender: TObject);
begin
  PanelsysColor.canvas.font.Name := sys_font.FontName;
  PanelSysColor.Refresh;
end;

procedure TSetupForm.sys_font_sizeChange(Sender: TObject);
begin
  PanelsysColor.canvas.font.Size := strtoint(sys_font_size.text);
  PanelSysColor.Refresh;
end;

procedure TSetupForm.PanelFontColor2Paint(Sender: TObject);
begin
  with PanelFontColor2 do
  begin
    Canvas.Lock;
    Canvas.Brush.color := MemoColor.color;
    Canvas.FillRect(PanelFontColor2.ClientRect);
    Canvas.TextOut(70, 0, 'Abc');
    Canvas.Unlock;
  end;
end;

procedure TSetupForm.MemoColorPaint(Sender: TObject);
begin
  with MemoColor do
  begin
    Canvas.Lock;
    Canvas.Brush.color := MemoColor.color;
    Canvas.FillRect(MemoColor.ClientRect);
    // вывод стилем canvas.font
    Canvas.font := Setup.myFont;
    Canvas.TextOut(110, 2, 'Abc');
    Canvas.Unlock;
  end;
end;

procedure TSetupForm.PanelFontColor2Click(Sender: TObject);
begin
  ColorDialog1.color := Setup.myFont.color;
  if ColorDialog1.Execute then
  begin
    PanelFontColor2.Canvas.font.color := ColorDialog1.color;
  end;
  PanelFontColor2.Repaint;
end;

// отобразить настройки
procedure TSetupForm.GetSetup;
var
  i: Integer;
  img: TJpegImage;
  sr: TsearchRec;
begin
  okb.Caption := lang.Get('save');
  cnb.Caption := lang.Get('cancel');
  PageControl2.ActivePageIndex := 0;
  ScrollBox1.VertScrollBar.Position := 0;

  CheckStopTray.Checked := Setup.stoptray;

  CheckSaveTraf.Checked := Setup.saveTraf;
  CheckSmiles.Checked := Setup.closeSmiles;
  CheckBtnQuote.Checked := Setup.quotebtn;
  CheckAutoConnect.Checked := Setup.autoconnect;
  CheckquickSmiles.checked := Setup.quickSmiles;
  CheckClosePage.checked := Setup.confirmclosepage;
  CheckPagesOneLine.checked := Setup.MultirowPages;
  ComboLang2.clear;
  If findFirst(LangDir + '*.lng', faAnyFile, sr) = 0 then
  begin
    repeat
      ComboLang2.Items.Add(sr.name);
    until FindNext(sr) <> 0;
    FindClose(sr);
    ComboLang2.ItemIndex := 0;
    for i := 0 to ComboLang2.Items.Count - 1 do
      if ansiuppercase(Setup.icomlang) = ansiuppercase(ComboLang2.Items[i]) then
        ComboLang2.ItemIndex := i;
  end
  else
  begin
    ComboLang2.Items.Add(default_lang);
    ComboLang2.ItemIndex := 0;
  end;
  //
  PageControl2.ActivePageIndex := 0;
  edit_dr.text := Setup.dr;
  CheckRGB.checked := Setup.showrgb;
  CheckWarnLang.checked := Setup.warnLang;
  ComboLang.ItemIndex := Setup.Startlang;
  Check_trayonoff.checked := Setup.trayonoff;
  CheckActPage.checked := Setup.actpage;
  CheckFree.checked := Setup.autofree;
  if Setup.male = 0 then
    mgRadio1.checked := true
  else
    mgRadio2.checked := true;
  CheckCollapse.checked := Setup.Collapselong;
  CheckInfo.checked := Setup.showinfo;
  CheckTraf.checked := Setup.checktraf;
  CheckExit.checked := Setup.checkexit;
  Edit_idle.text := inttostr(Setup.idlemax);
  Edit_Exit.text := inttostr(Setup.idleexit);
  Edit_traf.text := inttostr(Setup.traflimit);

  ComboIcons.ItemIndex := Setup.Channelicons;
  ComboTabs.ItemIndex := Setup.tabspos;
  CheckDelMsg.checked := Setup.confirmdelmsg;

  CheckZoom.checked := Setup.zoom;
  ComboZoom.ItemIndex := Setup.zoomMode;
  ComboZoom.Enabled := Setup.zoom;
  ComboDel.ItemIndex := Setup.delbtn;
  Combo_snap.text := Setup.hot1;
  Edit_snap.text := Setup.hot3;

  CheckSound.checked := Setup.soundon;
  Check_s1.checked := Setup.s1on;
  Check_s2.checked := Setup.s2on;
  Check_s3.checked := Setup.s3on;
  Check_s4.checked := Setup.s4on;
  Check_s5.checked := Setup.s5on;
  Check_s6.checked := Setup.s6on;

  Edit_s1.text := Setup.sndonline;
  Edit_s2.text := Setup.sndoffline;
  Edit_s3.text := Setup.sndfile;
  Edit_s4.text := Setup.sndout;
  Edit_s5.text := Setup.sndin;
  Edit_s6.text := Setup.snderror;

  CheckDelete.checked := Setup.confirmdelmsg;
  ComboIP.clear;
  for i := 0 to Setup.localip.Count - 1 do
    ComboIP.Items.Add(Setup.localip.Strings[i]);
  ComboIp.ItemIndex := 0;
  Edit_Nick.text := Setup.Myname;
  edit_port.text := inttostr(Setup.IcomPort);

  CheckNick.checked := Setup.setnick;
  CheckOffline.checked := Setup.showOffline;
  CheckLines.checked := Setup.drawlines;
  CheckSortMode.Checked := Setup.userboxsort;
  CheckOfflineEnd.checked := Setup.OfflineEnd;

  CheckIcon.ItemIndex := Setup.userboxmode;

  if not fileexists(Path + myavatar) then
  begin
    try
      DefaultAvatar.picture.SaveToFile(Path + myavatar);
    except
      on E: Exception do
        log('save def avatar: ' + E.Message);
    end;
  end;
  if fileexists(Path + myavatar) then
  begin
    img := TJpegImage.Create;
    img.LoadFromFile(Path + myavatar);
    Image1.picture.bitmap.Assign(img);
    FreeAndNil(img);
    // аватар
    LoadAvatar;
  end;

  //
  BlackBox.clear;
  for i := 0 to Setup.blacklist.Count - 1 do
  begin
    BlackBox.Items.Add(Setup.blacklist.Strings[i]);
  end;

  // отобразим список пользоваталей
  SetupUserBox.clear;
  for i := 0 to user_list.Count - 1 do
  begin
    SetupUserBox.Items.Add(user_list[i].name + '/' + user_list[i].ip);
  end;

  Check_ballon.checked := Setup.showballon;
  RadioNot1.Checked := not Setup.entermode2;
  RadioNot2.Checked := Setup.entermode2;
  Edit_path.text := Setup.myPath;

  for i := 0 to sys_font.Items.Count - 1 do
  begin
    if sys_font.Items[i] = Setup.sysFont.name then
      sys_font.ItemIndex := i;
  end;
  PanelSysColor.Canvas.Font.Assign(setup.sysFont);
  sys_font.font.name := Setup.sysFont.name;
  for i := 0 to sys_font_size.Items.Count - 1 do
  begin
    if Setup.sysfont.Size >= strtoint(sys_font_size.Items[i]) then
    begin
      sys_font_size.ItemIndex := i;
    end;
  end;

  Combo_font.ItemIndex := mainform.FontComboBox1.ItemIndex;
  PanelFontColor2.color := Setup.Wincolor;
  PanelFontColor2.Canvas.font.Assign(Setup.myFont);

  sWideFontBtn.down := (fsBold in PanelFontColor2.Canvas.font.style);
  sItalicFontBtn.down := (fsItalic in PanelFontColor2.Canvas.font.style);
  ComboBox_size2.ItemIndex := mainform.ComboBox_size.ItemIndex;

  MemoColor.color := Setup.Wincolor;
end;

// сохранить и применить настройки
procedure TSetupForm.OkBtnClick(Sender: TObject);
var
  i: Integer;
  uu, ip: string;
  icom_lang_old: string;
  green_old, blue_old, red_old, setup_old: string;
  ss: string;
  old_width :integer;
  procedure renameRGB;
  var
    i: Integer;
  begin
      for i := 0 to mainForm.PageControl1.PageCount-1 do
      begin
         if lang.isGreen(Trim(mainForm.PageControl1.Pages[i].Caption)) then
           mainForm.PageControl1.Pages[i].Caption := lang.get('green')+'      '
         else if lang.isBlue(Trim(mainForm.PageControl1.Pages[i].Caption)) then
           mainForm.PageControl1.Pages[i].Caption := lang.get('blue')+'      '
         else if lang.isRed(Trim(mainForm.PageControl1.Pages[i].Caption)) then
           mainForm.PageControl1.Pages[i].Caption := lang.get('red')+'      ';
      end;
      for i:= 0 to Channels.Count-1 do
      begin
         if lang.isGreen(Channels.getChannel(i).Name) then
           Channels.getChannel(i).Name := lang.get('green')
         else if lang.isBlue(Channels.getChannel(i).Name) then
           Channels.getChannel(i).Name := lang.get('blue')
         else if lang.isRed(Channels.getChannel(i).Name) then
           Channels.getChannel(i).Name := lang.get('red');
      end;
  end;
begin
  old_width := mainform.panel_user_box.width;
  try
    main.inUpdate := true;
    icom_lang_old := Setup.icomlang;
    green_old := lang.get('green');
    blue_old := lang.get('blue');
    red_old := lang.get('red');
    setup_old := lang.get('setup');
    okb.Enabled := false;
    Setup.dr := edit_dr.Text;
    unknown_user.clear;

    Setup.saveTraf := CheckSaveTraf.Checked;
    Setup.closeSmiles :=  CheckSmiles.Checked;
    Setup.stoptray := CheckStopTray.Checked;

    Setup.quotebtn := CheckBtnQuote.Checked;
    Setup.autoconnect := CheckAutoConnect.Checked;
    Setup.quickSmiles := CheckquickSmiles.checked;
    Setup.confirmclosepage := CheckClosePage.checked;
    Setup.MultirowPages := CheckPagesOneLine.checked;
    Setup.icomlang := ComboLang2.text;
    Setup.showrgb := CheckRGB.checked;
    Setup.warnLang := CheckWarnLang.checked;
    Setup.Startlang := ComboLang.ItemIndex;
    Setup.actpage := CheckActPage.checked;
    Setup.autofree := CheckFree.checked;
    if mgRadio1.checked then
      Setup.male := 0
    else
      Setup.male := 1;
    Setup.Collapselong := CheckCollapse.checked;
    Setup.showinfo := CheckInfo.checked;
    Setup.trayonoff := Check_trayonoff.checked;

    Setup.checktraf := CheckTraf.checked;
    Setup.checkexit := CheckExit.checked;
    Setup.idlemax := toint(Edit_idle.text);
    Setup.idleexit := toint(Edit_Exit.text);
    Setup.traflimit := toint(Edit_traf.text);

    Setup.Channelicons := ComboIcons.ItemIndex;
    CheckZoom.Enabled := true;
    ComboZoom.Enabled := true;
    Setup.tabspos := ComboTabs.ItemIndex;
    Setup.confirmdelmsg := CheckDelMsg.checked;

    Setup.delbtn := ComboDel.ItemIndex;

    Setup.zoom := CheckZoom.checked;
    Setup.zoomMode := ComboZoom.ItemIndex;

    Setup.soundon := CheckSound.checked;
    Setup.s1on := Check_s1.checked;
    Setup.s2on := Check_s2.checked;
    Setup.s3on := Check_s3.checked;
    Setup.s4on := Check_s4.checked;
    Setup.s5on := Check_s5.checked;
    Setup.s6on := Check_s6.checked;

    Setup.sndonline := Edit_s1.text;
    Setup.sndoffline := Edit_s2.text;
    Setup.sndfile := Edit_s3.text;
    Setup.sndout := Edit_s4.text;
    Setup.sndin := Edit_s5.text;
    Setup.snderror := Edit_s6.text;

    Setup.hot1 := Combo_snap.text;
    Setup.hot3 := Edit_snap.text;
    Setup.confirmdelete := CheckDelete.checked;
    Setup.setnick := CheckNick.checked;
    Setup.userboxsort := CheckSortMode.Checked;
    Setup.OfflineEnd := CheckOfflineEnd.checked;

    Setup.showOffline := CheckOffline.checked;
    Setup.drawlines := CheckLines.checked;
    // user list
    Setup.userboxmode := CheckIcon.ItemIndex;

    Setup.showballon := Check_ballon.checked;
    Setup.entermode2 := not Radionot1.Checked;
    Setup.myPath := Edit_path.text;

    mainform.FontComboBox1.ItemIndex := Combo_font.ItemIndex;

    mainform.PanelFontColor.font := PanelFontColor2.Canvas.font;
    mainform.PanelFontColor.Repaint;

    mainform.WideFontBtn.down := sWideFontBtn.down;
    mainform.ItalicFontBtn.down := sItalicFontBtn.down;
    mainform.ComboBox_size.ItemIndex := ComboBox_size2.ItemIndex;

    Setup.myFont.Assign(PanelFontColor2.Canvas.font);

    if sWideFontBtn.down then
      Setup.myFont.style := [fsBold]
    else
      Setup.myFont.style := [];
    if sItalicFontBtn.down then
      Setup.myFont.style := Setup.myFont.style + [fsItalic];

    Setup.sysFont.Assign(PanelSysColor.Canvas.Font);

    Setup.Wincolor := MemoColor.color;

    Edit_Nick.text := delsym(Edit_Nick.text);
    // сохраним изменени€ списка
    user_list.clearusers;
    for i := 0 to SetupUserBox.Count - 1 do
    begin
      ss := SetupUserBox.Items[i];
      uu := copy(ss, 1, Pos('/', ss) - 1);
      ip := copy(ss, Pos('/', ss) + 1, length(ss) - Pos('/', ss));
      if (ip > '') and (uu = '') then
        uu := 'Unknown user';
      if (ip > '') and (not testIP(ip)) then
      begin
        showmessage(lang.get('bad_ip') + ' ' + uu + ' ' + ip + ' !');
        exit; // ничего не записываем
      end;
      if NetWork.TestLocalIP(ip) then
      begin
        if Edit_nick.text > '' then
          uu := Edit_nick.text;
        Setup.Myname := uu;
      end;
      user_list.AddUser(uu, ip);
    end;

    Setup.blacklist.clear;
    for i := 0 to BlackBox.Items.Count - 1 do
    begin
      Setup.blacklist.Add(BlackBox.Items[i]);
    end;
    Setup.IcomPort := toint(edit_port.text);

    // применим
    Setup.SaveSetup;

    main.start_time := now; // откл показ подключилс€
    Setup.LoadSetup;
    mainform.ApplySetup;
    // помен€ли €зык - перегрузим данные
    if icom_lang_old <> Setup.icomlang then
    begin
      begin  // order!
        lang.LoadLang(Setup.icomlang);
        renameRGB;
        GetSetup;
      end;
{      // переименуем зел-син-кр-настр
      i := Channels.FindTab(green_old);
      if i >= 0 then
      begin
        mainform.PageControl1.Pages[i].caption := lang.get('green') + '      ';
        Channels.Channel[green_old].Name := lang.get('green');
        Channels.Channel[lang.get('green')].SaveToFile(htmldir + lang.get('green') + '.html');
      end;
      i := Channels.FindTab(blue_old);
      if i >= 0 then
      begin
        mainform.PageControl1.Pages[i].caption := lang.get('blue') + '      ';
        Channels.Channel[blue_old].Name := lang.get('blue');
        Channels.Channel[lang.get('blue')].SaveToFile(htmldir + lang.get('blue') + '.html');
      end
      else
        renamefile(htmldir + blue_old + '.html', htmldir + lang.get('blue') + '.html');

      i := Channels.FindTab(red_old);
      if i >= 0 then
      begin
        mainform.PageControl1.Pages[i].caption := lang.get('red') + '      ';
        Channels.Channel[red_old].Name := lang.get('red');
        Channels.Channel[lang.get('red')].SaveToFile(htmldir + lang.get('red') + '.html');
      end
      else
        renamefile(htmldir + red_old + '.html', htmldir + lang.get('red') + '.html');    }
    end;
    inUpdate := false;
    user_box.UpdateBox(True);
    log('after setup');
    mainform.MySetFocus(mainform.memoin);
  finally
    //mainForm.Rmenu(setup.rmenu);
    mainform.panel_user_box.width := old_width;
    mainform.Timer1sekTimer(nil);
    okb.Enabled := true;
    inUpdate := false;
  end;
end;

procedure TSetupForm.BlackBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  BlackBox.Canvas.FillRect(Rect);
  BlackBox.Canvas.TextOut(Rect.left + 2, Rect.top + 2, user_list.GetNickName(BlackBox.Items[Index]));
end;

procedure TSetupForm.BlackBoxClick(Sender: TObject);
begin
  ScrollBox1.VertScrollBar.Position := 0;
end;

procedure TSetupForm.PageControl2Change(Sender: TObject);
begin
  ScrollBox1.VertScrollBar.Position := 0;
  if PageControl2.ActivePageIndex = 4 then
  begin
    SetupUserBox.color := Setup.Wincolor;
    BlackBox.color := Setup.Wincolor;
  end;
end;

// закладки настроек
procedure TSetupForm.PageControl2DrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect;
  Active: boolean);
var
  bm: TBitmap;
  inactive_color:TColor;
  rt: Trect;
const
 active_color= $D1B499;
begin
  rt := rect;
  if ThemesActive then
    inactive_color := clWindow
  else
    inactive_color := clBtnFace;
  bm := TBitmap.Create;
  try
    Control.Canvas.Brush.style := bsSolid;
    if Active then
    begin
      rt.Right := rt.Right - 1;
      Control.Canvas.brush.color:=Active_color;
      Control.Canvas.fillrect(rt);
    end
    else
    begin
      Control.Canvas.brush.color:=inactive_color;
      rt.Right := rt.Right + 2;
      rt.Top := rt.Top - 3;
      Control.Canvas.fillrect(rt);
    end;
    bm.Transparent := true;
    bm.width := SetupList.width;
    bm.Height := SetupList.Height;
    // так прозрачна€ картинка и под хр и под вин7
    SetupList.Draw(bm.Canvas, 0, 0, TabIndex, dsnormal, itmask);
    SetupList.Draw(bm.Canvas, 0, 0, TabIndex, dsnormal, itimage);

    bm.TransparentColor := bm.Canvas.pixels[1, 1];
    bm.TransparentMode := tmAuto;
    with Control.Canvas do
    begin
      Draw(Rect.left + 4, Rect.top + ((Rect.Bottom - Rect.top - bm.Height) div 2), bm);
      if Active then
        font.color := clBlue
      else
        font.color := clblack;
      Brush.style := bsClear; // прозрачный фон
      TextRect(Rect, Rect.left + bm.width + 10, Rect.top + ((Rect.Bottom - Rect.top) div 2) - 5, TPageControl(Control).Pages[TabIndex].caption);
    end;
  finally
    FreeAndNil(bm);
  end;
end;

procedure TSetupForm.BlackDelClick(Sender: TObject);
begin
  BlackBox.DeleteSelected;
end;

procedure TSetupForm.AddUserButtonClick(Sender: TObject);
begin
  fmNewUser.Label_nik.caption := lang.get('nick');
  fmNewUser.Label_ip.caption := lang.get('ip');
  fmNewUser.Edit1.clear;
  fmNewUser.Edit2.clear;
  fmNewUser.ShowModal;
  if fmNewUser.ModalResult = mrOK then
  begin
    SetupUserBox.Items.Add(fmNewUser.Edit1.text + '/' + fmNewUser.Edit2.text)
  end;
end;

Function GetSelItem(LB: TListBox): Integer;
var
  sel, i: Integer;
begin
  sel := -1;
  if LB.selcount <> 0 then
  begin
    for i := 0 to LB.Items.Count - 1 do
    begin
      if LB.Selected[i] then
        sel := i;
    end;
  end;
  result := sel;
end;

procedure TSetupForm.BlackAddClick(Sender: TObject);
var
  ip: string;
  ss: string;
  sel: Integer;
begin
  if SetupUserBox.selcount <> 0 then
  begin
    sel := GetSelItem(SetupUserBox);
    if sel >= 0 then
    begin
      ss := SetupUserBox.Items[sel];
      ip := copy(ss, Pos('/', ss) + 1, length(ss) - Pos('/', ss));
      if not NetWork.TestLocalIP(ip) then
      begin
        if BlackBox.Items.IndexOf(ip) = -1 then
          BlackBox.Items.Add(ip);
      end;
    end;
  end;
end;

procedure TSetupForm.DelUserButtonClick(Sender: TObject);
var
  sel: Integer;
begin
  if messagedlg(lang.get('delete'), mtconfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  sel := GetSelItem(SetupUserBox);
  if sel >= 0 then
  begin
    if Pos('/', SetupUserBox.Items[sel]) <> 0 then
      NetWork.SendExit;
    SetupUserBox.DeleteSelected;
  end;
end;

procedure TSetupForm.DownBtnClick(Sender: TObject);
var
  sel: Integer;
  Temp: string;
begin
  sel := GetSelItem(SetupUserBox);
  if (sel < 0) or (sel >= SetupUserBox.Items.Count - 1) then
    exit;
  Temp := SetupUserBox.Items[sel];
  SetupUserBox.Items[sel] := SetupUserBox.Items[sel + 1];
  SetupUserBox.Items[sel + 1] := Temp;
  SetupUserBox.Selected[sel] := false;
  SetupUserBox.Selected[sel + 1] := true;
end;

procedure Tsetupform.FormActivate(Sender: TObject);
begin
  ScrollBox1.VertScrollBar.Position := 0;
  ScrollBox1.HorzScrollBar.Position := 0;
  PageControl2.ActivePageIndex := 0;
  // чтобе кнопки (transparent=false) на этих панел€х остались clBtnFace
  Panel15.Color := clWindow;
  Panel19.Color := clWindow;
  Panel23.Color := clWindow;
  Panel39.Color := clWindow;
  Panel25.Color := clWindow;
  // прочитать настройки
  GetSetup;
end;

procedure Tsetupform.FormCreate(Sender: TObject);
begin
  SetupButtons;
end;

procedure TSetupForm.UpBtnClick(Sender: TObject);
var
  sel: Integer;
  Temp: string;
begin
  mainform.delfonts(Combo_font);
  mainform.delfonts(sys_font);
  sel := GetSelItem(SetupUserBox);
  if sel <= 0 then
    exit;
  Temp := SetupUserBox.Items[sel];
  SetupUserBox.Items[sel] := SetupUserBox.Items[sel - 1];
  SetupUserBox.Items[sel - 1] := Temp;
  SetupUserBox.Selected[sel] := false;
  SetupUserBox.Selected[sel - 1] := true;
end;

procedure TSetupForm.wavBtnClick(Sender: TObject);
var
  fn: string;
begin
  OpenDialog1.filter := 'Sounds|*.wav;*.mp3';
  OpenDialog1.FilterIndex := 1;
  case TSpeedButton(Sender).tag of
    1:
      if Edit_s1.text > '' then
        fn := Edit_s1.text;
    2:
      if Edit_s2.text > '' then
        fn := Edit_s2.text;
    3:
      if Edit_s3.text > '' then
        fn := Edit_s3.text;
    4:
      if Edit_s4.text > '' then
        fn := Edit_s4.text;
    5:
      if Edit_s5.text > '' then
        fn := Edit_s5.text;
    6:
      if Edit_s6.text > '' then
        fn := Edit_s6.text;
  end;
  OpenDialog1.FileName := fn;
  OpenDialog1.Initialdir := extractfilepath(fn);
  if OpenDialog1.Execute then
  begin
    case TSpeedButton(Sender).tag of
      1:
        Edit_s1.text := OpenDialog1.FileName;
      2:
        Edit_s2.text := OpenDialog1.FileName;
      3:
        Edit_s3.text := OpenDialog1.FileName;
      4:
        Edit_s4.text := OpenDialog1.FileName;
      5:
        Edit_s5.text := OpenDialog1.FileName;
      6:
        Edit_s6.text := OpenDialog1.FileName;
    end;
  end;
end;

procedure TSetupForm.playBtnClick(Sender: TObject);
begin
  case TSpeedButton(Sender).tag of
    1:
      mysound(Edit_s1.text);
    2:
      mysound(Edit_s2.text);
    3:
      mysound(Edit_s3.text);
    4:
      mysound(Edit_s4.text);
    5:
      mysound(Edit_s5.text);
    6:
      mysound(Edit_s6.text);
  end;
end;

procedure TSetupForm.LoadAvBtnClick(Sender: TObject);
var
  img: TJpegImage;
  h, w: Integer;
  kf: real;
  TmpBmp: TBitmap;
  ARect: TRect;
begin
  OpenPictureDialog1.filter := 'jpeg|*.jpg; *.jpeg';
  OpenPictureDialog1.FilterIndex := 0;
  if OpenPictureDialog1.Execute then
  begin
    img := TJpegImage.Create;
    try
      if fileexists(OpenPictureDialog1.FileName) then
        img.LoadFromFile(OpenPictureDialog1.FileName)
      else
        exit;
      // уменьшим до 100х100
      if (img.Height > 100) or (img.width > 100) then
      begin
        h := img.Height;
        w := img.width;
        if h > w then
          kf := h / 100
        else
          kf := w / 100;
        h := trunc(h / kf);
        w := trunc(w / kf);
        TmpBmp := TBitmap.Create;
        TmpBmp.Height := h;
        TmpBmp.width := w;
        ARect := Rect(0, 0, w, h);
        TmpBmp.Canvas.StretchDraw(ARect, img);
        setupform.Image1.picture.bitmap.Assign(TmpBmp);
        FreeAndNil(TmpBmp);
      end
      else
      begin
        setupform.Image1.picture.bitmap.Assign(img);
      end;
    finally
      FreeAndNil(img);
    end;
    img := TJpegImage.Create;
    try
      img.CompressionQuality := 90;
      img.Assign(setupform.Image1.picture.bitmap);
      img.Compress;
      try
        img.SaveToFile(Path + myavatar);
      except
        on E: Exception do
          log('user load avatar: ' + E.Message);
      end;
    finally
      FreeAndNil(img);
    end;
  end;
end;

procedure TSetupForm.DelAvBtnClick(Sender: TObject);
var
  img: TJpegImage;
begin
  try
    DefaultAvatar.picture.SaveToFile(Path + myavatar);
  except
    on E: Exception do
      log('user delete avatar: ' + E.Message);
  end;
  if fileexists(Path + myavatar) then
  begin
    img := TJpegImage.Create;
    img.LoadFromFile(Path + myavatar);
    Image1.picture.bitmap.Assign(img);
    FreeAndNil(img);
  end;
end;

  // аватарка
Procedure TSetupForm.LoadAvatar;
var
  TmpBmp: TBitmap;
  img: TJpegImage;
begin
  try
    if (fileexists(Path + myavatar)) and (myfilesize(Path + myavatar) = 0) then
      deletefile(Path + myavatar);
    if not fileexists(Path + myavatar) then
      DefaultAvatar.picture.SaveToFile(Path + myavatar)
    else
    begin
      img := TJpegImage.Create;
      img.LoadFromFile(Path + myavatar);
      setupform.Image1.picture.bitmap.Assign(img);
      FreeAndNil(img);
    end;
    // big
    TmpBmp := TBitmap.Create;
    TmpBmp.Transparent := true;
    TmpBmp.Height := setupform.Image1.picture.Height;
    TmpBmp.width := setupform.Image1.picture.width;
    TmpBmp.Canvas.Draw(0, 0, setupform.Image1.picture.Graphic);
    // как jpeg в big
    img := TJpegImage.Create;
    img.Assign(TmpBmp);
    img.CompressionQuality := 80;
    img.Compress;
    img.SaveToFile(CacheDir + inttostr(user_list[Setup.Myip].randId) + '.jpg');
    //user_list[Setup.Myip].big.Assign(img);
    FreeAndNil(img);
    FreeAndNil(TmpBmp);
  except
    on E: Exception do
      log('loadavatar: ' + E.Message);
  end;
end;

procedure TSetupForm.MemoColorClick(Sender: TObject);
begin
  ColorDialog1.color := Setup.Wincolor;
  if ColorDialog1.Execute then
  begin
    MemoColor.color := ColorDialog1.color;
    PanelFontColor2.color := ColorDialog1.color;
    PanelSysColor.color := ColorDialog1.color;
  end;
end;

procedure TSetupForm.Combo_fontChange(Sender: TObject);
begin
  PanelFontColor2.Canvas.font.name := Combo_font.text;
  PanelFontColor2.Repaint;
end;

procedure Tsetupform.sItalicFontBtnClick(Sender: TObject);
begin
  sWideFontBtnClick(Sender);
end;

procedure TSetupForm.sWideFontBtnClick(Sender: TObject);
begin
  if sWideFontBtn.down then
    PanelFontColor2.Canvas.font.style := [fsBold]
  else
    PanelFontColor2.Canvas.font.style := [];
  if sItalicFontBtn.down then
    PanelFontColor2.Canvas.font.style := PanelFontColor2.Canvas.font.style + [fsItalic];
  PanelFontColor2.Repaint;
end;

procedure TSetupForm.ComboBox_size2Change(Sender: TObject);
begin
  PanelFontColor2.Canvas.font.Size := strtoint(ComboBox_size2.text);
  PanelFontColor2.Repaint;
end;

procedure TSetupForm.HomeDirBtnClick(Sender: TObject);
var
  dir:string;
begin
  dir := Edit_path.text;
  if SelectDirectory('','', dir, [], nil)  then
    Edit_path.text := dir;
end;

end.
