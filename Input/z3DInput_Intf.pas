unit z3DInput_Intf;

interface

uses Windows, XInput, StrSafe;

type

  TXInputGetState = function(dwUserIndex: DWORD; out pState: TXInputState): DWORD; stdcall;
  TXInputSetState = function(dwUserIndex: DWORD; const pVibration: TXInputVibration): DWORD; stdcall;
  TXInputGetCapabilities = function(dwUserIndex: DWORD; dwFlags: DWORD; out pCapabilities: TXInputCapabilities): DWORD; stdcall;
  TXInputEnable = procedure (bEnable: BOOL); stdcall;

  Pz3DGamePad = ^Tz3DGamePad;
  Tz3DGamePad = record
    wButtons: Word;
    bLeftTrigger: Byte;
    bRightTrigger: Byte;
    sThumbLX: Smallint;
    sThumbLY: Smallint;
    sThumbRX: Smallint;
    sThumbRY: Smallint;
    caps: XINPUT_CAPABILITIES;
    bConnected: Boolean;
    bInserted: Boolean;
    bRemoved: Boolean;
    fThumbRX: Single;
    fThumbRY: Single;
    fThumbLX: Single;
    fThumbLY: Single;
    wPressedButtons: Word;
    bPressedLeftTrigger: Boolean;
    bPressedRightTrigger: Boolean;
    wLastButtons: Word;
    bLastLeftTrigger: Boolean;
    bLastRightTrigger: Boolean;
  end;

const
  // Global engine constants
  INPUT_MAX_CONTROLLERS                  = 4;
  INPUT_GAMEPAD_TRIGGER_THRESHOLD        = 30;
  INPUT_DEADZONE                         = (0.24 * $7FFF);

implementation

end.
