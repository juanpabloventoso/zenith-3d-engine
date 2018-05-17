library z3DMath;

uses
  z3DMath_Intf,
  z3DMath_Impl;


exports

  // Vector constructors

  z3DFloat2,
  z3DFloat3,
  z3DFloat4,
  z3DFloat4Coord,

  // Matrix constructors

  z3DMatrix,
  z3DMatrixIdentity,

  // Plane functions

  z3DPlane,

  // Algebraic functions

  z3DGetNormal,
  z3DPlaneRaySHLerp,

  // Math functions

  Clamp,
  Saturate,
  Lerp,

  // Bounding volume functions

  z3DBoundingBox,
  z3DBoundingSphere,

  // Time of day functions
  z3DTimeOfDay;

{$R *.res}

begin
end.
