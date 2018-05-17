unit z3DScenarioObjects_Func;

interface

uses z3DMath_Intf, z3DScenarioObjects_Intf;

const
  z3DScenarioObjectsDLL = 'z3DScenarioObjects.dll';


function z3DBallPointsToQuat(const AFrom, ATo: Iz3DFloat3): Iz3DFloat4; stdcall; external z3DScenarioObjectsDLL;

function z3DCreateArcBall: Iz3DArcBall; stdcall; external z3DScenarioObjectsDLL;

// Camera controller management

function z3DCreateCameraController: Iz3DCameraController; stdcall; external z3DScenarioObjectsDLL;
procedure z3DSetCustomCameraController(const AController: Iz3DCameraController); stdcall; external z3DScenarioObjectsDLL;
function z3DCameraController: Iz3DCameraController; stdcall; external z3DScenarioObjectsDLL;

// Sky controller management

function z3DSkyController: Iz3DSkyController; stdcall; external z3DScenarioObjectsDLL;
function z3DCreateSkyController: Iz3DSkyController; stdcall; external z3DScenarioObjectsDLL;
procedure z3DSetCustomSkyController(const AController: Iz3DSkyController); stdcall; external z3DScenarioObjectsDLL;

// Rope controller management (TEMP JP: HAY QUE VER COMO HACERLO MULTIPLE)

function z3DRopeController: Iz3DRopeController; stdcall; external z3DScenarioObjectsDLL;
function z3DCreateRopeController: Iz3DRopeController; stdcall; external z3DScenarioObjectsDLL;
procedure z3DSetCustomRopeController(const AController: Iz3DRopeController); stdcall; external z3DScenarioObjectsDLL;

// Ambient sources
function z3DCreateAmbientSource: Iz3DAmbientSource; stdcall; external z3DScenarioObjectsDLL;

implementation

end.
