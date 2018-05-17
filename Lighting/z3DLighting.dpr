library z3DLighting;

uses
  z3DLighting_Intf,
  z3DLighting_Impl;

exports

  // Triangle initialization
  z3DTriangle,

  // Lighting calculations
  z3DLightingDiffuseDirectional,
  z3DLightingDiffuse,
  z3DLightingSpot,

  // Common lighting functions
  z3DRay,

  // LightMap controller management
  z3DLightMapController,
  z3DCreateLightMapController,
  z3DSetCustomLightMapController,

  // Lighting controller management
  z3DLightingController,
  z3DCreateLightingController,
  z3DSetCustomLightingController;

{$R *.res}

begin
end.
