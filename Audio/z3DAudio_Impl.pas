{==============================================================================}
{== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==}
{==============================================================================}
{== Unit: z3DAudio. Audio and music controller and functions                 ==}
{==============================================================================}

unit z3DAudio_Impl;

interface

uses
  Windows, MMSystem, DirectSound, z3DAudio_Intf, z3DClasses_Intf, z3DClasses_Impl,
  Classes, ActiveX, z3DScenario_Intf, Controls, MPlayer;



const
  AUDIO_BUFFERS = 1;
  AUDIO_BUFFER_TAIL = 65535;
  WAVE_FORMAT = WAVE_FORMAT_PCM;


const

  // WAV file read and write consts
  WAVEFILE_READ    = 1;
  WAVEFILE_WRITE   = 2;

type

  Tz3DWinControl = class(TWinControl)
  end;

  // PositionNotify extended types
  PADSBPositionNotify = ^ADSBPositionNotify;
  ADSBPositionNotify =  array[0..MaxInt div SizeOf(TDSBPositionNotify) - 1] of TDSBPositionNotify;





  Tz3DAudioController = class;
  Tz3DSound = class;
  Tz3DAudioWaveFile = class;

  Tz3DMusic = class(Tz3DBase, Iz3DMusic)
  private
    FFileName: PWideChar;
    FPlayer: TMediaPlayer;
    FControl: Tz3DWinControl;
  protected
    function GetPlaying: Boolean; stdcall;
    function GetFileName: PWideChar; stdcall;
  public
    procedure Play(const AFileName: PWideChar); stdcall;
    procedure Stop; stdcall;
    procedure Pause; stdcall;
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
    destructor Destroy; override;
  public
    property Playing: Boolean read GetPlaying;
    property FileName: PWideChar read GetFileName;
  end;


  Pz3DSoundEffectParams = ^Tz3DSoundEffectParams;
  Tz3DSoundEffectParams = packed record
    Chorus: TDSFXChorus;
    Echo: TDSFXEcho;
    Flanger: TDSFXFlanger;
    Equalizer: TDSFXParamEq;
    Reverb: TDSFXI3DL2Reverb;
  end;

  Tz3DSoundEnvironment = class(Tz3DBase, Iz3DSoundEnvironment)
  private
    FAutoUpdate: Boolean;
    FEnabled: Boolean;
    FEnableDoppler: Boolean;
    FKind: Tz3DEnvironmentKind;
    FCurrentEffects: TDSEffectDescArray;
    FCurrentKinds: Tz3DSoundEffectKindArray;
    FParams: Tz3DSoundEffectParams;
  protected
    function GetAutoUpdate: Boolean; stdcall;
    function GetEnabled: Boolean; stdcall;
    function GetEnableDoppler: Boolean; stdcall;
    function GetKind: Tz3DEnvironmentKind; stdcall;
    procedure SetAutoUpdate(const Value: Boolean); stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    procedure SetEnableDoppler(const Value: Boolean); stdcall;
    procedure SetKind(const Value: Tz3DEnvironmentKind); stdcall;

    procedure UpdateFromScenario; stdcall;
    procedure PrepareCurrentEnvironment; stdcall;
    procedure ApplyCurrentEnvironment; stdcall;
    procedure ApplyEnvironment(const ASound: Iz3DSound); stdcall;
    function GetCurrentEffects: PDSEffectDescArray; stdcall;
    procedure FrameMove; stdcall;
  public
    procedure Init(const AOwner: Iz3DBase = nil); override; stdcall;
  public
    property AutoUpdate: Boolean read GetAutoUpdate write SetAutoUpdate;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property EnableDoppler: Boolean read GetEnableDoppler write SetEnableDoppler;
    property Kind: Tz3DEnvironmentKind read GetKind write SetKind;
  end;





{==============================================================================}
{== Audio controller interface                                               ==}
{==============================================================================}
{== Global DirectSound manager                                               ==}
{==============================================================================}

  Tz3DAudioController = class(Tz3DLinked, Iz3DAudioController)
  private
    FDirectSound: IDirectSound8;
    FSounds: IInterfaceList;
    FMusic: Iz3DMusic;
    FEnvironment: Iz3DSoundEnvironment;
    FPrimaryBuffer: IDirectSoundBuffer;
  protected
    function GetSounds(const AIndex: Integer): Iz3DSound; stdcall;
    function GetSoundCount: Integer; stdcall;
    function GetEnvironment: Iz3DSoundEnvironment; stdcall;
    function GetDirectSound: IDirectSound8; stdcall;
    function GetMusic: Iz3DMusic; stdcall;
    procedure z3DFrameMove; override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;

    function Initialize(hWnd: HWND; dwCoopLevel: DWORD = DSSCL_PRIORITY): HRESULT; stdcall;
    function SetPrimaryBufferFormat(dwPrimaryChannels, dwPrimaryFreq, dwPrimaryBitRate: DWORD): HRESULT; stdcall;
    function Get3DListener: IDirectSound3DListener; stdcall;

    function CreateSound(const AFileName: PWideChar): Iz3DSound; stdcall;
    function Create3DSound(const AFileName: PWideChar): Iz3DSound; stdcall;
    procedure RemoveSound(const ASound: Iz3DSound); stdcall;
    function GetBufferArray: PIDirectSoundBufferArray; stdcall;
    function GetPrimaryBuffer: IDirectSoundBuffer; stdcall;
  public
    property DirectSound: IDirectSound8 read GetDirectSound;
    property SoundCount: Integer read GetSoundCount;
    property Sounds[const AIndex: Integer]: Iz3DSound read GetSounds;
    property Music: Iz3DMusic read GetMusic;
    property Environment: Iz3DSoundEnvironment read GetEnvironment;
  end;






{==============================================================================}
{== Sound interface                                                          ==}
{==============================================================================}
{== Individual sound manager                                                 ==}
{==============================================================================}

  Tz3DBaseSound = class(Tz3DBase, Iz3DBaseSound)
  private
    FWaveFile: Tz3DAudioWaveFile;
    FBuffers: PIDirectSoundBufferArray;
    FDSBufferSize: DWORD;
    FBufferCount: DWORD;
    FCreationFlags: DWORD;
    FFadeOutLength: Single;
    FFileName: PWideChar;
    FLooping: Boolean;
    FVolume: Integer;
  protected
    function RestoreBuffer(pDSB: IDirectSoundBuffer; pbWasRestored: PBOOL): HRESULT; stdcall;
    function GetVolume: Integer; stdcall;
    procedure SetVolume(const AVolume: Integer); stdcall;
    function GetFileName: PWideChar; stdcall;
    function GetPlaying: Boolean; stdcall;
    function GetLooping: Boolean; stdcall;
    procedure SetLooping(const Value: Boolean); stdcall;
    function GetBufferCount: DWORD; stdcall;
  public
    constructor Create(apDSBuffer: PIDirectSoundBufferArray; dwDSBufferSize: DWORD;
      dwNumBuffers: DWORD; pWaveFile: Tz3DAudioWaveFile; dwCreationFlags: DWORD);
    destructor Destroy; override;

    function FillBufferWithSound(pDSB: IDirectSoundBuffer; bRepeatWavIfBufferLarger: BOOL): HRESULT; stdcall;
    function GetFreeBuffer: IDirectSoundBuffer; stdcall;
    function GetBuffer(const AIndex: DWORD): IDirectSoundBuffer; stdcall;
    function GetBufferArray: PIDirectSoundBufferArray; stdcall;

    procedure Play; stdcall;
    procedure FadeOut(const ALength: Single); stdcall;
    procedure Stop; stdcall;
    procedure Reset; stdcall;
    procedure FrameMove; stdcall;
  public
    property Volume: Integer read GetVolume write SetVolume;
    property Playing: Boolean read GetPlaying;
    property FileName: PWideChar read GetFileName;
    property Looping: Boolean read GetLooping write SetLooping;
    property BufferCount: DWORD read GetBufferCount;
  end;

  Tz3DSound = class(Tz3DBaseSound, Iz3DSound)
  protected
    function GetPan: Integer; stdcall;
    procedure SetPan(const APan: Integer); stdcall;
  public
    function Get3DBuffer(const AIndex: Integer): IDirectSound3DBuffer; stdcall;
    procedure Play3D; stdcall;
  public
    property Pan: Integer read GetPan write SetPan;
  end;











{==============================================================================}
{== Audio wave file reader                                                   ==}
{==============================================================================}
{== Extension for MMIO functions from MMSystem                               ==}
{==============================================================================}

  Tz3DAudioWaveFile = class(Tz3DBase)
  public
    FFormatEx: PWaveFormatEx;
    FMMIO: HMMIO;
    FCKInfo: MMCKINFO;
    FCKInfoRiff: MMCKINFO;
    FSize: DWORD;
    FMMIOInfoOut: MMIOINFO;
    FFlags: DWORD;
    FFromMemory: BOOL;
    FData: PByte;
    FDataCur: PByte;
    FDataSize: Cardinal;
    FResourceBuffer: PChar;
  protected
    function ReadMMIO: HRESULT;
    function WriteMMIO(pwfxDest: PWaveFormatEx): HRESULT;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;

    function Open(strFileName: PWideChar; pwfx: PWaveFormatEx; dwFlags: DWORD): HRESULT;
    function OpenFromMemory(pbData: PByte; ulDataSize: Cardinal; pwfx: PWaveFormatEx; dwFlags: DWORD): HRESULT;
    function Close: HRESULT;

    function Read(pBuffer: PByte; dwSizeToRead: DWORD; pdwSizeRead: PDWORD): HRESULT;
    function Write(nSizeToWrite: LongWord; pbSrcData: PByte; out pnSizeWrote: LongWord): HRESULT;

    function GetSize: DWORD;
    function ResetFile: HRESULT;
    property GetFormat: PWaveFormatEx read FFormatEx;
  end;


const
  FLoopingFlags: array[Boolean] of DWORD = (0, DSBPLAY_LOOPING); 


// Controller management

function z3DCreateAudioController: Iz3DAudioController; stdcall;
function z3DAudioController: Iz3DAudioController; stdcall;
procedure z3DSetCustomAudioController(const AController: Iz3DAudioController); stdcall;

procedure z3DPlaySound(const ASound: Iz3DSound); stdcall;
procedure z3DPlaySoundLooping(const ASound: Iz3DSound); stdcall;
procedure z3DStopSound(const ASound: Iz3DSound); stdcall;

// Global audio engine functions

procedure z3DEnableMusic(const AEnable: Boolean); stdcall;
procedure z3DEnableSounds(const AEnable: Boolean); stdcall;
procedure z3DEnableAudio(const AEnable: Boolean); stdcall;


implementation

uses
  SysUtils, z3DCore_Intf, z3DCore_Func, z3DEngine_Func, z3DScenarioObjects_Func;

{$IFNDEF FPC}
function mmioOpenW(szFileName: PWideChar; lpmmioinfo: PMMIOInfo;
  dwOpenFlags: DWORD): HMMIO; stdcall; external mmsyst{ name 'mmioOpenW'};
{$ENDIF}


var
  GController: Iz3DAudioController;
  GEnableMusic: Boolean;
  GEnableSounds: Boolean;
  GEnableAudio: Boolean;

function z3DCreateAudioController: Iz3DAudioController; stdcall;
begin
  z3DTrace('z3DCreateAudioController: Creating audio controller object...', z3DtkInformation);
  GController:= Tz3DAudioController.Create;
  Result:= GController;
end;

function z3DAudioController: Iz3DAudioController; stdcall;
begin
  Result:= GController;
end;

procedure z3DSetCustomAudioController(const AController: Iz3DAudioController); stdcall;
begin
  GController:= AController;
end;

procedure z3DPlaySound(const ASound: Iz3DSound);
begin
  if Assigned(ASound) then ASound.Play;
end;

procedure z3DPlaySoundLooping(const ASound: Iz3DSound);
begin
  if Assigned(ASound) then
  begin
    ASound.Looping:= True;
    ASound.Play;
  end;
end;

procedure z3DStopSound(const ASound: Iz3DSound);
begin
  if Assigned(ASound) then ASound.Stop;
end;



procedure z3DEnableMusic(const AEnable: Boolean); stdcall;
begin
  GEnableMusic:= AEnable;
end;

procedure z3DEnableSounds(const AEnable: Boolean); stdcall;
begin
  GEnableSounds:= AEnable;
end;

procedure z3DEnableAudio(const AEnable: Boolean); stdcall;
begin
  GEnableAudio:= AEnable;
end;




const
  FillValuesStaticA: array[False..True] of Byte = (0, 128);

{ Tz3DAudioController }

constructor Tz3DAudioController.Create;
begin
  inherited;
  FMusic:= Tz3DMusic.Create;
  FEnvironment:= Tz3DSoundEnvironment.Create;
  Notifications:= [z3dlnFrameMove];
  FSounds:= TInterfaceList.Create;
  FDirectSound:= nil;
end;

destructor Tz3DAudioController.Destroy;
begin
  SafeRelease(FDirectSound);
  inherited;
end;

function Tz3DAudioController.Initialize(hWnd: HWND; dwCoopLevel: DWORD = DSSCL_PRIORITY): HRESULT;
begin
  SafeRelease(FDirectSound);

  // Create IDirectSound using the primary sound device
  Result := DirectSoundCreate8(nil, FDirectSound, nil);
  if FAILED(Result) then
  begin
    z3DTrace('Iz3DAudioController.Initialize failed (DirectSoundCreate8 failed)', z3dtkWarning);
    Exit;
  end;

  // Set DirectSound coop level
  FDirectSound.SetCooperativeLevel(hWnd, dwCoopLevel);

  SetPrimaryBufferFormat(2, 44100, 16);

  Result:= S_OK;
end;

function Tz3DAudioController.SetPrimaryBufferFormat(dwPrimaryChannels,
  dwPrimaryFreq, dwPrimaryBitRate: DWORD): HRESULT;
var
  dsbd: TDSBufferDesc;
  wfx: TWaveFormatEx;
begin

  if (FDirectSound = nil) then
  begin
    Result:= CO_E_NOTINITIALIZED;
    Exit;
  end;

  // Get the primary buffer
  ZeroMemory(@dsbd, SizeOf(TDSBufferDesc));
  dsbd.dwSize        := SizeOf(TDSBufferDesc);
  dsbd.dwFlags       := DSBCAPS_PRIMARYBUFFER;
  dsbd.dwBufferBytes := 0;
  dsbd.lpwfxFormat   := nil;

  Result := FDirectSound.CreateSoundBuffer(dsbd, FPrimaryBuffer, nil);
  if FAILED(Result) then
  begin
    z3DTrace('Iz3DAudioController.SetPrimaryBufferFormat failed (CreateSoundBuffer failed)', z3dtkWarning);
    Exit;
  end;

  ZeroMemory(@wfx, SizeOf(TWaveFormatEx));
  wfx.wFormatTag      := WAVE_FORMAT;
  wfx.nChannels       := dwPrimaryChannels;
  wfx.nSamplesPerSec  := dwPrimaryFreq;
  wfx.wBitsPerSample  := dwPrimaryBitRate;
  wfx.nBlockAlign     := (wfx.wBitsPerSample div 8 * wfx.nChannels);
  wfx.nAvgBytesPerSec := (wfx.nSamplesPerSec * wfx.nBlockAlign);

  if FAILED(FPrimaryBuffer.SetFormat(@wfx)) then
  begin
    z3DTrace('Iz3DAudioController.SetPrimaryBufferFormat failed (SetFormat failed)', z3dtkWarning);
    Exit;
  end;

  Result:= S_OK;
end;

function Tz3DAudioController.CreateSound(const AFileName: PWideChar): Iz3DSound; stdcall;
var
  hrRet: HRESULT;
  i: Integer;
  apDSBuffer: PIDirectSoundBufferArray;
  dwDSBufferSize: DWORD;
  pWaveFile: Tz3DAudioWaveFile;
  dsbd: TDSBufferDesc;
label
  LFail;
begin
  apDSBuffer := nil;
  pWaveFile := nil;
  //Result:= S_OK;

  if (FDirectSound = nil) then
  begin
    z3DTrace('Iz3DAudioController.CreateSound failed: no DirectSound available', z3DtkWarning);
    Exit;
  end;

  try
    try
      GetMem(apDSBuffer, SizeOf(IDirectSoundBuffer) * AUDIO_BUFFERS);
      ZeroMemory(apDSBuffer, SizeOf(IDirectSoundBuffer) * AUDIO_BUFFERS);
      pWaveFile := Tz3DAudioWaveFile.Create;

      pWaveFile.Open(AFileName, nil, WAVEFILE_READ);

      if (pWaveFile.GetSize = 0) then
      begin
        // Wave is blank, so don't create it.
        goto LFail;
      end;

      // Make the DirectSound buffer the same size as the wav file
      dwDSBufferSize := pWaveFile.GetSize + AUDIO_BUFFER_TAIL;

      // Create the direct sound buffer, and only request the flags needed
      // since each requires some overhead and limits if the buffer can
      // be hardware accelerated
      ZeroMemory(@dsbd, SizeOf(TDSBufferDesc));
      dsbd.dwSize          := SizeOf(TDSBufferDesc);
      dsbd.dwFlags         := DSBCAPS_CTRLVOLUME or DSBCAPS_CTRLPAN or DSBCAPS_CTRLFX;
      dsbd.dwBufferBytes   := dwDSBufferSize;
      dsbd.guid3DAlgorithm := GUID_NULL;
      dsbd.lpwfxFormat     := pWaveFile.FFormatEx;

      // DirectSound is only guarenteed to play PCM data.  Other
      // formats may or may not work depending the sound card driver.
      hrRet:= FDirectSound.CreateSoundBuffer(dsbd, apDSBuffer^[0], nil);

      if FAILED(hrRet) then
      begin
        // DSERR_BUFFERTOOSMALL will be returned if the buffer is
        // less than DSBSIZE_FX_MIN and the buffer is created
        // with DSBCAPS_CTRLFX.

        // It might also fail if hardware buffer mixing was requested
        // on a device that doesn't support it.
        z3DTrace('Iz3DAudioController.CreateSound failed (CreateSoundBuffer failed', z3dtkWarning);
        goto LFail;
      end;

      // Default to use DuplicateSoundBuffer() when created extra buffers since always
      // create a buffer that uses the same memory however DuplicateSoundBuffer() will fail if
      // DSBCAPS_CTRLFX is used, so use CreateSoundBuffer() instead in this case.
      for i:= 1 to AUDIO_BUFFERS - 1 do
      begin
        hrRet:= FDirectSound.CreateSoundBuffer(dsbd, apDSBuffer^[i], nil);
        if FAILED(hrRet) then
        begin
          goto LFail;
        end;
      end;

      // Create the sound
      Result:= Tz3DSound.Create(apDSBuffer, dwDSBufferSize, AUDIO_BUFFERS, pWaveFile,
        DSBCAPS_CTRLVOLUME or DSBCAPS_CTRLPAN or DSBCAPS_CTRLFX);
      FSounds.Add(Result);
      Exit;

    LFail: // Cleanup
    {$IFDEF FPC}
      //todo: FPC1.9.2 BUG workaround !!!
      dwNumBuffers := dwNumBuffers;
    {$ENDIF}
    except
      on EOutOfMemory do
      z3DTrace('Iz3DAudioController.CreateSound failed: Out of memory', z3DtkWarning)
      else z3DTrace('Iz3DAudioController.CreateSound failed: Unknown error', z3DtkWarning)
    end;

    // Cleanup
    FreeAndNil(pWaveFile);

  finally
    if Assigned(apDSBuffer) then
      for i:= 0 to AUDIO_BUFFERS - 1 do apDSBuffer[i] := nil;
    FreeMem(apDSBuffer);
  end;
end;

function Tz3DAudioController.Create3DSound(const AFileName: PWideChar): Iz3DSound; stdcall;
var
  hrRet: HRESULT;
  i: Integer;
  apDSBuffer: PIDirectSoundBufferArray;
  dwDSBufferSize: DWORD;
  pWaveFile: Tz3DAudioWaveFile;
  dsbd: TDSBufferDesc;
label
  LFail;
begin
  apDSBuffer := nil;
  pWaveFile := nil;
  //Result:= S_OK;

  if (FDirectSound = nil) then
  begin
    z3DTrace('Iz3DAudioController.Create3DSound failed: no DirectSound available', z3DtkWarning);
    Exit;
  end;

  try
    try
      GetMem(apDSBuffer, SizeOf(IDirectSoundBuffer) * AUDIO_BUFFERS);
      ZeroMemory(apDSBuffer, SizeOf(IDirectSoundBuffer) * AUDIO_BUFFERS);
      pWaveFile := Tz3DAudioWaveFile.Create;

      pWaveFile.Open(AFileName, nil, WAVEFILE_READ);

      if (pWaveFile.GetSize = 0) then
      begin
        // Wave is blank, so don't create it.
        goto LFail;
      end;

      // Make the DirectSound buffer the same size as the wav file
      dwDSBufferSize := pWaveFile.GetSize;

      // Create the direct sound buffer, and only request the flags needed
      // since each requires some overhead and limits if the buffer can
      // be hardware accelerated
      ZeroMemory(@dsbd, SizeOf(TDSBufferDesc));
      dsbd.dwSize          := SizeOf(TDSBufferDesc);
      dsbd.dwFlags         := DSBCAPS_CTRLVOLUME or DSBCAPS_CTRLFX or DSBCAPS_CTRL3D;
      dsbd.dwBufferBytes   := dwDSBufferSize;
      dsbd.guid3DAlgorithm := DS3DALG_HRTF_FULL;
      dsbd.lpwfxFormat     := pWaveFile.FFormatEx;

      // DirectSound is only guarenteed to play PCM data.  Other
      // formats may or may not work depending the sound card driver.
      hrRet:= FDirectSound.CreateSoundBuffer(dsbd, apDSBuffer^[0], nil);

      if FAILED(hrRet) then
      begin
        // DSERR_BUFFERTOOSMALL will be returned if the buffer is
        // less than DSBSIZE_FX_MIN and the buffer is created
        // with DSBCAPS_CTRLFX.

        // It might also fail if hardware buffer mixing was requested
        // on a device that doesn't support it.
        z3DTrace('Iz3DAudioController.CreateSound failed (CreateSoundBuffer failed)', z3dtkWarning);
        goto LFail;
      end;

      // Default to use DuplicateSoundBuffer() when created extra buffers since always
      // create a buffer that uses the same memory however DuplicateSoundBuffer() will fail if
      // DSBCAPS_CTRLFX is used, so use CreateSoundBuffer() instead in this case.
      for i:= 1 to AUDIO_BUFFERS - 1 do
      begin
        hrRet:= FDirectSound.CreateSoundBuffer(dsbd, apDSBuffer^[i], nil);
        if FAILED(hrRet) then
        begin
          goto LFail;
        end;
      end;

      // Create the sound
      Result:= Tz3DSound.Create(apDSBuffer, dwDSBufferSize, AUDIO_BUFFERS, pWaveFile,
        DSBCAPS_CTRLVOLUME or DSBCAPS_CTRLFX or DSBCAPS_CTRL3D);
      FSounds.Add(Result);
      Exit;

    LFail: // Cleanup
    {$IFDEF FPC}
      //todo: FPC1.9.2 BUG workaround !!!
      dwNumBuffers := dwNumBuffers;
    {$ENDIF}
    except
      on EOutOfMemory do
      z3DTrace('Iz3DAudioController.CreateSound failed: Out of memory', z3DtkWarning)
      else z3DTrace('Iz3DAudioController.CreateSound failed: Unknown error', z3DtkWarning)
    end;

    // Cleanup
    FreeAndNil(pWaveFile);

  finally
    if Assigned(apDSBuffer) then
      for i:= 0 to AUDIO_BUFFERS - 1 do apDSBuffer[i] := nil;
    FreeMem(apDSBuffer);
  end;
end;

function Tz3DAudioController.GetDirectSound: IDirectSound8;
begin
  Result:= FDirectSound;
end;

procedure Tz3DAudioController.z3DFrameMove;
var I: Integer;
begin
  inherited;
  FEnvironment.FrameMove;
  for I:= 0 to FSounds.Count-1 do
  (FSounds[I] as Iz3DBaseSound).FrameMove;
end;

procedure Tz3DAudioController.RemoveSound(const ASound: Iz3DSound);
begin
  FSounds.Remove(ASound);
end;

function Tz3DAudioController.Get3DListener: IDirectSound3DListener;
var
  dsbdesc:     TDSBufferDesc;
  HR: HRESULT;
begin
  Result:= nil;
  if (FDirectSound = nil) then Exit;

  if not z3DSupports(FPrimaryBuffer, IID_IDirectSound3DListener) then
  begin
    // Obtain primary buffer, asking it for 3D control
    ZeroMemory(@dsbdesc, Sizeof(TDSBufferDesc));
    dsbdesc.dwSize :=  Sizeof(TDSBufferDesc);
    dsbdesc.dwFlags := DSBCAPS_CTRL3D or DSBCAPS_PRIMARYBUFFER;

    HR:= FDirectSound.CreateSoundBuffer(dsbdesc, FPrimaryBuffer, nil);
    if FAILED(HR) then
    begin
      z3DTrace('Iz3DAudioController.Get3DListenerInterface failed (CreateSoundBuffer failed)', z3dtkWarning);
      Exit;
    end;
  end;
  FPrimaryBuffer.QueryInterface(IID_IDirectSound3DListener, Result);
end;

function Tz3DAudioController.GetMusic: Iz3DMusic;
begin
  Result:= FMusic;
end;

function Tz3DAudioController.GetEnvironment: Iz3DSoundEnvironment;
begin
  Result:= FEnvironment;
end;

function Tz3DAudioController.GetBufferArray: PIDirectSoundBufferArray;
begin
  Result:= nil;
end;

function Tz3DAudioController.GetPrimaryBuffer: IDirectSoundBuffer;
begin
  Result:= FPrimaryBuffer;
end;

function Tz3DAudioController.GetSoundCount: Integer;
begin
  Result:= FSounds.Count;
end;

function Tz3DAudioController.GetSounds(const AIndex: Integer): Iz3DSound;
begin
  Result:= FSounds[AIndex] as Iz3DSound;
end;

{ Tz3DBaseSound }

constructor Tz3DBaseSound.Create(apDSBuffer: PIDirectSoundBufferArray; dwDSBufferSize,
  dwNumBuffers: DWORD; pWaveFile: Tz3DAudioWaveFile; dwCreationFlags: DWORD);
var
  i: Integer;
  FShader: TDSEffectDesc;
  FResult: DWORD;
  HR: HRESULT;
begin
  GetMem(FFileName, 255);
  GetMem(FBuffers, SizeOf(IDirectSoundBuffer)*dwNumBuffers);
  // if (nil <> FDSBuffer) then
  // memory is always received or exception is raised
  begin
    ZeroMemory(FBuffers, SizeOf(IDirectSoundBuffer)*dwNumBuffers);
    for i:= 0 to dwNumBuffers - 1 do
      FBuffers[i] := apDSBuffer[i];

    FDSBufferSize  := dwDSBufferSize;
    FBufferCount    := dwNumBuffers;
    FWaveFile       := pWaveFile;
    FCreationFlags := dwCreationFlags;

    FillBufferWithSound(FBuffers[0], False);

{    if z3DSupports(FDSBuffer[0], IDirectSoundBuffer8) then
    begin
      ZeroMemory(@FEffect, SizeOf(FEffect));
      FShader.dwSize:= SizeOf(FEffect);
      FShader.dwFlags:= 0;
      FShader.guidDSFXClass:= GUID_DSFX_WAVES_REVERB;
      HR:= (FDSBuffer[0] as IDirectSoundBuffer8).SetFX(1, @FEffect, @FResult);
      if FAILED(HR) then
      begin
        z3DTrace('NO ANDO EL FX', z3DtkInformation);
        case HR of
          DSERR_INVALIDPARAM: z3DTrace('El efecto está en: INVALID PARAM', z3DtkInformation);
          DSERR_NOINTERFACE: z3DTrace('El efecto está en: NO INTERFACE', z3DtkInformation);
          else
          begin
            StringToWideChar('El efecto está en: '+IntToStr(HR), z3DWideBuffer, 255);
            z3DTrace(z3DWideBuffer, z3DtkInformation);
          end;
        end;
      end else
      begin
        case FResult of
          DSFXR_LOCHARDWARE: z3DTrace('El efecto está en: HARDWARE', z3DtkInformation);
          DSFXR_LOCSOFTWARE: z3DTrace('El efecto está en: SOFTWARE', z3DtkInformation);
          DSFXR_UNALLOCATED: z3DTrace('El efecto está en: UNALLOCATED', z3DtkInformation);
        end;
      end;
    end;}
  end;
end;

destructor Tz3DBaseSound.Destroy;
var
  i: Integer;
begin
  for i:= 0 to FBufferCount - 1 do SafeRelease(FBuffers[i]);
  FreeMem(FBuffers);
  FreeMem(FFileName);
  SafeDelete(FWaveFile);

  inherited;
end;

function Tz3DBaseSound.FillBufferWithSound(pDSB: IDirectSoundBuffer;
  bRepeatWavIfBufferLarger: BOOL): HRESULT;
var
  pDSLockedBuffer: Pointer;     // Pointer to locked buffer memory
  dwDSLockedBufferSize: DWORD;  // Size of the locked DirectSound buffer
  dwWavDataRead: DWORD;         // Amount of data read from the wav file
  dwReadSoFar: DWORD;
begin
  pDSLockedBuffer      := nil;
  dwDSLockedBufferSize := 0;
  dwWavDataRead        := 0;

  if (pDSB = nil) then
  begin
    Result:= CO_E_NOTINITIALIZED;
    Exit;
  end;

  // Make sure we have focus, and we didn't just switch in from
  // an app which had a DirectSound device
  Result := RestoreBuffer(pDSB, nil);
  if FAILED(Result) then
  begin
    Exit;
  end;

  // Lock the buffer down
  Result := pDSB.Lock(0, FDSBufferSize,
                      @pDSLockedBuffer, @dwDSLockedBufferSize, nil, nil, 0);
  if FAILED(Result) then
  begin
    Exit;
  end;

  // Reset the wave file to the beginning
  FWaveFile.ResetFile;

  Result := FWaveFile.Read(pDSLockedBuffer,
                             dwDSLockedBufferSize,
                             @dwWavDataRead);
  if FAILED(Result) then
  begin
    Exit;
  end;

  if (dwWavDataRead = 0) then
  begin
    // Wav is blank, so just fill with silence
    FillMemory(pDSLockedBuffer, dwDSLockedBufferSize, FillValuesStaticA[(FWaveFile.FFormatEx.wBitsPerSample = 8)]);
  end
  else if (dwWavDataRead < dwDSLockedBufferSize) then
  begin
    // If the wav file was smaller than the DirectSound buffer,
    // we need to fill the remainder of the buffer with data
    if (bRepeatWavIfBufferLarger) then
    begin
      // Reset the file and fill the buffer with wav data
      dwReadSoFar := dwWavDataRead;    // From previous call above.
      while (dwReadSoFar < dwDSLockedBufferSize) do
      begin
        // This will keep reading in until the buffer is full
        // for very short files
        Result := FWaveFile.ResetFile;
        if FAILED(Result) then
        begin
          Exit;
        end;

        Result := FWaveFile.Read(Pointer(DWORD(pDSLockedBuffer) + dwReadSoFar),
                                   dwDSLockedBufferSize - dwReadSoFar,
                                   @dwWavDataRead);
        if FAILED(Result) then
        begin
          Exit;
        end;

        dwReadSoFar := dwReadSoFar + dwWavDataRead;
      end;
    end else
    begin
      // Don't repeat the wav file, just fill in silence
      FillMemory(Pointer(DWORD(pDSLockedBuffer) + dwWavDataRead),
                 dwDSLockedBufferSize - dwWavDataRead,
                 FillValuesStaticA[FWaveFile.FFormatEx.wBitsPerSample = 8]);
    end;
  end;

  // Unlock the buffer, we don't need it anymore.
  pDSB.Unlock(pDSLockedBuffer, dwDSLockedBufferSize, nil, 0);

  Result:= S_OK;
end;

function Tz3DBaseSound.RestoreBuffer(pDSB: IDirectSoundBuffer; pbWasRestored: PBOOL): HRESULT;
var
  dwStatus: DWORD;
begin
  if (pDSB = nil) then
  begin
    Result:= CO_E_NOTINITIALIZED;
    Exit;
  end;

  if Assigned(pbWasRestored) then pbWasRestored^ := False;

  Result := pDSB.GetStatus(dwStatus);
  if FAILED(Result) then
  begin
    Exit;
  end;

  if (dwStatus and DSBSTATUS_BUFFERLOST <> 0) then
  begin
    // Since the app could have just been activated, then
    // DirectSound may not be giving us control yet, so
    // the restoring the buffer may fail.
    // If it does, sleep until DirectSound gives us control.
    Result := pDSB.Restore;
    while (Result = DSERR_BUFFERLOST) do
    begin
      Sleep(10);
      Result := pDSB.Restore;
    end;

    if Assigned(pbWasRestored) then pbWasRestored^ := True;

    Result:= S_OK;
  end else
  begin
    Result:= S_FALSE;
  end;
end;

function Tz3DBaseSound.GetFreeBuffer: IDirectSoundBuffer;
const
  RAND_MAX = $7FFF;
var
  i: Integer;
  dwStatus: DWORD;
begin
  Result:= nil;
  if (FBuffers = nil) then Exit;

  for i:= 0 to FBufferCount - 1 do
  begin
    if (FBuffers[i] <> nil) then
    begin
      dwStatus := 0;
      FBuffers[i].GetStatus(dwStatus);
      if ((dwStatus and DSBSTATUS_PLAYING ) = 0) then Break;
    end;
  end;

  if (i <> Integer(FBufferCount)) then  Result:= FBuffers[i]
  else Result:= FBuffers[Random(RAND_MAX) mod Integer(FBufferCount)];
end;

function Tz3DBaseSound.GetBuffer(const AIndex: DWORD): IDirectSoundBuffer;
begin
  Result:= nil;
  if (FBuffers = nil) then Exit;
  if (AIndex >= FBufferCount) then Exit;

  Result:= FBuffers^[AIndex];
end;

procedure Tz3DBaseSound.Play;
var
  bRestored: BOOL;
  pDSB: IDirectSoundBuffer;
  HR: HRESULT;
begin
  if not GEnableSounds or not GEnableAudio then Exit;
  
  if (FBuffers = nil) then
  begin
    z3DTrace('Iz3DBaseSound.Play failed: Buffer is NULL', z3DtkWarning);
    Exit;
  end;

  pDSB := GetFreeBuffer;
  if (pDSB = nil) then
  begin
    z3DTrace('Iz3DBaseSound.Play failed: Free buffer is NULL', z3DtkWarning);
    Exit;
  end;

  // Restore the buffer if it was lost
  HR := RestoreBuffer(pDSB, @bRestored);
  if FAILED(HR) then
  begin
    z3DTrace('Iz3DBaseSound.Play failed: Could not restore buffer', z3DtkWarning);
    Exit;
  end;

  if (bRestored) then
  begin
    // The buffer was restored, so we need to fill it with new data
    HR := FillBufferWithSound(pDSB, False);
    if FAILED(HR) then
    begin
      z3DTrace('Iz3DBaseSound.Play failed: Could not fill buffer with sound', z3DtkWarning);
      Exit;
    end;
  end;

  if (FCreationFlags and DSBCAPS_CTRLVOLUME <> 0) then
    pDSB.SetVolume(FVolume);

{  if (lFrequency <> -1) and
     (FCreationFlags and DSBCAPS_CTRLFREQUENCY <> 0) then
    pDSB.SetFrequency(lFrequency);

  if (FCreationFlags and DSBCAPS_CTRLPAN <> 0) then
    pDSB.SetPan(lPan);}

  HR:= pDSB.Play(0, 0, FLoopingFlags[FLooping]);
  if FAILED(HR) then
  begin
    z3DTrace('Iz3DBaseSound.Play failed: IDirectSoundBuffer.Play failed', z3DtkWarning);
    Exit;
  end;
end;

procedure Tz3DBaseSound.Stop;
var I: Integer;
begin
  if FBuffers = nil then
  begin
    z3DTrace('Iz3DBaseSound.Stop failed: Buffer is NULL', z3DtkWarning);
    Exit;
  end;

  for I:= 0 to FBufferCount - 1 do
  if FAILED(FBuffers[I].Stop) then
  z3DTrace('Iz3DBaseSound.Stop failed: Buffer.Stop failed', z3DtkWarning);
end;

procedure Tz3DBaseSound.Reset;
var I: Integer;
begin
  if FBuffers = nil then
  begin
    z3DTrace('Iz3DBaseSound.Reset failed: Buffer is NULL', z3DtkWarning);
    Exit;
  end;

  for I:= 0 to FBufferCount - 1 do
  if FAILED(FBuffers[I].SetCurrentPosition(0)) then
  z3DTrace('Iz3DBaseSound.Reset failed: Buffer.SetCurrentPosition failed', z3DtkWarning);
end;

function Tz3DBaseSound.GetPlaying: Boolean;
var
  i: Integer;
  bIsPlaying: BOOL;
  dwStatus: DWORD;
begin
  bIsPlaying := False;

  if (FBuffers = nil) then
  begin
    Result:= False;
    Exit;
  end;

  for i:= 0 to FBufferCount - 1 do
  begin
    if Assigned(FBuffers[i]) then
    begin
      dwStatus := 0;
      FBuffers[i].GetStatus(dwStatus);
      bIsPlaying := bIsPlaying or (dwStatus and DSBSTATUS_PLAYING <> 0);
    end;
  end;

  Result:= bIsPlaying;
end;

function Tz3DBaseSound.GetVolume: Integer;
begin
  if FBufferCount > 0 then
  FBuffers[0].GetVolume(Result) else Result:= 0;
end;

procedure Tz3DBaseSound.SetVolume(const AVolume: Integer);
var I: Integer;
begin
  for i:= 0 to FBufferCount - 1 do
  FBuffers[i].SetVolume(AVolume);
end;

procedure Tz3DBaseSound.FadeOut(const ALength: Single);
begin
{  FFadingOut:= True;
  FFadeOutLength:= ALength;}
end;

procedure Tz3DBaseSound.FrameMove;
begin
  if not z3DEngine.Scenario.Enabled then Exit;
  if z3DAudioController.Environment.AutoUpdate then
  z3DAudioController.Environment.AutoUpdate:= False;
{  if FFadingOut then
  begin
    if Volume > DSBVOLUME_MIN * 0.5 then
    Volume:= Volume - Round(FFadeOutLength * (30 / z3DCore_GetFPS)) else
    begin
      Stop;
      FFadingOut:= False;
    end;
  end;}
end;

function Tz3DBaseSound.GetBufferCount: DWORD;
begin
  Result:= FBufferCount;
end;

function Tz3DBaseSound.GetBufferArray: PIDirectSoundBufferArray;
begin
  Result:= FBuffers;
end;

{ Tz3DSound }

function Tz3DSound.Get3DBuffer(const AIndex: Integer): IDirectSound3DBuffer;
begin
  if FBuffers = nil then
  begin
    z3DTrace('Iz3DSound.Get3DBuffer failed (audio buffer is NULL)', z3dtkWarning);
    Exit;
  end;

  if AIndex >= FBufferCount then
  begin
    z3DTrace('Iz3DSound.Get3DBuffer failed (buffer index out of bounds)', z3dtkWarning);
    Exit;
  end;

  if not z3DSupports(FBuffers[AIndex], IDirectSound3DBuffer) then
  begin
    z3DTrace('Iz3DSound.Get3DBuffer failed (requested buffer is not a 3D buffer)', z3dtkWarning);
    Exit;
  end;

  FBuffers[AIndex].QueryInterface(IID_IDirectSound3DBuffer, Result);
end;

function Tz3DSound.GetPan: Integer;
begin
  if FBufferCount > 0 then
  FBuffers[0].GetPan(Result) else Result:= 0;
end;

procedure Tz3DSound.SetPan(const APan: Integer);
var I: Integer;
begin
  for i:= 0 to FBufferCount - 1 do
  FBuffers[i].SetPan(APan);
end;

procedure Tz3DSound.Play3D;
var
  bRestored: BOOL;
  dwBaseFrequency: DWORD;
  pDSB: IDirectSoundBuffer;
  pDS3DBuffer: IDirectSound3DBuffer;
  HR: HRESULT;
begin
  if not GEnableSounds or not GEnableAudio then Exit;

{(const p3DBuffer: TDS3DBuffer; dwPriority, dwFlags: DWORD;
  lFrequency: Integer): HRESULT}

{  FFadingOut:= False;}
  if FBuffers = nil then
  begin
    z3DTrace('Iz3DSound.Play3D failed: Buffer is NULL', z3DtkWarning);
    Exit;
  end;

  pDSB := GetFreeBuffer;
  if (pDSB = nil) then
  begin
    Exit;
  end;

  // Restore the buffer if it was lost
  HR := RestoreBuffer(pDSB, @bRestored);
  if FAILED(HR) then
  begin
    z3DTrace('Iz3DSound.Play3D failed: RestoreBuffer failed', z3DtkWarning);
    Exit;
  end;

  if (bRestored) then
  begin
    // The buffer was restored, so we need to fill it with new data
    HR:= FillBufferWithSound(pDSB, False);
    if FAILED(HR) then
    begin
      z3DTrace('Iz3DSound.Play3D failed: FillBufferWithSound failed', z3DtkWarning);
      Exit;
    end;
  end;

{  if (FCreationFlags and DSBCAPS_CTRLFREQUENCY <> 0) then
  begin
    pDSB.GetFrequency(dwBaseFrequency);
    pDSB.SetFrequency(dwBaseFrequency + DWORD(lFrequency));
  end;}




    

  // QI for the 3D buffer
  HR:= pDSB.QueryInterface(IID_IDirectSound3DBuffer, pDS3DBuffer);
  if SUCCEEDED(HR) then
  begin
{    HR:= pDS3DBuffer.SetAllParameters(p3DBuffer, DS3D_IMMEDIATE);
    if SUCCEEDED(HR) then}
    begin
      HR:= pDSB.Play(0, 0, FLoopingFlags[FLooping]);
      if FAILED(HR) then
      begin
        z3DTrace('Iz3DSound.Play3D failed: Buffer.Play failed', z3DtkWarning);
        Exit;
      end;
    end;

    pDS3DBuffer := nil;
  end;
end;


function mmioFOURCC(ch0, ch1, ch2, ch3: Char): DWord;
begin
  Result:= Byte(ch0) or (Byte(ch1) shl 8) or (Byte(ch2) shl 16) or (Byte(ch3) shl 24);
end;

function Tz3DBaseSound.GetFileName: PWideChar;
begin
  Result:= FFileName;
end;

function Tz3DBaseSound.GetLooping: Boolean;
begin
  Result:= FLooping;
end;

procedure Tz3DBaseSound.SetLooping(const Value: Boolean);
begin
  FLooping:= Value;
end;

{ Tz3DAudioWaveFile }

constructor Tz3DAudioWaveFile.Create;
begin
  FFormatEx:= nil;
  FMMIO:= 0;
  FResourceBuffer:= nil;
  FSize:= 0;
  FFromMemory:= False;
end;

destructor Tz3DAudioWaveFile.Destroy;
begin
  Close;
  if (not FFromMemory) then FreeMem(FFormatEx);
  inherited;
end;

function Tz3DAudioWaveFile.Open(strFileName: PWideChar; pwfx: PWaveFormatEx;
  dwFlags: DWORD): HRESULT;
var
  hResInfo: HRSRC;
  hResData: HGLOBAL;
  dwSize:   DWORD;
  pvRes:    Pointer;
  mmioInfo: TMMIOInfo;
begin
  FFlags := dwFlags;
  FFromMemory := False;

  if (FFlags = WAVEFILE_READ) then
  begin
    if (strFileName = nil) then
    begin
      Result:= E_INVALIDARG;
      Exit;
    end;
    FreeMem(FFormatEx);

    FMMIO := mmioOpenW(strFileName, nil, MMIO_ALLOCBUF or MMIO_READ);

    if (0 = FMMIO) then
    begin
      // Loading it as a file failed, so try it as a resource
      hResInfo := FindResourceW(0, strFileName, 'WAVE');
      if (hResInfo = 0) then
      begin
        hResInfo := FindResourceW(0, strFileName, 'WAV');
        if (hResInfo = 0) then
        begin
          Exit;
        end;
      end;

      hResData := LoadResource(0, hResInfo);
      if (hResData = 0) then
      begin
        Exit;
      end;

      dwSize := SizeofResource(0, hResInfo);
      if (dwSize = 0) then
      begin
        Exit;
      end;

      pvRes := LockResource(hResData);
      if (pvRes = nil) then
      begin
        Exit;
      end;

      try
        GetMem(FResourceBuffer, SizeOf(Char)*dwSize);
      except
        on EOutOfMemory do
        begin
          Exit;
        end;
      end;
      Move(pvRes^, FResourceBuffer^, dwSize);

      ZeroMemory(@mmioInfo, SizeOf(mmioInfo));
      mmioInfo.fccIOProc := FOURCC_MEM;
      mmioInfo.cchBuffer := dwSize;
      mmioInfo.pchBuffer := FResourceBuffer;

      FMMIO := mmioOpen(nil, @mmioInfo, MMIO_ALLOCBUF or MMIO_READ);
    end;

    Result := ReadMMIO;
    if FAILED(Result) then
    begin
      // ReadMMIO will fail if its an not a wave file
      mmioClose(FMMIO, 0);
      Exit;
    end;

    Result := ResetFile;
    if FAILED(Result) then
    begin
      Exit;
    end;

    // After the reset, the size of the wav file is FCKInfo.cksize so store it now
    FSize := FCKInfo.cksize;
  end else
  begin
    FMMIO := mmioOpenW(strFileName, nil, MMIO_ALLOCBUF or
                                           MMIO_READWRITE or
                                           MMIO_CREATE);
    if (0 = FMMIO) then
    begin
      Exit;
    end;

    Result := WriteMMIO(pwfx);
    if FAILED(Result) then
    begin
      Exit;
    end;

    Result := ResetFile;
    if FAILED(Result) then
    begin
      Exit;
    end;
  end;
end;

function Tz3DAudioWaveFile.OpenFromMemory(pbData: PByte; ulDataSize: Cardinal;
  pwfx: PWaveFormatEx; dwFlags: DWORD): HRESULT;
begin
  FFormatEx       := pwfx;
  FDataSize := ulDataSize;
  FData     := pbData;
  FDataCur  := FData;
  FFromMemory := True;

  if (dwFlags <> WAVEFILE_READ) then Result:= E_NOTIMPL
  else Result:= S_OK;
end;

function Tz3DAudioWaveFile.ReadMMIO: HRESULT;
var
  ckIn:          TMMCKInfo;      // chunk info. for general use.
  pcmWaveFormat: TPCMWaveFormat; // Temp PCM structure to load in.
  cbExtraBytes:  Word;
begin
  FFormatEx := nil;

  if (0 <> mmioDescend(FMMIO, @FCKInfoRiff, nil, 0)) then
  begin
    Exit;
  end;

  // Check to make sure this is a valid wave file
  if (FCKInfoRiff.ckid <> FOURCC_RIFF) or
     (FCKInfoRiff.fccType <>  DWORD(Byte('W') or (Byte('A') shl 8) or (Byte('V') shl 16) or (Byte('E') shl 24))) // mmioFOURCC('W', 'A', 'V', 'E'))
   then
  begin
    Exit;
  end;

  // Search the input file for for the 'fmt ' chunk.
  ckIn.ckid := DWORD(Byte('f') or (Byte('m') shl 8) or (Byte('t') shl 16) or (Byte(' ') shl 24)); // mmioFOURCC('f', 'm', 't', ' ');
  if (0 <> mmioDescend(FMMIO, @ckIn, @FCKInfoRiff, MMIO_FINDCHUNK)) then
  begin
    Exit;
  end;

  // Expect the 'fmt' chunk to be at least as large as <PCMWAVEFORMAT>;
  // if there are extra parameters at the end, we'll ignore them
  if (ckIn.cksize < SizeOf(TPCMWaveFormat)) then
  begin
    Exit;
  end;

  // Read the 'fmt ' chunk into <pcmWaveFormat>.
  if (mmioRead(FMMIO, @pcmWaveFormat, SizeOf(pcmWaveFormat)) <> SizeOf(pcmWaveFormat)) then
  begin
    Exit;
  end;

  // Allocate the waveformatex, but if its not pcm format, read the next
  // word, and thats how many extra bytes to allocate.
  if (pcmWaveFormat.wf.wFormatTag = WAVE_FORMAT) then
  begin
{$IFDEF SUPPORTS_EXCEPTIONS}
    try
      GetMem(FFormatEx, SizeOf(TWaveFormatEx));
    except
      on EOutOfMemory do
      begin
        Exit;
      end;
      else raise;
    end;
{$ELSE}
    GetMem(FFormatEx, SizeOf(TWaveFormatEx));
    if (FFormatEx = nil) then 
    begin
      Exit;
    end;
{$ENDIF}

    // Copy the bytes from the pcm structure to the waveformatex structure
    Move(pcmWaveFormat, FFormatEx^, SizeOf(pcmWaveFormat));
    FFormatEx.cbSize := 0;
  end else
  begin
    // Read in length of extra bytes.
    cbExtraBytes := 0;
    if (mmioRead(FMMIO, PChar(@cbExtraBytes), SizeOf(Word)) <> SizeOf(Word)) then
    begin
      Exit;
    end;

{$IFDEF SUPPORTS_EXCEPTIONS}
    try
      GetMem(FFormatEx, SizeOf(TWaveFormatEx) + cbExtraBytes);
    except
      on EOutOfMemory do
      begin
        Exit;
      end;
      else raise;
    end;
{$ELSE}
    GetMem(FFormatEx, SizeOf(TWaveFormatEx) + cbExtraBytes);
    if (FFormatEx = nil) then
    begin
      Exit;
    end;
{$ENDIF}

    // Copy the bytes from the pcm structure to the waveformatex structure
    Move(pcmWaveFormat, FFormatEx^, SizeOf(pcmWaveFormat));
    FFormatEx.cbSize := cbExtraBytes;

    // Now, read those extra bytes into the structure, if cbExtraAlloc != 0.
    if (mmioRead(FMMIO, PChar(Pointer(Integer(@(FFormatEx.cbSize))+SizeOf(Word))),
          cbExtraBytes ) <> cbExtraBytes) then
    begin
      FreeMem(FFormatEx);
      Exit;
    end;
  end;

  // Ascend the input file out of the 'fmt ' chunk.
  if (0 <> mmioAscend(FMMIO, @ckIn, 0)) then
  begin
    SafeDelete(FFormatEx);
    Exit;
  end;

  Result:= S_OK;
end;

function Tz3DAudioWaveFile.GetSize: DWORD;
begin
  Result:= FSize;
end;

function Tz3DAudioWaveFile.ResetFile: HRESULT;
begin
  if (FFromMemory) then
  begin
    FDataCur := FData;
  end else
  begin
    if (FMMIO = 0) then
    begin
      Result:= CO_E_NOTINITIALIZED;
      Exit;
    end;

    if (FFlags = WAVEFILE_READ) then
    begin
      // Seek to the data
      if (-1 = mmioSeek(FMMIO, FCKInfoRiff.dwDataOffset + SizeOf(FOURCC), SEEK_SET)) then
      begin
        Exit;
      end;

      // Search the input file for the 'data' chunk.
      FCKInfo.ckid := mmioFOURCC('d', 'a', 't', 'a');
      if (0 <> mmioDescend(FMMIO, @FCKInfo, @FCKInfoRiff, MMIO_FINDCHUNK)) then
      begin
        Exit;
      end;
    end else
    begin
      // Create the 'data' chunk that holds the waveform samples.
      FCKInfo.ckid := mmioFOURCC('d', 'a', 't', 'a');
      FCKInfo.cksize := 0;

      if (0 <> mmioCreateChunk(FMMIO, @FCKInfo, 0)) then
      begin
        Exit;
      end;

      if (0 <> mmioGetInfo(FMMIO, @FMMIOInfoOut, 0)) then
      begin
        Exit;
      end;
    end;
  end;

  Result:= S_OK;
end;

function Tz3DAudioWaveFile.Read(pBuffer: PByte; dwSizeToRead: DWORD;
  pdwSizeRead: PDWORD): HRESULT;
var
  mmioinfoIn: TMMIOInfo; // current status of FMMIO
  cbDataIn: LongWord;
  cT: Integer;
begin
  if (FFromMemory) then
  begin
    if (FDataCur = nil) then
    begin
      Result:= CO_E_NOTINITIALIZED;
      Exit;
    end;
    if (pdwSizeRead <> nil) then pdwSizeRead^ := 0;

    if (DWORD(FDataCur) + dwSizeToRead) >
       (DWORD(FData) + FDataSize) then
    begin
      dwSizeToRead := FDataSize - (DWORD(FDataCur) - DWORD(FData));
    end;

    CopyMemory(pBuffer, FDataCur, dwSizeToRead);

    if (pdwSizeRead <> nil) then pdwSizeRead^ := dwSizeToRead;
  end else
  begin
    if (FMMIO = 0) then
    begin
      Result:= CO_E_NOTINITIALIZED;
      Exit;
    end;
    if (pBuffer = nil) or (pdwSizeRead = nil) then
    begin
      Result:= E_INVALIDARG;
      Exit;
    end;

    if (pdwSizeRead <> nil) then pdwSizeRead^ := 0;

    if (0 <> mmioGetInfo(FMMIO, @mmioinfoIn, 0)) then
    begin
      Exit;
    end;

    cbDataIn := dwSizeToRead;
    if (cbDataIn > FCKInfo.cksize) then cbDataIn := FCKInfo.cksize;

    FCKInfo.cksize := FCKInfo.cksize - cbDataIn;

    for cT := 0 to cbDataIn - 1 do
    begin
      // Copy the bytes from the io to the buffer.
      if (mmioinfoIn.pchNext = mmioinfoIn.pchEndRead) then
      begin
        if (0 <> mmioAdvance(FMMIO, @mmioinfoIn, MMIO_READ)) then
        begin
          Exit;
        end;

        if (mmioinfoIn.pchNext = mmioinfoIn.pchEndRead) then 
        begin
          Exit;
        end;
      end;

      // Actual copy.
      //*((BYTE*)pBuffer+cT) = *((BYTE*)mmioinfoIn.pchNext);
      PByte(Integer(pBuffer)+cT)^ := PByte(mmioinfoIn.pchNext)^;
      Inc(mmioinfoIn.pchNext);
    end;

    if (0 <> mmioSetInfo(FMMIO, @mmioinfoIn, 0)) then
    begin
      Exit;
    end;

    if (pdwSizeRead <> nil) then pdwSizeRead^ := cbDataIn;
  end;
  Result:= S_OK;
end;

function Tz3DAudioWaveFile.Close: HRESULT;
var
  dwSamples: DWORD;
begin
  if (FFlags = WAVEFILE_READ) then
  begin
    mmioClose(FMMIO, 0);
    FMMIO := 0;
    FreeMem(FResourceBuffer);
  end else
  begin
    FMMIOInfoOut.dwFlags := FMMIOInfoOut.dwFlags or MMIO_DIRTY;

    if (FMMIO = 0) then
    begin
      Result:= CO_E_NOTINITIALIZED;
      Exit;
    end;

    if (0 <> mmioSetInfo( FMMIO, @FMMIOInfoOut, 0)) then
    begin
      Exit;
    end;

    // Ascend the output file out of the 'data' chunk -- this will cause
    // the chunk size of the 'data' chunk to be written.
    if (0 <> mmioAscend(FMMIO, @FCKInfo, 0)) then 
    begin
      Exit;
    end;

    // Do this here instead...
    if (0 <> mmioAscend(FMMIO, @FCKInfoRiff, 0)) then
    begin
      Exit;
    end;

    mmioSeek(FMMIO, 0, SEEK_SET);

    if (0 <> mmioDescend(FMMIO, @FCKInfoRiff, nil, 0)) then
    begin
      Exit;
    end;

    FCKInfo.ckid := mmioFOURCC('f', 'a', 'c', 't');

    if (0 = mmioDescend(FMMIO, @FCKInfo, @FCKInfoRiff, MMIO_FINDCHUNK)) then
    begin
      dwSamples := 0;
      mmioWrite(FMMIO, PChar(@dwSamples), SizeOf(DWORD));
      mmioAscend(FMMIO, @FCKInfo, 0);
    end;

    // Ascend the output file out of the 'RIFF' chunk -- this will cause
    // the chunk size of the 'RIFF' chunk to be written.
    if (0 <> mmioAscend( FMMIO, @FCKInfoRiff, 0)) then
    begin
      Exit;
    end;

    mmioClose(FMMIO, 0);
    FMMIO := 0;
  end;

  Result:= S_OK;
end;

function Tz3DAudioWaveFile.WriteMMIO(pwfxDest: PWaveFormatEx): HRESULT;
var
  dwFactChunk: DWORD; // Contains the actual fact chunk. Garbage until WaveCloseWriteFile.
  ckOut1: MMCKINFO;
begin
  dwFactChunk := DWORD(-1);

  // Create the output file RIFF chunk of form type 'WAVE'.
  FCKInfoRiff.fccType := mmioFOURCC('W', 'A', 'V', 'E');
  FCKInfoRiff.cksize := 0;

  if (0 <> mmioCreateChunk(FMMIO, @FCKInfoRiff, MMIO_CREATERIFF)) then 
  begin
    Exit;
  end;

  // We are now descended into the 'RIFF' chunk we just created.
  // Now create the 'fmt ' chunk. Since we know the size of this chunk,
  // specify it in the MMCKINFO structure so MMIO doesn't have to seek
  // back and set the chunk size after ascending from the chunk.
  FCKInfo.ckid := mmioFOURCC('f', 'm', 't', ' ');
  FCKInfo.cksize := SizeOf(TPCMWaveFormat);

  if (0 <> mmioCreateChunk(FMMIO, @FCKInfo, 0)) then
  begin
    Exit;
  end;

  // Write the PCMWAVEFORMAT structure to the 'fmt ' chunk if its that type.
  if (pwfxDest.wFormatTag = WAVE_FORMAT) then
  begin
    if (mmioWrite(FMMIO, PChar(pwfxDest), SizeOf(TPCMWaveFormat)) <> SizeOf(TPCMWaveFormat)) then
    begin
      Exit;
    end;
  end else
  begin
    // Write the variable length size.
    if mmioWrite(FMMIO, PChar(pwfxDest), SizeOf(pwfxDest^) + pwfxDest.cbSize) <>
       (SizeOf(pwfxDest^) + pwfxDest.cbSize) then
    begin
      Exit;
    end;
  end;  
    
  // Ascend out of the 'fmt ' chunk, back into the 'RIFF' chunk.
  if (0 <> mmioAscend(FMMIO, @FCKInfo, 0)) then
  begin
    Exit;
  end;

  // Now create the fact chunk, not required for PCM but nice to have.  This is filled
  // in when the close routine is called.
  ckOut1.ckid := mmioFOURCC('f', 'a', 'c', 't');
  ckOut1.cksize := 0;

  if (0 <> mmioCreateChunk(FMMIO, @ckOut1, 0)) then
  begin
    Exit;
  end;

  if (mmioWrite(FMMIO, PChar(@dwFactChunk), SizeOf(dwFactChunk)) <> SizeOf(dwFactChunk)) then
  begin
    Exit;
  end;

  // Now ascend out of the fact chunk...
  if (0 <> mmioAscend( FMMIO, @ckOut1, 0)) then
  begin
    Exit;
  end;

  Result:= S_OK;
end;

function Tz3DAudioWaveFile.Write(nSizeToWrite: LongWord; pbSrcData: PByte;
  out pnSizeWrote: LongWord): HRESULT;
var
  cT: Integer;
begin
  Result:= S_OK;
  if (FFromMemory)                  then Result:= E_NOTIMPL;
  if (FMMIO = 0)                             then Result:= CO_E_NOTINITIALIZED;
  if (@pnSizeWrote = nil) or (pbSrcData = nil) then Result:= E_INVALIDARG;
  if (Result <> S_OK) then Exit;

  pnSizeWrote := 0;

  for cT := 0 to nSizeToWrite - 1 do
  begin
    if (FMMIOInfoOut.pchNext = FMMIOInfoOut.pchEndWrite) then
    begin
      FMMIOInfoOut.dwFlags := FMMIOInfoOut.dwFlags or MMIO_DIRTY;
      if (0 <> mmioAdvance(FMMIO, @FMMIOInfoOut, MMIO_WRITE)) then
      begin
        Exit;
      end;
    end;

    //*((BYTE*)FMMIOInfoOut.pchNext) = *((BYTE*)pbSrcData+cT);
    PByte(FMMIOInfoOut.pchNext)^ := PByte(Integer(pbSrcData)+cT)^;
    Inc(PByte(FMMIOInfoOut.pchNext));

    Inc(pnSizeWrote);
  end;

  Result:= S_OK;
end;

{ Tz3DMusic }

destructor Tz3DMusic.Destroy;
begin
  FControl.Free;
  FPlayer.Free;
  inherited;
end;

function Tz3DMusic.GetFileName: PWideChar;
begin
  Result:= FFileName;
end;

function Tz3DMusic.GetPlaying: Boolean;
begin
  Result:= FPlayer.Mode = mpPlaying;
end;

procedure Tz3DMusic.Init(const AOwner: Iz3DBase);
begin
  inherited;
  GetMem(FFileName, 255);
  FPlayer:= TMediaPlayer.Create(nil);
  FPlayer.VisibleButtons:= [];
end;

procedure Tz3DMusic.Pause;
begin
  FPlayer.Pause;
end;

procedure Tz3DMusic.Play(const AFileName: PWideChar);
begin
  if not GEnableMusic or not GEnableAudio then Exit;

  FPlayer.FileName:= WideCharToString(AFileName);
  if FPlayer.Parent = nil then
  begin
    FControl:= Tz3DWinControl.Create(nil);
    FControl.WindowHandle:= z3DCore_GetHWND;
    FPlayer.Parent:= FControl;
  end;
  try
    FPlayer.Open;
    FPlayer.Play;
  except
    z3DTrace('Iz3DMusic.Play failed: Could not open/play music', z3dtkWarning);
  end;
end;

procedure Tz3DMusic.Stop;
begin
  FPlayer.Stop;
end;

{ Tz3DSoundEnvironment }

procedure Tz3DSoundEnvironment.Init(const AOwner: Iz3DBase);
begin
  inherited;
  FAutoUpdate:= True;
  FEnabled:= True;
  FEnableDoppler:= True;
  FKind:= z3dekGeneric;
end;

function Tz3DSoundEnvironment.GetAutoUpdate: Boolean;
begin
  Result:= FAutoUpdate;
end;

function Tz3DSoundEnvironment.GetEnabled: Boolean;
begin
  Result:= FEnabled;
end;

function Tz3DSoundEnvironment.GetEnableDoppler: Boolean;
begin
  Result:= FEnableDoppler;
end;

function Tz3DSoundEnvironment.GetKind: Tz3DEnvironmentKind;
begin
  Result:= FKind;
end;

procedure Tz3DSoundEnvironment.SetAutoUpdate(const Value: Boolean);
begin
  FAutoUpdate:= Value;
end;

procedure Tz3DSoundEnvironment.SetEnabled(const Value: Boolean);
begin
  FEnabled:= Value;
end;

procedure Tz3DSoundEnvironment.SetEnableDoppler(const Value: Boolean);
begin
  FEnableDoppler:= Value;
end;

procedure Tz3DSoundEnvironment.SetKind(const Value: Tz3DEnvironmentKind);
begin
  FKind:= Value;
end;

procedure Tz3DSoundEnvironment.UpdateFromScenario;
begin
  // TODO JP: Ver como abstraer de la camera, usando Iz3DEngine.ViewPosition
  if (z3DCameraController = nil) or (z3DCameraController.ActiveCamera = nil) then Exit;
  if FKind = (z3DCameraController.ActiveCamera as Iz3DScenarioDynamicObject).Environments[0].Environment.Kind then Exit;
  FKind:= (z3DCameraController.ActiveCamera as Iz3DScenarioDynamicObject).Environments[0].Environment.Kind;
  PrepareCurrentEnvironment;
  ApplyCurrentEnvironment;
end;

procedure Tz3DSoundEnvironment.PrepareCurrentEnvironment;

  procedure AddEffect(const AKind: Tz3DSoundEffectKind);
  begin
    SetLength(FCurrentEffects, Length(FCurrentEffects)+1);
    SetLength(FCurrentKinds, Length(FCurrentKinds)+1);
    FCurrentEffects[Length(FCurrentEffects)-1].dwSize:= SizeOf(TDSEffectDesc);
    FCurrentEffects[Length(FCurrentEffects)-1].guidDSFXClass:= Tz3DSoundEffectKindGUIDs[AKind];
    FCurrentKinds[Length(FCurrentKinds)-1]:= AKind;
  end;

begin
  // Reset the effect array
  SetLength(FCurrentEffects, 0);
  SetLength(FCurrentKinds, 0);

  case FKind of

    // Generic environment (no effect)
    z3dekGeneric:
    begin
//      AddEffect(z3dsek3DReverb);
    end;

    // Room environment (room reverb)
    z3dekRoom:
    begin
      AddEffect(z3dsekReverb);
    end;

    // Cave environment (cave reverb)
    z3dekCave:
    begin
      AddEffect(z3dsekReverb);
      AddEffect(z3dsekEcho);
    end;

    // Hallway environment (hallway reverb)
    z3dekHallway:
    begin
      AddEffect(z3dsekReverb);
      AddEffect(z3dsekEcho);
    end;

    // Forest environment (forest reverb)
    z3dekForest:
    begin
      AddEffect(z3dsekReverb);
      AddEffect(z3dsekEcho);
    end;

    // City environment (city reverb)
    z3dekCity:
    begin
      AddEffect(z3dsekReverb);
    end;

    // Mountains environment (mountains reverb)
    z3dekMountains:
    begin
      AddEffect(z3dsekReverb);
      AddEffect(z3dsekEcho);
    end;
  end;
end;

function Tz3DSoundEnvironment.GetCurrentEffects: PDSEffectDescArray;
begin
  Result:= Pointer(FCurrentEffects);
end;

procedure Tz3DSoundEnvironment.ApplyCurrentEnvironment;
var I: Integer;
begin
  for I:= 0 to z3DAudioController.SoundCount-1 do
  ApplyEnvironment(z3DAudioController.Sounds[I]);

  // Apply the doppler effect
  if FEnableDoppler then z3DAudioController.Get3DListener.SetDopplerFactor(3, DS3D_IMMEDIATE) else
  z3DAudioController.Get3DListener.SetDopplerFactor(DS3D_MINDOPPLERFACTOR, DS3D_IMMEDIATE);
end;

procedure Tz3DSoundEnvironment.ApplyEnvironment(const ASound: Iz3DSound);
var I, J: Integer;
    FPlayingMode: Integer;
    FPathInterface: IInterface;
    FInterface: TGUID;
begin
  FPlayingMode:= Integer(ASound.Playing);
  if FPlayingMode <> 0 then ASound.Stop;
  try
    for I:= 0 to ASound.GetBufferCount-1 do
    begin
      if not z3DSupports(ASound.GetBufferArray[I], IDirectSoundBuffer8) then Continue;

      // Set the effect for the current buffer
      if FAILED((ASound.GetBufferArray[I] as IDirectSoundBuffer8).SetFX(
      Length(FCurrentEffects), Pointer(FCurrentEffects), nil)) then
      begin
        z3DTrace('Iz3DSoundEnvironment.ApplyEnvironment failed: IDirectSoundBuffer8.SetFX failed', z3DtkWarning);
        Continue;
      end;

      for J:= 0 to Length(FCurrentEffects)-1 do
      begin

        // Get the effect interface
        case FCurrentKinds[J] of
          z3dsekReverb: FInterface:= IID_IDirectSoundFXI3DL2Reverb8;
          z3dsekEcho: FInterface:= IID_IDirectSoundFXEcho8;
          z3dsekFlanger: FInterface:= IID_IDirectSoundFXFlanger8;
          z3dsekChorus: FInterface:= IID_IDirectSoundFXChorus8;
          z3dsekEqualizer: FInterface:= IID_IDirectSoundFXParamEQ8;
        end;
        if FAILED((ASound.GetBufferArray[I] as IDirectSoundBuffer8).GetObjectInPath(
        FCurrentEffects[J].guidDSFXClass, 0, FInterface, FPathInterface)) then
        begin
          z3DTrace('Iz3DSoundEnvironment.ApplyEnvironment failed: IDirectSoundBuffer8.GetObjectInPath failed', z3DtkWarning);
          Continue;
        end;
        if not z3DSupports(FPathInterface, FInterface) then Continue;

        // Apply the effect parameters
        case FCurrentKinds[J] of
          z3dsekReverb:
          begin
            case FKind of
              z3dekRoom: (FPathInterface as IDirectSoundFXI3DL2Reverb8).SetPreset(DSFX_I3DL2_ENVIRONMENT_PRESET_ROOM);
              z3dekCave: (FPathInterface as IDirectSoundFXI3DL2Reverb8).SetPreset(DSFX_I3DL2_ENVIRONMENT_PRESET_CAVE);
              z3dekHallway: (FPathInterface as IDirectSoundFXI3DL2Reverb8).SetPreset(DSFX_I3DL2_ENVIRONMENT_PRESET_HALLWAY);
              z3dekForest: (FPathInterface as IDirectSoundFXI3DL2Reverb8).SetPreset(DSFX_I3DL2_ENVIRONMENT_PRESET_FOREST);
              z3dekCity: (FPathInterface as IDirectSoundFXI3DL2Reverb8).SetPreset(DSFX_I3DL2_ENVIRONMENT_PRESET_CITY);
              z3dekMountains: (FPathInterface as IDirectSoundFXI3DL2Reverb8).SetPreset(DSFX_I3DL2_ENVIRONMENT_PRESET_MOUNTAINS);
            end;
          end;
          z3dsekEcho:
          begin
            case FKind of
              z3dekCave:
              begin
                FParams.Echo.fLeftDelay:= 100;
                FParams.Echo.fRightDelay:= 140;
                FParams.Echo.fWetDryMix:= 50;
                FParams.Echo.fFeedback:= 10;
                FParams.Echo.lPanDelay:= 10;
              end;
              z3dekHallway:
              begin
                FParams.Echo.fLeftDelay:= 200;
                FParams.Echo.fRightDelay:= 240;
                FParams.Echo.fWetDryMix:= 30;
                FParams.Echo.fFeedback:= 30;
                FParams.Echo.lPanDelay:= 10;
              end;
              z3dekForest:
              begin
                FParams.Echo.fLeftDelay:= 1000;
                FParams.Echo.fRightDelay:= 1040;
                FParams.Echo.fWetDryMix:= 10;
                FParams.Echo.fFeedback:= 40;
                FParams.Echo.lPanDelay:= 10;
              end;
              z3dekMountains:
              begin
                FParams.Echo.fLeftDelay:= 2000;
                FParams.Echo.fRightDelay:= 2040;
                FParams.Echo.fWetDryMix:= 30;
                FParams.Echo.fFeedback:= 60;
                FParams.Echo.lPanDelay:= 10;
              end;
            end;
            (FPathInterface as IDirectSoundFXEcho8).SetAllParameters(FParams.Echo);
          end;
          z3dsekFlanger:
          begin
  //          FInterface:= IID_IDirectSoundFXI3DL2Reverb8;
          end;
          z3dsekChorus:
          begin
  //          FInterface:= IID_IDirectSoundFXI3DL2Reverb8;
          end;
          z3dsekEqualizer:
          begin
  //          FInterface:= IID_IDirectSoundFXI3DL2Reverb8;
          end;
        end;
      end;
    end;
  finally
    if FPlayingMode > 0 then ASound.Play;
  end;
end;

procedure Tz3DSoundEnvironment.FrameMove;
begin
  if z3DEngine.Scenario.Enabled then
  UpdateFromScenario;
end;

initialization
  CoInitialize(nil);
  GEnableMusic:= True;
  GEnableAudio:= True;
  GEnableSounds:= True;

finalization
  CoUninitialize;

end.
