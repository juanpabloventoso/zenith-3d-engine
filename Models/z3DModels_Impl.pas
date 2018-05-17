{==============================================================================}
{== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==}
{==============================================================================}
{== Unit: z3DModels. Model interface support and instance management         ==}
{==============================================================================}

unit z3DModels_Impl;

interface

uses
  Windows, SysUtils, Classes, Direct3D9, D3DX9, z3DClasses_Impl,
  z3DComponents_Intf, z3DModels_Intf, z3DScenario_Intf, z3DMath_Intf,
  z3DScenarioClasses, z3DLighting_Intf, z3DClasses_Intf, z3DFileSystem_Intf;

{==============================================================================}
{== 3DS file compatibility                                                   ==}
{==============================================================================}
{== Reads a 3DS file and converts it into a D3DX Mesh object                 ==}
{==============================================================================}

const

  MAX3DS_ID_HEADER          = $4D4D; // File header
  MAX3DS_ID_OBJECTINFO      = $3D3D; // Object information
  MAX3DS_ID_VERSION         = $0002; // File version
  MAX3DS_ID_SCALE           = $0100; // Scale
  MAX3DS_ID_MESH_VERSION    = $3D3E; // Mesh version

  MAX3DS_ID_OBJECT          = $4000; // Object
  MAX3DS_ID_OBJECT_MESH     = $4100; // Mesh
  MAX3DS_ID_OBJECT_VERTICES = $4110; // Mesh vertices
  MAX3DS_ID_OBJECT_FACES    = $4120; // Mesh faces
  MAX3DS_ID_OBJECT_MATERIAL = $4130; // Mesh material
  MAX3DS_ID_OBJECT_UV       = $4140; // Mesh texture coords
  MAX3DS_ID_OBJECT_MATRIX   = $4160; // Object transform
  MAX3DS_ID_OBJECT_PIVOT    = $B020; // Object pivot

  MAX3DS_ID_LIGHT           = $4600; // Scene light
  MAX3DS_ID_CAMERA          = $4700; // Camera information
  MAX3DS_ID_MATERIAL        = $AFFF; // Material information

  MAX3DS_ID_KEYFRAME        = $B000; // Keyframe
  MAX3DS_ID_KEYFRAME_OBJECT = $B002; // Keyframe object

  MAX3DS_ID_COLOR           = $0010; // Color
  MAX3DS_ID_LIGHT_RANGE     = $465A; // Light range

  MAX3DS_MAXVERTICES        = 65536; // Max vertices

  // 3DS loaded object vertex declaration (float3 POSITION, float2 TEXCOORD0)
  Tz3D3DSObjectVD: array [0..2] of TD3DVertexElement9 =
  (
    (Stream: 0;   Offset: 0;  _Type: D3DDECLTYPE_FLOAT3; Method: D3DDECLMETHOD_DEFAULT; Usage: D3DDECLUSAGE_POSITION; UsageIndex: 0),
    (Stream: 0;   Offset: 12; _Type: D3DDECLTYPE_FLOAT2; Method: D3DDECLMETHOD_DEFAULT; Usage: D3DDECLUSAGE_TEXCOORD; UsageIndex: 0),
    (Stream: $FF; Offset: 0;  _Type: D3DDECLTYPE_UNUSED; Method: TD3DDeclMethod(0);     Usage: TD3DDeclUsage(0);      UsageIndex: 0)
  );

type

  // 3DS loaded object vertex struct
  Pz3D3DSObjectVertex = ^Tz3D3DSObjectVertex;
  Tz3D3DSObjectVertex = packed record
    Position: TD3DXVector3;
    TexCoord: TD3DXVector2;
  end;
  Pz3D3DSObjectVertexArray = ^Tz3D3DSObjectVertexArray;
  Tz3D3DSObjectVertexArray = array[0..MaxInt div SizeOf(Tz3D3DSObjectVertex)-1] of Tz3D3DSObjectVertex;

  T3DSFaceIndices = array[0..3] of Word;

  Pz3D3DSFile = ^Tz3D3DSFile;

  // 3DS file chunk object
  Pz3D3DSFileChunk = ^Tz3D3DSFileChunk;
  Tz3D3DSFileChunk = object
    ID: Word;
    Length: LongWord;
    Start: LongWord;
    SubChunks: array of Pz3D3DSFileChunk;
    Data: Pz3D3DSFile;

    function NewSubChunk: Integer;
    procedure Read(var AStream: TStream);

    destructor Destroy;
  end;

  // 3DS file mesh object
  Tz3D3DSMeshObject = class
    NumVerts: Cardinal;
    NumFaces: Cardinal;
    NumCoords: Cardinal;
    NumNormals: Cardinal;
    HasCoords: Boolean;
    BBMin, BBMax: TD3DXVector3;

    Faces: array of T3DSFaceIndices;
    Coords: array of TD3DXVector2;
    Vertices: array of TD3DXVector3;

    procedure ComputeBounds;
  end;

  // 3DS file object
  Tz3D3DSFile = object
    Chunk: Pz3D3DSFileChunk;
    MeshCount: Cardinal;
    Meshes: array of Tz3D3DSMeshObject;
    BBMin, BBMax: TD3DXVector3;

    function Load(const AFileName: string): ID3DXMesh;

    procedure Clear;
    procedure ComputeBounds;
    procedure CenterVertices;
  end;


{==============================================================================}
{== Model controller interface                                               ==}
{==============================================================================}
{== Global controller and manager for models                                 ==}
{==============================================================================}

const
  ALPHA_UPPER_BOUND = 0.9999;

type

  Tz3DModelController = class(Tz3DLinked, Iz3DModelController)
  private
    FStaticModels: IInterfaceList;
    FDynamicModels: IInterfaceList;
    FStaticRenderOrder: Tz3DModelRenderOrder;
    FDynamicRenderOrder: Tz3DModelRenderOrder;
    FStaticModelVertexFormat: Iz3DVertexFormat;
    FDynamicModelVertexFormat: Iz3DVertexFormat;
    FElapsedTime: Single;
    FModelFormat: Iz3DObjectFileFormat;
    FWaitingGPUProcessStaticLighting: Boolean;

    FAnyVisibleInstance: Boolean;
    FAnyVisibleStaticInstance: Boolean;
    FAnyVisibleDynamicInstance: Boolean;
    FAnyVisibleOpaqueInstance: Boolean;
    FAnyVisibleTranslucentInstance: Boolean;
    FAnyVisibleOpaqueStaticInstance: Boolean;
    FAnyVisibleOpaqueDynamicInstance: Boolean;
    FAnyVisibleTranslucentStaticInstance: Boolean;
    FAnyVisibleTranslucentDynamicInstance: Boolean;
  protected
    function GetModelFormat: Iz3DObjectFileFormat; stdcall;
    function GetDynamicVertexFormat: Iz3DVertexFormat; stdcall;
    function GetStaticVertexFormat: Iz3DVertexFormat; stdcall;
    function GetDynamicModelList: IInterfaceList; stdcall;
    function GetStaticModelList: IInterfaceList; stdcall;
    function GetStaticRenderOrder: Tz3DModelRenderOrder; stdcall;
    function GetDynamicRenderOrder: Tz3DModelRenderOrder; stdcall;
    function GetStaticModelCount: Integer; stdcall;
    function GetDynamicModelCount: Integer; stdcall;
    function GetStaticModel(const AIndex: Integer): Iz3DStaticModel; stdcall;
    procedure SetStaticModel(const AIndex: Integer; const Value: Iz3DStaticModel); stdcall;
    function GetDynamicModel(const AIndex: Integer): Iz3DDynamicModel; stdcall;
    procedure SetDynamicModel(const AIndex: Integer; const Value: Iz3DDynamicModel); stdcall;
    procedure z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller); override; stdcall;
    procedure z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller); override; stdcall;
    procedure z3DDirectLightRender; override; stdcall;
    procedure z3DFrameMove; override; stdcall;
    procedure z3DFrameRender; override; stdcall;
    procedure z3DLightingRender; override; stdcall;
    procedure z3DStartScenario(const AStage: Tz3DStartScenarioStage); override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    function CreateStaticModel: Iz3DStaticModel; stdcall;
    function CreateHeightMappedModel: Iz3DHeightMappedModel; stdcall;
    function CreateDynamicModel: Iz3DDynamicModel; stdcall;
    function CreateWaterModel: Iz3DWaterModel; stdcall;
    procedure AddModel(const AModel: Iz3DModel); stdcall;
    procedure RemoveModel(const AModel: Iz3DModel); stdcall;
    procedure SortByDepth(const AModels: IInterfaceList; var AOrder: Tz3DModelRenderOrder); stdcall;
    procedure BuildStaticRenderOrder; stdcall;
    procedure BuildDynamicRenderOrder; stdcall;
    procedure BuildVertexFormats; stdcall;
    procedure ProcessStaticLighting; stdcall;
    procedure CreateScenarioObjects; stdcall;
    procedure BuildRenderOrders; stdcall;
    procedure DestroyScenarioObjects; stdcall;
    procedure BuildRenderOrder(const AModels: IInterfaceList; var AOrder: Tz3DModelRenderOrder); stdcall;
  public
    property ModelFormat: Iz3DObjectFileFormat read GetModelFormat;
    property StaticModels[const AIndex: Integer]: Iz3DStaticModel read GetStaticModel write SetStaticModel;
    property DynamicModels[const AIndex: Integer]: Iz3DDynamicModel read GetDynamicModel write SetDynamicModel;
    property StaticRenderOrder: Tz3DModelRenderOrder read GetStaticRenderOrder;
    property DynamicRenderOrder: Tz3DModelRenderOrder read GetDynamicRenderOrder;
    property StaticModelCount: Integer read GetStaticModelCount;
    property DynamicModelCount: Integer read GetDynamicModelCount;
    property StaticVertexFormat: Iz3DVertexFormat read GetStaticVertexFormat;
    property DynamicVertexFormat: Iz3DVertexFormat read GetDynamicVertexFormat;
    property StaticModelList: IInterfaceList read GetStaticModelList;
    property DynamicModelList: IInterfaceList read GetDynamicModelList;
  end;






{==============================================================================}
{== Model subset interface                                                   ==}
{==============================================================================}
{== Extension of world subset with exclusive methods for models              ==}
{==============================================================================}

  Tz3DModelSubset = class(Tz3DScenarioObjectSubset, Iz3DModelSubset)
  private
    FModel: Iz3DModel;
  public
    constructor Create(const AOwner: Iz3DBase); override;
  end;






{==============================================================================}
{== Model interface                                                          ==}
{==============================================================================}
{== Manages a mesh and prepares it for renderization                         ==}
{==============================================================================}

  Tz3DModel = class(Tz3DBase, Iz3DModel)
  private
    FBoundingBox: Iz3DBoundingBox;
    FOSBoundingBox: Iz3DBoundingBox;
    FAutoGenerateTexCoords: Boolean;
    FOSBoundingSphere: Iz3DBoundingSphere;
    FBoundingSphere: Iz3DBoundingSphere;
    FScale: Iz3DFloat3;
    FFaceCount: Integer;
    FBytesPerVertex: Integer;
    FFileName: PWideChar;
    FName: PWideChar;
    FInstancingMethod: Tz3DModelInstancingMethod;
    FLockAspectRatio: Boolean;
    FLockTexCoordsAspectRatio: Boolean;
    FShape: Tz3DScenarioObjectShape;
    FSubsets: IInterfaceList;
    FTexCoordsScale: Single;
    FVertexCount: Integer;
    FInstances: IInterfaceList;
    FMesh: ID3DXMesh;
    FLODMeshes: Tz3DLODMeshes;
    FComputeLightCoords: Boolean;
    FLockLOD: Tz3DScenarioObjectLOD;
    FGenerateLODMeshes: Boolean;
  protected
    function GetGenerateLODMeshes: Boolean; stdcall;
    procedure SetGenerateLODMeshes(const Value: Boolean); stdcall;
    function GetLODFaceCount(const ALOD: Tz3DScenarioObjectLOD): Integer; stdcall;
    function GetLODVertexCount(const ALOD: Tz3DScenarioObjectLOD): Integer; stdcall;
    function GetVertexFormat: Iz3DVertexFormat; stdcall;
    function GetName: PWideChar; stdcall;
    procedure SetName(const Value: PWideChar); stdcall;
    function GetComputeLightCoords: Boolean; stdcall;
    procedure SetComputeLightCoords(const Value: Boolean); stdcall;
    function GetLODMeshes: Tz3DLODMeshes; stdcall;
    function GetMesh: ID3DXMesh; stdcall;
    procedure SetFileName(const Value: PWideChar); stdcall;
    function GetInstanceList: IInterfaceList; stdcall;
    function GetSubsetList: IInterfaceList; stdcall;
    function GetInstanceCount: Integer; stdcall;
    function GetOSBoundingBox: Iz3DBoundingBox; stdcall;
    function GetOSBoundingSphere: Iz3DBoundingSphere; stdcall;
    function GetScale: Iz3DFloat3; stdcall;
    function GetBytesPerVertex: Integer; stdcall;
    function GetInstance(const AIndex: Integer): Iz3DModelInstance; stdcall;
    function GetBoundingBox: Iz3DBoundingBox; stdcall;
    function GetAutoGenerateTexCoords: Boolean; stdcall;
    function GetBoundingSphere: Iz3DBoundingSphere; stdcall;
    function GetFaceCount: Integer; stdcall;
    function GetFileName: PWideChar; stdcall;
    function GetInstancingMethod: Tz3DModelInstancingMethod; stdcall;
    function GetLockAspectRatio: Boolean; stdcall;
    function GetLockTexCoordsAspectRatio: Boolean; stdcall;
    function GetShape: Tz3DScenarioObjectShape; stdcall;
    function GetSubsetCount: Integer; stdcall;
    function GetSubsets(const I: Integer): Iz3DModelSubset; stdcall;
    function GetTexCoordsScale: Single; stdcall;
    function GetVertexCount: Integer; stdcall;
    procedure SetAutoGenerateTexCoords(const Value: Boolean); stdcall;
    procedure SetInstancingMethod(const Value: Tz3DModelInstancingMethod); stdcall;
    procedure SetLockAspectRatio(const Value: Boolean); stdcall;
    procedure SetLockTexCoordsAspectRatio(const Value: Boolean); stdcall;
    procedure SetShape(const Value: Tz3DScenarioObjectShape); stdcall;
    procedure SetTexCoordsScale(const Value: Single); stdcall;
    procedure Init(const AOwner: Iz3DBase); override; stdcall;
  public
    function LockVertices(const AFlags: DWORD = 0): Pointer; stdcall;
    procedure UnlockVertices; stdcall;
    function LockLODVertices(const ALOD: Tz3DScenarioObjectLOD; const AFlags: DWORD = 0): Pointer; stdcall;
    procedure UnlockLODVertices; stdcall;
    function LockIndices(const AFlags: DWORD = 0): PWordArray; stdcall;
    procedure UnlockIndices; stdcall;
    function LockLODIndices(const ALOD: Tz3DScenarioObjectLOD; const AFlags: DWORD = 0): PWordArray; stdcall;
    procedure UnlockLODIndices; stdcall;
    procedure CreateModel; virtual; stdcall;
    procedure CreateMesh(const AMeshFileName: PWideChar); stdcall;
    procedure CreateSubsets(const AD3DXMtrls: PD3DXMaterial; const ACount: Integer); stdcall;

    function AddSubset: Iz3DModelSubset; stdcall;
    procedure RemoveSubset(const ASubset: Iz3DModelSubset); stdcall;
    procedure RemoveInstance(const AInstance: Iz3DModelInstance); stdcall;

    procedure CreateLODMeshes; stdcall;
    procedure GenerateTexCoords; stdcall;
    procedure SetDeclaration(const ADeclaration: PD3DVertexElement9); stdcall;
    procedure ComputeBounds; virtual; stdcall;
    procedure CreateScenarioObjects; stdcall;
    procedure DestroyScenarioObjects; stdcall;
    procedure FrameMove; virtual; stdcall;
    procedure FrameRender; virtual; stdcall;
    procedure FrameRenderAmbient; virtual; stdcall;
    procedure FrameRenderDirectLighting; virtual; stdcall;
    procedure RenderMesh(const AShader: Iz3DShader; const ALOD: Tz3DScenarioObjectLOD = z3dsolHigh;
      const ASetMaterial: Boolean = True; const ADirectLighting: Boolean = True;
      const ALightMap: Boolean = False); virtual; stdcall;
    procedure PrepareMesh(const AShader: Iz3DShader; const ASetMaterial: Boolean = True;
      const ADirectLighting: Boolean = True); stdcall;
    function IndexOf(const AInstance: Iz3DModelInstance): Integer; stdcall;

    procedure LoadFromFile(const AFileName: PWideChar); stdcall;
    procedure SaveToFile(const AFileName: PWideChar); stdcall;
  public
    property VertexCount: Integer read GetVertexCount;
    property BytesPerVertex: Integer read GetBytesPerVertex;
    property FaceCount: Integer read GetFaceCount;
    property LODFaceCount[const ALOD: Tz3DScenarioObjectLOD]: Integer read GetLODFaceCount;
    property LODVertexCount[const ALOD: Tz3DScenarioObjectLOD]: Integer read GetLODVertexCount;
    property OSBoundingSphere: Iz3DBoundingSphere read GetOSBoundingSphere;
    property OSBoundingBox: Iz3DBoundingBox read GetOSBoundingBox;
    property Subsets[const I: Integer]: Iz3DModelSubset read GetSubsets;
    property SubsetCount: Integer read GetSubsetCount;
    property Instances[const AIndex: Integer]: Iz3DModelInstance read GetInstance;
    property InstanceCount: Integer read GetInstanceCount;
    property FileName: PWideChar read GetFileName write SetFileName;
    property Mesh: ID3DXMesh read GetMesh;
    property LODMeshes: Tz3DLODMeshes read GetLODMeshes;
    property ComputeLightCoords: Boolean read GetComputeLightCoords write SetComputeLightCoords;
    property Name: PWideChar read GetName write SetName;
    property VertexFormat: Iz3DVertexFormat read GetVertexFormat;
    property Shape: Tz3DScenarioObjectShape read GetShape write SetShape;
    property Scale: Iz3DFloat3 read GetScale;
    property BoundingSphere: Iz3DBoundingSphere read GetBoundingSphere;
    property BoundingBox: Iz3DBoundingBox read GetBoundingBox;
    property LockAspectRatio: Boolean read GetLockAspectRatio write SetLockAspectRatio;
    property InstancingMethod: Tz3DModelInstancingMethod read GetInstancingMethod write SetInstancingMethod;
    property AutoGenerateTexCoords: Boolean read GetAutoGenerateTexCoords write SetAutoGenerateTexCoords;
    property LockTexCoordsAspectRatio: Boolean read GetLockTexCoordsAspectRatio write SetLockTexCoordsAspectRatio;
    property TexCoordsScale: Single read GetTexCoordsScale write SetTexCoordsScale;
    property GenerateLODMeshes: Boolean read GetGenerateLODMeshes write SetGenerateLODMeshes;
    property InstanceList: IInterfaceList read GetInstanceList;
    property SubsetList: IInterfaceList read GetSubsetList;
  end;




{==============================================================================}
{== Static model interface                                                   ==}
{==============================================================================}
{== Adds lightmap support for a model                                        ==}
{==============================================================================}

  Tz3DStaticModel = class(Tz3DModel, Iz3DStaticModel)
  protected
    procedure Init(const AOwner: Iz3DBase); override; stdcall;
  public
    function CreateInstance: Iz3DModelStaticInstance; stdcall;
    function ProcessStaticLighting(const AStage: Tz3DModelLightMapProcessStage): Boolean; stdcall;
  end;







  Tz3DHeightMappedModel = class(Tz3DStaticModel, Iz3DHeightMappedModel)
  private
    FHorizontal: Boolean;
    FResolution: Single;
    FSmoothFactor: Single;
    FHeightMap: Iz3DTexture;
  protected
    function GetHorizontal: Boolean; stdcall;
    function GetResolution: Single; stdcall;
    function GetSmoothFactor: Single; stdcall;
    procedure SetHorizontal(const Value: Boolean); stdcall;
    procedure SetResolution(const Value: Single); stdcall;
    procedure SetSmoothFactor(const Value: Single); stdcall;
  public
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
    procedure CreateModel; override; stdcall;
  public
    property Horizontal: Boolean read GetHorizontal write SetHorizontal;
    property Resolution: Single read GetResolution write SetResolution;
    property SmoothFactor: Single read GetSmoothFactor write SetSmoothFactor;
  end;

  Tz3DWaterModel = class(Tz3DStaticModel, Iz3DWaterModel)
  private
  protected
  public
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
    procedure CreateModel; override; stdcall;
  public
  end;


{==============================================================================}
{== Dynamic model interface                                                  ==}
{==============================================================================}
{== Prepares the model for interacting with world phyiscs                    ==}
{==============================================================================}

  Tz3DDynamicModel = class(Tz3DModel, Iz3DDynamicModel)
  protected
    procedure Init(const AOwner: Iz3DBase); override; stdcall;
  public
    function CreateInstance: Iz3DModelDynamicInstance; stdcall;
  end;






{==============================================================================}
{== Model isntance nterface                                                  ==}
{==============================================================================}
{== Implements a world object and represents a version of the model on       ==}
{== the world                                                                ==}
{==============================================================================}

  Tz3DModelInstance = class(Tz3DScenarioObject, Iz3DModelInstance)
  private
    FInCameraEnvironment: Boolean;
    FEnableShadows: Boolean;
    FLookAt: Iz3DFloat3;
    FModel: Iz3DModel;
    FWorldMatrix, FWorldViewMatrix, FWorldViewProjMatrix: Iz3DMatrix;
    FCustomBoundingBox: Iz3DBoundingBox;
    FCustomBoundingSphere: Iz3DBoundingSphere;
    FCustomScale: Iz3DFloat3;
    FUpdating: Boolean;
  protected
    function GetCustomScale: Iz3DFloat3; stdcall;
    function GetCustomBoundingBox: Iz3DBoundingBox; stdcall;
    function GetCustomBoundingSphere: Iz3DBoundingSphere; stdcall;
    function GetInstanceIndex: Integer; stdcall;
    function GetWorldMatrix: Iz3DMatrix; stdcall;
    function GetModel: Iz3DModel; stdcall;
    function GetEnableShadows: Boolean; stdcall;
    function GetLookAt: Iz3DFloat3; stdcall;
    procedure SetEnableShadows(const Value: Boolean); stdcall;
    function GetShape: Tz3DScenarioObjectShape; override; stdcall;
    function GetSubsetCount: Integer; override; stdcall;
    function GetSubsets(const AIndex: Integer): Iz3DScenarioObjectSubset; override; stdcall;
    procedure BoundsChanged(const Sender: Iz3DBase); stdcall;
  public
    procedure Init(const AOwner: Iz3DBase); override; stdcall;
    procedure FrameMove; override; stdcall;
    procedure FrameRender; virtual; stdcall;
    procedure FrameRenderAmbient; virtual; stdcall;
    procedure FrameRenderDirectLighting; virtual; stdcall;
    procedure ComputeTransforms; stdcall;
    procedure ComputeViewTransforms; stdcall;
    procedure ComputeBounds; stdcall;

    procedure RenderDepth; stdcall;
    procedure RenderAmbientLighting; stdcall;
    procedure RenderSSAO; stdcall;
    procedure RenderShadowMap; stdcall;
    procedure RenderDynamicLighting; stdcall;
    procedure SetEffectCommonParams; stdcall;

    procedure Show; stdcall;
    procedure Hide; stdcall;
  public
    property CustomBoundingBox: Iz3DBoundingBox read GetCustomBoundingBox;
    property CustomBoundingSphere: Iz3DBoundingSphere read GetCustomBoundingSphere;
    property CustomScale: Iz3DFloat3 read GetCustomScale;
    property Model: Iz3DModel read GetModel;
    property WorldMatrix: Iz3DMatrix read GetWorldMatrix;
    property InstanceIndex: Integer read GetInstanceIndex;
    property LookAt: Iz3DFloat3 read GetLookAt;
    property EnableShadows: Boolean read GetEnableShadows write SetEnableShadows;
  end;





{==============================================================================}
{== Model static instance interface                                          ==}
{==============================================================================}
{== Prepares the model for rendering with static lighting using lightmaps    ==}
{== and radiosity                                                            ==}
{==============================================================================}

  Tz3DModelStaticInstance = class(Tz3DModelInstance, Iz3DModelStaticInstance, Iz3DScenarioStaticObject)
  private
    FLightMap: Iz3DLightMap;
  protected
    function GetLightMap: Iz3DLightMap; stdcall;
  public
    procedure LightMapProgress(const AStep: Tz3DLightMapGenerationStep;
    const ARadiosityLevel, APercent: Integer); stdcall;

    procedure Init(const AOwner: Iz3DBase); override; stdcall;
    function ProcessStaticLighting(const AStage: Tz3DModelLightMapProcessStage): Boolean; stdcall;
    procedure RenderStaticLighting; stdcall;
  public
    property LightMap: Iz3DLightMap read GetLightMap;
  end;







{==============================================================================}
{== Model dynamic instance interface                                         ==}
{==============================================================================}
{== Implements a world dynamic objects that interacts with world physics     ==}
{==============================================================================}

  Tz3DModelDynamicInstance = class(Tz3DModelInstance, Iz3DModelDynamicInstance, Iz3DScenarioDynamicObject)
  private
    FAcceleration: Iz3DFloat3;
    FVelocity: Iz3DFloat3;
    FGround: Boolean;
    FEnablePhysics: Boolean;
    FPrevVelocityY: Single;
  protected
    function GetAcceleration: Iz3DFloat3; stdcall;
    function GetVelocity: Iz3DFloat3; stdcall;
    function GetGround: Boolean; stdcall;
    procedure SetGround(const Value: Boolean); stdcall;
    function GetEnablePhysics: Boolean; stdcall;
    procedure SetEnablePhysics(const Value: Boolean); stdcall;
    procedure VelocityChanged(const ASender: Iz3DBase); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    procedure FrameMove; override; stdcall;
  public
    property Acceleration: Iz3DFloat3 read GetAcceleration;
    property Velocity: Iz3DFloat3 read GetVelocity;
    property Ground: Boolean read GetGround write SetGround;
    property EnablePhysics: Boolean read GetEnablePhysics write SetEnablePhysics;
  end;



// Controller management
function z3DCreateModelController: Iz3DModelController; stdcall;
procedure z3DSetCustomModelController(const AController: Iz3DModelController); stdcall;
function z3DModelController: Iz3DModelController; stdcall;


implementation

uses Math, z3DComponents_Func, z3DCore_Func, z3DEngine_Func, z3DScenario_Func,
  z3DMath_Func, z3DFileSystem_Func, z3DCore_Intf, z3DScenarioObjects_Intf, 
  z3DEngine_Intf, z3DLighting_Func, z3DScenarioObjects_Func;

var GModelController: Iz3DModelController;
var GLastMesh: ID3DXBaseMesh;
    GLastModel: Iz3DModel;

function z3DCreateModelController: Iz3DModelController;
begin
  z3DTrace('z3DCreateModelController: Creating model controller object...', z3DtkInformation);
  GModelController:= Tz3DModelController.Create;
  Result:= GModelController;
end;

procedure z3DSetCustomModelController(const AController: Iz3DModelController);
begin
  GModelController:= AController;
end;

function z3DModelController: Iz3DModelController;
begin
  Result:= GModelController;
end;

{ 3DS format }

procedure SkipChunk(Var F: TStream; Len: longword);
begin
  F.Seek(Len-6, soFromCurrent);
end;

destructor Tz3D3DSFileChunk.Destroy;
var I: integer;
begin
  for I:= 0 to High(SubChunks) do
  if SubChunks[I] <> nil then
  begin
    SubChunks[I]^.Destroy;
    FreeMem(SubChunks[I]);
    SubChunks[I] := nil;
  end;
  Setlength(SubChunks, 0);
end;

function Tz3D3DSFileChunk.NewSubchunk: integer;
begin
  Setlength(SubChunks, High(SubChunks)+2);
  New(subchunks[High(SubChunks)]);
  SubChunks[High(SubChunks)].Data:= Self.Data;
  Result:= High(SubChunks);
end;

procedure Tz3D3DSFileChunk.Read(var AStream: TStream);
Var S: string;
    Ch: Char;
    I: integer;
    Version: Cardinal;
    Temp: Single;
    W: Word;
begin
  Start := AStream.Position;

  AStream.ReadBuffer(ID, 2);
  AStream.ReadBuffer(Length, 4);

  case ID of

    // Version information
    MAX3DS_ID_VERSION:
    begin
      AStream.ReadBuffer(Version, 4);
      if Version > 3 then
        z3DTrace('Iz3D3DSFileChunk.Read: This file is from a later version of 3DS. It may not load correctly', z3dtkWarning);
    end;

    // Mesh object vertices
    MAX3DS_ID_OBJECT_VERTICES:
    begin
      if Data^.MeshCount > 0 then
      with Data^.Meshes[Data^.MeshCount-1] do
      begin
        AStream.ReadBuffer(W, 2);
        NumVerts:= W;
        SetLength(Vertices, Numverts);
        for I:= 0 to NumVerts-1 do
        begin
          AStream.ReadBuffer(Vertices[I], Sizeof(TD3DXVector3));
          // Swap Z and Y to make it D3D compatible
          Temp:= Vertices[I].y;
          Vertices[I].y:= Vertices[I].z;
          Vertices[I].z:= -Temp;
        end;
      end;
    end;

    // Mesh object texture coordinates
    MAX3DS_ID_OBJECT_UV:
    begin
      if Data^.MeshCount > 0 then
      with Data^.Meshes[Data^.MeshCount-1] do
      begin
        AStream.ReadBuffer(W, 2);
        NumCoords := W;
        HasCoords:= True;
        SetLength(Coords, NumCoords);
        for I := 0 to NumCoords-1 do
        AStream.ReadBuffer(Coords[I], Sizeof(TD3DXVector2));
      end;
    end;

    // Mesh object face indices
    MAX3DS_ID_OBJECT_FACES:
    begin
      if Data^.MeshCount > 0 then
      with Data^.Meshes[Data^.MeshCount-1] do
      begin
        AStream.ReadBuffer(W, 2);
        NumFaces := W;
        SetLength(Faces, NumFaces);
        For I := 0 to NumFaces-1 do
        AStream.ReadBuffer(Faces[I], Sizeof(T3DSFaceIndices));
      end;
    end;

    // Mesh object information
    MAX3DS_ID_OBJECTINFO, MAX3DS_ID_HEADER, MAX3DS_ID_OBJECT_MESH:
    begin
      repeat
        SubChunks[NewSubChunk]^.read(AStream);
      until AStream.Position >= (Start+Length);
    end;

    // Mesh object
    MAX3DS_ID_OBJECT:
    begin
      with Data^ do
      begin
        Inc(MeshCount);
        Setlength(Meshes, MeshCount);
        Meshes[MeshCount-1] := Tz3D3DSMeshObject.Create;
      end;
      repeat
        AStream.ReadBuffer(Ch, 1); // Name of object
        S := S + Ch;
      until Ch = #0;
      repeat
        SubChunks[NewSubChunk]^.read(AStream);
      until AStream.Position >= (Start+Length);
    end;

  else
    SkipChunk(AStream, Length);
  end;
end;


procedure Tz3D3DSMeshObject.ComputeBounds;
var I: integer;
    Vert: TD3DXVector3;
begin
  BBMin.x := 99999;
  BBMin.y := 99999;
  BBMin.z := 99999;
  BBMax.x := -99999;
  BBMax.y := -99999;
  BBMax.z := -99999;
  for I := 0 to NumVerts-1 do
  begin
    Vert.x := Vertices[I].x;
    Vert.y := Vertices[I].y;
    Vert.z := Vertices[I].z;
    if BBMin.x > Vert.x then BBMin.x := Vert.x;
    if BBMin.y > Vert.y then BBMin.y := Vert.y;
    if BBMin.z > Vert.z then BBMin.z := Vert.z;

    if BBMax.x < Vert.x then BBMax.x := Vert.x;
    if BBMax.y < Vert.y then BBMax.y := Vert.y;
    if BBMax.z < Vert.z then BBMax.z := Vert.z;
  end;
end;

procedure Tz3D3DSFile.CenterVertices;
var FCenter: TD3DXVector3;
    I, J: integer;
begin
  ComputeBounds;
  FCenter.x:= BBMin.x+FCenter.x/2;
  FCenter.y:= BBMin.y+FCenter.y/2;
  FCenter.z:= BBMin.z+FCenter.z/2;
  for I:= 0 to MeshCount-1 do
  begin
    for J:= 0 to Meshes[I].NumVerts-1 do
    with Meshes[I] do
    begin
       Vertices[J].x:= Vertices[J].x - FCenter.x;
       Vertices[J].y:= Vertices[J].y - FCenter.y;
       Vertices[J].z:= Vertices[J].z - FCenter.z;
    end;
  end;
end;

procedure Tz3D3DSFile.ComputeBounds;
var I: integer;
begin
  BBMin.x := 99999;
  BBMin.y := 99999;
  BBMin.z := 99999;
  BBMax.x := -99999;
  BBMax.y := -99999;
  BBMax.z := -99999;

  for I := 0 to MeshCount-1 do
  begin
   Meshes[I].ComputeBounds;
   if BBMin.x > Meshes[I].BBMin.x then BBmin.x := Meshes[I].Bbmin.x;
   if BBMin.y > Meshes[I].BBMin.y then BBmin.y := Meshes[I].Bbmin.y;
   if BBMin.z > Meshes[I].BBMin.z then BBmin.z := Meshes[I].Bbmin.z;

   if BBMax.x < Meshes[I].BBMax.x then BBmax.x := Meshes[I].Bbmax.x;
   if BBMax.y < Meshes[I].BBMax.y then BBmax.y := Meshes[I].Bbmax.y;
   if BBMax.z < Meshes[I].BBMax.z then BBmax.z := Meshes[I].Bbmax.z;
  end;
end;

procedure Tz3D3DSFile.Clear;
var I: integer;
begin
  for I := 0 to High(Meshes) do
  with Meshes[I] do
  begin
    Setlength(Vertices, 0);
    Setlength(Faces, 0);
    Setlength(Coords, 0);
    NumVerts:= 0;
    NumFaces:= 0;
    NumCoords:= 0;
    Meshes[I].Free;
  end;
  Setlength(Meshes, 0);
  MeshCount := 0;
end;

function Tz3D3DSFile.Load(const AFileName: string): ID3DXMesh;
var FStream: TFilestream;
    FIB: PWordArray;
    FVB: Pz3D3DSObjectVertexArray;
    FFaceCount, FVertexCount: Integer;
    FCurrentV, FCurrentF, I, J: integer;
    FVertices: array of TD3DXVector3;
    FFaces: array of T3DSFaceIndices;
    FCoords: array of TD3DXVector2;
begin
  if not FileExists(AFileName) then
    z3DTrace(PWideChar(WideString('Iz3D3DSFile.Load failed: File does not exist. Filename: '+ExtractFileName(AFileName))), z3dtkWarning);

  // Load the 3DS file
  try
    try
      Clear;
      FStream:= TFileStream.Create(AFileName, fmOpenRead);
      New(Chunk);
      Chunk^.Data := @Self;
      Chunk^.Read(TStream(FStream));
    except
      on E: Exception do
      z3DTrace(PWideChar(WideString('Iz3D3DSFile.Load failed: Unknown exception raised while loading the 3DS file. Error message: '+E.Message)), z3dtkWarning);
    end;

    if MeshCount = 0 then
      z3DTrace('Iz3D3DSFile.Load failed: 3DS file does not contain any valid meshes', z3dtkWarning);

    // Center all meshes
    CenterVertices;

    // Convert the meshes to D3D format
    if MeshCount > 0 then
    begin
      FFaceCount:= 0;
      FVertexCount:= 0;
      FCurrentV:= 0;
      FCurrentF:= 0;

      // Concatenate the vertices
      for J:= 0 to MeshCount-1 do
      begin
        SetLength(FFaces, Length(FFaces)+Meshes[J].NumFaces);
        for I:= 0 to Meshes[J].NumFaces-1 do
        begin
          FFaces[FCurrentF][0]:= Min(MAX3DS_MAXVERTICES-1, Meshes[J].Faces[I][0]+FVertexCount);
          FFaces[FCurrentF][1]:= Min(MAX3DS_MAXVERTICES-1, Meshes[J].Faces[I][1]+FVertexCount);
          FFaces[FCurrentF][2]:= Min(MAX3DS_MAXVERTICES-1, Meshes[J].Faces[I][2]+FVertexCount);
          FFaces[FCurrentF][3]:= Min(MAX3DS_MAXVERTICES-1, Meshes[J].Faces[I][3]+FVertexCount);
          Inc(FCurrentF);
        end;
        SetLength(FVertices, Length(FVertices)+Meshes[J].NumVerts);
        SetLength(FCoords, Length(FCoords)+Meshes[J].NumVerts);
        for I:= 0 to Meshes[J].NumVerts-1 do
        begin
          FVertices[FCurrentV].x:= Meshes[J].Vertices[I].x;
          FVertices[FCurrentV].y:= Meshes[J].Vertices[I].y;
          FVertices[FCurrentV].z:= Meshes[J].Vertices[I].z;
          if Meshes[J].HasCoords then
          begin
            FCoords[FCurrentV].x:= Meshes[J].Coords[I].x;
            FCoords[FCurrentV].y:= Meshes[J].Coords[I].y;
          end;
          Inc(FCurrentV);
        end;
        FFaceCount:= FFaceCount+Meshes[J].NumFaces;
        FVertexCount:= FVertexCount+Meshes[J].NumVerts;
      end;

      if FVertexCount > MAX3DS_MAXVERTICES then
      begin
        StringToWideChar('Iz3D3DSFile.Load: Imported 3DS file exceeds z3D vertex limit. Trying to truncate the vertex buffer', z3DWideBuffer, 255);
        z3DTrace(z3DWideBuffer, z3DtkWarning);
        FVertexCount:= MAX3DS_MAXVERTICES;
        FFaceCount:= FVertexCount div 3 + 1;
      end;

      // Create the D3D mesh
      if FAILED(D3DXCreateMesh(FFaceCount, FVertexCount, D3DXMESH_MANAGED, @Tz3D3DSObjectVD, z3DCore_GetD3DDevice, Result)) then
        z3DTrace('Iz3D3DSFile.Load failed: D3DXCreateMesh failed', z3dtkWarning);

      // Copy the vertices from 3DS to D3D
      if Result <> nil then
      begin
        Result.LockVertexBuffer(0, Pointer(FVB));
        Result.LockIndexBuffer(0, Pointer(FIB));
        try
          for I:= 0 to FFaceCount-1 do
          begin
            FIB[I*3]:= FFaces[I][0];
            FIB[I*3+1]:= FFaces[I][1];
            FIB[I*3+2]:= FFaces[I][2];
          end;
          for I := 0 to FVertexCount-1 do
          begin
            FVB[I].Position.x:= FVertices[I].x;
            FVB[I].Position.y:= FVertices[I].y;
            FVB[I].Position.z:= FVertices[I].z;
            if Length(FCoords) > 0 then
            begin
              FVB[I].TexCoord.x:= FCoords[I].x;
              FVB[I].TexCoord.y:= FCoords[I].y;
            end;
          end;
        finally
          Result.UnlockVertexBuffer;
          Result.UnlockIndexBuffer;
        end;
      end;
      
    end;
  finally
    FStream.Free;
    Chunk^.Destroy;
    Dispose(Chunk);
    Chunk:= nil;
  end;
end;

{ Tz3DModelController }

constructor Tz3DModelController.Create;
begin
  inherited;

  // Link this object to the desired events generated by the z3D Engine
  ScenarioStage:= z3dssCreatingSceneObjects;
  Notifications:= [z3dlnDevice, z3dlnFrameMove, z3dlnFrameRender, z3dlnLightingRender,
    z3dlnDirectLightRender];

  FModelFormat:= z3DFileSystemController.CreateObjectFormat;
  FModelFormat.Description:= 'Zenith Model File';
  FModelFormat.Extension:= 'zModel';
  FModelFormat.DefaultFolder:= fsModelsFolder;
  FModelFormat.Header:= 'ZMODEL';
  FStaticModels:= TInterfaceList.Create;
  FDynamicModels:= TInterfaceList.Create;
  FStaticModelVertexFormat:= z3DCreateVertexFormat;
  FDynamicModelVertexFormat:= z3DCreateVertexFormat;
  BuildVertexFormats;
end;

procedure Tz3DModelController.AddModel(const AModel: Iz3DModel);
begin
  if z3DSupports(AModel, Iz3DStaticModel) then
  FStaticModels.Add(AModel) else FDynamicModels.Add(AModel);
end;

procedure Tz3DModelController.SortByDepth(const AModels: IInterfaceList;
  var AOrder: Tz3DModelRenderOrder);
var I, FT0, FT1: Integer;
    FSwapped: Boolean;
begin
  // Use bubble sort to reorder Models front-to-back
  if (z3DCore_GetTime-FElapsedTime) > 1 then
  begin
    FSwapped:= True;
    while FSwapped do
    begin
      FSwapped:= False;
      for I:= 0 to Length(AOrder)-2 do
      if (AModels[AOrder[I][0]] as Iz3DModel).Instances[AOrder[I][1]].Visible and
      (AModels[AOrder[I+1][0]] as Iz3DModel).Instances[AOrder[I+1][1]].Visible and
      ((AModels[AOrder[I][0]] as Iz3DModel).Instances[AOrder[I][1]].ViewCenter.Z >
      (AModels[AOrder[I+1][0]] as Iz3DModel).Instances[AOrder[I+1][1]].ViewCenter.Z) then
      begin
        FT0:= AOrder[I][0];
        FT1:= AOrder[I][1];
        AOrder[I][0]:= AOrder[I+1][0];
        AOrder[I][1]:= AOrder[I+1][1];
        AOrder[I+1][0]:= FT0;
        AOrder[I+1][1]:= FT1;
        FSwapped:= True;
      end;
    end;
    FElapsedTime:= z3DCore_GetTime;
  end;
end;

procedure Tz3DModelController.BuildDynamicRenderOrder;
begin
  SortByDepth(FDynamicModels, FDynamicRenderOrder);
end;

procedure Tz3DModelController.BuildStaticRenderOrder;
begin
  SortByDepth(FStaticModels, FStaticRenderOrder);
end;

function Tz3DModelController.CreateDynamicModel: Iz3DDynamicModel;
begin
  Result:= Tz3DDynamicModel.Create;
  AddModel(Result);
end;

procedure Tz3DModelController.BuildRenderOrder(const AModels: IInterfaceList;
  var AOrder: Tz3DModelRenderOrder);
var I, J: Integer;
begin
  SetLength(AOrder, 0);
  for I:= 0 to AModels.Count-1 do
  for J:= 0 to (AModels[I] as Iz3DModel).InstanceCount-1 do
  begin
    SetLength(AOrder, Length(AOrder)+1);
    SetLength(AOrder[Length(AOrder)-1], 2);
    AOrder[Length(AOrder)-1][0]:= I;
    AOrder[Length(AOrder)-1][1]:= J;
  end;
end;

procedure Tz3DModelController.CreateScenarioObjects;
var I: Integer;
begin
  for I:= 0 to FStaticModels.Count-1 do StaticModels[I].CreateScenarioObjects;
  for I:= 0 to FDynamicModels.Count-1 do DynamicModels[I].CreateScenarioObjects;
  BuildRenderOrders;
end;

procedure Tz3DModelController.DestroyScenarioObjects;
var I: Integer;
begin
  for I:= 0 to FDynamicModels.Count-1 do DynamicModels[I].DestroyScenarioObjects;
  for I:= 0 to FStaticModels.Count-1 do StaticModels[I].DestroyScenarioObjects;
end;

function Tz3DModelController.CreateStaticModel: Iz3DStaticModel;
begin
  Result:= Tz3DStaticModel.Create;
  AddModel(Result);
end;

function Tz3DModelController.CreateHeightMappedModel: Iz3DHeightMappedModel;
begin
  Result:= Tz3DHeightMappedModel.Create;
  AddModel(Result);
end;

function Tz3DModelController.GetDynamicModel(const AIndex: Integer): Iz3DDynamicModel;
begin
  Result:= FDynamicModels[AIndex] as Iz3DDynamicModel;
end;

function Tz3DModelController.GetDynamicModelCount: Integer;
begin
  Result:= FDynamicModels.Count;
end;

function Tz3DModelController.GetDynamicRenderOrder: Tz3DModelRenderOrder;
begin
  Result:= FDynamicRenderOrder;
end;

function Tz3DModelController.GetStaticModel(const AIndex: Integer): Iz3DStaticModel;
begin
  Result:= FStaticModels[AIndex] as Iz3DStaticModel;
end;

function Tz3DModelController.GetStaticModelCount: Integer;
begin
  Result:= FStaticModels.Count;
end;

function Tz3DModelController.GetStaticRenderOrder: Tz3DModelRenderOrder;
begin
  Result:= FStaticRenderOrder;
end;

procedure Tz3DModelController.RemoveModel(const AModel: Iz3DModel);
begin
  if z3DSupports(AModel, Iz3DStaticModel) then
  FStaticModels.Remove(AModel as Iz3DStaticModel) else
  FDynamicModels.Remove(AModel as Iz3DDynamicModel);

  BuildRenderOrders;
end;

procedure Tz3DModelController.SetDynamicModel(const AIndex: Integer; const Value: Iz3DDynamicModel);
begin
  FDynamicModels[AIndex]:= Value;
end;

procedure Tz3DModelController.SetStaticModel(const AIndex: Integer; const Value: Iz3DStaticModel);
begin
  FStaticModels[AIndex]:= Value;
end;

function Tz3DModelController.GetDynamicModelList: IInterfaceList;
begin
  Result:= FDynamicModels;
end;

function Tz3DModelController.GetStaticModelList: IInterfaceList;
begin
  Result:= FStaticModels;
end;

procedure Tz3DModelController.ProcessStaticLighting;
var FKeepProcessing: Boolean;
    I: Integer;
begin
  // Generate the direct lighting and ambient lightmaps
  for I:= 0 to StaticModelCount - 1 do
  StaticModels[I].ProcessStaticLighting(z3dlmpsBeginGeneration);

  // Generate the radiosity lightmaps
  for I:= 0 to StaticModelCount - 1 do
  StaticModels[I].ProcessStaticLighting(z3dlmpsBeginRadiosity);
  FKeepProcessing:= True;
  while FKeepProcessing do
  begin
    FKeepProcessing:= False;
    for I:= 0 to StaticModelCount - 1 do
    if StaticModels[I].ProcessStaticLighting(z3dlmpsBeginRadiosityBounce) then
    FKeepProcessing:= True;
    for I:= 0 to StaticModelCount - 1 do
    StaticModels[I].ProcessStaticLighting(z3dlmpsEndRadiosityBounce);
  end;
  for I:= 0 to StaticModelCount - 1 do
  StaticModels[I].ProcessStaticLighting(z3dlmpsEndRadiosity);

  // End the lightmap generation process
  for I:= 0 to StaticModelCount - 1 do
  StaticModels[I].ProcessStaticLighting(z3dlmpsEndGeneration);
end;

procedure Tz3DModelController.BuildVertexFormats;
begin
  // Build the static model vertex format
  with FStaticModelVertexFormat do
  begin
    BeginUpdate;
    try
      ClearElements;
      AddElement(0, z3dvefFloat3, z3dvemDefault, z3dveuPosition, 0);
      AddElement(0, z3dvefFloat3, z3dvemDefault, z3dveuNormal, 0);
      AddElement(0, z3dvefFloat3, z3dvemDefault, z3dveuTangent, 0);
      AddElement(0, z3dvefFloat2, z3dvemDefault, z3dveuTexCoord, 0);
      AddElement(0, z3dvefFloat2, z3dvemDefault, z3dveuTexCoord, 1);
    finally
      EndUpdate;
    end;
  end;

  // Build the dynamic model vertex format
  with FDynamicModelVertexFormat do
  begin
    BeginUpdate;
    try
      ClearElements;
      AddElement(0, z3dvefFloat3, z3dvemDefault, z3dveuPosition, 0);
      AddElement(0, z3dvefFloat3, z3dvemDefault, z3dveuNormal, 0);
      AddElement(0, z3dvefFloat3, z3dvemDefault, z3dveuTangent, 0);
      AddElement(0, z3dvefFloat2, z3dvemDefault, z3dveuTexCoord, 0);
    finally
      EndUpdate;
    end;
  end;
end;

procedure Tz3DModelController.BuildRenderOrders;
begin
  // Build the ordered access index list
  BuildRenderOrder(FStaticModels, FStaticRenderOrder);
  BuildRenderOrder(FDynamicModels, FDynamicRenderOrder);
end;

procedure Tz3DModelController.z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller);
begin
  inherited;
  if ACaller <> z3dcocResetDevice then CreateScenarioObjects;
end;

procedure Tz3DModelController.z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller);
begin
  if ACaller <> z3ddocLostDevice then DestroyScenarioObjects;
end;

procedure Tz3DModelController.z3DFrameMove;
var I: Integer;
begin
  inherited;
  if not z3DEngine.Scenario.Enabled then Exit;
  FAnyVisibleInstance:= False;
  FAnyVisibleStaticInstance:= False;
  FAnyVisibleDynamicInstance:= False;
  FAnyVisibleOpaqueInstance:= False;
  FAnyVisibleTranslucentInstance:= False;
  FAnyVisibleOpaqueStaticInstance:= False;
  FAnyVisibleOpaqueDynamicInstance:= False;
  FAnyVisibleTranslucentStaticInstance:= False;
  FAnyVisibleTranslucentDynamicInstance:= False;
  for I:= 0 to FStaticModels.Count-1 do StaticModels[I].FrameMove;
  for I:= 0 to FDynamicModels.Count-1 do DynamicModels[I].FrameMove;
end;

procedure Tz3DModelController.z3DFrameRender;
var I: Integer;
begin
  inherited;

  // Process the static lighting on the GPU if needed
  // GRAN TODO JP
  if FWaitingGPUProcessStaticLighting then
  begin
//    ProcessStaticLighting;
    FWaitingGPUProcessStaticLighting:= False;
  end;

  if not z3DEngine.Scenario.Enabled then Exit;
  if z3DEngine.Renderer.RenderStage <> z3drsDepth then Exit;

  if Length(StaticRenderOrder) > 0 then
  begin
    FStaticModelVertexFormat.Apply;
    for I:= 0 to Length(StaticRenderOrder)-1 do
    StaticModels[StaticRenderOrder[I][0]].Instances[StaticRenderOrder[I][1]].FrameRender;
  end;
  if Length(DynamicRenderOrder) > 0 then
  begin
    FDynamicModelVertexFormat.Apply;
    for I:= 0 to Length(DynamicRenderOrder)-1 do
    DynamicModels[DynamicRenderOrder[I][0]].Instances[DynamicRenderOrder[I][1]].FrameRender;
  end;

  GLastMesh:= nil;
  GLastModel:= nil;
end;

procedure Tz3DModelController.z3DLightingRender;
var I, J: Integer;
begin
  inherited;

  // If MSAA is enabled, models must be rendered front-to-back because
  // we're writing the z-values to the depth buffer on this stage.
  if z3DEngine.Renderer.EnableMSAA then
  begin
    if z3DLightingController.OpaqueMode then
    begin
      // Opaque models
      if Length(StaticRenderOrder) > 0 then
      begin
        FStaticModelVertexFormat.Apply;
        for I:= 0 to Length(StaticRenderOrder)-1 do
        if (StaticModels[StaticRenderOrder[I][0]].SubsetCount = 0) or
        (StaticModels[StaticRenderOrder[I][0]]. Subsets[0].Material.ColorDiffuse.A > ALPHA_UPPER_BOUND) then
        StaticModels[StaticRenderOrder[I][0]].Instances[StaticRenderOrder[I][1]].FrameRenderAmbient;
      end;

      if Length(DynamicRenderOrder) > 0 then
      begin
        FDynamicModelVertexFormat.Apply;
        for I:= 0 to Length(DynamicRenderOrder)-1 do
        if (DynamicModels[DynamicRenderOrder[I][0]].SubsetCount = 0) or
        (DynamicModels[DynamicRenderOrder[I][0]]. Subsets[0].Material.ColorDiffuse.A > ALPHA_UPPER_BOUND) then
        DynamicModels[DynamicRenderOrder[I][0]].Instances[DynamicRenderOrder[I][1]].FrameRenderAmbient;
      end;
    end else
    begin
      // Transparent models
      if Length(StaticRenderOrder) > 0 then
      begin
        FStaticModelVertexFormat.Apply;
        for I:= 0 to Length(StaticRenderOrder)-1 do
        if (StaticModels[StaticRenderOrder[I][0]].SubsetCount > 0) and
        (StaticModels[StaticRenderOrder[I][0]]. Subsets[0].Material.ColorDiffuse.A < ALPHA_UPPER_BOUND) then
        StaticModels[StaticRenderOrder[I][0]].Instances[StaticRenderOrder[I][1]].FrameRenderAmbient;
      end;

      if Length(DynamicRenderOrder) > 0 then
      begin
        FDynamicModelVertexFormat.Apply;
        for I:= 0 to Length(DynamicRenderOrder)-1 do
        if (DynamicModels[DynamicRenderOrder[I][0]].SubsetCount > 0) and
        (DynamicModels[DynamicRenderOrder[I][0]]. Subsets[0].Material.ColorDiffuse.A < ALPHA_UPPER_BOUND) then
        DynamicModels[DynamicRenderOrder[I][0]].Instances[DynamicRenderOrder[I][1]].FrameRenderAmbient;
      end;
    end;
  end else
  begin

    if z3DLightingController.OpaqueMode then
    begin
      // Opaque models
      if StaticModelCount > 0 then FStaticModelVertexFormat.Apply;
      for I:= 0 to StaticModelCount-1 do
      if (StaticModels[I].SubsetCount = 0) or (StaticModels[I].Subsets[0].Material.ColorDiffuse.A > ALPHA_UPPER_BOUND) then
      for J:= 0 to StaticModels[I].InstanceCount-1 do
      StaticModels[I].Instances[J].FrameRenderAmbient;

      if DynamicModelCount > 0 then FDynamicModelVertexFormat.Apply;
      for I:= 0 to DynamicModelCount-1 do
      if (DynamicModels[I].SubsetCount = 0) or (DynamicModels[I].Subsets[0].Material.ColorDiffuse.A > ALPHA_UPPER_BOUND) then
      for J:= 0 to DynamicModels[I].InstanceCount-1 do
      DynamicModels[I].Instances[J].FrameRenderAmbient;
    end else
    begin
      // Transparent models
      if StaticModelCount > 0 then FStaticModelVertexFormat.Apply;
      for I:= 0 to StaticModelCount-1 do
      if (StaticModels[I].SubsetCount > 0) and (StaticModels[I].Subsets[0].Material.ColorDiffuse.A < ALPHA_UPPER_BOUND) then
      for J:= 0 to StaticModels[I].InstanceCount-1 do
      StaticModels[I].Instances[J].FrameRenderAmbient;

      if DynamicModelCount > 0 then FDynamicModelVertexFormat.Apply;
      for I:= 0 to DynamicModelCount-1 do
      if (DynamicModels[I].SubsetCount > 0) and (DynamicModels[I].Subsets[0].Material.ColorDiffuse.A < ALPHA_UPPER_BOUND) then
      for J:= 0 to DynamicModels[I].InstanceCount-1 do
      DynamicModels[I].Instances[J].FrameRenderAmbient;
    end;
  end;

  GLastMesh:= nil;
  GLastModel:= nil;
end;

procedure Tz3DModelController.z3DDirectLightRender;
var I, J: Integer;
begin
  inherited;

  if z3DLightingController.OpaqueMode then
  begin
    // Opaque models
    if StaticModelCount > 0 then FStaticModelVertexFormat.Apply;
    for I:= 0 to StaticModelCount-1 do
    if (StaticModels[I].SubsetCount = 0) or (StaticModels[I].Subsets[0].Material.ColorDiffuse.A > ALPHA_UPPER_BOUND) then
    for J:= 0 to StaticModels[I].InstanceCount-1 do
    StaticModels[I].Instances[J].FrameRenderDirectLighting;

    if DynamicModelCount > 0 then FDynamicModelVertexFormat.Apply;
    for I:= 0 to DynamicModelCount-1 do
    if (DynamicModels[I].SubsetCount = 0) or (DynamicModels[I].Subsets[0].Material.ColorDiffuse.A > ALPHA_UPPER_BOUND) then
    for J:= 0 to DynamicModels[I].InstanceCount-1 do
    DynamicModels[I].Instances[J].FrameRenderDirectLighting;
  end else
  begin
    // Transparent models
    if StaticModelCount > 0 then FStaticModelVertexFormat.Apply;
    for I:= 0 to StaticModelCount-1 do
    if (StaticModels[I].SubsetCount > 0) and (StaticModels[I].Subsets[0].Material.ColorDiffuse.A < ALPHA_UPPER_BOUND) then
    for J:= 0 to StaticModels[I].InstanceCount-1 do
    StaticModels[I].Instances[J].FrameRenderDirectLighting;

    if DynamicModelCount > 0 then FDynamicModelVertexFormat.Apply;
    for I:= 0 to DynamicModelCount-1 do
    if (DynamicModels[I].SubsetCount > 0) and (DynamicModels[I].Subsets[0].Material.ColorDiffuse.A < ALPHA_UPPER_BOUND) then
    for J:= 0 to DynamicModels[I].InstanceCount-1 do
    DynamicModels[I].Instances[J].FrameRenderDirectLighting;
  end;
  GLastMesh:= nil;
  GLastModel:= nil;
end;

function Tz3DModelController.GetDynamicVertexFormat: Iz3DVertexFormat;
begin
  Result:= FDynamicModelVertexFormat;
end;

function Tz3DModelController.GetStaticVertexFormat: Iz3DVertexFormat;
begin
  Result:= FStaticModelVertexFormat;
end;

procedure Tz3DModelController.z3DStartScenario(const AStage: Tz3DStartScenarioStage);
begin
  inherited;
  if AStage = z3dssCreatingLightingSystem then
  ProcessStaticLighting;
end;

function Tz3DModelController.GetModelFormat: Iz3DObjectFileFormat;
begin
  Result:= FModelFormat;
end;

function Tz3DModelController.CreateWaterModel: Iz3DWaterModel;
begin
  Result:= Tz3DWaterModel.Create;
  AddModel(Result);
end;

{ Tz3DModelSubset }

constructor Tz3DModelSubset.Create(const AOwner: Iz3DBase);
begin
  inherited;
  FModel:= AOwner as Iz3DModel;
end;

{ Tz3DModel }

procedure Tz3DModel.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FGenerateLODMeshes:= True;
  FOSBoundingBox:= z3DBoundingBox;
  FBoundingBox:= z3DBoundingBox;
  FAutoGenerateTexCoords:= False;
  FOSBoundingSphere:= z3DBoundingSphere;
  FBoundingSphere:= z3DBoundingSphere;
  FScale:= z3DFloat3;
  FFaceCount:= 0;
  GetMem(FFileName, 255);
  GetMem(FName, 255);
  FInstancingMethod:= z3dimTransform;
  FLockAspectRatio:= True;
  FLockTexCoordsAspectRatio:= True;
  FShape:= z3dsosCube;
  FSubsets:= TInterfaceList.Create;
  FTexCoordsScale:= 1;
  FVertexCount:= 0;
end;

procedure Tz3DModel.LoadFromFile(const AFileName: PWideChar);
begin
  FileName:= AFileName;
  CreateModel;
end;

procedure Tz3DModel.SaveToFile(const AFileName: PWideChar);
var FFile: Iz3DTypedObjectFile;
    FTempFile: Iz3DObjectFile;
    I: Integer;
    FLength: Int64;
    FXFilePtr: Pointer;
    FTempFileName: string;
begin
  // If the file is a Zenith Model File, save the entire model
  if LowerCase(ExtractFileExt(AFileName)) = '.'+LowerCase(z3dmfExtension) then
  begin
    FFile:= z3DFileSystemController.CreateTypedObjectFile(AFileName, fmCreate or fmOpenWrite,
      z3DModelController.ModelFormat);

      // Model properties
      FFile.WriteVariant(Integer(Shape));
      FFile.WriteFloat3(BoundingSphere.Center);
      FFile.WriteVariant(BoundingSphere.Radius);
      FFile.WriteFloat3(BoundingBox.Dimensions);
      FFile.WriteVariant(SubsetCount);

      // Materials
      for I:= 0 to SubsetCount-1 do
      begin
        StringToWideChar(Subsets[I].Material.FileName, z3DWideBuffer, 255);
        FFile.WriteString(z3DWideBuffer);
      end;

      // Mesh object
      StringToWideChar(fsBufferPath+fsPathDiv+'TmpModel.x', z3DWideBuffer, 255);
      FTempFileName:= WideCharToString(z3DFileSystemController.GetFullPath(z3DWideBuffer));
      StringToWideChar(FTempFileName, z3DWideBuffer, 255);
      if FAILED(D3DXSaveMeshToXW(z3DWideBuffer, FMesh, nil, nil, nil, 0, D3DXF_FILEFORMAT_BINARY)) then
      begin
        z3DTrace('Iz3DModel.SaveToFile: D3DXSaveMeshToX failed', z3dtkWarning);
        Exit;
      end;
      FTempFile:= z3DFileSystemController.CreateObjectFile(z3DWideBuffer, fmOpenRead);
      FLength:= FTempFile.Size;
      try
        GetMem(FXFilePtr, FLength);
      except
        z3DTrace('Iz3DModel.SaveToFile failed: Out of memory', z3dtkWarning);
      end;
      FTempFile.ReadUnknown(FXFilePtr^, FLength);
      FFile.WriteUnknown(FXFilePtr^, FLength);
      FTempFile:= nil;
      FFile:= nil;
      FileName:= AFileName;
      z3DFileSystemController.Delete(z3DWideBuffer);
  end else

  // If the file is a DirectX X File, save the mesh
  if LowerCase(ExtractFileExt(AFileName)) = '.x' then
  begin
    if FAILED(D3DXSaveMeshToXW(AFileName, FMesh, nil, nil, nil, 0, D3DXF_FILEFORMAT_BINARY)) then
    begin
      z3DTrace('Iz3DModel.SaveToFile: D3DXSaveMeshToX failed', z3dtkWarning);
      Exit;
    end;
  end else
  begin
    z3DTrace(PWideChar(WideString('Iz3DModel.SaveToFile: Unknown file extension ('+LowerCase(ExtractFileExt(AFileName))+')')), z3dtkWarning);
    Exit;
  end;
end;

procedure Tz3DModel.CreateMesh(const AMeshFileName: PWideChar);
var FAdjacencyBuffer: ID3DXBuffer;
    FSourceSubsetCount: Integer;
    FMtrlBuffer: ID3DXBuffer;
    F3DSFile: Tz3D3DSFile;
    FD3DXMtrls: PD3DXMaterial;
begin

  // If the file is a DirectX X File, load the mesh
  if LowerCase(ExtractFileExt(AMeshFileName)) = '.x' then
  begin
    if FAILED(D3DXLoadMeshFromXW(AMeshFileName, D3DXMESH_MANAGED, z3DCore_GetD3DDevice,
      @FAdjacencyBuffer, @FMtrlBuffer, nil, @FSourceSubsetCount, FMesh)) then
    begin
      z3DTrace('Iz3DModel.CreateMesh failed: D3DXLoadMeshFromX failed', z3dtkWarning);
      Exit;
    end;
  end else

  // If the file is a 3D Studio Max File, convert and load the mesh
  if LowerCase(ExtractFileExt(AMeshFileName)) = '.3ds' then
  begin
    try
      FMesh:= F3DSFile.Load(AMeshFileName);
      FSourceSubsetCount:= 1;
    except
      z3DTrace('Iz3DModel.CreateMesh failed: 3DSFile.Load failed', z3dtkWarning);
      Exit;
    end;
  end else
  begin
    z3DTrace(PWideChar(WideString('Iz3DModel.CreateModel failed: Unknown file extension ('+LowerCase(ExtractFileExt(AMeshFileName))+')')), z3dtkWarning);
    Exit;
  end;
  if FAdjacencyBuffer <> nil then
  if FAILED(FMesh.OptimizeInplace(D3DXMESHOPT_COMPACT or D3DXMESHOPT_ATTRSORT or D3DXMESHOPT_VERTEXCACHE,
    FAdjacencyBuffer.GetBufferPointer, nil, nil, nil)) then
  begin
    z3DTrace('Iz3DModel.CreateMesh failed: OptimizeInplace failed', z3DtkWarning);
    Exit;
  end;


  D3DXSaveMeshToX('C:\TEMP.x', FMesh, nil, nil, nil, 0, D3DXF_FILEFORMAT_BINARY);
  
  if FMesh = nil then Exit;

  // Fill the mesh information
  FVertexCount:= FMesh.GetNumVertices;
  FFaceCount:= FMesh.GetNumFaces;
  FBytesPerVertex:= FMesh.GetNumBytesPerVertex;

  // Create the materials
  if FMtrlBuffer <> nil then
  begin
    FD3DXMtrls:= PD3DXMaterial(FMtrlBuffer.GetBufferPointer);
    CreateSubsets(FD3DXMtrls, FSourceSubsetCount);
  end else
  begin
    GetMem(FD3DXMtrls, SizeOf(TD3DXMaterial));
    FD3DXMtrls.MatD3D.Diffuse:= D3DXColor(1, 1, 1, 1);
    FD3DXMtrls.pTextureFilename:= nil;
    CreateSubsets(FD3DXMtrls, 1);
  end;
  FAdjacencyBuffer:= nil;
  FMtrlBuffer:= nil;
end;

procedure Tz3DModel.CreateModel;
var FFile: Iz3DTypedObjectFile;
    FTempFile: Iz3DObjectFile;
    I: Integer;
    FSubset: Iz3DModelSubset;
    FXFilePtr: Pointer;
    FLength: Int64;
    FTempFileName: string;
begin

  // If the file is a Zenith Model File, load the entire model
  if LowerCase(ExtractFileExt(FFileName)) = '.'+LowerCase(z3dmfExtension) then
  begin
    FFile:= z3DFileSystemController.CreateTypedObjectFile(FFileName, fmOpenRead,
      z3DModelController.ModelFormat);

    // Model properties
    Shape:= Tz3DScenarioObjectShape(FFile.ReadInteger);
    FFile.ReadFloat3(BoundingSphere.Center);
    BoundingSphere.Radius:= FFile.ReadFloat;
    FFile.ReadFloat3(BoundingBox.Dimensions);

    // Materials
    FSubsets.Clear;
    for I:= 0 to FFile.ReadInteger-1 do
    begin
      FSubset:= AddSubset;
      FSubset.Material.LoadFromFile(FFile.ReadString);
    end;

    // Mesh object
    try
      GetMem(FXFilePtr, FFile.Size-FFile.Position);
    except
      z3DTrace('Iz3DModelFileSystem.CreateModel failed: Out of memory', z3dtkWarning);
    end;
    FLength:= FFile.Size-FFile.Position;
    FFile.ReadUnknown(FXFilePtr^, FLength);
    StringToWideChar(fsBufferPath+fsPathDiv+'TmpModel.x', z3DWideBuffer, 255);
    FTempFileName:= WideCharToString(z3DFileSystemController.GetFullPath(z3DWideBuffer));
    StringToWideChar(FTempFileName, z3DWideBuffer, 255);
    FTempFile:= z3DFileSystemController.CreateObjectFile(z3DWideBuffer, fmCreate or fmOpenWrite);
    FTempFile.WriteUnknown(FXFilePtr^, FLength);
    FTempFile:= nil;
    FFile:= nil;
    CreateMesh(z3DWideBuffer);
    z3DFileSystemController.Delete(z3DWideBuffer);
  end else

  // If the file is NOT a Zenith Model File, load the mesh
  CreateMesh(FFileName);

  SetDeclaration(VertexFormat.GetDeclaration);
  if GenerateLODMeshes then CreateLODMeshes;
  ComputeBounds;
end;

procedure Tz3DModel.CreateLODMeshes;
var FOldAdjacency: PDWORD;
    FNewAdjacency: PDWORD;
    FD3DXTempMesh: ID3DXMesh;
    FD3DXPMesh: ID3DXPMesh;
    FVertexFactor: Integer;
    FEpsilons: TD3DXWeldEpsilons;
begin
  if FMesh = nil then Exit;
  if LODMeshes[z3dsolHigh] <> nil then Exit;
  try
    GetMem(FOldAdjacency, SizeOf(DWORD) * Mesh.GetNumFaces * 3);
    GetMem(FNewAdjacency, SizeOf(DWORD) * Mesh.GetNumFaces * 3);
  except
    on EOutOfMemory do
    begin
      z3DTrace('Iz3DModel.CreateLODMeshes failed (Out of memory)', z3DtkError);
      Exit;
    end;
  end;
  Mesh.GenerateAdjacency(1e-2, FOldAdjacency);

  if FAILED(D3DXCleanMesh(D3DXCLEAN_SIMPLIFICATION, FMesh, FOldAdjacency, FD3DXTempMesh,
  FNewAdjacency, nil)) then z3DTrace('Iz3DModel.CreateLODMeshes failed: D3DXCleanMesh failed', z3DtkError);
  if (FD3DXTempMesh = Mesh) then
  begin
    if FAILED(FMesh.CloneMesh(FMesh.GetOptions or D3DXMESH_MANAGED, Pointer(VertexFormat.GetDeclaration),
    z3DCore_GetD3DDevice, FD3DXTempMesh)) then z3DTrace('Iz3DModel.CreateLODMeshes failed: D3DXCloneMesh failed', z3DtkError);
    FD3DXTempMesh.GenerateAdjacency(1e-2, FNewAdjacency);
  end;

  ZeroMemory(@FEpsilons, SizeOf(TD3DXWeldEpsilons));
  if FAILED(D3DXWeldVertices(FD3DXTempMesh, 0, @FEpsilons, FNewAdjacency, FNewAdjacency, nil, nil)) then
  z3DTrace('Iz3DModel.CreateLODMeshes failed: D3DXWeldVertices failed', z3DtkError);

  if FAILED(D3DXValidMesh(FD3DXTempMesh, FNewAdjacency, nil)) then
  z3DTrace('Iz3DModel.CreateLODMeshes failed: D3DXValidMesh failed', z3DtkError);

  if FAILED(D3DXGeneratePMesh(FD3DXTempMesh, FNewAdjacency, nil, nil, 1, D3DXMESHSIMP_VERTEX, FD3DXPMesh)) then
  z3DTrace('Iz3DModel.CreateLODMeshes failed: D3DXGeneratePMesh failed', z3DtkError);

  // Create hi-res mesh
  if FAILED(FD3DXPMesh.ClonePMesh(D3DXMESH_MANAGED or D3DXMESH_VB_SHARE, Pointer(VertexFormat.GetDeclaration), z3DCore_GetD3DDevice,
  FLODMeshes[z3dsolHigh])) then z3DTrace('Iz3DModel.CreateLODMeshes failed: Could not create hi-res mesh (ClonePMesh failed)', z3DtkError);

  // Create mid-res mesh
  FVertexFactor:= (FD3DXPMesh.GetMaxVertices - FD3DXPMesh.GetMinVertices) div 2;
  if FAILED(FD3DXPMesh.ClonePMesh(D3DXMESH_MANAGED or D3DXMESH_VB_SHARE, Pointer(VertexFormat.GetDeclaration), z3DCore_GetD3DDevice,
  FLODMeshes[z3dsolMid])) then z3DTrace('Iz3DModel.CreateLODMeshes failed: Could not create mid-res mesh (ClonePMesh failed)', z3DtkError);
  if FAILED(FLODMeshes[z3dsolMid].TrimByVertices(FD3DXPMesh.GetMinVertices + FVertexFactor, FD3DXPMesh.GetMinVertices + FVertexFactor, nil, nil)) then
  z3DTrace('Iz3DModel.CreateLODMeshes failed: Could not trim mid-res mesh (TrimByVertices failed)', z3DtkError);
  if FAILED(FLODMeshes[z3dsolMid].OptimizeBaseLOD(D3DXMESHOPT_VERTEXCACHE, nil)) then
  z3DTrace('Iz3DModel.CreateLODMeshes failed: Could not optimize mid-res mesh (OptimizeBaseLOD failed)', z3DtkError);

  // Create low-res mesh
  if FAILED(FD3DXPMesh.ClonePMesh(D3DXMESH_MANAGED or D3DXMESH_VB_SHARE, Pointer(VertexFormat.GetDeclaration), z3DCore_GetD3DDevice,
  FLODMeshes[z3dsolLow])) then z3DTrace('Iz3DModel.CreateLODMeshes failed: Could not create low-res mesh (ClonePMesh failed)', z3DtkError);
  if FAILED(FLODMeshes[z3dsolLow].TrimByVertices(FD3DXPMesh.GetMinVertices, FD3DXPMesh.GetMinVertices, nil, nil)) then
  z3DTrace('Iz3DModel.CreateLODMeshes failed: Could not trim low-res mesh (TrimByVertices failed)', z3DtkError);
  if FAILED(FLODMeshes[z3dsolLow].OptimizeBaseLOD(D3DXMESHOPT_VERTEXCACHE, nil)) then
  z3DTrace('Iz3DModel.CreateLODMeshes failed: Could not optimize low-res mesh (OptimizeBaseLOD failed)', z3DtkError);

  // Set the LOD meshes resolution
  FLODMeshes[z3dsolHigh].SetNumVertices(FD3DXPMesh.GetMaxVertices);
  FLODMeshes[z3dsolMid].SetNumVertices(FD3DXPMesh.GetMinVertices + FVertexFactor);
  FLODMeshes[z3dsolLow].SetNumVertices(FD3DXPMesh.GetMinVertices);
end;

procedure Tz3DModel.CreateSubsets(const AD3DXMtrls: PD3DXMaterial; const ACount: Integer);
var I: Integer;
    FSubset: Iz3DModelSubset;
    FExistent: Boolean;
begin
  if AD3DXMtrls = nil then
  begin
    z3DTrace('Iz3DModel.CreateSubsets failed (FD3DXMtrls is NULL)', z3DtkError);
    Exit;
  end;
  if ACount <= 0 then
  begin
    z3DTrace('Iz3DModel.CreateSubsets ignored (Subset count is 0)');
    Exit;
  end;
  for I:= 0 to ACount - 1 do
  begin
    if FSubsets.Count > I then
    begin
      FSubset:= FSubsets[I] as Iz3DModelSubset;
      FExistent:= True;
    end else
    begin
      FSubset:= Tz3DModelSubset.Create(Self);
      FSubsets.Add(FSubset);
      FExistent:= False;
    end;
    if FSubset.Material <> nil then
    begin
      with PD3DXMaterialArray(AD3DXMtrls)[I].MatD3D do
      begin
        if not FExistent then
        begin
          FSubset.Material.ColorDiffuse.From(Diffuse);
          FSubset.Material.ColorEmissive.From(Emissive);
          FSubset.Material.SpecularAmount:= Power / 100;
        end;
      end;

      // Enable the texture if the mesh has one
      z3DMaterialController.MaterialTextureFormat.Expand(FSubset.Material.Texture.FileName, z3DWideBuffer);
      if not FileExists(z3DWideBuffer) and
      (PD3DXMaterialArray(AD3DXMtrls)[I].pTextureFilename <> nil) then
      begin
        StringToWideChar(ExtractFilePath(FFileName)+PD3DXMaterialArray(AD3DXMtrls)[I].pTextureFilename, FSubset.Material.Texture.FileName, 255);
        FSubset.Material.Texture.Enabled:= FileExists(FSubset.Material.Texture.FileName);
      end else FSubset.Material.Texture.Enabled:= FileExists(z3DWideBuffer);
    end;
  end;
end;

procedure Tz3DModel.GenerateTexCoords;

  procedure GetCoords(const AV1, AV2, AV3: TD3DXVector2;
    var AMinU, AMaxU, AMinV, AMaxV, ADeltaU, ADeltaV: Single);
  begin
    // Get the texture min and max coordinates
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
    ADeltaU:= (AMaxU - AMinU);
    ADeltaV:= (AMaxV - AMinV);
  end;

var I, J: Integer;
    FVB: Pointer;
    FStaticVB: Pz3DStaticModelVertexArray;
    FDynamicVB: Pz3DDynamicModelVertexArray;
    FIB: PWordArray;
    FNormal: Iz3DFloat3;
    FFactorU, FFactorV, FUMin, FVMin, FUMax, FVMax, FUDelta, FVDelta: Single;
begin

  if not FAutoGenerateTexCoords and (FTexCoordsScale = 1) then Exit;

  FVB:= LockVertices;
  FIB:= LockIndices;
  try
    if Self is Tz3DStaticModel then
    begin
      FStaticVB:= Pz3DStaticModelVertexArray(FVB);
      for I:= 0 to FaceCount-1 do
      begin
        if AutoGenerateTexCoords then
        begin
          FFactorU:= 1;
          FFactorV:= 1;
          FNormal:= z3DGetNormal(z3DFloat3.From(FStaticVB[FIB[I*3]].Position),
          z3DFloat3.From(FStaticVB[FIB[I*3+1]].Position), z3DFloat3.From(FStaticVB[FIB[I*3+2]].Position));
          FNormal.Normalize;
          if (Abs(FNormal.X) > Abs(FNormal.Y)) and (Abs(FNormal.X) > Abs(FNormal.Z)) then
          begin
            if BoundingBox.Dimensions.Y < BoundingBox.Dimensions.Z then
            FFactorU:= BoundingBox.Dimensions.Y / BoundingBox.Dimensions.Z else
            FFactorV:= BoundingBox.Dimensions.Z / BoundingBox.Dimensions.Y;
            for J:= 0 to 2 do
            begin
              FStaticVB[FIB[I*3+J]].TexCoord.x:= (FStaticVB[FIB[I*3+J]].Position.y);
              FStaticVB[FIB[I*3+J]].TexCoord.y:= (FStaticVB[FIB[I*3+J]].Position.z);
            end;
          end else
          if (Abs(FNormal.Y) > Abs(FNormal.X)) and (Abs(FNormal.Y) > Abs(FNormal.Z)) then
          begin
            if BoundingBox.Dimensions.X < BoundingBox.Dimensions.Z then
            FFactorU:= BoundingBox.Dimensions.X / BoundingBox.Dimensions.Z else
            FFactorV:= BoundingBox.Dimensions.Z / BoundingBox.Dimensions.X;
            for J:= 0 to 2 do
            begin
              FStaticVB[FIB[I*3+J]].TexCoord.x:= (FStaticVB[FIB[I*3+J]].Position.x);
              FStaticVB[FIB[I*3+J]].TexCoord.y:= (FStaticVB[FIB[I*3+J]].Position.z);
            end;
          end else
          begin
            if BoundingBox.Dimensions.X < BoundingBox.Dimensions.Y then
            FFactorU:= BoundingBox.Dimensions.X / BoundingBox.Dimensions.Y else
            FFactorV:= BoundingBox.Dimensions.Y / BoundingBox.Dimensions.X;
            for J:= 0 to 2 do
            begin
              FStaticVB[FIB[I*3+J]].TexCoord.x:= (FStaticVB[FIB[I*3+J]].Position.x);
              FStaticVB[FIB[I*3+J]].TexCoord.y:= (FStaticVB[FIB[I*3+J]].Position.y);
            end;
          end;

          // Obtain the absolute texcoords
          GetCoords(FStaticVB[FIB[I*3]].TexCoord, FStaticVB[FIB[I*3+1]].TexCoord,
          FStaticVB[FIB[I*3+2]].TexCoord, FUMin, FUMax, FVMin, FVMax, FUDelta, FVDelta);

          for J:= 0 to 2 do
          begin
            FStaticVB[FIB[I*3+J]].TexCoord.x:= ((FStaticVB[FIB[I*3+J]].TexCoord.x - FUMin) / FUDelta) * FTexCoordsScale * FFactorU;
            FStaticVB[FIB[I*3+J]].TexCoord.y:= ((FStaticVB[FIB[I*3+J]].TexCoord.y - FUMin) / FUDelta) * FTexCoordsScale * FFactorV;
          end;
        end else
        for J:= 0 to 2 do
        begin
          FStaticVB[FIB[I*3+J]].TexCoord.x:= FStaticVB[FIB[I*3+J]].TexCoord.x * FTexCoordsScale;
          FStaticVB[FIB[I*3+J]].TexCoord.y:= FStaticVB[FIB[I*3+J]].TexCoord.y * FTexCoordsScale;
        end;
      end;
    end else
    begin
      FDynamicVB:= Pz3DDynamicModelVertexArray(FVB);
      for I:= 0 to FaceCount-1 do
      begin
        if FAutoGenerateTexCoords then
        begin
          FFactorU:= 1;
          FFactorV:= 1;
          FNormal:= z3DGetNormal(z3DFloat3.From(FDynamicVB[FIB[I*3]].Position),
          z3DFloat3.From(FDynamicVB[FIB[I*3+1]].Position), z3DFloat3.From(FDynamicVB[FIB[I*3+2]].Position));
          FNormal.Normalize;
          if (Abs(FNormal.X) > Abs(FNormal.Y)) and (Abs(FNormal.X) > Abs(FNormal.Z)) then
          begin
            if BoundingBox.Dimensions.Y < BoundingBox.Dimensions.Z then
            FFactorU:= BoundingBox.Dimensions.Y / BoundingBox.Dimensions.Z else
            FFactorV:= BoundingBox.Dimensions.Z / BoundingBox.Dimensions.Y;
            for J:= 0 to 2 do
            begin
              FDynamicVB[FIB[I*3+J]].TexCoord.x:= (FDynamicVB[FIB[I*3+J]].Position.y);
              FDynamicVB[FIB[I*3+J]].TexCoord.y:= (FDynamicVB[FIB[I*3+J]].Position.z);
            end;
          end else
          if (Abs(FNormal.Y) > Abs(FNormal.X)) and (Abs(FNormal.Y) > Abs(FNormal.Z)) then
          begin
            if BoundingBox.Dimensions.X < BoundingBox.Dimensions.Z then
            FFactorU:= BoundingBox.Dimensions.X / BoundingBox.Dimensions.Z else
            FFactorV:= BoundingBox.Dimensions.Z / BoundingBox.Dimensions.X;
            for J:= 0 to 2 do
            begin
              FDynamicVB[FIB[I*3+J]].TexCoord.x:= (FDynamicVB[FIB[I*3+J]].Position.x);
              FDynamicVB[FIB[I*3+J]].TexCoord.y:= (FDynamicVB[FIB[I*3+J]].Position.z);
            end;
          end else
          begin
            if BoundingBox.Dimensions.X < BoundingBox.Dimensions.Y then
            FFactorU:= BoundingBox.Dimensions.X / BoundingBox.Dimensions.Y else
            FFactorV:= BoundingBox.Dimensions.Y / BoundingBox.Dimensions.X;
            for J:= 0 to 2 do
            begin
              FDynamicVB[FIB[I*3+J]].TexCoord.x:= (FDynamicVB[FIB[I*3+J]].Position.x);
              FDynamicVB[FIB[I*3+J]].TexCoord.y:= (FDynamicVB[FIB[I*3+J]].Position.y);
            end;
          end;

          // Obtain the absolute texcoords
          GetCoords(FDynamicVB[FIB[I*3]].TexCoord, FDynamicVB[FIB[I*3+1]].TexCoord,
          FDynamicVB[FIB[I*3+2]].TexCoord, FUMin, FUMax, FVMin, FVMax, FUDelta, FVDelta);
          for J:= 0 to 2 do
          begin
            FDynamicVB[FIB[I*3+J]].TexCoord.x:= ((FDynamicVB[FIB[I*3+J]].TexCoord.x - FUMin) / FUDelta) * FTexCoordsScale * FFactorU;
            FDynamicVB[FIB[I*3+J]].TexCoord.y:= ((FDynamicVB[FIB[I*3+J]].TexCoord.y - FUMin) / FUDelta) * FTexCoordsScale * FFactorV;
          end;
        end else
        for J:= 0 to 2 do
        begin
          FStaticVB[FIB[I*3+J]].TexCoord.x:= FStaticVB[FIB[I*3+J]].TexCoord.x * FTexCoordsScale;
          FStaticVB[FIB[I*3+J]].TexCoord.y:= FStaticVB[FIB[I*3+J]].TexCoord.x * FTexCoordsScale;
        end;
      end;
    end;

  finally
    UnlockVertices;
    UnlockIndices;
  end;
end;

function Tz3DModel.GetBoundingBox: Iz3DBoundingBox;
begin
  Result:= FBoundingBox;
end;

function Tz3DModel.GetAutoGenerateTexCoords: Boolean;
begin
  Result:= FAutoGenerateTexCoords;
end;

function Tz3DModel.GetBoundingSphere: Iz3DBoundingSphere;
begin
  Result:= FBoundingSphere;
end;

function Tz3DModel.GetFaceCount: Integer;
begin
  Result:= FFaceCount;
end;

function Tz3DModel.GetFileName: PWideChar;
begin
  Result:= FFileName;
end;

function Tz3DModel.GetInstance(const AIndex: Integer): Iz3DModelInstance;
begin
  Result:= FInstances[AIndex] as Iz3DModelInstance;
end;

function Tz3DModel.GetInstancingMethod: Tz3DModelInstancingMethod;
begin
  Result:= FInstancingMethod;
end;

function Tz3DModel.GetLockAspectRatio: Boolean;
begin
  Result:= FLockAspectRatio;
end;

function Tz3DModel.GetLockTexCoordsAspectRatio: Boolean;
begin
  Result:= FLockTexCoordsAspectRatio;
end;

function Tz3DModel.GetShape: Tz3DScenarioObjectShape;
begin
  Result:= FShape;
end;

function Tz3DModel.GetSubsetCount: Integer;
begin
  Result:= FSubsets.Count;
end;

function Tz3DModel.GetSubsets(const I: Integer): Iz3DModelSubset;
begin
  Result:= FSubsets[I] as Iz3DModelSubset;
end;

function Tz3DModel.GetTexCoordsScale: Single;
begin
  Result:= FTexCoordsScale;
end;

function Tz3DModel.GetVertexCount: Integer;
begin
  Result:= FVertexCount;
end;

function Tz3DModel.LockIndices(const AFlags: DWORD): PWordArray;
begin
  if FAILED(FMesh.LockIndexBuffer(AFlags, Pointer(Result))) then
  begin
    z3DTrace('Iz3DModel.LockIndices failed: Could not lock index buffer', z3DtkWarning);
    Exit;
  end;
end;

function Tz3DModel.LockVertices(const AFlags: DWORD): Pointer;
begin
  if FAILED(FMesh.LockVertexBuffer(AFlags, Pointer(Result))) then
  begin
    z3DTrace('Iz3DModel.LockVertices failed: Could not lock vertex buffer', z3DtkWarning);
    Exit;
  end;
end;

procedure Tz3DModel.SetAutoGenerateTexCoords(const Value: Boolean);
begin
  FAutoGenerateTexCoords:= Value;
end;

procedure Tz3DModel.SetDeclaration(const ADeclaration: PD3DVertexElement9);
var FTempMesh: ID3DXMesh;
    FHadNormal, FHadTexCoord, FHadLightCoord, FHadTangent: Boolean;
    FIndex: Integer;
    FOldDecl, FNewDecl: TFVFDeclaration;
    FHaveNormal, FHaveTexCoord, FHaveLightCoord, FHaveTangent: Boolean;
    FNewMesh: ID3DXMesh;
    FAdjacency: PDWORD;
    FPartialEdgeThreshold: Single;
    FSingularPointThreshold: Single;
    FNormalEdgeThreshold: Single;
begin
  if z3DTraceCondition(FMesh = nil, 'Iz3DModel.SetDeclaration failed (FMesh is NULL)', z3DtkWarning) then Exit;
  if FAILED(FMesh.CloneMesh(FMesh.GetOptions, ADeclaration, z3DCore_GetD3DDevice, FTempMesh)) then
  begin
    z3DTrace('Iz3DModel.SetDeclaration failed (CloneMesh failed)', z3DtkWarning);
    Exit;
  end;

  // Compute normals and tangents if requested
  FHadNormal:= False;
  FHadTexCoord:= False;
  FHadLightCoord:= False;
  FHadTangent:= False;
  if SUCCEEDED(FMesh.GetDeclaration(FOldDecl)) then
  begin
    for FIndex:= 0 to D3DXGetDeclLength(@FOldDecl) - 1 do
    begin
      if (FOldDecl[FIndex].Usage = D3DDECLUSAGE_NORMAL) then FHadNormal:= True;
      if (FOldDecl[FIndex].Usage = D3DDECLUSAGE_TEXCOORD) and (FOldDecl[FIndex].UsageIndex = 0) then FHadTexCoord:= True;
      if (FOldDecl[FIndex].Usage = D3DDECLUSAGE_TEXCOORD) and (FOldDecl[FIndex].UsageIndex = 1) then FHadLightCoord:= True;
      if (FOldDecl[FIndex].Usage = D3DDECLUSAGE_TANGENT) then FHadTangent:= True;
    end;
  end else z3DTrace('Iz3DModel.SetDeclaration: Could not retrieve original declaration');
  FHaveNormal:= False;
  FHaveTexCoord:= False;
  FHaveLightCoord:= False;
  FHaveTangent:= False;
  if SUCCEEDED(FTempMesh.GetDeclaration(FNewDecl)) then
  begin
    for FIndex:= 0 to D3DXGetDeclLength(@FNewDecl) - 1 do
    begin
      if (FNewDecl[FIndex].Usage = D3DDECLUSAGE_NORMAL) then FHaveNormal:= True;
      if (FNewDecl[FIndex].Usage = D3DDECLUSAGE_TEXCOORD) and (FNewDecl[FIndex].UsageIndex = 0) then FHaveTexCoord:= True;
      if (FNewDecl[FIndex].Usage = D3DDECLUSAGE_TEXCOORD) and (FNewDecl[FIndex].UsageIndex = 1) then FHaveLightCoord:= True;
      if (FNewDecl[FIndex].Usage = D3DDECLUSAGE_TANGENT) then FHaveTangent:= True;
    end;
  end else z3DTrace('Iz3DModel.SetDeclaration: Could not retrieve new declaration');

  FMesh:= FTempMesh;

  // Compute normals
  if not FHadNormal and FHaveNormal then
  if FAILED(D3DXComputeNormals(FMesh, nil)) then
  z3DTrace('Iz3DModel.SetDeclaration: D3DXComputeNormals failed', z3DtkWarning);

  // Optimize vertices for tangents
  if FHaveNormal and not FHadTangent and FHaveTangent then
  begin
    try
      GetMem(FAdjacency, SizeOf(DWORD) * FMesh.GetNumFaces * 3);
    except
      on EOutOfMemory do
      begin
        z3DTrace('Iz3DModel.SetDeclaration failed (Out of memory)', z3DtkError);
        Exit;
      end;
    end;
    FMesh.GenerateAdjacency(1e-6, FAdjacency);
    FPartialEdgeThreshold:= 0.01;
    FSingularPointThreshold:= 0.25;
    FNormalEdgeThreshold:= 0.01;
    if FAILED(D3DXComputeTangentFrameEx(FMesh, DWORD(D3DDECLUSAGE_TEXCOORD), 0,
    DWORD(D3DDECLUSAGE_TANGENT), 0, D3DX_DEFAULT, 0, DWORD(D3DDECLUSAGE_NORMAL), 0,
    0, FAdjacency, FPartialEdgeThreshold, FSingularPointThreshold, FNormalEdgeThreshold, FNewMesh, nil)) then
    z3DTrace('Iz3DModel.SetDeclaration: D3DXComputeTangentFrameEx failed', z3DtkWarning) else
    FMesh:= FNewMesh;
    FreeMem(FAdjacency);
  end;

  // Compute texcoords
  if FHaveTexCoord then GenerateTexCoords;

  // Save a flag indicating that light coords need to be computed
  FComputeLightCoords:= not FHadLightCoord and FHaveLightCoord;

  // Compute tangent frame
  if FHaveNormal and not FHadTangent and FHaveTangent then
  begin
    try
      GetMem(FAdjacency, SizeOf(DWORD) * FMesh.GetNumFaces * 3);
    except
      on EOutOfMemory do
      begin
        z3DTrace('Iz3DModel.SetDeclaration failed (Out of memory)', z3DtkError);
        Exit;
      end;
    end;
    FMesh.GenerateAdjacency(1e-6, FAdjacency);
    FPartialEdgeThreshold:= 0.01;
    FSingularPointThreshold:= 0.25;
    FNormalEdgeThreshold:= 0.01;
    if FAILED(D3DXComputeTangentFrameEx(FMesh, DWORD(D3DDECLUSAGE_TEXCOORD), 0,
    DWORD(D3DDECLUSAGE_TANGENT), 0, D3DX_DEFAULT, 0, DWORD(D3DDECLUSAGE_NORMAL), 0,
    D3DXTANGENT_CALCULATE_NORMALS, FAdjacency, FPartialEdgeThreshold, FSingularPointThreshold,
    FNormalEdgeThreshold, FNewMesh, nil)) then
    z3DTrace('Iz3DModel.SetDeclaration: D3DXComputeTangentFrameEx failed', z3DtkWarning) else
    FMesh:= FNewMesh;
    FreeMem(FAdjacency);
  end;

  // Refresh current vertex values
  FVertexCount:= FMesh.GetNumVertices;
  FFaceCount:= FMesh.GetNumFaces;
  FBytesPerVertex:= FMesh.GetNumBytesPerVertex;
end;

procedure Tz3DModel.SetInstancingMethod(const Value: Tz3DModelInstancingMethod);
begin
  FInstancingMethod:= Value;
end;

procedure Tz3DModel.SetLockAspectRatio(const Value: Boolean);
begin
  FLockAspectRatio:= Value;
end;

procedure Tz3DModel.SetLockTexCoordsAspectRatio(const Value: Boolean);
begin
  FLockTexCoordsAspectRatio:= Value;
end;

procedure Tz3DModel.SetShape(const Value: Tz3DScenarioObjectShape);
begin
  if FShape <> Value then
  begin
    FShape:= Value;
    ComputeBounds;
  end;
end;

procedure Tz3DModel.SetTexCoordsScale(const Value: Single);
begin
  FTexCoordsScale:= Value;
end;

procedure Tz3DModel.UnlockIndices;
begin
  FMesh.UnlockIndexBuffer;
end;

procedure Tz3DModel.UnlockVertices;
begin
  FMesh.UnlockVertexBuffer;
end;

procedure Tz3DModel.CreateScenarioObjects;
var I: Integer;
begin
  CreateModel;
  for I:= 0 to InstanceCount-1 do Instances[I].ComputeTransforms;
end;

procedure Tz3DModel.DestroyScenarioObjects;
begin
  FMesh:= nil;
  FLODMeshes[z3dsolLow]:= nil;
  FLODMeshes[z3dsolMid]:= nil;
  FLODMeshes[z3dsolHigh]:= nil;
end;

procedure Tz3DModel.FrameMove;
var I: Integer;
begin
  for I:= 0 to FInstances.Count-1 do Instances[I].FrameMove;
end;

procedure Tz3DModel.FrameRender;
var I: Integer;
begin
  for I:= 0 to InstanceCount-1 do Instances[I].FrameRender;
end;

procedure Tz3DModel.FrameRenderAmbient;
var I: Integer;
begin
  for I:= 0 to InstanceCount-1 do Instances[I].FrameRenderAmbient;
end;

procedure Tz3DModel.FrameRenderDirectLighting;
var I: Integer;
begin
  for I:= 0 to InstanceCount-1 do Instances[I].FrameRenderDirectLighting;
end;

function Tz3DModel.GetBytesPerVertex: Integer;
begin
  Result:= FBytesPerVertex;
end;

function Tz3DModel.GetScale: Iz3DFloat3;
begin
  Result:= FScale;
end;

procedure Tz3DModel.ComputeBounds;
var I: Integer;
begin
  if FMesh = nil then Exit;
  FOSBoundingSphere.ComputeFromMesh(FMesh);
  FOSBoundingBox.ComputeFromMesh(FMesh);
  if Shape = z3dsosSphere then
  begin
    BoundingBox.Dimensions.X:= BoundingSphere.Radius * 2;
    BoundingBox.Dimensions.Y:= BoundingBox.Dimensions.X;
    BoundingBox.Dimensions.Z:= BoundingBox.Dimensions.X;
    Scale.X:= FBoundingSphere.Radius / FOSBoundingSphere.Radius;
    Scale.Y:= Scale.X;
    Scale.Z:= Scale.X;
  end else
  begin
    BoundingSphere.Radius:= Max(Max(BoundingBox.Dimensions.X, BoundingBox.Dimensions.Y), BoundingBox.Dimensions.Z) / 2;
    Scale.X:= BoundingBox.Dimensions.X / OSBoundingBox.Dimensions.X;
    Scale.Y:= BoundingBox.Dimensions.Y / OSBoundingBox.Dimensions.Y;
    Scale.Z:= BoundingBox.Dimensions.Z / OSBoundingBox.Dimensions.Z;
  end;
  for I:= 0 to InstanceCount-1 do Instances[I].ComputeBounds;
end;

procedure Tz3DModel.PrepareMesh(const AShader: Iz3DShader; const ASetMaterial: Boolean = True;
  const ADirectLighting: Boolean = True);
begin
  // Future use
end;


procedure Tz3DModel.RenderMesh(const AShader: Iz3DShader; const ALOD: Tz3DScenarioObjectLOD = z3dsolHigh;
  const ASetMaterial: Boolean = True; const ADirectLighting: Boolean = True;
  const ALightMap: Boolean = False);
var I: Integer;
    FVB: IDirect3DVertexBuffer9;
    FIB: IDirect3DIndexBuffer9;
begin

  if FMesh = nil then CreateModel;

  if not ASetMaterial or (GLastModel = Self as Iz3DModel) then AShader.Commit;
  { TODO JP: DIVIDIR EN SUBSETS PARA APLICAR MATERIALES }
  for I:= 0 to {SubsetCount-1}0 do
  begin

    if ASetMaterial and
    (GLastModel <> Self as Iz3DModel) then
    begin

      // Set the material properties
      AShader.Float2['GMaterialAlbedoFactor']:= Subsets[I].Material.AlbedoFactor;
      AShader.Color['GMaterialDiffuseColor']:= Subsets[I].Material.ColorDiffuse;
      AShader.Float3['GMaterialEmissiveColor']:= Subsets[I].Material.ColorEmissive;
      if ADirectLighting and z3DLightingController.CurrentLight.Effects.Specular then
      AShader.Param['GMaterialSpecularAmount']:= Subsets[I].Material.SpecularAmount;

      // Set the material texture
      if Subsets[I].Material.Texture.Enabled then
      begin
        Subsets[I].Material.Texture.AttachToSampler(0, True, True);
        if ADirectLighting and z3DLightingController.CurrentLight.Effects.NormalMapping then
        Subsets[I].Material.Texture.NormalMapTexture.AttachToSampler(1, True, True);
      end else
      begin
        z3DMaterialController.DefaultTexture.AttachToSampler(0, True, True);
        if ADirectLighting and z3DLightingController.CurrentLight.Effects.NormalMapping then
        z3DMaterialController.DefaultTexture.NormalMapTexture.AttachToSampler(1, True, True);
      end;

      // Apply current changes
      AShader.Commit;
    end;
    GLastModel:= Self as Iz3DModel;

    // Draw the mesh
    if ((Self is Tz3DStaticModel) and ALightMap) or not FGenerateLODMeshes then
    begin
      if GLastMesh <> FMesh as ID3DXBaseMesh then
      begin
        FMesh.GetVertexBuffer(FVB);
        FMesh.GetIndexBuffer(FIB);
        z3DCore_GetD3DDevice.SetStreamSource(0, FVB, 0, VertexFormat.VertexSize);
        z3DCore_GetD3DDevice.SetIndices(FIB);
        GLastMesh:= FMesh as ID3DXBaseMesh;
      end;
      z3DCore_GetD3DDevice.DrawIndexedPrimitive(D3DPT_TRIANGLELIST, 0, 0, VertexCount, 0, FaceCount);
    end else
    begin
      if GLastMesh <> LODMeshes[ALOD] as ID3DXBaseMesh then
      begin
        LODMeshes[ALOD].GetVertexBuffer(FVB);
        LODMeshes[ALOD].GetIndexBuffer(FIB);
        z3DCore_GetD3DDevice.SetStreamSource(0, FVB, 0, VertexFormat.VertexSize);
        z3DCore_GetD3DDevice.SetIndices(FIB);
        GLastMesh:= LODMeshes[ALOD] as ID3DXBaseMesh;
      end;
      z3DCore_GetD3DDevice.DrawIndexedPrimitive(D3DPT_TRIANGLELIST, 0, 0, LODVertexCount[ALOD], 0, LODFaceCount[ALOD]);
    end;
  end;
end;

function Tz3DModel.GetOSBoundingBox: Iz3DBoundingBox;
begin
  Result:= FOSBoundingBox;
end;

function Tz3DModel.GetOSBoundingSphere: Iz3DBoundingSphere;
begin
  Result:= FOSBoundingSphere;
end;

function Tz3DModel.GetInstanceCount: Integer;
begin
  Result:= FInstances.Count;
end;

function Tz3DModel.AddSubset: Iz3DModelSubset;
begin
  Result:= Tz3DModelSubset.Create(Self);
  FSubsets.Add(Result); 
end;

procedure Tz3DModel.RemoveSubset(const ASubset: Iz3DModelSubset);
begin
  FSubsets.Remove(ASubset);
end;

procedure Tz3DModel.RemoveInstance(const AInstance: Iz3DModelInstance);
begin
  FInstances.Remove(AInstance);
  z3DModelController.BuildRenderOrders;
end;

function Tz3DModel.GetInstanceList: IInterfaceList;
begin
  Result:= FInstances;
end;

function Tz3DModel.GetSubsetList: IInterfaceList;
begin
  Result:= FSubsets;
end;

procedure Tz3DModel.SetFileName(const Value: PWideChar);
begin
  StringToWideChar(WideCharToString(Value), FFileName, 255);
end;

function Tz3DModel.GetMesh: ID3DXMesh;
begin
  Result:= FMesh;
end;

function Tz3DModel.GetLODMeshes: Tz3DLODMeshes;
begin
  if not GenerateLODMeshes then
  begin
    z3DTrace('Iz3DModel.GetLODMeshes failed: LOD meshes generation set to FALSE', z3DtkWarning);
    Exit;
  end;
  Result:= FLODMeshes;
end;

function Tz3DModel.GetComputeLightCoords: Boolean;
begin
  Result:= FComputeLightCoords;
end;

procedure Tz3DModel.SetComputeLightCoords(const Value: Boolean);
begin
  FComputeLightCoords:= Value;
end;

function Tz3DModel.GetName: PWideChar;
begin
  Result:= FName;
end;

function Tz3DModel.IndexOf(const AInstance: Iz3DModelInstance): Integer;
begin
  Result:= FInstances.IndexOf(AInstance);
end;

procedure Tz3DModel.SetName(const Value: PWideChar);
begin
  StringToWideChar(WideCharToString(Value), FName, 255);
end;

function Tz3DModel.GetVertexFormat: Iz3DVertexFormat;
begin
  if z3DSupports(Self, Iz3DStaticModel) then
  Result:= z3DModelController.StaticVertexFormat else
  Result:= z3DModelController.DynamicVertexFormat;
end;

function Tz3DModel.LockLODVertices(const ALOD: Tz3DScenarioObjectLOD; const AFlags: DWORD): Pointer;
begin
  if not GenerateLODMeshes then
  begin
    z3DTrace('Iz3DModel.LockLODVertices failed: LOD meshes generation set to FALSE', z3DtkWarning);
    Exit;
  end;
  FLockLOD:= ALOD;
  if FAILED(FLODMeshes[ALOD].LockVertexBuffer(AFlags, Pointer(Result))) then
  begin
    z3DTrace('Iz3DModel.LockLODVertices failed: Could not lock vertex buffer', z3DtkWarning);
    Exit;
  end;
end;

procedure Tz3DModel.UnlockLODVertices;
begin
  if not GenerateLODMeshes then
  begin
    z3DTrace('Iz3DModel.LockLODVertices failed: LOD meshes generation set to FALSE', z3DtkWarning);
    Exit;
  end;
  FLODMeshes[FLockLOD].UnlockVertexBuffer;
end;

function Tz3DModel.GetLODFaceCount(const ALOD: Tz3DScenarioObjectLOD): Integer;
begin
  if FLODMeshes[ALOD] = nil then Result:= 0 else
  Result:= FLODMeshes[ALOD].GetNumFaces;
end;

function Tz3DModel.GetLODVertexCount(const ALOD: Tz3DScenarioObjectLOD): Integer;
begin
  if FLODMeshes[ALOD] = nil then Result:= 0 else
  Result:= FLODMeshes[ALOD].GetNumVertices;
end;

function Tz3DModel.LockLODIndices(const ALOD: Tz3DScenarioObjectLOD; const AFlags: DWORD): PWordArray;
begin
  if not GenerateLODMeshes then
  begin
    z3DTrace('Iz3DModel.LockLODVertices failed: LOD meshes generation set to FALSE', z3DtkWarning);
    Exit;
  end;
  FLockLOD:= ALOD;
  if FAILED(FLODMeshes[ALOD].LockIndexBuffer(AFlags, Pointer(Result))) then
  begin
    z3DTrace('Iz3DModel.LockLODIndices failed: Could not lock index buffer', z3DtkWarning);
    Exit;
  end;
end;

procedure Tz3DModel.UnlockLODIndices;
begin
  if not GenerateLODMeshes then
  begin
    z3DTrace('Iz3DModel.LockLODVertices failed: LOD meshes generation set to FALSE', z3DtkWarning);
    Exit;
  end;
  FLODMeshes[FLockLOD].UnlockIndexBuffer;
end;

function Tz3DModel.GetGenerateLODMeshes: Boolean;
begin
  Result:= FGenerateLODMeshes;
end;

procedure Tz3DModel.SetGenerateLODMeshes(const Value: Boolean);
begin
  FGenerateLODMeshes:= Value;
end;

{ Tz3DModelInstance }

procedure Tz3DModelInstance.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FCustomBoundingBox:= z3DBoundingBox;
  FCustomBoundingBox.Center.XYZ:= (AOwner as Iz3DModel).BoundingBox.Center.XYZ;
  FCustomBoundingBox.Dimensions.XYZ:= (AOwner as Iz3DModel).BoundingBox.Dimensions.XYZ;
  FCustomBoundingSphere:= z3DBoundingSphere;
  FCustomBoundingSphere.Center.XYZ:= (AOwner as Iz3DModel).BoundingSphere.Center.XYZ;
  FCustomBoundingSphere.Radius:= (AOwner as Iz3DModel).BoundingSphere.Radius;
  FCustomScale:= z3DFloat3.From((AOwner as Iz3DModel).Scale);
  FModel:= AOwner as Iz3DModel;
  FEnableShadows:= True;
  FLookAt:= z3DFloat3;
  FWorldMatrix:= z3DMatrix;
  FWorldViewMatrix:= z3DMatrix;
  FWorldViewProjMatrix:= z3DMatrix;
end;

procedure Tz3DModelInstance.ComputeTransforms;
var FRotation: Iz3DMatrix;
begin
  if FUpdating then Exit;
  FUpdating:= True;
  try
    FRotation:= z3DMatrix.RotateX(FLookAt.X);
    if FLookAt.Y <> 0 then FRotation.Multiply(z3DMatrix.RotateY(FLookAt.Y));
    if FLookAt.Z <> 0 then FRotation.Multiply(z3DMatrix.RotateZ(FLookAt.Z));
    if Model.Shape = z3dsosSphere then
    begin
      FWorldMatrix.Translation((BoundingBox.Center.X / CustomScale.X) - Model.OSBoundingSphere.Center.X,
      (BoundingBox.Center.Y / CustomScale.Y) - Model.OSBoundingSphere.Center.Y,
      (BoundingBox.Center.Z / CustomScale.Z) - Model.OSBoundingSphere.Center.Z);
    end else
    begin
      FWorldMatrix.Translation(BoundingBox.Center.X / CustomScale.X - Model.OSBoundingBox.Center.X,
      BoundingBox.Center.Y / CustomScale.Y - Model.OSBoundingBox.Center.Y,
      BoundingBox.Center.Z / CustomScale.Z - Model.OSBoundingBox.Center.Z);
    end;
    BoundingSphere.Radius:= CustomBoundingSphere.Radius;
    BoundingSphere.Center.From(BoundingBox.Center);
    BoundingBox.Dimensions.From(CustomBoundingBox.Dimensions);
    FWorldMatrix.Multiply(FRotation).Multiply(z3DMatrix.Scale(CustomScale));
  finally
    FUpdating:= False;
  end;
end;

procedure Tz3DModelInstance.FrameMove;
begin
  inherited;
  ComputeViewTransforms;
end;

procedure Tz3DModelInstance.FrameRender;
begin
  RenderDepth;
end;

procedure Tz3DModelInstance.FrameRenderAmbient;
begin
  case z3DLightingController.Stage of

    // Static ambient ligting
    z3dlrsStaticAmbient:
      if (Self is Tz3DModelStaticInstance) and (Tz3DModelStaticInstance(Self).LightMap <> nil) and
      Tz3DModelStaticInstance(Self).LightMap.Enabled and
      Tz3DModelStaticInstance(Self).LightMap.Options.EnableAmbient then
        RenderAmbientLighting;

    // Dynamic ambient ligting
    z3dlrsDynamicAmbient:
      if (Self is Tz3DModelDynamicInstance) or (Tz3DModelStaticInstance(Self).LightMap = nil) or not
      (Tz3DModelStaticInstance(Self).LightMap.Enabled and
      Tz3DModelStaticInstance(Self).LightMap.Options.EnableAmbient) then
        RenderAmbientLighting;

    // SSAO
    z3dlrsSSAO:
      if (((Self is Tz3DModelDynamicInstance) or (Tz3DModelStaticInstance(Self).LightMap = nil) or not
      (Tz3DModelStaticInstance(Self).LightMap.Enabled and
      Tz3DModelStaticInstance(Self).LightMap.Options.EnableAmbient)) or
      (z3DLightingController.SSAO.Quality = z3dssaoqHigh)) and
      ((SubsetCount = 0) or (Subsets[0].Material.ColorDiffuse.A > ALPHA_UPPER_BOUND)) then
      // TODO JP: RenderAmbientLighting esta renderizando el agua. HACER ESPECIFICO
        RenderSSAO else RenderAmbientLighting;
  end;
end;

procedure Tz3DModelInstance.FrameRenderDirectLighting;
begin
  case z3DLightingController.CurrentLight.Stage of

    // Static shadow mapping
    z3ddlrsStaticShadows:
      if EnableShadows and (Self is Tz3DModelStaticInstance) and
      ((SubsetCount = 0) or (Subsets[0].Material.ColorDiffuse.A > ALPHA_UPPER_BOUND)) then
      RenderShadowMap;

    // Static lighting
    z3ddlrsStaticLighting:
      if (Self is Tz3DModelStaticInstance) and (Tz3DModelStaticInstance(Self).LightMap <> nil) and
      Tz3DModelStaticInstance(Self).LightMap.Enabled then
      Tz3DModelStaticInstance(Self).RenderStaticLighting;

    // Dynamic shadow mapping
    z3ddlrsDynamicShadows:
      if EnableShadows and not ((Self is Tz3DModelStaticInstance) and z3DLightingController.CurrentLight.Static)
      and ((SubsetCount = 0) or (Subsets[0].Material.ColorDiffuse.A > ALPHA_UPPER_BOUND)) then
      RenderShadowMap;

    // Dynamic lighting
    z3ddlrsDynamicLighting:
      if not ((Self is Tz3DModelStaticInstance) and (Tz3DModelStaticInstance(Self).LightMap <> nil) and
      Tz3DModelStaticInstance(Self).LightMap.Enabled and z3DLightingController.CurrentLight.Static) then
        RenderDynamicLighting;
  end;
end;

function Tz3DModelInstance.GetEnableShadows: Boolean;
begin
  Result:= FEnableShadows;
end;

function Tz3DModelInstance.GetLookAt: Iz3DFloat3;
begin
  Result:= FLookAt;
end;

function Tz3DModelInstance.GetModel: Iz3DModel;
begin
  Result:= FModel;
end;

procedure Tz3DModelInstance.SetEnableShadows(const Value: Boolean);
begin
  FEnableShadows:= Value;
end;

procedure Tz3DModelInstance.RenderAmbientLighting;
var FLR, FLG, FLB: Single;
    I: Integer;
    FTechnique: Tz3DHandle;
begin
  if not FInCameraEnvironment then Exit;
  if not InFrustum then Exit;
  // TODO JP: HACK PARA EL AGUA
  if (z3DLightingController.Stage = z3dlrsSSAO) and not z3DLightingController.OpaqueMode and
  not z3DSupports(Model, Iz3DWaterModel) then Exit;
  if z3DSupports(Model, Iz3DWaterModel) and not ((z3DLightingController.Stage = z3dlrsSSAO) and not z3DLightingController.OpaqueMode) then Exit;

  if (Self is Tz3DModelStaticInstance) and (Tz3DModelStaticInstance(Self).LightMap <> nil) and
  Tz3DModelStaticInstance(Self).LightMap.Enabled and
  Tz3DModelStaticInstance(Self).LightMap.Options.EnableAmbient then
  Tz3DModelStaticInstance(Self).LightMap.AmbientTexture.Texture.AttachToSampler(2, True, True);
  if (Self is Tz3DModelDynamicInstance) then
  begin
    FLR:= 0;
    FLG:= 0;
    FLB:= 0;
    for I:= 0 to Length(Environments)-1 do
    begin
      FLR:= FLR + Environments[I].Environment.AmbientColor.R * Environments[I].Incidence;
      FLG:= FLG + Environments[I].Environment.AmbientColor.G * Environments[I].Incidence;
      FLB:= FLB + Environments[I].Environment.AmbientColor.B * Environments[I].Incidence;
    end;
    z3DLightingController.Shader.Color3['GAmbientColor']:= z3DFloat3(FLR, FLG, FLB);
  end else
  z3DLightingController.Shader.Color3['GAmbientColor']:= z3DScenario.Environment.AmbientColor;
  SetEffectCommonParams;
  Model.RenderMesh(z3DLightingController.Shader, LOD, True, False,
  (Self is Tz3DModelStaticInstance) and (Tz3DModelStaticInstance(Self).LightMap <> nil) and
  Tz3DModelStaticInstance(Self).LightMap.Enabled);
end;

procedure Tz3DModelInstance.RenderSSAO;
begin
  if not FInCameraEnvironment then Exit;
  if not InFrustum then Exit;

  SetEffectCommonParams;
  Model.RenderMesh(z3DLightingController.Shader, LOD, False, False,
  (Self is Tz3DModelStaticInstance) and Tz3DModelStaticInstance(Self).LightMap.Enabled);
end;

procedure Tz3DModelInstance.RenderDynamicLighting;
begin
  if not FInCameraEnvironment then Exit;
  if not InFrustum then Exit;

  if z3DLightingController.CurrentLight.Frustum.TestObjectCulling(Self) then Exit;
  SetEffectCommonParams;
  Model.RenderMesh(z3DLightingController.Shader, LOD, True, True, False);
end;

procedure Tz3DModelInstance.RenderShadowMap;
begin
  if not FInCameraEnvironment then Exit;
  if z3DLightingController.CurrentLight.Frustum.TestObjectCulling(Self) then Exit;

  SetEffectCommonParams;
  Model.RenderMesh(z3DLightingController.Shader, LOD, False, False, False);
end;

procedure Tz3DModelInstance.RenderDepth;
begin
  if not FInCameraEnvironment then Exit;
  if not InFrustum or
  ((SubsetCount > 0) and (Subsets[0].Material.ColorDiffuse.A < ALPHA_UPPER_BOUND)) then Exit;
  SetEffectCommonParams;
  Model.RenderMesh(z3DEngine.CoreShader, LOD, False, False, False);
end;

procedure Tz3DModelInstance.SetEffectCommonParams;
begin
  if z3DEngine.Renderer.RenderStage = z3drsDepth then
  begin
    z3DEngine.CoreShader.Matrix['GWorldViewMatrix']:= FWorldViewMatrix;
    z3DEngine.CoreShader.Matrix['GWorldViewProjectionMatrix']:= FWorldViewProjMatrix;

    // TEMP JP: Hacer mejor (GSSAOOffset permite identificar objetos estáticos y dinámicos
    // dentro del deferred buffer para aplicar el SSAO de calidad alta)
    if (Self is Tz3DModelDynamicInstance) or (Tz3DModelStaticInstance(Self).LightMap = nil) or not
    (Tz3DModelStaticInstance(Self).LightMap.Enabled and
    Tz3DModelStaticInstance(Self).LightMap.Options.EnableAmbient) then
    z3DEngine.CoreShader.Param['GSSAOOffset']:= 2 else
    z3DEngine.CoreShader.Param['GSSAOOffset']:= 0;
  end else
  begin
    z3DLightingController.Shader.Matrix['GWorldMatrix']:= FWorldMatrix;
    z3DLightingController.Shader.Matrix['GWorldViewMatrix']:= FWorldViewMatrix;
    z3DLightingController.Shader.Matrix['GWorldViewProjectionMatrix']:= FWorldViewProjMatrix;
  end;
end;

procedure Tz3DModelInstance.ComputeViewTransforms;
begin
  if InFrustum then
  begin
    // Get the current matrices
    FWorldViewMatrix.From(FWorldMatrix).Multiply(z3DScenario.ViewFrustum.ViewMatrix);
    FWorldViewProjMatrix.From(FWorldViewMatrix).Multiply(z3DScenario.ViewFrustum.ProjectionMatrix);

    // Set the current LOD mesh based on camera distance
//    FViewEdge:= ViewCenter.Z-BoundingSphere.Radius;
//    if FViewEdge > 50 then MeshLOD:= z3dsolLow else
//    if FViewEdge > 10 then MeshLOD:= z3dsolMid else MeshLOD:= z3dsolHigh;
  end;

  // Test if the object shares the same environment as the camera
  if Length((z3DCameraController.ActiveCamera as Iz3DScenarioDynamicObject).Environments) > 0 then
  FInCameraEnvironment:= InEnvironment((z3DCameraController.ActiveCamera as Iz3DScenarioDynamicObject).Environments[0].Environment);
end;

procedure Tz3DModelInstance.BoundsChanged(const Sender: Iz3DBase);
begin
//  if z3DEngine.Scenario.Enabled then ComputeTransforms;
end;

function Tz3DModelInstance.GetWorldMatrix: Iz3DMatrix;
begin
  Result:= FWorldMatrix;
end;

function Tz3DModelInstance.GetShape: Tz3DScenarioObjectShape;
begin
  Result:= Model.Shape;
end;

function Tz3DModelInstance.GetSubsetCount: Integer;
begin
  Result:= Model.SubsetCount;
end;

function Tz3DModelInstance.GetSubsets(const AIndex: Integer): Iz3DScenarioObjectSubset;
begin
  Result:= Model.Subsets[AIndex];
end;

procedure Tz3DModelInstance.Hide;
begin
  Visible:= False;
end;

procedure Tz3DModelInstance.Show;
begin
  Visible:= True;
end;

function Tz3DModelInstance.GetInstanceIndex: Integer;
begin
  Result:= FModel.IndexOf(Self as Iz3DModelInstance);
end;

function Tz3DModelInstance.GetCustomBoundingBox: Iz3DBoundingBox;
begin
  Result:= FCustomBoundingBox;
end;

function Tz3DModelInstance.GetCustomBoundingSphere: Iz3DBoundingSphere;
begin
  Result:= FCustomBoundingSphere;
end;

procedure Tz3DModelInstance.ComputeBounds;
begin
  if Shape = z3dsosSphere then
  begin
    CustomBoundingBox.Dimensions.X:= CustomBoundingSphere.Radius * 2;
    CustomBoundingBox.Dimensions.Y:= CustomBoundingBox.Dimensions.X;
    CustomBoundingBox.Dimensions.Z:= CustomBoundingBox.Dimensions.X;
    CustomScale.X:= CustomBoundingSphere.Radius / FModel.OSBoundingSphere.Radius;
    CustomScale.Y:= CustomScale.X;
    CustomScale.Z:= CustomScale.X;
  end else
  begin
    CustomBoundingSphere.Radius:= Max(Max(CustomBoundingBox.Dimensions.X, CustomBoundingBox.Dimensions.Y), CustomBoundingBox.Dimensions.Z) / 2;
    CustomScale.X:= CustomBoundingBox.Dimensions.X / FModel.OSBoundingBox.Dimensions.X;
    CustomScale.Y:= CustomBoundingBox.Dimensions.Y / FModel.OSBoundingBox.Dimensions.Y;
    CustomScale.Z:= CustomBoundingBox.Dimensions.Z / FModel.OSBoundingBox.Dimensions.Z;
  end;
  ComputeTransforms;
end;

function Tz3DModelInstance.GetCustomScale: Iz3DFloat3;
begin
  Result:= FCustomScale;
end;

{ Tz3DStaticModel }

function Tz3DStaticModel.CreateInstance: Iz3DModelStaticInstance;
begin
  Result:= Tz3DModelStaticInstance.Create(Self);
  FInstances.Add(Result as Iz3DModelInstance);
  z3DModelController.BuildRenderOrders;
end;

procedure Tz3DStaticModel.Init;
begin
  inherited;
  FInstances:= TInterfaceList.Create;
end;

function Tz3DStaticModel.ProcessStaticLighting(const AStage: Tz3DModelLightMapProcessStage): Boolean;
var I: Integer;
begin
  Result:= False;
  for I:= 0 to InstanceCount - 1 do
  if (Instances[I] as Iz3DModelStaticInstance).ProcessStaticLighting(AStage) then
  Result:= True;
end;

{ Tz3DDynamicModel }

function Tz3DDynamicModel.CreateInstance: Iz3DModelDynamicInstance;
begin
  Result:= Tz3DModelDynamicInstance.Create(Self);
  FInstances.Add(Result as Iz3DModelInstance);
  z3DModelController.BuildRenderOrders;
end;

procedure Tz3DDynamicModel.Init;
begin
  inherited;
  FInstances:= TInterfaceList.Create;
end;

{ Tz3DModelStaticInstance }

procedure Tz3DModelStaticInstance.Init(const AOwner: Iz3DBase);
begin
  inherited;
  if z3DLightMapController <> nil then
  begin
    FLightMap:= z3DLightMapController.CreateLightMap;
    // TODO JP: CHANCHO
    if z3DSupports(Model, Iz3DWaterModel) then FLightMap.Enabled:= False;
    FLightMap.OnProgress:= LightMapProgress;
  end;
end;

function Tz3DModelStaticInstance.GetLightMap: Iz3DLightMap;
begin
  Result:= FLightMap;
end;

procedure Tz3DModelStaticInstance.RenderStaticLighting;
begin
  if not FInCameraEnvironment then Exit;
  if not InFrustum then Exit;
  
  if not (LightMap.Enabled and LightMap.Options.EnableRadiosity) and
  z3DLightingController.CurrentLight.Frustum.TestObjectCulling(Self) then Exit;
  if LightMap.Enabled then
  begin
    LightMap.LightTextures[z3DLightingController.CurrentLight.Index].Texture.AttachToSampler(2, True, True);
    if LightMap.Options.EnableRadiosity then
    LightMap.RadiosityTextures[z3DLightingController.CurrentLight.Index].Texture.AttachToSampler(3, True, True);
  end;
  SetEffectCommonParams;
  Model.RenderMesh(z3DLightingController.Shader, LOD, True, True, LightMap.Enabled);
end;

function Tz3DModelStaticInstance.ProcessStaticLighting(const AStage: Tz3DModelLightMapProcessStage): Boolean;
var FAdjacency: Tz3DDWordArray;
begin
  Result:= False;
  if (LightMap = nil) or not LightMap.Enabled then Exit;
  case AStage of

    // Create the lightmap and compute UV coordinates if needed
    z3dlmpsBeginGeneration:
    begin
      if not LightMap.Generated then
      begin
        StringToWideChar(Model.Name+IntToStr(Model.IndexOf(Self as Iz3DModelInstance)), z3DWideBuffer, 255);
        LightMap.UniqueName:= z3DWideBuffer;
        try
          SetLength(FAdjacency, SizeOf(DWORD) * Model.FaceCount * 3);
        except
          on EOutOfMemory do
          begin
            z3DTrace('Iz3DModel.ProcessStaticLighting failed (Out of memory)', z3DtkError);
            Exit;
          end;
        end;
        Model.Mesh.GenerateAdjacency(1e-6, @FAdjacency[0]);
      end;
      Result:= LightMap.BeginGeneration(Self, @FAdjacency, Model.ComputeLightCoords);
      Model.ComputeLightCoords:= False;
    end;

    // Begin the radiosity computation
    z3dlmpsBeginRadiosity:
      if not LightMap.Generated then LightMap.BeginRadiosity;

    // Begin a new radiosity bounce computation
    z3dlmpsBeginRadiosityBounce:
      if not LightMap.Generated then Result:= LightMap.PerformRadiosityBounce;

    // End the last radiosity bounce computation
    z3dlmpsEndRadiosityBounce:
      if not LightMap.Generated then LightMap.EndRadiosityBounce;

    // End the radiosity computation
    z3dlmpsEndRadiosity:
      if not LightMap.Generated then LightMap.EndRadiosity;

    // End the radiosity computation
    z3dlmpsEndGeneration:
      if not LightMap.Generated then LightMap.EndGeneration;
  end;
end;

procedure Tz3DModelStaticInstance.LightMapProgress(const AStep: Tz3DLightMapGenerationStep;
  const ARadiosityLevel, APercent: Integer);
begin
//  EXIT;
  
  if ARadiosityLevel = -1 then
  StringToWideChar(Format('Creating lightmaps... Step %d of %d, Model %d of %d...', [
  Integer(AStep)+1, 4, Index+1, z3DModelController.StaticModelCount]), z3DWideBuffer, 255) else
  StringToWideChar(Format('Solving radiosity... Level %d of %d, Model %d of %d...', [
  ARadiosityLevel+1, LightMap.Options.RadiosityBounces, Index+1,
  z3DModelController.StaticModelCount]), z3DWideBuffer, 255);
  z3DEngine.Desktop.ProgressDialog.Status:= z3DWideBuffer;
  z3DEngine.Desktop.ProgressDialog.SetProgress(APercent);
  z3DCore_ProcessMessages;
end;

{ Tz3DModelDynamicInstance }

constructor Tz3DModelDynamicInstance.Create(const AOwner: Iz3DBase = nil);
begin
  inherited;
  BoundingBox.Center.OnChange:= BoundsChanged;
  BoundingBox.Dimensions.OnChange:= BoundsChanged;
  BoundingSphere.Center.OnChange:= BoundsChanged;
  FAcceleration:= z3DFloat3;
  FVelocity:= z3DFloat3;
  FVelocity.OnChange:= VelocityChanged;
  FGround:= False;
  FEnablePhysics:= True;
end;

procedure Tz3DModelDynamicInstance.FrameMove;
begin
  if Ground then Acceleration.Y:= Max(Acceleration.Y, 0);
  Velocity.Add(z3DFloat3.From(Acceleration).Scale(z3DCore_GetElapsedTime));
  BoundingBox.Center.Add(z3DFloat3.From(Velocity).Scale(z3DCore_GetElapsedTime));
  BoundingSphere.Center.From(BoundingBox.Center);
  ComputeTransforms;
  inherited;
end;

function Tz3DModelDynamicInstance.GetAcceleration: Iz3DFloat3;
begin
  Result:= FAcceleration;
end;

function Tz3DModelDynamicInstance.GetEnablePhysics: Boolean;
begin
  Result:= FEnablePhysics;
end;

function Tz3DModelDynamicInstance.GetGround: Boolean;
begin
  Result:= FGround;
end;

function Tz3DModelDynamicInstance.GetVelocity: Iz3DFloat3;
begin
  Result:= FVelocity;
end;

procedure Tz3DModelDynamicInstance.SetEnablePhysics(const Value: Boolean);
begin
  FEnablePhysics:= Value;
end;

procedure Tz3DModelDynamicInstance.SetGround(const Value: Boolean);
begin
  FGround:= Value;
end;

procedure Tz3DModelDynamicInstance.VelocityChanged(
  const ASender: Iz3DBase);
begin
  if SameValue(FVelocity.Y, FPrevVelocityY, 0.005) and (FVelocity.Y > 0.005) then
  begin
    FPrevVelocityY:= FVelocity.Y;
    FGround:= False;
  end;
end;

{ Tz3DHeightMappedModel }

procedure Tz3DHeightMappedModel.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FHeightMap:= z3DCreateTexture;
  FHeightMap.Source:= z3dtsFileName;
  FHorizontal:= True;
  FResolution:= 3;
  FSmoothFactor:= 3;
  FBoundingSphere.Radius:= 100;
  FGenerateLODMeshes:= False;
end;

function Tz3DHeightMappedModel.GetHorizontal: Boolean;
begin
  Result:= FHorizontal;
end;

function Tz3DHeightMappedModel.GetResolution: Single;
begin
  Result:= FResolution;
end;

function Tz3DHeightMappedModel.GetSmoothFactor: Single;
begin
  Result:= FSmoothFactor;
end;

procedure Tz3DHeightMappedModel.SetHorizontal(const Value: Boolean);
begin
  FHorizontal:= Value;
end;

procedure Tz3DHeightMappedModel.SetResolution(const Value: Single);
begin
  FResolution:= Value;
end;

procedure Tz3DHeightMappedModel.SetSmoothFactor(const Value: Single);
begin
  FSmoothFactor:= Value;
end;

procedure Tz3DHeightMappedModel.CreateModel;
var FHeightMapFile: string;
    FVB: Pz3DStaticModelVertexArray;
    FIB: PWordArray;
    FIB32: PDWordArray;
    F32Bit: Boolean;
    FTexU, FTexV: Single;
    FTexX, FTexY: Integer;
    I, J: Integer;
    FAdjacency: Tz3DDWordArray;
    FTempMesh: ID3DXMesh;
    dwMeshEnhancedFlags: DWORD;
begin

  // Load the quad model
  FHeightMapFile:= WideCharToString(FFileName);
  z3DModelController.ModelFormat.Expand('Quad.x', FFileName);
  inherited;
  StringToWideChar(FHeightMapFile, FFileName, 255);
  if FMesh = nil then Exit;

  // Read the heightmap file
  if not FileExists(FHeightMapFile) then
  begin
    StringToWideChar('Iz3DHeightMappedModel.CreateModel failed: HeightMap file does not exist ('+
    ExtractFileName(FHeightMapFile)+')', z3DWideBuffer, 255);
    z3DTrace(z3DWideBuffer, z3dtkWarning);
    Exit;
  end;
  StringToWideChar(FHeightMapFile, z3DWideBuffer, 255);
  FHeightMap.FileName:= z3DWideBuffer;
  FHeightMap.CreateD3DTexture;
  F32Bit:= False;
  
  // Tesselate the mesh based on the resolution factor
  if Resolution > 1 then
  begin
    SetLength(FAdjacency, 0);
    SetLength(FAdjacency, SizeOf(DWORD) * FaceCount * 3);
    FMesh.GenerateAdjacency(1e-6, @FAdjacency[0]);
    if FAILED(D3DXTessellateNPatches(FMesh, @FAdjacency[0], Resolution, False, FTempMesh, nil)) then
    begin
      F32Bit:= True;
      FMesh.CloneMesh(FMesh.GetOptions or D3DXMESH_32BIT, z3DModelController.StaticVertexFormat.GetDeclaration,
      z3DCore_GetD3DDevice, FTempMesh);
      FMesh:= FTempMesh;
      SetLength(FAdjacency, 0);
      SetLength(FAdjacency, SizeOf(DWORD) * FaceCount * 3);
      FMesh.GenerateAdjacency(1e-6, @FAdjacency[0]);
      FTempMesh:= nil;
      D3DXTessellateNPatches(FMesh, @FAdjacency[0], Resolution, False, FTempMesh, nil);
    end;
    FMesh:= FTempMesh;
    FVertexCount:= FMesh.GetNumVertices;
    FFaceCount:= FMesh.GetNumFaces;
  end;

  // Apply the heightmap to the mesh
  if F32Bit then
  begin
    FIB32:= Pointer(LockIndices);
    try
      FVB:= LockVertices;
      FHeightMap.BeginDraw;
      try
        for I:= 0 to FaceCount-1 do
        begin
          for J:= 0 to 2 do
          begin
            FTexU:= (FVB[FIB32[I*3+J]].Position.X + FOSBoundingBox.Dimensions.X * 0.5) / FOSBoundingBox.Dimensions.X;
            FTexV:= (FVB[FIB32[I*3+J]].Position.Z + FOSBoundingBox.Dimensions.Z * 0.5) / FOSBoundingBox.Dimensions.Z;
            FTexX:= Min(Max(Round(FTexU * FHeightMap.Width), 0), FHeightMap.Width - 1);
            FTexY:= Min(Max(Round(FTexV * FHeightMap.Height), 0), FHeightMap.Height - 1);
            FVB[FIB32[I*3+J]].Position.Y:= (((FHeightMap.GetPixel(FTexX, FTexY).R)) - 0.5) * 0.1;
          end;
        end;
      finally
        FHeightMap.EndDraw;
        UnlockVertices;
      end;
    finally
      UnlockIndices;
    end;
  end else
  begin
    FIB:= Pointer(LockIndices);
    try
      FVB:= LockVertices;
      FHeightMap.BeginDraw;
      try
        for I:= 0 to FaceCount-1 do
        begin
          for J:= 0 to 2 do
          begin
            FTexU:= (FVB[FIB[I*3+J]].Position.X + FOSBoundingBox.Dimensions.X * 0.5) / FOSBoundingBox.Dimensions.X;
            FTexV:= (FVB[FIB[I*3+J]].Position.Z + FOSBoundingBox.Dimensions.Z * 0.5) / FOSBoundingBox.Dimensions.Z;
            FTexX:= Min(Max(Round(FTexU * FHeightMap.Width), 0), FHeightMap.Width - 1);
            FTexY:= Min(Max(Round(FTexV * FHeightMap.Height), 0), FHeightMap.Height - 1);
            FVB[FIB[I*3+J]].Position.Y:= (((FHeightMap.GetPixel(FTexX, FTexY).R)) - 0.5) * 0.1;
          end;
        end;
      finally
        FHeightMap.EndDraw;
        UnlockVertices;
      end;
    finally
      UnlockIndices;
    end;
  end;

  // Tesselate the mesh based on the smooth factor
  if SmoothFactor > 1 then
  begin
    SetLength(FAdjacency, 0);
    SetLength(FAdjacency, SizeOf(DWORD) * FaceCount * 3);
    FMesh.GenerateAdjacency(1e-6, @FAdjacency[0]);
    if FAILED(D3DXTessellateNPatches(FMesh, @FAdjacency[0], SmoothFactor, False, FTempMesh, nil)) then
    begin
      FMesh.CloneMesh(FMesh.GetOptions or D3DXMESH_32BIT, z3DModelController.StaticVertexFormat.GetDeclaration,
      z3DCore_GetD3DDevice, FTempMesh);
      FMesh:= FTempMesh;
      SetLength(FAdjacency, 0);
      SetLength(FAdjacency, SizeOf(DWORD) * FaceCount * 3);
      FMesh.GenerateAdjacency(1e-6, @FAdjacency[0]);
      FTempMesh:= nil;
      D3DXTessellateNPatches(FMesh, @FAdjacency[0], SmoothFactor, False, FTempMesh, nil);
    end;
    FMesh:= FTempMesh;
    FVertexCount:= FMesh.GetNumVertices;
    FFaceCount:= FMesh.GetNumFaces;
  end;

  // Compute the vertex normals
  SetLength(FAdjacency, 0);
  SetLength(FAdjacency, SizeOf(DWORD) * FaceCount * 3);
  FMesh.GenerateAdjacency(1e-6, @FAdjacency[0]);
  D3DXComputeNormals(FMesh, @FAdjacency[0]);

  // Compute the new bounds
  ComputeBounds;
end;

{ Tz3DWaterModel }

procedure Tz3DWaterModel.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FBoundingBox.Dimensions.X:= 1000;
  FBoundingBox.Dimensions.Z:= 1000;
  FBoundingBox.Dimensions.Y:= 0.0001;
  FGenerateLODMeshes:= False;
end;

procedure Tz3DWaterModel.CreateModel;
var FVB: Pz3DStaticModelVertexArray;
    FIB: PWordArray;
    I, J: Integer;
begin
  AddSubset;
  Subsets[0].Material.SpecularAmount:= 38.5;
  Subsets[0].Material.AlbedoFactor.X:= 94;
  Subsets[0].Material.AlbedoFactor.Y:= 94;
  Subsets[0].Material.Texture.FileName:= 'C:\JP\Direct3D\TEXTURES\Water.dds';
  Subsets[0].Material.Texture.NormalMapFactor:= 0.15;
  Subsets[0].Material.ColorDiffuse.A:= 0.4;
  // Load the quad model
  z3DModelController.ModelFormat.Expand('Quad.x', FFileName);
  inherited;

  // Apply the heightmap to the mesh
  FIB:= Pointer(LockIndices);
  try
    FVB:= LockVertices;
    try
      for I:= 0 to FaceCount-1 do
      begin
        for J:= 0 to 2 do
        FVB[FIB[I*3+J]].Position.Y:= Random(10)/10000;
      end;
    finally
      UnlockVertices;
    end;
  finally
    UnlockIndices;
  end;

  ComputeBounds;
  
end;

end.
