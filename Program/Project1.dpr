program Project1;

uses
  Vcl.Forms,
  NewtonSystem in 'NewtonSystem.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  NSInterval in 'NSInterval.pas',
  IntervalArithmetic32and64 in 'IntervalArithmetic32and64.pas',
  NSNormal in 'NSNormal.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Ruby Graphite');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
