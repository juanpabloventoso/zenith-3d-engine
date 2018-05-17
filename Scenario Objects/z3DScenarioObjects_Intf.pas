unit z3DScenarioObjects_Intf;

interface

uses Windows, D3DX9, z3DMath_Intf, z3DComponents_Intf, z3DClasses_Intf,
  z3DScenario_Intf, z3DLighting_Intf;


const

  z3dcWasDownMask       = $80;
  z3DcIsDownMask        = $01;

  z3DcMouseLeftButton   = $01;
  z3DcMouseMiddleButton = $02;
  z3DcMouseRightButton  = $04;
  z3DcMouseWheel        = $08;

type

  Tz3DMouseButton = (z3DmbLeft, z3DmbMiddle, z3DmbRight, z3DmbWheel);

  Tz3DCameraInputKeys = (z3dckStrafeLeft, z3dckStrafeRight, z3dckMoveForward,
    z3dckMoveBackward, z3dckMoveUp, z3dckMoveDown, z3dckReset, z3dckControlDown,
    z3dckJump, z3dckZoomIn, z3dckZoomOut, z3dckMaxKeys, z3dckUnknown);





{==============================================================================}
{== Arcball interface                                                        ==}
{==============================================================================}
{== Mouse rotation handler                                                   ==}
{==============================================================================}

  Iz3DArcBall = interface(Iz3DBase)['{3AC7CF6A-EC55-4AEA-99A0-BC517564F6C7}']
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
    procedure HandleMessages(var Msg: TMsg; var Handled: Boolean); overload; stdcall;
    function RotationMatrix: Iz3DMatrix; stdcall;
    function TranslationMatrix: Iz3DMatrix; stdcall;
    function TranslationDeltaMatrix: Iz3DMatrix; stdcall;

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

  Iz3DCameraKeys = interface(Iz3DBase)['{AF6F8852-233F-4945-B08A-4C05A1558AE0}']
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

  Tz3DZoomMode = (z3dzmConstant, z3dzmLinear, z3dzmExponential);

  Iz3DBaseCamera = interface(Iz3DBase)['{07495766-B251-4B6A-A6D8-5E106BB88E57}']
    function GetZoomFactor: Single; stdcall;
    procedure SetZoomFactor(const Value: Single); stdcall;
    function GetMaxZoom: Single; stdcall;
    function GetMinZoom: Single; stdcall;
    function GetZoomMode: Tz3DZoomMode; stdcall;
    procedure SetMaxZoom(const Value: Single); stdcall;
    procedure SetMinZoom(const Value: Single); stdcall;
    procedure SetZoomMode(const Value: Tz3DZoomMode); stdcall;
    function GetKeys: Iz3DCameraKeys; stdcall;
    function GetDragging: Boolean; stdcall;
    procedure SetZoom(const Value: Single); stdcall;
    function GetClipMax: Iz3DFloat3; stdcall;
    function GetClipMin: Iz3DFloat3; stdcall;
    function GetClipping: Boolean; stdcall;
    function GetDragRect: TRect; stdcall;
    function GetZoom: Single; stdcall;
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
    function MapKey(const AKey: LongWord): Tz3DCameraInputKeys; stdcall;
    function IsKeyDown(const AKey: Byte): Boolean; stdcall;
    function WasKeyDown(const AKey: Byte): Boolean; stdcall;
    procedure ConstrainToBoundary(var AVector: Iz3DFloat3); stdcall;
    procedure UpdateVelocity(const AElapsedTime: Single); stdcall;
    procedure GetInput(const AGetKeyboardInput, AGetMouseInput, AGetGamepadInput, AResetCursorAfterMove: Boolean); stdcall;
    procedure SetScalers(const ARotationScaler: Single = 0.01; const AMoveScaler: Single = 5); stdcall;
    procedure SetDragRect(const ARect: TRect); stdcall;
    function ViewMatrix: Iz3DMatrix; stdcall;
    function ProjectionMatrix: Iz3DMatrix; stdcall;

    property MouseLButtonDown: Boolean read GetMouseLButtonDown;
    property MouseMButtonDown: Boolean read GetMouseMButtonDown;
    property MouseRButtonDown: Boolean read GetMouseRButtonDown;
    property Keys: Iz3DCameraKeys read GetKeys;
    property Dragging: Boolean read GetDragging;
    property DragRect: TRect read GetDragRect write SetDragRect;
    property InvertPitch: Boolean read GetInvertPitch write SetInvertPitch;
    property EnablePosMovement: Boolean read GetEnableMovement write SetEnableMovement;
    property EnableYMovement: Boolean read GetEnableYMovement write SetEnableYMovement;
    property SmoothMovement: Boolean read GetSmoothMovement write SetSmoothMovement;
    property Clipping: Boolean read GetClipping write SetClipping;
    property ClipMin: Iz3DFloat3 read GetClipMin;
    property ClipMax: Iz3DFloat3 read GetClipMax;
    property DragTime: Single read GetTotalDragTime write SetTotalDragTime;
    property SmoothFrames: Integer read GetSmoothFrameCount write SetSmoothFrameCount;
    property Active: Boolean read GetActive write SetActive;
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
{== Object view camera interface                                             ==}
{==============================================================================}
{== Camera that centers its view on a model                                  ==}
{==============================================================================}

  Iz3DObjectCameraMouseButtons = interface(Iz3DBase)['{78537843-44F2-452E-A1F1-8D31D72A8745}']
    procedure SetRotateCamera(const Value: Tz3DMouseButton); stdcall;
    procedure SetRotateObject(const Value: Tz3DMouseButton); stdcall;
    procedure SetZoom(const Value: Tz3DMouseButton); stdcall;
    function GetRotateCamera: Tz3DMouseButton; stdcall;
    function GetRotateObject: Tz3DMouseButton; stdcall;
    function GetZoom: Tz3DMouseButton; stdcall;

    property RotateObject: Tz3DMouseButton read GetRotateObject write SetRotateObject;
    property Zoom: Tz3DMouseButton read GetZoom write SetZoom;
    property RotateCamera: Tz3DMouseButton read GetRotateCamera write SetRotateCamera;
  end;

  Iz3DObjectCamera = interface(Iz3DBaseCamera)['{A1BC38B2-17A9-4487-8B22-266A6EFABFB0}']
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
    procedure SetWindow(const AWidth, AHeight: Integer; const AArcballRadius: Single = 0.9); stdcall;
    function GetWorldMatrix: Iz3DMatrix; stdcall;
    procedure SetWorldMatrix(const AMatrix: Iz3DMatrix); stdcall;
    function ObjectMatrix: Iz3DMatrix; stdcall;
    procedure SetObject(const AObject: Iz3DScenarioObject); stdcall;

    property Attached: Boolean read GetAttached write SetAttached;
    property LimitPitch: Boolean read GetLimitPitch write SetLimitPitch;
    property MouseButtons: Iz3DObjectCameraMouseButtons read GetMouseButtons;
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

  Iz3DFirstPersonCamera = interface;

  Iz3DFirstPersonCameraRotateButtons = interface(Iz3DBase)['{E013E6E6-529A-4AF8-BEE8-787F1DD935CC}']
    procedure SetIgnoreButtons(const Value: Boolean); stdcall;
    procedure SetLeft(const Value: Boolean); stdcall;
    procedure SetMiddle(const Value: Boolean); stdcall;
    procedure SetRight(const Value: Boolean); stdcall;
    function GetIgnoreButtons: Boolean; stdcall;
    function GetLeft: Boolean; stdcall;
    function GetMiddle: Boolean; stdcall;
    function GetRight: Boolean; stdcall;

    property Left: Boolean read GetLeft write SetLeft;
    property Middle: Boolean read GetMiddle write SetMiddle;
    property Right: Boolean read GetRight write SetRight;
    property IgnoreButtons: Boolean read GetIgnoreButtons write SetIgnoreButtons;
  end;

  Iz3DFirstPersonCamera = interface(Iz3DBaseCamera)['{CC0658A4-E5E2-46A8-9123-8D77ED8A8014}']
    function GetEnableFlashLight: Boolean; stdcall;
    procedure SetEnableFlashLight(const Value: Boolean); stdcall;
    function GetResetCursorAfterMove: Boolean; stdcall;
    function GetRotateButtons: Iz3DFirstPersonCameraRotateButtons; stdcall;
    procedure SetResetCursorAfterMove(const Value: Boolean); stdcall;
    procedure SetButtons(const ALeft, AMiddle, ARight: Boolean); stdcall;
    procedure SetFirstPerson(const AObject: Iz3DScenarioDynamicObject); stdcall;
    function GetWorldMatrix: Iz3DMatrix; stdcall;
    function GetWorldRight: Iz3DFloat3; stdcall;
    function GetWorldUp: Iz3DFloat3; stdcall;
    function GetWorldAhead: Iz3DFloat3; stdcall;
    function GetEyePt: Iz3DFloat3; stdcall;

    property RotateButtons: Iz3DFirstPersonCameraRotateButtons read GetRotateButtons;
    property ResetCursorAfterMove: Boolean read GetResetCursorAfterMove write SetResetCursorAfterMove;
    property EnableFlashLight: Boolean read GetEnableFlashLight write SetEnableFlashLight;
    property WorldUp: Iz3DFloat3 read GetWorldUp;
    property WorldAhead: Iz3DFloat3 read GetWorldAhead;
  end;




{==============================================================================}
{== Camera controller interface                                              ==}
{==============================================================================}
{== Manages and controls camera creation and allows to easy activate or      ==}
{== disable a camera                                                         ==}
{==============================================================================}

  Iz3DCameraController = interface(Iz3DBase)['{0FD91D09-22D5-47E0-8942-EB12CD661578}']
    function GetCameraCount: Integer; stdcall;
    function GetCameras(const AIndex: Integer): Iz3DBaseCamera; stdcall;
    function GetActiveCamera: Iz3DBaseCamera; stdcall;
    procedure SetActiveCamera(const Value: Iz3DBaseCamera); stdcall;

    procedure AddCamera(const ACamera: Iz3DBaseCamera); stdcall;
    procedure RemoveCamera(const ACamera: Iz3DBaseCamera); stdcall;
    function CreateObjectCamera: Iz3DObjectCamera; stdcall;
    function CreateFirstPersonCamera: Iz3DFirstPersonCamera; stdcall;

    property Cameras[const AIndex: Integer]: Iz3DBaseCamera read GetCameras;
    property CameraCount: Integer read GetCameraCount;
    property ActiveCamera: Iz3DBaseCamera read GetActiveCamera write SetActiveCamera;
  end;


const
  Cz3DCameraMouseButton: array[Tz3DMouseButton] of Integer =
    (z3dcMouseLeftButton, z3dcMouseMiddleButton, z3dcMouseRightButton, z3dcMouseWheel);



{==============================================================================}
{== Sky box interface                                                        ==}
{==============================================================================}
{== Creates a skybox with an environment map texture                         ==}
{==============================================================================}


type

  Pz3DSkyboxVert = ^Tz3DSkyboxVert;
  Tz3DSkyboxVert = packed record
    Position: TD3DXVector4;
  end;

  Pz3DSkyboxVertArray = ^Tz3DSkyboxVertArray;
  Tz3DSkyboxVertArray = array[0..MaxInt div SizeOf(Tz3DSkyboxVert)-1] of Tz3DSkyboxVert;

  Iz3DSkyBox = interface(Iz3DBase)['{D8124BC6-B411-4AF0-9F98-0095BBD0685D}']
    function GetActive: Boolean; stdcall;
    function GetFileName: PWideChar; stdcall;
    procedure SetActive(const Value: Boolean); stdcall;
    procedure SetFileName(const Value: PWideChar); stdcall;
    procedure CreateTexture; stdcall;
    procedure UpdateVertexBuffer; stdcall;

    procedure FrameRender; stdcall;
    procedure StartScenario; stdcall;
    procedure ResetDevice; stdcall;
    procedure FrameMove; stdcall;

    property FileName: PWideChar read GetFileName write SetFileName;
    property Active: Boolean read GetActive write SetActive;
  end;




{==============================================================================}
{== Sky interface                                                            ==}
{==============================================================================}
{== Manages a sky emulation for the scene and allows to use automatic lights ==}
{== like stars or planets                                                    ==}
{==============================================================================}

  Tz3DSkyMode = (z3dsmSkyBox, z3dsmLinear, z3dsmRayleigh, z3dsmCustom);

  Iz3DSky = interface(Iz3DBase)['{B418431D-18FC-41A8-ACFC-C33A1D5A3AC9}']
    function GetMode: Tz3DSkyMode; stdcall;
    procedure SetMode(const Value: Tz3DSkyMode); stdcall;
    function GetSkyBox: Iz3DSkyBox; stdcall;
    function GetActive: Boolean; stdcall;
    procedure SetActive(const Value: Boolean); stdcall;

    function AddStarLight: Iz3DLight; stdcall;

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

  Iz3DEarthSky = interface(Iz3DSky)['{E88C00AC-5D01-45BB-B1F7-E732D203C490}']
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

    property HazeAmount: Single read GetHazeAmount write SetHazeAmount;
    property RayleighRatio: Iz3DFloat3 read GetRayleighRatio;
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

  Iz3DSkyController = interface(Iz3DBase)['{793FEC06-5502-4F86-86D0-F6261B5BC09C}']
    function GetShader: Iz3DShader; stdcall;
    function GetActiveSky: Iz3DSky; stdcall;
    procedure SetActiveSky(const Value: Iz3DSky); stdcall;
    function GetSkyCount: Integer; stdcall;

    function CreateSky: Iz3DSky; stdcall;
    function CreateEarthSky: Iz3DEarthSky; stdcall;
    procedure AddSky(const ASky: Iz3DSky); stdcall;

    property ActiveSky: Iz3DSky read GetActiveSky write SetActiveSky;
    property Shader: Iz3DShader read GetShader;
    property SkyCount: Integer read GetSkyCount;
  end;





{==============================================================================}
{== Rope object                                                              ==}
{==============================================================================}
{== Creates a generic rope (cable, thread, etc.) in the scenario             ==}
{==============================================================================}

  // Rope vertex struct
  Pz3DRopeVertex = ^Tz3DRopeVertex;
  Tz3DRopeVertex = packed record
    Position: TD3DXVector3;
  end;
  Pz3DRopeVertexArray = ^Tz3DRopeVertexArray;
  Tz3DRopeVertexArray = array[0..MaxInt div SizeOf(Tz3DRopeVertex)-1] of Tz3DRopeVertex;

  Iz3DRope = interface(Iz3DScenarioObject)['{D88FE419-FB1C-4283-ABEF-AFAE4E280D22}']
    function GetLength: Single; stdcall;
    function GetMaterial: Iz3DMaterial; stdcall;
    function GetPointA: Iz3DFloat3; stdcall;
    function GetPointB: Iz3DFloat3; stdcall;
    function GetWidth: Single; stdcall;
    procedure SetLength(const Value: Single); stdcall;
    procedure SetWidth(const Value: Single); stdcall;

//    procedure Render(const AViewOrigin: Iz3DFloat3); stdcall;

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

  Iz3DRopeController = interface(Iz3DBase)['{F1636058-26B7-4B42-B4B8-8E76D9B09DBD}']
    function GetRopeCount: Integer; stdcall;
    function GetRopes(const I: Integer): Iz3DRope; stdcall;
    function GetRopeBuffer: Iz3DVertexBuffer; stdcall;
    function GetSegments: Integer; stdcall;
    procedure SetSegments(const Value: Integer); stdcall;

    function CreateRope: Iz3DRope; stdcall;
    procedure RemoveRope(const ARope: Iz3DRope); stdcall;
    procedure RenderRopes(const AShader: Iz3DShader; const AUniform: Boolean = False); stdcall;

    property RopeCount: Integer read GetRopeCount;
    property Ropes[const I: Integer]: Iz3DRope read GetRopes;
    property RopeBuffer: Iz3DVertexBuffer read GetRopeBuffer;
    property Segments: Integer read GetSegments write SetSegments;
  end;



  Iz3DAmbientSource = interface(Iz3DScenarioEntity)['{F9ACC71D-053E-4138-860C-E14E5B3AC9EF}']
    function GetCenter: Iz3DFloat3; stdcall;
    function GetColor: Iz3DFloat3; stdcall;
    function GetRange: Single; stdcall;
    procedure SetRange(const Value: Single); stdcall;

    property Center: Iz3DFloat3 read GetCenter;
    property Color: Iz3DFloat3 read GetColor;
    property Range: Single read GetRange write SetRange; 
  end;

implementation

end.
