{==============================================================================}
{== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==}
{==============================================================================}
{== Unit: z3DLighting. z3D lighting and shadowing system core                ==}
{==============================================================================}

unit z3DLighting_Func;

interface

uses z3DMath_Intf, z3DLighting_Intf;

const
  z3DLightingDLL = 'z3DLighting.dll';


// Triangle initalization

function z3DTriangle: Tz3DTriangle; stdcall; external z3DLightingDLL;

// Lighting calculations

function z3DLightingDiffuseDirectional(const ANormal, ALight: Iz3DFloat3): Single; stdcall; external z3DLightingDLL;
function z3DLightingDiffuse(const ANormal, ALight: Iz3DFloat3;
  const ADistance, ARange: Single): Single; stdcall; external z3DLightingDLL;
function z3DLightingSpot(const ALight, ADirection: Iz3DFloat3;
  const AAngle, ASharpness: Single): Single; stdcall; external z3DLightingDLL;

// Common lighting functions

function z3DRay(const AOrigin, ADirection: Iz3DFloat3;
  const ALength: Single = 1): Tz3DRay; stdcall; external z3DLightingDLL;

// Controller management

function z3DLightMapController: Iz3DLightMapController; stdcall; external z3DLightingDLL;
function z3DCreateLightMapController: Iz3DLightMapController; stdcall; external z3DLightingDLL;
procedure z3DSetCustomLightMapController(const AController: Iz3DLightMapController); stdcall; external z3DLightingDLL;

function z3DLightingController: Iz3DLightingController; stdcall; external z3DLightingDLL;
function z3DCreateLightingController: Iz3DLightingController; stdcall; external z3DLightingDLL;
procedure z3DSetCustomLightingController(const AController: Iz3DLightingController); stdcall; external z3DLightingDLL;

implementation

end.
