program Atomodo;

{$R *.dres}

uses
  data in 'data.pas' {UtilModule: TDataModule},
  main in 'main.pas' {MainForm},
  about in 'about.pas' {AboutForm},
  uMyMutex in 'uMyMutex.pas',
  System.Classes,
  System.SysUtils,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

var
  LPidFileName: string;

begin
  LPidFileName := 'Atomodo';
  try

    with TMutex.Create(LPidFileName) do
    try
      begin
        Application.Initialize;
        Application.CreateForm(TUtilModule, UtilModule);
  UtilModule.Language.setSource('language_rc');
        Application.MainFormOnTaskbar := True;
        Application.CreateForm(TMainForm, MainForm);
        Application.CreateForm(TAboutForm, AboutForm);
        Application.Run;
      end
    finally
      Free;
    end;
  except
    on E: Exception do
    begin
      Application.Restore;
    end;
  end;
end.

