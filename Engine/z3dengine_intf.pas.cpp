/*==============================================================================*/ 
/*== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==*/ 
/*==============================================================================*/ 
/*== Unit: z3DEngine. z3D Engine interfaces and access functions              ==*/ 
/*==============================================================================*/ 





     
     
  


   typedef interface Iz3DPostProcessEffects;

/*==============================================================================*/ 
/*== Debug helper interface                                                   ==*/ 
/*==============================================================================*/ 
/*== Helper class for the developer. It allow to view the position of every   ==*/ 
/*== light source, create a grid for position metrics and so on               ==*/ 
/*==============================================================================*/ 

   class Iz3DDebugHelper : public Iz3DBase
{
public:
['{70052626-D9B7-4B7C-BA24-5C332F9F2F73}']
      
Boolean GetEnableGrid ();
 ;
      
Boolean GetEnableLightMesh ();
 ;
      
Integer GetGridSize ();
 ;
      
Single GetGridSpace ();
 ;
       
SetEnableGrid (const Boolean Value 
);
 ;
       
SetEnableLightMesh (const Boolean Value 
);
 ;
       
SetGridSize (const Integer Value 
);
 ;
       
SetGridSpace (const Single Value 
);
 ;
     
FrameRender ();
 ;
     
RenderGridMesh ();
 ;  /// Renders a grid with an nxnxn size
     
CreateGridMesh ();
 ;
     
CreateLightMesh ();
 ;
    
         /** \sa GetEnableGrid For reading   \sa SetEnableGrid For writing */
Boolean EnableGrid; 

         /** \sa GetGridSize For reading   \sa SetGridSize For writing */
Integer GridSize; 

         /** \sa GetGridSpace For reading   \sa SetGridSpace For writing */
Single GridSpace; 

         /** \sa GetEnableLightMesh For reading   \sa SetEnableLightMesh For writing */
Boolean EnableLightMesh; 

 };


/*==============================================================================*/ 
/*== Device interface                                                         ==*/ 
/*==============================================================================*/ 
/*== Handles the additional properties and events of the device that are      ==*/ 
/*== related to the engine                                                    ==*/ 
/*==============================================================================*/ 

   typedef interface Iz3DDevice;

   enum Tz3DShaderModel
{
z3dsm1x, 
z3dsm2x, 
z3dsm3x, 
z3dsmHigher 
};


   enum Tz3DDirectXLevel
{
z3ddx70, 
z3ddx80, 
z3ddx81, 
z3ddx90, 
z3ddx91, 
z3ddxhigher 
};


   class Iz3DDeviceEngineCaps : public Iz3DBase
{
public:
['{9005EBA5-CE8A-4C9A-B4F0-D4E5F61B061C}']
      
TD3DFormat GetFPFormat ();
 ;
      
Tz3DDirectXLevel GetDirectXLevel ();
 ;
      
TD3DFormat GetCubeShadowMapFormat ();
 ;
      
TD3DFormat GetShadowMapFormat ();
 ;
      
Boolean GetShadowMapSupport ();
 ;
      
Boolean GetHDRSupport ();
 ;
      
Tz3DShaderModel GetShaderModel ();
 ;
      
Integer GetShaderModelMinor ();
 ;
      
Boolean GetShadowMapHWSupport ();
 ;

      
Boolean ShaderModel3Supported ();
 ;

    // General caps
       /** \sa GetDirectXLevel For reading*/
Tz3DDirectXLevel DirectXLevel; 
 
       /** \sa GetShaderModel For reading*/
Tz3DShaderModel ShaderModel; 

       /** \sa GetShaderModelMinor For reading*/
Integer ShaderModelMinor; 

       /** \sa GetHDRSupport For reading*/
Boolean HDRSupport; 

    // Depth map caps
       /** \sa GetFPFormat For reading*/
TD3DFormat FPFormat; 

    // Shadow map caps
       /** \sa GetShadowMapSupport For reading*/
Boolean ShadowMapSupport; 

       /** \sa GetShadowMapFormat For reading*/
TD3DFormat ShadowMapFormat; 

       /** \sa GetCubeShadowMapFormat For reading*/
TD3DFormat CubeShadowMapFormat; 

    // Support for hardware accelerated shadow map
       /** \sa GetShadowMapHWSupport For reading*/
Boolean ShadowMapHWSupport; 

 };


   class Iz3DDevice : public Iz3DBase
{
public:
['{8AFC6BD9-7CC2-4054-9250-1BB19123F239}']
      
Iz3DDeviceEngineCaps GetEngineCaps ();
 ;
      
Boolean GetFirstFrameMove ();
 ;
       
SetFirstFrameMove (const Boolean Value 
);
 ;
      
Boolean GetFirstDeviceSettings ();
 ;
       
SetFirstDeviceSettings (const Boolean Value 
);
 ;
      
Boolean GetDisplayREFWarning ();
 ;
      
Boolean GetFullScreen ();
 ;
       
SetDisplayREFWarning (const Boolean Value 
);
 ;
       
SetFullScreen (const Boolean Value 
);
 ;
     
CreateDevice ();
 ;
     
ToggleFullScreen ();
 ;
     
ToggleREF ();
 ;
      
Boolean Created ();
 ;

       /** \sa GetEngineCaps For reading*/
Iz3DDeviceEngineCaps EngineCaps; 

         /** \sa GetFirstFrameMove For reading   \sa SetFirstFrameMove For writing */
Boolean FirstFrameMove; 

         /** \sa GetFirstDeviceSettings For reading   \sa SetFirstDeviceSettings For writing */
Boolean FirstDeviceSettings; 

         /** \sa GetFullScreen For reading   \sa SetFullScreen For writing */
Boolean FullScreen; 

         /** \sa GetDisplayREFWarning For reading   \sa SetDisplayREFWarning For writing */
Boolean DisplayREFWarning; 

 };


/*==============================================================================*/ 
/*== Stats interface                                                          ==*/ 
/*==============================================================================*/ 
/*== This interface allows to display the rendering stats on the screen       ==*/ 
/*==============================================================================*/ 

   class Iz3DStats : public Iz3DBase
{
public:
['{E2840E4C-C405-4820-A003-A88F5C3DE598}']
      
Boolean GetShowRenderer ();
 ;
       
SetShowRenderer (const Boolean Value 
);
 ;
      
Boolean GetShowView ();
 ;
       
SetShowView (const Boolean Value 
);
 ;
      
Boolean GetShowDevice ();
 ;
      
Boolean GetShowFPS ();
 ;
      
Boolean GetShowDisplay ();
 ;
       
SetShowDevice (const Boolean Value 
);
 ;
       
SetShowFPS (const Boolean Value 
);
 ;
       
SetShowDisplay (const Boolean Value 
);
 ;
     
FrameRender ();
 ;

         /** \sa GetShowFPS For reading   \sa SetShowFPS For writing */
Boolean ShowFPS; 

         /** \sa GetShowDisplay For reading   \sa SetShowDisplay For writing */
Boolean ShowDisplay; 

         /** \sa GetShowDevice For reading   \sa SetShowDevice For writing */
Boolean ShowDevice; 

         /** \sa GetShowView For reading   \sa SetShowView For writing */
Boolean ShowView; 

         /** \sa GetShowRenderer For reading   \sa SetShowRenderer For writing */
Boolean ShowRenderer; 

 };


/*==============================================================================*/ 
/*== Options interface                                                        ==*/ 
/*==============================================================================*/ 
/*== Allows the developer to configure certain aspects and behaviors of the   ==*/ 
/*== engine                                                                   ==*/ 
/*==============================================================================*/ 

   class Iz3DEngineOptions : public Iz3DBase
{
public:
['{020A4EFE-4DE4-4B97-9AB9-A089D6168A81}']
      
Boolean GetPlayIntro ();
 ;
      
Boolean GetPlayMusic ();
 ;
       
SetPlayIntro (const Boolean Value 
);
 ;
       
SetPlayMusic (const Boolean Value 
);
 ;
      
Boolean GetStretchToWindow ();
 ;
       
SetStretchToWindow (const Boolean Value 
);
 ;
      
Boolean GetClipCursorOnFullScreen ();
 ;
      
Boolean GetExtendedEvents ();
 ;
      
Boolean GetHandleAltEnter ();
 ;
      
Boolean GetHandleDefaultHotkeys ();
 ;
      
Boolean GetHandleWindowMessages ();
 ;
      
Boolean GetLockAspectRatio ();
 ;
      
Boolean GetParseCommandLine ();
 ;
      
Boolean GetShadowStencil ();
 ;
      
Boolean GetShowCursorOnFullScreen ();
 ;
      
Boolean GetShowFatalMessages ();
 ;
       
SetShowFatalMessages (const Boolean Value 
);
 ;
       
SetExtendedEvents (const Boolean Value 
);
 ;
       
SetHandleAltEnter (const Boolean Value 
);
 ;
       
SetHandleDefaultHotkeys (const Boolean Value 
);
 ;
       
SetHandleWindowMessages (const Boolean Value 
);
 ;
       
SetLockAspectRatio (const Boolean Value 
);
 ;
       
SetParseCommandLine (const Boolean Value 
);
 ;
       
SetShadowStencil (const Boolean Value 
);
 ;
       
SetClipCursorOnFullScreen (const Boolean Value 
);
 ;
       
SetShowCursorOnFullScreen (const Boolean Value 
);
 ;

         /** \sa GetExtendedEvents For reading   \sa SetExtendedEvents For writing */
Boolean ExtendedEvents; 

         /** \sa GetShadowStencil For reading   \sa SetShadowStencil For writing */
Boolean ShadowStencil; 

         /** \sa GetParseCommandLine For reading   \sa SetParseCommandLine For writing */
Boolean ParseCommandLine; 

         /** \sa GetHandleDefaultHotkeys For reading   \sa SetHandleDefaultHotkeys For writing */
Boolean HandleDefaultHotkeys; 

         /** \sa GetShowFatalMessages For reading   \sa SetShowFatalMessages For writing */
Boolean ShowFatalMessages; 

         /** \sa GetHandleAltEnter For reading   \sa SetHandleAltEnter For writing */
Boolean HandleAltEnter; 

         /** \sa GetHandleWindowMessages For reading   \sa SetHandleWindowMessages For writing */
Boolean HandleWindowMessages; 

         /** \sa GetShowCursorOnFullScreen For reading   \sa SetShowCursorOnFullScreen For writing */
Boolean ShowCursorOnFullScreen; 

         /** \sa GetPlayIntro For reading   \sa SetPlayIntro For writing */
Boolean PlayIntro; 

         /** \sa GetPlayMusic For reading   \sa SetPlayMusic For writing */
Boolean PlayMusic; 

         /** \sa GetClipCursorOnFullScreen For reading   \sa SetClipCursorOnFullScreen For writing */
Boolean ClipCursorOnFullScreen; 

         /** \sa GetLockAspectRatio For reading   \sa SetLockAspectRatio For writing */
Boolean LockAspectRatio; 

         /** \sa GetStretchToWindow For reading   \sa SetStretchToWindow For writing */
Boolean StretchToWindow; 

 };


/*==============================================================================*/ 
/*== Effects interface                                                        ==*/ 
/*==============================================================================*/ 
/*== These are handlers for the post process effects included in the engine:  ==*/ 
/*==                                                                          ==*/ 
/*==   - Bloom: Enhances strong-lighted areas                                 ==*/ 
/*==   - Tone mapping: Simulates the eye adjustment                           ==*/ 
/*==   - Color correction: Applies color effects to the scene                 ==*/ 
/*==   - Motion blur: Blurs the screen when the eye moves at fast speeds      ==*/ 
/*==   - Depth of field: Centers the view into a certain distance             ==*/ 
/*==                                                                          ==*/ 
/*==============================================================================*/ 

   class Iz3DBloomEffect : public Iz3DBase
{
public:
['{D005E8D7-B337-4A8B-98B7-661B2E006977}']
      
Single GetFoggyFactor ();
 ;
       
SetFoggyFactor (const Single Value 
);
 ;
      
Boolean GetEnabled ();
 ;
      
Single GetIntensity ();
 ;
      
Single GetThreshold ();
 ;
       
SetEnabled (const Boolean Value 
);
 ;
       
SetIntensity (const Single Value 
);
 ;
       
SetThreshold (const Single Value 
);
 ;
     
FrameRender ();
 ;
     
RenderBloom ();
 ;
     
RenderBrightPass ();
 ;
     
CreateScenarioObjects ();
 ;
     
EnableResources ();
 ;

         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

         /** \sa GetIntensity For reading   \sa SetIntensity For writing */
Single Intensity; 

         /** \sa GetThreshold For reading   \sa SetThreshold For writing */
Single Threshold; 

         /** \sa GetFoggyFactor For reading   \sa SetFoggyFactor For writing */
Single FoggyFactor; 

 };


   class Iz3DToneMappingEffect : public Iz3DBase
{
public:
['{A3CB1DFD-87FC-4A69-9A2A-A0B37303ECD2}']
      
Single GetAdjustmentFactor ();
 ;
      
Single GetAdjustmentSpeed ();
 ;
      
Single GetMiddleTone ();
 ;
      
Single GetToneRangeMax ();
 ;
      
Single GetToneRangeMin ();
 ;
       
SetAdjustmentFactor (const Single Value 
);
 ;
       
SetAdjustmentSpeed (const Single Value 
);
 ;
       
SetMiddleTone (const Single Value 
);
 ;
       
SetToneRangeMax (const Single Value 
);
 ;
       
SetToneRangeMin (const Single Value 
);
 ;
       
SetEnabled (const Boolean Value 
);
 ;
      
Boolean GetEnabled ();
 ;
     
FrameMove ();
 ;
     
FrameRender ();
 ;
     
CreateScenarioObjects ();
 ;
     
EnableResources ();
 ;
    
         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

         /** \sa GetAdjustmentSpeed For reading   \sa SetAdjustmentSpeed For writing */
Single AdjustmentSpeed; 

         /** \sa GetAdjustmentFactor For reading   \sa SetAdjustmentFactor For writing */
Single AdjustmentFactor; 

         /** \sa GetMiddleTone For reading   \sa SetMiddleTone For writing */
Single MiddleTone; 

         /** \sa GetToneRangeMin For reading   \sa SetToneRangeMin For writing */
Single ToneRangeMin; 

         /** \sa GetToneRangeMax For reading   \sa SetToneRangeMax For writing */
Single ToneRangeMax; 

 };


   enum Tz3DColorCorrectionMode
{
z3dccmMonochromatic, 
z3dccmNegative, 
z3dccmSepia, 
z3dccmTonalize 
};


   class Iz3DColorCorrectionEffect : public Iz3DBase
{
public:
['{34A1FFAF-CBC8-4705-AEFA-44460220B773}']
       
SetEnabled (const Boolean Value 
);
 ;
      
Boolean GetEnabled ();
 ;
      
Tz3DColorCorrectionMode GetMode ();
 ;
      
Iz3DFloat3 GetToneFactor ();
 ;
       
SetMode (const Tz3DColorCorrectionMode Value 
);
 ;
     
FrameRender ();
 ;
     
CreateScenarioObjects ();
 ;
     
EnableResources ();
 ;
    
         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

       /** \sa GetToneFactor For reading*/
Iz3DFloat3 ToneFactor; 

         /** \sa GetMode For reading   \sa SetMode For writing */
Tz3DColorCorrectionMode Mode; 

 };


   class Iz3DMotionBlurEffect : public Iz3DBase
{
public:
['{CA37BC3D-DA3A-4171-A5DC-E7650FB83D3D}']
       
SetAmount (const Single Value 
);
 ;
       
SetEnabled (const Boolean Value 
);
 ;
      
Single GetAmount ();
 ;
      
Boolean GetEnabled ();
 ;
     
FrameMove ();
 ;
     
FrameRender ();
 ;
     
CreateScenarioObjects ();
 ;
     
EnableResources ();
 ;
    
         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

         /** \sa GetAmount For reading   \sa SetAmount For writing */
Single Amount; 

 };


   class Iz3DDepthOfFieldEffect : public Iz3DBase
{
public:
['{523667B0-970B-4D74-B08F-301E32C0FC71}']
      
Single GetAdjustmentSpeed ();
 ;
       
SetAdjustmentSpeed (const Single Value 
);
 ;
      
Single GetFocusSpread ();
 ;
       
SetFocusSpread (const Single Value 
);
 ;
      
Single GetAmount ();
 ;
       
SetAmount (const Single Value 
);
 ;
      
Boolean GetAutoFocusDepth ();
 ;
       
SetAutoFocusDepth (const Boolean Value 
);
 ;
       
SetEnabled (const Boolean Value 
);
 ;
      
Boolean GetEnabled ();
 ;
      
Single GetFocusDepth ();
 ;
      
Integer GetSamples ();
 ;
       
SetFocusDepth (const Single Value 
);
 ;
       
SetSamples (const Integer Value 
);
 ;
     
FrameMove ();
 ;
     
FrameRender ();
 ;
     
CreateScenarioObjects ();
 ;
     
EnableResources ();
 ;

         /** \sa GetAmount For reading   \sa SetAmount For writing */
Single Amount; 

         /** \sa GetAdjustmentSpeed For reading   \sa SetAdjustmentSpeed For writing */
Single AdjustmentSpeed; 

         /** \sa GetFocusSpread For reading   \sa SetFocusSpread For writing */
Single FocusSpread; 

         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

         /** \sa GetFocusDepth For reading   \sa SetFocusDepth For writing */
Single FocusDepth; 

         /** \sa GetAutoFocusDepth For reading   \sa SetAutoFocusDepth For writing */
Boolean AutoFocusDepth; 

         /** \sa GetSamples For reading   \sa SetSamples For writing */
Integer Samples; 

 };


/*==============================================================================*/ 
/*== Effects handler interface                                                ==*/ 
/*==============================================================================*/ 
/*== Holds every post process effect and manages its shared properties and    ==*/ 
/*== Objects                                                                  ==*/ 
/*==============================================================================*/ 

   class Iz3DPostProcessEffects : public Iz3DBase
{
public:
['{942922FA-75E2-4FAD-9AF4-BE8973644FFE}']
      
Iz3DRenderTexture GetSceneScaledTexture ();
 ;
      
Iz3DBloomEffect GetBloom ();
 ;
      
Iz3DColorCorrectionEffect GetColorCorrection ();
 ;
      
Iz3DDepthOfFieldEffect GetDepthOfField ();
 ;
      
Iz3DMotionBlurEffect GetMotionBlur ();
 ;
      
Iz3DToneMappingEffect GetToneMapping ();
 ;
     
FrameMove ();
 ;
     
FrameRender ();
 ;
     
CheckSharedResources ();
 ;

       /** \sa GetSceneScaledTexture For reading*/
Iz3DRenderTexture SceneScaledTexture; 

       /** \sa GetBloom For reading*/
Iz3DBloomEffect Bloom; 

       /** \sa GetToneMapping For reading*/
Iz3DToneMappingEffect ToneMapping; 

       /** \sa GetColorCorrection For reading*/
Iz3DColorCorrectionEffect ColorCorrection; 

       /** \sa GetMotionBlur For reading*/
Iz3DMotionBlurEffect MotionBlur; 

       /** \sa GetDepthOfField For reading*/
Iz3DDepthOfFieldEffect DepthOfField; 

 };


/*==============================================================================*/ 
/*== Renderer interface                                                       ==*/ 
/*==============================================================================*/ 
/*== Manages the rendering of the scene and controls the different types of   ==*/ 
/*== renderization                                                            ==*/ 
/*==============================================================================*/ 

   enum Tz3DTargetMode
{
z3dtmBackBuffer, 
z3dtmTexture, 
z3dtmRenderTarget 
};


   enum Tz3DRenderMode
{
z3drm2D, 
z3drm3D 
};


   enum Tz3DRenderStage
{
z3drsPrecomputation, 
z3drsBackBuffer, 
z3drsDepth, 
z3drsScene, 
z3drsPostProcess, 
z3drsGUI 
};


  // Post process quad vertex structure
   typedef Tz3DPostProcessVertex* Pz3DPostProcessVertex;

   struct Tz3DPostProcessVertex
{

      TD3DXVector4 Position; 

      TD3DXVector2 TexCoord; 

 };


   typedef Tz3DPostProcessVertexArray* Pz3DPostProcessVertexArray;

     () Tz3DPostProcessVertex Tz3DPostProcessVertexArray[-1]; /*!< [0..999..999..999..999..-1] */


   class Iz3DRenderer : public Iz3DBase
{
public:
['{A5186FB3-84BC-4085-BA83-6F134FBAA5E6}']
      
Integer GetRTHeight ();
 ;
      
Integer GetRTWidth ();
 ;
       
SetRTHeight (const Integer Value 
);
 ;
       
SetRTWidth (const Integer Value 
);
 ;
      
Boolean GetAutoClearDepth ();
 ;
      
Boolean GetAutoClearTarget ();
 ;
       
SetAutoClearDepth (const Boolean Value 
);
 ;
       
SetAutoClearTarget (const Boolean Value 
);
 ;
      
Iz3DFloat4 GetDefaultClearColor ();
 ;
      
Single GetDefaultClearDepth ();
 ;
       
SetDefaultClearDepth (const Single Value 
);
 ;
      
Boolean GetEnableMSAA ();
 ;
       
SetEnableMSAA (const Boolean Value 
);
 ;
      
Integer GetMSAASamples ();
 ;
       
SetMSAASamples (const Integer Value 
);
 ;
      
Tz3DRenderStage GetRenderStage ();
 ;
      
TD3DFormat GetFormat ();
 ;
      
Integer GetCurrentChain ();
 ;
       
SetCurrentChain (const Integer Value 
);
 ;
      
Iz3DRenderTexture GetPreviousRenderTexture ();
 ;
      
Boolean GetFirstSceneRender ();
 ;
      
Iz3DRenderTexture GetDeferredBuffer ();
 ;
      
Iz3DSurface GetBackBuffer ();
 ;
      
Boolean GetRendering ();
 ;
      
Tz3DRenderMode GetRenderMode ();
 ;
       
SetRenderMode (const Tz3DRenderMode Value 
);
 ;
      
Boolean GetHDRMode ();
 ;
      
Tz3DTargetMode GetTargetMode ();
 ;
      
Iz3DSurface GetRenderSurface ();
 ;
      
Iz3DRenderTexture GetRenderTexture ();
 ;
       
SetHDRMode (const Boolean Value 
);
 ;
       
SetTargetMode (const Tz3DTargetMode Value 
);
 ;

         
ClearDepthBuffer (const Single AValue = 1 
);
 ;
         
ClearRenderTarget (const Iz3DFloat4 AValue = nil 
);
 ;
              
Clear (const Iz3DFloat4 ARenderTarget = nil ,
const Single ADepthBuffer = 1 
);
 ;
       
AddBlendTexture (const Iz3DTexture ATexture 
);
 ;

    // Frame render control functions
     
Render ();
 ;
     
BeginRender ();
 ;
     
BeginSceneRender ();
 ;
     
RenderPrecomputation ();
 ;
     
RenderDeferredBuffers ();
 ;
     
RenderScenario ();
 ;
     
RenderPostProcess ();
 ;
     
RenderGUI ();
 ;
     
EndSceneRender ();
 ;
     
EndRender ();
 ;
     
SwapRenderChain ();
 ;

       
FadeIn (const Single AFactor 
);
 ;
       
FadeOut (const Single AFactor 
);
 ;

     
BeginSettingsChange ();
 ;
     
EndSettingsChange ();
 ;

     
CreateRenderTarget ();
 ;
     
CreateDeferredBuffer ();
 ;

    // Post process and screen space functions
                   
PostProcess (const Iz3DRenderTexture ATarget ,
const Iz3Dtexture *ATextures ,
const Iz3DEffect AEffect 
);
 ;
                
PostProcess_Blend (const Iz3Dtexture *ATextures ,
const Iz3DEffect AEffect 
);
 ;
                       
Blend (const Iz3DTexture *ATextures ,
const Iz3DEffect AEffect = nil ,
const Single AAlpha = 1 
);
 ;
                                
AutoBlend (const Iz3Dtexture ATexture ,
const Integer ALeft = 0 ,
const Integer ATop = 0 ,
const Iz3DEffect AEffect = nil ,
const Single AAlpha = 1 
);
 ;
         
DrawFullScreenQuad (const Iz3DFloat4 ACoords = nil 
);
 ;
       
DownScale (const Iz3DRenderTexture AOutTexture 
);
 ;

    // General properties
       /** \sa GetFormat For reading*/
TD3DFormat Format; 

       /** \sa GetBackBuffer For reading*/
Iz3DSurface BackBuffer; 

       /** \sa GetRenderTexture For reading*/
Iz3DRenderTexture RenderTexture; 

       /** \sa GetPreviousRenderTexture For reading*/
Iz3DRenderTexture PreviousRenderTexture; 

       /** \sa GetRenderSurface For reading*/
Iz3DSurface RenderSurface; 

       /** \sa GetDeferredBuffer For reading*/
Iz3DRenderTexture DeferredBuffer; 

       /** \sa GetDefaultClearColor For reading*/
Iz3DFloat4 DefaultClearColor; 

         /** \sa GetDefaultClearDepth For reading   \sa SetDefaultClearDepth For writing */
Single DefaultClearDepth; 

         /** \sa GetAutoClearTarget For reading   \sa SetAutoClearTarget For writing */
Boolean AutoClearTarget; 

         /** \sa GetAutoClearDepth For reading   \sa SetAutoClearDepth For writing */
Boolean AutoClearDepth; 


         /** \sa GetTargetMode For reading   \sa SetTargetMode For writing */
Tz3DTargetMode TargetMode; 

         /** \sa GetRenderMode For reading   \sa SetRenderMode For writing */
Tz3DRenderMode RenderMode; 

         /** \sa GetRTWidth For reading   \sa SetRTWidth For writing */
Integer RTWidth; 

         /** \sa GetRTHeight For reading   \sa SetRTHeight For writing */
Integer RTHeight; 

         /** \sa GetHDRMode For reading   \sa SetHDRMode For writing */
Boolean HDRMode; 

         /** \sa GetEnableMSAA For reading   \sa SetEnableMSAA For writing */
Boolean EnableMSAA; 

         /** \sa GetMSAASamples For reading   \sa SetMSAASamples For writing */
Integer MSAASamples; 


       /** \sa GetRendering For reading*/
Boolean Rendering; 

       /** \sa GetRenderStage For reading*/
Tz3DRenderStage RenderStage; 

       /** \sa GetFirstSceneRender For reading*/
Boolean FirstSceneRender; 

         /** \sa GetCurrentChain For reading   \sa SetCurrentChain For writing */
Integer CurrentChain; 

 };


/*==============================================================================*/ 
/*== Engine interface                                                         ==*/ 
/*==============================================================================*/ 
/*== The main interface of the engine. It creates and/or handles all the      ==*/ 
/*== components of the z3D engine                                             ==*/ 
/*==============================================================================*/ 

                  typedef void (*Tz3DCallbackConfirmDeviceEvent)(const TD3DCaps9 ACaps ,
const TD3DFormat AAdapterFormat ,
const TD3DFormat ABackBufferFormat ,
const Boolean AWindowed ,
Boolean &AAccept 
);
 ;

            typedef void (*Tz3DCallbackModifyDeviceEvent)(Tz3DDeviceSettings &ADeviceSettings ,
const TD3DCaps9 ACaps 
);
 ;

                       typedef void (*Tz3DCallbackMessageEvent)(const HWnd AWnd ,
const LongWord AMsg ,
const wParam AwParam ,
const lParam AlParam ,
Boolean &ADefault ,
lResult &AResult 
);
 ;

         typedef void (*Tz3DCallbackKeyboardEvent)(const LongWord AChar ,
const Boolean AKeyDown ,
const Boolean AAltDown 
);
 ;

   enum Tz3DNotifyControllerEvent
{
z3dnceCreate, 
z3dnceInit, 
z3dnceRun, 
z3dnceStop, 
z3dnceDestroy 
};


   class Iz3DEngine : public Iz3DBase
{
public:
['{6DB4E93B-907E-492F-9DB3-F1AC5194C49C}']
      
HWND GetWindow ();
 ;
      
Iz3DRenderer GetRenderer ();
 ;
      
Iz3DAudioController GetAudioController ();
 ;
      
Single GetViewVelocity ();
 ;
      
Iz3DDesktop GetDesktop ();
 ;
      
Iz3DFloat3 GetViewLookAt ();
 ;
      
Iz3DFloat3 GetViewPosition ();
 ;
      
Boolean GetActive ();
 ;
      
Iz3DDebugHelper GetDebugHelper ();
 ;
      
Iz3DDevice GetDevice ();
 ;
      
Iz3DEffect GetEffect ();
 ;
      
Tz3DCallbackConfirmDeviceEvent GetOnConfirmDevice ();
 ;
      
Tz3DBaseCallbackEvent GetOnCreateDevice ();
 ;
      
Tz3DBaseCallbackEvent GetOnDestroyDevice ();
 ;
      
Tz3DBaseCallbackEvent GetOnFinalization ();
 ;
      
Tz3DBaseCallbackEvent GetOnFrameMove ();
 ;
      
Tz3DBaseCallbackEvent GetOnFrameRender ();
 ;
      
Tz3DBaseCallbackEvent GetOnInitialization ();
 ;
      
Tz3DCallbackKeyboardEvent GetOnKeyboardProc ();
 ;
      
Tz3DBaseCallbackEvent GetOnLostDevice ();
 ;
      
Tz3DCallbackModifyDeviceEvent GetOnModifyDevice ();
 ;
      
Tz3DCallbackMessageEvent GetOnMsgProc ();
 ;
      
Tz3DBaseCallbackEvent GetOnResetDevice ();
 ;
      
Iz3DEngineOptions GetOptions ();
 ;
      
Iz3DPostProcessEffects GetPostProcessEffects ();
 ;
      
Iz3DScenario GetScenario ();
 ;
      
Iz3DStats GetStats ();
 ;
      
Iz3DMatrix GetProjectionMatrix ();
 ;
      
Iz3DMatrix GetViewMatrix ();
 ;
      
Iz3DMatrix GetPrevViewMatrix ();
 ;
       
SetActive (const Boolean Value 
);
 ;
       
SetOnConfirmDevice (const Tz3DCallbackConfirmDeviceEvent Value 
);
 ;
       
SetOnCreateDevice (const Tz3DBaseCallbackEvent Value 
);
 ;
       
SetOnDestroyDevice (const Tz3DBaseCallbackEvent Value 
);
 ;
       
SetOnFinalization (const Tz3DBaseCallbackEvent Value 
);
 ;
       
SetOnFrameMove (const Tz3DBaseCallbackEvent Value 
);
 ;
       
SetOnFrameRender (const Tz3DBaseCallbackEvent Value 
);
 ;
       
SetOnInitialization (const Tz3DBaseCallbackEvent Value 
);
 ;
       
SetOnKeyboardProc (const Tz3DCallbackKeyboardEvent Value 
);
 ;
       
SetWindow (const HWND Value 
);
 ;
       
SetOnLostDevice (const Tz3DBaseCallbackEvent Value 
);
 ;
       
SetOnModifyDevice (const Tz3DCallbackModifyDeviceEvent Value 
);
 ;
       
SetOnMsgProc (const Tz3DCallbackMessageEvent Value 
);
 ;
       
SetOnResetDevice (const Tz3DBaseCallbackEvent Value 
);
 ;
               
CreateDevice (const IDirect3DDevice9 ADevice ,
const TD3DSurfaceDesc ABackBufferSurfaceDesc 
);
 ;
                  
ConfirmDevice (const TD3DCaps9 ACaps ,
TD3DFormat AAdapterFormat ,
TD3DFormat ABackBufferFormat ,
Boolean AWindowed ,
Boolean &AAccept 
);
 ;
     
DestroyDevice ();
 ;
     
LostDevice ();
 ;
          
ModifyDevice (Tz3DDeviceSettings &ADeviceSettings ,
const TD3DCaps9 ACaps 
);
 ;
     
ResetDevice ();
 ;
     
FrameMove ();
 ;
     
FrameRender ();
 ;
                     
MsgProc (HWnd AWnd ,
LongWord AMsg ,
wParam AwParam ,
lParam AlParam ,
Boolean &ADefault ,
lResult &AResult 
);
 ;
         
KeyboardProc (LongWord AChar ,
Boolean AKeyDown ,
Boolean AAltDown 
);
 ;
                 .5 
Iz3DRenderTexture ComputeNormalMap (const Iz3DTexture ATexture ,
const Single ABump = 0 
);
 ;

     
NotifyLinks_z3DCreateDevice ();
 ;
     
NotifyLinks_z3DDestroyDevice ();
 ;
     
NotifyLinks_z3DLostDevice ();
 ;
     
NotifyLinks_z3DResetDevice ();
 ;

       
NotifyLinks_z3DStartScenario (const Tz3DStartScenarioStage AStage 
);
 ;
     
NotifyLinks_z3DEndScenario ();
 ;

     
NotifyLinks_z3DFrameMove ();
 ;
     
NotifyLinks_z3DFrameRender ();
 ;
     
NotifyLinks_z3DLightingRender ();
 ;
     
NotifyLinks_z3DDirectLightRender ();
 ;
     
NotifyLinks_z3DGUIRender ();
 ;
     
Initialize ();
 ;
       
StartScenario (const Tz3DStartScenarioStage AStage 
);
 ;
     
PlayIntro ();
 ;
                 
PlayMovie (const string AFileName ,
const Boolean ACanSkip = True ,
const Boolean AStretch = True 
);
 ;
            
PlayMusic (const string AFileName ,
const Boolean ALoop = True 
);
 ;
     
Run ();
 ;
     
Stop ();
 ;
       
AddLink (const Iz3DLinked AObject 
);
 ;
       
RemoveLink (const Iz3DLinked AObject 
);
 ;

       /** \sa GetAudioController For reading*/
Iz3DAudioController AudioController; 

       /** \sa GetEffect For reading*/
Iz3DEffect CoreEffect; 

       /** \sa GetDevice For reading*/
Iz3DDevice Device; 

       /** \sa GetScenario For reading*/
Iz3DScenario Scenario; 

       /** \sa GetDesktop For reading*/
Iz3DDesktop Desktop; 

       /** \sa GetStats For reading*/
Iz3DStats Stats; 

         /** \sa GetActive For reading   \sa SetActive For writing */
Boolean Active; 

       /** \sa GetOptions For reading*/
Iz3DEngineOptions Options; 

       /** \sa GetDebugHelper For reading*/
Iz3DDebugHelper DebugHelper; 

       /** \sa GetPostProcessEffects For reading*/
Iz3DPostProcessEffects PostProcess; 

       /** \sa GetRenderer For reading*/
Iz3DRenderer Renderer; 

       /** \sa GetViewMatrix For reading*/
Iz3DMatrix ViewMatrix; 

       /** \sa GetPrevViewMatrix For reading*/
Iz3DMatrix PrevViewMatrix; 

       /** \sa GetViewPosition For reading*/
Iz3DFloat3 ViewPosition; 

       /** \sa GetViewVelocity For reading*/
Single ViewVelocity; 

       /** \sa GetViewLookAt For reading*/
Iz3DFloat3 ViewLookAt; 

         /** \sa GetWindow For reading   \sa SetWindow For writing */
HWND Window; 

       /** \sa GetProjectionMatrix For reading*/
Iz3DMatrix ProjectionMatrix; 

         /** \sa GetOnInitialization For reading   \sa SetOnInitialization For writing */
Tz3DBaseCallbackEvent OnInitialization; 

         /** \sa GetOnFinalization For reading   \sa SetOnFinalization For writing */
Tz3DBaseCallbackEvent OnFinalization; 

         /** \sa GetOnMsgProc For reading   \sa SetOnMsgProc For writing */
Tz3DCallbackMessageEvent OnMessage; 

         /** \sa GetOnKeyboardProc For reading   \sa SetOnKeyboardProc For writing */
Tz3DCallbackKeyboardEvent OnKeyboard; 

         /** \sa GetOnFrameRender For reading   \sa SetOnFrameRender For writing */
Tz3DBaseCallbackEvent OnFrameRender; 

         /** \sa GetOnFrameMove For reading   \sa SetOnFrameMove For writing */
Tz3DBaseCallbackEvent OnFrameMove; 

         /** \sa GetOnCreateDevice For reading   \sa SetOnCreateDevice For writing */
Tz3DBaseCallbackEvent OnCreateDevice; 

         /** \sa GetOnConfirmDevice For reading   \sa SetOnConfirmDevice For writing */
Tz3DCallbackConfirmDeviceEvent OnConfirmDevice; 

         /** \sa GetOnDestroyDevice For reading   \sa SetOnDestroyDevice For writing */
Tz3DBaseCallbackEvent OnDestroyDevice; 

         /** \sa GetOnLostDevice For reading   \sa SetOnLostDevice For writing */
Tz3DBaseCallbackEvent OnLostDevice; 

         /** \sa GetOnModifyDevice For reading   \sa SetOnModifyDevice For writing */
Tz3DCallbackModifyDeviceEvent OnModifyDevice; 

         /** \sa GetOnResetDevice For reading   \sa SetOnResetDevice For writing */
Tz3DBaseCallbackEvent OnResetDevice; 

 };




  FPostProcess_VD: array[0..2] of TD3DVertexElement9 =
  (
    (Stream: 0; Offset: 0;  const D3DDECLTYPE_FLOAT4 _Type; 
  const D3DDECLMETHOD_DEFAULT Method; 
  const D3DDECLUSAGE_POSITIONT Usage; 
 UsageIndex: 0),
    (Stream: 0; Offset: 16; const D3DDECLTYPE_FLOAT2 _Type; 
  const D3DDECLMETHOD_DEFAULT Method; 
  const D3DDECLUSAGE_TEXCOORD Usage; 
  UsageIndex: 0),
    (Stream:$FF; Offset:0;  const D3DDECLTYPE_UNUSED _Type; 
 Method: TD3DDeclMethod(0);     Usage: TD3DDeclUsage(0);       UsageIndex: 0)
  );

    TD3DMultiSampleType FMSAASamplesD3D[16]=
    {D3DMULTISAMPLE_NONE,
     D3DMULTISAMPLE_NONE,
     D3DMULTISAMPLE_2_SAMPLES,
     D3DMULTISAMPLE_3_SAMPLES,
     D3DMULTISAMPLE_4_SAMPLES,
     D3DMULTISAMPLE_5_SAMPLES,
     D3DMULTISAMPLE_6_SAMPLES,
     D3DMULTISAMPLE_7_SAMPLES,
     D3DMULTISAMPLE_8_SAMPLES,
     D3DMULTISAMPLE_9_SAMPLES,
     D3DMULTISAMPLE_10_SAMPLES,
     D3DMULTISAMPLE_11_SAMPLES,
     D3DMULTISAMPLE_12_SAMPLES,
     D3DMULTISAMPLE_13_SAMPLES,
     D3DMULTISAMPLE_14_SAMPLES,
     D3DMULTISAMPLE_15_SAMPLES,
     D3DMULTISAMPLE_16_SAMPLES}; /*!< [0..16] */




// finished


