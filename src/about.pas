unit about;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, data, shellapi,
  SVGIconImage, Vcl.Buttons;

type
  TAboutForm = class(TForm)
    pnlMain: TPanel;
    lblAboutSoftName: TLabel;
    lblAboutSoftVersion: TLabel;
    lblAboutDevName: TLabel;
    lblAboutLicence: TLabel;
    lblLearn: TLabel;
    linkAtomodo: TLinkLabel;
    lblAnd: TLabel;
    linkPomodoro: TLinkLabel;
    lblAboutCore1: TLabel;
    lblAboutCore2: TLabel;
    lblAboutCore3: TLabel;
    imgLinkToSource: TSVGIconImage;
    procedure pnlMainClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure linkAtomodoLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure linkPomodoroLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure imgLinkToSourceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  Position := poScreenCenter; // Center the child form
  lblAboutCore1.Caption := UtilModule.Language.localize('ATOMODO (Atomic habits and Pomodoro technique) is');
  lblAboutCore2.Caption := UtilModule.Language.localize('an utility that helps you to manage tasks by splitting their');
  lblAboutCore3.Caption := UtilModule.Language.localize('durations into small chunks in order to be more effective');
  lblLearn.Caption := UtilModule.Language.localize('Learn more about');
  lblAnd.Caption := UtilModule.Language.localize('and');
  lblAboutDevName.Caption := UtilModule.Language.localize('Developped by Merci Bac');
end;

procedure TAboutForm.imgLinkToSourceClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://www.github.com/mercibac/atomodo', nil, nil, SW_SHOWNORMAL);
  Application.Minimize;
end;

procedure TAboutForm.linkAtomodoLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(0, nil, PChar(Link), nil, nil, 1);
  Application.Minimize;
end;

procedure TAboutForm.linkPomodoroLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(0, nil, PChar(Link), nil, nil, 1);
  Application.Minimize;
end;

procedure TAboutForm.pnlMainClick(Sender: TObject);
begin
  AboutForm.close;
end;

end.
