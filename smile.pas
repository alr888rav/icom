unit smile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RVStyle, extctrls, Grids, stdctrls, ComCtrls,
  JvAnimatedImage,
  JvGIFCtrl, Menus, ExtDlgs, icomView, desktop;

type
  TSmileForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    AddTrafMenu: TPopupMenu;
    AddPictMenu: TMenuItem;
    DeletePictMenu: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CreateMainViewHTML;
    procedure CreateAniView;
    procedure CreateAddView;
    procedure WebBrowser0BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowser1BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowser2BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure AddPictMenuClick(Sender: TObject);
    procedure DelImage(fname: string);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DeletePictMenuClick(Sender: TObject);
  private
    { Private declarations }
    htmlviewer0: TIcomViewer;
    htmlviewer1: TIcomViewer;
    htmlviewer2: TIcomViewer;
  public

    { Public declarations }
  end;

var
  SmileForm: TSmileForm;

implementation

uses main, commonLib, Global, ulog, wbpopup, htmllib;

{$R *.DFM}

procedure TSmileForm.CreateMainViewHTML;
var
  i, x, y: integer;
  sr: TSearchRec;
  sl: TstringList;
  ht: TStringList;
  ext: string;
  dir: string;
begin
  dir := HTMLdir + '\Smiles\';
  htmlviewer0 := TIcomViewer.create(TabSheet1);
  htmlviewer0.Align := alclient;
  htmlviewer0.OnBeforeNavigate2 := WebBrowser0BeforeNavigate2;

  sl := TstringList.create;
  if FindFirst(dir + 'smi*.gif', faAnyfile, sr) = 0 then
    repeat
      if (sr.Name = '.') or (sr.Name = '..') then
        continue;
      ext := uppercase(extractfileext(sr.Name));
      if (ext = '.GIF') then
        sl.Add(sr.Name);
    until (findnext(sr) <> 0);
  findclose(sr);
  sl.Sort;

  ht := TStringList.Create;
  ht.add( '<html><body>');
  ht.add( '<table style="text-align: center; width: ' + inttostr(htmlviewer0.width - 100) + 'Px;" border="0" cellpadding="0" cellspacing="0">');
  i := 0;
  for y := 0 to 5 do
  begin
    ht.add( '<tr>');
    for x := 0 to 9 do
    begin
      if i < sl.Count then
        ht.add( '<td>' + '<a href="' + LNK_FILE + dir + sl.Strings[i] + '">' + '<img border="0" src="' + dir + sl.Strings[i] + '">' + '</a>' + '</td>')
      else
        ht.add( '<td>&nbsp;</td>');
      i := i + 1;
    end;
    ht.add( '</tr>');
  end;
  ht.add( '</body></html>');
  htmlviewer0.LoadFromString(ht.Text);
  sl.Free;
  ht.Free;
end;

procedure TSmileForm.CreateAddView;
var
  i: integer;
  sr: TSearchRec;
  sl: TstringList;
  ht: TstringList;
  ext: string;
  w, h: Word;
  w_text: string;
  dir: string;
const
  w_max = 100;
begin
  dir := HTMLdir + 'AddSmiles\';
  htmlviewer2 := TIcomViewer.create(TabSheet3);
  htmlviewer2.Align := alClient;
  htmlviewer2.OnBeforeNavigate2 := WebBrowser2BeforeNavigate2;
  htmlviewer2.PopupMenu := AddTrafMenu;

  sl := TstringList.create;
  if FindFirst(dir + '*.*', faAnyfile, sr) = 0 then
    repeat
      if (sr.Name = '.') or (sr.Name = '..') then
        continue;
      ext := uppercase(extractfileext(sr.Name));
      if (ext = '.GIF') or (ext = '.JPG') or (ext = '.JPEG') or (ext = '.PNG') then
        sl.Add(sr.Name);
    until (findnext(sr) <> 0);
  findclose(sr);
  sl.Sort;

  ht := TStringList.Create;
  ht.add( '<html><body>');
  for i := 0 to sl.Count - 1 do
  begin
    GetImageSize(dir + sl.Strings[i], w, h);
    if (w > w_max) then
      w_text := 'width: ' + inttostr(w_max) + 'px;'
    else
      w_text := '';
    ht.add( '<a href="' + LNK_FILE + dir + sl.Strings[i] + '">' + '<img style="' + w_text + ' border: 0px;" src="' + dir + sl.Strings[i] + '">' + '</a>');
  end;
  ht.add( '</body></html>');
  htmlviewer2.LoadFromString(ht.Text);
  sl.Free;
  ht.Free;
end;

procedure TSmileForm.CreateAniView;
var
  i, x, y: integer;
  sl: TstringList;
  ht: TstringList;
  sr: TSearchRec;
  ext: string;
  dir: string;
const
  w_max = 60;
begin
  dir := HTMLdir + '\Smiles\';
  htmlviewer1 := TIcomViewer.create(TabSheet2);
  htmlviewer1.Align := alclient;
  htmlviewer1.OnBeforeNavigate2 := WebBrowser1BeforeNavigate2;

  sl := TstringList.create;
  if FindFirst(HTMLdir + '\Smiles\ani*.*', faAnyfile, sr) = 0 then
    repeat
      if (sr.Name = '.') or (sr.Name = '..') then
        continue;
      ext := uppercase(extractfileext(sr.Name));
      if (ext = '.GIF') then
        sl.Add(sr.Name);
    until (findnext(sr) <> 0);
  findclose(sr);
  sl.Sort;

  ht := TStringList.Create;
  ht.add( '<html><body>');

  ht.add( '<table style="text-align: center; width: ' + inttostr(htmlviewer1.width - 100) + 'Px;" border="0" cellpadding="0" cellspacing="0">');
  i := 0;
  for y := 0 to 6 do
  begin
    ht.add( '<tr>');
    for x := 0 to 7 do
    begin
      if i < sl.Count then
        ht.add( '<td style="vertical-align: middle;">' + '<a href="' + LNK_FILE + dir + sl.Strings[i] + '">' + '<img style="border: 0px solid;" src="' +
          dir + sl.Strings[i] + '">' + '</a>' + '</td>');
      i := i + 1;
    end;
    ht.add( '</tr>');
  end;
  ht.add( '</body></html>');
  htmlviewer1.LoadFromString(ht.Text);
  sl.Free;
  ht.Free;
end;

procedure TSmileForm.FormCreate(Sender: TObject);
begin
  SmileForm.width := 670;
  SmileForm.height := 450;
  CreateMainViewHTML;
  CreateAniView;
  CreateAddView;
end;

procedure TSmileForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  close;
end;

procedure TSmileForm.DeletePictMenuClick(Sender: TObject);
begin
  if not fileexists(copy(wbPopup.href,9)) then
    exit;
  delimage(copy(wbPopup.href,9));
end;

procedure TSmileForm.DelImage(fname: string);
begin
  if MessageDlg('Удалить ' + fname + ' ?', mtWarning, [mbYes, mbNo], 0) <> mrYes then
    exit;
  if fileexists(fname) then
  begin
    deletefile(fname);
    CreateAddView;
  end;
end;

procedure TSmileForm.FormActivate(Sender: TObject);
begin
  SmileForm.left := mainform.Left + mainform.SmileBtn3.Left +  mainform.SmileBtn3.Width - (self.Width div 2) ;
  if SmileForm.left < 0 then
    SmileForm.left := 0;
  SmileForm.top := MainForm.top + MainForm.MemoinPanel.top - Self.Height + WindowTitle;
  if SmileForm.Top < 0 then
    SmileForm.Top := 0;
  PageControl1.activepageindex := 0;
  CreateAddView;
end;

procedure TSmileForm.WebBrowser0BeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
  url2: string;
  tempGif: TjvGIFAnimator;
  nm: string;
  ext: string;
  tempImg: TImage;
begin
  url2 := urldecode(URL);
  url2 := dellast(url2);
  url2 := Copy(url2, Pos('//', url2)+2);
  if (uppercase(extractfilepath(url2))=uppercase(htmldir+'SMILES\'))and(uppercase(extractfileext(url2))='.HTML') then
  begin
    cancel:=false;
    exit;
  end;
  try
    ext := uppercase(extractfileext(url2));
    if ext = '.GIF' then
    begin
      tempGif := TjvGIFAnimator.create(nil);
      tempGif.Image.LoadFromFile(url2);
      tempGif.Animate := true;
      tempGif.AutoSize := true;
      nm := copy(extractfilename(url2), 1, pos('.GIF', extractfilename(uppercase(url2))) - 1);
      MainForm.memoin.InsertControl(ansistring(nm), tempGif, rvvaBaseline);
    end
    else if (ext = '.PNG') or (ext = '.JPG') then
    begin
      tempImg := TImage.create(nil);
      tempImg.Picture.LoadFromFile(url2);
      tempImg.Transparent := true;
      tempImg.AutoSize := true;
      tempImg.visible := False;
      nm := copy(extractfilename(url2), 1, pos('.PNG', extractfilename(uppercase(url2))) - 1);
      MainForm.memoin.InsertControl(ansistring(nm), tempImg, rvvaBaseline);
    end;
    MainForm.memoin.reFormat;
  finally
    Cancel:=true;
    if Setup.closeSmiles then
      close;
  end;
end;

procedure TSmileForm.WebBrowser1BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
var
  url2: string;
  tempGif: TjvGIFAnimator;
  nm: string;
  ext: string;
  tempImg: TImage;
begin
  url2 := urldecode(URL);
  url2 := dellast(url2);
  url2 := Copy(url2, Pos('//', url2)+2);
  if (uppercase(extractfilepath(url2))=uppercase(htmldir+'SMILES\'))and(uppercase(extractfileext(url2))='.HTML') then
  begin
    cancel:=false;
    exit;
  end;
  try
    ext := uppercase(extractfileext(url2));
    if ext = '.GIF' then
    begin
      tempGif := TjvGIFAnimator.create(nil);
      tempGif.Image.LoadFromFile(url2);
      tempGif.Animate := true;
      tempGif.AutoSize := true;
      nm := copy(extractfilename(url2), 1, pos('.GIF', extractfilename(uppercase(url2))) - 1);
      MainForm.memoin.InsertControl(ansistring(nm), tempGif, rvvaBaseline);
    end
    else if (ext = '.PNG') or (ext = '.JPG') then
    begin
      tempImg := TImage.create(nil);
      tempImg.Picture.LoadFromFile(url2);
      tempImg.Transparent := true;
      tempImg.AutoSize := true;
      tempImg.visible := False;
      nm := copy(extractfilename(url2), 1, pos('.PNG', extractfilename(uppercase(url2))) - 1);
      MainForm.memoin.InsertControl(ansistring(nm), tempImg, rvvaBaseline);
    end;
    MainForm.memoin.reFormat;
  finally
    Cancel := true;
    if Setup.closeSmiles then
      close;
  end;
end;

procedure TSmileForm.WebBrowser2BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
var
  url2: string;
begin
  url2 := urldecode(URL);
  url2 := dellast(url2);
  url2 := Copy(url2, Pos('//', url2)+2);
  if (uppercase(extractfilepath(url2))=uppercase(htmldir+'ADDSMILES\'))and(uppercase(extractfileext(url2))='.HTML') then
  begin
    cancel:=false;
    exit;
  end;
  if copy(url2,1,6)='del://' then
    delImage(copy(url2,7))
  else
  begin
    try
      MainForm.InsertFileImage(url2);
    finally
      cancel := true;
      if Setup.closeSmiles then
        close;
    end;
  end;
end;

procedure TSmileForm.AddPictMenuClick(Sender: TObject);
var
  file_name: string;
begin
  try // opendialog может вылетать на некоторых файлах
    if (pos(path, OpenPictureDialog1.FileName) <> 0) or (pos(path, OpenPictureDialog1.Initialdir) <> 0) or (OpenPictureDialog1.FileName = '') or
      (OpenPictureDialog1.Initialdir = '') then
    begin
      OpenPictureDialog1.FileName := '*.*';
      OpenPictureDialog1.Initialdir := path;
    end;
    OpenPictureDialog1.filter := 'All |*.gif;*.png;*.jpg;*.jpeg';
    OpenPictureDialog1.FilterIndex := 0;
    if not OpenPictureDialog1.Execute then
      exit;
    file_name := OpenPictureDialog1.FileName;
    if fileexists(file_name) then
    begin
      mycopyfile(file_name, HTMLdir + 'addsmiles\' + extractfilename(file_name));
      CreateAddView;
    end;
  except
    on E: Exception do
      log('addsmile ' + E.Message);
  end;
end;

end.
