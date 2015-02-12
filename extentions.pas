unit extentions;

// определяет тип файла если нет расширения
// попдерживаются mp3, mpg, asf, mov, swf, flv
// jpg, png, bmp, gif,
// exe, class (java)
// pdf, djvu, html, docx, xlsx, doc, xls
// rar, zip
interface

uses Windows, ShellAPI, sysutils, forms, classes;

function GetExt(file_name: string): string;

implementation

uses commonlib;

function File2string(file_name:string):ansistring;
var
  MyStream :TStringStream;
  TmpStrA: ansistring;
begin
  if FileExists(file_name) then
  begin
    MyStream := TStringStream.create;
    try
      MyStream.LoadFromFile(file_name);
      MyStream.Position := 0;
      if MyStream.Size > 0 then
      begin
        //SetLength(TmpStrA, MyStream.Size);
        //MyStream.read(TmpStrA[1], MyStream.Size);
        TmpStrA := AnsiString(MyStream.DataString);
      end
      else
        TmpStrA := '';
      result:=TmpStrA;
    finally
      MyStream.free;
    end;
  end
  else
    TmpStrA := '';
  result:=TmpStrA;
end;
(*
procedure DeleteFolder(FolderName: string);
var
  SR: TSearchRec;
  Len: integer;
begin
  Len := Length(FolderName);
  if FolderName[Len] = '\' then
    FolderName := Copy(FolderName, 1, Len - 1);
  if FindFirst(FolderName + '\*.*', faAnyFile, SR) = 0 then
  begin
    repeat
      if SR.Name = '.' then
        Continue;
      if SR.Name = '..' then
        Continue;
{$WARNINGS OFF}
      FileSetAttr(FolderName + '\' + SR.Name, SR.Attr and faDirectory);
{$WARNINGS ON}
      if SR.Attr and faDirectory <> 0 then
        DeleteFolder(FolderName + '\' + SR.Name)
      else
        DeleteFile(FolderName + '\' + SR.Name);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  RemoveDir(FolderName);
end;
*)

function GetExt(file_name: string): string;
var
  res2: string;
  mybuf: array [0 .. 50] of Byte;
  i: integer;
  TmpStrA: ansistring;
begin
  res2 := '';
  try
    if not fileexists(file_name) then
      exit;
    TmpStrA := File2string(file_name);
    i := 0;
    while (i < Length(mybuf)) and (i < Length(TmpStrA)) do
    begin
      mybuf[i] := Byte(TmpStrA[i + 1]);
      i := i + 1;
    end;

    if (mybuf[0] = $FF) and (mybuf[1] = $FB) then
      res2 := 'mp3'
    else if (mybuf[0] = $FF) and (mybuf[1] = $FB) then
      res2 := 'mp3'
    else if (mybuf[0] = $FF) and (mybuf[1] = $F3) then
      res2 := 'mp3'
    else if (mybuf[0] = $52) and (mybuf[1] = $49) and (mybuf[2] = $46) and (mybuf[3] = $46) then
      res2 := 'wav mp3'
    else if (mybuf[0] = $49) and (mybuf[1] = $44) and (mybuf[2] = $33) then
      res2 := 'mp3'
    else if (mybuf[0] = $4D) and (mybuf[1] = $54) and (mybuf[2] = $68) and (mybuf[3] = $64) then
      res2 := 'mid'
    else if (mybuf[0] = $FF) and (mybuf[1] = $D8) and (mybuf[2] = $FF) then
      res2 := 'jpg'
    else if (mybuf[0] = $47) and (mybuf[1] = $49) and (mybuf[2] = $46) then
      res2 := 'gif'
    else if (mybuf[0] = $00) and (mybuf[1] = $00) and (mybuf[2] = $01) then
      res2 := 'mpg'
    else if (mybuf[4] = $6D) and (mybuf[5] = $6F) and (mybuf[6] = $6F) and (mybuf[7] = $76) then
      res2 := 'mov'
    else if (mybuf[0] = $30) and (mybuf[1] = $26) and (mybuf[2] = $B2) then
      res2 := 'asf'
    else if (mybuf[0] = $25) and (mybuf[1] = $50) and (mybuf[2] = $44) and (mybuf[3] = $46) then
      res2 := 'pdf'
    else if (mybuf[0] = $CA) and (mybuf[1] = $FE) and (mybuf[2] = $BA) and (mybuf[3] = $BE) and (mybuf[4] = $00) then
      res2 := 'class'
    else if (mybuf[0] = $4D) and (mybuf[1] = $5A) and (mybuf[2] = $50) and (mybuf[3] = $00) then
      res2 := 'exe'
    else if (mybuf[0] = $43) and (mybuf[1] = $57) and (mybuf[2] = $53) and (mybuf[3] = $00) then
      res2 := 'swf'
    else if (mybuf[0] = $46) and (mybuf[1] = $57) and (mybuf[2] = $53) then
      res2 := 'swf'
    else if (mybuf[0] = $46) and (mybuf[1] = $4C) and (mybuf[2] = $56) then
      res2 := 'flv'
    else if (mybuf[1] = $50) and (mybuf[2] = $4E) and (mybuf[3] = $47) then
      res2 := 'png'
    else if (mybuf[0] = $52) and (mybuf[1] = $61) and (mybuf[2] = $72) then
      res2 := 'rar'
    else if (mybuf[0] = $3C) and (mybuf[1] = $21) and (mybuf[2] = $44) and (mybuf[3] = $4F) and (mybuf[4] = $43) then
      res2 := 'html'
    else if (mybuf[0] = $3C) and (mybuf[1] = $68) and (mybuf[2] = $74) and (mybuf[3] = $6D) and (mybuf[4] = $6C) then
      res2 := 'html'
    else if (mybuf[0] = $3C) and (mybuf[1] = $48) and (mybuf[2] = $54) and (mybuf[3] = $4D) and (mybuf[4] = $4C) then
      res2 := 'html'
    else if (mybuf[0] = $42) and (mybuf[1] = $4D) then
      res2 := 'bmp'
    else if (mybuf[0] = $49) and (mybuf[1] = $49) and (mybuf[2] = $2A) then
      res2 := 'tiff'
    else if (mybuf[0] = $41) and (mybuf[1] = $54) and (mybuf[2] = $26) and (mybuf[3] = $54) then
      res2 := 'djvu'
  finally
    if Length(res2) > 10 then
      res2 := '';
    if res2 <> '' then
      result := '.' + res2
    else
      result := res2;

  end;
end;

end.
