object SmileForm: TSmileForm
  Left = 302
  Top = 139
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = #1057#1084#1072#1081#1083#1080#1082#1080
  ClientHeight = 544
  ClientWidth = 718
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 718
    Height = 544
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1055#1088#1086#1089#1090#1099#1077
    end
    object TabSheet2: TTabSheet
      Caption = #1040#1085#1080#1084#1080#1088#1086#1074#1072#1085#1085#1099#1077
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 671
      ExplicitHeight = 0
    end
    object TabSheet3: TTabSheet
      Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 671
      ExplicitHeight = 0
    end
  end
  object AddTrafMenu: TPopupMenu
    Left = 64
    Top = 48
    object AddPictMenu: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnClick = AddPictMenuClick
    end
    object DeletePictMenu: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = DeletePictMenuClick
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 
      'All (*.gif;*.cur;*.pcx;*.ani;*.png;*.jpg;*.jpeg;*.bmp;*.ico;*.em' +
      'f;*.wmf)|*.gif;*.png;*.jpg;*.jpeg|CompuServe GIF Image (*.gif)|*' +
      '.gif|Portable network graphics (AlphaControls) (*.png)|*.png|JPE' +
      'G Image File (*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg'
    Left = 136
    Top = 48
  end
end
