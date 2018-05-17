unit z3DComponents_Func;

interface

uses z3DComponents_Intf;

const
  z3DComponentsDLL = 'z3DComponents.dll';

function z3DCreateShader: Iz3DShader; stdcall; external z3DComponentsDLL;

function z3DCreateTexture: Iz3DTexture; stdcall; external z3DComponentsDLL;
function z3DCreateRenderTexture: Iz3DRenderTexture; stdcall; external z3DComponentsDLL;
function z3DCreateCubeTexture: Iz3DCubeTexture; stdcall; external z3DComponentsDLL;
function z3DCreateCubeRenderTexture: Iz3DCubeRenderTexture; stdcall; external z3DComponentsDLL;

function z3DCreateSurface: Iz3DSurface; stdcall; external z3DComponentsDLL;
function z3DCreateDepthBuffer: Iz3DDepthBuffer; stdcall; external z3DComponentsDLL;

function z3DCreateVertexFormat: Iz3DVertexFormat; stdcall; external z3DComponentsDLL;
function z3DCreateVertexBuffer: Iz3DVertexBuffer; stdcall; external z3DComponentsDLL;

implementation

end.
