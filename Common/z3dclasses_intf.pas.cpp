///============================================================================///
///= Zenith 3D Engine - Developed by Juan Pablo Ventoso                       =///
///============================================================================///
///= Unit: z3DClasses. Main classes for z3D objects                           =///
///============================================================================///






    







   typedef interface Iz3DBase;

      typedef void (*Tz3DBaseObjectEvent)(const Iz3DBase ASender 
);
 ;
     typedef void (*Tz3DBaseCallbackEvent)(const Iz3DBase ASender 
);
 ;

/// z3D base interface.

/// Implements methods for initialization and cleanup and holds a reference
/// to its owner (if any) as a Pointer type to avoid mutual reference
/// counting.

   class Iz3DBase : public IUnknown
{
public:
['{07C50756-F9A5-4AE5-8602-58F0A04FA83D}']
    /// Returns the owner interface, if any
      
Iz3DBase GetOwner ();
 ;
    /// Initializes the internal variables and interfaces
    /// and prepares the interface to work properly
         
Init (const Iz3DBase AOwner = nil 
);
 ;
    /// Releases reference to interfaces and frees internal memory
     
Cleanup ();
 ;

    /// Owner interface, if any
       /** \sa GetOwner For reading*/
Iz3DBase Owner; 

 };







  /// Device settings struct
   typedef Tz3DDeviceSettings* Pz3DDeviceSettings;

   struct Tz3DDeviceSettings
{

      LongWord AdapterOrdinal; 

      TD3DDevType DeviceType; 

      TD3DFormat AdapterFormat; 

      DWORD BehaviorFlags; 

      TD3DPresentParameters PresentParams; 

 };


   enum Tz3DStartScenarioStage
{
z3dssCreatingScenario, 
z3dssCreatingScenarioObjects, 
z3dssCreatingWorld, 
z3dssCreatingWorldObjects, 
z3dssCreatingLightingSystem 
};


   enum Tz3DCreateObjectCaller
{
z3dcocCreateDevice, 
z3dcocResetDevice, 
z3dcocStartScenario 
};

   enum Tz3DDestroyObjectCaller
{
z3ddocDestroyDevice, 
z3ddocLostDevice, 
z3ddocStopScenario 
};


   enum Tz3DLinkNotification
{
z3dlnDevice, 
z3dlnFrameMove, 
z3dlnGPUPrecomputation, 
z3dlnFrameRender, 
z3dlnLightingRender, 
z3dlnDirectLightRender, 
z3dlnGUIRender, 
z3dlnMessages, 
z3dlnKeyboard 
};


     typedef set<Tz3DLinkNotification> Tz3DLinkNotifications;

/// z3D linked interface.

/// This interface can access to the common z3D Engine events such as device
/// creation, frame move or scenario render.
/// The z3D Engine will call this events on any object that implements this
/// interface and that registers with the engine by calling
/// z3DGlobalEngine.AddLink().

   class Iz3DLinked : public Iz3DBase
{
public:
['{F092F9D0-8C3D-424C-BF9C-9A3DBB734B63}']
    /// Returns if the interface works only when a scenario is enabled
      
Boolean GetScenarioLevel ();
 ;
    /// Sets if the interface works only when a scenario is enabled
       
SetScenarioLevel (const Boolean Value 
);
 ;
    /// If ScenarioLevel is TRUE, returns the creation stage for this interface
      
Tz3DStartScenarioStage GetScenarioStage ();
 ;
    /// If ScenarioLevel is TRUE, sets the creation stage for this interface
       
SetScenarioStage (const Tz3DStartScenarioStage AStage 
);
 ;
    /// Returns the notifications that this interface needs to receive
      
Tz3DLinkNotifications GetNotifications ();
 ;
    /// Sets the notifications that this interface needs to receive
       
SetNotifications (const Tz3DLinkNotifications ANotifications 
);
 ;

    /// Device creation notification
     
z3DCreateDevice ();
 ;
    /// Device destruction notification
     
z3DDestroyDevice ();
 ;
    /// Device reset notification
     
z3DResetDevice ();
 ;
    /// Device lost notification
     
z3DLostDevice ();
 ;

    /// Device confirmation notification
                   
z3DConfirmDevice (const TD3DCaps9 ACaps ,
const TD3DFormat AAdapterFormat ,
const TD3DFormat ABackBufferFormat ,
Boolean &AAccept 
);
 ;
    /// Device modification notification
          
z3DModifyDevice (Tz3DDeviceSettings &ADeviceSettings ,
const TD3DCaps9 ACaps 
);
 ;

    /// Scenario start notification
       
z3DStartScenario (const Tz3DStartScenarioStage AStage 
);
 ;
    /// Scenario stop notification
     
z3DStopScenario ();
 ;
    /// Objects creation notification
       
z3DCreateScenarioObjects (const Tz3DCreateObjectCaller ACaller 
);
 ;
    /// Objects destruction notification
       
z3DDestroyScenarioObjects (const Tz3DDestroyObjectCaller ACaller 
);
 ;

    /// Frame move notification
     
z3DFrameMove ();
 ;
    /// GPU precomputation notification.
    /// Before the scenario runs, a precomputation event is called
    /// to perform offline GPU processing
     
z3DGPUPrecomputation ();
 ;
    /// Frame render notification
     
z3DFrameRender ();
 ;
    /// Lighting render notification (ambient)
     
z3DLightingRender ();
 ;
    /// Direct light render notification (light)
     
z3DDirectLightRender ();
 ;
    /// GUI render notification
     
z3DGUIRender ();
 ;

    /// Message notification
                           
z3DMessage (const HWnd AWnd ,
const LongWord AMsg ,
const wParam AwParam ,
const lParam AlParam ,
Boolean &ADefault ,
lResult &AResult 
);
 ;
    /// Keyboard notification
           
z3DKeyboard (const LongWord AChar ,
const Boolean AKeyDown ,
const Boolean AAltDown 
);
 ;

    /// If ScenarioLevel is TRUE, creation stage for this interface
         /** \sa GetScenarioStage For reading   \sa SetScenarioStage For writing */
Tz3DStartScenarioStage ScenarioStage; 

    /// Notifications that this interface needs to receive
         /** \sa GetNotifications For reading   \sa SetNotifications For writing */
Tz3DLinkNotifications Notifications; 

    /// TRUE when the interface works only when a scenario is enabled, FALSE otherwise
         /** \sa GetScenarioLevel For reading   \sa SetScenarioLevel For writing */
Boolean ScenarioLevel; 

 };








  /// Major.Minor.Release.Build
    Integer Tz3DFileVersion[3]; /*!< [0..3] */


/// z3D persistent interface.
/// This interface implements a load and a save method to persist in a file
/// and holds properties related to the file format and version.

   class Iz3DPersistent : public Iz3DBase
{
public:
['{CCFB1344-FD15-4C22-AEA2-92935B6841DF}']
    /// Loads itself from a file
       
LoadFromFile (const PWideChar AFileName 
);
 ;
    /// Saves itself to a file
       
SaveToFile (const PWideChar AFileName 
);
 ;
 };




// finished

