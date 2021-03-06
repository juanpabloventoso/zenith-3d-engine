unit z3DREFSwitch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ImgList;

type
  TfrmREFSwitch = class(TForm)
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    lblApps: TLabel;
    btnLaunch: TButton;
    btnExit: TButton;
    bvlBottom: TBevel;
    imgIcon: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
  public
    class procedure Launch;
  end;

var
  frmREFSwitch: TfrmREFSwitch;

implementation

uses z3DStrings, z3DCore_Func, z3DFileSystem_Func;

{$R *.dfm}

class procedure TfrmREFSwitch.Launch;
begin
  frmREFSwitch:= TfrmREFSwitch.Create(Application);
  frmREFSwitch.ShowModal;
end;

procedure TfrmREFSwitch.FormCreate(Sender: TObject);
begin
{  Caption:= z3DFRMAPPSTART_TITLE;
  lblTitle.Caption:= z3DFRMAPPSTART_LBLTITLE_TEXT;
  if WideCharToString(z3DCore_GetState.CurrentApp) <> '' then
  lblSubtitle.Caption:= z3DFRMAPPSTART_APP_NOT_FOUND+#13#10+z3DFRMAPPSTART_LBLSUBTITLE_TEXT else
  lblSubtitle.Caption:= z3DFRMAPPSTART_LBLSUBTITLE_TEXT;
  lblApps.Caption:= z3DFRMAPPSTART_LBLAPPS_TEXT;
  btnLaunch.Caption:= z3DFRMAPPSTART_BTNLAUNCH_TEXT;
  btnExit.Caption:= z3DFRMAPPSTART_BTNEXIT_TEXT;}
end;

procedure TfrmREFSwitch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmREFSwitch.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult <> mrOK then FatalExit(0);
end;

end.
