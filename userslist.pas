unit userslist;

interface

uses Windows, Messages, SysUtils, Classes, Forms, jpeg, Global;

type
  // 1 контакт
  TUser = class(TObject)
    randId: integer;
    fname: string;
    oname: string;
    ip: string;
    fstatus: Tstatus;
    time: Tdatetime;
    ver: string;
    winver: string;
    dr: string; // ddmmyyyy
    fsortorder: integer;
    //big: Tjpegimage;
    big_time: Tdatetime;
    //winstatus: boolean;
    idletime: integer;
    male: integer; // 0-м 1-ж
    channels: string;
    fSelected: boolean;
    fmodified: boolean;
    plugins: string;
  private
    Fex_status: string;
    function GetExStatus: string;
    procedure SetExStatus(NewValue: string);
    procedure SetSelected(value: boolean);
    procedure SetName(value: string);
    procedure SetStatus(value: Tstatus);
    procedure Setsortorder(value: integer);
    function GetModified: boolean;
    procedure SetModified(value: boolean);
  public
    file_protocol: integer;
    constructor Create;
    destructor Destroy; override;
    property Name: string read fname write SetName;
    property ex_Status: string read GetExStatus write SetExStatus;
    property Selected: boolean read fSelected write SetSelected;
    property Status: TStatus read fStatus write SetStatus;
    property sortorder: integer read fsortorder write SetSortorder;
    property modified: boolean read GetModified write SetModified;
  end;

  // все контакты
  TUsers = class(TObject)
  private
    Empty_user: TUser;
    Fusers: TStringlist;
    function GetCount: integer;
    function GetUser(IP_or_Index: variant): TUser;
    procedure SetUser(IP_or_Index: variant; NewUser: TUser);
    function GetModified:boolean;
    procedure SetModified(value: boolean);
  public
    constructor Create;
    destructor Destroy; override;
    function Get(IP_or_Index: variant): TUser;
    Function GetID(ip_or_name: string): integer;
    Function GetNickName(ip: string): string;
    Function GetIP(name: string): string;
    Procedure SetOFFLINE(id: integer); overload;
    Procedure SetOFFLINE(ip: string); overload;
    procedure ClearUsers;
    procedure AddUser(UserName, ip: string);
    procedure DeleteUser(UserName_IP: string); overload;
    procedure DeleteUser(index: integer); overload;
    property Count: integer read GetCount;
    property user[IP_or_Index: variant]: TUser read GetUser write SetUser; default;
    property modified: boolean read GetModified write SetModified;
  end;

implementation

function TUser.GetModified: boolean;
begin
  result := fModified;
end;

procedure TUser.SetModified(value: boolean);
begin
  fModified := value;
end;

procedure TUser.SetSortorder(value: integer);
begin
  if fSortorder <> value then
    modified := true;
  fSortorder := value;
end;

procedure TUser.SetStatus(value: Tstatus);
begin
  if fStatus <> value then
    modified := true;
  fStatus := value;
end;

procedure TUser.SetName(value: string);
begin
  if fName <> value then
    modified := true;
  fName := value;
end;

procedure TUser.SetSelected(value: boolean);
begin
  if fSelected <> value then
    modified := true;
  fSelected := value;
end;

constructor TUser.Create;
begin
  inherited Create;
  //
  modified := true;
  status := OFFLINE;
  //big := Tjpegimage.Create;
  randId := random(1000000);
  file_protocol := 2;  // v1, v2
  big_time := Now;
  idletime := 0;
  channels := '';
  male := 0;
end;

destructor TUser.Destroy;
begin
  //if assigned(big) then
  //  big.Free;
  inherited Destroy;
end;

function TUser.GetExStatus: string;
begin
  result := trim(copy(Fex_status, 1, 50));
  if result > '' then
    result := '[' + result + ']';
end;

procedure TUser.SetExStatus(NewValue: string);
begin
  Fex_status := NewValue;
end;

function TUsers.GetModified:boolean;
var
  i: integer;
  md: boolean;
begin
  md := false;
  for i := 0 to Fusers.Count - 1 do
  begin
    if TUser(Fusers.objects[i]).modified then
    begin
      md := true;
    end;
  end;
  result := md;
end;

procedure TUsers.SetModified(value: boolean);
var
  i: integer;
begin
  for i := 0 to Fusers.Count - 1 do
  begin
    TUser(Fusers.objects[i]).modified := value;
  end;
end;

function TUsers.Get(IP_or_Index: variant): TUser;
begin
  Result := GetUser(IP_or_Index);
end;

function TUsers.GetUser(IP_or_Index: variant): TUser;
var
  index: integer;
begin
  try
    if pos('.', IP_or_Index) = 0 then
      index := strtoint(IP_or_Index)
    else
      index := GetID(IP_or_Index);
  except
    index := GetID(IP_or_Index);
  end;
  if (index >= 0) and (index < Fusers.Count) then
    result := TUser(Fusers.objects[index])
  else
    result := Empty_user;
end;

procedure TUsers.ClearUsers;
begin
  while Fusers.Count <> 0 do
  begin
    Fusers.objects[0].Free;
    Fusers.Delete(0);
  end;
  modified := true;
end;

procedure TUsers.SetUser(IP_or_Index: variant; NewUser: TUser);
var
  index: integer;
begin
  try
    index := strtoint(IP_or_Index);
  except
    index := GetID(IP_or_Index);
  end;
  if (index >= 0) and (index < Fusers.Count) then
    Fusers.objects[index] := NewUser;
end;

constructor TUsers.Create;
begin
  inherited Create;
  //
  Fusers := TStringlist.Create;
  Empty_user := TUser.Create;
  randomize();
end;

destructor TUsers.Destroy;
begin
  ClearUsers;
  Fusers.Free;
  myFreeAndNil(Empty_user);
  //
  inherited Destroy;
end;

function TUsers.GetCount: integer;
begin
  result := Fusers.Count;
end;

procedure TUsers.AddUser(UserName, ip: string);
var
  uu: TUser;
begin
  uu := TUser.Create;
  uu.name := trim(UserName);
  uu.ip := trim(ip);
  Fusers.AddObject(ip, uu);
  modified := true;
end;

procedure TUsers.DeleteUser(UserName_IP: string);
var
  i: integer;
begin
  for i := 0 to Fusers.Count - 1 do
    if (ansiuppercase(TUser(Fusers.objects[i]).name) = ansiuppercase(UserName_IP)) or
      (TUser(Fusers.objects[i]).ip = UserName_IP) then
    begin
      modified := true;
      DeleteUser(i);
      break;
    end;
end;

procedure TUsers.DeleteUser(index: integer);
begin
  if (index >= 0) and (index < Fusers.Count) then
  begin
    Fusers.objects[index].Free;
    Fusers.Delete(index);
  end;
end;

// Получаем ID по IP или по имени
Function TUsers.GetID(ip_or_name: string): integer;
var
  i: integer;
begin
  ip_or_name := trim(ip_or_name);
  if ip_or_name = '' then
  begin
    result := -1;
  end
  else
  begin
    result := -1;
    for i := 0 to Fusers.Count - 1 do
    begin
      if (TUser(Fusers.objects[i]).ip = ip_or_name) or
        (ansiuppercase(TUser(Fusers.objects[i]).name) = ansiuppercase(ip_or_name)) then
      begin
        result := i;
        break;
      end;
    end;
  end;
end;

// Получаем имя по IP
Function TUsers.GetNickName(ip: string): string;
var
  i: integer;
begin
  result := 'unknown';
  for i := 0 to Fusers.Count - 1 do
  begin
    if TUser(Fusers.objects[i]).ip = ip then
    begin
      result := trim(TUser(Fusers.objects[i]).name);
      break;
    end;
  end;
end;

// Получаем IP по имени
Function TUsers.GetIP(name: string): string;
var
  i: integer;
begin
  result := '';
  for i := 0 to Fusers.Count - 1 do
  begin
    if TUser(Fusers.objects[i]).name = name then
    begin
      result := TUser(Fusers.objects[i]).ip;
      break;
    end;
  end;
end;

Procedure TUsers.SetOFFLINE(ip: string);
begin
  setOffline(getid(ip));
end;

Procedure TUsers.SetOFFLINE(id: integer);
//var
 //empty:TjpegImage;
begin
  if (id >= 0) and (id < Fusers.Count) then
  begin
    TUser(Fusers.objects[id]).time := Now;
    TUser(Fusers.objects[id]).channels := '';
    TUser(Fusers.objects[id]).status := OFFLINE;
    //empty:=TjpegImage.Create;
    //TUser(Fusers.objects[id]).big.Assign(empty);
    //empty.Free;
  end;
end;

end.
