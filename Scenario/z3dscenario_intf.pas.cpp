



     
  


   typedef interface Iz3DWorld;

   typedef interface Iz3DMaterial;

   typedef interface Iz3DScenarioEntity;




/*==============================================================================*/ 
/*== Scenario interface                                                       ==*/ 
/*==============================================================================*/ 
/*== Contains the attributes that are applied to the global scene. It also    ==*/ 
/*== begins the render chain and allows to disable the world rendering        ==*/ 
/*==============================================================================*/ 

   enum Tz3DScenarioCreationSteps
{
z3dscsScenario, 
z3dscsWorlds, 
z3dscsObjects, 
z3dscsLightingSystem 
};


   enum Tz3DScenarioKind
{
z3dskEmpty, 
z3dskSingleWorldIndoor, 
z3dskSingleWorldOutdoor, 
z3dskSingleWorldMixed, 
z3dskMultipleWorlds 
};


   class Iz3DScenario : public Iz3DBase
{
public:
['{5C20B75C-7738-4172-9D09-0901A31AEEC1}']
      
Tz3DScenarioKind GetKind ();
 ;
       
SetKind (const Tz3DScenarioKind Value 
);
 ;
        
Iz3DScenarioEntity GetEntities (const Integer AIndex 
);
 ;
      
Integer GetEntityCount ();
 ;
      
Integer GetWorldCount ();
 ;
        
Iz3DWorld GetWorlds (const Integer AIndex 
);
 ;
      
Boolean GetProjectionChanged ();
 ;
       
SetProjectionChanged (const Boolean Value 
);
 ;
      
Iz3DBoundingSphere GetBounds ();
 ;
      
Boolean GetEnabled ();
 ;
       
SetEnabled (const Boolean Value 
);
 ;
     
FrameRender ();
 ;
     
ResetDevice ();
 ;
      
Iz3DWorld CreateWorld ();
 ;
       
AddEntity (const Iz3DScenarioEntity AEntity 
);
 ;
       
RemoveEntity (const Iz3DScenarioEntity AEntity 
);
 ;
        
Integer IndexOf (const Iz3DScenarioEntity AEntity 
);
 ;

         /** \sa GetKind For reading   \sa SetKind For writing */
Tz3DScenarioKind Kind; 

    /*[const AIndex: Integer]*/   /** \sa GetEntities For reading*/
Iz3DScenarioEntity Entities; 

       /** \sa GetEntityCount For reading*/
Integer EntityCount; 

    /*[const AIndex: Integer]*/   /** \sa GetWorlds For reading*/
Iz3DWorld Worlds; 

       /** \sa GetWorldCount For reading*/
Integer WorldCount; 

         /** \sa GetProjectionChanged For reading   \sa SetProjectionChanged For writing */
Boolean ProjectionChanged; 

       /** \sa GetBounds For reading*/
Iz3DBoundingSphere Bounds; 

         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

 };


   class Iz3DScenarioEntity : public Iz3DBase
{
public:
['{005AD0FD-7993-42A9-A69C-7EABB20CFC3F}']
      
Integer GetIndex ();
 ;
    
       /** \sa GetIndex For reading*/
Integer Index; 

 };


   class Iz3DScenarioObjectSubset : public Iz3DBase
{
public:
['{BEB88413-E6CB-4AB1-9BB8-AE1ED30364CE}']
      
Iz3DMaterial GetMaterial ();
 ;
      
Iz3DBoundingBox GetBoundingBox ();
 ;
      
Iz3DBoundingSphere GetBoundingSphere ();
 ;

       /** \sa GetMaterial For reading*/
Iz3DMaterial Material; 

       /** \sa GetBoundingSphere For reading*/
Iz3DBoundingSphere BoundingSphere; 

       /** \sa GetBoundingBox For reading*/
Iz3DBoundingBox BoundingBox; 

 };


   enum Tz3DScenarioObjectShape
{
z3dsosSphere, 
z3dsosCube 
};


   class Iz3DScenarioObject : public Iz3DScenarioEntity
{
public:
['{CF3545AD-61C7-4F0C-825F-2D60F8B61C07}']
      
Iz3DFloat3 GetCenter ();
 ;
      
Iz3DFloat4 GetViewCenter ();
 ;
      
Boolean GetVisible ();
 ;
      
Iz3DBoundingBox GetBoundingBox ();
 ;
      
Iz3DBoundingSphere GetBoundingSphere ();
 ;
      
Tz3DScenarioObjectShape GetShape ();
 ;
      
Integer GetSubsetCount ();
 ;
        
Iz3DScenarioObjectSubset GetSubsets (const Integer I 
);
 ;
       
SetVisible (const Boolean Value 
);
 ;

     
Show ();
 ;
     
Hide ();
 ;

       /** \sa GetShape For reading*/
Tz3DScenarioObjectShape Shape; 

       /** \sa GetBoundingSphere For reading*/
Iz3DBoundingSphere BoundingSphere; 

       /** \sa GetBoundingBox For reading*/
Iz3DBoundingBox BoundingBox; 

       /** \sa GetCenter For reading*/
Iz3DFloat3 Center; 

       /** \sa GetViewCenter For reading*/
Iz3DFloat4 ViewCenter; 

    /*[const I: Integer]*/   /** \sa GetSubsets For reading*/
Iz3DScenarioObjectSubset Subsets; 

       /** \sa GetSubsetCount For reading*/
Integer SubsetCount; 

         /** \sa GetVisible For reading   \sa SetVisible For writing */
Boolean Visible; 

 };


   class Iz3DScenarioStaticObject : public Iz3DScenarioObject
{
public:
['{457657D7-C6D1-4240-8859-95A3851DDD45}']
 };


   class Iz3DScenarioDynamicObject : public Iz3DScenarioObject
{
public:
['{D50CAB4B-45F3-4375-8C9A-521D2D28E8B2}']
      
Iz3DFloat3 GetAcceleration ();
 ;
      
Iz3DFloat3 GetVelocity ();
 ;
      
Boolean GetGround ();
 ;
       
SetGround (const Boolean Value 
);
 ;
      
Boolean GetEnablePhysics ();
 ;
       
SetEnablePhysics (const Boolean Value 
);
 ;

       /** \sa GetAcceleration For reading*/
Iz3DFloat3 Acceleration; 

       /** \sa GetVelocity For reading*/
Iz3DFloat3 Velocity; 

         /** \sa GetGround For reading   \sa SetGround For writing */
Boolean Ground; 

         /** \sa GetEnablePhysics For reading   \sa SetEnablePhysics For writing */
Boolean EnablePhysics; 

 };


/*==============================================================================*/ 
/*== Fog interface                                                            ==*/ 
/*==============================================================================*/ 
/*== Controller for the fog effect of the scenario                            ==*/ 
/*==============================================================================*/ 

   class Iz3DFog : public Iz3DBase
{
public:
['{A261C837-8A74-4711-B699-2EE6A49EBEC6}']
      
Boolean GetUniform ();
 ;
       
SetUniform (const Boolean Value 
);
 ;
       
SetDensity (const Single Value 
);
 ;
       
SetEnabled (const Boolean Value 
);
 ;
       
SetRangeMin (const Single Value 
);
 ;
       
SetRangeMax (const Single Value 
);
 ;
      
Iz3DFloat3 GetColor ();
 ;
      
Single GetDensity ();
 ;
      
Single GetRangeMin ();
 ;
      
Single GetRangeMax ();
 ;
      
Boolean GetEnabled ();
 ;

     
Show ();
 ;
     
Hide ();
 ;

       /** \sa GetColor For reading*/
Iz3DFloat3 Color; 

         /** \sa GetRangeMin For reading   \sa SetRangeMin For writing */
Single RangeMin; 

         /** \sa GetRangeMax For reading   \sa SetRangeMax For writing */
Single RangeMax; 

         /** \sa GetDensity For reading   \sa SetDensity For writing */
Single Density; 

         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

         /** \sa GetUniform For reading   \sa SetUniform For writing */
Boolean Uniform; 

 };


   class Iz3DWorld : public Iz3DBase
{
public:
['{22937440-ADFF-4A56-98DD-494E862D24B6}']
      
Iz3DFloat3 GetAmbientColor ();
 ;
      
Iz3DFog GetFog ();
 ;
      
Iz3DBoundingSphere GetBounds ();
 ;
      
Iz3DFloat3 GetWindSpeed ();
 ;
       
AddEntity (const Iz3DScenarioEntity AEntity 
);
 ;
       
RemoveEntity (const Iz3DScenarioEntity AEntity 
);
 ;
        
Iz3DScenarioEntity GetEntities (const Integer I 
);
 ;
          
SetEntities (const Integer I ,
const Iz3DScenarioEntity Value 
);
 ;
      
Single GetGravity ();
 ;
       
SetGravity (const Single Value 
);
 ;
      
Integer GetEntityCount ();
 ;
        
Integer IndexOf (const Iz3DScenarioEntity AEntity 
);
 ;

       /** \sa GetBounds For reading*/
Iz3DBoundingSphere Bounds; 

         /** \sa GetGravity For reading   \sa SetGravity For writing */
Single Gravity; 

    /*[const I: Integer]*/     /** \sa GetEntities For reading   \sa SetEntities For writing */
Iz3DScenarioEntity Entities; 

       /** \sa GetEntityCount For reading*/
Integer EntityCount; 

       /** \sa GetWindSpeed For reading*/
Iz3DFloat3 WindSpeed; 

       /** \sa GetAmbientColor For reading*/
Iz3DFloat3 AmbientColor; 

       /** \sa GetFog For reading*/
Iz3DFog Fog; 

 };


  

   enum Tz3DMaterialEmissiveMode
{
z3dmemIncandescent, 
z3dmemInnerLight 
};


   class Iz3DMaterial : public Iz3DBase
{
public:
['{F9997D0B-A491-4276-87F4-1D5194FE4909}']
      
PWideChar GetFileName ();
 ;
       
SetFileName (const PWideChar Value 
);
 ;
      
Iz3DMaterialTexture GetTexture ();
 ;
      
Single GetReflectivity ();
 ;
       
SetReflectivity (const Single Value 
);
 ;
      
Single GetRoughness ();
 ;
       
SetRoughness (const Single Value 
);
 ;
      
PWideChar GetSounds ();
 ;
       
SetSounds (const PWideChar Value 
);
 ;
      
Tz3DMaterialEmissiveMode GetEmissiveMode ();
 ;
       
SetEmissiveMode (const Tz3DMaterialEmissiveMode Value 
);
 ;
      
Single GetDensity ();
 ;
      
Single GetElasticity ();
 ;
      
Iz3DFloat4 GetColorDiffuse ();
 ;
      
Iz3DFloat3 GetColorEmissive ();
 ;
      
Single GetSpecularAmount ();
 ;
       
SetDensity (const Single Value 
);
 ;
       
SetElasticity (const Single Value 
);
 ;
       
SetColorDiffuse (const Iz3DFloat4 Value 
);
 ;
       
SetColorEmissive (const Iz3DFloat3 Value 
);
 ;
       
SetSpecularAmount (const Single Value 
);
 ;

       
LoadFromFile (const PWideChar AFileName 
);
 ;
       
SaveToFile (const PWideChar AFileName 
);
 ;

         /** \sa GetFileName For reading   \sa SetFileName For writing */
PWideChar FileName; 

         /** \sa GetDensity For reading   \sa SetDensity For writing */
Single Density; 

         /** \sa GetElasticity For reading   \sa SetElasticity For writing */
Single Elasticity; 

         /** \sa GetSounds For reading   \sa SetSounds For writing */
PWideChar Sounds; 

         /** \sa GetColorDiffuse For reading   \sa SetColorDiffuse For writing */
Iz3DFloat4 ColorDiffuse; 

         /** \sa GetRoughness For reading   \sa SetRoughness For writing */
Single Roughness; 

       /** \sa GetTexture For reading*/
Iz3DMaterialTexture Texture; 

         /** \sa GetColorEmissive For reading   \sa SetColorEmissive For writing */
Iz3DFloat3 ColorEmissive; 

         /** \sa GetReflectivity For reading   \sa SetReflectivity For writing */
Single Reflectivity; 

         /** \sa GetEmissiveMode For reading   \sa SetEmissiveMode For writing */
Tz3DMaterialEmissiveMode EmissiveMode; 

         /** \sa GetSpecularAmount For reading   \sa SetSpecularAmount For writing */
Single SpecularAmount; 

 };


   class Iz3DMaterialController : public Iz3DBase
{
public:
['{CF23B71D-0F00-47DF-90C5-0B1CE7651A32}']
      
Iz3DObjectFileFormat GetMaterialFormat ();
 ;
      
Iz3DObjectFileFormat GetMaterialTextureFormat ();
 ;
      
Iz3DObjectFileFormat GetMaterialSoundFormat ();
 ;
      
Integer GetMaterialCount ();
 ;
        
Iz3DMaterial GetMaterials (const Integer AIndex 
);
 ;
      
Iz3DMaterialTexture GetDefaultTexture ();
 ;

     
CreateScenarioObjects ();
 ;
      
Iz3DMaterial CreateMaterial ();
 ;
        
Iz3DMaterial CreateMaterialFromFile (const PWideChar AFileName 
);
 ;
       
RemoveMaterial (const Iz3DMaterial AMaterial 
);
 ;

       /** \sa GetMaterialFormat For reading*/
Iz3DObjectFileFormat MaterialFormat; 

       /** \sa GetMaterialTextureFormat For reading*/
Iz3DObjectFileFormat MaterialTextureFormat; 

       /** \sa GetMaterialSoundFormat For reading*/
Iz3DObjectFileFormat MaterialSoundFormat; 

       /** \sa GetDefaultTexture For reading*/
Iz3DMaterialTexture DefaultTexture; 

    /*[const AIndex: Integer]*/   /** \sa GetMaterials For reading*/
Iz3DMaterial Materials; 

       /** \sa GetMaterialCount For reading*/
Integer MaterialCount; 

 };




// finished

