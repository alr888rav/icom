unit IEbrowser;

interface

uses windows, SHDocVw, activex, classes, forms, Dialogs, Controls, StdCtrls, extctrls,
     Graphics, variants, OleCtrls, sysutils, math, MSHTML_TLB;

type
  TIEBrowser=class(TWebBrowser)
  private
    IEPanel:Tpanel;
    FAlign: TAlign;
    FCurrentFile: string;
    function GetDocument:string;
    Procedure SetAlign(value:Talign);
    Procedure PanelResize(Sender: TObject);
    function GetSelText:string;
    function GetSelLength:integer;
    function GetFormByNumber(formNumber: integer): IHTMLFormElement;
    function GetBase:string;
    function GetScrollPos:integer;
    function GetScrollPos2:integer;
    function GetScrollPos3:integer;
    procedure SetScrollPos3(value:integer);
    function GetScrollHeight:integer;
    function GetScrollHeight2:integer;
    //procedure setFlat(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
  public
    ImageCacheCount: integer;
    ScrollBars: TscrollStyle;
    DefFontName: string;
    Property ScrollPos:integer read GetScrollpos3 write SetScrollPos3; // для всего!
    Property SelLength:integer read GetselLength;
    property SelText:string read GetSelText;
    property Align:TAlign read FAlign write SetAlign;
    property DocumentSource:string read GetDocument;
    Property CurrentFile:string read FCurrentFile;
    Property Base: string read GetBase;
    Property DocHeight: Integer read GetScrollHeight;
    Property DocHeight2: Integer read GetScrollHeight2;

    function Ready:boolean;
    Procedure GoBegin;
    Procedure GoEnd;
    procedure ExecuteScript(script: string; ShowError: Boolean=false);
    Procedure CopyToClipBoard;
    Procedure SaveHtml(FileName:string);
    procedure SaveToStream(const Stream: TStream);
    function  SaveToString: string;
    procedure LoadFromStream(const Stream: TStream);
    procedure LoadFromFile(fname:string);
    procedure LoadFromString(Text: string);
    procedure LoadFromString2(Text: string);
    //procedure ReloadFile;
    Procedure ReAlign;
    procedure selectall;
    function GetFieldValue(formNUmber: integer; const fieldName: string; const instance: integer=0):string;
    procedure SetFieldValue(formNUmber: integer; const fieldName: string; const newValue: string; const instance: integer=0);
    function GetElementById(const Id: string): IDispatch;
    procedure Append(html: string);

    Constructor Create(AControl: TComponent); override;
    Destructor Destroy; override;
  end;

implementation

// wait 10sek max
function TIEBrowser.Ready:boolean;
var
  i:integer;
begin
  result:=false;
  for i:=0 to 100 do
  begin
    if (ReadyState=READYSTATE_COMPLETE) then
    begin
      result:=true;
      break;
    end;
    sleep(100);
    forms.Application.ProcessMessages;
  end;
end;

// работает всегда
Procedure TIEBrowser.GoBegin;
begin
  if Assigned(document) and ready then
    OleObject.Document.ParentWindow.ScrollTo(0,0);
end;

// работает всегда
Procedure TIEBrowser.GoEnd;
begin
  if Assigned(document) and ready then
    OleObject.Document.ParentWindow.ScrollTo(0,GetScrollHeight);
end;

function TIEBrowser.GetBase:string;
begin
  result := LocationURL;
end;

procedure TIEBrowser.SelectAll;
begin
  if ready then
    ExecWB(OLECMDID_SELECTALL, OLECMDEXECOPT_DODEFAULT);
end;

function TIEBrowser.GetSelLength:integer;
begin
  result:=length(GetSelText);
end;

function TIEBrowser.GetSelText:string;
var
  Doc: Variant;
begin
  if self.Document <> nil then
  begin
    Doc := self.Document;
    try
       Result := Doc.Selection.createRange.Text
    finally
       Doc := Unassigned;
    end;
  end
  else
    Result := '';
end;

Procedure TIEBrowser.PanelResize(Sender: TObject);
begin
  Self.ReAlign;
end;

{procedure TIEBrowser.setFlat(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
begin
  OleObject.document.body.style.borderstyle := 'none';
end;}

Constructor TIEBrowser.Create(AControl: TComponent);
begin
  IEPanel:=Tpanel.Create(Acontrol);
  IEPanel.Parent:=TWinControl(Acontrol);
  IEPanel.Ctl3D := false;
  IEPanel.BevelInner := bvNone;
  IEPanel.BevelOuter := bvNone;
  IEPanel.BorderStyle:=bsNone;
  IEPanel.OnResize:=PanelResize;
  IEPanel.DoubleBuffered:=false;
  IEPanel.Margins.Top := 0;
  inherited Create(IEPanel);
  Self.ParentWindow:=IEPanel.Handle;
  Self.Align := alClient;
  self.DoubleBuffered:=false;
  self.Margins.Top:=0;
  self.BorderWidth:=0;
  //self.OnNavigateComplete2 := setFlat;
  Navigate('about:blank');
end;

Destructor TIEBrowser.Destroy;
begin
  inherited Destroy;
end;

Procedure TIEBrowser.ReAlign;
var
  WindRect : TRect;
begin
  IEPanel.Align:=FAlign;
  IEPanel.Realign;
  WindRect:=IEPanel.ClientRect;
  Self.Left:= WindRect.Left;
  Self.Top:= WindRect.Top;
  self.Width:=WindRect.Width;
  self.Height:=WindRect.Height;
end;

// в IE не работает автоматическов выравнивание по родительскому контролу
Procedure TIEBrowser.SetAlign(value:Talign);
begin
  FAlign:=value;
  Realign;
end;

Procedure TIEBrowser.CopyToClipBoard;
begin
  ExecWB(OLECMDID_COPY, OLECMDEXECOPT_PROMPTUSER);
end;

{
procedure TIEBrowser.ReloadFile;
begin
  if fileexists(FCurrentFile) then
    loadfromfile(FCurrentFile);
end;
}
// исходный текст html-страницы
function TIEBrowser.GetDocument:string;
begin
  if Assigned(Document)and(ready) then
  begin
    Result := VarToStr(OleObject.Document.documentElement.outerHTML);
  end;
end;

// ansi или юникодный файл
{Procedure TIEBrowser.SaveHtml(FileName:string);
var
  PersistStream: IPersistStreamInit;
  sStream: TStringStream;
  Stream: IStream;
  SaveResult: HRESULT;
begin
  if Assigned(Document)and(Ready) then
  begin

    PersistStream := Document as IPersistStreamInit;
    sStream := TStringStream.Create('');
    try
      Stream := TStreamAdapter.Create(sStream, soReference) as IStream;
      SaveResult := PersistStream.Save(Stream, True);
      if FAILED(SaveResult) then
         MessageBox(Handle, 'Fail to save HTML source', 'Error', 0)
      else
      begin
        sStream.Position:=0;
        sstream.SaveToFile(FileName);
      end;
      Stream := nil;
    finally
      sStream.Free;
    end;
  end;
end;
}
// дополненный/очищенный оригиал
Procedure TIEBrowser.SaveHtml(FileName:string);
var
  ss: TStringStream;
begin
  ss := TStringStream.Create(GetDocument);
  ss.SaveToFile(FileName);
  ss.Free;
end;
{
// ansi или юникодный файл
procedure TIEBrowser.SaveHtml3(const FileName: string);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

// дополненный/очищенный оригинал
Procedure TIEBrowser.SaveHtml4(FileName:string);
var
  sl:tstringlist;
begin
  sl := tstringlist.Create;
  sl.Text := DocumentSource;
  sl.SaveToFile(filename);
  sl.Free;
end;
}
function TIEBrowser.SaveToString: string;
var
  StringStream: TStringStream;
begin
  StringStream := TStringStream.Create('');
  try
    SaveToStream(StringStream);
    Result := StringStream.DataString;
  finally
    StringStream.Free;
  end;
end;

procedure TIEBrowser.SaveToStream(const Stream: TStream);
var
  StreamAdapter: IStream;
  PersistStreamInit: IPersistStreamInit;
begin
  if not Assigned(Document) then
    Exit;
  if Document.QueryInterface(IPersistStreamInit, PersistStreamInit) = S_OK then
  begin
    StreamAdapter := TStreamAdapter.Create(Stream);
    PersistStreamInit.Save(StreamAdapter, True);
    StreamAdapter := nil;
    PersistStreamInit := nil;
  end;
end;

procedure TIEBrowser.LoadFromFile(fname:string);
var
 sl: TStringList;
begin
  sl := TStringList.Create;
  sl.LoadFromFile(fname);
  LoadFromString(sl.Text);
  sl.Free;
end;
{
// scrollpos после этого ставится неправильно
procedure TIEBrowser.LoadFromFile2(fname:string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FName, fmOpenRead or fmShareDenyWrite);
  try
    Stream.Seek(0, 0);
    if Assigned(Document) then
    begin
      (Document as IPersistStreamInit).Load(TStreamAdapter.Create(Stream));
    end;
  finally
    Stream.Free;
  end;
end;

procedure TIEBrowser.LoadFromFile3(const FileName: string);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure TIEBrowser.LoadFromFile4(const FileName: string);
var
  StringStream: TStringStream;
begin
  StringStream := TStringStream.Create('');
  StringStream.LoadFromFile(FileName);
  try
    LoadFromStream(StringStream);
  finally
    StringStream.Free;
  end;
end;
}
// вся высота документа
function TIEBrowser.GetScrollHeight:integer;
var
//  doc: IHTMLDocument3;
  body: variant;
//  html: IHTMLElement;
  h,h1,h2,h3:extended;
begin
  if Assigned(Document)and(Ready) then
  begin
    body := OleObject.document.body;
    //html = document.documentElement;

    h1 := Math.max(body.scrollHeight, body.offsetHeight);
    h2 := math.Max(body.clientHeight, body.scrollHeight);
    h3 := body.offsetHeight;
    h := math.Max(math.max(h1, h2), h3);
   // Document.QueryInterface(IHTMLDocument3, Doc);
   // result := ((Doc as IHTMLDocument3).documentElement as IHTMLElement2).scrollHeight;
   // Doc := nil;
    Result := trunc(h);
  end
  else
    result := 0;
end;

function TIEBrowser.GetScrollPos:integer;
var
  doc: IHTMLDocument3;
begin
  if Assigned(Document)and(Ready) then
  begin
    Document.QueryInterface(IHTMLDocument3, Doc);
    result := ((Doc as IHTMLDocument3).documentElement as IHTMLElement2).scrollTop;
    doc := nil;
  end
  else
    Result := 0;
end;

{
procedure TIEBrowser.SetScrollPos(value:integer);
var
  doc: IHTMLDocument3;
begin
  if Assigned(Document)and(ready) then
  begin
    Document.QueryInterface(IHTMLDocument3, Doc);
    ((Doc as IHTMLDocument3).documentElement as IHTMLElement2).scrollTop := value;
    doc := nil;
  end;
end;
}
// высота документа без отступов
function TIEBrowser.GetScrollHeight2:integer;
begin
  if Assigned(document) and ready then
    Result := OleObject.document.body.ClientHeight
  else
    Result := 0;
end;

function TIEBrowser.GetScrollPos2:integer;
begin
  if Assigned(document) and ready then
    Result := OleObject.document.body.ScrollTop
  else
    Result := 0;
end;

// комбинированное значение (независит от сполоба загрузки документа)
function TIEBrowser.GetScrollPos3:integer;
var
  s1,s2: Integer;
begin
  s1 := GetScrollPos;
  s2 := GetScrollPos2;
  if (s1<>s2) then
    result := Math.Max(s1, s2)
  else
    result := s1;
end;
{
procedure TIEBrowser.SetScrollPos2(value:integer);
begin
  OleObject.document.body.ScrollTop := value;
end;
}
procedure TIEBrowser.SetScrollPos3(value:integer);
begin
  if Assigned(document) and ready then
    OleObject.Document.ParentWindow.ScrollTo(0,value);
end;

procedure TIEBrowser.LoadFromString2(Text: string);
var
  Doc: Variant;
begin
  Doc := Document;
  Doc.Clear;
  Doc.Write(Text);
  Doc.Close;
end;

procedure TIEBrowser.LoadFromString(Text: string);
var
  doc: IHTMLDocument2;
  V: OleVariant;
  w: windows.HWND;
begin
  if Assigned(Document)and(Ready) then
  begin
    w := GetForegroundWindow;
    Self.Enabled := False; // предотвращает захват курсора
    try
      V := VarArrayCreate([0, 0], varVariant);
      V[0] := Text;
      Document.QueryInterface(IHTMLDocument2, Doc);
      if doc <> nil then
      begin
        try
          {$WARNINGS OFF}
          Doc.Write(PSafeArray(TVarData(v).VArray));
          {$WARNINGS ON}
          Doc.Close;
          doc := nil;
        except
        end;
      end;
    finally
      Self.Enabled := True;
      SetForegroundWindow(w);
    end;
  end;
end;
{
// scrollpos после этого ставится неправильно
procedure TIEBrowser.LoadFromString2(Text: string);
var
  Stream: TStringStream;
begin
  if Assigned(Document)and(Ready) then
  begin
    Self.Enabled := False; // предотвращает захват курсора
    try
      Stream := TStringStream.Create(Text);
      try
        (Document as IPersistStreamInit).Load(TStreamAdapter.Create(Stream));
      finally
        myFreeAndNil(Stream);
      end;
    finally
      Self.Enabled := True;
    end;
  end;
end;

procedure TIEBrowser.LoadFromString3(text: string);
var
  doc: IHTMLDocument2;
begin
  if Assigned(Document)and(Ready) then
  begin
    Self.Enabled := False; // предотвращает захват курсора
    try
      Document.QueryInterface(IHTMLDocument2, Doc);
      if doc <> nil then
      begin
        try
          Doc.body.innerHTML := Text;
          Doc.Close;
          doc := nil;
        except
        end;
      end;
    finally
      Self.Enabled := True;
    end;
  end;
end;

procedure TIEBrowser.LoadFromString4(text: string);
var
  StringStream: TStringStream;
begin
  if Assigned(Document)and(Ready) then
  begin
    Self.Enabled := False; // предотвращает захват курсора
    try
      StringStream := TStringStream.Create(text);
      try
        LoadFromStream(StringStream);
      finally
        StringStream.Free;
      end;
    finally
      Self.Enabled := True;
    end;
  end;
end;
}
procedure TIEBrowser.LoadFromStream(const Stream: TStream);
var
  PersistStreamInit: IPersistStreamInit;
  StreamAdapter: IStream;
  w: windows.HWND;
begin
  if Assigned(Document)and(ready) then
  begin
    if Document.QueryInterface(IPersistStreamInit, PersistStreamInit) = S_OK then
    begin
      // Clear document
      if PersistStreamInit.InitNew = S_OK then
      begin
        w := GetForegroundWindow;
        Self.Enabled := False;
        // Get IStream interface on stream
        StreamAdapter:= TStreamAdapter.Create(Stream);
        try
        // Load data from Stream into WebBrowser
        PersistStreamInit.Load(StreamAdapter);
        finally
          StreamAdapter := nil;
          PersistStreamInit := nil;
          Self.Enabled := True;
          SetForegroundWindow(w);
        end;
      end;
    end;
  end;
end;

// выполнить скрипт: текст js-скрипта или имя js-функции в текущем документе
procedure TIEBrowser.ExecuteScript(script: string; ShowError: Boolean=false);
var
  win: IHTMLWindow2;
  Olelanguage: Olevariant;
  doc: IHTMLDocument2;
begin
  if Assigned(Document)and(Ready) then
  begin
    Self.Silent := not ShowError;
    Document.QueryInterface(IHTMLDocument2, Doc);
    if doc <> nil then
    begin
      try
        win := doc.parentWindow;
        if win <> nil then
        begin
          try
            Olelanguage := 'JavaScript';
            if ShowError then
              win.ExecScript(script, Olelanguage)
            else
            begin
              try
                win.ExecScript(script, Olelanguage);
              except
              end;
            end;
          finally
            win := nil;
          end;
        end;
      finally
        doc := nil;
      end;
    end;
  end;
end;

function TIEBrowser.GetFormByNumber(formNumber: integer): IHTMLFormElement;
var
  forms: IHTMLElementCollection;
  doc: IHTMLDocument2;
begin
  if Assigned(Document)and(Ready) then
  begin
    // doc := Document as IHTMLDocument2; можно и так
    Document.QueryInterface(IHTMLDocument2, Doc);  // вариант 2
    forms := doc.Forms as IHTMLElementCollection;
    if formNumber < forms.Length then
      result := forms.Item(formNumber,'') as IHTMLFormElement
    else
      result := nil;
    doc := nil;
  end;
end;

// установить поле формы
procedure TIEBrowser.SetFieldValue(formNUmber: integer; const fieldName: string; const newValue: string; const instance: integer=0);
var
  field: IHTMLElement;
  inputField: IHTMLInputElement;
  selectField: IHTMLSelectElement;
  textField: IHTMLTextAreaElement;
  theForm: IHTMLFormElement;
begin
  if Assigned(Document)and(Ready) then
  begin
    theForm := GetFormByNumber(formNumber);
    if Assigned(theForm) then
    begin
      field := theForm.Item(fieldName,instance) as IHTMLElement;
      if Assigned(field) then
      begin
        if field.tagName = 'INPUT' then
        begin
          inputField := field as IHTMLInputElement;
          if (inputField.type_ <> 'radio') and (inputField.type_ <> 'checkbox') then
            inputField.value := newValue
          else
            inputField.checked := (newValue='checked')or(newValue='1')or(uppercase(newValue)='TRUE');
        end
        else if field.tagName = 'SELECT' then
        begin
          selectField := field as IHTMLSelectElement;
          selectField.value := newValue;
        end
        else if field.tagName = 'TEXTAREA' then
        begin
          textField := field as IHTMLTextAreaElement;
          textField.value := newValue;
        end;
      end;
    end;
  end;
end;

// прочитать поле формы
function TIEBrowser.GetFieldValue(formNUmber: integer; const fieldName: string; const instance: integer=0):string;
var
  field: IHTMLElement;
  inputField: IHTMLInputElement;
  selectField: IHTMLSelectElement;
  textField: IHTMLTextAreaElement;
  theForm: IHTMLFormElement;
begin
  result := '';
  if Assigned(Document)and(Ready) then
  begin
    theForm := GetFormByNumber(formNumber);
    if Assigned(theForm) then
    begin
      field := theForm.Item(fieldName,instance) as IHTMLElement;
      if Assigned(field) then
      begin
        if field.tagName = 'INPUT' then
        begin
          inputField := field as IHTMLInputElement;
          if (inputField.type_ <> 'radio') and (inputField.type_ <> 'checkbox') then
            result := inputField.value
          else
            result := booltostr(inputField.checked, true);
        end
        else if field.tagName = 'SELECT' then
        begin
          selectField := field as IHTMLSelectElement;
          result := selectField.value;
        end
        else if field.tagName = 'TEXTAREA' then
        begin
          textField := field as IHTMLTextAreaElement;
          result := textField.value;
        end;
      end;
    end;
  end;
end;

function TIEBrowser.GetElementById(const Id: string): IDispatch;
var
  Doc: IHTMLDocument2;
  Body: IHTMLElement2;
  Tags: IHTMLElementCollection;
  Tag: IHTMLElement;
  I: Integer;
begin
  Result := nil;
  // Check for valid document
  if Assigned(Document)and(Ready) then
  begin
    if Supports(Document, IHTMLDocument2, Doc) then
    begin
      if Supports(Doc.body, IHTMLElement2, Body) then
      begin
        Tags := Body.getElementsByTagName('*');
        for I := 0 to Pred(Tags.length) do
        begin
          Tag := Tags.item(I, EmptyParam) as IHTMLElement;
          if AnsiSameText(Tag.id, Id) then
          begin
            Result := Tag;
            Break;
          end;
        end;
      end;
    end;
  end;
end;

// не работает
{procedure TIEBrowser.Append(html: string);
var
   Range: IHTMLTxtRange;
begin
  if Assigned(Document)and(Ready) then
  begin
    Range := ((Document AS IHTMLDocument2).body AS IHTMLBodyElement).createTextRange;
    Range.Collapse(False);
    Range.PasteHTML(html);
    Range := nil;
  end;
end;
}

// работает
procedure TIEBrowser.Append(html: string);
var
  WebDoc: HTMLDocument;
  WebBody: HTMLBody;
begin
  WebDoc := Document as HTMLDocument;
  WebBody := WebDoc.body as HTMLBody;
  WebBody.insertAdjacentHTML('BeforeEnd', html);
end;

end.
