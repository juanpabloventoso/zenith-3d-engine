///============================================================================///
///= Zenith 3D Engine - Developed by Juan Pablo Ventoso                       =///
///============================================================================///
///= Unit: z3DAudio. Audio and music controller and functions                 =///
///============================================================================///

unit z3DAudio_Intf;

interface

uses
  Windows, DirectSound, z3DClasses_Intf, z3DScenario_Intf;

type

  PIDirectSoundBuffer = ^IDirectSoundBuffer;

  PIDirectSoundBufferArray = ^IDirectSoundBufferArray;
  IDirectSoundBufferArray = array[0..MaxInt div SizeOf(IDirectSoundBuffer) - 1] of IDirectSoundBuffer;



  Iz3DMusic = interface(Iz3DBase)['{FE90555F-2685-4A4F-9934-63D09A784943}']

    /// Returns the current music filename
    function GetFileName: PWideChar; stdcall;
    /// Returns TRUE if playing, FALSE otherwise
    function GetPlaying: Boolean; stdcall;
    /// Plays a specific music file
    procedure Play(const AFileName: PWideChar); stdcall;
    /// Stops the music
    procedure Stop; stdcall;
    /// Pauses the music
    procedure Pause; stdcall;

    /// Returns TRUE if playing, FALSE otherwise
    property Playing: Boolean read GetPlaying;
    /// Returns the current music filename
    property FileName: PWideChar read GetFileName;
  end;



  Iz3DSound = interface;


  /// Sound environment interface.

  /// Applies effects and modifies the scenario sounds based on the current
  /// environment properties.


  Tz3DSoundEffectKind = (z3dsekReverb, z3dsekEcho, z3dsekFlanger, z3dsekChorus,
  z3dsekEqualizer);

  Tz3DSoundEffectKindArray = array of Tz3DSoundEffectKind;


  TDSEffectDescArray = array of TDSEffectDesc;
  PDSEffectDescArray = array of PDSEffectDesc;


  Iz3DSoundEnvironment = interface(Iz3DBase)['{E2B58AA2-76BB-4783-A3E9-2F334E2C1791}']
    function GetAutoUpdate: Boolean; stdcall;
    function GetEnabled: Boolean; stdcall;
    function GetEnableDoppler: Boolean; stdcall;
    function GetKind: Tz3DEnvironmentKind; stdcall;
    procedure SetAutoUpdate(const Value: Boolean); stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;
    procedure SetEnableDoppler(const Value: Boolean); stdcall;
    procedure SetKind(const Value: Tz3DEnvironmentKind); stdcall;
    procedure ApplyEnvironment(const ASound: Iz3DSound); stdcall;
    function GetCurrentEffects: PDSEffectDescArray; stdcall;
    procedure FrameMove; stdcall;

    property AutoUpdate: Boolean read GetAutoUpdate write SetAutoUpdate;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property EnableDoppler: Boolean read GetEnableDoppler write SetEnableDoppler;
    property Kind: Tz3DEnvironmentKind read GetKind write SetKind;
  end;

  /// Audio controller interface.

  /// Global DirectSound manager.

  Iz3DAudioController = interface(Iz3DBase)['{35D70745-C247-4FA0-800C-A92B35B5CDBE}']
    /// Returns the created sounds
    function GetSounds(const AIndex: Integer): Iz3DSound; stdcall;
    /// Returns the current sound count
    function GetSoundCount: Integer; stdcall;
    /// Returns the sound environment interface
    function GetEnvironment: Iz3DSoundEnvironment; stdcall;
    /// Returns the currently used IDirectSound8 interface
    function GetDirectSound: IDirectSound8; stdcall;
    /// Starts DirectSound
    /// Must set a valid window handle for DirectSound to initialize properly
    function Initialize(hWnd: HWND; dwCoopLevel: DWORD = DSSCL_PRIORITY): HRESULT; stdcall;
    /// Called optionally, sets the frequency and rate
    function SetPrimaryBufferFormat(dwPrimaryChannels, dwPrimaryFreq, dwPrimaryBitRate: DWORD): HRESULT; stdcall;
    /// Returns the current 3D listener interface
    function Get3DListener: IDirectSound3DListener; stdcall;
    /// Returns the music interface
    function GetMusic: Iz3DMusic; stdcall;
    /// Returns the current DirectSound buffer array
    function GetBufferArray: PIDirectSoundBufferArray; stdcall;

    /// Creates a standard sound
    function CreateSound(const AFileName: PWideChar): Iz3DSound; stdcall;
    /// Creates a 3D sound
    function Create3DSound(const AFileName: PWideChar): Iz3DSound; stdcall;
    /// Removes a sound from the cache
    procedure RemoveSound(const ASound: Iz3DSound); stdcall;
    /// Returns the current primary buffer used
    function GetPrimaryBuffer: IDirectSoundBuffer; stdcall;

    /// Currently used IDirectSound8 interface
    property DirectSound: IDirectSound8 read GetDirectSound;
    /// Returns the music interface
    property Music: Iz3DMusic read GetMusic;
    /// Returns the sound environment interface
    property Environment: Iz3DSoundEnvironment read GetEnvironment;
    /// Returns the current sound count
    property SoundCount: Integer read GetSoundCount;
    /// Returns the created sounds
    property Sounds[const AIndex: Integer]: Iz3DSound read GetSounds;
  end;




  Iz3DBaseSound = interface(Iz3DBase)['{25FDED2E-9089-47E4-9450-34409F4EBB4E}']
    /// Returns the current number of buffers
    function GetBufferCount: DWORD; stdcall;
    /// Returns the current buffer array
    function GetBufferArray: PIDirectSoundBufferArray; stdcall;
    /// Returns current filename
    function GetFileName: PWideChar; stdcall;
    /// Returns TRUE if the sound is playing, FALSE otherwise
    function GetPlaying: Boolean; stdcall;
    /// Returns the looping state
    function GetLooping: Boolean; stdcall;
    /// Returns the current volume in dB
    function GetVolume: Integer; stdcall;
    /// Sets the current volume in dB
    procedure SetVolume(const AVolume: Integer); stdcall;
    /// Sets the looping state
    procedure SetLooping(const Value: Boolean); stdcall;

    /// Plays the sound
    procedure Play; stdcall;
    /// Fades out the current playing sound with a total time
    procedure FadeOut(const ALength: Single); stdcall;
    /// Stops the sound
    procedure Stop; stdcall;
    /// Resets the sound
    procedure Reset; stdcall;
    /// Called internally, updates the current frame
    procedure FrameMove; stdcall;

    /// Current volume in dB
    property Volume: Integer read GetVolume write SetVolume;
    /// Returns TRUE if the sound is playing, FALSE otherwise
    property Playing: Boolean read GetPlaying;
    /// Returns current filename
    property FileName: PWideChar read GetFileName;
    // Play with looping
    property Looping: Boolean read GetLooping write SetLooping;
  end;




  /// Sound interface.

  /// Individual sound manager.

  Iz3DSound = interface(Iz3DBaseSound)['{D273DE90-D762-4C17-B85D-F64A138CCD14}']
    /// Returns the current panoramic position
    function GetPan: Integer; stdcall;
    /// Sets the current panoramic position
    procedure SetPan(const APan: Integer); stdcall;

    /// Returns a 3D buffer interface for an audio buffer
    function Get3DBuffer(const AIndex: Integer): IDirectSound3DBuffer; stdcall;
    /// Plays the sound with a 3D interface
    procedure Play3D; stdcall;

    /// Returns the current panoramic position
    property Pan: Integer read GetPan write SetPan;
  end;

const
  Tz3DSoundEffectKindGUIDs: array[Tz3DSoundEffectKind] of TGUID = (
    '{ef985e71-d5c7-42d4-ba4d-2d073e2e96f4}', '{ef3e932c-d40b-4f51-8ccf-3f98f1b29d5d}',
    '{efca3d92-dfd8-4672-a603-7420894bad98}', '{efe6629c-81f7-4281-bd91-c9d604a95af6}',
    '{120ced89-3bf4-4173-a132-3cb406cf3231}');

implementation

end.
