library z3DCore;

uses
  z3DCore_Intf,
  z3DCore_Impl,
  z3DAppStart;

exports
  DynArrayContains,

  // Dynamic linking
  z3DCreateDynamicDirect3D9,

  z3DD3DFormatToString,
  z3DTraceD3DDECLUSAGEtoString,
  z3DTraceD3DDECLMETHODtoString,
  z3DTraceD3DDECLTYPEtoString,

  // Get info from monitors
  z3DMonitorFromWindow,
  z3DGetMonitorInfo,

  {$IFDEF D5_OR_FPC}
  WideFormatBuf,
  {$ENDIF}

  // Wide char extended support

  z3DCreateWideChar,
  z3DWideBuffer,
  z3DFreeWideChar,

  {==============================================================================}
  {== Global access functions                                                  ==}
  {==============================================================================}
  {== These functions controls the core state and allows to communicate with   ==}
  {== the core controllers                                                     ==}
  {==============================================================================}

  z3DInit,
  z3DCore_Shutdown,

  z3DCore_CreateWindow,
  z3DCore_SetWindow,
  z3DCore_StaticWndProc,

  z3DDisplayErrorMessage,
  z3DCore_CreateDevice,
  z3DCore_CreateDeviceFromSettings,
  z3DCore_SetDevice,
  z3DCore_MainLoop,
  z3DCore_ProcessMessages,
  z3DCore_Render3DEnvironment,

  z3DCore_GetDeviceList,
  z3DCore_GetStencilBits,
  z3DCore_GetDepthBits,
  z3DCore_GetAlphaChannelBits,
  z3DCore_GetColorChannelBits,

  z3DCore_GetGlobalResourceCache,
  z3DCore_GetGlobalTimer,
  z3DCore_GetState,
  z3DCore_FreeState,
  z3DCore_GetD3DObject,
  z3DCore_GetD3DDevice,
  z3DCore_GetDeviceSettings,
  z3DCore_GetPresentParameters,
  z3DCore_GetBackBufferSurfaceDesc,
  z3DCore_GetDeviceCaps,
  z3DCore_GetHINSTANCE,
  z3DCore_GetHWND,
  z3DCore_GetHWNDFocus,
  z3DCore_GetHWNDDeviceFullScreen,
  z3DCore_GetHWNDDeviceWindowed,
  z3DCore_GetWindowClientRect,
  z3DCore_GetWindowClientRectAtModeChange,
  z3DCore_GetFullsceenClientRectAtModeChange,
  z3DCore_GetTime,
  z3DCore_GetElapsedTime,
  z3DCore_IsWindowed,
  z3DCore_GetFPS,
  z3DCore_GetWindowTitle,
  z3DCore_GetFrameStats,
  z3DCore_GetDeviceStats,
  z3DCore_IsRenderingPaused,
  z3DCore_IsTimePaused,
  z3DCore_IsActive,
  z3DCore_GetExitCode,
  z3DCore_GetShowMsgBoxOnError,
  z3DCore_GetHandleDefaultHotkeys,
  z3DCore_IsKeyDown,
  z3DCore_IsMouseButtonDown,
  z3DCore_GetAutomation,
  z3DCore_FindValidDeviceSettings,

  z3DCore_SetCursorSettings,
  z3DCore_SetMultimonSettings,
  z3DCore_SetShortcutKeySettings,
  z3DCore_SetWindowSettings,
  z3DCore_SetConstantFrameTime,
  z3DCore_SetTimer,
  z3DCore_KillTimer,
  z3DCore_ToggleFullScreen,
  z3DCore_ToggleREF,
  z3DCore_Pause,
  z3DCore_ResetEngineState,

  z3DCore_GetDesktopResolution,
  z3DCore_CreateRefDevice,

  // Callback functions
  z3DCore_SetCallback_DeviceCreated,
  z3DCore_SetCallback_DeviceReset,
  z3DCore_SetCallback_DeviceLost,
  z3DCore_SetCallback_DeviceDestroyed,
  z3DCore_SetCallback_DeviceChanging,
  z3DCore_SetCallback_FrameMove,
  z3DCore_SetCallback_FrameRender,
  z3DCore_SetCallback_Keyboard,
  z3DCore_SetCallback_Mouse,
  z3DCore_SetCallback_MsgProc,

  // App starter
  z3DCore_LaunchAppStart,

  // Registry control
  z3DCore_ReadRegIntValue,
  z3DCore_ReadRegStrValue,
  z3DCore_WriteRegIntValue,
  z3DCore_WriteRegStrValue,

  // Debug mode and memory management
  z3DSupports,
  FreeAndNil,
  SafeRelease,
  SafeDelete,
  SafeFreeMem,
  z3DCore_OutputDebugString,
  z3DCore_OutputDebugStringA,
  z3DTrace,
  z3DTraceCondition,
  z3DTraceDX,
  z3DError,
  z3DErrorMessage,
  z3DTraceDebug,
  z3DFailedTrace;

{$R *.res}

begin
  // Turn on internal debug trace log. See C:\z3DDebug.txt for details.
//  z3DDebugTrace:= True;
end.
