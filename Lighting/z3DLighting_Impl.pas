{==============================================================================}
{== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==}
{==============================================================================}
{== Unit: z3DLighting. z3D lighting and shadowing system core                ==}
{==============================================================================}

unit z3DLighting_Impl;

interface

uses
  Windows, Classes, Direct3D9, z3DLighting_Intf, z3DMath_Intf,
  z3DComponents_Intf, z3DClasses_Impl, z3DScenario_Intf, z3DCore_Intf, SysUtils,
  z3DClasses_Intf;

type

{==============================================================================}
{== Light effects interface                                                  ==}
{==============================================================================}
{== Provides a way to configure the effects of a light source on the         ==}
{== surrounding world like shadows, specular reflections and glow            ==}
{==============================================================================}

  Tz3DLightEffects = class(Tz3DBase, Iz3DLightEffects)
  private
    FLight: Pointer;
    FNormalMapping: Boolean;
    FSpecular: Boolean;
    FStaticShadows: Boolean;
    FDynamicShadows: Boolean;
    FStaticPenumbra: Boolean;
    FGlow: Boolean;
    FGlowFactor: Single;
    FMultiSampleGlow: Boolean;    
  protected
    function GetLight: Iz3DLight; stdcall;
    function GetMultiSampleGlow: Boolean; stdcall;
    procedure SetMultiSampleGlow(const Value: Boolean); stdcall;
    function GetGlowFactor: Single; stdcall;
    procedure SetGlowFactor(const Value: Single); stdcall;
    function GetGlow: Boolean; stdcall;
    procedure SetGlow(const Value: Boolean); stdcall;
    function GetDynamicShadows: Boolean; stdcall;
    function GetNormalMapping: Boolean; stdcall;
    function GetSpecular: Boolean; stdcall;
    function GetStaticPenumbra: Boolean; stdcall;
    function GetStaticShadows: Boolean; stdcall;
    procedure SetDynamicShadows(const Value: Boolean); stdcall;
    procedure SetNormalMapping(const Value: Boolean); stdcall;
    procedure SetSpecular(const Value: Boolean); stdcall;
    procedure SetStaticShadows(const Value: Boolean); stdcall;
    procedure SetStaticPenumbra(const Value: Boolean); stdcall;
    procedure Init(const AOwner: Iz3DBase); override; stdcall;
    procedure Cleanup; override; stdcall;
  public
    property Light: Iz3DLight read GetLight;
    property Specular: Boolean read GetSpecular write SetSpecular;
    property StaticShadows: Boolean read GetStaticShadows write SetStaticShadows;
    property StaticPenumbra: Boolean read GetStaticPenumbra write SetStaticPenumbra;
    property DynamicShadows: Boolean read GetDynamicShadows write SetDynamicShadows;
    property NormalMapping: Boolean read GetNormalMapping write SetNormalMapping;
    property Glow: Boolean read GetGlow write SetGlow;
    property GlowFactor: Single read GetGlowFactor write SetGlowFactor;
    property MultiSampleGlow: Boolean read GetMultiSampleGlow write SetMultiSampleGlow;
  end;

{==============================================================================}
{== Light interface                                                          ==}
{==============================================================================}
{== Represents a light source into the world and controls its properties     ==}
{== like intensity, spot angle and position                                  ==}
{==============================================================================}

  Tz3DLight = class(Tz3DBase, Iz3DLight)
  private
    FTexMatrix: Iz3DMatrix;
    FTexViewProjMatrix: Iz3DMatrix;
    FCubeViewMatrix: array[0..5] of Iz3DMatrix;
    FStaticDepthMap: Iz3DRenderTexture;
    FStaticCubeDepthMap: Iz3DCubeRenderTexture;
    FStyle: Tz3DLightStyle;
    FSharpness: Single;
    FAngle: Single;
    FRange: Single;
    FEnabled: Boolean;
    FColor: Iz3DFloat3;
    FSize: Single;
    FOnRender: Tz3DDirectLightRenderEvent;
    FIntensity: Single;
    FStatic: Boolean;
    FEffects: Iz3DLightEffects;
    FDynamicMode: Boolean;
    FName: PWideChar;
    FStage: Tz3DDirectLightRenderStage;
    FFrustum: Iz3DFrustum;
  protected
    function GetFrustum: Iz3DFrustum; stdcall;
    function GetStage: Tz3DDirectLightRenderStage; stdcall;
    function GetName: PWideChar; stdcall;
    procedure SetName(const Value: PWideChar); stdcall;
    function GetDynamicMode: Boolean; stdcall;
    procedure SetDynamicMode(const Value: Boolean); stdcall;
    function GetIndex: Integer; stdcall;
    function GetAngle: Single; stdcall;
    function GetColor: Iz3DFloat3; stdcall;
    function GetEffects: Iz3DLightEffects; stdcall;
    function GetEnabled: Boolean; stdcall;
    function GetIntensity: Single; stdcall;
    function GetOnRender: Tz3DDirectLightRenderEvent; stdcall;
    function GetRange: Single; stdcall;
    function GetSharpness: Single; stdcall;
    function GetSize: Single; stdcall;
    function GetStatic: Boolean; stdcall;
    function GetStyle: Tz3DLightStyle; stdcall;
    procedure SetOnRender(const Value: Tz3DDirectLightRenderEvent); stdcall;
    procedure SetSize(const Value: Single); stdcall;
    procedure SetStyle(const Value: Tz3DLightStyle); stdcall;
    procedure SetRange(const Value: Single); stdcall;
    procedure SetAngle(const Value: Single); stdcall;
    procedure SetSharpness(const Value: Single); stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    procedure SetIntensity(const Value: Single); stdcall;
    procedure SetStatic(const Value: Boolean); stdcall;
    procedure MeasureLightEffectParams; stdcall;
    procedure UpdateLightingParams; stdcall;
    procedure UpdateSourceParams; stdcall;
    procedure ResetDevice; stdcall;
    procedure BuildStaticShadowMap; stdcall;
    procedure BuildDynamicShadowMap; stdcall;
    procedure BuildShadowMap(const ATarget: Iz3DBaseTexture; const ADepth: Iz3DSurface;
      const AStatic: Boolean = False); stdcall;
    procedure RenderPrecomputation; stdcall;
    procedure RenderWorld; stdcall;
    procedure RenderSource; stdcall;
    procedure SetLightingTechnique; stdcall;
    procedure PropertyChanged(const ASender: Iz3DBase); stdcall;
    procedure StartScenario; stdcall;
    procedure Init(const AOwner: Iz3DBase); override; stdcall;
    procedure Cleanup; override; stdcall;
    procedure PrepareDepthMap; stdcall;
    procedure CreateDepthMap; stdcall;
    procedure BuildTextureProjectionMatrix;
  public
    procedure TurnOn; stdcall;
    procedure TurnOff; stdcall;
  public
    property Index: Integer read GetIndex;
    property Frustum: Iz3DFrustum read GetFrustum;
    property Name: PWideChar read GetName write SetName;
    property Color: Iz3DFloat3 read GetColor;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Effects: Iz3DLightEffects read GetEffects;
    property Static: Boolean read GetStatic write SetStatic;
    property DynamicMode: Boolean read GetDynamicMode write SetDynamicMode;
    property Style: Tz3DLightStyle read GetStyle write SetStyle;
    property Intensity: Single read GetIntensity write SetIntensity;
    property Range: Single read GetRange write SetRange;
    property Sharpness: Single read GetSharpness write SetSharpness;
    property Angle: Single read GetAngle write SetAngle;
    property Size: Single read GetSize write SetSize;
    property Stage: Tz3DDirectLightRenderStage read GetStage;
    property OnRender: Tz3DDirectLightRenderEvent read GetOnRender write SetOnRender;
  end;

{==============================================================================}
{== Screen Space Ambient Occlusion interface                                 ==}
{==============================================================================}
{== Controller for the SSAO effect                                           ==}
{==============================================================================}

  Tz3DSSAO = class(Tz3DLinked, Iz3DSSAO)
  private
    FEnabled: Boolean;
    FAmount: Single;
    FQuality: Tz3DSSAOQuality;
    FSampleFactor: Single;
    FOcclusion, FBlurOcclusion: Iz3DRenderTexture;
  protected
    function GetSampleFactor: Single; stdcall;
    procedure SetSampleFactor(const Value: Single); stdcall;
    function GetQuality: Tz3DSSAOQuality; stdcall;
    procedure SetQuality(const Value: Tz3DSSAOQuality); stdcall;
    function GetAmount: Single; stdcall;
    procedure SetAmount(const Value: Single); stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    procedure z3DStartScenario(const AStage: Tz3DStartScenarioStage); override; stdcall;
    procedure CreateScenarioObjects; stdcall;
    procedure z3DResetDevice; override; stdcall;
    procedure ComputeOcclusion; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property Amount: Single read GetAmount write SetAmount;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Quality: Tz3DSSAOQuality read GetQuality write SetQuality;
    property SampleFactor: Single read GetSampleFactor write SetSampleFactor;
  end;

{==============================================================================}
{== Lights interface                                                         ==}
{==============================================================================}
{== Holds every light source and manages its shared properties and objects.  ==}
{== It also allows to add, access and remove light sources                   ==}
{==============================================================================}

  Tz3DLightingController = class(Tz3DLinked, Iz3DLightingController)
  private
    FSSAO: Iz3DSSAO;
    FLights: IInterfaceList;
    FDepthMap: Iz3DRenderTexture;
    FDirDepthMap: Iz3DRenderTexture;
    FCubeDepthMap: Iz3DCubeRenderTexture;
    FTempDepthMap: Iz3DRenderTexture;
    FTempDirDepthMap: Iz3DRenderTexture;
    FShader: Iz3DShader;
    FDepthBuffer: Iz3DDepthBuffer;
    FUseHWShadows: Boolean;
    FShadowQuality: Tz3DShadowQuality;
    FGlowTexture: Iz3DTexture;
    FNoiseTexture: Iz3DTexture;
    FShadowMapOffset: Single;
    FDirShadowMapOffset: Single;
    FDirShadowMapAreaSize: Single;
    FStage: Tz3DLightingRenderStage;
    FOpaqueMode: Boolean;
    FCurrentLight: Integer;
  protected
    function GetOpaqueMode: Boolean; stdcall;
    function GetCurrentLight: Iz3DLight; stdcall;
    function GetStage: Tz3DLightingRenderStage; stdcall;
    function GetDirShadowMapAreaSize: Single; stdcall;
    procedure SetDirShadowMapAreaSize(const Value: Single); stdcall;
    function GetDirShadowMapOffset: Single; stdcall;
    function GetShadowMapOffset: Single; stdcall;
    procedure SetDirShadowMapOffset(const Value: Single); stdcall;
    procedure SetShadowMapOffset(const Value: Single); stdcall;
    function GetSSAO: Iz3DSSAO; stdcall;
    function GetGlowTexture: Iz3DTexture; stdcall;
    function GetTempDirDepthMap: Iz3DRenderTexture; stdcall;
    function GetShadowQuality: Tz3DShadowQuality; stdcall;
    function GetUseHWShadows: Boolean; stdcall;
    procedure SetShadowQuality(const Value: Tz3DShadowQuality); stdcall;
    procedure SetUseHWShadows(const Value: Boolean); stdcall;
    function GetTempDepthMap: Iz3DRenderTexture; stdcall;
    function GetDirDepthMap: Iz3DRenderTexture; stdcall;
    function GetCubeDepthMap: Iz3DCubeRenderTexture; stdcall;
    function GetDepthMap: Iz3DRenderTexture; stdcall;
    function GetDepthBuffer: Iz3DDepthBuffer; stdcall;
    function GetLightCount: Integer; stdcall;
    function GetShader: Iz3DShader; stdcall;
    function GetLights(const AIndex: Integer): Iz3DLight; stdcall;
    procedure SetLights(const AIndex: Integer; const Value: Iz3DLight); stdcall;
    procedure RenderPrecomputation; stdcall;

    procedure RenderOpaqueStage; stdcall;
    procedure RenderTranslucentStage; stdcall;
    procedure RecreateDepthBuffers; stdcall;

    procedure RenderAmbient; stdcall;
    procedure RenderLighting; stdcall;
    procedure RenderLightSources; stdcall;
    procedure CreateScenarioObjects; stdcall;
    procedure SetEffectParams; stdcall;
    procedure z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller); override; stdcall;
    procedure z3DCreateDevice; override; stdcall;
    procedure z3DGPUPrecomputation; override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    function DepthMapSize: Integer; stdcall;
    function DirectionalDepthMapSize: Integer; stdcall;

    function CreateLight: Iz3DLight; stdcall;
    procedure RemoveLight(const ALight: Iz3DLight); stdcall;
    function IndexOfLight(const ALight: Iz3DLight): Integer; stdcall;
  public
    property OpaqueMode: Boolean read GetOpaqueMode;
    property Lights[const AIndex: Integer]: Iz3DLight read GetLights write SetLights; default;
    property CurrentLight: Iz3DLight read GetCurrentLight;
    property DepthBuffer: Iz3DDepthBuffer read GetDepthBuffer;
    property DepthMap: Iz3DRenderTexture read GetDepthMap;
    property DirDepthMap: Iz3DRenderTexture read GetDirDepthMap;
    property CubeDepthMap: Iz3DCubeRenderTexture read GetCubeDepthMap;
    property LightCount: Integer read GetLightCount;
    property Shader: Iz3DShader read GetShader;
    property ShadowMapOffset: Single read GetShadowMapOffset write SetShadowMapOffset;
    property DirShadowMapAreaSize: Single read GetDirShadowMapAreaSize write SetDirShadowMapAreaSize;
    property DirShadowMapOffset: Single read GetDirShadowMapOffset write SetDirShadowMapOffset;
    property TempDirDepthMap: Iz3DRenderTexture read GetTempDirDepthMap;
    property TempDepthMap: Iz3DRenderTexture read GetTempDepthMap;
    property GlowTexture: Iz3DTexture read GetGlowTexture;
    property SSAO: Iz3DSSAO read GetSSAO;
    property Stage: Tz3DLightingRenderStage read GetStage;
  end;

{==============================================================================}
{== Lightmap packing node interface                                          ==}
{==============================================================================}
{== Represents an individual lightmap into the packing tree and holds the    ==}
{== child lightmap nodes                                                     ==}
{==============================================================================}

  Tz3DLightMapPackNode = class(Tz3DBase, Iz3DLightMapPackNode)
  private
    FChilds: array[0..1] of Iz3DLightMapPackNode;
    FRect: TRect;
    FID: Integer;
  protected
    function GetChilds(const I: Integer): Iz3DLightMapPackNode; stdcall;
    function GetID: Integer; stdcall;
    function GetRect: TRect; stdcall;
    procedure SetChilds(const I: Integer; const Value: Iz3DLightMapPackNode); stdcall;
    procedure SetID(const Value: Integer); stdcall;
    procedure SetRect(const Value: TRect); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property Rect: TRect read GetRect write SetRect;
    property ID: Integer read GetID write SetID;
    property Childs[const I: Integer]: Iz3DLightMapPackNode read GetChilds write SetChilds;
  end;

{==============================================================================}
{== Ray tracer interface                                                     ==}
{==============================================================================}
{== Allows to perform ray tracing operations on the world for any purposes.  ==}
{== The main features are reflections, refractions, penumbra and bouncing    ==}
{==============================================================================}

  Tz3DRayTracer = class(Tz3DBase, Iz3DRayTracer)
  private
    FNormalLerp: Boolean;
    FNormalLerpExponent: Single;
    FAOSamples: Integer;
    FRadiositySamples: Integer;
    FPenumbraDetailFactor: Integer;
    FShadows: Boolean;
    FPenumbra: Boolean;
    FGPUTarget: Iz3DSurface;
    FGPURadiosityBuffer: array[0..1] of Iz3DTexture;
  protected
    function GetRadiosityBuffer0: Iz3DTexture; stdcall;
    function GetRadiosityBuffer1: Iz3DTexture; stdcall;
    function GetPenumbraDetailFactor: Integer; stdcall;
    procedure SetPenumbraDetailFactor(const Value: Integer); stdcall;
    function GetRadiositySamples: Integer; stdcall;
    procedure SetRadiositySamples(const Value: Integer); stdcall;
    function GetNormalLerp: Boolean; stdcall;
    function GetNormalLerpExponent: Single; stdcall;
    procedure SetNormalLerp(const Value: Boolean); stdcall;
    procedure SetNormalLerpExponent(const Value: Single); stdcall;
    function GetAOSamples: Integer; stdcall;
    procedure SetAOSamples(const Value: Integer); stdcall;
    function GetPenumbra: Boolean; stdcall;
    function GetShadows: Boolean; stdcall;
    procedure SetPenumbra(const Value: Boolean); stdcall;
    procedure SetShadows(const Value: Boolean); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;

    // Ray tracing functions
    procedure RayTraceLightMap(const ALightMap: Iz3DLightMap); stdcall;
    procedure RayTraceLightMapRadiosity(const ALightMap: Iz3DLightMap; const ALevel: Integer); stdcall;
    procedure RayTraceLightMapRadiosity_GPU(const ALightMap: Iz3DLightMap; const ALevel: Integer); stdcall;
    procedure NormalizeLightMapRadiosity(const ALightMap: Iz3DLightMap;
      const ALevel: Integer); stdcall;

    procedure BeginGPUTracing(const AAmbient: Boolean = False); stdcall;
    procedure EndGPUTracing; stdcall;
    procedure BeginAOTracing; stdcall;
    procedure EndAOTracing; stdcall;
    procedure BeginRadiosityTracing(const ALightMap: Iz3DLightMap); stdcall;
    procedure EndRadiosityTracing; stdcall;

    function RayTraceLight(const AObject: Iz3DScenarioObject; const ACenter, ANormal: Iz3DFloat3;
      const ALight: Integer): Iz3DFloat3; stdcall;
    function RayTraceAO(const AObject: Iz3DScenarioObject; const ACenter, ANormal,
      AOrigin, AEdge1, AEdge2: Iz3DFloat3; out ACollision: Boolean): Iz3DFloat3; stdcall;
    function RayTraceAO_GPU(const AObject: Iz3DScenarioObject;
      const ACenter, ANormal: Iz3DFloat3): Iz3DFloat3; stdcall;
    function RayTraceRadiosity(const AObject: Iz3DScenarioObject; var ALumel: Tz3DLightMapLuxel;
      const ACenter, ANormal, AOrigin, AEdge1, AEdge2, AColor: Iz3DFloat3;
      const ALight, ALevel: Integer): Iz3DFloat3; stdcall;
    function RayTraceRadiosity_GPU(const AObject: Iz3DScenarioObject;
      const ACenter, ANormal: Iz3DFloat3; const ALight, ALevel: Integer): Iz3DFloat3; stdcall;

    // Ray collision functions
    function RayIntersectTriangle(const ARay: Tz3DRay; const ATriangle: Tz3DTriangle; var ADistance: Single): Boolean; stdcall;
    function RayIntersectVertex(const AObject1, AObject2: Iz3DScenarioObject;
      const ARay: Tz3DRay; var ADistance: Single): Boolean; stdcall;
    function RayIntersectPlane(const ARay: Tz3DRay; const APlane: Tz3DTriangle; var ADistance: Single): Boolean; stdcall;
    function RayIntersectBoundingSphere(const ARay: Tz3DRay; const ASphere: Iz3DBoundingSphere;
      var ADistance: Single): Boolean; stdcall;
    function RayIntersectBoundingBox(const ARay: Tz3DRay; const ABox: Iz3DBoundingBox;
      var ADistance: Single; const ATEvaluation: Boolean = True): Boolean; stdcall;
    function RayIntersectBound(const AObject1, AObject2: Iz3DScenarioObject; const ARay:
      Tz3DRay; var ADistance: Single; const ATEvaluation: Boolean = True): Boolean; stdcall;

    function RayCollision(const ARayObject: Iz3DScenarioObject; const ARay: Tz3DRay; var AResult: Single;
      out ACollisionObject: Iz3DScenarioObject; out ACollisionT: Single;
      const AVertexEvaluation: Boolean = True; const ATEvaluation: Boolean = True;
      const ATotalSamples: Integer = 1): Boolean; stdcall;

  public
    property RadiosityBuffer0: Iz3DTexture read GetRadiosityBuffer0;
    property RadiosityBuffer1: Iz3DTexture read GetRadiosityBuffer1;
    property NormalLerp: Boolean read GetNormalLerp write SetNormalLerp;
    property NormalLerpExponent: Single read GetNormalLerpExponent write SetNormalLerpExponent;
    property AOSamples: Integer read GetAOSamples write SetAOSamples;
    property RadiositySamples: Integer read GetRadiositySamples write SetRadiositySamples;
    property PenumbraDetailFactor: Integer read GetPenumbraDetailFactor write SetPenumbraDetailFactor;
    property Shadows: Boolean read GetShadows write SetShadows;
    property Penumbra: Boolean read GetPenumbra write SetPenumbra;
  end;

{==============================================================================}
{== Lightmap options interface                                               ==}
{==============================================================================}
{== Holds the options available for the lightmap generation                  ==}
{==============================================================================}

  Tz3DLightMapOptions = class(Tz3DBase, Iz3DLightMapOptions)
  private
    FBlurSteps: Integer;
    FEnableAmbient: Boolean;
    FEnableRadiosity: Boolean;
    FRadiosityBounces: Integer;
    FDetailFactor: Integer;
  protected
    function GetEnableAmbient: Boolean; stdcall;
    function GetEnableRadiosity: Boolean; stdcall;
    function GetRadiosityBounces: Integer; stdcall;
    procedure SetEnableAmbient(const Value: Boolean); stdcall;
    procedure SetEnableRadiosity(const Value: Boolean); stdcall;
    procedure SetRadiosityBounces(const Value: Integer); stdcall;
    function GetBlurSteps: Integer; stdcall;
    procedure SetBlurSteps(const Value: Integer); stdcall;
    function GetDetailFactor: Integer; stdcall;
    procedure SetDetailFactor(const Value: Integer); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property DetailFactor: Integer read GetDetailFactor write SetDetailFactor;
    property BlurSteps: Integer read GetBlurSteps write SetBlurSteps;
    property EnableAmbient: Boolean read GetEnableAmbient write SetEnableAmbient;
    property EnableRadiosity: Boolean read GetEnableRadiosity write SetEnableRadiosity;
    property RadiosityBounces: Integer read GetRadiosityBounces write SetRadiosityBounces;
  end;

{==============================================================================}
{== Global lightmap controller interface                                     ==}
{==============================================================================}
{== Configures the global settings of the lightmap generation algorithm such ==}
{== as the texture format or the loading and saving path                     ==}
{==============================================================================}

  Tz3DLightMapController = class(Tz3DBase, Iz3DLightMapController)
  private
    FFolderName: PWideChar;
    FMaxTextureSize: Integer;
    FLightFileMask: PWideChar;
    FAOFileMask: PWideChar;
    FTotalLights: Integer;
    FLights: TIntegerArray;
  protected
    function GetLights: TIntegerArray; stdcall;
    function GetTotalLights: Integer; stdcall;
    function GetLightFileMask: PWideChar; stdcall;
    procedure SetLightFileMask(const Value: PWideChar); stdcall;
    function GetAOFileMask: PWideChar; stdcall;
    procedure SetAOFileMask(const Value: PWideChar); stdcall;
    function GetFolderName: PWideChar; stdcall;
    function GetMaxTextureSize: Integer; stdcall;
    procedure SetFolderName(const Value: PWideChar); stdcall;
    procedure SetMaxTextureSize(const Value: Integer); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    function GetTextureFileName(const ATextureName: PWideChar): PWideChar; stdcall;
    function CreateLightMap: Iz3DLightMap; stdcall;
    procedure Initialize; stdcall;
  public
    property FolderName: PWideChar read GetFolderName write SetFolderName;
    property LightFileMask: PWideChar read GetLightFileMask write SetLightFileMask;
    property AOFileMask: PWideChar read GetAOFileMask write SetAOFileMask;
    property MaxTextureSize: Integer read GetMaxTextureSize write SetMaxTextureSize;
    property TotalLights: Integer read GetTotalLights;
    property Lights: TIntegerArray read GetLights;
  end;

{==============================================================================}
{== Lightmap interface                                                       ==}
{==============================================================================}
{== Controls the lightmap creation and linking to an specific world static   ==}
{== object. It uses the ray tracer interface to generate the lighting        ==}
{==============================================================================}

  Tz3DLightMap = class(Tz3DBase, Iz3DLightMap)
  private
    FObject: Iz3DScenarioStaticObject;
    FObjectSize: Iz3DFloat3;
    FRadiosityLevel: Integer;
    FAreaFactor: Single;
    FOptions: Iz3DLightMapOptions;
    FRayTracer: Iz3DRayTracer;
    FDistribution: Tz3DLightMapDistribution;
    FDistributionIndices: TIntegerArray;
    FLightTextures: Tz3DLightMapTextures;
    FRadiosityTextures: Tz3DLightMapTextures;
    FAmbientTexture: Tz3DLightMapTexture;
    FUniqueName: PWideChar;
    FEnabled: Boolean;
    FGenerated: Boolean;
    FOnProgress: Tz3DCallbackLightMapProgressEvent;
    FStep: Tz3DLightMapGenerationStep;
  protected
    function GetOnProgress: Tz3DCallbackLightMapProgressEvent; stdcall;
    procedure SetOnProgress(const Value: Tz3DCallbackLightMapProgressEvent); stdcall;
    function GetCurrentObject: Iz3DScenarioStaticObject;
    function GetGenerated: Boolean; stdcall;
    function GetFacePlane(const AFace: Integer): Pz3DLightMapPlane; stdcall;
    function GetDistributionIndices: TIntegerArray; stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    function GetUniqueName: PWideChar; stdcall;
    procedure SetUniqueName(const Value: PWideChar); stdcall;
    function GetOffset: Integer; stdcall;
    function GetAmbientTexture: Tz3DLightMapTexture; stdcall;
    function GetLightTextures: Tz3DLightMapTextures; stdcall;
    function GetRadiosityTextures: Tz3DLightMapTextures; stdcall;
    function GetOptions: Iz3DLightMapOptions; stdcall;
    function GetRayTracer: Iz3DRayTracer; stdcall;
    function GetDistribution: Tz3DLightMapDistribution; stdcall;
    function GetWorldScale: Iz3DFloat3; stdcall;
    function GetSize: Integer; stdcall;
    procedure GetCoords(const AV1, AV2, AV3: Iz3DFloat2; const AAditional: Tz3DFloat2Array;
      var AMinU, AMaxU, AMinV, AMaxV, ADeltaU, ADeltaV: Single); stdcall;
    procedure GetWorldPlane(const ANormal, APointOnPlane: Iz3DFloat3; const AMinU, AMaxU,
      AMinV, AMaxV: Single; var APlane: Tz3DTriangle); stdcall;
    procedure InternalBeginStep(const AStep: Tz3DLightMapGenerationStep); stdcall;
    procedure InternalProgress(const APercent: Integer; const ALevel: Integer = -1); stdcall;

    procedure Blur(const ARect: TD3DLockedRect; const AOffsetU, AOffsetV, AWidth, AHeight: Integer); stdcall;
    procedure BlurTextures; stdcall;
    procedure BlurAndSave(var ATexture: Tz3DLightMapTexture); stdcall;
    procedure CopyRadiosityToTextures; stdcall;

    function AddPackNode(const ANode: Iz3DLightMapPackNode; const APlane: Tz3DLightMapPlane): Iz3DLightMapPackNode; stdcall;
    procedure GenerateLightCoords(const AObject: Iz3DBase; const AAdjacency: Pz3DDWordArray = nil); stdcall;
    procedure GeneratePlanarMapping(const AVB: Pointer; const AIB: PWordArray;
      const AFaceCount: Integer; const AAdjacency: Pz3DDWordArray; const AComputeCoords: Boolean); stdcall;
    procedure CreateTextures; stdcall;
    procedure SaveTextures; stdcall;
    procedure Distribute(const AVB: Pointer; const AIB: PWordArray;
      const AFaceCount: Integer; const AComputeCoords: Boolean); stdcall;

    procedure BeginDraw; stdcall;
    procedure EndDraw; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;

    function BeginGeneration(const AObject: Iz3DScenarioStaticObject; const AAdjacency: Pz3DDWordArray = nil;
      const AComputeCoords: Boolean = False): Boolean; stdcall;

    procedure BeginRadiosity; stdcall;
    function PerformRadiosityBounce: Boolean; stdcall;
    procedure EndRadiosityBounce; stdcall;
    procedure EndRadiosity; stdcall;

    function EndGeneration: Boolean; stdcall;
    function GenerationNeeded: Boolean; stdcall;
  public
    property AmbientTexture: Tz3DLightMapTexture read GetAmbientTexture;
    property LightTextures: Tz3DLightMapTextures read GetLightTextures;
    property RadiosityTextures: Tz3DLightMapTextures read GetRadiosityTextures;
    property DistributionIndices: TIntegerArray read GetDistributionIndices;
    property FacePlane[const AFace: Integer]: Pz3DLightMapPlane read GetFacePlane;
    property Generated: Boolean read GetGenerated;
    property Distribution: Tz3DLightMapDistribution read GetDistribution;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property CurrentObject: Iz3DScenarioStaticObject read GetCurrentObject;
    property Options: Iz3DLightMapOptions read GetOptions;
    property RayTracer: Iz3DRayTracer read GetRayTracer;
    property WorldScale: Iz3DFloat3 read GetWorldScale;
    property UniqueName: PWideChar read GetUniqueName write SetUniqueName;
    property Size: Integer read GetSize;
    property Offset: Integer read GetOffset;
    property OnProgress: Tz3DCallbackLightMapProgressEvent read GetOnProgress write SetOnProgress;
  end;

function z3DTriangle: Tz3DTriangle; stdcall;

// Lighting calculations
function z3DLightingDiffuseDirectional(const ANormal, ALight: Iz3DFloat3): Single; stdcall;
function z3DLightingDiffuse(const ANormal, ALight: Iz3DFloat3; const ADistance, ARange: Single): Single; stdcall;
function z3DLightingSpot(const ALight, ADirection: Iz3DFloat3; const AAngle, ASharpness: Single): Single; stdcall;

// Common lighting functions
function z3DRay(const AOrigin, ADirection: Iz3DFloat3; const ALength: Single = 1): Tz3DRay; stdcall;

// Controller management
function z3DLightMapController: Iz3DLightMapController; stdcall;
function z3DLightingController: Iz3DLightingController; stdcall;
function z3DCreateLightingController: Iz3DLightingController; stdcall;
function z3DCreateLightMapController: Iz3DLightMapController; stdcall;
procedure z3DSetCustomLightingController(const AController: Iz3DLightingController); stdcall;
procedure z3DSetCustomLightMapController(const AController: Iz3DLightMapController); stdcall;

implementation

uses z3DMath_Func, Math, z3DEngine_Func, z3DComponents_Func, z3DCore_Func,
  z3DModels_Func, D3DX9, z3DStrings, z3DFileSystem_Func, z3DFileSystem_Intf,
  z3DEngine_Intf, z3DModels_Intf, z3DScenario_Func, z3DFunctions;

{uses Forms, Math, z3DEngine, z3DModels, z3DStrings, z3DFileSystem;}

function z3DRay(const AOrigin, ADirection: Iz3DFloat3; const ALength: Single = 1): Tz3DRay;
begin
  Result.Origin:= AOrigin;
  Result.Direction:= ADirection;
  Result.Length:= ALength;
end;

var GLightMapController: Iz3DLightMapController;
    GLightingController: Iz3DLightingController;

function z3DLightMapController: Iz3DLightMapController;
begin
  Result:= GLightMapController;
end;

function z3DLightingController: Iz3DLightingController;
begin
  Result:= GLightingController;
end;

function z3DCreateLightingController: Iz3DLightingController;
begin
  z3DTrace('z3DCreateLightingController: Creating lighting controller object...', z3DtkInformation);
  GLightingController:= Tz3DLightingController.Create;
  Result:= GLightingController;
end;

function z3DCreateLightMapController: Iz3DLightMapController;
begin
  z3DTrace('z3DCreateLightMapController: Creating lightmap controller object...', z3DtkInformation);
  GLightMapController:= Tz3DLightMapController.Create;
  Result:= GLightMapController;
end;

procedure z3DSetCustomLightingController(const AController: Iz3DLightingController);
begin
  GLightingController:= AController;
end;

procedure z3DSetCustomLightMapController(const AController: Iz3DLightMapController);
begin
  GLightMapController:= AController;
end;

function z3DTriangle: Tz3DTriangle;
begin
  Result[0]:= z3DFloat3;
  Result[1]:= z3DFloat3;
  Result[2]:= z3DFloat3;
end;

function z3DLightingDiffuseDirectional(const ANormal, ALight: Iz3DFloat3): Single;
var FNormal, FLight: Iz3DFloat3;
begin
  // N dot L
  FNormal:= z3DFloat3.From(ANormal).Normalize;
  FLight:= z3DFloat3.From(ALight).Normalize;
  Result:= Saturate(FNormal.Dot(FLight));
end;

function z3DLightingDiffuse(const ANormal, ALight: Iz3DFloat3; const ADistance, ARange: Single): Single;
begin
  // N dot L with falloff
  Result:= (z3DLightingDiffuseDirectional(ANormal, ALight) / ADistance) * Saturate(1 - ADistance / ARange);
end;

function z3DLightingSpot(const ALight, ADirection: Iz3DFloat3; const AAngle, ASharpness: Single): Single;
begin
  // Spotlight cone: D dot L - sin(radians(Angle))
  Result:= Saturate(ASharpness * (Saturate(ALight.Dot(ADirection)) - Sin(DegToRad(AAngle / 2))));
end;

{ Tz3DLightEffects }

procedure Tz3DLightEffects.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FGlow:= True;
  FGlowFactor:= 0.5;
  FMultiSampleGlow:= True;
  FLight:= Pointer(AOwner);
  FNormalMapping:= True;
  FStaticPenumbra:= False;
  FSpecular:= True;
  FStaticShadows:= True;
  FDynamicShadows:= True;
end;

procedure Tz3DLightEffects.Cleanup;
begin
  FLight:= nil;
  inherited;
end;

function Tz3DLightEffects.GetDynamicShadows: Boolean;
begin
  Result:= FDynamicShadows;
end;

function Tz3DLightEffects.GetGlow: Boolean;
begin
  Result:= FGlow;
end;

function Tz3DLightEffects.GetGlowFactor: Single;
begin
  Result:= FGlowFactor;
end;

function Tz3DLightEffects.GetMultiSampleGlow: Boolean;
begin
  Result:= FMultiSampleGlow;
end;

function Tz3DLightEffects.GetNormalMapping: Boolean;
begin
  Result:= FNormalMapping;
end;

function Tz3DLightEffects.GetSpecular: Boolean;
begin
  Result:= FSpecular;
end;

function Tz3DLightEffects.GetStaticPenumbra: Boolean;
begin
  Result:= FStaticPenumbra;
end;

function Tz3DLightEffects.GetStaticShadows: Boolean;
begin
  Result:= FStaticShadows;
end;

procedure Tz3DLightEffects.SetDynamicShadows(const Value: Boolean);
begin
  if FDynamicShadows <> Value then
  begin
    FDynamicShadows:= Value;
    if z3DEngine.Scenario.Enabled then
    begin
      Light.CreateDepthMap;
      Light.SetLightingTechnique;
    end;
  end;
end;

procedure Tz3DLightEffects.SetGlow(const Value: Boolean);
begin
  FGlow:= Value;
end;

procedure Tz3DLightEffects.SetGlowFactor(const Value: Single);
begin
  FGlowFactor:= Value;
end;

procedure Tz3DLightEffects.SetMultiSampleGlow(const Value: Boolean);
begin
  FMultiSampleGlow:= Value;
end;

procedure Tz3DLightEffects.SetNormalMapping(const Value: Boolean);
begin
  if FNormalMapping <> Value then
  begin
    FNormalMapping:= Value;
    if z3DEngine.Scenario.Enabled then
    Light.SetLightingTechnique;
  end;
end;

procedure Tz3DLightEffects.SetSpecular(const Value: Boolean);
begin
  if FSpecular <> Value then
  begin
    FSpecular:= Value;
    if z3DEngine.Scenario.Enabled then
    Light.SetLightingTechnique;
  end;
end;

procedure Tz3DLightEffects.SetStaticPenumbra(const Value: Boolean);
begin
  FStaticPenumbra:= Value;
end;

procedure Tz3DLightEffects.SetStaticShadows(const Value: Boolean);
begin
  if FStaticShadows <> Value then
  begin
    FStaticShadows:= Value;
    if z3DEngine.Scenario.Enabled then
    Light.SetLightingTechnique;
  end;
end;

function Tz3DLightEffects.GetLight: Iz3DLight;
begin
  Result:= Iz3DBase(FLight) as Iz3DLight;
end;

{ Tz3DLight }

procedure Tz3DLight.Init(const AOwner: Iz3DBase);
var I: Integer;
begin
  inherited;
  FDynamicMode:= False;
  FStatic:= False;
  FColor:= z3DFloat3;
  FEffects:= Tz3DLightEffects.Create(Self);
  FTexMatrix:= z3DMatrix;
  FTexViewProjMatrix:= z3DMatrix;
  for I:= 0 to 5 do FCubeViewMatrix[I]:= z3DMatrix;
  FStaticDepthMap:= z3DCreateRenderTexture;
  FStaticDepthMap.SamplerState.Filter:= z3dsfBilinear;
  FStaticDepthMap.SamplerState.AddressMode:= z3dsamBorder;
  FStaticDepthMap.SamplerState.BorderColor:= z3DFloat3(1, 1, 1);
  FStaticDepthMap.AutoParams:= False;
  FStaticCubeDepthMap:= z3DCreateCubeRenderTexture;
  FStaticCubeDepthMap.SamplerState.Filter:= z3dsfBilinear;
  GetMem(FName, 255);
  FRange:= 20;
  FEnabled:= True;
  FAngle:= 90;
  FSharpness:= 10;
  FIntensity:= 1;
  FFrustum:= z3DCreateFrustum;
  FSize:= 0.25;
  FStyle:= z3dlsPoint;
  if z3DEngine.Scenario.Enabled then
  CreateDepthMap;
end;

procedure Tz3DLight.Cleanup;
var I: Integer;
begin
  z3DCleanupFree(FColor);
  z3DCleanupFree(FEffects);
  z3DCleanupFree(FTexMatrix);
  z3DCleanupFree(FTexViewProjMatrix);
  for I:= 0 to 5 do z3DCleanupFree(FCubeViewMatrix[I]);
  z3DCleanupFree(FStaticDepthMap);
  z3DCleanupFree(FStaticCubeDepthMap);
  z3DFreeWideChar(FName);
  inherited;
end;

procedure Tz3DLight.MeasureLightEffectParams;
var FPrevX, FPrevY, FPrevZ: Single;
    FPrevX2, FPrevY2, FPrevZ2: Single;
begin
  if {not Effects.DynamicShadows or }not z3DEngine.Device.Created then Exit;

  case Style of

    // Build the cube frustum
    z3dlsPoint:
    begin
      Frustum.ProjectionKind:= z3dpkPerspective;
      Frustum.NearClip:= 0.01;
      Frustum.FarClip:= FRange + 1;
      Frustum.AspectRatio:= 1;
      Frustum.FieldOfView:= z3DPI / 2;
      Frustum.ApplyChanges;
      FCubeViewMatrix[0].LookAt(Frustum.Position, z3DFloat3(Frustum.Position.X+1, Frustum.Position.Y,   Frustum.Position.Z),   z3DFloat3(0, 1, 0)).Multiply(Frustum.ProjectionMatrix);
      FCubeViewMatrix[1].LookAt(Frustum.Position, z3DFloat3(Frustum.Position.X-1, Frustum.Position.Y,   Frustum.Position.Z),   z3DFloat3(0, 1, 0)).Multiply(Frustum.ProjectionMatrix);
      FCubeViewMatrix[2].LookAt(Frustum.Position, z3DFloat3(Frustum.Position.X,   Frustum.Position.Y+1, Frustum.Position.Z),   z3DFloat3(0, 0,-1)).Multiply(Frustum.ProjectionMatrix);
      FCubeViewMatrix[3].LookAt(Frustum.Position, z3DFloat3(Frustum.Position.X,   Frustum.Position.Y-1, Frustum.Position.Z),   z3DFloat3(0, 0, 1)).Multiply(Frustum.ProjectionMatrix);
      FCubeViewMatrix[4].LookAt(Frustum.Position, z3DFloat3(Frustum.Position.X,   Frustum.Position.Y,   Frustum.Position.Z+1), z3DFloat3(0, 1, 0)).Multiply(Frustum.ProjectionMatrix);
      FCubeViewMatrix[5].LookAt(Frustum.Position, z3DFloat3(Frustum.Position.X,   Frustum.Position.Y,   Frustum.Position.Z-1), z3DFloat3(0, 1, 0)).Multiply(Frustum.ProjectionMatrix);
    end;

    z3dlsSpot:
    begin
      // Build the light view matrix

      Frustum.ProjectionKind:= z3dpkPerspective;
      Frustum.NearClip:= 0.01;
      Frustum.FarClip:= FRange + 10;
      Frustum.AspectRatio:= 1;
      FPrevX:= Frustum.LookAt.X;
      FPrevY:= Frustum.LookAt.Y;
      FPrevZ:= Frustum.LookAt.Z;
      Frustum.LookAt.Add(Frustum.Position);
      Frustum.FieldOfView:= DegToRad(180-(FAngle * 0.8));
      Frustum.ApplyChanges;
      Frustum.LookAt.X:= FPrevX;
      Frustum.LookAt.Y:= FPrevY;
      Frustum.LookAt.Z:= FPrevZ;

      // Build the texture projection matrix
      FTexViewProjMatrix:= z3DMatrix.From(Frustum.ViewProjMatrix).Multiply(FTexMatrix);
      FTexViewProjMatrix.e43:= FTexViewProjMatrix.e43-z3DLightingController.ShadowMapOffset;
    end;

    z3dlsDirectional:
    begin

      // Build the view and orthogonal projection matrix
      FPrevX:= Frustum.Position.X;
      FPrevY:= Frustum.Position.Y;
      FPrevZ:= Frustum.Position.Z;
      Frustum.ProjectionKind:= z3dpkOrthogonal;
      Frustum.Position.From(z3DScenario.ViewFrustum.Position).Add(z3DFloat3.From(Frustum.LookAt).
      Scale(-z3DLightingController.DirShadowMapAreaSize * 0.5 + 5));
      Frustum.Position.X:= Trunc(Frustum.Position.X * 0.25) * 4;
      Frustum.Position.Y:= Trunc(Frustum.Position.Y * 0.25) * 4;
      Frustum.Position.Z:= Trunc(Frustum.Position.Z * 0.25) * 4;
      Frustum.NearClip:= 0.01;
      Frustum.FarClip:= z3DLightingController.DirShadowMapAreaSize;
      FPrevX2:= Frustum.LookAt.X;
      FPrevY2:= Frustum.LookAt.Y;
      FPrevZ2:= Frustum.LookAt.Z;
      Frustum.LookAt.Add(Frustum.Position);
      Frustum.VolumeWidth:= z3DLightingController.DirShadowMapAreaSize;
      Frustum.VolumeHeight:= z3DLightingController.DirShadowMapAreaSize;
      Frustum.ApplyChanges;
      Frustum.LookAt.X:= FPrevX2;
      Frustum.LookAt.Y:= FPrevY2;
      Frustum.LookAt.Z:= FPrevZ2;

      // Build the texture projection matrix
      FTexViewProjMatrix:= z3DMatrix.From(Frustum.ViewProjMatrix).Multiply(FTexMatrix);
      FTexViewProjMatrix.e43:= FTexViewProjMatrix.e43-z3DLightingController.DirShadowMapOffset;

      if z3DEngine.Renderer.Rendering and ((Frustum.Position.X <> FPrevX) or (Frustum.Position.Y <> FPrevY) or
      (Frustum.Position.Z <> FPrevZ)) then
      begin
//        UpdateLightingParams;
        BuildStaticShadowMap;
      end;
    end;
  end;
end;

procedure Tz3DLight.UpdateLightingParams;
var FPos4: Iz3DFloat4;
    FDepthSize: Single;
begin

  // Set shadow parameters
  if z3DEngine.Device.EngineCaps.ShadowMapSupport and Effects.DynamicShadows then
  begin
    if Style = z3dlsDirectional then
    FDepthSize:= z3DLightingController.DirectionalDepthMapSize else
    FDepthSize:= z3DLightingController.DepthMapSize;
    z3DLightingController.Shader.Param['GDepthMapSize']:= FDepthSize;
    z3DLightingController.Shader.Param['GInvDepthMapSize']:= 1 / FDepthSize;
    z3DLightingController.Shader.Matrix['GTextureProjectionMatrix']:= FTexViewProjMatrix;
    if Style <> z3dlsPoint then
    begin
      z3DLightingController.Shader.Matrix['GLightViewMatrix']:= Frustum.ViewMatrix;
      z3DLightingController.Shader.Matrix['GLightViewProjectionMatrix']:= Frustum.ViewProjMatrix;
    end;
  end;

  // Set lighting parameters
  FPos4:= z3DFloat4(Frustum.Position.X, Frustum.Position.Y, Frustum.Position.Z, 1);
  z3DLightingController.Shader.Float4['GLightPos']:= FPos4;
  FPos4.Transform(z3DScenario.ViewFrustum.ViewMatrix);
  z3DLightingController.Shader.Float4['GLightPosView']:= FPos4;
  // TODO JP: RENOMBRAR A ALGO COMO GLightDirInv
  FPos4:= z3DFloat4(-Frustum.LookAt.X, -Frustum.LookAt.Y, -Frustum.LookAt.Z, 0);
  FPos4.Transform(z3DScenario.ViewFrustum.ViewMatrix).Normalize;
  z3DLightingController.Shader.Float4['GLightDirView']:= FPos4;
  if Style = z3dlsDirectional then z3DLightingController.Shader.Param['GLightSize']:= Size / 25000 else
  z3DLightingController.Shader.Param['GLightSize']:= Size / 50;
  z3DLightingController.Shader.Param['GLightRange']:= Range;
  if Style = z3dlsDirectional then z3DLightingController.Shader.Param['GDepthMapRange']:=
  z3DLightingController.DirShadowMapAreaSize else
  z3DLightingController.Shader.Param['GDepthMapRange']:= Range + 10;
  if Style = z3dlsSpot then
  begin
    z3DLightingController.Shader.Param['GLightSharpness']:= Sharpness;
    z3DLightingController.Shader.Param['GLightAngle']:= Sin(DegToRad(Angle / 2));
  end;
  z3DLightingController.Shader.Color3['GLightColor']:= Color;
  z3DLightingController.Shader.Param['GLightIntensity']:= FIntensity;
end;

procedure Tz3DLight.UpdateSourceParams;
begin
  z3DLightingController.Shader.Color3['GLightColor']:= Color;
end;

procedure Tz3DLight.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled:= Value;
    if z3DEngine.Device.Created then MeasureLightEffectParams;
  end;
end;

procedure Tz3DLight.SetRange(const Value: Single);
begin
  if FRange <> Value then
  begin
    FRange:= Value;
    if z3DEngine.Device.Created then MeasureLightEffectParams;
  end;
end;

procedure Tz3DLight.SetStyle(const Value: Tz3DLightStyle);
begin
  if FStyle <> Value then
  begin
    FStyle:= Value;
    if z3DEngine.Device.Created then
    begin
      CreateDepthMap;
      MeasureLightEffectParams;
    end;
  end;
end;

procedure Tz3DLight.SetAngle(const Value: Single);
begin
  if FAngle <> Value then
  begin
    FAngle:= Value;
    if z3DEngine.Device.Created then MeasureLightEffectParams;
  end;
end;

procedure Tz3DLight.SetSharpness(const Value: Single);
begin
  FSharpness:= Value;
end;

procedure Tz3DLight.TurnOff;
begin
  Enabled:= False;
end;

procedure Tz3DLight.TurnOn;
begin
  Enabled:= True;
end;

procedure Tz3DLight.ResetDevice;
begin
  if z3DEngine.Scenario.Enabled then MeasureLightEffectParams;
end;

procedure Tz3DLight.BuildDynamicShadowMap;
begin
  if not Effects.DynamicShadows then Exit;
  if z3DModelController = nil then Exit;

// TODO JP: VER COMO HACER PARA LUCES DIRECCIONALES
//  if not Frustum.Stats.AnyVisibleOpaqueObject then Exit;

  // HW shadow mapping
  if z3DLightingController.UseHWShadows and (Style <> z3dlsPoint) then
  begin
    if Style = z3dlsDirectional then
    BuildShadowMap(z3DLightingController.TempDirDepthMap, z3DLightingController.DirDepthMap.GetSurface) else
    BuildShadowMap(z3DLightingController.TempDepthMap, z3DLightingController.DepthMap.GetSurface);
  end else

  // Standard shadow mapping
  begin
    case Style of
      z3dlsDirectional: BuildShadowMap(z3DLightingController.DirDepthMap, z3DLightingController.DepthBuffer);
      z3dlsSpot: BuildShadowMap(z3DLightingController.DepthMap, z3DLightingController.DepthBuffer);
      z3dlsPoint: BuildShadowMap(z3DLightingController.CubeDepthMap, z3DLightingController.DepthBuffer);
    end;
  end;

  // Set the shadow map texture
  case Style of
    z3dlsDirectional: z3DLightingController.DirDepthMap.AttachToSampler(4, True, True);
    z3dlsSpot: z3DLightingController.DepthMap.AttachToSampler(4, True, True);
    z3dlsPoint: z3DLightingController.CubeDepthMap.AttachToSampler(4, True, True);
  end;

end;

procedure Tz3DLight.BuildStaticShadowMap;
begin
  MeasureLightEffectParams;
  UpdateLightingParams;
  if not Effects.StaticShadows or not Static then Exit;
  if z3DModelController = nil then Exit;

  // HW shadow mapping
  if z3DLightingController.UseHWShadows and (Style <> z3dlsPoint) then
  begin
    if Style = z3dlsDirectional then
    BuildShadowMap(z3DLightingController.TempDirDepthMap, FStaticDepthMap.GetSurface, True) else
    BuildShadowMap(z3DLightingController.TempDepthMap, FStaticDepthMap.GetSurface, True);
  end else

  // Standard shadow mapping
  if Style <> z3dlsPoint then
  BuildShadowMap(FStaticDepthMap, z3DLightingController.DepthBuffer, True) else
  BuildShadowMap(FStaticCubeDepthMap, z3DLightingController.DepthBuffer, True);
end;

procedure Tz3DLight.BuildShadowMap(const ATarget: Iz3DBaseTexture; const ADepth: Iz3DSurface;
  const AStatic: Boolean = False);
var FOldDepthBuffer, FOldRT: IDirect3DSurface9;
    I, J: Integer;
begin
  if not Effects.DynamicShadows or not z3DEngine.Device.EngineCaps.ShadowMapSupport then Exit;

  // Save previous depth stencil
  z3DCore_GetD3DDevice.GetDepthStencilSurface(FOldDepthBuffer);

  // Prepare device for rendering
  z3DCore_GetD3DDevice.SetDepthStencilSurface(ADepth.D3DSurface);
  z3DEngine.Renderer.BeginZWrite;
  z3DEngine.Renderer.DisableBlending;
  if z3DLightingController.UseHWShadows and (Style <> z3dlsPoint) then
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, 0) else
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED);
  if AStatic then FStage:= z3ddlrsStaticShadows else FStage:= z3ddlrsDynamicShadows;

  try
    if Style = z3dlsPoint then
    begin
      z3DLightingController.Shader.Technique:= 'z3DLighting_CubeDepthMap';
      z3DCore_GetD3DDevice.GetRenderTarget(0, FOldRT);
      try
        for I:= 0 to 5 do
        begin
          (ATarget as Iz3DCubeRenderTexture).SetRenderTarget(TD3DCubeMapFaces(I));
          z3DCore_GetD3DDevice.Clear(0, nil, D3DCLEAR_ZBUFFER or D3DCLEAR_TARGET, MaxInt, 1, 0);
          z3DLightingController.Shader.Matrix['GLightViewProjectionMatrix']:= FCubeViewMatrix[I];
          for J:= 0 to z3DLightingController.Shader.Prepare-1 do
          begin
            z3DLightingController.Shader.BeginPass;
            z3DEngine.NotifyLinks_z3DDirectLightRender;
            z3DLightingController.Shader.EndPass;
          end;
        end;
      finally
        z3DCore_GetD3DDevice.SetRenderTarget(0, FOldRT);
      end;
    end else
    begin
      if z3DLightingController.UseHWShadows then
      z3DLightingController.Shader.Technique:= 'z3DLighting_DepthMapHW' else
      z3DLightingController.Shader.Technique:= 'z3DLighting_DepthMap';
//      ST:= GetTickCount;
      (ATarget as Iz3DRenderTexture).SetRenderTarget(0, True);
      try
        if z3DLightingController.UseHWShadows then z3DEngine.Renderer.ClearDepthBuffer else
        z3DCore_GetD3DDevice.Clear(0, nil, D3DCLEAR_ZBUFFER or D3DCLEAR_TARGET, MaxInt, 1, 0);
        for J:= 0 to z3DLightingController.Shader.Prepare-1 do
        begin
          z3DLightingController.Shader.BeginPass;
          z3DEngine.NotifyLinks_z3DDirectLightRender;
          z3DLightingController.Shader.EndPass;
        end;
      finally
//        z3DTrace(PWideChar(WideString(IntToStr(GetTickCount-ST))), z3DtkError);
        (ATarget as Iz3DRenderTexture).RestoreRenderTarget;
      end;
    end;
  finally

    // Restore previous device state
    z3DCore_GetD3DDevice.SetDepthStencilSurface(FOldDepthBuffer);
    z3DEngine.Renderer.EndZWrite;
    if z3DLightingController.OpaqueMode then
    z3DEngine.Renderer.EnableAdditiveBlending else
    begin
      z3DEngine.Renderer.EnableAlphaBlending;
      z3DCore_GetD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
    end;
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED or D3DCOLORWRITEENABLE_GREEN or
      D3DCOLORWRITEENABLE_BLUE or D3DCOLORWRITEENABLE_ALPHA);
  end;
end;

procedure Tz3DLight.RenderWorld;
var I: Integer;
begin
  if not Enabled or (Color.Length = 0) then Exit;
//  if Assigned(FOnFrameRender) then FOnFrameRender(Self, z3d);
  {if Style = z3dlsDirectional then }MeasureLightEffectParams;

  UpdateLightingParams;

  // Render dynamic shadows
  if Effects.DynamicShadows and z3DLightingController.OpaqueMode then
  BuildDynamicShadowMap;

  // Render light
  SetLightingTechnique;

  // Static lighting
  if Static then
  begin
    FStage:= z3ddlrsStaticLighting;
    for I:= 0 to z3DLightingController.Shader.Prepare-1 do
    begin
      z3DLightingController.Shader.BeginPass;
      z3DEngine.NotifyLinks_z3DDirectLightRender;
      z3DLightingController.Shader.EndPass;
    end;
  end;

  // Dynamic lighting or dynamic mode for static lighting
  try
    if Static then
    begin
      FDynamicMode:= True;
      SetLightingTechnique;
      if Effects.StaticShadows then
      begin
        if Style = z3dlsPoint then
        FStaticCubeDepthMap.AttachToSampler(5, True, True) else
        FStaticDepthMap.AttachToSampler(5, True, True);
      end;
    end;
    FStage:= z3ddlrsDynamicLighting;
    for I:= 0 to z3DLightingController.Shader.Prepare-1 do
    begin
      z3DLightingController.Shader.BeginPass;
      z3DEngine.NotifyLinks_z3DDirectLightRender;
      z3DLightingController.Shader.EndPass;
    end;
  finally
    FDynamicMode:= False;
    if Static then SetLightingTechnique;
  end;
//  if Assigned(FOnFrameRender) then FOnFrameRender(z3dfsAfterEnd);
end;

procedure Tz3DLight.RenderSource;
var FLightView: Iz3DFloat4;
    FScreenPos: Iz3DFloat2;
    FVisible: Boolean;
begin
  if not Enabled then Exit;

  // Render glow effect when enabled
  if Effects.Glow then
  begin

    // If the light is outside the frustum, skip rendering
    if Style = z3dlsDirectional then
    FVisible:= not z3DScenario.ViewFrustum.TestCulling(z3DFloat3.From(Frustum.LookAt).Normalize.Scale(-500)) else
    FVisible:= not z3DScenario.ViewFrustum.TestCulling(Frustum.Position);
    if not FVisible then Exit;

    // Set the glow technique
    if Effects.MultiSampleGlow then
    z3DLightingController.Shader.Technique:= 'z3DLighting_GlowMS' else
    z3DLightingController.Shader.Technique:= 'z3DLighting_Glow';

    UpdateSourceParams;

    if Style = z3dlsDirectional then
    FLightView:= z3DFloat4(Frustum.LookAt.X, Frustum.LookAt.Y, Frustum.LookAt.Z, 0).
    Normalize.Scale(-500).Transform(z3DScenario.ViewFrustum.ViewProjMatrix) else
    FLightView:= z3DFloat4(Frustum.Position.X, Frustum.Position.Y, Frustum.Position.Z, 1).Transform(z3DScenario.ViewFrustum.ViewProjMatrix);
    if (Style <> z3dlsDirectional) and (FLightView.z > Range + 0.001) then Exit;

    // Light screen position
    FScreenPos:= z3DFloat2(FLightView.x / FLightView.z * 0.5 + 0.5, -FLightView.y / FLightView.z * 0.5 + 0.5);
    z3DLightingController.Shader.Float2['GScreenPos']:= FScreenPos;

    // Distance from light to camera
    if Style = z3dlsDirectional then
    z3DLightingController.Shader.Param['GLightDistance']:= 0.98 else
    z3DLightingController.Shader.Param['GLightDistance']:= FLightView.z / (z3DEngine.Scenario.ViewFrustum.FarClip);

    // Glow factor, determined by GlowFactor property and screen position
    z3DLightingController.Shader.Param['GGlowFactor']:= Effects.GlowFactor *
      Saturate(0.75 - FScreenPos.Subtract(z3DFloat2(0.5, 0.5)).Length) * Intensity;

    // Glow scale, determined by light size and light distance scaled to range
    if Style = z3dlsDirectional then
    z3DLightingController.Shader.Float2['GGlowScale']:= z3DFloat2((Size / 30) *
    z3DCore_GetBackBufferSurfaceDesc.Height/z3DCore_GetBackBufferSurfaceDesc.Width, Size / 30) else
    z3DLightingController.Shader.Float2['GGlowScale']:= z3DFloat2(Max(0, Range / FLightView.z - 1) * Size *
    z3DCore_GetBackBufferSurfaceDesc.Height/z3DCore_GetBackBufferSurfaceDesc.Width,
    Max(0, Range / FLightView.z - 1) * Size);

    // Render the glow effect
    z3DEngine.Renderer.Blend([], z3DLightingController.Shader);
  end;
end;

procedure Tz3DLight.SetLightingTechnique;
const FStyles: array[Tz3DLightStyle] of string = ('Diffuse', 'Point', 'Spot', 'Directional');
const FSpecular: array[Boolean] of string = ('', 'Spec');
const FShadowMap: array[Boolean] of string = ('', 'SM');
const FMSShadows: array[Boolean] of string = ('', 'MS');
const FHWShadows: array[Boolean] of string = ('', 'HW');
const FStaticShadowMap: array[Boolean] of string = ('', 'SSM');
const FNormalMap: array[Boolean] of string = ('', 'NM');
const FRadiosity: array[Boolean] of string = ('', 'Rad');
const FStatics: array[Boolean] of string = ('', '_Static');
var FTechnique: Tz3DHandle;
begin
  if not z3DEngine.Device.Created then Exit;
  FTechnique:= Tz3DHandle(Format('z3DLighting_%sLight%s%s%s%s%s%s%s%s', [FStyles[Style],
  FSpecular[Effects.Specular], FShadowMap[Effects.DynamicShadows and z3DEngine.Device.EngineCaps.ShadowMapSupport],
  FMSShadows[Effects.DynamicShadows and z3DEngine.Device.EngineCaps.ShadowMapSupport and (z3DLightingController.ShadowQuality = z3dsqHigh)],
  FHWShadows[Effects.DynamicShadows and z3DEngine.Device.EngineCaps.ShadowMapSupport and z3DLightingController.UseHWShadows],
  FNormalMap[Effects.NormalMapping and
  (z3DEngine.Device.EngineCaps.ShaderModel3Supported)], FStatics[Static and not FDynamicMode], FStaticShadowMap[Static and FDynamicMode and
  Effects.StaticShadows], FRadiosity[Static and not FDynamicMode and TRUE {TODO JP}]]));
  z3DLightingController.Shader.Technique:= FTechnique;
end;

procedure Tz3DLight.SetIntensity(const Value: Single);
begin
  FIntensity:= Value;
end;

procedure Tz3DLight.SetStatic(const Value: Boolean);
begin
  if FStatic <> Value then
  begin
    FStatic:= Value;
    SetLightingTechnique;
  end;
end;

procedure Tz3DLight.PrepareDepthMap;
var FDepthSize: Integer;
begin
  if not Effects.StaticShadows or not z3DEngine.Device.EngineCaps.ShadowMapSupport then
  begin
    FStaticCubeDepthMap.Enabled:= False;
    FStaticDepthMap.Enabled:= False;
    Exit;
  end;

  if Style = z3dlsDirectional then
  FDepthSize:= z3DLightingController.DirectionalDepthMapSize else
  FDepthSize:= z3DLightingController.DepthMapSize;

  // Set the parameters for the static depth map
  if Style = z3dlsPoint then
  begin
    FStaticDepthMap.Enabled:= False;
    FStaticCubeDepthMap.Size:= FDepthSize;
    FStaticCubeDepthMap.Format:= z3DEngine.Device.EngineCaps.CubeShadowMapFormat;
    FStaticCubeDepthMap.Enabled:= True;
  end else
  begin
    FStaticCubeDepthMap.Enabled:= False;
    FStaticDepthMap.Width:= FDepthSize;
    FStaticDepthMap.Height:= FDepthSize;

    // Hardware Shadow Mapping support
    if z3DLightingController.UseHWShadows then
    begin
      FStaticDepthMap.Usage:= D3DUSAGE_DEPTHSTENCIL;
      FStaticDepthMap.Format:= z3DCore_GetDeviceSettings.PresentParams.AutoDepthStencilFormat;
    end else
    begin
      FStaticDepthMap.Usage:= D3DUSAGE_RENDERTARGET;
      FStaticDepthMap.Format:= z3DEngine.Device.EngineCaps.ShadowMapFormat;
    end;
    FStaticDepthMap.Enabled:= True;
  end;
end;

procedure Tz3DLight.CreateDepthMap;
begin
  PrepareDepthMap;
  if FStaticCubeDepthMap.Enabled then FStaticCubeDepthMap.CreateD3DTexture else
  if FStaticDepthMap.Enabled then FStaticDepthMap.CreateD3DTexture;
end;

function Tz3DLight.GetAngle: Single;
begin
  Result:= FAngle;
end;

function Tz3DLight.GetColor: Iz3DFloat3;
begin
  Result:= FColor;
end;

function Tz3DLight.GetEffects: Iz3DLightEffects;
begin
  Result:= FEffects;
end;

function Tz3DLight.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

function Tz3DLight.GetIntensity: Single;
begin
  Result:= FIntensity;
end;

function Tz3DLight.GetOnRender: Tz3DDirectLightRenderEvent;
begin
  Result:= FOnRender;
end;

function Tz3DLight.GetRange: Single;
begin
  Result:= FRange;
end;

function Tz3DLight.GetSharpness: Single;
begin
  Result:= FSharpness;
end;

function Tz3DLight.GetSize: Single;
begin
  Result:= FSize;
end;

function Tz3DLight.GetStatic: Boolean;
begin
  Result:= FStatic;
end;

function Tz3DLight.GetStyle: Tz3DLightStyle;
begin
  Result:= FStyle;
end;

procedure Tz3DLight.SetOnRender(const Value: Tz3DDirectLightRenderEvent);
begin
  FOnRender:= Value;
end;

procedure Tz3DLight.SetSize(const Value: Single);
begin
  FSize:= Value;
end;

function Tz3DLight.GetIndex: Integer;
begin
  Result:= z3DLightingController.IndexOfLight(Self);
end;

procedure Tz3DLight.PropertyChanged(const ASender: Iz3DBase);
begin
  MeasureLightEffectParams;
end;

procedure Tz3DLight.StartScenario;
begin
  CreateDepthMap;
  BuildTextureProjectionMatrix;
  MeasureLightEffectParams;
end;

procedure Tz3DLight.RenderPrecomputation;
begin
  UpdateLightingParams;
  if Effects.StaticShadows then BuildStaticShadowMap;
end;

function Tz3DLight.GetDynamicMode: Boolean;
begin
  Result:= FDynamicMode;
end;

procedure Tz3DLight.SetDynamicMode(const Value: Boolean);
begin
  FDynamicMode:= Value;
end;

function Tz3DLight.GetName: PWideChar;
begin
  Result:= FName;
end;

procedure Tz3DLight.SetName(const Value: PWideChar);
begin
  FName:= Value;
end;

function Tz3DLight.GetStage: Tz3DDirectLightRenderStage;
begin
  Result:= FStage;
end;

function Tz3DLight.GetFrustum: Iz3DFrustum;
begin
  Result:= FFrustum;
end;

procedure Tz3DLight.BuildTextureProjectionMatrix;
begin
  FTexMatrix.Identity;
  FTexMatrix.e11:= 0.5;
  FTexMatrix.e22:= -0.5;
  if Style = z3dlsDirectional then
  FTexMatrix.e41:= 0.5 / z3DLightingController.DirectionalDepthMapSize + 0.5 else
  FTexMatrix.e41:= 0.5 / z3DLightingController.DepthMapSize + 0.5;
  FTexMatrix.e42:= FTexMatrix.e41;
end;

{ Tz3DSSAO }

procedure Tz3DSSAO.ComputeOcclusion;
var I: Integer;
begin
  if not Enabled or not z3DScenario.ViewFrustum.Stats.AnyVisibleObject then Exit;

  // Generate the SSAO for the dynamic ambient objects
  if z3DEngine.Device.EngineCaps.ShaderModel3Supported then
  begin
    case Quality of
      z3dssaoqLow: z3DLightingController.Shader.Technique:= 'z3DLighting_SSAOLQ';
      z3dssaoqMedium: z3DLightingController.Shader.Technique:= 'z3DLighting_SSAOMQ';
      z3dssaoqHigh: z3DLightingController.Shader.Technique:= 'z3DLighting_SSAOHQ';
    end;
  end else z3DLightingController.Shader.Technique:= 'z3DLighting_SSAOLQ';
  if z3DEngine.Renderer.EnableMSAA then z3DEngine.Renderer.EndMSAAMode;
  FOcclusion.SetRenderTarget(0, True);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED);
  try

    // Render the SSAO for the enabled objects
//    z3DEngine.Renderer.ClearRenderTarget(z3DFloat4(1, 1, 1, 1));
    for I:= 0 to z3DLightingController.Shader.Prepare-1 do
    begin
      z3DLightingController.Shader.BeginPass;
      z3DEngine.NotifyLinks_z3DLightingRender;
      z3DLightingController.Shader.EndPass;
    end;

    // Blur the SSAO result
    if z3DEngine.Device.EngineCaps.ShaderModel3Supported then
    begin
      z3DRenderGaussBlurSSAO(FOcclusion, FBlurOcclusion);
      FOcclusion.RestoreRenderTarget;
      FBlurOcclusion.AttachToSampler(2, True, True);
    end else
    begin
      FOcclusion.RestoreRenderTarget;
      FOcclusion.AttachToSampler(2, True, True);
    end;
  finally
    if z3DEngine.Renderer.EnableMSAA then
    z3DEngine.Renderer.BeginMSAAMode;
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED or D3DCOLORWRITEENABLE_GREEN or
      D3DCOLORWRITEENABLE_BLUE or D3DCOLORWRITEENABLE_ALPHA);
  end;
end;

constructor Tz3DSSAO.Create;
begin
  inherited;

  // Link this object to all the events generated by the z3D Engine
  Notifications:= [z3dlnDevice];

  FOcclusion:= z3DCreateRenderTexture;
  FOcclusion.Format:= D3DFMT_A8R8G8B8;
  FOcclusion.SamplerState.Filter:= z3dsfNone;
  FBlurOcclusion:= z3DCreateRenderTexture;
  FBlurOcclusion.Format:= D3DFMT_A8R8G8B8;
  FBlurOcclusion.SamplerState.Filter:= z3dsfNone;

  FEnabled:= True;
  FQuality:= z3dssaoqMedium;
  FAmount:= 1;
  FSampleFactor:= 1;
end;

procedure Tz3DSSAO.CreateScenarioObjects;
var FKernel: array[0..15] of TD3DXVector3;
    I, FElement, FInternalFactor: Integer;
begin
  if not z3DEngine.Device.Created then Exit;

  z3DLightingController.Shader.Param['GSSAOSampleFactor']:= FSampleFactor;
  if Quality = z3dssaoqHigh then
  z3DLightingController.Shader.Param['GSSAOScale']:= z3DEngine.Scenario.ViewFrustum.FarClip * 12 else
  z3DLightingController.Shader.Param['GSSAOScale']:= z3DEngine.Scenario.ViewFrustum.FarClip * 2;
  z3DLightingController.Shader.Param['GSSAOAmount']:= FAmount;

  case Quality of
    z3dssaoqLow: FInternalFactor:= 64;
    z3dssaoqMedium: FInternalFactor:= 2;
    z3dssaoqHigh: FInternalFactor:= 3;
  end;

  Randomize;
  // Set the SSAO kernel
  for I:= 0 to 15 do
  begin
    case Ceil((1 + I) * 0.25) of
    1: FElement:= 1;
    2: FElement:= 2;
    3: FElement:= 3;
    4: FElement:= 4;
    end;
//    FElement:= Ceil((1 + I) * 0.25);

    FKernel[I].x:= FElement * Integer(I mod 2 = 0);
    FKernel[I].y:= FElement * Integer(I mod 2 <> 0);
    if Ceil((I + 1) * 0.5) mod 2 = 0 then FKernel[I].x:= -FKernel[I].x;
    if Ceil(I * 0.5) mod 2 = 0 then FKernel[I].y:= -FKernel[I].y;
    FKernel[I].z:= FElement;

    FKernel[I].x:= (FKernel[I].x * SampleFactor * FInternalFactor) / z3DCore_GetBackBufferSurfaceDesc.Width;
    FKernel[I].y:= (FKernel[I].y * SampleFactor * FInternalFactor) / z3DCore_GetBackBufferSurfaceDesc.Height;
  end;                                                                             
  z3DLightingController.Shader.SetPointer('GSSAOKernel', @FKernel, SizeOf(FKernel));
end;

function Tz3DSSAO.GetAmount: Single;
begin
  Result:= FAmount;
end;

function Tz3DSSAO.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

function Tz3DSSAO.GetQuality: Tz3DSSAOQuality;
begin
  Result:= FQuality;
end;

function Tz3DSSAO.GetSampleFactor: Single;
begin
  Result:= FSamplefactor;
end;

procedure Tz3DSSAO.SetAmount(const Value: Single);
begin
  FAmount:= Value;
  if z3DEngine.Scenario.Enabled then
  z3DLightingController.Shader.Param['GSSAOAmount']:= FAmount;
end;

procedure Tz3DSSAO.SetEnabled(const Value: Boolean);
begin
  FEnabled:= Value;
end;

procedure Tz3DSSAO.SetQuality(const Value: Tz3DSSAOQuality);
begin
  if FQuality <> Value then
  begin
    FQuality:= Value;
    z3DEngine.Renderer.CreateDeferredBuffer;
    CreateScenarioObjects;
  end;
end;

procedure Tz3DSSAO.SetSampleFactor(const Value: Single);
begin
  if FSamplefactor <> Value then
  begin
    FSamplefactor:= Value;
    z3DLightingController.Shader.Param['GSSAOSampleFactor']:= FSampleFactor;
  end;
end;

procedure Tz3DSSAO.z3DResetDevice;
begin
  inherited;
  if z3DEngine.Scenario.Enabled then CreateScenarioObjects;
end;

procedure Tz3DSSAO.z3DStartScenario(const AStage: Tz3DStartScenarioStage);
begin
  if AStage = z3dssCreatingLightingSystem then CreateScenarioObjects;
end;

{ Tz3DLightingController }

constructor Tz3DLightingController.Create;
begin
  inherited;
  Notifications:= [z3dlnDevice, z3dlnGPUPrecomputation];
  ScenarioStage:= z3dssCreatingLightingSystem;
  FSSAO:= Tz3DSSAO.Create;
  FLights:= TInterfaceList.Create;

  FDirDepthMap:= z3DCreateRenderTexture;
  FDirDepthMap.SamplerState.Filter:= z3dsfBilinear;
  FDirDepthMap.SamplerState.AddressMode:= z3dsamBorder;
  FDirDepthMap.SamplerState.BorderColor:= z3DFloat3(1, 1, 1);
  FDirDepthMap.AutoParams:= False;
  FDirDepthMap.ScenarioLevel:= False;
  FTempDirDepthMap:= z3DCreateRenderTexture;
  FTempDirDepthMap.AutoParams:= False;
  FTempDirDepthMap.ScenarioLevel:= False;

  FDepthMap:= z3DCreateRenderTexture;
  FDepthMap.SamplerState.Filter:= z3dsfBilinear;
  FDepthMap.SamplerState.AddressMode:= z3dsamBorder;
  FDepthMap.SamplerState.BorderColor:= z3DFloat3(1, 1, 1);
  FDepthMap.AutoParams:= False;
  FDepthMap.ScenarioLevel:= False;
  FTempDepthMap:= z3DCreateRenderTexture;
  FTempDepthMap.AutoParams:= False;
  FTempDepthMap.ScenarioLevel:= False;

  FCubeDepthMap:= z3DCreateCubeRenderTexture;
  FCubeDepthMap.SamplerState.Filter:= z3dsfBilinear;
  FCubeDepthMap.ScenarioLevel:= False;

  FShadowQuality:= z3dsqHigh;
  FUseHWShadows:= True;
  FShader:= z3DCreateShader;
  FShader.FileName:= PWideChar(WideString(Z3DRES_LIGHTING_EFFECT));
  FDepthBuffer:= z3DCreateDepthBuffer;
  FDepthBuffer.ScenarioLevel:= False;

  // Load the glow texture
  FGlowTexture:= z3DCreateTexture;
  FGlowTexture.Source:= z3dtsFileName;
  FGlowTexture.SamplerState.Filter:= z3dsfLinear;
  FGlowTexture.SamplerState.AddressMode:= z3dsamBorder;
  FGlowTexture.SamplerState.BorderColor:= z3DFloat3;
  z3DFileSystemController.DecryptF(fsEngineCoreResFile, fsCoreResFile_LightGlow1);
  StringToWideChar(WideCharToString(z3DFileSystemController.GetFullPath(fsBufferPath)) + fsPathDiv +
  fsCoreResFile_LightGlow1, FGlowTexture.FileName, 255);

  // Load the random rotation kernel texture
  FNoiseTexture:= z3DCreateTexture;
  FNoiseTexture.Source:= z3dtsFileName;
  FNoiseTexture.SamplerState.AddressMode:= z3dsamWrap;
  FNoiseTexture.SamplerState.Filter:= z3dsfTrilinear;
{  z3DFileSystemController.DecryptF(fsEngineCoreResFile, fsCoreResFile_RotationNoise);
  StringToWideChar(WideCharToString(z3DFileSystemController.GetFullPath(fsBufferPath)) + fsPathDiv +
  fsCoreResFile_RotationNoise, FNoiseTexture.FileName, 255);}
  FNoiseTexture.FileName:= 'C:\JP\Direct3D\z3D\KernelAdjust.dds';
  FNoiseTexture.AutoGenerateMipMaps:= False;

  FShadowMapOffset:= 0.0005;
  FDirShadowMapOffset:= 0.008;
  FDirShadowMapAreaSize:= 1000;
end;

function Tz3DLightingController.CreateLight: Iz3DLight;
begin
  Result:= Tz3DLight.Create;
  FLights.Add(Result as Iz3DBase);
end;

procedure Tz3DLightingController.z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller);
var I: Integer;
begin
  CreateScenarioObjects;
  SetEffectParams;
  for I:= 0 to LightCount-1 do Lights[I].StartScenario;
end;

procedure Tz3DLightingController.RenderPrecomputation;
var I: Integer;
begin
  for I:= 0 to LightCount-1 do Lights[I].RenderPrecomputation;
end;

procedure Tz3DLightingController.RenderLighting;
var I: Integer;
begin
  // Set view parameters
  Shader.Matrix['GViewMatrix']:= z3DScenario.ViewFrustum.ViewMatrix;
  FNoiseTexture.AttachToSampler(7, True, True);

  // Render the world affected by lighting using additive blending
  for I:= 0 to LightCount-1 do
  begin
    FCurrentLight:= I;
    Lights[I].RenderWorld;
  end;
end;

procedure Tz3DLightingController.RenderLightSources;
var I: Integer;
begin
  // Turn on additive blending
  z3DEngine.Renderer.EnableAdditiveBlending;
  try
    // Render the light sources
    z3DEngine.Renderer.DeferredBuffer.AttachToSampler(1, True, True);
    FGlowTexture.AttachToSampler(2, True, True);
    for I:= 0 to LightCount-1 do
    Lights[I].RenderSource;
  finally
    z3DEngine.Renderer.DisableBlending;
  end;
end;

procedure Tz3DLightingController.RenderAmbient;
var I: Integer;
begin
  FShader.Color3['GAmbientColor']:= z3DScenario.Environment.AmbientColor;

  // Static ambient
  FStage:= z3dlrsStaticAmbient;
  if SSAO.Enabled and (SSAO.Quality = z3dssaoqHigh) and FOpaqueMode then
  FShader.Technique:= 'z3DLighting_Ambient_StaticSSAO' else
  FShader.Technique:= 'z3DLighting_Ambient_Static';
  for I:= 0 to z3DLightingController.Shader.Prepare-1 do
  begin
    z3DLightingController.Shader.BeginPass;
    z3DEngine.NotifyLinks_z3DLightingRender;
    z3DLightingController.Shader.EndPass;
  end;

  // Dynamic ambient
  FStage:= z3dlrsDynamicAmbient;
  if SSAO.Enabled and FOpaqueMode then
  FShader.Technique:= 'z3DLighting_AmbientSSAO' else
  FShader.Technique:= 'z3DLighting_Ambient';
  for I:= 0 to FShader.Prepare-1 do
  begin
    FShader.BeginPass;
    z3DEngine.NotifyLinks_z3DLightingRender;
    FShader.EndPass;
  end;

  // TODO JP: MOVER - Water
  if not FOpaqueMode then
  begin
    FStage:= z3dlrsSSAO;
    FShader.Technique:= 'z3DLighting_Water';
    for I:= 0 to FShader.Prepare-1 do
    begin
      FShader.BeginPass;
      z3DEngine.NotifyLinks_z3DLightingRender;
      FShader.EndPass;
    end;
  end;
end;

procedure Tz3DLightingController.RenderOpaqueStage;
begin
  if not z3DScenario.ViewFrustum.Stats.AnyVisibleOpaqueObject then Exit;

  // Generate the SSAO map
  FOpaqueMode:= True;
  if SSAO.Enabled then
  begin
    FStage:= z3dlrsSSAO;
    FNoiseTexture.AttachToSampler(7, True, True);
    SSAO.ComputeOcclusion;
  end;

  // Render ambient and direct lighting for opaque objects
  if z3DEngine.Renderer.EnableMSAA then
  z3DEngine.Renderer.BeginZWrite;
  try
    RenderAmbient;
  finally
    if z3DEngine.Renderer.EnableMSAA then
    z3DEngine.Renderer.EndZWrite;
  end;
  z3DEngine.Renderer.EnableAdditiveBlending;
  RenderLighting;
end;

procedure Tz3DLightingController.RenderTranslucentStage;
begin
  if not z3DScenario.ViewFrustum.Stats.AnyVisibleTranslucentObject then Exit;

  // Render ambient and direct lighting for translucent objects
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
//  z3DCore_GetD3DDevice.SetRenderState(D3DRS_FILLMODE, D3DFILL_WIREFRAME);
  FOpaqueMode:= False;
  Shader.Param['GAbsoluteTime']:= z3DCore_GetTime;
  FNoiseTexture.AttachToSampler(7, True, True);
  z3DEngine.Renderer.EnableAlphaBlending;
  RenderAmbient;
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
  RenderLighting;
//  z3DCore_GetD3DDevice.SetRenderState(D3DRS_FILLMODE, D3DFILL_SOLID);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_CCW);
  Shader.Param['GAbsoluteTime']:= 0;
end;

procedure Tz3DLightingController.SetEffectParams;
var FPixelWidth, FPixelHeight: Single;
begin
  if not z3DEngine.Device.Created then Exit;
  FShader.Param['GFarClip']:= z3DEngine.Scenario.ViewFrustum.FarClip;
  FShader.Param['GAspectRatio']:= z3DCore_GetState.BackBufferSurfaceDesc.Width / z3DCore_GetState.BackBufferSurfaceDesc.Height;
//  FShader.Texture['GNoiseTexture']:= FNoiseTexture;
//  FShader.Texture['GEdgeTexture']:= FEdgeTexture;
  FPixelWidth:= 1 / z3DCore_GetBackBufferSurfaceDesc.Width;
  FPixelHeight:= 1 / z3DCore_GetBackBufferSurfaceDesc.Height;
  FShader.Float2['GPixelSize']:= z3DFloat2(FPixelWidth, FPixelHeight);
end;

procedure Tz3DLightingController.CreateScenarioObjects;
begin
  if (FDepthBuffer.D3DSurface <> nil) or GetUseHWShadows then Exit;
  FDepthBuffer.SetParams(DirectionalDepthMapSize, DirectionalDepthMapSize,
  z3DCore_GetDeviceSettings.PresentParams.AutoDepthStencilFormat, D3DMULTISAMPLE_NONE, 0, True);
end;

function Tz3DLightingController.DepthMapSize: Integer;
begin
  Result:= Min(z3DCore_GetState.Caps.MaxTextureWidth div 4, 512);
end;

function Tz3DLightingController.DirectionalDepthMapSize: Integer;
begin
  Result:= Min(z3DCore_GetState.Caps.MaxTextureWidth div 2, 2048);
end;

function Tz3DLightingController.GetShader: Iz3DShader;
begin
  Result:= FShader;
end;

function Tz3DLightingController.GetLights(const AIndex: Integer): Iz3DLight;
begin
  Result:= FLights[AIndex] as Iz3DLight;
end;

function Tz3DLightingController.IndexOfLight(const ALight: Iz3DLight): Integer;
begin
  Result:= FLights.IndexOf(ALight as Iz3DBase);
end;

procedure Tz3DLightingController.RemoveLight(const ALight: Iz3DLight);
begin
  FLights.Remove(ALight);
end;

procedure Tz3DLightingController.SetLights(const AIndex: Integer; const Value: Iz3DLight);
begin
  FLights[AIndex]:= Value;
end;

function Tz3DLightingController.GetLightCount: Integer;
begin
  Result:= FLights.Count;
end;

function Tz3DLightingController.GetDepthBuffer: Iz3DDepthBuffer;
begin
  Result:= FDepthBuffer;
end;

function Tz3DLightingController.GetCubeDepthMap: Iz3DCubeRenderTexture;
begin
  Result:= FCubeDepthMap;
end;

function Tz3DLightingController.GetDepthMap: Iz3DRenderTexture;
begin
  Result:= FDepthMap;
end;

function Tz3DLightingController.GetDirDepthMap: Iz3DRenderTexture;
begin
  Result:= FDirDepthMap;
end;

function Tz3DLightingController.GetTempDepthMap: Iz3DRenderTexture;
begin
  Result:= FTempDepthMap;
end;

function Tz3DLightingController.GetShadowQuality: Tz3DShadowQuality;
begin
  Result:= FShadowQuality;
end;

function Tz3DLightingController.GetUseHWShadows: Boolean;
begin
  Result:= FUseHWShadows and z3DEngine.Device.EngineCaps.ShadowMapHWSupport;
end;

procedure Tz3DLightingController.SetShadowQuality(const Value: Tz3DShadowQuality);
begin
  FShadowQuality:= Value;
end;

procedure Tz3DLightingController.SetUseHWShadows(const Value: Boolean);
begin
  if FUseHWShadows <> Value then
  begin
    FUseHWShadows:= Value;
    RecreateDepthBuffers;
  end;
end;

function Tz3DLightingController.GetTempDirDepthMap: Iz3DRenderTexture;
begin
  Result:= FTempDirDepthMap;
end;

function Tz3DLightingController.GetGlowTexture: Iz3DTexture;
begin
  Result:= FGlowTexture;
end;

function Tz3DLightingController.GetSSAO: Iz3DSSAO;
begin
  Result:= FSSAO;
end;

function Tz3DLightingController.GetDirShadowMapOffset: Single;
begin
  Result:= FDirShadowMapOffset;
end;

function Tz3DLightingController.GetShadowMapOffset: Single;
begin
  Result:= FShadowMapOffset;
end;

procedure Tz3DLightingController.SetDirShadowMapOffset(const Value: Single);
begin
  FDirShadowMapOffset:= Value;
end;

procedure Tz3DLightingController.SetShadowMapOffset(const Value: Single);
begin
  FShadowMapOffset:= Value;
end;

function Tz3DLightingController.GetDirShadowMapAreaSize: Single;
begin
  Result:= FDirShadowMapAreaSize;
end;

procedure Tz3DLightingController.SetDirShadowMapAreaSize(const Value: Single);
begin
  FDirShadowMapAreaSize:= Value;
end;

function Tz3DLightingController.GetStage: Tz3DLightingRenderStage;
begin
  Result:= FStage;
end;

function Tz3DLightingController.GetCurrentLight: Iz3DLight;
begin
  if FCurrentLight = -1 then Result:= nil else
  Result:= Lights[FCurrentLight];
end;

procedure Tz3DLightingController.z3DCreateDevice;
begin
  // Set the cube depth map parameters
  FCubeDepthMap.Size:= DepthMapSize;
  FCubeDepthMap.Format:= z3DEngine.Device.EngineCaps.CubeShadowMapFormat;

  // Set the standard depth map parameters
  FDepthMap.Width:= DepthMapSize;
  FDepthMap.Height:= DepthMapSize;
  if FUseHWShadows then
  begin
    FDepthMap.Usage:= D3DUSAGE_DEPTHSTENCIL;
    FDepthmap.Format:= z3DCore_GetDeviceSettings.PresentParams.AutoDepthStencilFormat;

    FTempDepthMap.Width:= DepthMapSize;
    FTempDepthMap.Height:= DepthMapSize;
    FTempDepthMap.Format:= D3DFMT_A8R8G8B8;
  end else
  begin
    FDepthMap.Usage:= D3DUSAGE_RENDERTARGET;
    FDepthmap.Format:= z3DEngine.Device.EngineCaps.ShadowMapFormat;
  end;

  // Set the directional depth map parameters
  FDirDepthMap.Width:= DirectionalDepthMapSize;
  FDirDepthMap.Height:= DirectionalDepthMapSize;
  if FUseHWShadows then
  begin
    FDirDepthMap.Usage:= D3DUSAGE_DEPTHSTENCIL;
    FDirDepthMap.Format:= z3DCore_GetDeviceSettings.PresentParams.AutoDepthStencilFormat;

    FTempDirDepthMap.Width:= DirectionalDepthMapSize;
    FTempDirDepthMap.Height:= DirectionalDepthMapSize;
    FTempDirDepthMap.Format:= D3DFMT_A8R8G8B8;
  end else
  begin
    FDirDepthMap.Usage:= D3DUSAGE_RENDERTARGET;
    FDirDepthMap.Format:= z3DEngine.Device.EngineCaps.ShadowMapFormat;
  end;
end;

procedure Tz3DLightingController.z3DGPUPrecomputation;
begin
  inherited;
  RenderPrecomputation;
end;

function Tz3DLightingController.GetOpaqueMode: Boolean;
begin
  Result:= FOpaqueMode;
end;

procedure Tz3DLightingController.RecreateDepthBuffers;
var I: Integer;
begin
  if not z3DScenario.Enabled then Exit;
  FDepthBuffer.D3DSurface:= nil;
  z3DCreateDevice;
  CreateScenarioObjects;
  FCubeDepthMap.CreateD3DTexture;
  FDepthMap.CreateD3DTexture;
  FTempDepthMap.CreateD3DTexture;
  FDirDepthMap.CreateD3DTexture;
  FTempDirDepthMap.CreateD3DTexture;
  for I:= 0 to LightCount-1 do Lights[I].CreateDepthMap;
end;

{ Tz3DLightMap }

constructor Tz3DLightMap.Create;
begin
  inherited;
  GetMem(FUniqueName, 255);
  FGenerated:= False;
  FEnabled:= True;
  FOptions:= Tz3DLightMapOptions.Create;
  FRayTracer:= Tz3DRayTracer.Create;
  SetLength(FDistribution, 0);
  SetLength(FLightTextures, 0);
  SetLength(FRadiosityTextures, 0);
end;

destructor Tz3DLightMap.Destroy;
begin
  FOptions:= nil;
  FRayTracer:= nil;
  SetLength(FDistribution, 0);
  SetLength(FLightTextures, 0);
  SetLength(FRadiosityTextures, 0);
  inherited;
end;

procedure Tz3DLightMap.BeginRadiosity;
begin
  if GenerationNeeded and Options.EnableRadiosity then
  RayTracer.BeginRadiosityTracing(Self);
end;

procedure Tz3DLightMap.EndRadiosity;
var I: Integer;
begin
  if GenerationNeeded and Options.EnableRadiosity then
  begin
    RayTracer.EndRadiosityTracing;

    // Blur and save the radiosity textures
    for I:= 0 to z3DLightingController.LightCount-1 do
    if z3DLightingController[I].Static then
    BlurAndSave(FRadiosityTextures[I]);
  end;
end;

procedure Tz3DLightMap.Blur(const ARect: TD3DLockedRect; const AOffsetU,
  AOffsetV, AWidth, AHeight: Integer);
var FU, FV: Integer;
    FBits: PSingleArray;
    FBlurColor, FBlurColor1, FBlurColor2, FBlurColor3, FBlurColor4: TD3DXColor;
begin

  // Blur the current lightmap plane avoiding the edges for filtering
  for FU:= AOffsetU to AOffsetU+AWidth do
  for FV:= AOffsetV to AOffsetV+AHeight do
  begin
    FBits:= @ARect.pBits;
    FBlurColor:= D3DXColorFromDWord(FBits^[FV * ARect.Pitch div 4 + FU]);
    FBlurColor1:= D3DXColorFromDWord(FBits^[FV * ARect.Pitch div 4 + Max(AOffsetU, FU-1)]);
    FBlurColor2:= D3DXColorFromDWord(FBits^[Max(AOffsetV, FV-1) * ARect.Pitch div 4 + FU]);
    FBlurColor3:= D3DXColorFromDWord(FBits^[Min(AOffsetV+AHeight, FV+1) * ARect.Pitch div 4 + FU]);
    FBlurColor4:= D3DXColorFromDWord(FBits^[FV * ARect.Pitch div 4 + Min(AOffsetU+AWidth, FU+1)]);
    FBits^[FV * ARect.Pitch div 4 + FU]:=
    D3DCOLOR_COLORVALUE((FBlurColor.r+FBlurColor1.r+FBlurColor2.r+FBlurColor3.r+FBlurColor4.r) / 5,
    (FBlurColor.g+FBlurColor1.g+FBlurColor2.g+FBlurColor3.g+FBlurColor4.g) / 5,
    (FBlurColor.b+FBlurColor1.b+FBlurColor2.b+FBlurColor3.b+FBlurColor4.b) / 5, 1);
  end;
end;

procedure Tz3DLightMap.BlurTextures;

  procedure BlurTexture(const ATexture: Iz3DTexture; const ACoords: TRect; const ASteps: Integer);
  var I: Integer;
  begin
    for I:= 0 to ASteps-1 do
    Blur(ATexture.LockedRect, ACoords.Left, ACoords.Top, ACoords.Right, ACoords.Bottom);
  end;

var I, J: Integer;
    FRect: TRect;
begin
  for I:= 0 to Length(Distribution)-1 do
  begin
    FRect:= Rect(Trunc(Distribution[I].OffsetU) - Offset + 1,
    Trunc(Distribution[I].OffsetV) - Offset + 1,
    Trunc(Distribution[I].Width) + Offset * 2 - 2,
    Trunc(Distribution[I].Height) + Offset * 2 - 2);

    // Blur the final lightmaps
    if Options.EnableAmbient and not AmbientTexture.Loaded then BlurTexture(AmbientTexture.Texture, FRect, Options.BlurSteps+2);

    for J:= 0 to z3DLightingController.LightCount-1 do
    if z3DLightingController[J].Static then
    begin
      if not LightTextures[J].Loaded then BlurTexture(LightTextures[J].Texture, FRect, Options.BlurSteps);

      if Options.EnableRadiosity and not RadiosityTextures[J].Loaded then
      BlurTexture(RadiosityTextures[J].Texture, FRect, Options.BlurSteps+4);
    end;
  end;
end;

procedure Tz3DLightMap.BlurAndSave(var ATexture: Tz3DLightMapTexture);

  procedure BlurTexture(const ATexture: Iz3DTexture; const ACoords: TRect; const ASteps: Integer);
  var I: Integer;
  begin
    for I:= 0 to ASteps-1 do
    Blur(ATexture.LockedRect, ACoords.Left, ACoords.Top, ACoords.Right, ACoords.Bottom);
  end;

var I: Integer;
    FRect: TRect;
    FFile: PWideChar;
begin
  if not ATexture.Created or ATexture.Loaded or ATexture.Saved then Exit;

  for I:= 0 to Length(Distribution)-1 do
  begin
    FRect:= Rect(Trunc(Distribution[I].OffsetU) - Offset + 1,
    Trunc(Distribution[I].OffsetV) - Offset + 1,
    Trunc(Distribution[I].Width) + Offset * 2 - 2,
    Trunc(Distribution[I].Height) + Offset * 2 - 2);

    // Blur the final lightmap
    BlurTexture(ATexture.Texture, FRect, Options.BlurSteps);

    // Save the lightmap
    FFile:= z3DLightMapController.GetTextureFileName(ATexture.Name);
    ATexture.Texture.EndDraw;
    D3DXSaveTextureToFileW(FFile, D3DXIFF_DDS, ATexture.Texture.D3DBaseTexture, nil);
    ATexture.Texture.BeginDraw;
    ATexture.Saved:= True;
  end;
end;

procedure Tz3DLightMap.CopyRadiosityToTextures;
var FColor: Iz3DFloat3;
    I, J, L, X, Y: Integer;
begin
  if not Options.EnableRadiosity then Exit;
  EXIT;

  FColor:= z3DFloat3;

  // Iterate through the distribution list
  for I:= 0 to Length(Distribution)-1 do

  // Iterate through the luxels
  for X:= 0 to Length(Distribution[I].Luxels)-1 do
  for Y:= 0 to Length(Distribution[I].Luxels[X])-1 do

  // Iterate through the static lights
  for J:= 0 to z3DLightingController.LightCount-1 do
  if z3DLightingController[J].Static and not RadiosityTextures[J].Loaded then
  begin
    FColor.Identity;
    for L:= 0 to Options.RadiosityBounces-1 do
    FColor.Add(Distribution[I].Luxels[X][Y].RadiosityColors[L][J]);
    FColor.Saturate;
    RadiosityTextures[J].Texture.SetPixel(X + Trunc(Distribution[I].OffsetU) - Offset,
    Y + Trunc(Distribution[I].OffsetV) - Offset, FColor);
  end;
end;

procedure Tz3DLightMap.GeneratePlanarMapping(const AVB: Pointer;
  const AIB: PWordArray; const AFaceCount: Integer; const AAdjacency: Pz3DDWordArray;
  const AComputeCoords: Boolean);
const FEpsilon = 1e-3;
var I, K, L, FNormalSource: Integer;
    FNormal, FNormalAdj: Iz3DFloat3;
    FVB: Pz3DStaticModelVertexArray;
    FWorldU, FWorldV: Single;
    FAdjacent: Boolean;
    FEmptyArray: Tz3DFloat2Array;
begin
  // Reset the distribution list
  SetLength(FDistribution, 0);
  SetLength(FDistributionIndices, 0);
  FVB:= Pz3DStaticModelVertexArray(AVB);


  for I:= 0 to AFaceCount-1 do
  begin
    L:= -1;
    FAdjacent:= False;
    FNormal:= z3DGetNormal(z3DFloat3.From(FVB[AIB[I*3]].Position), z3DFloat3.From(FVB[AIB[I*3+1]].Position), z3DFloat3.From(FVB[AIB[I*3+2]].Position));
    if FNormal.Dot(z3DFloat3.From(FVB[AIB[I*3]].Normal)) < 0 then FNormal.Negate;
    FNormal.Normalize;

    // Find any other triangle sharing the same plane
    if AAdjacency <> nil then
    begin
      for K:= 0 to 2 do
      begin
        if not (AAdjacency^[I*3+K] < I) then Continue;

        FNormalAdj:= z3DGetNormal(z3DFloat3.From(FVB[AIB[AAdjacency^[I*3+K]*3]].Position),
        z3DFloat3.From(FVB[AIB[AAdjacency^[I*3+K]*3+1]].Position), z3DFloat3.From(FVB[AIB[AAdjacency^[I*3+K]*3+2]].Position));
        if FNormalAdj.Dot(z3DFloat3.From(FVB[AIB[AAdjacency^[I*3+K]*3]].Normal)) < 0 then FNormalAdj.Negate;
        FNormalAdj.Normalize.Subtract(FNormal);
        if (FDistribution[FDistributionIndices[AAdjacency^[I*3+K]]].RefCount < 2) and
        (FNormalAdj.Length < FEpsilon) then
        begin
          FAdjacent:= True;
          L:= FDistributionIndices[AAdjacency^[I*3+K]];
          Break;
        end;
      end;
    end;
    if L = -1 then
    begin
      SetLength(FDistribution, Length(FDistribution)+1);
      L:= Length(FDistribution)-1;
    end;
    SetLength(FDistributionIndices, Length(FDistributionIndices)+1);
    FDistributionIndices[Length(FDistributionIndices)-1]:= L;

    // Project the vertex into the plane
    if (Abs(FNormal.X) > Abs(FNormal.Y)) and (Abs(FNormal.X) > Abs(FNormal.Z)) then
    begin
      FNormalSource:= 1;
      if AComputeCoords then
      begin
        FVB[AIB[I*3]].LightCoord.x:= FVB[AIB[I*3]].Position.y;
        FVB[AIB[I*3]].LightCoord.y:= FVB[AIB[I*3]].Position.z;
        FVB[AIB[I*3+1]].LightCoord.x:= FVB[AIB[I*3+1]].Position.y;
        FVB[AIB[I*3+1]].LightCoord.y:= FVB[AIB[I*3+1]].Position.z;
        FVB[AIB[I*3+2]].LightCoord.x:= FVB[AIB[I*3+2]].Position.y;
        FVB[AIB[I*3+2]].LightCoord.y:= FVB[AIB[I*3+2]].Position.z;
      end;
    end else
    if (Abs(FNormal.Y) > Abs(FNormal.X)) and (Abs(FNormal.Y) > Abs(FNormal.Z)) then
    begin
      FNormalSource:= 2;
      if AComputeCoords then
      begin
        FVB[AIB[I*3]].LightCoord.x:= FVB[AIB[I*3]].Position.x;
        FVB[AIB[I*3]].LightCoord.y:= FVB[AIB[I*3]].Position.z;
        FVB[AIB[I*3+1]].LightCoord.x:= FVB[AIB[I*3+1]].Position.x;
        FVB[AIB[I*3+1]].LightCoord.y:= FVB[AIB[I*3+1]].Position.z;
        FVB[AIB[I*3+2]].LightCoord.x:= FVB[AIB[I*3+2]].Position.x;
        FVB[AIB[I*3+2]].LightCoord.y:= FVB[AIB[I*3+2]].Position.z;
      end;
    end else
    begin
      FNormalSource:= 3;
      if AComputeCoords then
      begin
        FVB[AIB[I*3]].LightCoord.x:= FVB[AIB[I*3]].Position.x;
        FVB[AIB[I*3]].LightCoord.y:= FVB[AIB[I*3]].Position.y;
        FVB[AIB[I*3+1]].LightCoord.x:= FVB[AIB[I*3+1]].Position.x;
        FVB[AIB[I*3+1]].LightCoord.y:= FVB[AIB[I*3+1]].Position.y;
        FVB[AIB[I*3+2]].LightCoord.x:= FVB[AIB[I*3+2]].Position.x;
        FVB[AIB[I*3+2]].LightCoord.y:= FVB[AIB[I*3+2]].Position.y;
      end;
    end;

    if not FAdjacent then
    begin
      SetLength(FacePlane[I].Lights, 3);
      FacePlane[I].Lights[0]:= z3DFloat2.From(FVB[AIB[I*3]].LightCoord);
      FacePlane[I].Lights[1]:= z3DFloat2.From(FVB[AIB[I*3+1]].LightCoord);
      FacePlane[I].Lights[2]:= z3DFloat2.From(FVB[AIB[I*3+2]].LightCoord);
      // Obtain the absolute lightcoords
      GetCoords(FacePlane[I].Lights[0], FacePlane[I].Lights[1], FacePlane[I].Lights[2], FEmptyArray,
      FacePlane[I].FUMin, FacePlane[I].FUMax, FacePlane[I].FVMin, FacePlane[I].FVMax, FacePlane[I].FUDelta, FacePlane[I].FVDelta);

      // Measure the individual lightmap dimensions
      case FNormalSource of
        1:
        begin
          FWorldU:= WorldScale.y;
          FWorldV:= WorldScale.z;
        end;
        2:
        begin
          FWorldU:= WorldScale.x;
          FWorldV:= WorldScale.z;
        end;
        3:
        begin
          FWorldU:= WorldScale.x;
          FWorldV:= WorldScale.y;
        end;
      end;
      FacePlane[I].Width:= Trunc(Max(2, FacePlane[I].FUDelta * FWorldU));
      FacePlane[I].Height:= Trunc(Max(2, FacePlane[I].FVDelta * FWorldV));
      FacePlane[I].Normal:= z3DFloat3.From(FNormal);
    end else
    begin
      // Obtain the absolute lightcoords
      GetCoords(z3DFloat2.From(FVB[AIB[I*3]].LightCoord), z3DFloat2.From(FVB[AIB[I*3+1]].LightCoord),
      z3DFloat2.From(FVB[AIB[I*3+2]].LightCoord), FacePlane[I].Lights,
      FacePlane[I].FUMin, FacePlane[I].FUMax, FacePlane[I].FVMin, FacePlane[I].FVMax, FacePlane[I].FUDelta, FacePlane[I].FVDelta);

      // Measure the individual lightmap dimensions
      case FNormalSource of
        1:
        begin
          FWorldU:= WorldScale.y;
          FWorldV:= WorldScale.z;
        end;
        2:
        begin
          FWorldU:= WorldScale.x;
          FWorldV:= WorldScale.z;
        end;
        3:
        begin
          FWorldU:= WorldScale.x;
          FWorldV:= WorldScale.y;
        end;
      end;
      FacePlane[I].Width:= Trunc(Max(2, FacePlane[I].FUDelta * FWorldU));
      FacePlane[I].Height:= Trunc(Max(2, FacePlane[I].FVDelta * FWorldV));
      FacePlane[I].Normal:= z3DFloat3.From(FNormal);
    end;
    FacePlane[I].RefCount:= FacePlane[I].RefCount + 1;
  end;
end;

procedure Tz3DLightMap.GetCoords(const AV1, AV2, AV3: Iz3DFloat2; const AAditional: Tz3DFloat2Array;
  var AMinU, AMaxU, AMinV, AMaxV, ADeltaU, ADeltaV: Single);
var I: Integer;
begin
  // Get the lightmap min and max coordinates
  AMinU:= AV1.x;
  AMaxU:= AMinU;
  AMinV:= AV1.y;
  AMaxV:= AMinV;
  if AV2.x < AMinU then AMinU:= AV2.x;
  if AV2.y < AMinV then AMinV:= AV2.y;
  if AV2.x > AMaxU then AMaxU:= AV2.x;
  if AV2.y > AMaxV then AMaxV:= AV2.y;
  if AV3.x < AMinU then AMinU:= AV3.x;
  if AV3.y < AMinV then AMinV:= AV3.y;
  if AV3.x > AMaxU then AMaxU:= AV3.x;
  if AV3.y > AMaxV then AMaxV:= AV3.y;

  for I:= 0 to Length(AAditional)-1 do
  begin
    if AAditional[I].x < AMinU then AMinU:= AAditional[I].x;
    if AAditional[I].y < AMinV then AMinV:= AAditional[I].y;
    if AAditional[I].x > AMaxU then AMaxU:= AAditional[I].x;
    if AAditional[I].y > AMaxV then AMaxV:= AAditional[I].y;
  end;

  ADeltaU:= (AMaxU - AMinU);
  ADeltaV:= (AMaxV - AMinV);
end;

function Tz3DLightMap.GetDistribution: Tz3DLightMapDistribution;
begin
  Result:= FDistribution;
end;

function Tz3DLightMap.GetOffset: Integer;
begin
  Result:= Options.BlurSteps+1;
end;

function Tz3DLightMap.GetOptions: Iz3DLightMapOptions;
begin
  Result:= FOptions;
end;

function Tz3DLightMap.GetRayTracer: Iz3DRayTracer;
begin
  Result:= FRayTracer;
end;

function Tz3DLightMap.GetSize: Integer;
var FTexArea: Integer;
    I: Integer;
begin
  // Return an approximate size for the lightmap
  FTexArea:= 0;
  for I:= 0 to Length(FDistribution)-1 do
    FTexArea:= FTexArea + (FDistribution[I].Width + Offset * 2) * (FDistribution[I].Height + Offset * 2);
  Result:= Min(z3DLightMapController.MaxTextureSize, Ceil(Power(2, Ceil(Log10(Sqrt(FTexArea * FAreaFactor)) / Log10(2)))) div 2);
end;

function Tz3DLightMap.GetUniqueName: PWideChar;
begin
  Result:= FUniqueName;
end;

procedure Tz3DLightMap.GetWorldPlane(const ANormal, APointOnPlane: Iz3DFloat3; const AMinU,
  AMaxU, AMinV, AMaxV: Single; var APlane: Tz3DTriangle);
var FDistance: Single;
    FNormalSource: Integer;
begin
  FDistance:= -(ANormal.x * APointOnPlane.x + ANormal.y * APointOnPlane.y + ANormal.z * APointOnPlane.z);
  if (Abs(ANormal.X) > Abs(ANormal.Y)) and (Abs(ANormal.X) > Abs(ANormal.Z)) then FNormalSource:= 1 else
  if (Abs(ANormal.Y) > Abs(ANormal.X)) and (Abs(ANormal.Y) > Abs(ANormal.Z)) then FNormalSource:= 2 else
  FNormalSource:= 3;

  // Get the world space vertices of the lightmap plane
  case FNormalSource of
    1:
    begin
      APlane[0].x:= -(ANormal.y * AMinU + ANormal.z * AMinV + FDistance) / ANormal.x;
      APlane[0].y:= AMinU;
      APlane[0].z:= AMinV;
      APlane[1].x:= -(ANormal.y * AMaxU + ANormal.z * AMinV + FDistance) / ANormal.x;
      APlane[1].y:= AMaxU;
      APlane[1].z:= AMinV;
      APlane[2].x:= -(ANormal.y * AMinU + ANormal.z * AMaxV + FDistance) / ANormal.x;
      APlane[2].y:= AMinU;
      APlane[2].z:= AMaxV;
    end;
    2:
    begin
      APlane[0].x:= AMinU;
      APlane[0].y:= -(ANormal.x * AMinU + ANormal.z * AMinV + FDistance) / ANormal.y;
      APlane[0].z:= AMinV;
      APlane[1].x:= AMaxU;
      APlane[1].y:= -(ANormal.x * AMaxU + ANormal.z * AMinV + FDistance) / ANormal.y;
      APlane[1].z:= AMinV;
      APlane[2].x:= AMinU;
      APlane[2].y:= -(ANormal.x * AMinU + ANormal.z * AMaxV + FDistance) / ANormal.y;
      APlane[2].z:= AMaxV;
    end;
    3:
    begin
      APlane[0].x:= AMinU;
      APlane[0].y:= AMinV;
      APlane[0].z:= -(ANormal.x * AMinU + ANormal.y * AMinV + FDistance) / ANormal.z;
      APlane[1].x:= AMaxU;
      APlane[1].y:= AMinV;
      APlane[1].z:= -(ANormal.x * AMaxU + ANormal.y * AMinV + FDistance) / ANormal.z;
      APlane[2].x:= AMinU;
      APlane[2].y:= AMaxV;
      APlane[2].z:= -(ANormal.x * AMinU + ANormal.y * AMaxV + FDistance) / ANormal.z;
    end;
  end;
end;

function Tz3DLightMap.GetWorldScale: Iz3DFloat3;
begin
  Result:= z3DFloat3.From(FObjectSize).Scale(Options.DetailFactor);
end;

procedure Tz3DLightMap.CreateTextures;

  procedure CreateTexture(var ATexture: Tz3DLightMapTexture; const AName, AFileName: PWideChar;
    const ADefaultColor: Iz3DFloat3);
  var X, Y: Integer;
  begin
    ATexture.Created:= True;
    GetMem(ATexture.Name, 255);
    StringToWideChar(WideCharToString(AName), ATexture.Name, 255);
    if FileExists(AFileName) then
    begin
      ATexture.Texture:= z3DCreateTexture;
      ATexture.Texture.SamplerState.Filter:= z3dsfTrilinear;
      ATexture.Texture.Source:= z3dtsFileName;
      StringToWideChar(AFileName, ATexture.Texture.FileName, 255);
      ATexture.Texture.CreateD3DTexture;
      ATexture.Loaded:= True;
      ATexture.Saved:= True;
    end else
    begin
      ATexture.Loaded:= False;
      ATexture.Saved:= False;
      ATexture.Texture:= z3DCreateTexture;
      ATexture.Texture.SamplerState.Filter:= z3dsfTrilinear;
      ATexture.Texture.SetParams(Size, Size, 1, D3DFMT_X8R8G8B8);
      ATexture.Texture.BeginDraw;
      try
        for X:= 0 to Size-1 do
        for Y:= 0 to Size-1 do
        begin
          if (X + Y) mod 2 = 0 then ATexture.Texture.SetPixel(X, Y, ADefaultColor) else
          ATexture.Texture.SetPixel(X, Y, z3DFloat3);
        end;
      finally
        ATexture.Texture.EndDraw;
      end;
    end;
  end;

var I: Integer;
    FName: PWideChar;
begin

  GetMem(FName, 255);
  // Create the texture for the ambient lighting
  if Options.EnableAmbient then
  begin
    StringToWideChar(Format(z3DLightMapController.AOFileMask, [WideCharToString(UniqueName)]), FName, 255);
    CreateTexture(FAmbientTexture, FName, z3DLightMapController.GetTextureFileName(FName),
    z3DFloat3(0, 0.5, 0));
  end;

  SetLength(FLightTextures, 0);
  SetLength(FLightTextures, z3DLightingController.LightCount);
  SetLength(FRadiosityTextures, 0);
  SetLength(FRadiosityTextures, z3DLightingController.LightCount);

  // Create the direct and radiosity textures for each static light
  for I:= 0 to z3DLightingController.LightCount-1 do
  if z3DLightingController[I].Static then
  begin
    StringToWideChar(Format(z3DLightMapController.LightFileMask, [WideCharToString(UniqueName), I]), FName, 255);
    CreateTexture(FLightTextures[I], FName, z3DLightMapController.GetTextureFileName(FName),
    z3DFloat3(0.5, 0, 0));

    if Options.EnableRadiosity then
    begin
      StringToWideChar('R_'+Format(z3DLightMapController.LightFileMask, [WideCharToString(UniqueName), I]), FName, 255);
      CreateTexture(FRadiosityTextures[I], FName, z3DLightMapController.GetTextureFileName(FName),
      z3DFloat3);
    end;
  end;
  FreeMem(FName);
end;

procedure Tz3DLightMap.SetUniqueName(const Value: PWideChar);
begin
  StringToWideChar(Value, FUniqueName, 255);
end;

function Tz3DLightMap.AddPackNode(const ANode: Iz3DLightMapPackNode; const APlane: Tz3DLightMapPlane): Iz3DLightMapPackNode;
var FNewNode: Iz3DLightMapPackNode;
begin
  // Search for the right place to put a new node
  Result:= nil;
  if (ANode.Childs[0] <> nil) and (ANode.Childs[1] <> nil) then
  begin
    FNewNode:= AddPackNode(ANode.Childs[0], APlane);
    if FNewNode <> nil then
    begin
      FNewNode.ID:= APlane.ID;
      Result:= FNewNode;
      Exit;
    end;
    Result:= AddPackNode(ANode.Childs[1], APlane);
    Exit;
  end else
  begin
    if ANode.ID > -1 then
    begin
      Result:= nil;
      Exit;
    end;
    if ((APlane.Width+Offset*2) > (ANode.Rect.Right-ANode.Rect.Left)) or
    ((APlane.Height+Offset*2) > (ANode.Rect.Bottom-ANode.Rect.Top)) then
    begin
      Result:= nil;
      Exit;
    end;
    if ((APlane.Width+Offset*2) = (ANode.Rect.Right-ANode.Rect.Left)) and
    ((APlane.Height+Offset*2) = (ANode.Rect.Bottom-ANode.Rect.Top)) then
    begin
      Result:= ANode;
      ANode.ID:= APlane.ID;
      Exit;
    end;
    ANode.Childs[0]:= Tz3DLightMapPackNode.Create;
    ANode.Childs[1]:= Tz3DLightMapPackNode.Create;
    if (ANode.Rect.Right-ANode.Rect.Left)-APlane.Width > (ANode.Rect.Bottom-ANode.Rect.Top)-APlane.Height then
    begin
      ANode.Childs[0].Rect:= Rect(ANode.Rect.Left, ANode.Rect.Top, ANode.Rect.Left+APlane.Width+Offset*2, ANode.Rect.Bottom);
      ANode.Childs[1].Rect:= Rect(ANode.Rect.Left+APlane.Width+Offset*2, ANode.Rect.Top, ANode.Rect.Right, ANode.Rect.Bottom);
    end else
    begin
      ANode.Childs[0].Rect:= Rect(ANode.Rect.Left, ANode.Rect.Top, ANode.Rect.Right, ANode.Rect.Top+APlane.Height+Offset*2);
      ANode.Childs[1].Rect:= Rect(ANode.Rect.Left, ANode.Rect.Top+APlane.Height+Offset*2, ANode.Rect.Right, ANode.Rect.Bottom);
    end;
    Result:= AddPackNode(ANode.Childs[0], APlane);
  end;
end;

procedure Tz3DLightMap.Distribute(const AVB: Pointer; const AIB: PWordArray;
  const AFaceCount: Integer; const AComputeCoords: Boolean);
var I, J: Integer;
    FVB: Pz3DStaticModelVertexArray;
    FPlane: Tz3DTriangle;
    FRoot, FNode: Iz3DLightMapPackNode;
    FPackingNeeded: Boolean;
begin
  FPackingNeeded:= True;
  FVB:= Pz3DStaticModelVertexArray(AVB);
  FPlane:= z3DTriangle;

  // Generate a tree to optimize the lightmap packing
  while FPackingNeeded do
  begin
    FRoot:= Tz3DLightMapPackNode.Create;
    FRoot.Rect:= Rect(0, 0, Size-1, Size-1);
    for I:= 0 to Length(FDistribution)-1 do
    begin
      FNode:= AddPackNode(FRoot, FDistribution[I]);
      if FNode = nil then
      begin
        if Size >= z3DLightMapController.MaxTextureSize then
        begin
          z3DTrace('Iz3DLightMap.Distribute failed: The lightmap is too big for the current detail factor and/or object size', z3dtkWarning);
          Exit;
        end;
        FAreaFactor:= FAreaFactor+0.25;
        FPackingNeeded:= True;
        Break;
      end;
      FDistribution[I].OffsetU:= FNode.Rect.Left+Offset;
      FDistribution[I].OffsetV:= FNode.Rect.Top+Offset;
      FPackingNeeded:= False;
    end;
    FRoot:= nil;
  end;

  for I:= 0 to AFaceCount-1 do
  begin

    // Distribute the lightmaps into the main texture
    if AComputeCoords then
    begin
      for J:= 0 to 2 do
      begin
        FVB[AIB[I*3+J]].LightCoord.x:= (FVB[AIB[I*3+J]].LightCoord.x - FacePlane[I].FUMin) / FacePlane[I].FUDelta;
        FVB[AIB[I*3+J]].LightCoord.y:= (FVB[AIB[I*3+J]].LightCoord.y - FacePlane[I].FVMin) / FacePlane[I].FVDelta;
        FVB[AIB[I*3+J]].LightCoord.x:= (FVB[AIB[I*3+J]].LightCoord.x *
          (FacePlane[I].Width / Size)) + (FacePlane[I].OffsetU / Size);
        FVB[AIB[I*3+J]].LightCoord.y:= (FVB[AIB[I*3+J]].LightCoord.y *
          (FacePlane[I].Height / Size)) + (FacePlane[I].OffsetV / Size);
      end;
    end;

    // Transform the plane into world space
    if not FacePlane[I].Generated then
    begin
      GetWorldPlane(FacePlane[I].Normal, z3DFloat3.From(FVB[AIB[I*3]].Position),
      FacePlane[I].FUMin, FacePlane[I].FUMax, FacePlane[I].FVMin, FacePlane[I].FVMax, FPlane);
      FacePlane[I].Origin:= z3DFloat3.From(FPlane[0]);
      FacePlane[I].Edge1:= z3DFloat3.From(FPlane[1]).Subtract(FPlane[0]);
      FacePlane[I].Edge2:= z3DFloat3.From(FPlane[2]).Subtract(FPlane[0]);
      FacePlane[I].Generated:= True;
    end;
  end;
end;

function Tz3DLightMap.BeginGeneration(const AObject: Iz3DScenarioStaticObject;
  const AAdjacency: Pz3DDWordArray = nil; const AComputeCoords: Boolean = False): Boolean;
var FInstance: Iz3DModelStaticInstance;
    FVB: Pz3DStaticModelVertexArray;
    FIB: PWordArray;
    I: Integer;
begin
  Result:= False;
  if not z3DSupports(AObject, Iz3DModelStaticInstance) then Exit;
  FInstance:= AObject as Iz3DModelStaticInstance;
  FObject:= AObject;
  if not Generated then
  begin

    // Set progress
    InternalBeginStep(z3dlmgsLightCoords);
    InternalProgress(0);

    FAreaFactor:= 1;
    FObjectSize:= z3DFloat3.From(FInstance.Model.Scale);
    FVB:= FInstance.Model.LockVertices;
    FIB:= FInstance.Model.LockIndices;
    try

      // Generate the individual lightmaps and pack them

      // Set progress
      InternalProgress(50);
      GeneratePlanarMapping(FVB, FIB, FInstance.Model.FaceCount, AAdjacency, AComputeCoords);

      // Set progress
      Distribute(FVB, FIB, FInstance.Model.FaceCount, AComputeCoords);

      // Set progress
      CreateTextures;

    finally
      FInstance.Model.UnlockVertices;
      FInstance.Model.UnlockIndices;
    end;


    // Set progress
    InternalProgress(100);
    if GenerationNeeded then BeginDraw;

    // Call the ray tracer to perform the direct lighting
    // and ambient occlusion operations
    if GenerationNeeded then 
    RayTracer.RayTraceLightMap(Self);

    // Save the generated lightmaps
    if Options.EnableAmbient then BlurAndSave(FAmbientTexture);
    for I:= 0 to z3DLightingController.LightCount-1 do
    if z3DLightingController[I].Static then
    BlurAndSave(FLightTextures[I]);

    // Prepare for radiosity if enabled
    FRadiosityLevel:= 0;
    Result:= True;

  end else CreateTextures;
end;

procedure Tz3DLightMap.GenerateLightCoords(const AObject: Iz3DBase;
  const AAdjacency: Pz3DDWordArray = nil);
var FModel: Iz3DStaticModel;
    FVB: Pz3DStaticModelVertexArray;
    FIB: PWordArray;
begin
  if not z3DSupports(AObject, Iz3DStaticModel) or Generated then Exit;
  FModel:= AObject as Iz3DStaticModel;
  FAreaFactor:= 1;
  FObjectSize:= z3DFloat3.From(FModel.Scale);
  FVB:= FModel.LockVertices;
  FIB:= FModel.LockIndices;
  try
    // Generate the lightmap coordinates
    GeneratePlanarMapping(FVB, FIB, FModel.FaceCount, AAdjacency, True);
    Distribute(FVB, FIB, FModel.FaceCount, True);
  finally
    FModel.UnlockVertices;
    FModel.UnlockIndices;
  end;
end;

function Tz3DLightMap.PerformRadiosityBounce: Boolean;
begin
  Result:= False;
  if not Generated and Options.EnableRadiosity and (Options.RadiosityBounces > FRadiosityLevel) then
  begin

    // Call the ray tracer to perform the current radiosity bounce operation
    if GenerationNeeded then
    RayTracer.RayTraceLightMapRadiosity_GPU(Self, FRadiosityLevel);
    Result:= True;
  end;
end;

procedure Tz3DLightMap.EndRadiosityBounce;
begin
  if not Generated and Options.EnableRadiosity and (Options.RadiosityBounces > FRadiosityLevel) then
  begin

    // Call the ray tracer to perform the current radiosity bounce operation
{    if GenerationNeeded then
    RayTracer.NormalizeLightMapRadiosity(Self, FRadiosityLevel);}
    Inc(FRadiosityLevel);
  end;
end;

function Tz3DLightMap.EndGeneration: Boolean;
begin
  if not Generated then
  begin
  
    // End drawing and release pointers
    if GenerationNeeded then EndDraw;
    FGenerated:= True;
    Result:= True;
    SetLength(FDistribution, 0);
    FObject:= nil;
  end;
end;

function Tz3DLightMap.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

procedure Tz3DLightMap.SetEnabled(const Value: Boolean);
begin
  FEnabled:= Value;
end;

procedure Tz3DLightMap.SaveTextures;
var I: Integer;
    FFile: PWideChar;
begin
  // Save the ambient occlusion texture
  if Options.EnableAmbient and FAmbientTexture.Created and not FAmbientTexture.Loaded and not FAmbientTexture.Saved then
  begin
    FFile:= z3DLightMapController.GetTextureFileName(FAmbientTexture.Name);
    D3DXSaveTextureToFileW(FFile,
    D3DXIFF_DDS, FAmbientTexture.Texture.D3DBaseTexture, nil);
    FAmbientTexture.Saved:= True;
  end;

  for I:= 0 to Length(FLightTextures)-1 do
  begin
    // Save the direct lighting texture
    if FLightTextures[I].Created and not FLightTextures[I].Loaded and not FLightTextures[I].Saved then
    begin
      FFile:= z3DLightMapController.GetTextureFileName(FLightTextures[I].Name);
      D3DXSaveTextureToFileW(FFile,
      D3DXIFF_DDS, FLightTextures[I].Texture.D3DBaseTexture, nil);
      FLightTextures[I].Saved:= True;
    end;

    // Save the radiosity lighting texture
    if Options.EnableRadiosity and FRadiosityTextures[I].Created and not FRadiosityTextures[I].Loaded
    and not FRadiosityTextures[I].Saved then
    begin
      FFile:= z3DLightMapController.GetTextureFileName(FRadiosityTextures[I].Name);
      D3DXSaveTextureToFileW(FFile,
      D3DXIFF_DDS, FRadiosityTextures[I].Texture.D3DBaseTexture, nil);
      FRadiosityTextures[I].Saved:= True;
    end;
  end;
end;

function Tz3DLightMap.GetDistributionIndices: TIntegerArray;
begin
  Result:= FDistributionIndices;
end;

function Tz3DLightMap.GetFacePlane(const AFace: Integer): Pz3DLightMapPlane;
begin
  Result:= @FDistribution[FDistributionIndices[AFace]];
end;

function Tz3DLightMap.GetGenerated: Boolean;
begin
  Result:= FGenerated;
end;

function Tz3DLightMap.GetAmbientTexture: Tz3DLightMapTexture;
begin
  Result:= FAmbientTexture;
end;

function Tz3DLightMap.GetLightTextures: Tz3DLightMapTextures;
begin
  Result:= FLightTextures;
end;

function Tz3DLightMap.GetRadiosityTextures: Tz3DLightMapTextures;
begin
  Result:= FRadiosityTextures;
end;

procedure Tz3DLightMap.BeginDraw;
var I: Integer;
begin
  if Options.EnableAmbient then FAmbientTexture.Texture.BeginDraw;
  for I:= 0 to z3DLightingController.LightCount-1 do
  if z3DLightingController[I].Static then
  begin
    FLightTextures[I].Texture.BeginDraw;
    if Options.EnableRadiosity then FRadiosityTextures[I].Texture.BeginDraw;
  end;
end;

procedure Tz3DLightMap.EndDraw;
var I: Integer;
begin
  if Options.EnableAmbient then FAmbientTexture.Texture.EndDraw;
  for I:= 0 to z3DLightingController.LightCount-1 do
  if z3DLightingController[I].Static then
  begin
    FLightTextures[I].Texture.EndDraw;
    if Options.EnableRadiosity then FRadiosityTextures[I].Texture.EndDraw;
  end;
  SetLength(FDistribution, 0);
end;

function Tz3DLightMap.GenerationNeeded: Boolean;
var I: Integer;
begin
  Result:= Options.EnableAmbient and not FAmbientTexture.Loaded;
  if Result then Exit;
  for I:= 0 to z3DLightingController.LightCount-1 do
  if z3DLightingController[I].Static and (not FLightTextures[I].Loaded or
  (Options.EnableRadiosity and not FRadiosityTextures[I].Loaded)) then
  begin
    Result:= True;
    Exit;
  end;
end;

function Tz3DLightMap.GetCurrentObject: Iz3DScenarioStaticObject;
begin
  Result:= FObject;
end;

function Tz3DLightMap.GetOnProgress: Tz3DCallbackLightMapProgressEvent;
begin
  Result:= FOnProgress;
end;

procedure Tz3DLightMap.SetOnProgress(const Value: Tz3DCallbackLightMapProgressEvent);
begin
  FOnProgress:= Value;
end;

procedure Tz3DLightMap.InternalBeginStep(const AStep: Tz3DLightMapGenerationStep);
begin
  FStep:= AStep;
end;

procedure Tz3DLightMap.InternalProgress(const APercent, ALevel: Integer);
begin
  if Assigned(FOnProgress) then
  FOnProgress(FStep, ALevel, APercent);
end;

{ Tz3DRayTracer }

constructor Tz3DRayTracer.Create;
begin
  inherited;
  FNormalLerp:= False;
  FNormalLerpExponent:= 5;
  FShadows:= True;
  FPenumbra:= True;
  FPenumbraDetailFactor:= 12;
  FRadiositySamples:= 16;
  FAOSamples:= 16;
  FGPUTarget:= z3DCreateSurface;
  FGPURadiosityBuffer[0]:= z3DCreateTexture;
  FGPURadiosityBuffer[0].SamplerState.Filter:= z3dsfTrilinear;
  FGPURadiosityBuffer[0].Format:= D3DFMT_X8R8G8B8;
  FGPURadiosityBuffer[0].Enabled:= False;
  FGPURadiosityBuffer[1]:= z3DCreateTexture;
  FGPURadiosityBuffer[1].SamplerState.Filter:= z3dsfTrilinear;
  FGPURadiosityBuffer[1].Format:= D3DFMT_X8R8G8B8;
  FGPURadiosityBuffer[1].Enabled:= False;
end;

procedure Tz3DRayTracer.BeginAOTracing;
var FSurface: IDirect3DSurface9;
begin
  // Create the GPU target for the luxel point of view rendering
  z3DCore_GetD3DDevice.CreateRenderTarget(AOSamples, AOSamples,
  D3DFMT_X8R8G8B8, D3DMULTISAMPLE_NONE, 0, True, FSurface, nil);
  FGPUTarget.D3DSurface:= FSurface;
end;

procedure Tz3DRayTracer.EndAOTracing;
begin
  FGPUTarget.D3DSurface:= nil;
end;

procedure Tz3DRayTracer.BeginRadiosityTracing(const ALightMap: Iz3DLightMap);
var FSurface: IDirect3DSurface9;
    I, FWidth, FHeight: Integer;
    FFormat: TD3DFormat;
begin
  // Create the GPU target for the luxel point of view rendering
  z3DCore_GetD3DDevice.CreateRenderTarget(RadiositySamples, RadiositySamples,
  D3DFMT_X8R8G8B8, D3DMULTISAMPLE_NONE, 0, True, FSurface, nil);
  FGPUTarget.D3DSurface:= FSurface;

  // Create the buffers for the previous and actual radiosity bounce
  for I:= 0 to Length(ALightMap.RadiosityTextures)-1 do
  begin
    if ALightMap.RadiosityTextures[I].Created then
    begin
      FWidth:= ALightMap.RadiosityTextures[I].Texture.Width;
      FHeight:= ALightMap.RadiosityTextures[I].Texture.Height;
      FFormat:= ALightMap.RadiosityTextures[I].Texture.Format;
      Break;
    end;
  end;
  FGPURadiosityBuffer[0].Enabled:= True;
  FGPURadiosityBuffer[0].SetParams(FWidth, FHeight, 1, FFormat);
  FGPURadiosityBuffer[1].Enabled:= True;
  FGPURadiosityBuffer[1].SetParams(FWidth, FHeight, 1, FFormat);
end;

procedure Tz3DRayTracer.EndRadiosityTracing;
begin
  FGPUTarget.D3DSurface:= nil;
  FGPURadiosityBuffer[0].D3DTexture:= nil;
  FGPURadiosityBuffer[0].D3DBaseTexture:= nil;
  FGPURadiosityBuffer[1].D3DTexture:= nil;
  FGPURadiosityBuffer[1].D3DBaseTexture:= nil;
end;

procedure Tz3DRayTracer.BeginGPUTracing(const AAmbient: Boolean = False);
begin
  z3DCore_GetD3DDevice.BeginScene;
  if AAmbient then
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED) else
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED or
  D3DCOLORWRITEENABLE_GREEN or D3DCOLORWRITEENABLE_BLUE or D3DCOLORWRITEENABLE_ALPHA);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_ZENABLE, iTrue);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_ZWRITEENABLE, iTrue);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, iFalse);
  FGPUTarget.SetRenderTarget(0, True);
  z3DModelController.StaticVertexFormat.Apply;
end;

procedure Tz3DRayTracer.EndGPUTracing;
begin
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_ZENABLE, iFalse);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_ZWRITEENABLE, iFalse);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_COLORWRITEENABLE, D3DCOLORWRITEENABLE_RED or
  D3DCOLORWRITEENABLE_GREEN or D3DCOLORWRITEENABLE_BLUE or D3DCOLORWRITEENABLE_ALPHA);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_CCW);
  FGPUTarget.RestoreRenderTarget;
  z3DCore_GetD3DDevice.EndScene;
end;

procedure Tz3DRayTracer.RayTraceLightMap(const ALightMap: Iz3DLightMap);
var I, J, X, Y, FLeft, FTop, FRight, FBottom: Integer;
    FLerpEdge1, FLerpEdge2, FLuxel: Iz3DFloat3;
    A2, A3, FNormal: Iz3DFloat3;
    FInstance: Iz3DModelStaticInstance;
begin

  // Set progress
  ALightMap.InternalBeginStep(z3dlmgsDirectLighting);
  ALightMap.InternalProgress(0);

  FInstance:= ALightMap.CurrentObject as Iz3DModelStaticInstance;

  // Begin GPU ray tracing if enabled
  if ALightMap.Options.EnableAmbient and not
  ALightMap.AmbientTexture.Loaded then BeginAOTracing;

  FLerpEdge1:= z3DFloat3;
  FLerpEdge2:= z3DFloat3;
  FLuxel:= z3DFloat3;
  A2:= z3DFloat3;
  A3:= z3DFloat3;
  FNormal:= z3DFloat3;

  // Iterate through the distribution list
  for I:= 0 to Length(ALightMap.Distribution)-1 do
  begin
    // Offset the edges of the lightmap for blurring and linear filtering
    FLeft:= Trunc(ALightMap.Distribution[I].OffsetU) - ALightMap.Offset;
    FTop:= Trunc(ALightMap.Distribution[I].OffsetV) - ALightMap.Offset;
    FRight:= FLeft + Trunc(ALightMap.Distribution[I].Width) + ALightMap.Offset * 2;
    FBottom:= FTop + Trunc(ALightMap.Distribution[I].Height) + ALightMap.Offset * 2;

    // Create the empty luxels
    SetLength(ALightMap.Distribution[I].Luxels, FRight-FLeft);
    for J:= 0 to Length(ALightMap.Distribution[I].Luxels)-1 do
    SetLength(ALightMap.Distribution[I].Luxels[J], FBottom-FTop);


    // Set progress
    ALightMap.InternalProgress((I + 1) * 100 div Length(ALightMap.Distribution));


    // Begin GPU ray tracing if enabled
    if ALightMap.Options.EnableAmbient and not
    ALightMap.AmbientTexture.Loaded then BeginGPUTracing(True);

    // Iterate through the luxels
    for X:= FLeft to FRight-1 do
    for Y:= FTop to FBottom-1 do
    begin
      // Get the position and normal for the luxel
      FNormal.From(ALightMap.Distribution[I].Normal);
      FLerpEdge1.From(ALightMap.Distribution[I].Edge1).Scale((X - FLeft - ALightMap.Offset + 0.5) / (FRight - FLeft - ALightMap.Offset * 2));
      FLerpEdge2.From(ALightMap.Distribution[I].Edge2).Scale((Y - FTop - ALightMap.Offset + 0.5) / (FBottom - FTop - ALightMap.Offset * 2));
      FLuxel.From(ALightMap.Distribution[I].Origin).Add(FLerpEdge1).Add(FLerpEdge2);

      // Transform to world space
      FLuxel.TransformC(FInstance.WorldMatrix);
      FNormal.TransformN(FInstance.WorldMatrix).Normalize;

      // Get the ambient color for the luxel
      if ALightMap.Options.EnableAmbient and not ALightMap.AmbientTexture.Loaded then
      ALightMap.AmbientTexture.Texture.SetPixel(X, Y, RayTraceAO_GPU(FInstance, FLuxel, FNormal));

      // Get the direct lighting color for the luxel
      for J:= 0 to z3DLightingController.LightCount-1 do
      if z3DLightingController[J].Static and not ALightMap.LightTextures[J].Loaded then
      ALightMap.LightTextures[J].Texture.SetPixel(X, Y, RayTraceLight(FInstance, FLuxel, FNormal, J));

      // Save the world representation of the luxel
      ALightMap.Distribution[I].Luxels[X-FLeft][Y-FTop].Position:= z3DFloat3.From(FLuxel);
      ALightMap.Distribution[I].Luxels[X-FLeft][Y-FTop].Normal:= z3DFloat3.From(FNormal);
    end;

    if ALightMap.Options.EnableAmbient and not
    ALightMap.AmbientTexture.Loaded then EndGPUTracing;
  end;

  if ALightMap.Options.EnableAmbient and not
  ALightMap.AmbientTexture.Loaded then EndAOTracing;
end;

procedure Tz3DRayTracer.RayTraceLightMapRadiosity(const ALightMap: Iz3DLightMap;
  const ALevel: Integer);
var FLeft, FTop, I, K, X, Y: Integer;
    FLightVec, FLightPos, FColor: Iz3DFloat3;
begin

  // Set progress
  ALightMap.InternalBeginStep(z3dlmgsRadiosity);
  ALightMap.InternalProgress(0, ALevel);

  FLightVec:= z3DFloat3;
  FLightPos:= z3DFloat3;
  FColor:= z3DFloat3;
  
  // Iterate through the distribution list
  for I:= 0 to Length(ALightMap.Distribution)-1 do
  begin
    FLeft:= Trunc(ALightMap.Distribution[I].OffsetU) - ALightMap.Offset;
    FTop:= Trunc(ALightMap.Distribution[I].OffsetV) - ALightMap.Offset;

    // Iterate through the luxels
    for X:= 0 to Length(ALightMap.Distribution[I].Luxels)-1 do
    for Y:= 0 to Length(ALightMap.Distribution[I].Luxels[X])-1 do
    begin

      // Use the ambient color to ignore luxels without collisions
      if ALightMap.Options.EnableAmbient then
      begin
        if SameValue(D3DXVec3Length(ALightMap.AmbientTexture.Texture.GetPixel(FLeft + X, FTop + Y).RGB),
        D3DXVec3Length(ALightMap.CurrentObject.Subsets[0].Material.ColorDiffuse.RGB), 0.0001) then
        Continue;
      end;

      // Spread the radiosity color to affected luxels
      for K:= 0 to z3DLightingController.LightCount-1 do
      if z3DLightingController[K].Static and not ALightMap.RadiosityTextures[K].Loaded then
      begin

        if ALevel = 0 then
        begin

          // Get the final color by scaling by the N dot L result
          if z3DLightingController[K].Style = z3DlsDirectional then
          FLightPos.From(z3DLightingController[K].Frustum.LookAt).Normalize.Scale(-z3DLightingController[K].Range)
          else FLightPos.From(z3DLightingController[K].Frustum.Position);
          FLIghtVec.From(FLightPos).Subtract(ALightMap.Distribution[I].Luxels[X][Y].Position).Normalize;
          FColor.From(ALightMap.LightTextures[K].Texture.GetPixel(FLeft + X, FTop + Y).Scale(
            z3DLightingDiffuseDirectional(ALightMap.Distribution[I].Luxels[X][Y].Normal, FLightVec)).RGB);
        end else
        FColor.From(ALightMap.Distribution[I].Luxels[X][Y].RadiosityColors[ALevel-1][K]);

        // Radiosity the current color to the environment
        RayTraceRadiosity(ALightMap.CurrentObject, ALightMap.Distribution[I].Luxels[X][Y],
        ALightMap.Distribution[I].Luxels[X][Y].Position, ALightMap.Distribution[I].Luxels[X][Y].Normal,
        ALightMap.Distribution[I].Origin, ALightMap.Distribution[I].Edge1,
        ALightMap.Distribution[I].Edge2, FColor, K, ALevel);

      end;
    end;
  end;
end;

procedure Tz3DRayTracer.RayTraceLightMapRadiosity_GPU(const ALightMap: Iz3DLightMap;
  const ALevel: Integer);
var FLeft, FTop, I, K, X, Y: Integer;
    FLightVec, FLightPos, FColor: Iz3DFloat3;
    FContinue: Boolean;
    FTemp: Iz3DTexture;
begin
  // Set progress
  ALightMap.InternalBeginStep(z3dlmgsRadiosity);
  ALightMap.InternalProgress(0, ALevel);

  FLightVec:= z3DFloat3;
  FLightPos:= z3DFloat3;
  FColor:= z3DFloat3;
  FGPURadiosityBuffer[1].BeginDraw;

  // Iterate through the distribution list
  for I:= 0 to Length(ALightMap.Distribution)-1 do
  begin

    // Set progress
    ALightMap.InternalProgress((I + 1) * 100 div Length(ALightMap.Distribution), ALevel);

    FLeft:= Trunc(ALightMap.Distribution[I].OffsetU) - ALightMap.Offset;
    FTop:= Trunc(ALightMap.Distribution[I].OffsetV) - ALightMap.Offset;

    BeginGPUTracing(False);

    // Iterate through the luxels
    for X:= 0 to Length(ALightMap.Distribution[I].Luxels)-1 do
    for Y:= 0 to Length(ALightMap.Distribution[I].Luxels[X])-1 do
    begin

      FContinue:= False;
      // Use the ambient color to ignore luxels without collisions
      if ALightMap.Options.EnableAmbient then
      begin
        if SameValue(ALightMap.AmbientTexture.Texture.GetPixel(X + FLeft, Y + FTop).Length,
        ALightMap.CurrentObject.Subsets[0].Material.ColorDiffuse.Length, 0.00001) then
        FContinue:= True;
      end;

      // Spread the radiosity color to affected luxels
      for K:= 0 to z3DLightingController.LightCount-1 do
      if z3DLightingController[K].Static and not ALightMap.RadiosityTextures[K].Loaded then
      begin

        // Get the radiosity value for this light and level
        if not FContinue then FColor.From(RayTraceRadiosity_GPU(ALightMap.CurrentObject,
        ALightMap.Distribution[I].Luxels[X][Y].Position, ALightMap.Distribution[I].Luxels[X][Y].Normal,
        K, ALevel)) else FColor.Identity;

        FGPURadiosityBuffer[1].SetPixel(X + FLeft, Y + FTop, FColor);
        ALightMap.RadiosityTextures[K].Texture.SetPixel(X + FLeft, Y + FTop,
        FColor.Add(ALightMap.RadiosityTextures[K].Texture.GetPixel(X + FLeft, Y + FTop).RGB).Saturate);
      end;
    end;

    EndGPUTracing;

  end;
  FGPURadiosityBuffer[1].EndDraw;
  FTemp:= FGPURadiosityBuffer[0];
  FGPURadiosityBuffer[0]:= FGPURadiosityBuffer[1];
  FGPURadiosityBuffer[1]:= FTemp;
end;

procedure Tz3DRayTracer.NormalizeLightMapRadiosity(const ALightMap: Iz3DLightMap;
  const ALevel: Integer);
var I, K, X, Y: Integer;
    FColor: Iz3DFloat3;
begin
  FColor:= z3DFloat3;

  // Iterate through the distribution list
  for I:= 0 to Length(ALightMap.Distribution)-1 do
  begin

    // Iterate through the luxels
    for X:= 0 to Length(ALightMap.Distribution[I].Luxels)-1 do
    for Y:= 0 to Length(ALightMap.Distribution[I].Luxels[X])-1 do
    begin

      // Normalize the radiosity color
      for K:= 0 to z3DLightingController.LightCount-1 do
      if z3DLightingController[K].Static and not ALightMap.RadiosityTextures[K].Loaded then
      begin
        if Round(ALightMap.Distribution[I].Luxels[X][Y].RadiositySamples[ALevel][K]) = 0 then
        FColor.Identity else
        FColor.From(ALightMap.Distribution[I].Luxels[X][Y].RadiosityColors[ALevel][K]).Scale(
        2 / ALightMap.Distribution[I].Luxels[X][Y].RadiositySamples[ALevel][K]);
        ALightMap.Distribution[I].Luxels[X][Y].RadiosityColors[ALevel][K].From(FColor);
      end;
    end;
  end;
end;

function Tz3DRayTracer.RayTraceRadiosity(const AObject: Iz3DScenarioObject; var ALumel: Tz3DLightMapLuxel; const ACenter, ANormal,
  AOrigin, AEdge1, AEdge2, AColor: Iz3DFloat3; const ALight, ALevel: Integer): Iz3DFloat3;
const FEpsilon = 1e-3;
var FSpread, I, J, K, LX, LY, X, Y: Integer;
    FLN, FExcidentColor, FColor, FEdge1, FEdge2, FTemp1, FTemp2, FTempVec, FRayVec, FRayVecN: Iz3DFloat3;
    AO, AE1, AE2: Iz3DFloat3;
    FAmount, FDet, FDistance, FDistance2, FLerpI, FLerpJ: Single;
    FObjectCol: Iz3DScenarioObject;
    FModelCol: Iz3DModelStaticInstance;
    FPlaneIndex, FNormalSource: Integer;
    FTested, FCollision: Boolean;
    FMesh: Iz3DModelStaticInstance;
    FRay: Tz3DRay;
    FTriangle: Tz3DTriangle;
    FDestLuxel: Pz3DLightMapLuxel;
begin

  // Ignore luxels with almost no lighting
  FExcidentColor:= z3DFloat3.From(AColor).Scale(AObject.Subsets[0].Material.Reflectivity);
  if FExcidentColor.Length < FEpsilon then Exit;

  FTested:= ALumel.CollisionTested;
  FEdge1:= z3DFloat3.From(AEdge1).Normalize;
  FEdge2:= z3DFloat3.From(AEdge2).Normalize;
  FRay.Origin:= z3DFloat3.From(ACenter);
  FRayVec:= z3DFloat3;
  FRayVecN:= z3DFloat3;
  FLN:= z3DFloat3;
  AO:= z3DFloat3;
  AE1:= z3DFloat3;
  AE2:= z3DFloat3;
  FTriangle:= z3DTriangle;
  FColor:= z3DFloat3;

  // Create the radiosity structure if empty
  if not FTested then
  begin
    SetLength(ALumel.Collisions, RadiositySamples);
    for I:= 0 to RadiositySamples-1 do SetLength(ALumel.Collisions[I], RadiositySamples);
    ALumel.CollisionTested:= True;
  end;

  // Perform a spheric interpolation between the normal and the edges to
  // sample the radiosity from the center point to the surrounding world
  for I:= 0 to RadiositySamples-1 do
  for J:= 0 to RadiositySamples-1 do
  begin

    // If the collision test was saved on a previous level, reuse it
    if FTested then
    begin
      FCollision:= ALumel.Collisions[I][J].Collision;
      if not FCollision or (ALumel.Collisions[I][J].PlaneIndex = -1) then Continue;
      FObjectCol:= ALumel.Collisions[I][J].Target as Iz3DModelStaticInstance;
      FMesh:= FObjectCol as Iz3DModelStaticInstance;
      if not FMesh.LightMap.Options.EnableRadiosity or
      (FMesh.LightMap.Options.RadiosityBounces < ALevel) then Continue;
      FDistance:= ALumel.Collisions[I][J].Distance;
      FPlaneIndex:= ALumel.Collisions[I][J].PlaneIndex;
      FDet:= ALumel.Collisions[I][J].Determinant;
      FDestLuxel:= ALumel.Collisions[I][J].Luxel;
    end else

    // If the collision test was not saved, test it now
    begin
      // Create the ray structure
      FDet:= z3DPlaneRaySHLerp(ANormal, FEdge1, FEdge2, I, J, AOSamples, FRayVecN);
      FRay.Length:= z3DEngine.Scenario.ViewFrustum.FarClip * 0.1;

      FRayVec.From(FRayVecN).Scale(FRay.Length);
      FRay.Direction:= FRayVecN;

      // Perform a collision test for this ray
      FCollision:= RayCollision(AObject, FRay, FAmount, FObjectCol, FDistance, False);
      ALumel.Collisions[I][J].Collision:= FCollision;
      if not FCollision then Continue;
      if not z3DSupports(FObjectCol, Iz3DModelStaticInstance) then Continue;
      FModelCol:= FObjectCol as Iz3DModelStaticInstance;         
      ALumel.Collisions[I][J].Target:= FObjectCol as Iz3DScenarioStaticObject;
      ALumel.Collisions[I][J].Distance:= FDistance;
      ALumel.Collisions[I][J].Determinant:= FDet;
      FMesh:= FObjectCol as Iz3DModelStaticInstance;
      if not FMesh.LightMap.Options.EnableRadiosity or
      (FMesh.LightMap.Options.RadiosityBounces < ALevel) then Continue;

      // If a collision was found, search for the target lightmap plane
      FPlaneIndex:= -1;
      for K:= 0 to Length(FMesh.LightMap.Distribution)-1 do
      begin

        // Ignore the plane if its facing away from the ray
        FLN.From(FMesh.LightMap.Distribution[K].Normal).TransformN(FModelCol.WorldMatrix).Normalize;
        if FLN.Dot(FRay.Direction) < FEpsilon then Continue;

        // Ignore the plane if theres a near plane or no intersection found
        FTriangle[0].From(FMesh.LightMap.Distribution[K].Origin).TransformC(FModelCol.WorldMatrix);
        FTriangle[1].From(FMesh.LightMap.Distribution[K].Edge1).Add(FMesh.LightMap.Distribution[K].Origin).TransformC(FModelCol.WorldMatrix);
        FTriangle[2].From(FMesh.LightMap.Distribution[K].Edge2).Add(FMesh.LightMap.Distribution[K].Origin).TransformC(FModelCol.WorldMatrix);
        if not RayIntersectPlane(FRay, FTriangle, FDistance2) or (FDistance2 > FDistance) then Continue;

        FPlaneIndex:= K;

        // The plane was found, now search for the right luxel
        // using this formula:
        //
        // Destination luxel = (tVec - FirstLuxel) * LuxelCount / (LastLuxel - FirstLuxel)
        // where
        // tVec: -RayDirection * Distance + RayOrigin
        AO.From(FRay.Direction).Scale(-FDistance).Add(FRay.Origin);
        AE1.From(AO).Subtract(FMesh.LightMap.Distribution[K].Luxels[0][0].Position);
        AE1.From(FMesh.LightMap.Distribution[K].Luxels[Length(FMesh.LightMap.Distribution[K].Luxels)-1]
        [Length(FMesh.LightMap.Distribution[K].Luxels[Length(FMesh.LightMap.Distribution[K].Luxels)-1])-1].Position).
        Subtract(FMesh.LightMap.Distribution[K].Luxels[0][0].Position);
        if (Abs(FLN.X) > Abs(FLN.Y)) and (Abs(FLN.X) > Abs(FLN.Z)) then
        begin
          X:= Round((AE1.y * Length(FMesh.LightMap.Distribution[K].Luxels)) / AE2.y);
          Y:= Round((AE1.z * Length(FMesh.LightMap.Distribution[K].Luxels[Length(FMesh.LightMap.Distribution[K].Luxels)-1])) / AE2.z);
        end else
        if (Abs(FLN.Y) > Abs(FLN.X)) and (Abs(FLN.Y) > Abs(FLN.Z)) then
        begin
          X:= Round((AE1.x * Length(FMesh.LightMap.Distribution[K].Luxels)) / AE2.x);
          Y:= Round((AE1.z * Length(FMesh.LightMap.Distribution[K].Luxels[Length(FMesh.LightMap.Distribution[K].Luxels)-1])) / AE2.z);
        end else
        begin
          X:= Round((AE1.x * Length(FMesh.LightMap.Distribution[K].Luxels)) / AE2.x);
          Y:= Round((AE1.y * Length(FMesh.LightMap.Distribution[K].Luxels[Length(FMesh.LightMap.Distribution[K].Luxels)-1])) / AE2.y);
        end;

        // Clamp the luxel to the distribution plane
        X:= Max(0, Min(X, Length(FMesh.LightMap.Distribution[K].Luxels)-1));
        Y:= Max(0, Min(Y, Length(FMesh.LightMap.Distribution[K].Luxels[X])-1));
        FDestLuxel:= @FMesh.LightMap.Distribution[FPlaneIndex].Luxels[X][Y];
        ALumel.Collisions[I][J].Luxel:= FDestLuxel;

        // The destination luxel was found, so stop searching
        Break;
      end;
    end;

    // If no plane was found, ignore this ray
    ALumel.Collisions[I][J].PlaneIndex:= FPlaneIndex;
    if FPlaneIndex = -1 then Continue;

    // Find the destination color
    FDistance2:= 1 + FDistance;
    FDet:= Saturate(Power(FDet, 0.25));
    FColor.x:= (FExcidentColor.x * FObjectCol.Subsets[0].Material.ColorDiffuse.R * FDet) / FDistance2;
    FColor.y:= (FExcidentColor.y * FObjectCol.Subsets[0].Material.ColorDiffuse.G * FDet) / FDistance2;
    FColor.z:= (FExcidentColor.z * FObjectCol.Subsets[0].Material.ColorDiffuse.B * FDet) / FDistance2;
    if FColor.Length < FEpsilon then Continue;

    // Add the radiosity color to the destination luxel
    FDestLuxel.RadiosityColors[ALevel][ALight].Add(FColor);
    FDestLuxel.RadiositySamples[ALevel][ALight]:= FDestLuxel.RadiositySamples[ALevel][ALight] + 1;
  end;
end;

function Tz3DRayTracer.RayTraceRadiosity_GPU(const AObject: Iz3DScenarioObject;
  const ACenter, ANormal: Iz3DFloat3; const ALight, ALevel: Integer): Iz3DFloat3;
const FEpsilon = 1e-3;
var I, J: Integer;
    FNormI, FNormJ: Single;
    FInstance: Iz3DModelStaticInstance;
    FView: Iz3DMatrix;
    FProj: Iz3DMatrix;
    FWorldViewProj: Iz3DMatrix;
    FScaleX, FScaleY: Single;
    FPos4: Iz3DFloat4;
begin
  // Convert the current luxel into a camera view
  if ANormal.Y > 0.99999 then FView:= z3DMatrix.LookAt(ACenter, z3DFloat3.From(ACenter).Add(ANormal), z3DFloat3(0, 0, -1)) else
  if ANormal.Y <- 0.99999 then FView:= z3DMatrix.LookAt(ACenter, z3DFloat3.From(ACenter).Add(ANormal), z3DFloat3(0, 0, 1)) else
  FView:= z3DMatrix.LookAt(ACenter, z3DFloat3.From(ACenter).Add(ANormal));
  z3DScenario.ViewFrustum.ViewMatrix.From(FView);
  FProj:= z3DMatrix.PerspectiveFOV(z3DPI / 1.4);
  FWorldViewProj:= z3DMatrix;

  // Render the current view
  z3DEngine.Renderer.Clear(z3DFloat4(0, 0, 0, 1));
  if ALevel = 0 then z3DLightingController.Shader.Technique:= 'z3DLighting_GPUStaticRadiosity0' else
  z3DLightingController.Shader.Technique:= 'z3DLighting_GPUStaticRadiosity';
  with z3DLightingController.Lights[ALight].Frustum.LookAt do
  FPos4:= z3DFloat4(-X, -Y, -Z, 0).Transform(FView).Normalize;
  z3DLightingController.Shader.Float4['GLightDirView']:= FPos4;
  for I:= 0 to z3DLightingController.Shader.Prepare-1 do
  begin
    z3DLightingController.Shader.BeginPass;
    for J:= 0 to z3DScenario.StaticObjectCount-1 do
    if z3DSupports(z3DScenario.StaticObjects[J], Iz3DModelStaticInstance) and
    (z3DScenario.StaticObjects[J] as Iz3DModelStaticInstance).LightMap.Enabled
    and ((ALevel = 0) or ((z3DScenario.StaticObjects[J] as Iz3DModelStaticInstance).LightMap.Options.EnableRadiosity and
    ((z3DScenario.StaticObjects[J] as Iz3DModelStaticInstance).LightMap.Options.RadiosityBounces > ALevel))) then
    begin
      FInstance:= z3DScenario.StaticObjects[J] as Iz3DModelStaticInstance;
      FWorldViewProj.From(FInstance.WorldMatrix).Multiply(FView);
      z3DLightingController.Shader.Matrix['GWorldViewMatrix']:= FWorldViewProj;
      z3DLightingController.Shader.Matrix['GWorldViewProjectionMatrix']:= FWorldViewProj.Multiply(FProj);
      z3DLightingController.Shader.Param['GMaterialReflectivity']:= z3DScenario.StaticObjects[J].Subsets[0].Material.Reflectivity;
      if ALevel = 0 then FInstance.LightMap.LightTextures[ALight].Texture.AttachToSampler(2, True, True) else
      FInstance.LightMap.RayTracer.RadiosityBuffer0.AttachToSampler(2, True, True);
      FInstance.Model.RenderMesh(z3DLightingController.Shader, z3dsolHigh, True, False, True);
    end;
    z3DLightingController.Shader.EndPass;
  end;

  // Read the result to sample the current radiosity amount
  Result:= z3DFloat3;
  FGPUTarget.BeginDraw;
  try
    for I:= 0 to RadiositySamples-1 do
    for J:= 0 to RadiositySamples-1 do
    begin
      FNormI:= (I / RadiositySamples);
      FScaleX:= FNormI * (1 - FNormI) * 4;
      FNormJ:= (J / RadiositySamples);
      FScaleY:= FNormJ * (1 - FNormJ) * 4;
      Result.Add(FGPUTarget.GetPixel(I, J).Scale(FScaleX * FScaleY).RGB);
    end;
  finally
    FGPUTarget.EndDraw;
  end;
  Result.Scale(2.25 / (RadiositySamples * RadiositySamples)).Saturate;
end;

function Tz3DRayTracer.RayTraceLight(const AObject: Iz3DScenarioObject; const ACenter, ANormal: Iz3DFloat3;
  const ALight: Integer): Iz3DFloat3;
const FBias = 0.0001;
      FDotBias = 0.35;
      FX = 0.25;
      FY = 0.01;
      FZ = 0.25;
var FLightPos, FLightPosLerp, FLightDir, FLightVec, FLightVecN: Iz3DFloat3;
    FDiffuse, FAmount, FDistance: Single;
    LX, LY, LZ, FCenterX, FCenterY, FCenterZ: Integer;
    FPLX, FPLY, FPLZ: Single;
    FObjectCol: Iz3DScenarioObject;
    FRay: Tz3DRay;
begin
  FAmount:= 1;
  if z3DLightingController[ALight].Style = z3DlsDirectional then
  FLightPos:= z3DFloat3.From(z3DLightingController[ALight].Frustum.LookAt).Normalize.
  Scale(-z3DLightingController[ALight].Range) else
  FLightPos:= z3DFloat3.From(z3DLightingController[ALight].Frustum.Position);

  FLightVec:= z3DFloat3.From(FLightPos).Subtract(ACenter);
  FDistance:= FLightVec.Length;
  FLightVecN:= z3DFloat3.From(FLightVec).Normalize;

  // N dot L and distance 
  if z3DLightingController[ALight].Style = z3dlsDirectional then
  FDiffuse:= Saturate(ANormal.Dot(FLightVecN) + FDotBias) else
  FDiffuse:= Saturate(ANormal.Dot(FLightVec) + FDotBias);
  if SameValue(FDiffuse, 0, FBias) then FDiffuse:= 0 else FDiffuse:= 1;
  if z3DLightingController[ALight].Style <> z3dlsDirectional then

  FDiffuse:= (FDiffuse) * Power(Saturate(1 - FDistance / z3DLightingController[ALight].Range), 2);

  // Spot computation
  if z3DLightingController[ALight].Style = z3dlsSpot then
  begin
    FLightDir:= z3DFloat3.From(z3DLightingController[ALight].Frustum.LookAt).Negate.Normalize;
    FAmount:= FAmount * z3DLightingSpot(FLightVecN, FLightDir, z3DLightingController[ALight].Angle, z3DLightingController[ALight].Sharpness);
  end;

  if FDiffuse * FAmount < FBias then
  begin
    Result:= z3DFloat3;
    Exit;
  end;

  // Shadow and penumbra computation
//  if Shadows and z3DLightingController[ALight].Effects.StaticShadows then
  begin
    if Penumbra and z3DLightingController[ALight].Effects.StaticPenumbra then
    begin
      FCenterX:= Round(Clamp((z3DLightingController[ALight].Size * PenumbraDetailFactor) / FDistance, 0, 8));
      FCenterY:= Round(Clamp((z3DLightingController[ALight].Size * PenumbraDetailFactor) / FDistance, 0, 8));
      FCenterZ:= Round(Clamp((z3DLightingController[ALight].Size * PenumbraDetailFactor) / FDistance, 0, 8));
      for LX:= -FCenterX to FCenterX do
      for LY:= -FCenterY to FCenterY do
      for LZ:= -FCenterZ to FCenterZ do
      begin
        if FAmount <= FBias then Break;
        if FCenterX = 0 then FPLX:= 0 else FPLX:= (LX + FCenterX) / (FCenterX * 2);
        if FCenterY = 0 then FPLY:= 0 else FPLY:= (LY + FCenterY) / (FCenterY * 2);
        if FCenterZ = 0 then FPLZ:= 0 else FPLZ:= (LZ + FCenterZ) / (FCenterZ * 2);
        FLightPosLerp:= z3DFloat3.From(FLightPos).Add(z3DFloat3(
        Lerp(-z3DLightingController[ALight].Size * 0.5, z3DLightingController[ALight].Size * 0.5, FPLX),
        Lerp(-z3DLightingController[ALight].Size * 0.5, z3DLightingController[ALight].Size * 0.5, FPLY),
        Lerp(-z3DLightingController[ALight].Size * 0.5, z3DLightingController[ALight].Size * 0.5, FPLZ)));
        FLightVec.From(FLightPosLerp).Subtract(ACenter);
        FLightVecN.From(FLightVec).Normalize;

        FRay.Origin:= FLightPosLerp;
        FRay.Direction:= FLightVecN;
        FRay.Length:= FLightVec.Length;

        // Check collisions for shadowing using bounds and low quality polygons
        RayCollision(AObject, FRay, FAmount, FObjectCol, FDistance, True, False, Round(IntPower((FCenterZ*2+1), 3)));
      end;
    end else
    begin
      FRay.Origin:= FLightPos;
      FRay.Direction:= FLightVecN;
      FRay.Length:= FLightVec.Length;

      // Check collisions for shadowing using bounds and low quality polygons
      RayCollision(AObject, FRay, FAmount, FObjectCol, FDistance, True, False);
    end;
  end;

  // Return the final color
  Result:= z3DFloat3;
  Result.x:= Saturate(z3DLightingController[ALight].Color.r *
    AObject.Subsets[0].Material.ColorDiffuse.R * FDiffuse * FAmount);
  Result.y:= Saturate(z3DLightingController[ALight].Color.g *
    AObject.Subsets[0].Material.ColorDiffuse.G * FDiffuse * FAmount);
  Result.z:= Saturate(z3DLightingController[ALight].Color.b *
    AObject.Subsets[0].Material.ColorDiffuse.B * FDiffuse * FAmount); 
end;

function Tz3DRayTracer.RayTraceAO(const AObject: Iz3DScenarioObject; const ACenter, ANormal,
  AOrigin, AEdge1, AEdge2: Iz3DFloat3; out ACollision: Boolean): Iz3DFloat3;
const FEpsilon = 1e-3;
var I, J: Integer;
    FEdge1, FEdge2, FRayVec, FRayVecN: Iz3DFloat3;
    FDistance, FAmount: Single;
    FObjectCol: Iz3DScenarioObject;
    FRay: Tz3DRay;
begin
  ACollision:= False;
  FAmount:= 1;
  FEdge1:= z3DFloat3.From(AEdge1).Normalize;
  FEdge2:= z3DFloat3.From(AEdge2).Normalize;
  FRayVec:= z3DFloat3;
  FRay.Origin:= z3DFloat3.From(ACenter);
  FRay.Direction:= z3DFloat3;

  // Perform a spheric interpolation between the normal and the edges to
  // sample the ambient lighting from the world that reaches the center point
  for I:= 0 to AOSamples-1 do
  for J:= 0 to AOSamples-1 do
  begin
    z3DPlaneRaySHLerp(ANormal, FEdge1, FEdge2, I, J, AOSamples, FRayVecN);
    FRay.Length:= z3DEngine.Scenario.ViewFrustum.FarClip * 0.1;
    FRayVec.From(FRayVecN).Scale(FRay.Length);
    FRay.Direction.From(FRayVecN);

    // Check collisions without vertex and distance evaluation
    if RayCollision(AObject, FRay, FAmount, FObjectCol, FDistance, False, False,
    AOSamples*AOSamples) then ACollision:= True;
  end;

  // Return the final color
  Result:= z3DFloat3.From(AObject.Subsets[0].Material.ColorDiffuse.RGB).Scale(FAmount).Saturate;
end;

function Tz3DRayTracer.RayTraceAO_GPU(const AObject: Iz3DScenarioObject;
  const ACenter, ANormal: Iz3DFloat3): Iz3DFloat3;
const FEpsilon = 1e-3;
var I, J: Integer;
    FNormI, FNormJ: Single;
    FInstance: Iz3DModelStaticInstance;
    FView: Iz3DMatrix;
    FProj: Iz3DMatrix;
    FWorldViewProj: Iz3DMatrix;
    FScaleX, FScaleY: Single;
begin

  // Convert the current luxel into a camera view
  if ANormal.Y > 0.99999 then FView:= z3DMatrix.LookAt(ACenter, z3DFloat3.From(ACenter).Add(ANormal), z3DFloat3(0, 0, -1)) else
  if ANormal.Y <-0.99999 then FView:= z3DMatrix.LookAt(ACenter, z3DFloat3.From(ACenter).Add(ANormal), z3DFloat3(0, 0, 1)) else
  FView:= z3DMatrix.LookAt(ACenter, z3DFloat3.From(ACenter).Add(ANormal));
  FProj:= z3DMatrix.PerspectiveFOV(z3DPI / 1.25);
  FView.Multiply(FProj);
  FWorldViewProj:= z3DMatrix;

  // Render the current view
  z3DEngine.Renderer.Clear(z3DFloat4(1, 1, 1, 1));
  z3DLightingController.Shader.Technique:= 'z3DLighting_GPUStaticAO';
  for I:= 0 to z3DLightingController.Shader.Prepare-1 do
  begin
    z3DLightingController.Shader.BeginPass;
    for J:= 0 to z3DScenario.StaticObjectCount-1 do
    if z3DSupports(z3DScenario.StaticObjects[J], Iz3DModelStaticInstance) then
    begin
      FInstance:= z3DScenario.StaticObjects[J] as Iz3DModelStaticInstance;
      FWorldViewProj.From(FInstance.WorldMatrix).Multiply(FView);
      z3DLightingController.Shader.Matrix['GWorldViewProjectionMatrix']:= FWorldViewProj;
      FInstance.Model.RenderMesh(z3DLightingController.Shader, z3dsolHigh, False, False, False);
    end;
    z3DLightingController.Shader.EndPass;
  end;

  // Read the result to sample the current occlusion
  Result:= z3DFloat3;
  FGPUTarget.BeginDraw;
  try
    for I:= 0 to AOSamples-1 do
    for J:= 0 to AOSamples-1 do
    begin
      FNormI:= (I / AOSamples);
      FScaleX:= FNormI * (1 - FNormI) * 4;
      FNormJ:= (J / AOSamples);
      FScaleY:= FNormJ * (1 - FNormJ) * 4;
      Result.R:= Result.R + FGPUTarget.GetPixel(I, J).Scale(FScaleX * FScaleY).R;
    end;
  finally
    FGPUTarget.EndDraw;
  end;
  
  Result.G:= Result.R;
  Result.B:= Result.R;
  Result.Scale(2.25 / (AOSamples * AOSamples)).Saturate;
  Result.R:= Result.R * AObject.Subsets[0].Material.ColorDiffuse.R;
  Result.G:= Result.G * AObject.Subsets[0].Material.ColorDiffuse.G;
  Result.B:= Result.B * AObject.Subsets[0].Material.ColorDiffuse.B;
end;

function Tz3DRayTracer.RayIntersectTriangle(const ARay: Tz3DRay; const ATriangle: Tz3DTriangle;
  var ADistance: Single): Boolean;
const FEpsilon = 1e-3;
var FEdge1, FEdge2, FT, FP, FQ: Iz3DFloat3;
    FDistance, FDet, FInvDet, FU, FV: Single;
begin
  Result:= False;
  FEdge1:= z3DFloat3.From(ATriangle[1]).Subtract(ATriangle[0]);
  FEdge2:= z3DFloat3.From(ATriangle[2]).Subtract(ATriangle[0]);
  FP:= z3DFloat3.From(ARay.Direction).Cross(FEdge2);
  FDet:= FEdge1.Dot(FP);
  if (FDet < FEpsilon) and (FDet > -FEpsilon) then Exit;
  FInvDet:= 1 / FDet;
  FT:= z3DFloat3.From(ARay.Origin).Subtract(ATriangle[0]);
  FU:= FT.Dot(FP) * FInvDet;
  if (FU < 0) or (FU > 1) then Exit;
  FQ:= z3DFloat3.From(FT).Cross(FEdge1);
  FV:= ARay.Direction.Dot(FQ) * FInvDet;
  if (FV < 0) or (FU + FV > 1) then Exit;
  FDistance:= FEdge2.Dot(FQ) * FInvDet;
  if (FDistance < 0) and (Abs(FDistance) < ARay.Length - FEpsilon) then
  begin
    Result:= True;
    ADistance:= Abs(FDistance) + FEpsilon;
  end;
end;

function Tz3DRayTracer.RayIntersectVertex(const AObject1, AObject2: Iz3DScenarioObject; const ARay: Tz3DRay;
  var ADistance: Single): Boolean;
const FEpsilon = 1e-3;
var FVB: Pz3DStaticModelVertexArray;
    FIB: PWordArray;
    FModel: Iz3DModelStaticInstance;
    FV31, FV32, FV33: Iz3DFloat3;
    FTriangle: Tz3DTriangle;
    FLOD: Tz3DScenarioObjectLOD;
    I: Integer;
begin
  // Perform a vertex-level intersection test
  Result:= False;
  if not z3DSupports(AObject2, Iz3DModelStaticInstance) then Exit;
  FModel:= AObject2 as Iz3DModelStaticInstance;
  if (AObject2 as Iz3DScenarioEntity).Index <> (AObject1 as Iz3DScenarioEntity).Index then
  FLOD:= z3dsolMid else FLOD:= z3dsolHigh;
  FVB:= FModel.Model.LockLODVertices(FLOD, D3DLOCK_READONLY or D3DLOCK_DONOTWAIT);
  try
    FIB:= FModel.Model.LockLODIndices(FLOD, D3DLOCK_READONLY or D3DLOCK_DONOTWAIT);
    try
      FV31:= z3DFloat3;
      FV32:= z3DFloat3;
      FV33:= z3DFloat3;
      FTriangle:= z3DTriangle;
      for I:= 0 to FModel.Model.LODFaceCount[FLOD]-1 do
      begin
        FTriangle[0].From(FVB[FIB[I*3]].Position).TransformC(FModel.WorldMatrix);
        FTriangle[1].From(FVB[FIB[I*3+1]].Position).TransformC(FModel.WorldMatrix);
        FTriangle[2].From(FVB[FIB[I*3+2]].Position).TransformC(FModel.WorldMatrix);
        if RayIntersectTriangle(ARay, FTriangle, ADistance) and
        (((AObject2 as Iz3DScenarioEntity).Index <> (AObject1 as Iz3DScenarioEntity).Index) or
        (ADistance < ARay.Length - 0.1)) then
        begin
          Result:= True;
          Break;
        end;
      end;
    finally
      FModel.Model.UnlockLODIndices;
    end;
  finally
    FModel.Model.UnlockLODVertices;
  end;
end;

function Tz3DRayTracer.RayIntersectBoundingSphere(const ARay: Tz3DRay; const ASphere: Iz3DBoundingSphere;
  var ADistance: Single): Boolean;
const FEpsilon = 1e-3;
var FQ: Iz3DFloat3;
    FDistance, FL, FDot, FDet: Single;
begin
  // Perform a bounding sphere-level intersection test
  FQ:= z3DFloat3.From(ASphere.Center).Subtract(ARay.Origin);
  FL:= FQ.Length;
  FDot:= FQ.Dot(ARay.Direction);
  FDet:= ASphere.Radius * ASphere.Radius - (FL * FL - FDot * FDot);
  if FDet < FEpsilon then Result:= False else
  begin
    FDistance:= FDot + Sqrt(FDet);
    Result:= (FDistance < 0) and (Abs(FDistance) < ARay.Length - FEpsilon);
    if Result then ADistance:= Abs(FDistance) + FEpsilon;
  end;
end;


function Tz3DRayTracer.RayIntersectPlane(const ARay: Tz3DRay; const APlane: Tz3DTriangle; var ADistance: Single): Boolean;
const FEpsilon = 1e-3;
var FEdge1, FEdge2, FT, FP, FQ: Iz3DFloat3;
    FDistance, FDet, FInvDet, FU, FV: Single;
begin
  Result:= False;
  FEdge1:= z3DFloat3.From(APlane[1]).Subtract(APlane[0]);
  FEdge2:= z3DFloat3.From(APlane[2]).Subtract(APlane[0]);
  FP:= z3DFloat3.From(ARay.Direction).Cross(FEdge2);
  FDet:= FEdge1.Dot(FP);
  if (FDet < FEpsilon) and (FDet > -FEpsilon) then Exit;
  FInvDet:= 1 / FDet;
  FT:= z3DFloat3.From(ARay.Origin).Subtract(APlane[0]);
  FU:= FT.Dot(FP) * FInvDet;
  if (FU < 0) or (FU > 1) then Exit;
  FQ:= z3DFloat3.From(FT).Cross(FEdge1);
  FV:= ARay.Direction.Dot(FQ) * FInvDet;
  if (FV < 0) or (FV > 1) then Exit;
  FDistance:= FEdge2.Dot(FQ) * FInvDet;
  if (FDistance < 0) and (Abs(FDistance) < ARay.Length - FEpsilon) then
  begin
    Result:= True;
    ADistance:= Abs(FDistance) + FEpsilon;
  end;
end;

function Tz3DRayTracer.RayIntersectBoundingBox(const ARay: Tz3DRay; const ABox: Iz3DBoundingBox;
  var ADistance: Single; const ATEvaluation: Boolean = True): Boolean;
const FEpsilon = 1e-3;
var FDistance, FMinX, FMinY, FMinZ, FMaxX, FMaxY, FMaxZ: Single;
    FPlane: Tz3DTriangle;
begin
  Result:= False;
  ADistance:= ARay.Length;
  FMinX:= ABox.Center.x - ABox.Dimensions.x * 0.5;
  FMinY:= ABox.Center.y - ABox.Dimensions.y * 0.5;
  FMinZ:= ABox.Center.z - ABox.Dimensions.z * 0.5;
  FMaxX:= ABox.Center.x + ABox.Dimensions.x * 0.5;
  FMaxY:= ABox.Center.y + ABox.Dimensions.y * 0.5;
  FMaxZ:= ABox.Center.z + ABox.Dimensions.z * 0.5;
  FPlane:= z3DTriangle;

  // Lower left bounds
  FPlane[0].XYZ:= D3DXVector3(FMinX, FMinY, FMinZ);
  FPlane[1].XYZ:= D3DXVector3(FMinX, FMaxY, FMinZ);
  FPlane[2].XYZ:= D3DXVector3(FMinX, FMinY, FMaxZ);
  if RayIntersectPlane(ARay, FPlane, FDistance) then
  begin
    Result:= True;
    ADistance:= Min(ADistance, FDistance);
    if not ATEvaluation then Exit;
  end;
  FPlane[0].XYZ:= D3DXVector3(FMinX, FMinY, FMinZ);
  FPlane[1].XYZ:= D3DXVector3(FMaxX, FMinY, FMinZ);
  FPlane[2].XYZ:= D3DXVector3(FMinX, FMinY, FMaxZ);
  if RayIntersectPlane(ARay, FPlane, FDistance) then
  begin
    Result:= True;
    ADistance:= Min(ADistance, FDistance);
    if not ATEvaluation then Exit;
  end;
  FPlane[0].XYZ:= D3DXVector3(FMinX, FMinY, FMinZ);
  FPlane[1].XYZ:= D3DXVector3(FMaxX, FMinY, FMinZ);
  FPlane[2].XYZ:= D3DXVector3(FMinX, FMaxY, FMinZ);
  if RayIntersectPlane(ARay, FPlane, FDistance) then
  begin
    Result:= True;
    ADistance:= Min(ADistance, FDistance);
    if not ATEvaluation then Exit;
  end;

  // Upper right bounds
  FPlane[0].XYZ:= D3DXVector3(FMaxX, FMinY, FMinZ);
  FPlane[1].XYZ:= D3DXVector3(FMaxX, FMaxY, FMinZ);
  FPlane[2].XYZ:= D3DXVector3(FMaxX, FMinY, FMaxZ);
  if RayIntersectPlane(ARay, FPlane, FDistance) then
  begin
    Result:= True;
    ADistance:= Min(ADistance, FDistance);
    if not ATEvaluation then Exit;
  end;
  FPlane[0].XYZ:= D3DXVector3(FMinX, FMaxY, FMinZ);
  FPlane[1].XYZ:= D3DXVector3(FMaxX, FMaxY, FMinZ);
  FPlane[2].XYZ:= D3DXVector3(FMinX, FMaxY, FMaxZ);
  if RayIntersectPlane(ARay, FPlane, FDistance) then
  begin
    Result:= True;
    ADistance:= Min(ADistance, FDistance);
    if not ATEvaluation then Exit;
  end;
  FPlane[0].XYZ:= D3DXVector3(FMinX, FMinY, FMaxZ);
  FPlane[1].XYZ:= D3DXVector3(FMaxX, FMinY, FMaxZ);
  FPlane[2].XYZ:= D3DXVector3(FMinX, FMaxY, FMaxZ);
  if RayIntersectPlane(ARay, FPlane, FDistance) then
  begin
    Result:= True;
    ADistance:= Min(ADistance, FDistance);
    if not ATEvaluation then Exit;
  end;
end;

function Tz3DRayTracer.RayIntersectBound(const AObject1, AObject2: Iz3DScenarioObject; const ARay: Tz3DRay;
  var ADistance: Single; const ATEvaluation: Boolean = True): Boolean;
begin
  // Perform a bound-level intersection test
  if (AObject1 as Iz3DScenarioEntity).Index = (AObject2 as Iz3DScenarioEntity).Index then
  begin
    Result:= True;
    Exit;
  end;
  if AObject2.Shape = z3dsosSphere then
  Result:= RayIntersectBoundingSphere(ARay, AObject2.BoundingSphere, ADistance) else
  Result:= RayIntersectBoundingBox(ARay, AObject2.BoundingBox, ADistance, ATEvaluation);
end;

function Tz3DRayTracer.RayCollision(const ARayObject: Iz3DScenarioObject; const ARay: Tz3DRay; var AResult: Single;
  out ACollisionObject: Iz3DScenarioObject; out ACollisionT: Single; const AVertexEvaluation: Boolean = True;
  const ATEvaluation: Boolean = True; const ATotalSamples: Integer = 1): Boolean;
var I: Integer;
    FMinDistance, FDistance: Single;
    FObject: Iz3DScenarioObject;
begin
  Result:= False;
  FObject:= nil;

  if ATEvaluation then
  begin
    FMinDistance:= ARay.Length;

    // Search for the nearest object that intersects with the ray
    for I:= 0 to z3DScenario.StaticObjectCount-1 do
    if z3DSupports(z3DScenario.StaticObjects[I], Iz3DScenarioStaticObject) and
    ((z3DScenario.StaticObjects[I].Index <> (ARayObject as Iz3DScenarioEntity).Index) or AVertexEvaluation) and
    RayIntersectBound(ARayObject, z3DScenario.StaticObjects[I] as Iz3DScenarioObject, ARay, FDistance, True) and
    (FDistance < FMinDistance) then
    begin
      FMinDistance:= FDistance;
      FObject:= z3DScenario.StaticObjects[I] as Iz3DScenarioObject;
    end;
    if FObject <> nil then
    begin
      if not AVertexEvaluation or RayIntersectVertex(ARayObject, FObject, ARay, FMinDistance) then
      begin
        AResult:= AResult - 1 / ATotalSamples;
        ACollisionObject:= FObject;
        ACollisionT:= FMinDistance;
        Result:= True;
      end;
    end;
  end else
  begin

    // Search for an intersection with any object in the world
    for I:= 0 to z3DScenario.StaticObjectCount-1 do
    if z3DSupports(z3DScenario.StaticObjects[I], Iz3DScenarioStaticObject) and
    ((z3DScenario.StaticObjects[I].Index <> (ARayObject as Iz3DScenarioEntity).Index) or AVertexEvaluation) and
    RayIntersectBound(ARayObject, z3DScenario.StaticObjects[I] as Iz3DScenarioObject, ARay, FDistance, False) and
    (not AVertexEvaluation or RayIntersectVertex(ARayObject, z3DScenario.StaticObjects[I] as Iz3DScenarioObject, ARay, FDistance)) then
    begin
      AResult:= AResult - 1 / ATotalSamples;
      ACollisionObject:= z3DScenario.StaticObjects[I] as Iz3DScenarioObject;
      ACollisionT:= FDistance;
      Result:= True;
      Exit;
    end;
  end;
end;

function Tz3DRayTracer.GetPenumbra: Boolean;
begin
  Result:= FPenumbra;
end;

function Tz3DRayTracer.GetShadows: Boolean;
begin
  Result:= FShadows;
end;

procedure Tz3DRayTracer.SetPenumbra(const Value: Boolean);
begin
  FPenumbra:= Value;
end;

procedure Tz3DRayTracer.SetShadows(const Value: Boolean);
begin
  FShadows:= Value;
end;

function Tz3DRayTracer.GetAOSamples: Integer;
begin
  Result:= FAOSamples;
end;

procedure Tz3DRayTracer.SetAOSamples(const Value: Integer);
begin
  FAOSamples:= Value;
end;

function Tz3DRayTracer.GetNormalLerp: Boolean;
begin
  Result:= FNormalLerp;
end;

function Tz3DRayTracer.GetNormalLerpExponent: Single;
begin
  Result:= FNormalLerpExponent;
end;

procedure Tz3DRayTracer.SetNormalLerp(const Value: Boolean);
begin
  FNormalLerp:= Value;
end;

procedure Tz3DRayTracer.SetNormalLerpExponent(const Value: Single);
begin
  FNormalLerpExponent:= Value;
end;

function Tz3DRayTracer.GetRadiositySamples: Integer;
begin
  Result:= FRadiositySamples;
end;

procedure Tz3DRayTracer.SetRadiositySamples(const Value: Integer);
begin
  FRadiositySamples:= Value;
end;

function Tz3DRayTracer.GetPenumbraDetailFactor: Integer;
begin
  Result:= FPenumbraDetailFactor;
end;

procedure Tz3DRayTracer.SetPenumbraDetailFactor(const Value: Integer);
begin
  FPenumbraDetailFactor:= Value;
end;

function Tz3DRayTracer.GetRadiosityBuffer0: Iz3DTexture;
begin
  Result:= FGPURadiosityBuffer[0];
end;

function Tz3DRayTracer.GetRadiosityBuffer1: Iz3DTexture;
begin
  Result:= FGPURadiosityBuffer[1];
end;

{ Tz3DLightMapPackNode }

constructor Tz3DLightMapPackNode.Create;
begin
  inherited;
  FChilds[0]:= nil;
  FChilds[1]:= nil;
  FRect:= Classes.Rect(0, 0, 0, 0);
  FID:= -1;
end;

function Tz3DLightMapPackNode.GetChilds(const I: Integer): Iz3DLightMapPackNode;
begin
  Result:= FChilds[I];
end;

function Tz3DLightMapPackNode.GetID: Integer;
begin
  Result:= FID;
end;

function Tz3DLightMapPackNode.GetRect: TRect;
begin
  Result:= FRect;
end;

procedure Tz3DLightMapPackNode.SetChilds(const I: Integer; const Value: Iz3DLightMapPackNode);
begin
  FChilds[I]:= Value;
end;

procedure Tz3DLightMapPackNode.SetID(const Value: Integer);
begin
  FID:= Value;
end;

procedure Tz3DLightMapPackNode.SetRect(const Value: TRect);
begin
  FRect:= Value;
end;

{ Tz3DLightMapOptions }

constructor Tz3DLightMapOptions.Create;
begin
  inherited;
  FBlurSteps:= 1;
  FEnableAmbient:= False;
  FEnableRadiosity:= False;
  FRadiosityBounces:= 4;
  FDetailFactor:= 12;
end;

function Tz3DLightMapOptions.GetDetailFactor: Integer;
begin
  Result:= FDetailFactor;
end;

function Tz3DLightMapOptions.GetBlurSteps: Integer;
begin
  Result:= FBlurSteps;
end;

function Tz3DLightMapOptions.GetEnableAmbient: Boolean;
begin
  Result:= FEnableAmbient;
end;

function Tz3DLightMapOptions.GetEnableRadiosity: Boolean;
begin
  Result:= FEnableRadiosity;
end;

function Tz3DLightMapOptions.GetRadiosityBounces: Integer;
begin
  Result:= FRadiosityBounces;
end;

procedure Tz3DLightMapOptions.SetBlurSteps(const Value: Integer);
begin
  FBlurSteps:= Value;
end;

procedure Tz3DLightMapOptions.SetEnableAmbient(const Value: Boolean);
begin
  FEnableAmbient:= Value;
end;

procedure Tz3DLightMapOptions.SetDetailFactor(const Value: Integer);
begin
  FDetailFactor:= Value;
end;

procedure Tz3DLightMapOptions.SetEnableRadiosity(const Value: Boolean);
begin
  FEnableRadiosity:= Value;
end;

procedure Tz3DLightMapOptions.SetRadiosityBounces(const Value: Integer);
begin
  FRadiosityBounces:= Value;
end;

{ Tz3DLightMapController }

constructor Tz3DLightMapController.Create;
begin
  inherited;
  FFolderName:= 'Lightmaps';
  FAOFileMask:= '%s_AO';
  FLightFileMask:= '%s_%d';
  FMaxTextureSize:= 2048;
end;

function Tz3DLightMapController.GetFolderName: PWideChar;
begin
  Result:= FFolderName;
end;

function Tz3DLightMapController.GetMaxTextureSize: Integer;
begin
  Result:= FMaxTextureSize;
end;

function Tz3DLightMapController.GetAOFileMask: PWideChar;
begin
  Result:= FAOFileMask;
end;

function Tz3DLightMapController.GetLightFileMask: PWideChar;
begin
  Result:= FLightFileMask;
end;

function Tz3DLightMapController.GetTextureFileName(const ATextureName: PWideChar): PWideChar;
var FPath: string;
begin
  FPath:= WideCharToString(z3DFileSystemController.RootPath)+WideCharToString(z3DCore_GetState.CurrentApp)+'\'+FFolderName;
  if FFolderName <> '' then FPath:= FPath + '\';
  StringToWideChar(Format('%s%s.%s', [FPath, WideCharToString(ATextureName), 'dds']), z3DWideBuffer, 255);
  Result:= z3DWideBuffer;
  if not DirectoryExists(ExtractFileDir(Result)) then CreateDir(ExtractFileDir(Result));
end;

procedure Tz3DLightMapController.SetFolderName(const Value: PWideChar);
begin
  FFolderName:= Value;
end;

procedure Tz3DLightMapController.SetMaxTextureSize(const Value: Integer);
begin
  FMaxTextureSize:= Value;
end;

procedure Tz3DLightMapController.SetAOFileMask(const Value: PWideChar);
begin
  FAOFileMask:= Value;
end;

procedure Tz3DLightMapController.SetLightFileMask(const Value: PWideChar);
begin
  FLightFileMask:= Value;
end;

function Tz3DLightMapController.CreateLightMap: Iz3DLightMap;
begin
  Result:= Tz3DLightMap.Create;
end;

function Tz3DLightMapController.GetLights: TIntegerArray;
begin
  Result:= FLights;
end;

function Tz3DLightMapController.GetTotalLights: Integer;
begin
  Result:= FTotalLights;
end;

procedure Tz3DLightMapController.Initialize;
var I, FTotal: Integer;
begin
  SetLength(FLights, 0);
  FTotalLights:= 0;
  for I:= 0 to z3DLightingController.LightCount - 1 do
  if z3DLightingController.Lights[I].Static then
  begin
    SetLength(FLights, Length(FLights)+1);
    FLights[Length(FLights)-1]:= I;
    Inc(FTotal);
  end;
  FTotalLights:= FTotal;
end;

end.
