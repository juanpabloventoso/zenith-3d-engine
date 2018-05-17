unit z3DScenario_Intf;

interface

uses Windows, D3DX9, z3DMath_Intf, z3DClasses_Intf, z3DComponents_Intf,
  z3DFileSystem_Intf;

type

  Iz3DMaterial = interface;
  Iz3DFog = interface;

  Iz3DScenarioEntity = interface;
  Iz3DScenarioObject = interface;
  Iz3DScenarioStaticObject = interface;
  Iz3DScenarioDynamicObject = interface;
  Iz3DScenarioEnvironment = interface;




{==============================================================================}
{== Scenario interface                                                       ==}
{==============================================================================}
{== Contains the attributes that are applied to the global scene. It also    ==}
{== begins the render chain for every renderable object on the scene         ==}
{==============================================================================}

  Iz3DFrustumStats = interface(Iz3DBase)['{07BF3F34-4B33-4AF6-9175-54EADF792E13}']
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

    property AnyVisibleObject: Boolean read GetAnyVisibleObject write SetAnyVisibleObject;
    property AnyVisibleOpaqueObject: Boolean read GetAnyVisibleOpaqueObject write SetAnyVisibleOpaqueObject;
    property AnyVisibleTranslucentObject: Boolean read GetAnyVisibleTranslucentObject write SetAnyVisibleTranslucentObject;
    property AnyVisibleStaticObject: Boolean read GetAnyVisibleStaticObject write SetAnyVisibleStaticObject;
    property AnyVisibleDynamicObject: Boolean read GetAnyVisibleDynamicObject write SetAnyVisibleDynamicObject;
    property Enabled: Boolean read GetEnabled write SetEnabled;
  end;

  Tz3DProjectionKind = (z3dpkPerspective, z3dpkOrthogonal);

  Iz3DFrustum = interface(Iz3DBase)['{6D59B926-1BE5-4DF4-9EDA-81CB1B423A06}']
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

    procedure ApplyChanges(const AUpdateView: Boolean = True; const AUpdateProj: Boolean = True;
      const AUpdatePlanes: Boolean = True); stdcall;

    function TestCulling(const APoint: Iz3DFloat3): Boolean; stdcall;
    function TestBSCulling(const ABoundingSphere: Iz3DBoundingSphere): Boolean; stdcall;
    function TestBBCulling(const ABoundingBox: Iz3DBoundingBox): Boolean; stdcall;
    function TestObjectCulling(const AObject: Iz3DScenarioObject): Boolean; stdcall;

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


  Iz3DOctreeNode = interface;

  Tz3DOctreeNodeChilds = array[0..1, 0..1, 0..1] of Iz3DOctreeNode;

  Tz3DOctreeNodeObject = packed record
    StaticObject: Iz3DScenarioStaticObject;
    Faces: array of Integer;
    FullObject: Boolean;
  end;

  Tz3DOctreeNodeObjects = array of Tz3DOctreeNodeObject;

  Iz3DOctreeNode = interface(Iz3DBase)['{41B1FE01-4BA4-4332-8AF6-7507EB68C180}']
    function GetObjects: Tz3DOctreeNodeObjects; stdcall;
    function GetBox: Iz3DBoundingBox; stdcall;
    function GetChilds: Tz3DOctreeNodeChilds; stdcall;
    function GetHasChilds: Boolean; stdcall;
    procedure SetHasChilds(const Value: Boolean); stdcall;
    procedure Subdivide(const AMaxSubdivisions: Integer); stdcall;
    procedure CreateChilds; stdcall;
    procedure ClearChilds; stdcall;

    property Childs: Tz3DOctreeNodeChilds read GetChilds;
    property Box: Iz3DBoundingBox read GetBox;
    property HasChilds: Boolean read GetHasChilds write SetHasChilds;
    property Objects: Tz3DOctreeNodeObjects read GetObjects;
  end;

  Iz3DOctree = interface(Iz3DBase)['{1ED3218B-F3D2-443A-8B51-3FEF92DE213D}']
    function GetRoot: Iz3DOctreeNode; stdcall;
    function NodeFromPoint(const APoint: Iz3DFloat3): Iz3DOctreeNode; stdcall;

    property Root: Iz3DOctreeNode read GetRoot;
  end;

  Tz3DEnvironmentKind = (z3dekGeneric, z3dekRoom, z3dekCave, z3dekHallway, z3dekForest,
  z3dekCity, z3dekMountains);

  Tz3DScenarioEnvironment = packed record
    Environment: Iz3DScenarioEnvironment;
    Incidence: Single;
  end;

  Tz3DScenarioEnvironments = array of Tz3DScenarioEnvironment;

  Iz3DScenarioEnvironment = interface(Iz3DBase)['{8B76C899-6239-4D32-8721-42F8ECC0DD22}']
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

    function ContainsPoint(const APoint: Iz3DFloat3): Boolean; stdcall;
    function IncidenceOnObject(const AObject: Iz3DScenarioObject): Single; stdcall;
    function AddChild: Iz3DScenarioEnvironment; stdcall;
    procedure RemoveChild(const AEnvironment: Iz3DScenarioEnvironment); stdcall;

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

  Tz3DScenarioCreationSteps = (z3dscsScenario, z3dscsEnvironment, z3dscsObjects, z3dscsLightingSystem);

  Tz3DScenarioKind = (z3dskDefault, z3dskIndoor, z3dskOutdoor, z3dskMixed);

  Iz3DScenario = interface(Iz3DPersistent)['{5C20B75C-7738-4172-9D09-0901A31AEEC1}']
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
    procedure FrameRender; stdcall;
    procedure ResetDevice; stdcall;
    procedure AddEntity(const AEntity: Iz3DScenarioEntity); stdcall;
    procedure RemoveEntity(const AEntity: Iz3DScenarioEntity); stdcall;
    function IndexOf(const AEntity: Iz3DScenarioEntity): Integer; stdcall;

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

  Iz3DScenarioEntity = interface(Iz3DBase)['{005AD0FD-7993-42A9-A69C-7EABB20CFC3F}']
    function GetIndex: Integer; stdcall;
    
    property Index: Integer read GetIndex;
  end;

  Iz3DScenarioObjectSubset = interface(Iz3DBase)['{BEB88413-E6CB-4AB1-9BB8-AE1ED30364CE}']
    function GetMaterial: Iz3DMaterial; stdcall;
    function GetBoundingBox: Iz3DBoundingBox; stdcall;
    function GetBoundingSphere: Iz3DBoundingSphere; stdcall;

    property Material: Iz3DMaterial read GetMaterial;
    property BoundingSphere: Iz3DBoundingSphere read GetBoundingSphere;
    property BoundingBox: Iz3DBoundingBox read GetBoundingBox;
  end;

  Tz3DScenarioObjectShape = (z3dsosSphere, z3dsosCube);
  Tz3DScenarioObjectLOD = (z3dsolLow, z3dsolMid, z3dsolHigh);

  Iz3DScenarioObject = interface(Iz3DScenarioEntity)['{CF3545AD-61C7-4F0C-825F-2D60F8B61C07}']
    function GetAutoLOD: Boolean; stdcall;
    function GetLOD: Tz3DScenarioObjectLOD; stdcall;
    procedure SetAutoLOD(const Value: Boolean); stdcall;
    procedure SetLOD(const Value: Tz3DScenarioObjectLOD); stdcall;
    function GetEnvironments: Tz3DScenarioEnvironments; stdcall;
    function GetViewCenter: Iz3DFloat4; stdcall;
    function GetVisible: Boolean; stdcall;
    function GetBoundingBox: Iz3DBoundingBox; stdcall;
    function GetBoundingSphere: Iz3DBoundingSphere; stdcall;
    function GetShape: Tz3DScenarioObjectShape; stdcall;
    function GetSubsetCount: Integer; stdcall;
    function GetSubsets(const I: Integer): Iz3DScenarioObjectSubset; stdcall;
    function GetInFrustum: Boolean; stdcall;
    procedure SetVisible(const Value: Boolean); stdcall;

    procedure FindCurrentEnvironments(const ARoot: Iz3DScenarioEnvironment); stdcall;
    function InEnvironment(const AEnvironment: Iz3DScenarioEnvironment): Boolean; stdcall;

    procedure Show; stdcall;
    procedure Hide; stdcall;
    procedure FrameMove; stdcall;

    procedure Render(const AMaterials: Boolean = True; const ALighting: Boolean = True;
      const AShader: Iz3DShader = nil); stdcall;

    property LOD: Tz3DScenarioObjectLOD read GetLOD write SetLOD;
    property AutoLOD: Boolean read GetAutoLOD write SetAutoLOD;
    property Environments: Tz3DScenarioEnvironments read GetEnvironments;
    property Shape: Tz3DScenarioObjectShape read GetShape;
    property BoundingSphere: Iz3DBoundingSphere read GetBoundingSphere;
    property BoundingBox: Iz3DBoundingBox read GetBoundingBox;
    property ViewCenter: Iz3DFloat4 read GetViewCenter;
    property Subsets[const I: Integer]: Iz3DScenarioObjectSubset read GetSubsets;
    property SubsetCount: Integer read GetSubsetCount;
    property Visible: Boolean read GetVisible write SetVisible;
    property InFrustum: Boolean read GetInFrustum;
  end;

  Iz3DScenarioStaticObject = interface(Iz3DScenarioObject)['{457657D7-C6D1-4240-8859-95A3851DDD45}']
  end;

  Iz3DScenarioDynamicObject = interface(Iz3DScenarioObject)['{D50CAB4B-45F3-4375-8C9A-521D2D28E8B2}']
    function GetAcceleration: Iz3DFloat3; stdcall;
    function GetVelocity: Iz3DFloat3; stdcall;
    function GetGround: Boolean; stdcall;
    procedure SetGround(const Value: Boolean); stdcall;
    function GetEnablePhysics: Boolean; stdcall;
    procedure SetEnablePhysics(const Value: Boolean); stdcall;

    property Acceleration: Iz3DFloat3 read GetAcceleration;
    property Velocity: Iz3DFloat3 read GetVelocity;
    property Ground: Boolean read GetGround write SetGround;
    property EnablePhysics: Boolean read GetEnablePhysics write SetEnablePhysics;
  end;

{==============================================================================}
{== Fog interface                                                            ==}
{==============================================================================}
{== Controller for the fog effect of the scenario                            ==}
{==============================================================================}

  Iz3DFog = interface(Iz3DBase)['{A261C837-8A74-4711-B699-2EE6A49EBEC6}']
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

    procedure Show; stdcall;
    procedure Hide; stdcall;

    property Color: Iz3DFloat3 read GetColor;
    property RangeMin: Single read GetRangeMin write SetRangeMin;
    property RangeMax: Single read GetRangeMax write SetRangeMax;
    property Density: Single read GetDensity write SetDensity;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Uniform: Boolean read GetUniform write SetUniform;
  end;



  Tz3DMaterialEmissiveMode = (z3dmemIncandescent, z3dmemInnerLight);

  Iz3DMaterial = interface(Iz3DPersistent)['{F9997D0B-A491-4276-87F4-1D5194FE4909}']
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

    property FileName: PWideChar read GetFileName write SetFileName;
    property Density: Single read GetDensity write SetDensity;
    property Elasticity: Single read GetElasticity write SetElasticity;
    property Sounds: PWideChar read GetSounds write SetSounds;
    property AlbedoFactor: Iz3DFloat2 read GetAlbedoFactor;
    property ColorDiffuse: Iz3DFloat4 read GetColorDiffuse write SetColorDiffuse;
    property Roughness: Single read GetRoughness write SetRoughness;
    property Texture: Iz3DMaterialTexture read GetTexture;
    property ColorEmissive: Iz3DFloat3 read GetColorEmissive write SetColorEmissive;
    property Reflectivity: Single read GetReflectivity write SetReflectivity;
    property EmissiveMode: Tz3DMaterialEmissiveMode read GetEmissiveMode write SetEmissiveMode;
    property SpecularAmount: Single read GetSpecularAmount write SetSpecularAmount;
  end;

  Iz3DMaterialController = interface(Iz3DBase)['{CF23B71D-0F00-47DF-90C5-0B1CE7651A32}']
    function GetMaterialFormat: Iz3DObjectFileFormat; stdcall;
    function GetMaterialTextureFormat: Iz3DObjectFileFormat; stdcall;
    function GetMaterialSoundFormat: Iz3DObjectFileFormat; stdcall;
    function GetMaterialCount: Integer; stdcall;
    function GetMaterials(const AIndex: Integer): Iz3DMaterial; stdcall;
    function GetDefaultTexture: Iz3DMaterialTexture; stdcall;

    procedure CreateScenarioObjects; stdcall;
    function CreateMaterial: Iz3DMaterial; stdcall;
    function CreateMaterialFromFile(const AFileName: PWideChar): Iz3DMaterial; stdcall;
    procedure RemoveMaterial(const AMaterial: Iz3DMaterial); stdcall;

    property MaterialFormat: Iz3DObjectFileFormat read GetMaterialFormat;
    property MaterialTextureFormat: Iz3DObjectFileFormat read GetMaterialTextureFormat;
    property MaterialSoundFormat: Iz3DObjectFileFormat read GetMaterialSoundFormat;
    property DefaultTexture: Iz3DMaterialTexture read GetDefaultTexture;
    property Materials[const AIndex: Integer]: Iz3DMaterial read GetMaterials;
    property MaterialCount: Integer read GetMaterialCount;
  end;

implementation

end.
