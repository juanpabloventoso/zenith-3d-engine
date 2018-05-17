{==============================================================================}
{== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==}
{==============================================================================}
{== Unit: z3DEngine. z3D Engine interfaces and access functions              ==}
{==============================================================================}

unit z3DEngine_Func;

interface

uses z3DEngine_Intf;

const
  z3DEngineDLL = 'z3DEngine.dll';

function z3DCreateEngine: Iz3DEngine; stdcall; external z3DEngineDLL;
function z3DEngine: Iz3DEngine; stdcall; external z3DEngineDLL;

implementation

end.

