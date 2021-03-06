{==============================================================================}
{== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==}
{==============================================================================}
{== Unit: z3DComponents. Zenith engine components                            ==}
{==============================================================================}

unit z3DComponents_Impl;

interface

uses
  Windows, Direct3D9, D3DX9, z3DClasses_Impl, z3DComponents_Intf, z3DMath_Intf,
  Classes, z3DClasses_Intf;

type





{==============================================================================}
{== Shader interface                                                         ==}
{==============================================================================}
{== Implementation of vertex and pixel shaders using D3DX shader interface   ==}
{==============================================================================}

  Tz3DShader = class;

  Tz3DShader = class(Tz3DLinked, Iz3DShader)
  private
    FFileName: PWideChar;
    FD3DXEffect: ID3DXEffect;
    FOnRender: Tz3DShaderRenderEvent;
    FTechnique: Tz3DHandle;
    FEnabled: Boolean;
    FOnCreate: Tz3DBaseCallbackEvent;
    FPassCount: Cardinal;
    FCurrentPass: Integer;
  protected
    function GetColor(const AParam: Tz3DHandle): Iz3DFloat4; stdcall;
    function GetColor3(const AParam: Tz3DHandle): Iz3DFloat3; stdcall;
    procedure SetColor(const AParam: Tz3DHandle; const Value: Iz3DFloat4); stdcall;
    procedure SetColor3(const AParam: Tz3DHandle; const Value: Iz3DFloat3); stdcall;
    function GetOnCreate: Tz3DBaseCallbackEvent; stdcall;
    procedure SetOnCreate(const Value: Tz3DBaseCallbackEvent); stdcall;
    function GetTexture(const AParam: Tz3DHandle): Iz3DBaseTexture; stdcall;
    procedure SetTexture(const AParam: Tz3DHandle; const Value: Iz3DBaseTexture); stdcall;
    function GetMatrix(const AParam: Tz3DHandle): Iz3DMatrix; stdcall;
    function GetFloat2(const AParam: Tz3DHandle): Iz3DFloat2; stdcall;
    function GetFloat3(const AParam: Tz3DHandle): Iz3DFloat3; stdcall;
    function GetFloat4(const AParam: Tz3DHandle): Iz3DFloat4; stdcall;
    procedure SetMatrix(const AParam: Tz3DHandle; const Value: Iz3DMatrix); stdcall;
    procedure SetFloat2(const AParam: Tz3DHandle; const Value: Iz3DFloat2); stdcall;
    procedure SetFloat3(const AParam: Tz3DHandle; const Value: Iz3DFloat3); stdcall;
    procedure SetFloat4(const AParam: Tz3DHandle; const Value: Iz3DFloat4); stdcall;
    function GetTechnique: Tz3DHandle; stdcall;
    function GetD3DXEffect: ID3DXEffect; stdcall;
    procedure SetFileName(const Value: PWideChar); virtual; stdcall;
    procedure SetTechnique(const Value: Tz3DHandle); stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    function GetParam(const AParam: Tz3DHandle): Variant; stdcall;
    procedure SetParam(const AParam: Tz3DHandle; const Value: Variant); stdcall;
    function GetEnabled: Boolean; stdcall;
    function GetFileName: PWideChar; stdcall;
    function GetOnRender: Tz3DShaderRenderEvent; stdcall;
    procedure SetOnRender(const Value: Tz3DShaderRenderEvent); stdcall;
    procedure z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller); override; stdcall;
    procedure z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller); override; stdcall;
    procedure CreateEffect; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;

    function Prepare(const AFlags: Cardinal = D3DXFX_DONOTSAVESTATE): Integer; stdcall;
    procedure BeginPass(const APassIndex: Integer = -1); stdcall;
    procedure EndPass; stdcall;
    procedure Draw(const AFlags: Cardinal = D3DXFX_DONOTSAVESTATE); stdcall;
    procedure DrawFullScreen(const AFlags: Cardinal = D3DXFX_DONOTSAVESTATE); stdcall;
    procedure Commit; stdcall;

    procedure SetPointer(const AParam: Tz3DHandle; const AValue: Pointer; const ASize: Integer); stdcall;
    function IsHandleValid(const AHandle: Tz3DHandle): Boolean; stdcall;
  public
    property D3DXEffect: ID3DXEffect read GetD3DXEffect;
    property Param[const AParam: Tz3DHandle]: Variant read GetParam write SetParam;
    property Float2[const AParam: Tz3DHandle]: Iz3DFloat2 read GetFloat2 write SetFloat2;
    property Float3[const AParam: Tz3DHandle]: Iz3DFloat3 read GetFloat3 write SetFloat3;
    property Float4[const AParam: Tz3DHandle]: Iz3DFloat4 read GetFloat4 write SetFloat4;
    property Color3[const AParam: Tz3DHandle]: Iz3DFloat3 read GetColor3 write SetColor3;
    property Color[const AParam: Tz3DHandle]: Iz3DFloat4 read GetColor write SetColor;
    property Matrix[const AParam: Tz3DHandle]: Iz3DMatrix read GetMatrix write SetMatrix;
    property Texture[const AParam: Tz3DHandle]: Iz3DBaseTexture read GetTexture write SetTexture;
    property Enabled: Boolean read GetEnabled write SetEnabled default True;
    property FileName: PWideChar read GetFileName write SetFileName;
    property Technique: Tz3DHandle read GetTechnique write SetTechnique;

    property OnCreate: Tz3DBaseCallbackEvent read GetOnCreate write SetOnCreate;
    property OnRender: Tz3DShaderRenderEvent read GetOnRender write SetOnRender;
  end;






{==============================================================================}
{== Base texture interface                                                   ==}
{==============================================================================}
{== Common properties and methods from all kinds of textures                 ==}
{==============================================================================}

  Tz3DBaseTexture = class(Tz3DLinked, Iz3DBaseTexture)
  private
    FEnabled: Boolean;
    FSurface0: Iz3DSurface;
    FD3DBaseTexture: IDirect3DBaseTexture9;
    FPool: TD3DPool;
    FFormat: TD3DFormat;
    FUsage: DWORD;
    FLevelCount: Integer;
    FFileName: PWideChar;
    FSource: Tz3DTextureSource;
    FAutoGenerateMipMaps: Boolean;
    FSamplerState: Tz3DSamplerState;
    FOnCreate: Tz3DBaseCallbackEvent;
  protected
    function GetSamplerState: Pz3DSamplerState; stdcall;
    function GetOnCreate: Tz3DBaseCallbackEvent; stdcall;
    procedure SetOnCreate(const Value: Tz3DBaseCallbackEvent); stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    function GetAutoGenerateMipMaps: Boolean; stdcall;
    procedure SetAutoGenerateMipMaps(const Value: Boolean); stdcall;
    function GetFileName: PWideChar; stdcall;
    function GetSource: Tz3DTextureSource; stdcall;
    procedure SetFileName(const Value: PWideChar); virtual; stdcall;
    procedure SetSource(const Value: Tz3DTextureSource); stdcall;
    function GetUsage: DWord; stdcall;
    procedure SetUsage(const Value: DWord); stdcall;
    function GetPool: TD3DPool; stdcall;
    procedure SetPool(const Value: TD3DPool); stdcall;
    function GetLevelCount: Integer; stdcall;
    procedure SetLevelCount(const Value: Integer); stdcall;
    function GetD3DBaseTexture: IDirect3DBaseTexture9; stdcall;
    procedure SetD3DBaseTexture(const Value: IDirect3DBaseTexture9); stdcall;
    function GetFormat: TD3DFormat; stdcall;
    procedure SetFormat(const Value: TD3DFormat); stdcall;
    procedure z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller); override; stdcall;
    procedure z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller); override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    function From(const ATexture: IDirect3DBaseTexture9): Iz3DBaseTexture; stdcall;
    procedure GenerateMipMaps; stdcall;
    procedure AttachToSampler(const AIndex: Integer; const ASetAddress: Boolean = False;
      const ASetFilter: Boolean = False); stdcall;
    procedure CreateD3DTexture; virtual; stdcall;
  public
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property D3DBaseTexture: IDirect3DBaseTexture9 read GetD3DBaseTexture write SetD3DBaseTexture;
    property LevelCount: Integer read GetLevelCount write SetLevelCount;
    property Pool: TD3DPool read GetPool write SetPool;
    property Source: Tz3DTextureSource read GetSource write SetSource;
    property FileName: PWideChar read GetFileName write SetFileName;
    property Format: TD3DFormat read GetFormat write SetFormat;
    property AutoGenerateMipMaps: Boolean read GetAutoGenerateMipMaps write SetAutoGenerateMipMaps;
    property Usage: DWord read GetUsage write SetUsage;
    property SamplerState: Pz3DSamplerState read GetSamplerState;
    property OnCreate: Tz3DBaseCallbackEvent read GetOnCreate write SetOnCreate;
  end;






{==============================================================================}
{== Texture interface                                                        ==}
{==============================================================================}
{== Basic 2D texture implementation                                          ==}
{==============================================================================}

  Tz3DTexture = class(Tz3DBaseTexture, Iz3DTexture)
  private
    FD3DTexture: IDirect3DTexture9;
    FWidth: Integer;
    FHeight: Integer;
    FRect: TD3DLockedRect;
  protected
    procedure SetD3DTexture(const Value: IDirect3DTexture9); stdcall;
    function GetLockedRect: TD3DLockedRect; stdcall;
    function GetD3DTexture: IDirect3DTexture9; stdcall;
    function GetHeight: Integer; stdcall;
    function GetWidth: Integer; stdcall;
    procedure SetHeight(const Value: Integer); stdcall;
    procedure SetWidth(const Value: Integer); stdcall;
    procedure z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller); override; stdcall;
  public
    function GetSurface: Iz3DSurface; stdcall;
    procedure CreateD3DTexture; override; stdcall;
    procedure Fill(const AColor: Iz3DFloat4); stdcall;
    procedure SetParams(const AWidth: Integer = -1; const AHeight: Integer = -1; const ALevels: Integer = -1;
      const AFormat: TD3DFormat = D3DFMT_UNKNOWN; const APool: TD3DPool = D3DPOOL_MANAGED); stdcall;
    procedure BeginDraw(const ALevel: Integer = 0; const AFlags: Cardinal = 0); stdcall;
    procedure EndDraw(const ALevel: Integer = 0); stdcall;
    function GetPixel(const AX, AY: Integer): Iz3DFloat4; stdcall;
    procedure SetPixel(const AX, AY: Integer; const AColor: Iz3DFloat3); overload; stdcall;
    procedure SetPixel(const AX, AY: Integer; const AColor: Iz3DFloat4); overload; stdcall;
  public
    property LockedRect: TD3DLockedRect read GetLockedRect;
    property D3DTexture: IDirect3DTexture9 read GetD3DTexture write SetD3DTexture;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
  end;





{==============================================================================}
{== Render texture interface                                                 ==}
{==============================================================================}
{== 2D texture that can be used as a render target                           ==}
{==============================================================================}

  Tz3DRenderTexture = class(Tz3DTexture, Iz3DRenderTexture)
  private
    FAutoParams: Boolean;
    FAutoWidthFactor: Single;
    FAutoHeightFactor: Single;
    FAutoFormat: Tz3DSurfaceAutoFormat;
  protected
    function GetAutoFormat: Tz3DSurfaceAutoFormat; stdcall;
    procedure SetAutoFormat(const Value: Tz3DSurfaceAutoFormat); stdcall;
    function GetAutoParams: Boolean; stdcall;
    function GetAutoHeightFactor: Single; stdcall;
    function GetAutoWidthFactor: Single; stdcall;
    procedure SetAutoParams(const Value: Boolean); stdcall;
    procedure SetAutoHeightFactor(const Value: Single); stdcall;
    procedure SetAutoWidthFactor(const Value: Single); stdcall;
  public
    procedure SetRenderTarget(const AIndex: Integer = 0; const ASave: Boolean = False); stdcall;
    procedure RestoreRenderTarget; stdcall;
    procedure z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller); override; stdcall;
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property AutoParams: Boolean read GetAutoParams write SetAutoParams;
    property AutoWidthFactor: Single read GetAutoWidthFactor write SetAutoWidthFactor;
    property AutoHeightFactor: Single read GetAutoHeightFactor write SetAutoHeightFactor;
    property AutoFormat: Tz3DSurfaceAutoFormat read GetAutoFormat write SetAutoFormat;
  end;






{==============================================================================}
{== Cube texture interface                                                   ==}
{==============================================================================}
{== Basic cube texture implementation                                        ==}
{==============================================================================}

  Tz3DCubeTexture = class(Tz3DBaseTexture, Iz3DCubeTexture)
  private
    FD3DCubeTexture: IDirect3DCubeTexture9;
    FSize: Integer;
    FSurfaces: array[TD3DCubemapFaces] of IDirect3DSurface9;
    FPReviousRT: IDirect3DSurface9;
  protected
    function GetD3DCubeTexture: IDirect3DCubeTexture9; stdcall;
    function GetSize: Integer; stdcall;
    procedure SetSize(const Value: Integer); stdcall;
    procedure z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller); override; stdcall;
  public
    procedure CreateD3DTexture; override; stdcall;
    procedure SetCubeParams(const ASize: Integer = -1; const ALevels: Integer = -1;
      const AFormat: TD3DFormat = D3DFMT_UNKNOWN; const APool: TD3DPool = D3DPOOL_MANAGED); stdcall;
    procedure Fill(const AColor: Iz3DFloat4); virtual; stdcall;
    function GetSurface(const AFace: TD3DCubemapFaces): Iz3DSurface; reintroduce; stdcall;
  public
    property D3DCubeTexture: IDirect3DCubeTexture9 read GetD3DCubeTexture;
    property Size: Integer read GetSize write SetSize;
  end;





{==============================================================================}
{== Cube render texture interface                                            ==}
{==============================================================================}
{== Cube texture that can be used as a render target                         ==}
{==============================================================================}

  Tz3DCubeRenderTexture = class(Tz3DCubeTexture, Iz3DCubeRenderTexture)
  protected
    procedure z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller); override; stdcall;
  public
    procedure SetRenderTarget(const AFace: TD3DCubemapFaces = D3DCUBEMAP_FACE_POSITIVE_X; const ASave: Boolean = False); stdcall;
    procedure RestoreRenderTarget; stdcall;
    constructor Create(const AOwner: Iz3DBase = nil); override;
  end;






{==============================================================================}
{== Material texture interface                                               ==}
{==============================================================================}
{== Extension of the texture interface that stores or generates a normal map ==}
{==============================================================================}

  Tz3DMaterialTexture = class(Tz3DTexture, Iz3DMaterialTexture)
  private
    FNormalMapFactor: Single;
    FNormalMapTexture: Iz3DTexture;
    FAutoGenerateNormalMap: Boolean;
  protected
    function GetAutoGenerateNormalMap: Boolean; stdcall;
    procedure SetAutoGenerateNormalMap(const Value: Boolean); stdcall;
    function GetEnableNormalMap: Boolean; stdcall;
    function GetNormalMapFactor: Single; stdcall;
    function GetNormalMapTexture: Iz3DTexture; stdcall;
    procedure SetEnableNormalMap(const Value: Boolean); stdcall;
    procedure SetNormalMapFactor(const Value: Single); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    procedure CreateD3DTexture; override; stdcall;
    procedure GenerateNormalMap; stdcall;
    function GetNormalMapFileName: PWideChar;
  public
    property NormalMapTexture: Iz3DTexture read GetNormalMapTexture;
    property EnableNormalMap: Boolean read GetEnableNormalMap write SetEnableNormalMap;
    property AutoGenerateNormalMap: Boolean read GetAutoGenerateNormalMap write SetAutoGenerateNormalMap;
    property NormalMapFactor: Single read GetNormalMapFactor write SetNormalMapFactor;
  end;






{==============================================================================}
{== Surface interface                                                        ==}
{==============================================================================}
{== Implementation of all kinds of surfaces                                  ==}
{==============================================================================}

  Tz3DSurface = class(Tz3DLinked, Iz3DSurface)
  private
    FD3DSurface: IDirect3DSurface9;
    FPreviousRT: IDirect3DSurface9;
    FWidth: Integer;
    FHeight: Integer;
    FRect: TD3DLockedRect;
  protected
    function GetHeight: Integer; stdcall;
    function GetWidth: Integer; stdcall;
    function GetD3DSurface: IDirect3DSurface9; stdcall;
    procedure SetD3DSurface(const Value: IDirect3DSurface9); stdcall;
    procedure z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller); override; stdcall;
  public
    class function New: Iz3DSurface;
    class function NewFrom(const ASurface: IDirect3DSurface9): Iz3DSurface;
    function From(const ASurface: IDirect3DSurface9): Iz3DSurface; overload; stdcall;
    function From(const ASurface: Iz3DSurface): Iz3DSurface; overload; stdcall;
    function From(const ATexture: Iz3DTexture): Iz3DSurface; overload; stdcall;
    procedure SetRenderTarget(const AIndex: Integer = 0; const ASave: Boolean = False); stdcall;
    procedure RestoreRenderTarget; stdcall;
    procedure BeginDraw(const AFlags: Cardinal = 0); stdcall;
    procedure EndDraw; stdcall;
    function GetPixel(const AX, AY: Integer): Iz3DFloat4; stdcall;
    procedure SetPixel(const AX, AY: Integer; const AColor: Iz3DFloat3); overload; stdcall;
    procedure SetPixel(const AX, AY: Integer; const AColor: Iz3DFloat4); overload; stdcall;
    constructor Create(const AOwner: Iz3DBase = nil); virtual;
  public
    property D3DSurface: IDirect3DSurface9 read GetD3DSurface write SetD3DSurface;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
  end;






{==============================================================================}
{== Depth/stencil buffer interface                                           ==}
{==============================================================================}
{== Implementation of depth stencil surfaces for rendering                   ==}
{==============================================================================}

  Tz3DDepthBuffer = class(Tz3DSurface, Iz3DDepthBuffer)
  private
    FDiscard: Boolean;
    FMSQuality: DWORD;
    FMultiSample: TD3DMultiSampleType;
    FFormat: TD3DFormat;
    FWidth: Integer;
    FHeight: Integer;
    FOnCreate: Tz3DBaseCallbackEvent;
  protected
    function GetOnCreate: Tz3DBaseCallbackEvent; stdcall;
    procedure SetOnCreate(const Value: Tz3DBaseCallbackEvent); stdcall;
    function GetDiscard: Boolean; stdcall;
    function GetMSQuality: DWORD; stdcall;
    function GetMultiSample: TD3DMultiSampleType; stdcall;
    procedure SetDiscard(const Value: Boolean); stdcall;
    procedure SetMSQuality(const Value: DWORD); stdcall;
    procedure SetMultiSample(const Value: TD3DMultiSampleType); stdcall;
    function GetFormat: TD3DFormat; stdcall;
    function GetHeight: Integer; stdcall;
    function GetWidth: Integer; stdcall;
    procedure SetFormat(const Value: TD3DFormat); stdcall;
    procedure SetHeight(const Value: Integer); stdcall;
    procedure SetWidth(const Value: Integer); stdcall;
  public
    procedure CreateD3DSurface; stdcall;
    procedure SetParams(const AWidth: Integer = -1; const AHeight: Integer = -1; const AFormat: TD3DFormat = D3DFMT_UNKNOWN;
    const AMultiSample: TD3DMultiSampleType = D3DMULTISAMPLE_NONE; const AMSQuality: DWORD = 0; const ADiscard: Boolean = True); stdcall;
  public
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Format: TD3DFormat read GetFormat write SetFormat;
    property MultiSample: TD3DMultiSampleType read GetMultiSample write SetMultiSample;
    property MSQuality: DWORD read GetMSQuality write SetMSQuality;
    property Discard: Boolean read GetDiscard write SetDiscard;

    property OnCreate: Tz3DBaseCallbackEvent read GetOnCreate write SetOnCreate;
  end;






{==============================================================================}
{== Vertex format interface                                                  ==}
{==============================================================================}
{== Stores a specific vertex format to be used with shaders                  ==}
{==============================================================================}

  Tz3DVertexElement = class(Tz3DBase, Iz3DVertexElement)
  private
    FFormat: Tz3DVertexElementFormat;
    FMethod: Tz3DVertexElementMethod;
    FStream: Integer;
    FUsage: Tz3DVertexElementUsage;
    FUsageIndex: Integer;
    FOwner: Iz3DVertexFormat;
  protected
    function GetFormat: Tz3DVertexElementFormat; stdcall;
    function GetMethod: Tz3DVertexElementMethod; stdcall;
    function GetStream: Integer; stdcall;
    function GetUsage: Tz3DVertexElementUsage; stdcall;
    function GetUsageIndex: Integer; stdcall;
    procedure SetFormat(const Value: Tz3DVertexElementFormat); stdcall;
    procedure SetMethod(const Value: Tz3DVertexElementMethod); stdcall;
    procedure SetStream(const Value: Integer); stdcall;
    procedure SetUsage(const Value: Tz3DVertexElementUsage); stdcall;
    procedure SetUsageIndex(const Value: Integer); stdcall;
  public
    constructor Create(const AOwner: Iz3DVertexFormat);
  public
    property Stream: Integer read GetStream write SetStream;
    property Format: Tz3DVertexElementFormat read GetFormat write SetFormat;
    property Method: Tz3DVertexElementMethod read GetMethod write SetMethod;
    property Usage: Tz3DVertexElementUsage read GetUsage write SetUsage;
    property UsageIndex: Integer read GetUsageIndex write SetUsageIndex;
  end;

  Tz3DVertexFormat = class(Tz3DLinked, Iz3DVertexFormat)
  private
    FElements: IInterfaceList;
    FD3DFormat: IDirect3DVertexDeclaration9;
    FUpdating: Boolean;
    FOnChange: Tz3DBaseObjectEvent;
    FVertexSize: Integer;
    FOnCreate: Tz3DBaseCallbackEvent;
  protected
    function GetOnCreate: Tz3DBaseCallbackEvent; stdcall;
    procedure SetOnCreate(const Value: Tz3DBaseCallbackEvent); stdcall;
    function GetOnChange: Tz3DBaseObjectEvent; stdcall;
    procedure SetOnChange(const Value: Tz3DBaseObjectEvent); stdcall;
    function GetVertexSize: Integer; stdcall;
    function GetUpdating: Boolean; stdcall;
    function GetElement(const AIndex: Integer): Iz3DVertexElement; stdcall;
    function GetElementCount: Integer; stdcall;
    procedure SetElement(const AIndex: Integer; const Value: Iz3DVertexElement); stdcall;
    procedure z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller); override; stdcall;
    procedure z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller); override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil);
    function CreateElement: Iz3DVertexElement; stdcall;
    function AddElement(const AStream: Integer = 0; const AFormat: Tz3DVertexElementFormat = z3dvefFloat4;
      const AMethod: Tz3DVertexElementMethod = z3dvemDefault; const AUsage: Tz3DVertexElementUsage = z3dveuPosition;
      const AUsageIndex: Integer = 0): Iz3DVertexElement; stdcall;
    procedure RemoveElement(const AElement: Iz3DVertexElement); stdcall;
    procedure ClearElements; stdcall;
    procedure Apply; stdcall;
    procedure CreateD3DFormat(const AForce: Boolean = False); stdcall;
    procedure BeginUpdate; stdcall;
    procedure EndUpdate; stdcall;
    function GetDeclaration: PD3DVertexElement9; stdcall;
    function GetD3DDeclaration: IDirect3DVertexDeclaration9; stdcall;
  public
    property Elements[const AIndex: Integer]: Iz3DVertexElement read GetElement write SetElement;
    property ElementCount: Integer read GetElementCount;
    property Updating: Boolean read GetUpdating;
    property VertexSize: Integer read GetVertexSize;

    property OnCreate: Tz3DBaseCallbackEvent read GetOnCreate write SetOnCreate;
    property OnChange: Tz3DBaseObjectEvent read GetOnChange write SetOnChange;
  end;






{==============================================================================}
{== Vertex buffer interface                                                  ==}
{==============================================================================}
{== Manages an array of vertices with a specific format                      ==}
{==============================================================================}

  Tz3DVertexBuffer = class(Tz3DLinked, Iz3DVertexBuffer)
  private
    FD3DBuffer: IDirect3DVertexBuffer9;
    FUpdating: Boolean;
    FFormat: Iz3DVertexFormat;
    FPool: TD3DPool;
    FUsage: DWord;
    FVertexCount: Integer;
    FPrimitiveKind: Tz3DPrimitiveKind;
    FPrimitiveCount: Integer;
    FOnCreate: Tz3DBaseCallbackEvent;
  protected
    function GetD3DBuffer: IDirect3DVertexBuffer9; stdcall;
    function GetOnCreate: Tz3DBaseCallbackEvent; stdcall;
    procedure SetOnCreate(const Value: Tz3DBaseCallbackEvent); stdcall;
    function GetPrimitiveCount: Integer; stdcall;
    function GetPrimitiveKind: Tz3DPrimitiveKind; stdcall;
    procedure SetPrimitiveKind(const Value: Tz3DPrimitiveKind); stdcall;
    function GetUpdating: Boolean; stdcall;
    function GetFormat: Iz3DVertexFormat; stdcall;
    function GetPool: TD3DPool; stdcall;
    function GetUsage: DWord; stdcall;
    function GetVertexCount: Integer; stdcall;
    procedure SetPool(const Value: TD3DPool); stdcall;
    procedure SetUsage(const Value: DWord); stdcall;
    procedure SetVertexCount(const Value: Integer); stdcall;
    procedure CreateD3DBuffer(const AForce: Boolean = False); stdcall;
    procedure z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller); override; stdcall;
    procedure z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller); override; stdcall;
    procedure FormatChanged(const ASender: Iz3DBase); stdcall;
    procedure SetScenarioLevel(const Value: Boolean); override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil);
    procedure BeginUpdate; stdcall;
    procedure EndUpdate; stdcall;
    function Lock(const AFlags: DWORD = 0): Pointer; stdcall;
    procedure Unlock; stdcall;
    procedure SetParams(const AVertexCount: Integer; const AUsage: DWord = D3DUSAGE_WRITEONLY;
      const APool: TD3DPool = D3DPOOL_MANAGED); stdcall;
    procedure Prepare; stdcall;
    procedure Render(const AStart: Integer = 0; ACount: Integer = -1); overload; stdcall;
    procedure Render(const AShader: Iz3DShader; const AStart: Integer = 0; ACount: Integer = -1); overload; stdcall;
  public
    property Format: Iz3DVertexFormat read GetFormat;
    property Usage: DWord read GetUsage write SetUsage;
    property Pool: TD3DPool read GetPool write SetPool;
    property VertexCount: Integer read GetVertexCount write SetVertexCount;
    property PrimitiveCount: Integer read GetPrimitiveCount;
    property Updating: Boolean read GetUpdating;
    property PrimitiveKind: Tz3DPrimitiveKind read GetPrimitiveKind write SetPrimitiveKind;
    property D3DBuffer: IDirect3DVertexBuffer9 read GetD3DBuffer;

    property OnCreate: Tz3DBaseCallbackEvent read GetOnCreate write SetOnCreate;
  end;

// Controller creation

function z3DCreateShader: Iz3DShader; stdcall;

function z3DCreateTexture: Iz3DTexture; stdcall;
function z3DCreateRenderTexture: Iz3DRenderTexture; stdcall;
function z3DCreateCubeTexture: Iz3DCubeTexture; stdcall;
function z3DCreateCubeRenderTexture: Iz3DCubeRenderTexture; stdcall;
function z3DCreateMaterialTexture: Iz3DMaterialTexture; stdcall;

function z3DCreateSurface: Iz3DSurface; stdcall;
function z3DCreateDepthBuffer: Iz3DDepthBuffer; stdcall;

function z3DCreateVertexFormat: Iz3DVertexFormat; stdcall;
function z3DCreateVertexBuffer: Iz3DVertexBuffer; stdcall;

implementation

uses z3DEngine_Intf, z3DEngine_Func, z3DFileSystem_Intf, z3DFileSystem_Func,
  z3DCore_Func, z3DCore_Intf, z3DMath_Func, SysUtils, Variants, Math,
  z3DScenario_Func;

const
  FMipMapUsage: array[Boolean] of Cardinal = (0, D3DUSAGE_AUTOGENMIPMAP);
  Tz3DVertexElementFormatOffsets: array[Tz3DVertexElementFormat] of Integer = (4, 8, 12,
    16, 16, 0, 4, 8, 0, 0, 4, 8, 0, 0, 32, 64, 0);

function z3DCreateShader: Iz3DShader; stdcall;
begin
  Result:= Tz3DShader.Create;
end;

function z3DCreateTexture: Iz3DTexture; stdcall;
begin
  Result:= Tz3DTexture.Create;
end;

function z3DCreateRenderTexture: Iz3DRenderTexture; stdcall;
begin
  Result:= Tz3DRenderTexture.Create;
end;

function z3DCreateCubeTexture: Iz3DCubeTexture; stdcall;
begin
  Result:= Tz3DCubeTexture.Create;
end;

function z3DCreateCubeRenderTexture: Iz3DCubeRenderTexture; stdcall;
begin
  Result:= Tz3DCubeRenderTexture.Create;
end;

function z3DCreateMaterialTexture: Iz3DMaterialTexture; stdcall;
begin
  Result:= Tz3DMaterialTexture.Create;
end;

function z3DCreateSurface: Iz3DSurface; stdcall;
begin
  Result:= Tz3DSurface.Create;
end;

function z3DCreateDepthBuffer: Iz3DDepthBuffer; stdcall;
begin
  Result:= Tz3DDepthBuffer.Create;
end;

function z3DCreateVertexFormat: Iz3DVertexFormat; stdcall;
begin
  Result:= Tz3DVertexFormat.Create;
end;

function z3DCreateVertexBuffer: Iz3DVertexBuffer; stdcall;
begin
  Result:= Tz3DVertexBuffer.Create;
end;


{ Tz3DShader }

constructor Tz3DShader.Create(const AOwner: Iz3DBase = nil);
begin
  inherited;

  // Link this object to the desired events generated by the z3D Engine
  Notifications:= [z3dlnDevice];
  ScenarioLevel:= True;
  ScenarioStage:= z3dssCreatingScenario;

  GetMem(FFileName, 255);
  ZeroMemory(FFileName, 255);
  FEnabled:= True;
end;

destructor Tz3DShader.Destroy;
begin
  z3DFreeWideChar(FFileName);
  inherited;
end;

function Tz3DShader.IsHandleValid(const AHandle: Tz3DHandle): Boolean;
begin
  Result:= AHandle <> '';
end;

procedure Tz3DShader.CreateEffect;
var FErrors: ID3DXBuffer;
begin
  if z3DTraceCondition(not FileExists(FFileName), PWideChar(WideString('Iz3DShader.CreateEffect: Invalid file or resource name: '+FFileName)), z3dtkWarning) then Exit;
  if z3DTraceCondition(z3DCore_GetD3DDevice = nil, PWideChar(WideString('Iz3DShader.CreateEffect: Direct3D device is NULL')), z3dtkWarning) then Exit;
  D3DXCreateBuffer(255, FErrors);
  if FAILED(D3DXCreateEffectFromFileW(z3DCore_GetD3DDevice, FFileName, nil, nil,
  D3DXFX_NOT_CLONEABLE or D3DXSHADER_ENABLE_BACKWARDS_COMPATIBILITY, nil, FD3DXEffect, @FErrors)) then
  begin
    z3DTrace(PWideChar(WideString('Iz3DShader.CreateEffect: Could not create Shader. Output messages: '+StrPas(FErrors.GetBufferPointer))), z3dtkWarning);
    Exit;
  end;
  if Assigned(FOnCreate) then FOnCreate(Self);
  FD3DXEffect.SetTechnique(TD3DXHandle(FTechnique));
end;

procedure Tz3DShader.Draw(const AFlags: Cardinal = D3DXFX_DONOTSAVESTATE);
var I, FCount: LongWord;
begin
  if z3DTraceCondition(FD3DXEffect = nil, 'Iz3DShader.Render failed: D3DX Effect is NULL', z3DtkWarning) then Exit;
  if z3DTraceCondition(not Assigned(FOnRender), 'Iz3DShader.Render failed (event OnRender is NULL)', z3DtkWarning) then Exit;
  for I:= 0 to Prepare(AFlags) - 1 do
  begin
    BeginPass;
    FOnRender(Self, I, FCount);
    Commit;
    EndPass;
  end;
end;

procedure Tz3DShader.SetFileName(const Value: PWideChar);
begin
  StringToWideChar(Value, FFileName, 255);
end;

procedure Tz3DShader.SetTechnique(const Value: Tz3DHandle);
begin
  FTechnique:= Value;
  if Assigned(FD3DXEffect) then
  begin
    if FAILED(FD3DXEffect.SetTechnique(FTechnique)) then
    z3DTrace(PWideChar(WideString('Iz3DShader.SetTechnique: D3DXEffect.SetTechnique failed')), z3dtkWarning);
  end;
end;

procedure Tz3DShader.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    if z3DEngine.Device.Created then
    begin
      if ScenarioLevel then
      z3DDestroyScenarioObjects(z3ddocStopScenario) else
      begin
        z3DDestroyScenarioObjects(z3ddocLostDevice);
        z3DDestroyScenarioObjects(z3ddocDestroyDevice);
      end;
    end;
    FEnabled:= Value;
    if z3DEngine.Device.Created then
    begin
      if ScenarioLevel then
      z3DCreateScenarioObjects(z3dcocStartScenario) else
      begin
        z3DCreateScenarioObjects(z3dcocCreateDevice);
        z3DCreateScenarioObjects(z3dcocResetDevice);
      end;
    end;
  end;
end;

function Tz3DShader.GetParam(const AParam: Tz3DHandle): Variant;
begin
  if z3DTraceCondition(FD3DXEffect = nil, PWideChar(WideString('Iz3DShader.GetParam failed: D3DX Effect is NULL (param '+AParam+')')), z3DtkWarning) then Result:= NULL else
  FD3DXEffect.GetValue(TD3DXHandle(AParam), @Result, SizeOf(@Result));
end;

procedure Tz3DShader.SetParam(const AParam: Tz3DHandle; const Value: Variant);
var FResult: HRESULT;
begin
  if z3DTraceCondition(FD3DXEffect = nil, PWideChar(WideString('Iz3DShader.SetParam failed: D3DX Effect is NULL (param '+AParam+')')), z3DtkWarning) then Exit;
  case VarType(Value) of
    varInteger, varWord, varByte, varLongWord: FResult:= FD3DXEffect.SetInt(TD3DXHandle(AParam), Value);
    varSingle, varDouble, varCurrency: FResult:= FD3DXEffect.SetFloat(TD3DXHandle(AParam), Value);
    varBoolean: FResult:= FD3DXEffect.SetBool(TD3DXHandle(AParam), Value);
    else
    begin
      z3DTrace(PWideChar(WideString('Iz3DShader.SetParam failed (param '+AParam+' is of an unknown type)')), z3DtkWarning);
      Exit;
    end;
  end;
  if FAILED(FResult) then z3DTrace(PWideChar(WideString('Iz3DShader.SetParams: D3DXEffect.Set* failed (param '+AParam+')')), z3DtkWarning);
end;

function Tz3DShader.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

function Tz3DShader.GetFileName: PWideChar;
begin
  Result:= FFileName;
end;

function Tz3DShader.GetOnRender: Tz3DShaderRenderEvent;
begin
  Result:= FOnRender;
end;

procedure Tz3DShader.SetOnRender(const Value: Tz3DShaderRenderEvent);
begin
  FOnRender:= Value;
end;

function Tz3DShader.GetD3DXEffect: ID3DXEffect;
begin
  Result:= FD3DXEffect;
end;

function Tz3DShader.GetTechnique: Tz3DHandle;
begin
  Result:= FTechnique;
end;

function Tz3DShader.GetMatrix(const AParam: Tz3DHandle): Iz3DMatrix;
var F: TD3DXMatrix;
begin
  if z3DTraceCondition(FD3DXEffect = nil, 'Iz3DShader.GetMatrix failed: D3DX Effect is NULL', z3DtkWarning) then Result:= nil else
  begin
    FD3DXEffect.GetMatrix(TD3DXHandle(AParam), F);
    Result:= z3DMatrix.From(F);
  end;
end;

function Tz3DShader.GetFloat2(const AParam: Tz3DHandle): Iz3DFloat2;
var F: TD3DXVector4;
begin
  if z3DTraceCondition(FD3DXEffect = nil, 'Iz3DShader.GetFloat2 failed: D3DX Effect is NULL', z3DtkWarning) then Result:= nil else
  begin
    FD3DXEffect.GetVector(TD3DXHandle(AParam), F);
    Result:= z3DFloat2(F.X, F.Y);
  end;
end;

function Tz3DShader.GetFloat3(const AParam: Tz3DHandle): Iz3DFloat3;
var F: TD3DXVector4;
begin
  if z3DTraceCondition(FD3DXEffect = nil, 'Iz3DShader.GetFloat3 failed: D3DX Effect is NULL', z3DtkWarning) then Result:= nil else
  begin
    FD3DXEffect.GetVector(TD3DXHandle(AParam), F);
    Result:= z3DFloat3(F.X, F.Y, F.Z);
  end;
end;

function Tz3DShader.GetFloat4(const AParam: Tz3DHandle): Iz3DFloat4;
var F: TD3DXVector4;
begin
  if z3DTraceCondition(FD3DXEffect = nil, 'Iz3DShader.GetFloat4 failed: D3DX Effect is NULL', z3DtkWarning) then Result:= nil else
  begin
    FD3DXEffect.GetVector(TD3DXHandle(AParam), F);
    Result:= z3DFloat4(F.X, F.Y, F.Z, F.W);
  end;
end;

procedure Tz3DShader.SetMatrix(const AParam: Tz3DHandle; const Value: Iz3DMatrix);
begin
  if not z3DTraceCondition(FD3DXEffect = nil, PWideChar(WideString('Iz3DShader.SetMatrix failed: D3DX Effect is NULL (param '+AParam+')')), z3DtkWarning) then
  if FAILED(FD3DXEffect.SetMatrix(TD3DXHandle(AParam), Value.D3DMatrix)) then
  z3DTrace(PWideChar(WideString('Iz3DShader.SetMatrix: D3DXEffect.SetMatrix failed (param '+AParam+')')), z3DtkWarning);
end;

procedure Tz3DShader.SetFloat2(const AParam: Tz3DHandle; const Value: Iz3DFloat2);
begin
  if not z3DTraceCondition(FD3DXEffect = nil, PWideChar(WideString('Iz3DShader.SetFloat2 failed: D3DX Effect is NULL (param '+AParam+')')), z3DtkWarning) then
  if FAILED(FD3DXEffect.SetVector(TD3DXHandle(AParam), z3DFloat4(Value.X, Value.Y).XYZW)) then
  z3DTrace(PWideChar(WideString('Iz3DShader.SetFloat2: D3DXEffect.SetVector failed (param '+AParam+')')), z3DtkWarning);
end;

procedure Tz3DShader.SetFloat3(const AParam: Tz3DHandle; const Value: Iz3DFloat3);
begin
  if not z3DTraceCondition(FD3DXEffect = nil, PWideChar(WideString('Iz3DShader.SetFloat3 failed: D3DX Effect is NULL (param '+AParam+')')), z3DtkWarning) then
  if FAILED(FD3DXEffect.SetVector(TD3DXHandle(AParam), z3DFloat4(Value.X, Value.Y, Value.Z).XYZW)) then
  z3DTrace(PWideChar(WideString('Iz3DShader.SetFloat3: D3DXEffect.SetVector failed (param '+AParam+')')), z3DtkWarning);
end;

procedure Tz3DShader.SetFloat4(const AParam: Tz3DHandle; const Value: Iz3DFloat4);
begin
  if not z3DTraceCondition(FD3DXEffect = nil, PWideChar(WideString('Iz3DShader.SetFloat4 failed: D3DX Effect is NULL (param '+AParam+')')), z3DtkWarning) then
  if FAILED(FD3DXEffect.SetVector(TD3DXHandle(AParam), Value.XYZW)) then
  z3DTrace(PWideChar(WideString('Iz3DShader.SetFloat4: D3DXEffect.SetVector failed (param '+AParam+')')), z3DtkWarning);
end;

function Tz3DShader.GetTexture(const AParam: Tz3DHandle): Iz3DBaseTexture;
var F: IDirect3DBaseTexture9;
begin
  if z3DTraceCondition(FD3DXEffect = nil, 'Iz3DShader.GetTexture failed: D3DX Effect is NULL', z3DtkWarning) then Result:= nil else
  begin
    FD3DXEffect.GetTexture(TD3DXHandle(AParam), F);
    Result:= Tz3DBaseTexture.Create;
    Result.D3DBaseTexture:= F;
  end;
end;

procedure Tz3DShader.SetTexture(const AParam: Tz3DHandle; const Value: Iz3DBaseTexture);
begin
  if z3DTraceCondition(Value = nil, PWideChar(WideString('Iz3DShader.SetTexture failed: Texture is NULL (param '+AParam+')')), z3DtkWarning) then Exit;
  if z3DTraceCondition(Value.D3DBaseTexture = nil, PWideChar(WideString('Iz3DShader.SetTexture failed: Texture.D3DBaseTexture is NULL (param '+AParam+')')), z3DtkWarning) then Exit;
  if z3DTraceCondition(FD3DXEffect = nil, PWideChar(WideString('Iz3DShader.SetTexture failed: D3DX Effect is NULL (param '+AParam+')')), z3DtkWarning) then Exit;
  if FAILED(FD3DXEffect.SetTexture(TD3DXHandle(AParam), Value.D3DBaseTexture)) then
  z3DTrace(PWideChar(WideString('Iz3DShader.SetTexture: D3DXEffect.SetTexture failed (param '+AParam+')')), z3DtkWarning);
end;

procedure Tz3DShader.SetPointer(const AParam: Tz3DHandle; const AValue: Pointer; const ASize: Integer);
begin
  if not z3DTraceCondition(FD3DXEffect = nil, PWideChar(WideString('Iz3DShader.SetPointer failed: D3DX Effect is NULL (param '+AParam+')')), z3DtkWarning) then
  if FAILED(FD3DXEffect.SetValue(TD3DXHandle(AParam), AValue, ASize)) then
  z3DTrace(PWideChar(WideString('Iz3DShader.SetPointer: D3DXEffect.SetValue failed (param '+AParam+')')), z3DtkWarning);
end;

function Tz3DShader.GetOnCreate: Tz3DBaseCallbackEvent;
begin
  Result:= FOnCreate;
end;

procedure Tz3DShader.SetOnCreate(const Value: Tz3DBaseCallbackEvent);
begin
  FOnCreate:= Value;
end;

function Tz3DShader.GetColor(const AParam: Tz3DHandle): Iz3DFloat4;
var F: TD3DXVector4;
begin
  if z3DTraceCondition(FD3DXEffect = nil, 'Iz3DShader.GetColor failed: D3DX Effect is NULL', z3DtkWarning) then Result:= nil else
  begin
    FD3DXEffect.GetVector(TD3DXHandle(AParam), F);
    Result:= z3DFloat4(F.X, F.Y, F.Z, F.W);
  end;
end;

function Tz3DShader.GetColor3(const AParam: Tz3DHandle): Iz3DFloat3;
var F: TD3DXVector4;
begin
  if z3DTraceCondition(FD3DXEffect = nil, 'Iz3DShader.GetColor3 failed: D3DX Effect is NULL', z3DtkWarning) then Result:= nil else
  begin
    FD3DXEffect.GetVector(TD3DXHandle(AParam), F);
    Result:= z3DFloat3(F.X, F.Y, F.Z);
  end;
end;

procedure Tz3DShader.SetColor(const AParam: Tz3DHandle; const Value: Iz3DFloat4);
begin
  if not z3DTraceCondition(FD3DXEffect = nil, PWideChar(WideString('Iz3DShader.SetColor failed: D3DX Effect is NULL (param '+AParam+')')), z3DtkWarning) then
  if FAILED(FD3DXEffect.SetVector(TD3DXHandle(AParam), Value.RGBA)) then
  z3DTrace(PWideChar(WideString('Iz3DShader.SetColor: D3DXEffect.SetVector failed (param '+AParam+')')), z3DtkWarning);
end;

procedure Tz3DShader.SetColor3(const AParam: Tz3DHandle; const Value: Iz3DFloat3);
begin
  if not z3DTraceCondition(FD3DXEffect = nil, PWideChar(WideString('Iz3DShader.SetColor3 failed: D3DX Effect is NULL (param '+AParam+')')), z3DtkWarning) then
  if FAILED(FD3DXEffect.SetVector(TD3DXHandle(AParam), Value.RGBA)) then
  z3DTrace(PWideChar(WideString('Iz3DShader.SetColor3: D3DXEffect.SetVector failed (param '+AParam+')')), z3DtkWarning);
end;

procedure Tz3DShader.BeginPass(const APassIndex: Integer = -1);
var FPassIndex: Integer;
begin
  if FD3DXEffect = nil then
  begin
    z3DTrace('Iz3DShader.BeginPass failed: D3DX Effect is NULL', z3DtkWarning);
    Exit;
  end;
  
  if APassIndex = -1 then
  begin
    FPassIndex:= FCurrentPass;
    Inc(FCurrentPass);
  end else FPassIndex:= APassIndex;

  if FAILED(D3DXEffect.BeginPass(FPassIndex)) then
  z3DTrace(PWideChar(WideString('Iz3DShader.BeginPass failed: D3DXEffect.BeginPass failed')), z3DtkWarning);
  Dec(FPassCount);
end;

procedure Tz3DShader.EndPass;
begin
  if FD3DXEffect = nil then
  begin
    z3DTrace('Iz3DShader.EndPass failed: D3DX Effect is NULL', z3DtkWarning);
    Exit;
  end;
  if FAILED(D3DXEffect.EndPass) then
  z3DTrace(PWideChar(WideString('Iz3DShader.EndPass failed: D3DXEffect.EndPass failed')), z3DtkWarning);
  if FPassCount = 0 then D3DXEffect._End;
end;

function Tz3DShader.Prepare(const AFlags: Cardinal = D3DXFX_DONOTSAVESTATE): Integer;
begin
  if FD3DXEffect = nil then
  begin
    z3DTrace('Iz3DShader.Run failed: D3DX Effect is NULL', z3DtkWarning);
    Result:= 0;
    Exit;
  end;
  if FAILED(D3DXEffect._Begin(@FPassCount, AFlags)) then
  z3DTrace(PWideChar(WideString('Iz3DShader.Run failed: D3DXEffect.Begin failed')), z3DtkWarning);
  FCurrentPass:= 0;
  Result:= FPassCount;
end;

procedure Tz3DShader.DrawFullScreen(const AFlags: Cardinal = D3DXFX_DONOTSAVESTATE);
var I: Integer;
begin
  if not z3DTraceCondition(FD3DXEffect = nil, PWideChar(WideString('Iz3DShader.RunFullScreen failed: D3DX Effect is NULL')), z3DtkWarning) then
  for I:= 0 to Prepare(AFlags) - 1 do
  begin
    BeginPass;
    z3DEngine.Renderer.DrawFullScreenQuad;
    EndPass;
  end;
end;

procedure Tz3DShader.Commit;
begin
  if FD3DXEffect = nil then
  begin
    z3DTrace('Iz3DShader.Commit failed: D3DX Effect is NULL', z3DtkWarning);
    Exit;
  end;
  if FAILED(D3DXEffect.CommitChanges) then
  z3DTrace(PWideChar(WideString('Iz3DShader.Commit failed: D3DXEffect.CommitChanges failed')), z3DtkWarning);
end;

procedure Tz3DShader.z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller);
begin
  inherited;
  if not Enabled then Exit;
  case ACaller of
    z3dcocCreateDevice, z3dcocStartScenario: CreateEffect;
    z3dcocResetDevice: if FD3DXEffect <> nil then FD3DXEffect.OnResetDevice;
  end;
end;

procedure Tz3DShader.z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller);
begin
  inherited;
  case ACaller of
    z3ddocDestroyDevice, z3ddocStopScenario: FD3DXEffect:= nil;
    z3ddocLostDevice: if FD3DXEffect <> nil then FD3DXEffect.OnLostDevice;
  end;
end;

{ Tz3DBaseTexture }

function Tz3DBaseTexture.From(const ATexture: IDirect3DBaseTexture9): Iz3DBaseTexture;
begin
  D3DBaseTexture:= ATexture;
end;

procedure Tz3DBaseTexture.GenerateMipMaps;
begin
  D3DBaseTexture.GenerateMipSubLevels;
end;

function Tz3DBaseTexture.GetFormat: TD3DFormat;
begin
  Result:= FFormat;
end;

function Tz3DBaseTexture.GetLevelCount: Integer;
begin
  Result:= FLevelCount;
end;

function Tz3DBaseTexture.GetUsage: DWord;
begin
  Result:= FUsage;
end;

function Tz3DBaseTexture.GetPool: TD3DPool;
begin
  Result:= FPool;
end;

procedure Tz3DBaseTexture.SetFormat(const Value: TD3DFormat);
begin
  FFormat:= Value;
end;

procedure Tz3DBaseTexture.SetUsage(const Value: DWord);
begin
  FUsage:= Value;
end;

procedure Tz3DBaseTexture.SetLevelCount(const Value: Integer);
begin
  FLevelCount:= Value;
end;

procedure Tz3DBaseTexture.SetPool(const Value: TD3DPool);
begin
  FPool:= Value;
end;

function Tz3DBaseTexture.GetD3DBaseTexture: IDirect3DBaseTexture9;
begin
  Result:= FD3DBaseTexture;
end;

procedure Tz3DBaseTexture.SetD3DBaseTexture(const Value: IDirect3DBaseTexture9);
begin
  FD3DBaseTexture:= Value;
end;

constructor Tz3DBaseTexture.Create;
begin
  inherited;

  // Link this object to the desired events generated by the z3D Engine
  Notifications:= [z3dlnDevice];
  ScenarioLevel:= True;
  FSamplerState.AddressMode:= z3dsamClamp;
  FSamplerState.Filter:= z3dsfNone;
  FSamplerState.MaxAnisotropy:= -1;

  FAutoGenerateMipMaps:= True;
  GetMem(FFileName, 255);
  ZeroMemory(FFileName, 255);
  FSource:= z3dtsNew;
  FUsage:= 0;
  FLevelCount:= 1;
  FEnabled:= True;
  FPool:= D3DPOOL_MANAGED;
end;

procedure Tz3DBaseTexture.z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller);
begin
  inherited;
  if not Enabled then Exit;
  case ACaller of
    z3dcocCreateDevice: if FPool = D3DPOOL_MANAGED then CreateD3DTexture;
    z3dcocResetDevice: if FPool <> D3DPOOL_MANAGED then CreateD3DTexture;
    z3dcocStartScenario: CreateD3DTexture;
  end;
end;

procedure Tz3DBaseTexture.z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller);
begin
  inherited;
  case ACaller of
    z3ddocDestroyDevice: if FPool = D3DPOOL_MANAGED then FD3DBaseTexture:= nil;
    z3ddocLostDevice: if FPool <> D3DPOOL_MANAGED then FD3DBaseTexture:= nil;
    z3ddocStopScenario: FD3DBaseTexture:= nil;
  end;
  FSurface0:= nil;
end;

function Tz3DBaseTexture.GetFileName: PWideChar;
begin
  Result:= FFileName;
end;

function Tz3DBaseTexture.GetSource: Tz3DTextureSource;
begin
  Result:= FSource;
end;

procedure Tz3DBaseTexture.SetFileName(const Value: PWideChar);
begin
  StringToWideChar(Value, FFileName, 255);
  if Enabled and z3DCore_GetState.DeviceCreated then CreateD3DTexture;
end;

procedure Tz3DBaseTexture.SetSource(const Value: Tz3DTextureSource);
begin
  FSource:= Value;
end;

procedure Tz3DBaseTexture.AttachToSampler(const AIndex: Integer; const ASetAddress: Boolean = False;
  const ASetFilter: Boolean = False); stdcall;
begin
  // TODO JP: VER DE PONER EN OTRO LUGAR
  if (Self is Tz3DMaterialTexture) then
  begin
    FSamplerState.Filter:= z3DEngine.Renderer.TextureFilter;
    FSamplerState.MaxAnisotropy:= z3DEngine.Renderer.AnisotropyLevel;
  end;

  z3DCore_GetD3DDevice.SetTexture(AIndex, GetD3DBaseTexture);
  if ASetAddress then z3DEngine.Renderer.SetSamplerAddressMode(AIndex, FSamplerState.AddressMode,
  FSamplerState.BorderColor);
  if ASetFilter then z3DEngine.Renderer.SetSamplerFilter(AIndex, FSamplerState.Filter,
  FSamplerState.MaxAnisotropy);
end;

function Tz3DBaseTexture.GetAutoGenerateMipMaps: Boolean;
begin
  Result:= FAutoGenerateMipMaps;
end;

procedure Tz3DBaseTexture.SetAutoGenerateMipMaps(const Value: Boolean);
begin
  FAutoGenerateMipMaps:= Value;
end;

procedure Tz3DBaseTexture.CreateD3DTexture;
begin
  if Assigned(FOnCreate) then FOnCreate(Self);
end;

function Tz3DBaseTexture.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

procedure Tz3DBaseTexture.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    if z3DEngine.Device.Created then
    begin
      if ScenarioLevel then
      z3DDestroyScenarioObjects(z3ddocStopScenario) else
      begin
        z3DDestroyScenarioObjects(z3ddocLostDevice);
        z3DDestroyScenarioObjects(z3ddocDestroyDevice);
      end;
    end;
    FEnabled:= Value;
    if z3DEngine.Device.Created then
    begin
      if ScenarioLevel then
      z3DCreateScenarioObjects(z3dcocStartScenario) else
      begin
        z3DCreateScenarioObjects(z3dcocCreateDevice);
        z3DCreateScenarioObjects(z3dcocResetDevice);
      end;
    end;
  end;
end;

function Tz3DBaseTexture.GetOnCreate: Tz3DBaseCallbackEvent;
begin
  Result:= FOnCreate;
end;

procedure Tz3DBaseTexture.SetOnCreate(const Value: Tz3DBaseCallbackEvent);
begin
  FOnCreate:= Value;
end;

function Tz3DBaseTexture.GetSamplerState: Pz3DSamplerState;
begin
  Result:= @FSamplerState;
end;

{ Tz3DTexture }

procedure Tz3DTexture.SetParams(const AWidth, AHeight, ALevels: Integer;
  const AFormat: TD3DFormat; const APool: TD3DPool);
begin
  FWidth:= AWidth;
  FHeight:= AHeight;
  FLevelCount:= ALevels;
  FFormat:= AFormat;
  if (FUsage = D3DUSAGE_RENDERTARGET) or (FUsage = D3DUSAGE_DEPTHSTENCIL) then
  FPool:= D3DPOOL_DEFAULT else FPool:= APool;
  if z3DEngine.Device.Created then CreateD3DTexture;
end;

procedure Tz3DTexture.Fill(const AColor: Iz3DFloat4);
begin
  if (FPool = D3DPOOL_MANAGED) then
  z3DTrace('Iz3DTexture.Fill: Could not fill a MANAGED texture', z3DtkWarning) else
  if (FUsage = D3DUSAGE_DEPTHSTENCIL) then
  z3DTrace('Iz3DTexture.Fill: Could not fill a DEPTHSTENCIL texture', z3DtkWarning) else
  if FAILED(z3DCore_GetD3DDevice.ColorFill(GetSurface.D3DSurface, nil, AColor.D3DColor)) then
  z3DTrace(PWideChar(WideString('Iz3DTexture.Fill failed: ColorFill failed')), z3DtkWarning);
end;

function Tz3DTexture.GetD3DTexture: IDirect3DTexture9;
begin
  Result:= FD3DTexture;
end;

function Tz3DTexture.GetHeight: Integer;
begin
  Result:= FHeight;
end;

function Tz3DTexture.GetWidth: Integer;
begin
  Result:= FWidth;
end;

procedure Tz3DTexture.CreateD3DTexture;
var FTexture: IDirect3DTexture9;
    FSurface: IDirect3DSurface9;
    FDesc: TD3DSurfaceDesc;
begin
  if not Enabled then Exit;
  if z3DTraceCondition(z3DCore_GetD3DDevice = nil, PWideChar(WideString('Iz3DTexture.CreateD3DTexture failed: Direct3D device is NULL')), z3DtkWarning) then Exit;
  FSurface0:= nil;
  if Source = z3dtsFileName then
  begin
    if not FileExists(FFileName) then
    begin
      z3DTrace(PWideChar(WideString('Iz3DTexture.CreateD3DTexture failed: Invalid filename ('+FFileName+')')), z3DtkWarning);
      Exit;
    end;
    if AutoGenerateMipMaps then
    begin
      if FAILED(D3DXCreateTextureFromFileW(z3DCore_GetD3DDevice, FFileName, FTexture)) then
      begin
        z3DTrace('Iz3DTexture.CreateD3DTexture failed: D3DXCreateTextureFromFile failed', z3dtkWarning);
        Exit;
      end;
    end else
    begin
      if FAILED(D3DXCreateTextureFromFileExW(z3DCore_GetD3DDevice, FFileName, D3DX_DEFAULT, D3DX_DEFAULT,
      D3DX_FROM_FILE, 0, D3DFMT_UNKNOWN, D3DPOOL_MANAGED, D3DX_DEFAULT, D3DX_DEFAULT, 0, nil, nil, FTexture)) then
      begin
        z3DTrace('Iz3DTexture.CreateD3DTexture failed: D3DXCreateTextureFromFileEx failed', z3dtkWarning);
        Exit;
      end;
    end;
    FD3DTexture:= FTexture;
    FD3DBaseTexture:= FTexture as IDirect3DBaseTexture9;
    if FD3DTexture <> nil then
    begin
      FTexture.GetSurfaceLevel(0, FSurface);
      FSurface.GetDesc(FDesc);
      FWidth:= FDesc.Width;
      FHeight:= FDesc.Height;
    end;
  end else
  begin
    if FAILED(D3DXCreateTexture(z3DCore_GetD3DDevice, FWidth, FHeight, FLevelCount,
    FUsage or FMipMapUsage[FAutoGenerateMipMaps], FFormat, FPool, FTexture)) then
    begin
      z3DTrace('Iz3DTexture.CreateD3DTexture failed: D3DXCreateTexture failed', z3DtkWarning);
      Exit;
    end;
    FD3DTexture:= FTexture;
    FD3DBaseTexture:= FTexture as IDirect3DBaseTexture9;
    if (FPool <> D3DPOOL_MANAGED) and (FUsage <> D3DUSAGE_DEPTHSTENCIL) then Fill(z3DFloat4);
  end;
  inherited;
end;

procedure Tz3DTexture.SetD3DTexture(const Value: IDirect3DTexture9);
begin
  inherited;
  FD3DTexture:= Value;
end;

procedure Tz3DTexture.SetHeight(const Value: Integer);
begin
  FHeight:= Value;
end;

procedure Tz3DTexture.SetWidth(const Value: Integer);
begin
  FWidth:= Value;
end;

function Tz3DTexture.GetSurface: Iz3DSurface;
var FSurface: IDirect3DSurface9;
begin
  if FSurface0 = nil then
  begin
    GetD3DTexture.GetSurfaceLevel(0, FSurface);
    FSurface0:= Tz3DSurface.Create;
    FSurface0.ScenarioLevel:= ScenarioLevel;
    FSurface0.D3DSurface:= FSurface;
  end;
  Result:= FSurface0;
end;

procedure Tz3DTexture.BeginDraw(const ALevel: Integer = 0; const AFlags: Cardinal = 0);
begin
  if FAILED(D3DTexture.LockRect(ALevel, FRect, nil, AFlags)) then
  z3DTrace(PWideChar(WideString('Iz3DTexture.BeginDraw failed: LockRect failed')), z3DtkWarning);
end;

procedure Tz3DTexture.EndDraw(const ALevel: Integer = 0);
begin
  D3DTexture.UnlockRect(ALevel);
end;

procedure Tz3DTexture.SetPixel(const AX, AY: Integer; const AColor: Iz3DFloat4);
var FBits: PSingleArray;
begin
  if FRect.pBits = nil then
  begin
    z3DTrace(PWideChar(WideString('Iz3DTexture.SetPixel failed: Texture is not locked')), z3DtkWarning);
    Exit;
  end;
  FBits:= @FRect.pBits;
  FBits^[AY * FRect.Pitch div 4 + AX]:= AColor.D3DColor;
end;

procedure Tz3DTexture.SetPixel(const AX, AY: Integer; const AColor: Iz3DFloat3);
begin
  SetPixel(AX, AY, z3DFloat4(AColor.R, AColor.G, AColor.B, 1));
end;

function Tz3DTexture.GetLockedRect: TD3DLockedRect;
begin
  Result:= FRect;
end;

function Tz3DTexture.GetPixel(const AX, AY: Integer): Iz3DFloat4;
var FBits: PSingleArray;
    FColor: TD3DXColor;
begin
  if FRect.pBits = nil then
  begin
    z3DTrace(PWideChar(WideString('Iz3DTexture.GetPixel failed: Texture is not locked')), z3DtkWarning);
    Exit;
  end;
  FBits:= @FRect.pBits;
  FColor:= D3DXColorFromDWORD(FBits^[AY * FRect.Pitch div 4 + AX]);
  Result:= z3DFloat4(FColor.r, FColor.g, FColor.b, FColor.a);
end;

procedure Tz3DTexture.z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller);
begin
  inherited;
  case ACaller of
    z3ddocDestroyDevice: if FPool = D3DPOOL_MANAGED then FD3DTexture:= nil;
    z3ddocLostDevice: if FPool <> D3DPOOL_MANAGED then FD3DTexture:= nil;
    z3ddocStopScenario: FD3DTexture:= nil;
  end;
end;

{ Tz3DSurface }

constructor Tz3DSurface.Create(const AOwner: Iz3DBase = nil);
begin
  inherited;
  // Link this object to the desired events generated by the z3D Engine
  Notifications:= [z3dlnDevice];
  ScenarioLevel:= True;
end;

function Tz3DSurface.From(const ASurface: IDirect3DSurface9): Iz3DSurface;
begin
  D3DSurface:= ASurface;
  Result:= Self;
end;

function Tz3DSurface.GetD3DSurface: IDirect3DSurface9;
begin
  Result:= FD3DSurface;
end;

class function Tz3DSurface.New: Iz3DSurface;
begin
  Result:= Tz3DSurface.Create;
end;

class function Tz3DSurface.NewFrom(const ASurface: IDirect3DSurface9): Iz3DSurface;
begin
  Result:= Tz3DSurface.Create;
  Result.D3DSurface:= ASurface;
end;

procedure Tz3DSurface.RestoreRenderTarget;
var FDesc: TD3DSurfaceDesc;
begin
  if FPreviousRT = nil then
  begin
    z3DTrace(PWideChar(WideString('Iz3DSurface.RestoreRenderTarget failed: Previous RT is NULL')), z3DtkWarning);
    Exit;
  end;
  FPreviousRT.GetDesc(FDesc);
  z3DCore_GetD3DDevice.SetRenderTarget(0, FPreviousRT);
  z3DEngine.Renderer.RTWidth:= FDesc.Width;
  z3DEngine.Renderer.RTHeight:= FDesc.Height;
  FPreviousRT:= nil;
end;

procedure Tz3DSurface.SetRenderTarget(const AIndex: Integer = 0; const ASave: Boolean = False);
begin
  if FD3DSurface = nil then
  begin
    z3DTrace(PWideChar(WideString('Iz3DSurface.SetRenderTarget failed: D3DSurface is NULL')), z3DtkWarning);
    Exit;
  end;
  if ASave then z3DCore_GetD3DDevice.GetRenderTarget(AIndex, FPreviousRT);
  z3DCore_GetD3DDevice.SetRenderTarget(AIndex, FD3DSurface);
  z3DEngine.Renderer.RTWidth:= Width;
  z3DEngine.Renderer.RTHeight:= Height;
end;

procedure Tz3DSurface.SetD3DSurface(const Value: IDirect3DSurface9);
var FDesc: TD3DSurfaceDesc;
begin
  FD3DSurface:= Value;
  if Value <> nil then
  begin
    Value.GetDesc(FDesc);
    FWidth:= FDesc.Width;
    FHeight:= FDesc.Height;
  end;
end;

procedure Tz3DSurface.z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller);
begin
  inherited;
  FD3DSurface:= nil;
  FPreviousRT:= nil;
end;

function Tz3DSurface.From(const ATexture: Iz3DTexture): Iz3DSurface;
begin
  From(ATexture.GetSurface.D3DSurface);
end;

function Tz3DSurface.GetHeight: Integer;
begin
  Result:= FHeight;
end;

function Tz3DSurface.GetWidth: Integer;
begin
  Result:= FWidth;
end;

function Tz3DSurface.From(const ASurface: Iz3DSurface): Iz3DSurface;
begin
  From(ASurface.D3DSurface);
end;

procedure Tz3DSurface.BeginDraw(const AFlags: Cardinal);
begin
  D3DSurface.LockRect(FRect, nil, AFlags);
end;

procedure Tz3DSurface.EndDraw;
begin
  D3DSurface.UnlockRect;
end;

function Tz3DSurface.GetPixel(const AX, AY: Integer): Iz3DFloat4;
var FBits: PSingleArray;
    FColor: TD3DXColor;
begin
  if FRect.pBits = nil then
  begin
    z3DTrace(PWideChar(WideString('Iz3DSurface.GetPixel failed: Surface is not locked')), z3DtkWarning);
    Exit;
  end;
  FBits:= @FRect.pBits;
  FColor:= D3DXColorFromDWORD(FBits^[AY * FRect.Pitch div 4 + AX]);
  Result:= z3DFloat4(FColor.r, FColor.g, FColor.b, FColor.a);
end;

procedure Tz3DSurface.SetPixel(const AX, AY: Integer; const AColor: Iz3DFloat4);
var FBits: PSingleArray;
begin
  if FRect.pBits = nil then
  begin
    z3DTrace(PWideChar(WideString('Iz3DSurface.SetPixel failed: Surface is not locked')), z3DtkWarning);
    Exit;
  end;
  FBits:= @FRect.pBits;
  FBits^[AY * FRect.Pitch div 4 + AX]:= AColor.D3DColor;
end;

procedure Tz3DSurface.SetPixel(const AX, AY: Integer; const AColor: Iz3DFloat3);
begin
  SetPixel(AX, AY, z3DFloat4(AColor.R, AColor.G, AColor.B, 1));
end;

{ Tz3DCubeTexture }

procedure Tz3DCubeTexture.SetCubeParams(const ASize, ALevels: Integer;
  const AFormat: TD3DFormat; const APool: TD3DPool);
begin
  FSize:= ASize;
  FLevelCount:= ALevels;
  FFormat:= AFormat;
  if FUsage = D3DUSAGE_RENDERTARGET then FPool:= D3DPOOL_DEFAULT else
  FPool:= APool;
  CreateD3DTexture;
end;

function Tz3DCubeTexture.GetD3DCubeTexture: IDirect3DCubeTexture9;
begin
  Result:= FD3DCubeTexture;
end;

function Tz3DCubeTexture.GetSize: Integer;
begin
  Result:= FSize;
end;

procedure Tz3DCubeTexture.CreateD3DTexture;
var FTexture: IDirect3DCubeTexture9;
begin
  if not Enabled then Exit;
  if z3DTraceCondition(z3DCore_GetD3DDevice = nil, PWideChar(WideString('Iz3DTexture.CreateD3DTexture: Direct3D device is NULL')), z3DtkError) then Exit;
  FSurface0:= nil;
  if Source = z3dtsFileName then
  begin
    if not FileExists(FFileName) then
    begin
      z3DTrace(PWideChar(WideString('Iz3DCubeTexture.CreateD3DTexture failed: Invalid filename ('+FFileName+')')), z3DtkWarning);
      Exit;
    end;
    if FAILED(D3DXCreateCubeTextureFromFileW(z3DCore_GetD3DDevice, FFileName, FTexture)) then
    begin
      z3DTrace('Iz3DCubeTexture.CreateD3DTexture failed: D3DXCreateCubeTextureFromFile failed', z3DtkWarning);
      Exit;
    end;
  end else
  begin
    if FAILED(D3DXCreateCubeTexture(z3DCore_GetD3DDevice, FSize, FLevelCount,
    FUsage or FMipMapUsage[FAutoGenerateMipMaps], FFormat, FPool, FTexture)) then
    begin
      z3DTrace('Iz3DCubeTexture.CreateD3DTexture failed: D3DXCreateCubeTexture failed', z3DtkWarning);
      Exit;
    end;
  end;
  FD3DCubeTexture:= FTexture;
  FD3DBaseTexture:= FTexture as IDirect3DBaseTexture9;
  inherited;
end;

procedure Tz3DCubeTexture.SetSize(const Value: Integer);
begin
  FSize:= Value;
end;

procedure Tz3DCubeTexture.Fill(const AColor: Iz3DFloat4);
var I: Integer;
begin
  if FPool = D3DPOOL_MANAGED then
  begin
    z3DTrace('Iz3DCubeTexture.Fill: Could not fill a MANAGED texture', z3DtkWarning);
    Exit;
  end;
  if (FUsage = D3DUSAGE_DEPTHSTENCIL) then
  begin
    z3DTrace('Iz3DTexture.Fill: Could not fill a DEPTHSTENCIL texture', z3DtkWarning);
    Exit;
  end;
  for I:= 0 to 5 do
  if FAILED(z3DCore_GetD3DDevice.ColorFill(GetSurface(TD3DCubemapFaces(I)).D3DSurface, nil, AColor.D3DColor)) then
  z3DTrace(PWideChar(WideString('Iz3DCubeTexture.Fill failed: ColorFill failed')), z3DtkWarning);
end;

function Tz3DCubeTexture.GetSurface(const AFace: TD3DCubemapFaces): Iz3DSurface;
begin
  if FSurfaces[AFace] = nil then D3DCubeTexture.GetCubeMapSurface(AFace, 0, FSurfaces[AFace]);
  Result:= Tz3DSurface.NewFrom(FSurfaces[AFace]);
end;

procedure Tz3DCubeTexture.z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller);
var I: Integer;
begin
  inherited;
  case ACaller of
    z3ddocDestroyDevice:
    if FPool = D3DPOOL_MANAGED then
    begin
      for I:= 0 to Length(FSurfaces)-1 do FSurfaces[TD3DCubeMapFaces(I)]:= nil;
      FD3DCubeTexture:= nil;
    end;
    z3ddocLostDevice:
    if FPool <> D3DPOOL_MANAGED then
    begin
      for I:= 0 to Length(FSurfaces)-1 do FSurfaces[TD3DCubeMapFaces(I)]:= nil;
      FD3DCubeTexture:= nil;
    end;
    z3ddocStopScenario:
    begin
      for I:= 0 to Length(FSurfaces)-1 do FSurfaces[TD3DCubeMapFaces(I)]:= nil;
      FD3DCubeTexture:= nil;
    end;
  end;
end;

{ Tz3DRenderTexture }

constructor Tz3DRenderTexture.Create;
begin
  inherited;
  FAutoGenerateMipMaps:= False;
  FUsage:= D3DUSAGE_RENDERTARGET;
  FPool:= D3DPOOL_DEFAULT;
  FAutoWidthFactor:= 1;
  FAutoHeightFactor:= 1;
  FAutoFormat:= z3dsafNone;
  FAutoParams:= True;
end;

procedure Tz3DRenderTexture.RestoreRenderTarget;
begin
  FSurface0.RestoreRenderTarget;
end;

procedure Tz3DRenderTexture.SetRenderTarget(const AIndex: Integer; const ASave: Boolean);
var FSurface: IDirect3DSurface9;
begin
  if FSurface0 = nil then
  begin
    if D3DTexture = nil then
    begin
      z3DTrace('Iz3DRenderTexture.SetRenderTarget failed: D3DTexture is NULL', z3DtkWarning);
      Exit;
    end;
    GetD3DTexture.GetSurfaceLevel(0, FSurface);
    FSurface0:= Tz3DSurface.NewFrom(FSurface);
  end;
  FSurface0.SetRenderTarget(AIndex, ASave);
end;

function Tz3DRenderTexture.GetAutoParams: Boolean;
begin
  Result:= FAutoParams;
end;

function Tz3DRenderTexture.GetAutoHeightFactor: Single;
begin
  Result:= FAutoHeightFactor;
end;

function Tz3DRenderTexture.GetAutoWidthFactor: Single;
begin
  Result:= FAutoWidthFactor;
end;

procedure Tz3DRenderTexture.SetAutoParams(const Value: Boolean);
begin
  FAutoParams:= Value;
end;

procedure Tz3DRenderTexture.SetAutoHeightFactor(const Value: Single);
begin
  FAutoHeightFactor:= Value;
end;

procedure Tz3DRenderTexture.SetAutoWidthFactor(const Value: Single);
begin
  FAutoWidthFactor:= Value;
end;

procedure Tz3DRenderTexture.z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller);
var FCropWidth, FCropHeight: Integer;
begin
  if not z3DEngine.Device.Created then Exit;
  if FAutoParams then
  begin
    FCropWidth:= z3DCore_GetBackBufferSurfaceDesc.Width-z3DCore_GetBackBufferSurfaceDesc.Width mod Round(1 / FAutoWidthFactor);
    FCropHeight:= z3DCore_GetBackBufferSurfaceDesc.Height-z3DCore_GetBackBufferSurfaceDesc.Height mod Round(1 / FAutoHeightFactor);
    FWidth:= Round(FCropWidth * FAutoWidthFactor);
    FHeight:= Round(FCropHeight * FAutoHeightFactor);
  end;
  case FAutoFormat of
    z3dsafRenderer: FFormat:= z3DEngine.Renderer.Format;
    z3dsafFP: FFormat:= z3DEngine.Device.EngineCaps.FPFormat;
    z3dsafShadowMap: FFormat:= z3DEngine.Device.EngineCaps.ShadowMapFormat;
  end;
  inherited;
end;

function Tz3DRenderTexture.GetAutoFormat: Tz3DSurfaceAutoFormat;
begin
  Result:= FAutoFormat;
end;

procedure Tz3DRenderTexture.SetAutoFormat(const Value: Tz3DSurfaceAutoFormat);
begin
  FAutoFormat:= Value;
end;

{ Tz3DCubeRenderTexture }

constructor Tz3DCubeRenderTexture.Create;
begin
  inherited;
  FAutoGenerateMipMaps:= False;
  FUsage:= D3DUSAGE_RENDERTARGET;
  FPool:= D3DPOOL_DEFAULT;
end;

procedure Tz3DCubeRenderTexture.RestoreRenderTarget;
var FDesc: TD3DSurfaceDesc;
begin
  FPreviousRT.GetDesc(FDesc);
  z3DCore_GetD3DDevice.SetRenderTarget(0, FPreviousRT);
  z3DEngine.Renderer.RTWidth:= FDesc.Width;
  z3DEngine.Renderer.RTHeight:= FDesc.Height;
  FPreviousRT:= nil;
end;

procedure Tz3DCubeRenderTexture.SetRenderTarget(const AFace: TD3DCubemapFaces; const ASave: Boolean);
begin
  if D3DCubeTexture = nil then
  begin
    z3DTrace('Iz3DCubeTexture.SetRenderTarget failed: D3DCubeTexture is NULL', z3DtkWarning);
    Exit;
  end;
  if FSurfaces[AFace] = nil then
  GetD3DCubeTexture.GetCubeMapSurface(AFace, 0, FSurfaces[AFace]);
  if ASave then z3DCore_GetD3DDevice.GetRenderTarget(0, FPReviousRT);
  z3DCore_GetD3DDevice.SetRenderTarget(0, FSurfaces[AFace]);
end;

procedure Tz3DCubeRenderTexture.z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller);
begin
  inherited;
  FPreviousRT:= nil;
end;

{ Tz3DDepthBuffer }

procedure Tz3DDepthBuffer.CreateD3DSurface;
begin
  if FAILED(z3DCore_GetD3DDevice.CreateDepthStencilSurface(FWidth, FHeight, FFormat, FMultiSample,
  FMSQuality, FDiscard, FD3DSurface, nil)) then
  z3DTrace('Iz3DDepthBuffer.CreateD3DSurface failed: CreateDepthStencilSurface failed', z3DtkWarning);
  if Assigned(FOnCreate) then FOnCreate(Self);
end;

procedure Tz3DDepthBuffer.SetDiscard(const Value: Boolean);
begin
  FDiscard:= Value;
end;

procedure Tz3DDepthBuffer.SetFormat(const Value: TD3DFormat);
begin
  FFormat:= Value;
end;

procedure Tz3DDepthBuffer.SetHeight(const Value: Integer);
begin
  FHeight:= Value;
end;

procedure Tz3DDepthBuffer.SetMSQuality(const Value: DWORD);
begin
  FMSQuality:= Value;
end;

procedure Tz3DDepthBuffer.SetMultiSample(const Value: TD3DMultiSampleType);
begin
  FMultiSample:= Value;
end;

procedure Tz3DDepthBuffer.SetParams(const AWidth, AHeight: Integer;
  const AFormat: TD3DFormat; const AMultiSample: TD3DMultiSampleType;
  const AMSQuality: DWORD; const ADiscard: Boolean);
begin
  FWidth:= AWidth;
  FHeight:= AHeight;
  FFormat:= AFormat;
  FMultiSample:= AMultiSample;
  FMSQuality:= AMSQuality;
  FDiscard:= ADiscard;
  CreateD3DSurface;
end;

procedure Tz3DDepthBuffer.SetWidth(const Value: Integer);
begin
  FWidth:= Value;
end;

function Tz3DDepthBuffer.GetDiscard: Boolean;
begin
  Result:= FDiscard;
end;

function Tz3DDepthBuffer.GetFormat: TD3DFormat;
begin
  Result:= FFormat;
end;

function Tz3DDepthBuffer.GetHeight: Integer;
begin
  Result:= FHeight;
end;

function Tz3DDepthBuffer.GetMSQuality: DWORD;
begin
  Result:= FMSQuality;
end;

function Tz3DDepthBuffer.GetMultiSample: TD3DMultiSampleType;
begin
  Result:= FMultiSample;
end;

function Tz3DDepthBuffer.GetWidth: Integer;
begin
  Result:= FWidth;
end;

function Tz3DDepthBuffer.GetOnCreate: Tz3DBaseCallbackEvent;
begin
  Result:= FOnCreate;
end;

procedure Tz3DDepthBuffer.SetOnCreate(const Value: Tz3DBaseCallbackEvent);
begin
  FOnCreate:= Value;
end;

{ Tz3DMaterialTexture }

constructor Tz3DMaterialTexture.Create;
begin
  inherited;
  FAutoGenerateNormalMap:= True;
  FSource:= z3dtsFileName;
  FNormalMapFactor:= 0.25;
  FPool:= D3DPOOL_MANAGED;
  FSamplerState.AddressMode:= z3dsamWrap;
  FNormalMapTexture:= Tz3DTexture.Create;
  FNormalMapTexture.Source:= z3dtsFileName;
  FNormalMapTexture.SamplerState.AddressMode:= z3dsamWrap;
  FNormalMapTexture.SamplerState.Filter:= z3dsfAnisotropic;
  FNormalMapTexture.SamplerState.MaxAnisotropy:= 16;
end;

procedure Tz3DMaterialTexture.CreateD3DTexture;
var FPrevFileName: PWideChar;
    FNormalMapFile: PWideChar;
begin
  // Expand the texture file name
  if FD3DTexture = nil then
  begin
    GetMem(FPrevFileName, 255);
    try
      StringToWideChar(FFileName, FPrevFileName, 255);
      z3DMaterialController.MaterialTextureFormat.Expand(FPrevFileName, FFileName);
      inherited;
      StringToWideChar(FPrevFileName, FFileName, 255);
    finally
      FreeMem(FPrevFileName);
    end;

    // Load the normal map texture if exists or create it
    if (Source = z3dtsFileName) and FNormalMapTexture.Enabled and (FD3DTexture <> nil) then
    begin
      GenerateNormalMap;
      GetMem(FNormalMapFile, 255);
      try
        z3DMaterialController.MaterialTextureFormat.Expand(GetNormalMapFileName, FNormalMapFile);
        FNormalMapTexture.FileName:= FNormalMapFile;
        FNormalMapTexture.CreateD3DTexture;
      finally
        FreeMem(FNormalMapFile);
      end;
    end;
  end;
end;

procedure Tz3DMaterialTexture.GenerateNormalMap;
var FNormalMapGen: Iz3DRenderTexture;
    FNormalMapFileExp: PWideChar;
    FExt: string;
    FFileFormat: TD3DXImageFileFormat;
begin
  if not z3DEngine.Device.Created or (FNormalMapTexture.D3DTexture <> nil) or
  not FNormalMapTexture.Enabled or (FD3DTexture = nil) then Exit;
  if (Source = z3dtsFileName) then
  begin
    GetMem(FNormalMapFileExp, 255);
    try
      z3DMaterialController.MaterialTextureFormat.Expand(GetNormalMapFileName, FNormalMapFileExp);
      if not FileExists(FNormalMapFileExp) then
      begin
        FNormalMapGen:= z3DEngine.ComputeNormalMap(Self, FNormalMapFactor);
        FExt:= LowerCase(ExtractFileExt(FFileName));
        if FExt = '.bmp' then FFileFormat:= D3DXIFF_BMP else
        if FExt = '.jpg' then FFileFormat:= D3DXIFF_JPG else
        if FExt = '.png' then FFileFormat:= D3DXIFF_PNG else
        if FExt = '.dib' then FFileFormat:= D3DXIFF_DIB else
        if FExt = '.hdr' then FFileFormat:= D3DXIFF_HDR else
        if FExt = '.pfm' then FFileFormat:= D3DXIFF_PFM else
        FFileFormat:= D3DXIFF_DDS;
        D3DXSaveSurfaceToFileW(FNormalMapFileExp, FFileFormat, FNormalMapGen.GetSurface.D3DSurface, nil, nil);
        FNormalMapGen.D3DTexture:= nil;
        FNormalMapGen.D3DBaseTexture:= nil;
        FNormalMapGen:= nil;
      end;
    finally
      FreeMem(FNormalMapFileExp);
    end;
  end else
  begin
    FNormalMapGen:= z3DEngine.ComputeNormalMap(Self, FNormalMapFactor);
    FNormalMapTexture.Pool:= D3DPOOL_DEFAULT;
    FNormalMapTexture.D3DTexture:= FNormalMapGen.D3DTexture;
    FNormalMapTexture.D3DBaseTexture:= FNormalMapGen.D3DBaseTexture;
    FNormalMapGen.D3DTexture:= nil;
    FNormalMapGen.D3DBaseTexture:= nil;
    FNormalMapGen:= nil;
  end;
end;

function Tz3DMaterialTexture.GetNormalMapFileName: PWideChar;
const FNormalMapSufix = '_NM';
begin
  if Pos('.', FFileName) > 0 then
  StringToWideChar(Copy(FFileName, 0, Pos('.', FFileName)-1)+
  FNormalMapSufix+Copy(FFileName, Pos('.', FFileName),
  Length(FFileName)-Pos('.', FFileName)+1), z3DWideBuffer, 255) else
  StringToWideChar(FFileName+FNormalMapSufix, z3DWideBuffer, 255);
  Result:= z3DWideBuffer;
end;

function Tz3DMaterialTexture.GetAutoGenerateNormalMap: Boolean;
begin
  Result:= FAutoGenerateNormalMap;
end;

function Tz3DMaterialTexture.GetEnableNormalMap: Boolean;
begin
  Result:= FNormalMapTexture.Enabled;
end;

function Tz3DMaterialTexture.GetNormalMapFactor: Single;
begin
  Result:= FNormalMapFactor;
end;

function Tz3DMaterialTexture.GetNormalMapTexture: Iz3DTexture;
begin
  Result:= FNormalMapTexture;
end;

procedure Tz3DMaterialTexture.SetAutoGenerateNormalMap(const Value: Boolean);
begin
  FAutoGenerateNormalMap:= Value;
end;

procedure Tz3DMaterialTexture.SetEnableNormalMap(const Value: Boolean);
begin
  FNormalMapTexture.Enabled:= Value;
end;

procedure Tz3DMaterialTexture.SetNormalMapFactor(const Value: Single);
begin
  FNormalMapFactor:= Value;
end;

{ Tz3DVertexElement }

constructor Tz3DVertexElement.Create(const AOwner: Iz3DVertexFormat);
begin
  inherited Create;
  FOwner:= AOwner;
  FFormat:= z3dvefFloat4;
  FMethod:= z3dvemDefault;
  FStream:= 0;
  FUsage:= z3dveuPosition;
  FUsageIndex:= 0;
end;

function Tz3DVertexElement.GetFormat: Tz3DVertexElementFormat;
begin
  Result:= FFormat;
end;

function Tz3DVertexElement.GetMethod: Tz3DVertexElementMethod;
begin
  Result:= FMethod;
end;

function Tz3DVertexElement.GetStream: Integer;
begin
  Result:= FStream;
end;

function Tz3DVertexElement.GetUsage: Tz3DVertexElementUsage;
begin
  Result:= FUsage;
end;

function Tz3DVertexElement.GetUsageIndex: Integer;
begin
  Result:= FUsageIndex;
end;

procedure Tz3DVertexElement.SetFormat(const Value: Tz3DVertexElementFormat);
begin
  FFormat:= Value;
  if not FOwner.Updating then
  begin
    FOwner.CreateD3DFormat;
    if Assigned(FOwner.OnChange) then FOwner.OnChange(Self);
  end;
end;

procedure Tz3DVertexElement.SetMethod(const Value: Tz3DVertexElementMethod);
begin
  FMethod:= Value;
  if not FOwner.Updating then
  begin
    FOwner.CreateD3DFormat;
    if Assigned(FOwner.OnChange) then FOwner.OnChange(Self);
  end;
end;

procedure Tz3DVertexElement.SetStream(const Value: Integer);
begin
  FStream:= Value;
  if not FOwner.Updating then
  begin
    FOwner.CreateD3DFormat;
    if Assigned(FOwner.OnChange) then FOwner.OnChange(Self);
  end;
end;

procedure Tz3DVertexElement.SetUsage(const Value: Tz3DVertexElementUsage);
begin
  FUsage:= Value;
  if not FOwner.Updating then
  begin
    FOwner.CreateD3DFormat;
    if Assigned(FOwner.OnChange) then FOwner.OnChange(Self);
  end;
end;

procedure Tz3DVertexElement.SetUsageIndex(const Value: Integer);
begin
  FUsageIndex:= Value;
  if not FOwner.Updating then
  begin
    FOwner.CreateD3DFormat;
    if Assigned(FOwner.OnChange) then FOwner.OnChange(Self);
  end;
end;

{ Tz3DVertexFormat }

constructor Tz3DVertexFormat.Create(const AOwner: Iz3DBase = nil);
begin
  inherited;

  // Link this object to the desired events generated by the z3D Engine
  Notifications:= [z3dlnDevice];
  ScenarioLevel:= True;

  FElements:= TInterfaceList.Create;
  FUpdating:= False;
end;

function Tz3DVertexFormat.AddElement(const AStream: Integer; const AFormat: Tz3DVertexElementFormat;
  const AMethod: Tz3DVertexElementMethod; const AUsage: Tz3DVertexElementUsage;
  const AUsageIndex: Integer): Iz3DVertexElement;
begin
  Result:= Tz3DVertexElement.Create(Self);
  Result.Stream:= AStream;
  Result.Format:= AFormat;
  Result.Method:= AMethod;
  Result.Usage:= AUsage;
  Result.UsageIndex:= AUsageIndex;
  FElements.Add(Result);
end;

procedure Tz3DVertexFormat.BeginUpdate;
begin
  FUpdating:= True;
end;

procedure Tz3DVertexFormat.CreateD3DFormat(const AForce: Boolean);
begin
  if not z3DEngine.Device.Created then Exit;
  if FAILED(z3DCore_GetD3DDevice.CreateVertexDeclaration(GetDeclaration, FD3DFormat)) then
  z3DTrace('Iz3DVertexFormat.CreateD3DFormat failed: CreateVertexDeclaration failed', z3DtkWarning);
  if Assigned(FOnCreate) then FOnCreate(Self);
end;

function Tz3DVertexFormat.CreateElement: Iz3DVertexElement;
begin
  Result:= Tz3DVertexElement.Create(Self);
  FElements.Add(Result);
  if not Updating then
  begin
    CreateD3DFormat;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure Tz3DVertexFormat.EndUpdate;
begin
  if FUpdating then
  begin
    FUpdating:= False;
    if not Updating then
    begin
      CreateD3DFormat;
      if Assigned(FOnChange) then FOnChange(Self);
    end;
  end;
end;

function Tz3DVertexFormat.GetElement(const AIndex: Integer): Iz3DVertexElement;
begin
  Result:= FElements[AIndex] as Iz3DVertexElement;
end;

function Tz3DVertexFormat.GetElementCount: Integer;
begin
  Result:= FElements.Count;
end;

function Tz3DVertexFormat.GetUpdating: Boolean;
begin
  Result:= FUpdating;
end;

procedure Tz3DVertexFormat.RemoveElement(const AElement: Iz3DVertexElement);
begin
  FElements.Remove(AElement);
  if not Updating then
  begin
    CreateD3DFormat;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure Tz3DVertexFormat.SetElement(const AIndex: Integer; const Value: Iz3DVertexElement);
begin
  FElements[AIndex]:= Value;
  if not Updating then
  begin
    CreateD3DFormat;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure Tz3DVertexFormat.Apply;
begin
  if FAILED(z3DCore_GetD3DDevice.SetVertexDeclaration(FD3DFormat)) then
  z3DTrace('Iz3DVertexFormat.Apply failed: SetVertexDeclaration failed', z3dtkWarning);
end;

procedure Tz3DVertexFormat.z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller);
begin
  inherited;
  if ACaller <> z3ddocDestroyDevice then FD3DFormat:= nil;
end;

procedure Tz3DVertexFormat.z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller);
begin
  inherited;
  if ACaller <> z3dcocCreateDevice then CreateD3DFormat;
end;

procedure Tz3DVertexFormat.ClearElements;
begin
  FElements.Clear;
  if not Updating then
  begin
    CreateD3DFormat;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

function Tz3DVertexFormat.GetVertexSize: Integer;
begin
  Result:= FVertexSize;
end;

function Tz3DVertexFormat.GetDeclaration: PD3DVertexElement9;
var I, FOffset: Integer;
    FDecl: TD3DVertexElement9Array;
begin
  SetLength(FDecl, ElementCount+1);
  FOffset:= 0;

  // Build declaration array
  for I:= 0 to ElementCount-1 do
  begin
    FDecl[I].Stream:= Elements[I].Stream;
    FDecl[I].Offset:= FOffset;
    FDecl[I]._Type:= TD3DDeclType(Elements[I].Format);
    FDecl[I].Method:= TD3DDeclMethod(Elements[I].Method);
    FDecl[I].Usage:= TD3DDeclUsage(Elements[I].Usage);
    FDecl[I].UsageIndex:= Elements[I].UsageIndex;
    FOffset:= FOffset + Tz3DVertexElementFormatOffsets[Elements[I].Format];
  end;

  FVertexSize:= FOffset;

  // D3DDECL_END
  FDecl[ElementCount].Stream:= $FF;
  FDecl[ElementCount].Offset:= 0;
  FDecl[ElementCount]._Type:= D3DDECLTYPE_UNUSED;
  FDecl[ElementCount].Method:= TD3DDeclMethod(0);
  FDecl[ElementCount].Usage:= TD3DDeclUsage(0);
  FDecl[ElementCount].UsageIndex:= 0;
  Result:= Pointer(FDecl);
end;

function Tz3DVertexFormat.GetOnChange: Tz3DBaseObjectEvent;
begin
  Result:= FOnChange;
end;

procedure Tz3DVertexFormat.SetOnChange(const Value: Tz3DBaseObjectEvent);
begin
  FOnChange:= Value;
end;

function Tz3DVertexFormat.GetOnCreate: Tz3DBaseCallbackEvent;
begin
  Result:= FOnCreate;
end;

procedure Tz3DVertexFormat.SetOnCreate(const Value: Tz3DBaseCallbackEvent);
begin
  FOnCreate:= Value;
end;

function Tz3DVertexFormat.GetD3DDeclaration: IDirect3DVertexDeclaration9;
begin
  Result:= FD3DFormat; 
end;

{ Tz3DVertexBuffer }

constructor Tz3DVertexBuffer.Create(const AOwner: Iz3DBase = nil);
begin
  inherited;
  FUpdating:= False;
  FPool:= D3DPOOL_MANAGED;
  FUsage:= D3DUSAGE_WRITEONLY;
  FVertexCount:= 0;
  FPrimitiveKind:= z3dpkTriangleStrip;
  FFormat:= Tz3DVertexFormat.Create;
  FFormat.OnChange:= FormatChanged;

  // Link this object to the desired events generated by the z3D Engine
  Notifications:= [z3dlnDevice];
end;

procedure Tz3DVertexBuffer.BeginUpdate;
begin
  FUpdating:= True;
end;

procedure Tz3DVertexBuffer.CreateD3DBuffer(const AForce: Boolean);
begin
  if not z3DEngine.Device.Created then Exit;
  if FAILED(z3DCore_GetD3DDevice.CreateVertexBuffer(FVertexCount * FFormat.VertexSize, FUsage, 0, FPool, FD3DBuffer, nil)) then
  z3DTrace('Iz3DVertexBuffer.CreateD3DBuffer failed (could not create vertex buffer)', z3DtkWarning);
  case FPrimitiveKind of
    z3dpkPointList: FPrimitiveCount:= FVertexCount;
    z3dpkLineList: FPrimitiveCount:= FVertexCount div 2;
    z3dpkLineStrip: FPrimitiveCount:= FVertexCount - 1;
    z3dpkTriangleList: FPrimitiveCount:= FVertexCount div 3;
    z3dpkTriangleStrip: FPrimitiveCount:= Max(1, FVertexCount - 2);
    z3dpkTriangleFan: FPrimitiveCount:= Max(1, FVertexCount - 2);
  end;
  if Assigned(FOnCreate) then FOnCreate(Self);
end;

procedure Tz3DVertexBuffer.EndUpdate;
begin
  FUpdating:= False;
  CreateD3DBuffer;
end;

function Tz3DVertexBuffer.GetFormat: Iz3DVertexFormat;
begin
  Result:= FFormat;
end;

function Tz3DVertexBuffer.GetPool: TD3DPool;
begin
  Result:= FPool;
end;

function Tz3DVertexBuffer.GetUpdating: Boolean;
begin
  Result:= FUpdating;
end;

function Tz3DVertexBuffer.GetUsage: DWord;
begin
  Result:= FUsage;
end;

function Tz3DVertexBuffer.Lock(const AFlags: DWORD): Pointer;
begin
  if FAILED(FD3DBuffer.Lock(0, 0, Result, AFlags)) then
  begin
    z3DTrace('Iz3DVertexBuffer.Lock failed: Could not lock vertex buffer', z3DtkError);
    Exit;
  end;
end;

function Tz3DVertexBuffer.GetVertexCount: Integer;
begin
  Result:= FVertexCount;
end;

procedure Tz3DVertexBuffer.Unlock;
begin
  FD3DBuffer.Unlock;
end;

procedure Tz3DVertexBuffer.SetParams(const AVertexCount: Integer; const AUsage: DWord = D3DUSAGE_WRITEONLY;
  const APool: TD3DPool = D3DPOOL_MANAGED);
begin
  BeginUpdate;
  try
    FVertexCount:= AVertexCount;
    FUsage:= AUsage;
    FPool:= APool;
  finally
    EndUpdate;
  end;
end;

procedure Tz3DVertexBuffer.SetPool(const Value: TD3DPool);
begin
  FPool:= Value;
  if not Updating then CreateD3DBuffer;
end;

procedure Tz3DVertexBuffer.SetScenarioLevel(const Value: Boolean);
begin
  inherited;
  FFormat.ScenarioLevel:= Value;
end;

procedure Tz3DVertexBuffer.SetUsage(const Value: DWord);
begin
  FUsage:= Value;
  if not Updating then CreateD3DBuffer;
end;

procedure Tz3DVertexBuffer.FormatChanged(const ASender: Iz3DBase);
begin
  if not Updating then CreateD3DBuffer;
end;

procedure Tz3DVertexBuffer.Prepare;
begin
  FFormat.Apply;
  if Failed(z3DCore_GetD3DDevice.SetStreamSource(0, FD3DBuffer, 0, FFormat.VertexSize)) then
  z3DTrace('Iz3DVertexBuffer.Prepare failed (SetStreamSource failed)', z3DtkWarning);
end;

procedure Tz3DVertexBuffer.Render(const AStart: Integer = 0; ACount: Integer = -1);
var FCount: Integer;
begin
  if ACount = -1 then FCount:= PrimitiveCount else FCount:= ACount;
  if FAILED(z3DCore_GetD3DDevice.DrawPrimitive(TD3DPrimitiveType(FPrimitiveKind), AStart, FCount)) then
  z3DTrace('Iz3DVertexBuffer.Render failed (DrawPrimitive failed)', z3DtkWarning);
end;

procedure Tz3DVertexBuffer.Render(const AShader: Iz3DShader; const AStart: Integer; ACount: Integer);
var I: Integer;
begin
  for I:= 0 to AShader.Prepare - 1 do
  begin
    AShader.BeginPass;
    Render;
    AShader.EndPass;
  end;
end;

procedure Tz3DVertexBuffer.SetVertexCount(const Value: Integer);
begin
  FVertexCount:= Value;
  if not Updating then CreateD3DBuffer;
end;

procedure Tz3DVertexBuffer.z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller); 
begin
  inherited;
  case ACaller of
    z3dcocCreateDevice: if FPool = D3DPOOL_MANAGED then CreateD3DBuffer;
    z3dcocResetDevice: if FPool <> D3DPOOL_MANAGED then CreateD3DBuffer;
    z3dcocStartScenario: CreateD3DBuffer;
  end;
end;

procedure Tz3DVertexBuffer.z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller);
begin
  inherited;
  case ACaller of
    z3ddocDestroyDevice: if FPool = D3DPOOL_MANAGED then FD3DBuffer:= nil;
    z3ddocLostDevice: if FPool <> D3DPOOL_MANAGED then FD3DBuffer:= nil;
    z3ddocStopScenario: FD3DBuffer:= nil;
  end;
end;

function Tz3DVertexBuffer.GetPrimitiveKind: Tz3DPrimitiveKind;
begin
  Result:= FPrimitiveKind;
end;

procedure Tz3DVertexBuffer.SetPrimitiveKind(const Value: Tz3DPrimitiveKind);
begin
  FPrimitiveKind:= Value;
end;

function Tz3DVertexBuffer.GetPrimitiveCount: Integer;
begin
  Result:= FPrimitiveCount;
end;

function Tz3DVertexBuffer.GetOnCreate: Tz3DBaseCallbackEvent;
begin
  Result:= FOnCreate;
end;

procedure Tz3DVertexBuffer.SetOnCreate(const Value: Tz3DBaseCallbackEvent);
begin
  FOnCreate:= Value;
end;

function Tz3DVertexBuffer.GetD3DBuffer: IDirect3DVertexBuffer9;
begin
  Result:= FD3DBuffer;
end;

end.
