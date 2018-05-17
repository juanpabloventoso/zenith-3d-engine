library z3DAudio;

uses
  z3DAudio_Intf,
  z3DAudio_Impl;

exports

  z3DAudioController,
  z3DCreateAudioController,
  z3DSetCustomAudioController,

  z3DPlaySound,
  z3DPlaySoundLooping,
  z3DStopSound,

  z3DEnableMusic,
  z3DEnableSounds,
  z3DEnableAudio;

{$R *.res}

begin
end.
