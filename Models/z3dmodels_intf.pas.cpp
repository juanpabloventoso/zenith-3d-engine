/*==============================================================================*/ 
/*== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==*/ 
/*==============================================================================*/ 
/*== Unit: z3DModels. Model interface support and instance management         ==*/ 
/*==============================================================================*/ 






       
    




                  const  z3dmfExtension =  "zModel";


  // Static model vertex struct
   typedef Tz3DStaticModelVertex* Pz3DStaticModelVertex;

   struct Tz3DStaticModelVertex
{

      TD3DXVector3 Position; 

      TD3DXVector3 Normal; 

      TD3DXVector3 Tangent; 

      TD3DXVector2 TexCoord; 

      TD3DXVector2 LightCoord; 

 };

   typedef Tz3DStaticModelVertexArray* Pz3DStaticModelVertexArray;

     () Tz3DStaticModelVertex Tz3DStaticModelVertexArray[-1]; /*!< [0..999..999..999..999..-1] */


  // Dynamic model vertex struct
   typedef Tz3DDynamicModelVertex* Pz3DDynamicModelVertex;

   struct Tz3DDynamicModelVertex
{

      TD3DXVector3 Position; 

      TD3DXVector3 Normal; 

      TD3DXVector3 Tangent; 

      TD3DXVector2 TexCoord; 

 };

   typedef Tz3DDynamicModelVertexArray* Pz3DDynamicModelVertexArray;

     () Tz3DDynamicModelVertex Tz3DDynamicModelVertexArray[-1]; /*!< [0..999..999..999..999..-1] */



   typedef interface Iz3DModel;
   typedef interface Iz3DModelInstance;
   typedef interface Iz3DStaticModel;
   typedef interface Iz3DDynamicModel;

   enum Tz3DModelLightMapProcessStage
{
z3dlmpsBeginGeneration, 
z3dlmpsBeginRadiosity, 
z3dlmpsBeginRadiosityBounce, 
z3dlmpsEndRadiosityBounce, 
z3dlmpsEndRadiosity, 
z3dlmpsEndGeneration 
};


   enum Tz3DModelMeshLOD
{
z3dmmlLow, 
z3dmmlMid, 
z3dmmlHigh 
};


    ID3DXPMesh Tz3DLODMeshes[999]; /*!< [999] */


   typedef array Tz3DModelRenderOrder  array of Integer;




  
/*==============================================================================*/ 
/*== Model controller interface                                               ==*/ 
/*==============================================================================*/ 
/*== Global controller and manager for models                                 ==*/ 
/*==============================================================================*/ 

  Iz3DModelController class of : public Iz3DBase
{
public:
['{F85B9727-E291-41D4-A1F6-B32EB4E2D025}']
      
Iz3DVertexFormat GetDynamicVertexFormat ();
 ;
      
Iz3DVertexFormat GetStaticVertexFormat ();
 ;
      
Tz3DModelRenderOrder GetStaticRenderOrder ();
 ;
      
Tz3DModelRenderOrder GetDynamicRenderOrder ();
 ;
      
Integer GetStaticModelCount ();
 ;
      
Integer GetDynamicModelCount ();
 ;
        
Iz3DStaticModel GetStaticModel (const Integer AIndex 
);
 ;
          
SetStaticModel (const Integer AIndex ,
const Iz3DStaticModel Value 
);
 ;
        
Iz3DDynamicModel GetDynamicModel (const Integer AIndex 
);
 ;
          
SetDynamicModel (const Integer AIndex ,
const Iz3DDynamicModel Value 
);
 ;

      
Iz3DStaticModel CreateStaticModel ();
 ;
      
Iz3DDynamicModel CreateDynamicModel ();
 ;
       
AddModel (const Iz3DModel AModel 
);
 ;
       
RemoveModel (const Iz3DModel AModel 
);
 ;

     
BuildRenderOrders ();
 ;
     
ProcessStaticLighting ();
 ;

      
Integer CurrentSceneInstances ();
 ;
      
Integer CurrentVisibleInstances ();
 ;
      
Integer CurrentScenePolygons ();
 ;
      
Integer CurrentVisiblePolygons ();
 ;
    
       /** \sa GetStaticModelCount For reading*/
Integer StaticModelCount; 

       /** \sa GetDynamicModelCount For reading*/
Integer DynamicModelCount; 

    /*[const AIndex: Integer]*/     /** \sa GetStaticModel For reading   \sa SetStaticModel For writing */
Iz3DStaticModel StaticModels; 

    /*[const AIndex: Integer]*/     /** \sa GetDynamicModel For reading   \sa SetDynamicModel For writing */
Iz3DDynamicModel DynamicModels; 

       /** \sa GetStaticVertexFormat For reading*/
Iz3DVertexFormat StaticVertexFormat; 

       /** \sa GetDynamicVertexFormat For reading*/
Iz3DVertexFormat DynamicVertexFormat; 

       /** \sa GetStaticRenderOrder For reading*/
Tz3DModelRenderOrder StaticRenderOrder; 

       /** \sa GetDynamicRenderOrder For reading*/
Tz3DModelRenderOrder DynamicRenderOrder; 

 };





/*==============================================================================*/ 
/*== Model subset interface                                                   ==*/ 
/*==============================================================================*/ 
/*== Extension of world subset with exclusive methods for models              ==*/ 
/*==============================================================================*/ 

   class Iz3DModelSubset : public Iz3DScenarioObjectSubset
{
public:
['{4E9A6ECE-59A6-46FF-BB68-C59B7822BBAC}']
 };







/*==============================================================================*/ 
/*== Model interface                                                          ==*/ 
/*==============================================================================*/ 
/*== Manages a mesh and prepares it for renderization                         ==*/ 
/*==============================================================================*/ 

   enum Tz3DModelInstancingMethod
{
z3dimReplicate, 
z3dimTransform, 
z3dimHardware 
};


   class Iz3DModel : public Iz3DBase
{
public:
['{9AA6324A-6531-4773-AF76-E1C1350965E0}']
        
Integer GetLODFaceCount (const Tz3DModelMeshLOD ALOD 
);
 ;
        
Integer GetLODVertexCount (const Tz3DModelMeshLOD ALOD 
);
 ;
      
PWideChar GetName ();
 ;
       
SetName (const PWideChar Value 
);
 ;
      
Boolean GetComputeLightCoords ();
 ;
       
SetComputeLightCoords (const Boolean Value 
);
 ;
      
Tz3DLODMeshes GetLODMeshes ();
 ;
      
ID3DXMesh GetMesh ();
 ;
       
SetFileName (const PWideChar Value 
);
 ;
      
Integer GetInstanceCount ();
 ;
      
Iz3DBoundingBox GetOSBoundingBox ();
 ;
      
Iz3DBoundingSphere GetOSBoundingSphere ();
 ;
      
Iz3DFloat3 GetScale ();
 ;
      
Integer GetBytesPerVertex ();
 ;
        
Iz3DModelInstance GetInstance (const Integer AIndex 
);
 ;
      
Iz3DBoundingBox GetBoundingBox ();
 ;
      
Boolean GetAutoGenerateTexCoords ();
 ;
      
Iz3DBoundingSphere GetBoundingSphere ();
 ;
      
Integer GetFaceCount ();
 ;
      
PWideChar GetFileName ();
 ;
      
Tz3DModelInstancingMethod GetInstancingMethod ();
 ;
      
Boolean GetLockAspectRatio ();
 ;
      
Boolean GetLockTexCoordsAspectRatio ();
 ;
      
Tz3DScenarioObjectShape GetShape ();
 ;
      
Integer GetSubsetCount ();
 ;
        
Iz3DModelSubset GetSubsets (const Integer I 
);
 ;
      
Single GetTexCoordsScale ();
 ;
      
Integer GetVertexCount ();
 ;
       
SetAutoGenerateTexCoords (const Boolean Value 
);
 ;
       
SetInstancingMethod (const Tz3DModelInstancingMethod Value 
);
 ;
       
SetLockAspectRatio (const Boolean Value 
);
 ;
       
SetLockTexCoordsAspectRatio (const Boolean Value 
);
 ;
       
SetShape (const Tz3DScenarioObjectShape Value 
);
 ;
       
SetTexCoordsScale (const Single Value 
);
 ;

          
Pointer LockVertices (const DWORD AFlags = 0 
);
 ;
     
UnlockVertices ();
 ;
             
Pointer LockLODVertices (const Tz3DModelMeshLOD ALOD ,
const DWORD AFlags = 0 
);
 ;
     
UnlockLODVertices ();
 ;
          
PWordArray LockIndices (const DWORD AFlags = 0 
);
 ;
     
UnlockIndices ();
 ;
             
PWordArray LockLODIndices (const Tz3DModelMeshLOD ALOD ,
const DWORD AFlags = 0 
);
 ;
     
UnlockLODIndices ();
 ;
     
CreateModel ();
 ;
          
CreateSubsets (const PD3DXMaterial AD3DXMtrls ,
const Integer ACount 
);
 ;

      
Iz3DModelSubset AddSubset ();
 ;
       
RemoveSubset (const Iz3DModelSubset ASubset 
);
 ;
       
RemoveInstance (const Iz3DModelInstance AInstance 
);
 ;
        
Integer IndexOf (const Iz3DModelInstance AInstance 
);
 ;

     
CreateLODMeshes ();
 ;
     
GenerateTexCoords ();
 ;
       
SetDeclaration (const PD3DVertexElement9 ADeclaration 
);
 ;
     
CreateScenarioObjects ();
 ;
     
DestroyScenarioObjects ();
 ;
     
FrameMove ();
 ;
     
FrameRender ();
 ;
     
FrameRenderAmbient ();
 ;
     
FrameRenderDirectLighting ();
 ;
                           
RenderMesh (const Iz3DEffect AEffect ,
const Tz3DModelMeshLOD ALOD = z3dmmlHigh ,
const Boolean ASetMaterial = True ,
const Boolean ADirectLighting = True 
);
 ;
       
LoadFromFile (const PWideChar AFileName 
);
 ;
       
SaveToFile (const PWideChar AFileName 
);
 ;

         /** \sa GetName For reading   \sa SetName For writing */
PWideChar Name; 

         /** \sa GetFileName For reading   \sa SetFileName For writing */
PWideChar FileName; 

       /** \sa GetVertexCount For reading*/
Integer VertexCount; 

       /** \sa GetBytesPerVertex For reading*/
Integer BytesPerVertex; 

       /** \sa GetFaceCount For reading*/
Integer FaceCount; 

    /*[const ALOD: Tz3DModelMeshLOD]*/   /** \sa GetLODFaceCount For reading*/
Integer LODFaceCount; 

    /*[const ALOD: Tz3DModelMeshLOD]*/   /** \sa GetLODVertexCount For reading*/
Integer LODVertexCount; 

         /** \sa GetShape For reading   \sa SetShape For writing */
Tz3DScenarioObjectShape Shape; 

       /** \sa GetMesh For reading*/
ID3DXMesh Mesh; 

       /** \sa GetLODMeshes For reading*/
Tz3DLODMeshes LODMeshes; 

         /** \sa GetComputeLightCoords For reading   \sa SetComputeLightCoords For writing */
Boolean ComputeLightCoords; 

       /** \sa GetBoundingSphere For reading*/
Iz3DBoundingSphere BoundingSphere; 

       /** \sa GetBoundingBox For reading*/
Iz3DBoundingBox BoundingBox; 

       /** \sa GetScale For reading*/
Iz3DFloat3 Scale; 

       /** \sa GetOSBoundingSphere For reading*/
Iz3DBoundingSphere OSBoundingSphere; 

       /** \sa GetOSBoundingBox For reading*/
Iz3DBoundingBox OSBoundingBox; 

         /** \sa GetLockAspectRatio For reading   \sa SetLockAspectRatio For writing */
Boolean LockAspectRatio; 

         /** \sa GetInstancingMethod For reading   \sa SetInstancingMethod For writing */
Tz3DModelInstancingMethod InstancingMethod; 

    /*[const I: Integer]*/   /** \sa GetSubsets For reading*/
Iz3DModelSubset Subsets; 

       /** \sa GetSubsetCount For reading*/
Integer SubsetCount; 

         /** \sa GetAutoGenerateTexCoords For reading   \sa SetAutoGenerateTexCoords For writing */
Boolean AutoGenerateTexCoords; 

         /** \sa GetLockTexCoordsAspectRatio For reading   \sa SetLockTexCoordsAspectRatio For writing */
Boolean LockTexCoordsAspectRatio; 

         /** \sa GetTexCoordsScale For reading   \sa SetTexCoordsScale For writing */
Single TexCoordsScale; 

    /*[const AIndex: Integer]*/   /** \sa GetInstance For reading*/
Iz3DModelInstance Instances; 

       /** \sa GetInstanceCount For reading*/
Integer InstanceCount; 

 };






/*==============================================================================*/ 
/*== Static model interface                                                   ==*/ 
/*==============================================================================*/ 
/*== Adds lightmap support for a model                                        ==*/ 
/*==============================================================================*/ 

   typedef interface Iz3DModelStaticInstance;

   class Iz3DStaticModel : public Iz3DModel
{
public:
['{CC3C2119-D831-4633-AAB9-1A4BA20B11C8}']
      
Iz3DModelStaticInstance CreateInstance ();
 ;
        
Boolean ProcessStaticLighting (const Tz3DModelLightMapProcessStage AStage 
);
 ;
 };








/*==============================================================================*/ 
/*== Dynamic model interface                                                  ==*/ 
/*==============================================================================*/ 
/*== Prepares the model for interacting with world phyiscs                    ==*/ 
/*==============================================================================*/ 

   typedef interface Iz3DModelDynamicInstance;

   class Iz3DDynamicModel : public Iz3DModel
{
public:
['{9E6B9217-B550-4592-83C5-946A31F0EAA1}']
      
Iz3DModelDynamicInstance CreateInstance ();
 ;
 };







/*==============================================================================*/ 
/*== Model isntance nterface                                                  ==*/ 
/*==============================================================================*/ 
/*== Implements a world object and represents a version of the model on       ==*/ 
/*== the world                                                                ==*/ 
/*==============================================================================*/ 

   class Iz3DModelInstance : public Iz3DScenarioObject
{
public:
['{3CD3FCD0-B296-4FD6-A336-0AD47CF3FC00}']
      
Tz3DModelMeshLOD GetMeshLOD ();
 ;
       
SetMeshLOD (const Tz3DModelMeshLOD Value 
);
 ;
      
Iz3DMatrix GetWorldMatrix ();
 ;
      
Iz3DModel GetModel ();
 ;
      
Boolean GetEnableShadows ();
 ;
      
Iz3DFloat3 GetLookAt ();
 ;
      
Iz3DFloat3 GetCenter ();
 ;
       
SetEnableShadows (const Boolean Value 
);
 ;
      
Boolean GetVisible ();
 ;
       
SetVisible (const Boolean Value 
);
 ;

     
ComputeTransforms ();
 ;
     
FrameMove ();
 ;
     
FrameRender ();
 ;
     
FrameRenderAmbient ();
 ;
     
FrameRenderDirectLighting ();
 ;
      
Boolean CurrentlyVisible ();
 ;

         /** \sa GetMeshLOD For reading   \sa SetMeshLOD For writing */
Tz3DModelMeshLOD MeshLOD; 

       /** \sa GetCenter For reading*/
Iz3DFloat3 Center; 

       /** \sa GetLookAt For reading*/
Iz3DFloat3 LookAt; 

         /** \sa GetEnableShadows For reading   \sa SetEnableShadows For writing */
Boolean EnableShadows; 

       /** \sa GetModel For reading*/
Iz3DModel Model; 

         /** \sa GetVisible For reading   \sa SetVisible For writing */
Boolean Visible; 

       /** \sa GetWorldMatrix For reading*/
Iz3DMatrix WorldMatrix; 

 };






/*==============================================================================*/ 
/*== Model static instance interface                                          ==*/ 
/*==============================================================================*/ 
/*== Prepares the model for rendering with static lighting using lightmaps    ==*/ 
/*== and radiosity                                                            ==*/ 
/*==============================================================================*/ 

   class Iz3DModelStaticInstance : public Iz3DModelInstance
{
public:
['{C7AD1B6C-DFCB-4DFB-A308-258AD09FDC89}']
      
Iz3DLightMap GetLightMap ();
 ;
        
Boolean ProcessStaticLighting (const Tz3DModelLightMapProcessStage AStage 
);
 ;
    
       /** \sa GetLightMap For reading*/
Iz3DLightMap LightMap; 

 };







/*==============================================================================*/ 
/*== Model dynamic instance interface                                         ==*/ 
/*==============================================================================*/ 
/*== Implements a world dynamic objects that interacts with world physics     ==*/ 
/*==============================================================================*/ 

   class Iz3DModelDynamicInstance : public Iz3DModelInstance
{
public:
['{4B03F4BD-637C-4F2A-AC04-ECCAB691379A}']
 };






// finished

