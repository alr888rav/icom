unit api;

interface

uses classes, controls,  StdCtrls, Buttons, ExtCtrls;
// новые функции добавлять в КОНЕЦ списка (функции вызываются по порядковым номерам)!!!
type
  IPluginInterface = interface
  ['{48809745-8FFC-4A6C-98F5-AE7805AD6FE3}']
  // версия api
  function GetApiVer:widestring; stdcall;
  // получение переменной из настроек
  function GetVar(name:widestring):variant; stdcall;
  // создать кнопку для плагина
  function plugin_button(plugin_name:WideString):WideString; stdcall;
  // создать панель для плагина 
  function plugin_panel(plugin_name:widestring):widestring; stdcall;
  // создаем контрол на панели плагина (по имени типа)
  function create_control(plugin_name, type_name, parent_name:widestring):widestring; stdcall;
  // установить заголовок
  procedure SetCaption(plugin_name, control_name, text:widestring); stdcall;
  // установить текст
  procedure SetText(Plugin_name, control_name, text:widestring); stdcall;
  // прочитать текст
  function GetText(Plugin_name, control_name:widestring):widestring; stdcall;
  // выравнивание
  procedure SetAlign(Plugin_name, control_name:widestring; Align:Talign); stdcall;
  // положение и размеры
  procedure SetWindow(Plugin_name, control_name:widestring; left, top, width, height:integer); stdcall;
  // видимость
  procedure SetVisible(Plugin_name, control_name:widestring; visible:boolean); stdcall;
  // назначение onclick
  procedure SetOnclick(Plugin_name, control_name:WideString; proc:pointer); stdcall;
  // назначение onKeyDown
  procedure SetOnKeyDown(Plugin_name, control_name:widestring; proc:pointer); stdcall;
  // вставить текст в поле ввода
  procedure InsertText(text:widestring); stdcall;
  // прочитать текст из поля ввода
  function GetInput:widestring; stdcall;
  // вставить картинку в поле ввода
  Procedure InsertImage(image:pointer); stdcall;
  // картинку на кнопку
  Procedure SetGlyphStream(Plugin_name, control_name:widestring; image:pointer); stdcall;
  // картинку на кнопку
  Procedure SetGlyphFile(Plugin_name, control_name:widestring; image:WideString); stdcall;
  // получить мин. свободную х-позицию
  function GetFreePos:integer; stdcall;
  // установить
  Procedure SetFreePos(ps:integer); stdcall;
  // установить флажок
  procedure SetChecked(plugin_name, control_name:widestring; check:boolean); stdcall;
  // прочитать флажок
  function GetChecked(plugin_name, control_name:widestring):boolean; stdcall;
  // установить плоскую/3d кнопку
  procedure SetFlat(plugin_name, control_name:widestring; flats:boolean); stdcall;
  // установить хинт на контрол
  procedure SetHint(plugin_name, control_name, hint_text:widestring); stdcall;
  // загрузить страницу из инета
  function Download(Url:widestring):widestring; stdcall;
  // загрузить страницу из локальной сети
  function DownloadLocal(Url:widestring):widestring; stdcall;
  // показать html-файл на вкладке
  procedure ShowPage(tab_name, file_name:widestring); stdcall;
  // послать данные всем
  Procedure SendRAW(package:widestring); stdcall;
  // установить переменную настроек
  procedure SetVar(name:widestring;value:variant); stdcall;
  // запись в лог икома
  procedure IcomLog(msg:widestring); stdcall;
  // добавить в попапменю
  procedure addToPopup(plugin_name, control_name, caption:widestring; proc:pointer); stdcall;
  // Выоота панели для плагинов
  function GetPluginHeight:integer; stdcall;
  //
  function empty1:boolean; stdcall;
  // высота
  procedure SetWindowHeight(Plugin_name, control_name:widestring; height:integer); stdcall;
  // ширина
  procedure SetWindowWidth(Plugin_name, control_name:widestring; width:integer); stdcall;
  // получить список пользователей
  function GetUserList: widestring; stdcall;
  // порт икома
  function GetPort: integer; stdcall;
  // статус пользователя
  function GetUserStatus(ip:widestring):integer; stdcall;
  // есть ли плагин
  function FindPlugin(name:widestring):boolean; stdcall;
  // послать данные
  Procedure TCPSend(ip, package:widestring); stdcall;
  // свой ip
  function GetIP: widestring; stdcall;
  //
  procedure SendFileV2(ip, FileName:widestring); stdcall;
  //
  procedure StartHttp; stdcall;
  // список плагинов
  function GetUserPlugins(ip:widestring):widestring; stdcall;
  //
  function GetSelectedUser:widestring; stdcall;
  //
  procedure addSimpleMessage(msg: widestring); stdcall;

  end;

 implementation


end.
