unit WbPopup;

interface

// Для преобразования кликов правой кнопкой в клики левой, раскомментировать
// {$DEFINE __R_TO_L}

var
  image_href: string;
  href: string;
  nick: string;

implementation

uses Windows,Controls,Messages,ShDocVw,activex,
  MSHTML_TLB, commonlib, Global, icomView, MAIN;

var
  HMouseHook:THandle;

function GetElementAtPos(Doc: IHTMLDocument2; x, y: integer): IHTMLElement;
begin
  Result := nil;
  Result := Doc.elementFromPoint(x, y);
end;

function GetNick(WC: TWebBrowser; P: TPoint): string;
var
  Doc: IHTMLDocument2;
  Element: IHTMLElement;
  x, y: Integer;
begin
  result := '';
  x := P.X;
  y := P.Y;
  Doc := WC.Document as IHTMLDocument2;
  Element := GetElementAtPos(doc, x, y);
  if Assigned(Element) then
  begin
    if Element.innerHTML = Delsym(Element.innerHTML) then
      result := Element.innerHTML;
  end;
end;

function GetElement(WC: TWebBrowser; P: TPoint): string;
var
  Doc: IHTMLDocument2;
  Element: IHTMLElement;
  imgElement: IHTMLIMGElement;
  scrElement: IHTMLLinkElement;
  Elementhref: string;
  x, y: Integer;
begin
  result := '';
  x := P.X;
  y := P.Y;
  // Get the element under the mouse cursor
  Doc := WC.Document as IHTMLDocument2;
  Element := GetElementAtPos(doc, x, y);
  if Assigned(Element) then
  begin
    Element.QueryInterface(IHTMLIMGElement, imgElement);
    if assigned(imgElement) then
    begin
      Elementhref := imgElement.href;
      result := urldecode(Elementhref);
    end;
    Element.QueryInterface(IHTMLLinkElement, scrElement);
    if assigned(scrElement) then
    begin
      Elementhref := scrElement.href;
      result := urldecode(Elementhref);
    end;
    if Element.tagname = 'A' then
      href := urldecode(Element.innerHTML);
  end;
end;

function MouseProc(
    nCode: Integer;     // hook code
    WP: wParam; // message identifier
    LP: lParam  // mouse coordinates
   ):Integer;stdcall;
var MHS:TMOUSEHOOKSTRUCT;
    WC:TWinControl;
    P:TPoint;
begin
  Result:=CallNextHookEx(HMouseHook,nCode,WP,LP);
  if nCode=HC_ACTION then
   begin
     {$WARNINGS OFF}
     MHS:=PMOUSEHOOKSTRUCT(LP)^;
     {$WARNINGS ON}
     if ((WP=WM_RBUTTONDOWN) or (WP=WM_RBUTTONUP)) then
      begin
        WC:=FindVCLWindow(MHS.pt);
        if (WC is TWebBrowser) then
        begin
          // на чем кликнули?
          P:=WC.ScreenToClient(MHS.pt);
          image_href := GetElement(TWebBrowser(WC), P);
          //
          Result:=1;
{$ifdef __R_TO_L}
          P:=WC.ScreenToClient(MHS.pt);
          GetElement(P);
          if WP=WM_RBUTTONDOWN
          then PostMessage(MHS.hwnd,WM_LBUTTONDOWN,0,P.x + P.y shl 16);
          if WP=WM_RBUTTONUP
          then PostMessage(MHS.hwnd,WM_LBUTTONUP,0,P.x + P.y shl 16);
{$endif}  // на списке польз по правой кнопке сразу выделим, потом попап меню
          if (Ticomviewer(wc).objname=USER_DISPLAY)and(WP=WM_RBUTTONDOWN) then
          begin
            P:=WC.ScreenToClient(MHS.pt);
            nick:=GetNick(TWebBrowser(WC),P);
            user_box.Select(nick);
          end;

          if (TWebBrowser(WC).PopupMenu<>nil) and (WP=WM_RBUTTONUP) then
           begin
            TWebBrowser(WC).PopupMenu.PopupComponent:=WC;
            TWebBrowser(WC).PopupMenu.Popup(MHS.pt.x,MHS.pt.y);
           end;
        end;
      end;
   end;
end;

initialization


  HMouseHook:=SetWindowsHookEx(WH_MOUSE,@MouseProc,HInstance,GetCurrentThreadID);
  OleInitialize(nil);


finalization

  OleUninitialize;
  if HMouseHook <> 0 then  UnHookWindowsHookEx(HMouseHook);

end.