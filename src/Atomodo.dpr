program Atomodo;

{$R *.dres}

uses
  data in 'data.pas' {UtilModule: TDataModule},
  main in 'main.pas' {MainForm},
  about in 'about.pas' {AboutForm},
  uMyMutex in 'uMyMutex.pas',
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}
begin
  Application.Initialize;
  Application.CreateForm(TUtilModule, UtilModule);
  UtilModule.Language.setSource('language_rc');
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.

