unit IcomUserBox;

interface

uses windows, messages, Vcl.StdCtrls, System.Classes, Vcl.Controls, System.Types, Vcl.Graphics, Vcl.imglist, SysUtils,
  Setting, UsersList, Global, IcomView, Dialogs, MSHTML_TLB;

Type
  TUserBox = Class(TListBox)
  private
    first: boolean;
    inUpdate: boolean;
    ClickUser: string;
    function DecodeStatus(status: Integer): Integer;
    function  Measure:integer;
    procedure WebBrowser2BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure SetSel(Index: Integer; sl: boolean);
    function GetSel(Index: Integer): boolean;
  public
    Display: TIcomViewer;
    nn: integer;
    ix, iy: Integer;
    //ImageList: TImageList;
    UserList: TUsers;
    Constructor Create(AOwner: TComponent); override;
    procedure UpdateBox(force: Boolean=false);
    function UserBox(Index: Integer): string;
    procedure SelectAll; override;
    function SelCount: Integer;
    function SelUser: string;
    procedure Select(UserName:string);
    procedure ToggleSelect(UserName:string);
    function GetSelectedIP:TStringList;
    function Selected(UserName:string): boolean;
    function Status(UserName:string): TStatus;
    function User(UserName:string): TUser;
    procedure Refresh(force:boolean=false);
  End;

implementation

uses main, htmllib, commonlib, desktop, VERS;

// высота строки перед рисованием
function TUserBox.Measure:integer;
begin
  // ничего-0 иконка слева-1 аватар_слева-2 аватар_справа-3 ничего-4 ничего-5
  case Setup.userboxmode of
    0,1:
      Height := hmin;
    2,3:
      Height := minisize;
  else
    Height := hmin;
  end;
  result := height;
end;

// рисование списка пользователей
procedure TUserBox.Refresh(force:boolean=false);
const
  clname: array [-1 .. 2] of Tcolor = (clGray, clred, clred, clGreen);
  icon_size = 16;
var
  index2: Integer; // индекс в списке userlist
  uo, i: Integer;
  ItemHeight: integer;
  img:string;
  page: TStringlist;
  bgcolor:Tcolor;
  nick_color:Tcolor;
  y: integer;
  lists: IDispatch;

  function line(index:integer; bgcolor:Tcolor; iHeight:integer):string;
  var
    st: string;
  begin
    if Setup.drawlines then
    begin
      if index=0 then
        st := 'btop_bot'
      else
        st := 'bbot';
    end
    else
      st := '';
    result := '<div id='+inttostr(index)+' class="'+st+'" style="z-index:0; width: 100%; background-color: '+htmlcolor(bgcolor)+'; line-height: '+inttostr(iHeight)+'px; height: '+inttostr(iHeight)+'px;"'
       + '>';
  end;
  function lineEnd:string;
  begin
    result := '</div>';
  end;
  function link(index:integer; txt:string; color:Tcolor):string;
  begin
    result := '<a style="color:'+htmlcolor(color)+'" ';
    if Setup.showinfo then
    begin
      result := result +
      'onmouseout="document.getElementById('+#39+txt+#39+').style.display=''none'';" '+
      'onmouseover="document.getElementById('+#39+txt+#39+').style.display=''block'';" ';
    end;
    result := result +
      'href="user://'+urlencode(UserList[index2].name)+'">'+txt+'</a>';
  end;
  function ui(index:integer):string;
  var
    it: integer;
    away: string;
    hh, mm, ss: integer;
    ht, wt: word;
  begin
    if userlist[index].Status = OFFLINE then
    begin
      result := '<div id='+#39+UserList[index2].name+#39+'></div>';
      exit;
    end;
    it := userlist[index].idletime;
    if it <> 0 then
    begin
      hh := it div 3600;
      mm := (it - hh * 3600) div 60;
      ss := it - hh * 3600 - mm * 60;
      away := lang.get('none') + ': ' + inttostr(hh) + lang.get('hour') + ' ' + inttostr(mm) +
        lang.get('min') + ' ' + inttostr(ss) + lang.get('sek');
    end;

    result := '<div id='+#39+UserList[index2].name+#39+' style="display: none; position: relative; z-index: 100; left: 0px; top: 0px; border: solid black 1px; padding: 2px; background-color: '+SAND+'; text-align: justify; font-size: 10px; width: 250px; height: 150px; line-height: 20px;">'+
      '<table width=100% border=0>'+
      '<tr>'+
          '<td width=60%>'+
          '<div>'+lang.get('nick')+': '+UserList[index2].name+'</div><br>'+
          '<div>'+lang.get('ver')+': '+ UserList[index2].ver+'</div>'+
          '<div>'+UserList[index2].winver+'</div>';
          if UserList[index2].dr > '' then
            result := result + '<div>'+lang.get('birthday')+': '+UserList[index2].dr+'</div>';
          result := result +
          '</td>'+
          '<td>';
          if fileexists(CacheDir+inttostr(UserList[index2].randId)+'.jpg') then
          begin
            GetImageSize(CacheDir+inttostr(UserList[index2].randId)+'.jpg',wt,ht);
            if ht >= Wt then
            begin
              result := result +
              '<img src="'+CacheDir+inttostr(UserList[index2].randId)+'.jpg" style="position relative; left: 100px; top: 20px; height: 100px; background-color: gray">'
            end
            else
            begin
              result := result +
              '<img src="'+CacheDir+inttostr(UserList[index2].randId)+'.jpg" style="position relative; left: 100px; top: 20px; width: 100px; background-color: gray">'
            end;
          end;
          result := result +
          '</td>'+
      '</tr>';
      if away > '' then
        result := result + '<tr><td colspan="2"><hr><div>'+away+'</div></td></tr>';
      result := result + '</table></div>';
  end;
  function nick(index: integer; txt:string;color:Tcolor):string;
  begin
    result := '<span style="vertical-align: top; display: inline-block; width: 80%; color: '+htmlcolor(color)+'">'+link(index, txt, color)+'</span>';
  end;
  function image(index:integer; parentHeight:integer):string;
  var
    img: string;
    dy: string;
    ht, wt: word;
  begin
    case Setup.userboxmode of
      0,4,5: img := '';
      1:begin
          dy := inttostr((ParentHeight-icon_size) div 2);
          img := '<img style="position: relative; top: '+dy+'px;" border=0 width='+inttostr(icon_size)+' height='+inttostr(icon_size)+' src="' + htmldir + 'smiles\';
          case UserList[index2].status of
            ONLINE: img := img + 'igreen.gif">';
            OFF:    img := img + 'ired.gif">';
            OFFLINE:img := img + 'igray.gif">'
          else
            img := img + 'igray.gif">'
          end;
        end;
      2,3:
        begin
          dy := inttostr((ParentHeight-(minisize-2)) div 2);
          if (UserList[index].status = OFFLINE)or(not fileexists(cachedir+inttostr(UserList[index].randId)+'.jpg')) then
            img := ''
          else
          begin
            GetImageSize(CacheDir+inttostr(UserList[index2].randId)+'.jpg',wt,ht);
            if ht >= wt then
              img := '<img style="position: relative; top: '+dy+'px;" border=0 height='+inttostr(minisize-2)+' src="'+cachedir+inttostr(UserList[index].randId)+'.jpg">'
            else
              img := '<img style="position: relative; top: '+dy+'px;" border=0 width='+inttostr(minisize-2)+' src="'+cachedir+inttostr(UserList[index].randId)+'.jpg">'
          end;
        end;
      else
        img := '';
    end;
    result := img;
  end;

begin
  if (not force)and(not user_list.modified) then
    exit;
  page := TStringlist.Create;
  if force then
  begin
    page.Add('<!DOCTYPE html>');
    page.Add('<html>');
    page.Add('<head>');
    page.Add('<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">');
    page.Add('<style>');
    page.Add('A { text-decoration: none; } ');
    page.add('.bbot { border-bottom: 1px solid silver; }');
    page.add('.btop_bot { border-top: 1px solid silver; border-bottom: 1px solid silver; }');

    page.Add('</style>');
    page.Add('</head>');
    page.Add('<body style="background-color:'+htmlcolor(setup.WinColor)+'; font-family: arial; font-size: 12px; font-weight: bold;">');
  end;
  try
    page.Add('<div id=''list''>');
    for i := 0 to Items.Count -1 do
    begin
      index2 := user_list.getID(Items[i]);
      ItemHeight := Measure;
      if UserList[index2].Selected then
        bgcolor := clBlue
      else
        bgcolor := Setup.WinColor;
      case UserList[index2].status of
        ONLINE: nick_color := clgreen;
        OFF: nick_color := clred;
        OFFLINE: nick_color := clgray;
      else
        nick_color := clgray;
      end;
      page.Add(line(i, bgcolor, ItemHeight));
      //
      img := image(index2, ItemHeight);
      // ничего-0 иконка слева-1 аватар_слева-2 аватар_справа-3 ничего-4 ничего-5
      case Setup.userboxmode of
        0: page.Add(nick(i, UserList[index2].name, nick_color));
        1: page.Add(image(index2, ItemHeight)+'&nbsp;' + nick(i, UserList[index2].name, nick_color));
        2: page.Add(image(index2, ItemHeight)+' '+nick(i, UserList[index2].name, nick_color));
        3: page.Add(nick(i, UserList[index2].name, nick_color)+image(index2, ItemHeight));
      else
        page.Add(nick(i, UserList[index2].name, nick_color));
      end;
      page.Add(ui(index2));
      page.Add(lineEnd);
    end;
  finally
    // онлайн
    begin
      uo := 0;
      for i := 0 to UserList.Count - 1 do
      begin
        if UserList[i].status <> OFFLINE then
          uo := uo + 1;
      end;
      page.Add('<div style="width: 100%; height: 10px; color: gray;" align="center">'+lang.get('Online')+': ' + inttostr(uo)+'</div>');
    end;
    page.Add('</div>');
    if force then
    begin
      page.Add('</body>');
      page.Add('</html>');
      y := Display.ScrollPos;
      Display.LoadFromString(page.Text);
      Display.ScrollPos := y;
    end
    else
    begin
      lists := Display.GetElementById('list');
      IHTMLElement(lists).setAttribute('innerhtml', page.text, 0);
    end;
    //Display.SaveHtml(htmldir+'ul.html');
    //page.SaveToFile(htmldir+'ul.html');
    mainForm.MySetFocus(mainForm.memoin, true);
    page.Free;
    user_list.modified := false;
  end;
end;


Constructor TUserBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  first := true;
  Parent := TWinControl(AOwner);
  ParentFont := false;
  Canvas.Font.size := 12;
  Canvas.Font.Style := [fsBold];
  Style := lbOwnerDrawVariable;
  MultiSelect := true;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  BevelKind := bkNone;
  ParentDoubleBuffered := false;
  doublebuffered := false;
  visible := false;
  // новое отображение
  Display := TIcomViewer.Create(AOwner);
  Display.Align := alClient;
  Display.BringToFront;
  Display.objname := USER_DISPLAY;
  Display.ScrollBars := ssBoth;
  Display.OnBeforeNavigate2 := WebBrowser2BeforeNavigate2;
  Display.Margins.Top := 0;
  nn:=0;
end;

procedure TUserBox.WebBrowser2BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
var
  url2: string;
begin
  url2 := urldecode(URL);
  if copy(url2,length(url2))='/' then //  в IE хвост /
    url2:=copy(url2,1,length(url2)-1);
  ClickUser := copy(url2,pos('//',url2)+2, length(url2)-pos('//',url2)-1);
  if ClickUser='usermenu' then
  begin
    mainForm.IcomButtonClick(self);
    exit;
  end;
  if (not CtrlDown) and (not ShiftDown) then
  begin
    if Selected(ClickUser) then
      ToggleSelect(ClickUser)
    else
      Select(ClickUser);
    Refresh;
    Cancel := true;
  end
  else if (CtrlDown) then
  begin
    ToggleSelect(ClickUser);
    Refresh;
    Cancel := true;
  end;
end;

function TUserBox.SelCount: Integer;
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

function TUserBox.SelUser: string;
var
  i: Integer;
begin
  if SelCount = 1 then
  begin
    result := '';
    for i := 0 to UserList.Count - 1 do
    begin
      if GetSel(i) then
        result := Userlist[i].name;
    end;
  end
  else
    result := '';
end;

procedure TUserBox.SelectAll;
var
  i: Integer;
begin
  for i := 0 to UserList.Count - 1 do
    SetSel(i, false);
end;

procedure TUserBox.ToggleSelect(UserName:string);
var
  i:integer;
begin
  for i := 0 to UserList.Count - 1 do
  begin
    if UserList[i].name = trim(UserName) then
    begin
      if UserList[i].Selected then
        SetSel(i, false)
      else
        SetSel(i, true);
      break;
    end;
  end;
end;

procedure TUserBox.Select(UserName:string);
var
  i:integer;
begin
  SelectAll;
  for i := 0 to UserList.Count - 1 do
  begin
    if UserList[i].name = trim(UserName) then
    begin
      SetSel(i, true);
      break;
    end;
  end;
end;

// статус в он/офф
function TUserBox.DecodeStatus(status: Integer): Integer;
begin
  if status <> OFFLINE then
    result := ONLINE
  else
    result := OFFLINE;
end;

// обновить список пользователей
procedure TUserBox.UpdateBox(force: Boolean=false);
var
  i, X: Integer;
  id: Integer;
  cnt: Integer;
  id1, id2: Integer;
begin
  try
    //if inUpdate then
    //  exit;
    inUpdate := true;
    user_box.Items.BeginUpdate;
    user_box.clear;
    for i := 0 to UserList.Count - 1 do
    begin
      if (UserList[i].name > '') then
        if Setup.showOffline then
          user_box.Items.Add(UserList[i].name)
        else if UserList[i].status <> OFFLINE then
          user_box.Items.Add(UserList[i].name);
    end;
    if not Setup.showOffline then
    begin
      // удалим тех кто оффлайн кроме себя
      cnt := user_box.Items.Count;
      i := 0;
      while i <= cnt - 1 do
      begin
        id := UserList.getID(UserBox(i));
        if (id >= 0) and (UserList[id].status = OFFLINE) and (not NetWork.TestLocalIP(UserList[id].ip)) then
        begin
          user_box.Items.delete(i);
          cnt := cnt - 1;
        end;
        i := i + 1;
      end;
    end;
    // сортировка
    if Setup.userboxsort then
    // по имени
    begin
      if not Setup.OfflineEnd then
      begin
        for i := 0 to (user_box.Items.Count - 1) do
        begin
          for X := 0 to (user_box.Items.Count - 1) do
          begin
            if (AnsiCompareText(UserBox(X), UserBox(i)) < 0) and (X > i) then
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
            id1 := UserList.getID(UserBox(X));
            id2 := UserList.getID(UserBox(i));
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
            id1 := UserList.getID(UserBox(X));
            id2 := UserList.getID(UserBox(i));
            if (AnsiCompareText(UserBox(X), UserBox(i)) < 0) and (X > i) then
            begin
              if (DecodeStatus(UserList[id1].status) = ONLINE) and (DecodeStatus(UserList[id2].status) = ONLINE)
              then
                user_box.Items.Exchange(i, X);
            end;
          end;
        end;

      end;
    end
    // по списку
    else
    begin
      if not Setup.OfflineEnd then
      begin
        for i := 0 to (user_box.Items.Count - 1) do
        begin
          for X := 0 to (user_box.Items.Count - 1) do
          begin
            id1 := UserList.getID(UserBox(X));
            id2 := UserList.getID(UserBox(i));
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
            id1 := UserList.getID(UserBox(X));
            id2 := UserList.getID(UserBox(i));
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
            id1 := UserList.getID(UserBox(X));
            id2 := UserList.getID(UserBox(i));
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
  finally
    user_box.Items.EndUpdate;
    user_box.refresh(force);
    inUpdate := false;
  end;
end;

function TUserBox.GetSelectedIP:TStringList;
var
  UList: TstringList;
  i: integer;
begin
  UList:= TstringList.Create;
  for i := 0 to UserList.count - 1 do
  begin
    if (SelCount = 0) or (GetSel(i)) then
    begin
      if UserList[i].status <> OFFLINE  then
      begin
        UList.Add(UserList[i].ip);
      end;
    end;
  end;
  result:=UList;
end;

function TUserBox.UserBox(Index: Integer): string;
begin
  if (index >= 0) and (index < self.Count) then
    result := trim(Items[index])
  else
    result := '';
end;

function TUserBox.User(UserName:string): TUser;
begin
  result := UserList[UserName];
end;

function TUserBox.Status(UserName:string): TStatus;
var
  i:integer;
begin
  result := OFFLINE;
  for i := 0 to UserList.count - 1 do
  begin
    if UserList[i].name = trim(UserName) then
      result := UserList[I].Status
  end;
end;


function TUserBox.Selected(UserName:string): boolean;
var
  i:integer;
begin
  result := false;
  for i := 0 to UserList.count - 1 do
  begin
    if UserList[i].name = trim(UserName) then
      result := UserList[I].Selected
  end;
end;


function TUserBox.GetSel(Index: Integer): boolean;
begin
  if (index >= 0) and (index < UserList.Count) then
    result := UserList[Index].Selected
  else
    result := false;
end;

// запись в список выдел. польз.
procedure TUserBox.SetSel(Index: Integer; sl: boolean);
begin
  if (index >= 0) and (index < UserList.Count) then
  begin
    UserList[index].Selected := sl;
  end;
end;

end.
