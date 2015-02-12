unit winnet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, wininet, WinSock;

function GetLocalIPs(with_locals: boolean): String;
procedure GetLanIp(List:TStrings; IndexLan: Integer=-1);

implementation

uses Global;

const
  MAX_ADAPTER_NAME_LENGTH        = 256;
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
  MAX_ADAPTER_ADDRESS_LENGTH     = 8;
  MAXLEN_IFDESCR         = 256;

  MAX_HOSTNAME_LEN    = 128;
  MAX_DOMAIN_NAME_LEN = 128;
  MAX_SCOPE_ID_LEN    = 256;

 type

   IP_ADDRESS_STRING = record
    S: array [0..15] of Char;
  end;
  IP_MASK_STRING = IP_ADDRESS_STRING;
  PIP_MASK_STRING = ^IP_MASK_STRING;

   PIP_ADDR_STRING = ^IP_ADDR_STRING;
  IP_ADDR_STRING = record
    Next: PIP_ADDR_STRING;
    IpAddress: IP_ADDRESS_STRING;
    IpMask: IP_MASK_STRING;
    Context: DWORD;
  end;

  PIP_ADAPTER_INFO = ^IP_ADAPTER_INFO;
  IP_ADAPTER_INFO = record
    Next: PIP_ADAPTER_INFO;
    ComboIndex: DWORD;
    AdapterName: array [0..MAX_ADAPTER_NAME_LENGTH + 3] of Char;
    Description: array [0..MAX_ADAPTER_DESCRIPTION_LENGTH + 3] of Char;
    AddressLength: UINT;
    Address: array [0..MAX_ADAPTER_ADDRESS_LENGTH - 1] of BYTE;
    Index: DWORD;
    Type_: UINT;
    DhcpEnabled: UINT;
    CurrentIpAddress: PIP_ADDR_STRING;
    IpAddressList: IP_ADDR_STRING;
    GatewayList: IP_ADDR_STRING;
    DhcpServer: IP_ADDR_STRING;
    HaveWins: BOOL;
    PrimaryWinsServer: IP_ADDR_STRING;
    SecondaryWinsServer: IP_ADDR_STRING;
    LeaseObtained: Longint;
    LeaseExpires: Longint;
  end;

 // При помощи данной функции мы определим наличие сетевых интерфейсов
  // на локальном компьютере и информацию о них
  function GetAdaptersInfo(pAdapterInfo: PIP_ADAPTER_INFO;
    var pOutBufLen: ULONG): DWORD; stdcall; external 'iphlpapi.dll';
{$WARNINGS OFF}
procedure GetLanIp(List:TStrings; IndexLan: Integer=-1);
var
  InterfaceInfo,
  TmpPointer: PIP_ADAPTER_INFO;
  IP: PIP_ADDR_STRING;
  Len: ULONG;
begin
  // Смотрим сколько памяти нам требуется?
  if GetAdaptersInfo(nil, Len) = ERROR_BUFFER_OVERFLOW then
  begin
    // Берем нужное кол-во
    GetMem(InterfaceInfo, Len);
    FillChar(InterfaceInfo^, Len, 0);
    try
    InterfaceInfo.Index:=1;
    // выполнение функции
    if GetAdaptersInfo(InterfaceInfo, Len) = ERROR_SUCCESS then
      begin
        // Перечисляем все сетевые интерфейсы
       TmpPointer := InterfaceInfo;
        repeat
          // перечисляем все IP адреса каждого интерфейса
          IP := @TmpPointer^.IpAddressList;
          repeat
            if IndexLan = -1 then
             List.Add(Format('%s Index:%d',[IP^.IpAddress.S, IP^.Context]));
            if IndexLan = Integer(IP^.Context) then
            begin
             List.add(Format('ip=%s',[IP^.IpAddress.S])+' '+Format('mask=%s',[IP^.IpMask.S])+' '+Format('gateway=%s',[TmpPointer^.GatewayList.IpAddress.S]));
            end;
            IP := IP.Next;
          until IP = nil;
          TmpPointer := TmpPointer.Next;
        until TmpPointer = nil;
      end;
    finally
      FreeMem(InterfaceInfo);
    end;
  end;
end;

function GetLocalIPs(with_locals: boolean): String;
type
  TaPInAddr = Array [0 .. 10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: Array [0 .. 63] of Char;
  I: integer;
  GInitData: TWSAData;
  IPs: TstringList;
begin
  IPs := TstringList.Create;
  try
    WSAStartup($101, GInitData);
    GetHostName(addr(Buffer), SizeOf(Buffer));
    phe := GetHostByName(addr(Buffer));
    if phe = nil then
      IPs.Add('No IP found')
    else
    begin
      pptr := PaPInAddr(phe^.h_addr_list);
      I := 0;
      while pptr^[I] <> nil do
      begin
        IPs.Add(string(inet_ntoa(pptr^[I]^)));
        Inc(I);
      end;
    end;
    WSACleanup;
    if not with_locals then
    begin
      I := 0;
      while I <= IPs.count - 1 do
      begin
        if (Pos('10.',IPs.strings[I]) = 1)or(Pos('172.',IPs.strings[I]) = 1)or(Pos('192.',IPs.strings[I]) = 1)  then
          I := I + 1
        else
          IPs.delete(I)
      end;
    end;
    result := IPs.Text;
  finally
    myFreeandnil(IPs);
  end;
end;

end.
