



    




/*==============================================================================*/ 
/*== XML format constants                                                     ==*/ 
/*==============================================================================*/ 



  // Application information XML file
              const  fsxmlAppInfo_Application =  "Application";
         const  fsxmlAppInfo_ApplicationTitle =  "Title";
      const  fsxmlAppInfo_ApplicationSubtitle =  "Subtitle";
     const  fsxmlAppInfo_ApplicationSceneKind =  "SceneKind";
            const  fsxmlAppInfo_LinkedModules =  "LinkedModules";
             const  fsxmlAppInfo_LinkedModule =  "LinkedModule";
         const  fsxmlAppInfo_LinkedModulePath =  "Path";


  // Basic XML file object

   class Iz3DXMLFile : public Iz3DBase
{
public:
['{FAD19268-85EB-4838-9170-D0F42489CD71}']
             
Variant Read (IXMLNode ANode ,
const PAnsiChar AName ,
const Variant ADefault 
);
 ;
            
Write (IXMLNode ANode ,
const PAnsiChar AName ,
const Variant AValue 
);
 ;
       
Load (const PWideChar AFileName 
);
 ;
         
Save (const PWideChar AFileName = nil 
);
 ;
 };


   class Iz3DXMLChild : public Iz3DBase
{
public:
['{0738F51F-6E28-4720-8AA2-711D3C680F54}']
             
Variant Read (IXMLNode ANode ,
const PAnsiChar AName ,
const Variant ADefault 
);
 ;
            
Write (IXMLNode ANode ,
const PAnsiChar AName ,
const Variant AValue 
);
 ;
 };


  // Application information XML object

   typedef interface Iz3DXMLAppInfoFile;

   enum Tz3DApplicationSceneKind
{
z3dask3D, 
z3dask2D, 
z3daskNonDraw 
};


   typedef interface Iz3DXMLAppInfoLinkedModule;

   class Iz3DXMLAppInfoFile : public Iz3DXMLFile
{
public:
['{9EB045EE-0193-48F9-AF8D-33360C1F80B1}']
      
Integer GetLinkedModuleCount ();
 ;
        
Iz3DXMLAppInfoLinkedModule GetLinkedModules (const Integer AIndex 
);
 ;
      
Tz3DApplicationSceneKind GetSceneKind ();
 ;
      
PWideChar GetSubtitle ();
 ;
      
PWideChar GetTitle ();
 ;
       
SetSceneKind (const Tz3DApplicationSceneKind Value 
);
 ;
       
SetSubtitle (const PWideChar Value 
);
 ;
       
SetTitle (const PWideChar Value 
);
 ;
      
Iz3DXMLAppInfoLinkedModule AddLinkedModule ();
 ;
       
DeleteLinkedModule (const Integer AIndex 
);
 ;
     
DeleteLinkedModules ();
 ;
    
         /** \sa GetTitle For reading   \sa SetTitle For writing */
PWideChar Title; 

         /** \sa GetSubtitle For reading   \sa SetSubtitle For writing */
PWideChar Subtitle; 

         /** \sa GetSceneKind For reading   \sa SetSceneKind For writing */
Tz3DApplicationSceneKind SceneKind; 

       /** \sa GetLinkedModuleCount For reading*/
Integer LinkedModuleCount; 

    /*[const AIndex: Integer]*/   /** \sa GetLinkedModules For reading*/
Iz3DXMLAppInfoLinkedModule LinkedModules; 

 };


   class Iz3DXMLAppInfoLinkedModule : public Iz3DXMLChild
{
public:
['{8450E578-BC7E-45B4-943C-2E981956397E}']
      
PWideChar GetPath ();
 ;
       
SetPath (const PWideChar Value 
);
 ;
    
         /** \sa GetPath For reading   \sa SetPath For writing */
PWideChar Path; 

 };





/*==============================================================================*/ 
/*== z3D format stream                                                        ==*/ 
/*==============================================================================*/ 



   class Iz3DObjectFile : public Iz3DBase
{
public:
['{9837C505-CEE9-4353-B4CA-A22E651915D0}']
      
Int64 GetPosition ();
 ;
       
SetPosition (const Int64 Pos 
);
 ;
      
Int64 GetSize ();
 ;
       
SetSize64 (const Int64 NewSize 
);
 ;

         
Longint ReadUnknown ( &Buffer ,
Longint &Count 
);
 ;
       
ReadFloat3 (const Iz3DFloat3 AValue 
);
 ;
       
ReadFloat4 (const Iz3DFloat4 AValue 
);
 ;
      
PWideChar ReadString ();
 ;
      
Integer ReadInteger ();
 ;
      
Single ReadFloat ();
 ;
      
Boolean ReadBoolean ();
 ;

        
WriteUnknown (const  Buffer ,
const Longint Count 
);
 ;
       
WriteFloat3 (const Iz3DFloat3 AValue 
);
 ;
       
WriteFloat4 (const Iz3DFloat4 AValue 
);
 ;
       
WriteVariant (const Variant AValue 
);
 ;
       
WriteString (const PWideChar AValue 
);
 ;

         /** \sa GetPosition For reading   \sa SetPosition For writing */
Int64 Position; 

         /** \sa GetSize For reading   \sa SetSize64 For writing */
Int64 Size; 

 };





  
/*==============================================================================*/ 
/*== z3D file format interface                                                ==*/ 
/*==============================================================================*/ 
/*== Interface that controls a specific format for the z3D file system. Saves ==*/ 
/*== de properties of a custom format                                         ==*/ 
/*==============================================================================*/ 

   class Iz3DObjectFileFormat : public Iz3DBase
{
public:
['{29156A84-B6DB-4B6C-B893-C4640F2951D6}']
      
PWideChar GetDescription ();
 ;
      
PWideChar GetExtension ();
 ;
      
PWideChar GetDefaultFolder ();
 ;
       
SetDescription (const PWideChar Value 
);
 ;
       
SetExtension (const PWideChar Value 
);
 ;
       
SetDefaultFolder (const PWideChar Value 
);
 ;
      
PWideChar GetHeader ();
 ;
       
SetHeader (const PWideChar Value 
);
 ;

        
Expand (const PWideChar ASource ,
const PWideChar ADest 
);
 ;

         /** \sa GetDescription For reading   \sa SetDescription For writing */
PWideChar Description; 

         /** \sa GetExtension For reading   \sa SetExtension For writing */
PWideChar Extension; 

         /** \sa GetDefaultFolder For reading   \sa SetDefaultFolder For writing */
PWideChar DefaultFolder; 

         /** \sa GetHeader For reading   \sa SetHeader For writing */
PWideChar Header; 

 };







/*==============================================================================*/ 
/*== z3D typed object file interface                                          ==*/ 
/*==============================================================================*/ 
/*== Implements the Iz3DObjectFile interface and extends its functionality to ==*/ 
/*== a typed file with a specific format                                      ==*/ 
/*==============================================================================*/ 

   class Iz3DTypedObjectFile : public Iz3DObjectFile
{
public:
['{3693F04D-3EED-4CF5-A93E-B9D71D0F641F}']
      
PWideChar GetFileName ();
 ;
      
Iz3DObjectFileFormat GetFormat ();
 ;

       /** \sa GetFormat For reading*/
Iz3DObjectFileFormat Format; 

       /** \sa GetFileName For reading*/
PWideChar FileName; 

 };






/*==============================================================================*/ 
/*== z3D file system controller                                               ==*/ 
/*==============================================================================*/ 
/*== Global controller for the z3D file system. Manages all files and folders ==*/ 
/*== used by the z3D engine and its applications to run                       ==*/ 
/*==============================================================================*/ 

/*==============================================================================*/ 
/*== Folder and file structure                                                ==*/ 
/*==============================================================================*/ 



   const  fsPathDiv =  "\";
   const  fsFileDiv =  ".";

      const  fsPackExt =  "z3DPack";
       const  fsXMLExt =  "xml";
       const  fsICOExt =  "ico";

       const  fsPrefix =  "fs_";

              const  fsEngineCorePath =  fsPrefix+"EngineCore";
               const  fsEngineResPath =  fsPrefix+"EngineRes";
               const  fsCommonResPath =  fsPrefix+"Common";
                  const  fsBufferPath =  fsPrefix+"Buffer";

             const  fsMaterialsFolder =  "Materials";
      const  fsMaterialTexturesFolder =  fsMaterialsFolder+fsPathDiv+"Textures";
        const  fsMaterialSoundsFolder =  fsMaterialsFolder+fsPathDiv+"Sounds";
                 const  fsSkiesFolder =  "Skies";
           const  fsSkyTexturesFolder =  fsSkiesFolder+fsPathDiv+"Textures";
                const  fsModelsFolder =  "Models";
                const  fsLightsFolder =  "Lights";


           const  fsEngineCoreResFile =  fsEngineResPath+fsPathDiv+"Core"+fsFileDiv+fsPackExt;

        const  fsCoreResFile_z3DTheme =  "z3DTheme.wav";
     const  fsCoreResFile_z3DAVIIntro =  "z3DIntro.avi";
          const  fsCoreResFile_z3DGUI =  "z3DGUI.dds";
      const  fsCoreResFile_LightGlow1 =  "LightGlow1.dds";

                 const  fsAppInfoFile =  fsPrefix+"AppInfo"+fsFileDiv+fsXMLExt;
                 const  fsAppIconFile =  fsPrefix+"AppIcon"+fsFileDiv+fsICOExt;


   enum Tz3DFileType
{
z3dftMaterial, 
z3dftMaterialTexture, 
z3dftMaterialSound, 
z3dftModel, 
z3dftSky, 
z3dftSkyTexture 
};


   class Iz3DFileSystemController : public Iz3DBase
{
public:
['{04CCB426-C930-44B2-A187-AC64C8AB630C}']
      
PWideChar GetRootPath ();
 ;
       
SetRootPath (const PWideChar Value 
);
 ;
        
Iz3DObjectFileFormat GetObjectFormats (const Integer AIndex 
);
 ;

        
PWideChar GetFullPath (const PWideChar APath 
);
 ;
        
Decrypt (const PWideChar APack ,
const PWideChar AFiles 
);
 ;
        
DecryptF (const PWideChar APack ,
const PWideChar AFiles 
);
 ;
        
Crypt (const PWideChar APack ,
const PWideChar AFiles 
);
 ;
        
CryptF (const PWideChar APack ,
const PWideChar AFiles 
);
 ;
       
Delete (const PWideChar AFile 
);
 ;
     
FreeBuffer ();
 ;

      
Iz3DXMLFile CreateXMLFile ();
 ;
      
Iz3DXMLAppInfoFile CreateAppInfoFile ();
 ;
           
Iz3DObjectFile CreateObjectFile (const PWideChar AFileName ,
const Word AMode 
);
 ;
                   
Iz3DTypedObjectFile CreateTypedObjectFile (const PWideChar AFileName ,
const Word AMode ,
const Iz3DObjectFileFormat AFormat 
);
 ;
      
Iz3DObjectFileFormat CreateObjectFormat ();
 ;

         /** \sa GetRootPath For reading   \sa SetRootPath For writing */
PWideChar RootPath; 

    /*[const AIndex: Integer]*/   /** \sa GetObjectFormats For reading*/
Iz3DObjectFileFormat ObjectFormats; 

 };




// finished

