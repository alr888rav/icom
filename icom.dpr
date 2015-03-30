//ALR (c) 2006-2014
program icom;

uses
  windows,
  sysutils,
  Graphics,
  Jpeg,
  ExtCtrls,
  Classes,
  shellapi,
  stdctrls,
  Dialogs,
  Vcl.Forms,
  vcl.Controls,
  about in 'about.pas' {fmAbout},
  api in 'api.pas',
  api_works in 'api_works.pas',
  Global in 'Global.pas',
  icomchannels in 'icomchannels.pas',
  icomClipboard in 'icomClipboard.pas',
  icomNET in 'icomNET.pas',
  icomPlugins in 'icomPlugins.pas',
  language in 'language.pas',
  MAIN in 'MAIN.PAS' {mainForm},
  newuser in 'newuser.pas' {fmNewUser},
  setting in 'setting.pas',
  smile in 'smile.pas' {SmileForm},
  ulog in 'ulog.pas',
  upagecontrol in 'upagecontrol.pas',
  userslist in 'userslist.pas',
  VERS in 'VERS.PAS',
  wtsapi in 'wtsapi.pas',
  htmllib in 'htmllib.pas',
  desktop in 'desktop.pas',
  tray in 'tray.pas',
  reslib in 'reslib.pas',
  IcomUserBox in 'IcomUserBox.pas',
  extentions in 'extentions.pas',
  Vcl.Themes,
  Vcl.Styles,
  sform in 'sform.pas' {setupform},
  MSHTML_TLB in 'Lib\MSHTML_TLB.pas',
  wbpopup in 'Lib\wbpopup.pas',
  IEbrowser in 'IEbrowser.pas',
  icomView in 'icomView.pas',
  winnet in 'winnet.pas',
  myplayer in 'myplayer.pas',
  simpleEncrypt in 'simpleEncrypt.pas',
  commonlib in 'commonlib.pas',
  myPageControl in 'myPageControl.pas',
  ieredimer in 'Lib\ieredimer.pas';

{$R .\myresource\smile_new\smile.res }
{$R .\myresource\add\add.res }
{$R .\myresource\mp3\sound.res }
{$R .\myresource\help\help.res }
{$R .\myresource\gif\anismile.res }
{$R .\myresource\lang\lang.res }
{$R icom.res }

begin
  path := extractfilepath(Application.exename);
  SoundDir := path + 'Sound\';
  HTMLDir := path + 'HTML\';
  CacheDir := path + 'Temp\';
  LangDir := path + 'Languages\';
  createdir(LangDir);
  createdir(SoundDir);
  createdir(CacheDir);
  createdir(HTMLDir);
  createdir(HTMLDir + '\Smiles\');
  createdir(HTMLDir + '\AddSmiles\');
  createdir(path + 'Plugins\');
  CreateDir(LangDir);
  extractLang;
  lang := TLangClass.Create;
  // настройки
  user_list := TUsers.Create;
  Setup := TSetupClass.Create;
  Setup.LoadSetup;
  ExtractResource(Setup);

  Application.ShowMainForm := false;
  Application.Initialize;
  Application.CreateForm(TmainForm, mainForm);
  if main.one_copy then
      exit;
  Application.CreateForm(TSmileForm, SmileForm);
  Application.CreateForm(TfmAbout, fmAbout);
  Application.CreateForm(TfmNewUser, fmNewUser);
  Application.CreateForm(Tsetupform, setupform);

  lang.SaveDefaultLang;
  lang.loadLangs;
  Lang.LoadLang(Setup.icomlang);
  mainForm.ApplySetup;
  Setup.LoadFree;

  // вкл обработчик
  mainForm.TrayIcon.Visible := true;
  mainForm.TrayIcon.OnClick := mainForm.TrayIconClick;

  NetWork := TNetWork.Create;
  // без прокси
  NetWork.SetProxy(':0');
  if NetWork.Start then
  begin
    PostMessage(mainform.Handle, WM_AFTER_CREATE, 0, 0);
    mainForm.Timer1sek.enabled := true;
    Application.Run;
  end;
  myFreeAndNil(NetWork);
  log('end');
end.
