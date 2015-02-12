unit HtmlUserBox;

interface

uses windows, messages, Vcl.StdCtrls, System.Classes, Vcl.Controls, System.Types, Vcl.Graphics, Vcl.imglist, SysUtils,
  Setting, UsersList, Global, icomView;

Type
  THtmlUserBox = Class(TStrings)
  private
    Display: TIcomViewer;
    font: TFont;
    inUpdate: boolean;
    function DecodeStatus(status: Integer): Integer;
    procedure boxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure boxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure boxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  //  procedure boxMeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
  //  procedure boxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure Draw;
    function MeasureItem:integer;
    function GetCount:integer;
    function GetItem(index: integer):string;
    procedure SetItem(index: integer; value:string);
  public
    NeedUpdate: boolean;
    ix, iy: Integer;
    ImageList: TImageList;
    UserList: TUsers;
    //DisplayList: TStringList;
    Constructor Create(AOwner: TComponent); override;
    procedure UpdateBox(delete: boolean);
    function User(Index: Integer): string;
    function GetSel(Index: Integer): boolean;
    procedure SetSel(sl: boolean); overload;
    procedure SetSel(Index: Integer; sl: boolean); overload;
    procedure SelectAll;
    function SelCount: Integer;
    function SelUser: string;
    procedure Select(UserName:string);
    function GetSelectedIP:TStringList;
    property Selected[Index: integer]: boolean read GetSel write SetSel;
    //property Items[Index: integer]: string read GetItem write SetItem;
    property Items: TStrings read Userlist write SetItems;
    property Count:integer read GetCount;
  End;

implementation

uses main;

function THtmlUserBox.GetCount:integer;
begin
  result := UserList.Count;
end;

Constructor THtmlUserBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  ParentFont := false;
  Font.size := 12;
  Font.Style := [fsBold];
  //Style := lbOwnerDrawVariable;
  //MultiSelect := true;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  BevelKind := bkNone;
  Align := AlClient;
  ParentDoubleBuffered := false;
  doublebuffered := true;
  //Self.OndrawItem := boxDrawItem;
  //Self.OnMeasureItem := boxMeasureItem;
  Self.OnMouseMove := boxMouseMove;
  Self.OnMouseDown := boxMouseDown;
  Self.OnMouseUp := boxMouseUp;
end;

function THtmlUserBox.SelCount: Integer;
var
  i: Integer;
begin
  result := 0;
  for i := 0 to UserList.Count - 1 do
  begin
    if GetSel(i) then
      result := result + 1;
  end;
end;

function THtmlUserBox.SelUser: string;
var
  i: Integer;
begin
  if SelCount = 1 then
  begin
    result := '';
    for i := 0 to UserList.Count - 1 do
    begin
      if GetSel(i) then
        result := User(i);
    end;
  end
  else
    result := '';
end;

procedure THtmlUserBox.SelectAll;
var
  i: Integer;
begin
  for i := 0 to user_box.Count - 1 do
    SetSel(i, false);
end;

procedure THtmlUserBox.Select(UserName:string);
var
  i:integer;
begin
  SelectAll;
  for i := 0 to user_box.Count - 1 do
  begin
    if User(i) = trim(UserName) then
    begin
      SetSel(i, true);
      break;
    end;
  end;
end;

// статус в он/офф
function THtmlUserBox.DecodeStatus(status: Integer): Integer;
begin
  if status <> OFFLINE then
    result := ONLINE
  else
    result := OFFLINE;
end;

// обновить список пользователей
procedure THtmlUserBox.UpdateBox(delete: boolean); // надо ли очищать вначале
var
  i, j, i2, X: Integer;
  id: Integer;
  Add: boolean;
  cnt: Integer;
  id1, id2: Integer;
  duser: TstringList;
begin
  duser := TstringList.Create;
  try
    if inUpdate then
      exit;
    inUpdate := true;
    //user_box.Items.BeginUpdate;
    // запомним выделенных
    for i := 0 to user_box.Count - 1 do
      if GetSel(i) then
        duser.Add(User(i));
    // очистим и загрузим заново
    if delete then
    begin
      user_box.clear;
      for i := 0 to UserList.Count - 1 do
      begin
        if (UserList[i].name > '') then
          if Setup.showOffline then
            user_box.Items.Add(UserList[i].name)
          else if UserList[i].status <> OFFLINE then
            user_box.Items.Add(UserList[i].name);
      end;
    end;
    // добавим подключившихся
    for i := 0 to UserList.Count - 1 do
    begin
      if (UserList[i].name > '') and (UserList[i].status <> OFFLINE) then
      begin
        // проверим нет ли уже в списке
        Add := true;
        for i2 := 0 to user_box.Items.Count - 1 do
        begin
          if UserList[i].name = User(i2) then
            Add := false;
        end;
        if Add then
          user_box.Items.Add(UserList[i].name);
      end;
    end;
    if not Setup.showOffline then
    begin
      // удалим тех кто оффлайн кроме себя
      cnt := user_box.Items.Count;
      i := 0;
      while i <= cnt - 1 do
      begin
        id := UserList.getID(User(i));
        if (id >= 0) and (UserList[id].status = OFFLINE) and (not NetWork.TestLocalIP(UserList[id].ip)) then
        begin
          user_box.Items.delete(i);
          cnt := cnt - 1;
        end;
        i := i + 1;
      end;
    end;
    // сортировка
    case Setup.user_box_sort of
      // по имени
      0:
        begin
          if not Setup.OfflineEnd then
          begin
            for i := 0 to (user_box.Items.Count - 1) do
            begin
              for X := 0 to (user_box.Items.Count - 1) do
              begin
                if (AnsiCompareText(User(X), User(i)) < 0) and (X > i) then
                begin
                  user_box.Items.Exchange(i, X);
                end;
              end;
            end;
          end
          else
          begin // оффлайн в конец
            for i := 0 to (user_box.Items.Count - 1) do
            begin
              for X := 0 to (user_box.Items.Count - 1) do
              begin
                id1 := UserList.getID(User(X));
                id2 := UserList.getID(User(i));
                if (DecodeStatus(UserList[id1].status) > DecodeStatus(UserList[id2].status)) and (X > i) then
                begin
                  user_box.Items.Exchange(i, X);
                end;
              end;
            end;
            // по имени, кроме оффлайн
            for i := 0 to (user_box.Items.Count - 1) do
            begin
              for X := 0 to (user_box.Items.Count - 1) do
              begin
                id1 := UserList.getID(User(X));
                id2 := UserList.getID(User(i));
                if (AnsiCompareText(User(X), User(i)) < 0) and (X > i) then
                begin
                  if (DecodeStatus(UserList[id1].status) = ONLINE) and (DecodeStatus(UserList[id2].status) = ONLINE)
                  then
                    user_box.Items.Exchange(i, X);
                end;
              end;
            end;

          end;
        end;
      // по списку
      1:
        begin
          if not Setup.OfflineEnd then
          begin
            for i := 0 to (user_box.Items.Count - 1) do
            begin
              for X := 0 to (user_box.Items.Count - 1) do
              begin
                id1 := UserList.getID(User(X));
                id2 := UserList.getID(User(i));
                if (UserList[id1].sortorder < UserList[id2].sortorder) and (X > i) then
                begin
                  user_box.Items.Exchange(i, X);
                end;
              end;
            end;
          end
          else
          begin
            // оффлайн в конец
            for i := 0 to (user_box.Items.Count - 1) do
            begin
              for X := 0 to (user_box.Items.Count - 1) do
              begin
                id1 := UserList.getID(User(X));
                id2 := UserList.getID(User(i));
                if (DecodeStatus(UserList[id1].status) > DecodeStatus(UserList[id2].status)) and (X > i) then
                begin
                  user_box.Items.Exchange(i, X);
                end;
              end;
            end;
            // по списку, кроме оффлайн
            for i := 0 to (user_box.Items.Count - 1) do
            begin
              for X := 0 to (user_box.Items.Count - 1) do
              begin
                id1 := UserList.getID(User(X));
                id2 := UserList.getID(User(i));
                if (UserList[id1].sortorder < UserList[id2].sortorder) and (X > i) then
                begin
                  if (DecodeStatus(UserList[id1].status) = ONLINE) and (DecodeStatus(UserList[id2].status) = ONLINE)
                  then
                    user_box.Items.Exchange(i, X);
                end;
              end;
            end;

          end;
        end;
    end;
  finally
    // восстановим выделение
    for i := 0 to user_box.Count - 1 do
    begin
      for j := 0 to duser.Count - 1 do
      begin
        if User(i) = duser.Strings[j] then
        begin
          SetSel(i, true);
        end;
      end;
    end;
    FreeAndNil(duser);
    //user_box.Items.EndUpdate;
    inUpdate := false;
  end;
end;

// мышь над списком юзеров - показать инфо
procedure THtmlUserBox.boxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
//var
//  uu: string;
//  pp: TPoint;
//  id: Integer;
//  infoip: string;
begin
{  pp.X := X;
  pp.Y := Y;
  if (ItemAtPos(pp, true) <> -1) then
  begin
    uu := Items.Strings[ItemAtPos(pp, true)];
    ShowHint := true;
    infoip := UserList.Getip(uu);
    id := UserList.getID(infoip);
    if (id < 0) then
    begin
      if not assigned(mainform.PanelInfo) then
        FreeAndNil(mainform.PanelInfo);
    end
    else if UserList[id].status <> OFFLINE then
    begin
      if Setup.show_info then
        mainform.ShowInfoPanel(infoip, X, Y);
    end
    else
    begin
      if Setup.show_info then
        mainform.PanelInfo.Hide;
    end;
  end; }
end;

procedure THtmlUserBox.boxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inUpdate := false;
  refresh;
end;

procedure THtmlUserBox.boxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
//var
//  i: Integer;
//  pp: TPoint;
//  ps: Integer;
begin
  ix := X;
  iy := Y;
{  // если щелчек на пустой строке - встанем на последнюю не пустую
  if Items.Strings[ItemIndex] = '' then
  begin
    for i := 0 to Items.Count - 1 do
      if Items.Strings[i] > '' then
        ItemIndex := i;
  end;
  if Shift = [ssRight] then
  begin
    pp.X := X;
    pp.Y := Y;
    ps := ItemAtPos(pp, true);
    if ps <> -1 then
    begin
      SelectAll;
      SetSel(ps, true);
    end;
  end; }
end;

function THtmlUserBox.GetSelectedIP:TStringList;
var
  UList: TstringList;
  i, id: integer;
begin
  UList:= TstringList.Create;
  for i := 0 to User_box.count - 1 do
  begin
    if (SelCount = 0) or (GetSel(i)) then
    begin
      id := UserList.GetID(User(i));
      if UserList[id].status <> OFFLINE  then
        UList.Add(UserList[id].ip);
    end;
  end;
  result:=UList;
end;


// высота строки перед рисованием
function THtmlUserBox.MeasureItem:integer;
begin
  begin
    // ничего-0 иконка-1 слева-2 справа-3 иконка+справа-4
    case Setup.user_box_mode of
      0:
        Height := hmin;
      1:
        Height := hmin;
      2:
        Height := minisize;
      3:
        Height := minisize;
      4:
        Height := minisize;
      5:
        Height := hmin;
    else
      Height := hmin;
    end;
  end;
  result := height;
end;


// рисование списка пользователей
procedure THtmlUserBox.Draw;
const
  clname: array [-1 .. 2] of Tcolor = (clGray, clred, clred, clGreen);
  icon_size = 16;
var
  foncolor: Tcolor;
  index2: Integer; // индекс в списке userlist
  uo, i: Integer;
  ItemHeight: integer;
  img, nik:string;
  page: TStringlist;
  str: TMemoryStream;
begin
  str:= TMemoryStream.Create;
  page := TStringlist.Create;
  page.Add('<html>');
  page.Add('<head>');
  page.Add('<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">');
  page.Add('</head>');
  page.Add('<body>');
  page.Add('<div style="font-size: 12; font-weught: bold;">');
  foncolor := Setup.Wincolor;
  ItemHeight := minisize;
  try
    for Index2 := 0 to Userlist.Count -1 do
    begin
      ItemHeight := MeasureItem;

      if UserList[index2].Selected then
        foncolor := clActiveCaption
      else
        foncolor := foncolor;
      // ничего-0 иконка слева-1 аватар_слева-2 аватар_справа-3 ничего-4 ничего-5
      case UserList[index2].status of
        ONLINE: nik := '<span style="color: green">';
        OFF: nik := '<span style="color: red">';
        OFFLINE: nik := '<span style="color: gray">';
      else
        nik := '<span style="color: gray">';
      end;
      nik := UserList[index2].name;
      case Setup.user_box_mode of
        0,4,5: img := '';
        1:begin
           case UserList[index2].status of
             ONLINE: img := '<img width='+inttostr(icon_size)+' height='+inttostr(icon_size)+' srg="'+htmldir+'/igreen.gif">';
             OFF:    img := '<img width='+inttostr(icon_size)+' height='+inttostr(icon_size)+' srg="'+htmldir+'/ired.gif">';
             OFFLINE:img := '<img width='+inttostr(icon_size)+' height='+inttostr(icon_size)+' srg="'+htmldir+'/igray.gif">'
           else
             img := '<img width='+inttostr(icon_size)+' height='+inttostr(icon_size)+' srg="'+htmldir+'/igray.gif">'
           end;
          end;
        2,3: img := '<img width='+inttostr(minisize)+' height='+inttostr(minisize)+' srg="../temp/'+nik+'.jpg">';
      end;
    end;
    page.Add('<div style="height: '+inttostr(ItemHeight)+'">');
    page.Add(img+nik);
    // полоска по границе
    if Setup.drawlines then
      page.Add('<hr>');
    page.Add('</div>')
  finally
    // онлайн
    begin
      uo := 0;
      for i := 0 to UserList.Count - 1 do
      begin
        if UserList[i].status <> OFFLINE then
          uo := uo + 1;
      end;
      page.Add('<div align="center">Online: ' + inttostr(uo)+'</div>');
    end;
    page.Add('</div>');
    page.Add('</body>');
    page.Add('</html>');
    page.SaveToStream(str);
    str.Position := 0;
    self.LoadFromStream(str);
    str.Free;
    page.Free;
  end;
end;

function THtmlUserBox.User(Index: Integer): string;
begin
  if (index >= 0) and (index < UserList.Count) then
    result := trim(UserList[index].name)
  else
    result := '';
end;

// чтение из списка выдел. польз.
function THtmlUserBox.GetSel(Index: Integer): boolean;
begin
  if (index >= 0) and (index < UserList.Count) then
    result := UserList[index].Selected
  else
    result := false;
end;

// запись в список выдел. польз.
procedure THtmlUserBox.SetSel(Index: Integer; sl: boolean);
begin
  if (index >= 0) and (index < UserList.Count) then
    UserList[index].Selected := sl
end;

end.
