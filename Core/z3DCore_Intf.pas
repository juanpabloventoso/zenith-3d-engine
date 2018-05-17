///============================================================================///
///= Zenith 3D Engine - Developed by Juan Pablo Ventoso                       =///
///============================================================================///
///= Unit: z3DCore. 3D native controller for the Engine interface             =///
///============================================================================///

unit z3DCore_Intf;

interface

uses
  Windows, DXTypes, Direct3D9, D3DX9, XInput, z3DClasses_Intf;

type

  /// Kind of debug trace
  Tz3DTraceKind = (z3DtkInformation, z3DtkWarning, z3DtkError);

  TSingleArray = array of DWord;
  PSingleArray = ^TSingleArray;

  Tz3DDWordArray = array of DWORD;
  Pz3DDWordArray = ^Tz3DDWordArray;

  QSortCB = function(const arg1, arg2: Pointer): Integer;

  ULongToPtr = Pointer;

{$IFDEF BORLAND}{$IFNDEF COMPILER6_UP}
  PBoolean = ^Boolean;
{$ENDIF}{$ENDIF}

{$IFDEF WIN64}
function PtrToUlong(P: Pointer): LongWord;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
{$ELSE}
  PtrToUlong = LongWord;
{$ENDIF}

{$IFNDEF MONITOR_DEFAULTTOPRIMARY}

const
  MONITORINFOF_PRIMARY        = $00000001;
  MONITOR_DEFAULTTONULL       = $00000000;
  MONITOR_DEFAULTTOPRIMARY    = $00000001;
  MONITOR_DEFAULTTONEAREST    = $00000002;

const
  ENUM_REGISTRY_SETTINGS      = DWORD(-2);

type
  Pz3DMonitorInfo = ^Tz3DMonitorInfo;
  Tz3DMonitorInfo = record
    cbSize:    DWORD;
    rcMonitor: TRect;
    rcWork:    TRect;
    dwFlags:   DWORD;
  end;

  Pz3DMonitorInfoExW = ^Tz3DMonitorInfoExW;
  Tz3DMonitorInfoExW = record
    cbSize:    DWORD;
    rcMonitor: TRect;
    rcWork:    TRect;
    dwFlags:   DWORD;
    szDevice: array[0..CCHDEVICENAME-1] of WideChar;
  end;
{$ENDIF}

type

  PMonitorInfo = ^TMonitorInfo;
  TMonitorInfo = record
    cbSize:    DWORD;
    rcMonitor: TRect;
    rcWork:    TRect;
    dwFlags:   DWORD;
  end;

  TMonitorFromWindow = function(hWnd: HWND; dwFlags: DWORD): HMONITOR; stdcall;
  TGetMonitorInfo = function(hMonitor: HMONITOR; lpMonitorInfo: PMonitorInfo): Boolean; stdcall;

  PD3DMaterialArray = ^TD3DMaterialArray;
  TD3DMaterialArray = array [0..MaxInt div SizeOf(TD3DMaterial9)-1] of TD3DMaterial9;

  PD3DXMaterialArray = ^TD3DXMaterialArray;
  TD3DXMaterialArray = array [0..MaxInt div SizeOf(TD3DXMaterial)-1] of TD3DXMaterial;

  PAIDirect3DBaseTexture9 = ^AIDirect3DBaseTexture9;
  AIDirect3DBaseTexture9 = array[0..MaxInt div SizeOf(IDirect3DBaseTexture9)-1] of IDirect3DBaseTexture9;






  /// z3D timer interface.

  /// Internal timer used for frame events.

  Iz3DTimer = interface(Iz3DBase)['{468AAF94-7AB3-4726-BBCB-D052F10547F7}']
    /// Returns the current absolute time
    function GetAbsoluteTime: Double; stdcall;
    /// Returns the current time
    function GetTime: Double; stdcall;
    /// Returns the current elapsed time 
    function GetElapsedTime: Double; stdcall;
    /// Returns the current time adjusted from 
    function GetAdjustedCurrentTime: TLargeInteger; stdcall;
    /// Returns TRUE if the timer is stopped
    function GetTimerStopped: Boolean; stdcall;
    /// Resets the timer
    procedure Reset; stdcall;
    /// Starts the timer
    procedure Start; stdcall;
    /// Stops the timer
    procedure Stop; stdcall;
    /// Advance a time frame
    procedure Advance; stdcall;
    /// Returns current time values as out parameters
    procedure GetTimeValues(out pfTime, pfAbsoluteTime: Double; out pfElapsedTime: Single); stdcall;

    /// Current absolute time
    property AbsoluteTime: Double read GetAbsoluteTime;
    /// Current time
    property Time: Double read GetTime;
    /// Current elapsed time
    property ElapsedTime: Double read GetElapsedTime;
    /// TRUE if stopped, FALSE otherwise
    property IsStopped: Boolean read GetTimerStopped;
  end;

  Tz3DCacheSourceLocation = (z3DCACHE_LOCATION_FILE, z3DCACHE_LOCATION_RESOURCE);

  /// Texture cache struct
  Pz3DCacheTexture = ^Tz3DCacheTexture;
  Tz3DCacheTexture = record
    Location: Tz3DCacheSourceLocation;
    wszSource: array[0..MAX_PATH-1] of WideChar;
    hSrcModule: HMODULE;
    Width: LongWord;
    Height: LongWord;
    Depth: LongWord;
    MipLevels: LongWord;
    Usage: DWORD;
    Format: TD3DFormat;
    Pool: TD3DPool;
    _Type: D3DRESOURCETYPE;
    pTexture: IDirect3DBaseTexture9;
  end;

  Tz3DCacheTextureArray = array of Tz3DCacheTexture;

  /// Font cache struct
  Tz3DCacheFont = record
    Height: Longint;
    Width: Longint;
    Weight: LongWord;
    MipLevels: LongWord;
    Italic: BOOL;
    CharSet: Byte;
    OutputPrecision: Byte;
    Quality: Byte;
    PitchAndFamily: Byte;
    FaceName: array[0..LF_FACESIZE-1] of WideChar;
    pFont: ID3DXFont;
  end;

  /// Effect cache struct
  Tz3DCacheEffect = record
    Location: Tz3DCacheSourceLocation;
    wszSource: array [0..MAX_PATH-1] of WideChar;
    hSrcModule: HMODULE;
    dwFlags: DWORD;
    pEffect: ID3DXEffect;
  end;





  /// z3D Resource cache interface

  /// Handles multiple loads of single objects and
  /// mantains a reference to the origin

  Iz3DResourceCache = interface(Iz3DBase)['{94438DAC-DE1C-44BC-B931-0DE6CF06596E}']
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
    function OnCreateDevice(pd3dDevice: IDirect3DDevice9): HResult; stdcall;
    function OnResetDevice(pd3dDevice: IDirect3DDevice9): HResult; stdcall;
    function OnLostDevice: HResult; stdcall;
    function OnDestroyDevice: HResult; stdcall;
  end;

const

  VK_XBUTTON1       = $05;
  VK_XBUTTON2       = $06;
  GCLP_HCURSOR      = -12;
  GWLP_HINSTANCE    = -6;

  WM_XBUTTONDOWN   = $020B; /// (not always defined)
  WM_XBUTTONUP     = $020C; /// (not always defined)
  WM_XBUTTONDBLCLK = $020D;
  WM_MOUSEWHEEL    = $020A; /// (not always defined)
  WHEEL_DELTA      = 120;   /// (not always defined)

  MK_XBUTTON1         = $0020;
  MK_XBUTTON2         = $0040;

  Z3D_MAX_CONTROLLERS = 4;  /// XInput handles up to 4 controllers

  /// Core engine error codes

  z3DERR_NODIRECT3D              = HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0901;
  z3DERR_NOCOMPATIBLEDEVICES     = HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0902;
  z3DERR_MEDIANOTFOUND           = HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0903;
  z3DERR_NONZEROREFCOUNT         = HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0904;
  z3DERR_CREATINGDEVICE          = HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0905;
  z3DERR_RESETTINGDEVICE         = HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0906;
  z3DERR_CREATINGDEVICEOBJECTS   = HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0907;
  z3DERR_RESETTINGDEVICEOBJECTS  = HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0908;
  z3DERR_INCORRECTVERSION        = HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0909;






///============================================================================///
///= Device section                                                           =///
///============================================================================///
///= Enumerates, controls and activates the 3D devices available for the      =///
///= engine to work with                                                      =///
///============================================================================///

type

  Tz3DCallback_AcceptDevice = function(const ACaps: TD3DCaps9; const AAdapterFormat, ABackBufferFormat: TD3DFormat;
    const AWindowed: Boolean; const AUserContext: Pointer): Boolean; stdcall;

  Iz3DEnumAdapterInfo = interface;
  Iz3DEnumDeviceInfo = interface;

  /// DepthStencil/Multisample conflict struct

  PD3DEnumDSMSConflict = ^Tz3DEnumDSMSConflict;
  Tz3DEnumDSMSConflict = record
    DSFormat: TD3DFormat;
    MSType: TD3DMultiSampleType;
  end;

  /// Valid device settings combination struct

  PD3DDeviceSettingsCombinations = ^TD3DDeviceSettingsCombinations;
  TD3DDeviceSettingsCombinations = record
    AdapterOrdinal: LongWord;
    DeviceType: TD3DDevType;
    AdapterFormat: TD3DFormat;
    BackBufferFormat: TD3DFormat;
    Windowed: Boolean;
    DepthStencilFormatList: array of TD3DFormat;
    MultiSampleTypeList: array of TD3DMultiSampleType;
    MultiSampleQualityList: array of DWORD;
    PresentIntervalList: array of LongWord;
    DSMSConflictList: array of Tz3DEnumDSMSConflict;
    AdapterInfo: Iz3DEnumAdapterInfo;
    DeviceInfo: Iz3DEnumDeviceInfo;
  end;

  Tz3DEnumAdapterInfoArray = array of Iz3DEnumAdapterInfo;
  TD3DFormatArray = array of TD3DFormat;
  TD3DMultiSampleTypeArray = array of TD3DMultiSampleType;
  TLongWordArray = array of LongWord;






  /// z3D device list interface

  /// Enumerates all available devices and allows to restrict
  /// the results to a specific filter.

  Iz3DDeviceList = interface(Iz3DBase)['{24422F6E-C72F-42B8-94AA-C1BD399863FA}']
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
    function GetDeviceSettingsCombo(AdapterOrdinal: LongWord; DeviceType: TD3DDevType; AdapterFormat, BackBufferFormat: TD3DFormat; Windowed: Boolean): PD3DDeviceSettingsCombinations; overload; stdcall;
    procedure CleanupDirect3DInterfaces; stdcall;
    function Enumerate(pD3D: IDirect3D9 = nil; AcceptDeviceFunc: Tz3DCallback_AcceptDevice = nil;
    pAcceptDeviceFuncUserContext: Pointer = nil): HRESULT; stdcall;

    property PossibleDepthStencilFormats: TD3DFormatArray read GetPossibleDepthStencilFormats write SetPossibleDepthStencilFormats;
    property PossibleMultisampleTypes: TD3DMultiSampleTypeArray read GetPossibleMultisampleTypes write SetPossibleMultisampleTypes;
    property PossiblePresentIntervals: TLongWordArray read GetPossiblePresentIntervals write SetPossiblePresentIntervals;
    property MultisampleQualityMax: LongWord read GetMultisampleQualityMax write SetMultisampleQualityMax;
    property RequirePostPixelShaderBlending: Boolean read GetRequirePostPixelShaderBlending write SetRequirePostPixelShaderBlending;
  end;

  PD3DDisplayModeArray = ^TD3DDisplayModeArray;
  TD3DDisplayModeArray = array of TD3DDisplayMode;

  Pz3DDeviceInfoList = ^Tz3DDeviceInfoList;
  Tz3DDeviceInfoList = array of Iz3DEnumDeviceInfo;

  PDescArray = ^TDescArray;
  TDescArray = array[0..255] of WideChar;






  /// z3D adapter enumeration interface

  /// Saves information about a specific adapter in the enumeration

  Iz3DEnumAdapterInfo = interface(Iz3DBase)['{D8AEF49A-DAD4-49DC-A806-2DEE93DE584D}']
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

    property AdapterOrdinal: LongWord read GetAdapterOrdinal write SetAdapterOrdinal;
    property AdapterIdentifier: PD3DAdapterIdentifier9 read GetAdapterIdentifier write SetAdapterIdentifier;
    property UniqueDescription: PDescArray read GetUniqueDescription write SetUniqueDescription;
    property DisplayModeList: PD3DDisplayModeArray read GetDisplayModeList write SetDisplayModeList;
    property DeviceInfoList: Pz3DDeviceInfoList read GetDeviceInfoList write SetDeviceInfoList;
  end;

  Pz3DDeviceSettingsComboList = ^Tz3DDeviceSettingsComboList;
  Tz3DDeviceSettingsComboList = array of PD3DDeviceSettingsCombinations;




  /// z3D device enumeration interface

  /// Saves information about a specific device in the enumeration

  Iz3DEnumDeviceInfo = interface(Iz3DBase)['{1A6B77CE-2510-4689-955D-907E831231F6}']
    function GetAdapterOrdinal: LongWord; stdcall;
    function GetCaps: TD3DCaps9; stdcall;
    function GetDeviceSettingsComboList: Pz3DDeviceSettingsComboList; stdcall;
    function GetDeviceType: TD3DDevType; stdcall;
    procedure SetAdapterOrdinal(const Value: LongWord); stdcall;
    procedure SetCaps(const Value: TD3DCaps9); stdcall;
    procedure SetDeviceSettingsComboList(const Value: Pz3DDeviceSettingsComboList); stdcall;
    procedure SetDeviceType(const Value: TD3DDevType); stdcall;

    property AdapterOrdinal: LongWord read GetAdapterOrdinal write SetAdapterOrdinal;
    property DeviceType: TD3DDevType read GetDeviceType write SetDeviceType;
    property Caps: TD3DCaps9 read GetCaps write SetCaps;
    property DeviceSettingsComboList: Pz3DDeviceSettingsComboList read GetDeviceSettingsComboList write SetDeviceSettingsComboList;
  end;




  /// Device matching
  Tz3DMatchType = (
    z3DMT_IGNORE_INPUT{$IFDEF SUPPORTS_EXPL_ENUMS} = 0{$ENDIF},  /// Use the closest valid value to a default
    z3DMT_PRESERVE_INPUT,    /// Use input without change, but may cause no valid device to be found
    z3DMT_CLOSEST_TO_INPUT   /// Use the closest valid value to the input
  );

  Pz3DMatchOptions = ^Tz3DMatchOptions;
  Tz3DMatchOptions = record
    eAdapterOrdinal:     Tz3DMatchType;
    eDeviceType:         Tz3DMatchType;
    eWindowed:           Tz3DMatchType;
    eAdapterFormat:      Tz3DMatchType;
    eVertexProcessing:   Tz3DMatchType;
    eResolution:         Tz3DMatchType;
    eBackBufferFormat:   Tz3DMatchType;
    eBackBufferCount:    Tz3DMatchType;
    eMultiSample:        Tz3DMatchType;
    eSwapEffect:         Tz3DMatchType;
    eDepthFormat:        Tz3DMatchType;
    eStencilFormat:      Tz3DMatchType;
    ePresentFlags:       Tz3DMatchType;
    eRefreshRate:        Tz3DMatchType;
    ePresentInterval:    Tz3DMatchType;
  end;






///============================================================================///
///= Common callback functions section                                        =///
///============================================================================///
///= This callback routines are used by the core to trigger the main 3D       =///
///= events such as device creation or frame render                           =///
///============================================================================///

type

  /// Main callback functions
  Tz3DCallback_ModifyDeviceSettings = function(var ASettings: Tz3DDeviceSettings; const ACaps: TD3DCaps9; const AUserContext: Pointer): Boolean; stdcall;
  Tz3DCallback_DeviceCreated = function(const ADevice: IDirect3DDevice9; const ABackBuffer: TD3DSurfaceDesc; const AUserContext: Pointer): HRESULT; stdcall;
  Tz3DCallback_DeviceReset = function(const ADevice: IDirect3DDevice9; const ABackBuffer: TD3DSurfaceDesc; const AUserContext: Pointer): HRESULT; stdcall;
  Tz3DCallback_DeviceDestroyed = procedure(const AUserContext: Pointer); stdcall;
  Tz3DCallback_DeviceLost = procedure(const AUserContext: Pointer); stdcall;
  Tz3DCallback_FrameMove = procedure(const ADevice: IDirect3DDevice9; const ATime: Double; const AElapsedTime: Single; const AUserContext: Pointer); stdcall;
  Tz3DCallback_FrameRender = procedure(const ADevice: IDirect3DDevice9; const ATime: Double; const AElapsedTime: Single; const AUserContext: Pointer); stdcall;
  Tz3DCallback_Keyboard = procedure(const AChar: LongWord; const AKeyDown, AAltDown: Boolean; const AUserContext: Pointer); stdcall;
  Tz3DCallback_Mouse = procedure(const ALeftButtonDown, ARightButtonDown, AMiddleButtonDown, ASideButton1Down, ASideButton2Down: Boolean; const AMouseWheelDelta, AXPos, AYPos: Integer; const AUserContext: Pointer); stdcall;
  Tz3DCallback_MsgProc = function (const AWnd: HWND; const AMsg: LongWord; const AWParam: WPARAM; const ALParam: LPARAM; out AHandled: Boolean; const AUserContext: Pointer): LRESULT; stdcall;
  Tz3DCallback_Timer = procedure(const AEvent: LongWord; const AUserContext: Pointer);

  Tz3DTimerRecord = record
    pCallbackTimer: Tz3DCallback_Timer;
    pCallbackUserContext: Pointer;
    fTimeoutInSecs: Single;
    fCountdown: Single;
    bEnabled: Boolean;
  end;

  Tz3DTimerRecordArray = array of Tz3DTimerRecord;

  Tz3DKeysArray = array[0..255] of Boolean;
  Tz3DMouseButtonsArray = array[0..4] of Boolean;
  Pz3DKeysArray = ^Tz3DKeysArray;
  Pz3DMouseButtonsArray = ^Tz3DMouseButtonsArray;





  /// z3D core state interface

  /// Allows access to the general state of the core engine to the user

  Iz3DState = interface(Iz3DBase)['{7B4EB639-3FF3-412E-862F-8B93D5F3FF02}']
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
    function GetCurrentApp: PWideChar;{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
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
    procedure SetCurrentApp(const Value: PWideChar);{$IFDEF STATE_ACCESS_INLINE} inline;{$ENDIF} stdcall;
    procedure CreateState; stdcall;
    procedure DestroyState; stdcall;
    
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
    property CurrentApp: PWideChar read GetCurrentApp write SetCurrentApp;
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

implementation

end.
