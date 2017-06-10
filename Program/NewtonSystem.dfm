object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'NEWTON SYSTEM'
  ClientHeight = 483
  ClientWidth = 1284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Visible = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 40
    Top = 32
    Width = 140
    Height = 16
    Caption = 'Liczba niewiadomych:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 40
    Top = 171
    Width = 58
    Height = 16
    Caption = 'Zmienne:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 40
    Top = 77
    Width = 94
    Height = 16
    Caption = 'Liczba iteracji:'
  end
  object Label4: TLabel
    Left = 40
    Top = 128
    Width = 110
    Height = 16
    Caption = 'Dok'#322'adno'#347#263' ( '#949' ):'
  end
  object Label5: TLabel
    Left = 40
    Top = 256
    Width = 83
    Height = 16
    Caption = 'Arytmetyka:'
  end
  object Label6: TLabel
    Left = 718
    Top = 29
    Width = 47
    Height = 16
    Caption = 'Wyniki:'
  end
  object Label7: TLabel
    Left = 678
    Top = 29
    Width = 56
    Height = 16
    Caption = 'delimiter'
  end
  object Button1: TButton
    Left = 40
    Top = 374
    Width = 313
    Height = 35
    Caption = #321'aduj'
    TabOrder = 6
    OnClick = Button1Click
    OnKeyPress = Button1KeyPress
  end
  object StringGrid2: TStringGrid
    Left = 200
    Top = 171
    Width = 433
    Height = 158
    ColCount = 2
    DefaultColWidth = 70
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 3
    OnGetEditMask = StringGrid2GetEditMask
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object Edit1: TEdit
    Left = 200
    Top = 29
    Width = 153
    Height = 24
    Hint = 'Liczba niewiadomych z zakresu od 1 do 20'
    MaxLength = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnChange = Edit1Change
    OnKeyPress = Edit1KeyPress
  end
  object Edit2: TEdit
    Left = 200
    Top = 74
    Width = 153
    Height = 24
    MaxLength = 4
    TabOrder = 1
    OnKeyPress = Edit2KeyPress
  end
  object Edit3: TEdit
    Left = 200
    Top = 125
    Width = 153
    Height = 24
    MaxLength = 10
    TabOrder = 2
    OnKeyPress = Edit3KeyPress
  end
  object RadioButton1: TRadioButton
    Left = 40
    Top = 297
    Width = 113
    Height = 17
    Caption = 'Zwyczajna'
    TabOrder = 4
  end
  object RadioButton2: TRadioButton
    Left = 40
    Top = 336
    Width = 113
    Height = 17
    Caption = 'Przedzia'#322'owa'
    TabOrder = 5
  end
  object Edit4: TEdit
    Left = 734
    Top = 74
    Width = 155
    Height = 24
    ReadOnly = True
    TabOrder = 7
  end
  object Edit5: TEdit
    Left = 734
    Top = 125
    Width = 155
    Height = 24
    ReadOnly = True
    TabOrder = 8
  end
  object StringGrid1: TStringGrid
    Left = 734
    Top = 171
    Width = 531
    Height = 158
    ColCount = 2
    DefaultColWidth = 70
    Options = [goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 9
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object Button2: TButton
    Left = 734
    Top = 374
    Width = 123
    Height = 35
    Caption = 'Wyczy'#347#263' wynik'
    TabOrder = 10
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 432
    Top = 374
    Width = 201
    Height = 35
    Caption = 'Wyczy'#347#263' wprowadzone dane'
    TabOrder = 11
    OnClick = Button3Click
  end
end
