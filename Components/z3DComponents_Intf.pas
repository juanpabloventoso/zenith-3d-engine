{==============================================================================}
{== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==}
{==============================================================================}
{== Unit: z3DComponents. Zenith engine components                            ==}
{==============================================================================}

unit z3DComponents_Intf;

interface

uses
  Windows, Direct3D9, D3DX9, z3DClasses_Intf, z3DCore_Intf, z3DMath_Intf;

type

  Tz3DSurfaceAutoFormat = (z3dsafNone, z3dsafRenderer, z3dsafFP, z3dsafShadowMap);





{==============================================================================}
{== Effect interface                                                         ==}
{==============================================================================}
{== Implementation of vertex and pixel shaders using D3DX effect interface   ==}
{==============================================================================}

  Tz3DHandle = TD3DXHandle;

  Iz3DShader = interface;
  Iz3DBaseTexture = interface;

  Tz3DShaderRenderEvent = procedure(const ASender: Iz3DShader; const APass, APassCount: Integer); stdcall;

  Iz3DShader = interface(Iz3DLinked)['{2A5B78FB-2F5A-4B15-8C72-D15C05561900}']
    function GetColor(const AParam: Tz3DHandle): Iz3DFloat4; stdcall;
    function GetColor3(const AParam: Tz3DHandle): Iz3DFloat3; stdcall;
    procedure SetColor(const AParam: Tz3DHandle; const Value: Iz3DFloat4); stdcall;
    procedure SetColor3(const AParam: Tz3DHandle; const Value: Iz3DFloat3); stdcall;
    function GetTexture(const AParam: Tz3DHandle): Iz3DBaseTexture; stdcall;
    procedure SetTexture(const AParam: Tz3DHandle; const Value: Iz3DBaseTexture); stdcall;
    function GetMatrix(const AParam: Tz3DHandle): Iz3DMatrix; stdcall;
    function GetFloat2(const AParam: Tz3DHandle): Iz3DFloat2; stdcall;
    function GetFloat3(const AParam: Tz3DHandle): Iz3DFloat3; stdcall;
    function GetFloat4(const AParam: Tz3DHandle): Iz3DFloat4; stdcall;
    function GetOnCreate: Tz3DBaseCallbackEvent; stdcall;
    procedure SetOnCreate(const Value: Tz3DBaseCallbackEvent); stdcall;
    procedure SetMatrix(const AParam: Tz3DHandle; const Value: Iz3DMatrix); stdcall;
    procedure SetFloat2(const AParam: Tz3DHandle; const Value: Iz3DFloat2); stdcall;
    procedure SetFloat3(const AParam: Tz3DHandle; const Value: Iz3DFloat3); stdcall;
    procedure SetFloat4(const AParam: Tz3DHandle; const Value: Iz3DFloat4); stdcall;
    function GetTechnique: Tz3DHandle; stdcall;
    function GetD3DXEffect: ID3DXEffect; stdcall;
    procedure SetFileName(const Value: PWideChar); stdcall;
    procedure SetTechnique(const Value: Tz3DHandle); stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    function GetParam(const AParam: Tz3DHandle): Variant; stdcall;
    procedure SetParam(const AParam: Tz3DHandle; const Value: Variant); stdcall;
    function GetEnabled: Boolean; stdcall;
    function GetFileName: PWideChar; stdcall;
    function GetOnRender: Tz3DShaderRenderEvent; stdcall;
    procedure SetOnRender(const Value: Tz3DShaderRenderEvent); stdcall;
    function IsHandleValid(const AHandle: Tz3DHandle): Boolean; stdcall;
    procedure SetPointer(const AParam: Tz3DHandle; const AValue: Pointer; const ASize: Integer); stdcall;

    function Prepare(const AFlags: Cardinal = D3DXFX_DONOTSAVESTATE): Integer; stdcall;
    procedure BeginPass(const APassIndex: Integer = -1); stdcall;
    procedure EndPass; stdcall;
    procedure Draw(const AFlags: Cardinal = D3DXFX_DONOTSAVESTATE); stdcall;
    procedure DrawFullScreen(const AFlags: Cardinal = D3DXFX_DONOTSAVESTATE); stdcall;
    procedure Commit; stdcall;

    property D3DXEffect: ID3DXEffect read GetD3DXEffect;
    property Param[const AParam: Tz3DHandle]: Variant read GetParam write SetParam;
    property Float2[const AParam: Tz3DHandle]: Iz3DFloat2 read GetFloat2 write SetFloat2;
    property Float3[const AParam: Tz3DHandle]: Iz3DFloat3 read GetFloat3 write SetFloat3;
    property Float4[const AParam: Tz3DHandle]: Iz3DFloat4 read GetFloat4 write SetFloat4;
    property Color3[const AParam: Tz3DHandle]: Iz3DFloat3 read GetColor3 write SetColor3;
    property Color[const AParam: Tz3DHandle]: Iz3DFloat4 read GetColor write SetColor;
    property Matrix[const AParam: Tz3DHandle]: Iz3DMatrix read GetMatrix write SetMatrix;
    property Texture[const AParam: Tz3DHandle]: Iz3DBaseTexture read GetTexture write SetTexture;
    property Enabled: Boolean read GetEnabled write SetEnabled;
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

  Tz3DSamplerAddressMode = (z3dsamWrap, z3dsamMirror, z3dsamClamp, z3dsamBorder,
    z3dsamMirrorClamp);

  Tz3DSamplerFilter = (z3dsfNone, z3dsfLinear, z3dsfBilinear, z3dsfTrilinear,
    z3dsfAnisotropic);

  Pz3DSamplerState = ^Tz3DSamplerState;
  Tz3DSamplerState = packed record
    AddressMode: Tz3DSamplerAddressMode;
    BorderColor: Iz3DFloat3;
    Filter: Tz3DSamplerFilter;
    MaxAnisotropy: Integer;
  end;

  Tz3DSamplerStates = array[0..7] of Tz3DSamplerState;

  Iz3DSurface = interface;

  Tz3DTextureSource = (z3dtsFileName, z3dtsNew);

  Iz3DBaseTexture = interface(Iz3DLinked)['{C7EF52D0-0802-4C73-AD12-94087D4BD1C9}']
    function GetSamplerState: Pz3DSamplerState; stdcall;
    function GetOnCreate: Tz3DBaseCallbackEvent; stdcall;
    procedure SetOnCreate(const Value: Tz3DBaseCallbackEvent); stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    function GetAutoGenerateMipMaps: Boolean; stdcall;
    procedure SetAutoGenerateMipMaps(const Value: Boolean); stdcall;
    function GetFileName: PWideChar; stdcall;
    function GetSource: Tz3DTextureSource; stdcall;
    procedure SetFileName(const Value: PWideChar); stdcall;
    procedure SetSource(const Value: Tz3DTextureSource); stdcall;
    function GetPool: TD3DPool; stdcall;
    procedure SetPool(const Value: TD3DPool); stdcall;
    function GetUsage: DWord; stdcall;
    procedure SetUsage(const Value: DWord); stdcall;
    function GetLevelCount: Integer; stdcall;
    function GetD3DBaseTexture: IDirect3DBaseTexture9; stdcall;
    procedure SetD3DBaseTexture(const Value: IDirect3DBaseTexture9); stdcall;
    procedure SetLevelCount(const Value: Integer); stdcall;
    function GetFormat: TD3DFormat; stdcall;
    procedure SetFormat(const Value: TD3DFormat); stdcall;
    function From(const ATexture: IDirect3DBaseTexture9): Iz3DBaseTexture; stdcall;
    procedure AttachToSampler(const AIndex: Integer; const ASetAddress: Boolean = False;
      const ASetFilter: Boolean = False); stdcall;
    procedure GenerateMipMaps; stdcall;
    procedure CreateD3DTexture; stdcall;

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

  Iz3DTexture = interface(Iz3DBaseTexture)['{A768B280-C0C5-414D-8C9A-25F7263426AF}']
    procedure SetD3DTexture(const Value: IDirect3DTexture9); stdcall;
    function GetLockedRect: TD3DLockedRect; stdcall;
    function GetD3DTexture: IDirect3DTexture9; stdcall;
    function GetFormat: TD3DFormat; stdcall;
    function GetHeight: Integer; stdcall;
    function GetWidth: Integer; stdcall;
    function GetSurface: Iz3DSurface; stdcall;
    procedure SetFormat(const Value: TD3DFormat); stdcall;
    procedure SetHeight(const Value: Integer); stdcall;
    procedure SetWidth(const Value: Integer); stdcall;
    procedure SetParams(const AWidth: Integer = -1; const AHeight: Integer = -1; const ALevels: Integer = -1;
      const AFormat: TD3DFormat = D3DFMT_UNKNOWN; const APool: TD3DPool = D3DPOOL_MANAGED); stdcall;
    procedure BeginDraw(const ALevel: Integer = 0; const AFlags: Cardinal = 0); stdcall;
    procedure EndDraw(const ALevel: Integer = 0); stdcall;
    function GetPixel(const AX, AY: Integer): Iz3DFloat4; stdcall;
    procedure SetPixel(const AX, AY: Integer; const AColor: Iz3DFloat3); overload; stdcall;
    procedure SetPixel(const AX, AY: Integer; const AColor: Iz3DFloat4); overload; stdcall;
    procedure Fill(const AColor: Iz3DFloat4); stdcall;

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

  Iz3DRenderTexture = interface(Iz3DTexture)['{442A4B00-14EA-418E-B4CA-0E617F94E690}']
    function GetAutoFormat: Tz3DSurfaceAutoFormat; stdcall;
    procedure SetAutoFormat(const Value: Tz3DSurfaceAutoFormat); stdcall;
    function GetAutoParams: Boolean; stdcall;
    function GetAutoHeightFactor: Single; stdcall;
    function GetAutoWidthFactor: Single; stdcall;
    procedure SetAutoParams(const Value: Boolean); stdcall;
    procedure SetAutoHeightFactor(const Value: Single); stdcall;
    procedure SetAutoWidthFactor(const Value: Single); stdcall;

    procedure SetRenderTarget(const AIndex: Integer = 0; const ASave: Boolean = False); stdcall;
    procedure RestoreRenderTarget; stdcall;

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

  Iz3DCubeTexture = interface(Iz3DBaseTexture)['{5AE5261D-6217-4E04-8DA5-17068EC2A933}']
    function GetSize: Integer; stdcall;
    procedure SetSize(const Value: Integer); stdcall;
    function GetD3DCubeTexture: IDirect3DCubeTexture9; stdcall;
    function GetSurface(const AFace: TD3DCubemapFaces): Iz3DSurface; stdcall;
    procedure Fill(const AColor: Iz3DFloat4); stdcall;
    procedure SetCubeParams(const ASize: Integer = -1; const ALevels: Integer = -1;
      const AFormat: TD3DFormat = D3DFMT_UNKNOWN; const APool: TD3DPool = D3DPOOL_MANAGED); stdcall;

    property D3DCubeTexture: IDirect3DCubeTexture9 read GetD3DCubeTexture;
    property Size: Integer read GetSize write SetSize;
  end;





{==============================================================================}
{== Cube render texture interface                                            ==}
{==============================================================================}
{== Cube texture that can be used as a render target                         ==}
{==============================================================================}

  Iz3DCubeRenderTexture = interface(Iz3DCubeTexture)['{39F771B1-CEBC-403A-83AA-204D1AA81D8A}']
    procedure SetRenderTarget(const AFace: TD3DCubemapFaces = D3DCUBEMAP_FACE_POSITIVE_X; const ASave: Boolean = False); stdcall;
    procedure RestoreRenderTarget; stdcall;
  end;






{==============================================================================}
{== Material texture interface                                               ==}
{==============================================================================}
{== Extension of the texture interface that stores or generates a normal map ==}
{==============================================================================}

  Iz3DMaterialTexture = interface(Iz3DTexture)['{90967713-4355-4E8A-8DB9-19EC663C609C}']
    function GetAutoGenerateNormalMap: Boolean; stdcall;
    procedure SetAutoGenerateNormalMap(const Value: Boolean); stdcall;
    function GetEnableNormalMap: Boolean; stdcall;
    function GetNormalMapFactor: Single; stdcall;
    function GetNormalMapTexture: Iz3DTexture; stdcall;
    procedure SetEnableNormalMap(const Value: Boolean); stdcall;
    procedure SetNormalMapFactor(const Value: Single); stdcall;

    procedure GenerateNormalMap; stdcall;

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

  Iz3DSurface = interface(Iz3DLinked)['{A44A32D6-4959-483A-B02F-BBD3499350B2}']
    function GetHeight: Integer; stdcall;
    function GetWidth: Integer; stdcall;
    function GetD3DSurface: IDirect3DSurface9; stdcall;
    procedure SetD3DSurface(const Value: IDirect3DSurface9); stdcall;
    procedure SetRenderTarget(const AIndex: Integer = 0; const ASave: Boolean = False); stdcall;
    procedure RestoreRenderTarget; stdcall;
    function From(const ASurface: IDirect3DSurface9): Iz3DSurface; overload; stdcall;
    function From(const ASurface: Iz3DSurface): Iz3DSurface; overload; stdcall;
    function From(const ATexture: Iz3DTexture): Iz3DSurface; overload; stdcall;
    procedure BeginDraw(const AFlags: Cardinal = 0); stdcall;
    procedure EndDraw; stdcall;
    function GetPixel(const AX, AY: Integer): Iz3DFloat4; stdcall;
    procedure SetPixel(const AX, AY: Integer; const AColor: Iz3DFloat3); overload; stdcall;
    procedure SetPixel(const AX, AY: Integer; const AColor: Iz3DFloat4); overload; stdcall;

    property D3DSurface: IDirect3DSurface9 read GetD3DSurface write SetD3DSurface;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
  end;






{==============================================================================}
{== Depth/stencil buffer interface                                           ==}
{==============================================================================}
{== Implementation of depth stencil surfaces for rendering                   ==}
{==============================================================================}

  Iz3DDepthBuffer = interface(Iz3DSurface)['{273C8EBD-F429-4119-8DD9-5D1153FD9835}']
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
    procedure SetParams(const AWidth: Integer = -1; const AHeight: Integer = -1; const AFormat: TD3DFormat = D3DFMT_UNKNOWN;
    const AMultiSample: TD3DMultiSampleType = D3DMULTISAMPLE_NONE; const AMSQuality: DWORD = 0; const ADiscard: Boolean = True); stdcall;

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

  Iz3DVertexFormat = interface;

  Tz3DVertexElementFormat = (z3dvefFloat, z3dvefFloat2, z3dvefFloat3, z3dvefFloat4,
    z3dvefColor, z3dvefUByte4, z3dvefShort2, z3dvefShort4, z3dvefUByte4N, z3dvefUByte2N,
    z3dvefShort2N, z3dvefShort4N, z3dvefUDec3, z3dvefDec3N, z3dvefFloat16_2, z3dvefFloat16_4,
    z3dvefUnused);

  Tz3DVertexElementMethod = (z3dvemDefault, z3dvemPartialU, z3dvemPartialV,
    z3dvemCrossUV, z3dvemUV, z3dvemLookup, z3dvemLookupPresampled);

  Tz3DVertexElementUsage = (z3dveuPosition, z3dveuBlendWeight, z3dveuBlendIndices,
    z3dveuNormal, z3dveuPSize, z3dveuTexCoord, z3dveuTangent, z3dveuBinormal, z3dveuTessFactor,
    z3dveuTransformedPosition, z3dveuColor, z3dveuFog, z3dveuDepth, z3dveuSample);

  Iz3DVertexElement = interface(Iz3DBase)['{EB3FC990-4240-4A43-AB36-AB446238A563}']
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

    property Stream: Integer read GetStream write SetStream;
    property Format: Tz3DVertexElementFormat read GetFormat write SetFormat;
    property Method: Tz3DVertexElementMethod read GetMethod write SetMethod;
    property Usage: Tz3DVertexElementUsage read GetUsage write SetUsage;
    property UsageIndex: Integer read GetUsageIndex write SetUsageIndex;
  end;

  TD3DVertexElement9Array = array of TD3DVertexElement9;

  Iz3DVertexFormat = interface(Iz3DLinked)['{0E0D2431-9FC5-4E36-8160-84CB977F7A68}']
    function GetOnCreate: Tz3DBaseCallbackEvent; stdcall;
    procedure SetOnCreate(const Value: Tz3DBaseCallbackEvent); stdcall;
    function GetOnChange: Tz3DBaseObjectEvent; stdcall;
    procedure SetOnChange(const Value: Tz3DBaseObjectEvent); stdcall;
    function GetVertexSize: Integer; stdcall;
    function GetUpdating: Boolean; stdcall;
    function GetElement(const AIndex: Integer): Iz3DVertexElement; stdcall;
    function GetElementCount: Integer; stdcall;
    procedure SetElement(const AIndex: Integer; const Value: Iz3DVertexElement); stdcall;

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

  Tz3DPrimitiveKind = (z3dpkReserved, z3dpkPointList, z3dpkLineList, z3dpkLineStrip, z3dpkTriangleList,
    z3dpkTriangleStrip, z3dpkTriangleFan);


  Iz3DVertexBuffer = interface(Iz3DLinked)['{16B7E530-1117-4317-9E48-421BA30E8160}']
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

    procedure BeginUpdate; stdcall;
    procedure EndUpdate; stdcall;
    function Lock(const AFlags: DWORD = 0): Pointer; stdcall;
    procedure Unlock; stdcall;
    procedure SetParams(const AVertexCount: Integer; const AUsage: DWord = D3DUSAGE_WRITEONLY;
      const APool: TD3DPool = D3DPOOL_MANAGED); stdcall;
    procedure CreateD3DBuffer(const AForce: Boolean = False); stdcall;
    procedure Prepare; stdcall;
    procedure Render(const AStart: Integer = 0; ACount: Integer = -1); overload; stdcall;
    procedure Render(const AShader: Iz3DShader; const AStart: Integer = 0; ACount: Integer = -1); overload; stdcall;

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

implementation

end.
