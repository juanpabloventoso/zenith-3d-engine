unit z3DPhysics_Func;

interface

uses z3DPhysics_Intf;

const
  z3DPhysicsDLL = 'z3DPhysics.dll';

function z3DCreatePhysicsEngine: Iz3DPhysicsEngine; stdcall; external z3DPhysicsDLL;
function z3DPhysicsEngine: Iz3DPhysicsEngine; stdcall; external z3DPhysicsDLL;
procedure z3DSetCustomPhysicsEngine(const AEngine: Iz3DPhysicsEngine); stdcall; external z3DPhysicsDLL;

implementation

end.
