unit z3DMath_Impl;

interface

uses Direct3D9, D3DX9, z3DMath_Intf, Math, z3DClasses_Intf, z3DClasses_Impl;

type

  Tz3DMatrix = class(Tz3DBase, Iz3DMatrix)
  private
    Pure: TD3DXMatrix;
    FOnChange: Tz3DBaseObjectEvent;
  protected
    function GetPD3DMatrix: PD3DXMatrix; stdcall;
    function Get11: Single; stdcall;
    function Get12: Single; stdcall;
    function Get13: Single; stdcall;
    function Get14: Single; stdcall;
    function Get21: Single; stdcall;
    function Get22: Single; stdcall;
    function Get23: Single; stdcall;
    function Get24: Single; stdcall;
    function Get31: Single; stdcall;
    function Get32: Single; stdcall;
    function Get33: Single; stdcall;
    function Get34: Single; stdcall;
    function Get41: Single; stdcall;
    function Get42: Single; stdcall;
    function Get43: Single; stdcall;
    function Get44: Single; stdcall;
    procedure Set11(const Value: Single); stdcall;
    procedure Set12(const Value: Single); stdcall;
    procedure Set13(const Value: Single); stdcall;
    procedure Set14(const Value: Single); stdcall;
    procedure Set21(const Value: Single); stdcall;
    procedure Set22(const Value: Single); stdcall;
    procedure Set23(const Value: Single); stdcall;
    procedure Set24(const Value: Single); stdcall;
    procedure Set31(const Value: Single); stdcall;
    procedure Set32(const Value: Single); stdcall;
    procedure Set33(const Value: Single); stdcall;
    procedure Set34(const Value: Single); stdcall;
    procedure Set41(const Value: Single); stdcall;
    procedure Set42(const Value: Single); stdcall;
    procedure Set43(const Value: Single); stdcall;
    procedure Set44(const Value: Single); stdcall;
    function GetD3DMatrix: TD3DXMatrix; stdcall;
    procedure SetD3DMatrix(const Value: TD3DXMatrix); stdcall;
    function GetOnChange: Tz3DBaseObjectEvent; stdcall;
    procedure SetOnChange(const Value: Tz3DBaseObjectEvent); stdcall;
  public
    class function New: Iz3DMatrix;
    class function NewFrom(const AMatrix: Iz3DMatrix): Iz3DMatrix; overload;
    class function NewFrom(const AMatrix: TD3DXMatrix): Iz3DMatrix; overload;
    class function NewIdentity: Iz3DMatrix;
    function From(const AMatrix: Iz3DMatrix): Iz3DMatrix; overload; stdcall;
    function From(const AMatrix: TD3DXMatrix): Iz3DMatrix; overload; stdcall;
    function LookAt(const APosition, ALookAt: Iz3DFloat3): Iz3DMatrix; overload; stdcall;
    function LookAt(const APosition, ALookAt, AUp: Iz3DFloat3): Iz3DMatrix; overload; stdcall;
    function PerspectiveFOV(const AAngle: Single; const AAspect: Single = 1;
      const ANear: Single = 0.01; const AFar: Single = 1000): Iz3DMatrix; overload; stdcall;
    function Ortho(const AWidth, AHeight: Single; const ANear: Single = 0.01;
      const AFar: Single = 1000): Iz3DMatrix; stdcall;
    function Multiply(const AMatrix: Iz3DMatrix): Iz3DMatrix; overload; stdcall;
    function Multiply(const AMatrix: TD3DXMatrix): Iz3DMatrix; overload; stdcall;
    function Inverse: Iz3DMatrix; overload; stdcall;
    function Identity: Iz3DMatrix; stdcall;
    function Inverse(const AMatrix: Iz3DMatrix): Iz3DMatrix; overload; stdcall;
    function Inverse(const AMatrix: TD3DXMatrix): Iz3DMatrix; overload; stdcall;
    function Translation(const AX, AY, AZ: Single): Iz3DMatrix; stdcall;
    function RotateYPR(const AYaw, APitch, ARoll: Single): Iz3DMatrix; stdcall;
    function RotateX(const AAngle: Single): Iz3DMatrix; stdcall;
    function RotateY(const AAngle: Single): Iz3DMatrix; stdcall;
    function RotateZ(const AAngle: Single): Iz3DMatrix; stdcall;
    function RotateQuat(const AQuat: TD3DXQuaternion): Iz3DMatrix; stdcall;
    function Scale(const AScale: Iz3DFloat3): Iz3DMatrix; stdcall;
  public
    property OnChange: Tz3DBaseObjectEvent read GetOnChange write SetOnChange;
    property D3DMatrix: TD3DXMatrix read GetD3DMatrix write SetD3DMatrix;
    property PD3DMatrix: PD3DXMatrix read GetPD3DMatrix;
    property e11: Single read Get11 write Set11;
    property e12: Single read Get12 write Set12;
    property e13: Single read Get13 write Set13;
    property e14: Single read Get14 write Set14;
    property e21: Single read Get21 write Set21;
    property e22: Single read Get22 write Set22;
    property e23: Single read Get23 write Set23;
    property e24: Single read Get24 write Set24;
    property e31: Single read Get31 write Set31;
    property e32: Single read Get32 write Set32;
    property e33: Single read Get33 write Set33;
    property e34: Single read Get34 write Set34;
    property e41: Single read Get41 write Set41;
    property e42: Single read Get42 write Set42;
    property e43: Single read Get43 write Set43;
    property e44: Single read Get44 write Set44;
  end;

  Tz3DFloat2 = class(Tz3DBase, Iz3DFloat2)
  private
    Pure: TD3DXVector2;
    FOnChange: Tz3DBaseObjectEvent;
    FInternalChanging: Boolean;
  protected
    function GetOnChange: Tz3DBaseObjectEvent; stdcall;
    procedure SetOnChange(const Value: Tz3DBaseObjectEvent); stdcall;
    function GetXY: TD3DXVector2; stdcall;
    procedure SetXY(const Value: TD3DXVector2); stdcall;
    function GetX: Single; stdcall;
    function GetY: Single; stdcall;
    procedure SetX(const Value: Single); stdcall;
    procedure SetY(const Value: Single); stdcall;
  public
    function From(const AVector: Iz3DFloat2): Iz3DFloat2; overload; stdcall;
    function From(const AVector: TD3DXVector2): Iz3DFloat2; overload; stdcall;
    function Add(const AVector: Iz3DFloat2): Iz3DFloat2; overload; stdcall;
    function Add(const AVector: TD3DXVector2): Iz3DFloat2; overload; stdcall;
    function Subtract(const AVector: Iz3DFloat2): Iz3DFloat2; overload; stdcall;
    function Subtract(const AVector: TD3DXVector2): Iz3DFloat2; overload; stdcall;
    function Scale(const AScale: Single): Iz3DFloat2; stdcall;
    function Negate: Iz3DFloat2; stdcall;
    function Saturate: Iz3DFloat2; stdcall;
    function Length: Single; stdcall;
    function LengthSq: Single; stdcall;
    function Normalize: Iz3DFloat2; stdcall;
    procedure BeginInternalChange; stdcall;
    procedure EndInternalChange; stdcall;
    class function New(const AX: Single = 0; const AY: Single = 0): Iz3DFloat2;
    class function NewFrom(const AVector: Iz3DFloat2): Iz3DFloat2; overload;
    class function NewFrom(const AVector: TD3DXVector2): Iz3DFloat2; overload;
  public
    property OnChange: Tz3DBaseObjectEvent read GetOnChange write SetOnChange;
    property XY: TD3DXVector2 read GetXY write SetXY;
    property R: Single read GetX write SetX;
    property G: Single read GetY write SetY;
    property RG: TD3DXVector2 read GetXY write SetXY;
    property X: Single read GetX write SetX;
    property Y: Single read GetY write SetY;
  end;

  Tz3DFloat3 = class(Tz3DBase, Iz3DFloat3)
  private
    Pure: TD3DXVector3;
    FOnChange: Tz3DBaseObjectEvent;
    FInternalChanging: Boolean;
  protected
    function GetD3DColor: TD3DColor; stdcall;
    function GetD3DColorValue: TD3DColorValue; stdcall;
    function GetOnChange: Tz3DBaseObjectEvent; stdcall;
    procedure SetOnChange(const Value: Tz3DBaseObjectEvent); stdcall;
    function GetXY: TD3DXVector2; stdcall;
    function GetXZ: TD3DXVector2; stdcall;
    function GetYZ: TD3DXVector2; stdcall;
    procedure SetXY(const Value: TD3DXVector2); stdcall;
    procedure SetXZ(const Value: TD3DXVector2); stdcall;
    procedure SetYZ(const Value: TD3DXVector2); stdcall;
    function GetX: Single; stdcall;
    function GetXYZ: TD3DXVector3; stdcall;
    function GetY: Single; stdcall;
    function GetZ: Single; stdcall;
    procedure SetX(const Value: Single); stdcall;
    procedure SetXYZ(const Value: TD3DXVector3); stdcall;
    procedure SetY(const Value: Single); stdcall;
    procedure SetZ(const Value: Single); stdcall;
    function GetRGBA: TD3DXVector4; stdcall;
  public
    function Add(const AVector: Iz3DFloat3): Iz3DFloat3; overload; stdcall;
    function Add(const AVector: TD3DXVector3): Iz3DFloat3; overload; stdcall;
    function Subtract(const AVector: Iz3DFloat3): Iz3DFloat3; overload; stdcall;
    function Subtract(const AVector: TD3DXVector3): Iz3DFloat3; overload; stdcall;
    function Scale(const AScale: Single): Iz3DFloat3; stdcall;
    function Dot(const AVector: Iz3DFloat3): Single; stdcall;
    function Negate: Iz3DFloat3; stdcall;
    function Saturate: Iz3DFloat3; stdcall;
    function Length: Single; stdcall;
    function LengthSq: Single; stdcall;
    function Identity: Iz3DFloat3; stdcall;
    function Cross(const AVector: Iz3DFloat3): Iz3DFloat3; stdcall;
    function TransformC(const AMatrix: Iz3DMatrix): Iz3DFloat3; stdcall;
    function TransformN(const AMatrix: Iz3DMatrix): Iz3DFloat3; stdcall;
    function Normalize: Iz3DFloat3; stdcall;
    function From(const AVector: Iz3DFloat3): Iz3DFloat3; overload; stdcall;
    function From(const AVector: TD3DXVector3): Iz3DFloat3; overload; stdcall;
    function From(const AColor: TD3DColorValue): Iz3DFloat3; overload; stdcall;
    procedure BeginInternalChange; stdcall;
    procedure EndInternalChange; stdcall;
    class function New(const AX: Single = 0; const AY: Single = 0; const AZ: Single = 0): Iz3DFloat3;
    class function NewFrom(const AVector: Iz3DFloat3): Iz3DFloat3; overload;
    class function NewFrom(const AVector: TD3DXVector3): Iz3DFloat3; overload;
    class function NewFrom(const AColor: TD3DColorValue): Iz3DFloat3; overload;
  public
    property OnChange: Tz3DBaseObjectEvent read GetOnChange write SetOnChange;
    property D3DColor: TD3DColor read GetD3DColor;
    property D3DColorValue: TD3DColorValue read GetD3DColorValue;
    property XY: TD3DXVector2 read GetXY write SetXY;
    property XZ: TD3DXVector2 read GetXZ write SetXZ;
    property YZ: TD3DXVector2 read GetYZ write SetYZ;
    property XYZ: TD3DXVector3 read GetXYZ write SetXYZ;
    property R: Single read GetX write SetX;
    property G: Single read GetY write SetY;
    property B: Single read GetZ write SetZ;
    property RG: TD3DXVector2 read GetXY write SetXY;
    property RB: TD3DXVector2 read GetXZ write SetXZ;
    property GB: TD3DXVector2 read GetYZ write SetYZ;
    property RGB: TD3DXVector3 read GetXYZ write SetXYZ;
    property RGBA: TD3DXVector4 read GetRGBA;
    property X: Single read GetX write SetX;
    property Y: Single read GetY write SetY;
    property Z: Single read GetZ write SetZ;
  end;

  Tz3DFloat4 = class(Tz3DBase, Iz3DFloat4)
  private
    Pure: TD3DXVector4;
    FOnChange: Tz3DBaseObjectEvent;
  protected
    function GetD3DColor: TD3DColor; stdcall;
    function GetD3DColorValue: TD3DColorValue; stdcall;
    function GetOnChange: Tz3DBaseObjectEvent; stdcall;
    procedure SetOnChange(const Value: Tz3DBaseObjectEvent); stdcall;
    function GetD3DQuat: TD3DXQuaternion; stdcall;
    procedure SetD3DQuat(const Value: TD3DXQuaternion); stdcall;
    function GetW: Single; stdcall;
    function GetXYW: TD3DXVector3; stdcall;
    function GetXYZW: TD3DXVector4; stdcall;
    function GetXZW: TD3DXVector3; stdcall;
    function GetYZW: TD3DXVector3; stdcall;
    procedure SetW(const Value: Single); stdcall;
    procedure SetXYW(const Value: TD3DXVector3); stdcall;
    procedure SetXYZW(const Value: TD3DXVector4); stdcall;
    procedure SetXZW(const Value: TD3DXVector3); stdcall;
    procedure SetYZW(const Value: TD3DXVector3); stdcall;
    function GetXY: TD3DXVector2; stdcall;
    function GetXZ: TD3DXVector2; stdcall;
    function GetYZ: TD3DXVector2; stdcall;
    procedure SetXY(const Value: TD3DXVector2); stdcall;
    procedure SetXZ(const Value: TD3DXVector2); stdcall;
    procedure SetYZ(const Value: TD3DXVector2); stdcall;
    function GetX: Single; stdcall;
    function GetXYZ: TD3DXVector3; stdcall;
    function GetY: Single; stdcall;
    function GetZ: Single; stdcall;
    procedure SetX(const Value: Single); stdcall;
    procedure SetXYZ(const Value: TD3DXVector3); stdcall;
    procedure SetY(const Value: Single); stdcall;
    procedure SetZ(const Value: Single); stdcall;
  public
    function Add(const AVector: Iz3DFloat4): Iz3DFloat4; overload; stdcall;
    function Add(const AVector: TD3DXVector4): Iz3DFloat4; overload; stdcall;
    function Subtract(const AVector: Iz3DFloat4): Iz3DFloat4; overload; stdcall;
    function Subtract(const AVector: TD3DXVector4): Iz3DFloat4; overload; stdcall;
    function Scale(const AScale: Single): Iz3DFloat4; stdcall;
    function Transform(const AMatrix: Iz3DMatrix): Iz3DFloat4; stdcall;
    function Multiply(const AVector: Iz3DFloat4): Iz3DFloat4; stdcall;
    function RotationMatrix(const AMatrix: Iz3DMatrix): Iz3DFloat4; stdcall;
    function Dot(const AVector: Iz3DFloat4): Single; stdcall;
    function Negate: Iz3DFloat4; stdcall;
    function Saturate: Iz3DFloat4; stdcall;
    function Identity: Iz3DFloat4; stdcall;
    function Normalize: Iz3DFloat4; stdcall;
    function Length: Single; stdcall;
    function LengthSq: Single; stdcall;
    function From(const AVector: Iz3DFloat4): Iz3DFloat4; overload; stdcall;
    function From(const AVector: TD3DXVector4): Iz3DFloat4; overload; stdcall;
    function From(const AColor: TD3DColorValue): Iz3DFloat4; overload; stdcall;
    class function New(const AX: Single = 0; const AY: Single = 0; const AZ: Single = 0; const AW: Single = 0): Iz3DFloat4;
    class function NewFrom(const AVector: Iz3DFloat4): Iz3DFloat4; overload;
    class function NewFrom(const AVector: TD3DXVector4): Iz3DFloat4; overload;
    class function NewFrom(const AColor: TD3DColorValue): Iz3DFloat4; overload;
  public
    property D3DQuat: TD3DXQuaternion read GetD3DQuat write SetD3DQuat;
    property D3DColor: TD3DColor read GetD3DColor;
    property D3DColorValue: TD3DColorValue read GetD3DColorValue;
    property OnChange: Tz3DBaseObjectEvent read GetOnChange write SetOnChange;
    property XY: TD3DXVector2 read GetXY write SetXY;
    property XZ: TD3DXVector2 read GetXZ write SetXZ;
    property YZ: TD3DXVector2 read GetYZ write SetYZ;
    property XYZ: TD3DXVector3 read GetXYZ write SetXYZ;
    property XYW: TD3DXVector3 read GetXYW write SetXYW;
    property XZW: TD3DXVector3 read GetXZW write SetXZW;
    property YZW: TD3DXVector3 read GetYZW write SetYZW;
    property XYZW: TD3DXVector4 read GetXYZW write SetXYZW;
    property R: Single read GetX write SetX;
    property G: Single read GetY write SetY;
    property B: Single read GetZ write SetZ;
    property A: Single read GetW write SetW;
    property RG: TD3DXVector2 read GetXY write SetXY;
    property RB: TD3DXVector2 read GetXZ write SetXZ;
    property GB: TD3DXVector2 read GetYZ write SetYZ;
    property RGB: TD3DXVector3 read GetXYZ write SetXYZ;
    property RGBA: TD3DXVector4 read GetXYZW write SetXYZW;
    property RGA: TD3DXVector3 read GetXYW write SetXYW;
    property RBA: TD3DXVector3 read GetXZW write SetXZW;
    property GBA: TD3DXVector3 read GetYZW write SetYZW;
    property X: Single read GetX write SetX;
    property Y: Single read GetY write SetY;
    property Z: Single read GetZ write SetZ;
    property W: Single read GetW write SetW;
  end;

  Tz3DPlane = class(Tz3DBase, Iz3DPlane)
  private
    Pure: TD3DXPlane;
    FOnChange: Tz3DBaseObjectEvent;
  protected
    function GetOnChange: Tz3DBaseObjectEvent; stdcall;
    procedure SetOnChange(const Value: Tz3DBaseObjectEvent); stdcall;
    function GetA: Single; stdcall;
    function GetB: Single; stdcall;
    function GetC: Single; stdcall;
    function GetD: Single; stdcall;
    function GetABCD: TD3DXPlane; stdcall;
    procedure SetABCD(const Value: TD3DXPlane); stdcall;
    procedure SetA(const Value: Single); stdcall;
    procedure SetB(const Value: Single); stdcall;
    procedure SetC(const Value: Single); stdcall;
    procedure SetD(const Value: Single); stdcall;
  public
    class function New(const AA: Single = 0; const AB: Single = 0; const AC: Single = 0;
      const AD: Single = 0): Iz3DPlane;
    class function NewFrom(const APlane: Iz3DPlane): Iz3DPlane; overload;
    class function NewFrom(const APlane: TD3DXPlane): Iz3DPlane; overload;
    function Intersects(const APlane: Iz3DPlane): Boolean; stdcall;
    function Included(const APlane: Iz3DPlane): Boolean; stdcall;
    function GetNormal: Iz3DFloat3; stdcall;
    function Normalize: Iz3DPlane; stdcall;
    function Dot(const AVector: Iz3DFloat3): Single; stdcall;
  public
    property OnChange: Tz3DBaseObjectEvent read GetOnChange write SetOnChange;
    property ABCD: TD3DXPlane read GetABCD write SetABCD;
    property A: Single read GetA write SetA;
    property B: Single read GetB write SetB;
    property C: Single read GetC write SetC;
    property D: Single read GetD write SetD;
  end;



  Tz3DBoundingVolume = class(Tz3DBase, Iz3DBoundingVolume)
  private
    FCenter: Iz3DFloat3;
  protected
    function GetCenter: Iz3DFloat3; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    procedure ComputeFromMesh(const AMesh: ID3DXMesh); virtual; stdcall;
    function Intersects(const AVolume: Iz3DBoundingVolume): Boolean; virtual; stdcall;
  public
    property Center: Iz3DFloat3 read GetCenter;
  end;

  Tz3DBoundingBox = class(Tz3DBoundingVolume, Iz3DBoundingBox)
  private
    FDimensions: Iz3DFloat3;
  protected
    function GetDimensions: Iz3DFloat3; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    procedure ComputeFromMesh(const AMesh: ID3DXMesh); override; stdcall;
    function Intersects(const AVolume: Iz3DBoundingVolume): Boolean; override; stdcall;
  public
    property Dimensions: Iz3DFloat3 read GetDimensions;
  end;

  Tz3DBoundingSphere = class(Tz3DBoundingVolume, Iz3DBoundingSphere)
  private
    FRadius: Single;
  protected
    function GetRadius: Single; stdcall;
    procedure SetRadius(const Value: Single); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    procedure ComputeFromMesh(const AMesh: ID3DXMesh); override; stdcall;
    function Intersects(const AVolume: Iz3DBoundingVolume): Boolean; override; stdcall;
  public
    property Radius: Single read GetRadius write SetRadius;
  end;

  Tz3DTimeOfDay = class(Tz3DBase, Iz3DTimeOfDay)
  private
    FHours: Integer;
    FMinutes: Integer;
    FSeconds: Integer;
  protected
    function GetHours: Integer; stdcall;
    function GetMinutes: Integer; stdcall;
    function GetSeconds: Integer; stdcall;
    procedure SetHours(const Value: Integer); stdcall;
    procedure SetMinutes(const Value: Integer); stdcall;
    procedure SetSeconds(const Value: Integer); stdcall;
  public
    function ToInteger: Integer; stdcall;
    function ToFloat: Single; stdcall;
  public
    property Hours: Integer read GetHours write SetHours;
    property Minutes: Integer read GetMinutes write SetMinutes;
    property Seconds: Integer read GetSeconds write SetSeconds;
  end;

// FloatN constructors

function z3DFloat2(const AX: Single = 0; const AY: Single = 0): Iz3DFloat2; stdcall;
function z3DFloat3(const AX: Single = 0; const AY: Single = 0;
  const AZ: Single = 0): Iz3DFloat3; stdcall;
function z3DFloat4(const AX: Single = 0; const AY: Single = 0;
  const AZ: Single = 0; const AW: Single = 0): Iz3DFloat4; stdcall;
function z3DFloat4Coord(const AX: Single = 0; const AY: Single = 0;
  const AZ: Single = 0; const AW: Single = 1): Iz3DFloat4; stdcall;

// Matrix constructors

function z3DMatrix: Iz3DMatrix; stdcall;
function z3DMatrixIdentity: Iz3DMatrix; stdcall;

// Plane functions

function z3DPlane(const AA: Single = 0; const AB: Single = 0; const AC: Single = 0;
  const AD: Single = 0): Iz3DPlane; stdcall;

// Algebraic functions

function Saturate(const AValue: Single): Single; stdcall;
function z3DGetNormal(const AV1, AV2, AV3: Iz3DFloat3): Iz3DFloat3; stdcall;
function z3DPlaneRaySHLerp(const ANormal, AEdgeI, AEdgeJ: Iz3DFloat3;
  const AI, AJ, ACount: Integer; out ARay: Iz3DFloat3): Single; stdcall;

// Math functions

function Clamp(const AValue, AMin, AMax: Single): Single; stdcall;
function Lerp(const AX, AY: Single; const AValue: Single): Single; stdcall;

// Bounding volume functions

function z3DBoundingBox: Iz3DBoundingBox; stdcall;
function z3DBoundingSphere: Iz3DBoundingSphere; stdcall;

// Time of day functions
function z3DTimeOfDay: Iz3DTimeOfDay; stdcall;

implementation

uses Windows, z3DCore_Func, z3DCore_Intf;

function z3DBoundingBox: Iz3DBoundingBox; stdcall;
begin
  Result:= Tz3DBoundingBox.Create;
end;

function z3DBoundingSphere: Iz3DBoundingSphere; stdcall;
begin
  Result:= Tz3DBoundingSphere.Create;
end;

function z3DFloat2(const AX: Single = 0; const AY: Single = 0): Iz3DFloat2; stdcall;
begin
  Result:= Tz3DFloat2.New(AX, AY);
end;

function z3DFloat3(const AX: Single = 0; const AY: Single = 0; const AZ: Single = 0): Iz3DFloat3; stdcall;
begin
  Result:= Tz3DFloat3.New(AX, AY, AZ);
end;

function z3DFloat4(const AX: Single = 0; const AY: Single = 0; const AZ: Single = 0; const AW: Single = 0): Iz3DFloat4; stdcall;
begin
  Result:= Tz3DFloat4.New(AX, AY, AZ, AW);
end;

function z3DFloat4Coord(const AX: Single = 0; const AY: Single = 0; const AZ: Single = 0; const AW: Single = 1): Iz3DFloat4; stdcall;
begin
  Result:= z3DFloat4(AX, AY, AZ, AW);
end;

function z3DMatrix: Iz3DMatrix; stdcall;
begin
  Result:= Tz3DMatrix.New;
end;

function z3DMatrixIdentity: Iz3DMatrix; stdcall;
begin
  Result:= Tz3DMatrix.NewIdentity;
end;

function z3DPlane(const AA: Single = 0; const AB: Single = 0; const AC: Single = 0; const AD: Single = 0): Iz3DPlane; stdcall;
begin
  Result:= Tz3DPlane.New(AA, AB, AC, AD);
end;

function z3DGetNormal(const AV1, AV2, AV3: Iz3DFloat3): Iz3DFloat3; stdcall;
var UX, UY, UZ, VX, VY, VZ: Single;
begin
  UX:= AV2.x - AV1.x;
  UY:= AV2.y - AV1.y;
  UZ:= AV2.z - AV1.z;
  VX:= AV3.x - AV1.x;
  VY:= AV3.y - AV1.y;
  VZ:= AV3.z - AV1.z;
  Result:= z3DFloat3((UY*VZ)-(VY*UZ), (UZ*VX)-(VZ*UX), (UX*VY)-(VX*UY));
end;

function Clamp(const AValue, AMin, AMax: Single): Single; stdcall;
begin
  Result:= Min(AMax, Max(AMin, AValue));
end;

function Saturate(const AValue: Single): Single; stdcall;
begin
  Result:= Clamp(AValue, 0, 1);
end;

function Lerp(const AX, AY: Single; const AValue: Single): Single; stdcall;
begin
  Result:= AX + AValue * (AY - AX);
end;

function z3DPlaneRaySHLerp(const ANormal, AEdgeI, AEdgeJ: Iz3DFloat3;
  const AI, AJ, ACount: Integer; out ARay: Iz3DFloat3): Single; stdcall;
const FEpsilon = 1e-3;
var FLerpEdgeI, FLerpEdgeJ, FLerpEdges, FLerpNormal, FLerpRay: Iz3DFloat3;
    FFactorI, FFactorJ: Single;
begin
  FFactorI:= AI / (ACount-1) - 0.5;
  FFactorJ:= AJ / (ACount-1) - 0.5;
  Result:= Saturate(1 - (Abs(FFactorI) + Abs(FFactorJ)) + FEpsilon);
  FLerpEdgeI:= z3DFloat3.From(AEdgeI).Scale(FFactorI);
  FLerpEdgeJ:= z3DFloat3.From(AEdgeJ).Scale(FFactorJ);
  FLerpEdges:= z3DFloat3.From(FLerpEdgeI).Add(FLerpEdgeJ);
  FLerpNormal:= z3DFloat3.From(ANormal).Scale(Result);
  FLerpRay:= z3DFloat3.From(FLerpEdges).Add(FLerpNormal).Normalize;
  ARay:= z3DFloat3.From(FLerpRay).Negate;
end;

function z3DTimeOfDay: Iz3DTimeOfDay; stdcall;
begin
  Result:= Tz3DTimeOfDay.Create;
end;

{ Tz3DMatrix }

class function Tz3DMatrix.NewIdentity: Iz3DMatrix;
begin
  Result:= Tz3DMatrix.Create;
  Result.Identity;
end;

class function Tz3DMatrix.New: Iz3DMatrix;
begin
  Result:= Tz3DMatrix.Create;
end;

function Tz3DMatrix.LookAt(const APosition, ALookAt: Iz3DFloat3): Iz3DMatrix;
begin
  D3DXMatrixLookAtLH(Pure, APosition.XYZ, ALookAt.XYZ, D3DXVector3(0, 1, 0));
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.LookAt(const APosition, ALookAt, AUp: Iz3DFloat3): Iz3DMatrix;
begin
  D3DXMatrixLookAtLH(Pure, APosition.XYZ, ALookAt.XYZ, AUp.XYZ);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.Multiply(const AMatrix: Iz3DMatrix): Iz3DMatrix;
var FResult: TD3DXMatrix;
begin
  D3DXMatrixMultiply(FResult, Pure, AMatrix.D3DMatrix);
  Pure:= FResult;
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.Multiply(const AMatrix: TD3DXMatrix): Iz3DMatrix;
var FResult: TD3DXMatrix;
begin
  D3DXMatrixMultiply(FResult, Pure, AMatrix);
  Pure:= FResult;
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.Inverse: Iz3DMatrix;
var FResult: TD3DXMatrix;
begin
  D3DXMatrixInverse(FResult, nil, Pure);
  Pure:= FResult;
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.Inverse(const AMatrix: Iz3DMatrix): Iz3DMatrix;
begin
  D3DXMatrixInverse(Pure, nil, AMatrix.D3DMatrix);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.Inverse(const AMatrix: TD3DXMatrix): Iz3DMatrix;
begin
  D3DXMatrixInverse(Pure, nil, AMatrix);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.RotateYPR(const AYaw, APitch, ARoll: Single): Iz3DMatrix;
begin
  D3DXMatrixRotationYawPitchRoll(Pure, AYaw, APitch, ARoll);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

class function Tz3DMatrix.NewFrom(const AMatrix: Iz3DMatrix): Iz3DMatrix;
begin
  Result:= Tz3DMatrix.Create;
  Result.D3DMatrix:= AMatrix.D3DMatrix;
end;

class function Tz3DMatrix.NewFrom(const AMatrix: TD3DXMatrix): Iz3DMatrix;
begin
  Result:= Tz3DMatrix.Create;
  Result.D3DMatrix:= AMatrix;
end;

function Tz3DMatrix.Identity: Iz3DMatrix;
begin
  D3DXMatrixIdentity(Pure);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.RotateQuat(const AQuat: TD3DXQuaternion): Iz3DMatrix;
begin
  D3DXMatrixRotationQuaternion(Pure, AQuat);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.Translation(const AX, AY, AZ: Single): Iz3DMatrix;
begin
  D3DXMatrixTranslation(Pure, AX, AY, AZ);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.PerspectiveFOV(const AAngle, AAspect, ANear, AFar: Single): Iz3DMatrix;
begin
  D3DXMatrixPerspectiveFovLH(Pure, AAngle, AAspect, ANear, AFar);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.Get11: Single;
begin
  Result:= Pure._11;
end;

function Tz3DMatrix.Get12: Single;
begin
  Result:= Pure._12;
end;

function Tz3DMatrix.Get13: Single;
begin
  Result:= Pure._13;
end;

function Tz3DMatrix.Get14: Single;
begin
  Result:= Pure._14;
end;

function Tz3DMatrix.Get21: Single;
begin
  Result:= Pure._21;
end;

function Tz3DMatrix.Get22: Single;
begin
  Result:= Pure._22;
end;

function Tz3DMatrix.Get23: Single;
begin
  Result:= Pure._23;
end;

function Tz3DMatrix.Get24: Single;
begin
  Result:= Pure._24;
end;

function Tz3DMatrix.Get31: Single;
begin
  Result:= Pure._31;
end;

function Tz3DMatrix.Get32: Single;
begin
  Result:= Pure._32;
end;

function Tz3DMatrix.Get33: Single;
begin
  Result:= Pure._33;
end;

function Tz3DMatrix.Get34: Single;
begin
  Result:= Pure._34;
end;

function Tz3DMatrix.Get41: Single;
begin
  Result:= Pure._41;
end;

function Tz3DMatrix.Get42: Single;
begin
  Result:= Pure._42;
end;

function Tz3DMatrix.Get43: Single;
begin
  Result:= Pure._43;
end;

function Tz3DMatrix.Get44: Single;
begin
  Result:= Pure._44;
end;

procedure Tz3DMatrix.Set11(const Value: Single);
begin
  Pure._11:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set12(const Value: Single);
begin
  Pure._12:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set13(const Value: Single);
begin
  Pure._13:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set14(const Value: Single);
begin
  Pure._14:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set21(const Value: Single);
begin
  Pure._21:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set22(const Value: Single);
begin
  Pure._22:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set23(const Value: Single);
begin
  Pure._23:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set24(const Value: Single);
begin
  Pure._24:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set31(const Value: Single);
begin
  Pure._31:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set32(const Value: Single);
begin
  Pure._32:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set33(const Value: Single);
begin
  Pure._33:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set34(const Value: Single);
begin
  Pure._34:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set41(const Value: Single);
begin
  Pure._41:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set42(const Value: Single);
begin
  Pure._42:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set43(const Value: Single);
begin
  Pure._43:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DMatrix.Set44(const Value: Single);
begin
  Pure._44:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

function Tz3DMatrix.GetD3DMatrix: TD3DXMatrix;
begin
  Result:= Pure;
end;

procedure Tz3DMatrix.SetD3DMatrix(const Value: TD3DXMatrix);
begin
  Pure:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

function Tz3DMatrix.RotateX(const AAngle: Single): Iz3DMatrix;
begin
  D3DXMatrixRotationX(Pure, AAngle);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.RotateY(const AAngle: Single): Iz3DMatrix;
begin
  D3DXMatrixRotationY(Pure, AAngle);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.RotateZ(const AAngle: Single): Iz3DMatrix;
begin
  D3DXMatrixRotationZ(Pure, AAngle);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.Scale(const AScale: Iz3DFloat3): Iz3DMatrix;
begin
  D3DXMatrixScaling(Pure, AScale.X, AScale.Y, AScale.Z);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DMatrix.GetOnChange: Tz3DBaseObjectEvent;
begin
  Result:= FOnChange;
end;

procedure Tz3DMatrix.SetOnChange(const Value: Tz3DBaseObjectEvent);
begin
  FOnChange:= Value;
end;

function Tz3DMatrix.From(const AMatrix: Iz3DMatrix): Iz3DMatrix;
begin
  Pure:= AMatrix.D3DMatrix;
  Result:= Self;
end;

function Tz3DMatrix.GetPD3DMatrix: PD3DXMatrix;
begin
  Result:= @Pure;
end;

function Tz3DMatrix.Ortho(const AWidth, AHeight, ANear,
  AFar: Single): Iz3DMatrix;
begin
  D3DXMatrixOrthoLH(Pure, AWidth, AHeight, ANear, AFar);
end;

function Tz3DMatrix.From(const AMatrix: TD3DXMatrix): Iz3DMatrix;
begin
  Pure:= AMatrix;
  Result:= Self;
end;

{ Tz3DFloat2 }

function Tz3DFloat2.Add(const AVector: TD3DXVector2): Iz3DFloat2;
begin
  Pure:= D3DXVec2Add(Pure, AVector);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat2.Add(const AVector: Iz3DFloat2): Iz3DFloat2;
begin
  Pure:= D3DXVec2Add(Pure, AVector.XY);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat2.From(const AVector: Iz3DFloat2): Iz3DFloat2;
begin
  XY:= AVector.XY;
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

procedure Tz3DFloat2.BeginInternalChange;
begin
  FInternalChanging:= True;
end;

procedure Tz3DFloat2.EndInternalChange;
begin
  FInternalChanging:= False;
end;

function Tz3DFloat2.From(const AVector: TD3DXVector2): Iz3DFloat2;
begin
  Pure:= AVector;
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat2.GetOnChange: Tz3DBaseObjectEvent;
begin
  Result:= FOnChange;
end;

function Tz3DFloat2.GetX: Single;
begin
  Result:= Pure.X;
end;

function Tz3DFloat2.GetXY: TD3DXVector2;
begin
  Result:= Pure;
end;

function Tz3DFloat2.GetY: Single;
begin
  Result:= Pure.Y;
end;

function Tz3DFloat2.Length: Single;
begin
  Result:= D3DXVec2Length(Pure);
end;

function Tz3DFloat2.LengthSq: Single;
begin
  Result:= D3DXVec2LengthSq(Pure);
end;

function Tz3DFloat2.Negate: Iz3DFloat2;
var FResult: TD3DXVector2;
begin
  D3DXVec2Scale(FResult, Pure, -1);
  Pure:= FResult;
  Result:= Self;
end;

class function Tz3DFloat2.New(const AX, AY: Single): Iz3DFloat2;
begin
  Result:= Tz3DFloat2.Create;
  Result.XY:= D3DXVector2(AX, AY);
end;

class function Tz3DFloat2.NewFrom(const AVector: TD3DXVector2): Iz3DFloat2;
begin
  Result:= Tz3DFloat2.Create;
  Result.XY:= AVector;
end;

class function Tz3DFloat2.NewFrom(const AVector: Iz3DFloat2): Iz3DFloat2;
begin
  Result:= Tz3DFloat2.Create;
  Result.XY:= AVector.XY;
end;

function Tz3DFloat2.Normalize: Iz3DFloat2;
var FResult: TD3DXVector2;
begin
  D3DXVec2Normalize(FResult, Pure);
  Pure:= FResult;
  if Assigned(FOnChange) then FOnChange(Self);
end;

function Tz3DFloat2.Saturate: Iz3DFloat2;
begin
  Pure.x:= Clamp(X, 0, 1);
  Pure.y:= Clamp(Y, 0, 1);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat2.Scale(const AScale: Single): Iz3DFloat2;
var FResult: TD3DXVector2;
begin
  D3DXVec2Scale(FResult, Pure, AScale);
  Pure:= FResult;
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

procedure Tz3DFloat2.SetOnChange(const Value: Tz3DBaseObjectEvent);
begin
  FOnChange:= Value;
end;

procedure Tz3DFloat2.SetX(const Value: Single);
begin
  Pure.X:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DFloat2.SetXY(const Value: TD3DXVector2);
begin
  Pure:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DFloat2.SetY(const Value: Single);
begin
  Pure.Y:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

function Tz3DFloat2.Subtract(const AVector: TD3DXVector2): Iz3DFloat2;
begin
  Pure:= D3DXVec2Subtract(Pure, AVector);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat2.Subtract(const AVector: Iz3DFloat2): Iz3DFloat2;
begin
  Pure:= D3DXVec2Subtract(Pure, AVector.XY);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

{ Tz3DFloat3 }

class function Tz3DFloat3.New(const AX: Single = 0; const AY: Single = 0; const AZ: Single = 0): Iz3DFloat3;
begin
  Result:= Tz3DFloat3.Create;
  Result.XYZ:= D3DXVector3(AX, AY, AZ);
end;

class function Tz3DFloat3.NewFrom(const AVector: Iz3DFloat3): Iz3DFloat3;
begin
  Result:= Tz3DFloat3.Create;
  Result.From(AVector);
end;

class function Tz3DFloat3.NewFrom(const AVector: TD3DXVector3): Iz3DFloat3;
begin
  Result:= Tz3DFloat3.Create;
  Result.From(AVector);
end;

class function Tz3DFloat3.NewFrom(const AColor: TD3DColorValue): Iz3DFloat3;
begin
  Result:= Tz3DFloat3.Create;
  Result.From(AColor);
end;

function Tz3DFloat3.From(const AVector: Iz3DFloat3): Iz3DFloat3;
begin
  XYZ:= AVector.XYZ;
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat3.From(const AVector: TD3DXVector3): Iz3DFloat3;
begin
  XYZ:= AVector;
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat3.From(const AColor: TD3DColorValue): Iz3DFloat3;
begin
  X:= AColor.R;
  Y:= AColor.G;
  Z:= AColor.B;
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat3.Add(const AVector: Iz3DFloat3): Iz3DFloat3;
begin
  D3DXVec3Add(Pure, Pure, AVector.XYZ);
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat3.Add(const AVector: TD3DXVector3): Iz3DFloat3;
begin
  D3DXVec3Add(Pure, Pure, AVector);
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat3.GetXY: TD3DXVector2;
begin
  Result:= D3DXVector2(Pure.X, Pure.Y);
end;

function Tz3DFloat3.GetXZ: TD3DXVector2;
begin
  Result:= D3DXVector2(Pure.X, Pure.Z);
end;

function Tz3DFloat3.GetYZ: TD3DXVector2;
begin
  Result:= D3DXVector2(Pure.Y, Pure.Z);
end;

procedure Tz3DFloat3.SetXY(const Value: TD3DXVector2);
begin
  Pure.x:= Value.x;
  Pure.y:= Value.y;
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
end;

procedure Tz3DFloat3.SetXZ(const Value: TD3DXVector2);
begin
  Pure.x:= Value.x;
  Pure.z:= Value.y;
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
end;

procedure Tz3DFloat3.SetYZ(const Value: TD3DXVector2);
begin
  Pure.y:= Value.x;
  Pure.z:= Value.y;
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
end;

function Tz3DFloat3.Subtract(const AVector: TD3DXVector3): Iz3DFloat3;
begin
  D3DXVec3Subtract(Pure, Pure, AVector);
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat3.Subtract(const AVector: Iz3DFloat3): Iz3DFloat3;
begin
  D3DXVec3Subtract(Pure, Pure, AVector.XYZ);
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat3.TransformC(const AMatrix: Iz3DMatrix): Iz3DFloat3;
begin
  D3DXVec3TransformCoord(Pure, Pure, AMatrix.D3DMatrix);
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat3.TransformN(const AMatrix: Iz3DMatrix): Iz3DFloat3;
begin
  D3DXVec3TransformNormal(Pure, Pure, AMatrix.D3DMatrix);
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat3.Scale(const AScale: Single): Iz3DFloat3;
begin
  D3DXVec3Scale(Pure, Pure, AScale);
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat3.Normalize: Iz3DFloat3;
begin
  D3DXVec3Normalize(Pure, Pure);
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat3.GetX: Single;
begin
  Result:= Pure.X;
end;

function Tz3DFloat3.GetXYZ: TD3DXVector3;
begin
  Result:= Pure;
end;

function Tz3DFloat3.GetY: Single;
begin
  Result:= Pure.Y;
end;

function Tz3DFloat3.GetZ: Single;
begin
  Result:= Pure.Z;
end;

procedure Tz3DFloat3.SetX(const Value: Single);
begin
  Pure.X:= Value;
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
end;

procedure Tz3DFloat3.SetXYZ(const Value: TD3DXVector3);
begin
  Pure:= Value;
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
end;

procedure Tz3DFloat3.SetY(const Value: Single);
begin
  Pure.Y:= Value;
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
end;

procedure Tz3DFloat3.SetZ(const Value: Single);
begin
  Pure.Z:= Value;
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
end;

function Tz3DFloat3.GetRGBA: TD3DXVector4;
begin
  Result:= D3DXVector4(Pure, 1);
end;

function Tz3DFloat3.Dot(const AVector: Iz3DFloat3): Single;
begin
  Result:= D3DXVec3Dot(Pure, AVector.XYZ);
end;

function Tz3DFloat3.Cross(const AVector: Iz3DFloat3): Iz3DFloat3;
var FResult: TD3DXVector3;
begin
  D3DXVec3Cross(FResult, Pure, AVector.XYZ);
  Pure:= FResult;
  Result:= Self;
end;

function Tz3DFloat3.Length: Single;
begin
  Result:= D3DXVec3Length(Pure);
end;

function Tz3DFloat3.LengthSq: Single;
begin
  Result:= D3DXVec3LengthSq(Pure);
end;

function Tz3DFloat3.Identity: Iz3DFloat3;
begin
  Pure.x:= 0;
  Pure.y:= 0;
  Pure.z:= 0;
  if Assigned(FOnChange) and not FInternalChanging then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat3.GetOnChange: Tz3DBaseObjectEvent;
begin
  Result:= FOnChange;
end;

procedure Tz3DFloat3.SetOnChange(const Value: Tz3DBaseObjectEvent);
begin
  FOnChange:= Value;
end;

procedure Tz3DFloat3.BeginInternalChange;
begin
  FInternalChanging:= True;
end;

procedure Tz3DFloat3.EndInternalChange;
begin
  FInternalChanging:= False;
end;

function Tz3DFloat3.Negate: Iz3DFloat3;
var FResult: TD3DXVector3;
begin
  D3DXVec3Scale(FResult, Pure, -1);
  Pure:= FResult;
  Result:= Self;
end;

function Tz3DFloat3.GetD3DColor: TD3DColor;
begin
  Result:= D3DCOLOR_ARGB(255, Round(R*255), Round(G*255), Round(B*255));
end;

function Tz3DFloat3.GetD3DColorValue: TD3DColorValue;
begin
  Result.r:= R;
  Result.g:= G;
  Result.b:= B;
  Result.a:= 1;
end;

function Tz3DFloat3.Saturate: Iz3DFloat3;
begin
  Pure.x:= Clamp(X, 0, 1);
  Pure.y:= Clamp(Y, 0, 1);
  Pure.z:= Clamp(Z, 0, 1);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

{ Tz3DPlane }

function Tz3DPlane.Dot(const AVector: Iz3DFloat3): Single;
begin
  Result:= D3DXPlaneDotCoord(Pure, AVector.XYZ);
end;

function Tz3DPlane.GetA: Single;
begin
  Result:= Pure.a;
end;

function Tz3DPlane.GetABCD: TD3DXPlane;
begin
  Result:= Pure;
end;

function Tz3DPlane.GetB: Single;
begin
  Result:= Pure.b;
end;

function Tz3DPlane.GetC: Single;
begin
  Result:= Pure.c;
end;

function Tz3DPlane.GetD: Single;
begin
  Result:= Pure.d;
end;

function Tz3DPlane.GetNormal: Iz3DFloat3;
begin
  Result:= z3DFloat3(A, B, C).Normalize;
end;

function Tz3DPlane.GetOnChange: Tz3DBaseObjectEvent;
begin
  Result:= FOnChange;
end;

function Tz3DPlane.Included(const APlane: Iz3DPlane): Boolean;
begin
  Result:= ((A > APlane.A) and (B > APlane.B) and
  (C < APlane.C) and (D < APlane.D)) or
  ((APlane.A > A) and (APlane.B > B) and
  (APlane.C < C) and (APlane.D < D));
end;

function Tz3DPlane.Intersects(const APlane: Iz3DPlane): Boolean;
begin
  Result:= ((C > APlane.A) and (D > APlane.B) and
  (C < APlane.C) and (D < APlane.D)) or
  ((A < APlane.C) and (B < APlane.D) and
  (A > APlane.A) and (B > APlane.B));
end;

class function Tz3DPlane.New(const AA, AB, AC, AD: Single): Iz3DPlane;
begin
  Result:= Tz3DPlane.Create;
  Result.ABCD:= D3DXPlane(AA, AB, AC, AD);
end;

class function Tz3DPlane.NewFrom(const APlane: TD3DXPlane): Iz3DPlane;
begin
  Result:= Tz3DPlane.Create;
  Result.ABCD:= APlane;
end;

class function Tz3DPlane.NewFrom(const APlane: Iz3DPlane): Iz3DPlane;
begin
  Result:= Tz3DPlane.Create;
  Result.ABCD:= APlane.ABCD;
end;

function Tz3DPlane.Normalize: Iz3DPlane;
var FPlane: TD3DXPlane;
begin
  D3DXPlaneNormalize(FPlane, Pure);
  Pure:= FPlane;
  Result:= Self;
end;

procedure Tz3DPlane.SetA(const Value: Single);
begin
  Pure.a:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DPlane.SetABCD(const Value: TD3DXPlane);
begin
  Pure:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DPlane.SetB(const Value: Single);
begin
  Pure.b:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DPlane.SetC(const Value: Single);
begin
  Pure.c:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DPlane.SetD(const Value: Single);
begin
  Pure.d:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DPlane.SetOnChange(const Value: Tz3DBaseObjectEvent);
begin
  FOnChange:= Value;
end;

{ Tz3DFloat4 }

function Tz3DFloat4.Add(const AVector: Iz3DFloat4): Iz3DFloat4;
begin
  D3DXVec4Add(Pure, Pure, AVector.XYZW);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat4.Add(const AVector: TD3DXVector4): Iz3DFloat4;
begin
  D3DXVec4Add(Pure, Pure, AVector);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat4.From(const AVector: Iz3DFloat4): Iz3DFloat4;
begin
  Pure:= AVector.XYZW;
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat4.From(const AVector: TD3DXVector4): Iz3DFloat4;
begin
  Pure:= AVector;
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat4.Dot(const AVector: Iz3DFloat4): Single;
begin
  Result:= D3DXVec4Dot(Pure, AVector.XYZW);
end;

function Tz3DFloat4.From(const AColor: TD3DColorValue): Iz3DFloat4;
begin
  Pure.x:= AColor.r;
  Pure.y:= AColor.g;
  Pure.z:= AColor.b;
  Pure.w:= AColor.a;
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat4.GetD3DColor: TD3DColor;
begin
  Result:= D3DCOLOR_ARGB(Round(A*255), Round(R*255), Round(G*255), Round(B*255));
end;

function Tz3DFloat4.GetD3DColorValue: TD3DColorValue;
begin
  Result.r:= R;
  Result.g:= G;
  Result.b:= B;
  Result.a:= A;
end;

function Tz3DFloat4.GetD3DQuat: TD3DXQuaternion;
begin
  Result:= TD3DXQuaternion(Pure);
end;

function Tz3DFloat4.GetOnChange: Tz3DBaseObjectEvent;
begin
  Result:= FOnChange;
end;

function Tz3DFloat4.GetW: Single;
begin
  Result:= Pure.w;
end;

function Tz3DFloat4.GetX: Single;
begin
  Result:= Pure.x;
end;

function Tz3DFloat4.GetXY: TD3DXVector2;
begin
  Result:= D3DXVector2(Pure.x, Pure.y);
end;

function Tz3DFloat4.GetXYW: TD3DXVector3;
begin
  Result:= D3DXVector3(Pure.x, Pure.y, Pure.w);
end;

function Tz3DFloat4.GetXYZ: TD3DXVector3;
begin
  Result:= D3DXVector3(Pure.x, Pure.y, Pure.z);
end;

function Tz3DFloat4.GetXYZW: TD3DXVector4;
begin
  Result:= Pure;
end;

function Tz3DFloat4.GetXZ: TD3DXVector2;
begin
  Result:= D3DXVector2(Pure.x, Pure.z);
end;

function Tz3DFloat4.GetXZW: TD3DXVector3;
begin
  Result:= D3DXVector3(Pure.x, Pure.z, Pure.w);
end;

function Tz3DFloat4.GetY: Single;
begin
  Result:= Pure.y;
end;

function Tz3DFloat4.GetYZ: TD3DXVector2;
begin
  Result:= D3DXVector2(Pure.y, Pure.z);
end;

function Tz3DFloat4.GetYZW: TD3DXVector3;
begin
  Result:= D3DXVector3(Pure.y, Pure.z, Pure.w);
end;

function Tz3DFloat4.GetZ: Single;
begin
  Result:= Pure.z;
end;

function Tz3DFloat4.Identity: Iz3DFloat4;
begin
  Pure.x:= 0;
  Pure.y:= 0;
  Pure.z:= 0;
  Pure.w:= 1;
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat4.Length: Single;
begin
  Result:= D3DXVec4Length(Pure);
end;

function Tz3DFloat4.LengthSq: Single;
begin
  Result:= D3DXVec4LengthSq(Pure);
end;

function Tz3DFloat4.Multiply(const AVector: Iz3DFloat4): Iz3DFloat4;
begin
  D3DXQuaternionMultiply(TD3DXQuaternion(Pure), TD3DXQuaternion(Pure), TD3DXQuaternion(AVector.XYZW));
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat4.Negate: Iz3DFloat4;
var FResult: TD3DXVector4;
begin
  D3DXVec4Scale(FResult, Pure, -1);
  Pure:= FResult;
  Result:= Self;
end;

class function Tz3DFloat4.New(const AX, AY, AZ, AW: Single): Iz3DFloat4;
begin
  Result:= Tz3DFloat4.Create;
  Result.XYZW:= D3DXVector4(AX, AY, AZ, AW);
end;

class function Tz3DFloat4.NewFrom(const AVector: Iz3DFloat4): Iz3DFloat4;
begin
  Result:= Tz3DFloat4.Create;
  Result.XYZW:= AVector.XYZW;
end;

class function Tz3DFloat4.NewFrom(const AColor: TD3DColorValue): Iz3DFloat4;
begin
  Result:= Tz3DFloat4.Create;
  Result.x:= AColor.r;
  Result.y:= AColor.g;
  Result.z:= AColor.b;
  Result.w:= AColor.a;
end;

class function Tz3DFloat4.NewFrom(const AVector: TD3DXVector4): Iz3DFloat4;
begin
  Result:= Tz3DFloat4.Create;
  Result.XYZW:= AVector;
end;

function Tz3DFloat4.Normalize: Iz3DFloat4;
begin
  D3DXVec4Normalize(Pure, Pure);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat4.RotationMatrix(const AMatrix: Iz3DMatrix): Iz3DFloat4;
begin
  D3DXQuaternionRotationMatrix(TD3DXQuaternion(Pure), AMatrix.D3DMatrix);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat4.Saturate: Iz3DFloat4;
begin
  Pure.x:= Clamp(X, 0, 1);
  Pure.y:= Clamp(Y, 0, 1);
  Pure.z:= Clamp(Z, 0, 1);
  Pure.w:= Clamp(W, 0, 1);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat4.Scale(const AScale: Single): Iz3DFloat4;
begin
  D3DXVec4Scale(Pure, Pure, AScale);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

procedure Tz3DFloat4.SetD3DQuat(const Value: TD3DXQuaternion);
begin
  Pure:= TD3DXVector4(Value);
end;

procedure Tz3DFloat4.SetOnChange(const Value: Tz3DBaseObjectEvent);
begin
  FOnChange:= Value;
end;

procedure Tz3DFloat4.SetW(const Value: Single);
begin
  Pure.w:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DFloat4.SetX(const Value: Single);
begin
  Pure.x:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DFloat4.SetXY(const Value: TD3DXVector2);
begin
  Pure.x:= Value.x;
  Pure.y:= Value.y;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DFloat4.SetXYW(const Value: TD3DXVector3);
begin
  Pure.x:= Value.x;
  Pure.y:= Value.y;
  Pure.w:= Value.z;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DFloat4.SetXYZ(const Value: TD3DXVector3);
begin
  Pure.x:= Value.x;
  Pure.y:= Value.y;
  Pure.z:= Value.z;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DFloat4.SetXYZW(const Value: TD3DXVector4);
begin
  Pure:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DFloat4.SetXZ(const Value: TD3DXVector2);
begin
  Pure.x:= Value.x;
  Pure.z:= Value.y;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DFloat4.SetXZW(const Value: TD3DXVector3);
begin
  Pure.x:= Value.x;
  Pure.z:= Value.y;
  Pure.w:= Value.z;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DFloat4.SetY(const Value: Single);
begin
  Pure.y:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DFloat4.SetYZ(const Value: TD3DXVector2);
begin
  Pure.y:= Value.x;
  Pure.z:= Value.y;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DFloat4.SetYZW(const Value: TD3DXVector3);
begin
  Pure.y:= Value.x;
  Pure.z:= Value.y;
  Pure.w:= Value.z;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure Tz3DFloat4.SetZ(const Value: Single);
begin
  Pure.z:= Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

function Tz3DFloat4.Subtract(const AVector: TD3DXVector4): Iz3DFloat4;
begin
  D3DXVec4Subtract(Pure, Pure, AVector);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat4.Subtract(const AVector: Iz3DFloat4): Iz3DFloat4;
begin
  D3DXVec4Subtract(Pure, Pure, AVector.XYZW);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;

function Tz3DFloat4.Transform(const AMatrix: Iz3DMatrix): Iz3DFloat4;
begin
  D3DXVec4Transform(Pure, Pure, AMatrix.D3DMatrix);
  if Assigned(FOnChange) then FOnChange(Self);
  Result:= Self;
end;


{ Tz3DBoundingVolume }

constructor Tz3DBoundingVolume.Create;
begin
  inherited Create;
  FCenter:= z3DFloat3;
end;

function Tz3DBoundingVolume.GetCenter: Iz3DFloat3;
begin
  Result:= FCenter;
end;

procedure Tz3DBoundingVolume.ComputeFromMesh(const AMesh: ID3DXMesh);
begin
  // Abstract method
end;

function Tz3DBoundingVolume.Intersects(const AVolume: Iz3DBoundingVolume): Boolean;
begin
  // Abstract method
  Result:= True;
end;

{ Tz3DBoundingBox }

constructor Tz3DBoundingBox.Create;
begin
  inherited Create;
  FDimensions:= z3DFloat3;
end;

function Tz3DBoundingBox.GetDimensions: Iz3DFloat3;
begin
  Result:= FDimensions;
end;

procedure Tz3DBoundingBox.ComputeFromMesh(const AMesh: ID3DXMesh);
var FBuffer: Pointer;
    FVLowerLeft, FVUpperRight: TD3DXVector3;
begin
  AMesh.LockVertexBuffer(0, FBuffer);
  try
    if FAILED(D3DXComputeBoundingBox(FBuffer, AMesh.GetNumVertices, AMesh.GetNumBytesPerVertex, FVLowerLeft, FVUpperRight)) then
    begin
      z3DTrace('Iz3DBoundingBox.ComputeFromMesh: D3DXComputeBoundingBox failed', z3DtkWarning);
      Exit;
    end;
    FDimensions.From(FVUpperRight).Subtract(FVLowerLeft);
    FCenter.From(FVUpperRight).Add(FVLowerLeft).Scale(0.5);
  finally
    AMesh.UnlockVertexBuffer;
  end;
end;

function Tz3DBoundingBox.Intersects(const AVolume: Iz3DBoundingVolume): Boolean;
var FCenterRelative: Iz3DFloat3;
    FClosest: Iz3DFloat3;
    FDistance: Iz3DFloat3;
begin
  // AABB-AABB intersection test
  if z3DSupports(AVolume, Iz3DBoundingBox) then
  begin
    Result:= True;
    if -Dimensions.x * 0.5 > (AVolume as Iz3DBoundingBox).Dimensions.x * 0.5 then Result:= False else
    if -Dimensions.y * 0.5 > (AVolume as Iz3DBoundingBox).Dimensions.y * 0.5 then Result:= False else
    if -Dimensions.z * 0.5 > (AVolume as Iz3DBoundingBox).Dimensions.z * 0.5 then Result:= False else
    if Dimensions.x * 0.5 < -(AVolume as Iz3DBoundingBox).Dimensions.x * 0.5 then Result:= False else
    if Dimensions.y * 0.5 < -(AVolume as Iz3DBoundingBox).Dimensions.y * 0.5 then Result:= False else
    if Dimensions.z * 0.5 < -(AVolume as Iz3DBoundingBox).Dimensions.z * 0.5 then Result:= False;
  end else

  // AABB-Sphere intersection test
  if z3DSupports(AVolume, Iz3DBoundingSphere) then
  begin
    FCenterRelative:= z3DFloat3.From((AVolume as Iz3DBoundingSphere).Center).Subtract(Center);
    FClosest:= z3DFloat3;

    if FCenterRelative.x < -Dimensions.x * 0.5 then
    FClosest.x:= -Dimensions.x * 0.5 else
    if FCenterRelative.x > Dimensions.x * 0.5 then
    FClosest.x:= Dimensions.x * 0.5 else FClosest.x:= FCenterRelative.x;

    if FCenterRelative.y < -Dimensions.y * 0.5 then
    FClosest.y:= -Dimensions.y * 0.5 else
    if FCenterRelative.y > Dimensions.y * 0.5 then
    FClosest.y:= Dimensions.y * 0.5 else FClosest.y:= FCenterRelative.y;

    if FCenterRelative.z < -Dimensions.z * 0.5 then
    FClosest.z:= -Dimensions.z * 0.5 else
    if FCenterRelative.z > Dimensions.z * 0.5 then
    FClosest.z:= Dimensions.z * 0.5 else FClosest.z:= FCenterRelative.z;

    FDistance:= z3Dfloat3.From(FCenterRelative).Subtract(FClosest);
    Result:= FDistance.LengthSq < (AVolume as Iz3DBoundingSphere).Radius * (AVolume as Iz3DBoundingSphere).Radius;
  end;
end;

{ Tz3DBoundingSphere }

constructor Tz3DBoundingSphere.Create;
begin
  inherited;
  FRadius:= 1;
end;

function Tz3DBoundingSphere.GetRadius: Single;
begin
  Result:= FRadius;
end;

procedure Tz3DBoundingSphere.SetRadius(const Value: Single);
begin
  FRadius:= Value;
end;

procedure Tz3DBoundingSphere.ComputeFromMesh(const AMesh: ID3DXMesh);
var FBuffer: Pointer;
    FVCenter: TD3DXVector3;
begin
  AMesh.LockVertexBuffer(0, FBuffer);
  try
    if FAILED(D3DXComputeBoundingSphere(FBuffer, AMesh.GetNumVertices, AMesh.GetNumBytesPerVertex, FVCenter, FRadius)) then
    begin
      z3DTrace('Iz3DBoundingSphere.Compute: D3DXComputeBoundingSphere failed', z3DtkWarning);
      Exit;
    end;
  finally
    AMesh.UnlockVertexBuffer;
  end;
end;

function Tz3DBoundingSphere.Intersects(const AVolume: Iz3DBoundingVolume): Boolean;
begin
  // AABB-Sphere intersection test
  if z3DSupports(AVolume, Iz3DBoundingBox) then
  Result:= AVolume.Intersects(Self) else

  // Sphere-Sphere intersection test
  Result:= z3DFloat3.From((AVolume as Iz3DBoundingSphere).Center).Subtract(Center).Length <=
  Radius + (AVolume as Iz3DBoundingSphere).Radius;
end;

{ Tz3DTimeOfDay }

function Tz3DTimeOfDay.GetHours: Integer;
begin
  Result:= FHours;
end;

function Tz3DTimeOfDay.GetMinutes: Integer;
begin
  Result:= FMinutes;
end;

function Tz3DTimeOfDay.GetSeconds: Integer;
begin
  Result:= FSeconds;
end;

procedure Tz3DTimeOfDay.SetHours(const Value: Integer);
begin
  FHours:= Value;
  if FHours > 23 then FHours:= 23 else
  if FHours < 0 then FHours:= 0;
end;

procedure Tz3DTimeOfDay.SetMinutes(const Value: Integer);
begin
  FMinutes:= Value;
  if FMinutes > 60 then FMinutes:= 60 else
  if FMinutes < 0 then FMinutes:= 0;
end;

procedure Tz3DTimeOfDay.SetSeconds(const Value: Integer);
begin
  FSeconds:= Value;
  if FSeconds > 60 then FSeconds:= 60 else
  if FSeconds < 0 then FSeconds:= 0;
end;

function Tz3DTimeOfDay.ToFloat: Single;
begin
  Result:= ToInteger / 240000;
end;

function Tz3DTimeOfDay.ToInteger: Integer;
begin
  Result:= FHours * 10000 + Round((FMinutes / 6) * 1000) + (FSeconds * 10) div 6;
end;

end.
