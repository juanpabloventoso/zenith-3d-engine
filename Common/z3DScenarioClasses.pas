unit z3DScenarioClasses;

interface

uses Windows, D3DX9, z3DMath_Intf, z3DComponents_Intf, Classes,
  z3DScenario_Intf, z3DClasses_Intf, z3DClasses_Impl;

type

  Tz3DScenarioEntity = class(Tz3DBase, Iz3DScenarioEntity)
  protected
    function GetIndex: Integer; stdcall;
  public
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
    procedure Cleanup; override; stdcall;
  public
    property Index: Integer read GetIndex;
  end;

  Tz3DScenarioLinkedEntity = class(Tz3DLinked, Iz3DScenarioEntity)
  protected
    function GetIndex: Integer; stdcall;
  public
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
    procedure Cleanup; override; stdcall;
  public
    property Index: Integer read GetIndex;
  end;

  Tz3DScenarioObjectSubset = class(Tz3DBase, Iz3DScenarioObjectSubset)
  private
    FMaterial: Iz3DMaterial;
    FBoundingBox: Iz3DBoundingBox;
    FBoundingSphere: Iz3DBoundingSphere;
  protected
    function GetMaterial: Iz3DMaterial; virtual; stdcall;
    function GetBoundingBox: Iz3DBoundingBox; virtual; stdcall;
    function GetBoundingSphere: Iz3DBoundingSphere; virtual; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property Material: Iz3DMaterial read GetMaterial;
    property BoundingSphere: Iz3DBoundingSphere read GetBoundingSphere;
    property BoundingBox: Iz3DBoundingBox read GetBoundingBox;
  end;

  Tz3DScenarioObject = class(Tz3DScenarioEntity, Iz3DScenarioObject)
  private
    FViewCenter: Iz3DFloat4;
    FVisible: Boolean;
    FBoundingBox: Iz3DBoundingBox;
    FBoundingSphere: Iz3DBoundingSphere;
    FShape: Tz3DScenarioObjectShape;
    FSubsets: IInterfaceList;
    FInFrustum: Boolean;
    FEnvironments: Tz3DScenarioEnvironments;
    FAutoLOD: Boolean;
    FLOD: Tz3DScenarioObjectLOD;
  protected
    function GetAutoLOD: Boolean; stdcall;
    function GetLOD: Tz3DScenarioObjectLOD; stdcall;
    procedure SetAutoLOD(const Value: Boolean); stdcall;
    procedure SetLOD(const Value: Tz3DScenarioObjectLOD); stdcall;
    function GetInFrustum: Boolean; stdcall;
    function GetViewCenter: Iz3DFloat4; virtual; stdcall;
    function GetVisible: Boolean; virtual; stdcall;
    function GetBoundingBox: Iz3DBoundingBox; virtual; stdcall;
    function GetBoundingSphere: Iz3DBoundingSphere; virtual; stdcall;
    function GetShape: Tz3DScenarioObjectShape; virtual; stdcall;
    function GetSubsetCount: Integer; virtual; stdcall;
    function GetSubsets(const I: Integer): Iz3DScenarioObjectSubset; virtual; stdcall;
    procedure SetVisible(const Value: Boolean); virtual; stdcall;
    function GetEnvironments: Tz3DScenarioEnvironments; virtual; stdcall;
    function InEnvironment(const AEnvironment: Iz3DScenarioEnvironment): Boolean; virtual; stdcall;
    procedure FindCurrentEnvironments(const ARoot: Iz3DScenarioEnvironment); virtual; stdcall;
  public
    procedure Show; virtual; stdcall;
    procedure Hide; virtual; stdcall;
    procedure FrameMove; virtual; stdcall;
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
    procedure Render(const AMaterials: Boolean = True; const ALighting: Boolean = True;
      const AShader: Iz3DShader = nil); virtual; stdcall;
  public
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

  Tz3DScenarioStaticObject = class(Tz3DScenarioObject, Iz3DScenarioStaticObject)
  end;

  Tz3DScenarioDynamicObject = class(Tz3DScenarioObject, Iz3DScenarioDynamicObject)
  private
    FAcceleration: Iz3DFloat3;
    FVelocity: Iz3DFloat3;
    FGround: Boolean;
    FEnablePhysics: Boolean;
  protected
    function GetAcceleration: Iz3DFloat3; virtual; stdcall;
    function GetVelocity: Iz3DFloat3; virtual; stdcall;
    function GetGround: Boolean; virtual; stdcall;
    procedure SetGround(const Value: Boolean); virtual; stdcall;
    function GetEnablePhysics: Boolean; virtual; stdcall;
    procedure SetEnablePhysics(const Value: Boolean); virtual; stdcall;
  public
    procedure FrameMove; override; stdcall;
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property Acceleration: Iz3DFloat3 read GetAcceleration;
    property Velocity: Iz3DFloat3 read GetVelocity;
    property Ground: Boolean read GetGround write SetGround;
    property EnablePhysics: Boolean read GetEnablePhysics write SetEnablePhysics;
  end;

implementation

uses z3DScenario_Func, z3DMath_Func, z3DEngine_Func, Math, z3DCore_Func;

{ Tz3DScenarioObjectSubset }

constructor Tz3DScenarioObjectSubset.Create(const AOwner: Iz3DBase);
begin
  inherited;
  if z3DMaterialController <> nil then
  FMaterial:= z3DMaterialController.CreateMaterial;
  FBoundingBox:= z3DBoundingBox;
  FBoundingSphere:= z3DBoundingSphere;
end;

function Tz3DScenarioObjectSubset.GetBoundingBox: Iz3DBoundingBox;
begin
  Result:= FBoundingBox;
end;

function Tz3DScenarioObjectSubset.GetBoundingSphere: Iz3DBoundingSphere;
begin
  Result:= FBoundingSphere;
end;

function Tz3DScenarioObjectSubset.GetMaterial: Iz3DMaterial;
begin
  Result:= FMaterial;
end;

{ Tz3DScenarioObject }

procedure Tz3DScenarioObject.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FAutoLOD:= True;
  FLOD:= z3dsolHigh;
  FViewCenter:= z3DFloat4;
  FVisible:= True;
  FBoundingBox:= z3DBoundingBox;
  FBoundingSphere:= z3DBoundingSphere;
  FShape:= z3dsosCube;
  FSubsets:= TInterfaceList.Create;
end;

function Tz3DScenarioObject.GetBoundingBox: Iz3DBoundingBox;
begin
  Result:= FBoundingBox;
end;

function Tz3DScenarioObject.GetBoundingSphere: Iz3DBoundingSphere;
begin
  Result:= FBoundingSphere;
end;

function Tz3DScenarioObject.GetShape: Tz3DScenarioObjectShape;
begin
  Result:= FShape;
end;

function Tz3DScenarioObject.GetSubsetCount: Integer;
begin
  Result:= FSubsets.Count;
end;

function Tz3DScenarioObject.GetSubsets(const I: Integer): Iz3DScenarioObjectSubset;
begin
  Result:= FSubsets[I] as Iz3DScenarioObjectSubset;
end;

function Tz3DScenarioObject.GetViewCenter: Iz3DFloat4;
begin
  Result:= FViewCenter;
end;

function Tz3DScenarioObject.GetVisible: Boolean;
begin
  Result:= FVisible;
end;

procedure Tz3DScenarioObject.Hide;
begin
  Visible:= False;
end;

procedure Tz3DScenarioObject.SetVisible(const Value: Boolean);
begin
  FVisible:= Value;
end;

procedure Tz3DScenarioObject.Show;
begin
  Visible:= True;
end;

function Tz3DScenarioObject.GetInFrustum: Boolean;
begin
  Result:= FInFrustum;
end;

procedure Tz3DScenarioObject.FrameMove;
var FViewEdge: Single;
begin
  FInFrustum:= not z3DScenario.ViewFrustum.TestObjectCulling(Self);

  if FInFrustum then
  begin
    // Get the view center from the current view matrix
    ViewCenter.From(D3DXVector4(BoundingBox.Center.XYZ, 1));
    ViewCenter.Transform(z3DScenario.ViewFrustum.ViewProjMatrix);
    if FAutoLOD then
    begin
      FViewEdge:= ViewCenter.Z-BoundingSphere.Radius;
      if FViewEdge > 50 then LOD:= z3dsolLow else
      if FViewEdge > 10 then LOD:= z3dsolMid else LOD:= z3dsolHigh;
    end;
  end;
  SetLength(FEnvironments, 0);
  FindCurrentEnvironments(z3DScenario.Environment);
end;

procedure Tz3DScenarioObject.FindCurrentEnvironments(const ARoot: Iz3DScenarioEnvironment);
const FEpsilon = 0.00001;
var I, FLength: Integer;
    FIncidence, FTotalIncidence: Single;
begin

  // If this environment has no incidence, stop searching
  FIncidence:= ARoot.IncidenceOnObject(Self);
  if FIncidence < FEpsilon then Exit;

  // Search for the child environments first
  FLength:= Length(FEnvironments);
  for I:= 0 to Length(ARoot.Childs)-1 do
  FindCurrentEnvironments(ARoot.Childs[I].Environment);

  FTotalIncidence:= 0;
  if FLength < Length(FEnvironments) then
  for I:= FLength to Length(FEnvironments)-1 do
  FTotalIncidence:= FTotalIncidence + FEnvironments[I].Incidence;

  // If no indicent childs were found, add this environment 
  if (FLength = Length(FEnvironments)) or (FTotalIncidence < 1 - FEpsilon) then
  begin
    SetLength(FEnvironments, Length(FEnvironments)+1);
    FEnvironments[Length(FEnvironments)-1].Environment:= ARoot;
    if (FTotalIncidence < 1 - FEpsilon) and (FTotalIncidence > FEpsilon) then
    FEnvironments[Length(FEnvironments)-1].Incidence:= 1 - FTotalIncidence else
    FEnvironments[Length(FEnvironments)-1].Incidence:= FIncidence;
  end;
end;

function Tz3DScenarioObject.GetEnvironments: Tz3DScenarioEnvironments;
begin
  Result:= FEnvironments;
end;

function Tz3DScenarioObject.InEnvironment(const AEnvironment: Iz3DScenarioEnvironment): Boolean;
var I: Integer;
begin
  Result:= False;
  for I:= 0 to Length(FEnvironments)-1 do
  if FEnvironments[I].Environment = AEnvironment then
  begin
    Result:= True;
    Exit;
  end;
end;

procedure Tz3DScenarioObject.Render(const AMaterials: Boolean = True; const ALighting: Boolean = True;
  const AShader: Iz3DShader = nil); stdcall;
begin
  //
end;

function Tz3DScenarioObject.GetAutoLOD: Boolean;
begin
  Result:= FAutoLOD;
end;

function Tz3DScenarioObject.GetLOD: Tz3DScenarioObjectLOD;
begin
  Result:= FLOD;
end;

procedure Tz3DScenarioObject.SetAutoLOD(const Value: Boolean);
begin
  FAutoLOD:= Value;
end;

procedure Tz3DScenarioObject.SetLOD(const Value: Tz3DScenarioObjectLOD);
begin
  FLOD:= Value;
end;

{ Tz3DScenarioDynamicObject }

constructor Tz3DScenarioDynamicObject.Create(const AOwner: Iz3DBase);
begin
  inherited;
  FAcceleration:= z3DFloat3;
  FVelocity:= z3DFloat3;
  FGround:= False;
  FEnablePhysics:= True;
end;

procedure Tz3DScenarioDynamicObject.FrameMove;
begin
  inherited;
  if Ground then Acceleration.Y:= Max(Acceleration.Y, 0);
  Velocity.Add(z3DFloat3.From(Acceleration).Scale(z3DCore_GetElapsedTime));
  BoundingBox.Center.Add(z3DFloat3.From(Velocity).Scale(z3DCore_GetElapsedTime));
  BoundingSphere.Center.From(BoundingBox.Center);
end;

function Tz3DScenarioDynamicObject.GetAcceleration: Iz3DFloat3;
begin
  Result:= FAcceleration;
end;

function Tz3DScenarioDynamicObject.GetEnablePhysics: Boolean;
begin
  Result:= FEnablePhysics;
end;

function Tz3DScenarioDynamicObject.GetGround: Boolean;
begin
  Result:= FGround;
end;

function Tz3DScenarioDynamicObject.GetVelocity: Iz3DFloat3;
begin
  Result:= FVelocity;
end;

procedure Tz3DScenarioDynamicObject.SetEnablePhysics(const Value: Boolean);
begin
  FEnablePhysics:= Value;
end;

procedure Tz3DScenarioDynamicObject.SetGround(const Value: Boolean);
begin
  FGround:= Value;
end;

{ Tz3DScenarioEntity }

procedure Tz3DScenarioEntity.Cleanup;
begin
  inherited;
  z3DScenario.RemoveEntity(Self);
end;

function Tz3DScenarioEntity.GetIndex: Integer;
begin
  Result:= z3DScenario.IndexOf(Self);
end;

procedure Tz3DScenarioEntity.Init(const AOwner: Iz3DBase);
begin
  inherited;
  z3DScenario.AddEntity(Self);
end;

{ Tz3DScenarioLinkedEntity }

procedure Tz3DScenarioLinkedEntity.Cleanup;
begin
  inherited;
  z3DScenario.RemoveEntity(Self);
end;

function Tz3DScenarioLinkedEntity.GetIndex: Integer;
begin
  Result:= z3DScenario.IndexOf(Self);
end;

procedure Tz3DScenarioLinkedEntity.Init(const AOwner: Iz3DBase);
begin
  inherited;
  z3DScenario.AddEntity(Self);
end;

end.
