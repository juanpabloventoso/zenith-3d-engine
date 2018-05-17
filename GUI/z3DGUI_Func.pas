unit z3DGUI_Func;

interface

uses z3DGUI_Intf, D3DX9;

const
  z3DGUIDLL = 'z3DGUI.dll';

//function GetAPIFormat(const AFormats: Tz3DFontFormats): Cardinal; stdcall; external z3DGUIDLL;

function z3DCreateDesktop: Iz3DDesktop; stdcall; external z3DGUIDLL;
function z3DDesktop: Iz3DDesktop; stdcall; external z3DGUIDLL;
procedure z3DSetCustomDesktop(const ADesktop: Iz3DDesktop); stdcall; external z3DGUIDLL;

function z3DCreateTextHelper(const AFont: ID3DXFont; const ASprite: ID3DXSprite;
  const ALineHeight: Integer): Iz3DTextHelper; stdcall; external z3DGUIDLL;

implementation

end.
