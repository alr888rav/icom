unit api_works;

interface

uses windows, forms, classes, controls, StdCtrls, Buttons, ExtCtrls, sysutils, grids, ComCtrls, menus, ActnCtrls,
  graphics,
  RVEdit, RVStyle;

// реализациа API икома
function GetApiVer: widestring; stdcall;
function GetVar(name: widestring): variant; stdcall;
function plugin_button(plugin_name: WideString): WideString; stdcall;
function plugin_panel(plugin_name: widestring): widestring; stdcall;
function create_control(plugin_name, type_name, parent_name: widestring): widestring; stdcall;
procedure SetCaption(plugin_name, control_name, text: widestring); stdcall;
procedure SetText(plugin_name, control_name, text: widestring); stdcall;
function GetText(plugin_name, control_name: widestring): widestring; stdcall;
procedure SetAlign(plugin_name, control_name: widestring; Align: Talign); stdcall;
procedure SetWindow(plugin_name, control_name: widestring; left, top, width, height: integer); stdcall;
procedure SetVisible(plugin_name, control_name: widestring; visible: boolean); stdcall;
procedure SetOnclick(plugin_name, control_name: WideString; proc: pointer); stdcall;
procedure InsertText(text: widestring); stdcall;
Procedure InsertImage(image: pointer); stdcall;
Procedure SetGlyphStream(plugin_name, control_name: widestring; image: pointer); stdcall;
Procedure SetGlyphFile(plugin_name, control_name, image: WideString); stdcall;
Procedure SetFreePos(ps: integer); stdcall;
function GetFreePos: integer; stdcall;
procedure SetChecked(plugin_name, control_name: widestring; check: boolean); stdcall;
function GetChecked(plugin_name, control_name: widestring): boolean; stdcall;
procedure SetFlat(plugin_name, control_name: widestring; flats: boolean); stdcall;
procedure SetOnKeyDown(plugin_name, control_name: widestring; proc: pointer); stdcall;
procedure SetHint(plugin_name, control_name, hint_text: widestring); stdcall;
function Download(Url: widestring): widestring;
procedure ShowPage(tab_name, file_name: widestring);
function GetInput: widestring; stdcall;
procedure SetVar(name: widestring; value: variant); stdcall;
procedure addToPopup(plugin_name, control_name, caption: widestring; proc: pointer); stdcall;
function GetPluginHeight: integer; stdcall;
procedure SetWindowHeight(plugin_name, control_name: widestring; height: integer); stdcall;
procedure SetWindowWidth(plugin_name, control_name: widestring; width: integer); stdcall;
function GetUserList: widestring; //stdcall;
function GetPort: integer; stdcall;
function GetUserStatus(ip:widestring):integer; stdcall;
function FindPlugin(name:widestring):boolean; stdcall;

implementation

uses main, setting, ulog, icomnet, Commonlib, icomplugins, Global;

type
  // класс дл€ обработчика кнопки
  TEventHandlers = class
    procedure PlgSetupClick(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure PluginObjectClick(Sender: TObject);
    procedure PluginObjectKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

var
  PluginsObj: TStringList;
  numbutton: integer;
  minX: integer;
  EvHandler: TEventHandlers;
  // последовательность дл€ неповтор€ющегос€ номера
  icom_seq: cardinal;

  // обработчик сетап плагинов
procedure TEventHandlers.PlgSetupClick(Sender: TObject);
var
  pClick: Tclick;
begin
  pClick := Tclick(TPlugin(Sender).SetupProc);
  try
    pClick;
  except
    on e: exception do
      log('PlugClick - ' + e.message);
  end;
end;

// обработчик кнопки плагинов
procedure TEventHandlers.ButtonClick(Sender: TObject);
var
  pClick: Tclick;
begin
  {$WARNINGS OFF}
  pClick := Tclick(plugins.Items[TSpeedButton(Sender).Tag]);
  {$WARNINGS ON}
  try
    pClick;
  except
    on e: exception do
      log('PlugClick - ' + e.message);
  end;
end;

// обработчик клика на объекте из плагина
procedure TEventHandlers.PluginObjectClick(Sender: TObject);
var
  pClick: Tclick;
begin
  pClick := Tclick(TButton(Sender).Tag);
  try
    pClick;
  except
    on e: exception do
      log('PlugClick - ' + e.message);
  end;
end;

// обработчик keydown объекта плагина
procedure TEventHandlers.PluginObjectKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  pKeyDown: TKeyDown;
begin
  pKeyDown := TKeyDown(Tedit(Sender).Tag);
  try
    pKeyDown(Key, Shift);
  except
    on e: exception do
      log('PlugKeyDown - ' + e.message);
  end;
end;

procedure AddPluginsObj(ob: string);
begin
  PluginsObj.Add(ob);
end;

// поиск компонента на форме
function myFindComponent(plugin_name: string; component_owner: tcomponent; component_name: string): tcomponent;
var
  i: integer;
begin
  result := component_owner.findcomponent(component_name);
  if result = nil then
  begin
    i := 0;
    repeat
      if i > component_owner.ComponentCount - 1 then
        break;
      result := component_owner.components[i].findcomponent(component_name);
      if (result = nil) and (component_owner.components[i].ComponentCount <> 0) then
        result := myFindComponent(plugin_name, component_owner.components[i], component_name);
      i := i + 1;
    until result <> nil;
  end;
end;

// уберем пробелы
function NoSpace(text: string): string;
begin
  result := stringreplace(text, ' ', '_', [rfreplaceall]);
end;

// верси€ api
function GetApiVer: widestring; stdcall;
begin
  result := '1.1';
end;

// возвращает след число
function myrandom: cardinal;
begin
  result := icom_seq;
  icom_seq := icom_seq + 1;
end;

Procedure SetFreePos(ps: integer); stdcall;
var
  add:Integer;
begin
  minX := ps;
  if ps<>0 then
    add := 10
  else
    add := 0;
  mainForm.PluginPanel.Width := ps + add;
end;

function GetFreePos: integer; stdcall;
begin
  result := minX;
end;

function GetPluginHeight: integer; stdcall;
begin
  result := mainform.StatusBar1.height;
end;

// установить переменную
procedure SetVar(name: widestring; value: variant); stdcall;
var
  name2: string;
begin
  name2 := string(name);
  name2 := trim(uppercase(name2));
end;

// получение переменной из настроек
function GetVar(name: widestring): variant; stdcall;
var
  name2: string;
begin
  name2 := trim(uppercase(string(name)));
  if name2 = 'VER' then
    result := ver
  else if name2 = 'WINVER' then
    result := winver
  else if name2 = 'PATH' then
    result := path
  else if name2 = 'HTMLDIR' then
    result := HTMLdir
  else if name2 = 'USER_BOX_SORT' then
    result := Setup.userboxsort
  else if name2 = 'SHOWOFFLINE' then
    result := Setup.ShowOffline
  else if name2 = 'DRAWLINES' then
    result := Setup.drawlines
  else if name2 = 'USER_BOX_MODE' then
    result := Setup.userboxmode
  else if name2 = 'MYNAME' then
    result := Setup.Myname
  else if name2 = 'SHOWBALLON' then
    result := Setup.showballon
  else if name2 = 'WINCOLOR' then
    result := Setup.WinColor
  else if name2 = 'MYIP' then
    result := Setup.localip.text
  else
    result := '';
end;

// создать кнопку плагина на панели paneltools2
function plugin_button(plugin_name: WideString): WideString; stdcall;
var
  bt: TSpeedButton;
begin
  bt := TSpeedButton.create(mainform.PluginPanel);
  try
    bt.Parent := mainform.PluginPanel;
    bt.visible := false;
    bt.left := GetFreePos;
    // по размеру панели
    bt.top := 0;
    bt.height := GetPluginHeight;
    bt.width := bt.Height;
    bt.caption := '';
    bt.visible := true;
    numbutton := numbutton + 1;
    bt.Tag := plugins.Count;
    bt.Hint := plugin_name;
    bt.ShowHint := true;
    bt.Flat := true;
    bt.Glyph.Transparent := true;
    bt.OnClick := EvHandler.ButtonClick;
    bt.name := NoSpace(plugin_name) + '_tspeedbutton';
    result := widestring(bt.name);
    SetFreePos(bt.left + bt.width);
  except
    on e: exception do
    begin
      log('CreateButton - ' + e.message);
      result := '';
    end;
  end;
end;

// создать панель дл€ плагина на панели дл€ плагинов
function plugin_panel(plugin_name: widestring): widestring; stdcall;
var
  Tp: Tpanel;
begin
  Tp := Tpanel.create(mainform.MainPanel);
  try
    Tp.Parent := mainform.StatusBar1;
    Tp.top := 0;
    Tp.left := GetFreePos;
    Tp.height := GetPluginHeight;
    Tp.width := 150;
    Tp.name := NoSpace(plugin_name) + '_panel';
    Tp.caption := '';
    result := widestring(Tp.name);
    SetFreePos(Tp.left + Tp.width);
  except
    on e: exception do
    begin
      log('CreatePanel - ' + e.message);
      result := '';
    end;
  end;
end;

// создаем контрол на панели плагина (по имени типа)
function create_control(plugin_name, type_name, parent_name: widestring): widestring; stdcall;
var
  bb: TButton;
  tb: tbitbtn;
  sb: TSpeedButton;
  rb: Tradiobutton;
  te: Tedit;
  cb: Tcheckbox;
  cbb: Tcombobox;
  lb: Tlistbox;
  gb: Tgroupbox;
  rg: Tradiogroup;
  Tp: Tpanel;
  //
  mm: TMemo;
  sg: TStringGrid;
  im: TImage;
  bl: TBevel;
  sx: TScrollBox;
  sp: TSplitter;
  st: TstaticText;
  cr: Tcontrolbar;
  le: TLabeledEdit;
  clr: TColorBox;
  //
  tc: TTabcontrol;
  pc: TPageControl;
  tr: TTrackBar;
  pb: TProgressBar;
  dt: TDateTimePicker;
  mc: TMonthCalendar;
  tv: TTreeView;
  lv: TListView;
  hc: THeaderControl;
  stb: TStatusBar;
  tlb: TToolBar;
  clb: TCoolBar;
  //
  tip: string;
  cn: tcomponent;
begin
  try
    tip := trim(uppercase(type_name));
    cn := myFindComponent(plugin_name, mainform, parent_name);
    if cn <> nil then
    begin
      if tip = 'TBUTTON' then
      begin
        bb := TButton.create(cn);
        bb.Parent := Twincontrol(cn);
        bb.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        bb.caption := '';
        result := widestring(bb.name);
      end
      else if tip = 'TSPEEDBUTTON' then
      begin
        sb := TSpeedButton.create(cn);
        sb.Parent := Twincontrol(cn);
        sb.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        sb.caption := '';
        result := widestring(sb.name);
      end
      else if tip = 'TBITBTN' then
      begin
        tb := tbitbtn.create(cn);
        tb.Parent := Twincontrol(cn);
        tb.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        tb.caption := '';
        result := widestring(tb.name);
      end
      else if tip = 'TRADIOBUTTON' then
      begin
        rb := Tradiobutton.create(cn);
        rb.Parent := Twincontrol(cn);
        rb.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        rb.caption := '';
        result := widestring(rb.name);
      end
      else if tip = 'TEDIT' then
      begin
        te := Tedit.create(cn);
        te.Parent := Twincontrol(cn);
        te.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        te.text := '';
        result := widestring(te.name);
      end
      else if tip = 'TCHECKBOX' then
      begin
        cb := Tcheckbox.create(cn);
        cb.Parent := Twincontrol(cn);
        cb.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        cb.caption := '';
        result := widestring(cb.name);
      end
      else if tip = 'TCOMBOBOX' then
      begin
        cbb := Tcombobox.create(cn);
        cbb.Parent := Twincontrol(cn);
        cbb.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        cbb.text := '';
        result := widestring(cbb.name);
      end
      else if tip = 'TLISTBOX' then
      begin
        lb := Tlistbox.create(cn);
        lb.Parent := Twincontrol(cn);
        lb.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(lb.name);
      end
      else if tip = 'TGROUPBOX' then
      begin
        gb := Tgroupbox.create(cn);
        gb.Parent := Twincontrol(cn);
        gb.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        gb.caption := '';
        result := widestring(gb.name);
      end
      else if tip = 'TRADIOGROUP' then
      begin
        rg := Tradiogroup.create(cn);
        rg.Parent := Twincontrol(cn);
        rg.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        rg.caption := '';
        result := widestring(rg.name);
      end
      else if tip = 'TPANEL' then
      begin
        Tp := Tpanel.create(cn);
        Tp.Parent := Twincontrol(cn);
        Tp.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        Tp.caption := '';
        result := widestring(Tp.name);
      end
      else if tip = 'TMEMO' then
      begin
        mm := TMemo.create(cn);
        mm.Parent := Twincontrol(cn);
        mm.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        mm.text := '';
        result := widestring(mm.name);
      end
      else if tip = 'TSTRINGGRID' then
      begin
        sg := TStringGrid.create(cn);
        sg.Parent := Twincontrol(cn);
        sg.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(sg.name);
      end
      else if tip = 'TIMAGE' then
      begin
        im := TImage.create(cn);
        im.Parent := Twincontrol(cn);
        im.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(im.name);
      end
      else if tip = 'TBEVEL' then
      begin
        bl := TBevel.create(cn);
        bl.Parent := Twincontrol(cn);
        bl.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(bl.name);
      end
      else if tip = 'TSCROLLBOX' then
      begin
        sx := TScrollBox.create(cn);
        sx.Parent := Twincontrol(cn);
        sx.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(sx.name);
      end
      else if tip = 'TSPLITTER' then
      begin
        sp := TSplitter.create(cn);
        sp.Parent := Twincontrol(cn);
        sp.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(sp.name);
      end
      else if tip = 'TSTATICTEXT' then
      begin
        st := TstaticText.create(cn);
        st.Parent := Twincontrol(cn);
        st.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(st.name);
      end
      else if tip = 'TCONTROLBAR' then
      begin
        cr := Tcontrolbar.create(cn);
        cr.Parent := Twincontrol(cn);
        cr.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(cr.name);
      end
      else if tip = 'TLABELEDEDIT' then
      begin
        le := TLabeledEdit.create(cn);
        le.Parent := Twincontrol(cn);
        le.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(le.name);
      end
      else if tip = 'TCOLORBOX' then
      begin
        clr := TColorBox.create(cn);
        clr.Parent := Twincontrol(cn);
        clr.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(clr.name);
      end
      else if tip = 'TTABCONTROL' then
      begin
        tc := TTabcontrol.create(cn);
        tc.Parent := Twincontrol(cn);
        tc.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(tc.name);
      end
      else if tip = 'TPAGECONTROL' then
      begin
        pc := TPageControl.create(cn);
        pc.Parent := Twincontrol(cn);
        pc.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(pc.name);
      end
      else if tip = 'TTRACKBAR' then
      begin
        tr := TTrackBar.create(cn);
        tr.Parent := Twincontrol(cn);
        tr.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(tr.name);
      end
      else if tip = 'TPROGRESSBAR' then
      begin
        pb := TProgressBar.create(cn);
        pb.Parent := Twincontrol(cn);
        pb.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(pb.name);
      end
      else if tip = 'TDATETIMEPICKER' then
      begin
        dt := TDateTimePicker.create(cn);
        dt.Parent := Twincontrol(cn);
        dt.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(dt.name);
      end
      else if tip = 'TMONTHCALENDAR' then
      begin
        mc := TMonthCalendar.create(cn);
        mc.Parent := Twincontrol(cn);
        mc.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(mc.name);
      end
      else if tip = 'TTREEVIEW' then
      begin
        tv := TTreeView.create(cn);
        tv.Parent := Twincontrol(cn);
        tv.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(tv.name);
      end
      else if tip = 'TLISTVIEW' then
      begin
        lv := TListView.create(cn);
        lv.Parent := Twincontrol(cn);
        lv.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(lv.name);
      end
      else if tip = 'THEADERCONTROL' then
      begin
        hc := THeaderControl.create(cn);
        hc.Parent := Twincontrol(cn);
        hc.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(hc.name);
      end
      else if tip = 'TSTATUSBAR' then
      begin
        stb := TStatusBar.create(cn);
        stb.Parent := Twincontrol(cn);
        stb.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(stb.name);
      end
      else if tip = 'TTOOLBAR' then
      begin
        tlb := TToolBar.create(cn);
        tlb.Parent := Twincontrol(cn);
        tlb.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(tlb.name);
      end
      else if tip = 'TCOOLBAR' then
      begin
        clb := TCoolBar.create(cn);
        clb.Parent := Twincontrol(cn);
        clb.name := NoSpace(plugin_name) + '_' + tip + inttostr(myrandom);
        result := widestring(clb.name);
      end
      else
        result := '';
    end
    else
      result := '';
    if result > '' then
      AddPluginsObj(result);
  except
    on e: exception do
    begin
      log('CreateControl - ' + e.message);
      result := '';
    end;
  end;
end;

// выравнивание
procedure SetAlign(plugin_name, control_name: widestring; Align: Talign); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if cn <> nil then
    begin
      Twincontrol(cn).Align := Align;
    end;
  except
    on e: exception do
      log('SetAlign - ' + e.message);
  end;
end;

// положение и размеры
procedure SetWindow(plugin_name, control_name: widestring; left, top, width, height: integer); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if cn <> nil then
    begin
      if left >= 0 then
        Twincontrol(cn).left := left;
      if top >= 0 then
        Twincontrol(cn).top := top;
      if width >= 0 then
        Twincontrol(cn).width := width;
      if height >= 0 then
        Twincontrol(cn).height := height;
    end;
  except
    on e: exception do
      log('SetWindow - ' + e.message);
  end;
end;

// размеры
procedure SetWindowHeight(plugin_name, control_name: widestring; height: integer); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if cn <> nil then
    begin
      if height >= 0 then
        Twincontrol(cn).height := height;
    end;
  except
    on e: exception do
      log('SetWindowHeight - ' + e.message);
  end;
end;

// размеры
procedure SetWindowWidth(plugin_name, control_name: widestring; width: integer); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if cn <> nil then
    begin
      if width >= 0 then
        Twincontrol(cn).width := width;
    end;
  except
    on e: exception do
      log('SetWindowHeight - ' + e.message);
  end;
end;

// видимость
procedure SetVisible(plugin_name, control_name: widestring; visible: boolean); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if cn <> nil then
    begin
      Twincontrol(cn).visible := visible;
    end;
  except
    on e: exception do
      log('SetVisible - ' + e.message);
  end;
end;

procedure SetCaption(plugin_name, control_name, text: widestring); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if cn <> nil then
    begin
      TButton(cn).caption := text;
    end;
  except
    on e: exception do
      log('SetCaption - ' + e.message);
  end;
end;

procedure SetText(plugin_name, control_name, text: widestring); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if cn <> nil then
    begin
      Tcustomedit(cn).text := text;
    end;
  except
    on e: exception do
      log('SetText - ' + e.message);
  end;
end;

function GetText(plugin_name, control_name: widestring): widestring; stdcall;
var
  cn: tcomponent;
begin
  result := '';
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if cn <> nil then
      result := widestring(Tcustomedit(cn).text);
  except
    on e: exception do
      log('SetText - ' + e.message);
  end;
end;

// назначение обработчика onkeydown
procedure SetOnKeyDown(plugin_name, control_name: widestring; proc: pointer); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainForm, control_name);
    if cn <> nil then
    begin
      Tedit(cn).Tag := integer(proc);
      Tedit(cn).OnKeyDown := EvHandler.PluginObjectKeyDown;
    end;
  except
    on e: exception do
      log('SetOnKeyDown - ' + e.message);
  end;
end;

// добавить в попап меню
// плагин, меню, строка_меню, обработчик
procedure addToPopup(plugin_name, control_name, caption: widestring; proc: pointer); stdcall;
var
  mn: TMenuItem;
  cn: tcomponent;
  i: Integer;
begin
  cn := myFindComponent(plugin_name, mainform, control_name);
  if cn <> nil then
  begin
    for i := 0 to TPopupMenu(cn).Items.Count-1 do
    begin
      if AnsiUpperCase(caption)=AnsiUpperCase(TPopupMenu(cn).Items.Caption) then
        Exit;
    end;
    mn := TMenuItem.create(TPopupMenu(cn));
    mn.Hint := '';
    mn.caption := caption;
    mn.Tag := integer(proc);
    mn.OnClick := EvHandler.PluginObjectClick;
    TPopupMenu(cn).Items.Add(mn);
  end;
end;

// назначение onclick
procedure SetOnclick(plugin_name, control_name: widestring; proc: pointer); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainForm, control_name);
    if cn <> nil then
    begin
      Tcustombuttoncontrol(cn).Tag := integer(proc);
      Tcustombuttoncontrol(cn).OnClick := EvHandler.PluginObjectClick;
    end;
  except
    on e: exception do
      log('SetOnClick - ' + e.message);
  end;
end;

// вставить текст в поле ввода
procedure InsertText(text: widestring); stdcall;
begin
  try
    mainform.memoin.InsertText(text);
    mainform.memoin.ReFormat;
  except
    on e: exception do
      log('InsertText - ' + e.message);
  end;
end;

// вставить картинку в поле ввода
Procedure InsertImage(image: pointer); stdcall;
var
  bm: Tbitmap;
begin
  try
    bm := Tbitmap.create; // переход к своему объекту
    {$WARNINGS OFF}
    bm.width := Tgraphic(image).width;
    bm.height := Tgraphic(image).height;
    bm.Canvas.Draw(0, 0, Tgraphic(image));
    {$WARNINGS ON}
    mainform.memoin.InsertPicture('plg_img', bm, rvvaBaseline);
    mainform.memoin.ReFormat;
  except
    on e: exception do
      log('InsertImage - ' + e.message);
  end;
end;

// картинку на кнопку из tmemorystream
Procedure SetGlyphStream(plugin_name, control_name: widestring; image: pointer); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if (cn <> nil) and (image <> nil) then
    begin
      {$WARNINGS OFF}
      Tmemorystream(image).Position := 0;
      if pos('BITBTN', uppercase(cn.name)) <> 0 then
        tbitbtn(cn).Glyph.LoadFromStream(Tmemorystream(image))
      else if pos('SPEEDBUTTON', uppercase(cn.name)) <> 0 then
        TSpeedButton(cn).Glyph.LoadFromStream(Tmemorystream(image));
      {$WARNINGS ON}
    end;
  except
    on e: exception do
      log('SetGlyphStream - ' + e.message);
  end;
end;

// картинку на кнопку из файла
Procedure SetGlyphFile(plugin_name, control_name, image: WideString); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if (cn <> nil) and (image > '') then
    begin
      if fileexists(image) then
      begin
        if pos('BITBTN', uppercase(cn.name)) <> 0 then
          tbitbtn(cn).Glyph.LoadFromFile(image)
        else if pos('SPEEDBUTTON', uppercase(cn.name)) <> 0 then
          TSpeedButton(cn).Glyph.LoadFromFile(image);
      end
    end;
  except
    on e: exception do
      log('SetGlyphFile - ' + e.message);
  end;
end;

procedure SetChecked(plugin_name, control_name: widestring; check: boolean); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if (cn <> nil) then
    begin
      if pos('CHECKBOX', uppercase(cn.name)) <> 0 then
        Tcheckbox(cn).Checked := check
      else if pos('RADIOBUTTON', uppercase(cn.name)) <> 0 then
        Tradiobutton(cn).Checked := check;
    end;
  except
    on e: exception do
      log('SetCheked - ' + e.message);
  end;
end;

function GetChecked(plugin_name, control_name: widestring): boolean; stdcall;
var
  cn: tcomponent;
begin
  result := false;
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if (cn <> nil) then
    begin
      if pos('CHECKBOX', uppercase(cn.name)) <> 0 then
        result := Tcheckbox(cn).Checked
      else if pos('RADIOBUTTON', uppercase(cn.name)) <> 0 then
        result := Tradiobutton(cn).Checked
    end;
  except
    on e: exception do
      log('SetCheked - ' + e.message);
  end;
end;

procedure SetFlat(plugin_name, control_name: widestring; flats: boolean); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if (cn <> nil) then
    begin
      if pos('BUTTON', uppercase(cn.name)) <> 0 then
        TSpeedButton(cn).Flat := flats;
    end;
  except
    on e: exception do
      log('SetFlat - ' + e.message);
  end;
end;

// установить хинт на контрол
procedure SetHint(plugin_name, control_name, hint_text: widestring); stdcall;
var
  cn: tcomponent;
begin
  try
    cn := myFindComponent(plugin_name, mainform, control_name);
    if (cn <> nil) then
    begin
      TControl(cn).Hint := hint_text;
      TControl(cn).ShowHint := true;
    end;
  except
    on e: exception do
      log('SetHint - ' + e.message);
  end;
end;

// загрузить страницу/файл из интернета
function Download(Url: widestring): widestring;
var
  fn: string;
begin
  try
    fn := NetWork.MyDownload(Url);
    result := widestring(fn + #0);
  except
    result := '';
  end;
end;

// показать html-файл на вкладке
procedure ShowPage(tab_name, file_name: widestring);
var
  ex: integer;
  fl: string;
begin
  fl := string(file_name);
  if (fileexists(fl)) and (myfilesize(fl) <> 0) then
  begin
    if tab_name = '' then
      tab_name := widestring('‘айл - ' + file_name);
    ex := mainform.NewTab(tab_name, true, READONLY_CH);
    deletefile(HTMLdir + trim(tab_name) + '.html');
    if ex >= 0 then
    begin
      Channels.Channel[tab_name].LoadFromFile(fl);
      Channels.Channel[tab_name].GoBegin;
    end;
  end
end;

function GetInput: widestring; stdcall;
var
  ss: string;
begin
  mainform.memoin.SelectAll;
  ss := mainform.memoin.GetSelText;
  mainform.memoin.Deselect;
  result := widestring(ss);
end;

function GetUserList: widestring; // stdcall;
var
  i:integer;
  ls:widestring;
begin
  ls := '';
  for i := 0 to User_List.Count -1 do
  begin
    if User_List[i].ip>'' then
      ls := ls + User_list[i].Name+'/'+User_List[i].ip+LF;
  end;
  result := widestring(ls);
end;

function GetPort: integer; stdcall;
begin
  result := Setup.IcomPort;
end;

function GetUserStatus(ip:widestring):integer; stdcall;
var
 sip:string;
begin
  sip:=ip;
  result := user_list[sip].status;
end;

function FindPlugin(name:widestring):boolean; stdcall;
begin
  if Plugins.FindPluginID(name)=-1 then
    result := false
  else
    result := true;
end;

initialization

  PluginsObj := TStringList.create;
  numbutton := 0;
  icom_seq := 0;

finalization

  PluginsObj.Free;

end.
