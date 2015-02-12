unit language;

interface

uses windows, menus, extctrls, buttons, stdctrls, controls, Forms, jpeg, graphics, classes, SysUtils, Dialogs,
  ComCtrls, messages;

type
  TLangClass = class(TObject)
  private
    langList: Tstringlist;
    procedure SaveLangForm(form: Tform; sl: Tstringlist);
    procedure SaveTxt(sl: Tstringlist);
    procedure LoadLang(ilang: string; list: Tstringlist);  overload;
  public
    function isGreen(value: string):boolean;
    function isBlue(value: string):boolean;
    function isRed(value: string):boolean;
    function toDefaultLang(value: string): string;
    function toMyLang(value: string): string;
    procedure SaveDefaultLang;
    function Get(var_name: string; lang: string): string; overload;
    function Get(var_name: string): string; overload;
    constructor Create;
    destructor Destroy; override;
    function LoadLang(ilang: string): boolean; overload;
    procedure LoadLangs;
  end;

implementation

uses Global, MAIN;

constructor TLangClass.Create;
begin
  inherited Create;
  LangDir := extractfilepath(application.ExeName) + 'Languages\';
  langlist := TstringList.Create;
end;

destructor TLangClass.Destroy;
begin
  langlist.free;
  inherited Destroy;
end;

function TLangClass.isGreen(value: string):boolean;
var
  i: Integer;
begin
  result := false;
  for i := 0 to langlist.Count-1 do
  begin
    if value = Tstringlist(langList.Objects[i]).Values['green'] then
    begin
      result := true;
      break;
    end;
  end;
end;

function TLangClass.isBlue(value: string):boolean;
var
  i: Integer;
begin
  result := false;
  for i := 0 to langlist.Count-1 do
  begin
    if value = Tstringlist(langList.Objects[i]).Values['blue'] then
    begin
      result := true;
      break;
    end;
  end;
end;

function TLangClass.isRed(value: string):boolean;
var
  i: Integer;
begin
  result := false;
  for i := 0 to langlist.Count-1 do
  begin
    if value = Tstringlist(langList.Objects[i]).Values['red'] then
    begin
      result := true;
      break;
    end;
  end;
end;

function TLangClass.toMyLang(value: string): string;
begin
  if isGreen(value) then
    result := get('green')
  else
  if isBlue(value) then
    result := get('blue')
  else
  if isRed(value) then
    result := get('red')
  else
    Result := value;
end;

function TLangClass.toDefaultLang(value: string): string;
begin
  if isGreen(value) then
    result := get('green', default_lang)
  else
  if isBlue(value) then
    result := get('blue', default_lang)
  else
  if isRed(value) then
    result := get('red', default_lang)
  else
    Result := value;
end;

function TLangClass.Get(var_name: string): string;
begin
  result := get(var_name, setup.icomLang);
end;

function TLangClass.Get(var_name: string; lang: string): string;
var
  i: Integer;
begin
  for i := 0 to langlist.Count-1 do
  begin
    if Pos(UpperCase(lang), Uppercase(langList.Strings[i])) <> 0 then
    begin
      Result := Tstringlist(langList.Objects[i]).Values[uppercase(var_name)];
      break;
    end;
  end;
end;

procedure TLangClass.LoadLangs;
var
  sr: TsearchRec;
  list: TStringlist;
  Res: Integer;
  path: string;
begin
  path := extractfilepath(Application.ExeName) + 'languages\';
  Res := findFirst(path + '*.lng', faAnyFile, sr);
  while Res = 0 do
  begin
    list := TStringlist.create;
    list.LoadFromFile(path + sr.Name);
    langList.AddObject(sr.name, list);
    Res := FindNext(sr);
  end;
  FindClose(sr);
end;

// �������� ����� ����������
function TLangClass.LoadLang(ilang: string): boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to langlist.Count-1 do
  begin
    if Pos(UpperCase(ilang), UpperCase(langList.Strings[i]))<>0 then
    begin
      loadLang(ilang, Tstringlist(langList.Objects[i]));
      Result := true;
    end;
  end;
end;

procedure TLangClass.LoadLang(ilang: string; list: TStringlist);
var
  f, i, j: integer;
  cp, ht, it: string;
  wc: TComponent;
  form: TForm;
  Procedure Load1(name: string; var cp, ht: string);
  begin
    if name = '' then
      exit;
    cp := ''; ht := '';
    cp := list.Values[name+'.caption'];
    ht := list.Values[name+'.hint'];
    cp := stringreplace(cp, '#13#10', LF, [rfReplaceAll]);
    ht := stringreplace(ht, '#13#10', LF, [rfReplaceAll]);
  end;
  Procedure Load2(name: string; index: integer; var item: string);
  begin
    if name = '' then
      exit;
    item := list.Values[name+'.items' + inttostr(index)];
  end;

begin
  if Pos('.lng', LowerCase(ilang))=0 then
    ilang := ilang + '.lng';
  // ����������
  for f := 0 to Application.ComponentCount-1 do
  begin
    if Application.Components[f] is TForm then
    begin
      form := TForm(Application.Components[f]);
      for i := 0 to form.ComponentCount - 1 do
      begin
        Load1(form.Name, cp, ht);
        form.Caption := cp;
        wc := form.Components[i];
        Load1(form.Name+'.'+wc.name, cp, ht);
        if wc is TpageControl then
        begin
          if ht > '' then
            TpageControl(wc).hint := ht;
          for j := 0 to TpageControl(wc).Pagecount - 1 do
          begin
            Load2(form.Name+'.'+wc.name, j, it);
            if (it > '') and (TpageControl(wc).pages[j].caption <> it) then
              TpageControl(wc).pages[j].caption := it;
          end;
        end
        else if wc is TLabel then
        begin
          if cp > '' then
            TLabel(wc).caption := cp;
          if ht > '' then
            TLabel(wc).hint := ht;
        end
        else if wc is TEdit then
        begin
          if ht > '' then
            TEdit(wc).hint := ht;
        end
        else if wc is TButton then
        begin
          if cp > '' then
            TButton(wc).caption := cp;
          if ht > '' then
            TButton(wc).hint := ht;
        end
        else if wc is TSpeedbutton then
        begin
          if cp > '' then
            TSpeedbutton(wc).caption := cp;
          if ht > '' then
            TSpeedbutton(wc).hint := ht;
        end
        else if wc is TBitBtn then
        begin
          if cp > '' then
            TBitBtn(wc).caption := cp;
          if ht > '' then
            TBitBtn(wc).hint := ht;
        end
        else if wc is TGroupBox then
        begin
          if cp > '' then
            TGroupBox(wc).caption := cp;
          if ht > '' then
            TGroupBox(wc).hint := ht;
        end
        else if wc is TRadioGroup then
        begin
          if cp > '' then
            TRadioGroup(wc).caption := cp;
          if ht > '' then
            TRadioGroup(wc).hint := ht;
          for j := 0 to TRadioGroup(wc).Items.count - 1 do
          begin
            Load2(form.Name+'.'+wc.name, j, it);
            if (it > '') and (TRadioGroup(wc).Items[j] <> it) then
              TRadioGroup(wc).Items[j] := it;
          end;
        end
        else if wc is TRadioButton then
        begin
          if cp > '' then
            TRadioButton(wc).caption := cp;
          if ht > '' then
            TRadioButton(wc).hint := ht;
        end
        else if (wc is TComboBox) and (pos('_size', wc.name) = 0) and (wc.name <> 'ComboIP') and (wc.name <> 'ComboLang2')
        then
        begin
          if ht > '' then
            TComboBox(wc).hint := ht;
          for j := 0 to TComboBox(wc).Items.count - 1 do
          begin
            Load2(form.Name+'.'+wc.name, j, it);
            if (it > '') and (TComboBox(wc).Items[j] <> it) then
              TComboBox(wc).Items[j] := it;
          end;
        end
        else if wc is TCheckBox then
        begin
          if cp > '' then
            TCheckBox(wc).caption := cp;
          if ht > '' then
            TCheckBox(wc).hint := ht;
        end
        else if wc is TPanel then
        begin
          if cp > '' then
            TPanel(wc).caption := cp;
          if ht > '' then
            TPanel(wc).hint := ht;
        end;
      end;
      // ����
      for i := 0 to form.ComponentCount - 1 do
      begin
        if form.Components[i] is TPopupMenu then
        begin
          wc := form.Components[i];
          for j := 0 to TPopupMenu(wc).Items.count - 1 do
          begin
            Load2(form.Name+'.'+wc.name, j, it);
            if (it > '') and (TPopupMenu(wc).Items[j].caption <> it) then
              TPopupMenu(wc).Items[j].caption := it;
          end;
        end;
      end;
      for i := 0 to form.ComponentCount - 1 do
      begin
        if form.Components[i] is TMainMenu then
        begin
          wc := form.Components[i];
          for j := 0 to TMainMenu(wc).Items.count - 1 do
          begin
            Load2(form.Name+'.'+wc.name, j, it);
            if (it > '') and (TMainMenu(wc).Items[j].caption <> it) then
              TMainMenu(wc).Items[j].caption := it;
          end;
        end;
      end;
    end;
  end;

//  mainform.CitBtn.hint := get('cit_hint');
//  mainform.FileBtn.hint := get('file_hint');
//  mainform.ClearBtn.hint := get('clear_hint');
//  mainform.SendBtn.hint := get('send_hint');
//  mainForm.FontSetupButton.hint := get('font_hint');
//  mainForm.SmileBtn3.hint := get('smile_hint');
  Application.Title := Get('ititle');
  mainForm.TrayIcon.Hint := Get('ititle');
  mainForm.MenuButton.hint := Get('main_menu_hint');
  mainform.MenuButton.Caption := Get('ititle');
end;

procedure TLangClass.SaveLangForm(form: Tform; sl: TStringList);
var
  i, j: integer;
  wc: TComponent;
  cp, ht: string;

  procedure Save1(name, caption, hint: string; index: integer = -1; item: string = '');
  const
    digits = '0123456789';
  var
    i: integer;
    dg: boolean;
  begin
    if (caption > '') and (caption <> '...') then
    begin
      sl.Add(Name+'.caption='+stringreplace(caption, LF, '#13#10', [rfReplaceAll]));
    end;
    if (hint > '') then
    begin
      sl.add(Name+'.hint='+stringreplace(hint, LF, '#13#10', [rfReplaceAll]));
    end;
    if index >= 0 then
    begin
      dg := true;
      for i := 1 to length(item) do
        if pos(item[i], digits) = 0 then
          dg := false;
      if not dg then
        sl.add(Name+'.items' + inttostr(index) +'='+ item);
    end;
  end;
begin
  Save1(form.Name, form.Caption, '');
  for i := 0 to form.ComponentCount - 1 do
  begin
    wc := form.Components[i];
    if wc is TpageControl then
    begin
      ht := TpageControl(wc).hint;
      Save1(form.Name+'.'+wc.name, '', ht);
      //if wc.name <> 'PageControl1' then
      //begin
        for j := 0 to TpageControl(wc).Pagecount - 1 do
          Save1(form.Name+'.'+wc.name, '', '', j, TpageControl(wc).pages[j].caption);
      //end;
    end
    else if wc is TLabel then
    begin
      cp := TLabel(wc).caption;
      ht := TLabel(wc).hint;
      Save1(form.name+'.'+wc.name, cp, ht);
    end
    else if wc is TEdit then
    begin
      ht := TButton(wc).hint;
      Save1(form.name+'.'+wc.name, '', ht);
    end
    else if wc is TButton then
    begin
      cp := TButton(wc).caption;
      ht := TButton(wc).hint;
      Save1(form.name+'.'+wc.name, cp, ht);
    end
    else if wc is TSpeedbutton then
    begin
      cp := TSpeedbutton(wc).caption;
      ht := TSpeedbutton(wc).hint;
      Save1(form.name+'.'+wc.name, cp, ht);
    end
    else if wc is TBitBtn then
    begin
      cp := TBitBtn(wc).caption;
      ht := TBitBtn(wc).hint;
      Save1(form.name+'.'+wc.name, cp, ht);
    end
    else if wc is TGroupBox then
    begin
      cp := TGroupBox(wc).caption;
      ht := TGroupBox(wc).hint;
      Save1(form.name+'.'+wc.name, cp, ht);
    end
    else if wc is TRadioGroup then
    begin
      cp := TRadioGroup(wc).caption;
      ht := TRadioGroup(wc).hint;
      Save1(form.name+'.'+wc.name, cp, ht);
      for j := 0 to TRadioGroup(wc).Items.count - 1 do
        Save1(form.Name+'.'+wc.name, '', '', j, TRadioGroup(wc).Items[j]);
    end
    else if wc is TRadioButton then
    begin
      cp := TRadioButton(wc).caption;
      ht := TRadioButton(wc).hint;
      Save1(form.name+'.'+wc.name, cp, ht);
    end
    else if (wc is TComboBox) and (pos('_size', wc.name) = 0) and (wc.name <> 'ComboLang2') then
    begin
      cp := '';
      ht := TComboBox(wc).hint;
      Save1(form.name+'.'+wc.name, cp, ht);
      for j := 0 to TComboBox(wc).Items.count - 1 do
        Save1(form.name+'.'+wc.name, '', '', j, TComboBox(wc).Items[j]);
    end
    else if wc is TCheckBox then
    begin
      cp := TCheckBox(wc).caption;
      ht := TCheckBox(wc).hint;
      Save1(form.name+'.'+wc.name, cp, ht);
    end
    else if wc is TPanel then
    begin
      cp := TPanel(wc).caption;
      ht := TPanel(wc).hint;
      Save1(form.name+'.'+wc.name, cp, ht);
    end;
  end;
  for i := 0 to form.ComponentCount - 1 do
  begin
    if form.Components[i] is TPopupMenu then
    begin
      for j := 0 to TPopupMenu(form.Components[i]).Items.count - 1 do
      begin
        wc := form.Components[i];
        Save1(form.name+'.'+wc.name, '', '', j, TPopupMenu(wc).Items[j].caption);
      end;
    end
  end;
  for i := 0 to form.ComponentCount - 1 do
  begin
    if form.Components[i] is TMainMenu then
    begin
      for j := 0 to TMainMenu(form.Components[i]).Items.count - 1 do
      begin
        wc := form.Components[i];
        Save1(form.name+'.'+wc.name, '', '', j, TMainMenu(wc).Items[j].caption);
      end;
    end
  end;
 end;

procedure TLangClass.SaveTxt(sl: Tstringlist);
  procedure Save2(name, value: string);
  begin
    sl.add(name+'='+value);
  end;
begin
  //
  Save2('iver', '5');
  Save2('green', '�������');
  Save2('blue', '�����');
  Save2('red', '�������');
  Save2('cit_start', '***Begin quote***');
  Save2('cit_end', '***End quote***');
  Save2('user_in0', '�����������');
  Save2('user_in1', '������������');
  Save2('user_out0', '����������');
  Save2('user_out1', '�����������');
  Save2('no_skin', '��� ��������� ������');
  Save2('nick', '���');
  Save2('onick', '������������ ���');
  Save2('ip', 'IP �����');
  Save2('note', '��������');
  Save2('att', '��������');
  Save2('enough', '������������ ���������� ������������ �� �����');
  Save2('birthday', '�/�');
  Save2('one_copy', '���� ����� ��������� ��� ��������');
  Save2('to_all', '����');
  Save2('no_names', '�� ������ �� ���� �������');
  Save2('send_file', '������ ����');
  Save2('off_line', '���������� ��������� ������� �������');
  Save2('self', '������ ��������� ������ ��������� ����');
  Save2('personal', '������ ��������� ���');
  Save2('correct', '�������� ��������� ���� ���������');
  Save2('resend', '��� ����� ���������?');
  Save2('clear_traffic', '�������� ������?');
  Save2('send_files', '��������� ����(�)');
  Save2('big_file', '������� ����');
  Save2('error', '������');
  Save2('start', '������ �������');
  Save2('overq', '��������� ������ ���� ���������!');
  Save2('clear_all', '�������� ������?');
  Save2('enter_stat', '������� ������');
  Save2('open_link', '������� ����/������?');
  Save2('hide', '������');
  Save2('show', '��������');
  Save2('file1', '����');
  Save2('page', '��������');
  Save2('stat', '������');
  Save2('none', '�����������');
  Save2('hour', '���');
  Save2('min', '���');
  Save2('sek', '���');
  Save2('setup', '���������');
  Save2('new_channel', '����� �����');
  Save2('channel', '�����');
  Save2('pict', '��������');
  Save2('common', '����� ��������');
  Save2('update', '��������� ����������?');
  Save2('block', '�������������');
  Save2('delete', '�������');
  Save2('bad_ip', '������������ ip-�����');
  Save2('overwrite', '��� ���� � ���������, ������������?');
  Save2('add_user', '�������� � ��������?');
  Save2('add_title', '������� ���������');
  Save2('no_send', '�� ������� ��������� ���������');
  Save2('personal2', '������');
  Save2('group', '���������');
  Save2('msgok', '��������� ����������');
  Save2('need_restart', '����������� �������');
  Save2('update_err', '������ ����������');
  Save2('update_check', '��������� ����������');
  Save2('update_exist', '�������� ����������');
  Save2('err_file', '������ ������ �����');
  Save2('update_page', '����������');
  Save2('update_req', '�������� ����������..');
  Save2('update_not_exist', '��� ����� ������');
  Save2('update_ok', '��������� ����������');
  Save2('close', '�������');
  Save2('ititle', '����');
  Save2('video', '�����');
  Save2('flash', 'Flash');
  Save2('i_am', '��� �');
  Save2('check_ip', '��������� ��������� IP �����');
  Save2('user', '���');
  Save2('password', '������');
  Save2('setup_menu', '���������');
  Save2('extstat_menu', '��������� ������');
  Save2('help_menu', '�������');
  Save2('on', '���');
  Save2('off', '����');
  Save2('show_off', '���������� �������');
  Save2('auto_scroll', '����������');
  Save2('ver', '������');
  Save2('message', '���������');
  Save2('from', '��');
  Save2('WaitAdd','��������� ����������');
  Save2('About_menu','� ���������');
  Save2('Restart_menu','�������');
  Save2('Exit_menu','�����');
  Save2('Mem_Warning','���� ��������� ������, �������� ������');
  Save2('secure_send','���������� �������� ��������');
  Save2('free_send','�������� �������� ��������');
  Save2('except_red','[����� �������]');
  Save2('lang_hint','���� �����');
  Save2('font_hint','����� ������-����� ������/������ ������-���� ����� �� ���������');
  Save2('smile_hint','��������');
  Save2('cit_hint','������');
  Save2('file_hint','��������� ����');
  Save2('clear_hint','��������');
  Save2('send_hint','��������� ���������');
  Save2('save','���������');
  Save2('cancel','������');
  Save2('protected','(������ �������)');
  save2('not_safe', '�� ���������� ����, ��� ����� ���������?');
  save2('main_menu_hint', '����');
  Save2('send_update', '������� ����������?');
  Save2('plugin','�������');
  Save2('online','� ����');
end;

// ���������� ���� �� ��������� (����������)
procedure TLangClass.SaveDefaultLang;
var
  i: integer;
  sl: TStringList;
  LangDir: string;
begin
  sl := TStringList.Create;
  for i := 0 to Application.ComponentCount - 1 do
    if (Application.Components[i] is TForm)and(TForm(Application.Components[i]).name<>'fmAbout') then
       SaveLangForm(TForm(Application.Components[i]), sl);
  SaveTxt(sl);
  LangDir := extractfilepath(application.ExeName) + 'Languages\';
  sl.SaveToFile(LangDir + default_lang + '.lng'); // override
  sl.Free;
end;

end.
