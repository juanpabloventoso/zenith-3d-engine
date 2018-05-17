{==============================================================================}
{== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==}
{==============================================================================}
{== Unit: z3DClasses. Main classes for z3D objects                           ==}
{==============================================================================}

unit z3DClasses_Impl;

interface

uses
  Windows, Classes, Direct3D9, z3DClasses_Intf;

type






{==============================================================================}
{== z3D base interface                                                       ==}
{==============================================================================}
{== Implements methods for initialization and cleanup and holds a reference  ==}
{== to its owner (if any) as a Pointer type to avoid mutual reference        ==}
{== counting                                                                 ==}
{==============================================================================}

  Tz3DBase = class(TInterfacedObject, Iz3DBase)
  private
    FOwner: Pointer;
    FRTTIPropertyList: Tz3DRTTIPropertyList;
  protected
    function GetOwner: Iz3DBase; stdcall;
    procedure Init(const AOwner: Iz3DBase = nil); virtual; stdcall;
    procedure Cleanup; virtual; stdcall;

    function RTTIGetPropertyList: Tz3DRTTIPropertyList;

    function RTTIGetIntValue(const AProperty: PAnsiChar): Integer;
    function RTTIGetFloatValue(const AProperty: PAnsiChar): Single;
    function RTTIGetACharValue(const AProperty: PAnsiChar): PAnsiChar;
    function RTTIGetWCharValue(const AProperty: PAnsiChar): PWideChar;
    function RTTIGetIntfValue(const AProperty: PAnsiChar): IInterface;

    procedure RTTISetIntValue(const AProperty: PAnsiChar; const AValue: Integer);
    procedure RTTISetACharValue(const AProperty: PAnsiChar; const AValue: PAnsiChar);
    procedure RTTISetWCharValue(const AProperty: PAnsiChar; const AValue: PWideChar);
    procedure RTTISetIntfValue(const AProperty: PAnsiChar; const AValue: IInterface);

  public
    constructor Create(const AOwner: Iz3DBase = nil); virtual;
    destructor Destroy; override;
  public
    property Owner: Iz3DBase read GetOwner;
  end;







{==============================================================================}
{== z3D linked interface                                                     ==}
{==============================================================================}
{== This interface can access to the common z3D Engine events such as device ==}
{== creation, frame move or scenario render                                  ==}
{== The z3D Engine will call this events on any object registered as linked  ==}
{==============================================================================}

  Tz3DLinked = class(Tz3DBase, Iz3DLinked)
  private
    FNotifications: Tz3DLinkNotifications;
    FScenarioStage: Tz3DStartScenarioStage;
    FScenarioLevel: Boolean;
  protected
    function GetScenarioLevel: Boolean; virtual; stdcall;
    procedure SetScenarioLevel(const Value: Boolean); virtual; stdcall;
    function GetScenarioStage: Tz3DStartScenarioStage; virtual; stdcall;
    procedure SetScenarioStage(const AStage: Tz3DStartScenarioStage); virtual; stdcall;
    function GetNotifications: Tz3DLinkNotifications; virtual; stdcall;
    procedure SetNotifications(const ANotifications: Tz3DLinkNotifications); virtual; stdcall;
  protected
    procedure z3DCreateDevice; virtual; stdcall;
    procedure z3DDestroyDevice; virtual; stdcall;
    procedure z3DResetDevice; virtual; stdcall;
    procedure z3DLostDevice; virtual; stdcall;
    procedure z3DConfirmDevice(const ACaps: TD3DCaps9; const AAdapterFormat,
      ABackBufferFormat: TD3DFormat; var AAccept: Boolean); virtual; stdcall;
    procedure z3DModifyDevice(var ADeviceSettings: Tz3DDeviceSettings; const ACaps: TD3DCaps9); virtual; stdcall;
    procedure z3DStartScenario(const AStage: Tz3DStartScenarioStage); virtual; stdcall;
    procedure z3DStopScenario; virtual; stdcall;
    procedure z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller); virtual; stdcall;
    procedure z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller); virtual; stdcall;
    procedure z3DFrameMove; virtual; stdcall;
    procedure z3DGPUPrecomputation; virtual; stdcall;
    procedure z3DFrameRender; virtual; stdcall;
    procedure z3DLightingRender; virtual; stdcall;
    procedure z3DDirectLightRender; virtual; stdcall;
    procedure z3DGUIRender; virtual; stdcall;
    procedure z3DMessage(const AWnd: HWnd; const AMsg: LongWord; const AwParam: wParam;
      const AlParam: lParam; var ADefault: Boolean; var AResult: lResult); virtual; stdcall;
    procedure z3DKeyboard(const AChar: LongWord; const AKeyDown, AAltDown: Boolean); virtual; stdcall;
    procedure Cleanup; override; stdcall;
  public
    procedure z3DLink; stdcall;
    procedure z3DUnlink; stdcall;
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property ScenarioStage: Tz3DStartScenarioStage read GetScenarioStage write SetScenarioStage;
    property Notifications: Tz3DLinkNotifications read GetNotifications write SetNotifications;
    property ScenarioLevel: Boolean read GetScenarioLevel write SetScenarioLevel;
  end;






// Cleanups all references mantained by a z3D interface and frees it
procedure z3DCleanupFree(var AInterface); stdcall;

implementation

uses z3DEngine_Func, TypInfo, z3DCore_Func, SysUtils;

procedure z3DCleanupFree(var AInterface);
begin
  if Iz3DBase(AInterface) = nil then Exit;
  Iz3DBase(AInterface).Cleanup;
  Pointer(AInterface):= nil;
end;

{ Tz3DBase }

constructor Tz3DBase.Create(const AOwner: Iz3DBase);
begin
  inherited Create;
  Init(AOwner);
end;

procedure Tz3DBase.Init(const AOwner: Iz3DBase);
begin
  FOwner:= Pointer(AOwner);
end;

function Tz3DBase.GetOwner: Iz3DBase;
begin
  Result:= Iz3DBase(FOwner);
end;

procedure Tz3DBase.Cleanup;
begin
  FOwner:= nil;
end;

destructor Tz3DBase.Destroy;
begin
  Cleanup;
  inherited;
end;

function Tz3DBase.RTTIGetACharValue(const AProperty: PAnsiChar): PAnsiChar;
var FValue: string;
begin
  FValue:= GetPropValue(Self, AProperty);
  Result:= PAnsiChar(FValue);
end;

function Tz3DBase.RTTIGetFloatValue(const AProperty: PAnsiChar): Single;
begin
  Result:= GetFloatProp(Self, AProperty);
end;

function Tz3DBase.RTTIGetIntfValue(const AProperty: PAnsiChar): IInterface;
begin
  Result:= GetInterfaceProp(Self, AProperty);
end;

function Tz3DBase.RTTIGetIntValue(const AProperty: PAnsiChar): Integer;
begin
  Result:= GetOrdProp(Self, AProperty);
end;

function Tz3DBase.RTTIGetPropertyList: Tz3DRTTIPropertyList;
begin
  Result:= FRTTIPropertyList;
end;

function Tz3DBase.RTTIGetWCharValue(const AProperty: PAnsiChar): PWideChar;
begin
  StringToWideChar(GetWideStrProp(Self, AProperty), z3DWideBuffer, 255);
  Result:= z3DWideBuffer;
end;

procedure Tz3DBase.RTTISetACharValue(const AProperty, AValue: PAnsiChar);
begin
  SetStrProp(Self, AProperty, StrPas(AValue));
end;

procedure Tz3DBase.RTTISetIntfValue(const AProperty: PAnsiChar; const AValue: IInterface);
begin
  SetInterfaceProp(Self, AProperty, AValue);
end;

procedure Tz3DBase.RTTISetIntValue(const AProperty: PAnsiChar; const AValue: Integer);
begin
  SetOrdProp(Self, AProperty, AValue);
end;

procedure Tz3DBase.RTTISetWCharValue(const AProperty: PAnsiChar; const AValue: PWideChar);
begin
  SetWideStrProp(Self, AProperty, AValue);
end;

{ Tz3DLinked }

constructor Tz3DLinked.Create(const AOwner: Iz3DBase);
begin
  inherited;
  FNotifications:= [];
  FScenarioStage:= z3dssCreatingScenarioObjects;
  FScenarioLevel:= True;
end;

function Tz3DLinked.GetScenarioLevel: Boolean;
begin
  Result:= FScenarioLevel;
end;

procedure Tz3DLinked.SetScenarioLevel(const Value: Boolean);
begin
  FScenarioLevel:= Value;
end;

procedure Tz3DLinked.z3DConfirmDevice(const ACaps: TD3DCaps9;
  const AAdapterFormat, ABackBufferFormat: TD3DFormat;
  var AAccept: Boolean);
begin
  // Not implemented on this class //
end;

procedure Tz3DLinked.z3DCreateDevice;
begin
  if z3DEngine.Scenario.Enabled or not ScenarioLevel then
  z3DCreateScenarioObjects(z3dcocCreateDevice);
end;

procedure Tz3DLinked.z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller);
begin
  // Not implemented on this class //
end;

procedure Tz3DLinked.z3DDestroyDevice;
begin
  if z3DEngine.Scenario.Enabled or not ScenarioLevel then
  z3DDestroyScenarioObjects(z3ddocDestroyDevice);
end;

procedure Tz3DLinked.z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller);
begin
  // Not implemented on this class //
end;

procedure Tz3DLinked.z3DDirectLightRender;
begin
  // Not implemented on this class //
end;

procedure Tz3DLinked.z3DFrameMove;
begin
  // Not implemented on this class //
end;

procedure Tz3DLinked.z3DFrameRender;
begin
  // Not implemented on this class //
end;

function Tz3DLinked.GetNotifications: Tz3DLinkNotifications;
begin
  Result:= FNotifications;
end;

function Tz3DLinked.GetScenarioStage: Tz3DStartScenarioStage;
begin
  Result:= FScenarioStage;
end;

procedure Tz3DLinked.z3DGPUPrecomputation;
begin
  // Not implemented on this class //
end;

procedure Tz3DLinked.z3DGUIRender;
begin
  // Not implemented on this class //
end;

procedure Tz3DLinked.z3DKeyboard(const AChar: LongWord;
  const AKeyDown, AAltDown: Boolean);
begin
  // Not implemented on this class //
end;

procedure Tz3DLinked.z3DLightingRender;
begin
  // Not implemented on this class //
end;

procedure Tz3DLinked.z3DLink;
begin
  if FNotifications <> [] then
  z3DEngine.AddLink(Self as Iz3DLinked);
end;

procedure Tz3DLinked.z3DLostDevice;
begin
  if z3DEngine.Scenario.Enabled or not ScenarioLevel then
  z3DDestroyScenarioObjects(z3ddocLostDevice);
end;

procedure Tz3DLinked.z3DMessage(const AWnd: HWnd; const AMsg: LongWord;
  const AwParam: wParam; const AlParam: lParam; var ADefault: Boolean; var AResult: lResult);
begin
  // Not implemented on this class //
end;

procedure Tz3DLinked.z3DModifyDevice(var ADeviceSettings: Tz3DDeviceSettings;
  const ACaps: TD3DCaps9);
begin
  // Not implemented on this class //
end;

procedure Tz3DLinked.z3DResetDevice;
begin
  if z3DEngine.Scenario.Enabled or not ScenarioLevel then
  z3DCreateScenarioObjects(z3dcocResetDevice);
end;

procedure Tz3DLinked.SetNotifications(const ANotifications: Tz3DLinkNotifications);
begin
  z3DUnlink;
  FNotifications:= ANotifications;
  z3DLink;
end;

procedure Tz3DLinked.SetScenarioStage(const AStage: Tz3DStartScenarioStage);
begin
  FScenarioStage:= AStage;
end;

procedure Tz3DLinked.z3DStartScenario(const AStage: Tz3DStartScenarioStage);
begin
  if (AStage = FScenarioStage) and FScenarioLevel then
  z3DCreateScenarioObjects(z3dcocStartScenario);
end;

procedure Tz3DLinked.z3DStopScenario;
begin
  if FScenarioLevel then z3DDestroyScenarioObjects(z3ddocStopScenario);
end;

procedure Tz3DLinked.z3DUnlink;
begin
  if FNotifications <> [] then
  z3DEngine.RemoveLink(Self as Iz3DLinked);
end;

procedure Tz3DLinked.Cleanup;
begin
  z3DUnlink;
  inherited;
end;

end.
