unit api;

interface

uses classes, controls,  StdCtrls, Buttons, ExtCtrls;
// ����� ������� ��������� � ����� ������ (������� ���������� �� ���������� �������)!!!
type
  IPluginInterface = interface
  ['{48809745-8FFC-4A6C-98F5-AE7805AD6FE3}']
  // ������ api
  function GetApiVer:widestring; stdcall;
  // ��������� ���������� �� ��������
  function GetVar(name:widestring):variant; stdcall;
  // ������� ������ ��� �������
  function plugin_button(plugin_name:WideString):WideString; stdcall;
  // ������� ������ ��� ������� 
  function plugin_panel(plugin_name:widestring):widestring; stdcall;
  // ������� ������� �� ������ ������� (�� ����� ����)
  function create_control(plugin_name, type_name, parent_name:widestring):widestring; stdcall;
  // ���������� ���������
  procedure SetCaption(plugin_name, control_name, text:widestring); stdcall;
  // ���������� �����
  procedure SetText(Plugin_name, control_name, text:widestring); stdcall;
  // ��������� �����
  function GetText(Plugin_name, control_name:widestring):widestring; stdcall;
  // ������������
  procedure SetAlign(Plugin_name, control_name:widestring; Align:Talign); stdcall;
  // ��������� � �������
  procedure SetWindow(Plugin_name, control_name:widestring; left, top, width, height:integer); stdcall;
  // ���������
  procedure SetVisible(Plugin_name, control_name:widestring; visible:boolean); stdcall;
  // ���������� onclick
  procedure SetOnclick(Plugin_name, control_name:WideString; proc:pointer); stdcall;
  // ���������� onKeyDown
  procedure SetOnKeyDown(Plugin_name, control_name:widestring; proc:pointer); stdcall;
  // �������� ����� � ���� �����
  procedure InsertText(text:widestring); stdcall;
  // ��������� ����� �� ���� �����
  function GetInput:widestring; stdcall;
  // �������� �������� � ���� �����
  Procedure InsertImage(image:pointer); stdcall;
  // �������� �� ������
  Procedure SetGlyphStream(Plugin_name, control_name:widestring; image:pointer); stdcall;
  // �������� �� ������
  Procedure SetGlyphFile(Plugin_name, control_name:widestring; image:WideString); stdcall;
  // �������� ���. ��������� �-�������
  function GetFreePos:integer; stdcall;
  // ����������
  Procedure SetFreePos(ps:integer); stdcall;
  // ���������� ������
  procedure SetChecked(plugin_name, control_name:widestring; check:boolean); stdcall;
  // ��������� ������
  function GetChecked(plugin_name, control_name:widestring):boolean; stdcall;
  // ���������� �������/3d ������
  procedure SetFlat(plugin_name, control_name:widestring; flats:boolean); stdcall;
  // ���������� ���� �� �������
  procedure SetHint(plugin_name, control_name, hint_text:widestring); stdcall;
  // ��������� �������� �� �����
  function Download(Url:widestring):widestring; stdcall;
  // ��������� �������� �� ��������� ����
  function DownloadLocal(Url:widestring):widestring; stdcall;
  // �������� html-���� �� �������
  procedure ShowPage(tab_name, file_name:widestring); stdcall;
  // ������� ������ ����
  Procedure SendRAW(package:widestring); stdcall;
  // ���������� ���������� ��������
  procedure SetVar(name:widestring;value:variant); stdcall;
  // ������ � ��� �����
  procedure IcomLog(msg:widestring); stdcall;
  // �������� � ���������
  procedure addToPopup(plugin_name, control_name, caption:widestring; proc:pointer); stdcall;
  // ������ ������ ��� ��������
  function GetPluginHeight:integer; stdcall;
  //
  function empty1:boolean; stdcall;
  // ������
  procedure SetWindowHeight(Plugin_name, control_name:widestring; height:integer); stdcall;
  // ������
  procedure SetWindowWidth(Plugin_name, control_name:widestring; width:integer); stdcall;
  // �������� ������ �������������
  function GetUserList: widestring; stdcall;
  // ���� �����
  function GetPort: integer; stdcall;
  // ������ ������������
  function GetUserStatus(ip:widestring):integer; stdcall;
  // ���� �� ������
  function FindPlugin(name:widestring):boolean; stdcall;
  // ������� ������
  Procedure TCPSend(ip, package:widestring); stdcall;
  // ���� ip
  function GetIP: widestring; stdcall;
  //
  procedure SendFileV2(ip, FileName:widestring); stdcall;
  //
  procedure StartHttp; stdcall;
  // ������ ��������
  function GetUserPlugins(ip:widestring):widestring; stdcall;
  //
  function GetSelectedUser:widestring; stdcall;
  //
  procedure addSimpleMessage(msg: widestring); stdcall;

  end;

 implementation


end.
