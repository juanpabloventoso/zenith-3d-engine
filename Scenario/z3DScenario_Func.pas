unit z3DScenario_Func;

interface

uses z3DScenario_Intf;

const
  z3DScenarioDLL = 'z3DScenario.dll';

function z3DCreateScenario: Iz3DScenario; stdcall; external z3DScenarioDLL;
function z3DScenario: Iz3DScenario; stdcall; external z3DScenarioDLL;
procedure z3DSetCustomScenario(const AScenario: Iz3DScenario); stdcall; external z3DScenarioDLL;

function z3DCreateMaterialController: Iz3DMaterialController; stdcall; external z3DScenarioDLL;
function z3DMaterialController: Iz3DMaterialController; stdcall; external z3DScenarioDLL;
procedure z3DSetCustomMaterialController(const AController: Iz3DMaterialController); stdcall; external z3DScenarioDLL;

function z3DCreateFrustum: Iz3DFrustum; stdcall; external z3DScenarioDLL;

implementation

end.
