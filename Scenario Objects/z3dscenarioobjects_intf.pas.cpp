



     
   




         const  z3dcWasDownMask =  $80;
          const  z3DcIsDownMask =  $01;

     const  z3DcMouseLeftButton =  $01;
   const  z3DcMouseMiddleButton =  $02;
    const  z3DcMouseRightButton =  $04;
          const  z3DcMouseWheel =  $08;


   enum Tz3DMouseButton
{
z3DmbLeft, 
z3DmbMiddle, 
z3DmbRight, 
z3DmbWheel 
};


   enum Tz3DCameraInputKeys
{
z3dckStrafeLeft, 
z3dckStrafeRight, 
z3dckMoveForward, 
z3dckMoveBackward, 
z3dckMoveUp, 
z3dckMoveDown, 
z3dckReset, 
z3dckControlDown, 
z3dckJump, 
z3dckZoomIn, 
z3dckZoomOut, 
z3dckMaxKeys, 
z3dckUnknown 
};






/*==============================================================================*/ 
/*== Arcball interface                                                        ==*/ 
/*==============================================================================*/ 
/*== Mouse rotation handler                                                   ==*/ 
/*==============================================================================*/ 

   class Iz3DArcBall : public Iz3DBase
{
public:
['{3AC7CF6A-EC55-4AEA-99A0-BC517564F6C7}']
       
SetHeight (const Integer Value 
);
 ;
       
SetWidth (const Integer Value 
);
 ;
       
SetOffset (const TPoint Value 
);
 ;
      
Iz3DFloat4 GetCurrentQuat ();
 ;
      
Boolean GetDragging ();
 ;
      
Integer GetHeight ();
 ;
      
TPoint GetOffset ();
 ;
      
Single GetRadius ();
 ;
      
Single GetTranslationRadius ();
 ;
      
Integer GetWidth ();
 ;
       
SetRadius (const Single Value 
);
 ;
       
SetTranslationRadius (const Single Value 
);
 ;
         
Iz3DFloat3 ScreenToVector (const Single AScreenX ,
const Single AScreenY 
);
 ;
       
OnBegin (Integer AX ,
Integer AY 
);
 ;
       
OnMove (Integer AX ,
Integer AY 
);
 ;
     
OnEnd ();
 ;
     
Reset ();
 ;
             
LRESULT HandleMessages (HWND hWnd ,
Cardinal uMsg ,
WPARAM wParam ,
LPARAM lParam 
);
 ; ;
          
HandleMessages (TMsg &Msg ,
Boolean &Handled 
);
 ; ;
      
Iz3DMatrix RotationMatrix ();
 ;
      
Iz3DMatrix TranslationMatrix ();
 ;
      
Iz3DMatrix TranslationDeltaMatrix ();
 ;

       /** \sa GetDragging For reading*/
Boolean Dragging; 

         /** \sa GetTranslationRadius For reading   \sa SetTranslationRadius For writing */
Single TranslationRadius; 

         /** \sa GetRadius For reading   \sa SetRadius For writing */
Single Radius; 

         /** \sa GetWidth For reading   \sa SetWidth For writing */
Integer Width; 

         /** \sa GetHeight For reading   \sa SetHeight For writing */
Integer Height; 

         /** \sa GetOffset For reading   \sa SetOffset For writing */
TPoint Offset; 

       /** \sa GetCurrentQuat For reading*/
Iz3DFloat4 CurrentQuat; 

 };






/*==============================================================================*/ 
/*== Base camera interface                                                    ==*/ 
/*==============================================================================*/ 
/*== Ancestor for all cameras                                                 ==*/ 
/*==============================================================================*/ 

   class Iz3DCameraKeys : public Iz3DBase
{
public:
['{AF6F8852-233F-4945-B08A-4C05A1558AE0}']
      
Boolean GetAutoZoom ();
 ;
      
Char GetZoomIn ();
 ;
      
Char GetZoomOut ();
 ;
       
SetAutoZoom (const Boolean Value 
);
 ;
       
SetZoomIn (const Char Value 
);
 ;
       
SetZoomOut (const Char Value 
);
 ;
      
Boolean GetEnableDefaultKeys ();
 ;
       
SetEnableDefaultKeys (const Boolean Value 
);
 ;
      
Char GetMoveBackward ();
 ;
      
Char GetMoveDown ();
 ;
      
Char GetMoveForward ();
 ;
      
Char GetMoveLeft ();
 ;
      
Char GetMoveRight ();
 ;
      
Char GetMoveUp ();
 ;
       
SetMoveBackward (const Char Value 
);
 ;
       
SetMoveDown (const Char Value 
);
 ;
       
SetMoveForward (const Char Value 
);
 ;
       
SetMoveLeft (const Char Value 
);
 ;
       
SetMoveRight (const Char Value 
);
 ;
       
SetMoveUp (const Char Value 
);
 ;

         /** \sa GetEnableDefaultKeys For reading   \sa SetEnableDefaultKeys For writing */
Boolean EnableDefaultKeys; 

         /** \sa GetMoveForward For reading   \sa SetMoveForward For writing */
Char MoveForward; 

         /** \sa GetMoveBackward For reading   \sa SetMoveBackward For writing */
Char MoveBackward; 

         /** \sa GetMoveRight For reading   \sa SetMoveRight For writing */
Char MoveRight; 

         /** \sa GetMoveLeft For reading   \sa SetMoveLeft For writing */
Char MoveLeft; 

         /** \sa GetMoveUp For reading   \sa SetMoveUp For writing */
Char MoveUp; 

         /** \sa GetMoveDown For reading   \sa SetMoveDown For writing */
Char MoveDown; 

         /** \sa GetZoomIn For reading   \sa SetZoomIn For writing */
Char ZoomIn; 

         /** \sa GetZoomOut For reading   \sa SetZoomOut For writing */
Char ZoomOut; 

         /** \sa GetAutoZoom For reading   \sa SetAutoZoom For writing */
Boolean AutoZoom; 

 };


   enum Tz3DZoomMode
{
z3dzmConstant, 
z3dzmLinear, 
z3dzmExponential 
};


   class Iz3DBaseCamera : public Iz3DBase
{
public:
['{07495766-B251-4B6A-A6D8-5E106BB88E57}']
      
Single GetZoomFactor ();
 ;
       
SetZoomFactor (const Single Value 
);
 ;
      
Single GetMaxZoom ();
 ;
      
Single GetMinZoom ();
 ;
      
Tz3DZoomMode GetZoomMode ();
 ;
       
SetMaxZoom (const Single Value 
);
 ;
       
SetMinZoom (const Single Value 
);
 ;
       
SetZoomMode (const Tz3DZoomMode Value 
);
 ;
      
Iz3DCameraKeys GetKeys ();
 ;
      
Boolean GetDragging ();
 ;
       
SetZoom (const Single Value 
);
 ;
      
Iz3DFloat3 GetClipMax ();
 ;
      
Iz3DFloat3 GetClipMin ();
 ;
      
Boolean GetClipping ();
 ;
      
TRect GetDragRect ();
 ;
      
Single GetZoom ();
 ;
      
Boolean GetActive ();
 ;
      
Boolean GetEnableMovement ();
 ;
      
Boolean GetEnableYMovement ();
 ;
      
Boolean GetInvertPitch ();
 ;
      
Iz3DFloat3 GetLookAt ();
 ;
      
Boolean GetMouseLButtonDown ();
 ;
      
Boolean GetMouseMButtonDown ();
 ;
      
Boolean GetMouseRButtonDown ();
 ;
      
Single GetMoveScale ();
 ;
      
Iz3DFloat3 GetPosition ();
 ;
      
Integer GetSmoothFrameCount ();
 ;
      
Boolean GetSmoothMovement ();
 ;
      
Single GetTotalDragTime ();
 ;
       
SetClipping (const Boolean Value 
);
 ;
       
SetActive (const Boolean Value 
);
 ;
       
SetEnableMovement (const Boolean Value 
);
 ;
       
SetEnableYMovement (const Boolean Value 
);
 ;
       
SetInvertPitch (const Boolean Value 
);
 ;
       
SetMoveScale (const Single Value 
);
 ;
       
SetSmoothFrameCount (const Integer Value 
);
 ;
       
SetSmoothMovement (const Boolean Value 
);
 ;
       
SetTotalDragTime (const Single Value 
);
 ;
        
Tz3DCameraInputKeys MapKey (const LongWord AKey 
);
 ;
        
Boolean IsKeyDown (const Byte AKey 
);
 ;
        
Boolean WasKeyDown (const Byte AKey 
);
 ;
       
ConstrainToBoundary (Iz3DFloat3 &AVector 
);
 ;
       
UpdateVelocity (const Single AElapsedTime 
);
 ;
          
GetInput (const Boolean AGetKeyboardInput ,
const Boolean AGetMouseInput ,
const Boolean AGetGamepadInput ,
const Boolean AResetCursorAfterMove 
);
 ;
         .01     
SetScalers (const Single ARotationScaler = 0 ,
const Single AMoveScaler = 5 
);
 ;
       
SetDragRect (const TRect ARect 
);
 ;
      
Iz3DMatrix ViewMatrix ();
 ;
      
Iz3DMatrix ProjectionMatrix ();
 ;

       /** \sa GetMouseLButtonDown For reading*/
Boolean MouseLButtonDown; 

       /** \sa GetMouseMButtonDown For reading*/
Boolean MouseMButtonDown; 

       /** \sa GetMouseRButtonDown For reading*/
Boolean MouseRButtonDown; 

       /** \sa GetKeys For reading*/
Iz3DCameraKeys Keys; 

       /** \sa GetDragging For reading*/
Boolean Dragging; 

         /** \sa GetDragRect For reading   \sa SetDragRect For writing */
TRect DragRect; 

         /** \sa GetInvertPitch For reading   \sa SetInvertPitch For writing */
Boolean InvertPitch; 

         /** \sa GetEnableMovement For reading   \sa SetEnableMovement For writing */
Boolean EnablePosMovement; 

         /** \sa GetEnableYMovement For reading   \sa SetEnableYMovement For writing */
Boolean EnableYMovement; 

         /** \sa GetSmoothMovement For reading   \sa SetSmoothMovement For writing */
Boolean SmoothMovement; 

         /** \sa GetClipping For reading   \sa SetClipping For writing */
Boolean Clipping; 

       /** \sa GetClipMin For reading*/
Iz3DFloat3 ClipMin; 

       /** \sa GetClipMax For reading*/
Iz3DFloat3 ClipMax; 

         /** \sa GetTotalDragTime For reading   \sa SetTotalDragTime For writing */
Single DragTime; 

         /** \sa GetSmoothFrameCount For reading   \sa SetSmoothFrameCount For writing */
Integer SmoothFrames; 

         /** \sa GetActive For reading   \sa SetActive For writing */
Boolean Active; 

       /** \sa GetPosition For reading*/
Iz3DFloat3 Position; 

       /** \sa GetLookAt For reading*/
Iz3DFloat3 LookAt; 

         /** \sa GetMoveScale For reading   \sa SetMoveScale For writing */
Single MoveScale; 

         /** \sa GetZoom For reading   \sa SetZoom For writing */
Single Zoom; 

         /** \sa GetZoomFactor For reading   \sa SetZoomFactor For writing */
Single ZoomFactor; 

         /** \sa GetMaxZoom For reading   \sa SetMaxZoom For writing */
Single MaxZoom; 

         /** \sa GetMinZoom For reading   \sa SetMinZoom For writing */
Single MinZoom; 

         /** \sa GetZoomMode For reading   \sa SetZoomMode For writing */
Tz3DZoomMode ZoomMode; 

 };






/*==============================================================================*/ 
/*== Object view camera interface                                             ==*/ 
/*==============================================================================*/ 
/*== Camera that centers its view on a model                                  ==*/ 
/*==============================================================================*/ 

   class Iz3DObjectCameraMouseButtons : public Iz3DBase
{
public:
['{78537843-44F2-452E-A1F1-8D31D72A8745}']
       
SetRotateCamera (const Tz3DMouseButton Value 
);
 ;
       
SetRotateObject (const Tz3DMouseButton Value 
);
 ;
       
SetZoom (const Tz3DMouseButton Value 
);
 ;
      
Tz3DMouseButton GetRotateCamera ();
 ;
      
Tz3DMouseButton GetRotateObject ();
 ;
      
Tz3DMouseButton GetZoom ();
 ;

         /** \sa GetRotateObject For reading   \sa SetRotateObject For writing */
Tz3DMouseButton RotateObject; 

         /** \sa GetZoom For reading   \sa SetZoom For writing */
Tz3DMouseButton Zoom; 

         /** \sa GetRotateCamera For reading   \sa SetRotateCamera For writing */
Tz3DMouseButton RotateCamera; 

 };


   class Iz3DObjectCamera : public Iz3DBaseCamera
{
public:
['{A1BC38B2-17A9-4487-8B22-266A6EFABFB0}']
      
Boolean GetAttached ();
 ;
      
Boolean GetLimitPitch ();
 ;
      
Single GetMaxRadius ();
 ;
      
Single GetMinRadius ();
 ;
      
Single GetRadius ();
 ;
       
SetAttached (const Boolean Value 
);
 ;
       
SetLimitPitch (const Boolean Value 
);
 ;
       
SetMaxRadius (const Single Value 
);
 ;
       
SetMinRadius (const Single Value 
);
 ;
       
SetRadius (const Single Value 
);
 ;
      
Iz3DObjectCameraMouseButtons GetMouseButtons ();
 ;
                        
SetButtonMasks (const Integer ARotateObjectButtonMask = z3DcMouseLeftButton ,
const Integer AZoomButtonMask = z3DcMouseWheel ,
const Integer ARotateCameraButtonMask = z3DcMouseRightButton 
);
 ;
             .9
SetWindow (const Integer AWidth ,
const Integer AHeight ,
const Single AArcballRadius = 0 
);
 ;
      
Iz3DMatrix GetWorldMatrix ();
 ;
       
SetWorldMatrix (const Iz3DMatrix AMatrix 
);
 ;
      
Iz3DMatrix ObjectMatrix ();
 ;
       
SetObject (const Iz3DScenarioObject AObject 
);
 ;

         /** \sa GetAttached For reading   \sa SetAttached For writing */
Boolean Attached; 

         /** \sa GetLimitPitch For reading   \sa SetLimitPitch For writing */
Boolean LimitPitch; 

       /** \sa GetMouseButtons For reading*/
Iz3DObjectCameraMouseButtons MouseButtons; 

         /** \sa GetRadius For reading   \sa SetRadius For writing */
Single Radius; 

         /** \sa GetMinRadius For reading   \sa SetMinRadius For writing */
Single MinRadius; 

         /** \sa GetMaxRadius For reading   \sa SetMaxRadius For writing */
Single MaxRadius; 

 };






/*==============================================================================*/ 
/*== First person camera interface                                            ==*/ 
/*==============================================================================*/ 
/*== Camera that acts like an entity looking at the world                     ==*/ 
/*==============================================================================*/ 

   typedef interface Iz3DFirstPersonCamera;

   class Iz3DFirstPersonCameraRotateButtons : public Iz3DBase
{
public:
['{E013E6E6-529A-4AF8-BEE8-787F1DD935CC}']
       
SetIgnoreButtons (const Boolean Value 
);
 ;
       
SetLeft (const Boolean Value 
);
 ;
       
SetMiddle (const Boolean Value 
);
 ;
       
SetRight (const Boolean Value 
);
 ;
      
Boolean GetIgnoreButtons ();
 ;
      
Boolean GetLeft ();
 ;
      
Boolean GetMiddle ();
 ;
      
Boolean GetRight ();
 ;

         /** \sa GetLeft For reading   \sa SetLeft For writing */
Boolean Left; 

         /** \sa GetMiddle For reading   \sa SetMiddle For writing */
Boolean Middle; 

         /** \sa GetRight For reading   \sa SetRight For writing */
Boolean Right; 

         /** \sa GetIgnoreButtons For reading   \sa SetIgnoreButtons For writing */
Boolean IgnoreButtons; 

 };


   class Iz3DFirstPersonCamera : public Iz3DBaseCamera
{
public:
['{CC0658A4-E5E2-46A8-9123-8D77ED8A8014}']
      
Boolean GetEnableFlashLight ();
 ;
       
SetEnableFlashLight (const Boolean Value 
);
 ;
      
Boolean GetResetCursorAfterMove ();
 ;
      
Iz3DFirstPersonCameraRotateButtons GetRotateButtons ();
 ;
       
SetResetCursorAfterMove (const Boolean Value 
);
 ;
         
SetButtons (const Boolean ALeft ,
const Boolean AMiddle ,
const Boolean ARight 
);
 ;
       
SetFirstPerson (const Iz3DScenarioDynamicObject AObject 
);
 ;
      
Iz3DMatrix GetWorldMatrix ();
 ;
      
Iz3DFloat3 GetWorldRight ();
 ;
      
Iz3DFloat3 GetWorldUp ();
 ;
      
Iz3DFloat3 GetWorldAhead ();
 ;
      
Iz3DFloat3 GetEyePt ();
 ;

       /** \sa GetRotateButtons For reading*/
Iz3DFirstPersonCameraRotateButtons RotateButtons; 

         /** \sa GetResetCursorAfterMove For reading   \sa SetResetCursorAfterMove For writing */
Boolean ResetCursorAfterMove; 

         /** \sa GetEnableFlashLight For reading   \sa SetEnableFlashLight For writing */
Boolean EnableFlashLight; 

 };





/*==============================================================================*/ 
/*== Camera controller interface                                              ==*/ 
/*==============================================================================*/ 
/*== Manages and controls camera creation and allows to easy activate or      ==*/ 
/*== disable a camera                                                         ==*/ 
/*==============================================================================*/ 

   class Iz3DCameraController : public Iz3DBase
{
public:
['{0FD91D09-22D5-47E0-8942-EB12CD661578}']
      
Integer GetCameraCount ();
 ;
        
Iz3DBaseCamera GetCameras (const Integer AIndex 
);
 ;
      
Iz3DBaseCamera GetActiveCamera ();
 ;
       
SetActiveCamera (const Iz3DBaseCamera Value 
);
 ;

       
AddCamera (const Iz3DBaseCamera ACamera 
);
 ;
       
RemoveCamera (const Iz3DBaseCamera ACamera 
);
 ;
      
Iz3DObjectCamera CreateObjectCamera ();
 ;
      
Iz3DFirstPersonCamera CreateFirstPersonCamera ();
 ;

    /*[const AIndex: Integer]*/   /** \sa GetCameras For reading*/
Iz3DBaseCamera Cameras; 

       /** \sa GetCameraCount For reading*/
Integer CameraCount; 

         /** \sa GetActiveCamera For reading   \sa SetActiveCamera For writing */
Iz3DBaseCamera ActiveCamera; 

 };




    Integer Cz3DCameraMouseButton[999]=
    {z3dcMouseLeftButton, z3dcMouseMiddleButton, z3dcMouseRightButton, z3dcMouseWheel}; /*!< [999] */




/*==============================================================================*/ 
/*== Sky box interface                                                        ==*/ 
/*==============================================================================*/ 
/*== Creates a skybox with an environment map texture                         ==*/ 
/*==============================================================================*/ 


   typedef Tz3DSkyboxVert* Pz3DSkyboxVert;

   struct Tz3DSkyboxVert
{

      TD3DXVector4 Position; 

 };


   typedef Tz3DSkyboxVertArray* Pz3DSkyboxVertArray;

     () Tz3DSkyboxVert Tz3DSkyboxVertArray[-1]; /*!< [0..999..999..999..999..-1] */


   class Iz3DSkyBox : public Iz3DBase
{
public:
['{D8124BC6-B411-4AF0-9F98-0095BBD0685D}']
      
Boolean GetActive ();
 ;
      
PWideChar GetFileName ();
 ;
      
Iz3DCubeTexture GetTexture ();
 ;
       
SetActive (const Boolean Value 
);
 ;
       
SetFileName (const PWideChar Value 
);
 ;
     
CreateTexture ();
 ;
     
UpdateVertexBuffer ();
 ;

     
FrameRender ();
 ;
     
StartScenario ();
 ;
     
ResetDevice ();
 ;
     
FrameMove ();
 ;

       /** \sa GetTexture For reading*/
Iz3DCubeTexture Texture; 

         /** \sa GetFileName For reading   \sa SetFileName For writing */
PWideChar FileName; 

         /** \sa GetActive For reading   \sa SetActive For writing */
Boolean Active; 

 };





/*==============================================================================*/ 
/*== Sky interface                                                            ==*/ 
/*==============================================================================*/ 
/*== Manages a sky emulation for the scene and allows to use automatic lights ==*/ 
/*== like stars or planets                                                    ==*/ 
/*==============================================================================*/ 

   enum Tz3DSkyDomeMode
{
z3dsdmNone, 
z3dsdmSkyBox, 
z3dsdmDynamic, 
z3dsdmCustom 
};


   class Iz3DSky : public Iz3DBase
{
public:
['{B418431D-18FC-41A8-ACFC-C33A1D5A3AC9}']
      
Iz3DWorld GetWorld ();
 ;
       
SetWorld (const Iz3DWorld Value 
);
 ;
      
Tz3DSkyDomeMode GetDomeMode ();
 ;
       
SetDomeMode (const Tz3DSkyDomeMode Value 
);
 ;
      
Iz3DSkyBox GetSkyBox ();
 ;
      
Boolean GetActive ();
 ;
       
SetActive (const Boolean Value 
);
 ;

      
Iz3DLight AddStarLight ();
 ;

       /** \sa GetSkyBox For reading*/
Iz3DSkyBox SkyBox; 

         /** \sa GetDomeMode For reading   \sa SetDomeMode For writing */
Tz3DSkyDomeMode DomeMode; 

         /** \sa GetActive For reading   \sa SetActive For writing */
Boolean Active; 

         /** \sa GetWorld For reading   \sa SetWorld For writing */
Iz3DWorld World; 

 };







/*==============================================================================*/ 
/*== Earth sky interface                                                      ==*/ 
/*==============================================================================*/ 
/*== A specific descendant from the sky interface that manages a earth-like   ==*/ 
/*== sky with sunlight and/or moonlight                                       ==*/ 
/*==============================================================================*/ 

   class Iz3DEarthSky : public Iz3DSky
{
public:
['{E88C00AC-5D01-45BB-B1F7-E732D203C490}']
      
Boolean GetAutoSetAmbient ();
 ;
      
Boolean GetAutoSetFog ();
 ;
       
SetAutoSetAmbient (const Boolean Value 
);
 ;
       
SetAutoSetFog (const Boolean Value 
);
 ;
      
Iz3DFloat3 GetMoonHorizonColor ();
 ;
      
Iz3DFloat3 GetMoonZenithColor ();
 ;
      
Iz3DFloat3 GetSunHorizonColor ();
 ;
      
Iz3DFloat3 GetSunZenithColor ();
 ;
      
Boolean GetEnableMoonLight ();
 ;
      
Boolean GetEnableSunLight ();
 ;
       
SetEnableMoonLight (const Boolean Value 
);
 ;
       
SetEnableSunLight (const Boolean Value 
);
 ;
      
Integer GetTime ();
 ;
       
SetTime (const Integer Value 
);
 ;
      
Iz3DLight GetSunLight ();
 ;
      
Iz3DLight GetMoonLight ();
 ;

     
UpdateSky ();
 ;

         /** \sa GetAutoSetFog For reading   \sa SetAutoSetFog For writing */
Boolean AutoSetFog; 

         /** \sa GetAutoSetAmbient For reading   \sa SetAutoSetAmbient For writing */
Boolean AutoSetAmbient; 

       /** \sa GetSunLight For reading*/
Iz3DLight SunLight; 

       /** \sa GetMoonLight For reading*/
Iz3DLight MoonLight; 

         /** \sa GetTime For reading   \sa SetTime For writing */
Integer Time; 

         /** \sa GetEnableSunLight For reading   \sa SetEnableSunLight For writing */
Boolean EnableSunLight; 

         /** \sa GetEnableMoonLight For reading   \sa SetEnableMoonLight For writing */
Boolean EnableMoonLight; 

       /** \sa GetSunHorizonColor For reading*/
Iz3DFloat3 SunHorizonColor; 

       /** \sa GetMoonHorizonColor For reading*/
Iz3DFloat3 MoonHorizonColor; 

       /** \sa GetSunZenithColor For reading*/
Iz3DFloat3 SunZenithColor; 

       /** \sa GetMoonZenithColor For reading*/
Iz3DFloat3 MoonZenithColor; 

 };







/*==============================================================================*/ 
/*== Sky controller interface                                                 ==*/ 
/*==============================================================================*/ 
/*== Controls the sky emulation by managing different sky types               ==*/ 
/*==============================================================================*/ 

   class Iz3DSkyController : public Iz3DBase
{
public:
['{793FEC06-5502-4F86-86D0-F6261B5BC09C}']
      
Iz3DEffect GetEffect ();
 ;
      
Iz3DSky GetActiveSky ();
 ;
       
SetActiveSky (const Iz3DSky Value 
);
 ;
      
Integer GetSkyCount ();
 ;

      
Iz3DSky CreateSky ();
 ;
      
Iz3DEarthSky CreateEarthSky ();
 ;
       
AddSky (const Iz3DSky ASky 
);
 ;

         /** \sa GetActiveSky For reading   \sa SetActiveSky For writing */
Iz3DSky ActiveSky; 

       /** \sa GetEffect For reading*/
Iz3DEffect Effect; 

       /** \sa GetSkyCount For reading*/
Integer SkyCount; 

 };






/*==============================================================================*/ 
/*== Rope object                                                              ==*/ 
/*==============================================================================*/ 
/*== Creates a generic rope (cable, thread, etc.) in the scenario             ==*/ 
/*==============================================================================*/ 

  // Rope vertex struct
   typedef Tz3DRopeVertex* Pz3DRopeVertex;

   struct Tz3DRopeVertex
{

      TD3DXVector3 Position; 

      TD3DXVector2 TexCoord; 

 };

   typedef Tz3DRopeVertexArray* Pz3DRopeVertexArray;

     () Tz3DRopeVertex Tz3DRopeVertexArray[-1]; /*!< [0..999..999..999..999..-1] */


   class Iz3DRope : public Iz3DScenarioObject
{
public:
['{D88FE419-FB1C-4283-ABEF-AFAE4E280D22}']
      
Single GetLength ();
 ;
      
Iz3DMaterial GetMaterial ();
 ;
      
Iz3DFloat3 GetPointA ();
 ;
      
Iz3DFloat3 GetPointB ();
 ;
      
Single GetWidth ();
 ;
       
SetLength (const Single Value 
);
 ;
       
SetWidth (const Single Value 
);
 ;

       
Render (const Iz3DFloat3 AViewOrigin 
);
 ;

       /** \sa GetPointA For reading*/
Iz3DFloat3 PointA; 

       /** \sa GetPointB For reading*/
Iz3DFloat3 PointB; 

         /** \sa GetLength For reading   \sa SetLength For writing */
Single Length; 

         /** \sa GetWidth For reading   \sa SetWidth For writing */
Single Width; 

       /** \sa GetMaterial For reading*/
Iz3DMaterial Material; 

 };






/*==============================================================================*/ 
/*== Rope controller                                                          ==*/ 
/*==============================================================================*/ 
/*== Manages a set of ropes with similar properties and shares a buffer       ==*/ 
/*==============================================================================*/ 

   class Iz3DRopeController : public Iz3DBase
{
public:
['{F1636058-26B7-4B42-B4B8-8E76D9B09DBD}']
      
Integer GetRopeCount ();
 ;
        
Iz3DRope GetRopes (const Integer I 
);
 ;
      
Iz3DVertexBuffer GetRopeBuffer ();
 ;
      
Integer GetSegments ();
 ;
       
SetSegments (const Integer Value 
);
 ;

      
Iz3DRope CreateRope ();
 ;
       
RemoveRope (const Iz3DRope ARope 
);
 ;

       /** \sa GetRopeCount For reading*/
Integer RopeCount; 

    /*[const I: Integer]*/   /** \sa GetRopes For reading*/
Iz3DRope Ropes; 

       /** \sa GetRopeBuffer For reading*/
Iz3DVertexBuffer RopeBuffer; 

         /** \sa GetSegments For reading   \sa SetSegments For writing */
Integer Segments; 

 };






// finished

