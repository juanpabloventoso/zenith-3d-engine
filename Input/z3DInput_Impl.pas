unit z3DInput_Impl;

interface

uses Windows, StrSafe, XInput, z3DInput_Intf;

function z3DGetGamepadState(const APort: DWORD; out AGamePad: Tz3DGamePad;
  const AThumbstickDeadZone: Boolean = True; const ASnapThumbstickToCardinals: Boolean = True): HRESULT; stdcall;
function z3DStopRumbleOnAllControllers: HRESULT; stdcall;
procedure z3DEnableXInput(const AEnable: Boolean); stdcall;

implementation

const
  s_pXInputGetState: TXInputGetState = nil;
  s_pXInputGetCapabilities: TXInputGetCapabilities = nil;

function z3DGetGamepadState(const APort: DWORD; out AGamePad: Tz3DGamePad;
  const AThumbstickDeadZone: Boolean = True; const ASnapThumbstickToCardinals: Boolean = True): HRESULT;
var
  wszPath: array[0..MAX_PATH-1] of WideChar;
  hInst: Windows.HINST;
  InputState: TXInputState;
  dwResult: DWORD;
  bWasConnected: Boolean;
  bPressed: Boolean;
begin
  if (APort >= INPUT_MAX_CONTROLLERS) {or (pGamePad = nil)} then
  begin
    Result:= E_FAIL;
    Exit;
  end;

  if (@s_pXInputGetState = nil) or (@s_pXInputGetCapabilities = nil) then
  begin
    if GetSystemDirectoryW(wszPath, MAX_PATH) <> 0 then
    begin
      StringCchCat(wszPath, MAX_PATH, '\');
      StringCchCat(wszPath, MAX_PATH, XINPUT_DLL);
      hInst := LoadLibraryW(wszPath);
      if (hInst <> 0) then 
      begin
        s_pXInputGetState := GetProcAddress(hInst, 'XInputGetState');
        s_pXInputGetCapabilities := GetProcAddress(hInst, 'XInputGetCapabilities');
      end;
    end;
  end;
  if (@s_pXInputGetState = nil) then
  begin
    Result:= E_FAIL;
    Exit;
  end;

  dwResult := s_pXInputGetState(APort, InputState);

  bWasConnected := AGamePad.bConnected;
  AGamePad.bConnected := (dwResult = ERROR_SUCCESS);
  AGamePad.bRemoved   := (    bWasConnected and not AGamePad.bConnected);
  AGamePad.bInserted  := (not bWasConnected and     AGamePad.bConnected);

  if (not AGamePad.bConnected) then
  begin
    Result:= S_OK;
    Exit;
  end;

  if (AGamePad.bInserted) then
  begin
    ZeroMemory(@AGamePad, SizeOf(Tz3DGamePad));
    AGamePad.bConnected := True;
    AGamePad.bInserted  := True;
    if (@s_pXInputGetCapabilities <> nil)
    then s_pXInputGetCapabilities(APort, XINPUT_DEVTYPE_GAMEPAD, AGamePad.caps);
  end;

  CopyMemory(@AGamePad, @InputState.Gamepad, SizeOf(Tz3DGamePad));

  if ASnapThumbstickToCardinals then
  begin
    if (AGamePad.sThumbLX < INPUT_DEADZONE) and (AGamePad.sThumbLX > -INPUT_DEADZONE) then AGamePad.sThumbLX := 0;
    if (AGamePad.sThumbLY < INPUT_DEADZONE) and (AGamePad.sThumbLY > -INPUT_DEADZONE) then AGamePad.sThumbLY := 0;
    if (AGamePad.sThumbRX < INPUT_DEADZONE) and (AGamePad.sThumbRX > -INPUT_DEADZONE) then AGamePad.sThumbRX := 0;
    if (AGamePad.sThumbRY < INPUT_DEADZONE) and (AGamePad.sThumbRY > -INPUT_DEADZONE) then AGamePad.sThumbRY := 0;
  end
  else if (AThumbstickDeadZone) then
  begin
    if (AGamePad.sThumbLX < INPUT_DEADZONE) and (AGamePad.sThumbLX > -INPUT_DEADZONE) and
       (AGamePad.sThumbLY < INPUT_DEADZONE) and (AGamePad.sThumbLY > -INPUT_DEADZONE) then
    begin
      AGamePad.sThumbLX := 0;
      AGamePad.sThumbLY := 0;
    end;
    if (AGamePad.sThumbRX < INPUT_DEADZONE) and (AGamePad.sThumbRX > -INPUT_DEADZONE) and
       (AGamePad.sThumbRY < INPUT_DEADZONE) and (AGamePad.sThumbRY > -INPUT_DEADZONE) then
    begin
      AGamePad.sThumbRX := 0;
      AGamePad.sThumbRY := 0;
    end;
  end;

  AGamePad.fThumbLX := AGamePad.sThumbLX / 32767;
  AGamePad.fThumbLY := AGamePad.sThumbLY / 32767;
  AGamePad.fThumbRX := AGamePad.sThumbRX / 32767;
  AGamePad.fThumbRY := AGamePad.sThumbRY / 32767;

  AGamePad.wPressedButtons := (AGamePad.wLastButtons xor AGamePad.wButtons) and AGamePad.wButtons;
  AGamePad.wLastButtons    := AGamePad.wButtons;

  bPressed := (AGamePad.bLeftTrigger > INPUT_GAMEPAD_TRIGGER_THRESHOLD);
  if bPressed then AGamePad.bPressedLeftTrigger := not AGamePad.bLastLeftTrigger
  else AGamePad.bPressedLeftTrigger := False;
  AGamePad.bLastLeftTrigger := bPressed;

  bPressed := (AGamePad.bRightTrigger > INPUT_GAMEPAD_TRIGGER_THRESHOLD);
  if bPressed then AGamePad.bPressedRightTrigger := not AGamePad.bLastRightTrigger
  else AGamePad.bPressedRightTrigger := False;
  AGamePad.bLastRightTrigger := bPressed;

  Result:= S_OK;
end;

const
  s_pXInputSetState: TXInputSetState = nil;

function z3DStopRumbleOnAllControllers: HRESULT;
var
  wszPath: array[0..MAX_PATH-1] of WideChar;
  vibration: TXInputVibration;
  iUserIndex: Integer;
  hInst: Windows.HINST;
begin
  if (@s_pXInputSetState = nil) then
  begin
    if GetSystemDirectoryW(wszPath, MAX_PATH) <> 0 then
    begin
      StringCchCat(wszPath, MAX_PATH, '\');
      StringCchCat(wszPath, MAX_PATH, XINPUT_DLL);
      hInst := LoadLibraryW(wszPath);
      if (hInst <> 0) then
        s_pXInputSetState := GetProcAddress(hInst, 'XInputSetState');
    end;
  end;
  if (@s_pXInputSetState = nil) then
  begin
    Result:= E_FAIL;
    Exit;
  end;
  vibration.wLeftMotorSpeed  := 0;
  vibration.wRightMotorSpeed := 0;
  for iUserIndex := 0 to INPUT_MAX_CONTROLLERS - 1 do
    s_pXInputSetState(iUserIndex, vibration);
  Result:= S_OK;
end;

const s_pXInputEnable: TXInputEnable = nil;

procedure z3DEnableXInput(const AEnable: Boolean);
var
  wszPath: array[0..MAX_PATH-1] of WideChar;
  hInst: THandle;
begin
  if (@s_pXInputEnable = nil) then
  begin
    if (GetSystemDirectoryW(wszPath, MAX_PATH) <> 0) then
    begin
      StringCchCat(wszPath, MAX_PATH, '\');
      StringCchCat(wszPath, MAX_PATH, XINPUT_DLL);
      hInst := LoadLibraryW(wszPath);
      if (hInst <> 0) then s_pXInputEnable := TXInputEnable(GetProcAddress(hInst, 'XInputEnable'));
    end;
  end;
  if (@s_pXInputEnable <> nil) then s_pXInputEnable(AEnable);
end;

end.
