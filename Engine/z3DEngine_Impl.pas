{==============================================================================}
{== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==}
{==============================================================================}
{== Unit: z3DEngine. z3D Engine interfaces and access functions              ==}
{==============================================================================}

unit z3DEngine_Impl;

interface

uses
  Windows, Controls, Direct3D9, D3DX9, z3DClasses_Impl,
  z3DMath_intf, z3DCore_Intf, z3DEngine_Intf, z3DGUI_Intf, z3DComponents_Intf,
  Classes, z3DAudio_Intf, MPlayer, z3DScenario_Intf, z3DClasses_Intf;

type

  Tz3DWinControl = class(TWinControl)
    procedure z3DSetHandle(const AHandle: HWnd);
  end;

{==============================================================================}
{== Debug helper interface                                                   ==}
{==============================================================================}
{== Helper class for the developer. It allow to view the position of every   ==}
{== light source, create a grid for position metrics and so on               ==}
{==============================================================================}

  Tz3DDebugHelper = class(Tz3DLinked, Iz3DDebugHelper)
  private
    FEnableGrid: Boolean;
    FGridSize: Integer;
    FGridSpace: Single;
    FGridMesh: ID3DXMesh;
    FLightMesh: ID3DXMesh;
    FEnableLightMesh: Boolean;
  protected
    function GetEnableGrid: Boolean; stdcall;
    function GetEnableLightMesh: Boolean; stdcall;
    function GetGridSize: Integer; stdcall;
    function GetGridSpace: Single; stdcall;
    procedure SetEnableGrid(const Value: Boolean); stdcall;
    procedure SetEnableLightMesh(const Value: Boolean); stdcall;
    procedure SetGridSize(const Value: Integer); stdcall;
    procedure SetGridSpace(const Value: Single); stdcall;
    procedure z3DResetDevice; override; stdcall;
    procedure FrameRender; stdcall;
    procedure RenderGridMesh; stdcall;
    procedure CreateGridMesh; stdcall;
    procedure CreateLightMesh; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property EnableGrid: Boolean read GetEnableGrid write SetEnableGrid;
    property GridSize: Integer read GetGridSize write SetGridSize;
    property GridSpace: Single read GetGridSpace write SetGridSpace;
    property EnableLightMesh: Boolean read GetEnableLightMesh write SetEnableLightMesh;
  end;

{==============================================================================}
{== Device interface                                                         ==}
{==============================================================================}
{== Handles the additional properties and events of the device that are      ==}
{== related to the engine                                                    ==}
{==============================================================================}

  Tz3DDeviceEngineCaps = class(Tz3DLinked, Iz3DDeviceEngineCaps)
  private
    FDirectXLevel: Tz3DDirectXLevel;
    FShaderModel: Tz3DShaderModel;
    FShaderModelMinor: Integer;
    FHDRSupport: Boolean;
    FFPFormat: TD3DFormat;
    FShadowMapSupport: Boolean;
    FShadowMapFormat: TD3DFormat;
    FCubeShadowMapFormat: TD3DFormat;
    FShadowMapHWSupport: Boolean;
    FDevice: Iz3DDevice;
  protected
    function GetFPFormat: TD3DFormat; stdcall;
    function GetDirectXLevel: Tz3DDirectXLevel; stdcall;
    function GetCubeShadowMapFormat: TD3DFormat; stdcall;
    function GetShadowMapFormat: TD3DFormat; stdcall;
    function GetShadowMapSupport: Boolean; stdcall;
    function GetHDRSupport: Boolean; stdcall;
    function GetShaderModel: Tz3DShaderModel; stdcall;
    function GetShaderModelMinor: Integer; stdcall;
    function GetShadowMapHWSupport: Boolean; stdcall;
    procedure z3DModifyDevice(var ADeviceSettings: Tz3DDeviceSettings;
      const ACaps: _D3DCAPS9); override; stdcall;
  public
    constructor Create(const ADevice: Iz3DDevice); reintroduce;
    function ShaderModel3Supported: Boolean; stdcall;
  public
    property DirectXLevel: Tz3DDirectXLevel read GetDirectXLevel;
    property ShaderModel: Tz3DShaderModel read GetShaderModel;
    property ShaderModelMinor: Integer read GetShaderModelMinor;
    property HDRSupport: Boolean read GetHDRSupport;
    property FPFormat: TD3DFormat read GetFPFormat;
    property ShadowMapSupport: Boolean read GetShadowMapSupport;
    property ShadowMapFormat: TD3DFormat read GetShadowMapFormat;
    property CubeShadowMapFormat: TD3DFormat read GetCubeShadowMapFormat;
    property ShadowMapHWSupport: Boolean read GetShadowMapHWSupport;
  end;

  Tz3DDevice = class(Tz3DBase, Iz3DDevice)
  private
    FFullScreen: Boolean;
    FDisplayREFWarning: Boolean;
    FEngineCaps: Iz3DDeviceEngineCaps;
  protected
    function GetEngineCaps: Iz3DDeviceEngineCaps; stdcall;
    function GetDisplayREFWarning: Boolean; stdcall;
    function GetFullScreen: Boolean; stdcall;
    procedure SetDisplayREFWarning(const Value: Boolean); stdcall;
    procedure SetFullScreen(const Value: Boolean); stdcall;
  public
    procedure CreateDevice; stdcall;
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;
    procedure ToggleFullScreen; stdcall;
    procedure ToggleREF; stdcall;
    function Created: Boolean; stdcall;
  public
    property EngineCaps: Iz3DDeviceEngineCaps read GetEngineCaps;
    property FullScreen: Boolean read GetFullScreen write SetFullScreen default False;
    property DisplayREFWarning: Boolean read GetDisplayREFWarning write SetDisplayREFWarning default True;
  end;

{==============================================================================}
{== Stats interface                                                          ==}
{==============================================================================}
{== This interface allows to display the rendering stats on the screen       ==}
{==============================================================================}

  Tz3DStats = class(Tz3DLinked, Iz3DStats)
  private
    FHelper: Iz3DTextHelper;
    FD3DXFont: ID3DXFont;
    FD3DXSprite: ID3DXSprite;
    FShowDevice: Boolean;
    FShowDisplay: Boolean;
    FShowFPS: Boolean;
    FShowView: Boolean;
    FShowRenderer: Boolean;
  protected
    function GetShowRenderer: Boolean; stdcall;
    procedure SetShowRenderer(const Value: Boolean); stdcall;
    function GetShowView: Boolean; stdcall;
    procedure SetShowView(const Value: Boolean); stdcall;
    function GetShowDevice: Boolean; stdcall;
    function GetShowFPS: Boolean; stdcall;
    function GetShowDisplay: Boolean; stdcall;
    procedure SetShowDevice(const Value: Boolean); stdcall;
    procedure SetShowFPS(const Value: Boolean); stdcall;
    procedure SetShowDisplay(const Value: Boolean); stdcall;
    procedure FrameRender; stdcall;
    procedure z3DCreateDevice;  override;
    procedure z3DDestroyDevice; override;
    procedure z3DLostDevice; override;
    procedure z3DResetDevice; override;

    function Float2ToText(const AFloat: Iz3DFloat2): string; stdcall;
    function Float3ToText(const AFloat: Iz3DFloat3): string; stdcall;
    function Float4ToText(const AFloat: Iz3DFloat4): string; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;
  public
    property ShowFPS: Boolean read GetShowFPS write SetShowFPS;
    property ShowDisplay: Boolean read GetShowDisplay write SetShowDisplay;
    property ShowDevice: Boolean read GetShowDevice write SetShowDevice;
    property ShowView: Boolean read GetShowView write SetShowView;
    property ShowRenderer: Boolean read GetShowRenderer write SetShowRenderer;
  end;

{==============================================================================}
{== Options interface                                                        ==}
{==============================================================================}
{== Allows the developer to configure certain aspects and behaviors of the   ==}
{== engine                                                                   ==}
{==============================================================================}

  Tz3DEngineOptions = class(Tz3DBase, Iz3DEngineOptions)
  private
    FExtendedEvents: Boolean;
    FShadowStencil: Boolean;
    FHandleDefaultHotkeys: Boolean;
    FShowFatalMessages: Boolean;
    FHandleWindowMessages: Boolean;
    FParseCommandLine: Boolean;
    FHandleAltEnter: Boolean;
    FShowCursorOnFullScreen: Boolean;
    FClipCursorOnFullScreen: Boolean;
    FLockAspectRatio: Boolean;
    FStretchToWindow: Boolean;
    FPlayIntro: Boolean;
    FPlayMusic: Boolean;
  protected
    function GetPlayIntro: Boolean; stdcall;
    function GetPlayMusic: Boolean; stdcall;
    procedure SetPlayIntro(const Value: Boolean); stdcall;
    procedure SetPlayMusic(const Value: Boolean); stdcall;
    function GetStretchToWindow: Boolean; stdcall;
    procedure SetStretchToWindow(const Value: Boolean); stdcall;
    function GetShowFatalMessages: Boolean; stdcall;
    procedure SetShowFatalMessages(const Value: Boolean); stdcall;
    function GetClipCursorOnFullScreen: Boolean; stdcall;
    function GetExtendedEvents: Boolean; stdcall;
    function GetHandleAltEnter: Boolean; stdcall;
    function GetHandleDefaultHotkeys: Boolean; stdcall;
    function GetHandleWindowMessages: Boolean; stdcall;
    function GetLockAspectRatio: Boolean; stdcall;
    function GetParseCommandLine: Boolean; stdcall;
    function GetShadowStencil: Boolean; stdcall;
    function GetShowCursorOnFullScreen: Boolean; stdcall;
    procedure SetExtendedEvents(const Value: Boolean); stdcall;
    procedure SetHandleAltEnter(const Value: Boolean); stdcall;
    procedure SetHandleDefaultHotkeys(const Value: Boolean); stdcall;
    procedure SetHandleWindowMessages(const Value: Boolean); stdcall;
    procedure SetLockAspectRatio(const Value: Boolean); stdcall;
    procedure SetParseCommandLine(const Value: Boolean); stdcall;
    procedure SetShadowStencil(const Value: Boolean); stdcall;
    procedure SetClipCursorOnFullScreen(const Value: Boolean); stdcall;
    procedure SetShowCursorOnFullScreen(const Value: Boolean); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property ExtendedEvents: Boolean read GetExtendedEvents write SetExtendedEvents;
    property ShadowStencil: Boolean read GetShadowStencil write SetShadowStencil;
    property ParseCommandLine: Boolean read GetParseCommandLine write SetParseCommandLine;
    property HandleDefaultHotkeys: Boolean read GetHandleDefaultHotkeys write SetHandleDefaultHotkeys;
    property ShowFatalMessages: Boolean read GetShowFatalMessages write SetShowFatalMessages;
    property HandleAltEnter: Boolean read GetHandleAltEnter write SetHandleAltEnter;
    property HandleWindowMessages: Boolean read GetHandleWindowMessages write SetHandleWindowMessages;
    property ShowCursorOnFullScreen: Boolean read GetShowCursorOnFullScreen write SetShowCursorOnFullScreen;
    property PlayIntro: Boolean read GetPlayIntro write SetPlayIntro;
    property PlayMusic: Boolean read GetPlayMusic write SetPlayMusic;
    property ClipCursorOnFullScreen: Boolean read GetClipCursorOnFullScreen write SetClipCursorOnFullScreen;
    property LockAspectRatio: Boolean read GetLockAspectRatio write SetLockAspectRatio;
    property StretchToWindow: Boolean read GetStretchToWindow write SetStretchToWindow;
  end;

{==============================================================================}
{== Effects interface                                                        ==}
{==============================================================================}
{== These are handlers for the post process effects included in the engine:  ==}
{==                                                                          ==}
{==   - Bloom: Enhances strong-lighted areas                                 ==}
{==   - Tone mapping: Simulates the eye adjustment                           ==}
{==   - Color correction: Applies color effects to the scene                 ==}
{==   - Motion blur: Blurs the screen when the eye moves at fast speeds      ==}
{==   - Depth of field: Centers the view into a certain distance             ==}
{==                                                                          ==}
{==============================================================================}

  Tz3DBloomEffect = class(Tz3DBase, Iz3DBloomEffect)
  private
    FEffects: Iz3DPostProcessEffects;
    FBloomPass1SampleOffsets: array[0..15] of TD3DXVector2;
    FBloomPass2SampleOffsets: array[0..15] of TD3DXVector2;
    FBloomSampleWeights: array[0..15] of Single;
    FBrightPassValidTechnique: Tz3DHandle;
    FBrightPassTex: Iz3DRenderTexture;
    FBloomTex: array[0..2] of Iz3DRenderTexture;
    FShader: Iz3DShader;
    FEnabled: Boolean;
    FIntensity: Single;
    FThreshold: Single;
    FFoggyFactor: Single;
  protected
    function GetFoggyFactor: Single; stdcall;
    procedure SetFoggyFactor(const Value: Single); stdcall;
    function GetEnabled: Boolean; stdcall;
    function GetIntensity: Single; stdcall;
    function GetThreshold: Single; stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    procedure SetIntensity(const Value: Single); stdcall;
    procedure SetThreshold(const Value: Single); stdcall;
    procedure FrameRender; stdcall;
    procedure RenderBloom; stdcall;
    procedure RenderBrightPass; stdcall;
    procedure CreateScenarioObjects; stdcall;
    procedure EnableResources; stdcall;
  public
    constructor Create(const AOwner: Iz3DPostProcessEffects);
  public
    property Enabled: Boolean read GetEnabled write SetEnabled default True;
    property Intensity: Single read GetIntensity write SetIntensity;
    property Threshold: Single read GetThreshold write SetThreshold;
    property FoggyFactor: Single read GetFoggyFactor write SetFoggyFactor;
  end;

  Tz3DToneMappingEffect = class(Tz3DBase, Iz3DToneMappingEffect)
  private
    FShader: Iz3DShader;
    FEnabled: Boolean;
    FRenderAdaptation: Iz3DRenderTexture;
    FLastAdaptation: Iz3DRenderTexture;
    FAdjustmentSpeed: Single;
    FAdjustmentFactor: Single;
    FMiddleTone: Single;
    FToneRangeMin: Single;
    FToneRangeMax: Single;
  protected
    function GetAdjustmentFactor: Single; stdcall;
    function GetAdjustmentSpeed: Single; stdcall;
    function GetMiddleTone: Single; stdcall;
    function GetToneRangeMax: Single; stdcall;
    function GetToneRangeMin: Single; stdcall;
    procedure SetAdjustmentFactor(const Value: Single); stdcall;
    procedure SetAdjustmentSpeed(const Value: Single); stdcall;
    procedure SetMiddleTone(const Value: Single); stdcall;
    procedure SetToneRangeMax(const Value: Single); stdcall;
    procedure SetToneRangeMin(const Value: Single); stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure FrameMove; stdcall;
    procedure FrameRender; stdcall;
    procedure CreateScenarioObjects; stdcall;
    procedure EnableResources; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property AdjustmentSpeed: Single read GetAdjustmentSpeed write SetAdjustmentSpeed;
    property AdjustmentFactor: Single read GetAdjustmentFactor write SetAdjustmentFactor;
    property MiddleTone: Single read GetMiddleTone write SetMiddleTone;
    property ToneRangeMin: Single read GetToneRangeMin write SetToneRangeMin;
    property ToneRangeMax: Single read GetToneRangeMax write SetToneRangeMax;
  end;

  Tz3DColorCorrectionEffect = class(Tz3DBase, Iz3DColorCorrectionEffect)
  private
    FShader: Iz3DShader;
    FEnabled: Boolean;
    FMode: Tz3DColorCorrectionMode;
    FToneFactor: Iz3DFloat3;
  protected
    procedure SetEnabled(const Value: Boolean); stdcall;
    function GetEnabled: Boolean; stdcall;
    function GetMode: Tz3DColorCorrectionMode; stdcall;
    function GetToneFactor: Iz3DFloat3; stdcall;
    procedure SetMode(const Value: Tz3DColorCorrectionMode); stdcall;
    procedure FrameRender; stdcall;
    procedure PropertyChanged(const ASender: Iz3DBase); stdcall;
    procedure CreateScenarioObjects; stdcall;
    procedure EnableResources; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property Enabled: Boolean read GetEnabled write SetEnabled default False;
    property ToneFactor: Iz3DFloat3 read GetToneFactor;
    property Mode: Tz3DColorCorrectionMode read GetMode write SetMode default z3dccmTonalize;
  end;

  Tz3DMotionBlurEffect = class(Tz3DBase, Iz3DMotionBlurEffect)
  private
    FShader: Iz3DShader;
    FLastRender: Iz3DRenderTexture;
    FRenderSum: Iz3DRenderTexture;
    FEnabled: Boolean;
    FAmount: Single;
  protected
    procedure SetAmount(const Value: Single); stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    function GetAmount: Single; stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure FrameMove; stdcall;
    procedure FrameRender; stdcall;
    procedure CreateScenarioObjects; stdcall;
    procedure EnableResources; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property Enabled: Boolean read GetEnabled write SetEnabled default False;
    property Amount: Single read GetAmount write SetAmount;
  end;

  Tz3DDepthOfFieldEffect = class(Tz3DBase, Iz3DDepthOfFieldEffect)
  private
    FEffects: Iz3DPostProcessEffects;
    FDepthTex: Iz3DRenderTexture;
    FBlurValuesTex: Iz3DRenderTexture;
    FLastDepthTex: Iz3DRenderTexture;
    FFinalBlurTex: Iz3DRenderTexture;
    FShader: Iz3DShader;
    FEnabled: Boolean;
    FFocusDepth: Single;
    FQuality: Tz3DDepthOfFieldQuality;
    FAutoFocusDepth: Boolean;
    FAmount: Single;
    FAdjustmentSpeed: Single;
    FFocusSpread: Single;
  protected
    function GetQuality: Tz3DDepthOfFieldQuality; stdcall;
    procedure SetQuality(const Value: Tz3DDepthOfFieldQuality); stdcall;
    function GetAdjustmentSpeed: Single; stdcall;
    procedure SetAdjustmentSpeed(const Value: Single); stdcall;
    function GetFocusSpread: Single; stdcall;
    procedure SetFocusSpread(const Value: Single); stdcall;
    function GetAmount: Single; stdcall;
    procedure SetAmount(const Value: Single); stdcall;
    function GetAutoFocusDepth: Boolean; stdcall;
    procedure SetAutoFocusDepth(const Value: Boolean); stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    function GetEnabled: Boolean; stdcall;
    function GetFocusDepth: Single; stdcall;
    procedure SetFocusDepth(const Value: Single); stdcall;
    procedure FrameMove; stdcall;
    procedure FrameRender; stdcall;
    procedure CreateScenarioObjects; stdcall;
    procedure EnableResources; stdcall;
  public
    constructor Create(const AOwner: Iz3DPostProcessEffects);
  public
    property Enabled: Boolean read GetEnabled write SetEnabled default False;
    property Amount: Single read GetAmount write SetAmount;
    property AdjustmentSpeed: Single read GetAdjustmentSpeed write SetAdjustmentSpeed;
    property FocusSpread: Single read GetFocusSpread write SetFocusSpread;
    property FocusDepth: Single read GetFocusDepth write SetFocusDepth;
    property AutoFocusDepth: Boolean read GetAutoFocusDepth write SetAutoFocusDepth;
    property Quality: Tz3DDepthOfFieldQuality read GetQuality write SetQuality;
  end;

{==============================================================================}
{== Effects handler interface                                                ==}
{==============================================================================}
{== Holds every post process effect and manages its shared properties and    ==}
{== Objects                                                                  ==}
{==============================================================================}

  Tz3DPostProcessEffects = class(Tz3DLinked, Iz3DPostProcessEffects)
  private
    FBloom: Iz3DBloomEffect;
    FColorCorrection: Iz3DColorCorrectionEffect;
    FDepthOfField: Iz3DDepthOfFieldEffect;
    FMotionBlur: Iz3DMotionBlurEffect;
    FToneMapping: Iz3DToneMappingEffect;
    FSceneScaledTex: Iz3DRenderTexture;
  protected
    function GetSceneScaledTexture: Iz3DRenderTexture; stdcall;
    function GetBloom: Iz3DBloomEffect; stdcall;
    function GetColorCorrection: Iz3DColorCorrectionEffect; stdcall;
    function GetDepthOfField: Iz3DDepthOfFieldEffect; stdcall;
    function GetMotionBlur: Iz3DMotionBlurEffect; stdcall;
    function GetToneMapping: Iz3DToneMappingEffect; stdcall;
    procedure FrameMove; stdcall;
    procedure FrameRender; stdcall;
    procedure CheckSharedResources; stdcall;
    procedure z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller); override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;
  public
    property SceneScaledTexture: Iz3DRenderTexture read GetSceneScaledTexture;
    property Bloom: Iz3DBloomEffect read GetBloom;
    property ToneMapping: Iz3DToneMappingEffect read GetToneMapping;
    property ColorCorrection: Iz3DColorCorrectionEffect read GetColorCorrection;
    property MotionBlur: Iz3DMotionBlurEffect read GetMotionBlur;
    property DepthOfField: Iz3DDepthOfFieldEffect read GetDepthOfField;
  end;

{==============================================================================}
{== Renderer interface                                                       ==}
{==============================================================================}
{== Manages the rendering of the scene and controls the different types of   ==}
{== renderization                                                            ==}
{==============================================================================}

  Tz3DRenderer = class(Tz3DLinked, Iz3DRenderer)
  private
    FSamplerStates: Tz3DSamplerStates;
    FRenderChainIndex: Integer;
    FFadeValue: Single;
    FFadeInMode: Boolean;
    FFadeFactor: Single;
    FSavedZWrite: Cardinal;
    FBackBuffer: Iz3DSurface;
    FHDRMode: Boolean;
    FRendering: Boolean;
    FTargetMode: Tz3DTargetMode;
    FRenderMode: Tz3DRenderMode;
    FRenderTextures: array[0..1] of Iz3DRenderTexture;
    FRenderTarget: Iz3DSurface;
    FLastDepthBuffer: Iz3DDepthBuffer;
    FDepthBuffer: Iz3DDepthBuffer;
    FDeferredBuffer: Iz3DRenderTexture;
    FBlendTextures: IInterfaceList;
    FFirstSceneRender: Boolean;
    FPostProcessBuffer: Iz3DVertexBuffer;
    FRenderStage: Tz3DRenderStage;
    FEnableMSAA: Boolean;
    FMSAASamples: Integer;
    FDefaultClearColor: Iz3DFloat4;
    FDefaultClearDepth: Single;
    FAutoClearTarget: Boolean;
    FAutoClearDepth: Boolean;
    FLastRTWidth, FLastRTHeight: Integer;
    FRTWidth, FRTHeight: Integer;
    FDownScaleSO: array[0..15] of TD3DXVector2;
    FSettingsChanging: Boolean;
    FPostProcessPrepared: Boolean;
    FTextureFilter: Tz3DSamplerFilter;
    FAnisotropyLevel: Integer;
  protected
    function GetAnisotropyLevel: Integer; stdcall;
    procedure SetAnisotropyLevel(const Value: Integer); stdcall;
    function GetTextureFilter: Tz3DSamplerFilter; stdcall;
    procedure SetTextureFilter(const Value: Tz3DSamplerFilter); stdcall;
    function GetDepthBuffer: Iz3DDepthBuffer; stdcall;
    function GetRTHeight: Integer; stdcall;
    function GetRTWidth: Integer; stdcall;
    procedure SetRTHeight(const Value: Integer); stdcall;
    procedure SetRTWidth(const Value: Integer); stdcall;
    function GetAutoClearDepth: Boolean; stdcall;
    function GetAutoClearTarget: Boolean; stdcall;
    procedure SetAutoClearDepth(const Value: Boolean); stdcall;
    procedure SetAutoClearTarget(const Value: Boolean); stdcall;
    function GetDefaultClearColor: Iz3DFloat4; stdcall;
    function GetDefaultClearDepth: Single; stdcall;
    procedure SetDefaultClearDepth(const Value: Single); stdcall;
    function GetEnableMSAA: Boolean; stdcall;
    procedure SetEnableMSAA(const Value: Boolean); stdcall;
    function GetMSAASamples: Integer; stdcall;
    procedure SetMSAASamples(const Value: Integer); stdcall;
    function GetRenderStage: Tz3DRenderStage; stdcall;
    function GetFormat: TD3DFormat; stdcall;
    function GetRenderChainIndex: Integer; stdcall;
    procedure SetRenderChainIndex(const Value: Integer); stdcall;
    function GetLastRenderTexture: Iz3DRenderTexture; stdcall;
    function GetFirstSceneRender: Boolean; stdcall;
    function GetDeferredBuffer: Iz3DRenderTexture; stdcall;
    function GetRenderSurface: Iz3DSurface; stdcall;
    function GetRenderTexture: Iz3DRenderTexture; stdcall;
    function GetBackBuffer: Iz3DSurface; stdcall;
    function GetRendering: Boolean; stdcall;
    function GetRenderMode: Tz3DRenderMode; stdcall;
    procedure SetRenderMode(const Value: Tz3DRenderMode); stdcall;
    function GetHDRMode: Boolean; stdcall;
    function GetTargetMode: Tz3DTargetMode; stdcall;
    procedure SetHDRMode(const Value: Boolean); stdcall;
    procedure SetTargetMode(const Value: Tz3DTargetMode); stdcall;
    procedure CreateRenderTarget; stdcall;
    procedure CreateDeferredBuffer; stdcall;
    procedure UpdateRenderMode; stdcall;
    procedure z3DResetDevice; override; stdcall;
    procedure z3DStartScenario(const AStage: Tz3DStartScenarioStage); override; stdcall;
    procedure z3DFrameMove; override; stdcall;
    procedure ResetSamplerStates;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    procedure ClearDepthBuffer(const AValue: Single = 1); stdcall;
    procedure ClearRenderTarget(const AValue: Iz3DFloat4 = nil); stdcall;
    procedure Clear(const ARenderTarget: Iz3DFloat4 = nil; const ADepthBuffer: Single = 1); stdcall;
    procedure AddBlendTexture(const ATexture: Iz3DTexture); stdcall;
    procedure RenderScene; stdcall;
    procedure BeginScene(const ABackBuffer: Boolean = True); stdcall;
    procedure BeginScenario; stdcall;
    procedure RenderPrecomputation; stdcall;
    procedure RenderDeferredBuffers; stdcall;
    procedure RenderScenario; stdcall;
    procedure RenderPostProcess; stdcall;
    procedure RenderFog; stdcall;
    procedure RenderGUI; stdcall;
    procedure EndScenario; stdcall;
    procedure EndScene; stdcall;
    procedure SwapRenderChain; stdcall;
    procedure FadeIn(const AFactor: Single); stdcall;
    procedure FadeOut(const AFactor: Single); stdcall;

    procedure BeginSettingsChange; stdcall;
    procedure EndSettingsChange; stdcall;

    procedure EnableAdditiveBlending; stdcall;
    procedure EnableAlphaBlending; stdcall;
    procedure DisableBlending; stdcall;
    procedure BeginZWrite; stdcall;
    procedure EndZWrite; stdcall;

    procedure BeginMSAAMode(const ARewriteZ: Boolean = True); stdcall;
    procedure EndMSAAMode(const AReuseZ: Boolean = True); stdcall;

    procedure PostProcess(const ATarget: Iz3DRenderTexture; const ATextures: array of Iz3Dtexture;
      const AShader: Iz3DShader); stdcall;
    procedure PostProcess_Blend(const ATextures: array of Iz3Dtexture;
      const AShader: Iz3DShader); stdcall;
    procedure Blend(const ATextures: array of Iz3Dtexture; const AShader: Iz3DShader = nil;
      const AAlpha: Single = 1); stdcall;
    procedure AutoBlend(const ATexture: Iz3DTexture; const ALeft: Integer = 0; const ATop: Integer = 0;
      const AShader: Iz3DShader = nil; const AAlpha: Single = 1); stdcall;
    procedure DrawFullScreenQuad(const ACoords: Iz3DFloat4 = nil); stdcall;
    procedure GetDownScaleSO(const AWidth, AHeight: Integer); stdcall;
    procedure DownScale(const AOutTexture: Iz3DRenderTexture); stdcall;

    procedure SetSamplerAddressMode(const ASampler: Integer; const AAddressingMode: Tz3DSamplerAddressMode;
      const ABorderColor: Iz3DFloat3 = nil); stdcall;
    procedure SetSamplerFilter(const ASampler: Integer; const AFilter: Tz3DSamplerFilter;
      const AMaxAnisotropy: Integer = -1); stdcall;
  public
    property DepthBuffer: Iz3DDepthBuffer read GetDepthBuffer;
    property Format: TD3DFormat read GetFormat;
    property BackBuffer: Iz3DSurface read GetBackBuffer;
    property RenderTexture: Iz3DRenderTexture read GetRenderTexture;
    property LastRenderTexture: Iz3DRenderTexture read GetLastRenderTexture;
    property RenderSurface: Iz3DSurface read GetRenderSurface;
    property DeferredBuffer: Iz3DRenderTexture read GetDeferredBuffer;
    property TargetMode: Tz3DTargetMode read GetTargetMode write SetTargetMode;
    property RenderMode: Tz3DRenderMode read GetRenderMode write SetRenderMode;
    property Rendering: Boolean read GetRendering;
    property RTWidth: Integer read GetRTWidth write SetRTWidth;
    property RTHeight: Integer read GetRTHeight write SetRTHeight;
    property RenderStage: Tz3DRenderStage read GetRenderStage;
    property HDRMode: Boolean read GetHDRMode write SetHDRMode;
    property FirstSceneRender: Boolean read GetFirstSceneRender;
    property TextureFilter: Tz3DSamplerFilter read GetTextureFilter write SetTextureFilter;
    property AnisotropyLevel: Integer read GetAnisotropyLevel write SetAnisotropyLevel;
    property DefaultClearColor: Iz3DFloat4 read GetDefaultClearColor;
    property DefaultClearDepth: Single read GetDefaultClearDepth write SetDefaultClearDepth;
    property AutoClearTarget: Boolean read GetAutoClearTarget write SetAutoClearTarget;
    property AutoClearDepth: Boolean read GetAutoClearDepth write SetAutoClearDepth;
    property RenderChainIndex: Integer read GetRenderChainIndex write SetRenderChainIndex;
    property EnableMSAA: Boolean read GetEnableMSAA write SetEnableMSAA;
    property MSAASamples: Integer read GetMSAASamples write SetMSAASamples;
  end;

{==============================================================================}
{== Engine interface                                                         ==}
{==============================================================================}
{== The main interface of the engine. It creates and/or handles all the      ==}
{== components of the z3D engine                                             ==}
{==============================================================================}

  Tz3DEngine = class(Tz3DBase, Iz3DEngine)
  private
    FRenderer: Iz3DRenderer;
    FAudioController: Iz3DAudioController;
    FVideoManager: TMediaPlayer;

    FFrameMoveLinks: IInterfaceList;
    FGPUPrecomputationLinks: IInterfaceList;
    FFrameRenderLinks: IInterfaceList;
    FLightingRenderLinks: IInterfaceList;
    FDirectLightRenderLinks: IInterfaceList;
    FGUIRenderLinks: IInterfaceList;
    FMessageLinks: IInterfaceList;
    FkeyboardLinks: IInterfaceList;
    FCreationLinksStageI: IInterfaceList;
    FCreationLinksStageII: IInterfaceList;
    FCreationLinksStageIII: IInterfaceList;

    FShader: Iz3DShader;
    FDevice: Iz3DDevice;
    FScenario: Iz3DScenario;
    FDesktop: Iz3DDesktop;
    FOnFrameRender: Tz3DBaseCallbackEvent;
    FOnKeyboardProc: Tz3DCallbackKeyboardEvent;
    FOnMsgProc: Tz3DCallbackMessageEvent;
    FDebugHelper: Tz3DDebugHelper;
    FOnFrameMove: Tz3DBaseCallbackEvent;
    FOnCreateDevice: Tz3DBaseCallbackEvent;
    FOnResetDevice: Tz3DBaseCallbackEvent;
    FOnDestroyDevice: Tz3DBaseCallbackEvent;
    FOnLostDevice: Tz3DBaseCallbackEvent;
    FOnConfirmDevice: Tz3DCallbackConfirmDeviceEvent;
    FOnModifyDevice: Tz3DCallbackModifyDeviceEvent;
    FActive: Boolean;
    FStats: Iz3DStats;
    FOnFinalization: Tz3DBaseCallbackEvent;
    FOnInitialization: Tz3DBaseCallbackEvent;
    FOptions: Iz3DEngineOptions;
    FInitialized: Boolean;
    FPostProcessEffects: Iz3DPostProcessEffects;
    FSettingsDialog: Iz3DEngineSettingsDialog;
    FWindow: HWND;
  protected
    function GetWindow: HWND; stdcall;
    procedure SetWindow(const Value: HWND); stdcall;
    function GetRenderer: Iz3DRenderer; stdcall;
    function GetAudioController: Iz3DAudioController; stdcall;
    function GetDesktop: Iz3DDesktop; stdcall;
    procedure SetActive(const Value: Boolean); stdcall;
    function GetActive: Boolean; stdcall;
    function GetDebugHelper: Iz3DDebugHelper; stdcall;
    function GetDevice: Iz3DDevice; stdcall;
    function GetShader: Iz3DShader; stdcall;
    function GetOnConfirmDevice: Tz3DCallbackConfirmDeviceEvent; stdcall;
    function GetOnCreateDevice: Tz3DBaseCallbackEvent; stdcall;
    function GetOnDestroyDevice: Tz3DBaseCallbackEvent; stdcall;
    function GetOnFinalization: Tz3DBaseCallbackEvent; stdcall;
    function GetOnFrameMove: Tz3DBaseCallbackEvent; stdcall;
    function GetOnFrameRender: Tz3DBaseCallbackEvent; stdcall;
    function GetOnInitialization: Tz3DBaseCallbackEvent; stdcall;
    function GetOnKeyboardProc: Tz3DCallbackKeyboardEvent; stdcall;
    function GetOnLostDevice: Tz3DBaseCallbackEvent; stdcall;
    function GetOnModifyDevice: Tz3DCallbackModifyDeviceEvent; stdcall;
    function GetOnMsgProc: Tz3DCallbackMessageEvent; stdcall;
    function GetOnResetDevice: Tz3DBaseCallbackEvent; stdcall;
    function GetOptions: Iz3DEngineOptions; stdcall;
    function GetPostProcessEffects: Iz3DPostProcessEffects; stdcall;
    function GetScenario: Iz3DScenario; stdcall;
    function GetStats: Iz3DStats; stdcall;
    procedure SetOnConfirmDevice(const Value: Tz3DCallbackConfirmDeviceEvent); stdcall;
    procedure SetOnCreateDevice(const Value: Tz3DBaseCallbackEvent); stdcall;
    procedure SetOnDestroyDevice(const Value: Tz3DBaseCallbackEvent); stdcall;
    procedure SetOnFinalization(const Value: Tz3DBaseCallbackEvent); stdcall;
    procedure SetOnFrameMove(const Value: Tz3DBaseCallbackEvent); stdcall;
    procedure SetOnFrameRender(const Value: Tz3DBaseCallbackEvent); stdcall;
    procedure SetOnInitialization(const Value: Tz3DBaseCallbackEvent); stdcall;
    procedure SetOnKeyboardProc(const Value: Tz3DCallbackKeyboardEvent); stdcall;
    procedure SetOnLostDevice(const Value: Tz3DBaseCallbackEvent); stdcall;
    procedure SetOnModifyDevice(const Value: Tz3DCallbackModifyDeviceEvent); stdcall;
    procedure SetOnMsgProc(const Value: Tz3DCallbackMessageEvent); stdcall;
    procedure SetOnResetDevice(const Value: Tz3DBaseCallbackEvent); stdcall;
    procedure CreateDevice(const ADevice: IDirect3DDevice9;
      const ABackBufferSurfaceDesc: TD3DSurfaceDesc); stdcall;
    procedure ConfirmDevice(const ACaps: TD3DCaps9; AAdapterFormat,
    ABackBufferFormat: TD3DFormat; AWindowed: Boolean; var AAccept: Boolean); stdcall;
    procedure DestroyDevice; stdcall;
    procedure LostDevice; stdcall;
    procedure ModifyDevice(var ADeviceSettings: Tz3DDeviceSettings; const ACaps: TD3DCaps9); stdcall;
    procedure ResetDevice; stdcall;
    procedure StartScenario(const AStage: Tz3DStartScenarioStage); stdcall;
    procedure FrameMove; stdcall;
    procedure FrameRender; stdcall;
    procedure MsgProc(AWnd: HWnd; AMsg: LongWord; AwParam: wParam;
    AlParam: lParam; var ADefault: Boolean; var AResult: lResult); stdcall;
    procedure KeyboardProc(AChar: LongWord; AKeyDown, AAltDown: Boolean); stdcall;
  public
    function ComputeNormalMap(const ATexture: Iz3DTexture;
      const ABump: Single = 0.5): Iz3DRenderTexture; stdcall;
    procedure Initialize; stdcall;
    procedure PlayIntro; stdcall;
    procedure PlayMovie(const AFileName: string; const ACanSkip: Boolean = True; const AStretch: Boolean = True); stdcall;
    procedure Run; stdcall;
    procedure Stop; stdcall;
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;
    procedure AddLink(const AObject: Iz3DLinked); stdcall;
    procedure RemoveLink(const AObject: Iz3DLinked); stdcall;
    procedure ShowSettingsDialog; stdcall;

    procedure NotifyLinks_z3DConfirmDevice(const ACaps: TD3DCaps9; AAdapterFormat,
      ABackBufferFormat: TD3DFormat; AWindowed: Boolean; var AAccept: Boolean); stdcall;
    procedure NotifyLinks_z3DModifyDevice(var ADeviceSettings: Tz3DDeviceSettings;
      const ACaps: TD3DCaps9); stdcall;
    procedure NotifyLinks_z3DCreateDevice; stdcall;
    procedure NotifyLinks_z3DDestroyDevice; stdcall;
    procedure NotifyLinks_z3DLostDevice; stdcall;
    procedure NotifyLinks_z3DResetDevice; stdcall;

    procedure NotifyLinks_z3DStartScenario(const AStage: Tz3DStartScenarioStage); stdcall;
    procedure NotifyLinks_z3DEndScenario; stdcall;

    procedure NotifyLinks_z3DFrameMove; stdcall;
    procedure NotifyLinks_z3DFrameRender; stdcall;
    procedure NotifyLinks_z3DLightingRender; stdcall;
    procedure NotifyLinks_z3DDirectLightRender; stdcall;
    procedure NotifyLinks_z3DGUIRender; stdcall;
    procedure NotifyLinks_z3DMessage(const AWnd: HWnd; const AMsg: LongWord; const AwParam: wParam;
      const AlParam: lParam; var ADefault: Boolean; var AResult: lResult); stdcall;
    procedure NotifyLinks_z3DKeyboard(const AChar: LongWord; const AKeyDown, AAltDown: Boolean); stdcall;
  public
    property AudioController: Iz3DAudioController read GetAudioController;
    property CoreShader: Iz3DShader read GetShader;
    property Device: Iz3DDevice read GetDevice;
    property Desktop: Iz3DDesktop read GetDesktop;
    property Stats: Iz3DStats read GetStats;
    property Active: Boolean read GetActive write SetActive default True;
    property Options: Iz3DEngineOptions read GetOptions;
    property DebugHelper: Iz3DDebugHelper read GetDebugHelper;
    property Renderer: Iz3DRenderer read GetRenderer;
    property Window: HWND read GetWindow write SetWindow;
    property Scenario: Iz3DScenario read GetScenario;
    property PostProcess: Iz3DPostProcessEffects read GetPostProcessEffects;

    property OnInitialization: Tz3DBaseCallbackEvent read GetOnInitialization write SetOnInitialization;
    property OnFinalization: Tz3DBaseCallbackEvent read GetOnFinalization write SetOnFinalization;
    property OnMessage: Tz3DCallbackMessageEvent read GetOnMsgProc write SetOnMsgProc;
    property OnKeyboard: Tz3DCallbackKeyboardEvent read GetOnKeyboardProc write SetOnKeyboardProc;
    property OnFrameRender: Tz3DBaseCallbackEvent read GetOnFrameRender write SetOnFrameRender;
    property OnFrameMove: Tz3DBaseCallbackEvent read GetOnFrameMove write SetOnFrameMove;
    property OnCreateDevice: Tz3DBaseCallbackEvent read GetOnCreateDevice write SetOnCreateDevice;
    property OnConfirmDevice: Tz3DCallbackConfirmDeviceEvent read GetOnConfirmDevice write SetOnConfirmDevice;
    property OnDestroyDevice: Tz3DBaseCallbackEvent read GetOnDestroyDevice write SetOnDestroyDevice;
    property OnLostDevice: Tz3DBaseCallbackEvent read GetOnLostDevice write SetOnLostDevice;
    property OnModifyDevice: Tz3DCallbackModifyDeviceEvent read GetOnModifyDevice write SetOnModifyDevice;
    property OnResetDevice: Tz3DBaseCallbackEvent read GetOnResetDevice write SetOnResetDevice;
  end;

// Global access variables and functions

const

  GTest = False;

  FPostProcess_VD: array[0..2] of TD3DVertexElement9 =
  (
    (Stream: 0; Offset: 0; _Type: D3DDECLTYPE_FLOAT4; Method: D3DDECLMETHOD_DEFAULT; Usage: D3DDECLUSAGE_POSITIONT; UsageIndex: 0),
    (Stream: 0; Offset: 16;_Type: D3DDECLTYPE_FLOAT2; Method: D3DDECLMETHOD_DEFAULT; Usage: D3DDECLUSAGE_TEXCOORD;  UsageIndex: 0),
    (Stream:$FF; Offset:0; _Type: D3DDECLTYPE_UNUSED; Method: TD3DDeclMethod(0);     Usage: TD3DDeclUsage(0);       UsageIndex: 0)
  );

  FMSAASamplesD3D: array[0..16] of TD3DMultiSampleType =
    (D3DMULTISAMPLE_NONE,
     D3DMULTISAMPLE_NONE,
     D3DMULTISAMPLE_2_SAMPLES,
     D3DMULTISAMPLE_3_SAMPLES,
     D3DMULTISAMPLE_4_SAMPLES,
     D3DMULTISAMPLE_5_SAMPLES,
     D3DMULTISAMPLE_6_SAMPLES,
     D3DMULTISAMPLE_7_SAMPLES,
     D3DMULTISAMPLE_8_SAMPLES,
     D3DMULTISAMPLE_9_SAMPLES,
     D3DMULTISAMPLE_10_SAMPLES,
     D3DMULTISAMPLE_11_SAMPLES,
     D3DMULTISAMPLE_12_SAMPLES,
     D3DMULTISAMPLE_13_SAMPLES,
     D3DMULTISAMPLE_14_SAMPLES,
     D3DMULTISAMPLE_15_SAMPLES,
     D3DMULTISAMPLE_16_SAMPLES);

var FDebugCounter: Cardinal;

procedure z3DDebug_Init;
function z3DDebug_Result: string;

function z3DCreateEngine: Iz3DEngine; stdcall;
function z3DEngine: Iz3DEngine; stdcall;

{procedure z3DRegisterGlobalController(const AController: Iz3DGlobalController; const ALinkCreation: Boolean = True;
  const ALinkInit: Boolean = True; const ALinkRun: Boolean = True); stdcall;
procedure z3DUnregisterGlobalController(const AController: Iz3DGlobalController; const ALinkCreation: Boolean = True;
  const ALinkInit: Boolean = True; const ALinkRun: Boolean = True); stdcall;}


var FTimers: array[0..20] of Cardinal;


implementation

uses z3DCore_Func, z3DMath_Func, z3DGUI_Func, z3DComponents_Func, SysUtils,
  z3DStrings, z3DFileSystem_Intf, z3DFileSystem_Func, z3DAudio_Func, Forms,
  z3DREFSwitch, Messages, z3DScenario_Func, z3DScenarioObjects_Intf,
  DirectSound, z3DFunctions, Math, z3DLighting_Func, z3DLighting_Intf,
  z3DModels_Func, z3DModels_Intf;

var GEngine: Iz3DEngine;
    GCreationControllers: IInterfaceList;
    GInitControllers: IInterfaceList;
    GRunControllers: IInterfaceList;

function z3DCreateEngine: Iz3DEngine; stdcall;
begin
  z3DTrace('z3DCreateEngine: Creating engine object...', z3DtkInformation);
  Result:= Tz3DEngine.Create;
end;

function z3DEngine: Iz3DEngine; stdcall;
begin
  Result:= GEngine;
end;


procedure z3DDebug_Init;
begin
  FDebugCounter:= GetTickCount;
end;

function z3DDebug_Result: string;
begin
  Result:= Format('%s seconds (%d ms).', [FormatFloat('0.0000', (GetTickCount-FDebugCounter)/1000), GetTickCount-FDebugCounter]);
end;

{==============================================================================}
{== Global callback functions to make contact with z3D Core                  ==}
{==============================================================================}

function IsDepthFormatOk(DepthFormat, AdapterFormat, BackBufferFormat: TD3DFormat): Boolean;
begin
  Result:= False;

  // Verify that the depth format exists
  if Failed(z3DCore_GetD3DObject.CheckDeviceFormat(D3DADAPTER_DEFAULT,
  D3DDEVTYPE_HAL, AdapterFormat, D3DUSAGE_DEPTHSTENCIL, D3DRTYPE_SURFACE, DepthFormat)) then Exit;

  // Verify that the backbuffer format is valid
  if Failed(z3DCore_GetD3DObject.CheckDeviceFormat(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL,
  AdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_SURFACE, BackBufferFormat)) then Exit;

  // Verify that the depth format is compatible
  if Failed(z3DCore_GetD3DObject.CheckDepthStencilMatch(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL,
  AdapterFormat, BackBufferFormat, DepthFormat)) then Exit;

  Result:= True;
end;

function GIsDeviceAcceptable(const ACaps: TD3DCaps9; const AAdapterFormat, ABackBufferFormat: TD3DFormat;
  const AWindowed: Boolean; const AUserContext: Pointer): Boolean; stdcall;
var pD3D: IDirect3D9;
begin
  Result:= False;
  pD3D:= z3DCore_GetD3DObject;

  // Skip backbuffer formats that don't support alpha blending
  if FAILED(pD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  AAdapterFormat, D3DUSAGE_QUERY_POSTPIXELSHADER_BLENDING, D3DRTYPE_TEXTURE, ABackBufferFormat)) then Exit;

  // Must support pixel shader 2 model
  if (ACaps.PixelShaderVersion < D3DPS_VERSION(2,0)) then Exit;

  // Need to support A8R8G8B8 render target
  if FAILED(pD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  AAdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_TEXTURE, D3DFMT_A8R8G8B8)) then Exit;

  // Need to support alpha blending for A8R8G8B8 texture
  if FAILED(pD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  AAdapterFormat, D3DUSAGE_QUERY_POSTPIXELSHADER_BLENDING, D3DRTYPE_TEXTURE, D3DFMT_A8R8G8B8)) then Exit;

// Forced REF device
//  if FAILED(pD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
//  AAdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_TEXTURE, D3DFMT_R8G8B8)) then Exit;

  Result:= True;
  z3DEngine.ConfirmDevice(ACaps, AAdapterFormat, ABackBufferFormat, AWindowed, Result);
end;

function GModifyDevice(var ASettings: Tz3DDeviceSettings; const ACaps: TD3DCaps9;
  const AUserContext: Pointer): Boolean; stdcall;
begin
  if (ACaps.DevCaps and D3DDEVCAPS_HWTRANSFORMANDLIGHT = 0) or
  (ACaps.VertexShaderVersion < D3DVS_VERSION(2,0)) then
  ASettings.BehaviorFlags:= D3DCREATE_SOFTWARE_VERTEXPROCESSING;

  z3DEngine.ModifyDevice(ASettings, ACaps);
  Result:= True;
end;

function GOnCreateDevice(const ADevice: IDirect3DDevice9; const ABackBuffer: TD3DSurfaceDesc;
  const AUserContext: Pointer): HRESULT; stdcall;
begin
  z3DEngine.CreateDevice(ADevice, ABackBuffer);
  Result:= S_OK;
end;

function GOnResetDevice(const ADevice: IDirect3DDevice9; const ABackBuffer: TD3DSurfaceDesc;
  const AUserContext: Pointer): HRESULT; stdcall;
begin
  z3DEngine.ResetDevice;
  Result:= S_OK;
end;

procedure GOnLostDevice(const AUserContext: Pointer); stdcall;
begin
  z3DEngine.LostDevice;
end;

procedure GOnDestroyDevice(const AUserContext: Pointer); stdcall;
begin
  z3DEngine.DestroyDevice;
end;

procedure GOnFrameMove(const ADevice: IDirect3DDevice9; const ATime: Double; const AElapsedTime: Single;
  const AUserContext: Pointer); stdcall;
begin
  z3DEngine.FrameMove;
end;

procedure GOnFrameRender(const ADevice: IDirect3DDevice9; const ATime: Double;
  const AElapsedTime: Single; const AUserContext: Pointer); stdcall;
begin
  z3DEngine.FrameRender;
end;

function GOnMsgProc(const AWnd: HWND; const AMsg: LongWord; const AWParam: WPARAM;
  const ALParam: LPARAM; out AHandled: Boolean; const AUserContext: Pointer): LRESULT; stdcall;
var FDefault: Boolean;
begin
  FDefault:= True;
  z3DEngine.MsgProc(AWnd, AMsg, AwParam, AlParam, FDefault, Result);
  AHandled:= not FDefault;
end;

procedure GOnKeyboardProc(const AChar: LongWord; const AKeyDown, AAltDown: Boolean;
  const AUserContext: Pointer); stdcall;
begin
  z3DEngine.KeyboardProc(AChar, AKeyDown, AAltDown);
end;

{ Tz3DEngine }

constructor Tz3DEngine.Create;
begin
  inherited;

  FFrameMoveLinks:= TInterfaceList.Create;
  FGPUPrecomputationLinks:= TInterfaceList.Create;
  FFrameRenderLinks:= TInterfaceList.Create;
  FLightingRenderLinks:= TInterfaceList.Create;
  FDirectLightRenderLinks:= TInterfaceList.Create;
  FGUIRenderLinks:= TInterfaceList.Create;
  FkeyboardLinks:= TInterfaceList.Create;
  FCreationLinksStageI:= TInterfaceList.Create;
  FCreationLinksStageII:= TInterfaceList.Create;
  FCreationLinksStageIII:= TInterfaceList.Create;
  FMessageLinks:= TInterfaceList.Create;

  GEngine:= Self as Iz3DEngine;
  FDevice:= Tz3DDevice.Create;
  FDesktop:= z3DCreateDesktop;
  FSettingsDialog:= FDesktop.CreateEngineSettingsDialog;
  FSettingsDialog.Visible:= False;
  FActive:= True;
  FInitialized:= False;
  FShader:= z3DCreateShader;
  FShader.ScenarioLevel:= False;
  FShader.FileName:= PWideChar(WideString(Z3DRES_CORE_EFFECT));
  FRenderer:= Tz3DRenderer.Create;
  FScenario:= z3DCreateScenario;
  FStats:= Tz3DStats.Create;
  FDebugHelper:= Tz3DDebugHelper.Create;
  FOptions:= Tz3DEngineOptions.Create;
  FPostProcessEffects:= Tz3DPostProcessEffects.Create;
end;

destructor Tz3DEngine.Destroy;
begin
  FAudioController:= nil;
  FOptions:= nil;
  FPostProcessEffects:= nil;
  FDebugHelper:= nil;
  FScenario:= nil;
  FDevice:= nil;
  FStats:= nil;
  if Assigned(FOnFinalization) then FOnFinalization(Self);
  GEngine:= nil;
  FatalExit(0);
  inherited;
end;

procedure Tz3DEngine.Initialize;
var FRect: TRect;
begin
  if FInitialized then Exit;
  if Assigned(FOnInitialization) then FOnInitialization(Self);

  // Initialize z3D environment
  z3DCore_SetCursorSettings(False, False);
  z3DCore_SetCallback_FrameMove(GOnFrameMove);
  z3DCore_SetCallback_FrameRender(GOnFrameRender);
  z3DCore_SetCallback_Keyboard(GOnKeyboardProc);
  z3DCore_SetCallback_MsgProc(GOnMsgProc);
  z3DInit(FOptions.ParseCommandLine, FOptions.HandleDefaultHotkeys,
  FOptions.ShowFatalMessages, False);
  SetWindowTextW(Window, z3DCore_GetState.CurrentApp);

  // Set the render window
  if IsWindow(Window) then
  z3DCore_SetWindow(Window, Window, Window, FOptions.HandleWindowMessages) else
  z3DCore_CreateWindow(z3DCore_GetState.CurrentApp, HInstance);
  if not Options.StretchToWindow or Device.FullScreen then
  begin
    z3DCore_GetState.OverrideWidth:= 800;
    z3DCore_GetState.OverrideHeight:= 600;
  end;

  // Center the window on screen
  ShowWindow(Window, SW_SHOW);
  GetWindowRect(Window, FRect);
  MoveWindow(Window, Screen.Width div 2 - (FRect.Right - FRect.Left) div 2,
  Screen.Height div 2 - (FRect.Bottom - FRect.Top) div 2, FRect.Right - FRect.Left,
  FRect.Bottom - FRect.Top, False);

  // Create the Direct3D device
  FDevice.CreateDevice;

  // Play introduction media
  if Options.PlayIntro then PlayIntro;

  // Prepare the engine to run
  z3DCore_SetCursorSettings(Options.ShowCursorOnFullScreen, Options.ClipCursorOnFullScreen);
  z3DCore_GetState.SetHandleAltEnter(FOptions.HandleAltEnter);
  FActive:= True;
  FInitialized:= True;
end;

procedure Tz3DEngine.PlayMovie(const AFileName: string; const ACanSkip, AStretch: Boolean);
var FControl: Tz3DWinControl;
    FRect: TRect;
    FCursor: TCursor;
begin
  // Check if the filename is valid
  if not FileExists(AFileName) then
  begin
    z3DTrace(PWideChar(WideString('Iz3DEngine.PlayMovie: Could not play movie (File '+ExtractFileName(AFileName)+' not found)')), z3dtkWarning);
    Exit;
  end;

  // Create the movie controller and open the file
  FCursor:= Screen.Cursor;
  Screen.Cursor:= crNone;
  FVideoManager:= TMediaPlayer.Create(nil);
  try
    FVideoManager.FileName:= AFileName;
    FControl:= Tz3DWinControl.Create(Application);
    try
      FControl.WindowHandle:= z3DCore_GetHWND;
      FVideoManager.Parent:= FControl;
      FVideoManager.Display:= FControl;
      try
        FVideoManager.Open;
      except
        z3DTrace(PWideChar(WideString('Iz3DEngine.PlayMovie: Could not open movie. Message: '+FVideoManager.ErrorMessage)), z3dtkWarning);
      end;

      // Prepare the movie on the screen
      GetWindowRect(Window, FRect);
      if AStretch then FVideoManager.DisplayRect:= Rect(0, 0, FControl.ClientRect.Right - FControl.ClientRect.Left,
      FControl.ClientRect.Bottom - FControl.ClientRect.Top) else
      FVideoManager.DisplayRect:= Rect((FControl.ClientRect.Right - FControl.ClientRect.Left) div 2 -
      FVideoManager.DisplayRect.Right div 2, (FControl.ClientRect.Bottom - FControl.ClientRect.Top) div 2 -
      FVideoManager.DisplayRect.Bottom div 2, FVideoManager.DisplayRect.Right, FVideoManager.DisplayRect.Bottom);

      // Play the movie
      ShowWindow(Window, SW_SHOW);
      FVideoManager.Play;

      // Process messages with no rendering and skip movie if spacebar is pressed
      while FVideoManager.Mode = mpPlaying do
      begin
        z3DCore_ProcessMessages(0, False);
        if ACanSkip and z3DCore_GetState.Keys[27] then Break;
      end;
      
    finally
      FControl.WindowHandle:= 0;
    end;
  finally
    FVideoManager.Free;
    Screen.Cursor:= FCursor;
  end;
end;

procedure Tz3DEngine.PlayIntro;
begin
  z3DFileSystemController.DecryptF(fsEngineCoreResFile, fsCoreResFile_z3DTheme);
  z3DFileSystemController.DecryptF(fsEngineCoreResFile, fsCoreResFile_z3DAVIIntro);

  if Options.PlayMusic and (z3DAudioController <> nil) then
  begin
    StringToWideChar(WideCharToString(z3DFileSystemController.GetFullPath(fsBufferPath))+fsPathDiv+fsCoreResFile_z3DTheme, z3DWideBuffer, 255);
    z3DAudioController.Music.Play(z3DWideBuffer);
  end;
  PlayMovie(WideCharToString(z3DFileSystemController.GetFullPath(fsBufferPath))+fsPathDiv+fsCoreResFile_z3DAVIIntro);

  z3DFileSystemController.Delete(fsCoreResFile_z3DAVIIntro);
end;

procedure Tz3DEngine.Run;
begin
  if z3DCore_GetState.InsideMainloop then z3DCore_Pause(False, False) else
  begin
    Initialize;

    // Pass control to z3D main loop. The only events that will be called since
    // here will be the z3D events. No application events are available
    z3DCore_MainLoop;
  end;
end;

procedure Tz3DEngine.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive:= Value;
    if Value then Run else Stop;
  end;
end;

procedure Tz3DEngine.ConfirmDevice(const ACaps: TD3DCaps9; AAdapterFormat,
  ABackBufferFormat: TD3DFormat; AWindowed: Boolean; var AAccept: Boolean);
begin
  AAccept:= True;
  NotifyLinks_z3DConfirmDevice(ACaps, AAdapterFormat, ABackBufferFormat, AWindowed, AAccept);
  if Assigned(FOnConfirmDevice) then
  FOnConfirmDevice(ACaps, AAdapterFormat, ABackBufferFormat, AWindowed, AAccept);
end;

procedure Tz3DEngine.CreateDevice(const ADevice: IDirect3DDevice9;
  const ABackBufferSurfaceDesc: TD3DSurfaceDesc);
begin
  // Initialize the audio manager
  FAudioController:= z3DCreateAudioController;
  FAudioController.Initialize(z3DCore_GetHWND);

  NotifyLinks_z3DCreateDevice;
  if Assigned(FOnCreateDevice) then FOnCreateDevice(Self);
end;

procedure Tz3DEngine.DestroyDevice;
begin
  FAudioController:= nil;
  NotifyLinks_z3DDestroyDevice;
  if Assigned(FOnDestroyDevice) then FOnDestroyDevice(Self);
end;

procedure Tz3DEngine.LostDevice;
begin
  NotifyLinks_z3DLostDevice;
  if Assigned(FOnLostDevice) then FOnLostDevice(Self);
end;

procedure Tz3DEngine.ModifyDevice(var ADeviceSettings: Tz3DDeviceSettings;
  const ACaps: TD3DCaps9);
begin
  NotifyLinks_z3DModifyDevice(ADeviceSettings, ACaps);
  if Assigned(FOnModifyDevice) then FOnModifyDevice(ADeviceSettings, ACaps);

  // Display the Switching to REF dialog warning
  if (ADeviceSettings.DeviceType = D3DDEVTYPE_REF) and
  Device.DisplayREFWarning then TfrmREFSwitch.Launch;
end;

procedure Tz3DEngine.ResetDevice;
begin
  NotifyLinks_z3DResetDevice;
  FScenario.ResetDevice;
  if Assigned(FOnResetDevice) then FOnResetDevice(Self);
end;

procedure Tz3DEngine.FrameMove;
begin
  if Assigned(FOnFrameMove) then FOnFrameMove(Self);
  NotifyLinks_z3DFrameMove;
  if FScenario.Enabled then FPostProcessEffects.FrameMove;
end;

procedure Tz3DEngine.FrameRender;
begin
  if Assigned(FOnFrameRender) then FOnFrameRender(Self);
  if Renderer <> nil then Renderer.RenderScene;
end;

function Tz3DEngine.ComputeNormalMap(const ATexture: Iz3DTexture; const ABump: Single = 0.5): Iz3DRenderTexture;
var FTexture: Iz3DRenderTexture;
begin
  if z3DTraceCondition(ATexture = nil, 'Iz3DEngine.ComputeNormalMap failed (ATexture is NULL)', z3DtkWarning) then Exit;
  if z3DTraceCondition(ATexture.D3DTexture = nil, 'Iz3DEngine.ComputeNormalMap failed (ATexture.D3DTexture is NULL)', z3DtkWarning) then Exit;
  FTexture:= z3DCreateRenderTexture;
  FTexture.ScenarioLevel:= False;
  FTexture.AutoParams:= False;
  FTexture.Usage:= D3DUSAGE_RENDERTARGET;
  FTexture.AutoGenerateMipMaps:= True;
  FTexture.SetParams(ATexture.Width, ATexture.Height, 1, D3DFMT_A8R8G8B8);
  if not Renderer.Rendering then z3DCore_GetD3DDevice.BeginScene;
  FShader.Technique:= 'z3DCore_NormalMap';
  FShader.Param['GTextureWidth']:= ATexture.Width;
  FShader.Param['GTextureHeight']:= ATexture.Height;
  FShader.Param['GBumpFactor']:= ABump;
  Renderer.PostProcess(FTexture, [ATexture], FShader);
  if not Renderer.Rendering then z3DCore_GetD3DDevice.EndScene;
  Result:= FTexture;
end;

procedure Tz3DEngine.MsgProc(AWnd: HWnd; AMsg: LongWord; AwParam: wParam;
  AlParam: lParam; var ADefault: Boolean; var AResult: lResult);
begin
  AResult:= 0;

  // Allow dialog resource manager calles to handle GUI messages
  if not ADefault then Exit;
  ADefault:= True;
  NotifyLinks_z3DMessage(AWnd, AMsg, AwParam, AlParam, ADefault, AResult);
  if not ADefault then Exit;
  if Assigned(FOnMsgProc) then FOnMsgProc(AWnd, AMsg, AwParam, AlParam, ADefault, AResult);
end;

procedure Tz3DEngine.KeyboardProc(AChar: LongWord; AKeyDown, AAltDown: Boolean);
begin
  if AKeyDown and (Ord(AChar) = VK_ESCAPE) and Scenario.Enabled then Desktop.Visible:= not Desktop.Visible;
  NotifyLinks_z3DKeyboard(AChar, AKeyDown, AAltDown);
  if Assigned(FOnKeyboardProc) then FOnKeyboardProc(AChar, AKeyDown, AAltDown);
end;

procedure Tz3DEngine.Stop;
begin
  z3DCore_Pause(True, True);
end;

procedure Tz3DEngine.AddLink(const AObject: Iz3DLinked);
begin


  // Register render targets and depth buffers first
  if z3dlnDevice in AObject.Notifications then
  begin

    // Stage I: Render textures, Depth/Stencil buffers
    if z3DSupports(AObject, Iz3DRenderer) then
    begin
      if (FCreationLinksStageI.IndexOf(AObject) = -1) and (FCreationLinksStageI.Count > 0) then
      FCreationLinksStageI.Insert(0, AObject);
    end else

    if z3DSupports(AObject, Iz3DRenderTexture) or
    z3DSupports(AObject, Iz3DDepthBuffer) then
    begin
      if FCreationLinksStageI.IndexOf(AObject) = -1 then
      FCreationLinksStageI.Add(AObject);
    end else

    // Stage II: Common textures, Effects
    if z3DSupports(AObject, Iz3DBaseTexture) or
    z3DSupports(AObject, Iz3DShader) then
    begin
      if FCreationLinksStageII.IndexOf(AObject) = -1 then
      FCreationLinksStageII.Add(AObject);
    end else

    // Stage III: Other objects
    begin
      if FCreationLinksStageIII.IndexOf(AObject) = -1 then
      FCreationLinksStageIII.Add(AObject);
    end;
  end;

  // Register camera objects first
  if z3dlnFrameMove in AObject.Notifications then
  if FFrameMoveLinks.IndexOf(AObject) = -1 then
  begin
    if z3DSupports(AObject, Iz3DBaseCamera) and (FFrameMoveLinks.Count > 0) then
    FFrameMoveLinks.Insert(0, AObject) else
    FFrameMoveLinks.Add(AObject);
  end;
  if z3dlnGPUPrecomputation in AObject.Notifications then
  if FGPUPrecomputationLinks.IndexOf(AObject) = -1 then
  begin
    FGPUPrecomputationLinks.Add(AObject);
  end;
  if z3dlnFrameRender in AObject.Notifications then
  if FFrameRenderLinks.IndexOf(AObject) = -1 then
  begin
    FFrameRenderLinks.Add(AObject);
  end;
  if z3dlnLightingRender in AObject.Notifications then
  if FLightingRenderLinks.IndexOf(AObject) = -1 then
  begin
    FLightingRenderLinks.Add(AObject);
  end;
  if z3dlnDirectLightRender in AObject.Notifications then
  if FDirectLightRenderLinks.IndexOf(AObject) = -1 then
  begin
    FDirectLightRenderLinks.Add(AObject);
  end;
  if z3dlnGUIRender in AObject.Notifications then
  if FGUIRenderLinks.IndexOf(AObject) = -1 then
  begin
    FGUIRenderLinks.Add(AObject);
  end;
  if z3dlnMessages in AObject.Notifications then
  if FMessageLinks.IndexOf(AObject) = -1 then
  begin
    FMessageLinks.Add(AObject);
  end;
  if z3dlnKeyboard in AObject.Notifications then
  if FkeyboardLinks.IndexOf(AObject) = -1 then
  begin
    FkeyboardLinks.Add(AObject);
  end;
end;

procedure Tz3DEngine.RemoveLink(const AObject: Iz3DLinked);
begin
  if z3dlnDevice in AObject.Notifications then
  begin
    if z3DSupports(AObject, Iz3DRenderTexture) or
    z3DSupports(AObject, Iz3DRenderer) or z3DSupports(AObject, Iz3DDepthBuffer) then
    FCreationLinksStageI.Remove(AObject) else

    if z3DSupports(AObject, Iz3DShader) or z3DSupports(AObject, Iz3DBaseTexture) then
    FCreationLinksStageII.Remove(AObject) else
    
    FCreationLinksStageIII.Remove(AObject);
  end;
  if z3dlnFrameMove in AObject.Notifications then FFrameMoveLinks.Remove(AObject);
  if z3dlnGPUPrecomputation in AObject.Notifications then FGPUPrecomputationLinks.Remove(AObject);
  if z3dlnFrameRender in AObject.Notifications then FFrameRenderLinks.Remove(AObject);
  if z3dlnLightingRender in AObject.Notifications then FLightingRenderLinks.Remove(AObject);
  if z3dlnDirectLightRender in AObject.Notifications then FDirectLightRenderLinks.Remove(AObject);
  if z3dlnGUIRender in AObject.Notifications then FGUIRenderLinks.Remove(AObject);
  if z3dlnMessages in AObject.Notifications then FMessageLinks.Remove(AObject);
  if z3dlnKeyboard in AObject.Notifications then FkeyboardLinks.Remove(AObject);
end;

procedure Tz3DEngine.NotifyLinks_z3DConfirmDevice;
var I: Integer;
begin
  for I:= 0 to FCreationLinksStageI.Count-1 do
  (FCreationLinksStageI.Items[I] as Iz3DLinked).z3DConfirmDevice(ACaps, AAdapterFormat, ABackBufferFormat, AAccept);
  for I:= 0 to FCreationLinksStageII.Count-1 do
  (FCreationLinksStageII.Items[I] as Iz3DLinked).z3DConfirmDevice(ACaps, AAdapterFormat, ABackBufferFormat, AAccept);
  for I:= 0 to FCreationLinksStageIII.Count-1 do
  (FCreationLinksStageIII.Items[I] as Iz3DLinked).z3DConfirmDevice(ACaps, AAdapterFormat, ABackBufferFormat, AAccept);
end;

procedure Tz3DEngine.NotifyLinks_z3DCreateDevice;
var I: Integer;
begin
  for I:= 0 to FCreationLinksStageI.Count-1 do
  (FCreationLinksStageI.Items[I] as Iz3DLinked).z3DCreateDevice;
  for I:= 0 to FCreationLinksStageII.Count-1 do
  (FCreationLinksStageII.Items[I] as Iz3DLinked).z3DCreateDevice;
  for I:= 0 to FCreationLinksStageIII.Count-1 do
  (FCreationLinksStageIII.Items[I] as Iz3DLinked).z3DCreateDevice;
end;

procedure Tz3DEngine.NotifyLinks_z3DDestroyDevice;
var I: Integer;
begin
  for I:= 0 to FCreationLinksStageIII.Count-1 do
  (FCreationLinksStageIII.Items[I] as Iz3DLinked).z3DDestroyDevice;
  for I:= 0 to FCreationLinksStageII.Count-1 do
  (FCreationLinksStageII.Items[I] as Iz3DLinked).z3DDestroyDevice;
  for I:= 0 to FCreationLinksStageI.Count-1 do
  (FCreationLinksStageI.Items[I] as Iz3DLinked).z3DDestroyDevice;
end;

procedure Tz3DEngine.NotifyLinks_z3DEndScenario;
var I: Integer;
begin
  for I:= 0 to FCreationLinksStageIII.Count-1 do
  (FCreationLinksStageIII.Items[I] as Iz3DLinked).z3DStopScenario;
  for I:= 0 to FCreationLinksStageII.Count-1 do
  (FCreationLinksStageII.Items[I] as Iz3DLinked).z3DStopScenario;
  for I:= 0 to FCreationLinksStageI.Count-1 do
  (FCreationLinksStageI.Items[I] as Iz3DLinked).z3DStopScenario;
end;

procedure Tz3DEngine.NotifyLinks_z3DStartScenario(const AStage: Tz3DStartScenarioStage);
var I, FTotal: Integer;
begin

  FTotal:= FCreationLinksStageI.Count+FCreationLinksStageII.Count+FCreationLinksStageIII.Count;

  // Create the scenario-staged render textures and depth stencils
  for I:= 0 to FCreationLinksStageI.Count-1 do
  begin
    if z3DEngine.Desktop.ProgressDialog <> nil then
    z3DEngine.Desktop.ProgressDialog.SetProgress(Round((Integer(AStage)*FTotal+I)*100 /
    ((Integer(High(Tz3DStartScenarioStage))+1) * FTotal)));
    (FCreationLinksStageI.Items[I] as Iz3DLinked).z3DStartScenario(AStage);
  end;

  // Create the scenario-staged common textures and effects
  for I:= 0 to FCreationLinksStageII.Count-1 do
  begin
    if z3DEngine.Desktop.ProgressDialog <> nil then
    z3DEngine.Desktop.ProgressDialog.SetProgress(Round((Integer(AStage)*FTotal+
    (FCreationLinksStageI.Count+I))*100 /
    ((Integer(High(Tz3DStartScenarioStage))+1) * FTotal)));
    (FCreationLinksStageII.Items[I] as Iz3DLinked).z3DStartScenario(AStage);
  end;

  // Create the scenario-staged objects
  for I:= 0 to FCreationLinksStageIII.Count-1 do
  begin
    if z3DEngine.Desktop.ProgressDialog <> nil then
    z3DEngine.Desktop.ProgressDialog.SetProgress(Round((Integer(AStage)*FTotal+
    (FCreationLinksStageI.Count+FCreationLinksStageII.Count+I))*100 /
    ((Integer(High(Tz3DStartScenarioStage))+1) * FTotal)));
    (FCreationLinksStageIII.Items[I] as Iz3DLinked).z3DStartScenario(AStage);
  end;
end;

procedure Tz3DEngine.NotifyLinks_z3DMessage(const AWnd: HWnd; const AMsg: LongWord; const AwParam: wParam;
  const AlParam: lParam; var ADefault: Boolean; var AResult: lResult);
var I: Integer;
begin
  for I:= 0 to FMessageLinks.Count-1 do
  (FMessageLinks.Items[I] as Iz3DLinked).z3DMessage(AWnd, AMsg, AwParam, AlParam, ADefault, AResult);
end;

procedure Tz3DEngine.NotifyLinks_z3DFrameMove;
var I: Integer;
begin
  for I:= 0 to FFrameMoveLinks.Count-1 do
  (FFrameMoveLinks.Items[I] as Iz3DLinked).z3DFrameMove;
end;

procedure Tz3DEngine.NotifyLinks_z3DFrameRender;
var I: Integer;
begin
  if Renderer.RenderStage = z3drsPrecomputation then
  begin
    for I:= 0 to FGPUPrecomputationLinks.Count-1 do
    (FGPUPrecomputationLinks.Items[I] as Iz3DLinked).z3DGPUPrecomputation;
  end else
  begin
    for I:= 0 to FFrameRenderLinks.Count-1 do
    (FFrameRenderLinks.Items[I] as Iz3DLinked).z3DFrameRender;
  end;
end;

procedure Tz3DEngine.NotifyLinks_z3DLightingRender;
var I: Integer;
begin
  for I:= 0 to FLightingRenderLinks.Count-1 do
  (FLightingRenderLinks.Items[I] as Iz3DLinked).z3DLightingRender;
end;

procedure Tz3DEngine.NotifyLinks_z3DDirectLightRender;
var I: Integer;
begin
  for I:= 0 to FDirectLightRenderLinks.Count-1 do
  (FDirectLightRenderLinks.Items[I] as Iz3DLinked).z3DDirectLightRender;
end;

procedure Tz3DEngine.NotifyLinks_z3DGUIRender;
var I: Integer;
begin
  for I:= 0 to FGUIRenderLinks.Count-1 do
  (FGUIRenderLinks.Items[I] as Iz3DLinked).z3DGUIRender;
end;

procedure Tz3DEngine.NotifyLinks_z3DKeyboard(const AChar: LongWord; const AKeyDown, AAltDown: Boolean);
var I: Integer;
begin
  for I:= 0 to FMessageLinks.Count-1 do
  (FMessageLinks[I] as Iz3DLinked).z3DKeyboard(AChar, AKeyDown, AAltDown);
end;

procedure Tz3DEngine.NotifyLinks_z3DLostDevice;
var I: Integer;
begin
  for I:= 0 to FCreationLinksStageIII.Count-1 do
  (FCreationLinksStageIII.Items[I] as Iz3DLinked).z3DLostDevice;
  for I:= 0 to FCreationLinksStageII.Count-1 do
  (FCreationLinksStageII.Items[I] as Iz3DLinked).z3DLostDevice;
  for I:= 0 to FCreationLinksStageI.Count-1 do
  (FCreationLinksStageI.Items[I] as Iz3DLinked).z3DLostDevice;
end;

procedure Tz3DEngine.NotifyLinks_z3DModifyDevice(var ADeviceSettings: Tz3DDeviceSettings;
  const ACaps: TD3DCaps9);
var I: Integer;
begin
  for I:= 0 to FCreationLinksStageI.Count-1 do
  (FCreationLinksStageI[I] as Iz3DLinked).z3DModifyDevice(ADeviceSettings, ACaps);
  for I:= 0 to FCreationLinksStageII.Count-1 do
  (FCreationLinksStageII[I] as Iz3DLinked).z3DModifyDevice(ADeviceSettings, ACaps);
  for I:= 0 to FCreationLinksStageIII.Count-1 do
  (FCreationLinksStageIII[I] as Iz3DLinked).z3DModifyDevice(ADeviceSettings, ACaps);
end;

procedure Tz3DEngine.NotifyLinks_z3DResetDevice;
var I: Integer;
begin
  for I:= 0 to FCreationLinksStageI.Count-1 do
  (FCreationLinksStageI[I] as Iz3DLinked).z3DResetDevice;
  for I:= 0 to FCreationLinksStageII.Count-1 do
  (FCreationLinksStageII[I] as Iz3DLinked).z3DResetDevice;
  for I:= 0 to FCreationLinksStageIII.Count-1 do
  (FCreationLinksStageIII[I] as Iz3DLinked).z3DResetDevice;
end;

function Tz3DEngine.GetActive: Boolean;
begin
  Result:= FActive;
end;

function Tz3DEngine.GetDebugHelper: Iz3DDebugHelper;
begin
  Result:= FDebugHelper;
end;

function Tz3DEngine.GetDevice: Iz3DDevice;
begin
  Result:= FDevice;
end;

function Tz3DEngine.GetShader: Iz3DShader;
begin
  Result:= FShader;
end;

function Tz3DEngine.GetOnConfirmDevice: Tz3DCallbackConfirmDeviceEvent;
begin
  Result:= FOnConfirmDevice;
end;

function Tz3DEngine.GetOnCreateDevice: Tz3DBaseCallbackEvent;
begin
  Result:= FOnCreateDevice;
end;

function Tz3DEngine.GetOnDestroyDevice: Tz3DBaseCallbackEvent;
begin
  Result:= FOnDestroyDevice;
end;

function Tz3DEngine.GetOnFinalization: Tz3DBaseCallbackEvent;
begin
  Result:= FOnFinalization;
end;

function Tz3DEngine.GetOnFrameMove: Tz3DBaseCallbackEvent;
begin
  Result:= FOnFrameMove;
end;

function Tz3DEngine.GetOnFrameRender: Tz3DBaseCallbackEvent;
begin
  Result:= FOnFrameRender;
end;

function Tz3DEngine.GetOnInitialization: Tz3DBaseCallbackEvent;
begin
  Result:= FOnInitialization;
end;

function Tz3DEngine.GetOnKeyboardProc: Tz3DCallbackKeyboardEvent;
begin
  Result:= FOnKeyboardProc;
end;

function Tz3DEngine.GetOnLostDevice: Tz3DBaseCallbackEvent;
begin
  Result:= FOnLostDevice;
end;

function Tz3DEngine.GetOnModifyDevice: Tz3DCallbackModifyDeviceEvent;
begin
  Result:= FOnModifyDevice;
end;

function Tz3DEngine.GetOnMsgProc: Tz3DCallbackMessageEvent;
begin
  Result:= FOnMsgProc;
end;

function Tz3DEngine.GetOnResetDevice: Tz3DBaseCallbackEvent;
begin
  Result:= FOnResetDevice;
end;

function Tz3DEngine.GetOptions: Iz3DEngineOptions;
begin
  Result:= FOptions;
end;

function Tz3DEngine.GetPostProcessEffects: Iz3DPostProcessEffects;
begin
  Result:= FPostProcessEffects;
end;

function Tz3DEngine.GetScenario: Iz3DScenario;
begin
  Result:= FScenario;
end;

function Tz3DEngine.GetStats: Iz3DStats;
begin
  Result:= FStats;
end;

procedure Tz3DEngine.SetOnConfirmDevice(const Value: Tz3DCallbackConfirmDeviceEvent);
begin
  FOnConfirmDevice:= Value;
end;

procedure Tz3DEngine.SetOnCreateDevice(const Value: Tz3DBaseCallbackEvent);
begin
  FOnCreateDevice:= Value;
end;

procedure Tz3DEngine.SetOnDestroyDevice(const Value: Tz3DBaseCallbackEvent);
begin
  FOnDestroyDevice:= Value;
end;

procedure Tz3DEngine.SetOnFinalization(const Value: Tz3DBaseCallbackEvent);
begin
  FOnFinalization:= Value;
end;

procedure Tz3DEngine.SetOnFrameMove(const Value: Tz3DBaseCallbackEvent);
begin
  FOnFrameMove:= Value;
end;

procedure Tz3DEngine.SetOnFrameRender(const Value: Tz3DBaseCallbackEvent);
begin
  FOnFrameRender:= Value;
end;

procedure Tz3DEngine.SetOnInitialization(const Value: Tz3DBaseCallbackEvent);
begin
  FOnInitialization:= Value;
end;

procedure Tz3DEngine.SetOnKeyboardProc(const Value: Tz3DCallbackKeyboardEvent);
begin
  FOnKeyboardProc:= Value;
end;

procedure Tz3DEngine.SetOnLostDevice(const Value: Tz3DBaseCallbackEvent);
begin
  FOnLostDevice:= Value;
end;

procedure Tz3DEngine.SetOnModifyDevice(const Value: Tz3DCallbackModifyDeviceEvent);
begin
  FOnModifyDevice:= Value;
end;

procedure Tz3DEngine.SetOnMsgProc(const Value: Tz3DCallbackMessageEvent);
begin
  FOnMsgProc:= Value;
end;

procedure Tz3DEngine.SetOnResetDevice(const Value: Tz3DBaseCallbackEvent);
begin
  FOnResetDevice:= Value;
end;

function Tz3DEngine.GetDesktop: Iz3DDesktop;
begin
  Result:= FDesktop;
end;

procedure Tz3DEngine.StartScenario(const AStage: Tz3DStartScenarioStage);
const FTexts: array[Tz3DStartScenarioStage] of PWideChar = ('Creating scenario...', 'Creating scenario objects...',
  'Creating environment...', 'Creating environment objects...', 'Creating lighting system...');
begin
  if z3DEngine.Desktop.ProgressDialog <> nil then
  z3DEngine.Desktop.ProgressDialog.SetStatus(FTexts[AStage]);
  NotifyLinks_z3DStartScenario(AStage);
end;

function Tz3DEngine.GetAudioController: Iz3DAudioController;
begin
  Result:= FAudioController;
end;

function Tz3DEngine.GetRenderer: Iz3DRenderer;
begin
  Result:= FRenderer;
end;

function Tz3DEngine.GetWindow: HWND;
begin
  Result:= FWindow;
end;

procedure Tz3DEngine.SetWindow(const Value: HWND);
begin
  FWindow:= Value;
  if z3DCore_GetState.z3DInitCalled then z3DCore_SetWindow(Value, Value, Value);
end;

procedure Tz3DEngine.ShowSettingsDialog;
begin
  FSettingsDialog.Visible:= True;
end;

{ Tz3DDevice }

constructor Tz3DDevice.Create;
begin
  inherited Create;
  FDisplayREFWarning:= True;
  z3DCore_SetCallback_DeviceCreated(GOnCreateDevice);
  z3DCore_SetCallback_DeviceDestroyed(GOnDestroyDevice);
  z3DCore_SetCallback_DeviceLost(GOnLostDevice);
  z3DCore_SetCallback_DeviceReset(GOnResetDevice);
  FEngineCaps:= Tz3DDeviceEngineCaps.Create(Self);
  SetFullScreen(True);
end;

destructor Tz3DDevice.Destroy;
begin
  FEngineCaps:= nil;
  inherited;
end;

procedure Tz3DDevice.CreateDevice;
var FRect: TRect;
begin
  GetClientRect(z3DEngine.Window, FRect);
  z3DCore_CreateDevice(D3DADAPTER_DEFAULT, True, FRect.Right-FRect.Left,
  FRect.Bottom-FRect.Top, GIsDeviceAcceptable, GModifyDevice);
end;

procedure Tz3DDevice.SetFullScreen(const Value: Boolean);
begin
  if FFullScreen <> Value then
  begin
    FFullScreen:= Value;
    if z3DCore_GetState.InsideMainloop then
    begin
      z3DCore_Pause(True, True);
      z3DCore_ToggleFullScreen;
      z3DCore_Pause(False, False);
    end else z3DCore_GetState.OverrideFullScreen:= Value;
  end;
end;

procedure Tz3DDevice.ToggleFullScreen;
begin
  FullScreen:= not FullScreen;
end;

procedure Tz3DDevice.ToggleREF;
begin
  z3DCore_ToggleREF;
end;

function Tz3DDevice.Created: Boolean;
begin
  Result:= z3DCore_GetD3DDevice <> nil;
end;

function Tz3DDevice.GetDisplayREFWarning: Boolean;
begin
  Result:= FDisplayREFWarning;
end;

function Tz3DDevice.GetFullScreen: Boolean;
begin
  Result:= FFullScreen;
end;

procedure Tz3DDevice.SetDisplayREFWarning(const Value: Boolean);
begin
  FDisplayREFWarning:= Value;
end;

function Tz3DDevice.GetEngineCaps: Iz3DDeviceEngineCaps;
begin
  Result:= FEngineCaps;
end;

{ Tz3DStats }

constructor Tz3DStats.Create;
begin
  inherited Create;

  // Link this object to all the events generated by the z3D Engine
  Notifications:= [z3dlnDevice];

  FShowFPS:= False;
  FShowDevice:= False;
  FShowDisplay:= False;
  FShowView:= False;
  FShowRenderer:= False;
end;

procedure Tz3DStats.z3DCreateDevice;
begin
  // Initialize the font
  if FAILED(D3DXCreateFont(z3DCore_GetD3DDevice, z3DFontHeight(10), 0,
  FW_BOLD, 1, FALSE, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS,
  DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, 'Courier New', FD3DXFont)) then
  begin
    z3DTrace('Iz3DStats.CreateFont failed: D3DXCreateFont failed. Stats will not be rendered', z3DtkWarning);
    Exit;
  end;
  FHelper:= z3DCreateTextHelper(FD3DXFont, FD3DXSprite, z3DFontHeight(10));
end;

destructor Tz3DStats.Destroy;
begin
  inherited;
end;

procedure Tz3DStats.z3DDestroyDevice;
begin
  SafeRelease(FD3DXFont);
  FHelper:= nil;
end;

procedure Tz3DStats.FrameRender;
const FBools: array[Boolean] of string = ('No', 'Yes');
var I: Integer;
begin
  if (FHelper = nil) or (not FShowDevice and not FShowDisplay and not FShowFPS) then Exit;

  FHelper.BeginRender;
  for I:= 0 to 1 do
  begin
    // Prepare the text helper
    if I = 0 then
    begin
      FHelper.SetInsertionPos(4, 4);
      FHelper.SetForegroundColor(z3DD3DXColor(z3DFloat3));
    end else
    begin
      FHelper.SetInsertionPos(3, 3);
      FHelper.SetForegroundColor(D3DXColor(255, 255, 255, 255));
    end;


    // Draw the core stats
    if GTest then FHelper.DrawTextLine(PAnsiChar(z3DDS(z3DMESSAGE_2DTEXT)));
    if FShowDevice then FHelper.DrawTextLine(z3DCore_GetState.DeviceStats);
    if FShowDisplay then FHelper.DrawTextLine(z3DCore_GetFrameStats);
    if FShowFPS then FHelper.DrawTextLine(z3DCore_GetState.FPSStats);

    // Draw the view stats
    if FShowView then
    begin
      FHelper.DrawTextLine('');
      FHelper.DrawTextLine('  View information');
      FHelper.DrawTextLine(PWideChar(WideString(('    Position: '+Float3ToText(z3DScenario.ViewFrustum.Position)))));
      FHelper.DrawTextLine(PWideChar(WideString(('    Look at:  '+Float3ToText(z3DFloat3.From(z3DScenario.ViewFrustum.LookAt).Subtract(z3DScenario.ViewFrustum.Position))))));
//      FHelper.DrawTextLine(PWideChar(WideString(('    Velocity: '+FormatFloat('0.00', z3DScenario.ViewFrustum.Velocity)))));
      FHelper.DrawTextLine('');
    end;

    // Draw the renderer stats
    if FShowRenderer then
    begin
      FHelper.DrawTextLine('');
      FHelper.DrawTextLine('  Renderer information');
      FHelper.DrawTextLine(PWideChar(WideString(('    Auto target clear: '+FBools[z3DEngine.Renderer.AutoClearTarget]))));
      FHelper.DrawTextLine(PWideChar(WideString(('    Auto depth clear:  '+FBools[z3DEngine.Renderer.AutoClearDepth]))));
      FHelper.DrawTextLine(PWideChar(WideString(('    HDR enabled:  '+FBools[z3DEngine.Renderer.HDRMode]))));
      FHelper.DrawTextLine(PWideChar(WideString(('    MSAA enabled: '+FBools[z3DEngine.Renderer.EnableMSAA]))));
      FHelper.DrawTextLine(PWideChar(WideString(('    MSAA samples: '+IntToStr(z3DEngine.Renderer.MSAASamples)))));
      FHelper.DrawTextLine(PWideChar(WideString(('    HW-Shadows:   '+FBools[z3DLightingController.UseHWShadows]))));
      FHelper.DrawTextLine('');
      FHelper.DrawTextLine('  Performance information');
      FHelper.DrawTextLine(PWideChar(WideString(('    BeginRender: '+IntToStr(FTimers[0])))));
      FHelper.DrawTextLine(PWideChar(WideString(('    Deferred:    '+IntToStr(FTimers[1])))));
      FHelper.DrawTextLine(PWideChar(WideString(('    BeginScene:  '+IntToStr(FTimers[2])))));
      FHelper.DrawTextLine(PWideChar(WideString(('    Scenario:    '+IntToStr(FTimers[3])))));
      FHelper.DrawTextLine(PWideChar(WideString(('    PostProcess: '+IntToStr(FTimers[4])))));
      FHelper.DrawTextLine(PWideChar(WideString(('    EndScene:    '+IntToStr(FTimers[5])))));
    end;
  end;

  FHelper.EndRender;
end;

procedure Tz3DStats.z3DLostDevice;
begin
  if FD3DXFont <> nil then FD3DXFont.OnLostDevice;
end;

procedure Tz3DStats.z3DResetDevice;
begin
  if FD3DXFont <> nil then FD3DXFont.OnResetDevice;
end;

function Tz3DStats.GetShowDevice: Boolean;
begin
  Result:= FShowDevice;
end;

function Tz3DStats.GetShowFPS: Boolean;
begin
  Result:= FShowFPS;
end;

function Tz3DStats.GetShowDisplay: Boolean;
begin
  Result:= FShowDisplay;
end;

procedure Tz3DStats.SetShowDevice(const Value: Boolean);
begin
  FShowDevice:= Value;
end;

procedure Tz3DStats.SetShowFPS(const Value: Boolean);
begin
  FShowFPS:= Value;
end;

procedure Tz3DStats.SetShowDisplay(const Value: Boolean);
begin
  FShowDisplay:= Value;
end;

function Tz3DStats.Float2ToText(const AFloat: Iz3DFloat2): string;
begin
  Result:= Format('[%f %f]', [AFloat.X, AFloat.Y]);
end;

function Tz3DStats.Float3ToText(const AFloat: Iz3DFloat3): string;
begin
  Result:= Format('[%f %f %f]', [AFloat.X, AFloat.Y, AFloat.Z]);
end;

function Tz3DStats.Float4ToText(const AFloat: Iz3DFloat4): string;
begin
  Result:= Format('[%f %f %f %f]', [AFloat.X, AFloat.Y, AFloat.Z, AFloat.W]);
end;

function Tz3DStats.GetShowView: Boolean;
begin
  Result:= FShowView;
end;

procedure Tz3DStats.SetShowView(const Value: Boolean);
begin
  FShowView:= Value;
end;

function Tz3DStats.GetShowRenderer: Boolean;
begin
  Result:= FShowRenderer;
end;

procedure Tz3DStats.SetShowRenderer(const Value: Boolean);
begin
  FShowRenderer:= Value;
end;

{ Tz3DEngineOptions }

constructor Tz3DEngineOptions.Create;
begin
  inherited;
  FExtendedEvents:= False;
  FShadowStencil:= True;
  FHandleDefaultHotkeys:= True;
  FShowFatalMessages:= True;
  FHandleWindowMessages:= True;
  FParseCommandLine:= True;
  FHandleAltEnter:= True;
  FClipCursorOnFullScreen:= True;
  FShowCursorOnFullScreen:= True;
  FLockAspectRatio:= True;
  FStretchToWindow:= False;
  FPlayIntro:= True;
  FPlayMusic:= True;
  z3DCore_SetCursorSettings(True, True);
end;

function Tz3DEngineOptions.GetClipCursorOnFullScreen: Boolean;
begin
  Result:= FClipCursorOnFullScreen;
end;

function Tz3DEngineOptions.GetExtendedEvents: Boolean;
begin
  Result:= FExtendedEvents;
end;

function Tz3DEngineOptions.GetHandleAltEnter: Boolean;
begin
  Result:= FHandleAltEnter;
end;

function Tz3DEngineOptions.GetHandleDefaultHotkeys: Boolean;
begin
  Result:= FHandleDefaultHotkeys;
end;

function Tz3DEngineOptions.GetHandleWindowMessages: Boolean;
begin
  Result:= FHandleWindowMessages;
end;

function Tz3DEngineOptions.GetLockAspectRatio: Boolean;
begin
  Result:= FLockAspectRatio;
end;

function Tz3DEngineOptions.GetParseCommandLine: Boolean;
begin
  Result:= FParseCommandLine;
end;

function Tz3DEngineOptions.GetPlayIntro: Boolean;
begin
  Result:= FPlayIntro;
end;

function Tz3DEngineOptions.GetPlayMusic: Boolean;
begin
  Result:= FPlayMusic;
end;

function Tz3DEngineOptions.GetShadowStencil: Boolean;
begin
  Result:= FShadowStencil;
end;

function Tz3DEngineOptions.GetShowCursorOnFullScreen: Boolean;
begin
  Result:= FShowCursorOnFullScreen;
end;

function Tz3DEngineOptions.GetShowFatalMessages: Boolean;
begin
  Result:= FShowFatalMessages;
end;

function Tz3DEngineOptions.GetStretchToWindow: Boolean;
begin
  Result:= FStretchToWindow;
end;

procedure Tz3DEngineOptions.SetClipCursorOnFullScreen(const Value: Boolean);
begin
  if FClipCursorOnFullScreen <> Value then
  begin
    FClipCursorOnFullScreen:= Value;
    z3DCore_SetCursorSettings(FShowCursorOnFullScreen, FClipCursorOnFullScreen);
  end;
end;

procedure Tz3DEngineOptions.SetExtendedEvents(const Value: Boolean);
begin
  FExtendedEvents:= Value;
end;

procedure Tz3DEngineOptions.SetHandleAltEnter(const Value: Boolean);
begin
  FHandleAltEnter:= Value;
  z3DCore_GetState.HandleAltEnter:= Value;
end;

procedure Tz3DEngineOptions.SetHandleDefaultHotkeys(const Value: Boolean);
begin
  FHandleDefaultHotkeys:= Value;
  z3DCore_GetState.HandleDefaultHotkeys:= Value;
end;

procedure Tz3DEngineOptions.SetHandleWindowMessages(const Value: Boolean);
begin
  FHandleWindowMessages:= Value;
end;

procedure Tz3DEngineOptions.SetLockAspectRatio(const Value: Boolean);
begin
  if FLockAspectRatio <> Value then
  begin
    FLockAspectRatio:= Value;
    z3DEngine.Scenario.ProjectionChanged:= True;
  end;
end;

procedure Tz3DEngineOptions.SetParseCommandLine(const Value: Boolean);
begin
  FParseCommandLine:= Value;
end;

procedure Tz3DEngineOptions.SetPlayIntro(const Value: Boolean);
begin
  FPlayIntro:= Value;
end;

procedure Tz3DEngineOptions.SetPlayMusic(const Value: Boolean);
begin
  FPlayMusic:= Value;
end;

procedure Tz3DEngineOptions.SetShadowStencil(const Value: Boolean);
begin
  FShadowStencil:= Value;
end;

procedure Tz3DEngineOptions.SetShowCursorOnFullScreen(const Value: Boolean);
begin
  if FShowCursorOnFullScreen <> Value then
  begin
    FShowCursorOnFullScreen:= Value;
    z3DCore_SetCursorSettings(FShowCursorOnFullScreen, FClipCursorOnFullScreen);
  end;
end;

procedure Tz3DEngineOptions.SetShowFatalMessages(const Value: Boolean);
begin
  FShowFatalMessages:= Value;
end;

procedure Tz3DEngineOptions.SetStretchToWindow(const Value: Boolean);
begin
  FStretchToWindow:= Value;
end;

{ Tz3DDebugHelper }

constructor Tz3DDebugHelper.Create;
begin
  inherited;
  FEnableGrid:= False;
  FGridSize:= 10;
  FGridSpace:= 1;
  FEnableLightMesh:= False;
end;

procedure Tz3DDebugHelper.CreateGridMesh;
begin
  if (FGridMesh = nil) and FEnableGrid then
  D3DXCreateBox(z3DCore_GetD3DDevice, 1, 1, 1, FGridMesh, nil);
end;

procedure Tz3DDebugHelper.CreateLightMesh;
begin
  if (FLightMesh = nil) and FEnableLightMesh then
  D3DXCreateSphere(z3DCore_GetD3DDevice, 1, 32, 32, FLightMesh, nil);
end;

procedure Tz3DDebugHelper.RenderGridMesh;
var X, Y, Z: Integer;
    FFillSaved: Cardinal;
    FW, FS: Iz3DMatrix;
    FMaterial: TD3DMaterial9;
begin
{  CreateGridMesh;
  z3DCore_GetD3DDevice.GetRenderState(D3DRS_FILLMODE, FFillSaved);
  FMaterial.Diffuse.r:= 255;
  FMaterial.Diffuse.g:= 255;
  FMaterial.Diffuse.b:= 255;
  FMaterial.Diffuse.a:= 255;
  z3DCore_GetD3DDevice.SetMaterial(FMaterial);
  FW:= z3DMatrix;
  FS:= z3DMatrix;
  try
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_FILLMODE, D3DFILL_WIREFRAME);
    for X:= -(FGridSize div 2) to (FGridSize div 2) do
    for Y:= -(FGridSize div 2) to (FGridSize div 2) do
    begin
      FW.Translation(X*FGridSpace/0.00001, Y*FGridSpace/0.00001, 0);
      FS.Scale(0.00001, 0.00001, FGridSize*FGridSpace).Multiply(FW);
      z3DCore_GetD3DDevice.SetTransform(D3DTS_WORLD, FS.D3DMatrix);
      FGridMesh.DrawSubset(0);
    end;
    for Z:= -(FGridSize div 2) to (FGridSize div 2) do
    for Y:= -(FGridSize div 2) to (FGridSize div 2) do
    begin
      FW.Translation(0, Y*FGridSpace/0.00001, Z*FGridSpace/0.00001);
      FS.Scale(FGridSize*FGridSpace, 0.00001, 0.00001).Multiply(FW);
      z3DCore_GetD3DDevice.SetTransform(D3DTS_WORLD, FS.D3DMatrix);
      FGridMesh.DrawSubset(0);
    end;
    for Z:= -(FGridSize div 2) to (FGridSize div 2) do
    for X:= -(FGridSize div 2) to (FGridSize div 2) do
    begin
      FW.Translation(X*FGridSpace/0.00001, 0, Z*FGridSpace/0.00001);
      FS.Scale(0.00001, FGridSize*FGridSpace, 0.00001).Multiply(FW);
      z3DCore_GetD3DDevice.SetTransform(D3DTS_WORLD, FS.D3DMatrix);
      FGridMesh.DrawSubset(0);
    end;
  finally
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_FILLMODE, FFillSaved);
  end;}
end;

procedure Tz3DDebugHelper.FrameRender;
begin
  if FEnableGrid then RenderGridMesh;
end;

procedure Tz3DDebugHelper.z3DResetDevice;
begin
  CreateGridMesh;
  CreateLightMesh;
end;

function Tz3DDebugHelper.GetEnableGrid: Boolean;
begin
  Result:= FEnableGrid;
end;

function Tz3DDebugHelper.GetEnableLightMesh: Boolean;
begin
  Result:= FEnableLightMesh;
end;

function Tz3DDebugHelper.GetGridSize: Integer;
begin
  Result:= FGridSize;
end;

function Tz3DDebugHelper.GetGridSpace: Single;
begin
  Result:= FGridSpace;
end;

procedure Tz3DDebugHelper.SetEnableGrid(const Value: Boolean);
begin
  FEnableGrid:= Value;
end;

procedure Tz3DDebugHelper.SetEnableLightMesh(const Value: Boolean);
begin
  FEnableLightMesh:= Value;
end;

procedure Tz3DDebugHelper.SetGridSize(const Value: Integer);
begin
  FGridSize:= Value;
end;

procedure Tz3DDebugHelper.SetGridSpace(const Value: Single);
begin
  FGridSpace:= Value;
end;

{ Tz3DPostProcessEffects }

procedure Tz3DPostProcessEffects.CheckSharedResources;
begin
  FSceneScaledTex.Enabled:= Bloom.Enabled or DepthOfField.Enabled;
end;

constructor Tz3DPostProcessEffects.Create;
begin
  inherited;

  // Link this object to the desired events generated by the z3D Engine
  Notifications:= [z3dlnDevice];

  FBloom:= Tz3DBloomEffect.Create(Self);
  FColorCorrection:= Tz3DColorCorrectionEffect.Create;
  FDepthOfField:= Tz3DDepthOfFieldEffect.Create(Self);
  FMotionBlur:= Tz3DMotionBlurEffect.Create;
  FToneMapping:= Tz3DToneMappingEffect.Create;
  FSceneScaledTex:= z3DCreateRenderTexture;
  FSceneScaledTex.AutoWidthFactor:= 1/4;
  FSceneScaledTex.AutoHeightFactor:= 1/4;
  FSceneScaledTex.AutoFormat:= z3dsafRenderer;
  FSceneScaledTex.Enabled:= False;
end;

destructor Tz3DPostProcessEffects.Destroy;
begin
  FBloom:= nil;
  FColorCorrection:= nil;
  FDepthOfField:= nil;
  FMotionBlur:= nil;
  FToneMapping:= nil;
  inherited;
end;

procedure Tz3DPostProcessEffects.z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller);
begin
  inherited;
  CheckSharedResources;
  FColorCorrection.CreateScenarioObjects;
  FToneMapping.CreateScenarioObjects;
  FBloom.CreateScenarioObjects;
  FDepthOfField.CreateScenarioObjects;
  FMotionBlur.CreateScenarioObjects;
end;

procedure Tz3DPostProcessEffects.FrameMove;
begin
  FToneMapping.FrameMove;
  FDepthOfField.FrameMove;
  FMotionBlur.FrameMove;
end;

procedure Tz3DPostProcessEffects.FrameRender;
begin
  FColorCorrection.FrameRender;

  if FBloom.Enabled or FDepthOfField.Enabled then
  z3DEngine.Renderer.DownScale(FSceneScaledTex);

  FDepthOfField.FrameRender;

  FBloom.FrameRender;
  FToneMapping.FrameRender;

  FMotionBlur.FrameRender;
end;

function Tz3DPostProcessEffects.GetBloom: Iz3DBloomEffect;
begin
  Result:= FBloom;
end;

function Tz3DPostProcessEffects.GetColorCorrection: Iz3DColorCorrectionEffect;
begin
  Result:= FColorCorrection;
end;

function Tz3DPostProcessEffects.GetDepthOfField: Iz3DDepthOfFieldEffect;
begin
  Result:= FDepthOfField;
end;

function Tz3DPostProcessEffects.GetMotionBlur: Iz3DMotionBlurEffect;
begin
  Result:= FMotionBlur;
end;

function Tz3DPostProcessEffects.GetSceneScaledTexture: Iz3DRenderTexture;
begin
  Result:= FSceneScaledTex;
end;

function Tz3DPostProcessEffects.GetToneMapping: Iz3DToneMappingEffect;
begin
  Result:= FToneMapping;
end;

{ Tz3DBloomEffect }

constructor Tz3DBloomEffect.Create(const AOwner: Iz3DPostProcessEffects);
begin
  inherited Create;
  FEffects:= AOwner;
  FEnabled:= True;
  FIntensity:= 1;
  FBrightPassTex:= z3DCreateRenderTexture;
  FBrightPassTex.AutoWidthFactor:= 0.25;
  FBrightPassTex.AutoHeightFactor:= 0.25;
  FBrightPassTex.Format:= D3DFMT_A8R8G8B8;
  FBrightPassTex.Enabled:= False;
  FBloomTex[0]:= z3DCreateRenderTexture;
  FBloomTex[0].AutoWidthFactor:= 0.125;
  FBloomTex[0].AutoHeightFactor:= 0.125;
  FBloomTex[0].Format:= D3DFMT_A8R8G8B8;
  FBloomTex[0].SamplerState.Filter:= z3dsfTrilinear;
  FBloomTex[0].Enabled:= False;
  FBloomTex[1]:= z3DCreateRenderTexture;
  FBloomTex[1].AutoWidthFactor:= 0.125;
  FBloomTex[1].AutoHeightFactor:= 0.125;
  FBloomTex[1].Format:= D3DFMT_A8R8G8B8;
  FBloomTex[1].Enabled:= False;
  FBloomTex[2]:= z3DCreateRenderTexture;
  FBloomTex[2].AutoWidthFactor:= 0.125;
  FBloomTex[2].AutoHeightFactor:= 0.125;
  FBloomTex[2].Format:= D3DFMT_A8R8G8B8;
  FBloomTex[2].Enabled:= False;
  FShader:= z3DCreateShader;
  FShader.FileName:= PWideChar(WideString(Z3DRES_BLOOM_EFFECT));
  FShader.Enabled:= False;
  FThreshold:= 0.95;
  FFoggyFactor:= 0.035;
end;

procedure Tz3DBloomEffect.RenderBloom;
begin
  FShader.Technique:= 'z3DBloom_BloomPass1';
  z3DEngine.Renderer.PostProcess(FBloomTex[1], [FBloomTex[2]], FShader);
  FShader.Technique:= 'z3DBloom_BloomPass2';
  z3DEngine.Renderer.PostProcess(FBloomTex[0], [FBloomTex[1]], FShader);
end;

procedure Tz3DBloomEffect.RenderBrightPass;
begin
  FShader.Technique:= FBrightPassValidTechnique;
  z3DEngine.Renderer.PostProcess(FBrightPassTex, [FEffects.SceneScaledTexture], FShader);
end;

procedure Tz3DBloomEffect.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    if z3DEngine.Scenario.Enabled then
    begin
      EnableResources;
      FEffects.CheckSharedResources;
    end;
    FEnabled:= Value;
    if z3DEngine.Scenario.Enabled then
    begin
      CreateScenarioObjects;
      FEffects.CheckSharedResources;
    end;
  end;
end;

procedure Tz3DBloomEffect.FrameRender;
begin
  if not Enabled then Exit;
  RenderBrightPass;
  z3DRenderGaussBlur(FBrightPassTex, FBloomTex[2]);
  RenderBloom;
  FShader.Technique:= 'z3DBloom_Blend';
  z3DEngine.Renderer.PostProcess_Blend([FBloomTex[0]], FShader);
end;

procedure Tz3DBloomEffect.SetIntensity(const Value: Single);
begin
  if FIntensity <> Value then
  begin
    FIntensity:= Value;
    if FShader.D3DXEffect <> nil then FShader.Param['GBloomIntensity']:= FIntensity;
  end;
end;

procedure Tz3DBloomEffect.SetThreshold(const Value: Single);
begin
  if FThreshold <> Value then
  begin
    FThreshold:= Value;
    if FShader.D3DXEffect <> nil then FShader.Param['GBloomThreshold']:= FThreshold;
  end;
end;

function Tz3DBloomEffect.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

function Tz3DBloomEffect.GetIntensity: Single;
begin
  Result:= FIntensity;
end;

function Tz3DBloomEffect.GetThreshold: Single;
begin
  Result:= FThreshold;
end;

procedure Tz3DBloomEffect.CreateScenarioObjects;
var FISampleOffsets: array[0..15] of Single;
    I: Integer;
begin
  EnableResources;
  if not Enabled then Exit;

  if z3DEngine.Renderer.HDRMode then
  FBrightPassValidTechnique:= 'z3DBloom_BrightPassFilterHDR' else
  FBrightPassValidTechnique:= 'z3DBloom_BrightPassFilter';
  z3DGetBloomSO(FBloomTex[1].Width, FISampleOffsets, FBloomSampleWeights, 3, 2);
  FShader.SetPointer('GSampleWeights', @FBloomSampleWeights, SizeOf(FBloomSampleWeights));
  for I:= 0 to 15 do FBloomPass1SampleOffsets[I]:= D3DXVector2(FISampleOffsets[I], 0);
  for I:= 0 to 15 do FBloomPass2SampleOffsets[I]:= D3DXVector2(0, FISampleOffsets[I]);
  FShader.Param['GBloomIntensity']:= FIntensity;
  FShader.Param['GBloomThreshold']:= FThreshold;
  FShader.Param['GBloomFoggy']:= FFoggyFactor;
  FShader.SetPointer('GPass1SampleOffsets', @FBloomPass1SampleOffsets, SizeOf(FBloomPass1SampleOffsets));
  FShader.SetPointer('GPass2SampleOffsets', @FBloomPass2SampleOffsets, SizeOf(FBloomPass2SampleOffsets));
end;

function Tz3DBloomEffect.GetFoggyFactor: Single;
begin
  Result:= FFoggyFactor;
end;

procedure Tz3DBloomEffect.SetFoggyFactor(const Value: Single);
begin
  if FFoggyFactor <> Value then
  begin
    FFoggyFactor:= Value;
    if FShader.D3DXEffect <> nil then FShader.Param['GBloomFoggy']:= FFoggyFactor;
  end;
end;

procedure Tz3DBloomEffect.EnableResources;
begin
  FBrightPassTex.Enabled:= FEnabled;
  FBloomTex[0].Enabled:= FEnabled;
  FBloomTex[1].Enabled:= FEnabled;
  FBloomTex[2].Enabled:= FEnabled;
  FShader.Enabled:= FEnabled;
end;

{ Tz3DDepthOfFieldEffect }

constructor Tz3DDepthOfFieldEffect.Create(const AOwner: Iz3DPostProcessEffects);
begin
  inherited Create;
  FEffects:= AOwner;
  FAdjustmentSpeed:= 10;
  FFocusSpread:= 0.1;
  FAmount:= 1;
  FAutoFocusDepth:= True;
  FEnabled:= False;
  FFocusDepth:= 2;
  FDepthTex:= z3DCreateRenderTexture;
  FDepthTex.AutoParams:= False;
  FDepthTex.Width:= 1;
  FDepthTex.Height:= 1;
  FDepthTex.AutoFormat:= z3dsafFP;
  FDepthTex.Enabled:= False;
  FLastDepthTex:= z3DCreateRenderTexture;
  FLastDepthTex.AutoParams:= False;
  FLastDepthTex.Width:= 1;
  FLastDepthTex.Height:= 1;
  FLastDepthTex.AutoFormat:= z3dsafFP;
  FLastDepthTex.Enabled:= False;
  FBlurValuesTex:= z3DCreateRenderTexture;
  FBlurValuesTex.AutoFormat:= z3dsafFP;
  FBlurValuesTex.Enabled:= False;
  FQuality:= z3ddofqLow;
  FFinalBlurTex:= z3DCreateRenderTexture;
  FFinalBlurTex.AutoWidthFactor:= 1/4;
  FFinalBlurTex.AutoHeightFactor:= 1/4;
  FFinalBlurTex.AutoFormat:= z3dsafRenderer;
  FFinalBlurTex.SamplerState.Filter:= z3dsfLinear;
  FFinalBlurTex.Enabled:= False;
  FShader:= z3DCreateShader;
  FShader.FileName:= PWideChar(WideString(Z3DRES_DEPTHOFFIELD_EFFECT));
  FShader.Enabled:= False;
end;

procedure Tz3DDepthOfFieldEffect.FrameMove;
begin
  if not Enabled then Exit;
  if z3DEngine.Desktop.Visible then FShader.Param['GAdjustmentSpeed']:= 0 else
  FShader.Param['GAdjustmentSpeed']:= FAdjustmentSpeed * (1 - Power(0.98, 30 * z3DCore_GetElapsedTime));
end;

procedure Tz3DDepthOfFieldEffect.FrameRender;
var FTemp: Iz3DRenderTexture;
begin
  if not Enabled then Exit;

  // Compute focus depth over time
  FTemp:= FLastDepthTex;
  FLastDepthTex:= FDepthTex;
  FDepthTex:= FTemp;

  // Generate a blurred version of the scene
  z3DRenderGaussBlur(FEffects.SceneScaledTexture, FFinalBlurTex);

  // Render the current depth focus value
  if FAutoFocusDepth then FShader.Technique:= 'z3DDepthOfField_CopyDepth' else
  begin
    FShader.Technique:= 'z3DDepthOfField_CopyDepthManual';
    FShader.Param['GManualFocusDepth']:= FFocusDepth / (z3DEngine.Scenario.ViewFrustum.FarClip * 0.1);
  end;
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED);
  try
    z3DEngine.Renderer.PostProcess(FDepthTex, [FLastDepthTex], FShader);
  finally
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED or D3DCOLORWRITEENABLE_GREEN or
      D3DCOLORWRITEENABLE_BLUE or D3DCOLORWRITEENABLE_ALPHA);
  end;

  if (FQuality <> z3ddofqLow) and (z3DEngine.Device.EngineCaps.ShaderModel3Supported) then
  begin
    // Convert depth values to blur amounts
    FShader.Technique:= 'z3DDepthOfField_DepthToBlur';
    z3DEngine.Renderer.PostProcess(FBlurValuesTex, [FDepthTex], FShader);

    // Blend the scene with the blurred version based on depth
    if FQuality = z3ddofqMid then
    FShader.Technique:= 'z3DDepthOfField_DepthOfFieldMQ' else
    FShader.Technique:= 'z3DDepthOfField_DepthOfFieldHQ';
    z3DEngine.Renderer.PostProcess_Blend([FFinalBlurTex, FBlurValuesTex], FShader);
  end else
  begin
    // Blend the scene with the blurred version based on depth
    FShader.Technique:= 'z3DDepthOfField_DepthOfFieldLQ';
    z3DEngine.Renderer.PostProcess_Blend([FFinalBlurTex, FDepthTex], FShader);
  end;
end;

procedure Tz3DDepthOfFieldEffect.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    if z3DEngine.Scenario.Enabled then
    begin
      EnableResources;
      FEffects.CheckSharedResources;
    end;
    FEnabled:= Value;
    if z3DEngine.Scenario.Enabled then
    begin
      CreateScenarioObjects;
      FEffects.CheckSharedResources;
    end;
  end;
end;

function Tz3DDepthOfFieldEffect.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

function Tz3DDepthOfFieldEffect.GetFocusDepth: Single;
begin
  Result:= FFocusDepth;
end;

procedure Tz3DDepthOfFieldEffect.SetFocusDepth(const Value: Single);
begin
  FFocusDepth:= Value;
end;

procedure Tz3DDepthOfFieldEffect.CreateScenarioObjects;
var FCropWidth, FCropHeight: Integer;
begin
  EnableResources;
  if not Enabled then Exit;

  FCropWidth:= z3DCore_GetBackBufferSurfaceDesc.Width-z3DCore_GetBackBufferSurfaceDesc.Width mod 8;
  FCropHeight:= z3DCore_GetBackBufferSurfaceDesc.Height-z3DCore_GetBackBufferSurfaceDesc.Height mod 8;
  FShader.Float4['GPixelSize']:= z3DFloat4(1 / z3DCore_GetBackBufferSurfaceDesc.Width,
  1 / z3DCore_GetBackBufferSurfaceDesc.Height, 4 * (1 / FCropWidth), 4 * (1 / FCropHeight));
  FShader.Param['GFocusSpread']:= FFocusSpread;
  FShader.Param['GAmount']:= FAmount;
  FShader.Param['GManualFocusDepth']:= FFocusDepth;
  FShader.Param['GAdjustmentSpeed']:= FAdjustmentSpeed;
  FShader.Param['GFarFocus']:= z3DEngine.Scenario.ViewFrustum.FarClip * 0.1;
end;

function Tz3DDepthOfFieldEffect.GetAutoFocusDepth: Boolean;
begin
  Result:= FAutoFocusDepth;
end;

procedure Tz3DDepthOfFieldEffect.SetAutoFocusDepth(const Value: Boolean);
begin
  FAutoFocusDepth:= Value;
end;

function Tz3DDepthOfFieldEffect.GetAmount: Single;
begin
  Result:= FAmount;
end;

procedure Tz3DDepthOfFieldEffect.SetAmount(const Value: Single);
begin
  FAmount:= Value;
  if FShader.D3DXEffect <> nil then FShader.Param['GAmount']:= Value;
end;

function Tz3DDepthOfFieldEffect.GetFocusSpread: Single;
begin
  Result:= FFocusSpread;
end;

procedure Tz3DDepthOfFieldEffect.SetFocusSpread(const Value: Single);
begin
  FFocusSpread:= Value;
  if FShader.D3DXEffect <> nil then FShader.Param['GFocusSpread']:= Value;
end;

function Tz3DDepthOfFieldEffect.GetAdjustmentSpeed: Single;
begin
  Result:= FAdjustmentSpeed;
end;

procedure Tz3DDepthOfFieldEffect.SetAdjustmentSpeed(const Value: Single);
begin
  FAdjustmentSpeed:= Value;
  if FShader.D3DXEffect <> nil then FShader.Param['GAdjustmentSpeed']:= Value;
end;

procedure Tz3DDepthOfFieldEffect.EnableResources;
begin
  FDepthTex.Enabled:= FEnabled;
  FBlurValuesTex.Enabled:= FEnabled;
  FLastDepthTex.Enabled:= FEnabled;
  FFinalBlurTex.Enabled:= FEnabled;
  FShader.Enabled:= FEnabled;
end;

function Tz3DDepthOfFieldEffect.GetQuality: Tz3DDepthOfFieldQuality;
begin
  Result:= FQuality;
end;

procedure Tz3DDepthOfFieldEffect.SetQuality(const Value: Tz3DDepthOfFieldQuality);
begin
  FQuality:= Value;
end;

{ Tz3DToneMappingEffect }

constructor Tz3DToneMappingEffect.Create;
begin
  inherited;
  FEnabled:= True;
  FAdjustmentSpeed:= 0.25;
  FAdjustmentFactor:= 0.4;
  FMiddleTone:= 0.5;
  FToneRangeMin:= 0.75;
  FToneRangeMax:= 100.0;
  FRenderAdaptation:= z3DCreateRenderTexture;
  FRenderAdaptation.AutoParams:= False;
  FRenderAdaptation.Width:= 1;
  FRenderAdaptation.Height:= 1;
  FRenderAdaptation.AutoFormat:= z3dsafFP;
  FRenderAdaptation.Enabled:= False;
  FLastAdaptation:= z3DCreateRenderTexture;
  FLastAdaptation.Width:= 1;
  FLastAdaptation.Height:= 1;
  FLastAdaptation.AutoFormat:= z3dsafFP;
  FLastAdaptation.Enabled:= False;
  FShader:= z3DCreateShader;
  FShader.FileName:= PWideChar(WideString(Z3DRES_TONEMAPPING_EFFECT));
  FShader.Enabled:= False;
end;

procedure Tz3DToneMappingEffect.FrameMove;
begin
  if not Enabled then Exit;
  if z3DEngine.Desktop.Visible then FShader.Param['GAdjustmentSpeed']:= 0 else
  FShader.Param['GAdjustmentSpeed']:= FAdjustmentSpeed * (1 - Power(0.98, 30 * z3DCore_GetElapsedTime));
end;

procedure Tz3DToneMappingEffect.FrameRender;
var FTemp: Iz3DRenderTexture;
begin
  if not Enabled then Exit;
  FShader.Technique:= 'z3DToneMapping_ToneMapping';
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED);
  try
    z3DEngine.Renderer.PostProcess(FRenderAdaptation, [FLastAdaptation], FShader);
  finally
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED or D3DCOLORWRITEENABLE_GREEN or
      D3DCOLORWRITEENABLE_BLUE or D3DCOLORWRITEENABLE_ALPHA);
  end;
  FTemp:= FLastAdaptation;
  FLastAdaptation:= FRenderAdaptation;
  FRenderAdaptation:= FTemp;
  FShader.Technique:= 'z3DToneMapping_Blend';
  z3DEngine.Renderer.PostProcess_Blend([FRenderAdaptation], FShader);
end;

procedure Tz3DToneMappingEffect.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    if z3DEngine.Scenario.Enabled then EnableResources;
    FEnabled := Value;
    if z3DEngine.Scenario.Enabled then CreateScenarioObjects;
  end;
end;

function Tz3DToneMappingEffect.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

procedure Tz3DToneMappingEffect.CreateScenarioObjects;
var FColor: Integer;
begin
  EnableResources;
  if not FEnabled then Exit;

  FColor:= Round(FMiddleTone*255);
  z3DClearTexture(FLastAdaptation.D3DTexture, RGB(FColor, FColor, FColor));
  z3DClearTexture(FRenderAdaptation.D3DTexture, RGB(FColor, FColor, FColor));
  FShader.Param['GAdjustmentSpeed']:= FAdjustmentSpeed;
  FShader.Param['GAdjustmentFactor']:= FAdjustmentFactor;
  FShader.Param['GMiddleTone']:= FMiddleTone;
  FShader.Param['GToneRangeMin']:= FToneRangeMin;
  FShader.Param['GToneRangeMax']:= FToneRangeMax;
end;

function Tz3DToneMappingEffect.GetAdjustmentFactor: Single;
begin
  Result:= FAdjustmentFactor;
end;

function Tz3DToneMappingEffect.GetAdjustmentSpeed: Single;
begin
  Result:= FAdjustmentSpeed;
end;

function Tz3DToneMappingEffect.GetMiddleTone: Single;
begin
  Result:= FMiddleTone;
end;

function Tz3DToneMappingEffect.GetToneRangeMax: Single;
begin
  Result:= FToneRangeMax;
end;

function Tz3DToneMappingEffect.GetToneRangeMin: Single;
begin
  Result:= FToneRangeMin;
end;

procedure Tz3DToneMappingEffect.SetAdjustmentFactor(const Value: Single);
begin
  FAdjustmentFactor:= Value;
  if FShader.D3DXEffect <> nil then FShader.Param['GAdjustmentFactor']:= Value;
end;

procedure Tz3DToneMappingEffect.SetAdjustmentSpeed(const Value: Single);
begin
  FAdjustmentSpeed:= Value;
  if FShader.D3DXEffect <> nil then FShader.Param['GAdjustmentSpeed']:= Value;
end;

procedure Tz3DToneMappingEffect.SetMiddleTone(const Value: Single);
begin
  FMiddleTone:= Value;
  if FShader.D3DXEffect <> nil then FShader.Param['GMiddleTone']:= Value;
end;

procedure Tz3DToneMappingEffect.SetToneRangeMax(const Value: Single);
begin
  FToneRangeMax:= Value;
  if FShader.D3DXEffect <> nil then FShader.Param['GRangeMax']:= Value;
end;

procedure Tz3DToneMappingEffect.SetToneRangeMin(const Value: Single);
begin
  FToneRangeMin:= Value;
  if FShader.D3DXEffect <> nil then FShader.Param['GRangeMin']:= Value;
end;

procedure Tz3DToneMappingEffect.EnableResources;
begin
  FRenderAdaptation.Enabled:= FEnabled;
  FLastAdaptation.Enabled:= FEnabled;
  FShader.Enabled:= FEnabled;
end;

{ Tz3DColorCorrectionEffect }

constructor Tz3DColorCorrectionEffect.Create;
begin
  inherited;
  FEnabled:= False;
  FMode:= z3dccmTonalize;
  FToneFactor:= z3DFloat3(1, 1, 1);
  FToneFactor.OnChange:= PropertyChanged;
  FShader:= z3DCreateShader;
  FShader.FileName:= PWideChar(WideString(Z3DRES_COLORCORRECTION_EFFECT));
  FShader.Enabled:= False;
end;

procedure Tz3DColorCorrectionEffect.FrameRender;
begin
  if not Enabled or z3DCore_GetState.RenderingPaused then Exit;
  z3DEngine.Renderer.PostProcess_Blend([z3DEngine.Renderer.LastRenderTexture], FShader);
end;

procedure Tz3DColorCorrectionEffect.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    if z3DEngine.Scenario.Enabled then EnableResources;
    FEnabled := Value;
    if z3DEngine.Scenario.Enabled then CreateScenarioObjects;
  end;
end;

function Tz3DColorCorrectionEffect.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

function Tz3DColorCorrectionEffect.GetMode: Tz3DColorCorrectionMode;
begin
  Result:= FMode;
end;

function Tz3DColorCorrectionEffect.GetToneFactor: Iz3DFloat3;
begin
  Result:= FToneFactor;
end;

procedure Tz3DColorCorrectionEffect.SetMode(const Value: Tz3DColorCorrectionMode);
begin
  FMode:= Value;
  if FShader.D3DXEffect <> nil then
  begin
    case FMode of
      z3dccmMonochromatic: FShader.SetTechnique('z3DColorCorrection_Monochromatic');
      z3dccmNegative: FShader.SetTechnique('z3DColorCorrection_Negative');
      z3dccmSepia: FShader.SetTechnique('z3DColorCorrection_Sepia');
      z3dccmTonalize: FShader.SetTechnique('z3DColorCorrection_Tonalize');
    end;
  end;
end;

procedure Tz3DColorCorrectionEffect.PropertyChanged(const ASender: Iz3DBase);
begin
  if Assigned(FShader.D3DXEffect) then FShader.Float3['GToneFactor']:= FToneFactor;
end;

procedure Tz3DColorCorrectionEffect.CreateScenarioObjects;
begin
  EnableResources;
  if not FEnabled then Exit;
  
  case FMode of
    z3dccmMonochromatic: FShader.SetTechnique('z3DColorCorrection_Monochromatic');
    z3dccmNegative: FShader.SetTechnique('z3DColorCorrection_Negative');
    z3dccmSepia: FShader.SetTechnique('z3DColorCorrection_Sepia');
    z3dccmTonalize: FShader.SetTechnique('z3DColorCorrection_Tonalize');
  end;
  FShader.Float3['GToneFactor']:= FToneFactor;
end;

procedure Tz3DColorCorrectionEffect.EnableResources;
begin
  FShader.Enabled:= FEnabled;
end;

{ Tz3DMotionBlurEffect }

constructor Tz3DMotionBlurEffect.Create;
begin
  inherited;
  FEnabled:= True;
  FAmount:= 0.75;
  FLastRender:= z3DCreateRenderTexture;
  FLastRender.Format:= D3DFMT_A8R8G8B8;
  FLastRender.Enabled:= False;
  FRenderSum:= z3DCreateRenderTexture;
  FRenderSum.Format:= D3DFMT_A8R8G8B8;
  FRenderSum.Enabled:= False;
  FShader:= z3DCreateShader;
  FShader.FileName:= PWideChar(WideString(Z3DRES_MOTIONBLUR_EFFECT));
  FShader.Enabled:= False;
end;

procedure Tz3DMotionBlurEffect.FrameMove;
var FVelocity: Single;
begin
  if not Enabled then Exit;
// TODO JP FRUSTUM  FVelocity:= z3DEngine.Renderer.ViewVelocity;
  if FVelocity < 0.001 then Exit;
  if z3DEngine.Desktop.Visible then FShader.Param['GAmount']:= 0 else
  FShader.Param['GAmount']:= FAmount * FVelocity * Power(0.98, 30 * z3DCore_GetElapsedTime);
end;

procedure Tz3DMotionBlurEffect.FrameRender;
var FTemp: Iz3DRenderTexture;
begin
  if not Enabled then Exit;
// TODO JP FRUSTUM  if z3DEngine.Renderer.ViewVelocity < 0.001 then Exit;
  FShader.Technique:= 'z3DMotionBlur_MotionBlur';
  z3DEngine.Renderer.PostProcess(FLastRender, [FRenderSum], FShader);
  FTemp:= FRenderSum;
  FRenderSum:= FLastRender;
  FLastRender:= FTemp;
  FShader.Technique:= 'z3DMotionBlur_Blend';
  z3DEngine.Renderer.PostProcess_Blend([FRenderSum], FShader);
end;

procedure Tz3DMotionBlurEffect.SetAmount(const Value: Single);
begin
  if FAmount <> Value then
  begin
    FAmount := Value;
  end;
end;

procedure Tz3DMotionBlurEffect.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    if z3DEngine.Scenario.Enabled then EnableResources;
    FEnabled := Value;
    if z3DEngine.Scenario.Enabled then CreateScenarioObjects;
  end;
end;

function Tz3DMotionBlurEffect.GetAmount: Single;
begin
  Result:= FAmount;
end;

function Tz3DMotionBlurEffect.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

procedure Tz3DMotionBlurEffect.CreateScenarioObjects;
begin
  EnableResources;
end;

procedure Tz3DMotionBlurEffect.EnableResources;
begin
  FLastRender.Enabled:= FEnabled;
  FRenderSum.Enabled:= FEnabled;
  FShader.Enabled:= FEnabled;
end;

{ Tz3DWinControl }

procedure Tz3DWinControl.z3DSetHandle(const AHandle: HWnd);
begin
  WindowHandle:= AHandle;
end;

{ Tz3DRenderer }

constructor Tz3DRenderer.Create;
begin
  inherited;

  // Link this object to all the events generated by the z3D Engine
  Notifications:= [z3dlnDevice, z3dlnFrameMove];
  ScenarioLevel:= False;

  FAutoClearTarget:= False;
  FAutoClearDepth:= True;
  FHDRMode:= True;
  FDefaultClearColor:= z3DFloat4;
  FDefaultClearDepth:= 1;
  FMSAASamples:= 1;
  FEnableMSAA:= False;
  FBlendTextures:= TInterfaceList.Create;
  FTargetMode:= z3dtmTexture;
  FRenderMode:= z3drm3D;
  FRendering:= False;
  FPostProcessBuffer:= z3DCreateVertexBuffer;
  FPostProcessBuffer.SetParams(4, D3DUSAGE_DYNAMIC or D3DUSAGE_WRITEONLY, D3DPOOL_DEFAULT);
  FPostProcessBuffer.Format.AddElement(0, z3dvefFloat4, z3dvemDefault, z3dveuTransformedPosition, 0);
  FPostProcessBuffer.Format.AddElement(0, z3dvefFloat2, z3dvemDefault, z3dveuTexCoord, 0);
  FPostProcessBuffer.ScenarioLevel:= False;
  FRenderTextures[0]:= z3DCreateRenderTexture;
  FRenderTextures[0].AutoFormat:= z3dsafRenderer;
  FRenderTextures[0].ScenarioLevel:= False;
  FRenderTextures[0].Enabled:= False;
  FRenderTextures[1]:= z3DCreateRenderTexture;
  FRenderTextures[1].AutoFormat:= z3dsafRenderer;
  FRenderTextures[1].ScenarioLevel:= False;
  FRenderTextures[1].Enabled:= False;
  FDepthBuffer:= z3DCreateDepthBuffer;
  FDepthBuffer.ScenarioLevel:= False;
  FDeferredBuffer:= z3DCreateRenderTexture;
  FDeferredBuffer.ScenarioLevel:= False;
  FDeferredBuffer.AutoParams:= False;
  FRenderTarget:= z3DCreateSurface;
  FRenderTarget.ScenarioLevel:= False;
  FBackBuffer:= z3DCreateSurface;
  FBackBuffer.ScenarioLevel:= False;
  FLastDepthBuffer:= z3DCreateDepthBuffer;
  FLastDepthBuffer.ScenarioLevel:= False;
  FTextureFilter:= z3dsfTrilinear;
  FAnisotropyLevel:= 1;  
end;

function Tz3DRenderer.GetHDRMode: Boolean;
begin
  Result:= FHDRMode;
end;

function Tz3DRenderer.GetTargetMode: Tz3DTargetMode;
begin
  Result:= FTargetMode;
end;

function Tz3DRenderer.GetRenderMode: Tz3DRenderMode;
begin
  Result:= FRenderMode;
end;

function Tz3DRenderer.GetRenderSurface: Iz3DSurface;
begin
  if RenderStage in [z3drsBackBuffer, z3drsGUI] then Result:= FBackBuffer else
  Result:= FRenderTextures[FRenderChainIndex].GetSurface;
end;

function Tz3DRenderer.GetRenderTexture: Iz3DRenderTexture;
begin
  Result:= FRenderTextures[FRenderChainIndex];
end;

procedure Tz3DRenderer.SetHDRMode(const Value: Boolean);
begin
  if FHDRMode <> Value then
  begin
    if z3DEngine.Device.Created and not z3DEngine.Device.EngineCaps.HDRSupport then
    FHDRMode:= False else FHDRMode:= Value;
    CreateRenderTarget;
    (z3DEngine.PostProcess as Iz3DLinked).z3DLostDevice;
    (z3DEngine.PostProcess as Iz3DLinked).z3DResetDevice;
  end;
end;

procedure Tz3DRenderer.SetTargetMode(const Value: Tz3DTargetMode);
begin
  if FTargetMode <> Value then
  begin
    FTargetMode:= Value;
    CreateRenderTarget;
  end;
end;

procedure Tz3DRenderer.SetRenderMode(const Value: Tz3DRenderMode);
begin
  if FRenderMode <> Value then
  begin
    FRenderMode:= Value;
    UpdateRenderMode;
  end;
end;

procedure Tz3DRenderer.CreateDeferredBuffer;
begin
  // Create the deferred texture
  if (z3DLightingController <> nil) and z3DLightingController.SSAO.Enabled and
  (z3DEngine.Device.EngineCaps.ShaderModel3Supported)
  and (z3DLightingController.SSAO.Quality = z3dssaoqHigh) and (z3DEngine.Device.EngineCaps.HDRSupport) then
  FDeferredBuffer.SetParams(z3DCore_GetState.BackBufferSurfaceDesc.Width,
  z3DCore_GetState.BackBufferSurfaceDesc.Height, 1, D3DFMT_A16B16G16R16F) else
  FDeferredBuffer.SetParams(z3DCore_GetState.BackBufferSurfaceDesc.Width,
  z3DCore_GetState.BackBufferSurfaceDesc.Height, 1, z3DEngine.Device.EngineCaps.FPFormat);
end;

procedure Tz3DRenderer.CreateRenderTarget;
var FSurface: IDirect3DSurface9;
begin
  if not z3DEngine.Device.Created or FSettingsChanging then Exit;

  // Create the render texture
  FRenderTextures[0].Enabled:= TargetMode = z3dtmTexture;
  FRenderTextures[1].Enabled:= TargetMode = z3dtmTexture;

  case TargetMode of

    // Set the back buffer as RT
    z3dtmBackBuffer:
    begin
      BackBuffer.SetRenderTarget;
      RenderSurface.From(BackBuffer);
    end;

    // TODO JP: Render target mode not implemented yet
    z3dtmRenderTarget:
    begin
      RenderTexture.D3DTexture:= nil;
      BackBuffer.SetRenderTarget;
      RenderSurface.From(BackBuffer);
    end;
  end;

  CreateDeferredBuffer;

  // Create a multisample render target if needed
  if EnableMSAA then
  begin
    if HDRMode then
    begin
      if FAILED(z3DCore_GetD3DDevice.CreateRenderTarget(z3DCore_GetBackBufferSurfaceDesc.Width, z3DCore_GetBackBufferSurfaceDesc.Height,
      D3DFMT_A16B16G16R16F, FMSAASamplesD3D[FMSAASamples], 0, False, FSurface, nil)) then
      z3DTrace('Iz3DRenderer.CreateRenderTarget: Could not create multisampled HDR render target', z3dtkError);
    end else
    begin
      if FAILED(z3DCore_GetD3DDevice.CreateRenderTarget(z3DCore_GetBackBufferSurfaceDesc.Width, z3DCore_GetBackBufferSurfaceDesc.Height,
      D3DFMT_A8R8G8B8, FMSAASamplesD3D[FMSAASamples], 0, False, FSurface, nil)) then
      z3DTrace('Iz3DRenderer.CreateRenderTarget: Could not create multisampled render target', z3dtkError);
    end;
    FRenderTarget.D3DSurface:= FSurface;
    FDepthBuffer.SetParams(z3DCore_GetBackBufferSurfaceDesc.Width, z3DCore_GetBackBufferSurfaceDesc.Height,
    z3DCore_GetDeviceSettings.PresentParams.AutoDepthStencilFormat, FMSAASamplesD3D[FMSAASamples], 0, False);
  end else
  begin
    FRenderTarget.D3DSurface:= nil;
    FDepthBuffer.D3DSurface:= nil;
    FLastDepthBuffer.D3DSurface:= nil;
  end;
end;

procedure Tz3DRenderer.UpdateRenderMode;
begin
  if RenderMode = z3drm2D then
  begin
    z3DCore_GetD3DDevice.GetRenderState(D3DRS_ZWRITEENABLE, FSavedZWrite);
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_ZENABLE, iFalse);
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_ZWRITEENABLE, iFalse);
  end else
  begin
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_ZENABLE, iTrue);
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_ZWRITEENABLE, FSavedZWrite);
  end;
end;

procedure Tz3DRenderer.z3DResetDevice;
var FSurface: IDirect3DSurface9;
begin
  // Set up the render states
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_LIGHTING, iFalse);
  if not z3DEngine.Device.EngineCaps.HDRSupport then HDRMode:= False;

  // Reset the sampler states
  ResetSamplerStates;

  // Save the back buffer
  z3DCore_GetD3DDevice.GetRenderTarget(0, FSurface);
  FBackBuffer.D3DSurface:= FSurface;

  // Create the render target
  CreateRenderTarget;
  FFirstSceneRender:= True;
end;

procedure Tz3DRenderer.AddBlendTexture(const ATexture: Iz3DTexture);
begin
  if FBlendTextures.IndexOf(ATexture) = -1 then FBlendTextures.Add(ATexture);
end;

procedure Tz3DRenderer.BeginScene(const ABackBuffer: Boolean = True);
begin
  if FAILED(z3DCore_GetD3DDevice.BeginScene) then
  begin
    z3DTrace('Iz3DRenderer.BeginRender failed (BeginScene failed)', z3dtkWarning);
    Exit;
  end;
  FRendering:= True;
  if ABackBuffer then
  begin
    FRenderStage:= z3drsBackBuffer;
    BackBuffer.SetRenderTarget;
  end;
  FRenderChainIndex:= 0;
end;

procedure Tz3DRenderer.BeginScenario;
var FDepth: IDirect3DSurface9;
begin
  // Set the multisample render target if needed
  if EnableMSAA then
  begin
    z3DCore_GetD3DDevice.GetDepthStencilSurface(FDepth);
    FLastDepthBuffer.D3DSurface:= FDepth;
    FRenderTarget.SetRenderTarget;
    z3DCore_GetD3DDevice.SetDepthStencilSurface(FDepthBuffer.D3DSurface);
    if AutoClearDepth then ClearDepthBuffer(FDefaultClearDepth);
  end else RenderTexture.SetRenderTarget;

  DeferredBuffer.AttachToSampler(1, True, True);
  FRenderStage:= z3drsScene;
end;

procedure Tz3DRenderer.EndScenario;
var I: Integer;
    FTechnique: Tz3DHandle;
begin

  // Restore the back buffer
  FRenderStage:= z3drsBackBuffer;
  BackBuffer.SetRenderTarget;
  RenderTexture.AttachToSampler(0);

  // Set the blend textures
  for I:= 2 to FBlendTextures.Count+1 do
  (FBlendTextures[I-2] as Iz3DTexture).AttachToSampler(I);

  // Set the blend technique
  FTechnique:= Tz3DHandle('z3DCore_MainSceneBlend_'+IntToStr(FBlendTextures.Count+1));

  z3DEngine.CoreShader.Technique:= FTechnique;

//  z3DEngine.CoreShader.Vector3['GGlobalColor']:= z3D;
//  z3DEngine.CoreShader.Float2['GPixelSize']:= z3DFloat2(1 / z3DCore_GetBackBufferSurfaceDesc.Width,
//  1 / z3DCore_GetBackBufferSurfaceDesc.Height);
  z3DEngine.CoreShader.DrawFullScreen;

  z3DCore_GetD3DDevice.SetTexture(0, nil);
  z3DCore_GetD3DDevice.SetTexture(1, nil);

end;

procedure Tz3DRenderer.EndScene;
begin
  if Rendering then z3DCore_GetD3DDevice.EndScene;
end;

function Tz3DRenderer.GetRendering: Boolean;
begin
  Result:= FRendering;
end;

function Tz3DRenderer.GetBackBuffer: Iz3DSurface;
begin
  Result:= FBackBuffer;
end;

function Tz3DRenderer.GetDeferredBuffer: Iz3DRenderTexture;
begin
  Result:= FDeferredBuffer;
end;

procedure Tz3DRenderer.PostProcess(const ATarget: Iz3DRenderTexture;
  const ATextures: array of Iz3Dtexture; const AShader: Iz3DShader);
var I: Integer;
    FMode: Tz3DRenderMode;
begin
  // Setup 2D mode if not assigned
  FMode:= RenderMode;
  RenderMode:= z3drm2D;

  // Draw a full screen quad to sample the render target
  try
    ATarget.SetRenderTarget;
    if RenderTexture <> nil then
      RenderTexture.AttachToSampler(0, True, True);
    for I:= 0 to High(ATextures) do ATextures[I].AttachToSampler(I + 2, True, True);
    AShader.DrawFullScreen;
  finally
    RenderMode:= FMode;
    z3DCore_GetD3DDevice.SetTexture(0, nil);
  end;
end;

procedure Tz3DRenderer.PostProcess_Blend(const ATextures: array of Iz3Dtexture;
  const AShader: Iz3DShader);
var I: Integer;
    FMode: Tz3DRenderMode;
begin
  // Setup 2D mode if not assigned
  FMode:= RenderMode;
  RenderMode:= z3drm2D;

  // Draw a full screen quad to sample the render target
  try
    if FRenderChainIndex = 0 then FRenderChainIndex:= 1 else FRenderChainIndex:= 0;
    RenderTexture.SetRenderTarget;
    LastRenderTexture.AttachToSampler(0);
    for I:= 0 to High(ATextures) do ATextures[I].AttachToSampler(I + 2, True, True);
    AShader.DrawFullScreen;
  finally
    RenderMode:= FMode;
    z3DCore_GetD3DDevice.SetTexture(0, nil);
  end;
end;

procedure Tz3DRenderer.Blend(const ATextures: array of Iz3Dtexture;
  const AShader: Iz3DShader = nil; const AAlpha: Single = 1);
var I: Integer;
    FMode: Tz3DRenderMode;
begin
  // Setup 2D mode if not assigned
  FMode:= RenderMode;
  RenderMode:= z3drm2D;

  if AShader = nil then
  begin
    if AAlpha < 1 then
    begin
      z3DEngine.CoreShader.SetTechnique(Tz3DHandle('z3DCore_TextureBlend_'+
      IntToStr(High(ATextures)-Low(ATextures)+1)+'_Alpha'));
      z3DEngine.CoreShader.Param['GAlphaBlendValue']:= AAlpha;
    end else z3DEngine.CoreShader.SetTechnique(Tz3DHandle('z3DCore_TextureBlend_'+
    IntToStr(High(ATextures)-Low(ATextures)+1)));
    // Draw a full screen quad to sample the render target
    try
      for I:= 0 to High(ATextures) do
        ATextures[I].AttachToSampler(I, True, True);
      if AAlpha < 1 then
      z3DEngine.CoreShader.DrawFullScreen(0) else
      z3DEngine.CoreShader.DrawFullScreen;
    finally
      RenderMode:= FMode;
    end;
  end else
  begin
    // Draw a full screen quad to sample the render target
    try
      for I:= 0 to High(ATextures) do
        ATextures[I].AttachToSampler(I, True, True);
      AShader.DrawFullScreen;
    finally
      RenderMode:= FMode;
    end;
  end;
end;

procedure Tz3DRenderer.AutoBlend(const ATexture: Iz3DTexture;
  const ALeft: Integer = 0; const ATop: Integer = 0;
  const AShader: Iz3DShader = nil; const AAlpha: Single = 1);
var I: Integer;
    FLeft, FTop, FU, FV: Single;
    FMode: Tz3DRenderMode;
begin
  // Setup 2D mode if not assigned
  FMode:= RenderMode;
  RenderMode:= z3drm2D;

  FU:= RenderSurface.Width / ATexture.Width;
  FV:= RenderSurface.Height / ATexture.Height;
  FLeft:= (-ALeft / RenderSurface.Width) * FU;
  FTop:= (-ATop / RenderSurface.Height) * FV;

  if AShader = nil then
  begin
    if AAlpha < 1 then
    begin
      z3DEngine.CoreShader.Technique:= 'z3DCore_TextureBlend_1_Alpha';
      z3DEngine.CoreShader.Param['GAlphaBlendValue']:= AAlpha;
    end else z3DEngine.CoreShader.Technique:= 'z3DCore_TextureBlend_1';
    // Draw a full screen quad to sample the render target
    try
      ATexture.AttachToSampler(0, True, True);
      if AAlpha < 1 then
      begin
        for I:= 0 to z3DEngine.CoreShader.Prepare(0)-1 do
        begin
          z3DEngine.CoreShader.BeginPass;
          DrawFullScreenQuad(z3DFloat4(FLeft, FTop, FLeft+FU, FTop+FV));
          z3DEngine.CoreShader.EndPass;
        end;
      end else
      begin
        for I:= 0 to z3DEngine.CoreShader.Prepare-1 do
        begin
          z3DEngine.CoreShader.BeginPass;
          DrawFullScreenQuad(z3DFloat4(FLeft, FTop, FLeft+FU, FTop+FV));
          z3DEngine.CoreShader.EndPass;
        end;
      end;
    finally
      RenderMode:= FMode;
    end;
  end else
  begin
    // Draw a full screen quad to sample the render target
    try
      ATexture.AttachToSampler(0, True, True);
      for I:= 0 to AShader.Prepare-1 do
      begin
        AShader.BeginPass;
        DrawFullScreenQuad(z3DFloat4(FLeft, FTop, FLeft+FU, FTop+FV));
        AShader.EndPass;
      end;
    finally
      RenderMode:= FMode;
    end;
  end;
end;

procedure Tz3DRenderer.z3DStartScenario(const AStage: Tz3DStartScenarioStage);
begin
  if AStage = z3dssCreatingScenario then
  begin
    FadeIn(4);
    FFirstSceneRender:= True;
  end;
end;

procedure Tz3DRenderer.ClearDepthBuffer(const AValue: Single);
begin
  if FAILED(z3DCore_GetD3DDevice.Clear(0, nil, D3DCLEAR_ZBUFFER, 0, AValue, 0)) then
  z3DTrace('Iz3DRenderer.ClearDepthBuffer: Could not clear depth buffer', z3dtkWarning);
end;

procedure Tz3DRenderer.ClearRenderTarget(const AValue: Iz3DFloat4);
var FColor: TD3DColor;
begin
  if AValue = nil then FColor:= z3DD3DColor(FDefaultClearColor) else FColor:= z3DD3DColor(AValue);
  if FAILED(z3DCore_GetD3DDevice.Clear(0, nil, D3DCLEAR_TARGET, FColor, 0, 0)) then
  z3DTrace('Iz3DRenderer.ClearRenderTarget: Could not clear render target', z3dtkWarning);
end;

procedure Tz3DRenderer.z3DFrameMove;
begin
  if not z3DEngine.Scenario.Enabled then Exit;

  // Decrease/increase fade factor when fading
  if (FFadeValue < 1) then
  begin
    FFadeValue:= FFadeValue / (Power(0.98, 30 * FFadeFactor * z3DCore_GetElapsedTime));
    if FFadeValue > 1 then FFadeValue:= 1;
    if FFadeInMode then z3DEngine.CoreShader.Param['GFadeFactor']:= FFadeValue else
    z3DEngine.CoreShader.Param['GFadeFactor']:= 1 - FFadeValue;
  end;
end;

{var GPerf: Cardinal;

   procedure BeginPerformanceCounter;
   begin
     GPerf:= GetTickCount;
   end;

   function EndPerformanceCounter: Cardinal;
   begin
     Result:= GetTickCount-GPerf;
   end;}

procedure Tz3DRenderer.RenderScene;
begin
  // Begin rendering the scene
  BeginScene(not z3DEngine.Scenario.Enabled);

  try

    // Render the scene
    if z3DEngine.Scenario.Enabled then
    begin
      // Clear the depth buffer
      if AutoClearDepth then ClearDepthBuffer;
      
      RenderMode:= z3drm3D;
      // Perform precomputation if needed
      if FirstSceneRender then RenderPrecomputation;
      RenderDeferredBuffers;
      BeginScenario;
      try
        // Clear the target
        if AutoClearTarget then ClearRenderTarget;
        RenderScenario;

        // Prepare for post processing
        if z3DEngine.PostProcess.Bloom.Enabled or z3DEngine.PostProcess.ToneMapping.Enabled or
        z3DEngine.PostProcess.ColorCorrection.Enabled or z3DEngine.PostProcess.MotionBlur.Enabled or
        z3DEngine.PostProcess.DepthOfField.Enabled then
        begin
          RenderMode:= z3drm2D;
          RenderPostProcess;
        end;
      finally
        EndScenario;
      end;
    end;

    // Render the user interface
    RenderMode:= z3drm2D;
    RenderGUI;

  finally
    // Stop rendering
    EndScene;
  end;
end;

procedure Tz3DRenderer.RenderPrecomputation;
begin
  FRenderStage:= z3drsPrecomputation;
  z3DEngine.NotifyLinks_z3DFrameRender;
  FFirstSceneRender:= False;
end;

procedure Tz3DRenderer.RenderDeferredBuffers;
var I: Integer;
begin
  FRenderStage:= z3drsDepth;
  BeginZWrite;
  try

    // Select the deferred technique
    if (z3DLightingController <> nil) and z3DLightingController.SSAO.Enabled and
    (z3DEngine.Device.EngineCaps.ShaderModel3Supported)
    and (z3DLightingController.SSAO.Quality = z3dssaoqHigh) and
    z3DEngine.Device.EngineCaps.HDRSupport then
    z3DEngine.CoreShader.Technique:= 'z3DCore_DepthNormal' else
    begin
      z3DEngine.CoreShader.Technique:= 'z3DCore_Depth';
      z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED);
    end;

    // TODO JP: OPTIMIZAR
    z3DEngine.CoreShader.Param['GFarClip']:= z3DEngine.Scenario.ViewFrustum.FarClip;
    DeferredBuffer.SetRenderTarget;
    ClearRenderTarget(z3DFloat4(1, 1, 1, 1));
    for I:= 0 to z3DEngine.CoreShader.Prepare-1 do
    begin
      z3DEngine.CoreShader.BeginPass;
      z3DEngine.NotifyLinks_z3DFrameRender;
      z3DEngine.CoreShader.EndPass;
    end;
  finally
    EndZWrite;
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED or D3DCOLORWRITEENABLE_GREEN or
      D3DCOLORWRITEENABLE_BLUE or D3DCOLORWRITEENABLE_ALPHA);
  end;
end;

procedure Tz3DRenderer.RenderScenario;
begin

  // Render the full scene with all scenario properties such as lighting
  z3DEngine.Scenario.FrameRender;

  // Copy the multisampled render target to the render texture
  if EnableMSAA then
  begin
    if FAILED(z3DCore_GetD3DDevice.StretchRect(FRenderTarget.D3DSurface,
    nil, RenderTexture.GetSurface.D3DSurface, nil, D3DTEXF_NONE)) then
    z3DTrace('Iz3DRenderer.RenderScenario: Could not copy render target (StretchRect failed)', z3dtkWarning);
    if FAILED(z3DCore_GetD3DDevice.SetDepthStencilSurface(FLastDepthBuffer.D3DSurface)) then
    z3DTrace('Iz3DRenderer.RenderScenario: Could not set Last depth surface', z3dtkWarning);
  end;
end;

procedure Tz3DRenderer.RenderPostProcess;
begin
  FRenderStage:= z3drsPostProcess;
  FPostProcessBuffer.Prepare;
  FPostProcessPrepared:= True;
  try
//    RenderTexture.SetRenderTarget; TODO JP: ?????
    z3DEngine.PostProcess.FrameRender;
  finally
    FPostProcessPrepared:= False;
  end;
end;

procedure Tz3DRenderer.RenderGUI;
begin
  FRenderStage:= z3drsGUI;
  z3DEngine.NotifyLinks_z3DGUIRender;
  z3DEngine.Stats.FrameRender;
end;

function Tz3DRenderer.GetFirstSceneRender: Boolean;
begin
  Result:= FFirstSceneRender and z3DEngine.Scenario.Enabled;
end;

procedure Tz3DRenderer.FadeIn(const AFactor: Single);
begin
  FFadeInMode:= True;
  FFadeFactor:= AFactor;
  FFadeValue:= 0.001;
end;

procedure Tz3DRenderer.FadeOut(const AFactor: Single);
begin
  FFadeInMode:= False;
  FFadeFactor:= AFactor;
  FFadeValue:= 0.001;
end;

function Tz3DRenderer.GetLastRenderTexture: Iz3DRenderTexture;
var FLastChain: Integer;
begin
  if FRenderChainIndex = 0 then FLastChain:= 1 else FLastChain:= 0;
  Result:= FRenderTextures[FLastChain];
end;

procedure Tz3DRenderer.Clear(const ARenderTarget: Iz3DFloat4; const ADepthBuffer: Single);
var FColor: TD3DColor;
begin
  if ARenderTarget = nil then FColor:= z3DD3DColor(FDefaultClearColor) else FColor:= z3DD3DColor(ARenderTarget);
  if FAILED(z3DCore_GetD3DDevice.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, FColor, ADepthBuffer, 0)) then
  z3DTrace('Iz3DRenderer.Clear: Could not clear render target and depth buffer', z3dtkWarning);
end;

function Tz3DRenderer.GetRenderChainIndex: Integer;
begin
  Result:= FRenderChainIndex;
end;

procedure Tz3DRenderer.SetRenderChainIndex(const Value: Integer);
begin
  FRenderChainIndex:= Value;
end;

function Tz3DRenderer.GetFormat: TD3DFormat;
begin
  if HDRMode then Result:= D3DFMT_A16B16G16R16F else Result:= D3DFMT_A8R8G8B8;
end;

procedure Tz3DRenderer.DrawFullScreenQuad(const ACoords: Iz3DFloat4);
var FBufferData: Pz3DPostProcessVertexArray;
begin
  // Update the post process quad buffer
  FBufferData:= FPostProcessBuffer.Lock(D3DLOCK_DISCARD);
  try
    FBufferData[0].Position:= D3DXVector4(-0.5, -0.5, 0.5, 1.0);
    FBufferData[1].Position:= D3DXVector4(RTWidth - 0.5, -0.5, 0.5, 1.0);
    FBufferData[2].Position:= D3DXVector4(-0.5, RTHeight - 0.5, 0.5, 1.0);
    FBufferData[3].Position:= D3DXVector4(RTWidth - 0.5, RTHeight - 0.5, 0.5, 1.0);
    if ACoords <> nil then
    begin
      FBufferData[0].TexCoord:= D3DXVector2(ACoords.X, ACoords.Y);
      FBufferData[1].TexCoord:= D3DXVector2(ACoords.Z, ACoords.Y);
      FBufferData[2].TexCoord:= D3DXVector2(ACoords.X, ACoords.W);
      FBufferData[3].TexCoord:= D3DXVector2(ACoords.Z, ACoords.W);
    end else
    begin
      FBufferData[0].TexCoord:= D3DXVector2(0, 0);
      FBufferData[1].TexCoord:= D3DXVector2(1, 0);
      FBufferData[2].TexCoord:= D3DXVector2(0, 1);
      FBufferData[3].TexCoord:= D3DXVector2(1, 1);
    end;
  finally
    FPostProcessBuffer.Unlock;
  end;
  if not FPostProcessPrepared then FPostProcessBuffer.Prepare;
  FPostProcessBuffer.Render;
end;

function Tz3DRenderer.GetRenderStage: Tz3DRenderStage;
begin
  Result:= FRenderStage;
end;

function Tz3DRenderer.GetMSAASamples: Integer;
begin
  Result:= FMSAASamples;
end;

procedure Tz3DRenderer.SetMSAASamples(const Value: Integer);
var I: Integer;
    FFound: Boolean;
begin
  if FMSAASamples <> Value then
  begin
    FFound:= False;
    if z3DEngine.Device.Created then
    begin
      for I:= Low(z3DCore_GetDeviceList.GetCurrentDeviceSettingsCombo.MultiSampleTypeList) to
      High(z3DCore_GetDeviceList.GetCurrentDeviceSettingsCombo.MultiSampleTypeList) do
      if z3DCore_GetDeviceList.GetCurrentDeviceSettingsCombo.MultiSampleTypeList[I] =
      FMSAASamplesD3D[Value] then FFound:= True;
    end else FFound:= True;
    if FFound then
    begin
      FMSAASamples:= Value;
      CreateRenderTarget;
    end else z3DTrace(PWideChar(WideString('Iz3DRenderer.SetMSAASamples: Mumber of MSAA samples ('+IntToStr(Value)+'x) is not compatible with current device')), z3dtkWarning);
  end;
end;

function Tz3DRenderer.GetEnableMSAA: Boolean;
begin
  Result:= FEnableMSAA;
end;

procedure Tz3DRenderer.SetEnableMSAA(const Value: Boolean);
begin
  if FEnableMSAA <> Value then
  begin
    FEnableMSAA:= Value;
    CreateRenderTarget;
  end;
end;

function Tz3DRenderer.GetDefaultClearColor: Iz3DFloat4;
begin
  Result:= FDefaultClearColor;
end;

function Tz3DRenderer.GetDefaultClearDepth: Single;
begin
  Result:= FDefaultClearDepth;
end;

procedure Tz3DRenderer.SetDefaultClearDepth(const Value: Single);
begin
  FDefaultClearDepth:= Value;
end;

function Tz3DRenderer.GetAutoClearDepth: Boolean;
begin
  Result:= FAutoClearDepth;
end;

function Tz3DRenderer.GetAutoClearTarget: Boolean;
begin
  Result:= FAutoClearTarget;
end;

procedure Tz3DRenderer.SetAutoClearDepth(const Value: Boolean);
begin
  FAutoClearDepth:= Value;
end;

procedure Tz3DRenderer.SetAutoClearTarget(const Value: Boolean);
begin
  FAutoClearTarget:= Value;
end;

procedure Tz3DRenderer.SwapRenderChain;
begin
  if FRenderChainIndex = 0 then FRenderChainIndex:= 1 else FRenderChainIndex:= 0;
  RenderTexture.SetRenderTarget;
end;

procedure Tz3DRenderer.GetDownScaleSO(const AWidth, AHeight: Integer);
var FU, FV: Single;
    FIndex, X, Y: Integer;
begin
  FU:= 1 / AWidth;
  FV:= 1 / AHeight;
  FIndex:= 0;
  for Y:= 0 to 3 do
  for X:= 0 to 3 do
  begin
    FDownScaleSO[FIndex].X:= (X - 1.5) * FU;
    FDownScaleSO[FIndex].Y:= (Y - 1.5) * FV;
    Inc(FIndex);
  end;
end;

procedure Tz3DRenderer.DownScale(const AOutTexture: Iz3DRenderTexture);
begin
  if (FLastRTWidth <> RTWidth) or (FLastRTHeight <> RTHeight) then
  begin
    FLastRTWidth:= RTWidth;
    FLastRTHeight:= RTHeight;
    GetDownScaleSO(RTWidth, RTHeight);
  end;
  z3DEngine.CoreShader.SetPointer('GDownScaleSampleOffsets', @FDownScaleSO, SizeOf(FDownScaleSO));
  z3DEngine.CoreShader.Technique:= 'z3DCore_DownScale';
  PostProcess(AOutTexture, [], z3DEngine.CoreShader);
end;

function Tz3DRenderer.GetRTHeight: Integer;
begin
  Result:= FRTHeight;
end;

function Tz3DRenderer.GetRTWidth: Integer;
begin
  Result:= FRTWidth;
end;

procedure Tz3DRenderer.SetRTHeight(const Value: Integer);
begin
  FRTHeight:= Value;
end;

procedure Tz3DRenderer.SetRTWidth(const Value: Integer);
begin
  FRTWidth:= Value;
end;

procedure Tz3DRenderer.BeginSettingsChange;
begin
  FSettingsChanging:= True;
end;

procedure Tz3DRenderer.EndSettingsChange;
begin
  FSettingsChanging:= False;
  CreateRenderTarget;
  (z3DEngine.PostProcess as Iz3DLinked).z3DLostDevice;
  (z3DEngine.PostProcess as Iz3DLinked).z3DResetDevice;
end;

procedure Tz3DRenderer.RenderFog;
begin
  if not z3DEngine.Scenario.Environment.Fog.Enabled then Exit;

  // Add the screen space fog to the scene when enabled
  if z3DEngine.Scenario.Environment.Fog.Uniform then
  z3DEngine.CoreShader.Technique:= 'z3DCore_FogUniform' else
  begin
    z3DEngine.CoreShader.Technique:= 'z3DCore_Fog';
    z3DEngine.CoreShader.Param['GAltitude']:= -z3DFloat3.From(z3DScenario.ViewFrustum.LookAt).
    Subtract(z3DScenario.ViewFrustum.Position).Normalize.Y + 0.5;
  end;
  DisableBlending;
  // TODO JP: hay un problema con el FOG
  // aunque la densidad sea 1, al usarse BLEND, el FOG no cubre completamente
  // los objetos, a no ser que el color del FOG sea (1, 1, 1)
  z3DEngine.Renderer.PostProcess(z3DEngine.Renderer.RenderTexture, [], z3DEngine.CoreShader);
//  z3DEngine.Renderer.Blend([], z3DEngine.CoreShader);
  EnableAdditiveBlending;
end;

function Tz3DRenderer.GetDepthBuffer: Iz3DDepthBuffer;
begin
  Result:= FDepthBuffer;
end;

procedure Tz3DRenderer.BeginMSAAMode(const ARewriteZ: Boolean = True);
begin
  z3DCore_GetD3DDevice.SetDepthStencilSurface(DepthBuffer.D3DSurface);
  if ARewriteZ then BeginZWrite;
end;

procedure Tz3DRenderer.EndMSAAMode(const AReuseZ: Boolean = True);
begin
  z3DCore_GetD3DDevice.SetDepthStencilSurface(FLastDepthBuffer.D3DSurface);
  if AReuseZ then EndZWrite;
end;

procedure Tz3DRenderer.BeginZWrite;
begin
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_ZWRITEENABLE, iTrue);
end;

procedure Tz3DRenderer.DisableBlending;
begin
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, iFalse);
end;

procedure Tz3DRenderer.EnableAdditiveBlending;
begin
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ONE);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
end;

procedure Tz3DRenderer.EnableAlphaBlending;
begin
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
end;

procedure Tz3DRenderer.EndZWrite;
begin
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_ZWRITEENABLE, iFalse);
end;

const
  FAddressModeD3D: array[Tz3DSamplerAddressMode] of DWORD =
    (D3DTADDRESS_WRAP, D3DTADDRESS_MIRROR, D3DTADDRESS_CLAMP, D3DTADDRESS_BORDER,
    {D3DTADDRESS_INDEPENDENTUV, }D3DTADDRESS_MIRRORONCE);


procedure Tz3DRenderer.SetSamplerAddressMode(const ASampler: Integer;
  const AAddressingMode: Tz3DSamplerAddressMode; const ABorderColor: Iz3DFloat3);
begin
//  if FSamplerStates[ASampler].AddressMode <> AAddressingMode then
  begin
    // Set the address mode
    z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_ADDRESSU, FAddressModeD3D[AAddressingMode]);
    z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_ADDRESSV, FAddressModeD3D[AAddressingMode]);

    // Set the border color
    if (AAddressingMode = z3dsamBorder) and (ABorderColor <> nil) and
    ((FSamplerStates[ASampler].BorderColor = nil) or
    ((FSamplerStates[ASampler].BorderColor.R <> ABorderColor.R) or
    (FSamplerStates[ASampler].BorderColor.G <> ABorderColor.G) or
    (FSamplerStates[ASampler].BorderColor.B <> ABorderColor.B))) then
    begin
      z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_BORDERCOLOR, ABorderColor.D3DColor);
      FSamplerStates[ASampler].BorderColor:= ABorderColor;
    end;
    FSamplerStates[ASampler].AddressMode:= AAddressingMode;
  end;
end;

procedure Tz3DRenderer.SetSamplerFilter(const ASampler: Integer;
  const AFilter: Tz3DSamplerFilter; const AMaxAnisotropy: Integer);
begin
//  if FSamplerStates[ASampler].Filter <> AFilter then
  begin

    // Set the filtering mode
    case AFilter of
      z3dsfNone:
      begin
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MAGFILTER, D3DTEXF_POINT);
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MIPFILTER, D3DTEXF_POINT);
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MINFILTER, D3DTEXF_POINT);
      end;
      z3dsfLinear:
      begin
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MIPFILTER, D3DTEXF_NONE);
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MINFILTER, D3DTEXF_POINT);
      end;
      z3dsfBilinear:
      begin
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MIPFILTER, D3DTEXF_NONE);
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
      end;
      z3dsfTrilinear:
      begin
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
      end;
      z3dsfAnisotropic:
      begin
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MINFILTER, D3DTEXF_ANISOTROPIC);

        // Set the max anisotropy
        if (AMaxAnisotropy <> -1) and (FSamplerStates[ASampler].MaxAnisotropy <> AMaxAnisotropy) then
        z3DCore_GetD3DDevice.SetSamplerState(ASampler, D3DSAMP_MAXANISOTROPY, AMaxAnisotropy);
      end;
    end;
  end;
end;

procedure Tz3DRenderer.ResetSamplerStates;
var I: Integer;
begin
  for I:= Low(FSamplerStates) to High(FSamplerStates) do
  begin
    FSamplerStates[I].AddressMode:= z3dsamClamp;
    FSamplerStates[I].BorderColor:= z3DFloat3;
    FSamplerStates[I].Filter:= z3dsfNone;
    FSamplerStates[I].MaxAnisotropy:= 1;
  end;
end;

function Tz3DRenderer.GetTextureFilter: Tz3DSamplerFilter;
begin
  Result:= FTextureFilter;
end;

procedure Tz3DRenderer.SetTextureFilter(const Value: Tz3DSamplerFilter);
begin
  FTextureFilter:= Value;
end;

function Tz3DRenderer.GetAnisotropyLevel: Integer;
begin
  Result:= FAnisotropyLevel;
end;

procedure Tz3DRenderer.SetAnisotropyLevel(const Value: Integer);
begin
  FAnisotropyLevel:= Value;
end;

{ Tz3DDeviceEngineCaps }

constructor Tz3DDeviceEngineCaps.Create(const ADevice: Iz3DDevice);
begin
  inherited Create;
  FDevice:= ADevice;
  Notifications:= [z3dlnDevice];
end;

procedure Tz3DDeviceEngineCaps.z3DModifyDevice(var ADeviceSettings: Tz3DDeviceSettings;
  const ACaps: _D3DCAPS9);
var FD3D: IDirect3D9;
begin
  FD3D:= z3DCore_GetD3DObject;

  // Shader model supported
  FShaderModelMinor:= D3DSHADER_VERSION_MINOR(ACaps.PixelShaderVersion);
  case D3DSHADER_VERSION_MAJOR(ACaps.PixelShaderVersion) of
    1: FShaderModel:= z3dsm1x;
    2: FShaderModel:= z3dsm2x;
    3: FShaderModel:= z3dsm3x;
    else FShaderModel:= z3dsmHigher;
  end;

  // HDR (must support ARGB16F RT with additive blending)
  FHDRSupport:= not FAILED(FD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  ADeviceSettings.AdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_TEXTURE, D3DFMT_A16B16G16R16F)) and
  not FAILED(FD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  ADeviceSettings.AdapterFormat, D3DUSAGE_QUERY_POSTPIXELSHADER_BLENDING,
  D3DRTYPE_TEXTURE, D3DFMT_A16B16G16R16F));

  // DirectX level supported by hardware
  case FShaderModel of
    z3dsm1x: FDirectXLevel:= z3ddx70;
    z3dsm2x:
    begin
      if ShaderModelMinor = 0 then FDirectXLevel:= z3ddx80 else
      FDirectXLevel:= z3ddx81;
    end;
    z3dsm3x:
    begin
      if HDRSupport then FDirectXLevel:= z3ddx91 else
      FDirectXLevel:= z3ddx90;
    end;
    z3dsmHigher: FDirectXLevel:= z3ddxHigher;
  end;

  // Default single-component flating point format
  if not FAILED(FD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  ADeviceSettings.AdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_TEXTURE, D3DFMT_R32F)) then
  FFPFormat:= D3DFMT_R32F else
  if not FAILED(FD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  ADeviceSettings.AdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_TEXTURE, D3DFMT_R16F)) then
  FFPFormat:= D3DFMT_R16F else
  if not FAILED(FD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  ADeviceSettings.AdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_TEXTURE, D3DFMT_G16R16)) then
  FFPFormat:= D3DFMT_G16R16 else
  if not FAILED(FD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  ADeviceSettings.AdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_TEXTURE, D3DFMT_A16B16G16R16F)) then
  FFPFormat:= D3DFMT_A16B16G16R16F else
  if not FAILED(FD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  ADeviceSettings.AdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_TEXTURE, D3DFMT_A16B16G16R16)) then
  FFPFormat:= D3DFMT_A16B16G16R16 else FFPFormat:= D3DFMT_A8R8G8B8;

  // Dynamic shadow map support and format
  FShadowMapFormat:= FFPFormat;
  FShadowMapSupport:= ShadowMapFormat <> D3DFMT_A8R8G8B8;
  if not FAILED(FD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  ADeviceSettings.AdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_CUBETEXTURE, D3DFMT_R32F)) then
  FCubeShadowMapFormat:= D3DFMT_R32F else
  if not FAILED(FD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  ADeviceSettings.AdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_CUBETEXTURE, D3DFMT_R16F)) then
  FCubeShadowMapFormat:= D3DFMT_R16F else
  if not FAILED(FD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  ADeviceSettings.AdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_CUBETEXTURE, D3DFMT_G16R16)) then
  FCubeShadowMapFormat:= D3DFMT_G16R16 else
  if not FAILED(FD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  ADeviceSettings.AdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_CUBETEXTURE, D3DFMT_A16B16G16R16F)) then
  FCubeShadowMapFormat:= D3DFMT_A16B16G16R16F else
  if not FAILED(FD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  ADeviceSettings.AdapterFormat, D3DUSAGE_RENDERTARGET, D3DRTYPE_CUBETEXTURE, D3DFMT_A16B16G16R16)) then
  FCubeShadowMapFormat:= D3DFMT_A16B16G16R16 else FShadowMapSupport:= False;

  // Check for current hardware acceleration for shadow mapping
  FShadowMapHWSupport:= not FAILED(FD3D.CheckDeviceFormat(ACaps.AdapterOrdinal, ACaps.DeviceType,
  ADeviceSettings.AdapterFormat, D3DUSAGE_DEPTHSTENCIL, D3DRTYPE_TEXTURE,
  ADeviceSettings.PresentParams.AutoDepthStencilFormat));
end;

function Tz3DDeviceEngineCaps.GetFPFormat: TD3DFormat;
begin
  Result:= FFPFormat;
end;

function Tz3DDeviceEngineCaps.GetDirectXLevel: Tz3DDirectXLevel;
begin
  Result:= FDirectXLevel;
end;

function Tz3DDeviceEngineCaps.GetCubeShadowMapFormat: TD3DFormat;
begin
  Result:= FCubeShadowMapFormat;
end;

function Tz3DDeviceEngineCaps.GetShadowMapFormat: TD3DFormat;
begin
  Result:= FShadowMapFormat;
end;

function Tz3DDeviceEngineCaps.GetShadowMapSupport: Boolean;
begin
  Result:= FShadowMapSupport;
end;

function Tz3DDeviceEngineCaps.GetHDRSupport: Boolean;
begin
  Result:= FHDRSupport;
end;

function Tz3DDeviceEngineCaps.GetShaderModel: Tz3DShaderModel;
begin
  Result:= FShaderModel;
end;

function Tz3DDeviceEngineCaps.GetShaderModelMinor: Integer;
begin
  Result:= FShaderModelMinor;
end;

function Tz3DDeviceEngineCaps.GetShadowMapHWSupport: Boolean;
begin
  Result:= FShadowMapHWSupport;
end;

function Tz3DDeviceEngineCaps.ShaderModel3Supported: Boolean;
begin
  Result:= ShaderModel in [z3dsm3x, z3dsmHigher];
end;

end.
