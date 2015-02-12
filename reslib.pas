unit reslib;

interface

uses System.Classes, vcl.forms, System.SysUtils, setting;

procedure ExtractResource(setup:TsetupClass);
procedure logo;
procedure ExtractHelp(filename:string);
procedure extractLang;

implementation

uses VERS, Global, commonlib, jpeg, main, ulog;

const
  snd: array [1 .. 6] of string = ('error', 'in', 'out', 'online', 'offline', 'file');



procedure extract(fname, resname: string);
var
  ResStream: TResourceStream;
  FileStream: TFileStream;
begin
  ResStream := TResourceStream.Create(hinstance, resname, 'MY');
  try
    try
      FileStream := TFileStream.Create(fname, fmCreate);
      try
        FileStream.CopyFrom(ResStream, 0);
      finally
        FileStream.Free;
      end;
    except
      on E: Exception do
        log('extract: ' + E.Message);
    end;
  finally
    ResStream.Free;
  end;
end;

procedure logo;
begin
  extract(HTMLDir + 'logo.gif', 'LOGO');
end;

procedure ExtractHelp(filename:string);
begin
  extract(filename, 'HELP1');
end;

procedure extractLang;
begin
  extract(LangDir+'EN.lng', 'EN');
  extract(LangDir+'UK.lng', 'UK');
end;

// after loadsetup!
procedure ExtractResource(setup:TsetupClass);
var
  i: integer;
  ss: string;
  exe_ver: string;
begin

  exe_ver := VERS.GetVersion(Application.exename);
  if exe_ver <> setup.lastver then // если сменилась версия - распаковываем ресурсы (обязательно накрываем)
  begin
    DeleteFolder(HTMLDir + '\Smiles\');
    createdir(HTMLDir + '\Smiles\');
    for i := 20 to 49 do
    begin
      ss := HTMLDir + '\Smiles\ani' + formatfloat('00', i) + '.gif';
      extract(ss, 'ANI' + formatfloat('00', i));
    end;
    // распаковка звуков, теперь mp3
    for i := 1 to length(snd) do
    begin
      extract(SoundDir + snd[i] + '.mp3', 'W' + uppercase(snd[i]));
    end;
    // статические смайлы теперь GIF
    for i := 0 to 28 do
    begin
      ss := HTMLDir + '\Smiles\smi' + formatfloat('000', i) + '.gif';
      extract(ss, 'SMI' + formatfloat('000', i));
    end;
    for i := 56 to 57 do
    begin
      ss := HTMLDir + '\Smiles\smi' + formatfloat('000', i) + '.gif';
      extract(ss, 'SMI' + formatfloat('000', i));
    end;
    for i := 80 to 81 do
    begin
      ss := HTMLDir + '\Smiles\smi' + formatfloat('000', i) + '.gif';
      extract(ss, 'SMI' + formatfloat('000', i));
    end;
    // дополнения PNG
    ss := HTMLDir + '\Smiles\logo.gif';
    extract(ss, 'LOGO');
    // иконки для списка пользов
    ss := HTMLDir + '\Smiles\igray.gif';
    extract(ss, 'IGRAY');
    ss := HTMLDir + '\Smiles\ired.gif';
    extract(ss, 'IRED');
    ss := HTMLDir + '\Smiles\igreen.gif';
    extract(ss, 'IGREEN');
  end;
  setup.lastVer := exe_ver;
end;

end.
