unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Types, Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, ShellAPI,
  System.ImageList, System.RegularExpressions, System.DateUtils, System.Diagnostics, SVGIconImageListBase, SVGIconImageList,
  Vcl.ExtCtrls, PngSpeedButton, SVGIconImage, Vcl.ComCtrls, Vcl.TitleBarCtrls, about,
  Vcl.ImgList, Vcl.Menus, Vcl.Themes, Vcl.Styles, Registry, uLanguages, MMSystem, data, inifiles;

const
WM_ICONTRAY = WM_USER + 100;


type
  // Get rid of dots on combobox selection
  TComboBox = class(Vcl.StdCtrls.TComboBox)   // Temporary subclass to get at the CNDraw message.
  private
    procedure CNDrawItem(var Message : TWMDrawItem); message CN_DRAWITEM;

  end;

  TMainForm = class(TForm)
    btnStart: TSpeedButton;
    lblDuration: TLabel;
    lblBreak: TLabel;
    lblTitle: TLabel;
    btnStop: TSpeedButton;
    btnPause: TSpeedButton;
    btnSettings: TSpeedButton;
    btnAbout: TSpeedButton;
    pnlMain: TPanel;
    cbbDuration: TComboBox;
    pnlTime: TPanel;
    lblTime: TLabel;
    cbbBreak: TComboBox;
    lblinfo: TLabel;
    pgContainer: TPageControl;
    tbMain: TTabSheet;
    tbSettings: TTabSheet;
    TimerMain: TTimer;
    btnMinimize: TSpeedButton;
    lblSettings: TLabel;
    lblTheme: TLabel;
    lblSound: TLabel;
    lblLanguage: TLabel;
    cbbTheme: TComboBox;
    cbbSound: TComboBox;
    cbbLanguage: TComboBox;
    btnBack: TSpeedButton;
    btnConfirm: TSpeedButton;
    btnMinimize2: TSpeedButton;
    btnRepeat: TSpeedButton;
    TimerBreak: TTimer;
    PopupMenu: TPopupMenu;
    Show1: TMenuItem;
    Quit1: TMenuItem;
    TrayIcon: TTrayIcon;
    procedure btnAboutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WMMouseMove(var Msg : TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMNCMouseLeave(var Msg : TMessage); message WM_NCMOUSELEAVE;
    procedure WMNCButtonDown(var Msg : TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
    procedure WMNCButtonUp(var Msg : TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure WMSYSCommand(var Msg : TWMSysCommand); message WM_SYSCOMMAND;
    procedure pnlMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TimerSession(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure cbbDurationSelect(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure btnMinimizeClick(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure Show1Click(Sender: TObject);
    procedure tbSettingsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure btnRepeatClick(Sender: TObject);
    procedure cbbThemeChange(Sender: TObject);
    procedure cbbLanguageChange(Sender: TObject);
    procedure TimerBreakTimer(Sender: TObject);
    procedure cbbDurationCloseUp(Sender: TObject);
    procedure cbbBreakCloseUp(Sender: TObject);
    procedure cbbThemeCloseUp(Sender: TObject);
    procedure cbbSoundCloseUp(Sender: TObject);
    procedure cbbLanguageCloseUp(Sender: TObject);
    procedure cbbSoundChange(Sender: TObject);


  private
    { Private declarations }
    FRgnHandle       : HRGN;
    FRgnTop          : Integer;
    FRgnBottom       : Integer;
    FRgnRight        : Integer;
    FRgnLeft         : Integer;
    FRgnCorner       : Integer;
    FMouseLeaveCount : Integer;
    FNCLButtonDown   : Boolean;
    FMousePoint: TPoint;
    FFormPoint: TPoint;
    procedure DeleteRegion;
    procedure CreateRegion;
    procedure SetMouseEvents;
    procedure UpdateLabel;
    procedure ApplySettings;
    procedure UpdateImages(Container: TWinControl);
    function isWindowsThemeDark: String;
    procedure Notify;

  public
    { Public declarations }
    procedure localize;

  end;

var
  MainForm: TMainForm;
  StartTime, StopTime, ElapsedTime, MyTime, CountDown: TDateTime;
  TimerActive: Boolean;
  TimerBreakActive: Boolean;
  Minutes, Seconds, Match , FormatedTime, cbbString: string;
  stopwatch: TStopWatch;
  ChildForm: TForm;
  rounds: Integer;
  remainingTime: TDateTime;
  sourceOfTime: Bool;
  SoundName: String;
  IniFile: TIniFile;
  IniFilePath: String;
  defaultSystemTheme: string;
  Theme: String;
  IniLanguage: String;

implementation

{$R *.dfm}

{ ------------- UI PROCEDURES ------------- }

procedure TMainForm.FormCreate(Sender: TObject);
begin

  // Load configurations

  if isWindowsThemeDark = 'True' then  defaultSystemTheme := 'Onyx Blue' else defaultSystemTheme := 'Windows';

   IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini' ));

   try
   begin
     Theme := IniFile.ReadString('Settings', 'Theme', 'Light');
     IniLanguage := IniFile.ReadString('Settings', 'Language', 'English');
     if  Theme = 'Light' then
     begin
      TStyleManager.SetStyle('Windows');
      cbbTheme.ItemIndex := 1;
     end
     else if Theme = 'Dark' then
     begin
      TStyleManager.SetStyle('Onyx Blue');
      cbbTheme.ItemIndex := 2;
      end
     else
     begin
      TStyleManager.SetStyle(defaultSystemTheme);
      cbbTheme.Text := 'System';
      end;
     end;
     SoundName := IniFile.ReadString('Settings', 'Sound', 'Classic');
     if SoundName = 'Classic' then
      cbbSound.ItemIndex := 0
     else if SoundName = 'Atmo' then
      cbbSound.ItemIndex := 1;

     UtilModule.Language.setLanguage(IniLanguage);

     if iniLanguage = 'English' then
      cbbLanguage.ItemIndex := 0;
     if iniLanguage = 'Français' then
      cbbLanguage.ItemIndex := 1;
   finally
     IniFile.Free;
   end;

   if (TStyleManager.ActiveStyle.Name = 'Windows') then
    lblTime.Font.Color := clBlack
   else
    lblTime.Font.Color := clWhite;

  UpdateImages(MainForm);

  tbMain.Show;
  lblInfo.Caption:= '';
  SetMouseEvents;
  FRgnTop    := GetSystemMetrics(SM_CYCAPTION) +
                GetSystemMetrics(SM_CYFRAME) +
                GetSystemMetrics(SM_CYFRAME);
  FRgnBottom := GetSystemMetrics(SM_CYFRAME) +
                GetSystemMetrics(SM_CYFRAME);
  FRgnRight  := GetSystemMetrics(SM_CXFRAME) +
                GetSystemMetrics(SM_CXFRAME);
  FRgnLeft   := GetSystemMetrics(SM_CXFRAME) +
                GetSystemMetrics(SM_CXFRAME);
  FRgnCorner := 15;
  CreateRegion;

  cbbString := cbbDuration.Text;
  Match := TRegEx.Match(cbbString, '\d+').Value	;
  MyTime := StrToTime('00:' + Match + ':00');
  FormatedTime := FormatDateTime('nn:ss', MyTime);
  lblTime.Caption := FormatedTime;
  TimerBreakActive := False;

  lblDuration.Caption := UtilModule.Language.localize('Duration');
  lblBreak.Caption := UtilModule.Language.localize('Break');
  lblSettings.Caption := UtilModule.Language.localize('Settings');
  lblTheme.Caption := UtilModule.Language.localize('Theme');
  lblSound.Caption := UtilModule.Language.localize('Sound');
  lblLanguage.Caption := UtilModule.Language.localize('Language');

  Rounds := 0;
end;

procedure TMainForm.ApplySettings;
 begin
   IniFile := TIniFile.Create( ChangeFileExt( Application.ExeName, '.ini' ) );
   try
     IniFile.WriteString( 'Settings', 'Theme', cbbTheme.Text);
     IniFile.WriteString( 'Settings', 'Sound', cbbSound.Text);
     IniFile.WriteString( 'Settings', 'Language', cbbLanguage.Text);
   finally
     IniFile.Free;
   end;
end;

procedure TMainForm.localize;
var
  I, CbbIndex: Integer;
begin
  cbbIndex := cbbTheme.ItemIndex;
  case (cbbLanguage.ItemIndex) of
    0: UtilModule.Language.setLanguage('English');
    1: UtilModule.Language.setLanguage('Français');
  end;
  lblDuration.Caption := UtilModule.Language.localize('Duration');
  lblBreak.Caption := UtilModule.Language.localize('Break');
  lblSettings.Caption := UtilModule.Language.localize('Settings');
  lblTheme.Caption := UtilModule.Language.localize('Theme');
  lblSound.Caption := UtilModule.Language.localize('Sound');
  lblLanguage.Caption := UtilModule.Language.localize('Language');

  cbbTheme.Items[0] := UtilModule.Language.localize('System');
  cbbTheme.Items[1] := UtilModule.Language.localize('Light');
  cbbTheme.Items[2] := UtilModule.Language.localize('Dark');
  MainForm.Refresh;
  cbbTheme.itemIndex := cbbIndex;

  AboutForm.lblAboutCore1.Caption := UtilModule.Language.localize('ATOMODO (Atomic habits and Pomodoro technique) is');
  AboutForm.lblAboutCore2.Caption := UtilModule.Language.localize('an utility that helps you to manage tasks by splitting their');
  AboutForm.lblAboutCore3.Caption := UtilModule.Language.localize('durations into small chunks in order to be more effective');
  AboutForm.lblLearn.Caption := UtilModule.Language.localize('Learn more about');
  AboutForm.lblAnd.Caption := UtilModule.Language.localize('and');
  AboutForm.lblAboutDevName.Caption := UtilModule.Language.localize('Developped by Merci Bac');


end;

procedure TMainForm.UpdateImages(Container: TWinControl);
var
  I: Integer;
begin
  for I := 0 to Container.ComponentCount - 1 do
  begin

    if Container.Components[i] is TSpeedButton then
    begin
      if (TStyleManager.ActiveStyle.Name = 'Windows') and
        ((Container.Components[i]).Name <> 'btnMinimize' ) and
        ((Container.Components[i]).Name <> 'btnMinimize2') then
        (Container.Components[i] as TSpeedButton).Images:= UtilModule.SVGIconImageList1
      else if (TStyleManager.ActiveStyle.Name = 'Windows') and
          (((Container.Components[i]).Name <> 'btnMinimize')
          or ( (Container.Components[i]).Name <> 'btnMinimize2')) then
        (Container.Components[i] as TSpeedButton).Images:= UtilModule.SVGIconImageList2;

      if (TStyleManager.ActiveStyle.Name = 'Onyx Blue') and
      ((Container.Components[i]).Name <> 'btnMinimize' ) and
      ((Container.Components[i]).Name <> 'btnMinimize2') then
        (Container.Components[i] as TSpeedButton).Images:= UtilModule.SVGIconImageList3
      else if (TStyleManager.ActiveStyle.Name = 'Onyx Blue') and
            ((( Container.Components[i]).Name <> 'btnMinimize' )
            or ( (Container.Components[i]).Name <> 'btnMinimize2' )) then
        (Container.Components[i] as TSpeedButton).Images:= UtilModule.SVGIconImageList4;
    end;
  end;
end;


procedure TComboBox.CNDrawItem(var Message : TWMDrawItem);
begin
  with Message do
    DrawItemStruct.itemState := DrawItemStruct.itemState and not ODS_FOCUS;
  inherited;

end; {CNDrawItem}

procedure TMainForm.pnlMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GetKeyState(VK_LBUTTON) < 0) then
  begin
    FMousePoint := Mouse.CursorPos;
    FFormPoint  := System.Classes.Point(Left, Top);
  end;
end;

procedure TMainForm.pnlMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (GetKeyState(VK_LBUTTON) < 0) then
  begin
    MainForm.left := Mouse.CursorPos.X - (FMousePoint.X - FFormPoint.X);
    MainForm.top := Mouse.CursorPos.Y - (FMousePoint.Y - FFormPoint.Y);
  end;
end;

procedure TMainForm.Quit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.SetMouseEvents;
var i: integer;
begin
  for i:=0 to self.ComponentCount-1 do
  begin
    if (self.Components[i] is TPanel) then
    begin
      TPanel(self.Components[i]).OnMouseDown:= pnlMainMouseDown;
      TPanel(self.Components[i]).OnMouseMove:= pnlMainMouseMove;
    end;

    if (self.Components[i] is TLabel) then
    begin
      TLabel(self.Components[i]).OnMouseDown:= pnlMainMouseDown;
      TLabel(self.Components[i]).OnMouseMove:= pnlMainMouseMove;
    end;

    if (self.Components[i] is TImage) then
    begin
      TImage(self.Components[i]).OnMouseDown:= pnlMainMouseDown;
      TImage(self.Components[i]).OnMouseMove:= pnlMainMouseMove;
    end;
  end;
end;

procedure TMainForm.Show1Click(Sender: TObject);
begin
  if not Visible
   then begin
   WindowState := wsNormal;
   SetForegroundWindow(handle);
   Show;			{ Show the main form }
   PopupMenu.Items[0].Caption := 'Hide';
   end
   else begin
   Hide();
   PopupMenu.Items[0].Caption := 'Show';
   end;
end;

procedure TMainForm.btnMinimizeClick(Sender: TObject);
begin
  Hide;
end;

procedure TMainForm.WMMouseMove(var Msg: TWMMouseMove);
begin
    if (Msg.YPos < GetSystemMetrics(SM_CYSIZEFRAME)) or
       (Msg.YPos > (Height - 55)) or
       (Msg.XPos < 10) or
       (Msg.XPos > (Width - 25)) then
    begin
      DeleteRegion;
    end else if (Msg.YPos >= 10) then
    begin
      CreateRegion;
    end;
    inherited;
end;

procedure TMainForm.WMNCButtonDown(var Msg: TWMNCLButtonDown);
begin
    FNCLButtonDown := TRUE;
    inherited;
end;

procedure TMainForm.WMNCButtonUp(var Msg: TWMNCLButtonUp);
begin
    FNCLButtonDown := FALSE;
    inherited;
end;


procedure TMainForm.WMNCMouseLeave(var Msg : TMessage);
begin
    Inc(FMouseLeaveCount);
    if (FRgnHandle = 0) and (not FNCLButtonDown) then
        CreateRegion;
    inherited;
end;

procedure TMainForm.WMSYSCommand(var Msg: TWMSysCommand);
begin
    if Msg.CmdType = SC_RESTORE then
        CreateRegion;
    inherited;
end;

procedure TMainForm.CreateRegion;
begin
  BorderStyle := bsNone;
  if FRgnHandle <> 0 then DeleteObject(FRgnHandle);

  with MainForm.BoundsRect do
  begin
    FRgnHandle := CreateRoundRectRgn(0, 0, Right - Left + 1, Bottom - Top + 1,
                  FRgnCorner, FRgnCorner);
  end;

  if SetWindowRGN(Handle, FRgnHandle, True) = 0 then DeleteObject(FRgnHandle);
end;
procedure TMainForm.DeleteRegion;
begin
  if FRgnHandle <> 0 then
  begin
    BorderStyle := bsToolWindow;
    SetWindowRGN(Handle, 0, True);
    DeleteObject(FRgnHandle);
    FRgnHandle := 0;
  end;
end;

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  AboutForm.FormStyle := fsStayOnTop;
  AboutForm.Position := poOwnerFormCenter;
  AboutForm.ShowModal;
end;

procedure TMainForm.tbSettingsContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

{ ------------- FONCTIONNAL PROCEDURES ------------- }

procedure TMainForm.TimerSession(Sender: TObject);

begin

  if TimerActive and (rounds >= 0) then
  begin
    remainingTime := MyTime - stopwatch.Elapsed;
    Minutes := Format('%2.2d', [Trunc(remainingTime * 24 * 60)]);
    Seconds := Format('%2.2d', [Trunc(remainingTime * 24 * 60 * 60) mod 60]);
    lblTime.Caption := Minutes + ':' + Seconds;

    if (lblTime.Caption = '00:12')  then
    begin
        if (lblTime.Font.Color = clBlack) or (lblTime.Font.Color = clWhite) then
          lblTime.Font.Color := clRed
        else if lblTime.Font.Color = clRed then
          if (TStyleManager.ActiveStyle.Name = 'Windows') then
            lblTime.Font.Color := clBlack else lblTime.Font.Color := clWhite;

        if (TStyleManager.ActiveStyle.Name = 'Windows') then
            lblTime.Font.Color := clBlack else lblTime.Font.Color := clWhite;
        Notify;
    end;


    if (lblTime.Caption = '00:00') then
    begin
      TimerActive := False;
      TimerBreakActive := True;

      if cbbBreak.Text <> 'None' then
      begin
        if (TStyleManager.ActiveStyle.Name = 'Windows') then
            lblTime.Font.Color := clBlack else lblTime.Font.Color := clWhite;
        cbbString := cbbBreak.Text;
        Match := TRegEx.Match(cbbString, '\d+').Value	;
        MyTime := StrToTime('00:' + Match + ':00') + stopwatch.Elapsed;
      end;
    end;
  end;
end;


procedure TMainForm.TimerBreakTimer(Sender: TObject);
begin

      if TimerBreakActive and (cbbBreak.Text <> 'None') then
      begin
        remainingTime := MyTime - stopwatch.Elapsed;
        Minutes := Format('%2.2d', [Trunc(remainingTime * 24 * 60)]);
        Seconds := Format('%2.2d', [Trunc(remainingTime * 24 * 60 * 60) mod 60]);
        lblTime.Caption := Minutes + ':' + Seconds;
        lblTime.Font.Color := clRed;

        if (lblTime.Caption = '00:12') then
          Notify;

        if (lblTime.Caption = '00:00') then
        begin
          if (TStyleManager.ActiveStyle.Name = 'Windows') then
            lblTime.Font.Color := clBlack else lblTime.Font.Color := clWhite;
          cbbString := cbbDuration.Text;
          Match := TRegEx.Match(cbbString, '\d+').Value;
          MyTime := StrToTime('00:' + Match + ':00') + stopwatch.Elapsed;
          rounds := rounds - 1;
          TimerActive := True;
          TimerBreakActive := False;
        end;
      end;

end;

procedure TMainForm.Notify;
begin
  PlaySound(nil, 0, 0);
  PlaySound(PChar(cbbSound.Text), 0, SND_RESOURCE or SND_ASYNC);

end;

procedure TMainForm.TrayIconClick(Sender: TObject);
begin
  if Visible then
   Hide()
  else begin
   WindowState := wsNormal;
   SetForegroundWindow(handle);
   Show;
  end;
end;

procedure TMainForm.btnBackClick(Sender: TObject);
begin
  PlaySound(nil, 0, 0);
  tbMain.Show;
end;

procedure TMainForm.btnConfirmClick(Sender: TObject);
begin
  ApplySettings;
  PlaySound(nil, 0, 0);
  tbMain.Show;
end;

procedure TMainForm.btnPauseClick(Sender: TObject);
begin
  if TimerActive then
  begin
    btnPause.Enabled := False;
    btnPause.ImageIndex := 5;
    btnStart.Enabled := True;
    btnStart.ImageIndex := 2;
    StopTime := Now;
    TimerActive := False;
    stopwatch.Stop;
    PlaySound(nil, 0, 0);
  end;
end;

procedure TMainForm.btnRepeatClick(Sender: TObject);

begin
  if btnRepeat.ImageIndex < 14 then
    begin
    btnRepeat.ImageIndex := btnRepeat.ImageIndex + 1;
    Rounds := btnRepeat.ImageIndex - 11;
    end
  else
    begin
    btnRepeat.ImageIndex := 11;
    Rounds := 0
    end;
end;

procedure TMainForm.btnSettingsClick(Sender: TObject);
begin
  tbSettings.Show;
end;

procedure TMainForm.btnStartClick(Sender: TObject);
begin

  if btnPause.Enabled = True then
    btnRepeat.ImageIndex := btnRepeat.ImageIndex + 5;
  btnStart.Enabled := False;
  btnStart.ImageIndex := 6;
  btnPause.Enabled := True;
  btnPause.ImageIndex := 1;
  cbbDuration.Enabled := False;
  cbbBreak.Enabled := False;
  btnRepeat.Enabled := False;
  TimerActive := True;
  stopwatch.Start;

end;

procedure TMainForm.btnStopClick(Sender: TObject);
begin
  TimerActive := False;
  TimerBreakActive := False;

  if btnStart.Enabled = False then
  begin
    btnRepeat.Enabled := True;
    btnRepeat.ImageIndex := btnRepeat.ImageIndex - 5;
  end;

  if (TStyleManager.ActiveStyle.Name = 'Windows') then
    lblTime.Font.Color := clBlack else lblTime.Font.Color := clWhite;
  StopTime := MyTime;
  stopwatch.Reset;
  btnStart.Enabled := True;
  btnStart.ImageIndex := 2;
  cbbDuration.Enabled := True;
  cbbBreak.Enabled := True;
  btnRepeat.Enabled := True;
  UpdateLabel;

  PlaySound(nil, 0, 0);
end;

procedure TMainForm.UpdateLabel;
var
newItems: TStringList;

begin
  cbbString := cbbDuration.Text;
  Match := TRegEx.Match(cbbString, '\d+').Value	;
  MyTime := StrToTime('00:' + Match + ':00');
  FormatedTime := FormatDateTime('nn:ss', MyTime);
  lblTime.Caption := FormatedTime;

  if TRegEx.IsMatch(cbbString, '(10 ATO)') then
  begin
    newItems := TStringList.Create;
    newItems.Add('2 ATO +');
    newItems.Add('None');
    cbbBreak.Items := newItems;
    cbbBreak.ItemIndex := 0;
  end;

  if TRegEx.IsMatch(cbbString, '(2)|(5) (ATO)') then
  begin
    newItems := TStringList.Create;
    newItems.Add('None');
    cbbBreak.Items := newItems;
    cbbBreak.ItemIndex := 0;
  end;

  if TRegEx.IsMatch(cbbString, '(POMO)') then
  begin
    newItems := TStringList.Create;
    newItems.Add('5 POMO');
    newItems.Add('10 POMO +');
    cbbBreak.Items := newItems;
    cbbBreak.ItemIndex := 0;
  end;
end;

procedure TMainForm.cbbBreakCloseUp(Sender: TObject);
begin
  MainForm.ActiveControl := nil;
end;

procedure TMainForm.cbbDurationCloseUp(Sender: TObject);
begin
  MainForm.ActiveControl := nil;
end;

procedure TMainForm.cbbDurationSelect(Sender: TObject);
begin
UpdateLabel;
end;

procedure TMainForm.cbbLanguageChange(Sender: TObject);
begin
  localize;
end;

procedure TMainForm.cbbLanguageCloseUp(Sender: TObject);
begin
  MainForm.ActiveControl := nil;
end;

procedure TMainForm.cbbSoundChange(Sender: TObject);
begin
  Notify;
end;

procedure TMainForm.cbbSoundCloseUp(Sender: TObject);
begin
  MainForm.ActiveControl := nil;
end;

function TMainForm.IsWindowsThemeDark: String;
var
  Reg: TRegistry;
begin
  Result := 'False'; // Default to Light theme
  Reg := TRegistry.Create;

  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Themes\Personalize') then
    begin
      if Reg.ValueExists('AppsUseLightTheme') and (Reg.ReadInteger('AppsUseLightTheme') = 0) then
        Result := 'True'; // Set Dark theme
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TMainForm.cbbThemeChange(Sender: TObject);
begin
  case (cbbTheme.ItemIndex) of
    0:
    begin
    TStyleManager.SetStyle(defaultSystemTheme);
      if (TStyleManager.ActiveStyle.Name = 'Windows') then
    lblTime.Font.Color := clBlack else lblTime.Font.Color := clWhite;
    end;

    1:
    begin
    TStyleManager.SetStyle('Windows');
    lblTime.Font.Color := clBlack;
    end;

    2:
    begin
    TStyleManager.SetStyle('Onyx Blue');
    lblTime.Font.Color := clWhite;
    end;
  end;

  UpdateImages(MainForm);
  tbSettings.show;
end;

procedure TMainForm.cbbThemeCloseUp(Sender: TObject);
begin
  MainForm.ActiveControl := nil;
end;

end.
