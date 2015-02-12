unit ulog;

interface

uses windows, sysutils, forms, shellapi;

Procedure log(msg:string);
procedure dellog(always:boolean=false);

implementation

uses Commonlib, main, Global;

// журнал
Procedure log(msg:string);
var
 lf:string;
 flog:textfile;
begin
  try
    if (FileExists(extractfilepath(application.ExeName)+'logok')) then
    begin
      lf:=extractfilepath(application.ExeName)+log_file;
      assignfile(flog,lf);
      if fileexists(lf) then
        append(flog)
      else
        rewrite(flog);
      writeln(flog,datetostr(date)+' '+timetostr(time)+' '+msg);
      closefile(flog);
    end;
  except
  end;
end;

// чистка лога
procedure dellog(always:boolean=false);
var
 lf:string;
 d1:tdatetime;
 Year, Month, Day: Word;
 Year2, Month2, Day2: Word;
begin
 lf:=extractfilepath(application.ExeName)+log_file;
 if always then
    deletefile(lf)
 else
 if myfilesize(lf)>2000000 then
    deletefile(lf)
 else
 begin
    d1:=filedatetime(lf);
    DecodeDate(d1, Year, Month, Day);
    DecodeDate(now, Year2, Month2, Day2);
    if day<>day2 then deletefile(lf);
 end;
end;

end.
