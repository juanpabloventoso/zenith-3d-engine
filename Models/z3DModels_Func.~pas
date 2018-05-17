{==============================================================================}
{== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==}
{==============================================================================}
{== Unit: z3DModels. Model interface support and instance management         ==}
{==============================================================================}

unit z3DModels_Func;

interface

uses
  z3DModels_Intf;

const
  z3DModelsDLL = 'z3DModels.dll';

// Controller management
function z3DCreateModelController: Iz3DModelController; stdcall; external z3DModelsDLL;
procedure z3DSetCustomModelController(const AController: Iz3DModelController); stdcall; external z3DModelsDLL;
function z3DModelController: Iz3DModelController; stdcall; external z3DModelsDLL;

implementation

end.
