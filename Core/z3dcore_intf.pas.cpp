///============================================================================///
///= Zenith 3D Engine - Developed by Juan Pablo Ventoso                       =///
///============================================================================///
///= Unit: z3DCore. 3D native controller for the Engine interface             =///
///============================================================================///






       


  // Kind of debug trace
   enum Tz3DTraceKind
{
z3DtkInformation, 
z3DtkWarning, 
z3DtkError 
};


     typedef array<DWord> TSingleArray;
   typedef TSingleArray* PSingleArray;


     typedef array<DWORD> Tz3DDWordArray;
   typedef Tz3DDWordArray* Pz3DDWordArray;


       typedef Integer (*QSortCB)(const Pointer arg1 ,
const Pointer arg2 
);


   typedef Pointer ULongToPtr;






          const  MONITORINFOF_PRIMARY =  $00000001;
         const  MONITOR_DEFAULTTONULL =  $00000000;
      const  MONITOR_DEFAULTTOPRIMARY =  $00000001;
      const  MONITOR_DEFAULTTONEAREST =  $00000002;


        const  ENUM_REGISTRY_SETTINGS =  DWORD(-2);

   typedef Tz3DMonitorInfo* Pz3DMonitorInfo;

   struct Tz3DMonitorInfo
{

         DWORD cbSize; 

      TRect rcMonitor; 

         TRect rcWork; 

        DWORD dwFlags; 

 };


   typedef Tz3DMonitorInfoExW* Pz3DMonitorInfoExW;

   struct Tz3DMonitorInfoExW
{

         DWORD cbSize; 

      TRect rcMonitor; 

         TRect rcWork; 

        DWORD dwFlags; 

     WideChar szDevice[-1]; /*!< [0..999..-1] */

 };




   typedef TMonitorInfo* PMonitorInfo;

   struct TMonitorInfo
{

         DWORD cbSize; 

      TRect rcMonitor; 

         TRect rcWork; 

        DWORD dwFlags; 

 };


       typedef HMONITOR (*TMonitorFromWindow)(HWND hWnd ,
DWORD dwFlags 
);
 ;
       typedef Boolean (*TGetMonitorInfo)(HMONITOR hMonitor ,
PMonitorInfo lpMonitorInfo 
);
 ;

   typedef TD3DMaterialArray* PD3DMaterialArray;

     () TD3DMaterial9 TD3DMaterialArray[-1]; /*!< [0..999..999..999..999..-1] */


   typedef TD3DXMaterialArray* PD3DXMaterialArray;

     () TD3DXMaterial TD3DXMaterialArray[-1]; /*!< [0..999..999..999..999..-1] */


   typedef AIDirect3DBaseTexture9* PAIDirect3DBaseTexture9;

     () IDirect3DBaseTexture9 AIDirect3DBaseTexture9[-1]; /*!< [0..999..999..999..999..-1] */







  /// z3D timer interface.

  /// Internal timer used for frame events.

   class Iz3DTimer : public Iz3DBase
{
public:
['{468AAF94-7AB3-4726-BBCB-D052F10547F7}']
    /// Returns the current absolute time
      
Double GetAbsoluteTime ();
 ;
    /// Returns the current time
      
Double GetTime ();
 ;
    /// Returns the current elapsed time 
      
Double GetElapsedTime ();
 ;
    /// Returns the current time adjusted from 
      
TLargeInteger GetAdjustedCurrentTime ();
 ;
    /// Returns TRUE if the timer is stopped
      
Boolean GetTimerStopped ();
 ;
    /// Resets the timer
     
Reset ();
 ;
    /// Starts the timer
     
Start ();
 ;
    /// Stops the timer
     
Stop ();
 ;
    /// Advance a time frame
     
Advance ();
 ;
    /// Returns current time values as out parameters
           
GetTimeValues (/* out */ Double &pfTime ,
/* out */ Double &pfAbsoluteTime ,
/* out */ Single &pfElapsedTime 
);
 ;

    /// Current absolute time
       /** \sa GetAbsoluteTime For reading*/
Double AbsoluteTime; 

    /// Current time
       /** \sa GetTime For reading*/
Double Time; 

    /// Current elapsed time
       /** \sa GetElapsedTime For reading*/
Double ElapsedTime; 

    /// TRUE if stopped, FALSE otherwise
       /** \sa GetTimerStopped For reading*/
Boolean IsStopped; 

 };


   enum Tz3DCacheSourceLocation
{
z3DCACHE_LOCATION_FILE, 
z3DCACHE_LOCATION_RESOURCE 
};


  /// Texture cache struct
   typedef Tz3DCacheTexture* Pz3DCacheTexture;

   struct Tz3DCacheTexture
{

      Tz3DCacheSourceLocation Location; 

     WideChar wszSource[-1]; /*!< [0..999..-1] */

      HMODULE hSrcModule; 

      LongWord Width; 

      LongWord Height; 

      LongWord Depth; 

      LongWord MipLevels; 

      DWORD Usage; 

      TD3DFormat Format; 

      TD3DPool Pool; 

      D3DRESOURCETYPE _Type; 

      IDirect3DBaseTexture9 pTexture; 

 };


     typedef array<Tz3DCacheTexture> Tz3DCacheTextureArray;

  /// Font cache struct
   struct Tz3DCacheFont
{

      Longint Height; 

      Longint Width; 

      LongWord Weight; 

      LongWord MipLevels; 

      BOOL Italic; 

      Byte CharSet; 

      Byte OutputPrecision; 

      Byte Quality; 

      Byte PitchAndFamily; 

     WideChar FaceName[-1]; /*!< [0..999..-1] */

      ID3DXFont pFont; 

 };


  /// Effect cache struct
   struct Tz3DCacheEffect
{

      Tz3DCacheSourceLocation Location; 

     WideChar wszSource[-1]; /*!< [0..999..-1] */

      HMODULE hSrcModule; 

      DWORD dwFlags; 

      ID3DXEffect pEffect; 

 };






  /// z3D Resource cache interface

  /// Handles multiple loads of single objects and
  /// mantains a reference to the origin

   class Iz3DResourceCache : public Iz3DBase
{
public:
['{94438DAC-DE1C-44BC-B931-0DE6CF06596E}']
            
HRESULT CreateTextureFromFile (IDirect3DDevice9 pDevice ,
PWideChar pSrcFile ,
/* out */ IDirect3DTexture9 &ppTexture 
);
 ;
                                              
HRESULT CreateTextureFromFileEx (IDirect3DDEVICE9 pDevice ,
PWideChar pSrcFile ,
LongWord Width ,
LongWord Height ,
LongWord MipLevels ,
DWORD Usage ,
TD3DFormat Format ,
TD3DPool Pool ,
DWORD Filter ,
DWORD MipFilter ,
TD3DColor ColorKey ,
PD3DXImageInfo pSrcInfo ,
PPaletteEntry pPalette ,
/* out */ IDirect3DTexture9 &ppTexture 
);
 ;
             
HRESULT CreateTextureFromResource (IDirect3DDevice9 pDevice ,
HMODULE hSrcModule ,
PWideChar pSrcResource ,
IDirect3DTexture9 ppTexture 
);
 ;
                                                
HRESULT CreateTextureFromResourceEx (IDirect3DDevice9 pDevice ,
HMODULE hSrcModule ,
PWideChar pSrcResource ,
LongWord Width ,
LongWord Height ,
LongWord MipLevels ,
DWORD Usage ,
TD3DFormat Format ,
TD3DPool Pool ,
DWORD Filter ,
DWORD MipFilter ,
TD3DColor ColorKey ,
PD3DXImageInfo pSrcInfo ,
PPaletteEntry pPalette ,
/* out */ IDirect3DTexture9 &ppTexture 
);
 ;
            
HRESULT CreateCubeTextureFromFile (IDirect3DDevice9 pDevice ,
PWideChar pSrcFile ,
/* out */ IDirect3DCubeTexture9 &ppCubeTexture 
);
 ;
                                             
HRESULT CreateCubeTextureFromFileEx (IDirect3DDevice9 pDevice ,
PWideChar pSrcFile ,
LongWord Size ,
LongWord MipLevels ,
DWORD Usage ,
TD3DFormat Format ,
TD3DPool Pool ,
DWORD Filter ,
DWORD MipFilter ,
TD3DColor ColorKey ,
PD3DXImageInfo pSrcInfo ,
PPaletteEntry pPalette ,
/* out */ IDirect3DCubeTexture9 &ppCubeTexture 
);
 ;
              
HRESULT CreateCubeTextureFromResource (IDirect3DDevice9 pDevice ,
HMODULE hSrcModule ,
PWideChar pSrcResource ,
/* out */ IDirect3DCubeTexture9 &ppCubeTexture 
);
 ;
                                               
HRESULT CreateCubeTextureFromResourceEx (IDirect3DDevice9 pDevice ,
HMODULE hSrcModule ,
PWideChar pSrcResource ,
LongWord Size ,
LongWord MipLevels ,
DWORD Usage ,
TD3DFormat Format ,
TD3DPool Pool ,
DWORD Filter ,
DWORD MipFilter ,
TD3DColor ColorKey ,
PD3DXImageInfo pSrcInfo ,
PPaletteEntry pPalette ,
/* out */ IDirect3DCubeTexture9 &ppCubeTexture 
);
 ;
            
HRESULT CreateVolumeTextureFromFile (IDirect3DDevice9 pDevice ,
PWideChar pSrcFile ,
/* out */ IDirect3DVolumeTexture9 &ppVolumeTexture 
);
 ;
                                               
HRESULT CreateVolumeTextureFromFileEx (IDirect3DDevice9 pDevice ,
PWideChar pSrcFile ,
LongWord Width ,
LongWord Height ,
LongWord Depth ,
LongWord MipLevels ,
DWORD Usage ,
TD3DFormat Format ,
TD3DPool Pool ,
DWORD Filter ,
DWORD MipFilter ,
TD3DColor ColorKey ,
PD3DXImageInfo pSrcInfo ,
PPaletteEntry pPalette ,
/* out */ IDirect3DVolumeTexture9 &ppTexture 
);
 ;
              
HRESULT CreateVolumeTextureFromResource (IDirect3DDevice9 pDevice ,
HMODULE hSrcModule ,
PWideChar pSrcResource ,
/* out */ IDirect3DVolumeTexture9 &ppVolumeTexture 
);
 ;
                                                 
HRESULT CreateVolumeTextureFromResourceEx (IDirect3DDevice9 pDevice ,
HMODULE hSrcModule ,
PWideChar pSrcResource ,
LongWord Width ,
LongWord Height ,
LongWord Depth ,
LongWord MipLevels ,
DWORD Usage ,
TD3DFormat Format ,
TD3DPool Pool ,
DWORD Filter ,
DWORD MipFilter ,
TD3DColor ColorKey ,
PD3DXImageInfo pSrcInfo ,
PPaletteEntry pPalette ,
/* out */ IDirect3DVolumeTexture9 &ppVolumeTexture 
);
 ;
                                       
HRESULT CreateFont (IDirect3DDevice9 pDevice ,
LongWord Height ,
LongWord Width ,
LongWord Weight ,
LongWord MipLevels ,
BOOL Italic ,
Byte CharSet ,
Byte OutputPrecision ,
Byte Quality ,
Byte PitchAndFamily ,
PWideChar pFacename ,
/* out */ ID3DXFont &ppFont 
);
 ;
             
HRESULT CreateFontIndirect (IDirect3DDevice9 pDevice ,
const TD3DXFontDescW pDesc ,
/* out */ ID3DXFont &ppFont 
);
 ;
                                 
HRESULT CreateEffectFromFile (IDirect3DDevice9 pDevice ,
PWideChar pSrcFile ,
const PD3DXMacro pDefines ,
ID3DXInclude pInclude ,
DWORD Flags ,
ID3DXEffectPool pPool ,
/* out */ ID3DXEffect &ppEffect ,
PID3DXBuffer ppCompilationErrors 
);
 ;
                                   
HRESULT CreateEffectFromResource (IDirect3DDevice9 pDevice ,
HMODULE hSrcModule ,
PWideChar pSrcResource ,
const PD3DXMacro pDefines ,
ID3DXInclude pInclude ,
DWORD Flags ,
ID3DXEffectPool pPool ,
/* out */ ID3DXEffect &ppEffect ,
PID3DXBuffer ppCompilationErrors 
);
 ;
       
HResult OnCreateDevice (IDirect3DDevice9 pd3dDevice 
);
 ;
       
HResult OnResetDevice (IDirect3DDevice9 pd3dDevice 
);
 ;
      
HResult OnLostDevice ();
 ;
      
HResult OnDestroyDevice ();
 ;
 };




         const  VK_XBUTTON1 =  $05;
         const  VK_XBUTTON2 =  $06;
        const  GCLP_HCURSOR =  -12;
      const  GWLP_HINSTANCE =  -6;

     const  WM_XBUTTONDOWN =  $020B; // (not always defined)
       const  WM_XBUTTONUP =  $020C; // (not always defined)
   const  WM_XBUTTONDBLCLK =  $020D;
      const  WM_MOUSEWHEEL =  $020A; // (not always defined)
        const  WHEEL_DELTA =  120;   // (not always defined)

           const  MK_XBUTTON1 =  $0020;
           const  MK_XBUTTON2 =  $0040;

   const  Z3D_MAX_CONTROLLERS =  4;  // XInput handles up to 4 controllers

  // Core engine error codes

                const  z3DERR_NODIRECT3D =  HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0901;
       const  z3DERR_NOCOMPATIBLEDEVICES =  HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0902;
             const  z3DERR_MEDIANOTFOUND =  HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0903;
           const  z3DERR_NONZEROREFCOUNT =  HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0904;
            const  z3DERR_CREATINGDEVICE =  HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0905;
           const  z3DERR_RESETTINGDEVICE =  HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0906;
     const  z3DERR_CREATINGDEVICEOBJECTS =  HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0907;
    const  z3DERR_RESETTINGDEVICEOBJECTS =  HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0908;
          const  z3DERR_INCORRECTVERSION =  HRESULT((1 shl 31) or (FACILITY_ITF shl 16)) or $0909;






///============================================================================///
///= Device section                                                           =///
///============================================================================///
///= Enumerates, controls and activates the 3D devices available for the      =///
///= engine to work with                                                      =///
///============================================================================///


                   typedef Boolean (*Tz3DCallback_AcceptDevice)(const TD3DCaps9 ACaps ,
const TD3DFormat AAdapterFormat ,
const TD3DFormat ABackBufferFormat ,
const Boolean AWindowed ,
const Pointer AUserContext 
);
 ;

   typedef interface Iz3DEnumAdapterInfo;
   typedef interface Iz3DEnumDeviceInfo;

  /// DepthStencil/Multisample conflict struct

   typedef Tz3DEnumDSMSConflict* PD3DEnumDSMSConflict;

   struct Tz3DEnumDSMSConflict
{

      TD3DFormat DSFormat; 

      TD3DMultiSampleType MSType; 

 };


  /// Valid device settings combination struct

   typedef TD3DDeviceSettingsCombinations* PD3DDeviceSettingsCombinations;

   struct TD3DDeviceSettingsCombinations
{

      LongWord AdapterOrdinal; 

      TD3DDevType DeviceType; 

      TD3DFormat AdapterFormat; 

      TD3DFormat BackBufferFormat; 

      Boolean Windowed; 

      typedef array<TD3DFormat> DepthStencilFormatList;
      typedef array<TD3DMultiSampleType> MultiSampleTypeList;
      typedef array<DWORD> MultiSampleQualityList;
      typedef array<LongWord> PresentIntervalList;
      typedef array<Tz3DEnumDSMSConflict> DSMSConflictList;
      Iz3DEnumAdapterInfo AdapterInfo; 

      Iz3DEnumDeviceInfo DeviceInfo; 

 };


     typedef array<Iz3DEnumAdapterInfo> Tz3DEnumAdapterInfoArray;
     typedef array<TD3DFormat> TD3DFormatArray;
     typedef array<TD3DMultiSampleType> TD3DMultiSampleTypeArray;
     typedef array<LongWord> TLongWordArray;






  /// z3D device list interface

  /// Enumerates all available devices and allows to restrict
  /// the results to a specific filter.

   class Iz3DDeviceList : public Iz3DBase
{
public:
['{24422F6E-C72F-42B8-94AA-C1BD399863FA}']
         
HRESULT EnumerateDevices (Iz3DEnumAdapterInfo pAdapterInfo ,
TD3DFormatArray pAdapterFormatList 
);
 ;
           
HRESULT EnumerateDeviceCombos (Iz3DEnumAdapterInfo pAdapterInfo ,
Iz3DEnumDeviceInfo pDeviceInfo ,
TD3DFormatArray pAdapterFormatList 
);
 ;
      
BuildDepthStencilFormatList (PD3DDeviceSettingsCombinations pDeviceCombo 
);
 ;
      
BuildMultiSampleTypeList (PD3DDeviceSettingsCombinations pDeviceCombo 
);
 ;
      
BuildDSMSConflictList (PD3DDeviceSettingsCombinations pDeviceCombo 
);
 ;
        
BuildPresentIntervalList (Iz3DEnumDeviceInfo pDeviceInfo ,
PD3DDeviceSettingsCombinations pDeviceCombo 
);
 ;
     
ClearAdapterInfoList ();
 ;
      
TD3DFormatArray GetPossibleDepthStencilFormats ();
 ;
      
TD3DMultiSampleTypeArray GetPossibleMultisampleTypes ();
 ;
      
TLongWordArray GetPossiblePresentIntervals ();
 ;
      
SetPossibleDepthStencilFormats (TD3DFormatArray a 
);
 ;
      
SetPossibleMultisampleTypes (TD3DMultiSampleTypeArray a 
);
 ;
      
SetPossiblePresentIntervals (TLongWordArray a 
);
 ;
      
SetRequirePostPixelShaderBlending (Boolean bRequire 
);
 ;
      
Boolean GetRequirePostPixelShaderBlending ();
 ;
      
LongWord GetMultisampleQualityMax ();
 ;
      
SetMultisampleQualityMax (LongWord nMax 
);
 ;
         
SetResolutionMinMax (LongWord nMinWidth ,
LongWord nMinHeight ,
LongWord nMaxWidth ,
LongWord nMaxHeight 
);
 ;
       
SetRefreshMinMax (LongWord nMin ,
LongWord nMax 
);
 ;
          
GetPossibleVertexProcessingList (/* out */ Boolean &pbSoftwareVP ,
/* out */ Boolean &pbHardwareVP ,
/* out */ Boolean &pbPureHarewareVP ,
/* out */ Boolean &pbMixedVP 
);
 ;
         
SetPossibleVertexProcessingList (Boolean bSoftwareVP ,
Boolean bHardwareVP ,
Boolean bPureHarewareVP ,
Boolean bMixedVP 
);
 ;
     
ResetPossibleDepthStencilFormats ();
 ;
     
ResetPossibleMultisampleTypes ();
 ;
     
ResetPossiblePresentIntervals ();
 ;
      
Tz3DEnumAdapterInfoArray GetAdapterInfoList ();
 ;
       
Iz3DEnumAdapterInfo GetAdapterInfo (LongWord AdapterOrdinal 
);
 ;
         
Iz3DEnumDeviceInfo GetDeviceInfo (LongWord AdapterOrdinal ,
TD3DDevType DeviceType 
);
 ;
      
Iz3DEnumDeviceInfo GetCurrentDeviceInfo ();
 ;
        
PD3DDeviceSettingsCombinations GetDeviceSettingsCombo (const Tz3DDeviceSettings pDeviceSettings 
);
 ; ;
      
PD3DDeviceSettingsCombinations GetCurrentDeviceSettingsCombo ();
 ; ;
              
PD3DDeviceSettingsCombinations GetDeviceSettingsCombo (LongWord AdapterOrdinal ,
TD3DDevType DeviceType ,
TD3DFormat AdapterFormat ,
TD3DFormat BackBufferFormat ,
Boolean Windowed 
);
 ; ;
     
CleanupDirect3DInterfaces ();
 ;
                    
HRESULT Enumerate (IDirect3D9 pD3D = nil ,
Tz3DCallback_AcceptDevice AcceptDeviceFunc = nil ,
Pointer pAcceptDeviceFuncUserContext = nil 
);
 ;

         /** \sa GetPossibleDepthStencilFormats For reading   \sa SetPossibleDepthStencilFormats For writing */
TD3DFormatArray PossibleDepthStencilFormats; 

         /** \sa GetPossibleMultisampleTypes For reading   \sa SetPossibleMultisampleTypes For writing */
TD3DMultiSampleTypeArray PossibleMultisampleTypes; 

         /** \sa GetPossiblePresentIntervals For reading   \sa SetPossiblePresentIntervals For writing */
TLongWordArray PossiblePresentIntervals; 

         /** \sa GetMultisampleQualityMax For reading   \sa SetMultisampleQualityMax For writing */
LongWord MultisampleQualityMax; 

         /** \sa GetRequirePostPixelShaderBlending For reading   \sa SetRequirePostPixelShaderBlending For writing */
Boolean RequirePostPixelShaderBlending; 

 };


   typedef TD3DDisplayModeArray* PD3DDisplayModeArray;

     typedef array<TD3DDisplayMode> TD3DDisplayModeArray;

   typedef Tz3DDeviceInfoList* Pz3DDeviceInfoList;

     typedef array<Iz3DEnumDeviceInfo> Tz3DDeviceInfoList;

   typedef TDescArray* PDescArray;

    WideChar TDescArray[255]; /*!< [0..255] */







  /// z3D adapter enumeration interface

  /// Saves information about a specific adapter in the enumeration

   class Iz3DEnumAdapterInfo : public Iz3DBase
{
public:
['{D8AEF49A-DAD4-49DC-A806-2DEE93DE584D}']
      
PD3DAdapterIdentifier9 GetAdapterIdentifier ();
 ;
      
LongWord GetAdapterOrdinal ();
 ;
      
Pz3DDeviceInfoList GetDeviceInfoList ();
 ;
      
PD3DDisplayModeArray GetDisplayModeList ();
 ;
      
PDescArray GetUniqueDescription ();
 ;
       
SetAdapterIdentifier (const PD3DAdapterIdentifier9 Value 
);
 ;
       
SetAdapterOrdinal (const LongWord Value 
);
 ;
       
SetDeviceInfoList (const Pz3DDeviceInfoList Value 
);
 ;
       
SetDisplayModeList (const PD3DDisplayModeArray Value 
);
 ;
       
SetUniqueDescription (const PDescArray Value 
);
 ;

         /** \sa GetAdapterOrdinal For reading   \sa SetAdapterOrdinal For writing */
LongWord AdapterOrdinal; 

         /** \sa GetAdapterIdentifier For reading   \sa SetAdapterIdentifier For writing */
PD3DAdapterIdentifier9 AdapterIdentifier; 

         /** \sa GetUniqueDescription For reading   \sa SetUniqueDescription For writing */
PDescArray UniqueDescription; 

         /** \sa GetDisplayModeList For reading   \sa SetDisplayModeList For writing */
PD3DDisplayModeArray DisplayModeList; 

         /** \sa GetDeviceInfoList For reading   \sa SetDeviceInfoList For writing */
Pz3DDeviceInfoList DeviceInfoList; 

 };


   typedef Tz3DDeviceSettingsComboList* Pz3DDeviceSettingsComboList;

     typedef array<PD3DDeviceSettingsCombinations> Tz3DDeviceSettingsComboList;




  /// z3D device enumeration interface

  /// Saves information about a specific device in the enumeration

   class Iz3DEnumDeviceInfo : public Iz3DBase
{
public:
['{1A6B77CE-2510-4689-955D-907E831231F6}']
      
LongWord GetAdapterOrdinal ();
 ;
      
TD3DCaps9 GetCaps ();
 ;
      
Pz3DDeviceSettingsComboList GetDeviceSettingsComboList ();
 ;
      
TD3DDevType GetDeviceType ();
 ;
       
SetAdapterOrdinal (const LongWord Value 
);
 ;
       
SetCaps (const TD3DCaps9 Value 
);
 ;
       
SetDeviceSettingsComboList (const Pz3DDeviceSettingsComboList Value 
);
 ;
       
SetDeviceType (const TD3DDevType Value 
);
 ;

         /** \sa GetAdapterOrdinal For reading   \sa SetAdapterOrdinal For writing */
LongWord AdapterOrdinal; 

         /** \sa GetDeviceType For reading   \sa SetDeviceType For writing */
TD3DDevType DeviceType; 

         /** \sa GetCaps For reading   \sa SetCaps For writing */
TD3DCaps9 Caps; 

         /** \sa GetDeviceSettingsComboList For reading   \sa SetDeviceSettingsComboList For writing */
Pz3DDeviceSettingsComboList DeviceSettingsComboList; 

 };





  // Device matching
   enum Tz3DMatchType
{
z3DMT_IGNORE_INPUT, // Use the closest valid value to a default// Use input without change, but may cause no valid device to be found// Use the closest valid value to the input
z3DMT_PRESERVE_INPUT, 
z3DMT_CLOSEST_TO_INPUT 
};


   typedef Tz3DMatchOptions* Pz3DMatchOptions;

   struct Tz3DMatchOptions
{

          Tz3DMatchType eAdapterOrdinal; 

              Tz3DMatchType eDeviceType; 

                Tz3DMatchType eWindowed; 

           Tz3DMatchType eAdapterFormat; 

        Tz3DMatchType eVertexProcessing; 

              Tz3DMatchType eResolution; 

        Tz3DMatchType eBackBufferFormat; 

         Tz3DMatchType eBackBufferCount; 

             Tz3DMatchType eMultiSample; 

              Tz3DMatchType eSwapEffect; 

             Tz3DMatchType eDepthFormat; 

           Tz3DMatchType eStencilFormat; 

            Tz3DMatchType ePresentFlags; 

             Tz3DMatchType eRefreshRate; 

         Tz3DMatchType ePresentInterval; 

 };







///============================================================================///
///= Common callback functions section                                        =///
///============================================================================///
///= This callback routines are used by the core to trigger the main 3D       =///
///= events such as device creation or frame render                           =///
///============================================================================///



  // Main callback functions
            typedef Boolean (*Tz3DCallback_ModifyDeviceSettings)(Tz3DDeviceSettings &ASettings ,
const TD3DCaps9 ACaps ,
const Pointer AUserContext 
);
 ;
            typedef HRESULT (*Tz3DCallback_DeviceCreated)(const IDirect3DDevice9 ADevice ,
const TD3DSurfaceDesc ABackBuffer ,
const Pointer AUserContext 
);
 ;
            typedef HRESULT (*Tz3DCallback_DeviceReset)(const IDirect3DDevice9 ADevice ,
const TD3DSurfaceDesc ABackBuffer ,
const Pointer AUserContext 
);
 ;
     typedef void (*Tz3DCallback_DeviceDestroyed)(const Pointer AUserContext 
);
 ;
     typedef void (*Tz3DCallback_DeviceLost)(const Pointer AUserContext 
);
 ;
              typedef void (*Tz3DCallback_FrameMove)(const IDirect3DDevice9 ADevice ,
const Double ATime ,
const Single AElapsedTime ,
const Pointer AUserContext 
);
 ;
              typedef void (*Tz3DCallback_FrameRender)(const IDirect3DDevice9 ADevice ,
const Double ATime ,
const Single AElapsedTime ,
const Pointer AUserContext 
);
 ;
            typedef void (*Tz3DCallback_Keyboard)(const LongWord AChar ,
const Boolean AKeyDown ,
const Boolean AAltDown ,
const Pointer AUserContext 
);
 ;
                 typedef void (*Tz3DCallback_Mouse)(const Boolean ALeftButtonDown ,
const Boolean ARightButtonDown ,
const Boolean AMiddleButtonDown ,
const Boolean ASideButton1Down ,
const Boolean ASideButton2Down ,
const Integer AMouseWheelDelta ,
const Integer AXPos ,
const Integer AYPos ,
const Pointer AUserContext 
);
 ;
                      typedef LRESULT (*Tz3DCallback_MsgProc)(const HWND AWnd ,
const LongWord AMsg ,
const WPARAM AWParam ,
const LPARAM ALParam ,
/* out */ Boolean &AHandled ,
const Pointer AUserContext 
);
 ;
        typedef void (*Tz3DCallback_Timer)(const LongWord AEvent ,
const Pointer AUserContext 
);


   struct Tz3DTimerRecord
{

      Tz3DCallback_Timer pCallbackTimer; 

      Pointer pCallbackUserContext; 

      Single fTimeoutInSecs; 

      Single fCountdown; 

      Boolean bEnabled; 

 };


     typedef array<Tz3DTimerRecord> Tz3DTimerRecordArray;

    Boolean Tz3DKeysArray[255]; /*!< [0..255] */

    Boolean Tz3DMouseButtonsArray[4]; /*!< [0..4] */

   typedef Tz3DKeysArray* Pz3DKeysArray;

   typedef Tz3DMouseButtonsArray* Pz3DMouseButtonsArray;






  /// z3D core state interface

  /// Allows access to the general state of the core engine to the user

   class Iz3DState : public Iz3DBase
{
public:
['{7B4EB639-3FF3-412E-862F-8B93D5F3FF02}']
      
Boolean GetActive ();

 
 ;
      /// \sa Direct3D9

HMONITOR GetAdapterMonitor ();

 
 ;
      
Boolean GetAllowShortcutKeys ();

 
 ;
      
Boolean GetAllowShortcutKeysWhenFullscreen ();

 
 ;
      
Boolean GetAllowShortcutKeysWhenWindowed ();

 
 ;
      
Boolean GetAutoChangeAdapter ();

 
 ;
      
PD3DSurfaceDesc GetBackBufferSurfaceDesc ();

 
 ;
      
PD3DCaps9 GetCaps ();

 
 ;
      
Boolean GetClipCursorWhenFullScreen ();

 
 ;
      
Boolean GetConstantFrameTime ();

 
 ;
      
Pz3DDeviceSettings GetCurrentDeviceSettings ();

 
 ;
      
Integer GetCurrentFrameNumber ();

 
 ;
      
IDirect3D9 GetD3D ();

 
 ;
      
IDirect3DDevice9 GetD3DDevice ();

 
 ;
      
Iz3DDeviceList Getz3DDeviceList ();

 
 ;
      
Boolean GetDeviceCreateCalled ();

 
 ;
      
Boolean GetDeviceCreated ();

 
 ;
      
Tz3DCallback_DeviceCreated GetDeviceCreatedFunc ();

 
 ;
      
Tz3DCallback_DeviceDestroyed GetDeviceDestroyedFunc ();

 
 ;
      
Boolean GetDeviceLost ();

 
 ;
      
Tz3DCallback_DeviceLost GetDeviceLostFunc ();

 
 ;
      
Boolean GetDeviceObjectsCreated ();

 
 ;
      
Boolean GetDeviceObjectsReset ();

 
 ;
      
Tz3DCallback_DeviceReset GetDeviceResetFunc ();

 
 ;
      
PWideChar GetDeviceStats ();

 
 ;
      
Boolean Getz3DInitCalled ();

 
 ;
      
Boolean Getz3DInited ();

 
 ;
      
Single GetElapsedTime ();

 
 ;
      
Integer GetExitCode ();

 
 ;
      
Single GetFPS ();

 
 ;
      
Tz3DCallback_FrameMove GetFrameMoveFunc ();

 
 ;
      
Tz3DCallback_FrameRender GetFrameRenderFunc ();

 
 ;
      
PWideChar GetFrameStats ();

 
 ;
      
Boolean GetHandleDefaultHotkeys ();

 
 ;
      
HWND GetHWNDFocus ();

 
 ;
      
HWND GetHWNDDeviceFullScreen ();

 
 ;
      
HWND GetHWNDDeviceWindowed ();

 
 ;
      
Boolean GetIgnoreSizeChange ();

 
 ;
      
Boolean GetNotifyOnMouseMove ();

 
 ;
      
Boolean GetInsideDeviceCallback ();

 
 ;
      
Boolean GetInsideMainloop ();

 
 ;
      
Tz3DCallback_AcceptDevice GetAcceptDeviceFunc ();

 
 ;
      
Tz3DCallback_Keyboard GetKeyboardFunc ();

 
 ;
      
HHOOK GetKeyboardHook ();

 
 ;
      
DWORD GetLastStatsUpdateFrames ();

 
 ;
      
Boolean GetCursorWatermark ();

 
 ;
      
Double GetLastStatsUpdateTime ();

 
 ;
      
Boolean GetMaximized ();

 
 ;
      
HMENU GetMenu ();

 
 ;
      
Boolean GetMinimized ();

 
 ;
      
Tz3DCallback_ModifyDeviceSettings GetModifyDeviceSettingsFunc ();

 
 ;
      
Tz3DCallback_Mouse GetMouseFunc ();

 
 ;
      
Integer GetOverrideAdapterOrdinal ();

 
 ;
      
Boolean GetOverrideConstantFrameTime ();

 
 ;
      
Single GetOverrideConstantTimePerFrame ();

 
 ;
      
Boolean GetOverrideForceHAL ();

 
 ;
      
Boolean GetOverrideForceHWVP ();

 
 ;
      
Boolean GetOverrideForcePureHWVP ();

 
 ;
      
Boolean GetOverrideForceREF ();

 
 ;
      
Boolean GetOverrideForceSWVP ();

 
 ;
      
Boolean GetOverrideFullScreen ();

 
 ;
      
Integer GetOverrideHeight ();

 
 ;
      
Integer GetOverrideQuitAfterFrame ();

 
 ;
      
Integer GetOverrideForceVsync ();

 
 ;
      
PWideChar GetCurrentApp ();

 
 ;
      
Integer GetOverrideStartX ();

 
 ;
      
Integer GetOverrideStartY ();

 
 ;
      
Integer GetOverrideWidth ();

 
 ;
      
Boolean GetOverrideWindowed ();

 
 ;
      
Integer GetPauseRenderingCount ();

 
 ;
      
Integer GetPauseTimeCount ();

 
 ;
      
Boolean GetRenderingPaused ();

 
 ;
      
Boolean GetShowCursorWhenFullScreen ();

 
 ;
      
Boolean GetShowMsgBoxOnError ();

 
 ;
      
Boolean GetNoStats ();

 
 ;
      
TFilterKeys GetStartupFilterKeys ();

 
 ;
      
TStickyKeys GetStartupStickyKeys ();

 
 ;
      
TToggleKeys GetStartupToggleKeys ();

 
 ;
      
PWideChar GetStaticFrameStats ();

 
 ;
      
PWideChar GetFPSStats ();

 
 ;
      
Double GetTime ();

 
 ;
      
Double GetAbsoluteTime ();

 
 ;
      
Boolean GetTimePaused ();

 
 ;
      
Single GetTimePerFrame ();

 
 ;
      
Tz3DTimerRecordArray GetTimerList ();

 
 ;
      
Pz3DKeysArray GetKeys ();

 
 ;
      
Pz3DMouseButtonsArray GetMouseButtons ();

 
 ;
      
Boolean GetWindowCreateCalled ();

 
 ;
      
Boolean GetWindowCreated ();

 
 ;
      
Boolean GetWindowCreatedWithDefaultPositions ();

 
 ;
      
Tz3DCallback_MsgProc GetWindowMsgFunc ();

 
 ;
      
PWideChar GetWindowTitle ();

 
 ;
      
Boolean GetWireframeMode ();

 
 ;
      
LongWord GetFullScreenBackBufferWidthAtModeChange ();

 
 ;
      
LongWord GetFullScreenBackBufferHeightAtModeChange ();

 
 ;
      
LongWord GetWindowBackBufferWidthAtModeChange ();

 
 ;
      
LongWord GetWindowBackBufferHeightAtModeChange ();

 
 ;
      
PWindowPlacement GetWindowedPlacement ();

 
 ;
      
DWORD GetWindowedStyleAtModeChange ();

 
 ;
      
Boolean GetTopmostWhileWindowed ();

 
 ;
      
Boolean GetMinimizedWhileFullscreen ();

 
 ;
      
HINST GetHInstance ();

 
 ;
      
Boolean GetAutomation ();

 
 ;
      
Boolean GetInSizeMove ();

 
 ;
      
Pointer GetAcceptDeviceFuncUserContext ();

 
 ;
      
Pointer GetModifyDeviceSettingsFuncUserContext ();

 
 ;
      
Pointer GetDeviceCreatedFuncUserContext ();

 
 ;
      
Pointer GetDeviceResetFuncUserContext ();

 
 ;
      
Pointer GetDeviceLostFuncUserContext ();

 
 ;
      
Pointer GetDeviceDestroyedFuncUserContext ();

 
 ;
      
Pointer GetFrameMoveFuncUserContext ();

 
 ;
      
Pointer GetFrameRenderFuncUserContext ();

 
 ;
      
Pointer GetKeyboardFuncUserContext ();

 
 ;
      
Pointer GetMouseFuncUserContext ();

 
 ;
      
Pointer GetWindowMsgFuncUserContext ();

 
 ;
      
Boolean GetCallDefWindowProc ();

 
 ;
      
Boolean GetHandleAltEnter ();

 
 ;
      
Single GetStatsUpdateInterval ();

 
 ;
       
SetActive (const Boolean Value 
);

 
 ;
       
SetAdapterMonitor (const Direct3D9::ONITOR Value 
);

 
 ;
       
SetAllowShortcutKeys (const Boolean Value 
);

 
 ;
       
SetAllowShortcutKeysWhenFullscreen (const Boolean Value 
);

 
 ;
       
SetAllowShortcutKeysWhenWindowed (const Boolean Value 
);

 
 ;
       
SetAutoChangeAdapter (const Boolean Value 
);

 
 ;
       
SetBackBufferSurfaceDesc (const PD3DSurfaceDesc Value 
);

 
 ;
       
SetCaps (const PD3DCaps9 Value 
);

 
 ;
       
SetClipCursorWhenFullScreen (const Boolean Value 
);

 
 ;
       
SetConstantFrameTime (const Boolean Value 
);

 
 ;
       
SetCurrentDeviceSettings (const Pz3DDeviceSettings Value 
);

 
 ;
       
SetCurrentFrameNumber (const Integer Value 
);

 
 ;
       
SetD3D (const IDirect3D9 Value 
);

 
 ;
       
SetD3DDevice (const IDirect3DDevice9 Value 
);

 
 ;
       
Setz3DDeviceList (const Iz3DDeviceList Value 
);

 
 ;
       
SetDeviceCreateCalled (const Boolean Value 
);

 
 ;
       
SetDeviceCreated (const Boolean Value 
);

 
 ;
             
SetDeviceCreatedFunc (const Tz3DCallback_DeviceCreated Value 
);

 
 ;
             
SetDeviceDestroyedFunc (const Tz3DCallback_DeviceDestroyed Value 
);

 
 ;
       
SetDeviceLost (const Boolean Value 
);

 
 ;
       
SetDeviceLostFunc (const Tz3DCallback_DeviceLost Value 
);

 
 ;
       
SetDeviceObjectsCreated (const Boolean Value 
);

 
 ;
       
SetDeviceObjectsReset (const Boolean Value 
);

 
 ;
       
SetDeviceResetFunc (const Tz3DCallback_DeviceReset Value 
);

 
 ;
       
Setz3DInitCalled (const Boolean Value 
);

 
 ;
       
Setz3DInited (const Boolean Value 
);

 
 ;
       
SetElapsedTime (const Single Value 
);

 
 ;
       
SetExitCode (const Integer Value 
);

 
 ;
       
SetFPS (const Single Value 
);

 
 ;
       
SetFrameMoveFunc (const Tz3DCallback_FrameMove Value 
);

 
 ;
       
SetFrameRenderFunc (const Tz3DCallback_FrameRender Value 
);

 
 ;
       
SetHandleDefaultHotkeys (const Boolean Value 
);

 
 ;
       
SetHWNDFocus (const HWND Value 
);

 
 ;
       
SetHWNDDeviceFullScreen (const HWND Value 
);

 
 ;
       
SetHWNDDeviceWindowed (const HWND Value 
);

 
 ;
       
SetIgnoreSizeChange (const Boolean Value 
);

 
 ;
       
SetNotifyOnMouseMove (const Boolean Value 
);

 
 ;
       
SetInsideDeviceCallback (const Boolean Value 
);

 
 ;
       
SetInsideMainloop (const Boolean Value 
);

 
 ;
             
SetAcceptDeviceFunc (const Tz3DCallback_AcceptDevice Value 
);

 
 ;
       
SetKeyboardFunc (const Tz3DCallback_Keyboard Value 
);

 
 ;
       
SetKeyboardHook (const HHOOK Value 
);

 
 ;
       
SetLastStatsUpdateFrames (const DWORD Value 
);

 
 ;
       
SetLastStatsUpdateTime (const Double Value 
);

 
 ;
       
SetMaximized (const Boolean Value 
);

 
 ;
       
SetMenu (const HMENU Value 
);

 
 ;
       
SetMinimized (const Boolean Value 
);

 
 ;
             
SetModifyDeviceSettingsFunc (const Tz3DCallback_ModifyDeviceSettings Value 
);

 
 ;
       
SetMouseFunc (const Tz3DCallback_Mouse Value 
);

 
 ;
       
SetOverrideAdapterOrdinal (const Integer Value 
);

 
 ;
       
SetOverrideConstantFrameTime (const Boolean Value 
);

 
 ;
       
SetOverrideConstantTimePerFrame (const Single Value 
);

 
 ;
       
SetOverrideForceHAL (const Boolean Value 
);

 
 ;
       
SetOverrideForceHWVP (const Boolean Value 
);

 
 ;
       
SetOverrideForcePureHWVP (const Boolean Value 
);

 
 ;
       
SetOverrideForceREF (const Boolean Value 
);

 
 ;
       
SetOverrideForceSWVP (const Boolean Value 
);

 
 ;
       
SetOverrideFullScreen (const Boolean Value 
);

 
 ;
       
SetOverrideHeight (const Integer Value 
);

 
 ;
       
SetOverrideQuitAfterFrame (const Integer Value 
);

 
 ;
       
SetOverrideForceVsync (const Integer Value 
);

 
 ;
       
SetOverrideRelaunchMCE (const Boolean Value 
);

 
 ;
       
SetOverrideStartX (const Integer Value 
);

 
 ;
       
SetOverrideStartY (const Integer Value 
);

 
 ;
       
SetOverrideWidth (const Integer Value 
);

 
 ;
       
SetOverrideWindowed (const Boolean Value 
);

 
 ;
       
SetPauseRenderingCount (const Integer Value 
);

 
 ;
       
SetPauseTimeCount (const Integer Value 
);

 
 ;
       
SetRenderingPaused (const Boolean Value 
);

 
 ;
       
SetShowCursorWhenFullScreen (const Boolean Value 
);

 
 ;
       
SetShowMsgBoxOnError (const Boolean Value 
);

 
 ;
       
SetNoStats (const Boolean Value 
);

 
 ;
       
SetStartupFilterKeys (const TFilterKeys Value 
);

 
 ;
       
SetStartupStickyKeys (const TStickyKeys Value 
);

 
 ;
       
SetStartupToggleKeys (const TToggleKeys Value 
);

 
 ;
       
SetTime (const Double Value 
);

 
 ;
       
SetAbsoluteTime (const Double Value 
);

 
 ;
       
SetTimePaused (const Boolean Value 
);

 
 ;
       
SetTimePerFrame (const Single Value 
);

 
 ;
       
SetTimerList (const Tz3DTimerRecordArray Value 
);

 
 ;
       
SetWindowCreateCalled (const Boolean Value 
);

 
 ;
       
SetWindowCreated (const Boolean Value 
);

 
 ;
       
SetWindowCreatedWithDefaultPositions (const Boolean Value 
);

 
 ;
       
SetWindowMsgFunc (const Tz3DCallback_MsgProc Value 
);

 
 ;
       
SetWireframeMode (const Boolean Value 
);

 
 ;
       
SetFullScreenBackBufferWidthAtModeChange (const LongWord Value 
);

 
 ;
       
SetFullScreenBackBufferHeightAtModeChange (const LongWord Value 
);

 
 ;
       
SetWindowBackBufferWidthAtModeChange (const LongWord Value 
);

 
 ;
       
SetWindowBackBufferHeightAtModeChange (const LongWord Value 
);

 
 ;
       
SetWindowedPlacement (const PWindowPlacement Value 
);

 
 ;
       
SetWindowedStyleAtModeChange (const DWORD Value 
);

 
 ;
       
SetCursorWatermark (const Boolean Value 
);

 
 ;
       
SetTopmostWhileWindowed (const Boolean Value 
);

 
 ;
       
SetMinimizedWhileFullscreen (const Boolean Value 
);

 
 ;
       
SetHInstance (const HINST Value 
);

 
 ;
       
SetAutomation (const Boolean Value 
);

 
 ;
       
SetInSizeMove (const Boolean Value 
);

 
 ;
       
SetStatsUpdateInterval (const Single Value 
);

 
 ;
       
SetAcceptDeviceFuncUserContext (const Pointer Value 
);

 
 ;
       
SetModifyDeviceSettingsFuncUserContext (const Pointer Value 
);

 
 ;
       
SetDeviceCreatedFuncUserContext (const Pointer Value 
);

 
 ;
       
SetDeviceResetFuncUserContext (const Pointer Value 
);

 
 ;
       
SetDeviceLostFuncUserContext (const Pointer Value 
);

 
 ;
       
SetDeviceDestroyedFuncUserContext (const Pointer Value 
);

 
 ;
       
SetFrameMoveFuncUserContext (const Pointer Value 
);

 
 ;
       
SetFrameRenderFuncUserContext (const Pointer Value 
);

 
 ;
       
SetKeyboardFuncUserContext (const Pointer Value 
);

 
 ;
       
SetMouseFuncUserContext (const Pointer Value 
);

 
 ;
       
SetWindowMsgFuncUserContext (const Pointer Value 
);

 
 ;
       
SetCallDefWindowProc (const Boolean Value 
);

 
 ;
       
SetHandleAltEnter (const Boolean Value 
);

 
 ;
       
SetCurrentApp (const PWideChar Value 
);

 
 ;
     
CreateState ();
 ;
     
DestroyState ();
 ;
    
         /** \sa GetD3D For reading   \sa SetD3D For writing */
IDirect3D9 D3D; 

         /** \sa GetD3DDevice For reading   \sa SetD3DDevice For writing */
IDirect3DDevice9 D3DDevice; 

         /** \sa Getz3DDeviceList For reading   \sa Setz3DDeviceList For writing */
Iz3DDeviceList z3DDeviceList; 

         /** \sa GetCurrentDeviceSettings For reading   \sa SetCurrentDeviceSettings For writing */
Pz3DDeviceSettings CurrentDeviceSettings; 

         /** \sa GetBackBufferSurfaceDesc For reading   \sa SetBackBufferSurfaceDesc For writing */
PD3DSurfaceDesc BackBufferSurfaceDesc; 

         /** \sa GetCaps For reading   \sa SetCaps For writing */
PD3DCaps9 Caps; 

         /** \sa GetHWNDFocus For reading   \sa SetHWNDFocus For writing */
HWND HWNDFocus; 

         /** \sa GetHWNDDeviceFullScreen For reading   \sa SetHWNDDeviceFullScreen For writing */
HWND HWNDDeviceFullScreen; 

         /** \sa GetHWNDDeviceWindowed For reading   \sa SetHWNDDeviceWindowed For writing */
HWND HWNDDeviceWindowed; 

         /** \sa GetAdapterMonitor For reading   \sa SetAdapterMonitor For writing */
HMONITOR AdapterMonitor; 

         /** \sa GetMenu For reading   \sa SetMenu For writing */
HMENU Menu; 

         /** \sa GetFullScreenBackBufferWidthAtModeChange For reading   \sa SetFullScreenBackBufferWidthAtModeChange For writing */
LongWord FullScreenBackBufferWidthAtModeChange; 

         /** \sa GetFullScreenBackBufferHeightAtModeChange For reading   \sa SetFullScreenBackBufferHeightAtModeChange For writing */
LongWord FullScreenBackBufferHeightAtModeChange; 

         /** \sa GetWindowBackBufferWidthAtModeChange For reading   \sa SetWindowBackBufferWidthAtModeChange For writing */
LongWord WindowBackBufferWidthAtModeChange; 

         /** \sa GetWindowBackBufferHeightAtModeChange For reading   \sa SetWindowBackBufferHeightAtModeChange For writing */
LongWord WindowBackBufferHeightAtModeChange; 

         /** \sa GetWindowedPlacement For reading   \sa SetWindowedPlacement For writing */
PWindowPlacement WindowedPlacement; 

         /** \sa GetWindowedStyleAtModeChange For reading   \sa SetWindowedStyleAtModeChange For writing */
DWORD WindowedStyleAtModeChange; 

         /** \sa GetTopmostWhileWindowed For reading   \sa SetTopmostWhileWindowed For writing */
Boolean TopmostWhileWindowed; 

         /** \sa GetMinimized For reading   \sa SetMinimized For writing */
Boolean Minimized; 

         /** \sa GetMaximized For reading   \sa SetMaximized For writing */
Boolean Maximized; 

         /** \sa GetMinimizedWhileFullscreen For reading   \sa SetMinimizedWhileFullscreen For writing */
Boolean MinimizedWhileFullscreen; 

         /** \sa GetIgnoreSizeChange For reading   \sa SetIgnoreSizeChange For writing */
Boolean IgnoreSizeChange; 

         /** \sa GetTime For reading   \sa SetTime For writing */
Double Time; 

         /** \sa GetAbsoluteTime For reading   \sa SetAbsoluteTime For writing */
Double AbsoluteTime; 

         /** \sa GetElapsedTime For reading   \sa SetElapsedTime For writing */
Single ElapsedTime; 

         /** \sa GetHInstance For reading   \sa SetHInstance For writing */
HINST HInstance; 

         /** \sa GetLastStatsUpdateTime For reading   \sa SetLastStatsUpdateTime For writing */
Double LastStatsUpdateTime; 

         /** \sa GetLastStatsUpdateFrames For reading   \sa SetLastStatsUpdateFrames For writing */
DWORD LastStatsUpdateFrames; 

         /** \sa GetFPS For reading   \sa SetFPS For writing */
Single FPS; 

         /** \sa GetStatsUpdateInterval For reading   \sa SetStatsUpdateInterval For writing */
Single StatsUpdateInterval; 

         /** \sa GetCurrentFrameNumber For reading   \sa SetCurrentFrameNumber For writing */
Integer CurrentFrameNumber; 

         /** \sa GetKeyboardHook For reading   \sa SetKeyboardHook For writing */
HHOOK KeyboardHook; 

         /** \sa GetAllowShortcutKeysWhenFullscreen For reading   \sa SetAllowShortcutKeysWhenFullscreen For writing */
Boolean AllowShortcutKeysWhenFullscreen; 

         /** \sa GetAllowShortcutKeysWhenWindowed For reading   \sa SetAllowShortcutKeysWhenWindowed For writing */
Boolean AllowShortcutKeysWhenWindowed; 

         /** \sa GetAllowShortcutKeys For reading   \sa SetAllowShortcutKeys For writing */
Boolean AllowShortcutKeys; 

         /** \sa GetCallDefWindowProc For reading   \sa SetCallDefWindowProc For writing */
Boolean CallDefWindowProc; 

         /** \sa GetStartupStickyKeys For reading   \sa SetStartupStickyKeys For writing */
TStickyKeys StartupStickyKeys; 

         /** \sa GetStartupToggleKeys For reading   \sa SetStartupToggleKeys For writing */
TToggleKeys StartupToggleKeys; 

         /** \sa GetStartupFilterKeys For reading   \sa SetStartupFilterKeys For writing */
TFilterKeys StartupFilterKeys; 

         /** \sa GetHandleDefaultHotkeys For reading   \sa SetHandleDefaultHotkeys For writing */
Boolean HandleDefaultHotkeys; 

         /** \sa GetHandleAltEnter For reading   \sa SetHandleAltEnter For writing */
Boolean HandleAltEnter; 

         /** \sa GetShowMsgBoxOnError For reading   \sa SetShowMsgBoxOnError For writing */
Boolean ShowMsgBoxOnError; 

         /** \sa GetNoStats For reading   \sa SetNoStats For writing */
Boolean NoStats; 

         /** \sa GetClipCursorWhenFullScreen For reading   \sa SetClipCursorWhenFullScreen For writing */
Boolean ClipCursorWhenFullScreen; 

         /** \sa GetShowCursorWhenFullScreen For reading   \sa SetShowCursorWhenFullScreen For writing */
Boolean ShowCursorWhenFullScreen; 

         /** \sa GetCursorWatermark For reading   \sa SetCursorWatermark For writing */
Boolean CursorWatermark; 

         /** \sa GetConstantFrameTime For reading   \sa SetConstantFrameTime For writing */
Boolean ConstantFrameTime; 

         /** \sa GetTimePerFrame For reading   \sa SetTimePerFrame For writing */
Single TimePerFrame; 

         /** \sa GetWireframeMode For reading   \sa SetWireframeMode For writing */
Boolean WireframeMode; 

         /** \sa GetAutoChangeAdapter For reading   \sa SetAutoChangeAdapter For writing */
Boolean AutoChangeAdapter; 

         /** \sa GetWindowCreatedWithDefaultPositions For reading   \sa SetWindowCreatedWithDefaultPositions For writing */
Boolean WindowCreatedWithDefaultPositions; 

         /** \sa GetExitCode For reading   \sa SetExitCode For writing */
Integer ExitCode; 

         /** \sa Getz3DInited For reading   \sa Setz3DInited For writing */
Boolean z3DInited; 

         /** \sa GetWindowCreated For reading   \sa SetWindowCreated For writing */
Boolean WindowCreated; 

         /** \sa GetDeviceCreated For reading   \sa SetDeviceCreated For writing */
Boolean DeviceCreated; 

         /** \sa Getz3DInitCalled For reading   \sa Setz3DInitCalled For writing */
Boolean z3DInitCalled; 

         /** \sa GetWindowCreateCalled For reading   \sa SetWindowCreateCalled For writing */
Boolean WindowCreateCalled; 

         /** \sa GetDeviceCreateCalled For reading   \sa SetDeviceCreateCalled For writing */
Boolean DeviceCreateCalled; 

         /** \sa GetInsideDeviceCallback For reading   \sa SetInsideDeviceCallback For writing */
Boolean InsideDeviceCallback; 

         /** \sa GetInsideMainloop For reading   \sa SetInsideMainloop For writing */
Boolean InsideMainloop; 

         /** \sa GetDeviceObjectsCreated For reading   \sa SetDeviceObjectsCreated For writing */
Boolean DeviceObjectsCreated; 

         /** \sa GetDeviceObjectsReset For reading   \sa SetDeviceObjectsReset For writing */
Boolean DeviceObjectsReset; 

         /** \sa GetActive For reading   \sa SetActive For writing */
Boolean Active; 

         /** \sa GetRenderingPaused For reading   \sa SetRenderingPaused For writing */
Boolean RenderingPaused; 

         /** \sa GetTimePaused For reading   \sa SetTimePaused For writing */
Boolean TimePaused; 

         /** \sa GetPauseRenderingCount For reading   \sa SetPauseRenderingCount For writing */
Integer PauseRenderingCount; 

         /** \sa GetPauseTimeCount For reading   \sa SetPauseTimeCount For writing */
Integer PauseTimeCount; 

         /** \sa GetDeviceLost For reading   \sa SetDeviceLost For writing */
Boolean DeviceLost; 

         /** \sa GetNotifyOnMouseMove For reading   \sa SetNotifyOnMouseMove For writing */
Boolean NotifyOnMouseMove; 

         /** \sa GetOverrideAdapterOrdinal For reading   \sa SetOverrideAdapterOrdinal For writing */
Integer OverrideAdapterOrdinal; 

         /** \sa GetOverrideWindowed For reading   \sa SetOverrideWindowed For writing */
Boolean OverrideWindowed; 

         /** \sa GetOverrideFullScreen For reading   \sa SetOverrideFullScreen For writing */
Boolean OverrideFullScreen; 

         /** \sa GetOverrideStartX For reading   \sa SetOverrideStartX For writing */
Integer OverrideStartX; 

         /** \sa GetOverrideStartY For reading   \sa SetOverrideStartY For writing */
Integer OverrideStartY; 

         /** \sa GetOverrideWidth For reading   \sa SetOverrideWidth For writing */
Integer OverrideWidth; 

         /** \sa GetOverrideHeight For reading   \sa SetOverrideHeight For writing */
Integer OverrideHeight; 

         /** \sa GetOverrideForceHAL For reading   \sa SetOverrideForceHAL For writing */
Boolean OverrideForceHAL; 

         /** \sa GetOverrideForceREF For reading   \sa SetOverrideForceREF For writing */
Boolean OverrideForceREF; 

         /** \sa GetOverrideForcePureHWVP For reading   \sa SetOverrideForcePureHWVP For writing */
Boolean OverrideForcePureHWVP; 

         /** \sa GetOverrideForceHWVP For reading   \sa SetOverrideForceHWVP For writing */
Boolean OverrideForceHWVP; 

         /** \sa GetOverrideForceSWVP For reading   \sa SetOverrideForceSWVP For writing */
Boolean OverrideForceSWVP; 

         /** \sa GetOverrideConstantFrameTime For reading   \sa SetOverrideConstantFrameTime For writing */
Boolean OverrideConstantFrameTime; 

         /** \sa GetOverrideConstantTimePerFrame For reading   \sa SetOverrideConstantTimePerFrame For writing */
Single OverrideConstantTimePerFrame; 

         /** \sa GetOverrideQuitAfterFrame For reading   \sa SetOverrideQuitAfterFrame For writing */
Integer OverrideQuitAfterFrame; 

         /** \sa GetOverrideForceVsync For reading   \sa SetOverrideForceVsync For writing */
Integer OverrideForceVsync; 

         /** \sa GetAcceptDeviceFunc For reading   \sa SetAcceptDeviceFunc For writing */
Tz3DCallback_AcceptDevice AcceptDeviceFunc; 

         /** \sa GetModifyDeviceSettingsFunc For reading   \sa SetModifyDeviceSettingsFunc For writing */
Tz3DCallback_ModifyDeviceSettings ModifyDeviceSettingsFunc; 

         /** \sa GetDeviceCreatedFunc For reading   \sa SetDeviceCreatedFunc For writing */
Tz3DCallback_DeviceCreated DeviceCreatedFunc; 

         /** \sa GetDeviceResetFunc For reading   \sa SetDeviceResetFunc For writing */
Tz3DCallback_DeviceReset DeviceResetFunc; 

         /** \sa GetDeviceLostFunc For reading   \sa SetDeviceLostFunc For writing */
Tz3DCallback_DeviceLost DeviceLostFunc; 

         /** \sa GetDeviceDestroyedFunc For reading   \sa SetDeviceDestroyedFunc For writing */
Tz3DCallback_DeviceDestroyed DeviceDestroyedFunc; 

         /** \sa GetFrameMoveFunc For reading   \sa SetFrameMoveFunc For writing */
Tz3DCallback_FrameMove FrameMoveFunc; 

         /** \sa GetFrameRenderFunc For reading   \sa SetFrameRenderFunc For writing */
Tz3DCallback_FrameRender FrameRenderFunc; 

         /** \sa GetKeyboardFunc For reading   \sa SetKeyboardFunc For writing */
Tz3DCallback_Keyboard KeyboardFunc; 

         /** \sa GetMouseFunc For reading   \sa SetMouseFunc For writing */
Tz3DCallback_Mouse MouseFunc; 

         /** \sa GetWindowMsgFunc For reading   \sa SetWindowMsgFunc For writing */
Tz3DCallback_MsgProc WindowMsgFunc; 

         /** \sa GetAutomation For reading   \sa SetAutomation For writing */
Boolean Automation; 

         /** \sa GetInSizeMove For reading   \sa SetInSizeMove For writing */
Boolean InSizeMove; 

         /** \sa GetCurrentApp For reading   \sa SetCurrentApp For writing */
PWideChar CurrentApp; 

         /** \sa GetAcceptDeviceFuncUserContext For reading   \sa SetAcceptDeviceFuncUserContext For writing */
Pointer AcceptDeviceFuncUserContext; 

         /** \sa GetModifyDeviceSettingsFuncUserContext For reading   \sa SetModifyDeviceSettingsFuncUserContext For writing */
Pointer ModifyDeviceSettingsFuncUserContext; 

         /** \sa GetDeviceCreatedFuncUserContext For reading   \sa SetDeviceCreatedFuncUserContext For writing */
Pointer DeviceCreatedFuncUserContext; 

         /** \sa GetDeviceResetFuncUserContext For reading   \sa SetDeviceResetFuncUserContext For writing */
Pointer DeviceResetFuncUserContext; 

         /** \sa GetDeviceLostFuncUserContext For reading   \sa SetDeviceLostFuncUserContext For writing */
Pointer DeviceLostFuncUserContext; 

         /** \sa GetDeviceDestroyedFuncUserContext For reading   \sa SetDeviceDestroyedFuncUserContext For writing */
Pointer DeviceDestroyedFuncUserContext; 

         /** \sa GetFrameMoveFuncUserContext For reading   \sa SetFrameMoveFuncUserContext For writing */
Pointer FrameMoveFuncUserContext; 

         /** \sa GetFrameRenderFuncUserContext For reading   \sa SetFrameRenderFuncUserContext For writing */
Pointer FrameRenderFuncUserContext; 

         /** \sa GetKeyboardFuncUserContext For reading   \sa SetKeyboardFuncUserContext For writing */
Pointer KeyboardFuncUserContext; 

         /** \sa GetMouseFuncUserContext For reading   \sa SetMouseFuncUserContext For writing */
Pointer MouseFuncUserContext; 

         /** \sa GetWindowMsgFuncUserContext For reading   \sa SetWindowMsgFuncUserContext For writing */
Pointer WindowMsgFuncUserContext; 

         /** \sa GetTimerList For reading   \sa SetTimerList For writing */
Tz3DTimerRecordArray TimerList; 

       /** \sa GetKeys For reading*/
Pz3DKeysArray Keys; 

       /** \sa GetMouseButtons For reading*/
Pz3DMouseButtonsArray MouseButtons; 

       /** \sa GetStaticFrameStats For reading*/
PWideChar StaticFrameStats; 

       /** \sa GetFPSStats For reading*/
PWideChar FPSStats; 

       /** \sa GetFrameStats For reading*/
PWideChar FrameStats; 

       /** \sa GetDeviceStats For reading*/
PWideChar DeviceStats; 

       /** \sa GetWindowTitle For reading*/
PWideChar WindowTitle; 

 };




   typedef TKBDLLHookStruct* PKBDLLHookStruct;

   struct tagKBDLLHOOKSTRUCT
{

      DWORD vkCode; 

      DWORD scanCode; 

      DWORD flags; 

      DWORD time; 

      ULONG_PTR dwExtraInfo; 

 };

  
   typedef tagKBDLLHOOKSTRUCT KBDLLHOOKSTRUCT;
  
   typedef KBDLLHOOKSTRUCT TKBDLLHookStruct;


       const  WH_KEYBOARD_LL =  13;
          const  WH_MOUSE_LL =  14;

           const  z3D_PRIMARY_MONITOR =  HMONITOR($12340042);


   const  VK_LWIN =  91;
   const  VK_RWIN =  92;

   const  E_FAIL =  HRESULT($80004005);
   const  E_INVALIDARG =  HRESULT($80070057);
   const  E_OUTOFMEMORY =  HRESULT($8007000E);
   const  E_NOTIMPL =  HRESULT($80004001);






// finished

