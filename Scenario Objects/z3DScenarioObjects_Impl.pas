unit z3DScenarioObjects_Impl;

interface

uses
  Windows, z3DScenarioObjects_Intf, z3DMath_Intf, z3DClasses_Impl,
  z3DInput_Intf, z3DScenario_Intf, Classes, Direct3D9, Messages, D3DX9,
  z3DComponents_Intf, z3DLighting_Intf, z3DScenarioClasses, z3DClasses_Intf,
  z3DAudio_Intf, z3DFileSystem_Intf;


{==============================================================================}
{== Arcball interface                                                        ==}
{==============================================================================}
{== Mouse rotation handler                                                   ==}
{==============================================================================}

type

  Tz3DArcBall = class(Tz3DBase, Iz3DArcBall)
  private
    FRotationMatrix: Iz3DMatrix;
    FTranslationMatrix: Iz3DMatrix;
    FTranslationMatrixDelta: Iz3DMatrix;
    FOffset: TPoint;
    FWidth: Integer;
    FHeight: Integer;
    FCenter: Iz3DFloat2;
    FRadius: Single;
    FTranslationRadius: Single;
    FDownQuat: Iz3DFloat4;
    FCurrentQuat: Iz3DFloat4;
    FDragging: Boolean;
    FLastMousePoint: TPoint;
    FDownPoint: Iz3DFloat3;
    FCurrentPoint: Iz3DFloat3;
  protected
    procedure SetHeight(const Value: Integer); stdcall;
    procedure SetWidth(const Value: Integer); stdcall;
    procedure SetOffset(const Value: TPoint); stdcall;
    function GetCurrentQuat: Iz3DFloat4; stdcall;
    function GetDragging: Boolean; stdcall;
    function GetHeight: Integer; stdcall;
    function GetOffset: TPoint; stdcall;
    function GetRadius: Single; stdcall;
    function GetTranslationRadius: Single; stdcall;
    function GetWidth: Integer; stdcall;
    procedure SetRadius(const Value: Single); stdcall;
    procedure SetTranslationRadius(const Value: Single); stdcall;
    function ScreenToVector(const AScreenX, AScreenY: Single): Iz3DFloat3; stdcall;
    procedure OnBegin(AX, AY: Integer); stdcall;
    procedure OnMove(AX, AY: Integer); stdcall;
    procedure OnEnd; stdcall;
    procedure Reset; stdcall;
    function HandleMessages(hWnd: HWND; uMsg: Cardinal; wParam: WPARAM; lParam: LPARAM): LRESULT; overload; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    procedure HandleMessages(var Msg: TMsg; var Handled: Boolean); overload; stdcall;
    function RotationMatrix: Iz3DMatrix; stdcall;
    function TranslationMatrix: Iz3DMatrix; stdcall;
    function TranslationDeltaMatrix: Iz3DMatrix; stdcall;
  public
    property Dragging: Boolean read GetDragging;
    property TranslationRadius: Single read GetTranslationRadius write SetTranslationRadius;
    property Radius: Single read GetRadius write SetRadius;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Offset: TPoint read GetOffset write SetOffset;
    property CurrentQuat: Iz3DFloat4 read GetCurrentQuat;
  end;

{==============================================================================}
{== Base camera interface                                                    ==}
{==============================================================================}
{== Ancestor for all cameras                                                 ==}
{==============================================================================}

  Tz3DCameraKeys = class(Tz3DBase, Iz3DCameraKeys)
  private
    FEnableDefaultKeys: Boolean;
    FAutoZoom: Boolean;
    FMoveForward: Char;
    FMoveBackward: Char;
    FMoveRight: Char;
    FMoveLeft: Char;
    FMoveUp: Char;
    FMoveDown: Char;
    FZoomIn: Char;
    FZoomOut: Char;
  protected
    function GetAutoZoom: Boolean; stdcall;
    function GetZoomIn: Char; stdcall;
    function GetZoomOut: Char; stdcall;
    procedure SetAutoZoom(const Value: Boolean); stdcall;
    procedure SetZoomIn(const Value: Char); stdcall;
    procedure SetZoomOut(const Value: Char); stdcall;
    function GetEnableDefaultKeys: Boolean; stdcall;
    procedure SetEnableDefaultKeys(const Value: Boolean); stdcall;
    function GetMoveBackward: Char; stdcall;
    function GetMoveDown: Char; stdcall;
    function GetMoveForward: Char; stdcall;
    function GetMoveLeft: Char; stdcall;
    function GetMoveRight: Char; stdcall;
    function GetMoveUp: Char; stdcall;
    procedure SetMoveBackward(const Value: Char); stdcall;
    procedure SetMoveDown(const Value: Char); stdcall;
    procedure SetMoveForward(const Value: Char); stdcall;
    procedure SetMoveLeft(const Value: Char); stdcall;
    procedure SetMoveRight(const Value: Char); stdcall;
    procedure SetMoveUp(const Value: Char); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property EnableDefaultKeys: Boolean read GetEnableDefaultKeys write SetEnableDefaultKeys;
    property MoveForward: Char read GetMoveForward write SetMoveForward;
    property MoveBackward: Char read GetMoveBackward write SetMoveBackward;
    property MoveRight: Char read GetMoveRight write SetMoveRight;
    property MoveLeft: Char read GetMoveLeft write SetMoveLeft;
    property MoveUp: Char read GetMoveUp write SetMoveUp;
    property MoveDown: Char read GetMoveDown write SetMoveDown;
    property ZoomIn: Char read GetZoomIn write SetZoomIn;
    property ZoomOut: Char read GetZoomOut write SetZoomOut;
    property AutoZoom: Boolean read GetAutoZoom write SetAutoZoom;
  end;

  Tz3DBaseCamera = class(Tz3DScenarioLinkedEntity, Iz3DBaseCamera)
  private
    FCameraKeys: Iz3DCameraKeys;
    FViewMatrix: Iz3DMatrix;
    FProjectionMatrix: Iz3DMatrix;
    FGamePad: array[0..INPUT_MAX_CONTROLLERS-1] of Tz3DGamePad;
    FGamePadLeftThumb: Iz3DFloat3;
    FGamePadRightThumb: Iz3DFloat3;
    FInvertPitch: Boolean;
    FGamePadLastActive: array[0..INPUT_MAX_CONTROLLERS] of Double;
    FKeyDownCount: Integer;
    FKeys: array[z3dckStrafeLeft..Pred(z3dckMaxKeys)] of Byte;
    FKeyboardDirection: Iz3DFloat3;
    FLastMousePosition: TPoint;
    FMouseLButtonDown: Boolean;
    FMouseMButtonDown: Boolean;
    FMouseRButtonDown: Boolean;
    FCurrentButtonMask: Integer;
    FMouseWheelDelta: Integer;
    FMouseDelta: Iz3DFloat2;
    FSmoothFrameCount: Integer;
    FDefaultEye: Iz3DFloat3;
    FDefaultLookAt: Iz3DFloat3;
    FPosition: Iz3DFloat3;
    FLookAt: Iz3DFloat3;
    FCameraYawAngle: Single;
    FCameraPitchAngle: Single;
    FDragRect: TRect;
    FVelocity: Iz3DFloat3;
    FSmoothMovement: Boolean;
    FVelocityDrag: Iz3DFloat3;
    FDragTimer: Single;
    FTotalDragTime: Single;
    FRotVelocity: Iz3DFloat2;
    FRotationScale: Single;
    FMoveScale: Single;
    FEnableMovement: Boolean;
    FEnableYMovement: Boolean;
    FClipping: Boolean;
    FActive: Boolean;
    FZoom: Single;
    FClipMin: Iz3DFloat3;
    FClipMax: Iz3DFloat3;
    FMaxZoom: Single;
    FMinZoom: Single;
    FZoomFactor: Single;
    FZoomMode: Tz3DZoomMode;
  protected
    function GetZoomFactor: Single; stdcall;
    procedure SetZoomFactor(const Value: Single); stdcall;
    function GetMaxZoom: Single; stdcall;
    function GetMinZoom: Single; stdcall;
    function GetZoomMode: Tz3DZoomMode; stdcall;
    procedure SetMaxZoom(const Value: Single); stdcall;
    procedure SetMinZoom(const Value: Single); stdcall;
    procedure SetZoomMode(const Value: Tz3DZoomMode); stdcall;
    procedure VectorChanged(const ASender: Iz3DBase); virtual; stdcall;
    function GetKeys: Iz3DCameraKeys; stdcall;
    function GetZoom: Single; stdcall;
    function GetDragging: Boolean; stdcall;
    procedure SetZoom(const Value: Single); stdcall;
    function GetClipMax: Iz3DFloat3; stdcall;
    function GetClipMin: Iz3DFloat3; stdcall;
    function GetClipping: Boolean; stdcall;
    function GetDragRect: TRect; stdcall;
    function GetActive: Boolean; stdcall;
    function GetEnableMovement: Boolean; stdcall;
    function GetEnableYMovement: Boolean; stdcall;
    function GetInvertPitch: Boolean; stdcall;
    function GetLookAt: Iz3DFloat3; stdcall;
    function GetMouseLButtonDown: Boolean; stdcall;
    function GetMouseMButtonDown: Boolean; stdcall;
    function GetMouseRButtonDown: Boolean; stdcall;
    function GetMoveScale: Single; stdcall;
    function GetPosition: Iz3DFloat3; stdcall;
    function GetSmoothFrameCount: Integer; stdcall;
    function GetSmoothMovement: Boolean; stdcall;
    function GetTotalDragTime: Single; stdcall;
    procedure SetClipping(const Value: Boolean); stdcall;
    procedure SetActive(const Value: Boolean); stdcall;
    procedure SetEnableMovement(const Value: Boolean); stdcall;
    procedure SetEnableYMovement(const Value: Boolean); stdcall;
    procedure SetInvertPitch(const Value: Boolean); stdcall;
    procedure SetMoveScale(const Value: Single); stdcall;
    procedure SetSmoothFrameCount(const Value: Integer); stdcall;
    procedure SetSmoothMovement(const Value: Boolean); stdcall;
    procedure SetTotalDragTime(const Value: Single); stdcall;
    function MapKey(const AKey: LongWord): Tz3DCameraInputKeys; virtual; stdcall;
    function IsKeyDown(const AKey: Byte): Boolean; stdcall;
    function WasKeyDown(const AKey: Byte): Boolean; stdcall;
    procedure ConstrainToBoundary(var AVector: Iz3DFloat3); stdcall;
    procedure UpdateVelocity(const AElapsedTime: Single); virtual; stdcall;
    procedure GetInput(const AGetKeyboardInput, AGetMouseInput, AGetGamepadInput, AResetCursorAfterMove: Boolean); stdcall;
    procedure z3DMessage(const AWnd: HWND; const AMsg: Cardinal; const AwParam: Integer; const AlParam: Integer;
      var ADefault: Boolean; var AResult: Integer); override; stdcall;
    procedure z3DFrameMove; override; stdcall;
    procedure z3DResetDevice; override; stdcall;
    procedure UpdateViewParams; virtual; stdcall;
    procedure UpdateProjection; virtual; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;
    procedure SetScalers(const ARotationScaler: Single = 0.01; const AMoveScaler: Single = 5); stdcall;
    procedure SetDragRect(const ARect: TRect); virtual; stdcall;
    function ViewMatrix: Iz3DMatrix; stdcall;
    function ProjectionMatrix: Iz3DMatrix; stdcall;
  public
    property MouseLButtonDown: Boolean read GetMouseLButtonDown;
    property MouseMButtonDown: Boolean read GetMouseMButtonDown;
    property MouseRButtonDown: Boolean read GetMouseRButtonDown;
    property Keys: Iz3DCameraKeys read GetKeys;
    property Dragging: Boolean read GetDragging;
    property DragRect: TRect read GetDragRect write SetDragRect;
    property DragTime: Single read GetTotalDragTime write SetTotalDragTime;
    property Active: Boolean read GetActive write SetActive default True;
    property InvertPitch: Boolean read GetInvertPitch write SetInvertPitch default False;
    property EnablePosMovement: Boolean read GetEnableMovement write SetEnableMovement;
    property EnableYMovement: Boolean read GetEnableYMovement write SetEnableYMovement default False;
    property SmoothMovement: Boolean read GetSmoothMovement write SetSmoothMovement default True;
    property Clipping: Boolean read GetClipping write SetClipping default False;
    property ClipMin: Iz3DFloat3 read GetClipMin;
    property ClipMax: Iz3DFloat3 read GetClipMax;
    property SmoothFrames: Integer read GetSmoothFrameCount write SetSmoothFrameCount default 2;
    property Position: Iz3DFloat3 read GetPosition;
    property LookAt: Iz3DFloat3 read GetLookAt;
    property MoveScale: Single read GetMoveScale write SetMoveScale;
    property Zoom: Single read GetZoom write SetZoom;
    property ZoomFactor: Single read GetZoomFactor write SetZoomFactor;
    property MaxZoom: Single read GetMaxZoom write SetMaxZoom;
    property MinZoom: Single read GetMinZoom write SetMinZoom;
    property ZoomMode: Tz3DZoomMode read GetZoomMode write SetZoomMode;
  end;

{==============================================================================}
{== First person camera interface                                            ==}
{==============================================================================}
{== Camera that centers its view on a model                                  ==}
{==============================================================================}

  Tz3DBaseCameraMouseButtons = class(Tz3DBase, Iz3DObjectCameraMouseButtons)
  private
    FRotateObject: Tz3DMouseButton;
    FZoom: Tz3DMouseButton;
    FRotateCamera: Tz3DMouseButton;
  protected
    procedure SetRotateCamera(const Value: Tz3DMouseButton); stdcall;
    procedure SetRotateObject(const Value: Tz3DMouseButton); stdcall;
    procedure SetZoom(const Value: Tz3DMouseButton); stdcall;
    function GetRotateCamera: Tz3DMouseButton; stdcall;
    function GetRotateObject: Tz3DMouseButton; stdcall;
    function GetZoom: Tz3DMouseButton; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property RotateObject: Tz3DMouseButton read GetRotateObject write SetRotateObject default z3DmbLeft;
    property Zoom: Tz3DMouseButton read GetZoom write SetZoom default z3DmbWheel;
    property RotateCamera: Tz3DMouseButton read GetRotateCamera write SetRotateCamera default z3DmbRight;
  end;

  Tz3DObjectCamera = class(Tz3DBaseCamera, Iz3DObjectCamera)
  private
    FWorldUp: Iz3DFloat3;
    FWorldAhead: Iz3DFloat3;
    FWorldArcBall: Iz3DArcBall;
    FViewArcBall: Iz3DArcBall;
    FObjectLastRot: Iz3DMatrix;
    FObjectRot: Iz3DMatrix;
    FWorldMatrix: Iz3DMatrix;
    FRotateObjectButtonMask: Integer;
    FZoomButtonMask: Integer;
    FRotateCameraButtonMask: Integer;
    FAttached: Boolean;
    FLimitPitch: Boolean;
    FRadius: Single;
    FDefaultRadius: Single;
    FMinRadius: Single;
    FMaxRadius: Single;
    FDragSinceLastUpdate: Boolean;
    FMouseButtons: Iz3DObjectCameraMouseButtons;
    FCameraRotLast: Iz3DMatrix;
    FObject: Iz3DScenarioObject;
  protected
    function GetWorldAhead: Iz3DFloat3; stdcall;
    function GetWorldUp: Iz3DFloat3; stdcall;
    function GetAttached: Boolean; stdcall;
    function GetLimitPitch: Boolean; stdcall;
    function GetMaxRadius: Single; stdcall;
    function GetMinRadius: Single; stdcall;
    function GetRadius: Single; stdcall;
    procedure SetAttached(const Value: Boolean); stdcall;
    procedure SetLimitPitch(const Value: Boolean); stdcall;
    procedure SetMaxRadius(const Value: Single); stdcall;
    procedure SetMinRadius(const Value: Single); stdcall;
    procedure SetRadius(const Value: Single); stdcall;
    function GetMouseButtons: Iz3DObjectCameraMouseButtons; stdcall;
    procedure SetButtonMasks(const ARotateObjectButtonMask: Integer = z3DcMouseLeftButton;
      const AZoomButtonMask: Integer = z3DcMouseWheel; const ARotateCameraButtonMask: Integer = z3DcMouseRightButton); stdcall;
    procedure z3DFrameMove; override; stdcall;
    procedure z3DResetDevice; override; stdcall;
    procedure z3DMessage(const AWnd: HWND; const AMsg: Cardinal; const AwParam: Integer; const AlParam: Integer;
      var ADefault: Boolean; var AResult: Integer); override; stdcall;
    procedure UpdateViewParams; override; stdcall;
  public
    procedure SetDragRect(const ARect: TRect); override; stdcall;
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;
    procedure SetWindow(const AWidth, AHeight: Integer; const AArcballRadius: Single = 0.9); stdcall;
    function GetWorldMatrix: Iz3DMatrix; stdcall;
    procedure SetWorldMatrix(const AMatrix: Iz3DMatrix); stdcall;
    function ObjectMatrix: Iz3DMatrix; stdcall;
    procedure SetObject(const AObject: Iz3DScenarioObject); stdcall;
  public
    property MouseButtons: Iz3DObjectCameraMouseButtons read GetMouseButtons;
    property Attached: Boolean read GetAttached write SetAttached default False;
    property LimitPitch: Boolean read GetLimitPitch write SetLimitPitch default True;
    property Radius: Single read GetRadius write SetRadius;
    property MinRadius: Single read GetMinRadius write SetMinRadius;
    property MaxRadius: Single read GetMaxRadius write SetMaxRadius;
    property WorldUp: Iz3DFloat3 read GetWorldUp;
    property WorldAhead: Iz3DFloat3 read GetWorldAhead;
  end;

{==============================================================================}
{== First person camera interface                                            ==}
{==============================================================================}
{== Camera that acts like an entity looking at the world                     ==}
{==============================================================================}

  Tz3DFirstPersonCameraRotateButtons = class(Tz3DBase, Iz3DFirstPersonCameraRotateButtons)
  private
    FOwner: Iz3DFirstPersonCamera;
    FIgnoreButtons: Boolean;
    FMiddle: Boolean;
    FRight: Boolean;
    FLeft: Boolean;
  protected
    procedure SetIgnoreButtons(const Value: Boolean); stdcall;
    procedure SetLeft(const Value: Boolean); stdcall;
    procedure SetMiddle(const Value: Boolean); stdcall;
    procedure SetRight(const Value: Boolean); stdcall;
    function GetIgnoreButtons: Boolean; stdcall;
    function GetLeft: Boolean; stdcall;
    function GetMiddle: Boolean; stdcall;
    function GetRight: Boolean; stdcall;
  public
    constructor Create(const AOwner: Iz3DFirstPersonCamera);
  public
    property Left: Boolean read GetLeft write SetLeft;
    property Middle: Boolean read GetMiddle write SetMiddle;
    property Right: Boolean read GetRight write SetRight;
    property IgnoreButtons: Boolean read GetIgnoreButtons write SetIgnoreButtons;
  end;

  Tz3DFirstPersonCamera = class(Tz3DBaseCamera, Iz3DFirstPersonCamera, Iz3DScenarioObject,
    Iz3DScenarioDynamicObject)
  private
    FCameraWorld: Iz3DMatrix;
    FActiveButtonMask: Integer;
    FResetCursorAfterMove: Boolean;
    FRotateButtons: Iz3DFirstPersonCameraRotateButtons;
    FObject: Iz3DScenarioDynamicObject;

    FBoundingBox: Iz3DBoundingBox;
    FBoundingSphere: Iz3DBoundingSphere;
    FSubset: Iz3DScenarioObjectSubset;
    FSWOAcceleration: Iz3DFloat3;
    FSWOVelocity: Iz3DFloat3;
    FGround: Boolean;
    FEnableFlashLight: Boolean;
    FFlashLight: Iz3DLight;
    FFlashLightSound: Iz3DSound;
    FEnvironments: Tz3DScenarioEnvironments;
  protected
    function GetAutoLOD: Boolean; stdcall;
    function GetLOD: Tz3DScenarioObjectLOD; stdcall;
    procedure SetAutoLOD(const Value: Boolean); stdcall;
    procedure SetLOD(const Value: Tz3DScenarioObjectLOD); stdcall;
    function GetEnableFlashLight: Boolean; stdcall;
    procedure SetEnableFlashLight(const Value: Boolean); stdcall;
    function GetResetCursorAfterMove: Boolean; stdcall;
    function GetRotateButtons: Iz3DFirstPersonCameraRotateButtons; stdcall;
    procedure SetResetCursorAfterMove(const Value: Boolean); stdcall;
    procedure z3DFrameMove; override; stdcall;
    procedure SetButtons(const ALeft, AMiddle, ARight: Boolean); stdcall;

    procedure CreateFlashLight; stdcall;

    function GetCenter: Iz3DFloat3; stdcall;
    function GetViewCenter: Iz3DFloat4; stdcall;
    function GetVisible: Boolean; stdcall;
    function GetBoundingBox: Iz3DBoundingBox; stdcall;
    function GetBoundingSphere: Iz3DBoundingSphere; stdcall;
    function GetShape: Tz3DScenarioObjectShape; stdcall;
    function GetSubsetCount: Integer; stdcall;
    function GetSubsets(const I: Integer): Iz3DScenarioObjectSubset; stdcall;
    procedure SetVisible(const Value: Boolean); stdcall;

    procedure Show; stdcall;
    procedure Hide; stdcall;

    function GetAcceleration: Iz3DFloat3; stdcall;
    function GetVelocity: Iz3DFloat3; stdcall;
    function GetGround: Boolean; stdcall;
    procedure SetGround(const Value: Boolean); stdcall;
    function GetEnablePhysics: Boolean; stdcall;
    procedure SetEnablePhysics(const Value: Boolean); stdcall;
    procedure VectorChanged(const ASender: Iz3DBase); virtual; stdcall;
    procedure UpdateVelocity(const AElapsedTime: Single); override; stdcall;
    procedure z3DStartScenario(const AStage: Tz3DStartScenarioStage);
      override; stdcall;
    procedure z3DStopScenario; override; stdcall;
    procedure z3DKeyboard(const AChar: Cardinal; const AKeyDown: Boolean;
      const AAltDown: Boolean); override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;
    procedure SetFirstPerson(const AObject: Iz3DScenarioDynamicObject); stdcall;
    function GetWorldMatrix: Iz3DMatrix; stdcall;
    function GetWorldRight: Iz3DFloat3; stdcall;
    function GetWorldUp: Iz3DFloat3; stdcall;
    function GetWorldAhead: Iz3DFloat3; stdcall;
    function GetEyePt: Iz3DFloat3; stdcall;
    function GetInFrustum: Boolean; stdcall;
    procedure FrameMove; stdcall;
    procedure FindCurrentEnvironments(const ARoot: Iz3DScenarioEnvironment); stdcall;
    function InEnvironment(const AEnvironment: Iz3DScenarioEnvironment): Boolean; virtual; stdcall;
    function GetEnvironments: Tz3DScenarioEnvironments; stdcall;
    procedure Render(const AMaterials: Boolean = True; const ALighting: Boolean = True;
      const AShader: Iz3DShader = nil); stdcall;
  public
    property RotateButtons: Iz3DFirstPersonCameraRotateButtons read GetRotateButtons;
    property ResetCursorAfterMove: Boolean read GetResetCursorAfterMove write SetResetCursorAfterMove default True;
    property WorldUp: Iz3DFloat3 read GetWorldUp;
    property WorldAhead: Iz3DFloat3 read GetWorldAhead;

    property LOD: Tz3DScenarioObjectLOD read GetLOD write SetLOD;
    property AutoLOD: Boolean read GetAutoLOD write SetAutoLOD;
    property Shape: Tz3DScenarioObjectShape read GetShape;
    property BoundingSphere: Iz3DBoundingSphere read GetBoundingSphere;
    property BoundingBox: Iz3DBoundingBox read GetBoundingBox;
    property Center: Iz3DFloat3 read GetCenter;
    property ViewCenter: Iz3DFloat4 read GetViewCenter;
    property Subsets[const I: Integer]: Iz3DScenarioObjectSubset read GetSubsets;
    property SubsetCount: Integer read GetSubsetCount;
    property Visible: Boolean read GetVisible write SetVisible;
    property Acceleration: Iz3DFloat3 read GetAcceleration;
    property Velocity: Iz3DFloat3 read GetVelocity;
    property Ground: Boolean read GetGround write SetGround;
    property EnablePhysics: Boolean read GetEnablePhysics write SetEnablePhysics;

    property EnableFlashLight: Boolean read GetEnableFlashLight write SetEnableFlashLight;
  end;

{==============================================================================}
{== Camera controller interface                                              ==}
{==============================================================================}
{== Manages and controls camera creation and allows to easy activate or      ==}
{== disable a camera                                                         ==}
{==============================================================================}

  Tz3DCameraController = class(Tz3DBase, Iz3DCameraController)
  private
    FCameras: IInterfaceList;
    FActiveCameraIndex: Integer;
  protected
    function GetCameraCount: Integer; stdcall;
    function GetActiveCamera: Iz3DBaseCamera; stdcall;
    procedure SetActiveCamera(const Value: Iz3DBaseCamera); stdcall;
    function GetCameras(const AIndex: Integer): Iz3DBaseCamera; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    procedure AddCamera(const ACamera: Iz3DBaseCamera); stdcall;
    procedure RemoveCamera(const ACamera: Iz3DBaseCamera); stdcall;
    function CreateObjectCamera: Iz3DObjectCamera; stdcall;
    function CreateFirstPersonCamera: Iz3DFirstPersonCamera; stdcall;
  public
    property Cameras[const AIndex: Integer]: Iz3DBaseCamera read GetCameras;
    property CameraCount: Integer read GetCameraCount;
    property ActiveCamera: Iz3DBaseCamera read GetActiveCamera write SetActiveCamera;
  end;





{==============================================================================}
{== Sky box interface                                                        ==}
{==============================================================================}
{== Creates a skybox with an environment map texture                         ==}
{==============================================================================}

  Tz3DSkyBox = class(Tz3DBase, Iz3DSkyBox)
  private
    FVertexBuffer: Iz3DVertexBuffer;
    FTexture: Iz3DCubeTexture;
    FActive: Boolean;
    FSkyTextureFormat: Iz3DObjectFileFormat;
  protected
    function GetActive: Boolean; stdcall;
    function GetFileName: PWideChar; stdcall;
    function GetTexture: Iz3DCubeTexture; stdcall;
    procedure SetActive(const Value: Boolean); stdcall;
    procedure SetFileName(const Value: PWideChar); stdcall;
    procedure UpdateVertexBuffer; stdcall;
    procedure CreateTexture; stdcall;

    procedure FrameRender; stdcall;
    procedure StartScenario; stdcall;
    procedure ResetDevice; stdcall;
    procedure FrameMove; stdcall;
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
    procedure Cleanup; override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property Texture: Iz3DCubeTexture read GetTexture;
    property FileName: PWideChar read GetFileName write SetFileName;
    property Active: Boolean read GetActive write SetActive;
  end;

{==============================================================================}
{== Sky interface                                                            ==}
{==============================================================================}
{== Manages a sky emulation for the scene and allows to use automatic lights ==}
{== like stars or planets                                                    ==}
{==============================================================================}

  Tz3DSky = class(Tz3DLinked, Iz3DSky)
  private
    FSkyBox: Iz3DSkyBox;
    FMode: Tz3DSkyMode;
    FActive: Boolean;
  protected
    function GetMode: Tz3DSkyMode; stdcall;
    procedure SetMode(const Value: Tz3DSkyMode); stdcall;
    function GetSkyBox: Iz3DSkyBox; stdcall;
    function GetActive: Boolean; stdcall;
    procedure SetActive(const Value: Boolean); stdcall;

    procedure z3DResetDevice; override; stdcall;
    procedure z3DStartScenario(const AStage: Tz3DStartScenarioStage); override; stdcall;
    procedure z3DFrameMove; override; stdcall;
    procedure z3DFrameRender; override; stdcall;
    procedure Init(const AOwner: Iz3DBase); override; stdcall;
    procedure Cleanup; override; stdcall;
  public
    function AddStarLight: Iz3DLight; stdcall;
  public
    property SkyBox: Iz3DSkyBox read GetSkyBox;
    property Mode: Tz3DSkyMode read GetMode write SetMode;
    property Active: Boolean read GetActive write SetActive;
  end;

{==============================================================================}
{== Earth sky interface                                                      ==}
{==============================================================================}
{== A specific descendant from the sky interface that manages a earth-like   ==}
{== sky with sunlight and/or moonlight                                       ==}
{==============================================================================}

  Tz3DEarthSky = class(Tz3DSky, Iz3DEarthSky)
  private
    FSunLight: Iz3DLight;
    FMoonLight: Iz3DLight;
    FTime: Iz3DTimeOfDay;
    FSunRiseTime: Iz3DTimeOfDay;
    FSunSetTime: Iz3DTimeOfDay;
    FEnableSunLight: Boolean;
    FEnableMoonLight: Boolean;
    FUpdateFog: Boolean;
    FUpdateAmbient: Boolean;
    FDomeMesh: ID3DXMesh;
    FDomeMatrix: Iz3DMatrix;
    FDomeTexture: Iz3DTexture;
    FHazeAmount: Single;
    FRayleighRatio: Iz3DFloat3;
    FMoonHorizonColor: Iz3DFloat3;
    FMoonZenithColor: Iz3DFloat3;
    FSunHorizonColor: Iz3DFloat3;
    FSunZenithColor: Iz3DFloat3;
  protected
    function GetUpdateAmbient: Boolean; stdcall;
    function GetUpdateFog: Boolean; stdcall;
    procedure SetUpdateAmbient(const Value: Boolean); stdcall;
    procedure SetUpdateFog(const Value: Boolean); stdcall;
    function GetEnableMoonLight: Boolean; stdcall;
    function GetEnableSunLight: Boolean; stdcall;
    procedure SetEnableMoonLight(const Value: Boolean); stdcall;
    procedure SetEnableSunLight(const Value: Boolean); stdcall;
    function GetTime: Iz3DTimeOfDay; stdcall;
    function GetSunLight: Iz3DLight; stdcall;
    function GetMoonLight: Iz3DLight; stdcall;
    function GetHazeAmount: Single; stdcall;
    function GetRayleighRatio: Iz3DFloat3; stdcall;
    procedure SetHazeAmount(const Value: Single); stdcall;

    procedure UpdateSky; stdcall;

    procedure CreateSkyObjects; stdcall;

    procedure CreateLights; stdcall;
    procedure z3DFrameRender; override; stdcall;
    procedure z3DStartScenario(const AStage: Tz3DStartScenarioStage); override; stdcall;
    procedure Init(const AOwner: Iz3DBase); override; stdcall;
    procedure Cleanup; override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    // For Rayleigh sky approximation
    property HazeAmount: Single read GetHazeAmount write SetHazeAmount;
    property RayleighRatio: Iz3DFloat3 read GetRayleighRatio;

    // Auto update options
    property UpdateFog: Boolean read GetUpdateFog write SetUpdateFog;
    property UpdateAmbient: Boolean read GetUpdateAmbient write SetUpdateAmbient;


    property SunLight: Iz3DLight read GetSunLight;
    property MoonLight: Iz3DLight read GetMoonLight;

    property Time: Iz3DTimeOfDay read GetTime;

    property EnableSunLight: Boolean read GetEnableSunLight write SetEnableSunLight;
    property EnableMoonLight: Boolean read GetEnableMoonLight write SetEnableMoonLight;
  end;

{==============================================================================}
{== Sky controller interface                                                 ==}
{==============================================================================}
{== Controls the sky emulation by managing different sky types               ==}
{==============================================================================}

  Tz3DSkyController = class(Tz3DBase, Iz3DSkyController)
  private
    FShader: Iz3DShader;
    FSkies: IInterfaceList;
    FActiveSky: Integer;
  protected
    function GetShader: Iz3DShader; stdcall;
    function GetSkies(const AIndex: Integer): Iz3DSky; stdcall;
    function GetActiveSky: Iz3DSky; stdcall;
    procedure SetActiveSky(const Value: Iz3DSky); stdcall;
    function GetSkyCount: Integer; stdcall;
    procedure Init(const AOwner: Iz3DBase); override; stdcall;
    procedure Cleanup; override; stdcall;
  public
    function CreateSky: Iz3DSky; stdcall;
    function CreateEarthSky: Iz3DEarthSky; stdcall;
    procedure AddSky(const ASky: Iz3DSky); stdcall;
  public
    property ActiveSky: Iz3DSky read GetActiveSky write SetActiveSky;
    property SkyCount: Integer read GetSkyCount;
    property Skies[const AIndex: Integer]: Iz3DSky read GetSkies;
    property Shader: Iz3DShader read GetShader;
  end;





{==============================================================================}
{== Rope object                                                              ==}
{==============================================================================}
{== Creates a generic rope (cable, thread, etc.) in the scenario             ==}
{==============================================================================}

  Tz3DRope = class(Tz3DScenarioObject, Iz3DRope)
  private
    FPointA: Iz3DFloat3;
    FPointB: Iz3DFloat3;
    FLength: Single;
    FWidth: Single;
    FMaterial: Iz3DMaterial;
    FController: Iz3DRopeController;
  protected
    function GetLength: Single; stdcall;
    function GetMaterial: Iz3DMaterial; stdcall;
    function GetPointA: Iz3DFloat3; stdcall;
    function GetPointB: Iz3DFloat3; stdcall;
    function GetWidth: Single; stdcall;
    procedure SetLength(const Value: Single); stdcall;
    procedure SetWidth(const Value: Single); stdcall;
  public
    constructor Create(const AController: Iz3DRopeController);
    procedure Render(const AMaterials: Boolean = True; const ALighting: Boolean = True;
      const AShader: Iz3DShader = nil); override;
//    procedure Render(const AViewOrigin: Iz3DFloat3); stdcall;
  public
    property PointA: Iz3DFloat3 read GetPointA;
    property PointB: Iz3DFloat3 read GetPointB;
    property Length: Single read GetLength write SetLength;
    property Width: Single read GetWidth write SetWidth;
    property Material: Iz3DMaterial read GetMaterial;
  end;





{==============================================================================}
{== Rope controller                                                          ==}
{==============================================================================}
{== Manages a set of ropes with similar properties and shares a buffer       ==}
{==============================================================================}

  Tz3DRopeController = class(Tz3DLinked, Iz3DRopeController)
  private
    FSegments: Integer;
    FRopeBuffer: Iz3DVertexBuffer;
    FRopes: IInterfaceList;
  protected
    function GetRopeCount: Integer; stdcall;
    function GetRopes(const I: Integer): Iz3DRope; stdcall;
    function GetRopeBuffer: Iz3DVertexBuffer; stdcall;
    function GetSegments: Integer; stdcall;
    procedure SetSegments(const Value: Integer); stdcall;
    procedure z3DLightingRender; override; stdcall;
    procedure z3DDirectLightRender; override; stdcall;
    procedure z3DFrameRender; override; stdcall;
    procedure z3DFrameMove; override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    function CreateRope: Iz3DRope; stdcall;
    procedure RemoveRope(const ARope: Iz3DRope); stdcall;
    procedure RenderRopes(const AShader: Iz3DShader; const AUniform: Boolean = False); stdcall;
  public
    property Ropes[const I: Integer]: Iz3DRope read GetRopes;
    property RopeBuffer: Iz3DVertexBuffer read GetRopeBuffer;
    property RopeCount: Integer read GetRopeCount;
    property Segments: Integer read GetSegments write SetSegments;
  end;



  Tz3DAmbientSource = class(Tz3DScenarioEntity, Iz3DAmbientSource)
  private
    FColor: Iz3DFloat3;
    FCenter: Iz3DFloat3;
    FRange: Single;
  protected
    function GetCenter: Iz3DFloat3; stdcall;
    function GetColor: Iz3DFloat3; stdcall;
    function GetRange: Single; stdcall;
    procedure SetRange(const Value: Single); stdcall;
  public
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
  public
    property Center: Iz3DFloat3 read GetCenter;
    property Color: Iz3DFloat3 read GetColor;
    property Range: Single read GetRange write SetRange;
  end;



function z3DBallPointsToQuat(const AFrom, ATo: Iz3DFloat3): Iz3DFloat4; stdcall;

function z3DCreateArcBall: Iz3DArcBall; stdcall;

// Camera controller management

function z3DCreateCameraController: Iz3DCameraController; stdcall;
procedure z3DSetCustomCameraController(const AController: Iz3DCameraController); stdcall;
function z3DCameraController: Iz3DCameraController; stdcall;

// Sky controller management

function z3DSkyController: Iz3DSkyController; stdcall;
function z3DCreateSkyController: Iz3DSkyController; stdcall;
procedure z3DSetCustomSkyController(const AController: Iz3DSkyController); stdcall;

// Rope controller management (TEMP JP: HAY QUE VER COMO HACERLO MULTIPLE)

function z3DRopeController: Iz3DRopeController; stdcall;
function z3DCreateRopeController: Iz3DRopeController; stdcall;
procedure z3DSetCustomRopeController(const AController: Iz3DRopeController); stdcall;

// Ambient sources
function z3DCreateAmbientSource: Iz3DAmbientSource; stdcall;

implementation

uses z3DMath_Func, z3DEngine_Func, z3DCore_Intf, z3DCore_Func, Math,
  z3DComponents_Func, z3DLighting_Func, z3DEngine_Intf, z3DStrings,
  z3DInput_Func, z3DScenario_Func, SysUtils, z3DAudio_Func, z3DFileSystem_Func;

var GCameraController: Iz3DCameraController;

function z3DCreateArcBall: Iz3DArcBall;
begin
  Result:= Tz3DArcBall.Create;
end;

function z3DCreateCameraController: Iz3DCameraController;
begin
  GCameraController:= Tz3DCameraController.Create;
  Result:= GCameraController;
end;

procedure z3DSetCustomCameraController(const AController: Iz3DCameraController);
begin
  GCameraController:= AController;
end;

function z3DCameraController: Iz3DCameraController;
begin
  Result:= GCameraController;
end;

function z3DCreateAmbientSource: Iz3DAmbientSource;
begin
  Result:= Tz3DAmbientSource.Create;
end;


var GSkyController: Iz3DSkyController;

function z3DSkyController: Iz3DSkyController;
begin
  Result:= GSkyController;
end;

function z3DCreateSkyController: Iz3DSkyController;
begin
  GSkyController:= Tz3DSkyController.Create;
  Result:= GSkyController;
end;

procedure z3DSetCustomSkyController(const AController: Iz3DSkyController);
begin
  GSkyController:= AController;
end;



var GRopeController: Iz3DRopeController;

function z3DRopeController: Iz3DRopeController; stdcall;
begin
  Result:= GRopeController;
end;

function z3DCreateRopeController: Iz3DRopeController; stdcall;
begin
  GRopeController:= Tz3DRopeController.Create;
  Result:= GRopeController;
end;

procedure z3DSetCustomRopeController(const AController: Iz3DRopeController); stdcall;
begin
  GRopeController:= AController;
end;


function z3DBallPointsToQuat(const AFrom, ATo: Iz3DFloat3): Iz3DFloat4;
var FPart: Iz3DFloat3;
    FDot: Single;
begin
  FDot:= z3DFloat3.From(AFrom).Dot(ATo);
  FPart:= z3DFloat3.From(AFrom).Cross(ATo);
  Result:= z3DFloat4;
  Result.XYZ:= FPart.XYZ;
  Result.W:= FDot;
end;

{ Tz3DArcBall }

constructor Tz3DArcBall.Create;
var FRect: TRect;
begin
  inherited;
  Reset;
  FRotationMatrix:= z3DMatrix;
  FTranslationMatrix:= z3DMatrix;
  FTranslationMatrixDelta:= z3DMatrix;
  FDownPoint:= z3DFloat3;
  FCurrentPoint:= z3DFloat3;
  FDownQuat:= z3DFloat4;
  FCurrentQuat:= z3DFloat4;
  FOffset.x:= 0;
  FOffset.y:= 0;
  FRadius:= 0.9;
  GetClientRect(GetForegroundWindow, FRect);
  FWidth:= FRect.Right;
  FHeight:= FRect.Bottom;
end;

procedure Tz3DArcBall.Reset;
begin
  FDownQuat.Identity;
  FCurrentQuat.Identity;
  FRotationMatrix.Identity;
  FTranslationMatrix.Identity;
  FTranslationMatrixDelta.Identity;
  FDragging:= False;
  FTranslationRadius:= 1;
  FRadius:= 1;
end;

function Tz3DArcBall.ScreenToVector(const AScreenX, AScreenY: Single): Iz3DFloat3;
var FX, FY, FZ, FMag, FScale: Single;
begin
  FX:= -(AScreenX - FOffset.x - FWidth / 2)  / (FRadius * FWidth / 2);
  FY:=  (AScreenY - FOffset.y - FHeight / 2) / (FRadius * FHeight / 2);
  FZ:= 0;
  FMag:= FX*FX + FY*FY;
  if (FMag > 1) then
  begin
    FScale:= 1 / Sqrt(FMag);
    FX:= FX * FScale;
    FY:= FY * FScale;
  end else FZ:= Sqrt(1 - FMag);
  Result:= z3DFloat3(FX, FY, FZ);
end;

procedure Tz3DArcBall.OnBegin(AX, AY: Integer);
begin
  if (AX >= FOffset.x) and (AX < FOffset.x + FWidth) and
  (AY >= FOffset.y) and (AY < FOffset.y + FHeight) then
  begin
    FDragging:= True;
    FDownQuat:= FCurrentQuat;
    FDownPoint:= ScreenToVector(AX, AY);
  end;
end;

procedure Tz3DArcBall.OnMove(AX, AY: Integer);
begin
  if FDragging then
  begin
    FCurrentPoint:= ScreenToVector(AX, AY);
    FCurrentQuat.From(FDownQuat).Multiply(z3DBallPointsToQuat(FDownPoint, FCurrentPoint));
  end;
end;

procedure Tz3DArcBall.OnEnd;
begin
  FDragging:= False;
  FDownQuat:= FCurrentQuat;
end;

function Tz3DArcBall.HandleMessages(hWnd: HWND; uMsg: Cardinal; wParam: WPARAM; lParam: LPARAM): LRESULT;
var FMouseX: Integer;
    FMouseY: Integer;
    FDeltaX: Single;
    FDeltaY: Single;
begin
  FMouseX:= LOWORD(DWORD(lParam));
  FMouseY:= HIWORD(DWORD(lParam));
  Result:= iTrue;
  case uMsg of
    WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
    begin
      SetCapture(hWnd);
      OnBegin(FMouseX, FMouseY);
      Exit;
    end;
    WM_LBUTTONUP:
    begin
      ReleaseCapture;
      OnEnd;
      Exit;
    end;
    WM_CAPTURECHANGED:
    begin
      if (THandle(lParam) <> hWnd) then
      begin
        ReleaseCapture;
        OnEnd;
      end;
      Exit;
    end;
    WM_RBUTTONDOWN, WM_RBUTTONDBLCLK, WM_MBUTTONDOWN, WM_MBUTTONDBLCLK:
    begin
      SetCapture(hWnd);
      FLastMousePoint.x:= FMouseX;
      FLastMousePoint.y:= FMouseY;
      Exit;
    end;
    WM_RBUTTONUP, WM_MBUTTONUP:
    begin
      ReleaseCapture;
      Exit;
    end;
    WM_MOUSEMOVE:
    begin
      if (MK_LBUTTON and wParam <> 0) then OnMove(FMouseX, FMouseY) else
      if (MK_RBUTTON and wParam <> 0) or (MK_MBUTTON and wParam <> 0) then
      begin
        FDeltaX:= (FLastMousePoint.x-FMouseX) * FTranslationRadius / FWidth;
        FDeltaY:= (FLastMousePoint.y-FMouseY) * FTranslationRadius / FHeight;
        if (wParam and MK_RBUTTON <> 0) then
        begin
          FTranslationMatrixDelta.Translation(-2*FDeltaX, 2*FDeltaY, 0);
          FTranslationMatrix.Multiply(FTranslationMatrixDelta);
        end else
        begin
          FTranslationMatrixDelta.Translation(0, 0, 5*FDeltaY);
          FTranslationMatrix.Multiply(FTranslationMatrixDelta);
        end;
        FLastMousePoint.x:= FMouseX;
        FLastMousePoint.y:= FMouseY;
      end;
      Exit;
    end;
  end;
  Result:= iFalse;
end;

procedure Tz3DArcBall.HandleMessages(var Msg: TMsg; var Handled: Boolean);
begin
  Handled:= HandleMessages(Msg.hwnd, Msg.message, Msg.wParam, Msg.lParam) <> 0;
end;

function Tz3DArcBall.RotationMatrix: Iz3DMatrix;
begin
  Result:= FRotationMatrix.RotateQuat(FCurrentQuat.D3DQuat);
end;

function Tz3DArcBall.TranslationMatrix: Iz3DMatrix;
begin
  Result:= FTranslationMatrix;
end;

function Tz3DArcBall.TranslationDeltaMatrix: Iz3DMatrix;
begin
  Result:= FTranslationMatrixDelta;
end;

procedure Tz3DArcBall.SetHeight(const Value: Integer);
begin
  if FHeight <> Value then
  begin
    FHeight:= Value;
    FCenter.X:= FWidth / 2;
    FCenter.Y:= FHeight / 2;
  end;
end;

procedure Tz3DArcBall.SetWidth(const Value: Integer);
begin
  if FWidth <> Value then
  begin
    FWidth:= Value;
    FCenter.X:= FWidth / 2;
    FCenter.Y:= FHeight / 2;
  end;
end;

procedure Tz3DArcBall.SetOffset(const Value: TPoint);
begin
  FOffset.X:= Value.X;
  FOffset.Y:= Value.Y;
end;

function Tz3DArcBall.GetCurrentQuat: Iz3DFloat4;
begin
  Result:= FCurrentQuat;
end;

function Tz3DArcBall.GetDragging: Boolean;
begin
  Result:= FDragging;
end;

function Tz3DArcBall.GetHeight: Integer;
begin
  Result:= FHeight;
end;

function Tz3DArcBall.GetOffset: TPoint;
begin
  Result:= FOffset;
end;

function Tz3DArcBall.GetRadius: Single;
begin
  Result:= FRadius;
end;

function Tz3DArcBall.GetTranslationRadius: Single;
begin
  Result:= FTranslationRadius;
end;

function Tz3DArcBall.GetWidth: Integer;
begin
  Result:= FWidth;
end;

procedure Tz3DArcBall.SetRadius(const Value: Single);
begin
  FRadius:= Value;
end;

procedure Tz3DArcBall.SetTranslationRadius(const Value: Single);
begin
  FTranslationRadius:= Value;
end;

{ Tz3DBaseCamera }

constructor Tz3DBaseCamera.Create;
const FMin = (-2147483647-1);
      FMax = 2147483647;
begin
  inherited Create;

  // Link this object to all the events generated by the z3D Engine
  Notifications:= [z3dlnDevice, z3dlnFrameMove, z3dlnMessages, z3dlnKeyboard];

  FCameraKeys:= Tz3DCameraKeys.Create;
  FKeyDownCount:= 0;
  ZeroMemory(@FKeys, SizeOf(Byte)*DWORD(z3dckMaxKeys));
  ZeroMemory(@FGamePad, SizeOf(Tz3DGamePad)*INPUT_MAX_CONTROLLERS);
  FPosition:= z3DFloat3(0, 1, 0);
  FPosition.OnChange:= VectorChanged;
  FLookAt:= z3DFloat3(0, 1, 1);
  FLookAt.OnChange:= VectorChanged;
  FClipMin:= z3DFloat3;
  FClipMin.OnChange:= VectorChanged;
  FClipMax:= z3DFloat3;
  FClipMax.OnChange:= VectorChanged;
  FViewMatrix:= z3DMatrix;
  FProjectionMatrix:= z3DMatrix;
  GetCursorPos(FLastMousePosition);
  FMouseLButtonDown:= False;
  FMouseMButtonDown:= False;
  FMouseRButtonDown:= False;
  FCurrentButtonMask:= 0;
  FMouseWheelDelta:= 0;
  FZoom:= 100;
  FMaxZoom:= 1000;
  FMinZoom:= 50;
  FZoomFactor:= 1.05;
  FZoomMode:= z3dzmConstant;
  FActive:= True;
  FCameraYawAngle:= 0;
  FCameraPitchAngle:= 0;
  SetRect(FDragRect, FMin, FMin, FMax, FMax);
  FVelocity:= z3DFloat3;
  FSmoothMovement:= True;
  FSmoothFrameCount:= 2;
  FVelocityDrag:= z3DFloat3;
  FDragTimer:= 0;
  FTotalDragTime:= 0.25;
  FRotVelocity:= z3DFloat2;
  FRotationScale:= 0.01;
  FMoveScale:= 1;
  FInvertPitch:= False;
  FEnableYMovement:= True;
  FEnableMovement:= True;
  FMouseDelta:= z3DFloat2;
  FClipping:= False;
  FClipMin:= z3DFloat3(-1, -1, -1);
  FClipMax:= z3DFloat3(1, 1, 1);
end;

destructor Tz3DBaseCamera.Destroy;
begin
  FLookAt:= nil;
  FPosition:= nil;
  FClipMin:= nil;
  FClipMax:= nil;
  inherited;
end;

procedure Tz3DBaseCamera.UpdateProjection;
var FAspectRatio: Single;
begin
  if not z3DEngine.Options.LockAspectRatio then FAspectRatio:= 1 else
  FAspectRatio:= z3DCore_GetBackBufferSurfaceDesc.Width/z3DCore_GetBackBufferSurfaceDesc.Height;
  FProjectionMatrix.PerspectiveFOV(z3DPI / (FZoom * 0.04), FAspectRatio,
  z3DEngine.Scenario.ViewFrustum.NearClip, z3DEngine.Scenario.ViewFrustum.FarClip);
  z3DEngine.Scenario.ViewFrustum.ViewMatrix.From(FViewMatrix);
  z3DEngine.Scenario.ViewFrustum.ProjectionMatrix.From(FProjectionMatrix);
  z3DEngine.Scenario.ViewFrustum.ViewProjMatrix.From(FViewMatrix).Multiply(FProjectionMatrix);
  z3DEngine.Scenario.ViewFrustum.ApplyChanges(False, False, True);
end;

procedure Tz3DBaseCamera.UpdateViewParams;
var FInvView: Iz3DMatrix;
    FZBasis: Iz3DFloat3;
    FLen: Single;
begin
  FDefaultEye:= FPosition;
  FDefaultLookAt:= FLookAt;
  FViewMatrix.LookAt(FPosition, FLookAt);
  FInvView:= z3DMatrix.From(FViewMatrix).Inverse;
  FZBasis:= z3DFloat3(FInvView.e31, FInvView.e32, FInvView.e33);
  FCameraYawAngle:= ArcTan2(FZBasis.x, FZBasis.z);
  FLen:= Sqrt(FZBasis.z*FZBasis.z + FZBasis.x*FZBasis.x);
  FCameraPitchAngle:= -ArcTan2(FZBasis.y, FLen);
end;

procedure Tz3DBaseCamera.SetDragRect(const ARect: TRect);
begin
  FDragRect:= ARect;
end;

procedure Tz3DBaseCamera.SetScalers(const ARotationScaler: Single = 0.01; const AMoveScaler: Single = 5);
begin
  FRotationScale:= ARotationScaler;
  FMoveScale:= AMoveScaler;
end;

function Tz3DBaseCamera.ViewMatrix: Iz3DMatrix;
begin
  Result:= FViewMatrix;
end;

function Tz3DBaseCamera.ProjectionMatrix: Iz3DMatrix;
begin
  Result:= FProjectionMatrix;
end;

function Tz3DBaseCamera.GetDragging: Boolean;
begin
  Result:= FMouseLButtonDown or FMouseMButtonDown or FMouseRButtonDown;
end;

procedure Tz3DBaseCamera.z3DMessage(const AWnd: HWND; const AMsg: Cardinal; const AwParam: Integer; const AlParam: Integer;
  var ADefault: Boolean; var AResult: Integer);
var FMappedKey: Tz3DCameraInputKeys;
begin
  inherited;
  if not FActive then Exit;
  case AMsg of
    WM_KEYDOWN:
    begin
      FMappedKey:= MapKey(AwParam);
      if (FMappedKey <> z3dckUnknown) then
      if (not IsKeyDown(FKeys[FMappedKey])) then
      begin
        FKeys[FMappedKey]:= z3DcWasDownMask or z3DcIsDownMask;
        Inc(FKeyDownCount);
      end;
    end;
    WM_KEYUP:
    begin
      FMappedKey:= MapKey(AwParam);
      if (FMappedKey <> z3dckUnknown){TODO JP: VER QUE MIERDA ES ESTO: and (DWORD(FMappedKey) < 8) }then
      begin
        FKeys[FMappedKey]:= FKeys[FMappedKey] and not z3DcIsDownMask;
        Dec(FKeyDownCount);
      end;
    end;
    WM_RBUTTONDOWN, WM_MBUTTONDOWN, WM_LBUTTONDOWN, WM_RBUTTONDBLCLK,
    WM_MBUTTONDBLCLK, WM_LBUTTONDBLCLK:
    begin
      if (AMsg = WM_LBUTTONDOWN) or (AMsg = WM_RBUTTONDBLCLK) then
      begin
        FMouseLButtonDown:= True;
        FCurrentButtonMask:= FCurrentButtonMask or z3DcMouseLeftButton;
      end;
      if (AMsg = WM_MBUTTONDOWN) or (AMsg = WM_MBUTTONDBLCLK) then
      begin
        FMouseMButtonDown:= True;
        FCurrentButtonMask:= FCurrentButtonMask or z3DcMouseMiddleButton;
      end;
      if (AMsg = WM_RBUTTONDOWN) or (AMsg = WM_RBUTTONDBLCLK) then
      begin
        FMouseRButtonDown:= True;
        FCurrentButtonMask:= FCurrentButtonMask or z3DcMouseRightButton;
      end;
      SetCapture(AWnd);
      GetCursorPos(FLastMousePosition);
      AResult:= iTrue;
      Exit;
    end;
    WM_RBUTTONUP, WM_MBUTTONUP, WM_LBUTTONUP:
    begin
      if (AMsg = WM_LBUTTONUP) then
      begin
        FMouseLButtonDown:= False;
        FCurrentButtonMask:= FCurrentButtonMask and not z3DcMouseLeftButton;
      end;
      if (AMsg = WM_MBUTTONUP) then
      begin
        FMouseMButtonDown:= False;
        FCurrentButtonMask:= FCurrentButtonMask and not z3DcMouseMiddleButton;
      end;
      if (AMsg = WM_RBUTTONUP) then
      begin
        FMouseRButtonDown:= False;
        FCurrentButtonMask:= FCurrentButtonMask and not z3DcMouseRightButton;
      end;
      if (not FMouseLButtonDown  and not FMouseRButtonDown and not FMouseMButtonDown) then
      ReleaseCapture;
    end;
    WM_CAPTURECHANGED:
    begin
      if (THandle(AlParam) <> AWnd) then
      begin
        if (FCurrentButtonMask and z3DcMouseLeftButton <> 0) or (FCurrentButtonMask and
        z3DcMouseMiddleButton <> 0) or (FCurrentButtonMask and z3DcMouseRightButton <> 0) then
        begin
          FMouseLButtonDown:= False;
          FMouseMButtonDown:= False;
          FMouseRButtonDown:= False;
          FCurrentButtonMask:= FCurrentButtonMask and not z3DcMouseLeftButton;
          FCurrentButtonMask:= FCurrentButtonMask and not z3DcMouseMiddleButton;
          FCurrentButtonMask:= FCurrentButtonMask and not z3DcMouseRightButton;
          ReleaseCapture;
        end;
      end;
    end;
    WM_MOUSEWHEEL:
    FMouseWheelDelta:= Smallint(HIWORD(DWORD(AwParam))) div 120;
  end;
  AResult:= iFalse;
end;

procedure Tz3DBaseCamera.GetInput(const AGetKeyboardInput, AGetMouseInput, AGetGamepadInput, AResetCursorAfterMove: Boolean);
var FCurrentMouseDelta: TPoint;
    FCurrentMousePos: TPoint;
    FCenter: TPoint;
    FMonitor: Tz3DMonitorInfo;
    FPercentOfNew: Single;
    FPercentOfOld: Single;
    FUserIndex: DWORD;
    FMostRecentlyActive: Integer;
    FMostRecentlyActiveTime: Double;
begin
  FKeyboardDirection:= z3DFloat3;
  if AGetKeyboardInput then
  begin
    // Movement
    if IsKeyDown(FKeys[z3dckMoveForward]) then FKeyboardDirection.z:= FKeyboardDirection.z + 1;
    if IsKeyDown(FKeys[z3dckMoveBackward]) then FKeyboardDirection.z:= FKeyboardDirection.z - 1;
    if FEnableYMovement then
    begin
      if IsKeyDown(FKeys[z3dckMoveUp]) then FKeyboardDirection.y:= FKeyboardDirection.y + 1;
      if IsKeyDown(FKeys[z3dckMoveDown]) then FKeyboardDirection.y:= FKeyboardDirection.y - 1;
    end;

    // Strafe
    if IsKeyDown(FKeys[z3dckStrafeRight]) then FKeyboardDirection.x:= FKeyboardDirection.x + 1;
    if IsKeyDown(FKeys[z3dckStrafeLeft]) then FKeyboardDirection.x:= FKeyboardDirection.x - 1;

    // Jump
    if FEnableYMovement then
    if IsKeyDown(FKeys[z3dckJump]) then FKeyboardDirection.y:= FKeyboardDirection.y + 1.5;

    // Zoom in
    if IsKeyDown(FKeys[z3dckZoomIn]) and (Zoom < MaxZoom) then
    begin
      case ZoomMode of
        z3dzmConstant: Zoom:= Zoom + ZoomFactor;
        z3dzmLinear: Zoom:= Zoom * ZoomFactor;
        z3dzmExponential: Zoom:= Power(Zoom, ZoomFactor);
      end;
      if Zoom > MaxZoom then Zoom:= MaxZoom;
    end;

    // Zoom out
    if IsKeyDown(FKeys[z3dckZoomOUt]) and (Zoom > MinZoom) then
    begin
      case ZoomMode of
        z3dzmConstant: Zoom:= Zoom - ZoomFactor;
        z3dzmLinear: Zoom:= Zoom / ZoomFactor;
        z3dzmExponential: Zoom:= Power(Zoom, 1/ZoomFactor);
      end;
      if Zoom < MinZoom then Zoom:= MinZoom;
    end;

  end;
  if AGetMouseInput then
  begin
    if GetCursorPos(FCurrentMousePos) then
    begin
      FCurrentMouseDelta.x:= FCurrentMousePos.x - FLastMousePosition.x;
      FCurrentMouseDelta.y:= FCurrentMousePos.y - FLastMousePosition.y;
      FLastMousePosition:= FCurrentMousePos;
    end else
    begin
      FCurrentMouseDelta.x:= 0;
      FCurrentMouseDelta.y:= 0;
    end;
    if (AResetCursorAfterMove and z3DCore_IsActive) then
    begin
      FMonitor.cbSize:= SizeOf(TMonitorInfo);
      z3DGetMonitorInfo(z3DMonitorFromWindow(z3DCore_GetHWND, MONITOR_DEFAULTTONEAREST), FMonitor);
      FCenter.x:= (FMonitor.rcMonitor.left + FMonitor.rcMonitor.right) div 2;
      FCenter.y:= (FMonitor.rcMonitor.top + FMonitor.rcMonitor.bottom) div 2;
      SetCursorPos(FCenter.x, FCenter.y);
      FLastMousePosition:= FCenter;
    end;
    FPercentOfNew:=  1 / FSmoothFrameCount;
    FPercentOfOld:=  1 - FPercentOfNew;
    FMouseDelta.x:= FMouseDelta.x*FPercentOfOld + FCurrentMouseDelta.x*FPercentOfNew;
    FMouseDelta.y:= FMouseDelta.y*FPercentOfOld + FCurrentMouseDelta.y*FPercentOfNew;
  end;
  if AGetGamepadInput then
  begin
    FGamePadLeftThumb:= z3DFloat3;
    FGamePadRightThumb:= z3DFloat3;
    for FUserIndex:= 0 to INPUT_MAX_CONTROLLERS - 1 do
    begin
      z3DGetGamepadState(FUserIndex, FGamePad[FUserIndex], True, True);
      if ((FGamePad[FUserIndex].wButtons <> 0) or (FGamePad[FUserIndex].sThumbLX <> 0) or
      (FGamePad[FUserIndex].sThumbLX <> 0) or (FGamePad[FUserIndex].sThumbRX <> 0) or
      (FGamePad[FUserIndex].sThumbRY <> 0) or (FGamePad[FUserIndex].bLeftTrigger <> 0) or
      (FGamePad[FUserIndex].bRightTrigger <> 0)) then
      FGamePadLastActive[FUserIndex]:= z3DCore_GetTime;
    end;
    FMostRecentlyActive:= -1;
    FMostRecentlyActiveTime:= 0.0;
    for FUserIndex:= 0 to INPUT_MAX_CONTROLLERS - 1 do
    begin
      if (FGamePadLastActive[FUserIndex] > fMostRecentlyActiveTime) then
      begin
        FMostRecentlyActiveTime:= FGamePadLastActive[FUserIndex];
        FMostRecentlyActive:= FUserIndex;
      end;
    end;
    if (FMostRecentlyActive >= 0) and (FGamePad[FMostRecentlyActive].bConnected) then
    begin
      FGamePadLeftThumb.x:= FGamePad[FMostRecentlyActive].FThumbLX;
      FGamePadLeftThumb.y:= 0;
      FGamePadLeftThumb.z:= FGamePad[FMostRecentlyActive].FThumbLY;
      FGamePadRightThumb.x:= FGamePad[FMostRecentlyActive].FThumbRX;
      FGamePadRightThumb.y:= 0;
      FGamePadRightThumb.z:= FGamePad[FMostRecentlyActive].FThumbRY;
    end;
  end;
end;

procedure Tz3DBaseCamera.UpdateVelocity(const AElapsedTime: Single);
var FAcceleration: Iz3DFloat3;
    FParam1, FParam2: Iz3DFloat2;
begin
  FParam1:= z3DFloat2.From(FMouseDelta).Scale(FRotationScale);
  FParam2:= z3DFloat2.From(z3DFloat2(FGamePadRightThumb.x, -FGamePadRightThumb.z)).Scale(0.02);
  FRotVelocity:= z3DFloat2.From(FParam1).Add(FParam2);
  FAcceleration:= z3DFloat3.From(FKeyboardDirection).Add(FGamePadLeftThumb).Normalize.Scale(FMoveScale);
  if FSmoothMovement then
  begin
    if FAcceleration.LengthSq > 0 then
    begin
      FVelocity:= FAcceleration;
      FDragTimer:= FTotalDragTime;
      FVelocityDrag:= z3DFloat3.From(FAcceleration).Scale(1 / FDragTimer);
    end else
    begin
      if (FDragTimer > 0) then
      begin
        FVelocity.Subtract(z3DFloat3.From(FVelocityDrag).Scale(AElapsedTime));
        FDragTimer:= FDragTimer - AElapsedTime;
      end else FVelocity.Identity;
    end;
  end else FVelocity:= FAcceleration;
end;

function Tz3DBaseCamera.IsKeyDown(const AKey: Byte): Boolean;
begin
  Result:= ((AKey and z3dcIsDownMask) = z3dcIsDownMask);
end;

function Tz3DBaseCamera.WasKeyDown(const AKey: Byte): Boolean;
begin
  Result:= ((AKey and z3DcWasDownMask) = z3DcWasDownMask);
end;

procedure Tz3DBaseCamera.ConstrainToBoundary(var AVector: Iz3DFloat3);
begin
  AVector.x:= Max(AVector.x, FClipMin.x);
  AVector.y:= Max(AVector.y, FClipMin.y);
  AVector.z:= Max(AVector.z, FClipMin.z);
  AVector.x:= Min(AVector.x, FClipMax.x);
  AVector.y:= Min(AVector.y, FClipMax.y);
  AVector.z:= Min(AVector.z, FClipMax.z);
end;

function Tz3DBaseCamera.MapKey(const AKey: LongWord): Tz3DCameraInputKeys;
begin
  Result:= z3dckUnknown;
  if FCameraKeys.EnableDefaultKeys then
  begin
    case AKey of
      VK_CONTROL: Result:= z3dckControlDown;
      VK_LEFT:    Result:= z3dckStrafeLeft;
      VK_RIGHT:   Result:= z3dckStrafeRight;
      VK_UP:      Result:= z3dckMoveForward;
      VK_DOWN:    Result:= z3dckMoveBackward;
      VK_PRIOR:   Result:= z3dckMoveUp;
      VK_NEXT:    Result:= z3dckMoveDown;
      VK_NUMPAD4: Result:= z3dckStrafeLeft;
      VK_NUMPAD6: Result:= z3dckStrafeRight;
      VK_NUMPAD8: Result:= z3dckMoveForward;
      VK_NUMPAD2: Result:= z3dckMoveBackward;
      VK_NUMPAD9: Result:= z3dckMoveUp;
      VK_NUMPAD3: Result:= z3dckMoveDown;
      VK_HOME:    Result:= z3dckReset;
    end;
  end;
  if AKey = Ord(FCameraKeys.MoveLeft) then Result:= z3dckStrafeLeft else
  if AKey = Ord(FCameraKeys.MoveRight) then Result:= z3dckStrafeRight else
  if AKey = Ord(FCameraKeys.MoveForward) then Result:= z3dckMoveForward else
  if AKey = Ord(FCameraKeys.MoveBackward) then Result:= z3dckMoveBackward else
  // TODO JP: SALTAR
  if AKey = VK_SPACE then Result:= z3dckJump else
  if AKey = Ord(FCameraKeys.ZoomIn) then Result:= z3dckZoomIn else
  if AKey = Ord(FCameraKeys.ZoomOut) then Result:= z3dckZoomOut else
  if AKey = Ord(FCameraKeys.MoveUp) then Result:= z3dckMoveUp else
  if AKey = Ord(FCameraKeys.MoveDown) then Result:= z3dckMoveDown;
end;

procedure Tz3DBaseCamera.z3DFrameMove;
var FAspectRatio: Single;
begin
  inherited;
  if not Active or not z3DEngine.Scenario.Enabled or z3DEngine.Desktop.Visible then Exit;
  z3DScenario.ViewFrustum.Position.From(Position);
  z3DScenario.ViewFrustum.LookAt.From(LookAt);
  z3DScenario.ViewFrustum.FieldOfView:= z3DPI / (FZoom * 0.04);
  if not z3DEngine.Options.LockAspectRatio then FAspectRatio:= 1 else
  FAspectRatio:= z3DCore_GetBackBufferSurfaceDesc.Width/z3DCore_GetBackBufferSurfaceDesc.Height;
  z3DScenario.ViewFrustum.AspectRatio:= FAspectRatio;

  // TODO JP: ESTO GENERA OTRO CALCULO DE VIEWMATRIX CUANDO YA LA TENEMOS EN LA CAMARA
  z3DScenario.ViewFrustum.ApplyChanges;
end;

procedure Tz3DBaseCamera.z3DResetDevice;
begin
  inherited;
  UpdateProjection;
end;

procedure Tz3DBaseCamera.SetZoom(const Value: Single);
begin
  if FZoom <> Value then
  begin
    FZoom:= Value;
    if z3DCore_GetState.DeviceCreated then UpdateProjection;
  end;
end;

function Tz3DBaseCamera.GetClipMax: Iz3DFloat3;
begin
  Result:= FClipMax;
end;

function Tz3DBaseCamera.GetClipMin: Iz3DFloat3;
begin
  Result:= FClipMin;
end;

function Tz3DBaseCamera.GetClipping: Boolean;
begin
  Result:= FClipping;
end;

function Tz3DBaseCamera.GetDragRect: TRect;
begin
  Result:= FDragRect;
end;

function Tz3DBaseCamera.GetActive: Boolean;
begin
  Result:= FActive;
end;

function Tz3DBaseCamera.GetEnableMovement: Boolean;
begin
  Result:= FEnableMovement;
end;

function Tz3DBaseCamera.GetEnableYMovement: Boolean;
begin
  Result:= FEnableYMovement;
end;

function Tz3DBaseCamera.GetInvertPitch: Boolean;
begin
  Result:= FInvertPitch;
end;

function Tz3DBaseCamera.GetLookAt: Iz3DFloat3;
begin
  Result:= FLookAt;
end;

function Tz3DBaseCamera.GetMouseLButtonDown: Boolean;
begin
  Result:= FMouseLButtonDown;
end;

function Tz3DBaseCamera.GetMouseMButtonDown: Boolean;
begin
  Result:= FMouseMButtonDown;
end;

function Tz3DBaseCamera.GetMouseRButtonDown: Boolean;
begin
  Result:= FMouseRButtonDown;
end;

function Tz3DBaseCamera.GetMoveScale: Single;
begin
  Result:= FMoveScale;
end;

function Tz3DBaseCamera.GetPosition: Iz3DFloat3;
begin
  Result:= FPosition;
end;

function Tz3DBaseCamera.GetSmoothFrameCount: Integer;
begin
  Result:= FSmoothFrameCount;
end;

function Tz3DBaseCamera.GetSmoothMovement: Boolean;
begin
  Result:= FSmoothMovement;
end;

function Tz3DBaseCamera.GetTotalDragTime: Single;
begin
  Result:= FTotalDragTime;
end;

procedure Tz3DBaseCamera.SetClipping(const Value: Boolean);
begin
  FClipping:= Value;
end;

procedure Tz3DBaseCamera.SetActive(const Value: Boolean);
begin
  FActive:= Value;
end;

procedure Tz3DBaseCamera.SetEnableMovement(const Value: Boolean);
begin
  FEnableMovement:= Value;
end;

procedure Tz3DBaseCamera.SetEnableYMovement(const Value: Boolean);
begin
  FEnableYMovement:= value;
end;

procedure Tz3DBaseCamera.SetInvertPitch(const Value: Boolean);
begin
  FInvertPitch:= value;
end;

procedure Tz3DBaseCamera.SetMoveScale(const Value: Single);
begin
  FMoveScale:= Value;
end;

procedure Tz3DBaseCamera.SetSmoothFrameCount(const Value: Integer);
begin
  FSmoothFrameCount:= Value;
end;

procedure Tz3DBaseCamera.SetSmoothMovement(const Value: Boolean);
begin
  FSmoothMovement:= Value;
end;

procedure Tz3DBaseCamera.SetTotalDragTime(const Value: Single);
begin
  FTotalDragTime:= value;
end;

function Tz3DBaseCamera.GetZoom: Single;
begin
  Result:= FZoom;
end;

function Tz3DBaseCamera.GetKeys: Iz3DCameraKeys;
begin
  Result:= FCameraKeys;
end;

procedure Tz3DBaseCamera.VectorChanged(const ASender: Iz3DBase);
begin
  UpdateViewParams;
end;

function Tz3DBaseCamera.GetMaxZoom: Single;
begin
  Result:= FMaxZoom;
end;

function Tz3DBaseCamera.GetMinZoom: Single;
begin
  Result:= FMinZoom;
end;

function Tz3DBaseCamera.GetZoomMode: Tz3DZoomMode;
begin
  Result:= FZoomMode;
end;

procedure Tz3DBaseCamera.SetMaxZoom(const Value: Single);
begin
  FMaxZoom:= Value;
end;

procedure Tz3DBaseCamera.SetMinZoom(const Value: Single);
begin
  FMinZoom:= Value;
end;

procedure Tz3DBaseCamera.SetZoomMode(const Value: Tz3DZoomMode);
begin
  FZoomMode:= Value;
end;

function Tz3DBaseCamera.GetZoomFactor: Single;
begin
  Result:= FZoomFactor;
end;

procedure Tz3DBaseCamera.SetZoomFactor(const Value: Single);
begin
  FZoomFactor:= Value;
end;

{ Tz3DBaseCameraMouseButtons }

constructor Tz3DBaseCameraMouseButtons.Create;
begin
  inherited;
  FRotateObject:= z3DmbLeft;
  FZoom:= z3DmbWheel;
  FRotateCamera:= z3DmbRight;
end;

function Tz3DBaseCameraMouseButtons.GetRotateCamera: Tz3DMouseButton;
begin
  Result:= FRotateCamera;
end;

function Tz3DBaseCameraMouseButtons.GetRotateObject: Tz3DMouseButton;
begin
  Result:= FRotateObject;
end;

function Tz3DBaseCameraMouseButtons.GetZoom: Tz3DMouseButton;
begin
  Result:= FZoom;
end;

procedure Tz3DBaseCameraMouseButtons.SetRotateCamera(const Value: Tz3DMouseButton);
begin
  if FRotateCamera <> Value then
  begin
    FRotateCamera:= Value;
  end;
end;

procedure Tz3DBaseCameraMouseButtons.SetRotateObject(const Value: Tz3DMouseButton);
begin
  if FRotateObject <> Value then
  begin
    FRotateObject:= Value;
  end;
end;

procedure Tz3DBaseCameraMouseButtons.SetZoom(const Value: Tz3DMouseButton);
begin
  if FZoom <> Value then
  begin
    FZoom:= Value;
  end;
end;

{ Tz3DObjectCamera }

constructor Tz3DObjectCamera.Create;
begin
  FWorldArcBall:= Tz3DArcBall.Create;
  FViewArcBall:= Tz3DArcBall.Create;
  inherited Create;
  FWorldUp:= z3DFloat3;
  FWorldAhead:= z3DFloat3;
  FEnableMovement:= False;
  FMouseButtons:= Tz3DBaseCameraMouseButtons.Create;
  FWorldMatrix:= z3DMatrixIdentity;
  FObjectRot:= z3DMatrixIdentity;
  FObjectLastRot:= z3DMatrixIdentity;
  FCameraRotLast:= z3DMatrixIdentity;
  FRadius:= 5;
  FDefaultRadius:= 5;
  FMinRadius:= 1;
  FMaxRadius:= 3.402823466e+38;
  FLimitPitch:= True;
  FAttached:= False;
  FDragSinceLastUpdate:= True;
end;

destructor Tz3DObjectCamera.Destroy;
begin
  FMouseButtons:= nil;
  FWorldArcBall:= nil;
  FViewArcBall:= nil;
  inherited Destroy;
end;

procedure Tz3DObjectCamera.z3DFrameMove;
var FPosDelta: Iz3DFloat3;
    FCameraRot: Iz3DMatrix;
    FPosDeltaWorld: Iz3DFloat3;
    FInvView: Iz3DMatrix;
    FObjectLastRotInv: Iz3DMatrix;
    FObjectRot: Iz3DMatrix;
    FXBasis: Iz3DFloat3;
    FYBasis: Iz3DFloat3;
    FZBasis: Iz3DFloat3;
    FTrans: Iz3DMatrix;
begin
  if not Active or not z3DEngine.Scenario.Enabled or z3DEngine.Desktop.Visible then Exit;
  if IsKeyDown(FKeys[z3dckReset]) then z3DResetDevice;
  if (not FDragSinceLastUpdate) and (FKeyDownCount = 0) then Exit;
  FDragSinceLastUpdate:= False;
  GetInput(FEnableMovement, FCurrentButtonMask <> 0, True, False);
  UpdateVelocity(z3DCore_GetElapsedTime);
  FPosDelta:= z3DFloat3.From(FVelocity).Scale(z3DCore_GetElapsedTime);
  if (FMouseWheelDelta <> 0) and (FZoomButtonMask = z3DcMouseWheel) then
  FRadius:= FRadius - FMouseWheelDelta * FRadius * 0.1;
  FRadius:= Min(FMaxRadius, FRadius);
  FRadius:= Max(FMinRadius, FRadius);
  FMouseWheelDelta:= 0;
  FCameraRot:= z3DMatrix.From(FViewArcBall.RotationMatrix).Inverse;
  FWorldUp.From(D3DXVector3(0, 1, 0)).TransformC(FCameraRot);
  FWorldAhead.From(D3DXVector3(0, 0, 1)).TransformC(FCameraRot);
  FPosDeltaWorld:= z3DFloat3.From(FPosDelta).TransformC(FCameraRot);
  FLookAt.BeginInternalChange;
  FLookAt.Add(FPosDeltaWorld);
  if FClipping then ConstrainToBoundary(FLookAt);
  FLookAt.EndInternalChange;
  FPosition.BeginInternalChange;
  FPosition.From(FLookAt).Subtract(z3DFloat3.From(FWorldAhead).Scale(FRadius));
  FPosition.EndInternalChange;
  FViewMatrix.LookAt(FPosition, FLookAt, FWorldUp);
  FInvView:= z3DMatrix.From(FViewMatrix).Inverse;
  FInvView.e41:= 0;
  FInvView.e42:= 0;
  FInvView.e43:= 0;
  FObjectLastRotInv:= z3DMatrix.From(FObjectLastRot).Inverse;
  FObjectRot:= FWorldArcBall.RotationMatrix;
  FObjectRot.Multiply(z3DMatrix.From(FObjectRot).Multiply(FInvView).Multiply(FObjectLastRotInv).Multiply(FViewMatrix));
  if (FViewArcBall.Dragging and FAttached and not IsKeyDown(FKeys[z3dckControlDown]) ) then
    FObjectRot.Multiply(z3DMatrix.From(FCameraRotLast).Inverse.Multiply(FCameraRot));
  FCameraRotLast:= FCameraRot;
  FObjectLastRot:= FObjectRot;
  FXBasis:= z3DFloat3(FObjectRot.e11, FObjectRot.e12, FObjectRot.e13).Normalize;
  FYBasis:= z3DFloat3(FObjectRot.e21, FObjectRot.e22, FObjectRot.e23);
  FZBasis:= z3DFloat3(FObjectRot.e31, FObjectRot.e32, FObjectRot.e33);
  FYBasis.From(FZBasis).Cross(FXBasis).Normalize;
  FZBasis.From(FXBasis).Cross(FYBasis);
  FObjectRot.e41:= FLookAt.x;
  FObjectRot.e42:= FLookAt.y;
  FObjectRot.e43:= FLookAt.z;
  FTrans:= z3DMatrix.Translation(-FObject.BoundingBox.Center.x, -FObject.BoundingBox.Center.y, -FObject.BoundingBox.Center.z);
  FWorldMatrix:= z3DMatrix.From(FTrans).Multiply(FObjectRot);
  z3DScenario.ViewFrustum.UpVector.From(WorldUp);
  inherited;
end;

procedure Tz3DObjectCamera.SetDragRect(const ARect: TRect);
begin
  inherited SetDragRect(ARect);
  FWorldArcBall.SetOffset(Point(ARect.Left, ARect.Top));
  FViewArcBall.SetOffset(Point(ARect.Left, ARect.Top));
  SetWindow(ARect.Right - ARect.Left, ARect.Bottom - ARect.Top);
end;

procedure Tz3DObjectCamera.z3DResetDevice;
begin
  inherited;
  SetWindow(z3DCore_GetBackBufferSurfaceDesc^.Width, z3DCore_GetBackBufferSurfaceDesc^.Height);
  FWorldMatrix.Identity;
  FRadius:= FDefaultRadius;
  FWorldArcBall.Reset;
  FViewArcBall.Reset;
  FDragSinceLastUpdate:= True;
  SetButtonMasks(Cz3DCameraMouseButton[FMouseButtons.RotateObject],
  Cz3DCameraMouseButton[FMouseButtons.Zoom], Cz3DCameraMouseButton[FMouseButtons.RotateCamera]);
end;

procedure Tz3DObjectCamera.UpdateViewParams;
var FRotation: Iz3DMatrix;
begin
  inherited;
  FRotation:= z3DMatrix.LookAt(FPosition, FLookAt);
  FViewArcBall.CurrentQuat.RotationMatrix(FRotation);
  SetRadius(z3DFloat3.From(FLookAt).Subtract(FPosition).Length);
  FDragSinceLastUpdate:= True;
end;

procedure Tz3DObjectCamera.z3DMessage(const AWnd: HWND; const AMsg: Cardinal; const AwParam: Integer; const AlParam: Integer;
  var ADefault: Boolean; var AResult: Integer);
var FMouseX: Integer;
    FMouseY: Integer;
begin
  inherited;
  if (((AMsg = WM_LBUTTONDOWN) or (AMsg = WM_LBUTTONDBLCLK)) and (FRotateObjectButtonMask and z3DcMouseLeftButton <> 0)) or
  (((AMsg = WM_MBUTTONDOWN) or (AMsg = WM_MBUTTONDBLCLK)) and (FRotateObjectButtonMask and z3DcMouseMiddleButton <> 0)) or
  (((AMsg = WM_RBUTTONDOWN) or (AMsg = WM_RBUTTONDBLCLK)) and (FRotateObjectButtonMask and z3DcMouseRightButton <> 0)) then
  begin
    FMouseX:= LOWORD(DWORD(AlParam));
    FMouseY:= HIWORD(DWORD(AlParam));
    FWorldArcBall.OnBegin(FMouseX, FMouseY);
  end;
  if (((AMsg = WM_LBUTTONDOWN) or (AMsg = WM_LBUTTONDBLCLK)) and (FRotateCameraButtonMask and z3DcMouseLeftButton <> 0)) or
  (((AMsg = WM_MBUTTONDOWN) or (AMsg = WM_MBUTTONDBLCLK)) and (FRotateCameraButtonMask and z3DcMouseMiddleButton <> 0)) or
  (((AMsg = WM_RBUTTONDOWN) or (AMsg = WM_RBUTTONDBLCLK)) and (FRotateCameraButtonMask and z3DcMouseRightButton <> 0)) then
  begin
    FMouseX:= LOWORD(DWORD(AlParam));
    FMouseY:= HIWORD(DWORD(AlParam));
    FViewArcBall.OnBegin(FMouseX, FMouseY);
  end;
  if (AMsg = WM_MOUSEMOVE) then
  begin
    FMouseX:= LOWORD(DWORD(AlParam));
    FMouseY:= HIWORD(DWORD(AlParam));
    FWorldArcBall.OnMove(FMouseX, FMouseY);
    FViewArcBall.OnMove(FMouseX, FMouseY);
  end;
  if ((AMsg = WM_LBUTTONUP) and (FRotateObjectButtonMask and z3DcMouseLeftButton <> 0)) or
  ((AMsg = WM_MBUTTONUP) and (FRotateObjectButtonMask and z3DcMouseMiddleButton <> 0)) or
  ((AMsg = WM_RBUTTONUP) and (FRotateObjectButtonMask and z3DcMouseRightButton <> 0)) then
  FWorldArcBall.OnEnd;
  if ((AMsg = WM_LBUTTONUP) and (FRotateCameraButtonMask and z3DcMouseLeftButton <> 0)) or
  ((AMsg = WM_MBUTTONUP) and (FRotateCameraButtonMask and z3DcMouseMiddleButton <> 0)) or
  ((AMsg = WM_RBUTTONUP) and (FRotateCameraButtonMask and z3DcMouseRightButton <> 0)) then
  FViewArcBall.OnEnd;
  if (AMsg = WM_CAPTURECHANGED) and (THandle(AlParam) <> AWnd) then
  begin
    if (FRotateObjectButtonMask and z3DcMouseLeftButton <> 0) or
    (FRotateObjectButtonMask and z3DcMouseMiddleButton <> 0) or
    (FRotateObjectButtonMask and z3DcMouseRightButton <> 0) then
    FWorldArcBall.OnEnd;
    if (FRotateCameraButtonMask and z3DcMouseLeftButton <> 0) or
    (FRotateCameraButtonMask and z3DcMouseMiddleButton <> 0) or
    (FRotateCameraButtonMask and z3DcMouseRightButton <> 0) then
    FViewArcBall.OnEnd;
  end;
  if (AMsg = WM_LBUTTONDOWN) or (AMsg = WM_LBUTTONDBLCLK) or (AMsg = WM_MBUTTONDOWN) or
  (AMsg = WM_MBUTTONDBLCLK) or (AMsg = WM_RBUTTONDOWN) or (AMsg = WM_RBUTTONDBLCLK) or
  (AMsg = WM_LBUTTONUP) or (AMsg = WM_MBUTTONUP) or (AMsg = WM_RBUTTONUP) or
  (AMsg = WM_MOUSEWHEEL) or (AMsg = WM_MOUSEMOVE) then FDragSinceLastUpdate:= True;
  AResult:= iFalse;
end;

procedure Tz3DObjectCamera.SetButtonMasks(const ARotateObjectButtonMask: Integer = z3DcMouseLeftButton;
  const AZoomButtonMask: Integer = z3DcMouseWheel; const ARotateCameraButtonMask: Integer = z3DcMouseRightButton);
begin
  FRotateObjectButtonMask:= ARotateObjectButtonMask;
  FZoomButtonMask:= AZoomButtonMask;
  FRotateCameraButtonMask:= ARotateCameraButtonMask;
end;

procedure Tz3DObjectCamera.SetWindow(const AWidth, AHeight: Integer; const AArcballRadius: Single = 0.9);
begin
  FWorldArcBall.Width:= AWidth;
  FWorldArcBall.Height:= AHeight;
  FWorldArcBall.Radius:= AArcballRadius;
  FViewArcBall.Width:= AWidth;
  FViewArcBall.Height:= AHeight;
  FViewArcBall.Radius:= AArcballRadius;
end;

function Tz3DObjectCamera.GetWorldMatrix: Iz3DMatrix;
begin
  Result:= FWorldMatrix;
end;

function Tz3DObjectCamera.ObjectMatrix: Iz3DMatrix;
begin
  Result:= FWorldMatrix;
end;

procedure Tz3DObjectCamera.SetObject(const AObject: Iz3DScenarioObject);
begin
  FLookAt:= AObject.BoundingBox.Center;
end;

procedure Tz3DObjectCamera.SetWorldMatrix(const AMatrix: Iz3DMatrix);
begin
  FWorldMatrix:= AMatrix;
  FDragSinceLastUpdate:= True;
end;

procedure Tz3DObjectCamera.SetMaxRadius(const Value: Single);
begin
  if FMaxRadius <> Value then
  begin
    FMaxRadius := Value;
    FDragSinceLastUpdate:= True;
  end;
end;

procedure Tz3DObjectCamera.SetMinRadius(const Value: Single);
begin
  if FMinRadius <> Value then
  begin
    FMinRadius := Value;
    FDragSinceLastUpdate:= True;
  end;
end;

procedure Tz3DObjectCamera.SetRadius(const Value: Single);
begin
  if FRadius <> Value then
  begin
    FRadius := Value;
    FDragSinceLastUpdate:= True;
  end;
end;

function Tz3DObjectCamera.GetMouseButtons: Iz3DObjectCameraMouseButtons;
begin
  Result:= FMouseButtons;
end;

function Tz3DObjectCamera.GetAttached: Boolean;
begin
  Result:= FAttached;
end;

function Tz3DObjectCamera.GetLimitPitch: Boolean;
begin
  Result:= FLimitPitch;
end;

function Tz3DObjectCamera.GetMaxRadius: Single;
begin
  Result:= FMaxRadius;
end;

function Tz3DObjectCamera.GetMinRadius: Single;
begin
  Result:= FMinRadius;
end;

function Tz3DObjectCamera.GetRadius: Single;
begin
  Result:= FRadius;
end;

procedure Tz3DObjectCamera.SetAttached(const Value: Boolean);
begin
  FAttached:= Value;
end;

procedure Tz3DObjectCamera.SetLimitPitch(const Value: Boolean);
begin
  FLimitPitch:= Value;
end;

function Tz3DObjectCamera.GetWorldAhead: Iz3DFloat3;
begin
  Result:= FWorldAhead;
end;

function Tz3DObjectCamera.GetWorldUp: Iz3DFloat3;
begin
  Result:= FWorldUp;
end;

{ Tz3DFirstPersonCameraRotateButtons }

constructor Tz3DFirstPersonCameraRotateButtons.Create(const AOwner: Iz3DFirstPersonCamera);
begin
  inherited Create;
  FOwner:= AOwner;
  FLeft:= False;
  FMiddle:= False;
  FRight:= False;
  FIgnoreButtons:= True;
end;

function Tz3DFirstPersonCameraRotateButtons.GetIgnoreButtons: Boolean;
begin
  Result:= FIgnoreButtons;
end;

function Tz3DFirstPersonCameraRotateButtons.GetLeft: Boolean;
begin
  Result:= FLeft;
end;

function Tz3DFirstPersonCameraRotateButtons.GetMiddle: Boolean;
begin
  Result:= FMiddle;
end;

function Tz3DFirstPersonCameraRotateButtons.GetRight: Boolean;
begin
  Result:= FRight;
end;

procedure Tz3DFirstPersonCameraRotateButtons.SetIgnoreButtons(const Value: Boolean);
begin
  FIgnoreButtons:= Value;
end;

procedure Tz3DFirstPersonCameraRotateButtons.SetLeft(const Value: Boolean);
begin
  FLeft:= Value;
  FOwner.SetButtons(FLeft, FMiddle, FRight);
end;

procedure Tz3DFirstPersonCameraRotateButtons.SetMiddle(const Value: Boolean);
begin
  FMiddle:= Value;
  FOwner.SetButtons(FLeft, FMiddle, FRight);
end;

procedure Tz3DFirstPersonCameraRotateButtons.SetRight(const Value: Boolean);
begin
  FRight:= Value;
  FOwner.SetButtons(FLeft, FMiddle, FRight);
end;

{ Tz3DFirstPersonCamera }

constructor Tz3DFirstPersonCamera.Create;
begin
  inherited Create;
  FResetCursorAfterMove:= True;
  FRotateButtons:= Tz3DFirstPersonCameraRotateButtons.Create(Self);
  FActiveButtonMask:= $07;
  FEnableFlashLight:= True;


  FBoundingBox:= z3DBoundingBox;
  FBoundingBox.Dimensions.X:= 0.50;
  FBoundingBox.Dimensions.Y:= 1.7;
  FBoundingBox.Dimensions.Z:= 0.40;
  FBoundingSphere:= z3DBoundingSphere;
  FBoundingSphere.Radius:= 0.85;
  FSubset:= Tz3DScenarioObjectSubset.Create(Self);
  if FSubset.Material <> nil then
  begin
    FSubset.Material.Density:= 0.5;
    FSubset.Material.Elasticity:= 0;
    FSubset.Material.Roughness:= 0.5;
  end;
  FSWOAcceleration:= z3DFloat3;
  FSWOVelocity:= z3DFloat3;
  FGround:= False;

end;

destructor Tz3DFirstPersonCamera.Destroy;
begin
  FRotateButtons:= nil;
  inherited;
end;

procedure Tz3DFirstPersonCamera.z3DFrameMove;
var FPosDelta: Iz3DFloat3;
    FYawDelta: Single;
    FPitchDelta: Single;
    FCameraRot, FInvOffsetView: Iz3DMatrix;
    FWorldUp, FWorldAhead: Iz3DFloat3;
    FPosDeltaWorld: Iz3DFloat3;
    FOffset: Iz3DFloat3;
    FNormalLookAt: Iz3DFloat3;
    AElapsedTime: Single;
begin
  if not Active or not z3DEngine.Scenario.Enabled or z3DEngine.Desktop.Visible then Exit;
  AElapsedTime:= z3DCore_GetElapsedTime;
  if z3DCore_GetGlobalTimer.IsStopped then AElapsedTime:= 1.0 / z3DCore_GetFPS;
  if IsKeyDown(FKeys[z3dckReset]) then z3DResetDevice;
  GetInput(FEnableMovement, (FActiveButtonMask and FCurrentButtonMask <> 0) or
  FRotateButtons.IgnoreButtons, True, FResetCursorAfterMove);
  UpdateVelocity(AElapsedTime);
  FPosDelta:= z3DFloat3.From(FVelocity).Scale(AElapsedTime);
  if (FActiveButtonMask and FCurrentButtonMask <> 0) or (FRotateButtons.IgnoreButtons) or
  (FGamePadRightThumb.x <> 0) or (FGamePadRightThumb.z <> 0) then
  begin
    FYawDelta:= FRotVelocity.x;
    FPitchDelta:= FRotVelocity.y;
    if (FInvertPitch) then FPitchDelta:= - FPitchDelta;
    FCameraPitchAngle:= FCameraPitchAngle + FPitchDelta;
    FCameraYawAngle:= FCameraYawAngle + FYawDelta;
    FCameraPitchAngle:= Max(-z3DPI / 2, FCameraPitchAngle);
    FCameraPitchAngle:= Min(+z3DPI / 2, FCameraPitchAngle);
  end;
  FCameraRot:= z3DMatrix.RotateYPR(FCameraYawAngle, FCameraPitchAngle, 0);
  FWorldUp:= z3DFloat3(0, 1, 0).TransformC(FCameraRot);
  FWorldAhead:= z3DFloat3(0, 0, 1).TransformC(FCameraRot);
  if not FEnableYMovement then FCameraRot.RotateYPR(FCameraYawAngle, 0, 0);
  FPosDeltaWorld:= z3DFloat3.From(FPosDelta).TransformC(FCameraRot);
  FPosition.BeginInternalChange;
  FPosition.Add(FPosDeltaWorld);
  FPosition.EndInternalChange;
  if FClipping then ConstrainToBoundary(FPosition);
  FLookAt.BeginInternalChange;
  FLookAt.From(FPosition).Add(FWorldAhead);
  FLookAt.EndInternalChange;
  FViewMatrix.LookAt(FPosition, FLookAt, FWorldUp);
  if FEnableFlashLight and (FFlashLight <> nil) then
  begin
    FFlashLight.Frustum.Position.From(FPosition).Add(z3DFloat3(0.1, -0.25, 0.15));
    FFlashLight.Frustum.LookAt.From(FLookAt).Subtract(FPosition).Normalize;
  end;
  if Assigned(FObject) then
  begin
    // Angle
    FNormalLookAt:= z3DFloat3.From(FLookAt).Subtract(FPosition);
    if FNormalLookAt.Z >= 0 then
{TODO JP    FObject.Angle.Y:= RadToDeg(ArcCos(FViewMatrix.e31) + D3DX_PI / 2) else
    FObject.Angle.Y:= RadToDeg(-ArcCos(FViewMatrix.e31) + D3DX_PI / 2);
    FObject.Angle.X:= RadToDeg(ArcSin(FViewMatrix.e23));}
    // Position
    FInvOffsetView:= z3DMatrix.Inverse(FViewMatrix);
    FInvOffsetView.e41:= 0;
    FInvOffsetView.e42:= 0;
    FInvOffsetView.e43:= 0;
    FOffset:= z3DFloat3(0.01, -1.44, -0.1).TransformC(FInvOffsetView);
    FObject.BoundingBox.Center.X:= FPosition.X+FOffset.X;
    FObject.BoundingBox.Center.Y:= FPosition.Y+FOffset.Y;
    FObject.BoundingBox.Center.Z:= FPosition.Z+FOffset.Z;
  end;
  FCameraWorld:= z3DMatrix.From(FViewMatrix).Inverse;
  if FPosDeltaWorld.Length > 0.0001 then
  begin
    FBoundingBox.Center.From(FPosition);
    FBoundingSphere.Center.From(FPosition);
  end;
  SetLength(FEnvironments, 0);
  FindCurrentEnvironments(z3DScenario.Environment);
  z3DScenario.ViewFrustum.UpVector.From(WorldUp);
  inherited;
end;

function Tz3DFirstPersonCamera.GetWorldMatrix: Iz3DMatrix;
begin
  Result:= FCameraWorld;
end;

function Tz3DFirstPersonCamera.GetWorldRight: Iz3DFloat3;
begin
  Result:= z3DFloat3(FCameraWorld.e11, FCameraWorld.e12, FCameraWorld.e13);
end;

function Tz3DFirstPersonCamera.GetWorldUp: Iz3DFloat3;
begin
  Result:= z3DFloat3(FCameraWorld.e21, FCameraWorld.e22, FCameraWorld.e23);
end;

function Tz3DFirstPersonCamera.GetWorldAhead: Iz3DFloat3;
begin
  Result:= z3DFloat3(FCameraWorld.e31, FCameraWorld.e32, FCameraWorld.e33);
end;

function Tz3DFirstPersonCamera.GetEyePt: Iz3DFloat3;
begin
  Result:= z3DFloat3(FCameraWorld.e41, FCameraWorld.e42, FCameraWorld.e43);
end;

procedure Tz3DFirstPersonCamera.SetButtons(const ALeft, AMiddle, ARight: Boolean);
begin
  FActiveButtonMask:= IfThen(ALeft, z3DcMouseLeftButton, 0) or
  IfThen(AMiddle, z3DcMouseMiddleButton, 0) or IfThen(ARight, z3DcMouseRightButton, 0);
end;

procedure Tz3DFirstPersonCamera.SetFirstPerson(const AObject: Iz3DScenarioDynamicObject);
begin
  FObject:= AObject;
end;

function Tz3DFirstPersonCamera.GetResetCursorAfterMove: Boolean;
begin
  Result:= FResetCursorAfterMove;
end;

function Tz3DFirstPersonCamera.GetRotateButtons: Iz3DFirstPersonCameraRotateButtons;
begin
  Result:= FRotateButtons;
end;

procedure Tz3DFirstPersonCamera.SetResetCursorAfterMove(const Value: Boolean);
begin
  FResetCursorAfterMove:= Value;
end;

function Tz3DFirstPersonCamera.GetAcceleration: Iz3DFloat3;
begin
  Result:= FSWOAcceleration;
end;

function Tz3DFirstPersonCamera.GetBoundingBox: Iz3DBoundingBox;
begin
  Result:= FBoundingBox;
end;

function Tz3DFirstPersonCamera.GetBoundingSphere: Iz3DBoundingSphere;
begin
  Result:= FBoundingSphere;
end;

function Tz3DFirstPersonCamera.GetCenter: Iz3DFloat3;
begin
  Result:= FPosition;
end;

function Tz3DFirstPersonCamera.GetEnablePhysics: Boolean;
begin
  Result:= True;
end;

function Tz3DFirstPersonCamera.GetGround: Boolean;
begin
  Result:= FGround;
end;

function Tz3DFirstPersonCamera.GetShape: Tz3DScenarioObjectShape;
begin
  Result:= z3dsosCube;
end;

function Tz3DFirstPersonCamera.GetSubsetCount: Integer;
begin
  Result:= 1;
end;

function Tz3DFirstPersonCamera.GetSubsets(
  const I: Integer): Iz3DScenarioObjectSubset;
begin
  Result:= FSubset;
end;

function Tz3DFirstPersonCamera.GetVelocity: Iz3DFloat3;
begin
  Result:= FSWOVelocity;
end;

function Tz3DFirstPersonCamera.GetViewCenter: Iz3DFloat4;
begin
  Result:= z3DFloat4(FPosition.X, FPosition.Y, FPosition.Z, 1);
end;

function Tz3DFirstPersonCamera.GetVisible: Boolean;
begin
  Result:= True;
end;

procedure Tz3DFirstPersonCamera.Hide;
begin
  //
end;

procedure Tz3DFirstPersonCamera.SetEnablePhysics(const Value: Boolean);
begin
  //
end;

procedure Tz3DFirstPersonCamera.SetGround(const Value: Boolean);
begin
  FGround:= Value;
end;

procedure Tz3DFirstPersonCamera.SetVisible(const Value: Boolean);
begin
  //
end;

procedure Tz3DFirstPersonCamera.Show;
begin
  //
end;

procedure Tz3DFirstPersonCamera.VectorChanged(const ASender: Iz3DBase);
begin
  FBoundingBox.Center.From(FPosition);
  FBoundingSphere.Center.From(FPosition);
end;

procedure Tz3DFirstPersonCamera.UpdateVelocity(const AElapsedTime: Single);
begin
  inherited;
end;

function Tz3DFirstPersonCamera.GetEnableFlashLight: Boolean;
begin
  Result:= FEnableFlashLight;
end;

procedure Tz3DFirstPersonCamera.SetEnableFlashLight(const Value: Boolean);
begin
  if FEnableFlashLight <> Value then
  begin
    FEnableFlashLight:= Value;
    if Value then CreateFlashLight;
    if not Value and (FFlashLight <> nil) then
    FFlashLight.Enabled:= False;
  end;
end;

procedure Tz3DFirstPersonCamera.z3DStartScenario(const AStage: Tz3DStartScenarioStage);
begin
  inherited;
  if (AStage = z3dssCreatingScenarioObjects) then CreateFlashLight;
end;

procedure Tz3DFirstPersonCamera.z3DStopScenario;
begin
  inherited;
  FFlashLight:= nil;
end;

procedure Tz3DFirstPersonCamera.z3DKeyboard(const AChar: Cardinal;
  const AKeyDown, AAltDown: Boolean);
begin
  inherited;
  if (AChar = Ord('F')) and AKeyDown and FEnableFlashLight and (FFlashLight <> nil) then
  begin
    FFlashLight.Enabled:= not FFlashLight.Enabled;
    {if FFlashLight.Enabled then }FFlashLightSound.Play;
  end;
end;

procedure Tz3DFirstPersonCamera.CreateFlashLight;
begin
  if not FEnableFlashLight or (FFlashLight <> nil) then Exit;
  if z3DLightingController = nil then
  begin
    z3DTrace('Iz3DFirstPersonCamera.CreateFlashLight failed (must create a lighting controller first)', z3dtkWarning);
    Exit;
  end;

  FFlashLight:= z3DLightingController.CreateLight;
  StringToWideChar('z3DFirstPersonCamera_FlashLight'+IntToStr(FFlashLight.Index), z3DWideBuffer, 255);
  FFlashLight.Name:= z3DWideBuffer;
  FFlashLight.Enabled:= False;
  FFlashLight.Color.R:= 0.87;
  FFlashLight.Color.G:= 0.8;
  FFlashLight.Color.B:= 0.6;
  FFlashLight.Style:= z3dlsSpot;
  FFlashLight.Angle:= 130;
  FFlashLight.Effects.Glow:= False;
  FFlashLight.Effects.StaticShadows:= False;
  FFlashLight.Sharpness:= 60;
  FFlashLight.Size:= 0.1;
  FFlashLight.Range:= 50;
  FFlashLight.Intensity:= 1;

  if z3DAudioController <> nil then
  begin
    FFlashLightSound:= z3DAudioController.CreateSound('C:\JP\Direct3D\Zenith 3D Engine\DLL\fs_Common\Audio\FlashLight1.wav');
    FFlashLightSound.Pan:= 300;
    FFlashLightSound.Volume:= -40;
  end;
end;

function Tz3DFirstPersonCamera.GetInFrustum: Boolean;
begin
  Result:= True;
end;

procedure Tz3DFirstPersonCamera.FrameMove;
begin
  //
end;

function Tz3DFirstPersonCamera.GetEnvironments: Tz3DScenarioEnvironments;
begin
  Result:= FEnvironments;
end;

procedure Tz3DFirstPersonCamera.FindCurrentEnvironments;
const FEpsilon = 0.00001;
var I, FLength: Integer;
    FIncidence: Single;
begin

  // If this environment has no incidence, stop searching
  FIncidence:= ARoot.IncidenceOnObject(Self);
  if FIncidence < FEpsilon then Exit;

  // Search for the child environments first
  FLength:= Length(FEnvironments);
  for I:= 0 to Length(ARoot.Childs)-1 do
  FindCurrentEnvironments(ARoot.Childs[I].Environment);

  // If no indicent childs were found, add this environment
  if FLength = Length(FEnvironments) then
  begin
    SetLength(FEnvironments, Length(FEnvironments)+1);
    FEnvironments[Length(FEnvironments)-1].Environment:= ARoot;
  end;
end;


function Tz3DFirstPersonCamera.InEnvironment(
  const AEnvironment: Iz3DScenarioEnvironment): Boolean;
var I: Integer;
begin
  Result:= False;
  for I:= 0 to Length(FEnvironments)-1 do
  if FEnvironments[I].Environment = AEnvironment then
  begin
    Result:= True;
    Exit;
  end;
end;

function Tz3DFirstPersonCamera.GetAutoLOD: Boolean;
begin

end;

function Tz3DFirstPersonCamera.GetLOD: Tz3DScenarioObjectLOD;
begin

end;

procedure Tz3DFirstPersonCamera.SetAutoLOD(const Value: Boolean);
begin

end;

procedure Tz3DFirstPersonCamera.SetLOD(const Value: Tz3DScenarioObjectLOD);
begin

end;

procedure Tz3DFirstPersonCamera.Render(const AMaterials,
  ALighting: Boolean; const AShader: Iz3DShader);
begin

end;

{ Tz3DCameraKeys }

constructor Tz3DCameraKeys.Create;
begin
  inherited;
  FEnableDefaultKeys:= True;
  FAutoZoom:= False;
  FMoveForward:= 'W';
  FMoveBackward:= 'S';
  FMoveRight:= 'D';
  FMoveLeft:= 'A';
  FMoveUp:= 'E';
  FMoveDown:= 'Q';
  FZoomIn:= 'Z';
  FZoomOut:= 'X';
end;

function Tz3DCameraKeys.GetAutoZoom: Boolean;
begin
  Result:= FAutoZoom;
end;

function Tz3DCameraKeys.GetEnableDefaultKeys: Boolean;
begin
  Result:= FEnableDefaultKeys;
end;

function Tz3DCameraKeys.GetMoveBackward: Char;
begin
  Result:= FMoveBackward;
end;

function Tz3DCameraKeys.GetMoveDown: Char;
begin
  Result:= FMoveDown;
end;

function Tz3DCameraKeys.GetMoveForward: Char;
begin
  Result:= FMoveForward;
end;

function Tz3DCameraKeys.GetMoveLeft: Char;
begin
  Result:= FMoveLeft;
end;

function Tz3DCameraKeys.GetMoveRight: Char;
begin
  Result:= FMoveRight;
end;

function Tz3DCameraKeys.GetMoveUp: Char;
begin
  Result:= FMoveUp;
end;

function Tz3DCameraKeys.GetZoomIn: Char;
begin
  Result:= FZoomIn;
end;

function Tz3DCameraKeys.GetZoomOut: Char;
begin
  Result:= FZoomOut;
end;

procedure Tz3DCameraKeys.SetAutoZoom(const Value: Boolean);
begin
  FAutoZoom:= Value;
end;

procedure Tz3DCameraKeys.SetEnableDefaultKeys(const Value: Boolean);
begin
  FEnableDefaultKeys:= Value;
end;

procedure Tz3DCameraKeys.SetMoveBackward(const Value: Char);
begin
  FMoveBackward:= Value;
end;

procedure Tz3DCameraKeys.SetMoveDown(const Value: Char);
begin
  FMoveDown:= Value;
end;

procedure Tz3DCameraKeys.SetMoveForward(const Value: Char);
begin
  FMoveForward:= Value;
end;

procedure Tz3DCameraKeys.SetMoveLeft(const Value: Char);
begin
  FMoveLeft:= Value;
end;

procedure Tz3DCameraKeys.SetMoveRight(const Value: Char);
begin
  FMoveRight:= Value;
end;

procedure Tz3DCameraKeys.SetMoveUp(const Value: Char);
begin
  FMoveUp:= Value;
end;

procedure Tz3DCameraKeys.SetZoomIn(const Value: Char);
begin
  FZoomIn:= Value;
end;

procedure Tz3DCameraKeys.SetZoomOut(const Value: Char);
begin
  FZoomOut:= Value;
end;

{ Tz3DCameraController }

procedure Tz3DCameraController.AddCamera(const ACamera: Iz3DBaseCamera);
begin
  FCameras.Add(ACamera);
  SetActiveCamera(ACamera);
end;

function Tz3DCameraController.CreateFirstPersonCamera: Iz3DFirstPersonCamera;
begin
  Result:= Tz3DFirstPersonCamera.Create;
  AddCamera(Result);
end;

function Tz3DCameraController.CreateObjectCamera: Iz3DObjectCamera;
begin
  Result:= Tz3DObjectCamera.Create;
  AddCamera(Result);
end;

constructor Tz3DCameraController.Create;
begin
  inherited;
  FCameras:= TInterfaceList.Create;
end;

function Tz3DCameraController.GetActiveCamera: Iz3DBaseCamera;
begin
  Result:= Cameras[FActiveCameraIndex];
end;

function Tz3DCameraController.GetCameraCount: Integer;
begin
  Result:= FCameras.Count;
end;

function Tz3DCameraController.GetCameras(const AIndex: Integer): Iz3DBaseCamera;
begin
  Result:= FCameras[AIndex] as Iz3DBaseCamera;
end;

procedure Tz3DCameraController.RemoveCamera(const ACamera: Iz3DBaseCamera);
begin
  FCameras.Remove(ACamera);
end;

procedure Tz3DCameraController.SetActiveCamera(const Value: Iz3DBaseCamera);
var I: Integer;
begin
  FActiveCameraIndex:= FCameras.IndexOf(Value);
  for I:= 0 to CameraCount-1 do
  if Cameras[I] = Value as Iz3DBaseCamera then
  Cameras[I].Active:= True else Cameras[I].Active:= False;
end;




{ Tz3DSkyBox }

constructor Tz3DSkyBox.Create;
begin
  inherited Create;
  Init;
end;

procedure Tz3DSkyBox.Init(const AOwner: Iz3DBase = nil);
begin
  inherited;
  FActive:= True;
  FTexture:= z3DCreateCubeTexture;
  FTexture.SamplerState.AddressMode:= z3dsamClamp;
  FTexture.SamplerState.Filter:= z3dsfLinear;
  FTexture.Source:= z3dtsFileName;
  FTexture.AutoGenerateMipMaps:= False;
  FTexture.Enabled:= False;
  FSkyTextureFormat:= z3DFileSystemController.CreateObjectFormat;
  FSkyTextureFormat.Description:= 'Zenith SkyBox Texture File';
  FSkyTextureFormat.Extension:= 'dds';
  FSkyTextureFormat.DefaultFolder:= fsSkyTexturesFolder;
  FVertexBuffer:= z3DCreateVertexBuffer;
  FVertexBuffer.Format.AddElement(0, z3dvefFloat4, z3dvemDefault, z3dveuPosition, 0);
  FVertexBuffer.SetParams(4, D3DUSAGE_DYNAMIC or D3DUSAGE_WRITEONLY, D3DPOOL_DEFAULT);
end;

procedure Tz3DSkyBox.Cleanup;
begin
  inherited;
  z3DCleanupFree(FVertexBuffer);
  z3DCleanupFree(FTexture);
end;

procedure Tz3DSkyBox.CreateTexture;
begin
  Texture.Enabled:= Active;
end;

procedure Tz3DSkyBox.FrameMove;
begin
  if not Active then Exit;
  if not z3DEngine.Scenario.Enabled then Exit;
  z3DSkyController.Shader.Matrix['GInvViewProjectionMatrix']:=
  z3DMatrix.From(z3DScenario.ViewFrustum.ViewProjMatrix).Inverse;
end;

procedure Tz3DSkyBox.FrameRender;
begin
  if not Active then Exit;
  if not z3DEngine.Scenario.Enabled then Exit;

  // Set the effect params
  z3DSkyController.Shader.Technique:= 'z3DSkies_Skybox';
  FTexture.AttachToSampler(2, True, True);

  // Draw the skybox
  FVertexBuffer.Prepare;
  FVertexBuffer.Render(z3DSkyController.Shader);
end;

procedure Tz3DSkyBox.ResetDevice;
begin
  inherited;
  if z3DEngine.Scenario.Enabled then
  begin
    CreateTexture;
    UpdateVertexBuffer;
  end;
end;

procedure Tz3DSkyBox.StartScenario;
begin
  CreateTexture;
  UpdateVertexBuffer;
end;

procedure Tz3DSkyBox.SetFileName(const Value: PWideChar);
begin
  FSkyTextureFormat.Expand(Value, z3DWideBuffer);
  FTexture.FileName:= z3DWideBuffer;
  if z3DEngine.Scenario.Enabled then CreateTexture;
end;

function Tz3DSkyBox.GetActive: Boolean;
begin
  Result:= FActive;
end;

function Tz3DSkyBox.GetFileName: PWideChar;
begin
  Result:= FTexture.FileName;
end;

function Tz3DSkyBox.GetTexture: Iz3DCubeTexture;
begin
  Result:= FTexture;
end;

procedure Tz3DSkyBox.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive:= Value;
    CreateTexture;
  end;
end;

procedure Tz3DSkyBox.UpdateVertexBuffer;
var FVertexArray: Pz3DSkyboxVertArray;
    FHighW, FHighH, FLowW, FLowH: Single;
begin
  // Fill the vertex buffer
  FVertexArray:= FVertexBuffer.Lock(D3DLOCK_DISCARD);
  try
    // Map texels to pixels
    FHighW:= -1 - (1 / z3DCore_GetBackBufferSurfaceDesc.Width);
    FHighH:= -1 - (1 / z3DCore_GetBackBufferSurfaceDesc.Height);
    FLowW:= 1 + (1 / z3DCore_GetBackBufferSurfaceDesc.Width);
    FLowH:= 1 + (1 / z3DCore_GetBackBufferSurfaceDesc.Height);
    FVertexArray[0].Position:= D3DXVector4(FLowW, FLowH, 1, 1);
    FVertexArray[1].Position:= D3DXVector4(FLowW, FHighH, 1, 1);
    FVertexArray[2].Position:= D3DXVector4(FHighW, FLowH, 1, 1);
    FVertexArray[3].Position:= D3DXVector4(FHighW, FHighH, 1, 1);
  finally
    FVertexBuffer.Unlock;
  end;
end;

{ Tz3DSky }

function Tz3DSky.AddStarLight: Iz3DLight;
begin
  if z3DLightingController = nil then
  begin
    z3DTrace('Iz3DSky.AddStarLight failed (must create a lighting controller): Returning NULL', z3DtkWarning);
    Result:= nil;
    Exit; 
  end;

  // Starlight default parameters
  Result:= z3DLightingController.CreateLight;
  with Result do
  begin
    Style:= z3dlsDirectional;
    Range:= 500;
    Size:= 25;
    Frustum.LookAt.X:= 0.2;
    Frustum.LookAt.Y:= -1;
    Frustum.LookAt.Z:= 0.2;
    Enabled:= True;
  end;
end;

procedure Tz3DSky.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FSkyBox:= Tz3DSkyBox.Create;
  FMode:= z3dsmRayleigh;
  FActive:= True;

  // Link this object to the desired events generated by the z3D Engine
  Notifications:= [z3dlnDevice, z3dlnFrameMove, z3dlnFrameRender];
end;

procedure Tz3DSky.Cleanup;
begin
  inherited;
  z3DCleanupFree(FSkyBox);
end;

function Tz3DSky.GetMode: Tz3DSkyMode;
begin
  Result:= FMode;
end;

function Tz3DSky.GetActive: Boolean;
begin
  Result:= FActive;
end;

function Tz3DSky.GetSkyBox: Iz3DSkyBox;
begin
  Result:= FSkyBox;
end;

procedure Tz3DSky.SetMode(const Value: Tz3DSkyMode);
begin
  if FMode <> Value then
  begin
    FMode:= Value;
    if z3DEngine.Scenario.Enabled then
    begin
      if FMode = z3dsmSkyBox then
      begin
        SkyBox.UpdateVertexBuffer;
        SkyBox.CreateTexture;
      end;
    end;
  end;
end;

procedure Tz3DSky.SetActive(const Value: Boolean);
begin
  FActive:= Value;
end;

procedure Tz3DSky.z3DFrameMove;
begin
  if FMode = z3dsmSkyBox then FSkyBox.FrameMove;
end;

procedure Tz3DSky.z3DFrameRender;
begin
  if not z3DEngine.Scenario.Enabled or
  (z3DEngine.Renderer.RenderStage = z3drsDepth) then Exit;
  if FMode = z3dsmSkyBox then FSkyBox.FrameRender;
end;

procedure Tz3DSky.z3DResetDevice;
begin
  if not z3DEngine.Scenario.Enabled then Exit;
  if FMode = z3dsmSkyBox then FSkyBox.ResetDevice;
end;

procedure Tz3DSky.z3DStartScenario(const AStage: Tz3DStartScenarioStage);
begin
  if AStage <> z3dssCreatingScene then Exit;
  if FMode = z3dsmSkyBox then FSkyBox.StartScenario;
end;

{ Tz3DEarthSky }

constructor Tz3DEarthSky.Create;
begin
  inherited;
end;

procedure Tz3DEarthSky.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FRayleighRatio:= z3DFloat3(10, 7, 2);
  FMoonHorizonColor:= z3DFloat3(0.739607, 0.574125, 0.351229);
  FSunHorizonColor:= z3DFloat3(0.705189, 0.526078, 0.144841);
  FMoonZenithColor:= z3DFloat3(0.417562, 0.551183, 0.722384);
  FSunZenithColor:= z3DFloat3(0.612256, 0.594730, 0.520998);
  FEnableMoonLight:= True;
  FEnableSunLight:= True;                                           
  FTime:= z3DTimeOfDay;
  FTime.Hours:= 12;
  FSunRiseTime:= z3DTimeOfDay;
  FSunRiseTime.Hours:= 6;
  FSunRiseTime.Minutes:= 15;
  FSunSetTime:= z3DTimeOfDay;
  FSunSetTime.Hours:= 18;
  FSunSetTime.Minutes:= 15;
  FUpdateFog:= True;
  FUpdateAmbient:= True;
  CreateLights;
end;

procedure Tz3DEarthSky.Cleanup;
begin
  inherited;
  FSunLight:= nil;
  FMoonLight:= nil;
end;

procedure Tz3DEarthSky.CreateLights;
begin
  if FSunLight <> nil then Exit;

  if z3DLightingController = nil then
  begin
    z3DTrace('Iz3DEarthSky.CreateLights failed (must create a lighting controller first)', z3DtkWarning);
    Exit;
  end;

  // Sunlight default parameters
  FSunLight:= z3DLightingController.CreateLight;
  with FSunLight do
  begin
    Style:= z3dlsDirectional;
    Size:= 25;
    Frustum.LookAt.X:= -0.001;
    Range:= 500;
    Enabled:= False;
  end;

  // Moonlight default parameters
  FMoonLight:= z3DLightingController.CreateLight;
  with FMoonLight do
  begin
    Style:= z3dlsDirectional;
    Size:= 28;
    Frustum.LookAt.X:= 0.001;
    Range:= 500;
    Enabled:= False;
  end;
end;

function Tz3DEarthSky.GetEnableMoonLight: Boolean;
begin
  Result:= FEnableMoonLight;
end;

function Tz3DEarthSky.GetEnableSunLight: Boolean;
begin
  Result:= FEnableSunLight;
end;

function Tz3DEarthSky.GetMoonLight: Iz3DLight;
begin
  Result:= FMoonLight;
end;

function Tz3DEarthSky.GetSunLight: Iz3DLight;
begin
  Result:= FSunLight;
end;

function Tz3DEarthSky.GetTime: Iz3DTimeOfDay;
begin
  Result:= FTime;
end;

procedure Tz3DEarthSky.SetEnableMoonLight(const Value: Boolean);
begin
  FEnableMoonLight:= Value;
end;

procedure Tz3DEarthSky.SetEnableSunLight(const Value: Boolean);
begin
  FEnableSunLight:= Value;
end;

procedure Tz3DEarthSky.UpdateSky;
var FSHAmount: Single;
    FTOD: Single;
    FDayTime: Single;
    FTimeFactor: Single;
begin

  if not z3DEngine.Device.Created then Exit;


  //TODO JP
  z3DScenario.Environment.Fog.RangeMin:= 0.001;
  z3DScenario.Environment.Fog.RangeMax:= 0.75;

  // Sunlight parameters
  if FEnableSunLight and (FSunLight <> nil) then
  begin
    with FSunLight do
    begin
      Enabled:= (FTime.Hours > FSunRiseTime.Hours-2) and (FTime.Hours < FSunSetTime.Hours+2);
      if Enabled then
      begin

        Frustum.LookAt.Y:= (FTime.ToFloat * 24 - (FSunRiseTime.ToFloat * 24)) / ((FSunSetTime.ToFloat * 24)-(FSunRiseTime.ToFloat * 24));
        Frustum.LookAt.X:= -(Frustum.LookAt.Y - 0.5) * 0.1;
        Frustum.LookAt.Z:= -(Frustum.LookAt.Y - 0.5) * 1.1;
        Frustum.LookAt.Y:= -Frustum.LookAt.Y * (1 - Frustum.LookAt.Y) * 4;
        FSHAmount:= Power(Max(0, -Frustum.LookAt.Y), 0.75);
        Color.R:= Lerp(FSunHorizonColor.X, FSunZenithColor.X, FSHAmount);
        Color.G:= Lerp(FSunHorizonColor.Y, FSunZenithColor.Y, FSHAmount);
        Color.B:= Lerp(FSunHorizonColor.Z, FSunZenithColor.Z, FSHAmount);
        if Frustum.LookAt.Y > 0 then
        begin
          Intensity:= 0.01;
          Effects.GlowFactor:= 100;
          Size:= 44;
        end else
        begin
          Intensity:= 0.5 + Power(FSHAmount, 0.1) * 2.5;
          Effects.GlowFactor:= 0.25 + (2.5 - Intensity * 0.84);
          Size:= 24 + Effects.GlowFactor * 16;
        end;
      end;
    end;
  end;

  // Moonlight parameters
  if FEnableMoonLight and (FMoonLight <> nil) then
  begin
    with FMoonLight do
    begin
      Enabled:= (FTime.Hours < FSunRiseTime.Hours+1) and (FTime.Hours > FSunSetTime.Hours-1);
      if Enabled then
      begin
        if FTime.Hours > FSunSetTime.Hours-1 then
        Frustum.LookAt.Y:= (FTime.ToInteger - FSunSetTime.ToInteger) / 100000 else
        Frustum.LookAt.Y:= (FSunSetTime.ToInteger + 40000) / 100000;

        Frustum.LookAt.X:= (Frustum.LookAt.Y - 0.5) * 1.25;
        Frustum.LookAt.Z:= (Frustum.LookAt.Y - 0.5) * 0.75;
        Frustum.LookAt.Y:= -Frustum.LookAt.Y * (1 - Frustum.LookAt.Y) * 4;
        FSHAmount:= Power(Max(0, -Frustum.LookAt.Y), 0.5);
        Color.R:= Lerp(FSunHorizonColor.X, FMoonZenithColor.X, FSHAmount);
        Color.G:= Lerp(FSunHorizonColor.Y, FMoonZenithColor.Y, FSHAmount);
        Color.B:= Lerp(FSunHorizonColor.Z, FMoonZenithColor.Z, FSHAmount);
        FMoonLight.Intensity:= Max(0, -Frustum.LookAt.Y) * 0.5;
        FMoonLight.Effects.GlowFactor:=  1 / (FMoonLight.Intensity * 1.75 + 0.001);
      end;
    end;
  end;

  case FTime.Hours of

    // After midnight
    0..5, 24:
    begin
      z3DSkyController.Shader.Color3['GSkyColorTop']:= z3DFloat3(0.002994, 0.003228, 0.005102);
      z3DSkyController.Shader.Color3['GSkyColorMid']:= z3DFloat3(0.005228, 0.010228, 0.010102);
      z3DSkyController.Shader.Color3['GSkyColorBottom']:= z3DFloat3(0.010102, 0.013228, 0.015102);

      if FUpdateAmbient then
      begin
        z3DScenario.Environment.AmbientColor.R:= 0.015255;
        z3DScenario.Environment.AmbientColor.G:= 0.019392;
        z3DScenario.Environment.AmbientColor.B:= 0.028372;
      end;

      if FUpdateFog then
      begin
        z3DScenario.Environment.Fog.Enabled:= False;
        z3DScenario.Environment.Fog.Color.RGB:= z3DFloat3.RGB;
      end;
    end;

    // Sunrise
    6:
    begin
      FTOD:= FTime.Minutes / 60;
      z3DSkyController.Shader.Color3['GSkyColorTop']:= z3DFloat3(Lerp(0.002994, 0.411764, FTOD),
      Lerp(0.003228, 0.654901, FTOD), Lerp(0.005102, 0.894117, FTOD));
      z3DSkyController.Shader.Color3['GSkyColorMid']:= z3DFloat3(Lerp(0.005228, 0.549019, FTOD),
      Lerp(0.010228, 0.707843, FTOD), Lerp(0.010102, 0.833333, FTOD));
      z3DSkyController.Shader.Color3['GSkyColorBottom']:= z3DFloat3(Lerp(0.010102, 0.780392, FTOD),
      Lerp(0.013228, 0.874509, FTOD), Lerp(0.015102, 0.874509, FTOD));

      if FUpdateAmbient then
      begin
        z3DScenario.Environment.AmbientColor.R:= Lerp(0.015255, 0.274902, FTOD);
        z3DScenario.Environment.AmbientColor.G:= Lerp(0.019392, 0.314117, FTOD);
        z3DScenario.Environment.AmbientColor.B:= Lerp(0.028372, 0.432157, FTOD);
      end;

      if FUpdateFog then
      begin
        z3DScenario.Environment.Fog.Density:= Lerp(0.1, 0.5, FTOD);
        z3DScenario.Environment.Fog.Color.RGB:= z3DFloat3(Lerp(0, 0.611764, FTOD),
        Lerp(0, 0.5190194, FTOD), Lerp(0, 0.761568, FTOD)).RGB;
        z3DScenario.Environment.Fog.Enabled:= True;
      end;
    end;

    // Morning
    7..12:
    begin
      FTOD:= ((FTime.Hours - 7) * 60 + FTime.Minutes) / (60*6);
      z3DSkyController.Shader.Color3['GSkyColorTop']:= z3DFloat3(Lerp(0.411764, 0.439215, FTOD),
      Lerp(0.654901, 0.643137, FTOD), Lerp(0.894117, 0.928627, FTOD));
      z3DSkyController.Shader.Color3['GSkyColorMid']:= z3DFloat3(Lerp(0.549019, 0.536078, FTOD),
      Lerp(0.707843, 0.702549, FTOD), Lerp(0.833333, 0.901960, FTOD));
      z3DSkyController.Shader.Color3['GSkyColorBottom']:= z3DFloat3(Lerp(0.780392, 0.678431, FTOD),
      Lerp(0.874509, 0.854902, FTOD), Lerp(0.874509, 0.984313, FTOD));

      if FUpdateAmbient then
      begin
        z3DScenario.Environment.AmbientColor.R:= Lerp(0.274902, 0.677647, FTOD);
        z3DScenario.Environment.AmbientColor.G:= Lerp(0.314117, 0.712568, FTOD);
        z3DScenario.Environment.AmbientColor.B:= Lerp(0.432157, 0.818823, FTOD);
      end;

      if FUpdateFog then
      begin
        z3DScenario.Environment.Fog.Density:= Lerp(0.5, 0.3, FTOD);
        z3DScenario.Environment.Fog.Color.RGB:= z3DFloat3(Lerp(0.611764, 0.568274, FTOD),
        Lerp(0.5190194, 0.650980, FTOD), Lerp(0.761568, 0.835294, FTOD)).RGB;
        z3DScenario.Environment.Fog.Enabled:= True;
      end;
    end;

    // Midday
    13..17:
    begin
      FTOD:= ((FTime.Hours - 13) * 60 + FTime.Minutes) / (60*5);
      z3DSkyController.Shader.Color3['GSkyColorTop']:= z3DFloat3(Lerp(0.439215, 0.235294, FTOD),
      Lerp(0.643137, 0.494117, FTOD), Lerp(0.928627, 0.640196, FTOD));
      z3DSkyController.Shader.Color3['GSkyColorMid']:= z3DFloat3(Lerp(0.536078, 0.409804, FTOD),
      Lerp(0.702549, 0.468627, FTOD), Lerp(0.901960, 0.605882, FTOD));
      z3DSkyController.Shader.Color3['GSkyColorBottom']:= z3DFloat3(Lerp(0.678431, 0.576470, FTOD),
      Lerp(0.854902, 0.564705, FTOD), Lerp(0.984313, 0.537254, FTOD));

      if FUpdateAmbient then
      begin
        z3DScenario.Environment.AmbientColor.R:= Lerp(0.677647, 0.292549, FTOD);
        z3DScenario.Environment.AmbientColor.G:= Lerp(0.712568, 0.310000, FTOD);
        z3DScenario.Environment.AmbientColor.B:= Lerp(0.818823, 0.503529, FTOD);
      end;

      if FUpdateFog then
      begin
        z3DScenario.Environment.Fog.Density:= Lerp(0.3, 0.5, FTOD);
        z3DScenario.Environment.Fog.Color.RGB:= z3DFloat3(Lerp(0.568274, 0.319393, FTOD),
        Lerp(0.854902, 0.412548, FTOD), Lerp(0.984313, 0.457255, FTOD)).RGB;
        z3DScenario.Environment.Fog.Enabled:= True;
      end;
    end;

    // Afternoon
    18..20:
    begin
      FTOD:= ((FTime.Hours - 18) * 60 + FTime.Minutes) / (60*3);
      z3DSkyController.Shader.Color3['GSkyColorTop']:= z3DFloat3(Lerp(0.235294, 0.066666, FTOD),
      Lerp(0.494117, 0.082352, FTOD), Lerp(0.640196, 0.121568, FTOD));
      z3DSkyController.Shader.Color3['GSkyColorMid']:= z3DFloat3(Lerp(0.409804, 0.076470, FTOD),
      Lerp(0.468627, 0.108621, FTOD), Lerp(0.605882, 0.130784, FTOD));
      z3DSkyController.Shader.Color3['GSkyColorBottom']:= z3DFloat3(Lerp(0.576470, 0.098039, FTOD),
      Lerp(0.564705, 0.125490, FTOD), Lerp(0.537254, 0.156862, FTOD));

      if FUpdateAmbient then
      begin
        z3DScenario.Environment.AmbientColor.R:= Lerp(0.292549, 0.014313, FTOD);
        z3DScenario.Environment.AmbientColor.G:= Lerp(0.310000, 0.021568, FTOD);
        z3DScenario.Environment.AmbientColor.B:= Lerp(0.503529, 0.055490, FTOD);
      end;

      if FUpdateFog then
      begin
        z3DScenario.Environment.Fog.Density:= Lerp(0.5, 0.3, FTOD);
        z3DScenario.Environment.Fog.Color.RGB:= z3DFloat3(Lerp(0.319393, 0.194117, FTOD),
        Lerp(0.412548, 0.152941, FTOD), Lerp(0.457255, 0.160784, FTOD)).RGB;
        z3DScenario.Environment.Fog.Enabled:= True;
      end;
    end;

    // Night
    21..23:
    begin
      FTOD:= ((FTime.Hours - 21) * 60 + FTime.Minutes) / (60*3);
      z3DSkyController.Shader.Color3['GSkyColorTop']:= z3DFloat3(Lerp(0.066666, 0.002994, FTOD),
      Lerp(0.082352, 0.003228, FTOD), Lerp(0.121568, 0.005102, FTOD));
      z3DSkyController.Shader.Color3['GSkyColorMid']:= z3DFloat3(Lerp(0.076470, 0.005228, FTOD),
      Lerp(0.108627, 0.010228, FTOD), Lerp(0.130784, 0.010102, FTOD));
      z3DSkyController.Shader.Color3['GSkyColorBottom']:= z3DFloat3(Lerp(0.098039, 0.010102, FTOD),
      Lerp(0.125490, 0.013228, FTOD), Lerp(0.156862, 0.015102, FTOD));

      if FUpdateAmbient then
      begin
        z3DScenario.Environment.AmbientColor.R:= Lerp(0.014313, 0.015255, FTOD);
        z3DScenario.Environment.AmbientColor.G:= Lerp(0.021568, 0.019392, FTOD);
        z3DScenario.Environment.AmbientColor.B:= Lerp(0.055490, 0.028372, FTOD);
      end;

      if FUpdateFog then
      begin
        z3DScenario.Environment.Fog.Density:= Lerp(0.3, 0, FTOD);
        z3DScenario.Environment.Fog.Color.RGB:= z3DFloat3(Lerp(0.194117, 0, FTOD),
        Lerp(0.152941, 0, FTOD), Lerp(0.160784, 0, FTOD)).RGB;
        z3DScenario.Environment.Fog.Enabled:= True;
      end;
    end;
  end;

  // Get the daylight factor and set the sunlight direction
  FDayTime:= (FTime.ToFloat * 24 - (FSunRiseTime.ToFloat * 24 - 0.5)) / ((FSunSetTime.ToFloat * 24 + 3)-(FSunRiseTime.ToFloat * 24 - 0.5));
  if (FDayTime > 1) or (FDayTime < 0) then z3DSkyController.Shader.Param['GDayLightFactor']:= 0 else
  z3DSkyController.Shader.Param['GDayLightFactor']:= 18 * Power(FDayTime * (1 - FDayTime) * 4, 0.35);
  z3DSkyController.Shader.Float3['GLightDir']:= z3DFloat3.From(SunLight.Frustum.LookAt).Normalize;
  z3DSkyController.Shader.Param['GHazeAmount']:= FHazeAmount;
  z3DSkyController.Shader.Float3['GRayleighRatio']:= FRayleighRatio;

  // Get the lookup position based on sample density and time
  case FTime.Hours of
    0..4: FTimeFactor:= FTime.Hours + FTime.Minutes / 60;
    5..6: FTimeFactor:= 4 + ((FTime.Hours - 5) + FTime.Minutes / 60) * 6;
    7..16: FTimeFactor:= 16 + ((FTime.Hours - 7) + FTime.Minutes / 60);
    17: FTimeFactor:= 25 + ((FTime.Hours - 17) + FTime.Minutes / 60) * 6;
    18..23: FTimeFactor:= 31 + ((FTime.Hours - 18) + FTime.Minutes / 60);
  end;
  z3DSkyController.Shader.Param['GLookupPosition']:= FTimeFactor / FDomeTexture.Width;
end;

procedure Tz3DEarthSky.z3DFrameRender;
var I: Integer;
    FWM: Iz3DMatrix;
begin
  if not z3DEngine.Scenario.Enabled or
  (z3DEngine.Renderer.RenderStage = z3drsDepth) then Exit;

  // Linear interpolation mode
  if FMode = z3dsmLinear then
  begin
    z3DSkyController.Shader.Technique:= 'z3DSkies_LinearSky';
    z3DSkyController.Shader.Param['GAltitude']:= -z3DFloat3.From(z3DScenario.ViewFrustum.LookAt).
    Subtract(z3DScenario.ViewFrustum.Position).Normalize.Y + 0.5;
    z3DEngine.Renderer.Blend([], z3DSkyController.Shader);
  end else

  // Mie-Rayleigh mode
  if FMode = z3dsmRayleigh then
  begin
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_CW);

    z3DSkyController.Shader.Technique:= 'z3DSkies_MieRayleighSky';
    z3DSkyController.Shader.Matrix['GWorldMatrix']:= FDomeMatrix;

    FWM:= z3DMatrix.From(FDomeMatrix).Multiply(z3DMatrix.LookAt(z3DFloat3,
    z3DFloat3.From(z3DScenario.ViewFrustum.LookAt).Subtract(z3DScenario.ViewFrustum.Position),
    z3DScenario.ViewFrustum.UpVector)).Multiply(z3DScenario.ViewFrustum.ProjectionMatrix);
    z3DSkyController.Shader.Matrix['GViewProjectionMatrix']:= FWM;

    FDomeTexture.AttachToSampler(2, True, True);
    for I:= 0 to z3DSkyController.Shader.Prepare-1 do
    begin
      z3DSkyController.Shader.BeginPass;
      FDomeMesh.DrawSubset(0);
      z3DSkyController.Shader.EndPass;
    end;
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_CCW);
  end else

  // Call the ancestor
  inherited;
end;

procedure Tz3DEarthSky.z3DStartScenario(const AStage: Tz3DStartScenarioStage);
begin
  inherited;
  if AStage = z3dssCreatingSceneObjects then
  begin
    CreateSkyObjects;
    CreateLights;
    UpdateSky;
  end;
end;

function Tz3DEarthSky.GetUpdateAmbient: Boolean;
begin
  Result:= FUpdateAmbient;
end;

function Tz3DEarthSky.GetUpdateFog: Boolean;
begin
  Result:= FUpdateFog;
end;

procedure Tz3DEarthSky.SetUpdateAmbient(const Value: Boolean);
begin
  FUpdateAmbient:= Value;
end;

procedure Tz3DEarthSky.SetUpdateFog(const Value: Boolean);
begin
  FUpdateFog:= Value;
end;

procedure Tz3DEarthSky.CreateSkyObjects;
var FSubsetCount: DWORD;
begin
  // TODO JP: MOVER DE ACA!
  if FAILED(D3DXLoadMeshFromX('C:\JP\Direct3D\MESHES\SkyDome.x', D3DXMESH_MANAGED,
    z3DCore_GetD3DDevice, nil, nil, nil, @FSubsetCount, FDomeMesh)) then
  z3DTrace('Iz3DEarthSky.CreateSkyObjects failed: D3DXLoadMeshFromX failed', z3DtkWarning);
  FDomeTexture:= z3DCreateTexture;
  FDomeTexture.Source:= z3dtsFileName;
  FDomeTexture.FileName:= 'C:\JP\Direct3D\TEXTURES\SkyLookup1.dds';
  FDomeTexture.SamplerState.Filter:= z3dsfBilinear;
  FDomeTexture.CreateD3DTexture;
  FDomeMatrix:= z3DMatrix.RotateX(89.8).Multiply(z3DMatrix.RotateZ(-0.3)).Multiply(z3DMatrix.Translation(-500, 500, -500));
  StringToWideChar(IntToStr(FSubsetCount), z3DWideBuffer, 255);
end;

function Tz3DEarthSky.GetHazeAmount: Single;
begin
  Result:= FHazeAmount;
end;

function Tz3DEarthSky.GetRayleighRatio: Iz3DFloat3;
begin
  Result:= FRayleighRatio;
end;

procedure Tz3DEarthSky.SetHazeAmount(const Value: Single);
begin
  FHazeAmount:= Value;
end;

{ Tz3DSkyController }

procedure Tz3DSkyController.AddSky(const ASky: Iz3DSky);
begin
  FSkies.Add(ASky);
  SetActiveSky(ASky);
end;

procedure Tz3DSkyController.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FShader:= z3DCreateShader;
  FShader.FileName:= PWideChar(WideString(z3DRES_SKIES_EFFECT));
  FSkies:= TInterfaceList.Create;
  FActiveSky:= -1;
end;

procedure Tz3DSkyController.Cleanup;
begin
  z3DCleanupFree(FShader);
  inherited;
end;

function Tz3DSkyController.CreateEarthSky: Iz3DEarthSky;
begin
  Result:= Tz3DEarthSky.Create;
  AddSky(Result);
end;

function Tz3DSkyController.CreateSky: Iz3DSky;
begin
  Result:= Tz3DSky.Create;
  AddSky(Result);
end;

function Tz3DSkyController.GetActiveSky: Iz3DSky;
begin
  Result:= FSkies[FActiveSky] as Iz3DSky;
end;

function Tz3DSkyController.GetShader: Iz3DShader;
begin
  Result:= FShader;
end;

function Tz3DSkyController.GetSkies(const AIndex: Integer): Iz3DSky;
begin
  Result:= FSkies[AIndex] as Iz3DSky;
end;

function Tz3DSkyController.GetSkyCount: Integer;
begin
  Result:= FSkies.Count;
end;

procedure Tz3DSkyController.SetActiveSky(const Value: Iz3DSky);
var I: Integer;
begin
  FActiveSky:= FSkies.IndexOf(Value);
  for I:= 0 to SkyCount-1 do
  if Skies[I] = Value as Iz3DSky then
  Skies[I].Active:= True else Skies[I].Active:= False;
end;

{ Tz3DRope }

constructor Tz3DRope.Create(const AController: Iz3DRopeController);
begin
  inherited Create;
  FController:= AController;
  FPointA:= z3DFloat3(-1, -1, -1);
  FPointB:= z3DFloat3(1, 1, 1);
  FLength:= 2.5;
  FWidth:= 0.02;
  FMaterial:= z3DMaterialController.CreateMaterial;
  FMaterial.ColorDiffuse.RGB:= D3DXVector3(0.1, 0.05, 0.07);
end;

function Tz3DRope.GetLength: Single;
begin
  Result:= FLength;
end;

function Tz3DRope.GetMaterial: Iz3DMaterial;
begin
  Result:= FMaterial;
end;

function Tz3DRope.GetPointA: Iz3DFloat3;
begin
  Result:= FPointA;
end;

function Tz3DRope.GetPointB: Iz3DFloat3;
begin
  Result:= FPointB;
end;

function Tz3DRope.GetWidth: Single;
begin
  Result:= FWidth;
end;

procedure Tz3DRope.SetLength(const Value: Single);
begin
  FLength:= Value;
end;

procedure Tz3DRope.SetWidth(const Value: Single);
begin
  FWidth:= Value;
end;

procedure Tz3DRope.Render(const AMaterials: Boolean = True; const ALighting: Boolean = True;
  const AShader: Iz3DShader = nil);
var FSegmentVec, FBillboard: Iz3DFloat3;
    I: Integer;
    FViewOrigin: Iz3DFloat3;
    FWindIntensity, FCableLength, FAnchorsLength: Single;
    FMovementScale: Iz3DFloat3;
    FBufferData: Pz3DRopeVertexArray;

  procedure PrepareSegment(const ASegment: Integer);
  var FLerp: Single;
  begin
    FLerp:= ASegment / (FController.Segments-1);
    FBufferData[ASegment*2].Position.x:= FLerp * (PointB.X - PointA.X) + PointA.X;

    // Bend the rope if inside a world with gravity
    if System.Length(Environments) <> 0 then FBufferData[ASegment*2].Position.y:= Sin(FLerp * D3DX_PI) *
    (1 - Saturate(FWindIntensity/80)) * (-(FCableLength - FAnchorsLength) / 2) +
    (FLerp * (PointB.Y - PointA.Y) + PointA.Y) else
    FBufferData[ASegment*2].Position.y:= FLerp * (PointB.Y - PointA.Y) + PointA.Y;

    FBufferData[ASegment*2].Position.z:= FLerp * (PointB.Z - PointA.Z) + PointA.Z;

    // Move the rope if inside a world and wind is present
    if FWindIntensity > 0.01 then
    begin
      FMovementScale.x:= Cos(z3DCore_GetTime * Sin((FPointA.Y+FPointB.Z) * 4) * 0.1805 * FWindIntensity);
      FMovementScale.y:= Abs(Sin(z3DCore_GetTime * Cos((FPointA.X+FPointB.Z) * 2) * 0.1631 * FWindIntensity) * 0.5 + 0.5);
      FMovementScale.z:= Sin(z3DCore_GetTime * Cos((FPointA.X+FPointB.Y) * 3) * 0.1986 * FWindIntensity);

      FMovementScale.x:= FMovementScale.x + Cos(FMovementScale.Y * 2) + Environments[0].Environment.WindSpeed.X/25;
      FMovementScale.y:= FMovementScale.y + Cos(FMovementScale.Z * 2) - Environments[0].Environment.WindSpeed.Y/25;
      FMovementScale.z:= FMovementScale.z + Cos(FMovementScale.X * 2) + Environments[0].Environment.WindSpeed.Z/25;
      FMovementScale.Normalize;

      FMovementScale.Scale(((FCableLength - FAnchorsLength) / 2) * Sin((ASegment / (FController.Segments-1)) * D3DX_PI) * Saturate(FWindIntensity/100));

      FBufferData[ASegment*2].Position.x:= FBufferData[ASegment*2].Position.x + FMovementScale.x;
      FBufferData[ASegment*2].Position.y:= FBufferData[ASegment*2].Position.y - FMovementScale.y;
      FBufferData[ASegment*2].Position.z:= FBufferData[ASegment*2].Position.z + FMovementScale.z;
    end;
  end;

begin
  if not Visible then Exit;

  // Get the view origin for billboarding
  if ALighting then
  begin
    if z3DLightingController.CurrentLight.Style = z3dlsDirectional then
    FViewOrigin:= z3DFloat3.From(z3DLightingController.CurrentLight.Frustum.LookAt).Scale(-100) else
    FViewOrigin:= z3DLightingController.CurrentLight.Frustum.LookAt;
  end else FViewOrigin:= z3DScenario.ViewFrustum.Position;

  // Prepare the variables
  FAnchorsLength:= z3DFloat3.From(FPointA).Subtract(FPointB).Length;
  FCableLength:= Max(FLength, FAnchorsLength);
  if System.Length(GetEnvironments) <> 0 then
  FWindIntensity:= Environments[0].Environment.WindSpeed.Length else FWindIntensity:= 0;
  FMovementScale:= z3DFloat3;
  FSegmentVec:= z3DFloat3;
  FBillboard:= z3DFloat3;

  // Update the buffer
  FBufferData:= FController.RopeBuffer.Lock(D3DLOCK_DISCARD);
  try
    for I:= 0 to FController.Segments-1 do
    begin
      if I <> 1 then PrepareSegment(I);
      if I = 0 then
      begin
        PrepareSegment(I+1);
        FSegmentVec.From(FBufferData[(I+1)*2].Position).Subtract(FBufferData[I*2].Position);
      end else FSegmentVec.From(FBufferData[I*2].Position).Subtract(FBufferData[(I-1)*2].Position);

      // Get the billboard extent
      FBillboard.From(FBufferData[I*2].Position).Subtract(FViewOrigin);
      FSegmentVec.Cross(FBillboard).Normalize.Scale(FWidth / 2);

      // Extrude the strip using the billboard plane to reach the desired width
      FBufferData[I*2].Position.x:= FBufferData[I*2].Position.x - FSegmentVec.x;
      FBufferData[I*2].Position.y:= FBufferData[I*2].Position.y - FSegmentVec.y;
      FBufferData[I*2].Position.z:= FBufferData[I*2].Position.z - FSegmentVec.z;
      FBufferData[I*2+1].Position.x:= FBufferData[I*2].Position.x + FSegmentVec.x * 2;
      FBufferData[I*2+1].Position.y:= FBufferData[I*2].Position.y + FSegmentVec.y * 2;
      FBufferData[I*2+1].Position.z:= FBufferData[I*2].Position.z + FSegmentVec.z * 2;
    end;
  finally
    FController.RopeBuffer.Unlock;
  end;

  // Set the materials
  if AMaterials then
  begin
    AShader.Color['GMaterialDiffuseColor']:= FMaterial.ColorDiffuse;
    AShader.Float3['GMaterialEmissiveColor']:= FMaterial.ColorEmissive;
  end;
  AShader.Commit;

  // Draw the rope
  FController.RopeBuffer.Render;
end;

{ Tz3DRopeController }

function Tz3DRopeController.CreateRope: Iz3DRope;
begin
  Result:= Tz3DRope.Create(Self);
  FRopes.Add(Result);
end;

constructor Tz3DRopeController.Create;
begin
  inherited;

  // Link this object to the desired events generated by the z3D Engine
  Notifications:= [z3dlnDevice, z3dlnFrameMove, z3dlnFrameRender, z3dlnLightingRender,
    z3dlnDirectLightRender];

  FSegments:= 32;
  FRopeBuffer:= z3DCreateVertexBuffer;
  FRopeBuffer.Format.AddElement(0, z3dvefFloat3, z3dvemDefault, z3dveuPosition, 0);
//  FRopeBuffer.Format.AddElement(0, z3dvefFloat2, z3dvemDefault, z3dveuTexCoord, 0);
  FRopeBuffer.SetParams(FSegments * 2, D3DUSAGE_DYNAMIC or D3DUSAGE_WRITEONLY, D3DPOOL_DEFAULT);
  FRopes:= TInterfaceList.Create;
end;

function Tz3DRopeController.GetRopeBuffer: Iz3DVertexBuffer;
begin
  Result:= FRopeBuffer;
end;

function Tz3DRopeController.GetRopeCount: Integer;
begin
  Result:= FRopes.Count;
end;

function Tz3DRopeController.GetRopes(const I: Integer): Iz3DRope;
begin
  Result:= FRopes[I] as Iz3DRope;
end;

function Tz3DRopeController.GetSegments: Integer;
begin
  Result:= FSegments;
end;

procedure Tz3DRopeController.RemoveRope(const ARope: Iz3DRope);
begin
  FRopes.Remove(ARope);
end;

procedure Tz3DRopeController.SetSegments(const Value: Integer);
begin
  if FSegments <> Value then
  begin
    FSegments:= Value;
    FRopeBuffer.SetParams(FSegments * 2, D3DUSAGE_DYNAMIC or D3DUSAGE_WRITEONLY, D3DPOOL_DEFAULT);
  end;
end;

procedure Tz3DRopeController.z3DFrameRender;
begin
  inherited;
  if not z3DEngine.Scenario.Enabled or
  (z3DEngine.Renderer.RenderStage <> z3drsDepth) then Exit;
  RenderRopes(z3DEngine.CoreShader);
end;

procedure Tz3DRopeController.z3DLightingRender;
begin
  inherited;
  if not z3DLightingController.OpaqueMode or
  (z3DLightingController.Stage <> z3dlrsDynamicAmbient) then Exit;
  RenderRopes(z3DLightingController.Shader);
end;

procedure Tz3DRopeController.z3DDirectLightRender;
begin
  inherited;
  if not z3DLightingController.OpaqueMode then Exit;
  if z3DLightingController.CurrentLight.Stage = z3ddlrsDynamicShadows then
  RenderRopes(z3DLightingController.Shader, True);
end;

procedure Tz3DRopeController.RenderRopes(const AShader: Iz3DShader; const AUniform: Boolean = False);
var I: Integer;
    FPreviousWidth: Single;
    FPreviousCullMode: Cardinal;
begin
  inherited;

  // Set up the params for rendering
  if z3DEngine.Renderer.RenderStage <> z3drsDepth then // TODO JP: HORRIBLE!
  AShader.Matrix['GWorldMatrix']:= z3DMatrix.Identity;
  AShader.Matrix['GWorldViewMatrix']:= z3DScenario.ViewFrustum.ViewMatrix;
  AShader.Matrix['GWorldViewProjectionMatrix']:= z3DScenario.ViewFrustum.ViewProjMatrix;

  // Turn off culling
  z3DCore_GetD3DDevice.GetRenderState(D3DRS_CULLMODE, FPreviousCullMode);
  z3DCore_GetD3DDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
  try

    // Render the ropes
    FRopeBuffer.Prepare;
    for I:= 0 to FRopes.Count-1 do
    begin

      // Ignore ropes that are outside the view frustum (except on shadows)
      if not AUniform and z3DScenario.ViewFrustum.TestObjectCulling(Ropes[I]) then Continue;

      if AUniform then
      begin
        if z3DLightingController.CurrentLight.Style = z3dlsDirectional then
        begin
          FPreviousWidth:= Ropes[I].Width;
          Ropes[I].Width:= 0.1;
        end;
        Ropes[I].Render(False, True, AShader);
        if z3DLightingController.CurrentLight.Style = z3dlsDirectional then
        Ropes[I].Width:= FPreviousWidth;
      end else
      if z3DEngine.Renderer.RenderStage <> z3drsDepth then // TODO JP: HORRIBLE!
      Ropes[I].Render(True, False, AShader) else
      Ropes[I].Render(False, False, AShader);
     end;

  // Restore previous values
  finally
    z3DCore_GetD3DDevice.SetRenderState(D3DRS_CULLMODE, FPreviousCullMode);
  end;
end;

procedure Tz3DRopeController.z3DFrameMove;
var I: Integer;
begin
  inherited;
  if not z3DScenario.Enabled then Exit;
  
  for I:= 0 to RopeCount-1 do
  begin
    Ropes[I].BoundingBox.Center.From(Ropes[I].PointA).Add(Ropes[I].PointB).Scale(0.5);
    Ropes[I].BoundingBox.Dimensions.From(Ropes[I].PointB).Subtract(Ropes[I].PointA);
    Ropes[I].BoundingBox.Dimensions.X:= Abs(Ropes[I].BoundingBox.Dimensions.X);
    Ropes[I].BoundingBox.Dimensions.Y:= Abs(Ropes[I].BoundingBox.Dimensions.Y);
    Ropes[I].BoundingBox.Dimensions.Z:= Abs(Ropes[I].BoundingBox.Dimensions.Z);
    Ropes[I].BoundingSphere.Center.From(Ropes[I].BoundingBox.Center);
    Ropes[I].BoundingSphere.Radius:= z3DFloat3.From(Ropes[I].PointB).Subtract(Ropes[I].PointA).Length * 0.5;
    Ropes[I].FrameMove;
  end;
end;

{ Tz3DAmbientSource }

procedure Tz3DAmbientSource.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FColor:= z3DFloat3;
  FCenter:= z3DFloat3;
  FRange:= 1;
end;

function Tz3DAmbientSource.GetCenter: Iz3DFloat3;
begin
  Result:= FCenter;
end;

function Tz3DAmbientSource.GetColor: Iz3DFloat3;
begin
  Result:= FColor;
end;

function Tz3DAmbientSource.GetRange: Single;
begin
  Result:= FRange;
end;

procedure Tz3DAmbientSource.SetRange(const Value: Single);
begin
  FRange:= Value;
end;

end.
