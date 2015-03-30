unit htmllib;

interface

uses MAIN, forms, sysutils, classes, windows, Vcl.Graphics, JvAnimatedImage, JvGIFCtrl, jpeg;

function AddText2HTML2(FromName, ch_name: string; msg: string; id:string):string;
function AddSysText2HTML2(FromName, ch_name: string; msg: string; color: string; id: string):string;
function NewHtml:string;

Function ImgSize(msg: string): string;
function DetectURL(msg: string): string;
function AddSmiles(msg: string): string;
function html2text(msg: string): string;
function htmlcode2text(html: string): string;
function empty(msg: string): boolean;
function TwinTag(msg: string): string;
function findBR(ss: string; maxl: integer): integer;
function DelEmpty(tag, txt: string; insert_br: boolean = false): string;
function DeleteTag(tag, txt: string): string;
function DeleteBR(delfirst, dellast: boolean; txt: string): string;
function DeleteDouble(tag, txt: string; level: integer = 3): string;
function HTMLColor(Color: TColor): string;
Function SimpleHTML(TmpStrHTML: string): string;
function htmlBegin:string;
function htmlEnd:string;
function HtmlColor2Color(html:string):Tcolor;
function spec2text(html: string): string;
procedure gif2jpg(fname:string);
function delLast(url:string):string;

implementation

uses CommonLib, strutils, icomplugins, setting, ulog, Global;

const
  AniName = 'ANI';
  SmileName = 'SMI';

function delLast(url:string):string;
begin
  if copy(url,length(url))='/' then
    url:=copy(url,1,length(url)-1);
  Result := url;
end;

// упрощение html
Function SimpleHTML(TmpStrHTML: string): string;
begin
  // уберем параграфы
  TmpStrHTML := DeleteTag('p', TmpStrHTML);
  TmpStrHTML := stringreplace(TmpStrHTML, '<br></span>', '</span>', [rfreplaceall, rfIgnoreCase]);
  // удалим "пустые" теги <p ....></p> <span ...></span>  <div...></div>
  TmpStrHTML := DelEmpty('span', TmpStrHTML, true);
  TmpStrHTML := DelEmpty('div', TmpStrHTML);
  // замена на теги
  TmpStrHTML := stringreplace(TmpStrHTML, '[hr]', '<hr>', [rfreplaceall, rfIgnoreCase]);
  TmpStrHTML := stringreplace(TmpStrHTML, '[br]', '<br>', [rfreplaceall, rfIgnoreCase]);
  // правка расположения тегов
  TmpStrHTML := stringreplace(TmpStrHTML, '<hr></span><br>', '<hr>', [rfreplaceall, rfIgnoreCase]);
  TmpStrHTML := stringreplace(TmpStrHTML, '<blockquote>', '</span><blockquote>', [rfreplaceall, rfIgnoreCase]);
  TmpStrHTML := stringreplace(TmpStrHTML, '</blockquote></span>', '</span></blockquote>', [rfreplaceall, rfIgnoreCase]);
  TmpStrHTML := stringreplace(TmpStrHTML, '</blockquote><br>', '</blockquote>', [rfreplaceall, rfIgnoreCase]);
  // еще раз почистим
  TmpStrHTML := DelEmpty('span', TmpStrHTML);
  TmpStrHTML := DeleteBR(false, true, TmpStrHTML);
  result := TmpStrHTML;
end;

// Tcolor to hex
function HTMLColor(Color: TColor): string;
begin
  result := 'rgb('
    // red
    + inttostr(GetRValue(Color)) + ','
    // green
    + inttostr(GetGValue(Color)) + ','
    // blue
    + inttostr(GetBValue(Color)) + ')';
end;

function HtmlColor2Color(html:string):Tcolor;
var
  psbegin,ps1,ps2,psend:integer;
  r,g,b:string;
begin
  psbegin:=pos('(',html);
  ps1:=pos(',',html);
  ps2:=posex(',', html, ps1+1);
  psend:=pos(')',html);
  r:=copy(html,psbegin+1,ps1-psbegin-1);
  g:=copy(html,ps1+1,ps2-ps1-1);
  b:=copy(html,ps2+1,psend-ps2-1);
  result:=RGB(toint(r),toint(g),toint(b));
end;

  // тип файла html?
function isHTMLfile(fn: string): boolean;
var
  ff: file of Char;
  i: integer;
  ss: string;
  ch: Char;
begin
  result := false;
  try
    AssignFile(ff, fn);
    Reset(ff);
    ss := '';
    for i := 0 to 10 do
    begin
      read(ff, ch);
      ss := ss + ch;
    end;
    if (Pos('<!DOCTYPE', ansiUpperCase(ss)) <> 0) or (Pos('<HTML', ansiUpperCase(ss)) <> 0) then
      result := true;
    CloseFile(ff);
  except
    on E: Exception do
      log('htmlfile: ' + E.Message);
  end
end;

function spec2text(html: string): string;
begin
  html := stringreplace(html, '%20', ' ', [rfReplaceall,rfIgnoreCase]);
  html := stringreplace(html, '&amp;', '&', [rfReplaceall,rfIgnoreCase]);
  html := stringreplace(html, '&nbsp;', ' ', [rfReplaceall,rfIgnoreCase]);
  html := stringreplace(html, '&lt;', '<', [rfReplaceall,rfIgnoreCase]);
  html := stringreplace(html, '&gt;', '>', [rfReplaceall,rfIgnoreCase]);
  html := stringreplace(html, '&euro;', 'euro', [rfReplaceall,rfIgnoreCase]);
  html := stringreplace(html, '&quot;', '"', [rfReplaceall,rfIgnoreCase]);
  result := html;
end;

// юникодный html текст вида &#1234 в строку
function htmlcode2text(html: string): string;
var
  i, start, ps: integer;
  ss: string;
  ch: Char;
  new: string;
  count: integer;
begin
  try
    new := '';
    start := 1;
    while start <= length(html) do
    begin
      ps := posex('&#', html, start);
      if ps <> 0 then
      begin
        new := new + copy(html, 1, ps - 1);
        ss := '';
        i := ps + 2;
        count := 0;
        while (html[i] <> ';') and (count < 6) do
        begin
          if charinset(html[i], ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
            ss := ss + copy(html, i, 1)
          else
            break;
          i := i + 1;
          count := count + 1;
        end;
        ch := chr(strtoint(ss));
        new := new + ch;
        html := copy(html, ps + count + 3, length(html) - ps - count - 1);
      end
      else
        break;
    end;
    new := new + html;
    result := new;
  except
    result := html;
  end;
end;

// удалить двойные теги
function DeleteDouble(tag, txt: string; level: integer = 3): string;
var
  i: integer;
begin
  for i := 1 to level do
    txt := stringreplace(txt, tag + tag, tag, [rfReplaceall, rfIgnoreCase]);
end;

// удалить первы и последний br
function DeleteBR(delfirst, dellast: boolean; txt: string): string;
begin
  if delfirst then
    if Pos('<br>', txt) = 1 then
      txt := copy(txt, 5, length(txt) - 4); // 1й BR
  if dellast then
  begin
    txt := stringreplace(txt, '<br>' + LF, '<br>', [rfReplaceall, rfIgnoreCase]);
    txt := stringreplace(txt, '<br><br>', '<br>', [rfReplaceall, rfIgnoreCase]);
    if (Pos('<br>', txt) <> 0) and (posex('<br>', txt, length(txt) - 3) = length(txt) - 3) then
      txt := copy(txt, 1, length(txt) - 4); // последний BR
  end;
  result := txt;
  if delfirst then
    if Pos('[br]', txt) = 1 then
      txt := copy(txt, 5, length(txt) - 4); // 1й BR
  if dellast then
  begin
    txt := stringreplace(txt, '[br]' + LF, '[br]', [rfReplaceall, rfIgnoreCase]);
    txt := stringreplace(txt, '[br][br]', '[br]', [rfReplaceall, rfIgnoreCase]);
    if (Pos('[br]', txt) <> 0) and (posex('[br]', txt, length(txt) - 3) = length(txt) - 3) then
      txt := copy(txt, 1, length(txt) - 4); // последний BR
  end;
  result := txt;
end;

// удаление тегов
function DeleteTag(tag, txt: string): string;
var
  i, ps1o, ps1e, ps2o: integer;
  start, count: integer;
begin
  try
    count := 0;
    start := 1;
    while start < length(txt) do
    begin
      count := count + 1;
      if count > 10 then
        break;
      ps1o := posex('<' + tag, txt, start);
      ps1e := ps1o;
      ps2o := posex('</' + tag + '>', txt, ps1o); // ps2e:=ps2o+2+length(tag)+1;
      if (ps1o <> 0) then
      begin
        // ищем конец открывающего тега
        for i := ps1o to ps2o do
        begin
          if txt[i] = '>' then
          begin
            ps1e := i;
            break;
          end;
        end;
        // удаляем теги
        if ps1e > ps1o then
        begin
          delete(txt, ps1o, ps1e - ps1o + 1);
          start := 1; // после удаления начнем с начала
        end;
      end
      else
        break;
    end;
    if ansiUpperCase(tag) = 'P' then
      txt := stringreplace(txt, '</' + tag + '>', '<br>', [rfReplaceall, rfIgnoreCase])
    else
      txt := stringreplace(txt, '</' + tag + '>', '', [rfReplaceall, rfIgnoreCase]);
  finally
    result := txt;
  end;
end;

// удаление пустых(между которыми ничего нет) пар тегов
function DelEmpty(tag, txt: string; insert_br: boolean = false): string;
var
  i, ps1o, ps1e, ps2o, ps2e: integer;
  em: boolean;
  start, count: integer;
begin
  try
    count := 0;
    start := 1;
    while start < length(txt) do
    begin
      count := count + 1;
      if count > 10 then
        break;
      ps1o := posex('<' + tag, txt, start);
      ps1e := ps1o;
      ps2o := posex('</' + tag + '>', txt, ps1o);
      ps2e := ps2o + 2 + length(tag) + 1;
      if (ps1o <> 0) and (ps2o <> 0) then
      begin
        // ищем конец открывающего тега
        for i := ps1o to ps2o do
        begin
          if txt[i] = '>' then
          begin
            ps1e := i;
            break;
          end;
        end;
        // проверка что ничего нет между тегами
        em := true;
        for i := ps1e + 1 to ps2o - 1 do
        begin
          if txt[i] <> ' ' then
          begin
            em := false;
            break;
          end
        end;
        // удаляем теги
        if (em) and (ps1e > ps1o) then
        begin
          delete(txt, ps1o, ps2e - ps1o);
          start := 1; // после удаления начнем с начала
          if insert_br then
            insert('<br>', txt, ps1o); // чтобы не исчезали пустые строки
        end
        else // двигаемся дальше
          start := ps1o + 1;
      end
      else
        break;
    end;
  finally
    result := txt;
  end;
end;

function link(number: integer; txt: string): string;
begin
  result := '<a style="text-decoration: none; color: ' + htmlcolor(Setup.sysfont.color) + ';" href="icom' +
    inttostr(number) + '://' + inttostr(GetTickCount) + '">' + txt + '</a>';
end;

// нахождение концов строк начиная с указанной позиции
function findBR(ss: string; maxl: integer): integer;
var
  i: integer;
  intag: boolean;
  charpos: integer;
  function NextChar(const cur_pos: integer): integer;
  var
    i: integer;
  begin
    try
      i := cur_pos;
      if (ss[i] = '&') then
        while ss[i] <> ';' do
          i := i + 1;
      result := i;
    except
      result := cur_pos
    end;
  end;

begin
  result := 0;
  charpos := 0;
  intag := false;
  i := 1;
  while i <= length(ss) do
  begin
    if (ss[i] = '<') and (not intag) then
    begin
      intag := true;
    end;
    if (ss[i] = '>') and (intag) then
    begin
      intag := false;
    end;
    i := i + 1;
    if (not intag) and (ss[i] <> '<') then
    begin
      i := NextChar(i);
      charpos := charpos + 1;
      if (i <= length(ss)) and (charpos > maxl) then
      begin
        result := i;
        break;
      end;
    end;
  end;
end;

// закрытие незакрытых тегов
function TwinTag(msg: string): string;
var
  stack: Tstringlist;
  i: integer;
  start, ends: integer;
  lasttag: string;
  intag: boolean;
  ss: string;
  ps: integer;
  i2: integer;
  nn: integer;
begin
  result := msg;
  stack := Tstringlist.create;
  try
    try
      intag := false;
      i := 1;
      start := 0;
      ends := 0;
      // накопим теги
      while i <= length(msg) do
      begin
        if (msg[i] = '<') and (not intag) then
        begin
          intag := true;
          start := i;
          ends := i;
        end;
        if (msg[i] = '>') and (intag) then
        begin
          intag := false;
          ends := i;
        end;
        if ends > start then
        begin
          lasttag := copy(msg, start, ends - start + 1);
          start := 0;
          ends := 0;
          stack.Add(lasttag);
        end
        else
        begin
          i := i + 1;
        end;
      end;
      if stack.count = 0 then // тегов нет - уходим
        exit;
      // минимальный вид тегов
      for i := 0 to stack.count - 1 do
      begin
        ss := stack.Strings[i];
        ps := Pos(' ', ss);
        if ps <> 0 then
          stack.Strings[i] := copy(ss, 1, ps - 1) + '>';
      end;
      // удалим одинарные теги
      i := 0;
      while i <= stack.count - 1 do
      begin
        if stack.Strings[i] = '<br>' then
          stack.delete(i)
        else if stack.Strings[i] = '<hr>' then
          stack.delete(i)
        else
          i := i + 1;
      end;
      // удалим все правильные пары тегов
      nn := 0;
      i2 := -1;
      while true do
      begin
        lasttag := '';
        for i := 1 to stack.count - 1 do // ищем 1й закрывающий
        begin
          if copy(stack.Strings[i], 1, 2) = '</' then
          begin
            lasttag := stringreplace(stack.Strings[i], '</', '<', []);
            i2 := i;
            break;
          end;
        end;
        // если предыдущий открывающий такой же удалим оба
        if lasttag > '' then
        begin
          if (i2 >= 0) and (stack.Strings[i2 - 1] = lasttag) then
          begin
            stack.delete(i2);
            stack.delete(i2 - 1);
          end;
        end
        else
        begin
          break;
        end;
        nn := nn + 1;
        if nn > 100 then
          break;
      end;
      // дополним до пар
      i2 := stack.count - 1;
      for i := i2 downto 0 do
      begin
        ss := stringreplace(stack.Strings[i], '<', '</', []);
        ss := stringreplace(ss, '//', '/', []);
        stack.Add(ss);
        result := result + ' ' + ss;
      end;
    except
      on E: Exception do
        log('twintag: ' + E.Message);
    end;
  finally
    myFreeAndNil(stack);
  end;
end;

function html2text(msg: string): string;
var
  ss: string;
  intag: boolean;
  i: integer;
  start, ends: integer;
begin
  try
    start := Pos('<BODY>', ansiUpperCase(msg));
    if start <> 0 then
      ss := copy(msg, start + 6, length(msg) - start + 1)
    else
      ss := msg;
    start := Pos('</BODY>', ansiUpperCase(ss));
    if start <> 0 then
      ss := copy(ss, 1, start - 1);

    //ss := DelScript(ss);
    ss := stringreplace(ss,'<br>',#13#10,[rfReplaceAll,rfIgnoreCase]);
    intag := false;
    i := 1;
    start := 0;
    ends := 0;
    while i <= length(ss) do
    begin
      if (ss[i] = '<') and (not intag) then
      begin
        intag := true;
        start := i;
        ends := i;
      end;
      if (ss[i] = '>') and (intag) then
      begin
        intag := false;
        ends := i;
      end;
      if ends > start then
      begin
        delete(ss, start, ends - start + 1);
        i := start;
        start := 0;
        ends := 0;
      end
      else
      begin
        i := i + 1;
      end;
    end;
    ss := Spec2text(ss);
    while Pos(LF + LF, ss) <> 0 do
      ss := stringreplace(ss, LF + LF, LF, [rfReplaceall]);
    result := ss;
  except
    on E: exception do
    begin
      log('#ERROR html2text ' + E.message+LF+msg);
      result := '';
    end;
  end;
end;

function DetectURL(msg: string): string;
var
  ss: string;
  start, ends: integer;
  i: integer;
  url: string;
const
  delimeters: string = ' {}<>'#13#10;
begin
  try
    ends := 0;
    ss := ' ' + msg + ' ';
    // сылки вида \\.....
    for i := 1 to length(delimeters) do
    begin
      ss := stringreplace(ss, delimeters[i] + '\\', delimeters[i] + ' \\', [rfReplaceall]);
    end;
    ss := stringreplace(ss, '\\', ' \\', [rfReplaceall]);
    while Pos(' \\', ss) <> 0 do
    begin
      start := Pos(' \\', ss);
      i := 1;
      while i < length(ss) do
      begin
        if (Pos(ss[start + i], delimeters) <> 0) then
        begin
          ends := start + i;
          break;
        end;
        i := i + 1;
      end;
      if ends > start then
      begin
        url := copy(ss, start + 1, ends - start - 1);
        ss := stringreplace(ss, ' ' + url, '<a href="' + url + '">' + url + '</a>', []);
        // start:=0;
        ends := 0;
      end;
    end;

    // выделить http
    for i := 1 to length(delimeters) do
    begin
      ss := stringreplace(ss, delimeters[i] + 'www.', delimeters[i] + ' http://www.', [rfReplaceall, rfIgnoreCase]);
    end;
    ss := ' ' + ss;
    ss := stringreplace(ss, 'http://', ' http://', [rfReplaceall, rfIgnoreCase]); // станет lower
    while Pos(' http://', ss) <> 0 do
    begin
      start := Pos(' http://', ss);
      i := 1;
      while i < length(ss) do
      begin
        if (Pos(ss[start + i], delimeters) <> 0) then
        begin
          ends := start + i;
          break;
        end;
        i := i + 1;
      end;
      if ends > start then
      begin
        url := copy(ss, start + 1, ends - start - 1);
        ss := stringreplace(ss, ' ' + url, '<a href="' + url + '">' + urlDecode(url) + '</a>', []);
        // start:=0;
        ends := 0;
      end;
    end;
    // выделить https
    ss := stringreplace(ss, 'https://', ' https://', [rfReplaceall, rfIgnoreCase]);
    while Pos(' https://', ss) <> 0 do
    begin
      start := Pos(' https://', ss);
      i := 1;
      while i < length(ss) do
      begin
        if (Pos(ss[start + i], delimeters) <> 0) then
        begin
          ends := start + i;
          break;
        end;
        i := i + 1;
      end;
      if ends > start then
      begin
        url := copy(ss, start + 1, ends - start - 1);
        ss := stringreplace(ss, ' ' + url, '<a href="' + url + '">' + urlDecode(url) + '</a>', []);
        // start:=0;
        ends := 0;
      end;
    end;
    // выделить ftp
    ss := stringreplace(ss, 'ftp://', ' ftp://', [rfReplaceall, rfIgnoreCase]);
    while Pos(' ftp://', ss) <> 0 do
    begin
      start := Pos(' ftp://', ss);
      i := 1;
      while i < length(ss) do
      begin
        if (Pos(ss[start + i], delimeters) <> 0) then
        begin
          ends := start + i;
          break;
        end;
        i := i + 1;
      end;
      if ends > start then
      begin
        url := copy(ss, start + 1, ends - start - 1);
        ss := stringreplace(ss, ' ' + url, '<a href="' + url + '">' + url + '</a>', []);
        // start:=0;
        ends := 0;
      end;
    end;
    // выделить waste
    ss := stringreplace(ss, 'waste:/', ' waste:/', [rfReplaceall, rfIgnoreCase]);
    while Pos(' waste:/', ss) <> 0 do
    begin
      start := Pos(' waste:/', ss);
      i := 1;
      while i < length(ss) do
      begin
        if (Pos(ss[start + i], delimeters) <> 0) then
        begin
          ends := start + i;
          break;
        end;
        i := i + 1;
      end;
      if ends > start then
      begin
        url := copy(ss, start + 1, ends - start - 1);
        ss := stringreplace(ss, ' ' + url, '<a href="' + url + '">' + urlDecode(url) + '</a>', []);
        // start:=0;
        ends := 0;
      end;
    end;
    // share://ЮЗЕР:КОМАНДА:c:\common\!test_data.txt
    ss := stringreplace(ss, 'share://', ' share://', [rfReplaceall, rfIgnoreCase]);
    while Pos(' share://', ss) <> 0 do
    begin
      start := Pos(' share://', ss);
      i := 1;
      while i < length(ss) do
      begin
        if (Pos(ss[start + i], delimeters) <> 0) then
        begin
          ends := start + i;
          break;
        end;
        i := i + 1;
      end;
      if ends > start then
      begin
        url := copy(ss, start + 1, ends - start - 1);
        ss := stringreplace(ss, ' ' + url, '<a href="' + url + '">' + urldecode(url) + '</a>', []);
        // start:=0;
        ends := 0;
      end;
    end;
    result := ss;
  except
    on E: exception do
    begin
      result := msg;
      log('#ERROR detectURL ' + E.message);
    end;
  end;
end;

function iplink(ip: string): string;
begin
  result := stringreplace(ip + '_', '.', '_', [rfReplaceall]);
end;

// замена <smi00> на <img src="'+htmldir+'Smiles\'+SMI00'.png">
function AddSmiHTML(ss: string): string;
var
  tmp, tmp2: string;
  ps: integer;
begin
  tmp := ss;
  while Pos('<' + SmileName, ansiUpperCase(tmp)) <> 0 do
  begin
    ps := Pos('<' + SmileName, ansiUpperCase(tmp));
    tmp2 := copy(tmp, ps + 1, length(SmileName) + 3);
    tmp := copy(tmp, 1, ps - 1) + '<img src="Smiles\' + tmp2 + '.gif">' + copy(tmp, ps + length(tmp2) + 2,
      length(tmp) - ps - length(tmp2) - 1);
  end;
  result := tmp;
end;

// замена <ani00> на <img src="'+htmldir+'Smiles\'+ANI00'.gif">
function AddAniHTML(ss: string): string;
var
  tmp, tmp2: string;
  ps: integer;
begin
  tmp := ss;
  while Pos('<' + AniName, ansiUpperCase(tmp)) <> 0 do
  begin
    ps := Pos('<' + AniName, ansiUpperCase(tmp));
    tmp2 := copy(tmp, ps + 1, length(AniName) + 2);
    if Pos('ANI_', ansiUpperCase(tmp2)) = 1 then
    begin // произвольный gif
      tmp2 := copy(tmp, ps + 1, Pos('.gif>', ansilowercase(tmp)) - ps - 1);
      tmp := copy(tmp, 1, ps - 1) + '<img src="' + tmp2 + '.gif">' + copy(tmp, ps + length(tmp2) + 6,
        length(tmp) - ps - length(tmp2) - 1);
    end
    else
    begin // смайлик
      tmp := copy(tmp, 1, ps - 1) + '<img src="Smiles\' + tmp2 + '.gif">' + copy(tmp, ps + length(tmp2) + 2,
        length(tmp) - ps - length(tmp2) - 1);
    end;
  end;
  result := tmp;
end;

// проверка на пустое сообщение
function empty(msg: string): boolean;
begin
  msg := ansiUpperCase(msg);
  try
    if msg = '' then
      result := true
    else if Pos('<IMG', msg) <> 0 then
      result := false
    else if Pos('<SMI', msg) <> 0 then
      result := false
    else if Pos('<ANI', msg) <> 0 then
      result := false
    else if Pos('<FILE', msg) <> 0 then
      result := false
    else if trim(stringreplace(html2text(msg), LF, '', [rfReplaceall])) > '' then
      result := false
    else
      result := true;
  except
    on E: exception do
    begin
      log(E.message);
      result := false;
    end;
  end;
end;

// замена <smixxx> <anixxx> на ссылку на картинку
function AddSmiles(msg: string): string;
var
  tmp: string;
begin
  tmp := AddAniHTML(msg);
  result := AddSmiHTML(tmp);
end;

function htmlBegin:string;
var
  ht: TstringList;
begin
  ht := TstringList.Create;
  ht.Add('<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4 Transitional//EN">');
  ht.add('<html>');
  ht.add('<head>');
  ht.add('<meta content="text/html; charset=Windows-1251" http-equiv="content-type">');
  ht.add('<title>ic</title>');
  ht.add('<style type="text/css">');
  ht.add('hr {');
  ht.add(' color: #CCCCFF;');
  ht.add(' height: 0px;');
  ht.add(' noshade;');
  ht.add(' border: none;');
  ht.add(' border-top: dotted 1px gray;');
  ht.add('}');
  ht.add('A:hover {');
  ht.add('    color: red;');
  ht.add('    text-decoration: underline;');
  ht.add('}');
  ht.add('</style>');
  ht.add('</head>');
  ht.add('<body link="#0000FF" vlink="#0000FF" alink="#0000FF"><font size="2" color="black">');
  result := ht.Text;
  ht.Free;
end;

function htmlEnd:string;
var
  ht: TstringList;
begin
  ht := TstringList.Create;
  ht.add('</body>');
  ht.add('</html>');
  result := ht.Text;
  ht.Free;
end;

procedure gif2jpg(fname:string);
var
  tempGif: TjvGifAnimator;
  img: TJpegImage;
  bm: TBitmap;
  rt: TRect;
begin
  if (fileexists(fname))and(not fileexists(changefileext(fname, '.jpg'))) then
  begin
    fname := extractfilename(fname);
    tempGif := TjvGifAnimator.Create(nil);
    tempGif.image.LoadFromFile(HtmlDir+fname);
    tempGif.Animate := false;
    tempGif.AutoSize := true;

    img := TJpegImage.Create;
    bm := TBitmap.Create;
    bm.Transparent := false;
    bm.Assign(tempGif.Image.Frames[0].Bitmap);

    rt := rect(2,2,20,20);
    bm.Canvas.Pen.Width := 1;
    bm.Canvas.Pen.Color := clGray;
    bm.Canvas.Brush.Color := clSilver;
    bm.Canvas.Rectangle(rt);

    bm.Canvas.Brush.Color := clWhite;
    bm.Canvas.Pen.Width := 2;
    bm.Canvas.Pen.Color := clWhite;
    bm.Canvas.MoveTo(16,10);
    bm.Canvas.LineTo(6,4);
    bm.Canvas.LineTo(6,16);
    bm.Canvas.LineTo(16,10);
    bm.Canvas.FloodFill(10,10, clWhite, fsBorder);

    img.Assign(bm);
    img.CompressionQuality := 80;
    img.Compress;
    img.SaveToFile(HtmlDir + changefileext(fname, '.jpg'));
    myFreeAndNil(bm);
    myFreeAndNil(img);
    myFreeAndNil(tempgif);
  end;
end;

function bs(msg:string):string;
begin
  result := stringreplace(msg,'\','/',[rfreplaceall]);
end;

// задать макс размеры картинки со ссылкой на полную
Function ImgSize(msg: string): string;
var
  ww, hh: word;
  iname: string;
  start, i, ps0, ps1, ps2: integer;
  tmp: string;
  cnt: integer;
  mx: integer;
  st: string;
const
  big=5000;
begin
  try
    tmp := msg;
    if Pos('<object', msg) = 0 then
    begin
      tmp := stringreplace(tmp, 'height=', 'h=', [rfReplaceall, rfIgnoreCase]);
      tmp := stringreplace(tmp, 'width=', 'w=', [rfReplaceall, rfIgnoreCase]);
    end;
    start := 1;
    cnt := 0;
    while posex('<img', tmp, start) <> 0 do
    begin
      ps0 := posex('<img', tmp, start);
      ps1 := posex('src="', tmp, ps0);
      ps2 := 0;
      for i := ps1 to length(tmp) - 1 do
      begin
        if (copy(tmp, i, 2) = '">') then
        begin
          ps2 := i;
          break;
        end;
      end;
      start := ps0;
      iname := copy(tmp, ps1 + 5, ps2 - ps1 - 5);
      if iname = '' then
        break;
      if fileexists(htmldir + iname) then
        GetImageSize(htmldir + iname, ww, hh)
      else
      begin
        hh := 0;
        ww := 0;
      end;
      case Setup.zoomMode of
        0:
            mx := maxint;
        1:
            mx := channels.getChannel(0).browser.clientwidth;
        2:
            mx := 100;
        3:
            mx := 200;
        4:
            mx := 400;
        5:
            mx := 600;
      else
            mx := 200;
      end;
      if pos('smiles\',ansilowercase(iname))<>0 then
        st := ''
      else if (Setup.zoomMode = 1)and((ww > mx)or(ww = 0)) then
        st := 'style="width: 100%;"'
      else if (ww > mx)or(ww = 0) then
        st := 'style="width: '+inttostr(mx)+'px;"'
      else
        st := '';
      // ждем gif если еще нет max 5сек
      for i:=1 to 10 do
      begin
        if fileexists(htmlDir+htmlcode2text(iname))and(myFileSize(htmlDir+htmlcode2text(iname))<>0) then
          break
        else
          delay(500);
      end;
      // предпросмотр gif (размер не меняем)
      if (ansilowercase(extractfileext(iname))='.gif')and(pos('smiles\',ansilowercase(iname))=0)and(myFileSize(htmlDir+htmlcode2text(iname))>100*1024) then
      begin
        gif2jpg(htmldir+htmlcode2text(iname));
        tmp := copy(tmp, 1, ps0 - 1) + '<a href="'+ LNK_FILE + htmldir + iname + '">' + '<img id='+#39+extractfilename(iname)+#39+
          ' src="' + htmldir + changefileext(iname,'.jpg') + '"' +
          ' onmouseover="document.getElementById('+#39+extractfilename(iname)+#39+').src='+#39+bs(htmldir+iname)+#39+'" '+
          ' onmouseout="document.getElementById('+#39+extractfilename(iname)+#39+').src='+#39+bs(htmldir+changefileext(iname,'.jpg'))+#39+'" '+
          '></a>' + copy(tmp, ps2 + 2, length(tmp) - ps2 - 1);
      end
      else
      begin // jpg размер по настройкам
        tmp := copy(tmp, 1, ps0 - 1) + '<a href="'+ LNK_FILE + htmldir + iname + '">' + '<img ' + st +
          ' src="' + htmldir + iname + '"'+
          '></a>' + copy(tmp, ps2 + 2, length(tmp) - ps2 - 1);
      end;
      start := start + length('<a href="' + LNK_FILE + htmldir + iname + '">') + 1;
      cnt := cnt + 1;
      if cnt >= 50 then // макс. картинок в одном сообщениии, также блокировка от зацикливания
      begin
        tmp := msg;
        break;
      end;
    end;
    result := tmp;
  except
    on E: exception do
    begin
      result := msg;
      log('#ERROR Imgsize ' + E.message);
    end;
  end;
end;

// добавить строку в конец Html
Procedure AddHtml(fname, msg: string);
var
  buf: Tstringlist;
  i: integer;
  newmsg: string;
begin
  try
    // расширение
    if Pos('.html', ansilowercase(fname)) = 0 then
      fname := fname + '.html';
    if msg = '' then
      exit;
    if not fileexists(fname) then
      exit;
    //
    buf := Tstringlist.create;
    try
      buf.LoadFromFile(fname);
      for i := buf.count - 1 downto 0 do
      begin
        if Pos('</BODY>', ansiUpperCase(buf.Strings[i])) <> 0 then
        begin
          newmsg := DetectURL(msg);
          newmsg := ImgSize(newmsg);
          // уберем рамку картинок
          newmsg := stringreplace(newmsg, '<img ', '<img border="0" ', [rfReplaceall, rfIgnoreCase]);
          buf.insert(i, newmsg);
          break;
        end;
      end;
      buf.SaveToFile(fname);
    finally
      myFreeAndNil(buf);
    end;
  except
    on E: exception do
      log('#ERROR addhtml ' + E.message);
  end;
end; 

Function HtmlButton(text: string; transparent: boolean): string;
var
  color: Tcolor;
  id: string;
begin
  color := Setup.sysfont.color;
  id := inttostr(GetTickCount);
  if not transparent then
    result := '<span style="border: 1px solid silver; background-color: ' + htmlcolor(color) +
      '; color: white; font-weight: bold; text-decoration: none; font-size: 10px;">' + text + '</span>'
  else
    result := '<span style="border: 1px solid ' + htmlcolor(color) + '; color: ' + htmlcolor(color) +
      '; font-weight: bold; text-decoration: none; font-size: 10px;">' + text + '</span>';
end;

function onMouseOver(id:string):string;
begin
  result := '';
  //result := ' onmouseover="document.getElementById('+id+').style.background='''+htmlcolor(Darker(setup.WinColor,5))+''';" ';
end;

function onMouseOut(id:string):string;
begin
  result := '';
  //result := ' onmouseout="document.getElementById('+id+').style.background='''+htmlcolor(setup.WinColor)+''';" ';
end;

function DelBtnHTML2(FromName, msg, color:string; id:string):string;
var
  fn: string;
begin
  id := 's'+id;
  fn := Setup.sysfont.Name;
  if Setup.delbtn = 0 then // нет
    result := '<div '+onmouseover(id)+onmouseout(id)+' id="' + id + '" nick="' + trim(FromName) + '"><span style="font-size:'
      + inttostr(Setup.sysfont.size) + 'pt; font-family:' + fn + '; color:' + color + ';">'
      + msg + '</span></div>'
  else if Setup.delbtn = 1 then // цветная справа
    result := '<div '+onmouseover(id)+onmouseout(id)+' id="' + id + '" nick="' + trim(FromName) + '"><span style="font-size:'
      + inttostr(Setup.sysfont.size) + 'pt; font-family:' + fn + '; color:' + color + ';">' + msg
      + IIF(Setup.quotebtn, '&nbsp;&nbsp;<a href="icom6://' + id + '">' + HtmlButton('Q', false) + '</a>', '')
      + '&nbsp;&nbsp;<a href="javascript:void(0)" onclick="delmsg('#39+id+#39')">' + HtmlButton('X', false) + '</a>'
      + '</span></div>'
  else if Setup.delbtn = 2 then // прозрачная справа
    result := '<div '+onmouseover(id)+onmouseout(id)+' id='#34 + id + #34' nick="' + trim(FromName) + '"><span style="font-size:'
      + inttostr(Setup.sysfont.size) + 'pt; font-family:' + fn + '; color:' + color + ';">' + msg
      + IIF(Setup.quotebtn, '&nbsp;&nbsp;<a href="icom6://' + id + '">' + HtmlButton('Q', true) + '</a>', '')
      + '&nbsp;&nbsp;<a href="javascript:void(0)" onclick="delmsg('#39+id+#39')">' + HtmlButton('X', true) + '</a>'
      + '</span></div>'
  else if Setup.delbtn = 3 then // цветная слева
    result := '<div '+onmouseover(id)+onmouseout(id)+' id='#34 + id + #34' nick="' + trim(FromName) + '"><span style="font-size:'
      + inttostr(Setup.sysfont.size) + 'pt; font-family:' + fn + '; color:' + color + ';">'
      + '&nbsp;<a href="javascript:void(0)" onclick="delmsg('#39+id+#39')">' +  HtmlButton('X', false) + '</a>&nbsp;'
      + IIF(Setup.quotebtn, '&nbsp;<a href="icom6://' + id + '">' + HtmlButton('Q', false) + '</a>', '')
      + '&nbsp;' + msg + '</span></div>'
  else if Setup.delbtn = 4 then // прозрачная слева
    result := '<div '+onmouseover(id)+onmouseout(id)+' id='#34 + id + #34' nick="' + trim(FromName) + '"><span style="font-size:'
      + inttostr(Setup.sysfont.size) + 'pt; font-family:' + fn + '; color:' + color + ';">'
      + '&nbsp;<a href="javascript:void(0)" onclick="delmsg('#39+id+#39')">' + HtmlButton('X', true) + '</a>&nbsp;'
      + IIF(Setup.quotebtn, '&nbsp;<a href="icom6://' + id + '">' + HtmlButton('Q', true)+'</a>', '')
      + '&nbsp;' + msg + '</span></div>';
end;

function AddSysText2HTML2(FromName, ch_name: string; msg: string; color: string; id:string):string;
begin
  try
    msg := DelBtnHTML2(FromName, msg, color, id);
    msg := Plugins.ExecBeforeSys(FromName, ch_name, msg);
    result := msg;
  except
    on E: exception do
      log('#ERROR addsystext2html ' + E.message);
  end;
end;

function AddText2HTML2(FromName, ch_name: string; msg: string; id:string):string;
begin
  try
    id := 'm'+id;
    // вызов плагинов beforemessage
    msg := '<div id="'+id+'">' + Plugins.ExecBefore(FromName, ch_name, msg) + '</div>';
    result := msg;
  except
    on E: exception do
      log('#ERROR addtext2html ' + E.message);
  end;
end;

function NewHtml:string;
var
  sl: TstringList;
begin
  sl := TstringList.Create;
  sl.add('<!DOCTYPE html>');
  sl.add('<html style="border:none;">');
  sl.add('<head>');
  sl.add('<meta content="text/html; charset=Windows-1251" http-equiv="content-type">');
  sl.add('<title>ic</title>');
  sl.add('<style type="text/css">');
  sl.add(  'blockquote {');
  sl.add(  ' width: 80%; ');
  sl.add(  ' border-left:solid #ff5a00 5px; ');
  sl.add(  ' margin:1px 40px; ');
  sl.add(  ' padding:5px; ');
  sl.add(  ' color:#333; ');
  sl.add(  ' font-family: Georgia; ');
  sl.add(  ' font-style:italic; ');
  sl.add(  ' font-size:12px; ');
  sl.add(  ' background:#CCCCFF; ');
  sl.add(  '} ');
  sl.add(  'hr { ');
  sl.add(  ' color: #CCCCFF; ');
  sl.add(  ' height: 0px; ');
  sl.add(  ' noshade; ');
  sl.add(  ' border: none; ');
  sl.add(  ' border-top: dotted 1px gray; ');
  sl.add(  '} ');
  sl.add(  'A:link { color: blue; text-decoration: underline; } ');
  sl.add(  'A:hover { color: red; text-decoration: underline; } ');
  sl.add(  'A:visited { color: blue; text-decoration: underline; } ');
  sl.add(  'body { background: '+htmlcolor(Setup.WinColor)+'; } ');
  sl.add(  '</style> ');
  sl.Add('<script>');
  sl.Add('function delmsg(id) {');
  sl.Add('  var elem = document.getElementById(id);');
  sl.Add('  elem.parentNode.removeChild(elem);');
  sl.Add('  var id2 = ''m''+id.substring(1);');
  sl.Add('  var elem2 = document.getElementById(id2);');
  sl.Add('  elem2.parentNode.removeChild(elem2);');
  sl.Add('}');
  sl.Add('function togglemsg(id) {');
  sl.Add('  var id2 = id + ''_1'';');
  sl.Add('  var elem = document.getElementById(id2);');
  sl.Add('  elem.style.display = elem.style.display === ''none'' ? '''' : ''none'';  ');
  sl.Add('  var id2 = id + ''_2'';');
  sl.Add('  var elem2 = document.getElementById(id2);');
  sl.Add('  elem2.style.display = elem2.style.display === ''none'' ? '''' : ''none'';  ');
  sl.Add('}');
  sl.Add('</script>');
  sl.add('</head>');
  sl.add('<body>');
  sl.add('<font size="2" color="black">');
  sl.add('</body>');
  sl.add('</html>');
  result := sl.Text;
  sl.Free;
end;

end.
