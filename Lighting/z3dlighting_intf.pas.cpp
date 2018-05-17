/*==============================================================================*/ 
/*== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==*/ 
/*==============================================================================*/ 
/*== Unit: z3DLighting. z3D lighting and shadowing system core                ==*/ 
/*==============================================================================*/ 





    
     


   enum Tz3DLightingRenderStage
{
z3dlrsStaticAmbient, 
z3dlrsDynamicAmbient 
};


   enum Tz3DDirectLightRenderStage
{
z3ddlrsStaticShadows, 
z3ddlrsDynamicShadows, 
z3ddlrsStaticLighting, 
z3ddlrsDynamicLighting 
};


     typedef void (*Tz3DLightingRenderEvent)(const Tz3DLightingRenderStage AStage 
);
 ;

/*==============================================================================*/ 
/*== Light effects interface                                                  ==*/ 
/*==============================================================================*/ 
/*== Provides a way to configure the effects of a light source on the         ==*/ 
/*== surrounding world like shadows, specular reflections and glow            ==*/ 
/*==============================================================================*/ 

   typedef interface Iz3DLight;

           typedef void (*Tz3DDirectLightRenderEvent)(const Tz3DDirectLightRenderStage AStage ,
const Iz3DLight ALight 
);


   class Iz3DLightEffects : public Iz3DBase
{
public:
['{362D39C9-A515-4CD2-BDAB-7E081D5B30B2}']
      
Boolean GetMultiSampleGlow ();
 ;
       
SetMultiSampleGlow (const Boolean Value 
);
 ;
      
Single GetGlowFactor ();
 ;
       
SetGlowFactor (const Single Value 
);
 ;
      
Boolean GetGlow ();
 ;
       
SetGlow (const Boolean Value 
);
 ;
       
SetDynamicShadows (const Boolean Value 
);
 ;
       
SetNormalMapping (const Boolean Value 
);
 ;
       
SetSpecular (const Boolean Value 
);
 ;
       
SetStaticShadows (const Boolean Value 
);
 ;
       
SetStaticPenumbra (const Boolean Value 
);
 ;
      
Boolean GetDynamicShadows ();
 ;
      
Boolean GetNormalMapping ();
 ;
      
Boolean GetSpecular ();
 ;
      
Boolean GetStaticPenumbra ();
 ;
      
Boolean GetStaticShadows ();
 ;

         /** \sa GetSpecular For reading   \sa SetSpecular For writing */
Boolean Specular; 

         /** \sa GetStaticShadows For reading   \sa SetStaticShadows For writing */
Boolean StaticShadows; 

         /** \sa GetDynamicShadows For reading   \sa SetDynamicShadows For writing */
Boolean DynamicShadows; 

         /** \sa GetNormalMapping For reading   \sa SetNormalMapping For writing */
Boolean NormalMapping; 

         /** \sa GetStaticPenumbra For reading   \sa SetStaticPenumbra For writing */
Boolean StaticPenumbra; 

         /** \sa GetGlow For reading   \sa SetGlow For writing */
Boolean Glow; 

         /** \sa GetGlowFactor For reading   \sa SetGlowFactor For writing */
Single GlowFactor; 

         /** \sa GetMultiSampleGlow For reading   \sa SetMultiSampleGlow For writing */
Boolean MultiSampleGlow; 

 };


/*==============================================================================*/ 
/*== Light interface                                                          ==*/ 
/*==============================================================================*/ 
/*== Represents a light source into the world and controls its properties     ==*/ 
/*== like intensity, spot angle and position                                  ==*/ 
/*==============================================================================*/ 

   enum Tz3DLightStyle
{
z3dlsDiffuse, 
z3dlsPoint, 
z3dlsSpot, 
z3dlsDirectional 
};


   class Iz3DLight : public Iz3DBase
{
public:
['{D6054A45-55A6-4A7E-8FB7-861D9D0445BD}']
      
Tz3DDirectLightRenderStage GetStage ();
 ;
      
PWideChar GetName ();
 ;
       
SetName (const PWideChar Value 
);
 ;
      
Boolean GetDynamicMode ();
 ;
      
Integer GetIndex ();
 ;
      
Single GetAngle ();
 ;
      
Iz3DFloat3 GetColor ();
 ;
      
Iz3DFloat3 GetDirection ();
 ;
      
Iz3DLightEffects GetEffects ();
 ;
      
Boolean GetEnabled ();
 ;
      
Single GetIntensity ();
 ;
      
Tz3DDirectLightRenderEvent GetOnRender ();
 ;
      
Iz3DFloat3 GetPosition ();
 ;
      
Single GetRange ();
 ;
      
Single GetSharpness ();
 ;
      
Single GetSize ();
 ;
      
Boolean GetStatic ();
 ;
      
Tz3DLightStyle GetStyle ();
 ;
       
SetDynamicMode (const Boolean Value 
);
 ;
       
SetOnRender (const Tz3DDirectLightRenderEvent Value 
);
 ;
       
SetSize (const Single Value 
);
 ;
       
SetStyle (const Tz3DLightStyle Value 
);
 ;
       
SetRange (const Single Value 
);
 ;
       
SetAngle (const Single Value 
);
 ;
       
SetSharpness (const Single Value 
);
 ;
       
SetEnabled (const Boolean Value 
);
 ;
       
SetIntensity (const Single Value 
);
 ;
       
SetStatic (const Boolean Value 
);
 ;
     
ResetDevice ();
 ;
     
CreateTextures ();
 ;
     
CreateStaticCubeDepthTexture ();
 ;
     
CreateStaticDepthTexture ();
 ;
     
BuildDynamicShadowMap ();
 ;
     
BuildStaticShadowMap ();
 ;
                    
BuildShadowMap (const Iz3DBaseTexture ATarget ,
const Iz3DSurface ADepth ,
const Boolean AStatic = False 
);
 ;
     
RenderPrecomputation ();
 ;
     
RenderWorld ();
 ;
     
RenderSource ();
 ;
     
SetLightingTechnique ();
 ;
     
MeasureLightEffectParams ();
 ;
     
UpdateLightingParams ();
 ;
     
UpdateSourceParams ();
 ;
     
StartScenario ();
 ;
     
TurnOn ();
 ;
     
TurnOff ();
 ;

       /** \sa GetColor For reading*/
Iz3DFloat3 Color; 

         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

       /** \sa GetEffects For reading*/
Iz3DLightEffects Effects; 

         /** \sa GetStatic For reading   \sa SetStatic For writing */
Boolean Static; 

         /** \sa GetDynamicMode For reading   \sa SetDynamicMode For writing */
Boolean DynamicMode; 

         /** \sa GetName For reading   \sa SetName For writing */
PWideChar Name; 

       /** \sa GetIndex For reading*/
Integer Index; 

         /** \sa GetStyle For reading   \sa SetStyle For writing */
Tz3DLightStyle Style; 

         /** \sa GetIntensity For reading   \sa SetIntensity For writing */
Single Intensity; 

         /** \sa GetRange For reading   \sa SetRange For writing */
Single Range; 

         /** \sa GetSharpness For reading   \sa SetSharpness For writing */
Single Sharpness; 

         /** \sa GetAngle For reading   \sa SetAngle For writing */
Single Angle; 

       /** \sa GetPosition For reading*/
Iz3DFloat3 Position; 

         /** \sa GetSize For reading   \sa SetSize For writing */
Single Size; 

       /** \sa GetDirection For reading*/
Iz3DFloat3 Direction; 

       /** \sa GetStage For reading*/
Tz3DDirectLightRenderStage Stage; 

         /** \sa GetOnRender For reading   \sa SetOnRender For writing */
Tz3DDirectLightRenderEvent OnRender; 

 };


/*==============================================================================*/ 
/*== Screen Space Ambient Occlusion interface                                 ==*/ 
/*==============================================================================*/ 
/*== Controller for the SSAO effect                                           ==*/ 
/*==============================================================================*/ 

   enum Tz3DSSAOQuality
{
z3dssaoqLow, 
z3dssaoqMedium, 
z3dssaoqHigh 
};


   class Iz3DSSAO : public Iz3DBase
{
public:
['{0027DE4E-6E3C-4CA8-B122-2B3A3D4AF129}']
      
Single GetSampleFactor ();
 ;
       
SetSampleFactor (const Single Value 
);
 ;
      
Tz3DSSAOQuality GetQuality ();
 ;
       
SetQuality (const Tz3DSSAOQuality Value 
);
 ;
      
Single GetAmount ();
 ;
       
SetAmount (const Single Value 
);
 ;
      
Boolean GetEnabled ();
 ;
       
SetEnabled (const Boolean Value 
);
 ;

         /** \sa GetAmount For reading   \sa SetAmount For writing */
Single Amount; 

         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

         /** \sa GetQuality For reading   \sa SetQuality For writing */
Tz3DSSAOQuality Quality; 

         /** \sa GetSampleFactor For reading   \sa SetSampleFactor For writing */
Single SampleFactor; 

 };


/*==============================================================================*/ 
/*== Lights interface                                                         ==*/ 
/*==============================================================================*/ 
/*== Holds every light source and manages its shared properties and objects.  ==*/ 
/*== It also allows to add, access and remove light sources                   ==*/ 
/*==============================================================================*/ 

   enum Tz3DShadowQuality
{
z3dsqLow, 
z3dsqMid, 
z3dsqHigh 
};


   class Iz3DLightingController : public Iz3DBase
{
public:
['{245A0C58-ABDE-4D18-B3E6-1E62D389CE58}']
      
Tz3DLightingRenderStage GetStage ();
 ;
      
Single GetDirShadowMapAreaSize ();
 ;
       
SetDirShadowMapAreaSize (const Single Value 
);
 ;
      
Single GetDirShadowMapOffset ();
 ;
      
Single GetShadowMapOffset ();
 ;
       
SetDirShadowMapOffset (const Single Value 
);
 ;
       
SetShadowMapOffset (const Single Value 
);
 ;
      
Iz3DLight GetCurrentLight ();
 ;
      
Iz3DSSAO GetSSAO ();
 ;
      
Tz3DShadowQuality GetShadowQuality ();
 ;
      
Boolean GetUseDynamicHWShadow ();
 ;
      
Boolean GetUseStaticHWShadow ();
 ;
       
SetShadowQuality (const Tz3DShadowQuality Value 
);
 ;
       
SetUseDynamicHWShadow (const Boolean Value 
);
 ;
       
SetUseStaticHWShadow (const Boolean Value 
);
 ;
      
Iz3DRenderTexture GetTempDepthMap ();
 ;
      
Iz3DRenderTexture GetTempDirDepthMap ();
 ;
      
Iz3DRenderTexture GetDirDepthMap ();
 ;
      
Iz3DCubeRenderTexture GetCubeDepthMap ();
 ;
      
Iz3DRenderTexture GetDepthMap ();
 ;
      
Iz3DDepthBuffer GetDepthBuffer ();
 ;
      
Integer GetLightCount ();
 ;
      
Iz3DEffect GetEffect ();
 ;
        
Iz3DLight GetLights (const Integer AIndex 
);
 ;
          
SetLights (const Integer AIndex ,
const Iz3DLight Value 
);
 ;
     
RenderPrecomputation ();
 ;
     
RenderAmbient ();
 ;
     
RenderLighting ();
 ;
     
RenderLightSources ();
 ;
     
CreateScenarioObjects ();
 ;
     
CreateDepthTexture ();
 ;
     
CreateDirDepthTexture ();
 ;
     
CreateCubeDepthTexture ();
 ;
      
Integer DepthMapSize ();
 ;
      
Integer DirectionalDepthMapSize ();
 ;

      
Iz3DLight CreateLight ();
 ;
       
RemoveLight (const Iz3DLight ALight 
);
 ;
        
Integer IndexOfLight (const Iz3DLight ALight 
);
 ;

    /*[const AIndex: Integer]*/     /** \sa GetLights For reading   \sa SetLights For writing */
Iz3DLight Lights; 
 
       /** \sa GetLightCount For reading*/
Integer LightCount; 

       /** \sa GetCurrentLight For reading*/
Iz3DLight CurrentLight; 

       /** \sa GetDepthMap For reading*/
Iz3DRenderTexture DepthMap; 

       /** \sa GetTempDepthMap For reading*/
Iz3DRenderTexture TempDepthMap; 

       /** \sa GetTempDirDepthMap For reading*/
Iz3DRenderTexture TempDirDepthMap; 

       /** \sa GetDirDepthMap For reading*/
Iz3DRenderTexture DirDepthMap; 

       /** \sa GetCubeDepthMap For reading*/
Iz3DCubeRenderTexture CubeDepthMap; 

       /** \sa GetDepthBuffer For reading*/
Iz3DDepthBuffer DepthBuffer; 

       /** \sa GetEffect For reading*/
Iz3DEffect Effect; 

         /** \sa GetDirShadowMapAreaSize For reading   \sa SetDirShadowMapAreaSize For writing */
Single DirShadowMapAreaSize; 

         /** \sa GetShadowMapOffset For reading   \sa SetShadowMapOffset For writing */
Single ShadowMapOffset; 

         /** \sa GetDirShadowMapOffset For reading   \sa SetDirShadowMapOffset For writing */
Single DirShadowMapOffset; 

         /** \sa GetShadowQuality For reading   \sa SetShadowQuality For writing */
Tz3DShadowQuality ShadowQuality; 

         /** \sa GetUseStaticHWShadow For reading   \sa SetUseStaticHWShadow For writing */
Boolean UseStaticHWShadow; 

         /** \sa GetUseDynamicHWShadow For reading   \sa SetUseDynamicHWShadow For writing */
Boolean UseDynamicHWShadow; 

       /** \sa GetSSAO For reading*/
Iz3DSSAO SSAO; 

       /** \sa GetStage For reading*/
Tz3DLightingRenderStage Stage; 

 };


/*==============================================================================*/ 
/*== LightMap interfaces                                                      ==*/ 
/*==============================================================================*/ 
/*== Creates, loads and manages static lightmaps for world objects.           ==*/ 
/*==============================================================================*/ 

   struct Tz3DRay
{

      Iz3DFloat3 Origin; 

      Iz3DFloat3 Direction; 

      Single Length; 

 };


   typedef Tz3DLightMapLuxel* Pz3DLightMapLuxel;


   struct Tz3DBounceCollision
{

      Boolean Collision; 
   // True if collision found
      Iz3DScenarioStaticObject Target; 
 // Index of collision object
      Single Distance; 
     // Distance from origin to collision
      Integer PlaneIndex; 
  // Index of the distribution plane that has collided
      Pz3DLightMapLuxel Luxel; 

      Single Determinant; 
  // The spheric interpolation determinant
 };

   typedef array Tz3DBounceCollisions  array of Tz3DBounceCollision;

  Tz3DLightMapLuxel struct of
{

    // Position and normal
      Iz3DFloat3 Position; 

      Iz3DFloat3 Normal; 

    // Color information (ambient, direct lighting and radiosity)
         
         
    // Stored radiosity objectives for each sample
      Tz3DBounceCollisions Collisions; 

      Boolean CollisionTested; 

 };

   typedef array Tz3DLightMapLuxels  array of Tz3DLightMapLuxel;

     typedef array<Iz3DFloat3> Tz3DFloat3Array;
     typedef array<Iz3DFloat2> Tz3DFloat2Array;

    Iz3DFloat3 Tz3DTriangle[2]; /*!< [0..2] */


  // Lightmap plane information
  Pz3DLightMapPlane typedef Tz3DLightMapPlane* of;

   struct Tz3DLightMapPlane
{

         Integer OffsetU; 
 Integer OffsetV; 
 Integer Width; 
 Integer Height; 

         Iz3DFloat3 Origin; 
 Iz3DFloat3 Edge1; 
 Iz3DFloat3 Edge2; 
 Iz3DFloat3 Normal; 


      Tz3DFloat2Array Lights; 

           Single FUMin; 
 Single FUMax; 
 Single FVMin; 
 Single FVMax; 
 Single FUDelta; 
 Single FVDelta; 


      Integer ID; 

      Integer RefCount; 

      Boolean Generated; 

      Tz3DLightMapLuxels Luxels; 

 };

     typedef array<Tz3DLightMapPlane> Tz3DLightMapDistribution;

  // Lightmap texture information
   struct Tz3DLightMapTexture
{

      Iz3DTexture Texture; 

      PWideChar Name; 

      Boolean Created; 

      Boolean Loaded; 

      Boolean Saved; 

 };

     typedef array<Tz3DLightMapTexture> Tz3DLightMapTextures;

/*==============================================================================*/ 
/*== Lightmap packing node interface                                          ==*/ 
/*==============================================================================*/ 
/*== Represents an individual lightmap into the packing tree and holds the    ==*/ 
/*== child lightmap nodes                                                     ==*/ 
/*==============================================================================*/ 

   class Iz3DLightMapPackNode : public Iz3DBase
{
public:
['{DE1CB2D7-8C3B-4C51-AB36-7E7CAAB5C0E5}']
        
Iz3DLightMapPackNode GetChilds (const Integer I 
);
 ;
      
Integer GetID ();
 ;
      
TRect GetRect ();
 ;
          
SetChilds (const Integer I ,
const Iz3DLightMapPackNode Value 
);
 ;
       
SetID (const Integer Value 
);
 ;
       
SetRect (const TRect Value 
);
 ;
    
         /** \sa GetRect For reading   \sa SetRect For writing */
TRect Rect; 

         /** \sa GetID For reading   \sa SetID For writing */
Integer ID; 

    /*[const I: Integer]*/     /** \sa GetChilds For reading   \sa SetChilds For writing */
Iz3DLightMapPackNode Childs; 

 };


   typedef interface Iz3DLightMap;

/*==============================================================================*/ 
/*== Ray tracer interface                                                     ==*/ 
/*==============================================================================*/ 
/*== Allows to perform ray tracing operations on the world for any purposes.  ==*/ 
/*== The main features are reflections, refractions, penumbra and bouncing    ==*/ 
/*==============================================================================*/ 

   typedef interface Iz3DRayTracer['/*E9526C46-1563-4225-8593-F43D2F7C9EF1*/ ']
      
Iz3DTexture GetRadiosityBuffer0 ();
 ;
      
Iz3DTexture GetRadiosityBuffer1 ();
 ;
      
Integer GetPenumbraDetailFactor ();
 ;
       
SetPenumbraDetailFactor (const Integer Value 
);
 ;
      
Integer GetRadiositySamples ();
 ;
       
SetRadiositySamples (const Integer Value 
);
 ;
      
Integer GetAOSamples ();
 ;
       
SetAOSamples (const Integer Value 
);
 ;
      
Boolean GetPenumbra ();
 ;
      
Boolean GetShadows ();
 ;
       
SetPenumbra (const Boolean Value 
);
 ;
       
SetShadows (const Boolean Value 
);
 ;
      
Boolean GetNormalLerp ();
 ;
      
Single GetNormalLerpExponent ();
 ;
       
SetNormalLerp (const Boolean Value 
);
 ;
       
SetNormalLerpExponent (const Single Value 
);
 ;

         
BeginGPUTracing (const Boolean ASetCull = False 
);
 ;
         
EndGPUTracing (const Boolean ASetCull = False 
);
 ;
     
BeginAOTracing ();
 ;
     
EndAOTracing ();
 ;
       
BeginRadiosityTracing (const Iz3DLightMap ALightMap 
);
 ;
     
EndRadiosityTracing ();
 ;

       
RayTraceLightMap (const Iz3DLightMap ALightMap 
);
 ;
          
RayTraceLightMapRadiosity (const Iz3DLightMap ALightMap ,
const Integer ALevel 
);
 ;
          
RayTraceLightMapRadiosity_GPU (const Iz3DLightMap ALightMap ,
const Integer ALevel 
);
 ;
               
NormalizeLightMapRadiosity (const Iz3DLightMap ALightMap ,
const Integer ALevel 
);
 ;

              
Boolean RayIntersectTriangle (const Tz3DRay ARay ,
const Tz3DTriangle ATriangle ,
Single &ADistance 
);
 ;
                    
Boolean RayIntersectVertex (const Iz3DScenarioObject AObject1 ,
const Iz3DScenarioObject AObject2 ,
const Tz3DRay ARay ,
Single &ADistance 
);
 ;
              
Boolean RayIntersectPlane (const Tz3DRay ARay ,
const Tz3DTriangle APlane ,
Single &ADistance 
);
 ;
                   
Boolean RayIntersectBoundingSphere (const Tz3DRay ARay ,
const Iz3DBoundingSphere ASphere ,
Single &ADistance 
);
 ;
                        
Boolean RayIntersectBoundingBox (const Tz3DRay ARay ,
const Iz3DBoundingBox ABox ,
Single &ADistance ,
const Boolean ATEvaluation = True 
);
 ;
          
               
Boolean RayIntersectBound (const Iz3DScenarioObject AObject1 ,
const Iz3DScenarioObject AObject2 ,
const Tz3DRay ARay ,
Single &ADistance ,
const Boolean ATEvaluation = True 
);
 ;

                                                  
Boolean RayCollision (const Iz3DScenarioObject ARayObject ,
const Tz3DRay ARay ,
Single &AResult ,
/* out */ Iz3DScenarioObject &ACollisionObject ,
/* out */ Single &ACollisionT ,
const Boolean AVertexEvaluation = True ,
const Boolean ATEvaluation = True ,
const Integer ATotalSamples = 1 
);
 ;

                    
Iz3DFloat3 RayTraceLight (const Iz3DScenarioObject AObject ,
const Iz3DFloat3 ACenter ,
const Iz3DFloat3 ANormal ,
const Integer ALight 
);
 ;
                       
Iz3DFloat3 RayTraceAO (const Iz3DScenarioObject AObject ,
const Iz3DFloat3 ACenter ,
const Iz3DFloat3 ANormal ,
const Iz3DFloat3 AOrigin ,
const Iz3DFloat3 AEdge1 ,
const Iz3DFloat3 AEdge2 ,
/* out */ Boolean &ACollision 
);
 ;
                                 
Iz3DFloat3 RayTraceRadiosity (const Iz3DScenarioObject AObject ,
Tz3DLightMapLuxel &ALumel ,
const Iz3DFloat3 ACenter ,
const Iz3DFloat3 ANormal ,
const Iz3DFloat3 AOrigin ,
const Iz3DFloat3 AEdge1 ,
const Iz3DFloat3 AEdge2 ,
const Iz3DFloat3 AColor ,
const Integer ALight ,
const Integer ALevel 
);
 ;

       /** \sa GetRadiosityBuffer0 For reading*/
Iz3DTexture RadiosityBuffer0; 

       /** \sa GetRadiosityBuffer1 For reading*/
Iz3DTexture RadiosityBuffer1; 

         /** \sa GetNormalLerp For reading   \sa SetNormalLerp For writing */
Boolean NormalLerp; 

         /** \sa GetNormalLerpExponent For reading   \sa SetNormalLerpExponent For writing */
Single NormalLerpExponent; 

         /** \sa GetAOSamples For reading   \sa SetAOSamples For writing */
Integer AOSamples; 

         /** \sa GetRadiositySamples For reading   \sa SetRadiositySamples For writing */
Integer RadiositySamples; 

         /** \sa GetShadows For reading   \sa SetShadows For writing */
Boolean Shadows; 

         /** \sa GetPenumbra For reading   \sa SetPenumbra For writing */
Boolean Penumbra; 

         /** \sa GetPenumbraDetailFactor For reading   \sa SetPenumbraDetailFactor For writing */
Integer PenumbraDetailFactor; 

 };


/*==============================================================================*/ 
/*== Lightmap options interface                                               ==*/ 
/*==============================================================================*/ 
/*== Holds the options available for the lightmap generation                  ==*/ 
/*==============================================================================*/ 

   typedef interface Iz3DLightMapOptions['/*53A99579-7971-47BF-912A-32EA5DEC9E11*/ ']
      
Boolean GetEnableAmbient ();
 ;
      
Boolean GetEnableRadiosity ();
 ;
      
Integer GetRadiosityBounces ();
 ;
       
SetEnableAmbient (const Boolean Value 
);
 ;
       
SetEnableRadiosity (const Boolean Value 
);
 ;
       
SetRadiosityBounces (const Integer Value 
);
 ;
      
Integer GetBlurSteps ();
 ;
       
SetBlurSteps (const Integer Value 
);
 ;
      
Integer GetDetailFactor ();
 ;
       
SetDetailFactor (const Integer Value 
);
 ;
    
         /** \sa GetDetailFactor For reading   \sa SetDetailFactor For writing */
Integer DetailFactor; 

         /** \sa GetBlurSteps For reading   \sa SetBlurSteps For writing */
Integer BlurSteps; 

         /** \sa GetEnableAmbient For reading   \sa SetEnableAmbient For writing */
Boolean EnableAmbient; 

         /** \sa GetEnableRadiosity For reading   \sa SetEnableRadiosity For writing */
Boolean EnableRadiosity; 

         /** \sa GetRadiosityBounces For reading   \sa SetRadiosityBounces For writing */
Integer RadiosityBounces; 

 };


/*==============================================================================*/ 
/*== Global lightmap controller interface                                     ==*/ 
/*==============================================================================*/ 
/*== Configures the global settings of the lightmap generation algorithm such ==*/ 
/*== as the texture format or the loading and saving path                     ==*/ 
/*==============================================================================*/ 

   typedef interface Iz3DLightMapController['/*E6100C60-3ADC-4A61-9AC1-A5FBB9AF3E58*/ ']
      
PWideChar GetLightFileMask ();
 ;
       
SetLightFileMask (const PWideChar Value 
);
 ;
      
PWideChar GetAOFileMask ();
 ;
       
SetAOFileMask (const PWideChar Value 
);
 ;
      
PWideChar GetFolderName ();
 ;
      
Integer GetMaxTextureSize ();
 ;
       
SetFolderName (const PWideChar Value 
);
 ;
       
SetMaxTextureSize (const Integer Value 
);
 ;

        
PWideChar GetTextureFileName (const PWideChar ATextureName 
);
 ;
      
Iz3DLightMap CreateLightMap ();
 ;

         /** \sa GetLightFileMask For reading   \sa SetLightFileMask For writing */
PWideChar LightFileMask; 

         /** \sa GetAOFileMask For reading   \sa SetAOFileMask For writing */
PWideChar AOFileMask; 

         /** \sa GetFolderName For reading   \sa SetFolderName For writing */
PWideChar FolderName; 

         /** \sa GetMaxTextureSize For reading   \sa SetMaxTextureSize For writing */
Integer MaxTextureSize; 

 };


/*==============================================================================*/ 
/*== Lightmap interface                                                       ==*/ 
/*==============================================================================*/ 
/*== Controls the lightmap creation and linking to an specific world static   ==*/ 
/*== object. It uses the ray tracer interface to generate the lighting        ==*/ 
/*==============================================================================*/ 

     typedef array<Integer> Tz3DDistributionIndices;

   typedef interface Iz3DLightMap['/*17261C55-B331-4006-B90A-FD9A4B6B37BF*/ ']
      
Iz3DScenarioStaticObject GetCurrentObject ();

      
Boolean GetGenerated ();
 ;
        
Pz3DLightMapPlane GetFacePlane (const Integer AFace 
);
 ;
      
Tz3DDistributionIndices GetDistributionIndices ();
 ;
      
Boolean GetEnabled ();
 ;
       
SetEnabled (const Boolean Value 
);
 ;
      
Integer GetOffset ();
 ;
      
Tz3DLightMapTexture GetAmbientTexture ();
 ;
      
Tz3DLightMapTextures GetLightTextures ();
 ;
      
Tz3DLightMapTextures GetRadiosityTextures ();
 ;
      
Iz3DLightMapOptions GetOptions ();
 ;
      
Iz3DRayTracer GetRayTracer ();
 ;
      
Tz3DLightMapDistribution GetDistribution ();
 ;
      
Iz3DFloat3 GetWorldScale ();
 ;
      
Integer GetSize ();
 ;
      
PWideChar GetUniqueName ();
 ;
       
SetUniqueName (const PWideChar Value 
);
 ;
                         
GetCoords (const Iz3DFloat2 AV1 ,
const Iz3DFloat2 AV2 ,
const Iz3DFloat2 AV3 ,
const Tz3DFloat2Array AAditional ,
Single &AMinU ,
Single &AMaxU ,
Single &AMinV ,
Single &AMaxV ,
Single &ADeltaU ,
Single &ADeltaV 
);
 ;
            
GenerateLightCoords (const Iz3DBase AObject ,
const Pz3DDWordArray AAdjacency = nil 
);
 ;
                        
GeneratePlanarMapping (const Pointer AVB ,
const PWordArray AIB ,
const Integer AFaceCount ,
const Pz3DDWordArray AAdjacency ,
const Boolean AComputeCoords 
);
 ;
           
Iz3DLightMapPackNode AddPackNode (const Iz3DLightMapPackNode ANode ,
const Tz3DLightMapPlane APlane 
);
 ;
     
CreateTextures ();
 ;
     
SaveTextures ();
 ;
                     
Distribute (const Pointer AVB ,
const PWordArray AIB ,
const Integer AFaceCount ,
const Boolean AComputeCoords 
);
 ;
                      
GetWorldPlane (const Iz3DFloat3 ANormal ,
const Iz3DFloat3 APointOnPlane ,
const Single AMinU ,
const Single AMaxU ,
const Single AMinV ,
const Single AMaxV ,
Tz3DTriangle &APlane 
);
 ;
             
Blur (const TD3DLockedRect ARect ,
const Integer AOffsetU ,
const Integer AOffsetV ,
const Integer AWidth ,
const Integer AHeight 
);
 ;
     
BlurTextures ();
 ;
       
BlurAndSave (Tz3DLightMapTexture &ATexture 
);
 ;
     
CopyRadiosityToTextures ();
 ;
     
BeginDraw ();
 ;
     
EndDraw ();
 ;

                       
Boolean BeginGeneration (const Iz3DScenarioStaticObject AObject ,
const Pz3DDWordArray AAdjacency = nil ,
const Boolean AComputeCoords = False 
);
 ;

     
BeginRadiosity ();
 ;
      
Boolean PerformRadiosityBounce ();
 ;
     
EndRadiosityBounce ();
 ;
     
EndRadiosity ();
 ;

      
Boolean EndGeneration ();
 ;
      
Boolean GenerationNeeded ();
 ;

       /** \sa GetAmbientTexture For reading*/
Tz3DLightMapTexture AmbientTexture; 

       /** \sa GetLightTextures For reading*/
Tz3DLightMapTextures LightTextures; 

       /** \sa GetRadiosityTextures For reading*/
Tz3DLightMapTextures RadiosityTextures; 

         /** \sa GetUniqueName For reading   \sa SetUniqueName For writing */
PWideChar UniqueName; 

       /** \sa GetDistributionIndices For reading*/
Tz3DDistributionIndices DistributionIndices; 

       /** \sa GetDistribution For reading*/
Tz3DLightMapDistribution Distribution; 

       /** \sa GetCurrentObject For reading*/
Iz3DScenarioStaticObject CurrentObject; 

    /*[const AFace: Integer]*/   /** \sa GetFacePlane For reading*/
Pz3DLightMapPlane FacePlane; 

       /** \sa GetGenerated For reading*/
Boolean Generated; 

         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

       /** \sa GetOptions For reading*/
Iz3DLightMapOptions Options; 

       /** \sa GetRayTracer For reading*/
Iz3DRayTracer RayTracer; 

       /** \sa GetWorldScale For reading*/
Iz3DFloat3 WorldScale; 

       /** \sa GetSize For reading*/
Integer Size; 

       /** \sa GetOffset For reading*/
Integer Offset; 

 };




// finished

