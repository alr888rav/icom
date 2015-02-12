unit simpleEncrypt;

interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes;

type TCipher = class
  private
  public
    function EnCrypt(const Value : String) : String;
    function DeCrypt(const Value : String) : String;
end;

implementation

{$WARNINGS OFF}
function TCipher.EnCrypt(const Value : String) : String;
var
  CharIndex : integer;
  avalue, ss, ss2: AnsiString;
  i: Integer;
begin
  avalue := AnsiString(Value);
  SetLength(ss, Length(aValue));
  for CharIndex := 1 to Length(aValue) do
    ss[CharIndex] := AnsiChar(not(ord(aValue[CharIndex])+CharIndex));
  ss2:='';
  for i:=1 to length(ss) do
  begin
    ss2:=ss2+Ansistring(inttoHex(ord(ss[i]),2));
  end;
  result:=string(ss2);
end;

function TCipher.DeCrypt(const Value : String) : String;
var
  CharIndex : integer;
  ss, ss2: AnsiString;
  i: Integer;
begin
  try
    ss:='';
    i:=1;
    while i<length(value) do
    begin
      ss:=ss+ansichar(strtoint('$'+copy(string(value),i,2)));
      i:=i+2;
    end;
    SetLength(ss2, Length(ss));
    for CharIndex := 1 to Length(ss) do
      ss2[CharIndex] := AnsiChar(not(ord(ss[CharIndex]))-CharIndex);
    result:=string(ss2);
  except
    result:='';
  end;
end;
{$WARNINGS ON}

end.
