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

// загрузка языка интерфейса
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
  // компоненты
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
      // меню
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
  Save2('green', 'Зеленый');
  Save2('blue', 'Синий');
  Save2('red', 'Красный');
  Save2('cit_start', '***Begin quote***');
  Save2('cit_end', '***End quote***');
  Save2('user_in0', 'Подключился');
  Save2('user_in1', 'Подключилась');
  Save2('user_out0', 'Отключился');
  Save2('user_out1', 'Отключилась');
  Save2('no_skin', 'Нет доступных скинов');
  Save2('nick', 'Ник');
  Save2('onick', 'Оригинальный ник');
  Save2('ip', 'IP адрес');
  Save2('note', 'Описание');
  Save2('att', 'Внимание');
  Save2('enough', 'Недостаточно свободного пространства на диске');
  Save2('birthday', 'Д/р');
  Save2('one_copy', 'Одна копия программы уже запущена');
  Save2('to_all', 'Всем');
  Save2('no_names', 'Не выбран ни один адресат');
  Save2('send_file', 'Послан файл');
  Save2('off_line', 'Невозможно отправить адресат оффлайн');
  Save2('self', 'Нельзя отправить личное сообщение себе');
  Save2('personal', 'Личное сообщение для');
  Save2('correct', 'Возможно ошибочный язык сообщения');
  Save2('resend', 'Все равно отправить?');
  Save2('clear_traffic', 'Очистить трафик?');
  Save2('send_files', 'Отправить файл(ы)');
  Save2('big_file', 'Большой файл');
  Save2('error', 'Ошибка');
  Save2('start', 'Ошибка запуска');
  Save2('overq', 'Выбирайте только одно сообщение!');
  Save2('clear_all', 'Очистить каналы?');
  Save2('enter_stat', 'Введите статус');
  Save2('open_link', 'Открыть файл/ссылку?');
  Save2('hide', 'скрыть');
  Save2('show', 'показать');
  Save2('file1', 'Файл');
  Save2('page', 'Страница');
  Save2('stat', 'Статус');
  Save2('none', 'Отсутствует');
  Save2('hour', 'час');
  Save2('min', 'мин');
  Save2('sek', 'сек');
  Save2('setup', 'Настройки');
  Save2('new_channel', 'Новый канал');
  Save2('channel', 'Канал');
  Save2('pict', 'Картинки');
  Save2('common', 'Папка входящие');
  Save2('update', 'Загрузить обновления?');
  Save2('block', 'Заблокировать');
  Save2('delete', 'Удалить');
  Save2('bad_ip', 'Неправильный ip-адрес');
  Save2('overwrite', 'уже есть в контактах, перезаписать?');
  Save2('add_user', 'Добавить в контакты?');
  Save2('add_title', 'Введите заголовок');
  Save2('no_send', 'Не удалось отправить сообщение');
  Save2('personal2', 'ЛИЧНОЕ');
  Save2('group', 'ГРУППОВОЕ');
  Save2('msgok', 'сообщение доставлено');
  Save2('need_restart', 'Произведите рестарт');
  Save2('update_err', 'Ошибка обновления');
  Save2('update_check', 'Проверить обновления');
  Save2('update_exist', 'Доступны обновления');
  Save2('err_file', 'Ошибка приема файла');
  Save2('update_page', 'Обновление');
  Save2('update_req', 'Проверка обновлений..');
  Save2('update_not_exist', 'Нет новых версий');
  Save2('update_ok', 'Загружено обновление');
  Save2('close', 'Закрыть');
  Save2('ititle', 'ИКОМ');
  Save2('video', 'Видео');
  Save2('flash', 'Flash');
  Save2('i_am', 'Это я');
  Save2('check_ip', 'Проверьте выбранный IP адрес');
  Save2('user', 'Имя');
  Save2('password', 'Пароль');
  Save2('setup_menu', 'Настройки');
  Save2('extstat_menu', 'Текстовый статус');
  Save2('help_menu', 'Справка');
  Save2('on', 'ВКЛ');
  Save2('off', 'ВЫКЛ');
  Save2('show_off', 'Показывать оффлайн');
  Save2('auto_scroll', 'Автоскролл');
  Save2('ver', 'Версия');
  Save2('message', 'Сообщение');
  Save2('from', 'от');
  Save2('WaitAdd','Ожидающие добавления');
  Save2('About_menu','О программе');
  Save2('Restart_menu','Рестарт');
  Save2('Exit_menu','Выход');
  Save2('Mem_Warning','Мало свободной памяти, очистите трафик');
  Save2('secure_send','Защищенная отправка картинок');
  Save2('free_send','Открытая отправка картинок');
  Save2('except_red','[кроме красных]');
  Save2('lang_hint','Язык ввода');
  Save2('font_hint','Левая кнопка-выбор шрифта/Правая кнопка-свой шрифт по умолчанию');
  Save2('smile_hint','Смайлики');
  Save2('cit_hint','Цитата');
  Save2('file_hint','Отправить файл');
  Save2('clear_hint','Очистить');
  Save2('send_hint','Отправить сообщение');
  Save2('save','Сохранить');
  Save2('cancel','Отмена');
  Save2('protected','(защита паролем)');
  save2('not_safe', 'Не безопасный файл, все равно запустить?');
  save2('main_menu_hint', 'Меню');
  Save2('send_update', 'Послать обновление?');
  Save2('plugin','Плагины');
  Save2('online','В сети');
end;

// записывает язык по умолчанию (встроенный)
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
