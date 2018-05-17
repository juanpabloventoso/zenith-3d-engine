unit z3DScenario_Impl;

interface

uses
  Classes, Direct3D9, D3DX9, z3DScenario_Intf, z3DClasses_Impl, z3DMath_Intf,
  z3DComponents_Intf, z3DScenarioObjects_Intf, z3DClasses_Intf, z3DFileSystem_Intf;

type



{==============================================================================}
{== Scenario interface                                                       ==}
{==============================================================================}
{== Contains the attributes that are applied to the global scene. It also    ==}
{== begins the render chain and allows to disable the world rendering        ==}
{==============================================================================}

  Tz3DFrustumStats = class(Tz3DBase, Iz3DFrustumStats)
  private
    FAnyVisibleObject: Boolean;
    FAnyVisibleOpaqueObject: Boolean;
    FAnyVisibleTranslucentObject: Boolean;
    FAnyVisibleStaticObject: Boolean;
    FAnyVisibleDynamicObject: Boolean;
    FEnabled: Boolean;
  protected
    function GetAnyVisibleDynamicObject: Boolean; stdcall;
    function GetAnyVisibleObject: Boolean; stdcall;
    function GetAnyVisibleOpaqueObject: Boolean; stdcall;
    function GetAnyVisibleStaticObject: Boolean; stdcall;
    function GetAnyVisibleTranslucentObject: Boolean; stdcall;
    procedure SetAnyVisibleDynamicObject(const Value: Boolean); stdcall;
    procedure SetAnyVisibleObject(const Value: Boolean); stdcall;
    procedure SetAnyVisibleOpaqueObject(const Value: Boolean); stdcall;
    procedure SetAnyVisibleStaticObject(const Value: Boolean); stdcall;
    procedure SetAnyVisibleTranslucentObject(const Value: Boolean); stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    procedure Reset; stdcall;
  public
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
  public
    property AnyVisibleObject: Boolean read GetAnyVisibleObject write SetAnyVisibleObject;
    property AnyVisibleOpaqueObject: Boolean read GetAnyVisibleOpaqueObject write SetAnyVisibleOpaqueObject;
    property AnyVisibleTranslucentObject: Boolean read GetAnyVisibleTranslucentObject write SetAnyVisibleTranslucentObject;
    property AnyVisibleStaticObject: Boolean read GetAnyVisibleStaticObject write SetAnyVisibleStaticObject;
    property AnyVisibleDynamicObject: Boolean read GetAnyVisibleDynamicObject write SetAnyVisibleDynamicObject;
    property Enabled: Boolean read GetEnabled write SetEnabled;
  end;

  Tz3DFrustum = class(Tz3DBase, Iz3DFrustum)
  private
    FVelocity: Single;
    FLeftPlane: Iz3DPlane;
    FRightPlane: Iz3DPlane;
    FBottomPlane: Iz3DPlane;
    FTopPlane: Iz3DPlane;
    FNearPlane: Iz3DPlane;
    FFarPlane: Iz3DPlane;
    FNearClip: Single;
    FFarClip: Single;
    FStats: Iz3DFrustumStats;
    FAspectRatio: Single;
    FFieldOfView: Single;
    FLookAt: Iz3DFloat3;
    FPosition: Iz3DFloat3;
    FProjectionKind: Tz3DProjectionKind;
    FProjectionMatrix: Iz3DMatrix;
    FUpVector: Iz3DFloat3;
    FViewMatrix: Iz3DMatrix;
    FVolumeHeight: Single;
    FVolumeWidth: Single;
    FViewProjMatrix: Iz3DMatrix;
    FLastViewMatrix: Iz3DMatrix;
  protected
    function GetLastViewMatrix: Iz3DMatrix; stdcall;
    function GetVelocity: Single; stdcall;
    function GetViewProjMatrix: Iz3DMatrix; stdcall;
    function GetAspectRatio: Single; stdcall;
    function GetFieldOfView: Single; stdcall;
    function GetLookAt: Iz3DFloat3; stdcall;
    function GetPosition: Iz3DFloat3; stdcall;
    function GetProjectionKind: Tz3DProjectionKind; stdcall;
    function GetProjectionMatrix: Iz3DMatrix; stdcall;
    function GetUpVector: Iz3DFloat3; stdcall;
    function GetViewMatrix: Iz3DMatrix; stdcall;
    function GetVolumeHeight: Single; stdcall;
    function GetVolumeWidth: Single; stdcall;
    function GetFarPlane: Iz3DPlane; stdcall;
    function GetLeftPlane: Iz3DPlane; stdcall;
    function GetBottomPlane: Iz3DPlane; stdcall;
    function GetTopPlane: Iz3DPlane; stdcall;
    function GetNearPlane: Iz3DPlane; stdcall;
    function GetRightPlane: Iz3DPlane; stdcall;
    function GetStats: Iz3DFrustumStats; stdcall;
    function GetFarClip: Single; stdcall;
    function GetNearClip: Single; stdcall;
    procedure SetFarClip(const Value: Single); stdcall;
    procedure SetNearClip(const Value: Single); stdcall;
    procedure SetAspectRatio(const Value: Single); stdcall;
    procedure SetFieldOfView(const Value: Single); stdcall;
    procedure SetProjectionKind(const Value: Tz3DProjectionKind); stdcall;
    procedure SetVolumeHeight(const Value: Single); stdcall;
    procedure SetVolumeWidth(const Value: Single); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;

    function TestCulling(const APoint: Iz3DFloat3): Boolean; stdcall;
    function TestBSCulling(const ABoundingSphere: Iz3DBoundingSphere): Boolean; stdcall;
    function TestBBCulling(const ABoundingBox: Iz3DBoundingBox): Boolean; stdcall;
    function TestObjectCulling(const AObject: Iz3DScenarioObject): Boolean; stdcall;

    procedure ApplyChanges(const AUpdateView: Boolean = True; const AUpdateProj: Boolean = True;
      const AUpdatePlanes: Boolean = True); stdcall;
  public
    // Frustum planes
    property LeftPlane: Iz3DPlane read GetLeftPlane;
    property RightPlane: Iz3DPlane read GetRightPlane;
    property BottomPlane: Iz3DPlane read GetBottomPlane;
    property TopPlane: Iz3DPlane read GetTopPlane;
    property FarPlane: Iz3DPlane read GetFarPlane;
    property NearPlane: Iz3DPlane read GetNearPlane;
    property Stats: Iz3DFrustumStats read GetStats;
    property ViewProjMatrix: Iz3DMatrix read GetViewProjMatrix;

    // View properties
    property ViewMatrix: Iz3DMatrix read GetViewMatrix;
    property Position: Iz3DFloat3 read GetPosition;
    property LookAt: Iz3DFloat3 read GetLookAt;
    property UpVector: Iz3DFloat3 read GetUpVector;
    property LastViewMatrix: Iz3DMatrix read GetLastViewMatrix;
    property Velocity: Single read GetVelocity;

    // Projection properties
    property ProjectionMatrix: Iz3DMatrix read GetProjectionMatrix;
    property ProjectionKind: Tz3DProjectionKind read GetProjectionKind write SetProjectionKind;
    property FieldOfView: Single read GetFieldOfView write SetFieldOfView;
    property AspectRatio: Single read GetAspectRatio write SetAspectRatio;
    property VolumeWidth: Single read GetVolumeWidth write SetVolumeWidth;
    property VolumeHeight: Single read GetVolumeHeight write SetVolumeHeight;
    property NearClip: Single read GetNearClip write SetNearClip;
    property FarClip: Single read GetFarClip write SetFarClip;  
  end;


  Tz3DOctreeNode = class(Tz3DBase, Iz3DOctreeNode)
  private
    FBox: Iz3DBoundingBox;
    FChilds: Tz3DOctreeNodeChilds;
    FHasChilds: Boolean;
    FObjects: Tz3DOctreeNodeObjects;
  protected
    function GetObjects: Tz3DOctreeNodeObjects; stdcall;
    function GetBox: Iz3DBoundingBox; stdcall;
    function GetChilds: Tz3DOctreeNodeChilds; stdcall;
    function GetHasChilds: Boolean; stdcall;
    procedure SetHasChilds(const Value: Boolean); stdcall;
    procedure Subdivide(const AMaxSubdivisions: Integer); stdcall;
    procedure CreateChilds; stdcall;
    procedure ClearChilds; stdcall;
  public
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
  public
    property Childs: Tz3DOctreeNodeChilds read GetChilds;
    property Box: Iz3DBoundingBox read GetBox;
    property HasChilds: Boolean read GetHasChilds write SetHasChilds;
    property Objects: Tz3DOctreeNodeObjects read GetObjects;
  end;

  Tz3DOctree = class(Tz3DBase, Iz3DOctree)
  private
    FNodeCount: Integer;
    FRoot: Iz3DOctreeNode;
  protected
    function GetRoot: Iz3DOctreeNode; stdcall;
    function NodeFromPoint(const APoint: Iz3DFloat3): Iz3DOctreeNode; stdcall;
  public
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
  public
    property Root: Iz3DOctreeNode read GetRoot;
  end;

  Tz3DScenarioEnvironment = class(Tz3DBase, Iz3DScenarioEnvironment)
  private
    FAutoFade: Boolean;
    FBoundingBox: Iz3DBoundingBox;
    FGravity: Single;
    FOverrideGravity: Boolean;
    FOverrideWind: Boolean;
    FSealed: Boolean;
    FWindSpeed: Iz3DFloat3;
    FKind: Tz3DEnvironmentKind;
    FChilds: Tz3DScenarioEnvironments;
    FAmbientColor: Iz3DFloat3;
    FFog: Iz3DFog;
  protected
    function GetChilds: Tz3DScenarioEnvironments; stdcall;
    function GetKind: Tz3DEnvironmentKind; stdcall;
    procedure SetKind(const Value: Tz3DEnvironmentKind); stdcall;
    function GetAutoFade: Boolean; stdcall;
    function GetBoundingBox: Iz3DBoundingBox; stdcall;
    function GetGravity: Single; stdcall;
    function GetOverrideGravity: Boolean; stdcall;
    function GetOverrideWind: Boolean; stdcall;
    function GetSealed: Boolean; stdcall;
    function GetWindSpeed: Iz3DFloat3; stdcall;
    function GetAmbientColor: Iz3DFloat3; stdcall;
    function GetFog: Iz3DFog; stdcall;
    procedure SetAutoFade(const Value: Boolean); stdcall;
    procedure SetGravity(const Value: Single); stdcall;
    procedure SetOverrideGravity(const Value: Boolean); stdcall;
    procedure SetOverrideWind(const Value: Boolean); stdcall;
    procedure SetSealed(const Value: Boolean); stdcall;
  public
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
    function ContainsPoint(const APoint: Iz3DFloat3): Boolean; stdcall;
    function IncidenceOnObject(const AObject: Iz3DScenarioObject): Single; stdcall;
    function AddChild: Iz3DScenarioEnvironment; stdcall;
    procedure RemoveChild(const AEnvironment: Iz3DScenarioEnvironment); stdcall;
  public
    property AutoFade: Boolean read GetAutoFade write SetAutoFade;
    property Sealed: Boolean read GetSealed write SetSealed;
    property Kind: Tz3DEnvironmentKind read GetKind write SetKind;
    property OverrideGravity: Boolean read GetOverrideGravity write SetOverrideGravity;
    property OverrideWind: Boolean read GetOverrideWind write SetOverrideWind;
    property Gravity: Single read GetGravity write SetGravity;
    property WindSpeed: Iz3DFloat3 read GetWindSpeed;
    property BoundingBox: Iz3DBoundingBox read GetBoundingBox;
    property Childs: Tz3DScenarioEnvironments read GetChilds;
    property AmbientColor: Iz3DFloat3 read GetAmbientColor;
    property Fog: Iz3DFog read GetFog;
  end;

  Tz3DScenario = class(Tz3DLinked, Iz3DScenario)
  private
    FEnabled: Boolean;
    FProjectionChanged: Boolean;
    FSceneFormat: Iz3DObjectFileFormat;
    FKind: Tz3DScenarioKind;
    FViewFrustum: Iz3DFrustum;
    FOctree: Iz3DOctree;
    FEnvironment: Iz3DScenarioEnvironment;
    FEntities: IInterfaceList;
    FStaticObjects: IInterfaceList;
    FDynamicObjects: IInterfaceList;
  protected
    function GetEnvironment: Iz3DScenarioEnvironment; stdcall;
    function GetDynamicObjectCount: Integer; stdcall;
    function GetDynamicObjects(const AIndex: Integer): Iz3DScenarioDynamicObject; stdcall;
    function GetStaticObjectCount: Integer; stdcall;
    function GetStaticObjects(const AIndex: Integer): Iz3DScenarioStaticObject; stdcall;
    function GetOctree: Iz3DOctree; stdcall;
    function GetViewFrustum: Iz3DFrustum; stdcall;
    function GetKind: Tz3DScenarioKind; stdcall;
    procedure SetKind(const Value: Tz3DScenarioKind); stdcall;
    function GetEntities(const AIndex: Integer): Iz3DScenarioEntity; stdcall;
    function GetEntityCount: Integer; stdcall;
    function GetProjectionChanged: Boolean; stdcall;
    procedure SetProjectionChanged(const Value: Boolean); stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    procedure ResetDevice; stdcall;
    procedure FrameRender; stdcall;
    procedure Render; stdcall;
    procedure PropertyChanged(const ASender: Iz3DBase); stdcall;
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
    procedure z3DFrameMove; override; stdcall;
  public

    procedure AddEntity(const AEntity: Iz3DScenarioEntity); stdcall;
    procedure RemoveEntity(const AEntity: Iz3DScenarioEntity); stdcall;
    function IndexOf(const AEntity: Iz3DScenarioEntity): Integer; stdcall;
    procedure LoadFromFile(const AFileName: PWideChar); stdcall;
    procedure SaveToFile(const AFileName: PWideChar); stdcall;
  public
    property Kind: Tz3DScenarioKind read GetKind write SetKind;
    property ProjectionChanged: Boolean read GetProjectionChanged write SetProjectionChanged;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property ViewFrustum: Iz3DFrustum read GetViewFrustum;
    property Octree: Iz3DOctree read GetOctree;

    property Entities[const AIndex: Integer]: Iz3DScenarioEntity read GetEntities;
    property EntityCount: Integer read GetEntityCount;
    property StaticObjects[const AIndex: Integer]: Iz3DScenarioStaticObject read GetStaticObjects;
    property StaticObjectCount: Integer read GetStaticObjectCount;
    property DynamicObjects[const AIndex: Integer]: Iz3DScenarioDynamicObject read GetDynamicObjects;
    property DynamicObjectCount: Integer read GetDynamicObjectCount;
    property Environment: Iz3DScenarioEnvironment read GetEnvironment;
  end;


{==============================================================================}
{== Fog interface                                                            ==}
{==============================================================================}
{== Controller for the fog effect of the scenario                            ==}
{==============================================================================}

  Tz3DFog = class(Tz3DLinked, Iz3DFog)
  private
    FEnabled: Boolean;
    FRangeMin: Single;
    FRangeMax: Single;
    FDensity: Single;
    FColor: Iz3DFloat3;
    FUniform: Boolean;
  protected
    function GetUniform: Boolean; stdcall;
    procedure SetUniform(const Value: Boolean); stdcall;
    procedure SetDensity(const Value: Single); stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    procedure SetRangeMin(const Value: Single); stdcall;
    procedure SetRangeMax(const Value: Single); stdcall;
    function GetColor: Iz3DFloat3; stdcall;
    function GetDensity: Single; stdcall;
    function GetRangeMin: Single; stdcall;
    function GetRangeMax: Single; stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure PropertyChanged(const ASender: Iz3DBase); stdcall;
    procedure z3DStartScenario(const AStage: Tz3DStartScenarioStage); override; stdcall;
  public
    procedure Show; stdcall;
    procedure Hide; stdcall;
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property Color: Iz3DFloat3 read GetColor;
    property RangeMin: Single read GetRangeMin write SetRangeMin;
    property RangeMax: Single read GetRangeMax write SetRangeMax;
    property Density: Single read GetDensity write SetDensity;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Uniform: Boolean read GetUniform write SetUniform;
  end;


  Tz3DMaterial = class(Tz3DBase, Iz3DMaterial)
  private
    FDensity: Single;
    FElasticity: Single;
    FColorDiffuse: Iz3DFloat4;
    FColorEmissive: Iz3DFloat3;
    FSpecularAmount: Single;
    FRoughness: Single;
    FEmissiveMode: Tz3DMaterialEmissiveMode;
    FSounds: PWideChar;
    FTexture: Iz3DMaterialTexture;
    FReflectivity: Single;
    FFileName: PWideChar;
    FAlbedoFactor: Iz3DFloat2;
  protected
    function GetAlbedoFactor: Iz3DFloat2; stdcall;
    function GetFileName: PWideChar; stdcall;
    procedure SetFileName(const Value: PWideChar); stdcall;
    function GetTexture: Iz3DMaterialTexture; stdcall;
    function GetReflectivity: Single; stdcall;
    procedure SetReflectivity(const Value: Single); stdcall;
    function GetRoughness: Single; stdcall;
    procedure SetRoughness(const Value: Single); stdcall;
    function GetSounds: PWideChar; stdcall;
    procedure SetSounds(const Value: PWideChar); stdcall;
    function GetEmissiveMode: Tz3DMaterialEmissiveMode; stdcall;
    procedure SetEmissiveMode(const Value: Tz3DMaterialEmissiveMode); stdcall;
    function GetDensity: Single; stdcall;
    function GetElasticity: Single; stdcall;
    function GetColorDiffuse: Iz3DFloat4; stdcall;
    function GetColorEmissive: Iz3DFloat3; stdcall;
    function GetSpecularAmount: Single; stdcall;
    procedure SetDensity(const Value: Single); stdcall;
    procedure SetElasticity(const Value: Single); stdcall;
    procedure SetColorDiffuse(const Value: Iz3DFloat4); stdcall;
    procedure SetColorEmissive(const Value: Iz3DFloat3); stdcall;
    procedure SetSpecularAmount(const Value: Single); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;
    procedure LoadFromFile(const AFileName: PWideChar); stdcall;
    procedure SaveToFile(const AFileName: PWideChar); stdcall;
  public
    property Sounds: PWideChar read GetSounds write SetSounds;
    property FileName: PWideChar read GetFileName write SetFileName;
    property Density: Single read GetDensity write SetDensity;
    property Elasticity: Single read GetElasticity write SetElasticity;
    property Roughness: Single read GetRoughness write SetRoughness;
    property Texture: Iz3DMaterialTexture read GetTexture;
    property AlbedoFactor: Iz3DFloat2 read GetAlbedoFactor;
    property ColorDiffuse: Iz3DFloat4 read GetColorDiffuse write SetColorDiffuse;
    property ColorEmissive: Iz3DFloat3 read GetColorEmissive write SetColorEmissive;
    property SpecularAmount: Single read GetSpecularAmount write SetSpecularAmount;
    property Reflectivity: Single read GetReflectivity write SetReflectivity;
    property EmissiveMode: Tz3DMaterialEmissiveMode read GetEmissiveMode write SetEmissiveMode;
  end;

  Tz3DMaterialController = class(Tz3DLinked, Iz3DMaterialController)
  private
    FDefaultTexture: Iz3DMaterialTexture;
    FMaterials: IInterfaceList;
    FMaterialFormat: Iz3DObjectFileFormat;
    FMaterialTextureFormat: Iz3DObjectFileFormat;
    FMaterialSoundFormat: Iz3DObjectFileFormat;
  protected
    function GetMaterialFormat: Iz3DObjectFileFormat; stdcall;
    function GetMaterialTextureFormat: Iz3DObjectFileFormat; stdcall;
    function GetMaterialSoundFormat: Iz3DObjectFileFormat; stdcall;
    function GetMaterialCount: Integer; stdcall;
    function GetMaterials(const AIndex: Integer): Iz3DMaterial; stdcall;
    function GetDefaultTexture: Iz3DMaterialTexture; stdcall;
    procedure z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller); override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    procedure CreateScenarioObjects; stdcall;
    function CreateMaterial: Iz3DMaterial; stdcall;
    function CreateMaterialFromFile(const AFileName: PWideChar): Iz3DMaterial; stdcall;
    procedure RemoveMaterial(const AMaterial: Iz3DMaterial); stdcall;
  public
    property MaterialFormat: Iz3DObjectFileFormat read GetMaterialFormat;
    property MaterialTextureFormat: Iz3DObjectFileFormat read GetMaterialTextureFormat;
    property MaterialSoundFormat: Iz3DObjectFileFormat read GetMaterialSoundFormat;
    property DefaultTexture: Iz3DMaterialTexture read GetDefaultTexture;
    property Materials[const AIndex: Integer]: Iz3DMaterial read GetMaterials;
    property MaterialCount: Integer read GetMaterialCount;
  end;

function z3DCreateScenario: Iz3DScenario; stdcall;
function z3DScenario: Iz3DScenario; stdcall;
procedure z3DSetCustomScenario(const AScenario: Iz3DScenario); stdcall;

function z3DCreateMaterialController: Iz3DMaterialController; stdcall;
function z3DMaterialController: Iz3DMaterialController; stdcall;
procedure z3DSetCustomMaterialController(const AController: Iz3DMaterialController); stdcall;

function z3DCreateFrustum: Iz3DFrustum; stdcall;

implementation

uses z3DMath_Func, z3DCore_Intf, z3DCore_Func, z3DEngine_Intf, z3DEngine_Func,
  Windows, z3DLighting_Func, z3DComponents_Func, SysUtils, z3DScenarioObjects_Func,
  z3DFileSystem_Func, z3DModels_Func, z3DModels_Intf;

var
  GScenario: Iz3DScenario;
  GMaterialController: Iz3DMaterialController;


function z3DCreateScenario: Iz3DScenario; stdcall;
begin
  z3DTrace('z3DCreateScenario: Creating scenario object...', z3DtkInformation);
  GScenario:= Tz3DScenario.Create;
  Result:= GScenario;
end;

function z3DScenario: Iz3DScenario; stdcall;
begin
  Result:= GScenario;
end;

procedure z3DSetCustomScenario(const AScenario: Iz3DScenario); stdcall;
begin
  GScenario:= AScenario;
end;

function z3DCreateMaterialController: Iz3DMaterialController; stdcall;
begin
  z3DTrace('z3DCreateMaterialController: Creating material controller object...', z3DtkInformation);
  if GMaterialController = nil then
  GMaterialController:= Tz3DMaterialController.Create;
  Result:= GMaterialController;
end;

function z3DMaterialController: Iz3DMaterialController; stdcall;
begin
  Result:= GMaterialController;
end;

procedure z3DSetCustomMaterialController(const AController: Iz3DMaterialController); stdcall;
begin
  GMaterialController:= AController;
end;

function z3DCreateFrustum: Iz3DFrustum; stdcall;
begin
  Result:= Tz3DFrustum.Create;
end;

{ Tz3DScenario }

procedure Tz3DScenario.Init(const AOwner: Iz3DBase);
begin
  inherited;
  Notifications:= [z3dlnFrameMove];
  FOctree:= Tz3DOctree.Create(Self);
  FOctree.Root.Subdivide(3);
  FViewFrustum:= Tz3DFrustum.Create;
  FEnvironment:= Tz3DScenarioEnvironment.Create(Self);
  FEnvironment.BoundingBox.Dimensions.X:= 1000;
  FEnvironment.BoundingBox.Dimensions.Y:= 1000;
  FEnvironment.BoundingBox.Dimensions.Z:= 1000;
  FEnvironment.Sealed:= True;
  FEnvironment.OverrideGravity:= False;
  FEnvironment.OverrideWind:= False;
  FSceneFormat:= z3DFileSystemController.CreateObjectFormat;
  FSceneFormat.Description:= 'Zenith Scene File';
  FSceneFormat.Extension:= 'zScene';
//  FSceneFormat.DefaultFolder:= fsMaterialsFolder;
  FSceneFormat.Header:= 'ZSCENE';

  FEntities:= TInterfaceList.Create;
  FStaticObjects:= TInterfaceList.Create;
  FDynamicObjects:= TInterfaceList.Create;
  FEnabled:= False;
  FProjectionChanged:= True;
  GScenario:= Self;
  FKind:= z3dskMixed;
end;

procedure Tz3DScenario.FrameRender;
begin
  if not Enabled then Exit;

  // Render the scene objects not affected by lighting
  z3DEngine.NotifyLinks_z3DFrameRender;

  // Render the opaque stage of the lighting system
//        z3DCore_GetD3DDevice.SetRenderState(D3DRS_DITHERENABLE, D3DFILL_WIREFRAME);
  if z3DLightingController <> nil then
  z3DLightingController.RenderOpaqueStage;
//        z3DCore_GetD3DDevice.SetRenderState(D3DRS_FILLMODE, D3DFILL_SOLID);

  // Add the screen space fog
  z3DEngine.Renderer.DeferredBuffer.AttachToSampler(1, True, True);
  z3DEngine.Renderer.RenderFog;

  // Render the translucent stage of the lighting system
  if z3DLightingController <> nil then
  z3DLightingController.RenderTranslucentStage;

  // Add the screen space lighting effects
  if z3DLightingController <> nil then
  z3DLightingController.RenderLightSources;
end;



procedure Tz3DScenario.Render;
begin
  if not Enabled then Exit;

{  if Kind <> z3dskIndoor then
  begin
    // Render the skyline objects if consistent with scenario kind
    RenderSkyLine;

    // Render the far objects if consistent with scenario kind
    RenderFarObjects;
  end;

  // Render opaque objects
  RenderOpaqueObjects;

  // Render alpha-blended objects
  RenderTranslucentObjects;

  // Render non-vertex based entities (glow effects, particle systems)
  RenderEntities;}
end;

function Tz3DScenario.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

procedure Tz3DScenario.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    if Value then
    begin
      z3DEngine.StartScenario(z3dssCreatingScenario);
      z3DEngine.StartScenario(z3dssCreatingScenarioObjects);
      z3DEngine.StartScenario(z3dssCreatingScene);
      z3DEngine.StartScenario(z3dssCreatingSceneObjects);
      z3DEngine.StartScenario(z3dssCreatingLightingSystem);
    end else
    z3DEngine.NotifyLinks_z3DEndScenario;
    FEnabled:= Value;
  end;
end;

function Tz3DScenario.GetProjectionChanged: Boolean;
begin
  Result:= FProjectionChanged;
end;

procedure Tz3DScenario.SetProjectionChanged(const Value: Boolean);
begin
  FProjectionChanged:= Value;
end;

procedure Tz3DScenario.ResetDevice;
begin
  ProjectionChanged:= True;
end;

procedure Tz3DScenario.PropertyChanged(const ASender: Iz3DBase);
begin
end;

procedure Tz3DScenario.AddEntity(const AEntity: Iz3DScenarioEntity);
begin
  if z3DSupports(AEntity, Iz3DScenarioStaticObject) then FStaticObjects.Add(AEntity) else
  if z3DSupports(AEntity, Iz3DScenarioDynamicObject) then FDynamicObjects.Add(AEntity) else
  FEntities.Add(AEntity);
end;

procedure Tz3DScenario.RemoveEntity(const AEntity: Iz3DScenarioEntity);
begin
  if z3DSupports(AEntity, Iz3DScenarioStaticObject) then FStaticObjects.Remove(AEntity) else
  if z3DSupports(AEntity, Iz3DScenarioDynamicObject) then FDynamicObjects.Remove(AEntity) else
  FEntities.Remove(AEntity);
end;

function Tz3DScenario.GetEntities(const AIndex: Integer): Iz3DScenarioEntity;
begin
  Result:= FEntities[AIndex] as Iz3DScenarioEntity;
end;

function Tz3DScenario.GetEntityCount: Integer;
begin
  Result:= FEntities.Count;
end;

function Tz3DScenario.IndexOf(const AEntity: Iz3DScenarioEntity): Integer;
begin
  if z3DSupports(AEntity, Iz3DScenarioStaticObject) then
  Result:= FStaticObjects.IndexOf(AEntity) else
  if z3DSupports(AEntity, Iz3DScenarioDynamicObject) then
  Result:= FDynamicObjects.IndexOf(AEntity) else
  Result:= FEntities.IndexOf(AEntity);
end;

function Tz3DScenario.GetKind: Tz3DScenarioKind;
begin
  Result:= FKind;
end;

procedure Tz3DScenario.SetKind(const Value: Tz3DScenarioKind);
begin
  if FKind <> Value then
  begin
    FKind:= Value;
{    case FKind of
      z3dskEmpty: FWorlds.Clear;
      z3dskSingleWorldIndoor, z3dskSingleWorldOutdoor, z3dskSingleWorldMixed:
        while FWorlds.Count > 1 do FWorlds.Delete(FWorlds.Count-1);
      z3dskMultipleWorlds: ;
    end;}
  end;
end;

procedure Tz3DScenario.LoadFromFile(const AFileName: PWideChar);
var FFile: Iz3DTypedObjectFile;
    I, J: Integer;
begin
  FFile:= z3DFileSystemController.CreateTypedObjectFile(AFileName, fmOpenRead, FSceneFormat);

  // Scenario properties
  Kind:= Tz3DScenarioKind(FFile.ReadInteger);

  // Lights
{  for I:= 0 to FFile.ReadInteger-1 do
  with z3DLightingController.CreateLight do
  begin

  end;}

  // Static models
  for I:= 0 to FFile.ReadInteger-1 do
  with z3DModelController.CreateStaticModel do
  begin
    FileName:= FFile.ReadString;
    for J:= 0 to FFile.ReadInteger-1 do
    with CreateInstance do
    FFile.ReadFloat3(BoundingBox.Center);
  end;

  // Dynamic models
  for I:= 0 to FFile.ReadInteger-1 do
  with z3DModelController.CreateDynamicModel do
  begin
    FileName:= FFile.ReadString;
    for J:= 0 to FFile.ReadInteger-1 do
    with CreateInstance do
    FFile.ReadFloat3(BoundingBox.Center);
  end;
end;

procedure Tz3DScenario.SaveToFile(const AFileName: PWideChar);
var FFile: Iz3DTypedObjectFile;
    I, J: Integer;
begin
  FFile:= z3DFileSystemController.CreateTypedObjectFile(AFileName, fmCreate or fmOpenWrite, FSceneFormat);

  // Scenario properties
  FFile.WriteVariant(Integer(Kind));

  // Lights

  // Static models
  FFile.WriteVariant(z3DModelController.StaticModelCount);
  for I:= 0 to z3DModelController.StaticModelCount-1 do
  begin
    FFile.WriteString(z3DModelController.StaticModels[I].FileName);
    FFile.WriteVariant(z3DModelController.StaticModels[I].InstanceCount);
    for J:= 0 to z3DModelController.StaticModels[I].InstanceCount-1 do
    FFile.WriteFloat3(z3DModelController.StaticModels[I].Instances[J].BoundingBox.Center);
  end;

  // Dynamic models
  FFile.WriteVariant(z3DModelController.DynamicModelCount);
  for I:= 0 to z3DModelController.DynamicModelCount-1 do
  begin
    FFile.WriteString(z3DModelController.DynamicModels[I].FileName);
    FFile.WriteVariant(z3DModelController.DynamicModels[I].InstanceCount);
    for J:= 0 to z3DModelController.DynamicModels[I].InstanceCount-1 do
    FFile.WriteFloat3(z3DModelController.DynamicModels[I].Instances[J].BoundingBox.Center);
  end;

end;

function Tz3DScenario.GetViewFrustum: Iz3DFrustum;
begin
  Result:= FViewFrustum;
end;

procedure Tz3DScenario.z3DFrameMove;
begin
  inherited;
// TODO JP: VER SI ESTO HACE FALTA  O NO  if Enabled then FViewFrustum.ApplyChanges;
end;

function Tz3DScenario.GetOctree: Iz3DOctree;
begin
  Result:= FOctree;
end;

function Tz3DScenario.GetEnvironment: Iz3DScenarioEnvironment;
begin
  Result:= FEnvironment;
end;

function Tz3DScenario.GetDynamicObjectCount: Integer;
begin
  Result:= FDynamicObjects.Count;
end;

function Tz3DScenario.GetDynamicObjects(const AIndex: Integer): Iz3DScenarioDynamicObject;
begin
  Result:= FDynamicObjects[AIndex] as Iz3DScenarioDynamicObject;
end;

function Tz3DScenario.GetStaticObjectCount: Integer;
begin
  Result:= FStaticObjects.Count;
end;

function Tz3DScenario.GetStaticObjects(const AIndex: Integer): Iz3DScenarioStaticObject;
begin
  Result:= FStaticObjects[AIndex] as Iz3DScenarioStaticObject;
end;

{ Tz3DFog }

constructor Tz3DFog.Create;
begin
  inherited Create;

  // Link this object to all the events generated by the z3D Engine
  Notifications:= [z3dlnDevice];

  FEnabled:= True;
  FColor:= z3DFloat3(0.65, 0.79, 0.94);
  FColor.OnChange:= PropertyChanged;
  FRangeMin:= 0.0001;
  FRangeMax:= 0.25;
  FDensity:= 0.5;
  FUniform:= False;
end;

procedure Tz3DFog.SetDensity(const Value: Single);
begin
  if FDensity <> Value then
  begin
    FDensity:= Value;
    if z3DEngine.CoreShader.D3DXEffect <> nil then
    z3DEngine.CoreShader.Param['GFogDensity']:= FDensity;
  end;
end;

procedure Tz3DFog.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled:= Value;
    if FEnabled then
    z3DStartScenario(z3dssCreatingScenario);
  end;
end;

procedure Tz3DFog.SetRangeMax(const Value: Single);
begin
  if FRangeMax <> Value then
  begin
    FRangeMax:= Value;
    if z3DEngine.CoreShader.D3DXEffect <> nil then
    z3DEngine.CoreShader.Param['GFogRangeMax']:= FRangeMax;
  end;
end;

procedure Tz3DFog.SetRangeMin(const Value: Single);
begin
  if FRangeMin <> Value then
  begin
    FRangeMin:= Value;
    if z3DEngine.CoreShader.D3DXEffect <> nil then
    z3DEngine.CoreShader.Param['GFogRangeMin']:= FRangeMin;
  end;
end;

procedure Tz3DFog.Hide;
begin
  SetEnabled(False);
end;

procedure Tz3DFog.Show;
begin
  SetEnabled(True);
end;

function Tz3DFog.GetColor: Iz3DFloat3;
begin
  Result:= FColor;
end;

function Tz3DFog.GetDensity: Single;
begin
  Result:= FDensity;
end;

function Tz3DFog.GetRangeMax: Single;
begin
  Result:= FRangeMax;
end;

function Tz3DFog.GetRangeMin: Single;
begin
  Result:= FRangeMin;
end;

function Tz3DFog.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

procedure Tz3DFog.PropertyChanged(const ASender: Iz3DBase);
begin
  if z3DEngine.CoreShader.D3DXEffect <> nil then
  z3DEngine.CoreShader.Color3['GFogColor']:= FColor;
end;

procedure Tz3DFog.z3DStartScenario(const AStage: Tz3DStartScenarioStage);
begin
  if (AStage = z3dssCreatingScenario) and Enabled then
  begin
    z3DEngine.CoreShader.Color3['GFogColor']:= FColor;
    z3DEngine.CoreShader.Param['GFogDensity']:= FDensity;
    z3DEngine.CoreShader.Param['GFogRangeMax']:= FRangeMax;
    z3DEngine.CoreShader.Param['GFogRangeMin']:= FRangeMin;
  end;
end;

function Tz3DFog.GetUniform: Boolean;
begin
  Result:= FUniform;
end;

procedure Tz3DFog.SetUniform(const Value: Boolean);
begin
  FUniform:= Value;
end;

{ Tz3DMaterial }

constructor Tz3DMaterial.Create;
begin
  inherited;
  GetMem(FFileName, 255);
  FDensity:= 1;
  FReflectivity:= 1;
  FElasticity:= 0.5;
  GetMem(FSounds, 255);
  FTexture:= z3DCreateMaterialTexture;
  FTexture.Enabled:= False;
  FRoughness:= 0.5;
  FEmissiveMode:= z3dmemInnerLight;
  FAlbedoFactor:= z3DFloat2(1, 1);
  FColorDiffuse:= z3DFloat4(1, 1, 1, 1);
  FColorEmissive:= z3DFloat3;
  FSpecularAmount:= 0;
end;

destructor Tz3DMaterial.Destroy;
begin
  FreeMem(FSounds);
  inherited;
end;

function Tz3DMaterial.GetAlbedoFactor: Iz3DFloat2;
begin
  Result:= FAlbedoFactor; 
end;

function Tz3DMaterial.GetColorDiffuse: Iz3DFloat4;
begin
  Result:= FColorDiffuse;
end;

function Tz3DMaterial.GetColorEmissive: Iz3DFloat3;
begin
  Result:= FColorEmissive;
end;

function Tz3DMaterial.GetDensity: Single;
begin
  Result:= FDensity;
end;

function Tz3DMaterial.GetElasticity: Single;
begin
  Result:= FElasticity;
end;

function Tz3DMaterial.GetEmissiveMode: Tz3DMaterialEmissiveMode;
begin
  Result:= FEmissiveMode;
end;

function Tz3DMaterial.GetFileName: PWideChar;
begin
  Result:= FFileName;
end;

function Tz3DMaterial.GetReflectivity: Single;
begin
  Result:= FReflectivity;
end;

function Tz3DMaterial.GetRoughness: Single;
begin
  Result:= FRoughness;
end;

function Tz3DMaterial.GetSounds: PWideChar;
begin
  Result:= FSounds;
end;

function Tz3DMaterial.GetSpecularAmount: Single;
begin
  Result:= FSpecularAmount;
end;

function Tz3DMaterial.GetTexture: Iz3DMaterialTexture;
begin
  Result:= FTexture;
end;

procedure Tz3DMaterial.LoadFromFile(const AFileName: PWideChar);
var FFile: Iz3DTypedObjectFile;
begin
  FFile:= z3DFileSystemController.CreateTypedObjectFile(AFileName, fmOpenRead,
    z3DMaterialController.MaterialFormat);
  Density:= FFile.ReadFloat;
  Elasticity:= FFile.ReadFloat;
  Sounds:= FFile.ReadString;
  FFile.ReadFloat4(ColorDiffuse);
  Roughness:= FFile.ReadFloat;
  Texture.FileName:= FFile.ReadString;
  Texture.Enabled:= Boolean(FFile.ReadInteger);
  FFile.ReadFloat3(ColorEmissive);
  Reflectivity:= FFile.ReadFloat;
  EmissiveMode:= Tz3DMaterialEmissiveMode(FFile.ReadInteger);
  SpecularAmount:= FFile.ReadFloat;
  FileName:= AFileName;
end;

procedure Tz3DMaterial.SaveToFile(const AFileName: PWideChar);
var FFile: Iz3DTypedObjectFile;
begin
  FFile:= z3DFileSystemController.CreateTypedObjectFile(AFileName, fmCreate or fmOpenWrite,
    z3DMaterialController.MaterialFormat);

  FFile.WriteVariant(Density);
  FFile.WriteVariant(Elasticity);
  FFile.WriteString(Sounds);
  FFile.WriteFloat4(ColorDiffuse);
  FFile.WriteVariant(Roughness);
  FFile.WriteString(Texture.FileName);
  FFile.WriteVariant(Integer(Texture.Enabled));
  FFile.WriteFloat3(ColorEmissive);
  FFile.WriteVariant(Reflectivity);
  FFile.WriteVariant(Integer(EmissiveMode));
  FFile.WriteVariant(SpecularAmount);
  FileName:= AFileName;
end;

procedure Tz3DMaterial.SetColorDiffuse(const Value: Iz3DFloat4);
begin
  FColorDiffuse:= Value;
end;

procedure Tz3DMaterial.SetColorEmissive(const Value: Iz3DFloat3);
begin
  FColorEmissive:= Value;
end;

procedure Tz3DMaterial.SetDensity(const Value: Single);
begin
  FDensity:= Value;
end;

procedure Tz3DMaterial.SetElasticity(const Value: Single);
begin
  FElasticity:= Value;
end;

procedure Tz3DMaterial.SetEmissiveMode(const Value: Tz3DMaterialEmissiveMode);
begin
  FEmissiveMode:= Value;
end;

procedure Tz3DMaterial.SetFileName(const Value: PWideChar);
begin
  StringToWideChar(WideCharToString(Value), FFileName, 255);
end;

procedure Tz3DMaterial.SetReflectivity(const Value: Single);
begin
  FReflectivity:= Value;
end;

procedure Tz3DMaterial.SetRoughness(const Value: Single);
begin
  FRoughness:= Value;
end;

procedure Tz3DMaterial.SetSounds(const Value: PWideChar);
begin
  StringToWideChar(WideCharToString(Value), FSounds, 255);
end;

procedure Tz3DMaterial.SetSpecularAmount(const Value: Single);
begin
  FSpecularAmount:= Value;
end;

{ Tz3DMaterialController }

constructor Tz3DMaterialController.Create;
begin
  inherited;

  // Link this object to the desired events generated by the z3D Engine
  Notifications:= [z3dlnDevice];
  ScenarioStage:= z3dssCreatingSceneObjects;


  FMaterials:= TInterfaceList.Create;
  FDefaultTexture:= z3DCreateMaterialTexture;
  FDefaultTexture.Source:= z3dtsNew;
  FDefaultTexture.Width:= 4;
  FDefaultTexture.Height:= 4;
  FDefaultTexture.Format:= D3DFMT_A8R8G8B8;
  FMaterialFormat:= z3DFileSystemController.CreateObjectFormat;
  FMaterialFormat.Description:= 'Zenith Material File';
  FMaterialFormat.Extension:= 'zMaterial';
  FMaterialFormat.DefaultFolder:= fsMaterialsFolder;
  FMaterialFormat.Header:= 'ZMATERIAL';
  FMaterialTextureFormat:= z3DFileSystemController.CreateObjectFormat;
  FMaterialTextureFormat.Description:= 'Zenith Material Texture File';
  FMaterialTextureFormat.Extension:= 'dds';
  FMaterialTextureFormat.DefaultFolder:= fsMaterialTexturesFolder;
  FMaterialSoundFormat:= z3DFileSystemController.CreateObjectFormat;
  FMaterialSoundFormat.Description:= 'Zenith Material Sound File';
  FMaterialSoundFormat.Extension:= 'wav';
  FMaterialSoundFormat.DefaultFolder:= fsMaterialSoundsFolder;
end;

function Tz3DMaterialController.CreateMaterial: Iz3DMaterial;
begin
  Result:= Tz3DMaterial.Create;
  FMaterials.Add(Result);
end;

function Tz3DMaterialController.CreateMaterialFromFile(const AFileName: PWideChar): Iz3DMaterial;
var I: Integer;
    FLower: string;
begin
  // If the material already exists, don't load it again
  FLower:= LowerCase(WideCharToString(AFileName));
  for I:= 0 to MaterialCount-1 do
  if LowerCase(WideCharToString(Materials[I].FileName)) = FLower then
  begin
    Result:= Materials[I];
    Break;
  end;
  if Result = nil then
  begin
    Result:= CreateMaterial;
    Result.LoadFromFile(AFileName);
  end;
end;

procedure Tz3DMaterialController.CreateScenarioObjects;
var I, J: Integer;
begin
  FDefaultTexture.BeginDraw;
  try
    for I:= 0 to 3 do
    for J:= 0 to 3 do
    FDefaultTexture.SetPixel(I, J, z3DFloat3(1, 1, 1));
  finally
    FDefaultTexture.EndDraw;
    FDefaultTexture.GenerateNormalMap;
  end;
end;

function Tz3DMaterialController.GetDefaultTexture: Iz3DMaterialTexture;
begin
  Result:= FDefaultTexture;
end;

function Tz3DMaterialController.GetMaterialFormat: Iz3DObjectFileFormat;
begin
  Result:= FMaterialFormat;
end;

function Tz3DMaterialController.GetMaterialTextureFormat: Iz3DObjectFileFormat;
begin
  Result:= FMaterialTextureFormat;
end;

function Tz3DMaterialController.GetMaterialSoundFormat: Iz3DObjectFileFormat;
begin
  Result:= FMaterialSoundFormat;
end;

function Tz3DMaterialController.GetMaterialCount: Integer;
begin
  Result:= FMaterials.Count;
end;

function Tz3DMaterialController.GetMaterials(const AIndex: Integer): Iz3DMaterial;
begin
  Result:= FMaterials[AIndex] as Iz3DMaterial;
end;

procedure Tz3DMaterialController.RemoveMaterial(const AMaterial: Iz3DMaterial);
begin
  FMaterials.Remove(AMaterial);
end;

procedure Tz3DMaterialController.z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller);
begin
  inherited;
  if ACaller in [z3dcocResetDevice, z3dcocStartScenario] then
  CreateScenarioObjects;
end;

{ Tz3DFrustum }

constructor Tz3DFrustum.Create(const AOwner: Iz3DBase);
begin
  inherited;
  FLeftPlane:= z3DPlane;
  FRightPlane:= z3DPlane;
  FBottomPlane:= z3DPlane;
  FTopPlane:= z3DPlane;
  FNearPlane:= z3DPlane;
  FFarPlane:= z3DPlane;
  FNearClip:= 0.01;
  FFarClip:= 1000;
  FStats:= Tz3DFrustumStats.Create;
  FAspectRatio:= 1;
  FFieldOfView:= D3DX_PI / 4;
  FPosition:= z3DFloat3;
  FLookAt:= z3DFloat3(0, 0, 1);
  FProjectionKind:= z3dpkPerspective;
  FProjectionMatrix:= z3DMatrix;
  FLastViewMatrix:= z3DMatrix;
  FViewProjMatrix:= z3DMatrix;
  FUpVector:= z3DFloat3(0, 1, 0);
  FViewMatrix:= z3DMatrix;
  FVolumeHeight:= 1;
  FVolumeWidth:= 1;
  ApplyChanges;
end;

function Tz3DFrustum.GetBottomPlane: Iz3DPlane;
begin
  Result:= FBottomPlane;
end;

function Tz3DFrustum.GetFarPlane: Iz3DPlane;
begin
  Result:= FFarPlane;
end;

function Tz3DFrustum.GetLeftPlane: Iz3DPlane;
begin
  Result:= FLeftPlane;
end;

function Tz3DFrustum.GetNearPlane: Iz3DPlane;
begin
  Result:= FNearPlane;
end;

function Tz3DFrustum.GetRightPlane: Iz3DPlane;
begin
  Result:= FRightPlane;
end;

function Tz3DFrustum.GetTopPlane: Iz3DPlane;
begin
  Result:= FTopPlane;
end;

function Tz3DFrustum.TestBBCulling(const ABoundingBox: Iz3DBoundingBox): Boolean;
begin
  // TODO JP: Implementar (http://www.lighthouse3d.com/opengl/viewfrustum/)
end;

function Tz3DFrustum.TestBSCulling(const ABoundingSphere: Iz3DBoundingSphere): Boolean;

  function TestPlane(const APlane: Iz3DPlane): Boolean;
  var FDistance: Single;
  begin
    FDistance:= APlane.Dot(ABoundingSphere.Center);
    Result:= FDistance < -ABoundingSphere.Radius;
  end;

begin
  Result:= TestPlane(FNearPlane) or
  TestPlane(FLeftPlane) or TestPlane(FRightPlane) or
  TestPlane(FBottomPlane) or TestPlane(FTopPlane) or
  TestPlane(FFarPlane);
end;

function Tz3DFrustum.TestCulling(const APoint: Iz3DFloat3): Boolean;

  function TestPlane(const APlane: Iz3DPlane): Boolean;
  begin
    Result:= APlane.Dot(APoint) < 0;
  end;

begin
  Result:= TestPlane(FNearPlane) or
  TestPlane(FLeftPlane) or TestPlane(FRightPlane) or
  TestPlane(FBottomPlane) or TestPlane(FTopPlane) or
  TestPlane(FFarPlane);
end;

procedure Tz3DFrustum.ApplyChanges(const AUpdateView: Boolean = True; const AUpdateProj: Boolean = True;
  const AUpdatePlanes: Boolean = True);
var FC, FP, FL, FU: Iz3DFloat4;
begin
  inherited;

  // Build the view and projection matrices
  FLastViewMatrix.From(FViewMatrix);
  if AUpdateView then FViewMatrix.LookAt(FPosition, FLookAt, FUpVector);
  if AUpdateProj then
  begin
    if ProjectionKind = z3dpkPerspective then
    FProjectionMatrix.PerspectiveFOV(FFieldOfView, FAspectRatio, FNearClip, FFarClip) else
    FProjectionMatrix.Ortho(FVolumeWidth, FVolumeHeight, FNearClip, FFarClip);
  end;
  if AUpdateView or AUpdateProj then
  FViewProjMatrix.From(FViewMatrix).Multiply(FProjectionMatrix);

  if AUpdatePlanes then
  begin
    // Reset the stats
    Stats.Reset;

    // Get the left plane
    FLeftPlane.A:= FViewProjMatrix.e14+FViewProjMatrix.e11;
    FLeftPlane.B:= FViewProjMatrix.e24+FViewProjMatrix.e21;
    FLeftPlane.C:= FViewProjMatrix.e34+FViewProjMatrix.e31;
    FLeftPlane.D:= FViewProjMatrix.e44+FViewProjMatrix.e41;
    FLeftPlane.Normalize;

    // Get the right plane
    FRightPlane.A:= FViewProjMatrix.e14-FViewProjMatrix.e11;
    FRightPlane.B:= FViewProjMatrix.e24-FViewProjMatrix.e21;
    FRightPlane.C:= FViewProjMatrix.e34-FViewProjMatrix.e31;
    FRightPlane.D:= FViewProjMatrix.e44-FViewProjMatrix.e41;
    FRightPlane.Normalize;

    // Get the bottom plane
    FBottomPlane.A:= FViewProjMatrix.e14+FViewProjMatrix.e12;
    FBottomPlane.B:= FViewProjMatrix.e24+FViewProjMatrix.e22;
    FBottomPlane.C:= FViewProjMatrix.e34+FViewProjMatrix.e32;
    FBottomPlane.D:= FViewProjMatrix.e44+FViewProjMatrix.e42;
    FBottomPlane.Normalize;

    // Get the top plane
    FTopPlane.A:= FViewProjMatrix.e14-FViewProjMatrix.e12;
    FTopPlane.B:= FViewProjMatrix.e24-FViewProjMatrix.e22;
    FTopPlane.C:= FViewProjMatrix.e34-FViewProjMatrix.e32;
    FTopPlane.D:= FViewProjMatrix.e44-FViewProjMatrix.e42;
    FTopPlane.Normalize;

    // Get the near plane
    FNearPlane.A:= FViewProjMatrix.e13;
    FNearPlane.B:= FViewProjMatrix.e23;
    FNearPlane.C:= FViewProjMatrix.e33;
    FNearPlane.D:= FViewProjMatrix.e43;
    FNearPlane.Normalize;

    // Get the far plane
    FFarPlane.A:= FViewProjMatrix.e14-FViewProjMatrix.e13;
    FFarPlane.B:= FViewProjMatrix.e24-FViewProjMatrix.e23;
    FFarPlane.C:= FViewProjMatrix.e34-FViewProjMatrix.e33;
    FFarPlane.D:= FViewProjMatrix.e44-FViewProjMatrix.e43;
    FFarPlane.Normalize;
  end;

  // Extract the four components of the view matrix
  FC:= z3DFloat4(FViewMatrix.e11, FViewMatrix.e12, FViewMatrix.e13, FViewMatrix.e14);
  FP:= z3DFloat4(FViewMatrix.e21, FViewMatrix.e22, FViewMatrix.e23, FViewMatrix.e24);
  FL:= z3DFloat4(FViewMatrix.e31, FViewMatrix.e32, FViewMatrix.e33, FViewMatrix.e34);
  FU:= z3DFloat4(FViewMatrix.e41, FViewMatrix.e42, FViewMatrix.e43, FViewMatrix.e44);

  // Compute the difference with the last view matrix
  FC.Subtract(z3DFloat4(FLastViewMatrix.e11, FLastViewMatrix.e12, FLastViewMatrix.e13, FLastViewMatrix.e14));
  FP.Subtract(z3DFloat4(FLastViewMatrix.e21, FLastViewMatrix.e22, FLastViewMatrix.e23, FLastViewMatrix.e24));
  FL.Subtract(z3DFloat4(FLastViewMatrix.e31, FLastViewMatrix.e32, FLastViewMatrix.e33, FLastViewMatrix.e34));
  FU.Subtract(z3DFloat4(FLastViewMatrix.e41, FLastViewMatrix.e42, FLastViewMatrix.e43, FLastViewMatrix.e44));

  // Save the difference as a velocity from the previous frame
  FVelocity:= Saturate((FC.Length + FP.Length + FL.Length + FU.Length) * 0.1);
end;

function Tz3DFrustum.GetFarClip: Single;
begin
  Result:= FFarClip;
end;

function Tz3DFrustum.GetNearClip: Single;
begin
  Result:= FNearClip;
end;

procedure Tz3DFrustum.SetFarClip(const Value: Single);
begin
  FFarClip:= Value;
end;

procedure Tz3DFrustum.SetNearClip(const Value: Single);
begin
  FNearClip:= Value;
end;

function Tz3DFrustum.GetStats: Iz3DFrustumStats;
begin
  Result:= FStats;
end;

function Tz3DFrustum.TestObjectCulling(const AObject: Iz3DScenarioObject): Boolean;
begin
  Result:= TestBSCulling(AObject.BoundingSphere);
  if not Result and Stats.Enabled then
  begin
    Stats.AnyVisibleObject:= True;
    if not Stats.AnyVisibleStaticObject and z3DSupports(AObject, Iz3DScenarioStaticObject) then
    Stats.AnyVisibleStaticObject:= True;
    if not Stats.AnyVisibleDynamicObject and z3DSupports(AObject, Iz3DScenarioDynamicObject) then
    Stats.AnyVisibleDynamicObject:= True;
    if not Stats.AnyVisibleOpaqueObject and
    ((AObject.SubsetCount = 0) or not (AObject.Subsets[0].Material.ColorDiffuse.A < 1)) then
    Stats.AnyVisibleOpaqueObject:= True;
    if not Stats.AnyVisibleTranslucentObject and
    ((AObject.SubsetCount > 0) and (AObject.Subsets[0].Material.ColorDiffuse.A < 1)) then
    Stats.AnyVisibleTranslucentObject:= True;
  end;
end;

function Tz3DFrustum.GetAspectRatio: Single;
begin
  Result:= FAspectRatio;
end;

function Tz3DFrustum.GetFieldOfView: Single;
begin
  Result:= FFieldOfView;
end;

function Tz3DFrustum.GetLookAt: Iz3DFloat3;
begin
  Result:= FLookAt;
end;

function Tz3DFrustum.GetPosition: Iz3DFloat3;
begin
  Result:= FPosition;
end;

function Tz3DFrustum.GetProjectionKind: Tz3DProjectionKind;
begin
  Result:= FProjectionKind;
end;

function Tz3DFrustum.GetProjectionMatrix: Iz3DMatrix;
begin
  Result:= FProjectionMatrix;
end;

function Tz3DFrustum.GetUpVector: Iz3DFloat3;
begin
  Result:= FUpVector;
end;

function Tz3DFrustum.GetViewMatrix: Iz3DMatrix;
begin
  Result:= FViewMatrix;
end;

function Tz3DFrustum.GetVolumeHeight: Single;
begin
  Result:= FVolumeHeight;
end;

function Tz3DFrustum.GetVolumeWidth: Single;
begin
  Result:= FVolumeWidth;
end;

procedure Tz3DFrustum.SetAspectRatio(const Value: Single);
begin
  FAspectRatio:= Value;
end;

procedure Tz3DFrustum.SetFieldOfView(const Value: Single);
begin
  FFieldOfView:= Value;
end;

procedure Tz3DFrustum.SetProjectionKind(const Value: Tz3DProjectionKind);
begin
  FProjectionKind:= Value;
end;

procedure Tz3DFrustum.SetVolumeHeight(const Value: Single);
begin
  FVolumeHeight:= Value;
end;

procedure Tz3DFrustum.SetVolumeWidth(const Value: Single);
begin
  FVolumeWidth:= Value;
end;

function Tz3DFrustum.GetViewProjMatrix: Iz3DMatrix;
begin
  Result:= FViewProjMatrix;
end;

function Tz3DFrustum.GetLastViewMatrix: Iz3DMatrix;
begin
  Result:= FLastViewMatrix;
end;

function Tz3DFrustum.GetVelocity: Single;
begin
  Result:= FVelocity;
end;

{ Tz3DFrustumStats }

function Tz3DFrustumStats.GetAnyVisibleDynamicObject: Boolean;
begin
  Result:= FAnyVisibleDynamicObject;
end;

function Tz3DFrustumStats.GetAnyVisibleObject: Boolean;
begin
  Result:= FAnyVisibleObject;
end;

function Tz3DFrustumStats.GetAnyVisibleOpaqueObject: Boolean;
begin
  Result:= FAnyVisibleOpaqueObject;
end;

function Tz3DFrustumStats.GetAnyVisibleStaticObject: Boolean;
begin
  Result:= FAnyVisibleStaticObject;
end;

function Tz3DFrustumStats.GetAnyVisibleTranslucentObject: Boolean;
begin
  Result:= FAnyVisibleTranslucentObject;
end;

function Tz3DFrustumStats.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

procedure Tz3DFrustumStats.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FEnabled:= True;
end;

procedure Tz3DFrustumStats.Reset;
begin
  if Enabled then
  begin
    FAnyVisibleObject:= False;
    FAnyVisibleOpaqueObject:= False;
    FAnyVisibleTranslucentObject:= False;
    FAnyVisibleStaticObject:= False;
    FAnyVisibleDynamicObject:= False;
  end;
end;

procedure Tz3DFrustumStats.SetAnyVisibleDynamicObject(const Value: Boolean);
begin
  FAnyVisibleDynamicObject:= Value;
end;

procedure Tz3DFrustumStats.SetAnyVisibleObject(const Value: Boolean);
begin
  FAnyVisibleObject:= Value;
end;

procedure Tz3DFrustumStats.SetAnyVisibleOpaqueObject(const Value: Boolean);
begin
  FAnyVisibleOpaqueObject:= Value;
end;

procedure Tz3DFrustumStats.SetAnyVisibleStaticObject(const Value: Boolean);
begin
  FAnyVisibleStaticObject:= Value;
end;

procedure Tz3DFrustumStats.SetAnyVisibleTranslucentObject(const Value: Boolean);
begin
  FAnyVisibleTranslucentObject:= Value;
end;

procedure Tz3DFrustumStats.SetEnabled(const Value: Boolean);
begin
  FEnabled:= Value;
end;

{ Tz3DOctreeNode }

procedure Tz3DOctreeNode.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FBox:= z3DBoundingBox;
end;

function Tz3DOctreeNode.GetBox: Iz3DBoundingBox;
begin
  Result:= FBox;
end;

function Tz3DOctreeNode.GetChilds: Tz3DOctreeNodeChilds;
begin
  Result:= FChilds;
end;

function Tz3DOctreeNode.GetHasChilds: Boolean;
begin
  Result:= FHasChilds;
end;

procedure Tz3DOctreeNode.SetHasChilds(const Value: Boolean);
begin
  if FHasChilds <> Value then
  begin
    FHasChilds:= Value;
    if FHasChilds then CreateChilds else ClearChilds;
  end;
end;

procedure Tz3DOctreeNode.ClearChilds;
begin
  if FChilds[0][0][0] = nil then Exit;
  FChilds[0][0][0].ClearChilds;
  FChilds[0][0][0]:= nil;
  FChilds[1][0][0].ClearChilds;
  FChilds[1][0][0]:= nil;
  FChilds[0][1][0].ClearChilds;
  FChilds[0][1][0]:= nil;
  FChilds[1][1][0].ClearChilds;
  FChilds[1][1][0]:= nil;
  FChilds[0][0][1].ClearChilds;
  FChilds[0][0][1]:= nil;
  FChilds[1][0][1].ClearChilds;
  FChilds[1][0][1]:= nil;
  FChilds[0][1][1].ClearChilds;
  FChilds[0][1][1]:= nil;
  FChilds[1][1][1].ClearChilds;
  FChilds[1][1][1]:= nil;
  FHasChilds:= False;
end;

procedure Tz3DOctreeNode.CreateChilds;
begin
  if FChilds[0][0][0] <> nil then ClearChilds;
  
  FChilds[0][0][0]:= Tz3DOctreeNode.Create;
  FChilds[1][0][0]:= Tz3DOctreeNode.Create;
  FChilds[0][1][0]:= Tz3DOctreeNode.Create;
  FChilds[1][1][0]:= Tz3DOctreeNode.Create;
  FChilds[0][0][1]:= Tz3DOctreeNode.Create;
  FChilds[1][0][1]:= Tz3DOctreeNode.Create;
  FChilds[0][1][1]:= Tz3DOctreeNode.Create;
  FChilds[1][1][1]:= Tz3DOctreeNode.Create;

  // Set the childs dimensions
  FChilds[0][0][0].Box.Dimensions.X:= Box.Dimensions.X * 0.5;
  FChilds[0][0][0].Box.Dimensions.Y:= Box.Dimensions.Y * 0.5;
  FChilds[0][0][0].Box.Dimensions.Z:= Box.Dimensions.X * 0.5;
  FChilds[1][0][0].Box.Dimensions.X:= Box.Dimensions.X * 0.5;
  FChilds[1][0][0].Box.Dimensions.Y:= Box.Dimensions.Y * 0.5;
  FChilds[1][0][0].Box.Dimensions.Z:= Box.Dimensions.X * 0.5;
  FChilds[0][1][0].Box.Dimensions.X:= Box.Dimensions.X * 0.5;
  FChilds[0][1][0].Box.Dimensions.Y:= Box.Dimensions.Y * 0.5;
  FChilds[0][1][0].Box.Dimensions.Z:= Box.Dimensions.X * 0.5;
  FChilds[1][1][0].Box.Dimensions.X:= Box.Dimensions.X * 0.5;
  FChilds[1][1][0].Box.Dimensions.Y:= Box.Dimensions.Y * 0.5;
  FChilds[1][1][0].Box.Dimensions.Z:= Box.Dimensions.X * 0.5;
  FChilds[0][0][1].Box.Dimensions.X:= Box.Dimensions.X * 0.5;
  FChilds[0][0][1].Box.Dimensions.Y:= Box.Dimensions.Y * 0.5;
  FChilds[0][0][1].Box.Dimensions.Z:= Box.Dimensions.X * 0.5;
  FChilds[1][0][1].Box.Dimensions.X:= Box.Dimensions.X * 0.5;
  FChilds[1][0][1].Box.Dimensions.Y:= Box.Dimensions.Y * 0.5;
  FChilds[1][0][1].Box.Dimensions.Z:= Box.Dimensions.X * 0.5;
  FChilds[0][1][1].Box.Dimensions.X:= Box.Dimensions.X * 0.5;
  FChilds[0][1][1].Box.Dimensions.Y:= Box.Dimensions.Y * 0.5;
  FChilds[0][1][1].Box.Dimensions.Z:= Box.Dimensions.X * 0.5;
  FChilds[1][1][1].Box.Dimensions.X:= Box.Dimensions.X * 0.5;
  FChilds[1][1][1].Box.Dimensions.Y:= Box.Dimensions.Y * 0.5;
  FChilds[1][1][1].Box.Dimensions.Z:= Box.Dimensions.X * 0.5;

  // Set the childs center
  FChilds[0][0][0].Box.Center.X:= Box.Center.X - Box.Dimensions.X * 0.5;
  FChilds[0][0][0].Box.Center.Y:= Box.Center.Y - Box.Dimensions.Y * 0.5;
  FChilds[0][0][0].Box.Center.Z:= Box.Center.Z - Box.Dimensions.Z * 0.5;
  FChilds[1][0][0].Box.Center.X:= Box.Center.X + Box.Dimensions.X * 0.5;
  FChilds[1][0][0].Box.Center.Y:= Box.Center.Y - Box.Dimensions.Y * 0.5;
  FChilds[1][0][0].Box.Center.Z:= Box.Center.Z - Box.Dimensions.Z * 0.5;
  FChilds[0][1][0].Box.Center.X:= Box.Center.X - Box.Dimensions.X * 0.5;
  FChilds[0][1][0].Box.Center.Y:= Box.Center.Y + Box.Dimensions.Y * 0.5;
  FChilds[0][1][0].Box.Center.Z:= Box.Center.Z - Box.Dimensions.Z * 0.5;
  FChilds[1][1][0].Box.Center.X:= Box.Center.X + Box.Dimensions.X * 0.5;
  FChilds[1][1][0].Box.Center.Y:= Box.Center.Y + Box.Dimensions.Y * 0.5;
  FChilds[1][1][0].Box.Center.Z:= Box.Center.Z - Box.Dimensions.Z * 0.5;
  FChilds[0][0][1].Box.Center.X:= Box.Center.X - Box.Dimensions.X * 0.5;
  FChilds[0][0][1].Box.Center.Y:= Box.Center.Y - Box.Dimensions.Y * 0.5;
  FChilds[0][0][1].Box.Center.Z:= Box.Center.Z + Box.Dimensions.Z * 0.5;
  FChilds[1][0][1].Box.Center.X:= Box.Center.X + Box.Dimensions.X * 0.5;
  FChilds[1][0][1].Box.Center.Y:= Box.Center.Y - Box.Dimensions.Y * 0.5;
  FChilds[1][0][1].Box.Center.Z:= Box.Center.Z + Box.Dimensions.Z * 0.5;
  FChilds[0][1][1].Box.Center.X:= Box.Center.X - Box.Dimensions.X * 0.5;
  FChilds[0][1][1].Box.Center.Y:= Box.Center.Y + Box.Dimensions.Y * 0.5;
  FChilds[0][1][1].Box.Center.Z:= Box.Center.Z + Box.Dimensions.Z * 0.5;
  FChilds[1][1][1].Box.Center.X:= Box.Center.X + Box.Dimensions.X * 0.5;
  FChilds[1][1][1].Box.Center.Y:= Box.Center.Y + Box.Dimensions.Y * 0.5;
  FChilds[1][1][1].Box.Center.Z:= Box.Center.Z + Box.Dimensions.Z * 0.5;

  FHasChilds:= True;
end;

procedure Tz3DOctreeNode.Subdivide(const AMaxSubdivisions: Integer);
begin
  if AMaxSubdivisions < 1 then
  begin
    ClearChilds;
    Exit;
  end;
  if not HasChilds then CreateChilds;
  FChilds[0][0][0].Subdivide(AMaxSubdivisions - 1);
  FChilds[1][0][0].Subdivide(AMaxSubdivisions - 1);
  FChilds[0][1][0].Subdivide(AMaxSubdivisions - 1);
  FChilds[1][1][0].Subdivide(AMaxSubdivisions - 1);
  FChilds[0][0][1].Subdivide(AMaxSubdivisions - 1);
  FChilds[1][0][1].Subdivide(AMaxSubdivisions - 1);
  FChilds[0][1][1].Subdivide(AMaxSubdivisions - 1);
  FChilds[1][1][1].Subdivide(AMaxSubdivisions - 1);
end;

function Tz3DOctreeNode.GetObjects: Tz3DOctreeNodeObjects;
begin
  Result:= FObjects;
end;

{ Tz3DOctree }

procedure Tz3DOctree.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FRoot:= Tz3DOctreeNode.Create;
  FRoot.Box.Dimensions.X:= 1000;
  FRoot.Box.Dimensions.Y:= 1000;
  FRoot.Box.Dimensions.Z:= 1000;
  FNodeCount:= 1;
end;

function Tz3DOctree.GetRoot: Iz3DOctreeNode;
begin
  Result:= FRoot;
end;

function Tz3DOctree.NodeFromPoint(const APoint: Iz3DFloat3): Iz3DOctreeNode;
begin

end;

{ Tz3DScenarioEnvironment }

procedure Tz3DScenarioEnvironment.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FAutoFade:= True;
  FBoundingBox:= z3DBoundingBox;
  FGravity:= -9.8;
  FOverrideGravity:= True;
  FOverrideWind:= True;
  FSealed:= True;
  FWindSpeed:= z3DFloat3;
  FKind:= z3dekGeneric;
  FAmbientColor:= z3DFloat3(0.2, 0.17, 0.35);
  FFog:= Tz3DFog.Create;
end;

function Tz3DScenarioEnvironment.GetAutoFade: Boolean;
begin
  Result:= FAutoFade;
end;

function Tz3DScenarioEnvironment.GetBoundingBox: Iz3DBoundingBox;
begin
  Result:= FBoundingBox;
end;

function Tz3DScenarioEnvironment.GetGravity: Single;
begin
  Result:= FGravity;
end;

function Tz3DScenarioEnvironment.GetOverrideGravity: Boolean;
begin
  Result:= FOverrideGravity;
end;

function Tz3DScenarioEnvironment.GetOverrideWind: Boolean;
begin
  Result:= FOverrideWind;
end;

function Tz3DScenarioEnvironment.GetSealed: Boolean;
begin
  Result:= FSealed;
end;

function Tz3DScenarioEnvironment.GetWindSpeed: Iz3DFloat3;
begin
  Result:= FWindSpeed;
end;

procedure Tz3DScenarioEnvironment.SetAutoFade(const Value: Boolean);
begin
  FAutoFade:= Value;
end;

procedure Tz3DScenarioEnvironment.SetGravity(const Value: Single);
begin
  FGravity:= Value;
end;

procedure Tz3DScenarioEnvironment.SetOverrideGravity(const Value: Boolean);
begin
  FOverrideGravity:= Value;
end;

procedure Tz3DScenarioEnvironment.SetOverrideWind(const Value: Boolean);
begin
  FOverrideWind:= Value;
end;

procedure Tz3DScenarioEnvironment.SetSealed(const Value: Boolean);
begin
  FSealed:= Value;
end;

function Tz3DScenarioEnvironment.GetKind: Tz3DEnvironmentKind;
begin
  Result:= FKind;
end;

procedure Tz3DScenarioEnvironment.SetKind(const Value: Tz3DEnvironmentKind);
begin
  FKind:= Value;
end;

function Tz3DScenarioEnvironment.ContainsPoint(const APoint: Iz3DFloat3): Boolean; stdcall;
begin
  Result:= (BoundingBox.Dimensions.X * 0.5) - Abs(APoint.X - BoundingBox.Center.X) > 0;
  if Result then Result:= (BoundingBox.Dimensions.Y * 0.5) - Abs(APoint.Y - BoundingBox.Center.Y) > 0;
  if Result then Result:= (BoundingBox.Dimensions.Z * 0.5) - Abs(APoint.Z - BoundingBox.Center.Z) > 0;
end;

function Tz3DScenarioEnvironment.IncidenceOnObject(const AObject: Iz3DScenarioObject): Single; stdcall;
const FEpsilon = 0.00001;
var FX, FY, FZ: Single;
begin
  Result:= Saturate((BoundingBox.Dimensions.X * 0.5 - Abs(AObject.BoundingBox.Center.X - BoundingBox.Center.X) - AObject.BoundingBox.Dimensions.X * 0.5)
  / (AObject.BoundingBox.Dimensions.X + FEpsilon) + 1);
  if Result <= 0 then Exit;
  FX:= Result;
  Result:= Saturate((BoundingBox.Dimensions.Y * 0.5 - Abs(AObject.BoundingBox.Center.Y - BoundingBox.Center.Y) - AObject.BoundingBox.Dimensions.Y * 0.5)
  / (AObject.BoundingBox.Dimensions.Y + FEpsilon) + 1);
  if Result <= 0 then Exit;
  FY:= Result;
  Result:= Saturate((BoundingBox.Dimensions.Z * 0.5 - Abs(AObject.BoundingBox.Center.Z - BoundingBox.Center.Z) - AObject.BoundingBox.Dimensions.Z * 0.5)
  / (AObject.BoundingBox.Dimensions.Z + FEpsilon) + 1);
  if Result <= 0 then Exit;
  FZ:= Result;
  Result:= FX * FY * FZ;
end;

function Tz3DScenarioEnvironment.GetChilds: Tz3DScenarioEnvironments;
begin
  Result:= FChilds;
end;

function Tz3DScenarioEnvironment.AddChild: Iz3DScenarioEnvironment;
begin
  Result:= Tz3DScenarioEnvironment.Create(Self);
  SetLength(FChilds, Length(FChilds)+1);
  FChilds[Length(FChilds)-1].Environment:= Result;
end;

procedure Tz3DScenarioEnvironment.RemoveChild(const AEnvironment: Iz3DScenarioEnvironment);
var I, J: Integer;
begin
  for I:= 0 to Length(FChilds)-1 do
  if FChilds[I].Environment = AEnvironment then
  begin
    for J:= I to Length(FChilds)-2 do
    FChilds[J]:= FChilds[J+1];
    SetLength(FChilds, Length(FChilds)-1);
  end;
end;

function Tz3DScenarioEnvironment.GetAmbientColor: Iz3DFloat3;
begin
  Result:= FAmbientColor;
end;

function Tz3DScenarioEnvironment.GetFog: Iz3DFog;
begin
  Result:= FFog;
end;

end.
