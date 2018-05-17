///============================================================================///
///= Zenith 3D Engine - Developed by Juan Pablo Ventoso                       =///
///============================================================================///
///= Unit: z3DAudio. Audio and music controller and functions                 =///
///============================================================================///






     


  // NULL GUID. Used to pass a null GUID to 3D-related functions
  GUID_NULL:   const  TGUID = "{00000000-0000-0000-0000-000000000000}";

  // WAV file read and write consts
      const  WAVEFILE_READ =  1;
     const  WAVEFILE_WRITE =  2;

  // DirectSoundBuffer extended types
   typedef IDirectSoundBuffer* PIDirectSoundBuffer;

   typedef AIDirectSoundBuffer* PAIDirectSoundBuffer;

     ()   IDirectSoundBuffer AIDirectSoundBuffer[1]; /*!< [0..999..999..999..999..0..1] */


  // PositionNotify extended types
   typedef ADSBPositionNotify* PADSBPositionNotify;

     ()   TDSBPositionNotify ADSBPositionNotify[1]; /*!< [0..999..999..999..999..0..1] */









   typedef interface Iz3DSound;
   typedef interface Iz3DStreamSound;

  /// Audio controller interface.

  /// Global DirectSound manager.

   class Iz3DAudioController : public Iz3DBase
{
public:
['{35D70745-C247-4FA0-800C-A92B35B5CDBE}']
    /// Returns the currently used IDirectSound8 interface
      
IDirectSound8 GetDirectSound ();
 ;
    /// Starts DirectSound
    /// Must set a valid window handle for DirectSound to initialize properly
           
HRESULT Initialize (HWND hWnd ,
DWORD dwCoopLevel = DSSCL_PRIORITY 
);
 ;
    /// Called optionally, sets the frequency and rate
         
HRESULT SetPrimaryBufferFormat (DWORD dwPrimaryChannels ,
DWORD dwPrimaryFreq ,
DWORD dwPrimaryBitRate 
);
 ;
    /// Returns the current 3D listener interface
        
HRESULT Get3DListenerInterface (/* out */ IDirectSound3DListener &ppDSListener 
);
 ;

    /// Creates a WAV sound. If GUID_NULL is passed to guid3DAlgorithm, the sound will not be 3D
                          
Iz3DSound CreateSound (PWideChar strWaveFileName ,
DWORD dwCreationFlags ,
const TGUID guid3DAlgorithm ,
DWORD dwNumBuffers = 1 
);
 ;
    /// Creates a WAV sound from memory
                              
HRESULT CreateSoundFromMemory (/* out */ Iz3DSound &ppSound ,
PByte pbData ,
Cardinal ulDataSize ,
PWaveFormatEx pwfx ,
DWORD dwCreationFlags ,
TGUID guid3DAlgorithm ,
DWORD dwNumBuffers 
);
 ;
    /// Creates a streaming WAV sound
                              
HRESULT CreateSoundStreaming (/* out */ Iz3DStreamSound &ppStreamingSound ,
PWideChar strWaveFileName ,
DWORD dwCreationFlags ,
TGUID guid3DAlgorithm ,
DWORD dwNotifyCount ,
DWORD dwNotifySize ,
THandle hNotifyEvent 
);
 ;
    /// Removes a sound from the controller internal cache
       
RemoveSound (const Iz3DSound ASound 
);
 ;

    /// Currently used IDirectSound8 interface
       /** \sa GetDirectSound For reading*/
IDirectSound8 DirectSound; 

 };






  /// Sound interface.

  /// Individual sound manager.

   class Iz3DSound : public Iz3DBase
{
public:
['{D273DE90-D762-4C17-B85D-F64A138CCD14}']
  /// Called internally, restores the sound buffer
         
HRESULT RestoreBuffer (IDirectSoundBuffer pDSB ,
PBOOL pbWasRestored 
);
 ;
    /// Returns the current panoramic position
      
Integer GetPan ();
 ;
    /// Returns the current volume in dB
      
Integer GetVolume ();
 ;
    /// Sets the current volume in dB
       
SetVolume (const Integer AVolume 
);
 ;
    /// Sets the current panoramic position
       
SetPan (const Integer APan 
);
 ;

    /// Returns the current 3D buffer interface
          
HRESULT Get3DBufferInterface (DWORD dwIndex ,
/* out */ IDirectSound3DBuffer &ppDS3DBuffer 
);
 ;
    /// Loads the current sound into the buffer
         
HRESULT FillBufferWithSound (IDirectSoundBuffer pDSB ,
BOOL bRepeatWavIfBufferLarger 
);
 ;
    /// Returns de available free buffer
      
IDirectSoundBuffer GetFreeBuffer ();
 ;
    /// Returns the buffer by index
       
IDirectSoundBuffer GetBuffer (DWORD dwIndex 
);
 ;

    /// Plays the sound. Parameters will take effect only if neccesary flags are specified
                -         -     
HRESULT Play (DWORD dwPriority = 0 ,
DWORD dwFlags = 0 ,
Longint lVolume = 1 ,
Longint lFrequency = 1 ,
Longint lPan = 0 
);
 ;
      /// Plays the sound with a 3D interface. Parameters will take effect only if neccesary flags are specified
                    
HRESULT Play3D (const TDS3DBuffer p3DBuffer ,
DWORD dwPriority = 0 ,
DWORD dwFlags = 0 ,
Longint lFrequency = 0 
);
 ;
    /// Fades out the current playing sound by the given amount (in dB) per frame
       
FadeOut (const Integer ASpeed 
);
 ;
    /// Stops the sound
      
HRESULT Stop ();
 ;
    /// Resets the sound
      
HRESULT Reset ();
 ;
    /// Returns TRUE if the sound is playing, FALSE otherwise
      
BOOL IsSoundPlaying ();
 ;
    /// Called internally, updates the current frame
     
FrameMove ();
 ;

    /// Current volume in dB
         /** \sa GetVolume For reading   \sa SetVolume For writing */
Integer Volume; 

    /// Current panoramic position
         /** \sa GetPan For reading   \sa SetPan For writing */
Integer Pan; 

 };






  /// Stream sound interface.

  /// Descendant from sound interface that supports streaming.

   class Iz3DStreamSound : public Iz3DSound
{
public:
['{03FFF83E-5778-4DC7-A5F6-BD4F5291963B}']
  /// Called internally, handles stream notifications
       
HRESULT HandleWaveStreamNotification (BOOL bLoopedPlay 
);
 ;
    /// Resets the sound
      
HRESULT Reset ();
 ;
 };




// finished

