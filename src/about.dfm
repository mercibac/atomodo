object AboutForm: TAboutForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'About'
  ClientHeight = 231
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poDefault
  OnCreate = FormCreate
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 394
    Height = 231
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    ShowCaption = False
    TabOrder = 0
    OnClick = pnlMainClick
    ExplicitWidth = 386
    ExplicitHeight = 219
    object lblAboutSoftName: TLabel
      Left = 167
      Top = -1
      Width = 61
      Height = 16
      Caption = 'ATOMODO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblAboutSoftVersion: TLabel
      Left = 183
      Top = 12
      Width = 28
      Height = 16
      Caption = 'v 1.1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblAboutDevName: TLabel
      Left = 111
      Top = 175
      Width = 142
      Height = 16
      Caption = 'Developped by Merci Bac'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblAboutLicence: TLabel
      Left = 152
      Top = 195
      Width = 80
      Height = 16
      Caption = 'Licence GPLv3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblLearn: TLabel
      Left = 8
      Top = 135
      Width = 117
      Height = 18
      Caption = 'Learn more about'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblAnd: TLabel
      Left = 220
      Top = 136
      Width = 24
      Height = 18
      Alignment = taCenter
      Caption = 'and'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object lblAboutCore1: TLabel
      Left = 17
      Top = 49
      Width = 359
      Height = 18
      Caption = 'ATOMODO (Atomic habits and Pomodoro technique) is'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblAboutCore2: TLabel
      Left = 9
      Top = 72
      Width = 372
      Height = 18
      Caption = 'an utility that helps you to manage tasks by splitting their'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblAboutCore3: TLabel
      Left = 11
      Top = 95
      Width = 372
      Height = 18
      Caption = 'durations into small chunks in order to be more effective.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object imgLinkToSource: TSVGIconImage
      Left = 262
      Top = 172
      Width = 21
      Height = 21
      Cursor = crHandPoint
      AutoSize = False
      ImageList = UtilModule.SVGIconImageList1
      ImageIndex = 15
      ImageName = 'github'
      OnClick = imgLinkToSourceClick
    end
    object linkAtomodo: TLinkLabel
      Left = 128
      Top = 135
      Width = 91
      Height = 22
      Caption = 
        '<a href="https://jamesclear.com/atomic-habits-summary">Atomic ha' +
        'bits</a>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnLinkClick = linkAtomodoLinkClick
    end
    object linkPomodoro: TLinkLabel
      Left = 248
      Top = 135
      Width = 137
      Height = 22
      Caption = 
        '<a href="https://www.wikiwand.com/en/Pomodoro_Technique">Pomodor' +
        'o technique</a>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnLinkClick = linkPomodoroLinkClick
    end
  end
end
