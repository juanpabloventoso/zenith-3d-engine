unit z3DAudio_Func;

interface

uses
  z3DAudio_Intf;

const
  z3DAudioDLL = 'z3DAudio.dll';

function z3DCreateAudioController: Iz3DAudioController; stdcall; external z3DAudioDLL;
function z3DAudioController: Iz3DAudioController; stdcall; external z3DAudioDLL;
procedure z3DSetCustomAudioController(const AController: Iz3DAudioController); stdcall; external z3DAudioDLL;

procedure z3DPlaySound(const ASound: Iz3DSound); stdcall; external z3DAudioDLL;
procedure z3DPlaySoundLooping(const ASound: Iz3DSound); stdcall; external z3DAudioDLL;
procedure z3DStopSound(const ASound: Iz3DSound); stdcall; external z3DAudioDLL;

procedure z3DEnableMusic(const AEnable: Boolean); stdcall; external z3DAudioDLL;
procedure z3DEnableSounds(const AEnable: Boolean); stdcall; external z3DAudioDLL;
procedure z3DEnableAudio(const AEnable: Boolean); stdcall; external z3DAudioDLL;

implementation

end.
