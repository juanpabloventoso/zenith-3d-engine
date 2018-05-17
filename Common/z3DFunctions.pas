unit z3DFunctions;

interface

uses Forms, Windows, Graphics, Direct3D9, SysUtils, Classes, z3DClasses_Intf,
  D3DX9, Dialogs, z3DMath_Intf, z3DComponents_Intf;


function z3DSupports(const AInterface: IInterface; const AGUID: TGUID): Boolean;

// Conversion of standard Delphi colors to D3DColor type
function z3DColor(const AColor: TColor; const AAlpha: Integer = 255): TD3DColor; stdcall;
// Conversion of standard Delphi colors to D3DColor type
function z3DD3DColor(const AColor: Iz3DFloat3): TD3DColor; overload; stdcall;
function z3DD3DColor(const AColor: Iz3DFloat4): TD3DColor; overload; stdcall;
function z3DD3DXColor(const AColor: Iz3DFloat3): TD3DXColor; overload; stdcall;
function z3DD3DXColor(const AColor: Iz3DFloat4): TD3DXColor; overload; stdcall;
// Conversion of standard Delphi colors to D3DVector4 type
function z3DColorToVec4(const AColor: TColor; const AAlpha: Integer = 255): TD3DXVector4; stdcall;
// Conversion of standard Delphi colors to D3DXColor type
function z3DColorValue(const AColor: TColor; const AAlpha: Integer = 255): TD3DXColor; stdcall;
// Conversion of Delphi font height to D3DX font height
function z3DFontHeight(const ASize: Integer): Integer; stdcall;
// Wait a specific time, in miliseconds.
procedure z3DWait(const ATime: DWORD); stdcall;
// Helper functions for blooming and gaussian effects
function z3DGaussianDistribution(X, Y, Rho: Single): Single; stdcall;
procedure z3DGetBloomSO(ATexSize: DWORD; var AOffset: array of Single; var AWeight: array of Single;
  ADeviation: Single; AMultiplier: Single = 1); stdcall;
procedure z3DGetDownScaleSO(AWidth, AHeight: DWORD; var AOffsets: array of TD3DXVector2); stdcall;
procedure z3DGetGaussBlurSO(ATexWidth, ATexHeight: DWORD; var AOffset: array of TD3DXVector2;
  var AWeight: array of Single; const AMultiplier: Single = 1); stdcall;
// Get a pixel color from a texture
function z3DGetPixel(const ATexture: IDirect3DBaseTexture9; const ALevel: Integer; const AX, AY: Integer): Single; stdcall;

{==============================================================================}
{=  Common texture methods                                                    =}
{==============================================================================}

// Clear the texture surface
procedure z3DClearTexture(ATexture: IDirect3DTexture9; const AColor: TColor = clBlack); overload; stdcall;
procedure z3DClearTexture(ATexture: IDirect3DCubeTexture9; const ACount: Integer = 6;
  const AColor: TColor = clBlack); overload; stdcall;
// Get the dimensions of the texture
function z3DGetTextureRect(const ATexture: IDirect3DTexture9): TRect; stdcall;
// Perform a 5x5 gauss blur
procedure z3DRenderGaussBlur(const AInTex: Iz3DTexture; const AOutTex: Iz3DRenderTexture; const AScale: Single = 1); stdcall;
procedure z3DRenderGaussBlurSSAO(const AInTex: Iz3DTexture; const AOutTex: Iz3DRenderTexture; const AScale: Single = 1); stdcall;


implementation

uses z3DCore_Func, z3DEngine_Func;

var GPreviousBlurWidth, GPreviousBlurHeight: Integer;
    GBlurSampleOffsets: array[0..15] of TD3DXVector2;
    GBlurSampleWeights: array[0..15] of Single;

function z3DSupports(const AInterface: IInterface; const AGUID: TGUID): Boolean;
var FInt: IInterface;
begin
  AInterface.QueryInterface(AGUID, FInt);
  Result:= FInt <> nil;
end;

function z3DColor(const AColor: TColor; const AAlpha: Integer = 255): TD3DColor;
var FColor: LongInt;
begin
  // Convert Delphi color to RGB color
  FColor:= ColorToRGB(AColor);
  Result:= D3DCOLOR_ARGB(AAlpha, GetRValue(FColor), GetGValue(FColor), GetBValue(FColor));
end;

function z3DD3DColor(const AColor: Iz3DFloat3): TD3DColor;
begin
  Result:= D3DCOLOR_ARGB(255, Round(AColor.R*255), Round(AColor.G*255), Round(AColor.B*255));
end;

function z3DD3DColor(const AColor: Iz3DFloat4): TD3DColor;
begin
  Result:= D3DCOLOR_ARGB(Round(AColor.A*255), Round(AColor.R*255), Round(AColor.G*255), Round(AColor.B*255));
end;

function z3DD3DXColor(const AColor: Iz3DFloat3): TD3DXColor; overload;
begin
  Result.r:= AColor.R;
  Result.g:= AColor.G;
  Result.b:= AColor.B;
  Result.a:= 255;
end;

function z3DD3DXColor(const AColor: Iz3DFloat4): TD3DXColor; overload;
begin
  Result.r:= AColor.R;
  Result.g:= AColor.G;
  Result.b:= AColor.B;
  Result.a:= AColor.A;
end;

function z3DColorValue(const AColor: TColor; const AAlpha: Integer = 255): TD3DXColor;
var FColor: LongInt;
begin
  // Convert Delphi color to RGB color
  FColor:= ColorToRGB(AColor);
  // Convert values to 0..1 range
  with Result do
  begin
    r:= GetRValue(FColor)/255;
    g:= GetGValue(FColor)/255;
    b:= GetBValue(FColor)/255;
    a:= AAlpha/255;
  end;
end;

function z3DFontHeight(const ASize: Integer): Integer;
begin
  Result:= Round(ASize * 1.65);
end;

function z3DColorToVec4(const AColor: TColor; const AAlpha: Integer = 255): TD3DXVector4;
var FColor: LongInt;
begin
  FColor:= ColorToRGB(AColor);
  Result:= D3DXVector4(GetRValue(FColor)/255,
  GetGValue(FColor)/255, GetBValue(FColor)/255, AAlpha/255);
end;

procedure z3DClearTexture(ATexture: IDirect3DTexture9; const AColor: TColor = clBlack);
var FSurface: IDirect3DSurface9;
begin
  ATexture.GetSurfaceLevel(0, FSurface);
  z3DCore_GetD3DDevice.ColorFill(FSurface, nil, z3DColor(AColor));
end;

procedure z3DClearTexture(ATexture: IDirect3DCubeTexture9; const ACount: Integer = 6; const AColor: TColor = clBlack);
var FSurface: IDirect3DSurface9;
    I: Integer;
begin
  for I:= 0 to ACount-1 do
  begin
    ATexture.GetCubeMapSurface(_D3DCUBEMAP_FACES(I), 0, FSurface);
    z3DCore_GetD3DDevice.ColorFill(FSurface, nil, z3DColor(AColor));
  end;
end;

function z3DGetTextureRect(const ATexture: IDirect3DTexture9): TRect;
var FDesc: TD3DSurfaceDesc;
begin
  ATexture.GetLevelDesc(0, FDesc);
  Result.Left:= 0;
  Result.Top:= 0;
  Result.Right:= FDesc.Width;
  Result.Bottom:= FDesc.Height;
end;

procedure z3DWait(const ATime: DWORD);
var FTime: DWORD;
begin
  FTime:= GetTickCount;
  while GetTickCount-FTime < ATime do Application.ProcessMessages;
end;

function z3DGaussianDistribution(X, Y, Rho: Single): Single;
var G: Single;
begin
  G:= 1 / Sqrt(2 * D3DX_PI * Rho * Rho);
  G:= G * Exp(-(X * X + Y * Y)/(2 * Rho * Rho));
  Result:= G;
end;

procedure z3DGetGaussBlurSO(ATexWidth, ATexHeight: DWORD; var AOffset: array of TD3DXVector2;
  var AWeight: array of Single; const AMultiplier: Single = 1);
var FU, FV: Single;
    FTotalWeight: Single;
    FIndex, X, Y, I: Integer;
begin
  FU:= 1 / ATexWidth;
  FV:= 1 / ATexHeight;
  FTotalWeight:= 0;
  FIndex:= 0;
  for X:= -2 to 2 do
  for Y:= -2 to 2 do
  begin
    if Abs(X) + Abs(Y) > 2 then Continue;
    AOffset[FIndex]:= D3DXVector2(X * FU * AMultiplier, Y * FV * AMultiplier);
    AWeight[FIndex]:= z3DGaussianDistribution(X, Y, 1);
    FTotalWeight:= FTotalWeight + AWeight[FIndex];
    Inc(FIndex);
  end;
  for I:= 0 to FIndex - 1 do
  AWeight[I]:= AWeight[I] * AMultiplier / FTotalWeight;
end;


procedure z3DGetDownScaleSO(AWidth, AHeight: DWORD; var AOffsets: array of TD3DXVector2);
var FU, FV: Single;
    FIndex, X, Y: Integer;
begin
  FU:= 1 / AWidth;
  FV:= 1 / AHeight;
  FIndex:= 0;
  for Y:= 0 to 3 do
  for X:= 0 to 3 do
  begin
    AOffsets[FIndex].X:= (X - 1.5) * FU;
    AOffsets[FIndex].Y:= (Y - 1.5) * FV;
    Inc(FIndex);
  end;
end;

procedure z3DGetBloomSO(ATexSize: DWORD; var AOffset: array of Single; var AWeight: array of Single;
  ADeviation: Single; AMultiplier: Single = 1);
var I: Integer;
    FU, FWeight: Single;
begin
  FU:= 1 / ATexSize;
  FWeight:= AMultiplier * z3DGaussianDistribution(0, 0, ADeviation);
  AWeight[0]:= FWeight;
  AOffset[0]:= 0;
  for I:= 1 to 7 do
  begin
    FWeight:= AMultiplier * z3DGaussianDistribution(I, 0, ADeviation);
    AOffset[I]:= I * FU;
    AWeight[I]:= FWeight;
  end;
  for I:= 8 to 14 do
  begin
    AWeight[I]:= AWeight[I-7];
    AOffset[I]:= -AOffset[I-7];
  end;
end;

procedure z3DRenderGaussBlur(const AInTex: Iz3DTexture; const AOutTex: Iz3DRenderTexture; const AScale: Single = 1);
var FDesc: TD3DSurfaceDesc;
begin
  AInTex.D3DTexture.GetLevelDesc(0, FDesc);
  if (GPreviousBlurWidth <> FDesc.Width) or (GPreviousBlurHeight <> FDesc.Height) then
  begin
    GPreviousBlurWidth:= FDesc.Width;
    GPreviousBlurHeight:= FDesc.Height;
    z3DGetGaussBlurSO(GPreviousBlurWidth, GPreviousBlurHeight, GBlurSampleOffsets, GBlurSampleWeights, AScale);
  end;
  z3DEngine.CoreShader.SetPointer('GBlurSampleOffsets', @GBlurSampleOffsets, SizeOf(GBlurSampleOffsets));
  z3DEngine.CoreShader.SetPointer('GBlurSampleWeights', @GBlurSampleWeights, SizeOf(GBlurSampleWeights));
  z3DEngine.CoreShader.Technique:= 'z3DCore_GaussBlur';
  z3DEngine.Renderer.PostProcess(AOutTex, [AInTex], z3DEngine.CoreShader);
end;

procedure z3DRenderGaussBlurSSAO(const AInTex: Iz3DTexture; const AOutTex: Iz3DRenderTexture; const AScale: Single = 1);
var FDesc: TD3DSurfaceDesc;
begin
  AInTex.D3DTexture.GetLevelDesc(0, FDesc);
  if (GPreviousBlurWidth <> FDesc.Width) or (GPreviousBlurHeight <> FDesc.Height) then
  begin
    GPreviousBlurWidth:= FDesc.Width;
    GPreviousBlurHeight:= FDesc.Height;
    z3DGetGaussBlurSO(GPreviousBlurWidth, GPreviousBlurHeight, GBlurSampleOffsets, GBlurSampleWeights, AScale);
  end;
  z3DEngine.CoreShader.SetPointer('GBlurSampleOffsets', @GBlurSampleOffsets, SizeOf(GBlurSampleOffsets));
  z3DEngine.CoreShader.SetPointer('GBlurSampleWeights', @GBlurSampleWeights, SizeOf(GBlurSampleWeights));
  z3DEngine.CoreShader.Technique:= 'z3DCore_GaussBlurSSAO';
  z3DEngine.Renderer.PostProcess(AOutTex, [AInTex], z3DEngine.CoreShader);
end;

type TSingleArray = array of Single;

function z3DGetPixel(const ATexture: IDirect3DBaseTexture9; const ALevel: Integer; const AX, AY: Integer): Single;
var FSurface, FCopySurface: IDirect3DSurface9;
    FDesc: TD3DSurfaceDesc;
    FLockedRect: TD3DLockedRect;
begin
  (ATexture as IDirect3DTexture9).GetSurfaceLevel(ALevel, FSurface);
  FSurface.GetDesc(FDesc);
  z3DCore_GetD3DDevice.CreateOffscreenPlainSurface(FDesc.Width, FDesc.Height,
  FDesc.Format, D3DPOOL_SYSTEMMEM, FCopySurface, nil);
  z3DCore_GetD3DDevice.GetRenderTargetData(FSurface, FCopySurface);
  FCopySurface.LockRect(FLockedRect, nil, D3DLOCK_NO_DIRTY_UPDATE or D3DLOCK_READONLY);
  try
    Result:= TSingleArray(FLockedRect.pBits)[AY*(FLockedRect.Pitch div SizeOf(Single))+AX];
  finally
    FSurface.UnlockRect;
  end;
end;

end.
