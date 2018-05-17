unit z3DAppStart;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ImgList;

type
  TfrmAppStart = class(TForm)
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    lblApps: TLabel;
    lvApps: TListView;
    btnLaunch: TButton;
    btnExit: TButton;
    bvlBottom: TBevel;
    imgIcon: TImage;
    ilApps: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lvAppsDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FBuffer: PWideChar;
    procedure BuildAppList;
  public
    class procedure Launch;
  end;

var
  frmAppStart: TfrmAppStart;

implementation

uses z3DCore_Intf, z3DCore_Func, z3DFileSystem_Func, z3DFileSystem_Intf,
  z3DStrings;

{$R *.dfm}

class procedure TfrmAppStart.Launch;
begin
  frmAppStart:= TfrmAppStart.Create(Application);
  frmAppStart.ShowModal;
end;

procedure TfrmAppStart.FormCreate(Sender: TObject);
begin
  Caption:= z3DFRMAPPSTART_TITLE;
  lblTitle.Caption:= z3DFRMAPPSTART_LBLTITLE_TEXT;
  if WideCharToString(z3DCore_GetState.CurrentApp) <> '' then
  lblSubtitle.Caption:= z3DFRMAPPSTART_APP_NOT_FOUND+#13#10+z3DFRMAPPSTART_LBLSUBTITLE_TEXT else
  lblSubtitle.Caption:= z3DFRMAPPSTART_LBLSUBTITLE_TEXT;
  lblApps.Caption:= z3DFRMAPPSTART_LBLAPPS_TEXT;
  btnLaunch.Caption:= z3DFRMAPPSTART_BTNLAUNCH_TEXT;
  btnExit.Caption:= z3DFRMAPPSTART_BTNEXIT_TEXT;
  GetMem(FBuffer, 255);
  BuildAppList;
end;

procedure TfrmAppStart.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmAppStart.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult = mrOK then
  begin
    if lvApps.Selected = nil then CanClose:= False else
    StringToWideChar(lvApps.Selected.SubItems[0], z3DCore_GetState.CurrentApp, 255);
  end else
  begin
    FatalExit(0);
  end;
end;

procedure TfrmAppStart.BuildAppList;
var SR: TSearchRec;
    FFile: PWideChar;
    FAppInfo: Iz3DXMLAppInfoFile;
    FIcon: TIcon;
begin
  GetMem(FFile, 255);
  ilApps.AddIcon(Application.Icon);
  FAppInfo:= z3DFileSystemController.CreateAppInfoFile;
  FIcon:= TIcon.Create;
  try
    // Search for apps
    if FindFirst(WideCharToString(z3DFileSystemController.RootPath) + '*.*', faAnyFile, SR) = 0 then
    begin
      repeat

        // Exclude non-app folders
        StringToWideChar(SR.Name, FFile, 255);
        if DirectoryExists(z3DFileSystemController.GetFullPath(FFile)) and (Copy(SR.Name, 0, 1) <> '.') and
        (LowerCase(Copy(SR.Name, 0, Length(fsPrefix))) <> LowerCase(fsPrefix)) then
        begin

          // App was found
          StringToWideChar(WideCharToString(z3DFileSystemController.GetFullPath(FFile)) + fsPathDiv + fsAppInfoFile, FBuffer, 255);
          FAppInfo.Load(FBuffer);
          with lvApps.Items.Add do
          begin
            // Load application icon
            if FileExists(WideCharToString(z3DFileSystemController.GetFullPath(FFile)) + fsPathDiv + fsAppIconFile) then
            begin
              FIcon.LoadFromFile(WideCharToString(z3DFileSystemController.GetFullPath(FFile)) + fsPathDiv + fsAppIconFile);
              ilApps.AddIcon(FIcon);
              ImageIndex:= ilApps.Count-1;
            end else ImageIndex:= 0;

            // Extract application game
            if FAppInfo.Title <> '' then
            begin
              Caption:= FAppInfo.Title;
              if FAppInfo.Subtitle <> '' then
              Caption:= Caption + ' - ' + FAppInfo.Subtitle;
            end else Caption:= SR.Name;
            Subitems.Add(SR.Name);
          end;
        end;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  finally
    FIcon.Free;
    FreeMem(FFile);
  end;
  if lvApps.Items.Count = 0 then
  begin
    z3DTrace('TfrmAppStart.BuildAppList: z3D Engine could not detect any available applications. This program will now be terminated', z3dtkError);
    Exit;
  end;
end;

procedure TfrmAppStart.lvAppsDblClick(Sender: TObject);
begin
  ModalResult:= mrOK;
end;

procedure TfrmAppStart.FormDestroy(Sender: TObject);
begin
  FreeMem(FBuffer);
end;

end.
