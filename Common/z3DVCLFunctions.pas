unit z3DVCLFunctions;

interface

uses Windows, Graphics, z3DMath_Intf, z3DMath_Func;

function z3DVCLColorToVec3(const AColor: TColor): Iz3DFloat3;
function z3DVCLColorToVec4(const AColor: TColor): Iz3DFloat4;

function z3DVCLVec3ToColor(const AColor: Iz3DFloat3): TColor;
function z3DVCLVec4ToColor(const AColor: Iz3DFloat4): TColor;

implementation

function z3DVCLColorToVec3(const AColor: TColor): Iz3DFloat3;
begin
  Result:= z3DFloat3(GetRValue(ColorToRGB(AColor)) / 255, GetGValue(ColorToRGB(AColor)) / 255,
  GetBValue(ColorToRGB(AColor)) / 255);
end;

function z3DVCLColorToVec4(const AColor: TColor): Iz3DFloat4;
begin
  Result:= z3DFloat4(GetRValue(ColorToRGB(AColor)) / 255, GetGValue(ColorToRGB(AColor)) / 255,
  GetBValue(ColorToRGB(AColor)) / 255, 1);
end;

function z3DVCLVec3ToColor(const AColor: Iz3DFloat3): TColor;
begin
  Result:= RGB(Round(AColor.x * 255), Round(AColor.y * 255), Round(AColor.z * 255));
end;

function z3DVCLVec4ToColor(const AColor: Iz3DFloat4): TColor;
begin
  Result:= RGB(Round(AColor.x * 255), Round(AColor.y * 255), Round(AColor.z * 255));
end;

end.
