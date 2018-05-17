unit z3DInput_Func;

interface

uses Windows, z3DInput_Intf;

const
  z3DInputDLL = 'z3DInput.dll';

function z3DGetGamepadState(const APort: DWORD; out AGamePad: Tz3DGamePad;
  const AThumbstickDeadZone: Boolean = True;
  const ASnapThumbstickToCardinals: Boolean = True): HRESULT; stdcall; external z3DInputDLL;
function z3DStopRumbleOnAllControllers: HRESULT; stdcall; external z3DInputDLL;
procedure z3DEnableXInput(const AEnable: Boolean); stdcall; external z3DInputDLL;

implementation

end.
