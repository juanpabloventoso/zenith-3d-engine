library z3DScenarioObjects;

uses
  z3DScenarioObjects_Intf,
  z3DScenarioObjects_Impl;

exports

  z3DBallPointsToQuat,

  z3DCreateArcBall,

  // Camera controller management

  z3DCreateCameraController,
  z3DSetCustomCameraController,
  z3DCameraController,

  // Sky controller management

  z3DSkyController,
  z3DCreateSkyController,
  z3DSetCustomSkyController,

  // Rope controller management

  z3DRopeController,
  z3DCreateRopeController,
  z3DSetCustomRopeController,

  // Ambient sources

  z3DCreateAmbientSource;

{$R *.res}

begin
end.
