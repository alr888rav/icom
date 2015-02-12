unit Global;

interface

const
  KB=1024;
  MB=KB*KB;
  GB=int64(KB*MB);
  MAX_FILE_SIZE_V1 = 50*MB;
  MAX_FILE_SIZE_V2 = 1*GB;
  default_lang='RU';
  default_port=6711;
  myavatar='MyAvatar.jpg';
  OFFLINE=-1;
  OFF=0;
  ONLINE=2;
  max=50;
  log_file='icom.log';
  ImgName='IMG';
  AniName='ANI';
  SmileName='SMI';
  LFa:ansistring=#13#10;
  LF=#13#10;
  flt=true;
  ititle='����';
  FREE_CH=98;
  PERSONAL_CH=100;
  READONLY_CH=-1;
  NOT_CREATE_TAB=false;
  SAND='#FFF0B2';
  USER_DISPLAY='user_display';
  // ���-����
  ini_file='icom.cfg';
  ini_file_xml='icom.xml';
  // ������
  LNK_FILE='icomfile://';
var
  // ����� ��� html
  HTMLdir:string;
  // ����� ��� ������
  SoundDir:string;
  // ���
  CacheDir:string;
  // �����
  LangDir:string;
  // ���� � �����
  path:string;


type
  Tstatus=integer;

function TestMode:boolean;
procedure myFreeAndNil(var Obj);

implementation

uses sysutils;

{$WARNINGS OFF}
procedure myFreeAndNil(var Obj);
var
  Temp: TObject;
begin
  if assigned(TObject(Obj)) then
  begin
    Temp := TObject(Obj);
    Pointer(Obj) := nil;
    Temp.Free;
  end;
end;
{$WARNINGS OFF}

// �������� �� ����� = �������� �����
function TestMode:boolean;
begin
  result:=fileexists(path+'icom.dpr');
end;

end.
