unit z3DPhysics_Impl;

interface

uses Windows, Classes, z3DClasses_Impl, z3DCore_Intf, D3DX9, z3DPhysics_Intf,
  z3DAudio_Intf, z3DScenario_Intf, z3DMath_Intf, z3DClasses_Intf, DirectSound;


type

  Tz3DPhysicsEngine = class(Tz3DLinked, Iz3DPhysicsEngine)
  private
    FEnabled: Boolean;
    FFPS: Integer;
    FFPSInv: Single;
  protected
    function GetFPS: Integer; stdcall;
    procedure SetFPS(const Value: Integer); stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
    procedure z3DFrameMove; override; stdcall;

    procedure SyncronizeScenarioPhysics; stdcall;
    procedure PerformWorldsPhysics(const AObject: Iz3DScenarioDynamicObject); stdcall;
    function PerformCollisionPhysics(const AObject: Iz3DScenarioDynamicObject): Boolean; stdcall;
    procedure ApplyPhysics(const AObject: Iz3DScenarioDynamicObject); stdcall;

    function CheckCollision(const AObjectA: Iz3DScenarioDynamicObject;
      const AObjectB: Iz3DScenarioObject): Boolean; stdcall;
    function BoundIntersectionTest(const AObjectA: Iz3DScenarioDynamicObject;
      const AObjectB: Iz3DScenarioObject): Boolean; stdcall;

    function BSvsBSCollisionTest(const AObjectA: Iz3DScenarioDynamicObject;
      const AObjectB: Iz3DScenarioObject): Boolean; stdcall;
    function AABBvsAABBCollisionTest(const AObjectA: Iz3DScenarioDynamicObject;
      const AObjectB: Iz3DScenarioObject): Boolean; stdcall;

    function TriangleCollisionTest(const AObjectA: Iz3DScenarioDynamicObject;
      const AObjectB: Iz3DScenarioObject): Boolean; stdcall;
    function TriangleIntersects(const A1, A2, A3, B1, B2, B3: Iz3DFloat3): Boolean; stdcall;

    function BSvsBSCollisionResponse(const AObjectA: Iz3DScenarioDynamicObject;
      const AObjectB: Iz3DScenarioObject): Boolean; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property FPS: Integer read GetFPS write SetFPS;
  end;


const SOUND_COUNT = 14;

var GFrameTime: Single;
    GCollisionSounds: array[0..SOUND_COUNT-1] of Iz3DSound;
    GLastPlayTime: Double;

const
  MIN_VELOCITY_Y = 0.05;
  POSITION_BIAS = 0.0001;


function z3DCreatePhysicsEngine: Iz3DPhysicsEngine; stdcall;
function z3DPhysicsEngine: Iz3DPhysicsEngine; stdcall;
procedure z3DSetCustomPhysicsEngine(const AEngine: Iz3DPhysicsEngine); stdcall;

implementation

uses Math, z3DMath_Func, z3DCore_Func, z3DScenario_Func, z3DEngine_Func,
  z3DModels_Intf, SysUtils, z3DScenarioObjects_Intf, Direct3D9, z3DScenarioObjects_Func;

var GEngine: Iz3DPhysicsEngine;

function z3DCreatePhysicsEngine: Iz3DPhysicsEngine; stdcall;
begin
  z3DTrace('z3DCreatePhysicsEngine: Creating physics engine object...', z3DtkInformation);
  GEngine:= Tz3DPhysicsEngine.Create;
  Result:= GEngine;
end;

function z3DPhysicsEngine: Iz3DPhysicsEngine; stdcall;
begin
  Result:= GEngine;
end;

procedure z3DSetCustomPhysicsEngine(const AEngine: Iz3DPhysicsEngine); stdcall;
begin
  GEngine:= AEngine;
end;







function z3DBBCollisionTest(const APos1, APos2, AOffset1, AOffset2, AVel1: Single;
  const ANormalPlane1, ANormalPlane2: Iz3DPlane; const AUpper: Boolean;
  out ALength: Single): Boolean;
const FSign: array[Boolean] of Integer = (-1, 1);
var  I, FRan: Integer;
begin

  // TODO JP: mover
  if GCollisionSounds[0] = nil then
  begin
    for I:= 0 to SOUND_COUNT-1 do
    begin
      FRan:= Random(3);
      case FRan of
        0: GCollisionSounds[I]:= z3DEngine.AudioController.Create3DSound('C:\JP\Direct3D\SOUNDS\Plastic1.wav');
        1: GCollisionSounds[I]:= z3DEngine.AudioController.Create3DSound('C:\JP\Direct3D\SOUNDS\Plastic2.wav');
        2: GCollisionSounds[I]:= z3DEngine.AudioController.Create3DSound('C:\JP\Direct3D\SOUNDS\Plastic3.wav');
      end;
      GCollisionSounds[I].Volume:= -20;
    end;
  end;




  // Measure the distance between the bodies
  ALength:= APos2 + AOffset2 * FSign[AUpper] - APos1;

  // The collision happens if the distance is less than the segment of the object 1
  // and it's normal plane intersects with the normal plane of the object 2
  Result:= ((Sign(ALength) = AVel1) or (Sign(AVel1) = 0)) and (Abs(ALength) <= AOffset1) and
    ANormalPlane1.Intersects(ANormalPlane2);
end;

procedure z3DBBCollisionResponse(const iObject1, iObject2: Iz3DScenarioObject; const APos1, APos2, AOffset1, AOffset2,
  AVel1P, AVel2P: Single; const AVel1N: Iz3DFloat2; const AUpper: Boolean;
  const ALength: Single; out APos, AVelocity1P, AVelocity2P: Single; const AVelocityN: Iz3DFloat2);
const FSign: array[Boolean] of Integer = (-1, 1);
begin
  // Return the object into the collision position
  APos:= APos2 + AOffset2 * FSign[AUpper] - (AOffset1 + POSITION_BIAS) * Sign(ALength);

  // Apply the force to both objects
  AVelocity1P:= -AVel1P * iObject1.Subsets[0].Material.Elasticity;
  AVelocity2P:= (AVel1P + AVel2P) * iObject2.Subsets[0].Material.Elasticity;

  // Apply the friction
  AVelocityN.X:= AVel1N.X - (AVel1N.X * iObject1.Subsets[0].Material.Roughness * GFrameTime);
  AVelocityN.Y:= AVel1N.Y - (AVel1N.Y * iObject1.Subsets[0].Material.Roughness * GFrameTime);
end;

{ Tz3DPhysicsEngine }

constructor Tz3DPhysicsEngine.Create(const AOwner: Iz3DBase);
begin
  inherited;
  Notifications:= [z3dlnFrameMove];
end;

function Tz3DPhysicsEngine.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

procedure Tz3DPhysicsEngine.Init(const AOwner: Iz3DBase);
begin
  inherited;
  SetFPS(30);
  FEnabled:= True;
end;

procedure Tz3DPhysicsEngine.SetEnabled(const Value: Boolean);
begin
  FEnabled:= Value;
end;

procedure Tz3DPhysicsEngine.z3DFrameMove;
begin
  inherited;
  if FEnabled and z3DScenario.Enabled then
  SyncronizeScenarioPhysics;
end;

procedure Tz3DPhysicsEngine.SyncronizeScenarioPhysics;
var I: Integer;
    FTimeLeft: Single;
begin
  inherited;
  if not z3DScenario.Enabled or z3DEngine.Desktop.Visible then Exit;

  // Perform the physics calculations at a fixed rate
  GFrameTime:= GFrameTime + z3DCore_GetElapsedTime;
  if GFrameTime < FFPSInv then Exit;
  FTimeLeft:= GFrameTime;
  while FTimeLeft > 0 do
  begin
    GFrameTime:= min(FTimeLeft, FFPSInv);

    // Iterate through all dynamic objects and apply physics to them
    for I:= 0 to z3DScenario.DynamicObjectCount-1 do
    if z3DScenario.DynamicObjects[I].EnablePhysics then
    ApplyPhysics(z3DScenario.DynamicObjects[I]);
    FTimeLeft:= FTimeLeft - GFrameTime;
  end;
  GFrameTime:= 0;







{    z3DEngine.AudioController.Get3DListener.SetPosition(z3DCameraController.ActiveCamera.Position.X,
    z3DCameraController.ActiveCamera.Position.Y, z3DCameraController.ActiveCamera.Position.Z, DS3D_DEFERRED);
    z3DEngine.AudioController.Get3DListener.SetOrientation(
    z3DCameraController.ActiveCamera.LookAt.X-z3DCameraController.ActiveCamera.Position.X,
    z3DCameraController.ActiveCamera.LookAt.Y-z3DCameraController.ActiveCamera.Position.Y,
    z3DCameraController.ActiveCamera.LookAt.Z-z3DCameraController.ActiveCamera.Position.Z,
    (z3DCameraController.ActiveCamera as Iz3DFirstPersonCamera).GetWorldUp.X,
    (z3DCameraController.ActiveCamera as Iz3DFirstPersonCamera).GetWorldUp.Y,
    (z3DCameraController.ActiveCamera as Iz3DFirstPersonCamera).GetWorldUp.Z, DS3D_DEFERRED);
    z3DEngine.AudioController.Get3DListener.SetVelocity(z3DScenario.ViewFrustum.Velocity,
    z3DScenario.ViewFrustum.Velocity, z3DScenario.ViewFrustum.Velocity, DS3D_DEFERRED);
    z3DEngine.AudioController.Get3DListener.CommitDeferredSettings;}




end;

function Tz3DPhysicsEngine.PerformCollisionPhysics(const AObject: Iz3DScenarioDynamicObject): Boolean;
const FEpsilon = 0.0001;
var I, FSound: Integer;
    FVelocity: Iz3DFloat3;
    FVelY: Single;
    FCollision, FGrounded, FPreviousGround: Boolean;
begin
  FPreviousGround:= AObject.Ground;
  FCollision:= False;
  FVelY:= Abs(AObject.Velocity.Y) / 5;

  // Compute collision with dynamic objects
  for I:= AObject.Index+1 to z3DScenario.DynamicObjectCount-1 do
  if {z3DScenario.DynamicObjects[I].InEnvironment(AObject.Environments[0].Environment) and}
  CheckCollision(AObject, z3DScenario.DynamicObjects[I]) then FCollision:= True;

  // Compute collision with other objects
  for I:= 0 to z3DScenario.StaticObjectCount-1 do
  if {z3DScenario.StaticObjects[I].InEnvironment(AObject.Environments[0].Environment) and}
  CheckCollision(AObject, z3DScenario.StaticObjects[I]) then FCollision:= True;


  if not FCollision then AObject.Ground:= False;
  Result:= FCollision;
  // Play collision sound
  if FCollision and not FPreviousGround and Assigned(GCollisionSounds[0]){ and
  (z3DCore_GetTime-GLastPlayTime > 0.05)} then
  begin
    FSound:= Random(SOUND_COUNT);
    GCollisionSounds[FSound].Get3DBuffer(0).SetPosition(AObject.BoundingBox.Center.X,
    AObject.BoundingBox.Center.Y, AObject.BoundingBox.Center.Z, DS3D_IMMEDIATE);
//    GCollisionSound.Reset;
    GCollisionSounds[FSound].Play3D;   // COMENTAR PARA QUE NO JODA EL AUDIO
//    Round(z3DFloat4.From(AObject.ViewCenter).Normalize.X * 1000));
//    GLastPlayTime:= z3DCore_GetTime;
  end;

end;

procedure Tz3DPhysicsEngine.PerformWorldsPhysics(const AObject: Iz3DScenarioDynamicObject);
begin
  if Length(AObject.Environments) = 0 then Exit;

  // Add the gravity acceleration
  if not AObject.Ground and (Abs(AObject.Acceleration.Y) <> Abs(AObject.Environments[0].Environment.Gravity)) then
  AObject.Acceleration.Y:= AObject.Environments[0].Environment.Gravity;

  // Add the wind force
  AObject.Acceleration.Add(z3DFloat3.From(AObject.Environments[0].Environment.WindSpeed).Scale(
  Saturate(AObject.Environments[0].Environment.WindSpeed.Length - AObject.BoundingBox.Dimensions.Length * 8) *
  (1 - AObject.Subsets[0].Material.Roughness)));
end;

procedure Tz3DPhysicsEngine.ApplyPhysics(const AObject: Iz3DScenarioDynamicObject);
begin

  // Perform all physics calculations
  PerformCollisionPhysics(AObject);
  PerformWorldsPhysics(AObject);

  // Restore the current acceleration
  if z3DSupports(AObject, Iz3DModelDynamicInstance) then
  (AObject as Iz3DModelDynamicInstance).ComputeTransforms;

end;

function Tz3DPhysicsEngine.BoundIntersectionTest(const AObjectA: Iz3DScenarioDynamicObject;
  const AObjectB: Iz3DScenarioObject): Boolean;
begin

  // Test the bounding volumes for intersection (no intersection, no collision)

  // BoundingSphere vs BoundingSphere test
  if (AObjectA.Shape = z3dsosSphere) and (AObjectB.Shape = z3dsosSphere) then
  Result:= AObjectA.BoundingSphere.Intersects(AObjectB.BoundingSphere) and
  BSvsBSCollisionTest(AObjectA, AObjectB) else

  // BoundingBox vs BoundingBox test
  if (AObjectA.Shape = z3dsosCube) and (AObjectB.Shape = z3dsosCube) then
  Result:= AObjectA.BoundingBox.Intersects(AObjectB.BoundingBox) and
  AABBvsAABBCollisionTest(AObjectA, AObjectB) else

  // BoundingSphere vs BoundingBox or viceversa test
  begin
    if (AObjectA.Shape = z3dsosSphere) then
    Result:= AObjectA.BoundingSphere.Intersects(AObjectB.BoundingBox) else
    Result:= AObjectA.BoundingBox.Intersects(AObjectB.BoundingSphere);
    Result:= Result and AABBvsAABBCollisionTest(AObjectA, AObjectB);
  end;
end;

function Tz3DPhysicsEngine.CheckCollision(const AObjectA: Iz3DScenarioDynamicObject;
  const AObjectB: Iz3DScenarioObject): Boolean;
begin

  // Test the bounding volumes. If an intersection is detected a collision
  // may exist
  Result:= BoundIntersectionTest(AObjectA, AObjectB) and
  TriangleCollisionTest(AObjectA, AObjectB);

  // If the object collided, apply the response
//  if Result then ApplyCollisionResponse(AObjectA, AObjectB);
end;

function Tz3DPhysicsEngine.AABBvsAABBCollisionTest(const AObjectA: Iz3DScenarioDynamicObject;
  const AObjectB: Iz3DScenarioObject): Boolean;
var FLength: Single;
    FDynObject2: Iz3DScenarioDynamicObject;
    FOffset1, FOffset2: Iz3DFloat3;
    FCenter1: Iz3DFloat3;
    FVelocity1, FVelocity2: Iz3DFloat3;
    FVel1P, FVel2P, FPos: Single;
    FVelN: Iz3DFloat2;
    I: Integer;
begin
  Result:= False;

  FVelocity1:= z3DFloat3.From(AObjectA.Velocity);
  FVelocity2:= z3DFloat3;
  AObjectB.QueryInterface(Iz3DScenarioDynamicObject, FDynObject2);
  if FDynObject2 <> nil then FVelocity2.From(FDynObject2.Velocity);
  FOffset1:= z3DFloat3.From(AObjectA.BoundingBox.Dimensions).Scale(0.5);
  FOffset2:= z3DFloat3.From(AObjectB.BoundingBox.Dimensions).Scale(0.5);
  FCenter1:= z3DFloat3.From(AObjectA.BoundingBox.Center);
  FVelN:= z3DFloat2;

  // 0: Lower collision | 1: Upper collision
  for I:= 0 to 1 do
  begin

    // X-axis collision
    if z3DBBCollisionTest(AObjectA.BoundingBox.Center.X, AObjectB.BoundingBox.Center.X, FOffset1.X, FOffset2.X,
    Sign(FVelocity1.X),
    z3DPlane(AObjectA.BoundingBox.Center.Y-FOffset1.Y, AObjectA.BoundingBox.Center.Z-FOffset1.Z,
    AObjectA.BoundingBox.Center.Y+FOffset1.Y, AObjectA.BoundingBox.Center.Z+FOffset1.Z),
    z3DPlane(AObjectB.BoundingBox.Center.Y-FOffset2.Y, AObjectB.BoundingBox.Center.Z-FOffset2.Z,
    AObjectB.BoundingBox.Center.Y+FOffset2.Y, AObjectB.BoundingBox.Center.Z+FOffset2.Z), I = 1, FLength) then
    begin
      Result:= True;


  AObjectA.Acceleration.Identity;
  if FDynObject2 <> nil then FDynObject2.Acceleration.Identity;


      z3DBBCollisionResponse(AObjectA, AObjectB, AObjectA.BoundingBox.Center.X, AObjectB.BoundingBox.Center.X, FOffset1.X,
      FOffset2.X, FVelocity1.X, FVelocity2.X, z3DFloat2(FVelocity1.Y, FVelocity1.Z),
      I = 1, FLength, FPos, FVel1P, FVel2P, FVelN);
      FCenter1.X:= FPos;
      FVelocity1.X:= FVel1P;
      FVelocity2.X:= FVel2P;
      FVelocity1.YZ:= FVelN.XY;
      AObjectA.BoundingBox.Center.From(FCenter1);
      AObjectA.Velocity.From(FVelocity1);
      if FDynObject2 <> nil then FDynObject2.Velocity.From(FVelocity2);
    end;

    // Y-axis collision
    if z3DBBCollisionTest(AObjectA.BoundingBox.Center.Y, AObjectB.BoundingBox.Center.Y, FOffset1.Y, FOffset2.Y,
    Sign(FVelocity1.Y),
    z3DPlane(AObjectA.BoundingBox.Center.X-FOffset1.X, AObjectA.BoundingBox.Center.Z-FOffset1.Z,
    AObjectA.BoundingBox.Center.X+FOffset1.X, AObjectA.BoundingBox.Center.Z+FOffset1.Z),
    z3DPlane(AObjectB.BoundingBox.Center.X-FOffset2.X, AObjectB.BoundingBox.Center.Z-FOffset2.Z,
    AObjectB.BoundingBox.Center.X+FOffset2.X, AObjectB.BoundingBox.Center.Z+FOffset2.Z), I = 1, FLength) then
    begin
      Result:= True;


  AObjectA.Acceleration.Identity;
  if FDynObject2 <> nil then FDynObject2.Acceleration.Identity;


      z3DBBCollisionResponse(AObjectA, AObjectB, AObjectA.BoundingBox.Center.Y, AObjectB.BoundingBox.Center.Y, FOffset1.Y,
      FOffset2.Y, FVelocity1.Y, FVelocity2.Y, z3DFloat2(FVelocity1.X, FVelocity1.Z),
      I = 1, FLength, FPos, FVel1P, FVel2P, FVelN);
      FCenter1.Y:= FPos;
      FVelocity1.Y:= FVel1P;
      FVelocity1.XZ:= FVelN.XY;
      AObjectA.Ground:= True;
      AObjectA.BoundingBox.Center.From(FCenter1);
      AObjectA.Velocity.From(FVelocity1);
      if AObjectA.Ground and (AObjectA.Velocity.Y < MIN_VELOCITY_Y) then
      begin
        AObjectA.Velocity.BeginInternalChange;
        AObjectA.Velocity.Y:= 0;
        AObjectA.Velocity.EndInternalChange;
        AObjectA.Ground:= True;
      end else AObjectA.Ground:= False;
      if FDynObject2 <> nil then FDynObject2.Velocity.From(FVelocity2);
      if (FDynObject2 <> nil) and (Abs(FDynObject2.Velocity.Y) < MIN_VELOCITY_Y) then FDynObject2.Ground:= True;
    end;

    // Z-axis collision
    if z3DBBCollisionTest(AObjectA.BoundingBox.Center.Z, AObjectB.BoundingBox.Center.Z, FOffset1.Z, FOffset2.Z,
    Sign(FVelocity1.Z),
    z3DPlane(AObjectA.BoundingBox.Center.X-FOffset1.X, AObjectA.BoundingBox.Center.Y-FOffset1.Y,
    AObjectA.BoundingBox.Center.X+FOffset1.X, AObjectA.BoundingBox.Center.Y+FOffset1.Y),
    z3DPlane(AObjectB.BoundingBox.Center.X-FOffset2.X, AObjectB.BoundingBox.Center.Y-FOffset2.Y,
    AObjectB.BoundingBox.Center.X+FOffset2.X, AObjectB.BoundingBox.Center.Y+FOffset2.Y), I = 1, FLength) then
    begin
      Result:= True;


  AObjectA.Acceleration.Identity;
  if FDynObject2 <> nil then FDynObject2.Acceleration.Identity;


      z3DBBCollisionResponse(AObjectA, AObjectB, AObjectA.BoundingBox.Center.Z, AObjectB.BoundingBox.Center.Z, FOffset1.Z,
      FOffset2.Z, FVelocity1.Z, FVelocity2.Z, z3DFloat2(FVelocity1.X, FVelocity1.Y),
      I = 1, FLength, FPos, FVel1P, FVel2P, FVelN);
      FCenter1.Z:= FPos;
      FVelocity1.Z:= FVel1P;
      FVelocity2.Z:= FVel2P;
      FVelocity1.XY:= FVelN.XY;
      AObjectA.BoundingBox.Center.From(FCenter1);
      AObjectA.Velocity.From(FVelocity1);
      if FDynObject2 <> nil then FDynObject2.Velocity.From(FVelocity2);
    end;
  end;
end;

function Tz3DPhysicsEngine.BSvsBSCollisionTest(const AObjectA: Iz3DScenarioDynamicObject;
  const AObjectB: Iz3DScenarioObject): Boolean;
begin

  // No additional testing needed
  Result:= True;

  if Result then BSvsBSCollisionResponse(AObjectA, AObjectB);
end;


function Tz3DPhysicsEngine.TriangleCollisionTest(const AObjectA: Iz3DScenarioDynamicObject;
  const AObjectB: Iz3DScenarioObject): Boolean;
var FVBA, FVBB: Pz3DDynamicModelVertexArray;
    FSVBB: Pz3DStaticModelVertexArray;
    FIBA, FIBB: PWordArray;
    FModelA, FModelB: Iz3DModel;
    FDynamicB: Boolean;
    I, J: Integer;
    FTriA1, FTriA2, FTriA3: Iz3DFloat3;
    FTriB1, FTriB2, FTriB3: Iz3DFloat3;
begin

  // Objects must be models to achieve this test
{  if not z3DSupports(AObjectA, Iz3DModelDynamicInstance) or not
  z3DSupports(AObjectB, Iz3DModelInstance) then}
  begin
    Result:= True;
    Exit;
  end;

  Result:= False;

  // Get the models vertices (low quality version)
  FModelA:= (AObjectA as Iz3DModelInstance).Model;
  FModelB:= (AObjectB as Iz3DModelInstance).Model;
  FDynamicB:= z3DSupports(AObjectB, Iz3DModelDynamicInstance);
  FVBA:= FModelA.LockLODVertices(z3dsolLow, D3DLOCK_READONLY or D3DLOCK_DONOTWAIT);
  FIBA:= FModelA.LockLODIndices(z3dsolLow, D3DLOCK_READONLY or D3DLOCK_DONOTWAIT);
  if FDynamicB then FVBB:= FModelB.LockLODVertices(z3dsolLow) else
  FSVBB:= FModelB.LockLODVertices(z3dsolLow, D3DLOCK_READONLY or D3DLOCK_DONOTWAIT);
  FIBB:= FModelB.LockLODIndices(z3dsolLow, D3DLOCK_READONLY or D3DLOCK_DONOTWAIT);

  FTriA1:= z3DFloat3;
  FTriA2:= z3DFloat3;
  FTriA3:= z3DFloat3;

  FTriB1:= z3DFloat3;
  FTriB2:= z3DFloat3;
  FTriB3:= z3DFloat3;

  try
    for I:= 0 to FModelA.LODFaceCount[z3dsolLow]-1 do
    begin
      FTriA1.From(FVBA[FIBA[I*3]].Position);
      FTriA2.From(FVBA[FIBA[I*3+1]].Position);
      FTriA3.From(FVBA[FIBA[I*3+2]].Position);
      for J:= 0 to FModelB.LODFaceCount[z3dsolLow]-1 do
      begin
        if FDynamicB then
        begin
          FTriB1.From(FVBB[FIBB[J*3]].Position);
          FTriB2.From(FVBB[FIBB[J*3+1]].Position);
          FTriB3.From(FVBB[FIBB[J*3+2]].Position);
        end else
        begin
          FTriB1.From(FSVBB[FIBB[J*3]].Position);
          FTriB2.From(FSVBB[FIBB[J*3+1]].Position);
          FTriB3.From(FSVBB[FIBB[J*3+2]].Position);
        end;
        if TriangleIntersects(FTriA1, FTriA2, FTriA3, FTriB1, FTriB2, FTriB3) then Result:= True;
        if Result then Break;
      end;
      if Result then Break;
    end;
  finally
    FModelA.UnlockLODVertices;
    FModelA.UnlockLODIndices;
    FModelB.UnlockLODVertices;
    FModelB.UnlockLODIndices;
  end;
end;

function Tz3DPhysicsEngine.BSvsBSCollisionResponse(const AObjectA: Iz3DScenarioDynamicObject;
  const AObjectB: Iz3DScenarioObject): Boolean;
var FVelocity1N, FVelocity1T, FVelocity2N, FVelocity2T: Iz3DFloat3;
    FDynObject2: Iz3DScenarioDynamicObject;
    FVelocity1, FVelocity2: Iz3DFloat3;
    ADistance: Iz3DFloat3;
begin
  AObjectB.QueryInterface(Iz3DScenarioDynamicObject, FDynObject2);
  FVelocity1:= AObjectA.Velocity;


  AObjectA.Acceleration.Identity;
  if FDynObject2 <> nil then FDynObject2.Acceleration.Identity;

  
  if FDynObject2 <> nil then FVelocity2:= FDynObject2.Velocity else FVelocity2:= z3DFloat3;
  ADistance:= z3DFloat3.From(AObjectB.BoundingBox.Center).Subtract(AObjectA.BoundingBox.Center);

  // Measure the velocity
  FVelocity1N:= z3DFloat3.From(ADistance).Scale(AObjectA.Subsets[0].Material.Elasticity * ADistance.Dot(FVelocity1));
  FVelocity1T:= z3DFloat3.From(FVelocity1).Scale(AObjectA.Subsets[0].Material.Elasticity).Subtract(FVelocity1N);
  if FDynObject2 <> nil then
  begin
    FVelocity2N:= z3DFloat3.From(ADistance).Scale(AObjectB.Subsets[0].Material.Elasticity * ADistance.Dot(FVelocity2));
    FVelocity2T:= z3DFloat3.From(FVelocity2).Scale(AObjectB.Subsets[0].Material.Elasticity).Subtract(FVelocity2N);
  end else
  begin
    FVelocity2N:= z3DFloat3;
    FVelocity2T:= z3DFloat3;
  end;

  // Apply the final velocity and restore the center
  AObjectA.Velocity.From(FVelocity1T.Subtract(FVelocity1N.Scale(AObjectA.Subsets[0].Material.Elasticity)).Add(FVelocity2N.Scale(AObjectB.Subsets[0].Material.Elasticity)));
  if FDynObject2 <> nil then FDynObject2.Velocity.From(FVelocity2T.Subtract(FVelocity2N.Scale(AObjectB.Subsets[0].Material.Elasticity)).Add(FVelocity1N.Scale(1 - AObjectA.Subsets[0].Material.Elasticity)));
  AObjectA.BoundingBox.Center.Subtract(ADistance.Scale((AObjectA.BoundingSphere.Radius + AObjectB.BoundingSphere.Radius - ADistance.Length + POSITION_BIAS) * 0.5));
  if FDynObject2 <> nil then AObjectB.BoundingBox.Center.Subtract(ADistance.Scale((AObjectB.BoundingSphere.Radius + AObjectA.BoundingSphere.Radius - ADistance.Length + POSITION_BIAS) * -0.5));
end;

function Tz3DPhysicsEngine.TriangleIntersects(const A1, A2, A3, B1, B2, B3: Iz3DFloat3): Boolean;
var FPlaneA, FPlaneB: Iz3DPlane;
begin
  Result:= False;
  FPlaneA:= z3DPlane(A1.x, A2.x, A3.x, A1.x+A2.x);
  FPlaneB:= z3DPlane(B1.x, B2.x, B3.x, B1.x+B2.x);
  Result:= FPlaneA.Intersects(FPlaneB);
  if Result then Exit;
  FPlaneA:= z3DPlane(A1.y, A2.y, A3.y, A1.y+A2.y);
  FPlaneB:= z3DPlane(B1.y, B2.y, B3.y, B1.y+B2.y);
  Result:= FPlaneA.Intersects(FPlaneB);
  if Result then Exit;
  FPlaneA:= z3DPlane(A1.z, A2.z, A3.z, A1.z+A2.z);
  FPlaneB:= z3DPlane(B1.z, B2.z, B3.z, B1.z+B2.z);
  Result:= FPlaneA.Intersects(FPlaneB);
end;

function Tz3DPhysicsEngine.GetFPS: Integer;
begin
  Result:= FFPS;
end;

procedure Tz3DPhysicsEngine.SetFPS(const Value: Integer);
begin
  if FFPS <> Value then
  begin
    FFPS:= Value;
    FFPSInv:= 1 / Value;
  end;
end;

end.
