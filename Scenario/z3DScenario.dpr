library z3DScenario;

uses
  z3DScenario_Intf,
  z3DScenario_Impl;

exports

  z3DCreateScenario,
  z3DScenario_Impl.z3DScenario,
  z3DSetCustomScenario,

  z3DCreateMaterialController,
  z3DMaterialController,
  z3DSetCustomMaterialController,

  z3DCreateFrustum;

{$R *.res}

begin
end.
