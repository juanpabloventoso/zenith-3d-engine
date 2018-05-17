{==============================================================================}
{== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==}
{==============================================================================}
{== Unit: z3DCore. 3D native controller for the Engine interface             ==}
{==============================================================================}

unit z3DCore_Impl;

interface

uses
  Windows, DXTypes, Direct3D9, D3DX9, XInput, z3DCore_Intf, z3DClasses_Impl,
  SysUtils, z3DInput_Func, z3DClasses_Intf;

{==============================================================================}
{== Common section                                                           ==}
{==============================================================================}
{== Common interfaces, classes and types                                     ==}
{==============================================================================}

type

  Tz3DTimer = class(Tz3DBase, Iz3DTimer)
  protected
    FTimerStopped: Boolean;
    FQPFTicksPerSec: LONGLONG;
    FStopTime: LONGLONG;
    FLastElapsedTime: LONGLONG;
    FBaseTime: LONGLONG;
  protected
    function GetAbsoluteTime: Double; stdcall;
    function GetTime: Double; stdcall;
    function GetElapsedTime: Double; stdcall;
    function GetAdjustedCurrentTime: TLargeInteger; stdcall;
  public
    constructor Create;
    procedure Reset; stdcall;
    procedure Start; stdcall;
    procedure Stop; stdcall;
    procedure Advance; stdcall;
    procedure GetTimeValues(out pfTime, pfAbsoluteTime: Double; out pfElapsedTime: Single); stdcall;
    function GetTimerStopped: Boolean; stdcall;
  public
    property AbsoluteTime: Double read GetAbsoluteTime;
    property Time: Double read GetTime;
    property ElapsedTime: Double read GetElapsedTime;
    property IsStopped: Boolean read GetTimerStopped;
  end;

  Tz3DResourceCache = class(Tz3DBase, Iz3DResourceCache)
  protected
    m_TextureCache: Tz3DCacheTextureArray; // array of Tz3DCacheTexture;
    m_EffectCache: array of Tz3DCacheEffect;
    m_FontCache: array of Tz3DCacheFont;
  public
    destructor Destroy; override;
  public
    function CreateTextureFromFile(pDevice: IDirect3DDevice9; pSrcFile: PWideChar; out ppTexture: IDirect3DTexture9): HRESULT; stdcall;
    function CreateTextureFromFileEx(pDevice: IDirect3DDEVICE9; pSrcFile: PWideChar;
      Width, Height, MipLevels: LongWord; Usage: DWORD; Format: TD3DFormat;
      Pool: TD3DPool; Filter, MipFilter: DWORD; ColorKey: TD3DColor;
      pSrcInfo: PD3DXImageInfo; pPalette: PPaletteEntry; out ppTexture: IDirect3DTexture9): HRESULT; stdcall;
    function CreateTextureFromResource(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar; ppTexture: IDirect3DTexture9): HRESULT; stdcall;
    function CreateTextureFromResourceEx(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar;
      Width, Height, MipLevels: LongWord; Usage: DWORD; Format: TD3DFormat;
      Pool: TD3DPool; Filter, MipFilter: DWORD; ColorKey: TD3DColor;
      pSrcInfo: PD3DXImageInfo; pPalette: PPaletteEntry; out ppTexture: IDirect3DTexture9): HRESULT; stdcall;
    function CreateCubeTextureFromFile(pDevice: IDirect3DDevice9; pSrcFile: PWideChar; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall;
    function CreateCubeTextureFromFileEx(pDevice: IDirect3DDevice9; pSrcFile: PWideChar;
      Size, MipLevels: LongWord; Usage: DWORD; Format: TD3DFormat;
      Pool: TD3DPool; Filter, MipFilter: DWORD; ColorKey: TD3DColor;
      pSrcInfo: PD3DXImageInfo; pPalette: PPaletteEntry; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall;
    function CreateCubeTextureFromResource(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall;
    function CreateCubeTextureFromResourceEx(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar;
      Size, MipLevels: LongWord; Usage: DWORD; Format: TD3DFormat;
      Pool: TD3DPool; Filter, MipFilter: DWORD; ColorKey: TD3DColor;
      pSrcInfo: PD3DXImageInfo; pPalette: PPaletteEntry; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT; stdcall;
    function CreateVolumeTextureFromFile(pDevice: IDirect3DDevice9; pSrcFile: PWideChar; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT; stdcall;
    function CreateVolumeTextureFromFileEx(pDevice: IDirect3DDevice9; pSrcFile: PWideChar;
      Width, Height, Depth, MipLevels: LongWord; Usage: DWORD; Format: TD3DFormat;
      Pool: TD3DPool; Filter, MipFilter: DWORD; ColorKey: TD3DColor;
      pSrcInfo: PD3DXImageInfo; pPalette: PPaletteEntry; out ppTexture: IDirect3DVolumeTexture9): HRESULT; stdcall;
    function CreateVolumeTextureFromResource(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT; stdcall;
    function CreateVolumeTextureFromResourceEx(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar;
      Width, Height, Depth, MipLevels: LongWord; Usage: DWORD; Format: TD3DFormat;
      Pool: TD3DPool; Filter, MipFilter: DWORD; ColorKey: TD3DColor;
      pSrcInfo: PD3DXImageInfo; pPalette: PPaletteEntry; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT; stdcall;
    function CreateFont(pDevice: IDirect3DDevice9;
      Height, Width, Weight, MipLevels: LongWord; Italic: BOOL;
      CharSet, OutputPrecision, Quality, PitchAndFamily: Byte;
      pFacename: PWideChar; out ppFont: ID3DXFont): HRESULT; stdcall;
    function CreateFontIndirect(pDevice: IDirect3DDevice9; const pDesc: TD3DXFontDescW; out ppFont: ID3DXFont): HRESULT; stdcall;
    function CreateEffectFromFile(pDevice: IDirect3DDevice9; pSrcFile: PWideChar;
      const pDefines: PD3DXMacro; pInclude: ID3DXInclude; Flags: DWORD;
      pPool: ID3DXEffectPool; out ppEffect: ID3DXEffect; ppCompilationErrors: PID3DXBuffer): HRESULT; stdcall;
    function CreateEffectFromResource(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar;
      const pDefines: PD3DXMacro; pInclude: ID3DXInclude; Flags: DWORD;
      pPool: ID3DXEffectPool; out ppEffect: ID3DXEffect; ppCompilationErrors: PID3DXBuffer): HRESULT; stdcall;
  public
    function OnCreateDevice(pd3dDevice: IDirect3DDevice9): HResult; stdcall;
    function OnResetDevice(pd3dDevice: IDirect3DDevice9): HResult; stdcall;
    function OnLostDevice: HResult; stdcall;
    function OnDestroyDevice: HResult; stdcall;
  end;

function WideFormatBuf(var Buffer; BufLen: Cardinal; const Format: WideString; const Args: array of const): Cardinal; overload;
function DynArrayContains(const DynArray: Pointer; var Element; ElementSize: Integer): Boolean; stdcall;

{==============================================================================}
{== Dynamic linking                                                          ==}
{==============================================================================}

function z3DCreateDynamicDirect3D9(SDKVersion: LongWord): IDirect3D9; stdcall;

function z3DD3DFormatToString(format: TD3DFormat; bWithPrefix: Boolean): PWideChar; stdcall;
function z3DTraceD3DDECLUSAGEtoString(u: TD3DDeclUsage): PWideChar; stdcall;
function z3DTraceD3DDECLMETHODtoString(m: TD3DDeclMethod): PWideChar; stdcall;
function z3DTraceD3DDECLTYPEtoString(t: TD3DDeclType): PWideChar; stdcall;

// Get info from monitors
function z3DMonitorFromWindow(const AWnd: HWND; const AFlags: DWORD): HMONITOR; stdcall;
function z3DGetMonitorInfo(const AMonitor: HMONITOR; var AMonitorInfo: Tz3DMonitorInfo): Boolean; stdcall;

{$IFDEF FPC}
  {$DEFINE D5_OR_FPC}
{$ENDIF}
{$IFDEF BORLAND}{$IFNDEF COMPILER6_UP}
    {$DEFINE D5_OR_FPC}
{$ENDIF}{$ENDIF}
{$IFDEF D5_OR_FPC}
function WideFormat(const FormatS: WideString; const Args: array of const): WideString;
function WideFormatBuf(var Buffer; BufLen: Cardinal; const FormatBuf; iFormatLength: Integer; const Args: array of const): Cardinal; overload; stdcall;
{$ENDIF}

type

  Tz3DDeviceList = class(Tz3DBase, Iz3DDeviceList)
  private
    FD3D: IDirect3D9;
    FAcceptDeviceFunc: Tz3DCallback_AcceptDevice;
    FAcceptDeviceFuncUserContext: Pointer;
    FRequirePostPixelShaderBlending: Boolean;
    FDepthStecilPossibleList: TD3DFormatArray;
    FMultiSampleTypeList: TD3DMultiSampleTypeArray;
    FPresentIntervalList: TLongWordArray;
    FSoftwareVP: Boolean;
    FHardwareVP: Boolean;
    FPureHarewareVP: Boolean;
    FMixedVP: Boolean;
    FMinWidth: LongWord;
    FMaxWidth: LongWord;
    FMinHeight: LongWord;
    FMaxHeight: LongWord;
    FRefreshMin: LongWord;
    FRefreshMax: LongWord;
    FMultisampleQualityMax: LongWord;
    FAdapterInfoList: Tz3DEnumAdapterInfoArray;
  protected
    function EnumerateDevices(pAdapterInfo: Iz3DEnumAdapterInfo; pAdapterFormatList: TD3DFormatArray): HRESULT; stdcall;
    function EnumerateDeviceCombos(pAdapterInfo: Iz3DEnumAdapterInfo; pDeviceInfo: Iz3DEnumDeviceInfo; pAdapterFormatList: TD3DFormatArray): HRESULT; stdcall;
    procedure BuildDepthStencilFormatList(pDeviceCombo: PD3DDeviceSettingsCombinations); stdcall;
    procedure BuildMultiSampleTypeList(pDeviceCombo: PD3DDeviceSettingsCombinations); stdcall;
    procedure BuildDSMSConflictList(pDeviceCombo: PD3DDeviceSettingsCombinations); stdcall;
    procedure BuildPresentIntervalList(pDeviceInfo: Iz3DEnumDeviceInfo; pDeviceCombo: PD3DDeviceSettingsCombinations); stdcall;
    procedure ClearAdapterInfoList; stdcall;
    function GetPossibleDepthStencilFormats: TD3DFormatArray; stdcall;
    function GetPossibleMultisampleTypes: TD3DMultiSampleTypeArray; stdcall;
    function GetPossiblePresentIntervals: TLongWordArray; stdcall;
    procedure SetPossibleDepthStencilFormats(a: TD3DFormatArray); stdcall;
    procedure SetPossibleMultisampleTypes(a: TD3DMultiSampleTypeArray); stdcall;
    procedure SetPossiblePresentIntervals(a: TLongWordArray); stdcall;
    procedure SetRequirePostPixelShaderBlending(bRequire: Boolean); stdcall;
    function GetRequirePostPixelShaderBlending: Boolean; stdcall;
    function GetMultisampleQualityMax: LongWord; stdcall;
    procedure SetMultisampleQualityMax(nMax: LongWord); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;
    procedure SetResolutionMinMax(nMinWidth, nMinHeight, nMaxWidth, nMaxHeight: LongWord); stdcall;
    procedure SetRefreshMinMax(nMin, nMax: LongWord); stdcall;
    procedure GetPossibleVertexProcessingList(out pbSoftwareVP, pbHardwareVP, pbPureHarewareVP, pbMixedVP: Boolean); stdcall;
    procedure SetPossibleVertexProcessingList(bSoftwareVP, bHardwareVP, bPureHarewareVP, bMixedVP: Boolean); stdcall;
    procedure ResetPossibleDepthStencilFormats; stdcall;
    procedure ResetPossibleMultisampleTypes; stdcall;
    procedure ResetPossiblePresentIntervals; stdcall;
    function GetAdapterInfoList: Tz3DEnumAdapterInfoArray; stdcall;
    function GetAdapterInfo(AdapterOrdinal: LongWord): Iz3DEnumAdapterInfo; stdcall;
    function GetDeviceInfo(AdapterOrdinal: LongWord; DeviceType: TD3DDevType): Iz3DEnumDeviceInfo; stdcall;
    function GetCurrentDeviceInfo: Iz3DEnumDeviceInfo; stdcall;
    function GetDeviceSettingsCombo(const pDeviceSettings: Tz3DDeviceSettings): PD3DDeviceSettingsCombinations; overload; stdcall;
    function GetCurrentDeviceSettingsCombo: PD3DDeviceSettingsCombinations; overload; stdcall;
    function GetDeviceSettingsCombo(AdapterOrdinal: LongWord; DeviceType: TD3DDevType; AdapterFormat,
      BackBufferFormat: TD3DFormat; Windowed: Boolean): PD3DDeviceSettingsCombinations; overload; stdcall;
    procedure CleanupDirect3DInterfaces; stdcall;
    function Enumerate(pD3D: IDirect3D9 = nil; AcceptDeviceFunc: Tz3DCallback_AcceptDevice = nil;
      pAcceptDeviceFuncUserContext: Pointer = nil): HRESULT; stdcall; 
  public
    property PossibleDepthStencilFormats: TD3DFormatArray read GetPossibleDepthStencilFormats write SetPossibleDepthStencilFormats;
    property PossibleMultisampleTypes: TD3DMultiSampleTypeArray read GetPossibleMultisampleTypes write SetPossibleMultisampleTypes;
    property PossiblePresentIntervals: TLongWordArray read GetPossiblePresentIntervals write SetPossiblePresentIntervals;
    property MultisampleQualityMax: LongWord read GetMultisampleQualityMax write SetMultisampleQualityMax;
    property RequirePostPixelShaderBlending: Boolean read GetRequirePostPixelShaderBlending write SetRequirePostPixelShaderBlending;
  end;

  Tz3DEnumAdapterInfo = class(Tz3DBase, Iz3DEnumAdapterInfo)
  private
    FAdapterOrdinal: LongWord;
    FAdapterIdentifier: TD3DAdapterIdentifier9;
    FUniqueDescription: TDescArray;
    FDisplayModeList: TD3DDisplayModeArray;
    FDeviceInfoList: Tz3DDeviceInfoList;
  protected
    function GetAdapterIdentifier: PD3DAdapterIdentifier9; stdcall;
    function GetAdapterOrdinal: LongWord; stdcall;
    function GetDeviceInfoList: Pz3DDeviceInfoList; stdcall;
    function GetDisplayModeList: PD3DDisplayModeArray; stdcall;
    function GetUniqueDescription: PDescArray; stdcall;
    procedure SetAdapterIdentifier(const Value: PD3DAdapterIdentifier9); stdcall;
    procedure SetAdapterOrdinal(const Value: LongWord); stdcall;
    procedure SetDeviceInfoList(const Value: Pz3DDeviceInfoList); stdcall;
    procedure SetDisplayModeList(const Value: PD3DDisplayModeArray); stdcall;
    procedure SetUniqueDescription(const Value: PDescArray); stdcall;
  public
    destructor Destroy; override;
  public
    property AdapterOrdinal: LongWord read GetAdapterOrdinal write SetAdapterOrdinal;
    property AdapterIdentifier: PD3DAdapterIdentifier9 read GetAdapterIdentifier write SetAdapterIdentifier;
    property UniqueDescription: PDescArray read GetUniqueDescription write SetUniqueDescription;
    property DisplayModeList: PD3DDisplayModeArray read GetDisplayModeList write SetDisplayModeList;
    property DeviceInfoList: Pz3DDeviceInfoList read GetDeviceInfoList write SetDeviceInfoList;
  end;

  Tz3DEnumDeviceInfo = class(Tz3DBase, Iz3DEnumDeviceInfo)
  private
    FAdapterOrdinal: LongWord;
    FDeviceType: TD3DDevType;
    FCaps: TD3DCaps9;
    FDeviceSettingsComboList: Tz3DDeviceSettingsComboList;
  protected
    function GetAdapterOrdinal: LongWord; stdcall;
    function GetCaps: TD3DCaps9; stdcall;
    function GetDeviceSettingsComboList: Pz3DDeviceSettingsComboList; stdcall;
    function GetDeviceType: TD3DDevType; stdcall;
    procedure SetAdapterOrdinal(const Value: LongWord); stdcall;
    procedure SetCaps(const Value: TD3DCaps9); stdcall;
    procedure SetDeviceSettingsComboList(const Value: Pz3DDeviceSettingsComboList); stdcall;
    procedure SetDeviceType(const Value: TD3DDevType); stdcall;
  public
    destructor Destroy; override;
  public
    property AdapterOrdinal: LongWord read GetAdapterOrdinal write SetAdapterOrdinal;
    property DeviceType: TD3DDevType read GetDeviceType write SetDeviceType;
    property Caps: TD3DCaps9 read GetCaps write SetCaps;
    property DeviceSettingsComboList: Pz3DDeviceSettingsComboList read GetDeviceSettingsComboList write SetDeviceSettingsComboList;
  end;

{==============================================================================}
{== Core state                                                               ==}
{==============================================================================}
{== This interface holds the general state of the core engine to the user    ==}
{==============================================================================}

type

  Tz3DState = class(Tz3DBase, Iz3DState)
  private
    function GetActive: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetAdapterMonitor: Direct3D9.HMONITOR;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetAllowShortcutKeys: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetAllowShortcutKeysWhenFullscreen: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetAllowShortcutKeysWhenWindowed: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetAutoChangeAdapter: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetBackBufferSurfaceDesc: PD3DSurfaceDesc;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetCaps: PD3DCaps9;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetClipCursorWhenFullScreen: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetConstantFrameTime: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetCurrentDeviceSettings: Pz3DDeviceSettings;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetCurrentFrameNumber: Integer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetD3D: IDirect3D9;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetD3DDevice: IDirect3DDevice9;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function Getz3DDeviceList: Iz3DDeviceList;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceCreateCalled: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceCreated: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceCreatedFunc: Tz3DCallback_DeviceCreated;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceDestroyedFunc: Tz3DCallback_DeviceDestroyed;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceLost: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceLostFunc: Tz3DCallback_DeviceLost;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceObjectsCreated: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceObjectsReset: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceResetFunc: Tz3DCallback_DeviceReset;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceStats: PWideChar;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function Getz3DInitCalled: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function Getz3DInited: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetElapsedTime: Single;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetExitCode: Integer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetFPS: Single;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetFrameMoveFunc: Tz3DCallback_FrameMove;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetFrameRenderFunc: Tz3DCallback_FrameRender;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetFrameStats: PWideChar;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetHandleDefaultHotkeys: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetHWNDFocus: HWND;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetHWNDDeviceFullScreen: HWND;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetHWNDDeviceWindowed: HWND;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetIgnoreSizeChange: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetNotifyOnMouseMove: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetInsideDeviceCallback: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetInsideMainloop: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetAcceptDeviceFunc: Tz3DCallback_AcceptDevice;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetKeyboardFunc: Tz3DCallback_Keyboard;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetKeyboardHook: HHOOK;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetLastStatsUpdateFrames: DWORD;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetCursorWatermark: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetLastStatsUpdateTime: Double;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetMaximized: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetMenu: HMENU;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetMinimized: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetModifyDeviceSettingsFunc: Tz3DCallback_ModifyDeviceSettings;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetMouseFunc: Tz3DCallback_Mouse;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideAdapterOrdinal: Integer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideConstantFrameTime: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideConstantTimePerFrame: Single;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideForceHAL: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideForceHWVP: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideForcePureHWVP: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideForceREF: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideForceSWVP: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideFullScreen: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideHeight: Integer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideQuitAfterFrame: Integer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideForceVsync: Integer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideStartX: Integer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideStartY: Integer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideWidth: Integer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetOverrideWindowed: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetPauseRenderingCount: Integer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetPauseTimeCount: Integer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetRenderingPaused: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetShowCursorWhenFullScreen: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetShowMsgBoxOnError: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetNoStats: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetStartupFilterKeys: TFilterKeys;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetStartupStickyKeys: TStickyKeys;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetStartupToggleKeys: TToggleKeys;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetStaticFrameStats: PWideChar;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetFPSStats: PWideChar;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetTime: Double;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetAbsoluteTime: Double;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetTimePaused: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetTimePerFrame: Single;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetTimerList: Tz3DTimerRecordArray;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetKeys: Pz3DKeysArray;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetMouseButtons: Pz3DMouseButtonsArray;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetWindowCreateCalled: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetWindowCreated: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetWindowCreatedWithDefaultPositions: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetWindowMsgFunc: Tz3DCallback_MsgProc;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetWindowTitle: PWideChar;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetWireframeMode: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetFullScreenBackBufferWidthAtModeChange: LongWord;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetCurrentApp: PWideChar;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetFullScreenBackBufferHeightAtModeChange: LongWord;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetWindowBackBufferWidthAtModeChange: LongWord;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetWindowBackBufferHeightAtModeChange: LongWord;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetWindowedPlacement: PWindowPlacement;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetWindowedStyleAtModeChange: DWORD;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetTopmostWhileWindowed: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetMinimizedWhileFullscreen: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetHInstance: HINST;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetAutomation: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetInSizeMove: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetAcceptDeviceFuncUserContext: Pointer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetModifyDeviceSettingsFuncUserContext: Pointer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceCreatedFuncUserContext: Pointer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceResetFuncUserContext: Pointer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceLostFuncUserContext: Pointer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetDeviceDestroyedFuncUserContext: Pointer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetFrameMoveFuncUserContext: Pointer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetFrameRenderFuncUserContext: Pointer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetKeyboardFuncUserContext: Pointer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetMouseFuncUserContext: Pointer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetWindowMsgFuncUserContext: Pointer;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetCallDefWindowProc: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetHandleAltEnter: Boolean;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    function GetStatsUpdateInterval: Single;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetActive(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetAdapterMonitor(const Value: Direct3D9.HMONITOR);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetAllowShortcutKeys(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetAllowShortcutKeysWhenFullscreen(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetAllowShortcutKeysWhenWindowed(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetAutoChangeAdapter(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetBackBufferSurfaceDesc(const Value: PD3DSurfaceDesc);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetCaps(const Value: PD3DCaps9);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetClipCursorWhenFullScreen(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetConstantFrameTime(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetCurrentDeviceSettings(const Value: Pz3DDeviceSettings);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetCurrentFrameNumber(const Value: Integer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetD3D(const Value: IDirect3D9);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetD3DDevice(const Value: IDirect3DDevice9);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure Setz3DDeviceList(const Value: Iz3DDeviceList);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetDeviceCreateCalled(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetDeviceCreated(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetDeviceCreatedFunc(
      const Value: Tz3DCallback_DeviceCreated);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetDeviceDestroyedFunc(
      const Value: Tz3DCallback_DeviceDestroyed);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetDeviceLost(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetDeviceLostFunc(const Value: Tz3DCallback_DeviceLost);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetDeviceObjectsCreated(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetDeviceObjectsReset(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetDeviceResetFunc(const Value: Tz3DCallback_DeviceReset);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure Setz3DInitCalled(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure Setz3DInited(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetElapsedTime(const Value: Single);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetExitCode(const Value: Integer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetFPS(const Value: Single);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetFrameMoveFunc(const Value: Tz3DCallback_FrameMove);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetFrameRenderFunc(const Value: Tz3DCallback_FrameRender);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetHandleDefaultHotkeys(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetHWNDFocus(const Value: HWND);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetHWNDDeviceFullScreen(const Value: HWND);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetHWNDDeviceWindowed(const Value: HWND);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetIgnoreSizeChange(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetNotifyOnMouseMove(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetInsideDeviceCallback(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetInsideMainloop(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetAcceptDeviceFunc(
      const Value: Tz3DCallback_AcceptDevice);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetKeyboardFunc(const Value: Tz3DCallback_Keyboard);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetKeyboardHook(const Value: HHOOK);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetLastStatsUpdateFrames(const Value: DWORD);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetLastStatsUpdateTime(const Value: Double);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetMaximized(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetMenu(const Value: HMENU);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetMinimized(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetModifyDeviceSettingsFunc(
      const Value: Tz3DCallback_ModifyDeviceSettings);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetMouseFunc(const Value: Tz3DCallback_Mouse);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideAdapterOrdinal(const Value: Integer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideConstantFrameTime(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideConstantTimePerFrame(const Value: Single);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideForceHAL(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideForceHWVP(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideForcePureHWVP(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideForceREF(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideForceSWVP(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideFullScreen(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideHeight(const Value: Integer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideQuitAfterFrame(const Value: Integer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideForceVsync(const Value: Integer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideRelaunchMCE(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideStartX(const Value: Integer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideStartY(const Value: Integer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideWidth(const Value: Integer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetOverrideWindowed(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetPauseRenderingCount(const Value: Integer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetPauseTimeCount(const Value: Integer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetRenderingPaused(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetShowCursorWhenFullScreen(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetShowMsgBoxOnError(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetNoStats(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetStartupFilterKeys(const Value: TFilterKeys);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetStartupStickyKeys(const Value: TStickyKeys);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetStartupToggleKeys(const Value: TToggleKeys);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetTime(const Value: Double);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetAbsoluteTime(const Value: Double);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetTimePaused(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetTimePerFrame(const Value: Single);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetTimerList(const Value: Tz3DTimerRecordArray);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetWindowCreateCalled(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetWindowCreated(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetWindowCreatedWithDefaultPositions(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetWindowMsgFunc(const Value: Tz3DCallback_MsgProc);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetWireframeMode(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetFullScreenBackBufferWidthAtModeChange(const Value: LongWord);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetFullScreenBackBufferHeightAtModeChange(const Value: LongWord);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetWindowBackBufferWidthAtModeChange(const Value: LongWord);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetWindowBackBufferHeightAtModeChange(const Value: LongWord);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetWindowedPlacement(const Value: PWindowPlacement);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetWindowedStyleAtModeChange(const Value: DWORD);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetCursorWatermark(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetTopmostWhileWindowed(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetMinimizedWhileFullscreen(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetHInstance(const Value: HINST);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetAutomation(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetInSizeMove(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetStatsUpdateInterval(const Value: Single);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetAcceptDeviceFuncUserContext(const Value: Pointer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetModifyDeviceSettingsFuncUserContext(const Value: Pointer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetDeviceCreatedFuncUserContext(const Value: Pointer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetDeviceResetFuncUserContext(const Value: Pointer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetDeviceLostFuncUserContext(const Value: Pointer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetDeviceDestroyedFuncUserContext(const Value: Pointer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetFrameMoveFuncUserContext(const Value: Pointer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetFrameRenderFuncUserContext(const Value: Pointer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetKeyboardFuncUserContext(const Value: Pointer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetMouseFuncUserContext(const Value: Pointer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetWindowMsgFuncUserContext(const Value: Pointer);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetCallDefWindowProc(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure SetHandleAltEnter(const Value: Boolean);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure AppException(Sender: TObject; E: Exception);
    procedure SetCurrentApp(const Value: PWideChar);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;
    procedure CreateState; stdcall;
    procedure DestroyState; stdcall;
  public
    property D3D: IDirect3D9 read GetD3D write SetD3D;
    property D3DDevice: IDirect3DDevice9 read GetD3DDevice write SetD3DDevice;
    property z3DDeviceList: Iz3DDeviceList read Getz3DDeviceList write Setz3DDeviceList;
    property CurrentDeviceSettings: Pz3DDeviceSettings read GetCurrentDeviceSettings write SetCurrentDeviceSettings;
    property BackBufferSurfaceDesc: PD3DSurfaceDesc read GetBackBufferSurfaceDesc write SetBackBufferSurfaceDesc;
    property Caps: PD3DCaps9 read GetCaps write SetCaps;
    property HWNDFocus: HWND read GetHWNDFocus write SetHWNDFocus;
    property HWNDDeviceFullScreen: HWND read GetHWNDDeviceFullScreen write SetHWNDDeviceFullScreen;
    property HWNDDeviceWindowed: HWND read GetHWNDDeviceWindowed write SetHWNDDeviceWindowed;
    property AdapterMonitor: HMONITOR read GetAdapterMonitor write SetAdapterMonitor;
    property Menu: HMENU read GetMenu write SetMenu;
    property FullScreenBackBufferWidthAtModeChange: LongWord read GetFullScreenBackBufferWidthAtModeChange write SetFullScreenBackBufferWidthAtModeChange;
    property FullScreenBackBufferHeightAtModeChange: LongWord read GetFullScreenBackBufferHeightAtModeChange write SetFullScreenBackBufferHeightAtModeChange;
    property WindowBackBufferWidthAtModeChange: LongWord read GetWindowBackBufferWidthAtModeChange write SetWindowBackBufferWidthAtModeChange;
    property WindowBackBufferHeightAtModeChange: LongWord read GetWindowBackBufferHeightAtModeChange write SetWindowBackBufferHeightAtModeChange;
    property WindowedPlacement: PWindowPlacement read GetWindowedPlacement write SetWindowedPlacement;
    property WindowedStyleAtModeChange: DWORD read GetWindowedStyleAtModeChange write SetWindowedStyleAtModeChange;
    property TopmostWhileWindowed: Boolean read GetTopmostWhileWindowed write SetTopmostWhileWindowed;
    property Minimized: Boolean read GetMinimized write SetMinimized;
    property Maximized: Boolean read GetMaximized write SetMaximized;
    property MinimizedWhileFullscreen: Boolean read GetMinimizedWhileFullscreen write SetMinimizedWhileFullscreen;
    property IgnoreSizeChange: Boolean read GetIgnoreSizeChange write SetIgnoreSizeChange;
    property Time: Double read GetTime write SetTime;
    property AbsoluteTime: Double read GetAbsoluteTime write SetAbsoluteTime;
    property ElapsedTime: Single read GetElapsedTime write SetElapsedTime;
    property HInstance: HINST read GetHInstance write SetHInstance;
    property LastStatsUpdateTime: Double read GetLastStatsUpdateTime write SetLastStatsUpdateTime;
    property LastStatsUpdateFrames: DWORD read GetLastStatsUpdateFrames write SetLastStatsUpdateFrames;
    property FPS: Single read GetFPS write SetFPS;
    property StatsUpdateInterval: Single read GetStatsUpdateInterval write SetStatsUpdateInterval;
    property CurrentFrameNumber: Integer read GetCurrentFrameNumber write SetCurrentFrameNumber;
    property KeyboardHook: HHOOK read GetKeyboardHook write SetKeyboardHook;
    property AllowShortcutKeysWhenFullscreen: Boolean read GetAllowShortcutKeysWhenFullscreen write SetAllowShortcutKeysWhenFullscreen;
    property AllowShortcutKeysWhenWindowed: Boolean read GetAllowShortcutKeysWhenWindowed write SetAllowShortcutKeysWhenWindowed;
    property AllowShortcutKeys: Boolean read GetAllowShortcutKeys write SetAllowShortcutKeys;
    property CallDefWindowProc: Boolean read GetCallDefWindowProc write SetCallDefWindowProc;
    property StartupStickyKeys: TStickyKeys read GetStartupStickyKeys write SetStartupStickyKeys;
    property StartupToggleKeys: TToggleKeys read GetStartupToggleKeys write SetStartupToggleKeys;
    property StartupFilterKeys: TFilterKeys read GetStartupFilterKeys write SetStartupFilterKeys;
    property HandleDefaultHotkeys: Boolean read GetHandleDefaultHotkeys write SetHandleDefaultHotkeys;
    property HandleAltEnter: Boolean read GetHandleAltEnter write SetHandleAltEnter;
    property ShowMsgBoxOnError: Boolean read GetShowMsgBoxOnError write SetShowMsgBoxOnError;
    property NoStats: Boolean read GetNoStats write SetNoStats;
    property ClipCursorWhenFullScreen: Boolean read GetClipCursorWhenFullScreen write SetClipCursorWhenFullScreen;
    property ShowCursorWhenFullScreen: Boolean read GetShowCursorWhenFullScreen write SetShowCursorWhenFullScreen;
    property CursorWatermark: Boolean read GetCursorWatermark write SetCursorWatermark;
    property ConstantFrameTime: Boolean read GetConstantFrameTime write SetConstantFrameTime;
    property TimePerFrame: Single read GetTimePerFrame write SetTimePerFrame;
    property WireframeMode: Boolean read GetWireframeMode write SetWireframeMode;
    property AutoChangeAdapter: Boolean read GetAutoChangeAdapter write SetAutoChangeAdapter;
    property WindowCreatedWithDefaultPositions: Boolean read GetWindowCreatedWithDefaultPositions write SetWindowCreatedWithDefaultPositions;
    property CurrentApp: PWideChar read GetCurrentApp write SetCurrentApp;
    property ExitCode: Integer read GetExitCode write SetExitCode;
    property z3DInited: Boolean read Getz3DInited write Setz3DInited;
    property WindowCreated: Boolean read GetWindowCreated write SetWindowCreated;
    property DeviceCreated: Boolean read GetDeviceCreated write SetDeviceCreated;
    property z3DInitCalled: Boolean read Getz3DInitCalled write Setz3DInitCalled;
    property WindowCreateCalled: Boolean read GetWindowCreateCalled write SetWindowCreateCalled;
    property DeviceCreateCalled: Boolean read GetDeviceCreateCalled write SetDeviceCreateCalled;
    property InsideDeviceCallback: Boolean read GetInsideDeviceCallback write SetInsideDeviceCallback;
    property InsideMainloop: Boolean read GetInsideMainloop write SetInsideMainloop;
    property DeviceObjectsCreated: Boolean read GetDeviceObjectsCreated write SetDeviceObjectsCreated;
    property DeviceObjectsReset: Boolean read GetDeviceObjectsReset write SetDeviceObjectsReset;
    property Active: Boolean read GetActive write SetActive;
    property RenderingPaused: Boolean read GetRenderingPaused write SetRenderingPaused;
    property TimePaused: Boolean read GetTimePaused write SetTimePaused;
    property PauseRenderingCount: Integer read GetPauseRenderingCount write SetPauseRenderingCount;
    property PauseTimeCount: Integer read GetPauseTimeCount write SetPauseTimeCount;
    property DeviceLost: Boolean read GetDeviceLost write SetDeviceLost;
    property NotifyOnMouseMove: Boolean read GetNotifyOnMouseMove write SetNotifyOnMouseMove;
    property OverrideAdapterOrdinal: Integer read GetOverrideAdapterOrdinal write SetOverrideAdapterOrdinal;
    property OverrideWindowed: Boolean read GetOverrideWindowed write SetOverrideWindowed;
    property OverrideFullScreen: Boolean read GetOverrideFullScreen write SetOverrideFullScreen;
    property OverrideStartX: Integer read GetOverrideStartX write SetOverrideStartX;
    property OverrideStartY: Integer read GetOverrideStartY write SetOverrideStartY;
    property OverrideWidth: Integer read GetOverrideWidth write SetOverrideWidth;
    property OverrideHeight: Integer read GetOverrideHeight write SetOverrideHeight;
    property OverrideForceHAL: Boolean read GetOverrideForceHAL write SetOverrideForceHAL;
    property OverrideForceREF: Boolean read GetOverrideForceREF write SetOverrideForceREF;
    property OverrideForcePureHWVP: Boolean read GetOverrideForcePureHWVP write SetOverrideForcePureHWVP;
    property OverrideForceHWVP: Boolean read GetOverrideForceHWVP write SetOverrideForceHWVP;
    property OverrideForceSWVP: Boolean read GetOverrideForceSWVP write SetOverrideForceSWVP;
    property OverrideConstantFrameTime: Boolean read GetOverrideConstantFrameTime write SetOverrideConstantFrameTime;
    property OverrideConstantTimePerFrame: Single read GetOverrideConstantTimePerFrame write SetOverrideConstantTimePerFrame;
    property OverrideQuitAfterFrame: Integer read GetOverrideQuitAfterFrame write SetOverrideQuitAfterFrame;
    property OverrideForceVsync: Integer read GetOverrideForceVsync write SetOverrideForceVsync;
    property AcceptDeviceFunc: Tz3DCallback_AcceptDevice read GetAcceptDeviceFunc write SetAcceptDeviceFunc;
    property ModifyDeviceSettingsFunc: Tz3DCallback_ModifyDeviceSettings read GetModifyDeviceSettingsFunc write SetModifyDeviceSettingsFunc;
    property DeviceCreatedFunc: Tz3DCallback_DeviceCreated read GetDeviceCreatedFunc write SetDeviceCreatedFunc;
    property DeviceResetFunc: Tz3DCallback_DeviceReset read GetDeviceResetFunc write SetDeviceResetFunc;
    property DeviceLostFunc: Tz3DCallback_DeviceLost read GetDeviceLostFunc write SetDeviceLostFunc;
    property DeviceDestroyedFunc: Tz3DCallback_DeviceDestroyed read GetDeviceDestroyedFunc write SetDeviceDestroyedFunc;
    property FrameMoveFunc: Tz3DCallback_FrameMove read GetFrameMoveFunc write SetFrameMoveFunc;
    property FrameRenderFunc: Tz3DCallback_FrameRender read GetFrameRenderFunc write SetFrameRenderFunc;
    property KeyboardFunc: Tz3DCallback_Keyboard read GetKeyboardFunc write SetKeyboardFunc;
    property MouseFunc: Tz3DCallback_Mouse read GetMouseFunc write SetMouseFunc;
    property WindowMsgFunc: Tz3DCallback_MsgProc read GetWindowMsgFunc write SetWindowMsgFunc;
    property Automation: Boolean read GetAutomation write SetAutomation;
    property InSizeMove: Boolean read GetInSizeMove write SetInSizeMove;
    property AcceptDeviceFuncUserContext: Pointer read GetAcceptDeviceFuncUserContext write SetAcceptDeviceFuncUserContext;
    property ModifyDeviceSettingsFuncUserContext: Pointer read GetModifyDeviceSettingsFuncUserContext write SetModifyDeviceSettingsFuncUserContext;
    property DeviceCreatedFuncUserContext: Pointer read GetDeviceCreatedFuncUserContext write SetDeviceCreatedFuncUserContext;
    property DeviceResetFuncUserContext: Pointer read GetDeviceResetFuncUserContext write SetDeviceResetFuncUserContext;
    property DeviceLostFuncUserContext: Pointer read GetDeviceLostFuncUserContext write SetDeviceLostFuncUserContext;
    property DeviceDestroyedFuncUserContext: Pointer read GetDeviceDestroyedFuncUserContext write SetDeviceDestroyedFuncUserContext;
    property FrameMoveFuncUserContext: Pointer read GetFrameMoveFuncUserContext write SetFrameMoveFuncUserContext;
    property FrameRenderFuncUserContext: Pointer read GetFrameRenderFuncUserContext write SetFrameRenderFuncUserContext;
    property KeyboardFuncUserContext: Pointer read GetKeyboardFuncUserContext write SetKeyboardFuncUserContext;
    property MouseFuncUserContext: Pointer read GetMouseFuncUserContext write SetMouseFuncUserContext;
    property WindowMsgFuncUserContext: Pointer read GetWindowMsgFuncUserContext write SetWindowMsgFuncUserContext;
    property TimerList: Tz3DTimerRecordArray read GetTimerList write SetTimerList;
    property Keys: Pz3DKeysArray read GetKeys;
    property MouseButtons: Pz3DMouseButtonsArray read GetMouseButtons;
    property StaticFrameStats: PWideChar read GetStaticFrameStats;
    property FPSStats: PWideChar read GetFPSStats;
    property FrameStats: PWideChar read GetFrameStats;
    property DeviceStats: PWideChar read GetDeviceStats;
    property WindowTitle: PWideChar read GetWindowTitle;
  end;

// Wide char extended support

procedure z3DCreateWideChar(var AWideChar: PWideChar; const ASize: Integer = 255); stdcall;
function z3DWideBuffer: PWideChar; stdcall;
procedure z3DFreeWideChar(var AWideChar: PWideChar); stdcall;

{==============================================================================}
{== Global access functions                                                  ==}
{==============================================================================}
{== These functions controls the core state and allows to communicate with   ==}
{== the core controllers                                                     ==}
{==============================================================================}

procedure z3DTrace(const AMessage: PWideChar; const AKind: Tz3DTraceKind = z3DtkInformation); stdcall;
function z3DTraceCondition(const ACondition: Boolean; const AMessage: PWideChar;
  const AKind: Tz3DTraceKind = z3DtkInformation): Boolean; stdcall;

function z3DInit(bParseCommandLine: Boolean = True; bHandleDefaultHotkeys: Boolean = True;
  bShowMsgBoxOnError: Boolean = True; bHandleAltEnter: Boolean = True): HRESULT; stdcall;
procedure z3DCore_Shutdown(nExitCode: Integer = 0); stdcall;

function z3DCore_CreateWindow(const strWindowTitle: PWideChar = nil; hInstance: LongWord = 0; hIcon: HICON = 0;
  hMenu: HMENU = 0; x: Integer = Integer(CW_USEDEFAULT); y: Integer = Integer(CW_USEDEFAULT)): HRESULT; stdcall;
function z3DCore_SetWindow(hWndFocus, hWndDeviceFullScreen, hWndDeviceWindowed: HWND; bHandleMessages: Boolean = True): HRESULT; stdcall;
function z3DCore_StaticWndProc(hWnd: Windows.HWND; uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;

procedure z3DDisplayErrorMessage(hr: HRESULT);  stdcall;
function z3DCore_CreateDevice(AdapterOrdinal: LongWord = D3DADAPTER_DEFAULT; bWindowed: Boolean = True; nSuggestedWidth: Integer = 0;
  nSuggestedHeight: Integer = 0; pCallbackAcceptDevice: Tz3DCallback_AcceptDevice = nil; pCallbackModifyDeviceSettings: Tz3DCallback_ModifyDeviceSettings = nil;
  pUserContext: Pointer = nil): HRESULT; stdcall;
function z3DCore_CreateDeviceFromSettings(pDeviceSettings: Pz3DDeviceSettings; bPreserveInput: Boolean = False;
  bClipWindowToSingleAdapter: Boolean = True): HRESULT; stdcall;
function z3DCore_SetDevice(pd3dDevice: IDirect3DDevice9): HRESULT; stdcall;
function z3DCore_MainLoop(hAccel: HACCEL = 0): HRESULT; stdcall;
function z3DCore_ProcessMessages(hAccel: HACCEL = 0; const ARender: Boolean = True): UINT; stdcall;
procedure z3DCore_Render3DEnvironment; stdcall;

function z3DCore_GetDeviceList: Iz3DDeviceList; stdcall;
function z3DCore_GetStencilBits(fmt: TD3DFormat): LongWord; stdcall;
function z3DCore_GetDepthBits(fmt: TD3DFormat): LongWord; stdcall;
function z3DCore_GetAlphaChannelBits(fmt: TD3DFormat): LongWord; stdcall;
function z3DCore_GetColorChannelBits(fmt: TD3DFormat): Integer; stdcall;

function z3DCore_GetGlobalResourceCache: Iz3DResourceCache; stdcall;
function z3DCore_GetGlobalTimer: Iz3DTimer; stdcall;
function z3DCore_GetState: Iz3DState; stdcall;
procedure z3DCore_FreeState; stdcall;
function z3DCore_GetD3DObject: IDirect3D9; stdcall;
function z3DCore_GetD3DDevice: IDirect3DDevice9; stdcall;
function z3DCore_GetDeviceSettings: Tz3DDeviceSettings; stdcall;
function z3DCore_GetPresentParameters: TD3DPresentParameters; stdcall;
function z3DCore_GetBackBufferSurfaceDesc: PD3DSurfaceDesc; stdcall;
function z3DCore_GetDeviceCaps: PD3DCaps9; stdcall;
function z3DCore_GetHINSTANCE: HINST; stdcall;
function z3DCore_GetHWND: HWND; stdcall;
function z3DCore_GetHWNDFocus: HWND; stdcall;
function z3DCore_GetHWNDDeviceFullScreen: HWND; stdcall;
function z3DCore_GetHWNDDeviceWindowed: HWND; stdcall;
function z3DCore_GetWindowClientRect: TRect; stdcall;
function z3DCore_GetWindowClientRectAtModeChange: TRect; stdcall;
function z3DCore_GetFullsceenClientRectAtModeChange: TRect; stdcall;
function z3DCore_GetTime: Double; stdcall;
function z3DCore_GetElapsedTime: Single; stdcall;
function z3DCore_IsWindowed: Boolean; stdcall;
function z3DCore_GetFPS: Single; stdcall;
function z3DCore_GetWindowTitle: PWideChar; stdcall;
function z3DCore_GetFrameStats(bIncludeFPS: Boolean = False): PWideChar; stdcall;
function z3DCore_GetDeviceStats: PWideChar; stdcall;
function z3DCore_IsRenderingPaused: Boolean; stdcall;
function z3DCore_IsTimePaused: Boolean; stdcall;
function z3DCore_IsActive: Boolean; stdcall;
function z3DCore_GetExitCode: Integer; stdcall;
function z3DCore_GetShowMsgBoxOnError: Boolean; stdcall;
function z3DCore_GetHandleDefaultHotkeys: Boolean; stdcall;
function z3DCore_IsKeyDown(vKey: Byte): Boolean; stdcall;
function z3DCore_IsMouseButtonDown(vButton: Byte): Boolean; stdcall;
function z3DCore_GetAutomation: Boolean; stdcall;
function z3DCore_FindValidDeviceSettings(out pOut: Tz3DDeviceSettings; pIn: Pz3DDeviceSettings = nil;
  pMatchOptions: Pz3DMatchOptions = nil): HRESULT; stdcall;

procedure z3DCore_SetCursorSettings(bShowCursorWhenFullScreen, bClipCursorWhenFullScreen: Boolean); stdcall;
procedure z3DCore_SetMultimonSettings(bAutoChangeAdapter: Boolean); stdcall;
procedure z3DCore_SetShortcutKeySettings(bAllowWhenFullscreen: Boolean = False; bAllowWhenWindowed: Boolean = True); stdcall;
procedure z3DCore_SetWindowSettings(bCallDefWindowProc: Boolean = True); stdcall;
procedure z3DCore_SetConstantFrameTime(bConstantFrameTime: Boolean; fTimePerFrame: Single = 0.0333); stdcall;
function z3DCore_SetTimer(pCallbackTimer: Tz3DCallback_Timer; fTimeoutInSecs: Single = 1;
  pnIDEvent: PLongWord = nil; pCallbackUserContext: Pointer = nil): HRESULT; stdcall;
function z3DCore_KillTimer(nIDEvent: LongWord): HRESULT; stdcall;
function z3DCore_ToggleFullScreen: HRESULT; stdcall;
function z3DCore_ToggleREF: HRESULT; stdcall;
procedure z3DCore_Pause(bPauseTime, bPauseRendering: Boolean); stdcall;
procedure z3DCore_ResetEngineState; stdcall;

procedure z3DCore_GetDesktopResolution(AdapterOrdinal: LongWord; out pWidth, pHeight: LongWord); stdcall;
function z3DCore_CreateRefDevice(hWnd: HWND; bNullRef: Boolean = True): IDirect3DDevice9; stdcall;

// Callback functions
procedure z3DCore_SetCallback_DeviceCreated(pCallbackDeviceCreated: Tz3DCallback_DeviceCreated; pUserContext: Pointer = nil); stdcall;
procedure z3DCore_SetCallback_DeviceReset(pCallbackDeviceReset: Tz3DCallback_DeviceReset; pUserContext: Pointer = nil); stdcall;
procedure z3DCore_SetCallback_DeviceLost(pCallbackDeviceLost: Tz3DCallback_DeviceLost; pUserContext: Pointer = nil); stdcall;
procedure z3DCore_SetCallback_DeviceDestroyed(pCallbackDeviceDestroyed: Tz3DCallback_DeviceDestroyed; pUserContext: Pointer = nil); stdcall;
procedure z3DCore_SetCallback_DeviceChanging(pCallbackModifyDeviceSettings: Tz3DCallback_ModifyDeviceSettings; pUserContext: Pointer = nil); stdcall;
procedure z3DCore_SetCallback_FrameMove(pCallbackFrameMove: Tz3DCallback_FrameMove; pUserContext: Pointer = nil); stdcall;
procedure z3DCore_SetCallback_FrameRender(pCallbackFrameRender: Tz3DCallback_FrameRender; pUserContext: Pointer = nil); stdcall;
procedure z3DCore_SetCallback_Keyboard(pCallbackKeyboard: Tz3DCallback_Keyboard; pUserContext: Pointer = nil); stdcall;
procedure z3DCore_SetCallback_Mouse(pCallbackMouse: Tz3DCallback_Mouse; bIncludeMouseMove: Boolean = False; pUserContext: Pointer = nil); stdcall;
procedure z3DCore_SetCallback_MsgProc(pCallbackMsgProc: Tz3DCallback_MsgProc; pUserContext: Pointer = nil); stdcall;

// App starter
procedure z3DCore_LaunchAppStart; stdcall;

// Registry control
function z3DCore_ReadRegIntValue(const ASection, AKey: PWideChar; const ADefault: Integer): Integer; stdcall;
function z3DCore_ReadRegStrValue(const ASection, AKey: PWideChar; const ADefault: PWideChar): PWideChar; stdcall;
procedure z3DCore_WriteRegIntValue(const ASection, AKey: PWideChar; const AValue: Integer); stdcall;
procedure z3DCore_WriteRegStrValue(const ASection, AKey: PWideChar; const AValue: PWideChar); stdcall;


// Debug mode and memory management
function z3DSupports(const AInterface: IInterface; const AGUID: TGUID): Boolean; stdcall;
procedure FreeAndNil(var Obj);{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
procedure SafeRelease(var i);{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
procedure SafeDelete(var Obj);{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
procedure SafeFreeMem(var p);{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;

procedure z3DCore_OutputDebugString(strMsg: PWideChar; const args: array of const); stdcall;
procedure z3DCore_OutputDebugStringA(strMsg: PAnsiChar; const args: array of const); stdcall;

var z3DCore_OutputDebugStringW: procedure(strMsg: PWideChar; const args: array of const); stdcall = z3DCore_OutputDebugString;

function z3DTraceDX(const strFile: PChar; dwLine: DWORD; hr: HRESULT; const strMsg: PWideChar; bPopMsgBox: Boolean): HRESULT; stdcall;
function z3DError(str: PWideChar; hr: HRESULT; FileName: PChar = nil; Line: DWORD = $FFFFFFFF): HRESULT;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
function z3DErrorMessage(str: PWideChar; hr: HRESULT; FileName: PChar = nil; Line: DWORD = $FFFFFFFF): HRESULT;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
procedure z3DTraceDebug(strMsg: PWideChar; args: array of const); stdcall;

function z3DFailedTrace(Status: HRESULT): BOOL;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;

type

  PKBDLLHookStruct = ^TKBDLLHookStruct;
  tagKBDLLHOOKSTRUCT = packed record
    vkCode: DWORD;
    scanCode: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: ULONG_PTR;
  end;
  {$EXTERNALSYM tagKBDLLHOOKSTRUCT}
  KBDLLHOOKSTRUCT = tagKBDLLHOOKSTRUCT;
  {$EXTERNALSYM KBDLLHOOKSTRUCT}
  TKBDLLHookStruct = KBDLLHOOKSTRUCT;

const
  WH_KEYBOARD_LL     = 13;
  WH_MOUSE_LL        = 14;

  z3D_PRIMARY_MONITOR         = HMONITOR($12340042);

{$IFDEF FPC}
  VK_LWIN = 91;
  VK_RWIN = 92;

  E_FAIL = HRESULT($80004005);
  E_INVALIDARG = HRESULT($80070057);
  E_OUTOFMEMORY = HRESULT($8007000E);
  E_NOTIMPL = HRESULT($80004001);

{$ENDIF}

var
    z3DDebugTrace: Boolean = False;

implementation

uses
  StrSafe, DXErr9, z3DAppStart, Classes, RzCommon, Math, z3DFileSystem_Func,
  Messages, Forms, MMSystem, ShellAPI, z3DEngine_Func;

var
    GMonitorFromWindow: Boolean = False;
    GMonitorInfo: Boolean = False;
    GGetMonitorFromWindow: TMonitorFromWindow = nil;
    GGetMonitorInfo: TGetMonitorInfo = nil;
    GLog: TStringList;
    GRegistry: TRzRegIniFile;
    GWideBuffer: PWideChar; 

const
  z3DDebugLog = 'C:\z3DDebug.txt';

const
  z3D_GAMEPAD_TRIGGER_THRESHOLD      = 30;
  z3D_INPUT_DEADZONE                 = (0.24 * $7FFF);


procedure z3DCreateWideChar(var AWideChar: PWideChar; const ASize: Integer = 255); stdcall;
begin
  GetMem(AWideChar, ASize);
  ZeroMemory(AWideChar, ASize);
end;

function z3DWideBuffer: PWideChar; stdcall;
begin
  Result:= GWideBuffer;
end;

procedure z3DFreeWideChar(var AWideChar: PWideChar); stdcall;
begin
  if AWideChar = nil then Exit;
  FreeMem(AWideChar);
  Pointer(AWideChar):= nil;
end;

function z3DCore_ReadRegIntValue(const ASection, AKey: PWideChar; const ADefault: Integer): Integer;
begin
  Result:= GRegistry.ReadInteger(WideCharToString(ASection), WideCharToString(AKey), ADefault);
end;

function z3DCore_ReadRegStrValue(const ASection, AKey: PWideChar; const ADefault: PWideChar): PWideChar;
var FValue: string;
begin
  FValue:= GRegistry.ReadString(WideCharToString(ASection), WideCharToString(AKey), WideCharToString(ADefault));
  StringToWideChar(FValue, GWideBuffer, 255);
  Result:= GWideBuffer;
end;

procedure z3DCore_WriteRegIntValue(const ASection, AKey: PWideChar; const AValue: Integer);
begin
  GRegistry.WriteInteger(WideCharToString(ASection), WideCharToString(AKey), AValue);
end;

procedure z3DCore_WriteRegStrValue(const ASection, AKey: PWideChar; const AValue: PWideChar);
begin
  GRegistry.WriteString(WideCharToString(ASection), WideCharToString(AKey), WideCharToString(AValue));
end;

function z3DSupports(const AInterface: IInterface; const AGUID: TGUID): Boolean;
var FInt: IInterface;
begin
  AInterface.QueryInterface(AGUID, FInt);
  Result:= FInt <> nil;
end;

function DynArrayContains(const DynArray: Pointer; var Element; ElementSize: Integer): Boolean;
var
  i: Integer;
  p, pp: Pointer;
begin
  Result:= False;
  if DynArray = nil then Exit;
  p:= DynArray; Dec(PLongint(p));
  for i:= 0 to PLongint(p)^ - 1 do
  begin
    pp:= Pointer(Longint(DynArray) + ElementSize*i);
    if CompareMem(@Element, pp, ElementSize) then
    begin
      Result:= True;
      Break;
    end;
  end;
end;


{$IFDEF WIN64}
function PtrToUlong(p:Pointer): LongWord;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
begin
  Result:= LongWord(ULONG_PTR(p));
end;
{$ENDIF}

{$IFDEF D5_OR_FPC}
function WideFormat(const FormatS: WideString; const Args: array of const): WideString;
var
  S: String;
begin
  S:= Format(FormatS, Args);
  Result:= S + '_';
  Result[Length(S)+1]:= #0;
  SetLength(Result, Length(S));
end;

function WideFormatBuf(var Buffer; BufLen: Cardinal; const FormatBuf; iFormatLength: Integer; const Args: array of const): Cardinal; overload;
var
  l: Integer;
  S: WideString;
{$IFDEF FPC}
  S1: String;
  i: Integer;
{$ENDIF}
begin
{$IFDEF FPC}
  for i:= 0 to High(Args) do
  begin
    if (Args[i].Vtype = vtPointer) or
       (Args[i].Vtype = vtObject) or
       (Args[i].Vtype = vtClass) or
       (Args[i].Vtype = vtVariant)
    then Break;
  end;
{$ENDIF}
  S:= WideFormat(PWideChar(@FormatBuf), Args);
  l:= Min(Length(S)*2, Integer(BufLen)-2);
  Move(S[1], Buffer, l+2);
  Result:= l div 2;
end;
{$ENDIF}

function WideFormatBuf(var Buffer; BufLen: Cardinal; const Format: WideString; const Args: array of const): Cardinal; overload;
begin
  Result:= {$IFNDEF D5_OR_FPC}SysUtils.{$ENDIF}WideFormatBuf(Buffer, BufLen, Format[1], Length(Format), Args);
end;

procedure FreeAndNil(var Obj);{$IFNDEF DELPHI10}{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;{$ENDIF}
var Temp: TObject;
begin
  Temp:= TObject(Obj);
  Pointer(Obj):= nil;
  Temp.Free;
end;

procedure SafeRelease(var i);{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
begin
  if IUnknown(i) <> nil then IUnknown(i):= nil;
end;

procedure SafeDelete(var Obj);{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
var Temp: TObject;
begin
  Temp:= TObject(Obj);
  Pointer(Obj):= nil;
  Temp.Free;
end;

procedure SafeFreeMem(var p);{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
begin
  if (Pointer(p) <> nil) then
  begin
    FreeMem(Pointer(p));
    Pointer(p):= nil;
  end;
end;

function z3DGetMonitorInfo(const AMonitor: HMONITOR; var AMonitorInfo: Tz3DMonitorInfo): Boolean;
var FUser32: HMODULE;
    FVersionInfo: TOSVersionInfo;
    FWorkArea: TRect;
begin
  if not GMonitorInfo then
  begin
    FUser32 := GetModuleHandle('USER32');
    if (FUser32 <> 0) then
    begin
      FVersioninfo.dwOSVersionInfoSize := SizeOf(FVersioninfo);
      GetVersionEx(FVersioninfo);
      if FVersioninfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
      GGetMonitorInfo := GetProcAddress(FUser32, 'GetMonitorInfoW') else
      GGetMonitorInfo := GetProcAddress(FUser32, 'GetMonitorInfoA');
    end;
    GMonitorInfo:= True;
  end;
  if (@GGetMonitorInfo <> nil) then
  begin
    Result:= GGetMonitorInfo(AMonitor, @AMonitorInfo);
    Exit;
  end;
  if (AMonitor = z3D_PRIMARY_MONITOR) and (@AMonitorInfo <> nil) and
  (AMonitorInfo.cbSize >= SizeOf(TMonitorInfo)) and
  SystemParametersInfoA(SPI_GETWORKAREA, 0, @FWorkArea, 0) then
  begin
    AMonitorInfo.rcMonitor.Left := 0;
    AMonitorInfo.rcMonitor.Top := 0;
    AMonitorInfo.rcMonitor.Right := GetSystemMetrics(SM_CXSCREEN);
    AMonitorInfo.rcMonitor.Bottom := GetSystemMetrics(SM_CYSCREEN);
    AMonitorInfo.rcWork := FWorkArea;
    AMonitorInfo.dwFlags := MONITORINFOF_PRIMARY;
    Result:= True;
    Exit;
  end;
  Result:= False;
end;


function z3DMonitorFromWindow(const AWnd: HWND; const AFlags: DWORD): HMONITOR;
var FUser32: HMODULE;
begin
  if not GMonitorFromWindow then
  begin
    FUser32 := GetModuleHandle('USER32');
    if (FUser32 <> 0) then
    GGetMonitorFromWindow := GetProcAddress(FUser32, 'MonitorFromWindow');
    GMonitorFromWindow := True;
  end;
  if (@GGetMonitorFromWindow <> nil) then
  begin
    Result:= GGetMonitorFromWindow(AWnd, AFlags);
    Exit;
  end;
  if (AFlags and (MONITOR_DEFAULTTOPRIMARY or MONITOR_DEFAULTTONEAREST) <> 0) then
  begin
    Result:= z3D_PRIMARY_MONITOR;
    Exit;
  end;
  Result:= 0;
end;

procedure z3DTrace(const AMessage: PWideChar; const AKind: Tz3DTraceKind = z3DtkInformation);
const FMode: array[Tz3DTraceKind] of LongInt = (MB_ICONINFORMATION, MB_ICONWARNING, MB_ICONSTOP);
const FDesc: array[Tz3DTraceKind] of string = ('Information', 'Warning', 'Error');
begin
  if AKind = z3dtkError then
  begin
    ShowWindow(z3DCore_GetHWND, SW_HIDE);
    ShowWindow(z3DCore_GetHWNDFocus, SW_HIDE);
    ShowWindow(z3DCore_GetHWNDDeviceFullScreen, SW_HIDE);
    ShowWindow(z3DCore_GetHWNDDeviceWindowed, SW_HIDE);
  end;
  if (AKind = z3dtkError) then Application.MessageBox(PAnsiChar(WideCharToString(AMessage)+'.'), 'z3D Engine', MB_OK+FMode[AKind]);
  if z3DDebugTrace then
  begin
    if FileExists(z3DDebugLog) then GLog.LoadFromFile(z3DDebugLog);
    GLog.Add(FDesc[AKind]+' - '+AMessage+'. ('+DateTimeToStr(Now)+')');
    GLog.SaveToFile(z3DDebugLog);
  end;
  if (z3DEngine <> nil) and (z3DEngine.Desktop <> nil) and (z3DEngine.Desktop.Console <> nil) then
  z3DEngine.Desktop.Console.AddTrace(AMessage, AKind);
  if AKind = z3dtkError then FatalExit(1);
end;

function z3DTraceCondition(const ACondition: Boolean; const AMessage: PWideChar; const AKind: Tz3DTraceKind = z3DtkInformation): Boolean;
begin
  if ACondition then z3DTrace(AMessage, AKind);
  Result:= ACondition;
end;


procedure z3DCore_OutputDebugString(strMsg: PWideChar; const args: array of const);
{$IFDEF DEBUG}
var
  strBuffer: array[0..511] of WideChar;
{$ENDIF}
begin
{$IFDEF DEBUG}
  StringCchFormat(strBuffer, 512, strMsg, args);
  OutputDebugStringW(strBuffer);
{$ELSE}
   // Do nothing
{$ENDIF}
end;

procedure z3DCore_OutputDebugStringA(strMsg: PAnsiChar; const args: array of const);
{$IFDEF DEBUG}
var strBuffer: array[0..511] of AnsiChar;
{$ENDIF}
begin
{$IFDEF DEBUG}
  StringCchFormat(strBuffer, 512, strMsg, args);
  OutputDebugStringA(strBuffer);
{$ELSE}
   // Do nothing
{$ENDIF}
end;

function z3DTraceDX(const strFile: PChar; dwLine: DWORD; hr: HRESULT; const strMsg: PWideChar; bPopMsgBox: Boolean): HRESULT; stdcall;
var bShowMsgBoxOnError: Boolean;
begin
  bShowMsgBoxOnError := z3DCore_GetState.ShowMsgBoxOnError;
  if not (bPopMsgBox and bShowMsgBoxOnError) then bPopMsgBox := False;
  Result:= DXTraceW(strFile, dwLine, hr, strMsg, bPopMsgBox);
end;

{$IFDEF DEBUG}

function z3DError(str: PWideChar; hr: HRESULT; FileName: PChar = nil; Line: DWORD = $FFFFFFFF): HRESULT;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
begin
  z3DDisplayErrorMessage(hr);
  Result:= hr;
end;

function z3DErrorMessage(str: PWideChar; hr: HRESULT; FileName: PChar = nil; Line: DWORD = $FFFFFFFF): HRESULT;
begin
  z3DDisplayErrorMessage(hr);
  Result:= hr;
end;

procedure z3DTraceDebug(strMsg: PWideChar; args: array of const);
begin
  z3DTrace('The debugger sent a message on the current operation. Additional information: '+strMsg, z3dtkInformation);
  z3DCore_OutputDebugString(strMsg, args);
end;

{$ELSE}

function z3DError(str: PWideChar; hr: HRESULT; FileName: PChar = nil; Line: DWORD = $FFFFFFFF): HRESULT;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
begin
  Result:= hr;
end;

function z3DErrorMessage(str: PWideChar; hr: HRESULT; FileName: PChar = nil; Line: DWORD = $FFFFFFFF): HRESULT;
begin
  Result:= hr;
end;

procedure z3DTraceDebug(strMsg: PWideChar; args: array of const);
begin
end;

{$ENDIF}

{$IFDEF DEBUG}

function z3DFailedTrace(Status: HRESULT): BOOL;
begin
  Result := Status and HRESULT($80000000) <> 0;
  if Result then
  z3DTrace('Verification failed on operation with status: '+ IntToHex(Status, 12), z3dtkWarning);
end;

{$ELSE}

function z3DFailedTrace(Status: HRESULT): BOOL;
begin
  Result := Failed(Status);
end;

{$ENDIF}

procedure z3DCore_GetDesktopResolution(AdapterOrdinal: LongWord; out pWidth, pHeight: LongWord);
var pd3dEnum: Iz3DDeviceList;
    pAdapterInfo: Iz3DEnumAdapterInfo;
    devMode: TDeviceModeW;
    strDeviceName: array[0..255] of WideChar;
begin
  pd3dEnum := z3DCore_GetDeviceList;
  pAdapterInfo := pd3dEnum.GetAdapterInfo(AdapterOrdinal);
  ZeroMemory(@devMode, SizeOf(devMode));
  devMode.dmSize := SizeOf(devMode);
  MultiByteToWideChar(CP_ACP, 0, pAdapterInfo.AdapterIdentifier.DeviceName, -1, strDeviceName, 256);
  strDeviceName[255] := #0;
  EnumDisplaySettingsW(strDeviceName, ENUM_REGISTRY_SETTINGS, devMode);
  pWidth := devMode.dmPelsWidth;
  pHeight := devMode.dmPelsHeight;
end;

function z3DCore_CreateRefDevice(hWnd: HWND; bNullRef: Boolean = True): IDirect3DDevice9;
var pD3D: IDirect3D9;
    Mode: TD3DDisplayMode;
    pp: TD3DPresentParameters;
    devType: TD3DDevType;
begin
  Result:= nil;
  pD3D := z3DCreateDynamicDirect3D9(D3D_SDK_VERSION);
  if (pD3D = nil) then Exit;
  pD3D.GetAdapterDisplayMode(0, Mode);
  ZeroMemory(@pp, SizeOf(pp));
  pp.BackBufferWidth  := 1;
  pp.BackBufferHeight := 1;
  pp.BackBufferFormat := Mode.Format;
  pp.BackBufferCount  := 1;
  pp.SwapEffect       := D3DSWAPEFFECT_COPY;
  pp.Windowed         := True;
  pp.hDeviceWindow    := hWnd;
  if bNullRef then devType:= D3DDEVTYPE_NULLREF else devType:= D3DDEVTYPE_REF;
  pD3D.CreateDevice(D3DADAPTER_DEFAULT, devType, hWnd,
  D3DCREATE_HARDWARE_VERTEXPROCESSING, @pp, Result);
end;

{ Tz3DTimer }

constructor Tz3DTimer.Create;
var FTicksPerSec: LARGE_INTEGER;
begin
  FTimerStopped    := True;
  FQPFTicksPerSec  := 0;
  FStopTime        := 0;
  FLastElapsedTime := 0;
  FBaseTime        := 0;
  QueryPerformanceFrequency(FTicksPerSec.QuadPart);
  FQPFTicksPerSec := FTicksPerSec.QuadPart;
end;

procedure Tz3DTimer.Reset;
var FTime: TLargeInteger;
begin
  FTime := GetAdjustedCurrentTime;
  FBaseTime        := FTime;
  FLastElapsedTime := FTime;
  FStopTime        := 0;
  FTimerStopped    := False;
end;

procedure Tz3DTimer.Start;
var FTime: TLargeInteger;
begin
  QueryPerformanceCounter(FTime);
  if FTimerStopped then Inc(FBaseTime, FTime - FStopTime);
  FStopTime := 0;
  FLastElapsedTime := FTime;
  FTimerStopped := False;
end;

procedure Tz3DTimer.Stop;
var qwTime: TLargeInteger;
begin
  if not FTimerStopped then
  begin
    QueryPerformanceCounter(qwTime);
    FStopTime:= qwTime;
    FLastElapsedTime := qwTime;
    FTimerStopped := True;
  end;
end;

function Tz3DTimer.GetTimerStopped: Boolean;
begin
  Result:= FTimerStopped;
end;

procedure Tz3DTimer.Advance;
begin
  Inc(FStopTime, FQPFTicksPerSec div 10);
end;

function Tz3DTimer.GetAbsoluteTime: Double;
var qwTime: TLargeInteger;
    FTime: Double;
begin
  QueryPerformanceCounter(qwTime);
  FTime := qwTime / FQPFTicksPerSec;
  Result:= fTime;
end;

function Tz3DTimer.GetTime: Double;
var qwTime: TLargeInteger;
    FAppTime: Double;
begin
  qwTime:= GetAdjustedCurrentTime;
  FAppTime:= (qwTime - FBaseTime) / FQPFTicksPerSec;
  Result:= fAppTime;
end;

procedure Tz3DTimer.GetTimeValues(out pfTime, pfAbsoluteTime: Double; out pfElapsedTime: Single);
var qwTime: TLargeInteger;
    FElapsedTime: Single;
begin
  qwTime := GetAdjustedCurrentTime;
  fElapsedTime := (qwTime - FLastElapsedTime) / FQPFTicksPerSec;
  FLastElapsedTime := qwTime;
  if (FElapsedTime < 0) then FElapsedTime:= 0;
  pfAbsoluteTime := qwTime / FQPFTicksPerSec;
  pfTime := (qwTime - FBaseTime) / FQPFTicksPerSec;
  pfElapsedTime := fElapsedTime;
end;

function Tz3DTimer.GetElapsedTime: Double;
var
  qwTime: TLargeInteger;
  fElapsedTime: Double;
begin
  qwTime := GetAdjustedCurrentTime;
  fElapsedTime := (qwTime - FLastElapsedTime) / FQPFTicksPerSec;
  FLastElapsedTime := qwTime;
  if (fElapsedTime < 0.0) then fElapsedTime := 0.0;
  Result:= fElapsedTime;
end;

function Tz3DTimer.GetAdjustedCurrentTime: TLargeInteger;
var qwTime: TLargeInteger;
begin
  if FStopTime <> 0 then
  qwTime := FStopTime else QueryPerformanceCounter(qwTime);
  Result:= qwTime;
end;


var Gz3DDeviceList: Iz3DDeviceList = nil;

function z3DCore_GetDeviceList: Iz3DDeviceList;
begin
  if (Gz3DDeviceList = nil) then Gz3DDeviceList:= Tz3DDeviceList.Create;
  Result:= Gz3DDeviceList;
end;

function z3DCore_GetStencilBits(fmt: TD3DFormat): LongWord;
begin
  case fmt of
    D3DFMT_D16_LOCKABLE,
    D3DFMT_D16,
    D3DFMT_D32F_LOCKABLE,
    D3DFMT_D32,
    D3DFMT_D24X8: Result:= 0;
    D3DFMT_D15S1: Result:= 1;
    D3DFMT_D24X4S4: Result:= 4;
    D3DFMT_D24S8,
    D3DFMT_D24FS8: Result:= 8;
  else
    Result:= 0;
  end;
end;

function z3DCore_GetDepthBits(fmt: TD3DFormat): LongWord;
begin
  case fmt of
    D3DFMT_D32F_LOCKABLE,
    D3DFMT_D32: Result:= 32;
    D3DFMT_D24X8,
    D3DFMT_D24S8,
    D3DFMT_D24X4S4,
    D3DFMT_D24FS8: Result:= 24;
    D3DFMT_D16_LOCKABLE,
    D3DFMT_D16: Result:= 16;
    D3DFMT_D15S1: Result:= 15;
  else
    Result:= 0;
  end;
end;

function z3DCore_GetAlphaChannelBits(fmt: TD3DFormat): LongWord;
begin
  case fmt of
    D3DFMT_R8G8B8:        Result:= 0;
    D3DFMT_A8R8G8B8:      Result:= 8;
    D3DFMT_X8R8G8B8:      Result:= 0;
    D3DFMT_R5G6B5:        Result:= 0;
    D3DFMT_X1R5G5B5:      Result:= 0;
    D3DFMT_A1R5G5B5:      Result:= 1;
    D3DFMT_A4R4G4B4:      Result:= 4;
    D3DFMT_R3G3B2:        Result:= 0;
    D3DFMT_A8R3G3B2:      Result:= 8;
    D3DFMT_X4R4G4B4:      Result:= 0;
    D3DFMT_A2B10G10R10:   Result:= 2;
    D3DFMT_A8B8G8R8:      Result:= 8;
    D3DFMT_A2R10G10B10:   Result:= 2;
    D3DFMT_A16B16G16R16:  Result:= 16;
   else Result:= 0;
  end;
end;

function z3DCore_GetColorChannelBits(fmt: TD3DFormat): Integer;
begin
  case fmt of
    D3DFMT_R8G8B8:        Result:= 8;
    D3DFMT_A8R8G8B8:      Result:= 8;
    D3DFMT_X8R8G8B8:      Result:= 8;
    D3DFMT_R5G6B5:        Result:= 5;
    D3DFMT_X1R5G5B5:      Result:= 5;
    D3DFMT_A1R5G5B5:      Result:= 5;
    D3DFMT_A4R4G4B4:      Result:= 4;
    D3DFMT_R3G3B2:        Result:= 2;
    D3DFMT_A8R3G3B2:      Result:= 2;
    D3DFMT_X4R4G4B4:      Result:= 4;
    D3DFMT_A2B10G10R10:   Result:= 10;
    D3DFMT_A8B8G8R8:      Result:= 8;
    D3DFMT_A2R10G10B10:   Result:= 10;
    D3DFMT_A16B16G16R16:  Result:= 16;
    else Result:= 0;
  end;
end;

procedure QSort_int(base: Pointer; width: Integer; compare: QSortCB;
  Left, Right: Integer; TempBuffer, TempBuffer2: Pointer);
var Lo, Hi: Integer;
    P: Pointer;
begin
  Lo := Left;
  Hi := Right;
  P := Pointer(Integer(base) + ((Lo + Hi) div 2)*width);
  Move(P^, TempBuffer2^, width);
  repeat
    while compare(Pointer(Integer(base) + Lo*width), TempBuffer2) < 0 do Inc(Lo);
    while compare(Pointer(Integer(base) + Hi*width), TempBuffer2) > 0 do Dec(Hi);
    if Lo <= Hi then
    begin
      Move(Pointer(Integer(base) + Lo*width)^, TempBuffer^, width);
      Move(Pointer(Integer(base) + Hi*width)^, Pointer(Integer(base) + Lo*width)^, width);
      Move(TempBuffer^,  Pointer(Integer(base) + Hi*width)^, width);
      Inc(Lo);
      Dec(Hi);
    end;
  until Lo > Hi;
  if Hi > Left  then qsort_int(base, width, compare, Left, Hi,  TempBuffer, TempBuffer2);
  if Lo < Right then qsort_int(base, width, compare, Lo, Right, TempBuffer, TempBuffer2);
end;

procedure QSort(base: Pointer; num: Size_t; width: Size_t; compare: QSortCB);
var p, p1: Pointer;
begin
  GetMem(p, width);
  GetMem(p1, width);
  try
    QSort_int(base, width, compare, 0, num - 1, p, p1);
  finally
    FreeMem(p1, width);
    FreeMem(p, width);
  end;
end;

procedure z3DCore_LaunchAppStart;
begin
  TfrmAppStart.Launch;
end;

{ Tz3DDeviceList }

constructor Tz3DDeviceList.Create(const AOwner: Iz3DBase = nil); 
begin
  inherited;
  FD3D:= nil;
  FAcceptDeviceFunc := nil;
  FAcceptDeviceFuncUserContext := nil;
  FRequirePostPixelShaderBlending := True;
  FMinWidth := 640;
  FMinHeight := 480;
  FMaxWidth := $FFFFFFFF;
  FMaxHeight := $FFFFFFFF;
  FRefreshMin := 0;
  FRefreshMax := $FFFFFFFF;
  FMultisampleQualityMax := $FFFF;
  ResetPossibleDepthStencilFormats;
  ResetPossibleMultisampleTypes;
  ResetPossiblePresentIntervals;
  SetPossibleVertexProcessingList(True, True, True, False);
end;

destructor Tz3DDeviceList.Destroy;
begin
  ClearAdapterInfoList;
  inherited;
end;

function SortModesCallback(const arg1, arg2: Pointer): Integer; forward;

function Tz3DDeviceList.Enumerate(pD3D: IDirect3D9 = nil;
  AcceptDeviceFunc: Tz3DCallback_AcceptDevice = nil;
  pAcceptDeviceFuncUserContext: Pointer = nil): HRESULT;
const
  allowedAdapterFormatArray: array[0..3] of TD3DFormat  = (
    D3DFMT_X8R8G8B8,
    D3DFMT_X1R5G5B5,
    D3DFMT_R5G6B5,
    D3DFMT_A2R10G10B10
  );
var
  adapterFormatList: TD3DFormatArray;
  numAdapters: LongWord;
  adapterOrdinal: Integer;
  pAdapterInfo: Iz3DEnumAdapterInfo;
  iFormatList: Integer;
  allowedAdapterFormat: TD3DFormat;
  numAdapterModes: Integer;
  mode: Integer;
  displayMode: TD3DDisplayMode;
  l: Integer;
  bUniqueDesc: Boolean;
  i, j: Integer;
  pAdapterInfo1: Iz3DEnumAdapterInfo;
  pAdapterInfo2: Iz3DEnumAdapterInfo;
  sz: array[0..99] of WideChar;
begin
  try
    if (pD3D = nil) then
    begin
      pD3D := z3DCore_GetD3DObject;
      if (pD3D = nil) then
      begin
        Result:= z3DERR_NODIRECT3D;
        Exit;
      end;
    end;
    FD3D := pD3D;
    FAcceptDeviceFunc := AcceptDeviceFunc;
    FAcceptDeviceFuncUserContext := pAcceptDeviceFuncUserContext;
    ClearAdapterInfoList;
    numAdapters := pD3D.GetAdapterCount;
    for adapterOrdinal := 0 to numAdapters - 1 do
    begin
      pAdapterInfo:= Tz3DEnumAdapterInfo.Create;
      pAdapterInfo.AdapterOrdinal:= AdapterOrdinal;
      pD3D.GetAdapterIdentifier(adapterOrdinal, 0, pAdapterInfo.AdapterIdentifier^);
      adapterFormatList:= nil;
      for iFormatList := 0 to High(allowedAdapterFormatArray) do
      begin
        allowedAdapterFormat := allowedAdapterFormatArray[iFormatList];
        numAdapterModes := pD3D.GetAdapterModeCount(adapterOrdinal, allowedAdapterFormat);
        for mode := 0 to numAdapterModes - 1 do
        begin
          pD3D.EnumAdapterModes(adapterOrdinal, allowedAdapterFormat, mode, displayMode);
          if (displayMode.Width < FMinWidth) or
             (displayMode.Height < FMinHeight) or
             (displayMode.Width > FMaxWidth) or
             (displayMode.Height > FMaxHeight) or
             (displayMode.RefreshRate < FRefreshMin) or
             (displayMode.RefreshRate > FRefreshMax)
          then Continue;
          l:= Length(pAdapterInfo.displayModeList^);
          SetLength(pAdapterInfo.DisplayModeList^, l+1);
          pAdapterInfo.displayModeList^[l]:= displayMode;
          if not DynArrayContains(adapterFormatList, displayMode.Format, SizeOf(displayMode.Format)) then
          begin
            l:= Length(adapterFormatList);
            SetLength(adapterFormatList, l+1);
            adapterFormatList[l]:= displayMode.Format;
          end;
        end;
      end;
      pD3D.GetAdapterDisplayMode(adapterOrdinal, displayMode);
      if not DynArrayContains(adapterFormatList, displayMode.Format, SizeOf(displayMode.Format)) then
      begin
        l:= Length(adapterFormatList);
        SetLength(adapterFormatList, l+1);
        adapterFormatList[l]:= displayMode.Format;
      end;
      QSort(Pointer(pAdapterInfo.displayModeList^), Length(pAdapterInfo.displayModeList^),
      SizeOf(TD3DDisplayMode), SortModesCallback);
      if FAILED(EnumerateDevices(pAdapterInfo, adapterFormatList)) then
      begin
        pAdapterInfo:= nil;
        Continue;
      end;
      if (Length(pAdapterInfo.deviceInfoList^) > 0) then
      begin
        l:= Length(FAdapterInfoList);
        SetLength(FAdapterInfoList, l+1);
        FAdapterInfoList[l]:= pAdapterInfo;
      end else
      pAdapterInfo:= nil;
    end;
    bUniqueDesc := true;
    for i:= 0 to Length(FAdapterInfoList) - 1 do
    begin
      pAdapterInfo1 := FAdapterInfoList[i];
      for j:= i+1 to Length(FAdapterInfoList) - 1 do
      begin
        pAdapterInfo2 := FAdapterInfoList[j];
        if (AnsiCompareText(pAdapterInfo1.AdapterIdentifier.Description,
        pAdapterInfo2.AdapterIdentifier.Description) = 0) then
        begin
          bUniqueDesc := False;
          Break;
        end;
      end;
      if not bUniqueDesc then Break;
    end;
    for i:= 0 to Length(FAdapterInfoList) - 1 do
    begin
      pAdapterInfo := FAdapterInfoList[I];
      MultiByteToWideChar(CP_ACP, 0, pAdapterInfo.AdapterIdentifier.Description, -1,
      pAdapterInfo.UniqueDescription^, 100);
      pAdapterInfo.UniqueDescription^[100] := #0;
      if not bUniqueDesc then
      begin
        StringCchFormat(sz, 100, ' (#%d)', [pAdapterInfo.AdapterOrdinal]);
        StringCchCat(pAdapterInfo.UniqueDescription^, 256, sz);
      end;
    end;
    Result:= S_OK;
  except
    on EOutOfMemory do
    begin
      Result:= E_OUTOFMEMORY;
      Exit;
    end;
  end;
end;

function Tz3DDeviceList.EnumerateDevices(pAdapterInfo: Iz3DEnumAdapterInfo;
  pAdapterFormatList: TD3DFormatArray): HRESULT;
const
  devTypeArray: array[0..2] of TD3DDevType = (
    D3DDEVTYPE_HAL,
    D3DDEVTYPE_SW,
    D3DDEVTYPE_REF
  );
var
  iDeviceType: Integer;
  pDeviceInfo: Tz3DEnumDeviceInfo;
  l: Integer;
  Mode: TD3DDisplayMode;
  pp: TD3DPresentParameters;
  pDevice: IDirect3DDevice9;
begin
  for iDeviceType := 0 to High(devTypeArray) do
  begin
    try
      pDeviceInfo := Tz3DEnumDeviceInfo.Create;
    except
      Result:= E_OUTOFMEMORY;
      Exit;
    end;
    pDeviceInfo.DeviceType := devTypeArray[iDeviceType];
    Result:= FD3D.GetDeviceCaps(pAdapterInfo.AdapterOrdinal, pDeviceInfo.DeviceType,
                                  pDeviceInfo.FCaps);
    if FAILED(Result) then
    begin
      pDeviceInfo:= nil;
      Continue;
    end;
    FD3D.GetAdapterDisplayMode(0, Mode);
    ZeroMemory(@pp, SizeOf(pp));
    pp.BackBufferWidth  := 1;
    pp.BackBufferHeight := 1;
    pp.BackBufferFormat := Mode.Format;
    pp.BackBufferCount  := 1;
    pp.SwapEffect       := D3DSWAPEFFECT_COPY;
    pp.Windowed         := True;
    pp.hDeviceWindow    := z3DCore_GetHWNDFocus;
    Result := FD3D.CreateDevice(pAdapterInfo.AdapterOrdinal, pDeviceInfo.DeviceType, z3DCore_GetHWNDFocus,
                              D3DCREATE_HARDWARE_VERTEXPROCESSING, @pp, pDevice);
    if FAILED(Result) then
    begin
      if (Result = D3DERR_NOTAVAILABLE) then
      begin
        pDeviceInfo:= nil;
        Continue;
      end;
    end;
    pDevice := nil;
    Result := EnumerateDeviceCombos(pAdapterInfo, pDeviceInfo, pAdapterFormatList);
    if FAILED(Result) then
    begin
      pDeviceInfo:= nil;
      Continue;
    end;
    if (Length(pDeviceInfo.DeviceSettingsComboList^) > 0) then
    begin
      l:= Length(pAdapterInfo.DeviceInfoList^);
      SetLength(pAdapterInfo.DeviceInfoList^, l+1);
      pAdapterInfo.deviceInfoList^[l]:= pDeviceInfo;
    end else
    pDeviceInfo:= nil;
  end;
  Result:= S_OK;
end;

function Tz3DDeviceList.EnumerateDeviceCombos(pAdapterInfo: Iz3DEnumAdapterInfo;
  pDeviceInfo: Iz3DEnumDeviceInfo; pAdapterFormatList: TD3DFormatArray): HRESULT;
const
  backBufferFormatArray: array[0..5] of TD3DFormat = (
    D3DFMT_A8R8G8B8,
    D3DFMT_X8R8G8B8,
    D3DFMT_A2R10G10B10,
    D3DFMT_R5G6B5,
    D3DFMT_A1R5G5B5,
    D3DFMT_X1R5G5B5
  );
var
  iFormat: Integer;
  adapterFormat: TD3DFormat;
  iBackBufferFormat: Integer;
  backBufferFormat: TD3DFormat;
  nWindowed: Integer;
  pDeviceCombo: PD3DDeviceSettingsCombinations;
  l: Integer;
begin
  try
    for iFormat:= 0 to Length(pAdapterFormatList) - 1 do
    begin
      adapterFormat := pAdapterFormatList[iFormat];
      for iBackBufferFormat := 0 to High(backBufferFormatArray) do
      begin
        backBufferFormat := backBufferFormatArray[iBackBufferFormat];
        for nWindowed := 0 to 1 do
        begin
          if (nWindowed = 0) and (Length(pAdapterInfo.DisplayModeList^) = 0)
          then Continue;
          if FAILED(FD3D.CheckDeviceType(pAdapterInfo.AdapterOrdinal, pDeviceInfo.DeviceType,
                                           adapterFormat, backBufferFormat, nWindowed <> 0))
          then Continue;
          if FRequirePostPixelShaderBlending then
          begin
            if FAILED(FD3D.CheckDeviceFormat(pAdapterInfo.AdapterOrdinal, pDeviceInfo.DeviceType,
                                               adapterFormat, D3DUSAGE_QUERY_POSTPIXELSHADER_BLENDING,
                                               D3DRTYPE_TEXTURE, backBufferFormat))
            then Continue;
          end;
          if (@FAcceptDeviceFunc <> nil) then
          begin
            if (not FAcceptDeviceFunc(pDeviceInfo.Caps, adapterFormat, backBufferFormat, nWindowed <> 0, FAcceptDeviceFuncUserContext))
            then Continue;
          end;
          New(pDeviceCombo);
          pDeviceCombo.AdapterOrdinal := pAdapterInfo.AdapterOrdinal;
          pDeviceCombo.DeviceType := pDeviceInfo.DeviceType;
          pDeviceCombo.AdapterFormat := adapterFormat;
          pDeviceCombo.BackBufferFormat := backBufferFormat;
          pDeviceCombo.Windowed := (nWindowed <> 0);
          BuildDepthStencilFormatList(pDeviceCombo);
          BuildMultiSampleTypeList(pDeviceCombo);
          if Length(pDeviceCombo.multiSampleTypeList) = 0 then
          begin
            Dispose(pDeviceCombo);
            Continue;
          end;
          BuildDSMSConflictList(pDeviceCombo);
          BuildPresentIntervalList(pDeviceInfo, pDeviceCombo);
          pDeviceCombo.AdapterInfo := pAdapterInfo;
          pDeviceCombo.DeviceInfo := pDeviceInfo;
          l:= Length(pDeviceInfo.DeviceSettingsComboList^);
          SetLength(pDeviceInfo.DeviceSettingsComboList^, l+1);
          pDeviceInfo.DeviceSettingsComboList^[l]:= pDeviceCombo;
        end;
      end;
    end;
    Result:= S_OK;
  except
    on EOutOfMemory do
    begin
      Result:= E_OUTOFMEMORY;
      Exit;
    end;
  end;
end;

procedure Tz3DDeviceList.BuildDepthStencilFormatList(pDeviceCombo: PD3DDeviceSettingsCombinations);
var
  depthStencilFmt: TD3DFormat;
  idsf, l: Integer;
begin
  for idsf := 0 to Length(FDepthStecilPossibleList) - 1 do
  begin
    depthStencilFmt := FDepthStecilPossibleList[idsf];
    if SUCCEEDED(FD3D.CheckDeviceFormat(pDeviceCombo.AdapterOrdinal,
         pDeviceCombo.DeviceType, pDeviceCombo.AdapterFormat,
         D3DUSAGE_DEPTHSTENCIL, D3DRTYPE_SURFACE, depthStencilFmt)) then
    begin
      if SUCCEEDED(FD3D.CheckDepthStencilMatch(pDeviceCombo.AdapterOrdinal,
           pDeviceCombo.DeviceType, pDeviceCombo.AdapterFormat,
           pDeviceCombo.BackBufferFormat, depthStencilFmt)) then
      begin
        l:= Length(pDeviceCombo.depthStencilFormatList);
        SetLength(pDeviceCombo.depthStencilFormatList, l+1);
        pDeviceCombo.depthStencilFormatList[l]:= depthStencilFmt;
      end;
    end;
  end;
end;

procedure Tz3DDeviceList.BuildMultiSampleTypeList(pDeviceCombo: PD3DDeviceSettingsCombinations);
var
  msType: TD3DMultiSampleType;
  msQuality: DWORD;
  imst, l: Integer;
begin
  for imst := 0 to Length(FMultiSampleTypeList) - 1 do
  begin
    msType := FMultiSampleTypeList[imst];
    if SUCCEEDED(FD3D.CheckDeviceMultiSampleType(pDeviceCombo.AdapterOrdinal,
         pDeviceCombo.DeviceType, pDeviceCombo.BackBufferFormat,
         pDeviceCombo.Windowed, msType, @msQuality)) then
    begin
      l:= Length(pDeviceCombo.multiSampleTypeList);
      SetLength(pDeviceCombo.multiSampleTypeList, l+1);
      pDeviceCombo.multiSampleTypeList[l]:= msType;
      if (msQuality > FMultisampleQualityMax+1) then msQuality := FMultisampleQualityMax+1;
      l:= Length(pDeviceCombo.multiSampleQualityList);
      SetLength(pDeviceCombo.multiSampleQualityList, l+1);
      pDeviceCombo.multiSampleQualityList[l]:= msQuality;
    end;
  end;
end;

procedure Tz3DDeviceList.BuildDSMSConflictList(pDeviceCombo: PD3DDeviceSettingsCombinations);
var
  DSMSConflict: Tz3DEnumDSMSConflict;
  iDS, iMS, l: Integer;
  dsFmt: TD3DFormat;
  msType: TD3DMultiSampleType;
begin
  for iDS:=0 to Length(pDeviceCombo.depthStencilFormatList) - 1 do
  begin
    dsFmt := pDeviceCombo.depthStencilFormatList[iDS];
    for iMS:= 0 to Length(pDeviceCombo.multiSampleTypeList) - 1 do
    begin
      msType := pDeviceCombo.multiSampleTypeList[iMS];
      if FAILED(FD3D.CheckDeviceMultiSampleType(pDeviceCombo.AdapterOrdinal, pDeviceCombo.DeviceType,
      dsFmt, pDeviceCombo.Windowed, msType, nil)) then
      begin
        DSMSConflict.DSFormat := dsFmt;
        DSMSConflict.MSType := msType;
        l:= Length(pDeviceCombo.DSMSConflictList);
        SetLength(pDeviceCombo.DSMSConflictList, l+1);
        pDeviceCombo.DSMSConflictList[l]:= DSMSConflict;
      end;
    end;
  end;
end;

procedure Tz3DDeviceList.BuildPresentIntervalList(pDeviceInfo: Iz3DEnumDeviceInfo;
  pDeviceCombo: PD3DDeviceSettingsCombinations);
var
  pi: LongWord;
  ipi, l: Integer;
begin
  for ipi := 0 to Length(FPresentIntervalList) - 1 do
  begin
    pi := FPresentIntervalList[ipi];
    if pDeviceCombo.Windowed then
    begin
      if (pi = D3DPRESENT_INTERVAL_TWO) or
      (pi = D3DPRESENT_INTERVAL_THREE) or
      (pi = D3DPRESENT_INTERVAL_FOUR) then Continue;
    end;
    if (pi = D3DPRESENT_INTERVAL_DEFAULT) or
    (pDeviceInfo.Caps.PresentationIntervals and pi <> 0) then
    begin
      l:= Length(pDeviceCombo.presentIntervalList);
      SetLength(pDeviceCombo.presentIntervalList, l+1);
      pDeviceCombo.presentIntervalList[l]:= pi;
    end;
  end;
end;

procedure Tz3DDeviceList.ClearAdapterInfoList;
var
  i: Integer;
begin
  for i:= 0 to Length(FAdapterInfoList) - 1 do
    FAdapterInfoList[i]:= nil;
  FAdapterInfoList:= nil;
end;

function Tz3DDeviceList.GetAdapterInfoList: Tz3DEnumAdapterInfoArray;
begin
  Result:= FAdapterInfoList;
end;

function Tz3DDeviceList.GetAdapterInfo(AdapterOrdinal: LongWord): Iz3DEnumAdapterInfo;
var
  iAdapter: Integer;
begin
  for iAdapter:= 0 to Length(FAdapterInfoList) - 1 do
  begin
    if (FAdapterInfoList[iAdapter].AdapterOrdinal = AdapterOrdinal) then
    begin
      Result:= FAdapterInfoList[iAdapter];
      Exit;
    end;
  end;
  Result:= nil;
end;

function Tz3DDeviceList.GetDeviceInfo(AdapterOrdinal: LongWord;
  DeviceType: TD3DDevType): Iz3DEnumDeviceInfo;
var
  pAdapterInfo: Iz3DEnumAdapterInfo;
  iDeviceInfo: Integer;
begin
  pAdapterInfo := GetAdapterInfo(AdapterOrdinal);
  if (pAdapterInfo <> nil) then
  begin
    for iDeviceInfo:= 0 to Length(pAdapterInfo.DeviceInfoList^) - 1 do
    begin
      if (pAdapterInfo.DeviceInfoList^[iDeviceInfo].DeviceType = DeviceType) then
      begin
        Result:= pAdapterInfo.DeviceInfoList^[iDeviceInfo];
        Exit;
      end;
    end;
  end;
  Result:= nil;
end;

function Tz3DDeviceList.GetDeviceSettingsCombo(const pDeviceSettings: Tz3DDeviceSettings): PD3DDeviceSettingsCombinations;
begin
  with pDeviceSettings do
  Result:= GetDeviceSettingsCombo(AdapterOrdinal, DeviceType, AdapterFormat,
  PresentParams.BackBufferFormat, PresentParams.Windowed);
end;

function Tz3DDeviceList.GetDeviceSettingsCombo(AdapterOrdinal: LongWord;
  DeviceType: TD3DDevType; AdapterFormat, BackBufferFormat: TD3DFormat;
  Windowed: Boolean): PD3DDeviceSettingsCombinations;
var
  pDeviceInfo: Iz3DEnumDeviceInfo;
  iDeviceCombo: Integer;
  pDeviceSettingsCombo: PD3DDeviceSettingsCombinations;
begin
  pDeviceInfo := GetDeviceInfo(AdapterOrdinal, DeviceType);
  if (pDeviceInfo <> nil) then
  begin
    for iDeviceCombo:= 0 to Length(pDeviceInfo.DeviceSettingsComboList^) - 1 do
    begin
      pDeviceSettingsCombo := pDeviceInfo.DeviceSettingsComboList^[iDeviceCombo];
      if (pDeviceSettingsCombo.AdapterFormat = AdapterFormat) and
         (pDeviceSettingsCombo.BackBufferFormat = BackBufferFormat) and
         (pDeviceSettingsCombo.Windowed = Windowed) then
      begin
        Result:= pDeviceSettingsCombo;
        Exit;
      end;
    end;
  end;
  Result:= nil;
end;

procedure Tz3DDeviceList.CleanupDirect3DInterfaces;
begin
  FD3D:= nil;
end;

function SortModesCallback(const arg1, arg2: Pointer): Integer;
var
  pdm1, pdm2: PD3DDisplayMode;
begin
  pdm1 := PD3DDisplayMode(arg1);
  pdm2 := PD3DDisplayMode(arg2);
  if (pdm1.Width > pdm2.Width) then Result:= 1
  else if (pdm1.Width < pdm2.Width) then Result:= -1
  else if (pdm1.Height > pdm2.Height) then Result:= 1
  else if (pdm1.Height < pdm2.Height) then Result:= -1
  else if (pdm1.Format > pdm2.Format) then Result:= 1
  else if (pdm1.Format < pdm2.Format) then Result:= -1
  else if (pdm1.RefreshRate > pdm2.RefreshRate) then Result:= 1
  else if (pdm1.RefreshRate < pdm2.RefreshRate) then Result:= -1
  else Result:= 0;
end;

{ Tz3DEnumAdapterInfo }

destructor Tz3DEnumAdapterInfo.Destroy;
var I: Integer;
begin
  for I:= 0 to Length(FDeviceInfoList)-1 do FDeviceInfoList[I]:= nil;
  FDeviceInfoList:= nil;
  inherited;
end;

function Tz3DEnumAdapterInfo.GetAdapterIdentifier: PD3DAdapterIdentifier9;
begin
  Result:= @FAdapterIdentifier;
end;

function Tz3DEnumAdapterInfo.GetAdapterOrdinal: LongWord;
begin
  Result:= FAdapterOrdinal;
end;

function Tz3DEnumAdapterInfo.GetDeviceInfoList: Pz3DDeviceInfoList;
begin
  Result:= @FDeviceInfoList;
end;

function Tz3DEnumAdapterInfo.GetDisplayModeList: PD3DDisplayModeArray;
begin
  Result:= @FDisplayModeList;
end;

function Tz3DEnumAdapterInfo.GetUniqueDescription: PDescArray;
begin
  Result:= @FUniqueDescription;
end;

procedure Tz3DEnumAdapterInfo.SetAdapterIdentifier(const Value: PD3DAdapterIdentifier9);
begin
  FAdapterIdentifier:= Value^;
end;

procedure Tz3DEnumAdapterInfo.SetAdapterOrdinal(const Value: LongWord);
begin
  FAdapterOrdinal:= Value;
end;

procedure Tz3DEnumAdapterInfo.SetDeviceInfoList(const Value: Pz3DDeviceInfoList);
begin
  FDeviceInfoList:= Value^;
end;

procedure Tz3DEnumAdapterInfo.SetDisplayModeList(const Value: PD3DDisplayModeArray);
begin
  FDisplayModeList:= Value^;
end;

procedure Tz3DEnumAdapterInfo.SetUniqueDescription(const Value: PDescArray);
begin
  FUniqueDescription:= Value^;
end;

{ Tz3DEnumDeviceInfo }

destructor Tz3DEnumDeviceInfo.Destroy;
var
  i: Integer;
begin
  for i:= 0 to Length(FDeviceSettingsComboList) - 1 do FDeviceSettingsComboList[i]:= nil;
  FDeviceSettingsComboList:= nil;
  inherited;
end;

function Tz3DEnumDeviceInfo.GetCaps: TD3DCaps9;
begin
  Result:= FCaps;
end;

function Tz3DEnumDeviceInfo.GetAdapterOrdinal: LongWord;
begin
  Result:= FAdapterOrdinal;
end;

function Tz3DEnumDeviceInfo.GetDeviceSettingsComboList: Pz3DDeviceSettingsComboList;
begin
  Result:= @FDeviceSettingsComboList;
end;

function Tz3DEnumDeviceInfo.GetDeviceType: TD3DDevType;
begin
  Result:= FDeviceType;
end;

procedure Tz3DEnumDeviceInfo.SetAdapterOrdinal(const Value: LongWord);
begin
  FAdapterOrdinal:= Value;
end;

procedure Tz3DEnumDeviceInfo.SetCaps(const Value: TD3DCaps9);
begin
  FCaps:= Value;
end;

procedure Tz3DEnumDeviceInfo.SetDeviceSettingsComboList(const Value: Pz3DDeviceSettingsComboList);
begin
  FDeviceSettingsComboList:= Value^;
end;

procedure Tz3DEnumDeviceInfo.SetDeviceType(const Value: TD3DDevType);
begin
  FDeviceType:= Value;
end;

{ Tz3DDeviceList }

function Tz3DDeviceList.GetPossibleDepthStencilFormats: TD3DFormatArray;
begin
  Result:= FDepthStecilPossibleList;
end;

function Tz3DDeviceList.GetPossibleMultisampleTypes: TD3DMultiSampleTypeArray;
begin
  Result:= FMultiSampleTypeList;
end;

function Tz3DDeviceList.GetPossiblePresentIntervals: TLongWordArray;
begin
  Result:= FPresentIntervalList;
end;

procedure Tz3DDeviceList.SetPossibleDepthStencilFormats(a: TD3DFormatArray);
begin
  FDepthStecilPossibleList:= a;
end;

procedure Tz3DDeviceList.SetPossibleMultisampleTypes(a: TD3DMultiSampleTypeArray);
begin
  FMultiSampleTypeList:= a;
end;

procedure Tz3DDeviceList.SetPossiblePresentIntervals(a: TLongWordArray);
begin
  FPresentIntervalList:= a;
end;

procedure Tz3DDeviceList.ResetPossibleDepthStencilFormats;
begin
  FDepthStecilPossibleList:= nil;
  SetLength(FDepthStecilPossibleList, 6);
  FDepthStecilPossibleList[0]:= D3DFMT_D16;
  FDepthStecilPossibleList[1]:= D3DFMT_D15S1;
  FDepthStecilPossibleList[2]:= D3DFMT_D24X8;
  FDepthStecilPossibleList[3]:= D3DFMT_D24S8;
  FDepthStecilPossibleList[4]:= D3DFMT_D24X4S4;
  FDepthStecilPossibleList[5]:= D3DFMT_D32;
end;

procedure Tz3DDeviceList.ResetPossibleMultisampleTypes;
begin
  FMultiSampleTypeList:= nil;
  SetLength(FMultiSampleTypeList, 17);
  FMultiSampleTypeList[00]:= D3DMULTISAMPLE_NONE;
  FMultiSampleTypeList[01]:= D3DMULTISAMPLE_NONMASKABLE;
  FMultiSampleTypeList[02]:= D3DMULTISAMPLE_2_SAMPLES;
  FMultiSampleTypeList[03]:= D3DMULTISAMPLE_3_SAMPLES;
  FMultiSampleTypeList[04]:= D3DMULTISAMPLE_4_SAMPLES;
  FMultiSampleTypeList[05]:= D3DMULTISAMPLE_5_SAMPLES;
  FMultiSampleTypeList[06]:= D3DMULTISAMPLE_6_SAMPLES;
  FMultiSampleTypeList[07]:= D3DMULTISAMPLE_7_SAMPLES;
  FMultiSampleTypeList[08]:= D3DMULTISAMPLE_8_SAMPLES;
  FMultiSampleTypeList[09]:= D3DMULTISAMPLE_9_SAMPLES;
  FMultiSampleTypeList[10]:= D3DMULTISAMPLE_10_SAMPLES;
  FMultiSampleTypeList[11]:= D3DMULTISAMPLE_11_SAMPLES;
  FMultiSampleTypeList[12]:= D3DMULTISAMPLE_12_SAMPLES;
  FMultiSampleTypeList[13]:= D3DMULTISAMPLE_13_SAMPLES;
  FMultiSampleTypeList[14]:= D3DMULTISAMPLE_14_SAMPLES;
  FMultiSampleTypeList[15]:= D3DMULTISAMPLE_15_SAMPLES;
  FMultiSampleTypeList[16]:= D3DMULTISAMPLE_16_SAMPLES;
end;

procedure Tz3DDeviceList.ResetPossiblePresentIntervals;
begin
  FPresentIntervalList:= nil;
  SetLength(FPresentIntervalList, 6);
  FPresentIntervalList[0]:= D3DPRESENT_INTERVAL_IMMEDIATE;
  FPresentIntervalList[1]:= D3DPRESENT_INTERVAL_DEFAULT;
  FPresentIntervalList[2]:= D3DPRESENT_INTERVAL_ONE;
  FPresentIntervalList[3]:= D3DPRESENT_INTERVAL_TWO;
  FPresentIntervalList[4]:= D3DPRESENT_INTERVAL_THREE;
  FPresentIntervalList[5]:= D3DPRESENT_INTERVAL_FOUR;
end;

procedure Tz3DDeviceList.GetPossibleVertexProcessingList(out pbSoftwareVP,
  pbHardwareVP, pbPureHarewareVP, pbMixedVP: Boolean);
begin
  pbSoftwareVP := FSoftwareVP;
  pbHardwareVP := FHardwareVP;
  pbPureHarewareVP := FPureHarewareVP;
  pbMixedVP := FMixedVP;
end;

procedure Tz3DDeviceList.SetPossibleVertexProcessingList(bSoftwareVP,
  bHardwareVP, bPureHarewareVP, bMixedVP: Boolean);
begin
  FSoftwareVP := bSoftwareVP;
  FHardwareVP := bHardwareVP;
  FPureHarewareVP := bPureHarewareVP;
  FMixedVP := bMixedVP;
end;

procedure Tz3DDeviceList.SetResolutionMinMax(nMinWidth, nMinHeight,
  nMaxWidth, nMaxHeight: LongWord);
begin
  FMinWidth := nMinWidth;
  FMinHeight := nMinHeight;
  FMaxWidth := nMaxWidth;
  FMaxHeight := nMaxHeight;
end;

procedure Tz3DDeviceList.SetRefreshMinMax(nMin, nMax: LongWord);
begin
  FRefreshMin := nMin;
  FRefreshMax := nMax;
end;

procedure Tz3DDeviceList.SetMultisampleQualityMax(nMax: LongWord);
begin
  if (nMax > $FFFF) then nMax := $FFFF;
  FMultisampleQualityMax := nMax;
end;

function Tz3DDeviceList.GetMultisampleQualityMax: LongWord;
begin
  Result:= FMultisampleQualityMax;
end;

function Tz3DDeviceList.GetRequirePostPixelShaderBlending: Boolean;
begin
  Result:= FRequirePostPixelShaderBlending;
end;

procedure Tz3DDeviceList.SetRequirePostPixelShaderBlending(bRequire: Boolean);
begin
  FRequirePostPixelShaderBlending := bRequire;
end;

var g_state: Iz3DState = nil;

function z3DCore_GetState: Iz3DState;
begin
  if (g_state = nil) then g_state:= Tz3DState.Create;
  Result:= g_state;
end;

procedure z3DCore_FreeState;
begin
  g_state:= nil;
end;

const
  z3D_MIN_WINDOW_SIZE_X = 200;
  z3D_MIN_WINDOW_SIZE_Y = 200;

var
  g_cs: TRTLCriticalSection;
  g_bThreadSafe: Boolean = True;

procedure z3DLock;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
begin
  if (g_bThreadSafe) then EnterCriticalSection(g_cs);
end;

procedure z3DUnlock;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
begin
  if (g_bThreadSafe) then LeaveCriticalSection(g_cs);
end;

type
  Tz3DState_STATE = record
    m_D3D: IDirect3D9;                   // the main D3D object
    m_D3DDevice: IDirect3DDevice9;       // the D3D rendering device
    m_D3DDeviceList: Iz3DDeviceList;   // CD3DDeviceList object
    m_CurrentDeviceSettings: Pz3DDeviceSettings;   // current device settings
    m_BackBufferSurfaceDesc: TD3DSurfaceDesc;   // back buffer surface description
    m_Caps: TD3DCaps9;                   // D3D caps for current device
    m_HWNDFocus: HWND;                   // the main app focus window
    m_HWNDDeviceFullScreen: HWND;        // the main app device window in fullscreen mode
    m_HWNDDeviceWindowed: HWND;          // the main app device window in windowed mode
    m_AdapterMonitor: HMONITOR;          // the monitor of the adapter
    m_Menu: HMENU;                       // handle to menu

    m_FullScreenBackBufferWidthAtModeChange: LongWord;  // back buffer size of fullscreen mode right before switching to windowed mode.  Used to restore to same resolution when toggling back to fullscreen
    m_FullScreenBackBufferHeightAtModeChange: LongWord; // back buffer size of fullscreen mode right before switching to windowed mode.  Used to restore to same resolution when toggling back to fullscreen
    m_WindowBackBufferWidthAtModeChange: LongWord;      // back buffer size of windowed mode right before switching to fullscreen mode.  Used to restore to same resolution when toggling back to windowed mode
    m_WindowBackBufferHeightAtModeChange: LongWord;     // back buffer size of windowed mode right before switching to fullscreen mode.  Used to restore to same resolution when toggling back to windowed mode
    m_WindowedStyleAtModeChange: DWORD;  // window style
    m_WindowedPlacement: TWindowPlacement; // record of windowed HWND position/show state/etc
    m_TopmostWhileWindowed: Boolean;     // if true, the windowed HWND is topmost 
    FCursorWatermark: Boolean;           // if true, a watermark with D3D is added to the full screen cursor
    m_Minimized: Boolean;                // if true, the HWND is minimized
    m_Maximized: Boolean;                // if true, the HWND is maximized
    m_MinimizedWhileFullscreen: Boolean; // if true, the HWND is minimized due to a focus switch away when fullscreen mode
    m_IgnoreSizeChange: Boolean;         // if true, z3D won't reset the device upon HWND size change

    m_Time: Double;                      // current time in seconds
    m_AbsoluteTime: Double;              // absolute time in seconds
    m_ElapsedTime: Single;               // time elapsed since last frame
    FStatsUpdateInterval: Single;        // interval for stats update

    m_HInstance: HINST;                  // handle to the app instance
    m_LastStatsUpdateTime: Double;       // last time the stats were updated
    m_LastStatsUpdateFrames: DWORD;      // frames count since last time the stats were updated
    m_FPS: Single;                       // frames per second
    m_CurrentFrameNumber: Integer;       // the current frame number
    m_KeyboardHook: HHOOK;               // handle to keyboard hook
    m_AllowShortcutKeysWhenFullscreen: Boolean; // if true, when fullscreen enable shortcut keys (Windows keys, StickyKeys shortcut, ToggleKeys shortcut, FilterKeys shortcut)
    m_AllowShortcutKeysWhenWindowed: Boolean;   // if true, when windowed enable shortcut keys (Windows keys, StickyKeys shortcut, ToggleKeys shortcut, FilterKeys shortcut)
    m_AllowShortcutKeys: Boolean;        // if true, then shortcut keys are currently disabled (Windows key, etc)
    m_CallDefWindowProc: Boolean;        // if true, z3DStaticWndProc will call DefWindowProc for unhandled messages. Applications rendering to a dialog may need to set this to false.
    m_StartupStickyKeys: TStickyKeys;    // StickyKey settings upon startup so they can be restored later
    m_StartupToggleKeys: TToggleKeys;    // ToggleKey settings upon startup so they can be restored later
    m_StartupFilterKeys: TFilterKeys;    // FilterKey settings upon startup so they can be restored later

    m_HandleDefaultHotkeys: Boolean;     // if true, then z3D will handle some default hotkeys
    m_HandleAltEnter: Boolean;           // if true, then z3D will handle Alt-Enter
    m_ShowMsgBoxOnError: Boolean;        // if true, then msgboxes are displayed upon errors
    m_NoStats: Boolean;                  // if true, then z3DGetFrameStats() and z3DGetDeviceStats() will return blank strings
    m_ClipCursorWhenFullScreen: Boolean; // if true, then z3D will keep the cursor from going outside the window when full screen
    m_ShowCursorWhenFullScreen: Boolean; // if true, then z3D will show a cursor when full screen
    m_ConstantFrameTime: Boolean;        // if true, then elapsed frame time will always be 0.05f seconds which is good for debugging or automated capture
    m_TimePerFrame: Single;              // the constant time per frame in seconds, only valid if m_ConstantFrameTime==true
    m_WireframeMode: Boolean;            // if true, then D3DRS_FILLMODE==D3DFILL_WIREFRAME else D3DRS_FILLMODE==D3DFILL_SOLID
    m_AutoChangeAdapter: Boolean;        // if true, then the adapter will automatically change if the window is different monitor
    m_WindowCreatedWithDefaultPositions: Boolean; // if true, then CW_USEDEFAULT was used and the window should be moved to the right adapter
    m_ExitCode: Integer;                 // the exit code to be returned to the command line

    m_z3DInited: Boolean;               // if true, then z3DInit() has succeeded
    m_WindowCreated: Boolean;            // if true, then z3DCreateWindow() or z3DSetWindow() has succeeded
    m_DeviceCreated: Boolean;            // if true, then z3DCreateDevice*() or z3DSetDevice() has succeeded

    m_z3DInitCalled: Boolean;           // if true, then z3DInit() was called
    m_WindowCreateCalled: Boolean;       // if true, then z3DCreateWindow() or z3DSetWindow() was called
    m_DeviceCreateCalled: Boolean;       // if true, then z3DCreateDevice*() or z3DSetDevice() was called

    m_DeviceObjectsCreated: Boolean;     // if true, then DeviceCreated callback has been called (if non-NULL)
    m_DeviceObjectsReset: Boolean;       // if true, then DeviceReset callback has been called (if non-NULL)
    m_InsideDeviceCallback: Boolean;     // if true, then the engine is inside an app device callback
    m_InsideMainloop: Boolean;           // if true, then the engine is inside the main loop
    m_Active: Boolean;                   // if true, then the app is the active top level window
    m_TimePaused: Boolean;               // if true, then time is paused
    m_RenderingPaused: Boolean;          // if true, then rendering is paused
    m_PauseRenderingCount: Integer;      // pause rendering ref count
    m_PauseTimeCount: Integer;           // pause time ref count
    m_DeviceLost: Boolean;               // if true, then the device is lost and needs to be reset
    m_NotifyOnMouseMove: Boolean;        // if true, include WM_MOUSEMOVE in mousecallback
    m_Automation: Boolean;               // if true, automation is enabled
    m_InSizeMove: Boolean;               // if true, app is inside a WM_ENTERSIZEMOVE

    m_OverrideAdapterOrdinal: Integer;   // if != -1, then override to use this adapter ordinal
    m_OverrideWindowed: Boolean;         // if true, then force to start windowed
    m_OverrideFullScreen: Boolean;       // if true, then force to start full screen
    m_OverrideStartX: Integer;           // if != -1, then override to this X position of the window
    m_OverrideStartY: Integer;           // if != -1, then override to this Y position of the window
    m_OverrideWidth: Integer;            // if != 0, then override to this width
    m_OverrideHeight: Integer;           // if != 0, then override to this height
    m_OverrideForceHAL: Boolean;         // if true, then force to HAL device (failing if one doesn't exist)
    m_OverrideForceREF: Boolean;         // if true, then force to REF device (failing if one doesn't exist)
    m_OverrideForcePureHWVP: Boolean;    // if true, then force to use pure HWVP (failing if device doesn't support it)
    m_OverrideForceHWVP: Boolean;        // if true, then force to use HWVP (failing if device doesn't support it)
    m_OverrideForceSWVP: Boolean;        // if true, then force to use SWVP
    m_OverrideConstantFrameTime: Boolean;// if true, then force to constant frame time
    m_OverrideConstantTimePerFrame: Single; // the constant time per frame in seconds if m_OverrideConstantFrameTime==true
    m_OverrideQuitAfterFrame: Integer;   // if != 0, then it will force the app to quit after that frame
    m_OverrideForceVsync: Integer;       // if == 0, then it will force the app to use D3DPRESENT_INTERVAL_IMMEDIATE, if == 1 force use of D3DPRESENT_INTERVAL_DEFAULT
    m_OverrideRelaunchMCE: Boolean;      // if true, then force relaunch of MCE at exit

    m_AcceptDeviceFunc:    Tz3DCallback_AcceptDevice;   // is device acceptable callback
    m_ModifyDeviceSettingsFunc:  Tz3DCallback_ModifyDeviceSettings; // modify device settings callback
    m_DeviceCreatedFunc:         Tz3DCallback_DeviceCreated;        // device created callback
    m_DeviceResetFunc:           Tz3DCallback_DeviceReset;          // device reset callback
    m_DeviceLostFunc:            Tz3DCallback_DeviceLost;           // device lost callback
    m_DeviceDestroyedFunc:       Tz3DCallback_DeviceDestroyed;      // device destroyed callback
    m_FrameMoveFunc:             Tz3DCallback_FrameMove;            // frame move callback
    m_FrameRenderFunc:           Tz3DCallback_FrameRender;          // frame render callback
    m_KeyboardFunc:              Tz3DCallback_Keyboard;             // keyboard callback
    m_MouseFunc:                 Tz3DCallback_Mouse;                // mouse callback
    m_WindowMsgFunc:             Tz3DCallback_MsgProc;              // window messages callback

    m_AcceptDeviceFuncUserContext:   Pointer; // user context for is device acceptable callback
    m_ModifyDeviceSettingsFuncUserContext: Pointer; // user context for modify device settings callback
    m_DeviceCreatedUserContext:            Pointer; // user context for device created callback
    m_DeviceCreatedFuncUserContext:        Pointer; // user context for device created callback
    m_DeviceResetFuncUserContext:          Pointer; // user context for device reset callback
    m_DeviceLostFuncUserContext:           Pointer; // user context for device lost callback
    m_DeviceDestroyedFuncUserContext:      Pointer; // user context for device destroyed callback
    m_FrameMoveFuncUserContext:            Pointer; // user context for frame move callback
    m_FrameRenderFuncUserContext:          Pointer; // user context for frame render callback
    m_KeyboardFuncUserContext:             Pointer; // user context for keyboard callback
    m_MouseFuncUserContext:                Pointer; // user context for mouse callback
    m_WindowMsgFuncUserContext:            Pointer; // user context for window messages callback

    m_Keys:                      Tz3DKeysArray;                    // array of key state
    m_MouseButtons:              Tz3DMouseButtonsArray;             // array of mouse states

    m_TimerList: Tz3DTimerRecordArray;                                   // list of z3D_TIMER structs
    m_StaticFrameStats: array[0..255] of WideChar;                  // static part of frames stats
    m_FPSStats: array[0..63] of WideChar;                           // fps stats
    m_FrameStats: array[0..255] of WideChar;                        // frame stats (fps, width, etc)
    m_DeviceStats: array[0..255] of WideChar;                       // device stats (description, device type, etc)
    m_WindowTitle: array[0..255] of WideChar;                       // window title

    CurrentApp: array[0..255] of WideChar;     // Current application
  end;

var
  m_state: Tz3DState_STATE;

constructor Tz3DState.Create(const AOwner: Iz3DBase = nil); 
begin
  inherited;
  CreateState;
  Application.OnException:= AppException;
end;

destructor Tz3DState.Destroy;
begin
  DestroyState;
  inherited;
end;

procedure Tz3DState.CreateState;
begin
  z3DCore_GetGlobalResourceCache;
  ZeroMemory(@m_state, SizeOf(m_state));
  g_bThreadSafe := True;
  InitializeCriticalSection(g_cs);
  m_state.m_OverrideStartX := -1;
  m_state.m_OverrideStartY := -1;
  m_state.m_OverrideAdapterOrdinal := -1;
  m_state.m_OverrideForceVsync := 0; // TODO JP: Change to 1 to accept REF device
  m_state.m_AutoChangeAdapter := True;
  m_state.m_ShowMsgBoxOnError := True;
  m_state.FStatsUpdateInterval:= 0.5;
  m_state.FCursorWatermark:= False;
  m_state.m_AllowShortcutKeysWhenWindowed := True;
  m_state.m_Active := True;
  m_state.m_CallDefWindowProc := True;
end;

procedure Tz3DState.DestroyState;
begin
  z3DCore_Shutdown;
  DeleteCriticalSection(g_cs);
end;

function Tz3DState.GetActive: Boolean;
begin
  z3DLock;
  Result:= m_state.m_Active;
  z3DUnlock;
end;

function Tz3DState.GetCurrentApp: PWideChar;
begin
  z3DLock;
  Result:= m_state.CurrentApp;
  z3DUnlock;
end;

function Tz3DState.GetAdapterMonitor: Direct3D9.HMONITOR;
begin
  z3DLock;
  Result:= m_state.m_AdapterMonitor;
  z3DUnlock;
end;

function Tz3DState.GetStatsUpdateInterval: Single;
begin
  z3DLock;
  Result:= m_state.FStatsUpdateInterval;
  z3DUnlock;
end;

function Tz3DState.GetAutoChangeAdapter: Boolean;
begin
  z3DLock;
  Result:= m_state.m_AutoChangeAdapter;
  z3DUnlock;
end;

function Tz3DState.GetBackBufferSurfaceDesc: PD3DSurfaceDesc;
begin
  z3DLock;
  Result:= @m_state.m_BackBufferSurfaceDesc;
  z3DUnlock;
end;

function Tz3DState.GetCaps: PD3DCaps9;
begin
  z3DLock;
  Result:= @m_state.m_Caps;
  z3DUnlock;
end;

function Tz3DState.GetClipCursorWhenFullScreen: Boolean;
begin
  z3DLock;
  Result:= m_state.m_ClipCursorWhenFullScreen;
  z3DUnlock;
end;

function Tz3DState.GetConstantFrameTime: Boolean;
begin
  z3DLock;
  Result:= m_state.m_ConstantFrameTime;
  z3DUnlock;
end;

function Tz3DState.GetCurrentDeviceSettings: Pz3DDeviceSettings;
begin
  z3DLock;
  Result:= m_state.m_CurrentDeviceSettings;
  z3DUnlock;
end;

function Tz3DState.GetCurrentFrameNumber: Integer;
begin
  z3DLock;
  Result:= m_state.m_CurrentFrameNumber;
  z3DUnlock;
end;

function Tz3DState.GetD3D: IDirect3D9;
begin
  z3DLock;
  Result:= m_state.m_D3D;
  z3DUnlock;
end;

function Tz3DState.GetD3DDevice: IDirect3DDevice9;
begin
  z3DLock;
  Result:= m_state.m_D3DDevice;
  z3DUnlock;
end;

function Tz3DState.GeTz3DDeviceList: Iz3DDeviceList;
begin
  z3DLock;
  Result:= m_state.m_D3DDeviceList;
  z3DUnlock;
end;

function Tz3DState.GetDeviceCreateCalled: Boolean;
begin
  z3DLock;
  Result:= m_state.m_DeviceCreateCalled;
  z3DUnlock;
end;

function Tz3DState.GetDeviceCreated: Boolean;
begin
  z3DLock;
  Result:= m_state.m_DeviceCreated;
  z3DUnlock;
end;

function Tz3DState.GetDeviceCreatedFunc: Tz3DCallback_DeviceCreated;
begin
  z3DLock;
  Result:= m_state.m_DeviceCreatedFunc;
  z3DUnlock;
end;

function Tz3DState.GetDeviceDestroyedFunc: Tz3DCallback_DeviceDestroyed;
begin
  z3DLock;
  Result:= m_state.m_DeviceDestroyedFunc;
  z3DUnlock;
end;

function Tz3DState.GetDeviceLost: Boolean;
begin
  z3DLock;
  Result:= m_state.m_DeviceLost;
  z3DUnlock;
end;

function Tz3DState.GetDeviceLostFunc: Tz3DCallback_DeviceLost;
begin
  z3DLock;
  Result:= m_state.m_DeviceLostFunc;
  z3DUnlock;
end;

function Tz3DState.GetDeviceObjectsCreated: Boolean;
begin
  z3DLock;
  Result:= m_state.m_DeviceObjectsCreated;
  z3DUnlock;
end;

function Tz3DState.GetDeviceObjectsReset: Boolean;
begin
  z3DLock;
  Result:= m_state.m_DeviceObjectsReset;
  z3DUnlock;
end;

function Tz3DState.GetDeviceResetFunc: Tz3DCallback_DeviceReset;
begin
  z3DLock;
  Result:= m_state.m_DeviceResetFunc;
  z3DUnlock;
end;

function Tz3DState.GetDeviceStats: PWideChar;
begin
  z3DLock;
  Result:= m_state.m_DeviceStats;
  z3DUnlock;
end;

function Tz3DState.Getz3DInitCalled: Boolean;
begin
  z3DLock;
  Result:= m_state.m_z3DInitCalled;
  z3DUnlock;
end;

function Tz3DState.Getz3DInited: Boolean;
begin
  z3DLock;
  Result:= m_state.m_z3DInited;
  z3DUnlock;
end;

function Tz3DState.GetElapsedTime: Single;
begin
  z3DLock;
  Result:= m_state.m_ElapsedTime;
  z3DUnlock;
end;

function Tz3DState.GetExitCode: Integer;
begin
  z3DLock;
  Result:= m_state.m_ExitCode;
  z3DUnlock;
end;

function Tz3DState.GetFPS: Single;
begin
  z3DLock;
  Result:= m_state.m_FPS;
  z3DUnlock;
end;

function Tz3DState.GetFrameMoveFunc: Tz3DCallback_FrameMove;
begin
  z3DLock;
  Result:= m_state.m_FrameMoveFunc;
  z3DUnlock;
end;

function Tz3DState.GetFrameRenderFunc: Tz3DCallback_FrameRender;
begin
  z3DLock;
  Result:= m_state.m_FrameRenderFunc;
  z3DUnlock;
end;

function Tz3DState.GetFrameStats: PWideChar;
begin
  z3DLock;
  Result:= m_state.m_FrameStats;
  z3DUnlock;
end;

function Tz3DState.GetHandleDefaultHotkeys: Boolean;
begin
  z3DLock;
  Result:= m_state.m_HandleDefaultHotkeys;
  z3DUnlock;
end;

function Tz3DState.GetHWNDFocus: HWND;
begin
  z3DLock;
  Result:= m_state.m_HWNDFocus;
  z3DUnlock;
end;

function Tz3DState.GetHWNDDeviceFullScreen: HWND;
begin
  z3DLock;
  Result:= m_state.m_HWNDDeviceFullScreen;
  z3DUnlock;
end;

function Tz3DState.GetHWNDDeviceWindowed: HWND;
begin
  z3DLock;
  Result:= m_state.m_HWNDDeviceWindowed;
  z3DUnlock;
end;

function Tz3DState.GetIgnoreSizeChange: Boolean;
begin
  z3DLock;
  Result:= m_state.m_IgnoreSizeChange;
  z3DUnlock;
end;

function Tz3DState.GetNotifyOnMouseMove: Boolean;
begin
  z3DLock;
  Result:= m_state.m_NotifyOnMouseMove;
  z3DUnlock;
end;

function Tz3DState.GetInsideDeviceCallback: Boolean;
begin
  z3DLock;
  Result:= m_state.m_InsideDeviceCallback;
  z3DUnlock;
end;

function Tz3DState.GetInsideMainloop: Boolean;
begin
  z3DLock;
  Result:= m_state.m_InsideMainloop;
  z3DUnlock;
end;

function Tz3DState.GetAcceptDeviceFunc: Tz3DCallback_AcceptDevice;
begin
  z3DLock;
  Result:= m_state.m_AcceptDeviceFunc;
  z3DUnlock;
end;

function Tz3DState.GetKeyboardFunc: Tz3DCallback_Keyboard;
begin
  z3DLock;
  Result:= m_state.m_KeyboardFunc;
  z3DUnlock;
end;

function Tz3DState.GetLastStatsUpdateFrames: DWORD;
begin
  z3DLock;
  Result:= m_state.m_LastStatsUpdateFrames;
  z3DUnlock;
end;

function Tz3DState.GetCursorWatermark: Boolean;
begin
  z3DLock;
  Result:= m_state.FCursorWatermark;
  z3DUnlock;
end;

function Tz3DState.GetLastStatsUpdateTime: Double;
begin
  z3DLock;
  Result:= m_state.m_LastStatsUpdateTime;
  z3DUnlock;
end;

function Tz3DState.GetMaximized: Boolean;
begin
  z3DLock;
  Result:= m_state.m_Maximized;
  z3DUnlock;
end;

function Tz3DState.GetMenu: HMENU;
begin
  z3DLock;
  Result:= m_state.m_Menu;
  z3DUnlock;
end;

function Tz3DState.GetMinimized: Boolean;
begin
  z3DLock;
  Result:= m_state.m_Minimized;
  z3DUnlock;
end;

function Tz3DState.GetModifyDeviceSettingsFunc: Tz3DCallback_ModifyDeviceSettings;
begin
  z3DLock;
  Result:= m_state.m_ModifyDeviceSettingsFunc;
  z3DUnlock;
end;

function Tz3DState.GetMouseFunc: Tz3DCallback_Mouse;
begin
  z3DLock;
  Result:= m_state.m_MouseFunc;
  z3DUnlock;
end;

function Tz3DState.GetOverrideAdapterOrdinal: Integer;
begin
  z3DLock;
  Result:= m_state.m_OverrideAdapterOrdinal;
  z3DUnlock;
end;

function Tz3DState.GetOverrideConstantFrameTime: Boolean;
begin
  z3DLock;
  Result:= m_state.m_OverrideConstantFrameTime;
  z3DUnlock;
end;

function Tz3DState.GetOverrideConstantTimePerFrame: Single;
begin
  z3DLock;
  Result:= m_state.m_OverrideConstantTimePerFrame;
  z3DUnlock;
end;

function Tz3DState.GetOverrideForceHAL: Boolean;
begin
  z3DLock;
  Result:= m_state.m_OverrideForceHAL;
  z3DUnlock;
end;

function Tz3DState.GetOverrideForceHWVP: Boolean;
begin
  z3DLock;
  Result:= m_state.m_OverrideForceHWVP;
  z3DUnlock;
end;

function Tz3DState.GetOverrideForcePureHWVP: Boolean;
begin
  z3DLock;
  Result:= m_state.m_OverrideForcePureHWVP;
  z3DUnlock;
end;

function Tz3DState.GetOverrideForceREF: Boolean;
begin
  z3DLock;
  Result:= m_state.m_OverrideForceREF;
  z3DUnlock;
end;

function Tz3DState.GetOverrideForceSWVP: Boolean;
begin
  z3DLock;
  Result:= m_state.m_OverrideForceSWVP;
  z3DUnlock;
end;

function Tz3DState.GetOverrideFullScreen: Boolean;
begin
  z3DLock;
  Result:= m_state.m_OverrideFullScreen;
  z3DUnlock;
end;

function Tz3DState.GetOverrideHeight: Integer;
begin
  z3DLock;
  Result:= m_state.m_OverrideHeight;
  z3DUnlock;
end;

function Tz3DState.GetOverrideQuitAfterFrame: Integer;
begin
  z3DLock;
  Result:= m_state.m_OverrideQuitAfterFrame;
  z3DUnlock;
end;

function Tz3DState.GetOverrideForceVsync: Integer;
begin
  z3DLock;
  Result:= m_state.m_OverrideForceVsync;
  z3DUnlock;
end;

function Tz3DState.GetOverrideStartX: Integer;
begin
  z3DLock;
  Result:= m_state.m_OverrideStartX;
  z3DUnlock;
end;

function Tz3DState.GetOverrideStartY: Integer;
begin
  z3DLock;
  Result:= m_state.m_OverrideStartY;
  z3DUnlock;
end;

function Tz3DState.GetOverrideWidth: Integer;
begin
  z3DLock;
  Result:= m_state.m_OverrideWidth;
  z3DUnlock;
end;

function Tz3DState.GetOverrideWindowed: Boolean;
begin
  z3DLock;
  Result:= m_state.m_OverrideWindowed;
  z3DUnlock;
end;

function Tz3DState.GetPauseRenderingCount: Integer;
begin
  z3DLock;
  Result:= m_state.m_PauseRenderingCount;
  z3DUnlock;
end;

function Tz3DState.GetPauseTimeCount: Integer;
begin
  z3DLock;
  Result:= m_state.m_PauseTimeCount;
  z3DUnlock;
end;

function Tz3DState.GetRenderingPaused: Boolean;
begin
  z3DLock;
  Result:= m_state.m_RenderingPaused;
  z3DUnlock;
end;

function Tz3DState.GetShowCursorWhenFullScreen: Boolean;
begin
  z3DLock;
  Result:= m_state.m_ShowCursorWhenFullScreen;
  z3DUnlock;
end;

function Tz3DState.GetShowMsgBoxOnError: Boolean;
begin
  z3DLock;
  Result:= m_state.m_ShowMsgBoxOnError;
  z3DUnlock;
end;

function Tz3DState.GetNoStats : Boolean;
begin
  z3DLock;
  Result:= m_state.m_NoStats;
  z3DUnlock;
end;

function Tz3DState.GetStaticFrameStats: PWideChar;
begin
  z3DLock;
  Result:= m_state.m_StaticFrameStats;
  z3DUnlock;
end;

function Tz3DState.GetFPSStats: PWideChar;
begin
  z3DLock;
  Result:= m_state.m_FPSStats;
  z3DUnlock;
end;

function Tz3DState.GetTime: Double;
begin
  z3DLock;
  Result:= m_state.m_Time;
  z3DUnlock;
end;

function Tz3DState.GetAbsoluteTime: Double;
begin
  z3DLock;
  Result:= m_state.m_AbsoluteTime;
  z3DUnlock;
end;

function Tz3DState.GetTimePaused: Boolean;
begin
  z3DLock;
  Result:= m_state.m_TimePaused;
  z3DUnlock;
end;

function Tz3DState.GetTimePerFrame: Single;
begin
  z3DLock;
  Result:= m_state.m_TimePerFrame;
  z3DUnlock;
end;

function Tz3DState.GetTimerList: Tz3DTimerRecordArray;
begin
  z3DLock;
  Result:= m_state.m_TimerList;
  z3DUnlock;
end;

function Tz3DState.GetKeys: Pz3DKeysArray;
begin
  z3DLock;
  Result:= @m_state.m_Keys;
  z3DUnlock;
end;

function Tz3DState.GetMouseButtons: Pz3DMouseButtonsArray;
begin
  z3DLock;
  Result:= @m_state.m_MouseButtons;
  z3DUnlock;
end;

function Tz3DState.GetWindowCreateCalled: Boolean;
begin
  z3DLock;
  Result:= m_state.m_WindowCreateCalled;
  z3DUnlock;
end;

function Tz3DState.GetWindowCreated: Boolean;
begin
  z3DLock;
  Result:= m_state.m_WindowCreated;
  z3DUnlock;
end;

function Tz3DState.GetWindowCreatedWithDefaultPositions: Boolean;
begin
  z3DLock;
  Result:= m_state.m_WindowCreatedWithDefaultPositions;
  z3DUnlock;
end;

function Tz3DState.GetWindowMsgFunc: Tz3DCallback_MsgProc;
begin
  z3DLock;
  Result:= m_state.m_WindowMsgFunc;
  z3DUnlock;
end;

function Tz3DState.GetWindowTitle: PWideChar;
begin
  z3DLock;
  Result:= m_state.m_WindowTitle;
  z3DUnlock;
end;

function Tz3DState.GetWireframeMode: Boolean;
begin
  z3DLock;
  Result:= m_state.m_WireframeMode;
  z3DUnlock;
end;


function Tz3DState.GetAllowShortcutKeys: Boolean;
begin
  z3DLock;
  Result:= m_state.m_AllowShortcutKeys;
  z3DUnlock;
end;

function Tz3DState.GetAllowShortcutKeysWhenFullscreen: Boolean;
begin
  z3DLock;
  Result:= m_state.m_AllowShortcutKeysWhenFullscreen;
  z3DUnlock;
end;

function Tz3DState.GetAllowShortcutKeysWhenWindowed: Boolean;
begin
  z3DLock;
  Result:= m_state.m_AllowShortcutKeysWhenWindowed;
  z3DUnlock;
end;

function Tz3DState.GetKeyboardHook: HHOOK;
begin
  z3DLock;
  Result:= m_state.m_KeyboardHook;
  z3DUnlock;
end;

function Tz3DState.GetStartupFilterKeys: TFilterKeys;
begin
  z3DLock;
  Result:= m_state.m_StartupFilterKeys;
  z3DUnlock;
end;

function Tz3DState.GetStartupStickyKeys: TStickyKeys;
begin
  z3DLock;
  Result:= m_state.m_StartupStickyKeys;
  z3DUnlock;
end;

function Tz3DState.GetStartupToggleKeys: TToggleKeys;
begin
  z3DLock;
  Result:= m_state.m_StartupToggleKeys;
  z3DUnlock;
end;

function Tz3DState.GetAutomation: Boolean;
begin
  z3DLock;
  Result:= m_state.m_Automation;
  z3DUnlock;
end;

function Tz3DState.GetDeviceCreatedFuncUserContext: Pointer;
begin
  z3DLock;
  Result:= m_state.m_DeviceCreatedFuncUserContext;
  z3DUnlock;
end;

function Tz3DState.GetDeviceDestroyedFuncUserContext: Pointer;
begin
  z3DLock;
  Result:= m_state.m_DeviceDestroyedFuncUserContext;
  z3DUnlock;
end;

function Tz3DState.GetDeviceLostFuncUserContext: Pointer;
begin
  z3DLock;
  Result:= m_state.m_DeviceLostFuncUserContext;
  z3DUnlock;
end;

function Tz3DState.GetDeviceResetFuncUserContext: Pointer;
begin
  z3DLock;
  Result:= m_state.m_DeviceResetFuncUserContext;
  z3DUnlock;
end;

function Tz3DState.GetFrameMoveFuncUserContext: Pointer;
begin
  z3DLock;
  Result:= m_state.m_FrameMoveFuncUserContext;
  z3DUnlock;
end;

function Tz3DState.GetFrameRenderFuncUserContext: Pointer;
begin
  z3DLock;
  Result:= m_state.m_FrameRenderFuncUserContext;
  z3DUnlock;
end;

function Tz3DState.GetFullScreenBackBufferHeightAtModeChange: LongWord;
begin
  z3DLock;
  Result:= m_state.m_FullScreenBackBufferHeightAtModeChange;
  z3DUnlock;
end;

function Tz3DState.GetFullScreenBackBufferWidthAtModeChange: LongWord;
begin
  z3DLock;
  Result:= m_state.m_FullScreenBackBufferWidthAtModeChange;
  z3DUnlock;
end;

function Tz3DState.GetHInstance: HINST;
begin
  z3DLock;
  Result:= m_state.m_HInstance;
  z3DUnlock;
end;

function Tz3DState.GetInSizeMove: Boolean;
begin
  z3DLock;
  Result:= m_state.m_InSizeMove;
  z3DUnlock;
end;

function Tz3DState.GetAcceptDeviceFuncUserContext: Pointer;
begin
  z3DLock;
  Result:= m_state.m_AcceptDeviceFuncUserContext;
  z3DUnlock;
end;

function Tz3DState.GetKeyboardFuncUserContext: Pointer;
begin
  z3DLock;
  Result:= m_state.m_KeyboardFuncUserContext;
  z3DUnlock;
end;

function Tz3DState.GetMinimizedWhileFullscreen: Boolean;
begin
  z3DLock;
  Result:= m_state.m_MinimizedWhileFullscreen;
  z3DUnlock;
end;

function Tz3DState.GetModifyDeviceSettingsFuncUserContext: Pointer;
begin
  z3DLock;
  Result:= m_state.m_ModifyDeviceSettingsFuncUserContext;
  z3DUnlock;
end;

function Tz3DState.GetMouseFuncUserContext: Pointer;
begin
  z3DLock;
  Result:= m_state.m_MouseFuncUserContext;
  z3DUnlock;
end;

function Tz3DState.GetWindowBackBufferHeightAtModeChange: LongWord;
begin
  z3DLock;
  Result:= m_state.m_WindowBackBufferHeightAtModeChange;
  z3DUnlock;
end;

function Tz3DState.GetWindowBackBufferWidthAtModeChange: LongWord;
begin
  z3DLock;
  Result:= m_state.m_WindowBackBufferWidthAtModeChange;
  z3DUnlock;
end;

function Tz3DState.GetWindowedPlacement: PWindowPlacement;
begin
  z3DLock;
  Result:= @m_state.m_WindowedPlacement;
  z3DUnlock;
end;

function Tz3DState.GetWindowedStyleAtModeChange: DWORD;
begin
  z3DLock;
  Result:= m_state.m_WindowedStyleAtModeChange;
  z3DUnlock;
end;

function Tz3DState.GetTopmostWhileWindowed: Boolean;
begin
  z3DLock;
  Result:= m_state.m_TopmostWhileWindowed;
  z3DUnlock;
end;

function Tz3DState.GetWindowMsgFuncUserContext: Pointer;
begin
  z3DLock;
  Result:= m_state.m_WindowMsgFuncUserContext;
  z3DUnlock;
end;

function Tz3DState.GetCallDefWindowProc: Boolean;
begin
  z3DLock;
  Result:= m_state.m_CallDefWindowProc;
  z3DUnlock;
end;

function Tz3DState.GetHandleAltEnter: Boolean;
begin
  z3DLock;
  Result:= m_state.m_HandleAltEnter;
  z3DUnlock;
end;

procedure Tz3DState.SetActive(const Value: Boolean);
begin
  z3DLock;
  m_state.m_Active:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetCurrentApp(const Value: PWideChar);
begin
  z3DLock;
  StringCchCopy(m_state.CurrentApp, 255, Value);
  z3DUnlock;
end;

procedure Tz3DState.SetStatsUpdateInterval(const Value: Single);
begin
  z3DLock;
  m_state.FStatsUpdateInterval:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetAdapterMonitor(const Value: Direct3D9.HMONITOR);
begin
  z3DLock;
  m_state.m_AdapterMonitor:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetAutoChangeAdapter(const Value: Boolean);
begin
  z3DLock;                 
  m_state.m_AutoChangeAdapter:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetBackBufferSurfaceDesc(
  const Value: PD3DSurfaceDesc);
begin
  z3DLock;
  m_state.m_BackBufferSurfaceDesc:= Value^;
  z3DUnlock;
end;

procedure Tz3DState.SetCaps(const Value: PD3DCaps9);
begin
  z3DLock;
  m_state.m_Caps:= Value^;
  z3DUnlock;
end;

procedure Tz3DState.SetClipCursorWhenFullScreen(const Value: Boolean);
begin
  z3DLock;
  m_state.m_ClipCursorWhenFullScreen:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetConstantFrameTime(const Value: Boolean);
begin
  z3DLock;
  m_state.m_ConstantFrameTime:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetCurrentDeviceSettings(
  const Value: Pz3DDeviceSettings);
begin
  z3DLock;
  m_state.m_CurrentDeviceSettings:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetCurrentFrameNumber(const Value: Integer);
begin
  z3DLock;
  m_state.m_CurrentFrameNumber:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetD3D(const Value: IDirect3D9);
begin
  z3DLock;
  m_state.m_D3D:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetD3DDevice(const Value: IDirect3DDevice9);
begin
  z3DLock;
  m_state.m_D3DDevice:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SeTz3DDeviceList(const Value: Iz3DDeviceList);
begin
  z3DLock;
  m_state.m_D3DDeviceList:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetDeviceCreateCalled(const Value: Boolean);
begin
  z3DLock;
  m_state.m_DeviceCreateCalled:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetDeviceCreated(const Value: Boolean);
begin
  z3DLock;
  m_state.m_DeviceCreated:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetDeviceCreatedFunc(
  const Value: Tz3DCallback_DeviceCreated);
begin
  z3DLock;
  m_state.m_DeviceCreatedFunc:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetDeviceDestroyedFunc(
  const Value: Tz3DCallback_DeviceDestroyed);
begin
  z3DLock;
  m_state.m_DeviceDestroyedFunc:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetDeviceLost(const Value: Boolean);
begin
  z3DLock;
  m_state.m_DeviceLost:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetDeviceLostFunc(
  const Value: Tz3DCallback_DeviceLost);
begin
  z3DLock;
  m_state.m_DeviceLostFunc:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetDeviceObjectsCreated(const Value: Boolean);
begin
  z3DLock;
  m_state.m_DeviceObjectsCreated:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetDeviceObjectsReset(const Value: Boolean);
begin
  z3DLock;
  m_state.m_DeviceObjectsReset:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetDeviceResetFunc(
  const Value: Tz3DCallback_DeviceReset);
begin
  z3DLock;
  m_state.m_DeviceResetFunc:= Value;
  z3DUnlock;
end;

procedure Tz3DState.Setz3DInitCalled(const Value: Boolean);
begin
  z3DLock;
  m_state.m_z3DInitCalled:= Value;
  z3DUnlock;
end;

procedure Tz3DState.Setz3DInited(const Value: Boolean);
begin
  z3DLock;
  m_state.m_z3DInited:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetElapsedTime(const Value: Single);
begin
  z3DLock;
  m_state.m_ElapsedTime:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetExitCode(const Value: Integer);
begin
  z3DLock;
  m_state.m_ExitCode:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetFPS(const Value: Single);
begin
  z3DLock;
  m_state.m_FPS:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetFrameMoveFunc(const Value: Tz3DCallback_FrameMove);
begin
  z3DLock;
  m_state.m_FrameMoveFunc:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetFrameRenderFunc(
  const Value: Tz3DCallback_FrameRender);
begin
  z3DLock;
  m_state.m_FrameRenderFunc:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetHandleDefaultHotkeys(const Value: Boolean);
begin
  z3DLock;
  m_state.m_HandleDefaultHotkeys:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetHWNDFocus(const Value: HWND);
begin
  z3DLock;
  m_state.m_HWNDFocus:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetHWNDDeviceFullScreen(const Value: HWND);
begin
  z3DLock;
  m_state.m_HWNDDeviceFullScreen:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetHWNDDeviceWindowed(const Value: HWND);
begin
  z3DLock;
  m_state.m_HWNDDeviceWindowed:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetIgnoreSizeChange(const Value: Boolean);
begin
  z3DLock;
  m_state.m_IgnoreSizeChange:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetNotifyOnMouseMove(const Value: Boolean);
begin
  z3DLock;
  m_state.m_NotifyOnMouseMove:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetInsideDeviceCallback(const Value: Boolean);
begin
  z3DLock;
  m_state.m_InsideDeviceCallback:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetInsideMainloop(const Value: Boolean);
begin
  z3DLock;
  m_state.m_InsideMainloop:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetAcceptDeviceFunc(
  const Value: Tz3DCallback_AcceptDevice);
begin
  z3DLock;
  m_state.m_AcceptDeviceFunc:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetKeyboardFunc(const Value: Tz3DCallback_Keyboard);
begin
  z3DLock;
  m_state.m_KeyboardFunc:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetLastStatsUpdateFrames(const Value: DWORD);
begin
  z3DLock;
  m_state.m_LastStatsUpdateFrames:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetLastStatsUpdateTime(const Value: Double);
begin
  z3DLock;
  m_state.m_LastStatsUpdateTime:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetMaximized(const Value: Boolean);
begin
  z3DLock;
  m_state.m_Maximized:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetMenu(const Value: HMENU);
begin
  z3DLock;
  m_state.m_Menu:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetMinimized(const Value: Boolean);
begin
  z3DLock;
  m_state.m_Minimized:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetModifyDeviceSettingsFunc(
  const Value: Tz3DCallback_ModifyDeviceSettings);
begin
  z3DLock;
  m_state.m_ModifyDeviceSettingsFunc:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetMouseFunc(const Value: Tz3DCallback_Mouse);
begin
  z3DLock;
  m_state.m_MouseFunc:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideAdapterOrdinal(const Value: Integer);
begin
  z3DLock;
  m_state.m_OverrideAdapterOrdinal:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideConstantFrameTime(const Value: Boolean);
begin
  z3DLock;
  m_state.m_OverrideConstantFrameTime:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideConstantTimePerFrame(const Value: Single);
begin
  z3DLock;
  m_state.m_OverrideConstantTimePerFrame:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideForceHAL(const Value: Boolean);
begin
  z3DLock;
  m_state.m_OverrideForceHAL:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideForceHWVP(const Value: Boolean);
begin
  z3DLock;
  m_state.m_OverrideForceHWVP:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideForcePureHWVP(const Value: Boolean);
begin
  z3DLock;
  m_state.m_OverrideForcePureHWVP:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideForceREF(const Value: Boolean);
begin
  z3DLock;
  m_state.m_OverrideForceREF:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideForceSWVP(const Value: Boolean);
begin
  z3DLock;
  m_state.m_OverrideForceSWVP:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideFullScreen(const Value: Boolean);
begin
  z3DLock;
  m_state.m_OverrideFullScreen:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideHeight(const Value: Integer);
begin
  z3DLock;
  m_state.m_OverrideHeight:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideQuitAfterFrame(const Value: Integer);
begin
  z3DLock;
  m_state.m_OverrideQuitAfterFrame:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideForceVsync(const Value: Integer);
begin
  z3DLock;
  m_state.m_OverrideForceVsync:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideRelaunchMCE(const Value: Boolean);
begin
  z3DLock;
  m_state.m_OverrideRelaunchMCE:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideStartX(const Value: Integer);
begin
  z3DLock;
  m_state.m_OverrideStartX:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideStartY(const Value: Integer);
begin
  z3DLock;
  m_state.m_OverrideStartY:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideWidth(const Value: Integer);
begin
  z3DLock;
  m_state.m_OverrideWidth:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetOverrideWindowed(const Value: Boolean);
begin
  z3DLock;
  m_state.m_OverrideWindowed:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetPauseRenderingCount(const Value: Integer);
begin
  z3DLock;
  m_state.m_PauseRenderingCount:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetPauseTimeCount(const Value: Integer);
begin
  z3DLock;
  m_state.m_PauseTimeCount:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetRenderingPaused(const Value: Boolean);
begin
  z3DLock;
  m_state.m_RenderingPaused:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetShowCursorWhenFullScreen(const Value: Boolean);
begin
  z3DLock;
  m_state.m_ShowCursorWhenFullScreen:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetShowMsgBoxOnError(const Value: Boolean);
begin
  z3DLock;
  m_state.m_ShowMsgBoxOnError:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetNoStats(const Value: Boolean);
begin
  z3DLock;
  m_state.m_NoStats:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetTime(const Value: Double);
begin
  z3DLock;
  m_state.m_Time:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetAbsoluteTime(const Value: Double);
begin
  z3DLock;
  m_state.m_AbsoluteTime:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetTimePaused(const Value: Boolean);
begin
  z3DLock;
  m_state.m_TimePaused:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetTimePerFrame(const Value: Single);
begin
  z3DLock;
  m_state.m_TimePerFrame:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetTimerList(const Value: Tz3DTimerRecordArray);
begin
  z3DLock;
  m_state.m_TimerList:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetWindowCreateCalled(const Value: Boolean);
begin
  z3DLock;
  m_state.m_WindowCreateCalled:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetWindowCreated(const Value: Boolean);
begin
  z3DLock;
  m_state.m_WindowCreated:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetWindowCreatedWithDefaultPositions(
  const Value: Boolean);
begin
  z3DLock;
  m_state.m_WindowCreatedWithDefaultPositions:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetWindowMsgFunc(const Value: Tz3DCallback_MsgProc);
begin
  z3DLock;
  m_state.m_WindowMsgFunc:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetWireframeMode(const Value: Boolean);
begin
  z3DLock;
  m_state.m_WireframeMode:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetAllowShortcutKeys(const Value: Boolean);
begin
  z3DLock;
  m_state.m_AllowShortcutKeys:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetAllowShortcutKeysWhenFullscreen(
  const Value: Boolean);
begin
  z3DLock;
  m_state.m_AllowShortcutKeysWhenFullscreen:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetAllowShortcutKeysWhenWindowed(
  const Value: Boolean);
begin
  z3DLock;
  m_state.m_AllowShortcutKeysWhenWindowed:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetKeyboardHook(const Value: HHOOK);
begin
  z3DLock;
  m_state.m_KeyboardHook:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetStartupFilterKeys(const Value: TFilterKeys);
begin
  z3DLock;
  m_state.m_StartupFilterKeys:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetStartupStickyKeys(const Value: TStickyKeys);
begin
  z3DLock;
  m_state.m_StartupStickyKeys:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetStartupToggleKeys(const Value: TToggleKeys);
begin
  z3DLock;
  m_state.m_StartupToggleKeys:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetAutomation(const Value: Boolean);
begin
  z3DLock;
  m_state.m_Automation:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetDeviceCreatedFuncUserContext(const Value: Pointer);
begin
  z3DLock;
  m_state.m_DeviceCreatedFuncUserContext:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetDeviceDestroyedFuncUserContext(
  const Value: Pointer);
begin
  z3DLock;
  m_state.m_DeviceDestroyedFuncUserContext:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetDeviceLostFuncUserContext(const Value: Pointer);
begin
  z3DLock;
  m_state.m_DeviceLostFuncUserContext:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetDeviceResetFuncUserContext(const Value: Pointer);
begin
  z3DLock;
  m_state.m_DeviceResetFuncUserContext:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetFrameMoveFuncUserContext(const Value: Pointer);
begin
  z3DLock;
  m_state.m_FrameMoveFuncUserContext:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetFrameRenderFuncUserContext(const Value: Pointer);
begin
  z3DLock;
  m_state.m_FrameRenderFuncUserContext:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetFullScreenBackBufferHeightAtModeChange(
  const Value: LongWord);
begin
  z3DLock;
  m_state.m_FullScreenBackBufferHeightAtModeChange:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetFullScreenBackBufferWidthAtModeChange(
  const Value: LongWord);
begin
  z3DLock;
  m_state.m_FullScreenBackBufferWidthAtModeChange:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetHInstance(const Value: HINST);
begin
  z3DLock;
  m_state.m_HInstance:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetInSizeMove(const Value: Boolean);
begin
  z3DLock;
  m_state.m_InSizeMove:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetAcceptDeviceFuncUserContext(
  const Value: Pointer);
begin
  z3DLock;
  m_state.m_AcceptDeviceFuncUserContext:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetKeyboardFuncUserContext(const Value: Pointer);
begin
  z3DLock;
  m_state.m_KeyboardFuncUserContext:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetMinimizedWhileFullscreen(const Value: Boolean);
begin
  z3DLock;
  m_state.m_MinimizedWhileFullscreen:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetModifyDeviceSettingsFuncUserContext(
  const Value: Pointer);
begin
  z3DLock;
  m_state.m_ModifyDeviceSettingsFuncUserContext:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetMouseFuncUserContext(const Value: Pointer);
begin
  z3DLock;
  m_state.m_MouseFuncUserContext:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetWindowBackBufferHeightAtModeChange(
  const Value: LongWord);
begin
  z3DLock;
  m_state.m_WindowBackBufferHeightAtModeChange:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetWindowBackBufferWidthAtModeChange(
  const Value: LongWord);
begin
  z3DLock;
  m_state.m_WindowBackBufferWidthAtModeChange:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetWindowedPlacement(const Value: PWindowPlacement);
begin
  z3DLock;
  m_state.m_WindowedPlacement:= Value^;
  z3DUnlock;
end;

procedure Tz3DState.SetWindowedStyleAtModeChange(const Value: DWORD);
begin
  z3DLock;
  m_state.m_WindowedStyleAtModeChange:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetCursorWatermark(const Value: Boolean);
begin
  z3DLock;
  m_state.FCursorWatermark:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetTopmostWhileWindowed(const Value: Boolean);
begin
  z3DLock;
  m_state.m_TopmostWhileWindowed:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetWindowMsgFuncUserContext(const Value: Pointer);
begin
  z3DLock;
  m_state.m_WindowMsgFuncUserContext:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetCallDefWindowProc(const Value: Boolean);
begin
  z3DLock;
  m_state.m_CallDefWindowProc:= Value;
  z3DUnlock;
end;

procedure Tz3DState.SetHandleAltEnter(const Value: Boolean);
begin
  z3DLock;
  m_state.m_HandleAltEnter:= Value;
  z3DUnlock;
end;



function z3DMapButtonToArrayIndex(vButton: Byte): Integer; forward;
procedure z3DSetProcessorAffinity; forward;
procedure z3DParseCommandLine; forward;
function z3DPrepareDeviceListObject(bEnumerate: Boolean = False): Iz3DDeviceList; forward;
procedure z3DBuildOptimalDeviceSettings(pOptimalDeviceSettings: Pz3DDeviceSettings; pDeviceSettingsIn: Pz3DDeviceSettings; pMatchOptions: Pz3DMatchOptions); forward;
function z3DDoesDeviceComboMatchPreserveOptions(pDeviceSettingsCombo: PD3DDeviceSettingsCombinations; pDeviceSettingsIn: Pz3DDeviceSettings; pMatchOptions: Pz3DMatchOptions): Boolean; forward;
function z3DRankDeviceCombo(pDeviceSettingsCombo: PD3DDeviceSettingsCombinations; pOptimalDeviceSettings: Pz3DDeviceSettings; pAdapterDesktopDisplayMode: PD3DDisplayMode): Single; forward;
procedure z3DBuildValidDeviceSettings(out pValidDeviceSettings: Tz3DDeviceSettings; const pBestDeviceSettingsCombo: TD3DDeviceSettingsCombinations; pDeviceSettingsIn: Pz3DDeviceSettings; pMatchOptions: Pz3DMatchOptions); forward;

function z3DFindValidResolution(const pBestDeviceSettingsCombo: TD3DDeviceSettingsCombinations; displayModeIn: TD3DDisplayMode; out pBestDisplayMode: TD3DDisplayMode): HRESULT; forward;
function z3DFindAdapterFormat(AdapterOrdinal: LongWord; DeviceType: TD3DDevType; BackBufferFormat: TD3DFormat; Windowed: Boolean; out pAdapterFormat: TD3DFormat): HRESULT; forward;
function z3DChangeDevice(pNewDeviceSettings: Pz3DDeviceSettings; pd3dDeviceFromApp: IDirect3DDevice9; bForceRecreate: Boolean; bClipWindowToSingleAdapter: Boolean): HRESULT; forward;
procedure z3DUpdateDeviceSettingsWithOverrides(out pDeviceSettings: Tz3DDeviceSettings); forward;
function z3DCreate3DEnvironment(const pd3dDeviceFromApp: IDirect3DDevice9): HRESULT; forward;
function z3DReset3DEnvironment: HRESULT; forward;
procedure z3DCleanup3DEnvironment(bReleaseSettings: Boolean = True); forward;
procedure z3DUpdateFrameStats; forward;
procedure z3DUpdateDeviceStats(DeviceType: TD3DDevType; BehaviorFlags: DWORD; const pAdapterIdentifier: TD3DAdapterIdentifier9); forward;
procedure z3DUpdateStaticFrameStats; forward;
procedure z3DCheckForWindowSizeChange; forward;
procedure z3DCheckForWindowChangingMonitors; forward;
procedure z3DHandleTimers; forward;
function z3DIsNextArg(var strCmdLine: PAnsiChar; strArg: PAnsiChar): Boolean; forward;
function z3DGetCmdParam(var strCmdLine: PAnsiChar; out strFlag: PAnsiChar): Boolean; forward;
function z3DGetAdapterOrdinalFromMonitor(hMonitor: HMONITOR; out pAdapterOrdinal: LongWord): HRESULT; forward;
procedure z3DAllowShortcutKeys(bAllowKeys: Boolean); forward;
procedure z3DUpdateBackBufferDesc; forward;
procedure z3DSetupCursor; forward;
function z3DSetDeviceCursor(const pd3dDevice: IDirect3DDevice9; hCursor: HCURSOR; bAddWatermark: Boolean): HRESULT; forward;


procedure z3DCore_SetCallback_DeviceCreated(pCallbackDeviceCreated: Tz3DCallback_DeviceCreated; pUserContext: Pointer);
begin
  z3DCore_GetState.SetDeviceCreatedFunc(pCallbackDeviceCreated);
  z3DCore_GetState.SetDeviceCreatedFuncUserContext(pUserContext);
end;

procedure z3DCore_SetCallback_DeviceReset(pCallbackDeviceReset: Tz3DCallback_DeviceReset; pUserContext: Pointer);
begin
  z3DCore_GetState.SetDeviceResetFunc(pCallbackDeviceReset);
  z3DCore_GetState.SetDeviceResetFuncUserContext(pUserContext);
end;

procedure z3DCore_SetCallback_DeviceLost(pCallbackDeviceLost: Tz3DCallback_DeviceLost; pUserContext: Pointer);
begin
  z3DCore_GetState.SetDeviceLostFunc(pCallbackDeviceLost);
  z3DCore_GetState.SetDeviceLostFuncUserContext(pUserContext);
end;

procedure z3DCore_SetCallback_DeviceDestroyed(pCallbackDeviceDestroyed: Tz3DCallback_DeviceDestroyed; pUserContext: Pointer);
begin
  z3DCore_GetState.SetDeviceDestroyedFunc(pCallbackDeviceDestroyed);
  z3DCore_GetState.SetDeviceDestroyedFuncUserContext(pUserContext);
end;

procedure z3DCore_SetCallback_DeviceChanging(pCallbackModifyDeviceSettings: Tz3DCallback_ModifyDeviceSettings; pUserContext: Pointer);
begin
  z3DCore_GetState.SetModifyDeviceSettingsFunc(pCallbackModifyDeviceSettings);
  z3DCore_GetState.SetModifyDeviceSettingsFuncUserContext(pUserContext);
end;

procedure z3DCore_SetCallback_FrameMove(pCallbackFrameMove: Tz3DCallback_FrameMove; pUserContext: Pointer);
begin
  z3DCore_GetState.SetFrameMoveFunc(pCallbackFrameMove);
  z3DCore_GetState.SetFrameMoveFuncUserContext(pUserContext);
end;

procedure z3DCore_SetCallback_FrameRender(pCallbackFrameRender: Tz3DCallback_FrameRender; pUserContext: Pointer);
begin
  z3DCore_GetState.SetFrameRenderFunc(pCallbackFrameRender);
  z3DCore_GetState.SetFrameRenderFuncUserContext(pUserContext);
end;

procedure z3DCore_SetCallback_Keyboard(pCallbackKeyboard: Tz3DCallback_Keyboard; pUserContext: Pointer);
begin
  z3DCore_GetState.SetKeyboardFunc(pCallbackKeyboard);
  z3DCore_GetState.SetKeyboardFuncUserContext(pUserContext);
end;

procedure z3DCore_SetCallback_Mouse(pCallbackMouse: Tz3DCallback_Mouse; bIncludeMouseMove: Boolean; pUserContext: Pointer);
begin
  with z3DCore_GetState do
  begin
    SetMouseFunc(pCallbackMouse);
    SetNotifyOnMouseMove(bIncludeMouseMove);
  end;
end;

procedure z3DCore_SetCallback_MsgProc(pCallbackMsgProc: Tz3DCallback_MsgProc; pUserContext: Pointer);
begin
  z3DCore_GetState.SetWindowMsgFunc(pCallbackMsgProc);
  z3DCore_GetState.SetWindowMsgFuncUserContext(pUserContext);
end;

////////////////////////////////////////////////////////////////////////////////
// Note about the z3D Command line parameters                                 //
////////////////////////////////////////////////////////////////////////////////
// Possible command line parameters are:                                      //
////////////////////////////////////////////////////////////////////////////////
//    -adapter:#            forces app to use this adapter # (fails if the    //
//                          adapter doesn't exist)                            //
//    -windowed             forces app to start windowed                      //
//    -fullscreen           forces app to start full screen                   //
//    -forcehal             forces app to use HAL (fails if HAL doesn't       //
//                          exist)                                            //
//    -forceref             forces app to use REF (fails if REF doesn't       //
//                          exist)                                            //
//    -forcepurehwvp        forces app to use pure HWVP (fails if device      //
//                          doesn't support it)                               //
//    -forcehwvp            forces app to use HWVP (fails if device doesn't   //
//                          support it)                                       //
//    -forceswvp            forces app to use SWVP                            //
//    -forcevsync:#         if # is 0, forces app to use                      //
//                          D3DPRESENT_INTERVAL_IMMEDIATE otherwise force use //
//                          of D3DPRESENT_INTERVAL_DEFAULT                    //
//    -width:#              forces app to use # for width. for full screen,   //
//                          it will pick the closest possible supported mode  //
//    -height:#             forces app to use # for height. for full screen,  //
//                          it will pick the closest possible supported mode  //
//    -startx:#             forces app to use # for the x coord of the window //
//                          position for windowed mode                        //
//    -starty:#             forces app to use # for the y coord of the window //
//                          position for windowed mode                        //
//    -constantframetime:#  forces app to use constant frame time, where # is //
//                          the time/frame in seconds                         //
//    -quitafterframe:x     forces app to quit after # frames                 //
//    -noerrormsgboxes      prevents the display of message boxes generated   //
//                          by the engine so the application can be run       //
//                          without user interaction                          //
//    -nostats              prevents the display of the stats                 //
//    -automation           every Cz3DDialog created will have                //
//                          EnableKeyboardInput(true) called, enabling UI     //
//                          navigation with keyboard                          //
//                          This is useful when automating application        //
//                          testing.                                          //
////////////////////////////////////////////////////////////////////////////////
// Hotkeys handled by default are:                                            //
////////////////////////////////////////////////////////////////////////////////
//    Alt-Enter           toggle between full screen & windowed (hotkey       //
//                        always enabled)                                     //
//    ESC                 exit app                                            //
//    F3                  toggle HAL/REF                                      //
//    F8                  toggle wire-frame mode                              //
//    Pause               pause time                                          //
////////////////////////////////////////////////////////////////////////////////

function z3DInit(bParseCommandLine: Boolean = True; bHandleDefaultHotkeys: Boolean = True;
  bShowMsgBoxOnError: Boolean = True; bHandleAltEnter: Boolean = True): HRESULT;
var
  sk: TStickyKeys;
  tk: TToggleKeys;
  fk: TFilterKeys;
  pD3D: IDirect3D9;
begin
  z3DCore_GetState.Setz3DInitCalled(True);
//  InitCommonControls;
  FillChar(sk, SizeOf(sk), 0); sk.cbSize:= SizeOf(sk);
  SystemParametersInfo(SPI_GETSTICKYKEYS, SizeOf(sk), @sk, 0);
  z3DCore_GetState.SetStartupStickyKeys(sk);
  FillChar(tk, SizeOf(tk), 0); tk.cbSize:= SizeOf(tk);
  SystemParametersInfo(SPI_GETTOGGLEKEYS, SizeOf(tk), @tk, 0);
  z3DCore_GetState.SetStartupToggleKeys(tk);
  FillChar(fk, SizeOf(fk), 0); fk.cbSize:= SizeOf(fk);
  SystemParametersInfo(SPI_GETFILTERKEYS, SizeOf(fk), @fk, 0);
  z3DCore_GetState.SetStartupFilterKeys(fk);
  timeBeginPeriod(1);
  z3DCore_GetState.SetShowMsgBoxOnError(bShowMsgBoxOnError);
  z3DCore_GetState.SetHandleDefaultHotkeys(bHandleDefaultHotkeys);
  z3DCore_GetState.SetHandleAltEnter(bHandleAltEnter);
  if bParseCommandLine and not z3DCore_GetState.z3DInited then z3DParseCommandLine;

  // Check DirectX version
  if not D3DXCheckVersion(D3D_SDK_VERSION, D3DX_SDK_VERSION) then
  begin
    z3DDisplayErrorMessage(z3DERR_INCORRECTVERSION);
    Result:= z3DError('D3DXCheckVersion', z3DERR_INCORRECTVERSION);
    Exit;
  end;

  // Test device creation
  pD3D := z3DCore_GetD3DObject;
  if (pD3D = nil) then
  begin
    pD3D := z3DCreateDynamicDirect3D9(D3D_SDK_VERSION);
    z3DCore_GetState.D3D := pD3D;
  end;
  if (pD3D = nil) then
  begin
    z3DDisplayErrorMessage(z3DERR_NODIRECT3D);
    Result:= z3DError('Direct3DCreate9', z3DERR_NODIRECT3D);
    Exit;
  end;

  // Check if current app is valid
  if z3DFileSystemController <> nil then
  if (WideCharToString(z3DCore_GetState.CurrentApp) = '') or not
  DirectoryExists(z3DFileSystemController.GetFullPath(z3DCore_GetState.CurrentApp)) then
  z3DCore_LaunchAppStart;

  // Reset timers and init app
  z3DCore_GetGlobalTimer.Reset;
  z3DCore_GetState.z3DInited := True;
  Result:= S_OK;
end;

procedure z3DSetProcessorAffinity;
var
  hCurrentProcess: THandle;
  dwProcessAffinityMask: DWORD_PTR;
  dwSystemAffinityMask: DWORD_PTR;
  dwAffinityMask: DWORD_PTR;
  hCurrentThread: THandle;
begin
  hCurrentProcess := GetCurrentProcess;
  dwProcessAffinityMask := 0;
  dwSystemAffinityMask := 0;
  if GetProcessAffinityMask(hCurrentProcess, dwProcessAffinityMask, dwSystemAffinityMask) and
     (dwProcessAffinityMask <> 0) then
  begin
    dwAffinityMask := (dwProcessAffinityMask and ((not dwProcessAffinityMask) + 1 ));
    hCurrentThread := GetCurrentThread;
    if (INVALID_HANDLE_VALUE <> hCurrentThread) then
    begin
      SetThreadAffinityMask(hCurrentThread, dwAffinityMask);
      CloseHandle(hCurrentThread);
    end;
  end;
  CloseHandle(hCurrentProcess);
end;

procedure z3DParseCommandLine;
var
  S: PWideChar;
  strCmdLine: PAnsiChar;
  strFlag: PAnsiChar;
  nNumArgs: Integer;
  iArg: Integer;
  nAdapter: Integer;
  nOn: Integer;
  nWidth, nHeight: Integer;
  nX, nY: Integer;
  fTimePerFrame: Single;
  nFrame: Integer;
  strSpace: PAnsiChar;
begin
  nNumArgs:= ParamCount;
  GetMem(S, 255);
  try
    for iArg:= 1 to nNumArgs do
    begin
      StringToWideChar(ParamStr(iArg), S, 255);
      strCmdLine := PAnsiChar(ParamStr(iArg));
      if (strCmdLine^ = '/') or (strCmdLine^ = '-') then
      begin
        Inc(strCmdLine);

        if z3DIsNextArg(strCmdLine, 'adapter') then
        begin
          if z3DGetCmdParam(strCmdLine, strFlag) then
          begin
            nAdapter := StrToInt(strFlag);
            z3DCore_GetState.OverrideAdapterOrdinal := nAdapter;
            Continue;
          end;
        end;
        if z3DIsNextArg(strCmdLine, 'windowed') then
        begin
          z3DCore_GetState.OverrideWindowed := True;
          Continue;
        end;
        if z3DIsNextArg(strCmdLine, 'fullscreen') then
        begin
          z3DCore_GetState.OverrideFullScreen := True;
          Continue;
        end;
        if z3DIsNextArg(strCmdLine, 'forcehal') then
        begin
          z3DCore_GetState.OverrideForceHAL := True;
          Continue;
        end;
        if z3DIsNextArg(strCmdLine,'forceref') then
        begin
          z3DCore_GetState.OverrideForceREF := True;
          Continue;
        end;
        if z3DIsNextArg(strCmdLine, 'forcepurehwvp') then
        begin
          z3DCore_GetState.OverrideForcePureHWVP := True;
          Continue;
        end;
        if z3DIsNextArg(strCmdLine, 'forcehwvp') then
        begin
          z3DCore_GetState.OverrideForceHWVP := True;
          Continue;
        end;
        if z3DIsNextArg(strCmdLine, 'forceswvp') then
        begin
          z3DCore_GetState.OverrideForceSWVP := True;
          Continue;
        end;
        if z3DIsNextArg(strCmdLine, 'forcevsync') then
        begin
          if z3DGetCmdParam(strCmdLine, strFlag) then
          begin
            nOn := StrToInt(strFlag);
            z3DCore_GetState.OverrideForceVsync := nOn;
            Continue;
          end;
        end;
        if z3DIsNextArg(strCmdLine, 'width') then
        begin
          if z3DGetCmdParam(strCmdLine, strFlag) then
          begin
            nWidth := StrToInt(strFlag);
            z3DCore_GetState.OverrideWidth := nWidth;
            Continue;
          end;
        end;
        if z3DIsNextArg(strCmdLine, 'app') then
        begin
          if z3DGetCmdParam(strCmdLine, strFlag) then
          begin
            StringToWideChar(strFlag, z3DCore_GetState.CurrentApp, 255);
            Continue;
          end;
        end;
        if z3DIsNextArg(strCmdLine, 'height') then
        begin
          if z3DGetCmdParam(strCmdLine, strFlag) then
          begin
            nHeight := StrToInt(strFlag);
            z3DCore_GetState.OverrideHeight := nHeight;
            Continue;
          end;
        end;
        if z3DIsNextArg(strCmdLine, 'startx') then
        begin
          if z3DGetCmdParam(strCmdLine, strFlag) then
          begin
            nX := StrToInt(strFlag);
            z3DCore_GetState.OverrideStartX := nX;
            Continue;
          end;
        end;
        if z3DIsNextArg(strCmdLine, 'starty') then
        begin
          if z3DGetCmdParam(strCmdLine, strFlag) then
          begin
            nY := StrToInt(strFlag);
            z3DCore_GetState.OverrideStartY := nY;
            Continue;
          end;
        end;
        if z3DIsNextArg(strCmdLine, 'constantframetime') then
        begin
          if z3DGetCmdParam(strCmdLine, strFlag)
          then fTimePerFrame := StrToFloat(strFlag)
          else fTimePerFrame := 0.0333;
          z3DCore_GetState.OverrideConstantFrameTime := True;
          z3DCore_GetState.OverrideConstantTimePerFrame := fTimePerFrame;
          z3DCore_SetConstantFrameTime(True, fTimePerFrame);
          Continue;
        end;
        if z3DIsNextArg(strCmdLine, 'quitafterframe') then
        begin
          if z3DGetCmdParam(strCmdLine, strFlag) then
          begin
            nFrame := StrToInt(strFlag);
            z3DCore_GetState.OverrideQuitAfterFrame := nFrame;
            Continue;
          end;
        end;
        if z3DIsNextArg(strCmdLine, 'noerrormsgboxes') then
        begin
          z3DCore_GetState.ShowMsgBoxOnError := False;
          Continue;
        end;
        if z3DIsNextArg(strCmdLine, 'nostats') then
        begin
          z3DCore_GetState.NoStats := True;
          Continue;
        end;
        if z3DIsNextArg(strCmdLine, 'automation') then
        begin
          z3DCore_GetState.Automation := True;
          Continue;
        end;
      end;
      strFlag := strCmdLine;
      strSpace := PAnsiChar(strFlag);
      while (strSpace^ <> #0) and (strSpace^ > ' ') do Inc(strSpace);
      strSpace^ := #0;
      z3DTrace(PWideChar(WideString('z3DParseCommandLine: Unknown parameter: '+strFlag)));
    end;
  finally
    FreeMem(S);
  end;
end;

function z3DIsNextArg(var strCmdLine: PAnsiChar; strArg: PAnsiChar): Boolean;
var
  nArgLen: Integer;
  nCmdLen: Integer;
begin
  nArgLen := StrLen(strArg);
  nCmdLen := StrLen(strCmdLine);
  if (nCmdLen >= nArgLen) and
     (StrLIComp(strCmdLine, strArg, nArgLen) = 0) and
     ((strCmdLine[nArgLen] = #0) or (strCmdLine[nArgLen] = ':')) then
  begin
    Inc(strCmdLine, nArgLen);
    Result:= True;
    Exit;
  end;
  Result:= False;
end;

function z3DGetCmdParam(var strCmdLine: PAnsiChar; out strFlag: PAnsiChar): Boolean;
var
  strFlagBuf: array[0..255] of AnsiChar;
  strSpace: PChar;
begin
  if (strCmdLine^ = ':') then
  begin
    Inc(strCmdLine);
    StringCchCopy(strFlagBuf, 256, strCmdLine);
    strSpace := strFlagBuf;
    while (strSpace^ <> #0) and (strSpace^ > ' ') do Inc(strSpace);
    strSpace^ := #0;
    strFlag := strFlagBuf;
    Inc(strCmdLine, Length(strFlag));
    Result:= True;
  end else
  begin
    strFlag := '';
    Result:= False;
  end;
end;

function z3DCore_CreateWindow(const strWindowTitle: PWideChar = nil;
                          hInstance: LongWord = 0; hIcon: HICON = 0; hMenu: HMENU = 0;
                          x: Integer = Integer(CW_USEDEFAULT); y: Integer = Integer(CW_USEDEFAULT)): HRESULT;
var
  szExePath: array[0..MAX_PATH-1] of WideChar;
  dwError: DWORD;
  rc: TRect;
  nDefaultWidth: Integer;
  nDefaultHeight: Integer;
  strCachedWindowTitle: PWideChar;
  hWnd: Windows.HWND;
  wndClass: TWndClassW;
begin
  if z3DCore_GetState.InsideDeviceCallback then
  begin
    Result:= z3DErrorMessage('z3DCreateWindow', E_FAIL);
    Exit;
  end;
  z3DCore_GetState.WindowCreateCalled:= True;
  if not z3DCore_GetState.z3DInited then
  begin
    if z3DCore_GetState.z3DInitCalled then
    begin
      Result:= E_FAIL;
      Exit;
    end;
    Result := z3DInit;
    if FAILED(Result) then Exit;
  end;
  if (z3DCore_GetHWNDFocus = 0) then
  begin
    if (hInstance = 0) then hInstance := GetModuleHandle(nil);
    z3DCore_GetState.SetHInstance(hInstance);
    GetModuleFileNameW(0, szExePath, MAX_PATH);
    if (hIcon = 0) then
      hIcon := ExtractIconW(hInstance, szExePath, 0);
    FillChar(wndClass, SizeOf(wndClass), 0);
    wndClass.style := CS_DBLCLKS;
    wndClass.lpfnWndProc := @z3DCore_StaticWndProc;
    wndClass.cbClsExtra := 0;
    wndClass.cbWndExtra := 0;
    wndClass.hInstance := hInstance;
    wndClass.hIcon := hIcon;
    wndClass.hCursor := LoadCursor(0, IDC_ARROW);
    wndClass.hbrBackground := GetStockObject(BLACK_BRUSH);
    wndClass.lpszMenuName := nil;
    wndClass.lpszClassName := 'z3DWindowClass';
    if (Windows.RegisterClassW(wndClass) = 0) then
    begin
      dwError := GetLastError;
      if (dwError <> ERROR_CLASS_ALREADY_EXISTS) then
      begin
        Result:= z3DErrorMessage('RegisterClass', HRESULT((dwError and $0000FFFF) or (FACILITY_WIN32 shl 16))); // HRESULT_FROM_WIN32(dwError));
        Exit;
      end;
    end;
    if (z3DCore_GetState.OverrideStartX <> -1) then
      x := z3DCore_GetState.OverrideStartX;
    if (z3DCore_GetState.OverrideStartY <> -1) then
      y := z3DCore_GetState.OverrideStartY;
    z3DCore_GetState.WindowCreatedWithDefaultPositions:= False;
    if (DWORD(x) = CW_USEDEFAULT) and (DWORD(y) = CW_USEDEFAULT) then
      z3DCore_GetState.WindowCreatedWithDefaultPositions:= True;
    nDefaultWidth := 640;
    nDefaultHeight := 480;
    if (z3DCore_GetState.OverrideWidth <> 0) then
      nDefaultWidth := z3DCore_GetState.OverrideWidth;
    if (z3DCore_GetState.OverrideHeight <> 0) then
      nDefaultHeight := z3DCore_GetState.OverrideHeight;
    SetRect(rc, 0, 0, nDefaultWidth, nDefaultHeight);
    AdjustWindowRect(rc, WS_OVERLAPPEDWINDOW, (hMenu <> 0));

    strCachedWindowTitle := z3DCore_GetState.WindowTitle;
    StringCchCopy(strCachedWindowTitle, 256, strWindowTitle);
    hWnd := CreateWindowW('z3DWindowClass', strCachedWindowTitle, WS_OVERLAPPEDWINDOW,
                         x, y, (rc.right-rc.left), (rc.bottom-rc.top), 0,
                         hMenu, hInstance, nil);
    if (hWnd = 0) then
    begin
      dwError := GetLastError;
      Result:= z3DErrorMessage('CreateWindow', HRESULT((dwError and $0000FFFF) or (FACILITY_WIN32 shl 16))); // HRESULT_FROM_WIN32(dwError));
      Exit;
    end;
    z3DCore_GetState.WindowCreated := True;
    z3DCore_GetState.SetHWNDFocus(hWnd);
    z3DCore_GetState.SetHWNDDeviceFullScreen(hWnd);
    z3DCore_GetState.SetHWNDDeviceWindowed(hWnd);
  end;
  Result:= S_OK;
end;

function z3DCore_SetWindow(hWndFocus, hWndDeviceFullScreen, hWndDeviceWindowed: HWND;
  bHandleMessages: Boolean = True): HRESULT;
var
  nResult: LONG_PTR;
  strCachedWindowTitle: PWideChar;
  dwError: DWORD;
  hInstance: HINST;
begin
  if (z3DCore_GetState.GetInsideDeviceCallback) then
  begin
    Result:= z3DErrorMessage('z3DSetWindow', E_FAIL);
    Exit;
  end;
  z3DCore_GetState.SetWindowCreateCalled(True);
  if (hWndFocus = 0) or (hWndDeviceFullScreen = 0) or (hWndDeviceWindowed = 0) then
  begin
    Result:= z3DErrorMessage('z3DSetWindow', E_INVALIDARG);
    Exit;
  end;
  if (bHandleMessages) then
  begin
  {$IFDEF WIN64}
    LONG_PTR nResult = SetWindowLongPtr(hWndFocus, GWLP_WNDPROC, (LONG_PTR)z3DStaticWndProc );
  {$ELSE}
    nResult := SetWindowLong(hWndFocus, GWL_WNDPROC, Integer(@z3DCore_StaticWndProc));
  {$ENDIF}

    dwError := GetLastError;
    if (nResult = 0) then
    begin
      Result:= z3DErrorMessage('SetWindowLongPtr', HRESULT((dwError and $0000FFFF) or (FACILITY_WIN32 shl 16))); // HRESULT_FROM_WIN32(dwError));
      Exit;
    end;
  end;
  if (not z3DCore_GetState.Getz3DInited) then
  begin
    if (z3DCore_GetState.Getz3DInitCalled) then
    begin
      Result:= E_FAIL;
      Exit;
    end;
    Result := z3DInit;
    if FAILED(Result) then Exit;
  end;
  strCachedWindowTitle := z3DCore_GetState.WindowTitle;
  GetWindowTextW(hWndFocus, strCachedWindowTitle, 255);
  strCachedWindowTitle[255] := #0;
  {$IFDEF WIN64}
  hInstance := HINST(LONG_PTR(GetWindowLongPtr(hWndFocus, GWLP_HINSTANCE)));
  {$ELSE}
  hInstance := HINST(LONG_PTR(GetWindowLong(hWndFocus, GWLP_HINSTANCE)));
  {$ENDIF}
  z3DCore_GetState.HInstance := hInstance;
  z3DCore_GetState.WindowCreatedWithDefaultPositions := False;
  z3DCore_GetState.WindowCreated := True;
  z3DCore_GetState.SetHWNDFocus(hWndFocus);
  z3DCore_GetState.SetHWNDDeviceFullScreen(hWndDeviceFullScreen);
  z3DCore_GetState.SetHWNDDeviceWindowed(hWndDeviceWindowed);
  Result:= S_OK;
end;

function z3DCore_CreateDevice(AdapterOrdinal: LongWord = D3DADAPTER_DEFAULT; bWindowed: Boolean = True;
                          nSuggestedWidth: Integer = 0; nSuggestedHeight: Integer = 0;
                          pCallbackAcceptDevice: Tz3DCallback_AcceptDevice = nil;
                          pCallbackModifyDeviceSettings: Tz3DCallback_ModifyDeviceSettings = nil;
                          pUserContext: Pointer = nil): HRESULT;
var
  matchOptions: Tz3DMatchOptions;
  deviceSettings: Tz3DDeviceSettings;
begin
  if z3DCore_GetState.InsideDeviceCallback then
  begin
    Result:= z3DErrorMessage('z3DCreateWindow', E_FAIL);
    Exit;
  end;
  z3DCore_GetState.SetAcceptDeviceFunc(pCallbackAcceptDevice);
  z3DCore_GetState.SetModifyDeviceSettingsFunc(pCallbackModifyDeviceSettings);
  z3DCore_GetState.SetAcceptDeviceFuncUserContext(pUserContext);
  z3DCore_GetState.SetModifyDeviceSettingsFuncUserContext(pUserContext);
  z3DCore_GetState.DeviceCreateCalled:= True;
  if (not z3DCore_GetState.WindowCreated) then
  begin
    if z3DCore_GetState.WindowCreateCalled then
    begin
      Result:= E_FAIL;
      Exit;
    end;
    Result := z3DCore_CreateWindow;
    if FAILED(Result) then Exit;
  end;
  z3DPrepareDeviceListObject(True);
  matchOptions.eAdapterOrdinal     := z3DMT_PRESERVE_INPUT;
  matchOptions.eDeviceType         := z3DMT_IGNORE_INPUT;
  matchOptions.eWindowed           := z3DMT_PRESERVE_INPUT;
  matchOptions.eAdapterFormat      := z3DMT_IGNORE_INPUT;
  matchOptions.eVertexProcessing   := z3DMT_IGNORE_INPUT;
  if bWindowed or ((nSuggestedWidth <> 0) and (nSuggestedHeight <> 0))
    then matchOptions.eResolution  := z3DMT_CLOSEST_TO_INPUT
    else matchOptions.eResolution  := z3DMT_IGNORE_INPUT;
  matchOptions.eBackBufferFormat   := z3DMT_IGNORE_INPUT;
  matchOptions.eBackBufferCount    := z3DMT_IGNORE_INPUT;
  matchOptions.eMultiSample        := z3DMT_IGNORE_INPUT;
  matchOptions.eSwapEffect         := z3DMT_IGNORE_INPUT;
  matchOptions.eDepthFormat        := z3DMT_IGNORE_INPUT;
  matchOptions.eStencilFormat      := z3DMT_IGNORE_INPUT;
  matchOptions.ePresentFlags       := z3DMT_IGNORE_INPUT;
  matchOptions.eRefreshRate        := z3DMT_IGNORE_INPUT;
  matchOptions.ePresentInterval    := z3DMT_IGNORE_INPUT;

  ZeroMemory(@deviceSettings, SizeOf(Tz3DDeviceSettings));
  deviceSettings.AdapterOrdinal      := AdapterOrdinal;
  deviceSettings.PresentParams.Windowed         := bWindowed;
  deviceSettings.PresentParams.BackBufferWidth  := nSuggestedWidth;
  deviceSettings.PresentParams.BackBufferHeight := nSuggestedHeight;
  if (z3DCore_GetState.OverrideWidth <> 0)
  then deviceSettings.PresentParams.BackBufferWidth := z3DCore_GetState.OverrideWidth;
  if (z3DCore_GetState.OverrideHeight <> 0)
  then deviceSettings.PresentParams.BackBufferHeight := z3DCore_GetState.OverrideHeight;
  if (z3DCore_GetState.OverrideAdapterOrdinal <> -1)
  then deviceSettings.AdapterOrdinal := z3DCore_GetState.OverrideAdapterOrdinal;
  if (z3DCore_GetState.OverrideFullScreen) then
  begin
    deviceSettings.PresentParams.Windowed := False;
    if (z3DCore_GetState.OverrideWidth = 0) and (z3DCore_GetState.OverrideHeight = 0)
    then matchOptions.eResolution := z3DMT_IGNORE_INPUT;
  end;
  if (z3DCore_GetState.OverrideWindowed) then
    deviceSettings.PresentParams.Windowed := True;
  if (z3DCore_GetState.OverrideForceHAL) then
  begin
    deviceSettings.DeviceType := D3DDEVTYPE_HAL;
    matchOptions.eDeviceType := z3DMT_PRESERVE_INPUT;
  end;
  if (z3DCore_GetState.OverrideForceREF) then
  begin
    deviceSettings.DeviceType := D3DDEVTYPE_REF;
    matchOptions.eDeviceType := z3DMT_PRESERVE_INPUT;
  end;
  if (z3DCore_GetState.OverrideForcePureHWVP) then
  begin
    deviceSettings.BehaviorFlags := D3DCREATE_HARDWARE_VERTEXPROCESSING or D3DCREATE_PUREDEVICE;
    matchOptions.eVertexProcessing := z3DMT_PRESERVE_INPUT;
  end
  else if (z3DCore_GetState.OverrideForceHWVP) then
  begin
    deviceSettings.BehaviorFlags := D3DCREATE_HARDWARE_VERTEXPROCESSING;
    matchOptions.eVertexProcessing := z3DMT_PRESERVE_INPUT;
  end
  else if (z3DCore_GetState.OverrideForceSWVP) then
  begin
    deviceSettings.BehaviorFlags := D3DCREATE_SOFTWARE_VERTEXPROCESSING;
    matchOptions.eVertexProcessing := z3DMT_PRESERVE_INPUT;
  end;
  if (z3DCore_GetState.OverrideForceVsync = 0) then
  begin
    deviceSettings.PresentParams.PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
    matchOptions.ePresentInterval := z3DMT_PRESERVE_INPUT;
  end
  else if (z3DCore_GetState.OverrideForceVsync = 1) then
  begin
    deviceSettings.PresentParams.PresentationInterval := D3DPRESENT_INTERVAL_DEFAULT;
    matchOptions.ePresentInterval := z3DMT_PRESERVE_INPUT;
  end;
  Result := z3DCore_FindValidDeviceSettings(deviceSettings, @deviceSettings, @matchOptions);
  if FAILED(Result) then
  begin
    z3DDisplayErrorMessage(Result);
    Result:= z3DError('z3DFindValidDeviceSettings', Result);
    Exit;
  end;
  Result := z3DChangeDevice(@deviceSettings, nil, False, True);
  if FAILED(Result) then Exit;
  Result:= S_OK;
end;

function z3DCore_SetDevice(pd3dDevice: IDirect3DDevice9): HRESULT;
var
  pBackBuffer: IDirect3DSurface9;
  pSwapChain: IDirect3DSwapChain9;
  d3dCreationParams: TD3DDeviceCreationParameters;
  pDeviceSettings: Pz3DDeviceSettings;
begin
  if (pd3dDevice = nil) then
  begin
    Result:= z3DErrorMessage('z3DSetDevice', E_INVALIDARG);
    Exit;
  end;
  if (z3DCore_GetState.GetInsideDeviceCallback) then
  begin
    Result:= z3DErrorMessage('z3DCreateWindow', E_FAIL);
    Exit;
  end;
  z3DCore_GetState.DeviceCreateCalled:= True;
  if (not z3DCore_GetState.WindowCreated) then
  begin
    if (z3DCore_GetState.WindowCreateCalled) then
    begin
      Result:= E_FAIL;
      Exit;
    end;
    Result := z3DCore_CreateWindow;
    if FAILED(Result) then Exit;
  end;
  try
    New(pDeviceSettings);
  except
    Result:= E_OUTOFMEMORY;
    Exit;
  end;
  ZeroMemory(pDeviceSettings, SizeOf(Tz3DDeviceSettings));
  Result := pd3dDevice.GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, pBackBuffer);
  if SUCCEEDED(Result) then
  begin
    Result := pBackBuffer.GetContainer(IID_IDirect3DSwapChain9, Pointer(pSwapChain));
    if SUCCEEDED(Result) then
    begin
      pSwapChain.GetPresentParameters(pDeviceSettings.PresentParams);
      SafeRelease(pSwapChain);
    end;
    SafeRelease(pBackBuffer);
  end;
  pd3dDevice.GetCreationParameters(d3dCreationParams);
  pDeviceSettings.AdapterOrdinal := d3dCreationParams.AdapterOrdinal;
  pDeviceSettings.DeviceType     := d3dCreationParams.DeviceType;
  z3DFindAdapterFormat(pDeviceSettings.AdapterOrdinal, pDeviceSettings.DeviceType,
                        pDeviceSettings.PresentParams.BackBufferFormat, pDeviceSettings.PresentParams.Windowed,
                        pDeviceSettings.AdapterFormat);
  pDeviceSettings.BehaviorFlags  := d3dCreationParams.BehaviorFlags;
  Result := z3DChangeDevice(pDeviceSettings, pd3dDevice, False, False);
  Dispose(pDeviceSettings);
  if FAILED(Result) then Exit;
  Result:= S_OK;
end;

function z3DCore_CreateDeviceFromSettings(pDeviceSettings: Pz3DDeviceSettings; bPreserveInput: Boolean = False; bClipWindowToSingleAdapter: Boolean = True): HRESULT;
var
  matchOptions: Tz3DMatchOptions;
begin
  z3DCore_GetState.SetDeviceCreateCalled(True);
  if not z3DCore_GetState.GetWindowCreated then
  begin
    if (z3DCore_GetState.GetWindowCreateCalled) then
    begin
      Result:= E_FAIL;
      Exit;
    end;
    Result := z3DCore_CreateWindow;
    if FAILED(Result) then Exit;
  end;
  if not bPreserveInput then
  begin
    matchOptions.eAdapterOrdinal     := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.eDeviceType         := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.eWindowed           := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.eAdapterFormat      := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.eVertexProcessing   := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.eResolution         := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.eBackBufferFormat   := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.eBackBufferCount    := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.eMultiSample        := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.eSwapEffect         := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.eDepthFormat        := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.eStencilFormat      := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.ePresentFlags       := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.eRefreshRate        := z3DMT_CLOSEST_TO_INPUT;
    matchOptions.ePresentInterval    := z3DMT_CLOSEST_TO_INPUT;

    Result := z3DCore_FindValidDeviceSettings(pDeviceSettings^, pDeviceSettings, @matchOptions);
    if FAILED(Result) then
    begin
      z3DDisplayErrorMessage(Result);
      Result:= z3DError('z3DFindValidDeviceSettings', Result);
      Exit;
    end;
  end;
  Result := z3DChangeDevice(pDeviceSettings, nil, False, bClipWindowToSingleAdapter);
  if FAILED(Result) then Exit;
  Result:= S_OK;
end;

function z3DCore_ToggleFullScreen: HRESULT;
var
  deviceSettings: Tz3DDeviceSettings;
  matchOptions: Tz3DMatchOptions;
  nWidth: Integer;
  nHeight: Integer;
  hr2: HRESULT;
begin
  deviceSettings := z3DCore_GetDeviceSettings;
  deviceSettings.PresentParams.Windowed := not deviceSettings.PresentParams.Windowed;

  matchOptions.eAdapterOrdinal     := z3DMT_PRESERVE_INPUT;
  matchOptions.eDeviceType         := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eWindowed           := z3DMT_PRESERVE_INPUT;
  matchOptions.eAdapterFormat      := z3DMT_IGNORE_INPUT;
  matchOptions.eVertexProcessing   := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eBackBufferFormat   := z3DMT_IGNORE_INPUT;
  matchOptions.eBackBufferCount    := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eMultiSample        := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eSwapEffect         := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eDepthFormat        := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eStencilFormat      := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.ePresentFlags       := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eRefreshRate        := z3DMT_IGNORE_INPUT;
  matchOptions.ePresentInterval    := z3DMT_CLOSEST_TO_INPUT;
  if deviceSettings.PresentParams.Windowed then
  begin
    nWidth  := z3DCore_GetState.GetWindowBackBufferWidthAtModeChange;
    nHeight := z3DCore_GetState.GetWindowBackBufferHeightAtModeChange;
  end else
  begin
    nWidth  := z3DCore_GetState.GetFullScreenBackBufferWidthAtModeChange;
    nHeight := z3DCore_GetState.GetFullScreenBackBufferHeightAtModeChange;
  end;

  if (nWidth > 0) and (nHeight > 0) then
  begin
    matchOptions.eResolution := z3DMT_CLOSEST_TO_INPUT;
    deviceSettings.PresentParams.BackBufferWidth := nWidth;
    deviceSettings.PresentParams.BackBufferHeight := nHeight;
  end else
  begin
    matchOptions.eResolution := z3DMT_IGNORE_INPUT;
  end;

  Result := z3DCore_FindValidDeviceSettings(deviceSettings, @deviceSettings, @matchOptions);
  if SUCCEEDED(Result) then
  begin
    Result := z3DChangeDevice(@deviceSettings, nil, False, False);
    if FAILED(Result) and (Result <> E_ABORT) then
    begin
      deviceSettings.PresentParams.Windowed := not deviceSettings.PresentParams.Windowed;
      if deviceSettings.PresentParams.Windowed then
      begin
        nWidth  := z3DCore_GetState.GetWindowBackBufferWidthAtModeChange;
        nHeight := z3DCore_GetState.GetWindowBackBufferHeightAtModeChange;
      end else
      begin
        nWidth  := z3DCore_GetState.GetFullScreenBackBufferWidthAtModeChange;
        nHeight := z3DCore_GetState.GetFullScreenBackBufferHeightAtModeChange;
      end;
      if (nWidth > 0) and (nHeight > 0) then
      begin
        matchOptions.eResolution := z3DMT_CLOSEST_TO_INPUT;
        deviceSettings.PresentParams.BackBufferWidth := nWidth;
        deviceSettings.PresentParams.BackBufferHeight := nHeight;
      end else
        matchOptions.eResolution := z3DMT_IGNORE_INPUT;

      z3DCore_FindValidDeviceSettings(deviceSettings, @deviceSettings, @matchOptions);

      hr2 := z3DChangeDevice(@deviceSettings, nil, False, False);
      if FAILED(hr2) then
        z3DCore_Shutdown;
    end;
  end;
end;

function z3DCore_ToggleREF: HRESULT;
var
  deviceSettings: Tz3DDeviceSettings;
  matchOptions: Tz3DMatchOptions;
  hr2: HRESULT;
begin
  deviceSettings := z3DCore_GetDeviceSettings;
  if (deviceSettings.DeviceType = D3DDEVTYPE_HAL)
  then deviceSettings.DeviceType := D3DDEVTYPE_REF
  else if (deviceSettings.DeviceType = D3DDEVTYPE_REF)
  then deviceSettings.DeviceType := D3DDEVTYPE_HAL;

  matchOptions.eAdapterOrdinal     := z3DMT_PRESERVE_INPUT;
  matchOptions.eDeviceType         := z3DMT_PRESERVE_INPUT;
  matchOptions.eWindowed           := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eAdapterFormat      := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eVertexProcessing   := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eResolution         := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eBackBufferFormat   := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eBackBufferCount    := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eMultiSample        := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eSwapEffect         := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eDepthFormat        := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eStencilFormat      := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.ePresentFlags       := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.eRefreshRate        := z3DMT_CLOSEST_TO_INPUT;
  matchOptions.ePresentInterval    := z3DMT_CLOSEST_TO_INPUT;

  Result := z3DCore_FindValidDeviceSettings(deviceSettings, @deviceSettings, @matchOptions);
  if SUCCEEDED(Result) then
  begin
    Result := z3DChangeDevice(@deviceSettings, nil, False, False);
    if FAILED(Result) and (Result <> E_ABORT) then
    begin
      // Failed creating device, try to switch back.
      if (deviceSettings.DeviceType = D3DDEVTYPE_HAL) then deviceSettings.DeviceType := D3DDEVTYPE_REF
      else if (deviceSettings.DeviceType = D3DDEVTYPE_REF) then deviceSettings.DeviceType := D3DDEVTYPE_HAL;

      z3DCore_FindValidDeviceSettings(deviceSettings, @deviceSettings, @matchOptions);

      hr2 := z3DChangeDevice(@deviceSettings, nil, False, False);
      if FAILED(hr2) then
        z3DCore_Shutdown;
    end;
  end;
end;

function z3DPrepareDeviceListObject(bEnumerate: Boolean = False): Iz3DDeviceList;
var
  pd3dEnum: Iz3DDeviceList;
  pD3D: IDirect3D9;
begin
  // Create a new Tz3DDeviceList object and enumerate all devices unless its already been done
  pd3dEnum := z3DCore_GetState.z3DDeviceList;
  if (pd3dEnum = nil) then
  begin
    pd3dEnum := z3DCore_GetDeviceList;
    z3DCore_GetState.SeTz3DDeviceList(pd3dEnum);

    bEnumerate := True;
  end;
  if (bEnumerate) then
  begin
    pD3D := z3DCore_GetD3DObject;
    pd3dEnum.Enumerate(pD3D, z3DCore_GetState.AcceptDeviceFunc, z3DCore_GetState.AcceptDeviceFuncUserContext);
  end;

  Result:= pd3dEnum;
end;

function z3DCore_FindValidDeviceSettings(out pOut: Tz3DDeviceSettings;
  pIn: Pz3DDeviceSettings = nil; pMatchOptions: Pz3DMatchOptions = nil): HRESULT;
var
  pd3dEnum: Iz3DDeviceList;
  pD3D: IDirect3D9;
  defaultMatchOptions: Tz3DMatchOptions;
  optimalDeviceSettings: Tz3DDeviceSettings;
  fBestRanking: Single;
  pBestDeviceSettingsCombo: PD3DDeviceSettingsCombinations;
  adapterDesktopDisplayMode: TD3DDisplayMode;
  pAdapterList: Tz3DEnumAdapterInfoArray;
  iAdapter: Integer;
  pAdapterInfo: Iz3DEnumAdapterInfo;
  iDeviceInfo: Integer;
  pDeviceInfo: Iz3DEnumDeviceInfo;
  iDeviceCombo: Integer;
  pDeviceSettingsCombo: PD3DDeviceSettingsCombinations;
  fCurRanking: Single;
  validDeviceSettings: Tz3DDeviceSettings;
begin
  pd3dEnum := z3DPrepareDeviceListObject(False);
  pD3D     := z3DCore_GetD3DObject;

  if (nil = pMatchOptions) then
  begin
    ZeroMemory(@defaultMatchOptions, SizeOf(Tz3DMatchOptions));
    pMatchOptions := @defaultMatchOptions;
  end;

  z3DBuildOptimalDeviceSettings(@optimalDeviceSettings, pIn, pMatchOptions);
  fBestRanking := -1.0;
  pBestDeviceSettingsCombo := nil;

  pAdapterList := pd3dEnum.GetAdapterInfoList;
  for iAdapter:= 0 to Length(pAdapterList) - 1 do
  begin
    pAdapterInfo := pAdapterList[iAdapter];

    pD3D.GetAdapterDisplayMode(pAdapterInfo.AdapterOrdinal, adapterDesktopDisplayMode);
    for iDeviceInfo:= 0 to Length(pAdapterInfo.deviceInfoList^) - 1 do
    begin
      pDeviceInfo := pAdapterInfo.deviceInfoList^[iDeviceInfo];
      for iDeviceCombo:= 0 to Length(pDeviceInfo.deviceSettingsComboList^) - 1 do
      begin
        pDeviceSettingsCombo := pDeviceInfo.deviceSettingsComboList^[iDeviceCombo];
        if pDeviceSettingsCombo.Windowed and (pDeviceSettingsCombo.AdapterFormat <> adapterDesktopDisplayMode.Format)
        then Continue;
        if not z3DDoesDeviceComboMatchPreserveOptions(pDeviceSettingsCombo, pIn, pMatchOptions)
        then Continue;
        fCurRanking := z3DRankDeviceCombo(pDeviceSettingsCombo, @optimalDeviceSettings, @adapterDesktopDisplayMode);
        if (fCurRanking > fBestRanking) then
        begin
          pBestDeviceSettingsCombo := pDeviceSettingsCombo;
          fBestRanking := fCurRanking;
        end;
      end;
    end;
  end;
  if (pBestDeviceSettingsCombo = nil) then
  begin
    Result:= z3DERR_NOCOMPATIBLEDEVICES;
    Exit;
  end;
  z3DBuildValidDeviceSettings(validDeviceSettings, pBestDeviceSettingsCombo^, pIn, pMatchOptions);
  pOut := validDeviceSettings;
  Result:= S_OK;
end;

procedure z3DBuildOptimalDeviceSettings(pOptimalDeviceSettings: Pz3DDeviceSettings;
  pDeviceSettingsIn: Pz3DDeviceSettings; pMatchOptions: Pz3DMatchOptions);
var
  pD3D: IDirect3D9;
  adapterDesktopDisplayMode: TD3DDisplayMode;
  nBackBufferBits: LongWord;
begin
  pD3D := z3DCore_GetD3DObject;

  ZeroMemory(pOptimalDeviceSettings, SizeOf(Tz3DDeviceSettings));

  //---------------------
  // Adapter ordinal
  //---------------------
  if (pMatchOptions.eAdapterOrdinal = z3DMT_IGNORE_INPUT)
  then pOptimalDeviceSettings.AdapterOrdinal := D3DADAPTER_DEFAULT
  else pOptimalDeviceSettings.AdapterOrdinal := pDeviceSettingsIn.AdapterOrdinal;

  //---------------------
  // Device type
  //---------------------
  if (pMatchOptions.eDeviceType = z3DMT_IGNORE_INPUT)
  then pOptimalDeviceSettings.DeviceType := D3DDEVTYPE_HAL
  else pOptimalDeviceSettings.DeviceType := pDeviceSettingsIn.DeviceType;

  //---------------------
  // Windowed
  //---------------------
  if (pMatchOptions.eWindowed = z3DMT_IGNORE_INPUT)
  then pOptimalDeviceSettings.PresentParams.Windowed := True
  else pOptimalDeviceSettings.PresentParams.Windowed := pDeviceSettingsIn.PresentParams.Windowed;

  //---------------------
  // Adapter format
  //---------------------
  if (pMatchOptions.eAdapterFormat = z3DMT_IGNORE_INPUT) then
  begin
    pD3D.GetAdapterDisplayMode(pOptimalDeviceSettings.AdapterOrdinal, adapterDesktopDisplayMode);
    if pOptimalDeviceSettings.PresentParams.Windowed or (z3DCore_GetColorChannelBits(adapterDesktopDisplayMode.Format) >= 8)
    then pOptimalDeviceSettings.AdapterFormat := adapterDesktopDisplayMode.Format
    else pOptimalDeviceSettings.AdapterFormat := D3DFMT_X8R8G8B8;
  end else
  begin
    pOptimalDeviceSettings.AdapterFormat := pDeviceSettingsIn.AdapterFormat;
  end;

  //---------------------
  // Vertex processing
  //---------------------
  if (pMatchOptions.eVertexProcessing = z3DMT_IGNORE_INPUT)
  then pOptimalDeviceSettings.BehaviorFlags := D3DCREATE_HARDWARE_VERTEXPROCESSING
  else pOptimalDeviceSettings.BehaviorFlags := pDeviceSettingsIn.BehaviorFlags;

  //---------------------
  // Resolution
  //---------------------
  if (pMatchOptions.eResolution = z3DMT_IGNORE_INPUT) then
  begin
    if pOptimalDeviceSettings.PresentParams.Windowed then
    begin
      pOptimalDeviceSettings.PresentParams.BackBufferWidth := 640;
      pOptimalDeviceSettings.PresentParams.BackBufferHeight := 480;
    end else
    begin
      pD3D.GetAdapterDisplayMode( pOptimalDeviceSettings.AdapterOrdinal, adapterDesktopDisplayMode);
      pOptimalDeviceSettings.PresentParams.BackBufferWidth := adapterDesktopDisplayMode.Width;
      pOptimalDeviceSettings.PresentParams.BackBufferHeight := adapterDesktopDisplayMode.Height;
    end;
  end else
  begin
    pOptimalDeviceSettings.PresentParams.BackBufferWidth := pDeviceSettingsIn.PresentParams.BackBufferWidth;
    pOptimalDeviceSettings.PresentParams.BackBufferHeight := pDeviceSettingsIn.PresentParams.BackBufferHeight;
  end;

  //---------------------
  // Back buffer format
  //---------------------
  if (pMatchOptions.eBackBufferFormat = z3DMT_IGNORE_INPUT)
  then pOptimalDeviceSettings.PresentParams.BackBufferFormat := pOptimalDeviceSettings.AdapterFormat // Default to match the adapter format
  else pOptimalDeviceSettings.PresentParams.BackBufferFormat := pDeviceSettingsIn.PresentParams.BackBufferFormat;

  //---------------------
  // Back buffer count
  //---------------------
  if (pMatchOptions.eBackBufferCount = z3DMT_IGNORE_INPUT)
  then pOptimalDeviceSettings.PresentParams.BackBufferCount := 2 // Default to triple buffering for perf gain
  else pOptimalDeviceSettings.PresentParams.BackBufferCount := pDeviceSettingsIn.PresentParams.BackBufferCount;

  //---------------------
  // Multisample
  //---------------------
  if (pMatchOptions.eMultiSample = z3DMT_IGNORE_INPUT) then
  begin
    // Default to no multisampling
    pOptimalDeviceSettings.PresentParams.MultiSampleType := D3DMULTISAMPLE_NONE;
    pOptimalDeviceSettings.PresentParams.MultiSampleQuality := 0;
  end else
  begin
    pOptimalDeviceSettings.PresentParams.MultiSampleType := pDeviceSettingsIn.PresentParams.MultiSampleType;
    pOptimalDeviceSettings.PresentParams.MultiSampleQuality := pDeviceSettingsIn.PresentParams.MultiSampleQuality;
  end;

  //---------------------
  // Swap effect
  //---------------------
  if (pMatchOptions.eSwapEffect = z3DMT_IGNORE_INPUT)
  then pOptimalDeviceSettings.PresentParams.SwapEffect := D3DSWAPEFFECT_DISCARD
  else pOptimalDeviceSettings.PresentParams.SwapEffect := pDeviceSettingsIn.PresentParams.SwapEffect;

  //---------------------
  // Depth stencil
  //---------------------
  if (pMatchOptions.eDepthFormat = z3DMT_IGNORE_INPUT) and
     (pMatchOptions.eStencilFormat = z3DMT_IGNORE_INPUT) then
  begin
    nBackBufferBits := z3DCore_GetColorChannelBits(pOptimalDeviceSettings.PresentParams.BackBufferFormat);
    if (nBackBufferBits >= 8)
    then pOptimalDeviceSettings.PresentParams.AutoDepthStencilFormat := D3DFMT_D32
    else pOptimalDeviceSettings.PresentParams.AutoDepthStencilFormat := D3DFMT_D16;
  end else
  begin
    pOptimalDeviceSettings.PresentParams.AutoDepthStencilFormat := pDeviceSettingsIn.PresentParams.AutoDepthStencilFormat;
  end;

  //---------------------
  // Present flags
  //---------------------
  if (pMatchOptions.ePresentFlags = z3DMT_IGNORE_INPUT)
  then pOptimalDeviceSettings.PresentParams.Flags := 0{D3DPRESENTFLAG_DISCARD_DEPTHSTENCIL} // TODO JP
  else pOptimalDeviceSettings.PresentParams.Flags := pDeviceSettingsIn.PresentParams.Flags;

  //---------------------
  // Refresh rate
  //---------------------
  if (pMatchOptions.eRefreshRate = z3DMT_IGNORE_INPUT)
  then pOptimalDeviceSettings.PresentParams.FullScreen_RefreshRateInHz := 0
  else pOptimalDeviceSettings.PresentParams.FullScreen_RefreshRateInHz := pDeviceSettingsIn.PresentParams.FullScreen_RefreshRateInHz;

  //---------------------
  // Present interval
  //---------------------
  if (pMatchOptions.ePresentInterval = z3DMT_IGNORE_INPUT) then
  begin
    pOptimalDeviceSettings.PresentParams.PresentationInterval := D3DPRESENT_INTERVAL_DEFAULT;
  end else
  begin
    pOptimalDeviceSettings.PresentParams.PresentationInterval := pDeviceSettingsIn.PresentParams.PresentationInterval;
  end;
end;

function z3DDoesDeviceComboMatchPreserveOptions(pDeviceSettingsCombo: PD3DDeviceSettingsCombinations;
  pDeviceSettingsIn: Pz3DDeviceSettings; pMatchOptions: Pz3DMatchOptions): Boolean;
var
  bFound: Boolean;
  i: Integer;
  displayMode: TD3DDisplayMode;
  msType: TD3DMultiSampleType;
  msQuality: DWORD;
  dwDepthBits: LongWord;
  depthStencilFmt: TD3DFormat;
  dwCurDepthBits: LongWord;
  dwStencilBits: LongWord;
  dwCurStencilBits: LongWord;
begin
  Result:= False;

  //---------------------
  // Adapter ordinal
  //---------------------
  if (pMatchOptions.eAdapterOrdinal = z3DMT_PRESERVE_INPUT) and
     (pDeviceSettingsCombo.AdapterOrdinal <> pDeviceSettingsIn.AdapterOrdinal)
  then Exit;

  //---------------------
  // Device type
  //---------------------
  if (pMatchOptions.eDeviceType = z3DMT_PRESERVE_INPUT) and
     (pDeviceSettingsCombo.DeviceType <> pDeviceSettingsIn.DeviceType)
  then Exit;

  //---------------------
  // Windowed
  //---------------------
  if (pMatchOptions.eWindowed = z3DMT_PRESERVE_INPUT) and
     (pDeviceSettingsCombo.Windowed <> pDeviceSettingsIn.PresentParams.Windowed)
  then Exit;

  //---------------------
  // Adapter format
  //---------------------
  if (pMatchOptions.eAdapterFormat = z3DMT_PRESERVE_INPUT) and
     (pDeviceSettingsCombo.AdapterFormat <> pDeviceSettingsIn.AdapterFormat)
  then Exit;

  //---------------------
  // Vertex processing
  //---------------------
  if (pMatchOptions.eVertexProcessing = z3DMT_PRESERVE_INPUT) and
     ((pDeviceSettingsIn.BehaviorFlags and D3DCREATE_HARDWARE_VERTEXPROCESSING) <> 0) and
     ((pDeviceSettingsCombo.DeviceInfo.Caps.DevCaps and D3DDEVCAPS_HWTRANSFORMANDLIGHT) = 0)
  then Exit;

  //---------------------
  // Resolution
  //---------------------
  if (pMatchOptions.eResolution = z3DMT_PRESERVE_INPUT) then
  begin
    bFound := False;
    for i:= 0 to Length(pDeviceSettingsCombo.AdapterInfo.displayModeList^) - 1 do
    begin
      displayMode := pDeviceSettingsCombo.AdapterInfo.displayModeList^[i];
      if (displayMode.Format <> pDeviceSettingsCombo.AdapterFormat)
      then Continue; // Skip this display mode if it doesn't match the combo's adapter format

      if (displayMode.Width = pDeviceSettingsIn.PresentParams.BackBufferWidth) and
         (displayMode.Height = pDeviceSettingsIn.PresentParams.BackBufferHeight) then
      begin
        bFound := True;
        Break;
      end;
    end;

    if (not bFound) then Exit;
  end;

  //---------------------
  // Back buffer format
  //---------------------
  if (pMatchOptions.eBackBufferFormat = z3DMT_PRESERVE_INPUT) and
     (pDeviceSettingsCombo.BackBufferFormat <> pDeviceSettingsIn.PresentParams.BackBufferFormat)
  then Exit;

  //---------------------
  // Back buffer count
  //---------------------
  // No caps for the back buffer count

  //---------------------
  // Multisample
  //---------------------
  if (pMatchOptions.eMultiSample = z3DMT_PRESERVE_INPUT) then
  begin
    bFound := false;
    for i:= 0 to Length(pDeviceSettingsCombo.multiSampleTypeList) - 1 do
    begin
      msType := pDeviceSettingsCombo.multiSampleTypeList[i];
      msQuality  := pDeviceSettingsCombo.multiSampleQualityList[i];

      if (msType = pDeviceSettingsIn.PresentParams.MultiSampleType) and
         (msQuality >= pDeviceSettingsIn.PresentParams.MultiSampleQuality) then
      begin
        bFound := True;
        Break;
      end;
    end;

    // If multisample type/quality not supported by this combo, then return false
    if not bFound then Exit;
  end;

  //---------------------
  // Swap effect
  //---------------------
  // No caps for swap effects

  //---------------------
  // Depth stencil
  //---------------------
  // If keep depth stencil format then check that the depth stencil format is supported by this combo
  if (pMatchOptions.eDepthFormat = z3DMT_PRESERVE_INPUT) and
     (pMatchOptions.eStencilFormat = z3DMT_PRESERVE_INPUT) then
  begin
    if (pDeviceSettingsIn.PresentParams.AutoDepthStencilFormat <> D3DFMT_UNKNOWN) and
       not DynArrayContains(pDeviceSettingsCombo.depthStencilFormatList,
                            pDeviceSettingsIn.PresentParams.AutoDepthStencilFormat,
                            SizeOf(pDeviceSettingsIn.PresentParams.AutoDepthStencilFormat))
    then Exit;
  end;

  // If keep depth format then check that the depth format is supported by this combo
  if (pMatchOptions.eDepthFormat = z3DMT_PRESERVE_INPUT) and
     (pDeviceSettingsIn.PresentParams.AutoDepthStencilFormat <> D3DFMT_UNKNOWN) then
  begin
    bFound := False;
    dwDepthBits := z3DCore_GetDepthBits(pDeviceSettingsIn.PresentParams.AutoDepthStencilFormat);
    for i:= 0 to Length(pDeviceSettingsCombo.depthStencilFormatList) - 1 do
    begin
      depthStencilFmt := pDeviceSettingsCombo.depthStencilFormatList[i];
      dwCurDepthBits := z3DCore_GetDepthBits(depthStencilFmt);
      if (dwCurDepthBits - dwDepthBits = 0) then bFound := True;
    end;

    if not bFound then Exit;
  end;

  // If keep depth format then check that the depth format is supported by this combo
  if (pMatchOptions.eStencilFormat = z3DMT_PRESERVE_INPUT) and
     (pDeviceSettingsIn.PresentParams.AutoDepthStencilFormat <> D3DFMT_UNKNOWN) then
  begin
    bFound := False;
    dwStencilBits := z3DCore_GetStencilBits(pDeviceSettingsIn.PresentParams.AutoDepthStencilFormat);
    for i:= 0 to Length(pDeviceSettingsCombo.depthStencilFormatList) - 1 do
    begin
      depthStencilFmt := pDeviceSettingsCombo.depthStencilFormatList[i];
      dwCurStencilBits := z3DCore_GetStencilBits(depthStencilFmt);
      if (dwCurStencilBits - dwStencilBits = 0) then bFound := True;
    end;

    if not bFound then Exit;
  end;

  //---------------------
  // Present flags
  //---------------------
  // No caps for the present flags

  //---------------------
  // Refresh rate
  //---------------------
  // If keep refresh rate then check that the resolution is supported by this combo
  if (pMatchOptions.eRefreshRate = z3DMT_PRESERVE_INPUT) then
  begin
    bFound := false;
    for i:= 0 to Length(pDeviceSettingsCombo.AdapterInfo.displayModeList^) - 1 do
    begin
      displayMode := pDeviceSettingsCombo.AdapterInfo.displayModeList^[i];
      if (displayMode.Format <> pDeviceSettingsCombo.AdapterFormat) then Continue;
      if (displayMode.RefreshRate = pDeviceSettingsIn.PresentParams.FullScreen_RefreshRateInHz) then
      begin
        bFound := True;
        Break;
      end;
    end;

    // If refresh rate not supported by this combo, then return false
    if not bFound then Exit;
  end;

  //---------------------
  // Present interval
  //---------------------
  // If keep present interval then check that the present interval is supported by this combo
  if (pMatchOptions.ePresentInterval = z3DMT_PRESERVE_INPUT) and
     not DynArrayContains(pDeviceSettingsCombo.presentIntervalList,
                          pDeviceSettingsIn.PresentParams.PresentationInterval,
                          SizeOf(pDeviceSettingsIn.PresentParams.PresentationInterval))
  then Exit;

  Result:= True;
end;

function z3DRankDeviceCombo(pDeviceSettingsCombo: PD3DDeviceSettingsCombinations;
  pOptimalDeviceSettings: Pz3DDeviceSettings; pAdapterDesktopDisplayMode: PD3DDisplayMode): Single;
const
  fAdapterOrdinalWeight   = 1000.0;
  fDeviceTypeWeight       = 100.0;
  fWindowWeight           = 10.0;
  fAdapterFormatWeight    = 1.0;
  fVertexProcessingWeight = 1.0;
  fResolutionWeight       = 1.0;
  fBackBufferFormatWeight = 1.0;
  fMultiSampleWeight      = 1.0;
  fDepthStencilWeight     = 1.0;
  fRefreshRateWeight      = 1.0;
  fPresentIntervalWeight  = 1.0;
var
  fCurRanking: Single;
  nBitDepthDelta: Integer;
  fScale: Single;
  bAdapterOptimalMatch: Boolean;
  bResolutionFound: Boolean;
  idm: Integer;
  displayMode: TD3DDisplayMode;
  bAdapterMatchesBB: Boolean;
  bMultiSampleFound: Boolean;
  i: Integer;
  msType: TD3DMultiSampleType;
  msQuality: DWORD;
  bRefreshFound: Boolean;
begin
  fCurRanking := 0.0;

  //---------------------
  // Adapter ordinal
  //---------------------
  if (pDeviceSettingsCombo.AdapterOrdinal = pOptimalDeviceSettings.AdapterOrdinal)
  then fCurRanking := fCurRanking + fAdapterOrdinalWeight;

  //---------------------
  // Device type
  //---------------------
  if (pDeviceSettingsCombo.DeviceType = pOptimalDeviceSettings.DeviceType)
  then fCurRanking := fCurRanking + fDeviceTypeWeight;
  // Slightly prefer HAL
  if (pDeviceSettingsCombo.DeviceType = D3DDEVTYPE_HAL)
  then fCurRanking := fCurRanking + 0.1;

  //---------------------
  // Windowed
  //---------------------
  if (pDeviceSettingsCombo.Windowed = pOptimalDeviceSettings.PresentParams.Windowed )
  then fCurRanking := fCurRanking + fWindowWeight;

  //---------------------
  // Adapter format
  //---------------------
  if (pDeviceSettingsCombo.AdapterFormat = pOptimalDeviceSettings.AdapterFormat) then
  begin
    fCurRanking := fCurRanking + fAdapterFormatWeight;
  end else
  begin
    nBitDepthDelta := Abs(z3DCore_GetColorChannelBits(pDeviceSettingsCombo.AdapterFormat) -
                          z3DCore_GetColorChannelBits(pOptimalDeviceSettings.AdapterFormat));
    fScale := Max(0.9 - nBitDepthDelta*0.2, 0);
    fCurRanking := fCurRanking + fScale * fAdapterFormatWeight;
  end;

  if (not pDeviceSettingsCombo.Windowed) then
  begin
    if (z3DCore_GetColorChannelBits(pAdapterDesktopDisplayMode.Format) >= 8)
    then bAdapterOptimalMatch := (pDeviceSettingsCombo.AdapterFormat = pAdapterDesktopDisplayMode.Format)
    else bAdapterOptimalMatch := (pDeviceSettingsCombo.AdapterFormat = D3DFMT_X8R8G8B8);

    if (bAdapterOptimalMatch) then fCurRanking := fCurRanking + 0.1;
  end;

  //---------------------
  // Vertex processing
  //---------------------
  if ((pOptimalDeviceSettings.BehaviorFlags and D3DCREATE_HARDWARE_VERTEXPROCESSING) <> 0) or
     ((pOptimalDeviceSettings.BehaviorFlags and D3DCREATE_MIXED_VERTEXPROCESSING) <> 0) then
  begin
    if ((pDeviceSettingsCombo.DeviceInfo.Caps.DevCaps and D3DDEVCAPS_HWTRANSFORMANDLIGHT) <> 0)
    then fCurRanking := fCurRanking + fVertexProcessingWeight;
  end;
  // Slightly prefer HW T&L
  if ((pDeviceSettingsCombo.DeviceInfo.Caps.DevCaps and D3DDEVCAPS_HWTRANSFORMANDLIGHT) <> 0)
  then fCurRanking := fCurRanking + 0.1;

  //---------------------
  // Resolution
  //---------------------
  bResolutionFound := False;
  for idm := 0 to Length(pDeviceSettingsCombo.AdapterInfo.displayModeList^) - 1 do
  begin
    displayMode := pDeviceSettingsCombo.AdapterInfo.displayModeList^[idm];
    if (displayMode.Format <> pDeviceSettingsCombo.AdapterFormat) then Continue;

    if (displayMode.Width = pOptimalDeviceSettings.PresentParams.BackBufferWidth) and
       (displayMode.Height = pOptimalDeviceSettings.PresentParams.BackBufferHeight)
    then bResolutionFound := True;
  end;
  if (bResolutionFound) then fCurRanking := fCurRanking + fResolutionWeight;

  //---------------------
  // Back buffer format
  //---------------------
  if (pDeviceSettingsCombo.BackBufferFormat = pOptimalDeviceSettings.PresentParams.BackBufferFormat) then
  begin
    fCurRanking := fCurRanking + fBackBufferFormatWeight;
  end else
  begin
    nBitDepthDelta := Abs(z3DCore_GetColorChannelBits(pDeviceSettingsCombo.BackBufferFormat) -
                          z3DCore_GetColorChannelBits(pOptimalDeviceSettings.PresentParams.BackBufferFormat));
    fScale := Max(0.9 - nBitDepthDelta*0.2, 0);
    fCurRanking := fCurRanking + fScale * fBackBufferFormatWeight;
  end;

  // Check if this back buffer format is the same as
  // the adapter format since this is preferred.
  bAdapterMatchesBB := (pDeviceSettingsCombo.BackBufferFormat = pDeviceSettingsCombo.AdapterFormat);
  if bAdapterMatchesBB then fCurRanking := fCurRanking + 0.1;

  //---------------------
  // Back buffer count
  //---------------------
  // No caps for the back buffer count

  //---------------------
  // Multisample
  //---------------------
  bMultiSampleFound := False;
  for i:= 0 to Length(pDeviceSettingsCombo.multiSampleTypeList) - 1 do
  begin
    msType := pDeviceSettingsCombo.multiSampleTypeList[i];
    msQuality  := pDeviceSettingsCombo.multiSampleQualityList[i];

    if (msType = pOptimalDeviceSettings.PresentParams.MultiSampleType) and
       (msQuality >= pOptimalDeviceSettings.PresentParams.MultiSampleQuality) then
    begin
      bMultiSampleFound := True;
      Break;
    end;
  end;
  if bMultiSampleFound then fCurRanking := fCurRanking + fMultiSampleWeight;

  //---------------------
  // Swap effect
  //---------------------
  // No caps for swap effects

  //---------------------
  // Depth stencil
  //---------------------
  if DynArrayContains(pDeviceSettingsCombo.depthStencilFormatList,
                      pOptimalDeviceSettings.PresentParams.AutoDepthStencilFormat,
                      SizeOf(pOptimalDeviceSettings.PresentParams.AutoDepthStencilFormat))
  then fCurRanking := fCurRanking + fDepthStencilWeight;

  //---------------------
  // Present flags
  //---------------------
  // No caps for the present flags

  //---------------------
  // Refresh rate
  //---------------------
  bRefreshFound := False;
  for idm := 0 to Length(pDeviceSettingsCombo.AdapterInfo.displayModeList^) - 1 do
  begin
    displayMode := pDeviceSettingsCombo.AdapterInfo.displayModeList^[idm];
    if (displayMode.Format <> pDeviceSettingsCombo.AdapterFormat) then Continue;

    if (displayMode.RefreshRate = pOptimalDeviceSettings.PresentParams.FullScreen_RefreshRateInHz)
    then bRefreshFound := True;
  end;
  if bRefreshFound then fCurRanking := fCurRanking + fRefreshRateWeight;

  //---------------------
  // Present interval
  //---------------------
  if DynArrayContains(pDeviceSettingsCombo.presentIntervalList,
                      pOptimalDeviceSettings.PresentParams.PresentationInterval,
                      SizeOf(pOptimalDeviceSettings.PresentParams.PresentationInterval))
  then fCurRanking := fCurRanking + fPresentIntervalWeight;

  Result:= fCurRanking;
end;

procedure z3DBuildValidDeviceSettings(out pValidDeviceSettings: Tz3DDeviceSettings;
  const pBestDeviceSettingsCombo: TD3DDeviceSettingsCombinations; pDeviceSettingsIn: Pz3DDeviceSettings;
  pMatchOptions: Pz3DMatchOptions);
var
  pD3D: IDirect3D9;
  adapterDesktopDisplayMode: TD3DDisplayMode;
  dwBestBehaviorFlags: DWORD;
  bestDisplayMode: TD3DDisplayMode;
  displayModeIn: TD3DDisplayMode;
  bestBackBufferCount: LongWord;
  bestMultiSampleType: TD3DMultiSampleType;
  bestMultiSampleQuality: DWORD;
  i: Integer;
  bestSwapEffect: TD3DSwapEffect;
  bestDepthStencilFormat: TD3DFormat;
  bestEnableAutoDepthStencil: Boolean;
  depthStencilRanking: array of Integer;
  dwBackBufferBitDepth: LongWord;
  dwInputDepthBitDepth: LongWord;
  curDepthStencilFmt: TD3DFormat;
  dwCurDepthBitDepth: DWORD;
  nRanking: Integer;
  l: Integer;
  dwInputStencilBitDepth: LongWord;
  dwCurStencilBitDepth: DWORD;
  nBestRanking: Integer;
  nBestIndex: Integer;
  dwBestFlags: DWORD;
  refreshRateMatch: LongWord;
  nBestRefreshRanking: Integer;
  pDisplayModeList: TD3DDisplayModeArray;
  iDisplayMode: Integer;
  displayMode: TD3DDisplayMode;
  nCurRanking: Integer;
  bestPresentInterval: LongWord;
  type_: TD3DMultiSampleType;
  qualityLevels: DWORD;
begin
  pDisplayModeList := nil;
  pD3D := z3DCore_GetD3DObject;
  pD3D.GetAdapterDisplayMode(pBestDeviceSettingsCombo.AdapterOrdinal, adapterDesktopDisplayMode);

  //---------------------
  // Vertex processing
  //---------------------
  dwBestBehaviorFlags := 0;
  if (pMatchOptions.eVertexProcessing = z3DMT_PRESERVE_INPUT) then
  begin
    dwBestBehaviorFlags := pDeviceSettingsIn.BehaviorFlags;
  end
  else if (pMatchOptions.eVertexProcessing = z3DMT_IGNORE_INPUT) then
  begin
    if ((pBestDeviceSettingsCombo.DeviceInfo.Caps.DevCaps and D3DDEVCAPS_HWTRANSFORMANDLIGHT) <> 0)
    then dwBestBehaviorFlags := dwBestBehaviorFlags or D3DCREATE_HARDWARE_VERTEXPROCESSING
    else dwBestBehaviorFlags := dwBestBehaviorFlags or D3DCREATE_SOFTWARE_VERTEXPROCESSING;
  end
  else
  begin
    // Default to input, and fallback to SWVP if HWVP not available
    dwBestBehaviorFlags := pDeviceSettingsIn.BehaviorFlags;
    if ((pBestDeviceSettingsCombo.DeviceInfo.Caps.DevCaps and D3DDEVCAPS_HWTRANSFORMANDLIGHT) = 0) and
       (((dwBestBehaviorFlags and D3DCREATE_HARDWARE_VERTEXPROCESSING) <> 0) or
        ((dwBestBehaviorFlags and D3DCREATE_MIXED_VERTEXPROCESSING) <> 0)) then
    begin
      dwBestBehaviorFlags := dwBestBehaviorFlags and not D3DCREATE_HARDWARE_VERTEXPROCESSING;
      dwBestBehaviorFlags := dwBestBehaviorFlags and not D3DCREATE_MIXED_VERTEXPROCESSING;
      dwBestBehaviorFlags := dwBestBehaviorFlags or D3DCREATE_SOFTWARE_VERTEXPROCESSING;
    end;

    // One of these must be selected
    if ((dwBestBehaviorFlags and D3DCREATE_HARDWARE_VERTEXPROCESSING) = 0) and
       ((dwBestBehaviorFlags and D3DCREATE_MIXED_VERTEXPROCESSING) = 0) and
       ((dwBestBehaviorFlags and D3DCREATE_SOFTWARE_VERTEXPROCESSING) = 0) then
    begin
      if ((pBestDeviceSettingsCombo.DeviceInfo.Caps.DevCaps and D3DDEVCAPS_HWTRANSFORMANDLIGHT) <> 0)
      then dwBestBehaviorFlags := dwBestBehaviorFlags or D3DCREATE_HARDWARE_VERTEXPROCESSING
      else dwBestBehaviorFlags := dwBestBehaviorFlags or D3DCREATE_SOFTWARE_VERTEXPROCESSING;
    end;
  end;

  //---------------------
  // Resolution
  //---------------------
  if (pMatchOptions.eResolution = z3DMT_PRESERVE_INPUT) then
  begin
    bestDisplayMode.Width := pDeviceSettingsIn.PresentParams.BackBufferWidth;
    bestDisplayMode.Height := pDeviceSettingsIn.PresentParams.BackBufferHeight;
  end else
  begin
    if (pMatchOptions.eResolution = z3DMT_CLOSEST_TO_INPUT) and
       (pDeviceSettingsIn <> nil) then
    begin
      displayModeIn.Width := pDeviceSettingsIn.PresentParams.BackBufferWidth;
      displayModeIn.Height := pDeviceSettingsIn.PresentParams.BackBufferHeight;
    end
    else
    begin
      if pBestDeviceSettingsCombo.Windowed then
      begin
        displayModeIn.Width := 640;
        displayModeIn.Height := 480;
      end else
      begin
        displayModeIn.Width := adapterDesktopDisplayMode.Width;
        displayModeIn.Height := adapterDesktopDisplayMode.Height;
      end;
    end;

    // Call a helper function to find the closest valid display mode to the optimal
    z3DFindValidResolution(pBestDeviceSettingsCombo, displayModeIn, bestDisplayMode);
  end;

  //---------------------
  // Back Buffer Format
  //---------------------
  // Just using pBestDeviceSettingsCombo->BackBufferFormat

  //---------------------
  // Back buffer count
  //---------------------
  if (pMatchOptions.eBackBufferCount = z3DMT_PRESERVE_INPUT) then
  begin
    bestBackBufferCount := pDeviceSettingsIn.PresentParams.BackBufferCount;
  end
  else if (pMatchOptions.eBackBufferCount = z3DMT_IGNORE_INPUT) then
  begin
    bestBackBufferCount := 2;
  end
  else // if( pMatchOptions->eBackBufferCount == z3DMT_CLOSEST_TO_INPUT )
  begin
    bestBackBufferCount := pDeviceSettingsIn.PresentParams.BackBufferCount;
    if (bestBackBufferCount > 3) then bestBackBufferCount := 3;
    if (bestBackBufferCount < 1) then bestBackBufferCount := 1;
  end;

  //---------------------
  // Multisample
  //---------------------
  if (pDeviceSettingsIn <> nil) and (pDeviceSettingsIn.PresentParams.SwapEffect <> D3DSWAPEFFECT_DISCARD) then
  begin
    // Swap effect is not set to discard so multisampling has to off
    bestMultiSampleType := D3DMULTISAMPLE_NONE;
    bestMultiSampleQuality := 0;
  end else
  begin
    if (pMatchOptions.eMultiSample = z3DMT_PRESERVE_INPUT) then
    begin
      bestMultiSampleType    := pDeviceSettingsIn.PresentParams.MultiSampleType;
      bestMultiSampleQuality := pDeviceSettingsIn.PresentParams.MultiSampleQuality;
    end
    else if (pMatchOptions.eMultiSample = z3DMT_IGNORE_INPUT) then
    begin
      // Default to no multisampling (always supported)
      bestMultiSampleType := D3DMULTISAMPLE_NONE;
      bestMultiSampleQuality := 0;
    end
    else if (pMatchOptions.eMultiSample = z3DMT_CLOSEST_TO_INPUT) then
    begin
      // Default to no multisampling (always supported)
      bestMultiSampleType := D3DMULTISAMPLE_NONE;
      bestMultiSampleQuality := 0;

      for i := 0 to Length(pBestDeviceSettingsCombo.multiSampleTypeList) - 1 do
      begin
        type_ := pBestDeviceSettingsCombo.multiSampleTypeList[i];
        qualityLevels := pBestDeviceSettingsCombo.multiSampleQualityList[i];

        // Check whether supported type is closer to the input than our current best
        if (Abs(Ord(type_) - Ord(pDeviceSettingsIn.PresentParams.MultiSampleType)) <
              Abs(Ord(bestMultiSampleType) - Ord(pDeviceSettingsIn.PresentParams.MultiSampleType))) then
        begin
          bestMultiSampleType := type_;
          bestMultiSampleQuality := Min(qualityLevels-1, pDeviceSettingsIn.PresentParams.MultiSampleQuality);
        end;
      end;
    end else
    begin
      // Error case
      bestMultiSampleType := D3DMULTISAMPLE_NONE;
      bestMultiSampleQuality := 0;
    end;
  end;

  //---------------------
  // Swap effect
  //---------------------
  if (pMatchOptions.eSwapEffect = z3DMT_PRESERVE_INPUT) then
  begin
    bestSwapEffect := pDeviceSettingsIn.PresentParams.SwapEffect;
  end
  else if (pMatchOptions.eSwapEffect = z3DMT_IGNORE_INPUT) then
  begin
    bestSwapEffect := D3DSWAPEFFECT_DISCARD;
  end
  else // if( pMatchOptions->eSwapEffect == z3DMT_CLOSEST_TO_INPUT )
  begin
    bestSwapEffect := pDeviceSettingsIn.PresentParams.SwapEffect;

    // Swap effect has to be one of these 3
    if (bestSwapEffect <> D3DSWAPEFFECT_DISCARD) and
       (bestSwapEffect <> D3DSWAPEFFECT_FLIP) and
       (bestSwapEffect <> D3DSWAPEFFECT_COPY) then
      bestSwapEffect := D3DSWAPEFFECT_DISCARD;
  end;

  //---------------------
  // Depth stencil
  //---------------------
  dwBackBufferBitDepth := z3DCore_GetColorChannelBits(pBestDeviceSettingsCombo.BackBufferFormat);
  dwInputDepthBitDepth := 0;
  if (pDeviceSettingsIn <> nil) then
    dwInputDepthBitDepth := z3DCore_GetDepthBits(pDeviceSettingsIn.PresentParams.AutoDepthStencilFormat);

  for i:= 0 to Length(pBestDeviceSettingsCombo.depthStencilFormatList) - 1 do
  begin
    curDepthStencilFmt := pBestDeviceSettingsCombo.depthStencilFormatList[i];
    dwCurDepthBitDepth := z3DCore_GetDepthBits(curDepthStencilFmt);

    if (pMatchOptions.eDepthFormat = z3DMT_PRESERVE_INPUT) then
    begin
      // Need to match bit depth of input
      if (dwCurDepthBitDepth = dwInputDepthBitDepth)
      then nRanking := 0
      else nRanking := 10000;
    end
    else if (pMatchOptions.eDepthFormat = z3DMT_IGNORE_INPUT) then
    begin
      // Prefer match of backbuffer bit depth
      nRanking := Abs(Integer(dwCurDepthBitDepth) - Integer(dwBackBufferBitDepth*4));
    end
    else
    begin
      // Prefer match of input depth format bit depth
      nRanking := Abs(Integer(dwCurDepthBitDepth) - Integer(dwInputDepthBitDepth));
    end;

    // depthStencilRanking.Add(nRanking);
    l:= Length(depthStencilRanking);
    SetLength(depthStencilRanking, l+1);
    depthStencilRanking[l]:= nRanking;
  end;

  dwInputStencilBitDepth := 0;
  if (pDeviceSettingsIn <> nil) then
    dwInputStencilBitDepth := z3DCore_GetStencilBits(pDeviceSettingsIn.PresentParams.AutoDepthStencilFormat);

  for i:= 0 to Length(pBestDeviceSettingsCombo.depthStencilFormatList) - 1 do
  begin
    curDepthStencilFmt := pBestDeviceSettingsCombo.depthStencilFormatList[i];
    nRanking := depthStencilRanking[i];
    dwCurStencilBitDepth := z3DCore_GetStencilBits(curDepthStencilFmt);

    if (pMatchOptions.eStencilFormat = z3DMT_PRESERVE_INPUT) then
    begin
      // Need to match bit depth of input
      if (dwCurStencilBitDepth = dwInputStencilBitDepth)
      then Inc(nRanking, 0)
      else Inc(nRanking, 10000);
    end
    else if (pMatchOptions.eStencilFormat = z3DMT_IGNORE_INPUT) then
    begin
      // Prefer 0 stencil bit depth
      Inc(nRanking, dwCurStencilBitDepth);
    end
    else
    begin
      // Prefer match of input stencil format bit depth
      Inc(nRanking, Abs(Integer(dwCurStencilBitDepth) - Integer(dwInputStencilBitDepth)));
    end;

    depthStencilRanking[i]:= nRanking;
  end;

  nBestRanking := 100000;
  nBestIndex := -1;
  for i:= 0 to Length(pBestDeviceSettingsCombo.depthStencilFormatList) - 1 do
  begin
    nRanking := depthStencilRanking[i];
    if (nRanking < nBestRanking) then
    begin
      nBestRanking := nRanking;
      nBestIndex := i;
    end;
  end;

  if (nBestIndex >= 0) then
  begin
    bestDepthStencilFormat := pBestDeviceSettingsCombo.depthStencilFormatList[nBestIndex];
    bestEnableAutoDepthStencil := True;
  end else
  begin
    bestDepthStencilFormat := D3DFMT_UNKNOWN;
    bestEnableAutoDepthStencil := False;
  end;


  //---------------------
  // Present flags
  //---------------------
  if (pMatchOptions.ePresentFlags = z3DMT_PRESERVE_INPUT) then
  begin
    dwBestFlags := pDeviceSettingsIn.PresentParams.Flags;
  end
  else if (pMatchOptions.ePresentFlags = z3DMT_IGNORE_INPUT) then
  begin
    dwBestFlags := 0;
    if bestEnableAutoDepthStencil then
      dwBestFlags := 0{D3DPRESENTFLAG_DISCARD_DEPTHSTENCIL}; // TODO JP
  end
  else
  begin
    dwBestFlags := pDeviceSettingsIn.PresentParams.Flags;
    if bestEnableAutoDepthStencil then
      dwBestFlags := dwBestFlags{ or D3DPRESENTFLAG_DISCARD_DEPTHSTENCIL}; // TODO JP
  end;

  //---------------------
  // Refresh rate
  //---------------------
  if pBestDeviceSettingsCombo.Windowed then
  begin
    // Must be 0 for windowed
    bestDisplayMode.RefreshRate := 0;
  end else
  begin
    if (pMatchOptions.eRefreshRate = z3DMT_PRESERVE_INPUT) then
    begin
      bestDisplayMode.RefreshRate := pDeviceSettingsIn.PresentParams.FullScreen_RefreshRateInHz;
    end else
    begin
      if (pMatchOptions.eRefreshRate = z3DMT_CLOSEST_TO_INPUT) then
      begin
        refreshRateMatch := pDeviceSettingsIn.PresentParams.FullScreen_RefreshRateInHz;
      end
      else
      begin
        refreshRateMatch := adapterDesktopDisplayMode.RefreshRate;
      end;

      bestDisplayMode.RefreshRate := 0;

      if (refreshRateMatch <> 0) then
      begin
        nBestRefreshRanking := 100000;
        pDisplayModeList := pBestDeviceSettingsCombo.AdapterInfo.displayModeList^;
        for iDisplayMode:= 0 to Length(pDisplayModeList) - 1 do
        begin
          displayMode := pDisplayModeList[iDisplayMode];
          if (displayMode.Format <> pBestDeviceSettingsCombo.AdapterFormat) or
             (displayMode.Height <> bestDisplayMode.Height) or
             (displayMode.Width <> bestDisplayMode.Width)
          then Continue; // Skip display modes that don't match

          // Find the delta between the current refresh rate and the optimal refresh rate
          nCurRanking := Abs(Integer(displayMode.RefreshRate) - Integer(refreshRateMatch));

          if (nCurRanking < nBestRefreshRanking) then
          begin
            bestDisplayMode.RefreshRate := displayMode.RefreshRate;
            nBestRefreshRanking := nCurRanking;

            // Stop if perfect match found
            if (nBestRefreshRanking = 0) then Break;
          end;
        end;
      end;
    end;
  end;

  //---------------------
  // Present interval
  //---------------------
  if (pMatchOptions.ePresentInterval = z3DMT_PRESERVE_INPUT) then
  begin
    bestPresentInterval := pDeviceSettingsIn.PresentParams.PresentationInterval;
  end
  else if (pMatchOptions.ePresentInterval = z3DMT_IGNORE_INPUT) then
  begin
    bestPresentInterval := D3DPRESENT_INTERVAL_DEFAULT;
  end
  else // if( pMatchOptions->ePresentInterval == z3DMT_CLOSEST_TO_INPUT )
  begin
    if DynArrayContains(pBestDeviceSettingsCombo.presentIntervalList,
                        pDeviceSettingsIn.PresentParams.PresentationInterval,
                        SizeOf(pDeviceSettingsIn.PresentParams.PresentationInterval))
    then bestPresentInterval := pDeviceSettingsIn.PresentParams.PresentationInterval
    else bestPresentInterval := D3DPRESENT_INTERVAL_DEFAULT;
  end;

  // Fill the device settings struct
  ZeroMemory(@pValidDeviceSettings, SizeOf(Tz3DDeviceSettings));
  pValidDeviceSettings.AdapterOrdinal                 := pBestDeviceSettingsCombo.AdapterOrdinal;
  pValidDeviceSettings.DeviceType                     := pBestDeviceSettingsCombo.DeviceType;
  pValidDeviceSettings.AdapterFormat                  := pBestDeviceSettingsCombo.AdapterFormat;
  pValidDeviceSettings.BehaviorFlags                  := dwBestBehaviorFlags;
  pValidDeviceSettings.PresentParams.BackBufferWidth             := bestDisplayMode.Width;
  pValidDeviceSettings.PresentParams.BackBufferHeight            := bestDisplayMode.Height;
  pValidDeviceSettings.PresentParams.BackBufferFormat            := pBestDeviceSettingsCombo.BackBufferFormat;
  pValidDeviceSettings.PresentParams.BackBufferCount             := bestBackBufferCount;
  pValidDeviceSettings.PresentParams.MultiSampleType             := bestMultiSampleType;
  pValidDeviceSettings.PresentParams.MultiSampleQuality          := bestMultiSampleQuality;
  pValidDeviceSettings.PresentParams.SwapEffect                  := bestSwapEffect;
  pValidDeviceSettings.PresentParams.hDeviceWindow               := HWND(IfThen(pBestDeviceSettingsCombo.Windowed, z3DCore_GetHWNDDeviceWindowed, z3DCore_GetHWNDDeviceFullScreen));
  pValidDeviceSettings.PresentParams.Windowed                    := pBestDeviceSettingsCombo.Windowed;
  pValidDeviceSettings.PresentParams.EnableAutoDepthStencil      := bestEnableAutoDepthStencil;
  pValidDeviceSettings.PresentParams.AutoDepthStencilFormat      := bestDepthStencilFormat;
  pValidDeviceSettings.PresentParams.Flags                       := dwBestFlags;                   
  pValidDeviceSettings.PresentParams.FullScreen_RefreshRateInHz  := bestDisplayMode.RefreshRate;
  pValidDeviceSettings.PresentParams.PresentationInterval        := bestPresentInterval;
end;

function z3DFindValidResolution(const pBestDeviceSettingsCombo: TD3DDeviceSettingsCombinations; displayModeIn: TD3DDisplayMode; out pBestDisplayMode: TD3DDisplayMode): HRESULT;
var
  bestDisplayMode: TD3DDisplayMode;
  iDisplayMode: Integer;
  nBestRanking: Integer;
  nCurRanking: Integer;
  pDisplayModeList: TD3DDisplayModeArray;
  displayMode: TD3DDisplayMode;
begin
  pDisplayModeList:= nil;
  ZeroMemory(@bestDisplayMode, SizeOf(TD3DDisplayMode));

  if pBestDeviceSettingsCombo.Windowed then
  begin
    // In windowed mode, all resolutions are valid but restritions still apply
    // on the size of the window.  See z3DChangeDevice() for details
    pBestDisplayMode := displayModeIn;
  end else
  begin
    nBestRanking := 100000;
    pDisplayModeList := pBestDeviceSettingsCombo.AdapterInfo.displayModeList^;
    for iDisplayMode:= 0 to Length(pDisplayModeList) - 1 do
    begin
      displayMode := pDisplayModeList[iDisplayMode];

      // Skip display modes that don't match the combo's adapter format
      if (displayMode.Format <> pBestDeviceSettingsCombo.AdapterFormat)
      then Continue;

      // Find the delta between the current width/height and the optimal width/height
      nCurRanking := Abs(Integer(displayMode.Width) - Integer(displayModeIn.Width)) +
                     Abs(Integer(displayMode.Height)- Integer(displayModeIn.Height));

      if (nCurRanking < nBestRanking) then
      begin
        bestDisplayMode := displayMode;
        nBestRanking := nCurRanking;

        // Stop if perfect match found
        if (nBestRanking = 0) then Break;
      end;
    end;

    if (bestDisplayMode.Width = 0) then
    begin
      pBestDisplayMode := displayModeIn;
      Result:= E_FAIL; // No valid display modes found
      Exit;
    end;

    pBestDisplayMode := bestDisplayMode;
  end;

  Result:= S_OK;
end;

function z3DFindAdapterFormat(AdapterOrdinal: LongWord; DeviceType: TD3DDevType; BackBufferFormat: TD3DFormat; Windowed: Boolean; out pAdapterFormat: TD3DFormat): HRESULT;
var
  pd3dEnum: Iz3DDeviceList;
  pDeviceInfo: Iz3DEnumDeviceInfo;
  iDeviceCombo: Integer;
  pDeviceSettingsCombo: PD3DDeviceSettingsCombinations;
begin
  pd3dEnum := z3DPrepareDeviceListObject;
  pDeviceInfo := pd3dEnum.GetDeviceInfo(AdapterOrdinal, DeviceType);
  if (pDeviceInfo <> nil) then
  begin
    for iDeviceCombo:= 0 to Length(pDeviceInfo.deviceSettingsComboList^) - 1 do
    begin
      pDeviceSettingsCombo := pDeviceInfo.deviceSettingsComboList^[iDeviceCombo];
      if (pDeviceSettingsCombo.BackBufferFormat = BackBufferFormat) and
         (pDeviceSettingsCombo.Windowed = Windowed) then
      begin
        // Return the adapter format from the first match
        pAdapterFormat := pDeviceSettingsCombo.AdapterFormat;
        Result:= S_OK;
        Exit;
      end;
    end;
  end;

  pAdapterFormat := BackBufferFormat;
  Result:= E_FAIL;
end;

{$IFDEF FPC}

type
  tagMONITORINFOW = record
    cbSize: DWORD;
    rcMonitor: TRect;
    rcWork: TRect;
    dwFlags: DWORD;
  end;
  PMonitorInfoW = ^tagMONITORINFOW;
  TMonitorInfoW = tagMONITORINFOW;

const
  MONITOR_DEFAULTTONULL = $0;

{$ENDIF}

type
  EXECUTION_STATE = DWORD;
const
  ES_SYSTEM_REQUIRED  = DWORD($00000001);
  ES_DISPLAY_REQUIRED = DWORD($00000002);
  ES_USER_PRESENT     = DWORD($00000004);
  ES_CONTINUOUS       = DWORD($80000000);

function SetThreadExecutionState(esFlags: EXECUTION_STATE): EXECUTION_STATE; stdcall; external kernel32;

function z3DChangeDevice(pNewDeviceSettings: Pz3DDeviceSettings; pd3dDeviceFromApp: IDirect3DDevice9; bForceRecreate: Boolean; bClipWindowToSingleAdapter: Boolean): HRESULT;
var
  pOldDeviceSettings, pNewDeviceSettingsOnHeap: Pz3DDeviceSettings;
  pCallbackModifyDeviceSettings: Tz3DCallback_ModifyDeviceSettings;
  caps: TD3DCaps9;
  pD3D: IDirect3D9;
  bContinue: Boolean;
  rcWindowClient, rcWindowBounds: TRect;
  pd3dDevice: IDirect3DDevice9;
  pd3dEnum: Tz3DDeviceList;
  pAdapterInfo: Tz3DEnumAdapterInfo;
  hAdapterMonitor: HMONITOR;
  ptClient: TPoint;
  wp: TWindowPlacement;
  bKeepCurrentWindowSize: Boolean;
  pwp: PWindowPlacement;
  wpFullscreen: TWindowPlacement;
  dwStyle: DWORD;
  hMenu: Windows.HMENU;
  pd3dCaps: PD3DCaps9;
  bNeedToResize: Boolean;
  nClientWidth, nClientHeight: LongWord;
  rcClient: TRect;
  rcFrame: TRect;
  nFrameWidth, nFrameHeight: Longint;
  miAdapter: Tz3DMonitorInfo;
  nMonitorWidth, nMonitorHeight: Integer;
  hWindowMonitor: HMONITOR;
  miWindow: Tz3DMonitorInfo;
  nAdapterMonitorWidth, nAdapterMonitorHeight: Integer;
  rcWindow, rcResizedWindow: TRect;
  nWindowOffsetX, nWindowOffsetY, nWindowWidth, nWindowHeight: Integer;
  cx, cy: Integer;
  deviceSettings: Tz3DDeviceSettings;
  bMonitorChanged: Boolean;
  bIsTopmost: Boolean;
  hWndInsertAfter: HWND;
begin
  pOldDeviceSettings := z3DCore_GetState.CurrentDeviceSettings;

  if (z3DCore_GetD3DObject = nil) then
  begin
    Result:= S_FALSE;
    Exit;
  end;

  // Make a copy of the pNewDeviceSettings on the heap
  try
    New(pNewDeviceSettingsOnHeap);
  except
    Result:= E_OUTOFMEMORY;
    Exit;
  end;
  Move(pNewDeviceSettings^, pNewDeviceSettingsOnHeap^, SizeOf(Tz3DDeviceSettings));
  pNewDeviceSettings := pNewDeviceSettingsOnHeap;

  // If the ModifyDeviceSettings callback is non-NULL, then call it to let the app 
  // change the settings or reject the device change by returning false.
  pCallbackModifyDeviceSettings := z3DCore_GetState.ModifyDeviceSettingsFunc;
  if Assigned(pCallbackModifyDeviceSettings) then 
  begin
    pD3D := z3DCore_GetD3DObject;
    pD3D.GetDeviceCaps(pNewDeviceSettings.AdapterOrdinal, pNewDeviceSettings.DeviceType, caps);

    bContinue := pCallbackModifyDeviceSettings(pNewDeviceSettings^, caps, z3DCore_GetState.ModifyDeviceSettingsFuncUserContext);
    if not bContinue then
    begin
      // The app rejected the device change by returning false, so just use the current device if there is one.
      if (pOldDeviceSettings = nil) then z3DDisplayErrorMessage(z3DERR_NOCOMPATIBLEDEVICES);
      Dispose(pNewDeviceSettings);
      Result:= E_ABORT;
      Exit;
    end;
    if (z3DCore_GetState.D3D = nil) then 
    begin
      Dispose(pNewDeviceSettings);
      Result:= S_False;
      Exit;
    end;
  end;

  z3DCore_GetState.CurrentDeviceSettings := pNewDeviceSettings;

  z3DCore_Pause(True, True);

  // When a WM_SIZE message is received, it calls z3DCheckForWindowSizeChange().
  // A WM_SIZE message might be sent when adjusting the window, so tell
  // z3DCheckForWindowSizeChange() to ignore size changes temporarily
  z3DCore_GetState.IgnoreSizeChange := True;

  // Update thread safety on/off depending on Direct3D device's thread safety
  g_bThreadSafe := ((pNewDeviceSettings.BehaviorFlags and D3DCREATE_MULTITHREADED) <> 0);

  // Only apply the cmd line overrides if this is the first device created
  // and z3DSetDevice() isn't used
  if (pd3dDeviceFromApp = nil) and (pOldDeviceSettings = nil) then
  begin
    // Updates the device settings struct based on the cmd line args.
    // Warning: if the device doesn't support these new settings then CreateDevice() will fail.
    z3DUpdateDeviceSettingsWithOverrides(pNewDeviceSettings^);
  end;

  // Take note if the backbuffer width & height are 0 now as they will change after pd3dDevice->Reset()
  bKeepCurrentWindowSize := False;
  if (pNewDeviceSettings.PresentParams.BackBufferWidth = 0) and (pNewDeviceSettings.PresentParams.BackBufferHeight = 0)
  then bKeepCurrentWindowSize := True;

  //////////////////////////
  // Before reset
  /////////////////////////
  if pNewDeviceSettings.PresentParams.Windowed then
  begin
    // Going to windowed mode

    if Assigned(pOldDeviceSettings) and not pOldDeviceSettings.PresentParams.Windowed then
    begin
      // Going from fullscreen -> windowed
      z3DCore_GetState.SetFullScreenBackBufferWidthAtModeChange(pOldDeviceSettings.PresentParams.BackBufferWidth);
      z3DCore_GetState.SetFullScreenBackBufferHeightAtModeChange(pOldDeviceSettings.PresentParams.BackBufferHeight);

      // Restore windowed mode style
      SetWindowLong(z3DCore_GetHWNDDeviceWindowed, GWL_STYLE, z3DCore_GetState.GetWindowedStyleAtModeChange);
    end;

    // If different device windows are used for windowed mode and fullscreen mode,
    // hide the fullscreen window so that it doesn't obscure the screen.
    if (z3DCore_GetHWNDDeviceFullScreen <> z3DCore_GetHWNDDeviceWindowed)
    then ShowWindow(z3DCore_GetHWNDDeviceFullScreen, SW_HIDE);

    // If using the same window for windowed and fullscreen mode, reattach menu if one exists
    if (z3DCore_GetHWNDDeviceFullScreen = z3DCore_GetHWNDDeviceWindowed) then
    begin
      if (z3DCore_GetState.Menu <> 0)
      then SetMenu(z3DCore_GetHWNDDeviceWindowed, z3DCore_GetState.GetMenu);
    end;
  end else
  begin
    // Going to fullscreen mode

    if (pOldDeviceSettings = nil) or (Assigned(pOldDeviceSettings) and pOldDeviceSettings.PresentParams.Windowed) then
    begin
      // Transistioning to full screen mode from a standard window so
      // save current window position/size/style now in case the user toggles to windowed mode later
      pwp := z3DCore_GetState.GetWindowedPlacement;
      ZeroMemory(pwp, SizeOf(TWindowPlacement));
      pwp.length := SizeOf(TWindowPlacement);
      {$IFDEF FPC}
      GetWindowPlacement(z3DCore_GetHWNDDeviceWindowed, pwp^);
      {$ELSE}
      GetWindowPlacement(z3DCore_GetHWNDDeviceWindowed, pwp);
      {$ENDIF}
      bIsTopmost := GetWindowLong(z3DCore_GetHWNDDeviceWindowed, GWL_EXSTYLE) and WS_EX_TOPMOST <> 0;
      z3DCore_GetState.SetTopmostWhileWindowed(bIsTopmost);
      dwStyle := GetWindowLong(z3DCore_GetHWNDDeviceWindowed, GWL_STYLE);
      dwStyle := dwStyle and not WS_MAXIMIZE and not WS_MINIMIZE; // remove minimize/maximize style
      z3DCore_GetState.SetWindowedStyleAtModeChange(dwStyle);
      if Assigned(pOldDeviceSettings) then
      begin
        z3DCore_GetState.SetWindowBackBufferWidthAtModeChange(pOldDeviceSettings.PresentParams.BackBufferWidth);
        z3DCore_GetState.SetWindowBackBufferHeightAtModeChange(pOldDeviceSettings.PresentParams.BackBufferHeight);
      end;
    end;

    // Hide the window to avoid animation of blank windows
    ShowWindow(z3DCore_GetHWNDDeviceFullScreen, SW_HIDE);

    // Set FS window style
    SetWindowLong(z3DCore_GetHWNDDeviceFullScreen, GWL_STYLE, Integer(WS_POPUP or WS_SYSMENU));

    // If using the same window for windowed and fullscreen mode, save and remove menu
    if (z3DCore_GetHWNDDeviceFullScreen = z3DCore_GetHWNDDeviceWindowed) then
    begin
      hMenu := GetMenu(z3DCore_GetHWNDDeviceFullScreen);
      z3DCore_GetState.SetMenu(hMenu);
      SetMenu(z3DCore_GetHWNDDeviceFullScreen, 0);
    end;

    ZeroMemory(@wpFullscreen, SizeOf(TWindowPlacement));
    wpFullscreen.length := SizeOf(TWindowPlacement);
    {$IFDEF FPC}
    GetWindowPlacement(z3DCore_GetHWNDDeviceFullScreen, wpFullscreen);
    {$ELSE}
    GetWindowPlacement(z3DCore_GetHWNDDeviceFullScreen, @wpFullscreen);
    {$ENDIF}
    if ((wpFullscreen.flags and WPF_RESTORETOMAXIMIZED) <> 0) then
    begin
      // Restore the window to normal if the window was maximized then minimized.  This causes the
      // WPF_RESTORETOMAXIMIZED flag to be set which will cause SW_RESTORE to restore the
      // window from minimized to maxmized which isn't what we want
      with wpFullscreen do flags := flags and not WPF_RESTORETOMAXIMIZED;
      wpFullscreen.showCmd := SW_RESTORE;
      {$IFDEF FPC}
      SetWindowPlacement(z3DCore_GetHWNDDeviceFullScreen, wpFullscreen);
      {$ELSE}
      SetWindowPlacement(z3DCore_GetHWNDDeviceFullScreen, @wpFullscreen);
      {$ENDIF}
    end;
  end;

  // If AdapterOrdinal and DeviceType are the same, we can just do a Reset().
  // If they've changed, we need to do a complete device tear down/rebuild.
  // Also only allow a reset if pd3dDevice is the same as the current device
  if not bForceRecreate and
     ((pd3dDeviceFromApp = nil) or (pd3dDeviceFromApp = z3DCore_GetD3DDevice)) and
     (z3DCore_GetD3DDevice <> nil) and
     (pOldDeviceSettings <> nil) and
     (pOldDeviceSettings.AdapterOrdinal = pNewDeviceSettings.AdapterOrdinal) and
     (pOldDeviceSettings.DeviceType = pNewDeviceSettings.DeviceType) and
     (pOldDeviceSettings.BehaviorFlags = pNewDeviceSettings.BehaviorFlags) then
  begin
    // Reset the Direct3D device and call the app's device callbacks
    Result := z3DReset3DEnvironment;
    if FAILED(Result) then
    begin
      if (Result = D3DERR_DEVICELOST) then
      begin
        // The device is lost, just mark it as so and continue on with
        // capturing the state and resizing the window/etc.
        z3DCore_GetState.DeviceLost:= True;
      end
      else if (Result = z3DERR_RESETTINGDEVICEOBJECTS) or
              (Result = z3DERR_MEDIANOTFOUND) then
      begin
        // Something bad happened in the app callbacks
        Dispose(pOldDeviceSettings);
        z3DDisplayErrorMessage(Result);
        z3DCore_Shutdown;
        Exit; // Result:= hr;
      end
      else // z3DERR_RESETTINGDEVICE
      begin
        // Reset failed and the device wasn't lost and it wasn't the apps fault,
        // so recreate the device to try to recover
        //todo: Fill bug report: should SafeDelete( pNewDeviceSettings ); and Pause (False)
        z3DCore_GetState.CurrentDeviceSettings := pOldDeviceSettings;
        if FAILED(z3DChangeDevice(pNewDeviceSettings, pd3dDeviceFromApp, True, bClipWindowToSingleAdapter)) then
        begin
          // If that fails, then shutdown
          z3DCore_Shutdown;
          Result:= z3DERR_CREATINGDEVICE;
        end else
          Result:= S_OK;
          
        Dispose(pNewDeviceSettings);
        Exit;
      end;
    end;
  end else
  begin
    // Cleanup if not first device created
    if (pOldDeviceSettings <> nil) then z3DCleanup3DEnvironment(False);

    // Create the D3D device and call the app's device callbacks
    Result := z3DCreate3DEnvironment(pd3dDeviceFromApp);
    if FAILED(Result) then
    begin
      Dispose(pOldDeviceSettings);
      z3DCleanup3DEnvironment;
      z3DDisplayErrorMessage(Result);
      z3DCore_Pause(False, False);
      z3DCore_GetState.SetIgnoreSizeChange(False);
      Exit;
    end;
  end;

  // Enable/disable StickKeys shortcut, ToggleKeys shortcut, FilterKeys shortcut, and Windows key
  // to prevent accidental task switching
  if pNewDeviceSettings.PresentParams.Windowed
  then z3DAllowShortcutKeys(z3DCore_GetState.GetAllowShortcutKeysWhenWindowed)
  else z3DAllowShortcutKeys(z3DCore_GetState.GetAllowShortcutKeysWhenFullscreen);

  pD3D := z3DCore_GetD3DObject;
  hAdapterMonitor := pD3D.GetAdapterMonitor(pNewDeviceSettings.AdapterOrdinal);
  z3DCore_GetState.SetAdapterMonitor(hAdapterMonitor);

  // Update the device stats text
  z3DUpdateStaticFrameStats;

  if (pOldDeviceSettings <> nil) and not pOldDeviceSettings.PresentParams.Windowed and pNewDeviceSettings.PresentParams.Windowed then
  begin
    // Going from fullscreen -> windowed

    // Restore the show state, and positions/size of the window to what it was
    // It is important to adjust the window size
    // after resetting the device rather than beforehand to ensure
    // that the monitor resolution is correct and does not limit the size of the new window.
    pwp := z3DCore_GetState.GetWindowedPlacement;
    {$IFDEF FPC}
    SetWindowPlacement(z3DCore_GetHWNDDeviceWindowed, pwp^);
    {$ELSE}
    SetWindowPlacement(z3DCore_GetHWNDDeviceWindowed, pwp);
    {$ENDIF}

    // Also restore the z-order of window to previous state
    if z3DCore_GetState.GetTopmostWhileWindowed then hWndInsertAfter := HWND_TOPMOST else hWndInsertAfter := HWND_NOTOPMOST;
    SetWindowPos(z3DCore_GetHWNDDeviceWindowed, hWndInsertAfter, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOREDRAW or SWP_NOSIZE);
  end;

  // Check to see if the window needs to be resized.  
  // Handle cases where the window is minimized and maxmimized as well.
  bNeedToResize := False;
  if pNewDeviceSettings.PresentParams.Windowed and // only resize if in windowed mode
     not bKeepCurrentWindowSize then    // only resize if pp.BackbufferWidth/Height were not 0
  begin
    if IsIconic(z3DCore_GetHWNDDeviceWindowed) then
    begin
      // Window is currently minimized. To tell if it needs to resize,
      // get the client rect of window when its restored the
      // hard way using GetWindowPlacement()
      ZeroMemory(@wp, SizeOf(TWindowPlacement));
      wp.length := SizeOf(TWindowPlacement);
      {$IFDEF FPC}
      GetWindowPlacement(z3DCore_GetHWNDDeviceWindowed, wp);
      {$ELSE}
      GetWindowPlacement(z3DCore_GetHWNDDeviceWindowed, @wp);
      {$ENDIF}

      if (wp.flags and WPF_RESTORETOMAXIMIZED <> 0) and (wp.showCmd = SW_SHOWMINIMIZED) then
      begin
        // WPF_RESTORETOMAXIMIZED means that when the window is restored it will
        // be maximized.  So maximize the window temporarily to get the client rect
        // when the window is maximized.  GetSystemMetrics( SM_CXMAXIMIZED ) will give this
        // information if the window is on the primary but this will work on multimon.
        ShowWindow(z3DCore_GetHWNDDeviceWindowed, SW_RESTORE);
        GetClientRect(z3DCore_GetHWNDDeviceWindowed, rcClient);
        nClientWidth  := (rcClient.right - rcClient.left);
        nClientHeight := (rcClient.bottom - rcClient.top);
        ShowWindow(z3DCore_GetHWNDDeviceWindowed, SW_MINIMIZE);
      end else
      begin
        // Use wp.rcNormalPosition to get the client rect, but wp.rcNormalPosition
        // includes the window frame so subtract it
        rcFrame := Rect(0, 0, 0, 0);
        AdjustWindowRect(rcFrame, z3DCore_GetState.GetWindowedStyleAtModeChange, z3DCore_GetState.Menu <> 0);
        nFrameWidth := rcFrame.right - rcFrame.left;
        nFrameHeight := rcFrame.bottom - rcFrame.top;
        nClientWidth  := (wp.rcNormalPosition.right - wp.rcNormalPosition.left - nFrameWidth);
        nClientHeight := (wp.rcNormalPosition.bottom - wp.rcNormalPosition.top - nFrameHeight);
      end;
    end else
    begin
      // Window is restored or maximized so just get its client rect
      GetClientRect(z3DCore_GetHWNDDeviceWindowed, rcClient);
      nClientWidth  := (rcClient.right - rcClient.left);
      nClientHeight := (rcClient.bottom - rcClient.top);
    end;

    // Now that we know the client rect, compare it against the back buffer size
    // to see if the client rect is already the right size
    if (nClientWidth  <> pNewDeviceSettings.PresentParams.BackBufferWidth) or
       (nClientHeight <> pNewDeviceSettings.PresentParams.BackBufferHeight) then
    begin
      bNeedToResize := True;
    end;

    if bClipWindowToSingleAdapter and not IsIconic(z3DCore_GetHWNDDeviceWindowed) then
    begin
      // Get the rect of the monitor attached to the adapter
      miAdapter.cbSize := SizeOf(Tz3DMonitorInfo);
      hAdapterMonitor := z3DCore_GetD3DObject.GetAdapterMonitor(pNewDeviceSettings.AdapterOrdinal);
      z3DGetMonitorInfo(hAdapterMonitor, miAdapter);
      hWindowMonitor := z3DMonitorFromWindow(z3DCore_GetHWND, MONITOR_DEFAULTTOPRIMARY);

      // Get the rect of the window
      GetWindowRect(z3DCore_GetHWNDDeviceWindowed, rcWindow);

      // Check if the window rect is fully inside the adapter's vitural screen rect
      if (rcWindow.left   < miAdapter.rcWork.left)   or
         (rcWindow.right  > miAdapter.rcWork.right)  or
         (rcWindow.top    < miAdapter.rcWork.top)    or
         (rcWindow.bottom > miAdapter.rcWork.bottom) then
      begin
        if (hWindowMonitor = hAdapterMonitor) and IsZoomed(z3DCore_GetHWNDDeviceWindowed) then
        begin
          // If the window is maximized and on the same monitor as the adapter, then
          // no need to clip to single adapter as the window is already clipped
          // even though the rcWindow rect is outside of the miAdapter.rcWork
        end else
        begin
          bNeedToResize := True;
        end;
      end;
    end;
  end;

  // Only resize window if needed
  if bNeedToResize then
  begin
    // Need to resize, so if window is maximized or minimized then restore the window
    if IsIconic(z3DCore_GetHWNDDeviceWindowed) then ShowWindow(z3DCore_GetHWNDDeviceWindowed, SW_RESTORE);
    if IsZoomed(z3DCore_GetHWNDDeviceWindowed) then // doing the IsIconic() check first also handles the WPF_RESTORETOMAXIMIZED case
      ShowWindow(z3DCore_GetHWNDDeviceWindowed, SW_RESTORE);

    if bClipWindowToSingleAdapter then
    begin
      // Get the rect of the monitor attached to the adapter
      miAdapter.cbSize := SizeOf(Tz3DMonitorInfo);
      z3DGetMonitorInfo(z3DCore_GetD3DObject.GetAdapterMonitor(pNewDeviceSettings.AdapterOrdinal), miAdapter);

      // Get the rect of the monitor attached to the window
      miWindow.cbSize := SizeOf(Tz3DMonitorInfo);
      z3DGetMonitorInfo(z3DMonitorFromWindow(z3DCore_GetHWND, MONITOR_DEFAULTTOPRIMARY), miWindow);

      // Do something reasonable if the BackBuffer size is greater than the monitor size
      nAdapterMonitorWidth := miAdapter.rcWork.right - miAdapter.rcWork.left;
      nAdapterMonitorHeight := miAdapter.rcWork.bottom - miAdapter.rcWork.top;

      nClientWidth := pNewDeviceSettings.PresentParams.BackBufferWidth;
      nClientHeight := pNewDeviceSettings.PresentParams.BackBufferHeight;

      // Get the rect of the window
      GetWindowRect(z3DCore_GetHWNDDeviceWindowed, rcWindow);

      // Make a window rect with a client rect that is the same size as the backbuffer
      rcResizedWindow.left := 0;
      rcResizedWindow.right := nClientWidth;
      rcResizedWindow.top := 0;
      rcResizedWindow.bottom := nClientHeight;
      AdjustWindowRect(rcResizedWindow, GetWindowLong(z3DCore_GetHWNDDeviceWindowed, GWL_STYLE), z3DCore_GetState.Menu <> 0);

      nWindowWidth := rcResizedWindow.right - rcResizedWindow.left;
      nWindowHeight := rcResizedWindow.bottom - rcResizedWindow.top;

      if (nWindowWidth > nAdapterMonitorWidth) then nWindowWidth := (nAdapterMonitorWidth - 0);
      if (nWindowHeight > nAdapterMonitorHeight) then nWindowHeight := (nAdapterMonitorHeight - 0);

      if (rcResizedWindow.left < miAdapter.rcWork.left) or
         (rcResizedWindow.top < miAdapter.rcWork.top) or
         (rcResizedWindow.right > miAdapter.rcWork.right) or
         (rcResizedWindow.bottom > miAdapter.rcWork.bottom) then
      begin
        nWindowOffsetX := (nAdapterMonitorWidth - nWindowWidth) div 2;
        nWindowOffsetY := (nAdapterMonitorHeight - nWindowHeight) div 2;

        rcResizedWindow.left := miAdapter.rcWork.left + nWindowOffsetX;
        rcResizedWindow.top := miAdapter.rcWork.top + nWindowOffsetY;
        rcResizedWindow.right := miAdapter.rcWork.left + nWindowOffsetX + nWindowWidth;
        rcResizedWindow.bottom := miAdapter.rcWork.top + nWindowOffsetY + nWindowHeight;
      end;

      // Resize the window.  It is important to adjust the window size
      // after resetting the device rather than beforehand to ensure
      // that the monitor resolution is correct and does not limit the size of the new window.
      SetWindowPos(z3DCore_GetHWNDDeviceWindowed, 0, rcResizedWindow.left, rcResizedWindow.top, nWindowWidth, nWindowHeight, SWP_NOZORDER);
    end else
    begin
      // Make a window rect with a client rect that is the same size as the backbuffer
      rcWindow := Rect(0, 0, 0, 0);
      rcWindow.right := (pNewDeviceSettings.PresentParams.BackBufferWidth);
      rcWindow.bottom := (pNewDeviceSettings.PresentParams.BackBufferHeight);
      AdjustWindowRect(rcWindow, GetWindowLong(z3DCore_GetHWNDDeviceWindowed, GWL_STYLE), z3DCore_GetState.Menu <> 0);

      // Resize the window.  It is important to adjust the window size
      // after resetting the device rather than beforehand to ensure
      // that the monitor resolution is correct and does not limit the size of the new window.
      cx := (rcWindow.right - rcWindow.left);
      cy := (rcWindow.bottom - rcWindow.top);
      SetWindowPos(z3DCore_GetHWNDDeviceWindowed, 0, 0, 0, cx, cy, SWP_NOZORDER or SWP_NOMOVE);
    end;

    // Its possible that the new window size is not what we asked for.
    // No window can be sized larger than the desktop, so see see if the Windows OS resized the
    // window to something smaller to fit on the desktop.  Also if WM_GETMINMAXINFO
    // will put a limit on the smallest/largest window size.
    GetClientRect(z3DCore_GetHWNDDeviceWindowed, rcClient);
    nClientWidth  := (rcClient.right - rcClient.left);
    nClientHeight := (rcClient.bottom - rcClient.top);
    if (nClientWidth  <> pNewDeviceSettings.PresentParams.BackBufferWidth) or
       (nClientHeight <> pNewDeviceSettings.PresentParams.BackBufferHeight) then
    begin
      // If its different, then resize the backbuffer again.  This time create a backbuffer that matches the
      // client rect of the current window w/o resizing the window.
      deviceSettings := z3DCore_GetDeviceSettings;
      deviceSettings.PresentParams.BackBufferWidth  := 0;
      deviceSettings.PresentParams.BackBufferHeight := 0;
      Result := z3DChangeDevice(@deviceSettings, nil, False, bClipWindowToSingleAdapter);
      if FAILED(Result) then
      begin
        Dispose(pOldDeviceSettings);
        z3DCleanup3DEnvironment;
        z3DCore_Pause(False, False);
        z3DCore_GetState.SetIgnoreSizeChange(False);
        Exit;
      end;
    end;
  end;

  // Make the window visible
  if not IsWindowVisible(z3DCore_GetHWND) then ShowWindow(z3DCore_GetHWND, SW_SHOW);

  // Make the window visible
  if not IsWindowVisible(z3DCore_GetHWND) then ShowWindow(z3DCore_GetHWND, SW_SHOW);

  // Ensure that the display doesn't power down when fullscreen but does when windowed
  if not z3DCore_IsWindowed
  then SetThreadExecutionState(ES_DISPLAY_REQUIRED or ES_CONTINUOUS)
  else SetThreadExecutionState(ES_CONTINUOUS);

  Dispose(pOldDeviceSettings);
  z3DCore_GetState.IgnoreSizeChange:= False;
  z3DCore_Pause(False, False);
  z3DCore_GetState.DeviceCreated:= True;

  Result:= S_OK;
end;

function LowLevelKeyboardProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  bEatKeystroke: Boolean;
  p: PKBDLLHookStruct;
begin
  if (nCode < 0) or (nCode <> HC_ACTION) then // do not process message
  begin
    Result:= CallNextHookEx(z3DCore_GetState.GetKeyboardHook, nCode, wParam, lParam);
    Exit;
  end;

  bEatKeystroke := False;
  p := PKBDLLHookStruct(lParam);
  case wParam of
    WM_KEYDOWN, WM_KEYUP:
    begin
      bEatKeystroke := not z3DCore_GetState.GetAllowShortcutKeys and
                      ((p.vkCode = VK_LWIN) or (p.vkCode = VK_RWIN));
    end;
  end;

  if bEatKeystroke then Result:= 1
  else Result:= CallNextHookEx(z3DCore_GetState.GetKeyboardHook, nCode, wParam, lParam);
end;

procedure z3DCore_SetShortcutKeySettings(bAllowWhenFullscreen, bAllowWhenWindowed: Boolean);
begin
  z3DCore_GetState.SetAllowShortcutKeysWhenWindowed(bAllowWhenWindowed);
  z3DCore_GetState.SetAllowShortcutKeysWhenFullscreen(bAllowWhenFullscreen);

  if z3DCore_GetState.z3DInited then
  begin
    if z3DCore_IsWindowed
    then z3DAllowShortcutKeys(z3DCore_GetState.GetAllowShortcutKeysWhenWindowed)
    else z3DAllowShortcutKeys(z3DCore_GetState.GetAllowShortcutKeysWhenFullscreen);
  end;
end;

procedure z3DAllowShortcutKeys(bAllowKeys: Boolean);
var
  sk: TStickyKeys;
  tk: TToggleKeys;
  fk: TFilterKeys;
  OSVersionInfo: TOSVersionInfo;
  hKeyboardHook: HHOOK;
  skOff: TStickyKeys;
  tkOff: TToggleKeys;
  fkOff: TFilterKeys;
begin
  z3DCore_GetState.AllowShortcutKeys := bAllowKeys;

  if bAllowKeys then
  begin
    // Restore StickyKeys/etc to original state and enable Windows key
    sk := z3DCore_GetState.StartupStickyKeys;
    tk := z3DCore_GetState.StartupToggleKeys;
    fk := z3DCore_GetState.StartupFilterKeys;

    SystemParametersInfo(SPI_SETSTICKYKEYS, SizeOf(sk), @sk, 0);
    SystemParametersInfo(SPI_SETTOGGLEKEYS, SizeOf(tk), @tk, 0);
    SystemParametersInfo(SPI_SETFILTERKEYS, SizeOf(fk), @fk, 0);

    // Remove the keyboard hoook when it isn't needed to prevent any slow down of other apps
    if (z3DCore_GetState.KeyboardHook <> 0) then
    begin
      UnhookWindowsHookEx(z3DCore_GetState.KeyboardHook);
      z3DCore_GetState.KeyboardHook := 0;
    end;
  end else
  begin
    // Set low level keyboard hook if haven't already
    if (z3DCore_GetState.KeyboardHook = 0) then
    begin
      // Set the low-level hook procedure.  Only works on Windows 2000 and above
      OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
      GetVersionEx(OSVersionInfo);
      if (OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT) and (OSVersionInfo.dwMajorVersion > 4) then
      begin
        hKeyboardHook := SetWindowsHookEx(WH_KEYBOARD_LL, @LowLevelKeyboardProc, GetModuleHandle(nil), 0);
        z3DCore_GetState.SetKeyboardHook(hKeyboardHook);
      end;
    end;

    // Disable StickyKeys/etc shortcuts but if the accessibility feature is on,
    // then leave the settings alone as its probably being usefully used

    skOff := z3DCore_GetState.StartupStickyKeys;
    if (skOff.dwFlags and SKF_STICKYKEYSON = 0) then
    begin
      // Disable the hotkey and the confirmation
      skOff.dwFlags := skOff.dwFlags and not SKF_HOTKEYACTIVE;
      skOff.dwFlags := skOff.dwFlags and not SKF_CONFIRMHOTKEY;

      SystemParametersInfo(SPI_SETSTICKYKEYS, SizeOf(skOff), @skOff, 0);
    end;

    tkOff := z3DCore_GetState.StartupToggleKeys;
    if (tkOff.dwFlags and TKF_TOGGLEKEYSON = 0) then 
    begin
      // Disable the hotkey and the confirmation
      tkOff.dwFlags := tkOff.dwFlags and not TKF_HOTKEYACTIVE;
      tkOff.dwFlags := tkOff.dwFlags and not TKF_CONFIRMHOTKEY;

      SystemParametersInfo(SPI_SETTOGGLEKEYS, SizeOf(tkOff), @tkOff, 0);
    end;

    fkOff := z3DCore_GetState.StartupFilterKeys;
    if (fkOff.dwFlags and FKF_FILTERKEYSON = 0) then
    begin
      // Disable the hotkey and the confirmation
      fkOff.dwFlags := fkOff.dwFlags and not FKF_HOTKEYACTIVE;
      fkOff.dwFlags := fkOff.dwFlags and not FKF_CONFIRMHOTKEY;

      SystemParametersInfo(SPI_SETFILTERKEYS, SizeOf(fkOff), @fkOff, 0);
    end;
  end;
end;

procedure z3DUpdateDeviceSettingsWithOverrides(out pDeviceSettings: Tz3DDeviceSettings);
begin
  if (z3DCore_GetState.GetOverrideAdapterOrdinal <> -1) then
      pDeviceSettings.AdapterOrdinal := z3DCore_GetState.GetOverrideAdapterOrdinal;

  if z3DCore_GetState.OverrideFullScreen then pDeviceSettings.PresentParams.Windowed := False;
  if z3DCore_GetState.OverrideWindowed then pDeviceSettings.PresentParams.Windowed := True;

  if z3DCore_GetState.OverrideForceREF then
    pDeviceSettings.DeviceType := D3DDEVTYPE_REF
  else if z3DCore_GetState.OverrideForceHAL then
    pDeviceSettings.DeviceType := D3DDEVTYPE_HAL;

  if (z3DCore_GetState.OverrideWidth <> 0) then
      pDeviceSettings.PresentParams.BackBufferWidth := z3DCore_GetState.OverrideWidth;
  if (z3DCore_GetState.OverrideHeight <> 0) then
      pDeviceSettings.PresentParams.BackBufferHeight := z3DCore_GetState.OverrideHeight;

  if z3DCore_GetState.OverrideForcePureHWVP then
  begin
    pDeviceSettings.BehaviorFlags := pDeviceSettings.BehaviorFlags and not D3DCREATE_SOFTWARE_VERTEXPROCESSING;
    pDeviceSettings.BehaviorFlags := pDeviceSettings.BehaviorFlags or D3DCREATE_HARDWARE_VERTEXPROCESSING;
    pDeviceSettings.BehaviorFlags := pDeviceSettings.BehaviorFlags or D3DCREATE_PUREDEVICE;
  end
  else if z3DCore_GetState.OverrideForceHWVP then
  begin
    pDeviceSettings.BehaviorFlags := pDeviceSettings.BehaviorFlags and not D3DCREATE_SOFTWARE_VERTEXPROCESSING;
    pDeviceSettings.BehaviorFlags := pDeviceSettings.BehaviorFlags and not D3DCREATE_PUREDEVICE;
    pDeviceSettings.BehaviorFlags := pDeviceSettings.BehaviorFlags or D3DCREATE_HARDWARE_VERTEXPROCESSING;
  end
  else if z3DCore_GetState.OverrideForceSWVP then
  begin
    pDeviceSettings.BehaviorFlags := pDeviceSettings.BehaviorFlags and not D3DCREATE_HARDWARE_VERTEXPROCESSING;
    pDeviceSettings.BehaviorFlags := pDeviceSettings.BehaviorFlags and not D3DCREATE_PUREDEVICE;
    pDeviceSettings.BehaviorFlags := pDeviceSettings.BehaviorFlags or D3DCREATE_SOFTWARE_VERTEXPROCESSING;
  end;
end;

function z3DCreate3DEnvironment(const pd3dDeviceFromApp: IDirect3DDevice9): HRESULT;
var
  pd3dDevice: IDirect3DDevice9;
  pNewDeviceSettings: Pz3DDeviceSettings;
  pD3D: IDirect3D9;
  pd3dEnum: Iz3DDeviceList;
  pAdapterInfo: Iz3DEnumAdapterInfo;
  pbackBufferSurfaceDesc: PD3DSurfaceDesc;
  pCallbackDeviceCreated: Tz3DCallback_DeviceCreated;
  pCallbackDeviceReset: Tz3DCallback_DeviceReset;
  pd3dCaps: PD3DCaps9;
begin
  pNewDeviceSettings := z3DCore_GetState.GetCurrentDeviceSettings;

  // Only create a Direct3D device if one hasn't been supplied by the app
  if (pd3dDeviceFromApp = nil) then
  begin
    // Try to create the device with the chosen settings
    pD3D := z3DCore_GetD3DObject;
    Result := pD3D.CreateDevice(pNewDeviceSettings.AdapterOrdinal, pNewDeviceSettings.DeviceType,
                                z3DCore_GetHWNDFocus, pNewDeviceSettings.BehaviorFlags,
                                @pNewDeviceSettings.PresentParams, pd3dDevice);
    if (Result = D3DERR_DEVICELOST) then
    begin
      z3DCore_GetState.DeviceLost := True;
      Result:= S_OK;
      Exit;
    end
    else if FAILED(Result) then
    begin
      z3DError('CreateDevice', Result);
      Result:= z3DERR_CREATINGDEVICE;
      Exit;
    end;
  end else
  begin
    // pd3dDeviceFromApp.AddRef; // - done automagically in Delphi
    pd3dDevice := pd3dDeviceFromApp;
  end;

  z3DCore_GetState.SetD3DDevice(pd3dDevice);

  // If switching to REF, set the exit code to 11.  If switching to HAL and exit code was 11, then set it back to 0.
  if (pNewDeviceSettings.DeviceType = D3DDEVTYPE_REF) and (z3DCore_GetState.GetExitCode = 0)
  then z3DCore_GetState.SetExitCode(11)
  else if (pNewDeviceSettings.DeviceType = D3DDEVTYPE_HAL) and (z3DCore_GetState.GetExitCode = 11)
  then z3DCore_GetState.SetExitCode(0);

  // Update back buffer desc before calling app's device callbacks
  z3DUpdateBackBufferDesc;

  // Setup cursor based on current settings (window/fullscreen mode, show cursor state, clip cursor state)
  z3DSetupCursor;

  // Update z3DCore_GetState()'s copy of D3D caps
  pd3dCaps := z3DCore_GetState.Caps;
  z3DCore_GetD3DDevice.GetDeviceCaps(pd3dCaps^);

  // Update the device stats text
  pd3dEnum := z3DPrepareDeviceListObject;
  pAdapterInfo := pd3dEnum.GetAdapterInfo(pNewDeviceSettings.AdapterOrdinal);
  z3DUpdateDeviceStats(pNewDeviceSettings.DeviceType,
                        pNewDeviceSettings.BehaviorFlags,
                        pAdapterInfo.AdapterIdentifier^);

  // Call the resource cache created function
  Result := z3DCore_GetGlobalResourceCache.OnCreateDevice(pd3dDevice);
  if FAILED(Result) then
  begin
    if (Result <> z3DERR_MEDIANOTFOUND) then Result:= z3DERR_CREATINGDEVICEOBJECTS;
    Result:= z3DError('OnCreateDevice', Result);
    Exit;
  end;

  // Call the app's device created callback if non-NULL
  pbackBufferSurfaceDesc := z3DCore_GetBackBufferSurfaceDesc;
  z3DCore_GetState.InsideDeviceCallback := True;
  pCallbackDeviceCreated := z3DCore_GetState.DeviceCreatedFunc;
  Result := S_OK;
  if (@pCallbackDeviceCreated <> nil) then
    Result := pCallbackDeviceCreated(z3DCore_GetD3DDevice, pbackBufferSurfaceDesc^, z3DCore_GetState.DeviceCreatedFuncUserContext);
  z3DCore_GetState.InsideDeviceCallback := False;
  if (z3DCore_GetD3DDevice = nil) then // Handle z3DShutdown from inside callback
  begin
    Result:= E_FAIL;
    Exit;
  end;

  if FAILED(Result) then
  begin
    z3DError('DeviceCreated callback', Result);
    if (Result <> z3DERR_MEDIANOTFOUND) then Result := z3DERR_CREATINGDEVICEOBJECTS;
    Exit;
  end;
  z3DCore_GetState.DeviceObjectsCreated := True;

  // Call the resource cache device reset function
  Result := z3DCore_GetGlobalResourceCache.OnResetDevice(pd3dDevice);
  if FAILED(Result) then
  begin
    Result:= z3DError('OnResetDevice', z3DERR_RESETTINGDEVICEOBJECTS);
    Exit;
  end;

  // Call the app's device reset callback if non-NULL
  z3DCore_GetState.InsideDeviceCallback := True;
  pCallbackDeviceReset := z3DCore_GetState.DeviceResetFunc;
  Result := S_OK;
  if (@pCallbackDeviceReset <> nil) then
    Result := pCallbackDeviceReset(z3DCore_GetD3DDevice, pbackBufferSurfaceDesc^, z3DCore_GetState.GetDeviceResetFuncUserContext);
  z3DCore_GetState.InsideDeviceCallback := False;
  if (z3DCore_GetD3DDevice = nil) then // Handle z3DShutdown from inside callback
  begin
    Result:= E_FAIL;
    Exit;
  end;

  if FAILED(Result) then
  begin
    z3DError('DeviceReset callback', Result);
    if (Result <> z3DERR_MEDIANOTFOUND) then Result := z3DERR_RESETTINGDEVICEOBJECTS;
    Exit;
  end;
  z3DCore_GetState.DeviceObjectsReset := True;

  Result:= S_OK;
end;

function z3DReset3DEnvironment: HRESULT;
var
  pd3dDevice: IDirect3DDevice9;
  pCallbackDeviceLost: Tz3DCallback_DeviceLost;
  pDeviceSettings: Pz3DDeviceSettings;
  pbackBufferSurfaceDesc: PD3DSurfaceDesc;
  pCallbackDeviceReset: Tz3DCallback_DeviceReset;
begin
  pd3dDevice := z3DCore_GetD3DDevice;     
  Assert(pd3dDevice <> nil);

  // Call the app's device lost callback
  if z3DCore_GetState.DeviceObjectsReset then
  begin
    z3DCore_GetState.InsideDeviceCallback:= True;

    pCallbackDeviceLost := z3DCore_GetState.DeviceLostFunc;
    if (@pCallbackDeviceLost <> nil) then pCallbackDeviceLost(z3DCore_GetState.DeviceLostFuncUserContext);
    z3DCore_GetState.DeviceObjectsReset:= False;
    z3DCore_GetState.InsideDeviceCallback:= False;

    // Call the resource cache device lost function
    z3DCore_GetGlobalResourceCache.OnLostDevice;
  end;

  // Reset the device
  pDeviceSettings := z3DCore_GetState.CurrentDeviceSettings;
  Result := pd3dDevice.Reset(pDeviceSettings.PresentParams);
  if FAILED(Result) then
  begin
    if (Result = D3DERR_DEVICELOST)
    then Result := D3DERR_DEVICELOST // Reset could legitimately fail if the device is lost
    else Result := z3DError('Reset', z3DERR_RESETTINGDEVICE);
    Exit;
  end;

  // Update back buffer desc before calling app's device callbacks
  z3DUpdateBackBufferDesc;

  // Setup cursor based on current settings (window/fullscreen mode, show cursor state, clip cursor state)
  z3DSetupCursor;

  Result := z3DCore_GetGlobalResourceCache.OnResetDevice(pd3dDevice);
  if FAILED(Result) then
  begin
    Result:= z3DError('OnResetDevice', z3DERR_RESETTINGDEVICEOBJECTS);
    Exit;
  end;

  // Call the app's OnDeviceReset callback
  z3DCore_GetState.SetInsideDeviceCallback(True);
  pbackBufferSurfaceDesc := z3DCore_GetBackBufferSurfaceDesc;
  pCallbackDeviceReset := z3DCore_GetState.DeviceResetFunc;
  Result := S_OK;
  if (@pCallbackDeviceReset <> nil) then
    Result := pCallbackDeviceReset(pd3dDevice, pbackBufferSurfaceDesc^, z3DCore_GetState.GetDeviceResetFuncUserContext);
  z3DCore_GetState.SetInsideDeviceCallback(False);
  if FAILED(Result) then
  begin
    // If callback failed, cleanup
    z3DError('DeviceResetCallback', Result);
    if (Result <> z3DERR_MEDIANOTFOUND) then Result:= z3DERR_RESETTINGDEVICEOBJECTS;

    z3DCore_GetState.InsideDeviceCallback := True;

    pCallbackDeviceLost := z3DCore_GetState.DeviceLostFunc;
    if (@pCallbackDeviceLost <> nil) then pCallbackDeviceLost(z3DCore_GetState.DeviceLostFuncUserContext);

    z3DCore_GetState.InsideDeviceCallback := False;

    z3DCore_GetGlobalResourceCache.OnLostDevice;
    Exit;
  end;

  // Success
  z3DCore_GetState.DeviceObjectsReset := True;
  
  Result:= S_OK;
end;

procedure z3DCore_Pause(bPauseTime, bPauseRendering: Boolean);
var
  nPauseTimeCount: Integer;
  nPauseRenderingCount: Integer;
begin
  nPauseTimeCount := z3DCore_GetState.PauseTimeCount;
  Inc(nPauseTimeCount, IfThen(bPauseTime, +1, -1));
  if (nPauseTimeCount < 0) then nPauseTimeCount := 0;
  z3DCore_GetState.SetPauseTimeCount(nPauseTimeCount);

  nPauseRenderingCount := z3DCore_GetState.GetPauseRenderingCount;
  Inc(nPauseRenderingCount, IfThen(bPauseRendering, +1, -1));
  if (nPauseRenderingCount < 0) then nPauseRenderingCount := 0;
  z3DCore_GetState.SetPauseRenderingCount(nPauseRenderingCount);

  if (nPauseTimeCount > 0) then z3DCore_GetGlobalTimer.Stop else
  z3DCore_GetGlobalTimer.Start;

  z3DCore_GetState.SetRenderingPaused(nPauseRenderingCount > 0);
  z3DCore_GetState.SetTimePaused(nPauseTimeCount > 0);
end;

procedure z3DCheckForWindowSizeChange;
var
  rcCurrentClient: TRect;
  deviceSettings: Tz3DDeviceSettings;
begin
  // Skip the check for various reasons
  if z3DCore_GetState.IgnoreSizeChange or
     not z3DCore_GetState.DeviceCreated or
     not z3DCore_GetState.CurrentDeviceSettings.PresentParams.Windowed
  then Exit;

  GetClientRect(z3DCore_GetHWND, rcCurrentClient);

  if (rcCurrentClient.right <> Integer(z3DCore_GetState.GetCurrentDeviceSettings.PresentParams.BackBufferWidth)) or
     (rcCurrentClient.bottom <> Integer(z3DCore_GetState.GetCurrentDeviceSettings.PresentParams.BackBufferHeight)) then
  begin
    // A new window size will require a new backbuffer size
    // size, so the device must be reset and the D3D structures updated accordingly.

    // Tell z3DChangeDevice and D3D to size according to the HWND's client rect
    deviceSettings := z3DCore_GetDeviceSettings;
    deviceSettings.PresentParams.BackBufferWidth  := 0;
    deviceSettings.PresentParams.BackBufferHeight := 0;
    z3DChangeDevice(@deviceSettings, nil, False, False);
  end;
end;

function z3DCore_MainLoop(hAccel: HACCEL = 0): HRESULT;
var msg: TMsg;
begin
  // Not allowed to call this from inside the device callbacks or reenter
  if (z3DCore_GetState.InsideDeviceCallback or z3DCore_GetState.InsideMainloop) then
  begin
    if (z3DCore_GetState.ExitCode = 0) or (z3DCore_GetState.GetExitCode = 11) then z3DCore_GetState.ExitCode:= 1;
    Result:= z3DErrorMessage('z3DMainLoop', E_FAIL);
    Exit;
  end;

  z3DCore_GetState.InsideMainloop:= True;

  // If z3DCreateDevice*() or z3DSetDevice() has not already been called,
  // then call z3DCreateDevice() with the default parameters.
  if not z3DCore_GetState.DeviceCreated then
  begin
    if z3DCore_GetState.DeviceCreateCalled then
    begin
      if (z3DCore_GetState.ExitCode = 0) or (z3DCore_GetState.GetExitCode = 11) then z3DCore_GetState.ExitCode:= 1;
      Result:= E_FAIL; // z3DCreateDevice() must first succeed for this function to succeed
      Exit;
    end;

    Result := z3DCore_CreateDevice;
    if FAILED(Result) then
    begin
      if (z3DCore_GetState.ExitCode = 0) or (z3DCore_GetState.GetExitCode = 11) then z3DCore_GetState.ExitCode:= 1;
      Exit;
    end;
  end;

  if not z3DCore_GetState.z3DInited or not z3DCore_GetState.WindowCreated or not z3DCore_GetState.DeviceCreated then
  begin
    if (z3DCore_GetState.ExitCode = 0) or (z3DCore_GetState.GetExitCode = 11) then z3DCore_GetState.ExitCode:= 1;
    Result:= z3DErrorMessage('z3DMainLoop', E_FAIL);
    Exit;
  end;


  // Process Windows messages
  msg.message := WM_NULL;
  PeekMessage(msg, 0, 0, 0, PM_NOREMOVE);

  while (WM_QUIT <> msg.message) do msg.message:= z3DCore_ProcessMessages;

  // Cleanup the accelerator table
  if (hAccel <> 0) then DestroyAcceleratorTable(hAccel);

  z3DCore_GetState.InsideMainloop:= False;

  Result:= S_OK;
end;

function z3DCore_ProcessMessages(hAccel: HACCEL = 0; const ARender: Boolean = True): UINT;
var bGotMsg: LongBool;
    hWnd: Windows.HWND;
    msg: TMsg;
begin
  hWnd := z3DCore_GetHWND;

  // Use PeekMessage() so we can use idle time to render the scene
  bGotMsg := PeekMessage(msg, 0, 0, 0, PM_REMOVE);

  if bGotMsg then
  begin
    // Translate and dispatch the message
    if (hAccel = 0) or (hWnd = 0) or
       (0 = TranslateAccelerator(hWnd, hAccel, msg)) then
    begin
      TranslateMessage(msg);
      DispatchMessage(msg);
    end;
  end else
  if ARender then
  begin
    // Render a frame during idle time (no messages are waiting)
    z3DCore_Render3DEnvironment;
  end;
  Result:= msg.message;
end;

procedure z3DCore_Render3DEnvironment;
var
  pd3dDevice: IDirect3DDevice9;
  hr: HRESULT;
  adapterDesktopDisplayMode: TD3DDisplayMode;
  pD3D: IDirect3D9;
  pDeviceSettings: Pz3DDeviceSettings;
  matchOptions: Tz3DMatchOptions;
  deviceSettings: Tz3DDeviceSettings;
  fTime, fAbsTime: Double;
  fElapsedTime: Single;
  pCallbackFrameMove: Tz3DCallback_FrameMove;
  pCallbackFrameRender: Tz3DCallback_FrameRender;
  nFrame: Integer;
{$IFDEF DEBUG}
  rcClient: TRect;
{$ENDIF}
begin
  if z3DCore_GetState.DeviceLost or z3DCore_IsRenderingPaused or not z3DCore_IsActive then
  begin
    // Window is minimized or paused so yield CPU time to other processes
    Sleep(20);
  end;

  pd3dDevice := z3DCore_GetD3DDevice;
  if (pd3dDevice = nil) then
  begin
    if z3DCore_GetState.DeviceLost then
    begin
      deviceSettings := z3DCore_GetDeviceSettings;
      z3DChangeDevice(@deviceSettings, nil, False, True);
    end;
    Exit;
  end;

  if z3DCore_GetState.DeviceLost and not z3DCore_GetState.RenderingPaused then
  begin
    // Test the cooperative level to see if it's okay to render
    hr:= pd3dDevice.TestCooperativeLevel;
    if FAILED(hr) then
    begin
      if (hr = D3DERR_DEVICELOST) then
      begin
        // The device has been lost but cannot be reset at this time.
        // So wait until it can be reset.
        Exit;
      end;

      // If we are windowed, read the desktop format and
      // ensure that the Direct3D device is using the same format
      // since the user could have changed the desktop bitdepth
      if z3DCore_IsWindowed then
      begin
        pD3D := z3DCore_GetD3DObject;
        pDeviceSettings := z3DCore_GetState.CurrentDeviceSettings;
        pD3D.GetAdapterDisplayMode(pDeviceSettings.AdapterOrdinal, adapterDesktopDisplayMode);
        if (pDeviceSettings.AdapterFormat <> adapterDesktopDisplayMode.Format) then
        begin
          matchOptions.eAdapterOrdinal     := z3DMT_PRESERVE_INPUT;
          matchOptions.eDeviceType         := z3DMT_PRESERVE_INPUT;
          matchOptions.eWindowed           := z3DMT_PRESERVE_INPUT;
          matchOptions.eAdapterFormat      := z3DMT_PRESERVE_INPUT;
          matchOptions.eVertexProcessing   := z3DMT_CLOSEST_TO_INPUT;
          matchOptions.eResolution         := z3DMT_CLOSEST_TO_INPUT;
          matchOptions.eBackBufferFormat   := z3DMT_CLOSEST_TO_INPUT;
          matchOptions.eBackBufferCount    := z3DMT_CLOSEST_TO_INPUT;
          matchOptions.eMultiSample        := z3DMT_CLOSEST_TO_INPUT;
          matchOptions.eSwapEffect         := z3DMT_CLOSEST_TO_INPUT;
          matchOptions.eDepthFormat        := z3DMT_CLOSEST_TO_INPUT;
          matchOptions.eStencilFormat      := z3DMT_CLOSEST_TO_INPUT;
          matchOptions.ePresentFlags       := z3DMT_CLOSEST_TO_INPUT;
          matchOptions.eRefreshRate        := z3DMT_CLOSEST_TO_INPUT;
          matchOptions.ePresentInterval    := z3DMT_CLOSEST_TO_INPUT;

          deviceSettings := z3DCore_GetDeviceSettings;
          deviceSettings.AdapterFormat := adapterDesktopDisplayMode.Format;

          hr := z3DCore_FindValidDeviceSettings(deviceSettings, @deviceSettings, @matchOptions);
          if FAILED(hr) then // the call will fail if no valid devices were found
          begin
            z3DDisplayErrorMessage(z3DERR_NOCOMPATIBLEDEVICES);
            z3DCore_Shutdown;
          end;

          // Change to a Direct3D device created from the new device settings.
          // If there is an existing device, then either reset or recreate the scene
          hr := z3DChangeDevice(@deviceSettings, nil, False, False);
          if FAILED(hr) then
          begin
            // If this fails, try to go fullscreen and if this fails also shutdown.
            if FAILED(z3DCore_ToggleFullScreen) then z3DCore_Shutdown;
          end;

          Exit;
        end;
      end;

      // Try to reset the device
      hr := z3DReset3DEnvironment;
      if FAILED(hr) then 
      begin
        if (D3DERR_DEVICELOST = hr) then
        begin
          // The device was lost again, so continue waiting until it can be reset.
          Exit;
        end
        else if (hr = z3DERR_RESETTINGDEVICEOBJECTS) or
                (hr = z3DERR_MEDIANOTFOUND) then
        begin
          z3DDisplayErrorMessage(hr);
          z3DCore_Shutdown;
          Exit;
        end else
        begin
          // Reset failed, but the device wasn't lost so something bad happened,
          // so recreate the device to try to recover
          z3DTrace('z3DCore_Render3DEnvironment failed (unknown error z3DReset3DEnvironment). Trying to recover', z3dtkWarning);
          pDeviceSettings := z3DCore_GetState.GetCurrentDeviceSettings;
          if FAILED(z3DChangeDevice(pDeviceSettings, nil, True, False)) then
          begin
            z3DCore_Shutdown;
            Exit;
          end;
        end;
      end;
    end;

    z3DCore_GetState.DeviceLost:= False;
  end;

  // Get the app's time, in seconds. Skip rendering if no time elapsed
  z3DCore_GetGlobalTimer.GetTimeValues(fTime, fAbsTime, fElapsedTime);

  // Store the time for the app
  if z3DCore_GetState.ConstantFrameTime then
  begin
    fElapsedTime := z3DCore_GetState.TimePerFrame;
    fTime        := z3DCore_GetTime + fElapsedTime;
  end;

  z3DCore_GetState.SetTime(fTime);
  z3DCore_GetState.SetAbsoluteTime(fAbsTime);
  z3DCore_GetState.SetElapsedTime(fElapsedTime);

  // Update the FPS stats
  z3DUpdateFrameStats;

  z3DHandleTimers;

  // Animate the scene by calling the app's frame move callback
  pCallbackFrameMove := z3DCore_GetState.FrameMoveFunc;
  if (@pCallbackFrameMove <> nil) then
  begin
    pCallbackFrameMove(pd3dDevice, fTime, fElapsedTime, z3DCore_GetState.FrameMoveFuncUserContext);
    pd3dDevice := z3DCore_GetD3DDevice;
    if (pd3dDevice = nil) then Exit; // Handle z3DShutdown from inside callback
  end;

  if not z3DCore_GetState.RenderingPaused then
  begin
    // Render the scene by calling the app's render callback
    pCallbackFrameRender := z3DCore_GetState.FrameRenderFunc;
    if (@pCallbackFrameRender <> nil) then
    begin
      pCallbackFrameRender(pd3dDevice, fTime, fElapsedTime, z3DCore_GetState.FrameRenderFuncUserContext);
      pd3dDevice := z3DCore_GetD3DDevice;
      if (pd3dDevice = nil) then Exit; // Handle z3DShutdown from inside callback
    end;

{$IFDEF DEBUG}
    // The back buffer should always match the client rect
    // if the Direct3D backbuffer covers the entire window
    GetClientRect(z3DCore_GetHWND, rcClient);
    if not IsIconic(z3DCore_GetHWND) then
    begin
      GetClientRect(z3DCore_GetHWND, rcClient);
      Assert(z3DCore_GetBackBufferSurfaceDesc.Width = LongWord(rcClient.right));
      Assert(z3DCore_GetBackBufferSurfaceDesc.Height = LongWord(rcClient.bottom));
    end;
{$ENDIF}

    // Show the frame on the primary surface.
    hr := pd3dDevice.Present(nil, nil, 0, nil);
    if FAILED(hr) then
    begin
      if (D3DERR_DEVICELOST = hr) then
      begin
        z3DCore_GetState.SetDeviceLost(True);
      end
      else if (D3DERR_DRIVERINTERNALERROR = hr) then
      begin
        // When D3DERR_DRIVERINTERNALERROR is returned from Present(),
        // the application can do one of the following:
        //
        // - End, with the pop-up window saying that the application cannot continue
        //   because of problems in the display adapter and that the user should
        //   contact the adapter manufacturer.
        //
        // - Attempt to restart by calling IDirect3DDevice9::Reset, which is essentially the same
        //   path as recovering from a lost device. If IDirect3DDevice9::Reset fails with
        //   D3DERR_DRIVERINTERNALERROR, the application should end immediately with the message
        //   that the user should contact the adapter manufacturer.
        //
        z3DTrace('z3DCore_Render3DEnvironment failed (internal driver error on IDirect3DDevice9.Present). The engine will now try to recover its state', z3dtkWarning);
        z3DCore_GetState.SetDeviceLost(True);
      end;
    end;
  end;

  // Update current frame #
  nFrame := z3DCore_GetState.CurrentFrameNumber;
  Inc(nFrame);
  z3DCore_GetState.CurrentFrameNumber:= nFrame;

  // Check to see if the app should shutdown due to cmdline
  if (z3DCore_GetState.OverrideQuitAfterFrame <> 0) then
    if (nFrame > z3DCore_GetState.OverrideQuitAfterFrame) then z3DCore_Shutdown;
end;

procedure z3DUpdateDeviceStats(DeviceType: TD3DDevType; BehaviorFlags: DWORD; const pAdapterIdentifier: TD3DAdapterIdentifier9);
const
  cchDesc = SizeOf(pAdapterIdentifier.Description);
var
  pstrDeviceStats: PWideChar;
  szDescription: array[0..cchDesc-1] of WideChar;
  pDeviceSettings: Pz3DDeviceSettings;
  pd3dEnum: Iz3DDeviceList;
  pDeviceSettingsCombo: PD3DDeviceSettingsCombinations;
begin
  if z3DCore_GetState.NoStats then Exit;

  // Store device description
  pstrDeviceStats := z3DCore_GetState.GetDeviceStats;
  if (DeviceType = D3DDEVTYPE_REF) then StringCchCopy(pstrDeviceStats, 256, 'REF')
  else if (DeviceType = D3DDEVTYPE_HAL) then StringCchCopy(pstrDeviceStats, 256, 'HAL')
  else if (DeviceType = D3DDEVTYPE_SW)  then StringCchCopy(pstrDeviceStats, 256, 'SW');

  if (BehaviorFlags and D3DCREATE_HARDWARE_VERTEXPROCESSING <> 0) and
     (BehaviorFlags and D3DCREATE_PUREDEVICE <> 0) then
  begin
    if (DeviceType = D3DDEVTYPE_HAL)
    then StringCchCat(pstrDeviceStats, 256, ' (pure hardware vp)')
    else StringCchCat(pstrDeviceStats, 256, ' (simulated pure hardware vp)');
  end
  else if (BehaviorFlags and D3DCREATE_HARDWARE_VERTEXPROCESSING <> 0) then
  begin
    if (DeviceType = D3DDEVTYPE_HAL)
    then StringCchCat(pstrDeviceStats, 256, ' (hardware vp)')
    else StringCchCat(pstrDeviceStats, 256, ' (simulated hardware vp)');
  end
  else if (BehaviorFlags and D3DCREATE_MIXED_VERTEXPROCESSING <> 0) then
  begin
    if (DeviceType = D3DDEVTYPE_HAL)
    then StringCchCat(pstrDeviceStats, 256, ' (mixed vp)')
    else StringCchCat(pstrDeviceStats, 256, ' (simulated mixed vp)');
  end
  else if (BehaviorFlags and D3DCREATE_SOFTWARE_VERTEXPROCESSING <> 0) then
  begin
    StringCchCat(pstrDeviceStats, 256, ' (software vp)');
  end;

  if (DeviceType = D3DDEVTYPE_HAL) then
  begin
    // Be sure not to overflow m_strDeviceStats when appending the adapter
    // description, since it can be long.
    StringCchCat(pstrDeviceStats, 256, ': ');

    // Try to get a unique description from the CD3DDeviceSettingsCombinations
    pDeviceSettings := z3DCore_GetState.GetCurrentDeviceSettings;
    pd3dEnum := z3DPrepareDeviceListObject;
    pDeviceSettingsCombo := pd3dEnum.GetDeviceSettingsCombo(pDeviceSettings.AdapterOrdinal, pDeviceSettings.DeviceType, pDeviceSettings.AdapterFormat, pDeviceSettings.PresentParams.BackBufferFormat, pDeviceSettings.PresentParams.Windowed);
    if (pDeviceSettingsCombo <> nil) then
    begin
      StringCchCat(pstrDeviceStats, 256, pDeviceSettingsCombo.AdapterInfo.UniqueDescription^);
    end else
    begin
      MultiByteToWideChar(CP_ACP, 0, pAdapterIdentifier.Description, -1, szDescription, cchDesc);
      szDescription[cchDesc-1] := #0;
      StringCchCat(pstrDeviceStats, 256, szDescription);
    end;
  end;
end;

procedure z3DUpdateFrameStats;
var
  fLastTime: Double;
  dwFrames: DWORD;
  fAbsTime: Double;
  fFPS: Single;
  pstrFPS: PWideChar;
begin
  if z3DCore_GetState.NoStats then Exit;

  // Keep track of the frame count
  fLastTime := z3DCore_GetState.LastStatsUpdateTime;
  dwFrames  := z3DCore_GetState.LastStatsUpdateFrames;
  fAbsTime  := z3DCore_GetState.AbsoluteTime;
  Inc(dwFrames);
  z3DCore_GetState.LastStatsUpdateFrames:= dwFrames;

  // Update the scene stats by the given interval
  if (fAbsTime - fLastTime > z3DCore_GetState.GetStatsUpdateInterval) then
  begin
    fFPS := (dwFrames / (fAbsTime - fLastTime));
    z3DCore_GetState.FPS:= fFPS;
    z3DCore_GetState.LastStatsUpdateTime:= fAbsTime;
    z3DCore_GetState.LastStatsUpdateFrames:= 0;

    pstrFPS := z3DCore_GetState.FPSStats;
    StringCchFormat(pstrFPS, 64, '%f FPS', [fFPS]);
  end;
end;

procedure z3DUpdateStaticFrameStats;
const
  VSyncDesc: array[False..True] of PWideChar = ('off', 'on');
var
  pDeviceSettings: Pz3DDeviceSettings;
  pd3dEnum: Iz3DDeviceList;
  pDeviceSettingsCombo: PD3DDeviceSettingsCombinations;
  pPP: PD3DPresentParameters;
  strFmt, strDepthFmt, strMultiSample: array[0..99] of WideChar;
  pstrStaticFrameStats: PWideChar;
begin
  if z3DCore_GetState.NoStats then Exit;

  pDeviceSettings := z3DCore_GetState.GetCurrentDeviceSettings;
  if (pDeviceSettings = nil) then Exit;

  pd3dEnum := z3DPrepareDeviceListObject;
  if (pd3dEnum = nil) then Exit;

  pDeviceSettingsCombo := pd3dEnum.GetDeviceSettingsCombo(pDeviceSettings.AdapterOrdinal,
                            pDeviceSettings.DeviceType, pDeviceSettings.AdapterFormat,
                            pDeviceSettings.PresentParams.BackBufferFormat, pDeviceSettings.PresentParams.Windowed);
  if (pDeviceSettingsCombo = nil) then Exit;

  pPP := @pDeviceSettings.PresentParams;

  if (pDeviceSettingsCombo.AdapterFormat = pDeviceSettingsCombo.BackBufferFormat) then
  begin
    StringCchCopy(strFmt, 100, z3DD3DFormatToString(pDeviceSettingsCombo.AdapterFormat, False));
  end else
  begin
    StringCchFormat(strFmt, 100, 'backbuffer: %s, adapter: %s',
      [z3DD3DFormatToString(pDeviceSettingsCombo.BackBufferFormat, False),
       z3DD3DFormatToString(pDeviceSettingsCombo.AdapterFormat, False)]);
  end;

  if pPP.EnableAutoDepthStencil then
  begin
    StringCchFormat(strDepthFmt, 100, ' (depth stencil %s)', [z3DD3DFormatToString(pPP.AutoDepthStencilFormat, False)]);
  end else
  begin
    // No depth buffer
    strDepthFmt[0] := #0;
  end;

  case pPP.MultiSampleType of
    D3DMULTISAMPLE_NONMASKABLE: StringCchCopy(strMultiSample, 100, ' (Nonmaskable Multisample)');
    D3DMULTISAMPLE_NONE:        StringCchCopy(strMultiSample, 100, '');
    else                        StringCchFormat(strMultiSample, 100, ' (%dx Multisample)', [Ord(pPP.MultiSampleType)]);
  end;
  strMultiSample[99] := #0;

  pstrStaticFrameStats := z3DCore_GetState.StaticFrameStats;

  StringCchFormat(pstrStaticFrameStats, 256, '%%sVertical sync is %s - %dx%d - %s%s%s',
              [VSyncDesc[pPP.PresentationInterval <> D3DPRESENT_INTERVAL_IMMEDIATE],
              pPP.BackBufferWidth, pPP.BackBufferHeight,
              strFmt, strDepthFmt, strMultiSample]);
end;


function z3DCore_GetFrameStats(bIncludeFPS: Boolean = False): PWideChar;
var
  pstrFrameStats: PWideChar;
  pstrFPS: PWideChar;
begin
  pstrFrameStats := z3DCore_GetState.GetFrameStats;
  if bIncludeFPS then pstrFPS := z3DCore_GetState.GetFPSStats else pstrFPS := '';
  StringCchFormat(pstrFrameStats, 256, z3DCore_GetState.GetStaticFrameStats, [pstrFPS]);
  Result:= pstrFrameStats;
end;


function z3DCore_StaticWndProc(hWnd: Windows.HWND; uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): LRESULT;
var
  pCallbackKeyboard: Tz3DCallback_Keyboard;
  bKeyDown, bAltDown: Boolean;
  dwMask: DWORD;
  pCallbackMouse: Tz3DCallback_Mouse;
  xPos, yPos: Integer;
  pt: TPoint;
  nMouseWheelDelta: Integer;
  nMouseButtonState: Integer;
  bLeftButton, bRightButton, bMiddleButton, bSideButton1, bSideButton2: Boolean;
  pCallbackMsgProc: Tz3DCallback_MsgProc;
  bNoFurtherProcessing: Boolean;
  nResult: LRESULT;
  pd3dDevice: IDirect3DDevice9;
  hr: HRESULT;
  fTime: Double;
  fElapsedTime: Single;
  pCallbackFrameRender: Tz3DCallback_FrameRender;
  ptCursor: TPoint;
  bWireFrame: Boolean;
  bTimePaused: Boolean;
  hMenu: Windows.HMENU;
  bKeys: Pz3DKeysArray;
  bMouseButtons: Pz3DMouseButtonsArray;
  rcCurrentClient: TRect;
begin
  if (uMsg = WM_KEYDOWN) or
     (uMsg = WM_SYSKEYDOWN) or
     (uMsg = WM_KEYUP) or
     (uMsg = WM_SYSKEYUP) then
  begin
    bKeyDown := (uMsg = WM_KEYDOWN) or (uMsg = WM_SYSKEYDOWN);
    dwMask := (1 shl 29);
    bAltDown := ((lParam and dwMask) <> 0);

    bKeys := z3DCore_GetState.Keys;
    bKeys[Byte(wParam and $FF)] := bKeyDown;

    pCallbackKeyboard := z3DCore_GetState.KeyboardFunc;
    if (@pCallbackKeyboard <> nil) then
      pCallbackKeyboard(wParam, bKeyDown, bAltDown, z3DCore_GetState.KeyboardFuncUserContext);
  end;

  // Consolidate the mouse button messages and pass them to the app's mouse callback
  if (uMsg = WM_LBUTTONDOWN) or
     (uMsg = WM_LBUTTONUP) or
     (uMsg = WM_LBUTTONDBLCLK) or
     (uMsg = WM_MBUTTONDOWN) or
     (uMsg = WM_MBUTTONUP) or
     (uMsg = WM_MBUTTONDBLCLK) or
     (uMsg = WM_RBUTTONDOWN) or
     (uMsg = WM_RBUTTONUP) or
     (uMsg = WM_RBUTTONDBLCLK) or
     (uMsg = WM_XBUTTONDOWN) or
     (uMsg = WM_XBUTTONUP) or
     (uMsg = WM_XBUTTONDBLCLK) or
     (uMsg = WM_MOUSEWHEEL) or
     (z3DCore_GetState.NotifyOnMouseMove and (uMsg = WM_MOUSEMOVE)) then
  begin
    xPos := LOWORD(DWORD(lParam));
    yPos := HIWORD(DWORD(lParam));

    if (uMsg = WM_MOUSEWHEEL) then
    begin
      // WM_MOUSEWHEEL passes screen mouse coords
      // so convert them to client coords
      pt.x := xPos; pt.y := yPos;
      ScreenToClient(hWnd, pt);
      xPos := pt.x; yPos := pt.y;
    end;

    nMouseWheelDelta := 0;
    if (uMsg = WM_MOUSEWHEEL)
    then nMouseWheelDelta := HIWORD(DWORD(wParam));

    nMouseButtonState := LOWORD(DWORD(wParam));
    bLeftButton  := ((nMouseButtonState and MK_LBUTTON) <> 0);
    bRightButton := ((nMouseButtonState and MK_RBUTTON) <> 0);
    bMiddleButton := ((nMouseButtonState and MK_MBUTTON) <> 0);
    bSideButton1 := ((nMouseButtonState and MK_XBUTTON1) <> 0);
    bSideButton2 := ((nMouseButtonState and MK_XBUTTON2) <> 0);

    bMouseButtons := z3DCore_GetState.MouseButtons;
    bMouseButtons[0] := bLeftButton;
    bMouseButtons[1] := bMiddleButton;
    bMouseButtons[2] := bRightButton;
    bMouseButtons[3] := bSideButton1;
    bMouseButtons[4] := bSideButton2;

    pCallbackMouse := z3DCore_GetState.MouseFunc;
    if (@pCallbackMouse <> nil) then
      pCallbackMouse(bLeftButton, bRightButton, bMiddleButton,
                     bSideButton1, bSideButton2, nMouseWheelDelta,
                     xPos, yPos, z3DCore_GetState.MouseFuncUserContext);
  end;

  // Pass all messages to the app's MsgProc callback, and don't
  // process further messages if the apps says not to.
  pCallbackMsgProc := z3DCore_GetState.WindowMsgFunc;
  if (@pCallbackMsgProc <> nil) then
  begin
    bNoFurtherProcessing := False;
    nResult := pCallbackMsgProc(hWnd, uMsg, wParam, lParam, bNoFurtherProcessing, z3DCore_GetState.WindowMsgFuncUserContext);
    if bNoFurtherProcessing then
    begin
      Result:= nResult;
      Exit;
    end;
  end;

  case uMsg of
    WM_PAINT:
    begin
      pd3dDevice := z3DCore_GetD3DDevice;

      // Handle paint messages when the app is paused
      if (pd3dDevice <> nil) and z3DCore_IsRenderingPaused and
         z3DCore_GetState.DeviceObjectsCreated and z3DCore_GetState.DeviceObjectsReset then
      begin
        fTime := z3DCore_GetTime;
        fElapsedTime := z3DCore_GetElapsedTime;

        pCallbackFrameRender := z3DCore_GetState.FrameRenderFunc;
        if (@pCallbackFrameRender <> nil) then
          pCallbackFrameRender(pd3dDevice, fTime, fElapsedTime, z3DCore_GetState.FrameRenderFuncUserContext);

        hr := pd3dDevice.Present(nil, nil, 0, nil);
        if (D3DERR_DEVICELOST = hr) then
        begin
          z3DCore_GetState.SetDeviceLost(True);
        end
        else if (D3DERR_DRIVERINTERNALERROR = hr) then
        begin
          // When D3DERR_DRIVERINTERNALERROR is returned from Present(),
          // the application can do one of the following:
          //
          // - End, with the pop-up window saying that the application cannot continue
          //   because of problems in the display adapter and that the user should
          //   contact the adapter manufacturer.
          //
          // - Attempt to restart by calling IDirect3DDevice9::Reset, which is essentially the same
          //   path as recovering from a lost device. If IDirect3DDevice9::Reset fails with
          //   D3DERR_DRIVERINTERNALERROR, the application should end immediately with the message
          //   that the user should contact the adapter manufacturer.
          //
          z3DCore_GetState.SetDeviceLost(True);
        end;
      end;
    end;

    WM_SIZE:
    begin
      if (SIZE_MINIMIZED = wParam) then
      begin
        z3DCore_Pause(True, True); // Pause while we're minimized
        z3DCore_GetState.SetMinimized(True);
        z3DCore_GetState.SetMaximized(False);
      end else
      begin
        GetClientRect(z3DCore_GetHWND, rcCurrentClient);
        if (rcCurrentClient.top = 0) and (rcCurrentClient.bottom = 0) then
        begin
          // Rapidly clicking the task bar to minimize and restore a window
          // can cause a WM_SIZE message with SIZE_RESTORED when
          // the window has actually become minimized due to rapid change
          // so just ignore this message
         end
        else if (SIZE_MAXIMIZED = wParam) then
        begin
          if z3DCore_GetState.Minimized then
            z3DCore_Pause(False, False); // Unpause since we're no longer minimized

          z3DCore_GetState.Minimized := False;
          z3DCore_GetState.Maximized := True;
          z3DCheckForWindowSizeChange;
          z3DCheckForWindowChangingMonitors;
        end
        else if (SIZE_RESTORED = wParam) then
        begin
          if z3DCore_GetState.Maximized then
          begin
            z3DCore_GetState.Maximized := False;
            z3DCheckForWindowSizeChange;
            z3DCheckForWindowChangingMonitors;
          end
          else if z3DCore_GetState.Minimized then
          begin
            z3DCore_Pause(False, False); // Unpause since we're no longer minimized
            z3DCore_GetState.Minimized := False;
            z3DCheckForWindowSizeChange;
            z3DCheckForWindowChangingMonitors;
          end else
          if z3DCore_GetState.InSizeMove then
          begin
            // If we're neither maximized nor minimized, the window size
            // is changing by the user dragging the window edges.  In this
            // case, we don't reset the device yet -- we wait until the
            // user stops dragging, and a WM_EXITSIZEMOVE message comes.
          end else
          begin
            // This WM_SIZE come from resizing the window via an API like SetWindowPos() so
            // resize and reset the device now.
            z3DCheckForWindowSizeChange;
            z3DCheckForWindowChangingMonitors;
          end;
        end
      end;
    end;

    WM_GETMINMAXINFO:
    begin
      PMinMaxInfo(lParam).ptMinTrackSize.x := z3D_MIN_WINDOW_SIZE_X;
      PMinMaxInfo(lParam).ptMinTrackSize.y := z3D_MIN_WINDOW_SIZE_Y;
    end;

    WM_ENTERSIZEMOVE:
    begin
      // Halt frame movement while the app is sizing or moving
      z3DCore_Pause(True, True);
      z3DCore_GetState.InSizeMove := True;
    end;

    WM_EXITSIZEMOVE:
    begin
      z3DCore_Pause(False, False);
      z3DCheckForWindowSizeChange;
      z3DCheckForWindowChangingMonitors;
      z3DCore_GetState.InSizeMove := False;
    end;

    WM_MOUSEMOVE:
    begin
      if not z3DCore_IsActive and not z3DCore_IsWindowed then
      begin
        pd3dDevice := z3DCore_GetD3DDevice;
        if (pd3dDevice <> nil) then
        begin
          GetCursorPos(ptCursor);
          pd3dDevice.SetCursorPosition(ptCursor.x, ptCursor.y, 0);
        end;
      end;
    end;

    WM_SETCURSOR:
    begin
      if z3DCore_IsActive and not z3DCore_IsWindowed then
      begin
        pd3dDevice := z3DCore_GetD3DDevice;
        if Assigned(pd3dDevice) and z3DCore_GetState.ShowCursorWhenFullScreen then pd3dDevice.ShowCursor(True);
        Result:= iTrue; // prevent Windows from setting cursor to window class cursor
        Exit;
      end;
    end;

    WM_ACTIVATEAPP:
    begin
      if (wParam = Integer(iTrue)) and not z3DCore_IsActive then // Handle only if previously not active
      begin
        z3DCore_GetState.Active := True;

        // Disable any controller rumble & input when de-activating app
        z3DEnableXInput(True);

        // The GetMinimizedWhileFullscreen() varible is used instead of !z3DCore_IsWindowed()
        // to handle the rare case toggling to windowed mode while the fullscreen application
        // is minimized and thus making the pause count wrong
        if z3DCore_GetState.MinimizedWhileFullscreen then
        begin
          z3DCore_Pause(False, False); // Unpause since we're no longer minimized
          z3DCore_GetState.MinimizedWhileFullscreen := False;
        end;

        // Upon returning to this app, potentially disable shortcut keys
        // (Windows key, accessibility shortcuts)
        if z3DCore_IsWindowed
        then z3DAllowShortcutKeys(z3DCore_GetState.AllowShortcutKeysWhenWindowed)
        else z3DAllowShortcutKeys(z3DCore_GetState.AllowShortcutKeysWhenFullscreen);

      end
      else if (wParam = Integer(iFalse)) and z3DCore_IsActive then // Handle only if previously active
      begin
        z3DCore_GetState.Active := False;

        // Disable any controller rumble & input when de-activating app
        z3DEnableXInput(False);

        if not z3DCore_IsWindowed then
        begin
          // Going from full screen to a minimized state
          ClipCursor(nil);      // don't limit the cursor anymore
          z3DCore_Pause(True, True); // Pause while we're minimized (take care not to pause twice by handling Self message twice)
          z3DCore_GetState.MinimizedWhileFullscreen := True;
        end;

        // Restore shortcut keys (Windows key, accessibility shortcuts) to original state
        //
        // This is important to call here if the shortcuts are disabled,
        // because if this is not done then the Windows key will continue to
        // be disabled while this app is running which is very bad.
        // If the app crashes, the Windows key will return to normal.
        z3DAllowShortcutKeys(True);
      end;
    end;

    WM_ENTERMENULOOP:
      // Pause the app when menus are displayed
      z3DCore_Pause(True, True);

    WM_EXITMENULOOP:
      z3DCore_Pause(False, False);

    WM_MENUCHAR:
    begin
      // A menu is active and the user presses a key that does not correspond to any mnemonic or accelerator key
      // So just ignore and don't beep
      {$IFNDEF FPC}
      Result:= MAKELRESULT(0, MNC_CLOSE);
      {$ELSE}
      Result:= MAKELRESULT(0, {MNC_CLOSE}1);
      {$ENDIF}
      Exit;
    end;

    WM_NCHITTEST:
      // Prevent the user from selecting the menu in full screen mode
      if not z3DCore_IsWindowed then
      begin
        Result:= HTCLIENT;
        Exit;
      end;

    WM_POWERBROADCAST:
      case wParam of
        (*{$IFNDEF PBT_APMQUERYSUSPEND}
            const PBT_APMQUERYSUSPEND 0x0000
        {$ENDIF}*)
        0: {PBT_APMQUERYSUSPEND}
        begin
          // At this point, the app should save any data for open
          // network connections, files, etc., and prepare to go into
          // a suspended mode.  The app can use the MsgProc callback
          // to handle this if desired.
          Result:= iTrue;
          Exit;
        end;

        (*#ifndef PBT_APMRESUMESUSPEND
            #define PBT_APMRESUMESUSPEND 0x0007
        #endif*)
        7: {PBT_APMRESUMESUSPEND}
        begin
          // At this point, the app should recover any data, network
          // connections, files, etc., and resume running from when
          // the app was suspended. The app can use the MsgProc callback
          // to handle this if desired.

          // QPC may lose consistency when suspending, so reset the timer
          // upon resume.
          z3DCore_GetGlobalTimer.Reset;
          z3DCore_GetState.SetLastStatsUpdateTime(0);
          Result:= iTrue;
          Exit;
        end;
      end;

    WM_SYSCOMMAND:
      // Prevent moving/sizing in full screen mode
      case wParam of
        SC_MOVE,
        SC_SIZE,
        SC_MAXIMIZE,
        SC_KEYMENU:
          if not z3DCore_IsWindowed then
          begin
            Result:= 0;
            Exit;
          end;
      end;

    WM_SYSKEYDOWN:
    begin
      case wParam of
        VK_RETURN:
        begin
          if z3DCore_GetState.HandleAltEnter then
          begin
            // Toggle full screen upon alt-enter
            dwMask := (1 shl 29);
            if ((lParam and dwMask) <> 0) then // Alt is down also
            begin
              // Toggle the full screen/window mode
              z3DCore_Pause(True, True);
              z3DCore_ToggleFullScreen;
              z3DCore_Pause(False, False);
              Result:= 0;
              Exit;
            end;
          end;
        end;
      end;
    end;

    WM_KEYDOWN:
    begin
      if z3DCore_GetState.HandleDefaultHotkeys then
      begin
        case wParam of
          VK_F3:
          begin
            z3DCore_Pause(True, True);
            z3DCore_ToggleREF;
            z3DCore_Pause(False, False);
          end;

          VK_F8:
          begin
            bWireFrame := z3DCore_GetState.GetWireframeMode;
            bWireFrame := not bWireFrame;
            z3DCore_GetState.SetWireframeMode(bWireFrame);

            pd3dDevice := z3DCore_GetD3DDevice;
            if (pd3dDevice <> nil)
            then pd3dDevice.SetRenderState(D3DRS_FILLMODE, IfThen(bWireFrame, D3DFILL_WIREFRAME, D3DFILL_SOLID));
          end;

          VK_PAUSE:
          begin
            bTimePaused := z3DCore_IsTimePaused;
            bTimePaused := not bTimePaused;
            if bTimePaused
            then z3DCore_Pause(True,  False)
            else z3DCore_Pause(False, False);
          end;
        end;
      end;
    end;

    WM_CLOSE:
    begin
      hMenu := GetMenu(hWnd);
      if (hMenu <> 0) then DestroyMenu(hMenu);
      DestroyWindow(hWnd);
      Windows.UnregisterClass('Direct3DWindowClass', 0);
      z3DCore_GetState.SetHWNDFocus(0);
      z3DCore_GetState.SetHWNDDeviceFullScreen(0);
      z3DCore_GetState.SetHWNDDeviceWindowed(0);
      Result:= 0;
      Exit;
    end;

    WM_DESTROY: PostQuitMessage(0);
  end;

  // Don't allow the F10 key to act as a shortcut to the menu bar
  // by not passing these messages to the DefWindowProc only when
  // there's no menu present
  if not z3DCore_GetState.CallDefWindowProc or (z3DCore_GetState.Menu = 0) and ((uMsg = WM_SYSKEYDOWN) or (uMsg = WM_SYSKEYUP)) and (wParam = VK_F10)
  then Result:= 0
  else Result:= DefWindowProcW(hWnd, uMsg, wParam, lParam);
end;

procedure z3DCore_ResetEngineState;
begin
  z3DCore_GetState.DestroyState;
  z3DCore_GetState.CreateState;
end;

procedure z3DCore_Shutdown(nExitCode: Integer = 0);
var
  hWnd: Windows.HWND;
begin
  hWnd := z3DCore_GetHWND;
  if (hWnd <> 0) then SendMessage(hWnd, WM_CLOSE, 0, 0);

  z3DCore_GetState.SetExitCode(nExitCode);

  z3DCleanup3DEnvironment(True);

  // Restore shortcut keys (Windows key, accessibility shortcuts) to original state
  // This is important to call here if the shortcuts are disabled,
  // because accessibility setting changes are permanent.
  // This means that if this is not done then the accessibility settings
  // might not be the same as when the app was started.
  // If the app crashes without restoring the settings, this is also true so it
  // would be wise to backup/restore the settings from a file so they can be
  // restored when the crashed app is run again.
  z3DAllowShortcutKeys(True);

  with z3DCore_GetState do
  begin
    if Assigned(z3DDeviceList) then z3DDeviceList.CleanupDirect3DInterfaces;
    z3DDeviceList:= nil;
    D3D:= nil;
  end;

  z3DFileSystemController.FreeBuffer;
end;

procedure z3DCleanup3DEnvironment(bReleaseSettings: Boolean = True);
var
  pd3dDevice: IDirect3DDevice9;
  pCallbackDeviceLost: Tz3DCallback_DeviceLost;
  pCallbackDeviceDestroyed: Tz3DCallback_DeviceDestroyed;
  pOldDeviceSettings: Pz3DDeviceSettings;
  pbackBufferSurfaceDesc: PD3DSurfaceDesc;
  pd3dCaps: PD3DCaps9;
  FRefCount: Cardinal;
begin
  pd3dDevice := z3DCore_GetD3DDevice;
  if (pd3dDevice <> nil) then 
  begin
    z3DCore_GetState.InsideDeviceCallback := True;

    // Call the app's device lost callback
    if z3DCore_GetState.DeviceObjectsReset then
    begin
      pCallbackDeviceLost := z3DCore_GetState.DeviceLostFunc;
      if (@pCallbackDeviceLost <> nil) then pCallbackDeviceLost(z3DCore_GetState.DeviceLostFuncUserContext);
      z3DCore_GetState.DeviceObjectsReset := False;

      // Call the resource cache device lost function
      z3DCore_GetGlobalResourceCache.OnLostDevice;
    end;

    // Call the app's device destroyed callback
    if z3DCore_GetState.DeviceObjectsCreated then
    begin
      pCallbackDeviceDestroyed := z3DCore_GetState.DeviceDestroyedFunc;
      if (@pCallbackDeviceDestroyed <> nil) then
        pCallbackDeviceDestroyed(z3DCore_GetState.DeviceDestroyedFuncUserContext);
      z3DCore_GetState.DeviceObjectsCreated := False;

      // Call the resource cache device destory function
      z3DCore_GetGlobalResourceCache.OnDestroyDevice;
    end;

    z3DCore_GetState.InsideDeviceCallback:= False;

    // Release the D3D device and in debug configs, displays a message box if there
    // are unrelease objects.
    z3DCore_GetState.D3DDevice:= nil;
    if (pd3dDevice <> nil) then
    begin
      FRefCount:= pd3dDevice._Release;
      if FRefCount > 0 then
      begin
      {$IFNDEF FPC} //todo: Remove this HACK after succesfull debugging of FPC port
        z3DTrace(PWideChar(WideString('z3DCleanup3DEnvironment: Device reference count > 0. Current count: '+IntToStr(FRefCount))), z3dtkWarning);
        z3DDisplayErrorMessage(z3DERR_NONZEROREFCOUNT);
        z3DError('z3DCleanup3DEnvironment', z3DERR_NONZEROREFCOUNT);
        {$IFDEF DEBUG}
        // Forced clearing of D3DDevice references, so D3D debug level will show additional messages
        OutputDebugString('z3D.pas: releasing D3DDevice refcount until ZERO');
        while (pd3dDevice._Release > 0) do Application.ProcessMessages;
        {$ENDIF}
      {$ENDIF}
      end;
      Pointer(pd3dDevice) := nil;
    end;

    if bReleaseSettings then
    begin
      pOldDeviceSettings := z3DCore_GetState.CurrentDeviceSettings;
      Dispose(pOldDeviceSettings);
      z3DCore_GetState.CurrentDeviceSettings:= nil;
    end;

    pbackBufferSurfaceDesc := z3DCore_GetState.BackBufferSurfaceDesc;
    ZeroMemory(pbackBufferSurfaceDesc, SizeOf(TD3DSurfaceDesc));

    pd3dCaps := z3DCore_GetState.Caps;
    ZeroMemory(pd3dCaps, SizeOf(TD3DCaps9));

    z3DCore_GetState.DeviceCreated := False;
  end;
end;

procedure z3DUpdateBackBufferDesc;
var
  pBackBuffer: IDirect3DSurface9;
  hr: HRESULT;
  pBBufferSurfaceDesc: PD3DSurfaceDesc;
begin
  hr := z3DCore_GetState.D3DDevice.GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, pBackBuffer);
  pBBufferSurfaceDesc := z3DCore_GetState.GetBackBufferSurfaceDesc;
  ZeroMemory(pBBufferSurfaceDesc, SizeOf(TD3DSurfaceDesc));
  if SUCCEEDED(hr) then
  begin
    pBackBuffer.GetDesc(pBBufferSurfaceDesc^);
    pBackBuffer := nil;
  end;
end;

function z3DCore_SetTimer(pCallbackTimer: Tz3DCallback_Timer; fTimeoutInSecs: Single = 1.0; pnIDEvent: PLongWord = nil; pCallbackUserContext: Pointer = nil): HRESULT;
var
  z3DTimer: Tz3DTimerRecord;
  pTimerList: Tz3DTimerRecordArray;
  l: Integer;
begin
  if (@pCallbackTimer = nil) then
  begin
    Result:= z3DErrorMessage('z3DSetTimer', E_INVALIDARG);
    Exit;
  end;

  z3DTimer.pCallbackTimer := pCallbackTimer;
  z3DTimer.pCallbackUserContext := pCallbackUserContext;
  z3DTimer.fTimeoutInSecs := fTimeoutInSecs;
  z3DTimer.fCountdown := fTimeoutInSecs;
  z3DTimer.bEnabled := True;

  pTimerList := z3DCore_GetState.TimerList;
  l:= Length(pTimerList);
  SetLength(pTimerList, l+1);
  pTimerList[l]:= z3DTimer;

  if (pnIDEvent <> nil) then pnIDEvent^ := Length(pTimerList);

  Result:= S_OK;
end;

function z3DCore_KillTimer(nIDEvent: LongWord): HRESULT;
var
  pTimerList: Tz3DTimerRecordArray;
begin
  pTimerList := z3DCore_GetState.GetTimerList;
  if (pTimerList = nil) then
  begin
    Result:= S_FALSE;
    Exit;
  end;

  if (nIDEvent < LongWord(Length(pTimerList))) then
  begin
    pTimerList[nIDEvent].bEnabled := False;
  end else
  begin
    Result:= z3DErrorMessage('z3DKillTimer', E_INVALIDARG);
    Exit;
  end;

  Result:= S_OK;
end;

procedure z3DHandleTimers;
var
  fElapsedTime: Single;
  pTimerList: Tz3DTimerRecordArray;
  i: Integer;
  z3DTimer: Tz3DTimerRecord;
begin
  fElapsedTime := z3DCore_GetElapsedTime;

  pTimerList := z3DCore_GetState.GetTimerList;
  if (pTimerList = nil) then Exit;

  // Walk through the list of timer callbacks
  for i:= 0 to Length(pTimerList) - 1 do
  begin
    z3DTimer := pTimerList[i];
    if z3DTimer.bEnabled then
    begin
      z3DTimer.fCountdown := z3DTimer.fCountdown - fElapsedTime;

      // Call the callback if count down expired
      if (z3DTimer.fCountdown < 0) then
      begin
        z3DTimer.pCallbackTimer(i, z3DTimer.pCallbackUserContext);
        z3DTimer.fCountdown := z3DTimer.fTimeoutInSecs;
      end;
      pTimerList[i]:= z3DTimer;
    end;
  end;
end;


function z3DCore_GetD3DObject: IDirect3D9;
begin Result:= z3DCore_GetState.D3D; end;

function z3DCore_GetD3DDevice: IDirect3DDevice9;
begin Result:= z3DCore_GetState.D3DDevice; end;

function z3DCore_GetBackBufferSurfaceDesc: PD3DSurfaceDesc;
begin Result:= z3DCore_GetState.BackBufferSurfaceDesc; end;

function z3DCore_GetDeviceCaps: PD3DCaps9;
begin Result:= z3DCore_GetState.Caps; end;

function z3DCore_GetHINSTANCE: HINST;
begin Result:= z3DCore_GetState.HInstance; end;

function z3DCore_GetHWND: HWND;
begin
  if z3DCore_IsWindowed then Result:= z3DCore_GetState.HWNDDeviceWindowed
  else Result:= z3DCore_GetState.HWNDDeviceFullScreen;
end;

function z3DCore_GetHWNDFocus: HWND;
begin Result:= z3DCore_GetState.HWNDFocus; end;

function z3DCore_GetHWNDDeviceFullScreen: HWND;
begin Result:= z3DCore_GetState.HWNDDeviceFullScreen; end;

function z3DCore_GetHWNDDeviceWindowed: HWND;
begin Result:= z3DCore_GetState.HWNDDeviceWindowed; end;

function z3DCore_GetWindowClientRect: TRect;
begin
  GetClientRect(z3DCore_GetHWND, Result);
end;

function z3DCore_GetWindowClientRectAtModeChange: TRect;
begin
  Result := Rect(0, 0, z3DCore_GetState.WindowBackBufferWidthAtModeChange,
                       z3DCore_GetState.WindowBackBufferHeightAtModeChange);
end;

function z3DCore_GetFullsceenClientRectAtModeChange: TRect;
begin
  Result := Rect(0, 0, z3DCore_GetState.FullScreenBackBufferWidthAtModeChange,
                       z3DCore_GetState.GetFullScreenBackBufferHeightAtModeChange);
end;

function z3DCore_GetTime: Double;
begin Result:= z3DCore_GetState.Time; end;

function z3DCore_GetElapsedTime: Single;
begin Result:= z3DCore_GetState.ElapsedTime; end;

function z3DCore_GetFPS: Single;
begin Result:= z3DCore_GetState.FPS; end;

function z3DCore_GetWindowTitle: PWideChar;
begin Result:= z3DCore_GetState.WindowTitle; end;

function z3DCore_GetDeviceStats: PWideChar;
begin Result:= z3DCore_GetState.DeviceStats; end;

function z3DCore_IsRenderingPaused: Boolean;
begin Result:= z3DCore_GetState.PauseRenderingCount > 0; end;

function z3DCore_IsTimePaused: Boolean;
begin Result:= z3DCore_GetState.PauseTimeCount > 0; end;

function z3DCore_IsActive: Boolean;
begin Result:= z3DCore_GetState.GetActive; end;

function z3DCore_GetExitCode:Integer;
begin Result:= z3DCore_GetState.ExitCode; end;

function z3DCore_GetShowMsgBoxOnError: Boolean;
begin
  Result:= z3DCore_GetState.ShowMsgBoxOnError;
end;

function z3DCore_GetAutomation: Boolean;
begin
  Result:= z3DCore_GetState.Automation;
end;

function z3DCore_GetHandleDefaultHotkeys: Boolean;
begin Result:= z3DCore_GetState.GetHandleDefaultHotkeys; end;

function z3DCore_IsKeyDown(vKey: Byte): Boolean; // Pass a virtual-key code, ex. VK_F1, 'A', VK_RETURN, VK_LSHIFT, etc
var
  bKeys: Pz3DKeysArray;
begin
  bKeys := z3DCore_GetState.Keys;
  if (vKey >= $A0) and (vKey <= $A5) then // VK_LSHIFT, VK_RSHIFT, VK_LCONTROL, VK_RCONTROL, VK_LMENU, VK_RMENU
    Result:= GetAsyncKeyState(vKey) <> 0 // these keys only are tracked via GetAsyncKeyState()
  else if( vKey >= $01) and (vKey <= $06) and (vKey <> $03) then // mouse buttons (VK_*BUTTON)
    Result:= z3DCore_IsMouseButtonDown(vKey)
  else
    Result:= bKeys[vKey];
end;

function z3DCore_IsMouseButtonDown(vButton: Byte): Boolean; // Pass a virtual-key code: VK_LBUTTON, VK_RBUTTON, VK_MBUTTON, VK_XBUTTON1, VK_XBUTTON2
var
  bMouseButtons: Pz3DMouseButtonsArray;
  nIndex: Integer;
begin
  bMouseButtons := z3DCore_GetState.GetMouseButtons;
  nIndex := z3DMapButtonToArrayIndex(vButton);
  Result:= bMouseButtons[nIndex];
end;

procedure z3DCore_SetMultimonSettings(bAutoChangeAdapter: Boolean);
begin
  z3DCore_GetState.AutoChangeAdapter:= bAutoChangeAdapter;
end;

procedure z3DCore_SetCursorSettings(bShowCursorWhenFullScreen, bClipCursorWhenFullScreen: Boolean);
begin
  z3DCore_GetState.SetClipCursorWhenFullScreen(bClipCursorWhenFullScreen);
  z3DCore_GetState.SetShowCursorWhenFullScreen(bShowCursorWhenFullScreen);
  z3DSetupCursor;
end;

procedure z3DCore_SetWindowSettings(bCallDefWindowProc: Boolean);
begin
  z3DCore_GetState.SetCallDefWindowProc(bCallDefWindowProc);
end;

procedure z3DCore_SetConstantFrameTime(bConstantFrameTime: Boolean; fTimePerFrame: Single = 0.0333);
begin
  if (z3DCore_GetState.OverrideConstantFrameTime) then
  begin
    bConstantFrameTime := z3DCore_GetState.OverrideConstantFrameTime;
    fTimePerFrame := z3DCore_GetState.OverrideConstantTimePerFrame;
  end;
  z3DCore_GetState.SetConstantFrameTime(bConstantFrameTime);
  z3DCore_GetState.SetTimePerFrame(fTimePerFrame);
end;

function z3DCore_IsWindowed: Boolean;
var
  pDeviceSettings: Pz3DDeviceSettings;
begin
  pDeviceSettings := z3DCore_GetState.CurrentDeviceSettings;
  if (pDeviceSettings <> nil)
  then Result:= pDeviceSettings.PresentParams.Windowed
  else Result:= False;
end;

function z3DCore_GetPresentParameters: TD3DPresentParameters;
var
  pDS: Pz3DDeviceSettings;
  pp: TD3DPresentParameters;
begin
  pDS := z3DCore_GetState.CurrentDeviceSettings;
  if (pDS <> nil) then
  begin
    Result:= pDS.PresentParams;
  end else
  begin
    ZeroMemory(@pp, SizeOf(TD3DPresentParameters));
    Result:= pp;
  end;
end;

function z3DCore_GetDeviceSettings: Tz3DDeviceSettings;
var
  pDS: Pz3DDeviceSettings;
  ds: Tz3DDeviceSettings;
begin
  pDS := z3DCore_GetState.CurrentDeviceSettings;
  if (pDS <> nil) then
  begin
    Result:= pDS^;
  end else
  begin
    ZeroMemory(@ds, SizeOf(Tz3DDeviceSettings));
    Result:= ds;
  end;
end;

const
  SM_REMOTESESSION        = $1000;

procedure z3DDisplayErrorMessage(hr: HRESULT);
var
  strBuffer: PWideChar;
  nExitCode: Integer;
  bFound: Boolean;
  bShowMsgBoxOnError: Boolean;
begin
  GetMem(strBuffer, 255);
  bFound := true;
  case hr of
    Z3DERR_NODIRECT3D:             begin nExitCode := 2; StringToWideChar('Could not initialize Direct3D. Please make sure that you have DirectX 9.0c or later installed on your system. '+
                                                                     'If this problem persists, please contact the software manufacturer.', strBuffer, 255); end;
    Z3DERR_INCORRECTVERSION:       begin nExitCode := 10;StringToWideChar('Could not initialize Direct3D due to an incorrect version of Direct3D and/or D3DX. Please reinstall DirectX if this problem persists.', strBuffer, 255); end;
    Z3DERR_MEDIANOTFOUND:          begin nExitCode := 4; StringToWideChar('Could not find required media files. Please reinstall this program if the problem continues.', strBuffer, 255); end;
    Z3DERR_NONZEROREFCOUNT:        begin nExitCode := 5; StringToWideChar('The Direct3D device has a non-zero reference count, meaning some objects were not released. The system may become unstable.', strBuffer, 255); end;
    Z3DERR_CREATINGDEVICE:         begin nExitCode := 6; StringToWideChar('Could not create the Direct3D device. Please reinstall DirectX if this problem persists.', strBuffer, 255); end;
    Z3DERR_RESETTINGDEVICE:        begin nExitCode := 7; StringToWideChar('Could not reset the Direct3D device. Please reinstall DirectX if this problem persists.', strBuffer, 255); end;
    Z3DERR_CREATINGDEVICEOBJECTS:  begin nExitCode := 8; StringToWideChar('Could not create the Direct3D device objects. Please reinstall DirectX if this problem persists.', strBuffer, 255); end;
    Z3DERR_RESETTINGDEVICEOBJECTS: begin nExitCode := 9; StringToWideChar('Could not reset the Direct3D device objects. Please reinstall DirectX if this problem persists.', strBuffer, 255); end;
    Z3DERR_NOCOMPATIBLEDEVICES:
    begin
      nExitCode := 3;
      if (GetSystemMetrics(SM_REMOTESESSION) <> 0)
      then StringToWideChar('Direct3D does not work over a remote session. Reinstall this program if the problem persists.', strBuffer, 255)
      else StringToWideChar('The engine could not find any compatible Direct3D devices. Please review your hardware specifications to make sure that it reaches the program requirements.', strBuffer, 255);
    end;
  else
    bFound := False;
    nExitCode := 1;
  end;

  z3DCore_GetState.ExitCode:= nExitCode;

  bShowMsgBoxOnError := z3DCore_GetState.ShowMsgBoxOnError;
  if bShowMsgBoxOnError then
  begin
    if bFound then
    Application.MessageBox(PAnsiChar(strBuffer+#13#10+'The program must be terminated.'), PAnsiChar(Application.Title), MB_ICONERROR or MB_OK) else
    Application.MessageBox(PAnsiChar('An unknown error has ocurred. The program must be terminated. Error code: '+IntToStr(hr)), PAnsiChar(Application.Title), MB_ICONERROR or MB_OK);
  end;
  z3DCore_ShutDown(nExitCode);
//  FatalExit(nExitCode);
end;

procedure z3DCheckForWindowChangingMonitors;
{$IFDEF FPC}
begin
  if not z3DCore_GetState.AutoChangeAdapter then Exit;

{$ELSE}
var
  hr: HRESULT;
  hWindowMonitor: HMONITOR;
  hAdapterMonitor: HMONITOR;
  newOrdinal: LongWord;
  deviceSettings: Tz3DDeviceSettings;
  matchOptions: Tz3DMatchOptions;
begin
  // Skip this check for various reasons
  if not z3DCore_GetState.AutoChangeAdapter or
         z3DCore_GetState.IgnoreSizeChange or
     not z3DCore_GetState.DeviceCreated or
     not z3DCore_GetState.CurrentDeviceSettings.PresentParams.Windowed
  then Exit;

  hWindowMonitor := z3DMonitorFromWindow(z3DCore_GetHWND, MONITOR_DEFAULTTOPRIMARY);
  hAdapterMonitor := z3DCore_GetState.AdapterMonitor;
  if (hWindowMonitor <> hAdapterMonitor) then
  begin
    if SUCCEEDED(z3DGetAdapterOrdinalFromMonitor(hWindowMonitor, newOrdinal)) then
    begin
      // Find the closest valid device settings with the new ordinal
      deviceSettings := z3DCore_GetDeviceSettings;
      deviceSettings.AdapterOrdinal := newOrdinal;

      matchOptions.eAdapterOrdinal     := z3DMT_PRESERVE_INPUT;
      matchOptions.eDeviceType         := z3DMT_CLOSEST_TO_INPUT;
      matchOptions.eWindowed           := z3DMT_CLOSEST_TO_INPUT;
      matchOptions.eAdapterFormat      := z3DMT_CLOSEST_TO_INPUT;
      matchOptions.eVertexProcessing   := z3DMT_CLOSEST_TO_INPUT;
      matchOptions.eResolution         := z3DMT_CLOSEST_TO_INPUT;
      matchOptions.eBackBufferFormat   := z3DMT_CLOSEST_TO_INPUT;
      matchOptions.eBackBufferCount    := z3DMT_CLOSEST_TO_INPUT;
      matchOptions.eMultiSample        := z3DMT_CLOSEST_TO_INPUT;
      matchOptions.eSwapEffect         := z3DMT_CLOSEST_TO_INPUT;
      matchOptions.eDepthFormat        := z3DMT_CLOSEST_TO_INPUT;
      matchOptions.eStencilFormat      := z3DMT_CLOSEST_TO_INPUT;
      matchOptions.ePresentFlags       := z3DMT_CLOSEST_TO_INPUT;
      matchOptions.eRefreshRate        := z3DMT_CLOSEST_TO_INPUT;
      matchOptions.ePresentInterval    := z3DMT_CLOSEST_TO_INPUT;

      hr := z3DCore_FindValidDeviceSettings(deviceSettings, @deviceSettings, @matchOptions);
      if SUCCEEDED(hr) then
      begin
        // Create a Direct3D device using the new device settings.
        // If there is an existing device, then it will either reset or recreate the scene.
        hr := z3DChangeDevice(@deviceSettings, nil, False, False);
        // If hr == E_ABORT, this means the app rejected the device settings in the ModifySettingsCallback
        if (hr = E_ABORT) then
        begin
          // so nothing changed and keep from attempting to switch adapters next time
          z3DCore_GetState.AutoChangeAdapter := False;
        end else
        if FAILED(hr) then
        begin
          z3DCore_Shutdown;
          z3DCore_Pause(False, False);
          Exit;
        end;
      end;
    end;
  end;
{$ENDIF}
end;

function z3DGetAdapterOrdinalFromMonitor(hMonitor: HMONITOR; out pAdapterOrdinal: LongWord): HRESULT;
var
  pd3dEnum: Iz3DDeviceList;
  pD3D: IDirect3D9;
  pAdapterList: Tz3DEnumAdapterInfoArray;
  iAdapter: Integer;
  pAdapterInfo: Iz3DEnumAdapterInfo;
  hAdapterMonitor: {$IFDEF FPC}HANDLE{$ELSE}Direct3D9.HMONITOR{$ENDIF};
begin
  pAdapterOrdinal := 0;

  pd3dEnum := z3DPrepareDeviceListObject;
  pD3D     := z3DCore_GetD3DObject;

  pAdapterList := pd3dEnum.GetAdapterInfoList;
  for iAdapter:= 0 to Length(pAdapterList) - 1 do
  begin
    pAdapterInfo := pAdapterList[iAdapter];
    hAdapterMonitor := pD3D.GetAdapterMonitor(pAdapterInfo.AdapterOrdinal);
    if (hAdapterMonitor = hMonitor) then
    begin
      pAdapterOrdinal := pAdapterInfo.AdapterOrdinal;
      Result:= S_OK;
      Exit;
    end;
  end;

  Result:= E_FAIL;
end;

function z3DMapButtonToArrayIndex(vButton: Byte): Integer;
begin
  case vButton of
    MK_LBUTTON: Result:= 0;
    VK_MBUTTON,
    MK_MBUTTON: Result:= 1;
    MK_RBUTTON: Result:= 2;
    VK_XBUTTON1,
    MK_XBUTTON1: Result:= 3;
    VK_XBUTTON2,
    MK_XBUTTON2: Result:= 4;
  else
    Result:= 0;
  end;
end;


procedure z3DSetupCursor;
var
  pd3dDevice: IDirect3DDevice9;
  hCursor: Windows.HCURSOR;
  rcWindow: TRect;
begin
  // Show the cursor again if returning to fullscreen
  pd3dDevice := z3DCore_GetD3DDevice;
  if not z3DCore_IsWindowed and Assigned(pd3dDevice) then
  begin
    if z3DCore_GetState.ShowCursorWhenFullScreen then
    begin
      SetCursor(0); // Turn off Windows cursor in full screen mode
      hCursor := ULONG_PTR(GetClassLong{Ptr}(z3DCore_GetHWNDDeviceFullScreen, GCLP_HCURSOR));
      z3DSetDeviceCursor(pd3dDevice, hCursor, z3DCore_GetState.CursorWatermark);
      z3DCore_GetD3DDevice.ShowCursor(True);
    end else
    begin
      SetCursor(0); // Turn off Windows cursor in full screen mode
      z3DCore_GetD3DDevice.ShowCursor(False);
    end;
  end;

  // Clip cursor if requested
  if not z3DCore_IsWindowed and z3DCore_GetState.ClipCursorWhenFullScreen then
  begin
    // Confine cursor to full screen window
    GetWindowRect(z3DCore_GetHWNDDeviceFullScreen, rcWindow);
    ClipCursor(@rcWindow);
  end else
  begin
    ClipCursor(nil);
  end;
end;

function z3DSetDeviceCursor(const pd3dDevice: IDirect3DDevice9; hCursor: HCURSOR; bAddWatermark: Boolean): HRESULT;
const
  wMask: array [0..4] of Word = ($ccc0, $a2a0, $a4a0, $a2a0, $ccc0);
label
  End_;
type
  PACOLORREF = ^ACOLORREF;
  ACOLORREF = array[0..0] of COLORREF;
  pImg = ^img;
  img = array[0..16000] of DWORD;
var
  hr: HRESULT;
  iconinfo_: TIconInfo;
  bBWCursor: BOOL;
  pCursorSurface: IDirect3DSurface9;
  hdcColor: HDC;
  hdcMask: HDC;
  hdcScreen: HDC;
  bm: TBitmap;
  dwWidth: DWORD;
  dwHeightSrc: DWORD;
  dwHeightDest: DWORD;
  crColor: COLORREF;
  crMask: COLORREF;
  x, y: Cardinal;
  bmi: TBitmapInfo;
  pcrArrayColor: PACOLORREF;
  pcrArrayMask: PACOLORREF;
  pBitmap: pImg;
  hgdiobjOld: HGDIOBJ;
  lr: TD3DLockedRect;
begin
  hr := E_FAIL;
  pCursorSurface := nil;
  hdcColor := 0;
  hdcMask := 0;
  hdcScreen := 0;
  pcrArrayColor := nil;
  pcrArrayMask := nil;

  ZeroMemory(@iconinfo_, SizeOf(TIconInfo));
  if not GetIconInfo(hCursor, iconinfo_) then
    goto End_;

  if (0 = GetObject(iconinfo_.hbmMask, SizeOf(TBitmap), @bm)) then
    goto End_;
  dwWidth := bm.bmWidth;
  dwHeightSrc := bm.bmHeight;

  if (iconinfo_.hbmColor = 0) then
  begin
    bBWCursor := True;
    dwHeightDest := dwHeightSrc div 2;
  end else
  begin
    bBWCursor := False;
    dwHeightDest := dwHeightSrc;
  end;

  // Create a surface for the fullscreen cursor
  hr:= pd3dDevice.CreateOffscreenPlainSurface(dwWidth, dwHeightDest,
          D3DFMT_A8R8G8B8, D3DPOOL_SCRATCH, pCursorSurface, nil);
  if FAILED(hr) then
    goto End_;

  // pcrArrayMask = new DWORD[dwWidth * dwHeightSrc];
  GetMem(pcrArrayMask, SizeOf(DWORD)*(dwWidth * dwHeightSrc));

  ZeroMemory(@bmi, sizeof(bmi));
  bmi.bmiHeader.biSize := sizeof(bmi.bmiHeader);
  bmi.bmiHeader.biWidth := dwWidth;
  bmi.bmiHeader.biHeight := dwHeightSrc;
  bmi.bmiHeader.biPlanes := 1;
  bmi.bmiHeader.biBitCount := 32;
  bmi.bmiHeader.biCompression := BI_RGB;

  hdcScreen := GetDC(0);
  hdcMask := CreateCompatibleDC(hdcScreen);
  if (hdcMask = 0) then
  begin
    hr := E_FAIL;
    goto End_;
  end;
  hgdiobjOld := SelectObject(hdcMask, iconinfo_.hbmMask);
  GetDIBits(hdcMask, iconinfo_.hbmMask, 0, dwHeightSrc, pcrArrayMask, bmi,
    DIB_RGB_COLORS);
  SelectObject(hdcMask, hgdiobjOld);

  if (not bBWCursor) then
  begin
    // pcrArrayColor = new DWORD[dwWidth * dwHeightDest];
    GetMem(pcrArrayColor, SizeOf(DWORD)*(dwWidth * dwHeightDest));
    hdcColor := CreateCompatibleDC(hdcScreen);
    if (hdcColor = 0) then
    begin
      hr := E_FAIL;
      goto End_;
    end;
    SelectObject(hdcColor, iconinfo_.hbmColor);
    GetDIBits(hdcColor, iconinfo_.hbmColor, 0, dwHeightDest, pcrArrayColor, bmi,
      DIB_RGB_COLORS);
  end;

  // Transfer cursor image into the surface
  pCursorSurface.LockRect(lr, nil, 0);
  pBitmap:= lr.pBits;
  for y:= 0 to dwHeightDest - 1 do
  begin
    for x:= 0 to dwWidth - 1 do
    begin
      if bBWCursor then
      begin
        crColor:= pcrArrayMask^[dwWidth*(dwHeightDest-1-y) + x];
        crMask:= pcrArrayMask^[dwWidth*(dwHeightSrc-1-y) + x];
      end else
      begin
        crColor:= pcrArrayColor^[dwWidth*(dwHeightDest-1-y) + x];
        crMask:= pcrArrayMask^[dwWidth*(dwHeightDest-1-y) + x];
      end;
      if (crMask = 0) then
        pBitmap^[dwWidth*y + x]:= $FF000000 or crColor
      else
        pBitmap^[dwWidth*y + x]:= $00000000;

      // It may be helpful to make the D3D cursor look slightly
      // different from the Windows cursor so you can distinguish
      // between the two when developing/testing code.  When
      // bAddWatermark is TRUE, the following code adds some
      // small grey "D3D" characters to the upper-left corner of
      // the D3D cursor image.

      if bAddWatermark and (x < 12) and (y < 5) then
      begin
        // 11.. 11.. 11.. .... CCC0
        // 1.1. ..1. 1.1. .... A2A0
        // 1.1. .1.. 1.1. .... A4A0
        // 1.1. ..1. 1.1. .... A2A0
        // 11.. 11.. 11.. .... CCC0

        if (wMask[y] and (1 shl (15 - x)) <> 0) then
          pBitmap^[dwWidth*y + x]:= pBitmap^[dwWidth*y + x] or $FF808080;
      end;
    end;
  end;
  pCursorSurface.UnlockRect;

  // Set the device cursor
  hr := pd3dDevice.SetCursorProperties(iconinfo_.xHotspot,
      iconinfo_.yHotspot, pCursorSurface);
  if FAILED(hr) then
    goto End_;

  hr := S_OK;

End_:
  if (iconinfo_.hbmMask <> 0)  then DeleteObject(iconinfo_.hbmMask);
  if (iconinfo_.hbmColor <> 0) then DeleteObject(iconinfo_.hbmColor);
  if (hdcScreen <> 0)          then ReleaseDC(0, hdcScreen);
  if (hdcColor <> 0)           then DeleteDC(hdcColor);
  if (hdcMask <> 0)            then DeleteDC(hdcMask);
  // SafeDelete_ARRAY(pcrArrayColor);
  FreeMem(pcrArrayColor);
  // SafeDelete_ARRAY(pcrArrayMask);
  FreeMem(pcrArrayMask);
  SafeRelease(pCursorSurface);
  Result:= hr;
end;

var cache: Iz3DResourceCache = nil;
var timer: Iz3DTimer = nil;

function z3DCore_GetGlobalResourceCache: Iz3DResourceCache;
begin
  if (cache = nil) then cache:= Tz3DResourceCache.Create;
  Result:= cache;
end;

function z3DCore_GetGlobalTimer: Iz3DTimer;
begin
  if (timer = nil) then timer:= Tz3DTimer.Create;
  Result:= timer;
end;

function Tz3DDeviceList.GetCurrentDeviceInfo: Iz3DEnumDeviceInfo;
begin
  Result:= GetDeviceInfo(z3DCore_GetDeviceSettings.AdapterOrdinal,
  z3DCore_GetDeviceSettings.DeviceType);
end;

function Tz3DDeviceList.GetCurrentDeviceSettingsCombo: PD3DDeviceSettingsCombinations;
begin
  Result:= z3DCore_GetDeviceList.GetDeviceSettingsCombo(
  z3DCore_GetDeviceList.GetCurrentDeviceInfo.AdapterOrdinal,
  z3DCore_GetDeviceList.GetCurrentDeviceInfo.DeviceType,
  z3DCore_GetDeviceSettings.AdapterFormat,
  z3DCore_GetDeviceSettings.PresentParams.BackBufferFormat,
  z3DCore_GetDeviceSettings.PresentParams.Windowed);
end;

{ Tz3DResourceCache }

destructor Tz3DResourceCache.Destroy;
begin
  OnDestroyDevice;
  m_TextureCache:= nil;
  m_EffectCache:= nil;
  m_FontCache:= nil;
  inherited;
end;

function Tz3DResourceCache.CreateTextureFromFile(pDevice: IDirect3DDevice9; pSrcFile: PWideChar; out ppTexture: IDirect3DTexture9): HRESULT;
begin
  Result:= CreateTextureFromFileEx(pDevice, pSrcFile, D3DX_DEFAULT, D3DX_DEFAULT, D3DX_DEFAULT,
  0, D3DFMT_UNKNOWN, D3DPOOL_MANAGED, D3DX_DEFAULT, D3DX_DEFAULT, 0, nil, nil, ppTexture);
end;

function Tz3DResourceCache.CreateTextureFromFileEx(pDevice: IDirect3DDEVICE9; pSrcFile: PWideChar;
  Width, Height, MipLevels: LongWord; Usage: DWORD; Format: TD3DFormat; Pool: TD3DPool;
  Filter, MipFilter: DWORD; ColorKey: TD3DColor; pSrcInfo: PD3DXImageInfo; pPalette: PPaletteEntry;
  out ppTexture: IDirect3DTexture9): HRESULT;
var
  i: Integer;
  Entry: Pz3DCacheTexture;
  NewEntry: Tz3DCacheTexture;
begin
  for i := 0 to Length(m_TextureCache) - 1 do
  begin
    Entry := @m_TextureCache[i];
    if (Entry.Location = z3DCACHE_LOCATION_FILE) and
       (lstrcmpW(Entry.wszSource, pSrcFile) = 0) and
       (Entry.Width = Width) and
       (Entry.Height = Height) and
       (Entry.MipLevels = MipLevels) and
       (Entry.Usage = Usage) and
       (Entry.Format = Format) and
       (Entry.Pool = Pool) and
       (Entry._Type = D3DRTYPE_TEXTURE) then
    begin
      Result:= Entry.pTexture.QueryInterface(IID_IDirect3DTexture9, ppTexture);
      Exit;
    end;
  end;
  Result := D3DXCreateTextureFromFileExW(pDevice, pSrcFile, Width, Height, MipLevels, Usage, Format,
  Pool, Filter, MipFilter, ColorKey, pSrcInfo, pPalette, ppTexture);
  if FAILED(Result) then Exit;
  NewEntry.Location := z3DCACHE_LOCATION_FILE;
  StringCchCopy(NewEntry.wszSource, MAX_PATH, pSrcFile);
  NewEntry.Width := Width;
  NewEntry.Height := Height;
  NewEntry.MipLevels := MipLevels;
  NewEntry.Usage := Usage;
  NewEntry.Format := Format;
  NewEntry.Pool := Pool;
  NewEntry._Type := D3DRTYPE_TEXTURE;
  ppTexture.QueryInterface(IID_IDirect3DBaseTexture9, NewEntry.pTexture);
  i:= Length(m_TextureCache);
  SetLength(m_TextureCache, i+1);
  m_TextureCache[i]:= NewEntry;
  Result:= S_OK;
end;

function Tz3DResourceCache.CreateTextureFromResource(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar; ppTexture: IDirect3DTexture9): HRESULT;
begin
  Result:= CreateTextureFromResourceEx(pDevice, hSrcModule, pSrcResource, D3DX_DEFAULT, D3DX_DEFAULT,
  D3DX_DEFAULT, 0, D3DFMT_UNKNOWN, D3DPOOL_MANAGED, D3DX_DEFAULT, D3DX_DEFAULT, 0, nil, nil, ppTexture);
end;

function Tz3DResourceCache.CreateTextureFromResourceEx(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar;
  Width, Height, MipLevels: LongWord; Usage: DWORD; Format: TD3DFormat; Pool: TD3DPool; Filter, MipFilter: DWORD; ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo; pPalette: PPaletteEntry; out ppTexture: IDirect3DTexture9): HRESULT;
var i: Integer;
    Entry: Pz3DCacheTexture;
    NewEntry: Tz3DCacheTexture;
begin
  for i := 0 to Length(m_TextureCache) - 1 do
  begin
    Entry := @m_TextureCache[i];
    if (Entry.Location = z3DCACHE_LOCATION_RESOURCE) and
       (Entry.hSrcModule = hSrcModule) and
       (lstrcmpW(Entry.wszSource, pSrcResource) = 0) and
       (Entry.Width = Width) and
       (Entry.Height = Height) and
       (Entry.MipLevels = MipLevels) and
       (Entry.Usage = Usage) and
       (Entry.Format = Format) and
       (Entry.Pool = Pool) and
       (Entry._Type = D3DRTYPE_TEXTURE) then
    begin
      Result:= Entry.pTexture.QueryInterface(IID_IDirect3DTexture9, ppTexture);
      Exit;
    end;
  end;
  Result := D3DXCreateTextureFromResourceExW(pDevice, hSrcModule, pSrcResource,
  Width, Height, MipLevels, Usage, Format, Pool, Filter, MipFilter, ColorKey, pSrcInfo, pPalette, ppTexture);
  if FAILED(Result) then Exit;
  NewEntry.Location := z3DCACHE_LOCATION_RESOURCE;
  NewEntry.hSrcModule := hSrcModule;
  StringCchCopy(NewEntry.wszSource, MAX_PATH, pSrcResource);
  NewEntry.Width := Width;
  NewEntry.Height := Height;
  NewEntry.MipLevels := MipLevels;
  NewEntry.Usage := Usage;
  NewEntry.Format := Format;
  NewEntry.Pool := Pool;
  NewEntry._Type := D3DRTYPE_TEXTURE;
  ppTexture.QueryInterface(IID_IDirect3DBaseTexture9, NewEntry.pTexture);
  i:= Length(m_TextureCache);
  SetLength(m_TextureCache, i+1);
  m_TextureCache[i]:= NewEntry;
  Result:= S_OK;
end;

function Tz3DResourceCache.CreateCubeTextureFromFile(pDevice: IDirect3DDevice9; pSrcFile: PWideChar; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT;
begin
  Result:= CreateCubeTextureFromFileEx(pDevice, pSrcFile, D3DX_DEFAULT, D3DX_DEFAULT, 0,
  D3DFMT_UNKNOWN, D3DPOOL_MANAGED, D3DX_DEFAULT, D3DX_DEFAULT, 0, nil, nil, ppCubeTexture);
end;

function Tz3DResourceCache.CreateCubeTextureFromFileEx(pDevice: IDirect3DDevice9; pSrcFile: PWideChar;
  Size, MipLevels: LongWord; Usage: DWORD; Format: TD3DFormat;
  Pool: TD3DPool; Filter, MipFilter: DWORD; ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo; pPalette: PPaletteEntry; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT;
var
  i: Integer;
  Entry: Pz3DCacheTexture;
  NewEntry: Tz3DCacheTexture;
begin
  for i := 0 to Length(m_TextureCache) - 1 do
  begin
    Entry := @m_TextureCache[i];
    if (Entry.Location = z3DCACHE_LOCATION_FILE) and
       (lstrcmpW(Entry.wszSource, pSrcFile) = 0) and
       (Entry.Width = Size) and
       (Entry.MipLevels = MipLevels) and
       (Entry.Usage = Usage) and
       (Entry.Format = Format) and
       (Entry.Pool = Pool) and
       (Entry._Type = D3DRTYPE_TEXTURE) then
    begin
      Result:= Entry.pTexture.QueryInterface(IID_IDirect3DCubeTexture9, ppCubeTexture);
      Exit;
    end;
  end;
  Result := D3DXCreateCubeTextureFromFileExW(pDevice, pSrcFile, Size, MipLevels, Usage, Format, Pool, Filter,
  MipFilter, ColorKey, pSrcInfo, pPalette, ppCubeTexture);
  if FAILED(Result) then Exit;
  NewEntry.Location := z3DCACHE_LOCATION_FILE;
  StringCchCopy(NewEntry.wszSource, MAX_PATH, pSrcFile);
  NewEntry.Width := Size;
  NewEntry.MipLevels := MipLevels;
  NewEntry.Usage := Usage;
  NewEntry.Format := Format;
  NewEntry.Pool := Pool;
  NewEntry._Type := D3DRTYPE_CUBETEXTURE;
  ppCubeTexture.QueryInterface(IID_IDirect3DBaseTexture9, NewEntry.pTexture);
  i:= Length(m_TextureCache);
  SetLength(m_TextureCache, i+1);
  m_TextureCache[i]:= NewEntry;
  Result:= S_OK;
end;

function Tz3DResourceCache.CreateCubeTextureFromResource(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT;
begin
  Result:= CreateCubeTextureFromResourceEx(pDevice, hSrcModule, pSrcResource, D3DX_DEFAULT, D3DX_DEFAULT,
  0, D3DFMT_UNKNOWN, D3DPOOL_MANAGED, D3DX_DEFAULT, D3DX_DEFAULT, 0, nil, nil, ppCubeTexture);
end;

function Tz3DResourceCache.CreateCubeTextureFromResourceEx(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar;
  Size, MipLevels: LongWord; Usage: DWORD; Format: TD3DFormat; Pool: TD3DPool; Filter, MipFilter: DWORD; ColorKey: TD3DColor;
  pSrcInfo: PD3DXImageInfo; pPalette: PPaletteEntry; out ppCubeTexture: IDirect3DCubeTexture9): HRESULT;
var
  i: Integer;
  Entry: Pz3DCacheTexture;
  NewEntry: Tz3DCacheTexture;
begin
  for i := 0 to Length(m_TextureCache) - 1 do
  begin
    Entry := @m_TextureCache[i];
    if (Entry.Location = z3DCACHE_LOCATION_RESOURCE) and
       (Entry.hSrcModule = hSrcModule) and
       (lstrcmpW(Entry.wszSource, pSrcResource) = 0) and
       (Entry.Width = Size) and
       (Entry.MipLevels = MipLevels) and
       (Entry.Usage = Usage) and
       (Entry.Format = Format) and
       (Entry.Pool = Pool) and
       (Entry._Type = D3DRTYPE_TEXTURE) then
    begin
      Result:= Entry.pTexture.QueryInterface(IID_IDirect3DCubeTexture9, ppCubeTexture);
      Exit;
    end;
  end;
  Result := D3DXCreateCubeTextureFromResourceExW(pDevice, hSrcModule, pSrcResource, Size, MipLevels, Usage, Format,
  Pool, Filter, MipFilter, ColorKey, pSrcInfo, pPalette, ppCubeTexture);
  if FAILED(Result) then Exit;
  NewEntry.Location := z3DCACHE_LOCATION_RESOURCE;
  NewEntry.hSrcModule := hSrcModule;
  StringCchCopy(NewEntry.wszSource, MAX_PATH, pSrcResource);
  NewEntry.Width := Size;
  NewEntry.MipLevels := MipLevels;
  NewEntry.Usage := Usage;
  NewEntry.Format := Format;
  NewEntry.Pool := Pool;
  NewEntry._Type := D3DRTYPE_CUBETEXTURE;
  ppCubeTexture.QueryInterface(IID_IDirect3DBaseTexture9, NewEntry.pTexture);
  i:= Length(m_TextureCache);
  SetLength(m_TextureCache, i+1);
  m_TextureCache[i]:= NewEntry;
  Result:= S_OK;
end;

function Tz3DResourceCache.CreateVolumeTextureFromFile(pDevice: IDirect3DDevice9; pSrcFile: PWideChar; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT;
begin
  Result:= CreateVolumeTextureFromFileEx(pDevice, pSrcFile, D3DX_DEFAULT, D3DX_DEFAULT, D3DX_DEFAULT, D3DX_DEFAULT,
  0, D3DFMT_UNKNOWN, D3DPOOL_MANAGED, D3DX_DEFAULT, D3DX_DEFAULT, 0, nil, nil, ppVolumeTexture);
end;

function Tz3DResourceCache.CreateVolumeTextureFromFileEx(pDevice: IDirect3DDevice9; pSrcFile: PWideChar;
  Width, Height, Depth, MipLevels: LongWord; Usage: DWORD; Format: TD3DFormat; Pool: TD3DPool;
  Filter, MipFilter: DWORD; ColorKey: TD3DColor; pSrcInfo: PD3DXImageInfo; pPalette: PPaletteEntry; out ppTexture: IDirect3DVolumeTexture9): HRESULT;
var
  i: Integer;
  Entry: Pz3DCacheTexture;
  NewEntry: Tz3DCacheTexture;
begin
  for i := 0 to Length(m_TextureCache) - 1 do
  begin
    Entry := @m_TextureCache[i];
    if (Entry.Location = z3DCACHE_LOCATION_FILE) and
       (lstrcmpW(Entry.wszSource, pSrcFile) = 0) and
       (Entry.Width = Width) and
       (Entry.Height = Height) and
       (Entry.Depth = Depth) and
       (Entry.MipLevels = MipLevels) and
       (Entry.Usage = Usage) and
       (Entry.Format = Format) and
       (Entry.Pool = Pool) and
       (Entry._Type = D3DRTYPE_TEXTURE) then
    begin
      Result:= Entry.pTexture.QueryInterface(IID_IDirect3DVolumeTexture9, ppTexture);
      Exit;
    end;
  end;
  Result := D3DXCreateVolumeTextureFromFileExW(pDevice, pSrcFile, Width, Height, Depth, MipLevels, Usage, Format,
  Pool, Filter, MipFilter, ColorKey, pSrcInfo, pPalette, ppTexture);
  if FAILED(Result) then Exit;
  NewEntry.Location := z3DCACHE_LOCATION_FILE;
  StringCchCopy(NewEntry.wszSource, MAX_PATH, pSrcFile);
  NewEntry.Width := Width;
  NewEntry.Height := Height;
  NewEntry.Depth := Depth;
  NewEntry.MipLevels := MipLevels;
  NewEntry.Usage := Usage;
  NewEntry.Format := Format;
  NewEntry.Pool := Pool;
  NewEntry._Type := D3DRTYPE_VOLUMETEXTURE;
  ppTexture.QueryInterface(IID_IDirect3DBaseTexture9, NewEntry.pTexture);
  i:= Length(m_TextureCache);
  SetLength(m_TextureCache, i+1);
  m_TextureCache[i]:= NewEntry;
  Result:= S_OK;
end;

function Tz3DResourceCache.CreateVolumeTextureFromResource(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT;
begin
  Result:= CreateVolumeTextureFromResourceEx(pDevice, hSrcModule, pSrcResource, D3DX_DEFAULT, D3DX_DEFAULT,
  D3DX_DEFAULT, D3DX_DEFAULT, 0, D3DFMT_UNKNOWN, D3DPOOL_MANAGED, D3DX_DEFAULT, D3DX_DEFAULT, 0, nil, nil, ppVolumeTexture);
end;

function Tz3DResourceCache.CreateVolumeTextureFromResourceEx(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar;
  Width, Height, Depth, MipLevels: LongWord; Usage: DWORD; Format: TD3DFormat; Pool: TD3DPool; Filter, MipFilter: DWORD;
  ColorKey: TD3DColor; pSrcInfo: PD3DXImageInfo; pPalette: PPaletteEntry; out ppVolumeTexture: IDirect3DVolumeTexture9): HRESULT;
var
  i: Integer;
  Entry: Pz3DCacheTexture;
  NewEntry: Tz3DCacheTexture;
begin
  for i := 0 to Length(m_TextureCache) - 1 do
  begin
    Entry := @m_TextureCache[i];
    if (Entry.Location = z3DCACHE_LOCATION_RESOURCE) and
       (Entry.hSrcModule = hSrcModule) and
       (lstrcmpW(Entry.wszSource, pSrcResource) = 0) and
       (Entry.Width = Width) and
       (Entry.Height = Height) and
       (Entry.Depth = Depth) and
       (Entry.MipLevels = MipLevels) and
       (Entry.Usage = Usage) and
       (Entry.Format = Format) and
       (Entry.Pool = Pool) and
       (Entry._Type = D3DRTYPE_VOLUMETEXTURE) then
    begin
      Result:= Entry.pTexture.QueryInterface(IID_IDirect3DVolumeTexture9, ppVolumeTexture);
      Exit;
    end;
  end;
  Result := D3DXCreateVolumeTextureFromResourceExW(pDevice, hSrcModule, pSrcResource, Width, Height, Depth, MipLevels, Usage,
  Format, Pool, Filter, MipFilter, ColorKey, pSrcInfo, pPalette, ppVolumeTexture);
  if FAILED(Result) then Exit;
  NewEntry.Location := z3DCACHE_LOCATION_RESOURCE;
  NewEntry.hSrcModule := hSrcModule;
  StringCchCopy(NewEntry.wszSource, MAX_PATH, pSrcResource);
  NewEntry.Width := Width;
  NewEntry.Height := Height;
  NewEntry.Depth := Depth;
  NewEntry.MipLevels := MipLevels;
  NewEntry.Usage := Usage;
  NewEntry.Format := Format;
  NewEntry.Pool := Pool;
  NewEntry._Type := D3DRTYPE_VOLUMETEXTURE;
  ppVolumeTexture.QueryInterface(IID_IDirect3DBaseTexture9, NewEntry.pTexture);
  i:= Length(m_TextureCache);
  SetLength(m_TextureCache, i+1);
  m_TextureCache[i]:= NewEntry;
  Result:= S_OK;
end;

function Tz3DResourceCache.CreateFont(pDevice: IDirect3DDevice9; Height, Width, Weight, MipLevels: LongWord;
  Italic: BOOL; CharSet, OutputPrecision, Quality, PitchAndFamily: Byte; pFacename: PWideChar; out ppFont: ID3DXFont): HRESULT;
var
  Desc: TD3DXFontDescW;
begin
  Desc.Height := Height;
  Desc.Width := Width;
  Desc.Weight := Weight;
  Desc.MipLevels := MipLevels;
  Desc.Italic := Italic;
  Desc.CharSet := CharSet;
  Desc.OutputPrecision := OutputPrecision;
  Desc.Quality := Quality;
  Desc.PitchAndFamily := PitchAndFamily;
  StringCchCopy(Desc.FaceName, LF_FACESIZE, pFacename);
  Result:= CreateFontIndirect(pDevice, Desc, ppFont);
end;

function Tz3DResourceCache.CreateFontIndirect(pDevice: IDirect3DDevice9; const pDesc: TD3DXFontDescW; out ppFont: ID3DXFont): HRESULT;
var
  i: Integer;
  Entry: Tz3DCacheFont;
  NewEntry: Tz3DCacheFont;
begin
  for i := 0 to Length(m_FontCache) - 1 do
  begin
    Entry := m_FontCache[i];
    if (Entry.Width = pDesc.Width) and
       (Entry.Height = pDesc.Height) and
       (Entry.Weight = pDesc.Weight) and
       (Entry.MipLevels = pDesc.MipLevels) and
       (Entry.Italic = pDesc.Italic) and
       (Entry.CharSet = pDesc.CharSet) and
       (Entry.OutputPrecision = pDesc.OutputPrecision) and
       (Entry.Quality = pDesc.Quality) and
       (Entry.PitchAndFamily = pDesc.PitchAndFamily) and
       (CompareStringW(LOCALE_USER_DEFAULT, NORM_IGNORECASE,
                       Entry.FaceName, -1,
                       pDesc.FaceName, -1) = CSTR_EQUAL) then
    begin
      ppFont := Entry.pFont;
      Result:= S_OK;
      Exit;
    end;
  end;
  Result := D3DXCreateFontIndirectW(pDevice, pDesc, ppFont);
  if FAILED(Result) then Exit;
  PD3DXFontDescW(@NewEntry)^ := pDesc;
  NewEntry.pFont := ppFont;
  i:= Length(m_FontCache);
  SetLength(m_FontCache, i+1);
  m_FontCache[i]:= NewEntry;
  Result:= S_OK;
end;

function Tz3DResourceCache.CreateEffectFromFile(pDevice: IDirect3DDevice9; pSrcFile: PWideChar;
  const pDefines: PD3DXMacro; pInclude: ID3DXInclude; Flags: DWORD; pPool: ID3DXEffectPool; out ppEffect: ID3DXEffect; ppCompilationErrors: PID3DXBuffer): HRESULT;
var
  i: Integer;
  Entry: Tz3DCacheEffect;
  NewEntry: Tz3DCacheEffect;
begin
  for i := 0 to Length(m_EffectCache) - 1 do
  begin
   Entry := m_EffectCache[i];
   if (Entry.Location = z3DCACHE_LOCATION_FILE) and
      (lstrcmpW(Entry.wszSource, pSrcFile) = 0) and
      (Entry.dwFlags = Flags) then
   begin
     ppEffect := Entry.pEffect;
     Result:= S_OK;
     Exit;
   end;
  end;
  Result := D3DXCreateEffectFromFileW(pDevice, pSrcFile, pDefines, pInclude, Flags, pPool, ppEffect, ppCompilationErrors);
  if FAILED(Result) then Exit;
  NewEntry.Location := z3DCACHE_LOCATION_FILE;
  StringCchCopy(NewEntry.wszSource, MAX_PATH, pSrcFile);
  NewEntry.dwFlags := Flags;
  NewEntry.pEffect := ppEffect;
  i:= Length(m_EffectCache);
  SetLength(m_EffectCache, i+1);
  m_EffectCache[i]:= NewEntry;
  Result:= S_OK;
end;

function Tz3DResourceCache.CreateEffectFromResource(pDevice: IDirect3DDevice9; hSrcModule: HMODULE; pSrcResource: PWideChar;
  const pDefines: PD3DXMacro; pInclude: ID3DXInclude; Flags: DWORD; pPool: ID3DXEffectPool; out ppEffect: ID3DXEffect; ppCompilationErrors: PID3DXBuffer): HRESULT;
var
  i: Integer;
  Entry: Tz3DCacheEffect;
  NewEntry: Tz3DCacheEffect;
begin
  for i := 0 to Length(m_EffectCache) - 1 do
  begin
   Entry := m_EffectCache[i];
   if (Entry.Location = z3DCACHE_LOCATION_RESOURCE) and
      (Entry.hSrcModule = hSrcModule) and
      (lstrcmpW(Entry.wszSource, pSrcResource) = 0) and
      (Entry.dwFlags = Flags) then
    begin
      ppEffect := Entry.pEffect;
      Result:= S_OK;
      Exit;
    end;
  end;
  Result := D3DXCreateEffectFromResourceW(pDevice, hSrcModule, pSrcResource, pDefines, pInclude, Flags,
  pPool, ppEffect, ppCompilationErrors);
  if FAILED(Result) then Exit;
  NewEntry.Location := z3DCACHE_LOCATION_RESOURCE;
  NewEntry.hSrcModule := hSrcModule;
  StringCchCopy(NewEntry.wszSource, MAX_PATH, pSrcResource);
  NewEntry.dwFlags := Flags;
  NewEntry.pEffect := ppEffect;
  i:= Length(m_EffectCache);
  SetLength(m_EffectCache, i+1);
  m_EffectCache[i]:= NewEntry;
  Result:= S_OK;
end;

function Tz3DResourceCache.OnCreateDevice(pd3dDevice: IDirect3DDevice9): HResult;
begin
  Result:= S_OK;
end;

function Tz3DResourceCache.OnResetDevice(pd3dDevice: IDirect3DDevice9): HResult;
var
  i: Integer;
begin
  for i := 0 to Length(m_EffectCache) - 1 do
    m_EffectCache[i].pEffect.OnResetDevice;
  for i := 0 to Length(m_FontCache) - 1 do
    m_FontCache[i].pFont.OnResetDevice;
  Result:= S_OK;
end;

function Tz3DResourceCache.OnLostDevice: HResult;
var
  i, l: Integer;
  m_TextureCacheCopy: Tz3DCacheTextureArray; // array of Tz3DCacheTexture;
begin
  for i := 0 to Length(m_EffectCache) - 1 do
    m_EffectCache[i].pEffect.OnLostDevice;
  for i := 0 to Length(m_FontCache) - 1 do
    m_FontCache[i].pFont.OnLostDevice;
  for i := 0 to Length(m_TextureCache) - 1 do
    if (m_TextureCache[i].Pool <> D3DPOOL_DEFAULT) then
    begin // copy non D3DPOOL_DEFAULT texture
      l:= Length(m_TextureCacheCopy);
      SetLength(m_TextureCacheCopy, l+1);
      m_TextureCacheCopy[l]:= m_TextureCache[i];
    end;
  m_TextureCache:= nil; // Free D3DPOOL_DEFAULT textures
  m_TextureCache:= m_TextureCacheCopy;
  Result:= S_OK;
end;

function Tz3DResourceCache.OnDestroyDevice: HResult;
begin
  m_EffectCache:= nil;
  m_FontCache:= nil;
  m_TextureCache:= nil;
  Result:= S_OK;
end;

type
  TDirect3DCreate9 = function(SDKVersion: LongWord): Pointer; stdcall;

var
  s_hModD3D9: HMODULE = 0;
  s_DynamicDirect3DCreate9: TDirect3DCreate9 = nil;

function z3D_EnsureD3DAPIs: Boolean;
var wszPath: array[0..MAX_PATH] of WideChar;
begin
  if (s_hModD3D9 <> 0) then
  begin
    Result:= True;
    Exit;
  end;
  Result:= False;
  if GetSystemDirectoryW(wszPath, MAX_PATH+1) = 0 then Exit;
  StringCchCat(wszPath, MAX_PATH, PWideChar(WideString('\d3d9.dll')));
  s_hModD3D9 := LoadLibraryW(wszPath);
  if (s_hModD3D9 = 0) then Exit;
  s_DynamicDirect3DCreate9:= GetProcAddress(s_hModD3D9, 'Direct3DCreate9');
  Result:= True;
end;

function z3DCreateDynamicDirect3D9(SDKVersion: LongWord): IDirect3D9; stdcall;
begin
  if z3D_EnsureD3DAPIs and (@s_DynamicDirect3DCreate9 <> nil) then
  begin
    Result:= IDirect3D9(s_DynamicDirect3DCreate9(SDKVersion));
    if Assigned(Result) then Result._Release;
  end else
  begin
    Result:= nil;
    z3DTrace('Could not initialize Direct3D. Please make sure that you have DirectX 9.0c installed.', z3DtkError);
  end;
end;

function z3DD3DFormatToString(format: TD3DFormat; bWithPrefix: Boolean): PWideChar;
begin
  case format of
    D3DFMT_UNKNOWN:         Result:= 'D3DFMT_UNKNOWN';
    D3DFMT_R8G8B8:          Result:= 'D3DFMT_R8G8B8';
    D3DFMT_A8R8G8B8:        Result:= 'D3DFMT_A8R8G8B8';
    D3DFMT_X8R8G8B8:        Result:= 'D3DFMT_X8R8G8B8';
    D3DFMT_R5G6B5:          Result:= 'D3DFMT_R5G6B5';
    D3DFMT_X1R5G5B5:        Result:= 'D3DFMT_X1R5G5B5';
    D3DFMT_A1R5G5B5:        Result:= 'D3DFMT_A1R5G5B5';
    D3DFMT_A4R4G4B4:        Result:= 'D3DFMT_A4R4G4B4';
    D3DFMT_R3G3B2:          Result:= 'D3DFMT_R3G3B2';
    D3DFMT_A8:              Result:= 'D3DFMT_A8';
    D3DFMT_A8R3G3B2:        Result:= 'D3DFMT_A8R3G3B2';
    D3DFMT_X4R4G4B4:        Result:= 'D3DFMT_X4R4G4B4';
    D3DFMT_A2B10G10R10:     Result:= 'D3DFMT_A2B10G10R10';
    D3DFMT_A8B8G8R8:        Result:= 'D3DFMT_A8B8G8R8';
    D3DFMT_X8B8G8R8:        Result:= 'D3DFMT_X8B8G8R8';
    D3DFMT_G16R16:          Result:= 'D3DFMT_G16R16';
    D3DFMT_A2R10G10B10:     Result:= 'D3DFMT_A2R10G10B10';
    D3DFMT_A16B16G16R16:    Result:= 'D3DFMT_A16B16G16R16';
    D3DFMT_A8P8:            Result:= 'D3DFMT_A8P8';
    D3DFMT_P8:              Result:= 'D3DFMT_P8';
    D3DFMT_L8:              Result:= 'D3DFMT_L8';
    D3DFMT_A8L8:            Result:= 'D3DFMT_A8L8';
    D3DFMT_A4L4:            Result:= 'D3DFMT_A4L4';
    D3DFMT_V8U8:            Result:= 'D3DFMT_V8U8';
    D3DFMT_L6V5U5:          Result:= 'D3DFMT_L6V5U5';
    D3DFMT_X8L8V8U8:        Result:= 'D3DFMT_X8L8V8U8';
    D3DFMT_Q8W8V8U8:        Result:= 'D3DFMT_Q8W8V8U8';
    D3DFMT_V16U16:          Result:= 'D3DFMT_V16U16';
    D3DFMT_A2W10V10U10:     Result:= 'D3DFMT_A2W10V10U10';
    D3DFMT_UYVY:            Result:= 'D3DFMT_UYVY';
    D3DFMT_YUY2:            Result:= 'D3DFMT_YUY2';
    D3DFMT_DXT1:            Result:= 'D3DFMT_DXT1';
    D3DFMT_DXT2:            Result:= 'D3DFMT_DXT2';
    D3DFMT_DXT3:            Result:= 'D3DFMT_DXT3';
    D3DFMT_DXT4:            Result:= 'D3DFMT_DXT4';
    D3DFMT_DXT5:            Result:= 'D3DFMT_DXT5';
    D3DFMT_D16_LOCKABLE:    Result:= 'D3DFMT_D16_LOCKABLE';
    D3DFMT_D32:             Result:= 'D3DFMT_D32';
    D3DFMT_D15S1:           Result:= 'D3DFMT_D15S1';
    D3DFMT_D24S8:           Result:= 'D3DFMT_D24S8';
    D3DFMT_D24X8:           Result:= 'D3DFMT_D24X8';
    D3DFMT_D24X4S4:         Result:= 'D3DFMT_D24X4S4';
    D3DFMT_D16:             Result:= 'D3DFMT_D16';
    D3DFMT_L16:             Result:= 'D3DFMT_L16';
    D3DFMT_VERTEXDATA:      Result:= 'D3DFMT_VERTEXDATA';
    D3DFMT_INDEX16:         Result:= 'D3DFMT_INDEX16';
    D3DFMT_INDEX32:         Result:= 'D3DFMT_INDEX32';
    D3DFMT_Q16W16V16U16:    Result:= 'D3DFMT_Q16W16V16U16';
    D3DFMT_MULTI2_ARGB8:    Result:= 'D3DFMT_MULTI2_ARGB8';
    D3DFMT_R16F:            Result:= 'D3DFMT_R16F';
    D3DFMT_G16R16F:         Result:= 'D3DFMT_G16R16F';
    D3DFMT_A16B16G16R16F:   Result:= 'D3DFMT_A16B16G16R16F';
    D3DFMT_R32F:            Result:= 'D3DFMT_R32F';
    D3DFMT_G32R32F:         Result:= 'D3DFMT_G32R32F';
    D3DFMT_A32B32G32R32F:   Result:= 'D3DFMT_A32B32G32R32F';
    D3DFMT_CxV8U8:          Result:= 'D3DFMT_CxV8U8';
  else
    Result:= 'Unknown format';
  end;
  if (bWithPrefix or (Pos('D3DFMT_', Result) = 0)) then
  else Result:= Result + Length('D3DFMT_');
end;

function z3DTraceD3DDECLTYPEtoString(t: TD3DDeclType): PWideChar;
begin
  case t of
    D3DDECLTYPE_FLOAT1: Result := 'D3DDECLTYPE_FLOAT1';
    D3DDECLTYPE_FLOAT2: Result := 'D3DDECLTYPE_FLOAT2';
    D3DDECLTYPE_FLOAT3: Result := 'D3DDECLTYPE_FLOAT3';
    D3DDECLTYPE_FLOAT4: Result := 'D3DDECLTYPE_FLOAT4';
    D3DDECLTYPE_D3DCOLOR: Result := 'D3DDECLTYPE_D3DCOLOR';
    D3DDECLTYPE_UBYTE4: Result := 'D3DDECLTYPE_UBYTE4';
    D3DDECLTYPE_SHORT2: Result := 'D3DDECLTYPE_SHORT2';
    D3DDECLTYPE_SHORT4: Result := 'D3DDECLTYPE_SHORT4';
    D3DDECLTYPE_UBYTE4N: Result := 'D3DDECLTYPE_UBYTE4N';
    D3DDECLTYPE_SHORT2N: Result := 'D3DDECLTYPE_SHORT2N';
    D3DDECLTYPE_SHORT4N: Result := 'D3DDECLTYPE_SHORT4N';
    D3DDECLTYPE_USHORT2N: Result := 'D3DDECLTYPE_USHORT2N';
    D3DDECLTYPE_USHORT4N: Result := 'D3DDECLTYPE_USHORT4N';
    D3DDECLTYPE_UDEC3: Result := 'D3DDECLTYPE_UDEC3';
    D3DDECLTYPE_DEC3N: Result := 'D3DDECLTYPE_DEC3N';
    D3DDECLTYPE_FLOAT16_2: Result := 'D3DDECLTYPE_FLOAT16_2';
    D3DDECLTYPE_FLOAT16_4: Result := 'D3DDECLTYPE_FLOAT16_4';
    D3DDECLTYPE_UNUSED: Result := 'D3DDECLTYPE_UNUSED';
  else
    Result:= 'D3DDECLTYPE Unknown';
  end;
end;

function z3DTraceD3DDECLMETHODtoString(m: TD3DDeclMethod): PWideChar;
begin
  case m of
    D3DDECLMETHOD_DEFAULT: Result := 'D3DDECLMETHOD_DEFAULT';
    D3DDECLMETHOD_PARTIALU: Result := 'D3DDECLMETHOD_PARTIALU';
    D3DDECLMETHOD_PARTIALV: Result := 'D3DDECLMETHOD_PARTIALV';
    D3DDECLMETHOD_CROSSUV: Result := 'D3DDECLMETHOD_CROSSUV';
    D3DDECLMETHOD_UV: Result := 'D3DDECLMETHOD_UV';
    D3DDECLMETHOD_LOOKUP: Result := 'D3DDECLMETHOD_LOOKUP';
    D3DDECLMETHOD_LOOKUPPRESAMPLED: Result := 'D3DDECLMETHOD_LOOKUPPRESAMPLED';
  else
    Result := 'D3DDECLMETHOD Unknown';
  end;
end;

function z3DTraceD3DDECLUSAGEtoString(u: TD3DDeclUsage): PWideChar;
begin
  case u of
    D3DDECLUSAGE_POSITION: Result := 'D3DDECLUSAGE_POSITION';
    D3DDECLUSAGE_BLENDWEIGHT: Result := 'D3DDECLUSAGE_BLENDWEIGHT';
    D3DDECLUSAGE_BLENDINDICES: Result := 'D3DDECLUSAGE_BLENDINDICES';
    D3DDECLUSAGE_NORMAL: Result := 'D3DDECLUSAGE_NORMAL';
    D3DDECLUSAGE_PSIZE: Result := 'D3DDECLUSAGE_PSIZE';
    D3DDECLUSAGE_TEXCOORD: Result := 'D3DDECLUSAGE_TEXCOORD';
    D3DDECLUSAGE_TANGENT: Result := 'D3DDECLUSAGE_TANGENT';
    D3DDECLUSAGE_BINORMAL: Result := 'D3DDECLUSAGE_BINORMAL';
    D3DDECLUSAGE_TESSFACTOR: Result := 'D3DDECLUSAGE_TESSFACTOR';
    D3DDECLUSAGE_POSITIONT: Result := 'D3DDECLUSAGE_POSITIONT';
    D3DDECLUSAGE_COLOR: Result := 'D3DDECLUSAGE_COLOR';
    D3DDECLUSAGE_FOG: Result := 'D3DDECLUSAGE_FOG';
    D3DDECLUSAGE_DEPTH: Result := 'D3DDECLUSAGE_DEPTH';
    D3DDECLUSAGE_SAMPLE: Result := 'D3DDECLUSAGE_SAMPLE';
  else
    Result := 'D3DDECLUSAGE Unknown';
  end;
end;

procedure Tz3DState.AppException(Sender: TObject; E: Exception);
begin
  z3DTrace(PWideChar(WideString('A fatal exception has ocurred. Please check the log files for details. '+
  'If the problem persists, reinstall this program. Error message:'+#13#10+E.Message)), z3DtkError);
end;

initialization
  GLog:= TStringList.Create;
  GRegistry:= TRzRegIniFile.Create(nil);
  GRegistry.PathType:= ptRegistry;
  GRegistry.Path:= 'Software\Zenith Engine\';
  z3DCreateWideChar(GWideBuffer);

finalization
  Gz3DDeviceList:= nil;
  z3DCore_FreeState;
  GLog.Free;
  GRegistry.Free;
  FreeMem(GWideBuffer);

end.
