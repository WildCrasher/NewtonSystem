unit NewtonSystem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Data.DB,
  Bde.DBTables, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.DBCtrls, IntervalArithmetic32and64,
  NSInterval, NSNormal, system.StrUtils;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    StringGrid2: TStringGrid;
    Label3: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label5: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    StringGrid1: TStringGrid;
    Label6: TLabel;
    Label7: TLabel;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Button1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure StringGrid2GetEditMask(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure Button3Click(Sender: TObject);

  private
    { Private declarations }
  public
    procedure initialize_components( n: integer);
    procedure clear_inserted_data_components();
    procedure clear_result_data_components();
    procedure get_x_from_stringgrid( radiobuttonx : integer);
    procedure show_result(radiobuttonx : integer);
    function conditions : Boolean;
    function is_extended(s: String): Boolean;
    function is_stringgrid_good : Boolean;
    function is_data_interval : Boolean;

    { Public declarations }
  end;

var
  Form1: TForm1;
  i, it, mit, n, st : Integer;
  eps               : Extended;
  x                 : vector;
  // wersja interval
  x2                : vector4;

  const
     enter = AnsiChar(#13);
implementation

//uses IntervalArithmetic32and64, NSInterval;

{$R *.dfm}


function TForm1.is_extended(s: String): Boolean;
begin
  if StrToFloatDef(s,0)=StrToFloatDef(s,1)
    then Result:=True
  else Result:=False;
end;

function TForm1.is_data_interval : Boolean;
var
  ind: Integer;
  control : integer;
  temp: string;

begin
  control := 0;
  for ind := 1 to StringGrid2.RowCount do
  begin
    temp := Copy( StringGrid2.Cells[1,ind], 23, 20);
    if is_extended( LeftStr( temp, 20 ) ) then
    begin
      control := 1;
      break;
    end;

    if control = 1 then
      Result := True
    else
      Result := False;
  end;
end;

function TForm1.is_stringgrid_good : Boolean;
var
  control : integer;
  ind : integer;
begin
  control := 0;
  for ind := 1 to StrToInt(Edit1.Text) do
  begin
    if ( Stringgrid2.Cells[1,ind] <> '' ) and
       ( is_extended( LeftStr( Copy( StringGrid2.Cells[1,ind], 2, 42), 20) ) ) then
    begin
      inc(control);
    end;
  end;

  if control = StrToInt(Edit1.Text) then
  begin
    Result := True;
  end
  else Result := False;

end;

function TForm1.conditions : Boolean;
begin
    if ( Edit1.GetTextLen > 0) and ( Edit2.GetTextLen > 0) and ( Edit3.GetTextLen > 0) and
       ( StrToInt(Edit1.Text) >= 1 ) and
       ( StrToInt(Edit2.Text) >= 1 ) and ( StrToInt(Edit2.Text) <= 1000 ) and
       ( is_extended( edit3.Text ) ) and
       ( is_stringgrid_good ) then
    begin
       Result := true;
    end
    else
       Result := false;
end;

procedure TForm1.initialize_components( n: integer );
var ind : integer;
begin
    StringGrid2.Cells[0,0] := 'Numer';
    StringGrid2.Cells[1,0] := 'Wartoœci';
    StringGrid1.Cells[0,0] := 'Numer';
    StringGrid1.Cells[1,0] := 'Wartoœci';
    StringGrid1.ColWidths[1] := 450;
    StringGrid2.ColWidths[1] := 450;
    for ind := 1 to n do
    begin
      StringGrid2.Cells[0,ind] := Concat('X', IntToStr(ind - 1));
      StringGrid1.Cells[0,ind] := Concat('X', IntToStr(ind - 1));
      //StringGrid2.Cells[1,ind] := '[CCCCCCCCCCCCCCCCCCCC;CCCCCCCCCCCCCCCCCCCC];1;_';
    end;

    Label7.Caption := '';
    for ind := 1 to 23 do
    begin
      Label7.Caption := Label7.Caption + '|'+enter;
    end;
end;

procedure TForm1.clear_result_data_components();
var
  ind : integer;
begin
  Edit4.Text := '';
  Edit5.Text := '';

  for ind := 1 to StringGrid1.RowCount do
  begin
    StringGrid1.Cells[1,ind] := '';
  end;
end;

procedure TForm1.clear_inserted_data_components();
var
  ind : integer;
begin
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';

  for ind := 1 to StringGrid2.RowCount do
  begin
    StringGrid2.Cells[1,ind] := '';
  end;

  RadioButton1.Checked := False;
  RadioButton1.Checked := False;
end;

procedure TForm1.show_result( radiobuttonx : integer);
var
  ind : integer;
  left : string;
  right : string;
begin
  if radiobuttonx = 1 then
  begin
    Edit4.Text := IntToStr(it);
    Edit5.Text := IntToStr(st);
    for ind := 1 to StrToInt(Edit1.Text) do
     begin
       Stringgrid1.Cells[1,ind] := FloatToStr(x[ind]);
     end;
    SetLength(x,0);
  end
  else if radiobuttonx = 2 then
  begin
    Edit4.Text := IntToStr(it);
    Edit5.Text := IntToStr(st);
    for ind := 1 to StrToInt(Edit1.Text) do
     begin
       iends_to_strings(x2[ind],left,right);
       Stringgrid1.Cells[1,ind] := '[' + left + ' ; ' + right + ']';
     end;
    SetLength(x2,0);
  end;

  if st = 2 then
    showmessage('Podczas obliczeñ wyst¹pi³¹ macierz osobliwa')
  else if st = 3 then
      showmessage('¯eby uzyskaæ t¹ dok³adnoœæ, potrzebna jest wiêksza liczba iteracji.');
end;

procedure TForm1.StringGrid2GetEditMask(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
begin
  with Sender as tStringGrid do
      if ACol = ColCount - 1 then
         Value := '[CCCCCCCCCCCCCCCCCCCC;CCCCCCCCCCCCCCCCCCCC];1;_';
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  button : integer;
begin
  button := messagedlg('Czy na pewno chcesz wyjœæ?',mtInformation,[mbYes,mbNo],0);
  if button=mrYes then application.Terminate;
  abort;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Initialize_components(4);
end;

procedure TForm1.get_x_from_stringgrid( radiobuttonx : integer);
var
  ind : integer;
  tempa, tempb : string;
begin
  if radiobuttonx = 1 then
  begin
    SetLength( x, StrToInt(Edit1.Text) + 1 );
    for ind := 1 to StrToInt(edit1.Text) do
    begin
      x[ind] := StrToFloat( LeftStr( Copy( StringGrid2.Cells[1,ind], 2, 42), 20) );
    end;
  end
  else if radiobuttonx = 2 then
  begin
    SetLength( x2, StrToInt(Edit1.Text) + 1 );
    for ind := 1 to StrToInt(edit1.Text) do
    begin
      tempa := LeftStr( Copy( StringGrid2.Cells[1,ind], 2, 42), 20);
      tempb := LeftStr( Copy( StringGrid2.Cells[1,ind], 23, 20), 20);
      if is_extended( tempa ) and is_extended( tempb ) then
      begin
        x2[ind].a := StrToFloat( tempa );
        x2[ind].b := StrToFloat( tempb )
      end
      else if ( is_extended( tempa ) ) and ( not is_extended( tempb ) ) then
      begin
        x2[ind].a := left_read( tempa );
        x2[ind].b := right_read( tempa );
      end;
    end;
  end;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  if (Edit1.Text <> '') and (StrToInt( Edit1.Text ) >= 1) then
  begin
    StringGrid2.RowCount := StrToInt(Edit1.Text) + 1;
    StringGrid1.RowCount := StrToInt(Edit1.Text) + 1;
    initialize_components(StrToInt(Edit1.Text));
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  button : integer;
begin
  button := messagedlg('Czy na pewno chcesz wyczyœciæ dane?',mtInformation,[mbYes,mbNo],0);
  if button=mrYes then
  begin
    clear_result_data_components();
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  button : integer;
begin
  button := messagedlg('Czy na pewno chcesz wyczyœciæ dane?',mtInformation,[mbYes,mbNo],0);
  if button=mrYes then
  begin
    clear_inserted_data_components();
  end;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  button : integer;
begin
  try
    if Key = #13 then
    begin
      if (conditions) and (not is_data_interval()) and (RadioButton1.Checked) then
      begin
        get_x_from_stringgrid(1);
        NewtonSys( StrToInt(Edit1.Text), x, f, df, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
        show_result(1);
      end
      else if (conditions) and (is_data_interval()) and (Radiobutton2.Checked) then
      begin
        get_x_from_stringgrid(2);
        NewtonSysInterval( StrToInt(Edit1.Text), x2, fi, dfi, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
        show_result(2);
      end
      else if (conditions) and (not is_data_interval()) and Radiobutton2.Checked then
      begin
        get_x_from_stringgrid(2);
        NewtonSysInterval( StrToInt(Edit1.Text), x2, fi, dfi, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
        show_result(2);
      end
      else if is_data_interval() and RadioButton1.Checked then
      begin
        button := messagedlg('Twoje dane s¹ w postaci przedzia³ów, wiêc zaznacz opcjê "arytmetyka przedzia³owa"'
        ,mtError,[mbYes],0);
      end;

    end
    else if not(ord(Key) in [48..57]) and not(ord(Key) = 8) then
    begin
      Key:=#0;
    end;
  except
    button := messagedlg('Iloœæ równanñ, która wpisa³eœ, nie zgadza siê z defenicj¹ równañ z Twojego modu³u'
    ,mtError,[mbYes],0);
  end;
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
var
  button : integer;
begin
  try
    if Key = #13 then
    begin

      if (conditions) and (not is_data_interval()) and (RadioButton1.Checked) then
      begin
        get_x_from_stringgrid(1);
        NewtonSys( StrToInt(Edit1.Text), x, f, df, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
        show_result(1);
      end
      else if (conditions) and (is_data_interval()) and (Radiobutton2.Checked) then
      begin
        get_x_from_stringgrid(2);
        NewtonSysInterval( StrToInt(Edit1.Text), x2, fi, dfi, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
        show_result(2);
      end
      else if (conditions) and (not is_data_interval()) and Radiobutton2.Checked then
      begin
        get_x_from_stringgrid(2);
        NewtonSysInterval( StrToInt(Edit1.Text), x2, fi, dfi, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
        show_result(2);
      end
      else if is_data_interval() and RadioButton1.Checked then
      begin
        button := messagedlg('Twoje dane s¹ w postaci przedzia³ów, wiêc zaznacz opcjê "arytmetyka przedzia³owa"'
        ,mtError,[mbYes],0);
      end;

    end
    else if not(ord(Key) in [48..57]) and not(ord(Key) = 8) then
    begin
      Key:=#0;
    end;
  except
    button := messagedlg('Iloœæ równanñ, która wpisa³eœ, nie zgadza siê z defenicj¹ równañ z Twojego modu³u'
    ,mtError,[mbYes],0);
  end;
end;

procedure TForm1.Edit3KeyPress(Sender: TObject; var Key: Char);
var
  button : integer;
begin
  try
    if Key = #13 then
    begin

        if (conditions) and (not is_data_interval()) and (RadioButton1.Checked) then
        begin
          get_x_from_stringgrid(1);
          NewtonSys( StrToInt(Edit1.Text), x, f, df, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
          show_result(1);
        end
        else if (conditions) and (is_data_interval()) and (Radiobutton2.Checked) then
        begin
          get_x_from_stringgrid(2);
          NewtonSysInterval( StrToInt(Edit1.Text), x2, fi, dfi, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
          show_result(2);
        end
        else if (conditions) and (not is_data_interval()) and Radiobutton2.Checked then
        begin
          get_x_from_stringgrid(2);
          NewtonSysInterval( StrToInt(Edit1.Text), x2, fi, dfi, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
          show_result(2);
        end
        else if is_data_interval() and RadioButton1.Checked then
        begin
          button := messagedlg('Twoje dane s¹ w postaci przedzia³ów, wiêc zaznacz opcjê "arytmetyka przedzia³owa"'
          ,mtError,[mbYes],0);
        end;

    end
    else if not(ord(Key) in [48..57]) and not(ord(Key) = 8) and not(ord(Key) = 101) and not(ord(Key) = 45) then
    begin
      Key:=#0;
    end;
  except
    button := messagedlg('Iloœæ równanñ, która wpisa³eœ, nie zgadza siê z defenicj¹ równañ z Twojego modu³u'
    ,mtError,[mbYes],0);
  end;
end;

procedure TForm1.Button1KeyPress(Sender: TObject; var Key: Char);
var
  button : integer;
begin
  try
    if Key = #13 then
    begin
      showmessage('if');
      if (conditions) and (not is_data_interval()) and (RadioButton1.Checked) then
      begin
        showmessage('getin');
        get_x_from_stringgrid(1);
        showmessage('getout');
        NewtonSys( StrToInt(Edit1.Text), x, f, df, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
       showmessage('newtonout'); show_result(1);showmessage('showout');
      end
      else if (conditions) and (is_data_interval()) and (Radiobutton2.Checked) then
      begin
        get_x_from_stringgrid(2);
        NewtonSysInterval( StrToInt(Edit1.Text), x2, fi, dfi, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
        show_result(2);
      end
      else if (conditions) and (not is_data_interval()) and Radiobutton2.Checked then
      begin
        get_x_from_stringgrid(2);
        NewtonSysInterval( StrToInt(Edit1.Text), x2, fi, dfi, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
        show_result(2);
      end
      else if is_data_interval() and RadioButton1.Checked then
      begin
        button := messagedlg('Twoje dane s¹ w postaci przedzia³ów, wiêc zaznacz opcjê "arytmetyka przedzia³owa"'
        ,mtError,[mbYes],0);
      end;

    end;
  except
    button := messagedlg('Iloœæ równanñ, która wpisa³eœ, nie zgadza siê z defenicj¹ równañ z Twojego modu³u'
    ,mtError,[mbYes],0);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  button : integer;
begin
  try
    if (conditions) and (not is_data_interval()) and (RadioButton1.Checked) then
      begin
        showmessage('getin');
        get_x_from_stringgrid(1);
        showmessage('getout');
        NewtonSys( StrToInt(Edit1.Text), x, f, df, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
       showmessage('newtonout'); show_result(1);showmessage('showout');
      end
      else if (conditions) and (is_data_interval()) and (Radiobutton2.Checked) then
      begin
        get_x_from_stringgrid(2);
        NewtonSysInterval( StrToInt(Edit1.Text), x2, fi, dfi, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
        show_result(2);
      end
      else if (conditions) and (not is_data_interval()) and Radiobutton2.Checked then
      begin
        get_x_from_stringgrid(2);
        NewtonSysInterval( StrToInt(Edit1.Text), x2, fi, dfi, StrToInt(Edit2.Text), StrToFloat(Edit3.Text), it, st );
        show_result(2);
      end
      else if is_data_interval() and RadioButton1.Checked then
      begin
        button := messagedlg('Twoje dane s¹ w postaci przedzia³ów, wiêc zaznacz opcjê "arytmetyka przedzia³owa"'
        ,mtError,[mbYes],0);
      end;
  except
    button := messagedlg('Iloœæ równanñ, która wpisa³eœ, nie zgadza siê z defenicj¹ równañ z Twojego modu³u'
    ,mtError,[mbYes],0);
  end;
end;

end.
