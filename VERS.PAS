unit vers;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

function GetVersion(exename:string):string;
function delbuild(vv:string):string;
function VerToNum(vers:string):integer;

implementation

type
  TEXEVersionData = record
    CompanyName,
    FileDescription,
    FileVersion,
    InternalName,
    LegalCopyright,
    LegalTrademarks,
    OriginalFileName,
    ProductName,
    ProductVersion,
    Comments,
    PrivateBuild,
    SpecialBuild: string;
  end;


// xx.xx.xx.xx ->
function VerToNum(vers:string):integer;
var
 ps:array[1..4] of integer;
 ps_count:integer;
 n1,n2,n3,n4:string;
 i:integer;
begin
 try
   if vers='' then
   begin
      result:=0; exit;
   end;
   ps_count:=0;
   for i:=1 to length(ps) do ps[i]:=length(vers)+1;
   for i:=1 to length(vers) do
   begin
       if vers[i]='.' then
       begin
          ps_count:=ps_count+1;
          ps[ps_count]:=i;
       end;
   end;
   n1:=copy(vers,1,ps[1]-1);
   n2:=copy(vers,ps[1]+1,ps[2]-ps[1]-1);
   case ps_count of
     1: begin
        n3:='0';
        n4:='0';
        end;
     2: begin
        n3:=copy(vers,ps[2]+1,ps[3]-ps[2]-1);
        n4:='0';
        end;
     3: begin
        n3:=copy(vers,ps[2]+1,ps[3]-ps[2]-1);
        n4:=copy(vers,ps[3]+1,ps[4]-ps[3]-1);
        end;
   end;
   // число
   result:=strtoint(n4)+strtoint(n3)*100+strtoint(n2)*10000+strtoint(n1)*1000000;
 except
   result:=0;
 end;
end;

// отсечем билд
function delbuild(vv:string):string;
var
  i:integer;
begin
 result:=vv;
 for i:=length(vv) downto 1 do
 begin
     if vv[i]='.' then
     begin
        result:=copy(vv,1,i-1);
        break;
     end;
 end;
end;
{$WARNINGS OFF}
function GetEXEVersionData(const FileName: string):TEXEVersionData;
type
  PLandCodepage = ^TLandCodepage;
  TLandCodepage = record
    wLanguage,
    wCodePage: word;
  end;
var
  dummy,
  len: cardinal;
  buf, pntr: pointer;
  lang: string;
begin
  len := GetFileVersionInfoSize(PChar(FileName), dummy);
  if len = 0 then
    RaiseLastOSError;
  GetMem(buf, len);
  try
    if not GetFileVersionInfo(PChar(FileName), 0, len, buf) then
      RaiseLastOSError;

    if not VerQueryValue(buf, '\VarFileInfo\Translation\', pntr, len) then
      RaiseLastOSError;

    lang := Format('%.4x%.4x', [PLandCodepage(pntr)^.wLanguage, PLandCodepage(pntr)^.wCodePage]);

    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\CompanyName'), pntr, len){ and (@len <> nil)} then
      result.CompanyName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileDescription'), pntr, len){ and (@len <> nil)} then
      result.FileDescription := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileVersion'), pntr, len){ and (@len <> nil)} then
      result.FileVersion := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\InternalName'), pntr, len){ and (@len <> nil)} then
      result.InternalName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\LegalCopyright'), pntr, len){ and (@len <> nil)} then
      result.LegalCopyright := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\LegalTrademarks'), pntr, len){ and (@len <> nil)} then
      result.LegalTrademarks := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\OriginalFileName'), pntr, len){ and (@len <> nil)} then
      result.OriginalFileName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\ProductName'), pntr, len){ and (@len <> nil)} then
      result.ProductName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\ProductVersion'), pntr, len){ and (@len <> nil)} then
      result.ProductVersion := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\Comments'), pntr, len){ and (@len <> nil)} then
      result.Comments := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\PrivateBuild'), pntr, len){ and (@len <> nil)} then
      result.PrivateBuild := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\SpecialBuild'), pntr, len){ and (@len <> nil)} then
      result.SpecialBuild := PChar(pntr);
  finally
    FreeMem(buf);
  end;
end;
function GetVersion(exename:string):string;
var
 ver:TEXEVersionData;
begin
  ver:=Getexeversiondata(exename);
  result:=ver.FileVersion;
end;

end.
