/*==============================================================================*/ 
/*== Zenith 3D Engine - Developed by Juan Pablo Ventoso                       ==*/ 
/*==============================================================================*/ 
/*== Unit: z3DComponents. Zenith engine components                            ==*/ 
/*==============================================================================*/ 






      
  


   enum Tz3DRenderAutoFormat
{
z3drafNone, 
z3drafRenderer, 
z3drafFP, 
z3drafShadowMap 
};






/*==============================================================================*/ 
/*== Effect interface                                                         ==*/ 
/*==============================================================================*/ 
/*== Implementation of vertex and pixel shaders using D3DX effect interface   ==*/ 
/*==============================================================================*/ 

   typedef TD3DXHandle Tz3DHandle;

   typedef interface Iz3DEffect;
   typedef interface Iz3DBaseTexture;

         typedef void (*Tz3DEffectRenderEvent)(const Iz3DEffect ASender ,
const Integer APass ,
const Integer ACount 
);
 ;

   class Iz3DEffect : public Iz3DLinked
{
public:
['{2A5B78FB-2F5A-4B15-8C72-D15C05561900}']
        
Iz3DFloat4 GetColor (const Tz3DHandle AParam 
);
 ;
        
Iz3DFloat3 GetColor3 (const Tz3DHandle AParam 
);
 ;
          
SetColor (const Tz3DHandle AParam ,
const Iz3DFloat4 Value 
);
 ;
          
SetColor3 (const Tz3DHandle AParam ,
const Iz3DFloat3 Value 
);
 ;
        
Iz3DBaseTexture GetTexture (const Tz3DHandle AParam 
);
 ;
          
SetTexture (const Tz3DHandle AParam ,
const Iz3DBaseTexture Value 
);
 ;
        
Iz3DMatrix GetMatrix (const Tz3DHandle AParam 
);
 ;
        
Iz3DFloat2 GetFloat2 (const Tz3DHandle AParam 
);
 ;
        
Iz3DFloat3 GetFloat3 (const Tz3DHandle AParam 
);
 ;
        
Iz3DFloat4 GetFloat4 (const Tz3DHandle AParam 
);
 ;
      
Tz3DBaseCallbackEvent GetOnCreate ();
 ;
       
SetOnCreate (const Tz3DBaseCallbackEvent Value 
);
 ;
          
SetMatrix (const Tz3DHandle AParam ,
const Iz3DMatrix Value 
);
 ;
          
SetFloat2 (const Tz3DHandle AParam ,
const Iz3DFloat2 Value 
);
 ;
          
SetFloat3 (const Tz3DHandle AParam ,
const Iz3DFloat3 Value 
);
 ;
          
SetFloat4 (const Tz3DHandle AParam ,
const Iz3DFloat4 Value 
);
 ;
      
Tz3DHandle GetTechnique ();
 ;
      
ID3DXEffect GetEffect ();
 ;
       
SetFileName (const PWideChar Value 
);
 ;
       
SetTechnique (const Tz3DHandle Value 
);
 ;
       
SetEnabled (const Boolean Value 
);
 ;
        
Variant GetParams (const Tz3DHandle AParam 
);
 ;
          
SetParams (const Tz3DHandle AParam ,
const Variant Value 
);
 ;
      
Boolean GetEnabled ();
 ;
      
PWideChar GetFileName ();
 ;
      
Tz3DEffectRenderEvent GetOnRender ();
 ;
       
SetOnRender (const Tz3DEffectRenderEvent Value 
);
 ;
     
CreateEffect ();
 ;
        
Boolean IsHandleValid (const Tz3DHandle AHandle 
);
 ;
             
SetPointer (const Tz3DHandle AParam ,
const Pointer AValue ,
const Integer ASize 
);
 ;
     
Render ();
 ;
       
BeginPass (const Integer APassIndex 
);
 ;
     
EndPass ();
 ;
     
Commit ();
 ;
          
Integer Run (const Cardinal AFlags = D3DXFX_DONOTSAVESTATE 
);
 ;
         
RunPostProcess (const Cardinal AFlags = D3DXFX_DONOTSAVESTATE 
);
 ;

       /** \sa GetEffect For reading*/
ID3DXEffect D3DXEffect; 

    /*[const AParam: Tz3DHandle]*/     /** \sa GetParams For reading   \sa SetParams For writing */
Variant Param; 

    /*[const AParam: Tz3DHandle]*/     /** \sa GetFloat2 For reading   \sa SetFloat2 For writing */
Iz3DFloat2 Float2; 

    /*[const AParam: Tz3DHandle]*/     /** \sa GetFloat3 For reading   \sa SetFloat3 For writing */
Iz3DFloat3 Float3; 

    /*[const AParam: Tz3DHandle]*/     /** \sa GetFloat4 For reading   \sa SetFloat4 For writing */
Iz3DFloat4 Float4; 

    /*[const AParam: Tz3DHandle]*/     /** \sa GetColor3 For reading   \sa SetColor3 For writing */
Iz3DFloat3 Color3; 

    /*[const AParam: Tz3DHandle]*/     /** \sa GetColor For reading   \sa SetColor For writing */
Iz3DFloat4 Color; 

    /*[const AParam: Tz3DHandle]*/     /** \sa GetMatrix For reading   \sa SetMatrix For writing */
Iz3DMatrix Matrix; 

    /*[const AParam: Tz3DHandle]*/     /** \sa GetTexture For reading   \sa SetTexture For writing */
Iz3DBaseTexture Texture; 

         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

         /** \sa GetFileName For reading   \sa SetFileName For writing */
PWideChar FileName; 

         /** \sa GetTechnique For reading   \sa SetTechnique For writing */
Tz3DHandle Technique; 


         /** \sa GetOnCreate For reading   \sa SetOnCreate For writing */
Tz3DBaseCallbackEvent OnCreate; 

         /** \sa GetOnRender For reading   \sa SetOnRender For writing */
Tz3DEffectRenderEvent OnRender; 

 };







/*==============================================================================*/ 
/*== Base texture interface                                                   ==*/ 
/*==============================================================================*/ 
/*== Common properties and methods from all kinds of textures                 ==*/ 
/*==============================================================================*/ 

   typedef interface Iz3DSurface;

   enum Tz3DTextureSource
{
z3dtsFileName, 
z3dtsNew 
};


   class Iz3DBaseTexture : public Iz3DLinked
{
public:
['{C7EF52D0-0802-4C73-AD12-94087D4BD1C9}']
      
Tz3DBaseCallbackEvent GetOnCreate ();
 ;
       
SetOnCreate (const Tz3DBaseCallbackEvent Value 
);
 ;
      
Boolean GetEnabled ();
 ;
       
SetEnabled (const Boolean Value 
);
 ;
      
Boolean GetAutoGenerateMipMaps ();
 ;
       
SetAutoGenerateMipMaps (const Boolean Value 
);
 ;
      
PWideChar GetFileName ();
 ;
      
Tz3DTextureSource GetSource ();
 ;
       
SetFileName (const PWideChar Value 
);
 ;
       
SetSource (const Tz3DTextureSource Value 
);
 ;
      
TD3DPool GetPool ();
 ;
       
SetPool (const TD3DPool Value 
);
 ;
      
DWord GetUsage ();
 ;
       
SetUsage (const DWord Value 
);
 ;
      
Integer GetLevelCount ();
 ;
      
IDirect3DBaseTexture9 GetD3DBaseTexture ();
 ;
       
SetD3DBaseTexture (const IDirect3DBaseTexture9 Value 
);
 ;
       
SetLevelCount (const Integer Value 
);
 ;
      
TD3DFormat GetFormat ();
 ;
       
SetFormat (const TD3DFormat Value 
);
 ;
        
Iz3DBaseTexture From (const IDirect3DBaseTexture9 ATexture 
);
 ;
       
SetRenderTexture (const Integer AIndex 
);
 ;
     
GenerateMipMaps ();
 ;
     
CreateD3DTexture ();
 ;

         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

         /** \sa GetD3DBaseTexture For reading   \sa SetD3DBaseTexture For writing */
IDirect3DBaseTexture9 D3DBaseTexture; 

         /** \sa GetLevelCount For reading   \sa SetLevelCount For writing */
Integer LevelCount; 

         /** \sa GetPool For reading   \sa SetPool For writing */
TD3DPool Pool; 

         /** \sa GetSource For reading   \sa SetSource For writing */
Tz3DTextureSource Source; 

         /** \sa GetFileName For reading   \sa SetFileName For writing */
PWideChar FileName; 

         /** \sa GetFormat For reading   \sa SetFormat For writing */
TD3DFormat Format; 

         /** \sa GetAutoGenerateMipMaps For reading   \sa SetAutoGenerateMipMaps For writing */
Boolean AutoGenerateMipMaps; 

         /** \sa GetUsage For reading   \sa SetUsage For writing */
DWord Usage; 


         /** \sa GetOnCreate For reading   \sa SetOnCreate For writing */
Tz3DBaseCallbackEvent OnCreate; 

 };







/*==============================================================================*/ 
/*== Texture interface                                                        ==*/ 
/*==============================================================================*/ 
/*== Basic 2D texture implementation                                          ==*/ 
/*==============================================================================*/ 

   class Iz3DTexture : public Iz3DBaseTexture
{
public:
['{A768B280-C0C5-414D-8C9A-25F7263426AF}']
       
SetD3DTexture (const IDirect3DTexture9 Value 
);
 ;
      
TD3DLockedRect GetLockedRect ();
 ;
      
IDirect3DTexture9 GetD3DTexture ();
 ;
      
TD3DFormat GetFormat ();
 ;
      
Integer GetHeight ();
 ;
      
Integer GetWidth ();
 ;
      
Iz3DSurface GetSurface ();
 ;
       
SetFormat (const TD3DFormat Value 
);
 ;
       
SetHeight (const Integer Value 
);
 ;
       
SetWidth (const Integer Value 
);
 ;
         -     -     -               
SetParams (const Integer AWidth = 1 ,
const Integer AHeight = 1 ,
const Integer ALevels = 1 ,
const TD3DFormat AFormat = D3DFMT_UNKNOWN ,
const TD3DPool APool = D3DPOOL_MANAGED 
);
 ;
              
BeginDraw (const Integer ALevel = 0 ,
const Cardinal AFlags = 0 
);
 ;
         
EndDraw (const Integer ALevel = 0 
);
 ;
         
Iz3DFloat4 GetPixel (const Integer AX ,
const Integer AY 
);
 ;
           
SetPixel (const Integer AX ,
const Integer AY ,
const Iz3DFloat3 AColor 
);
 ; ;
           
SetPixel (const Integer AX ,
const Integer AY ,
const Iz3DFloat4 AColor 
);
 ; ;
       
Fill (const Iz3DFloat4 AColor 
);
 ;

       /** \sa GetLockedRect For reading*/
TD3DLockedRect LockedRect; 

         /** \sa GetD3DTexture For reading   \sa SetD3DTexture For writing */
IDirect3DTexture9 D3DTexture; 

         /** \sa GetWidth For reading   \sa SetWidth For writing */
Integer Width; 

         /** \sa GetHeight For reading   \sa SetHeight For writing */
Integer Height; 

 };






/*==============================================================================*/ 
/*== Render texture interface                                                 ==*/ 
/*==============================================================================*/ 
/*== 2D texture that can be used as a render target                           ==*/ 
/*==============================================================================*/ 

   class Iz3DRenderTexture : public Iz3DTexture
{
public:
['{442A4B00-14EA-418E-B4CA-0E617F94E690}']
      
Tz3DRenderAutoFormat GetAutoFormat ();
 ;
       
SetAutoFormat (const Tz3DRenderAutoFormat Value 
);
 ;
      
Boolean GetAutoParams ();
 ;
      
Single GetAutoHeightFactor ();
 ;
      
Single GetAutoWidthFactor ();
 ;
       
SetAutoParams (const Boolean Value 
);
 ;
       
SetAutoHeightFactor (const Single Value 
);
 ;
       
SetAutoWidthFactor (const Single Value 
);
 ;

              
SetRenderTarget (const Integer AIndex = 0 ,
const Boolean ASave = False 
);
 ;
     
RestoreRenderTarget ();
 ;

         /** \sa GetAutoParams For reading   \sa SetAutoParams For writing */
Boolean AutoParams; 

         /** \sa GetAutoWidthFactor For reading   \sa SetAutoWidthFactor For writing */
Single AutoWidthFactor; 

         /** \sa GetAutoHeightFactor For reading   \sa SetAutoHeightFactor For writing */
Single AutoHeightFactor; 

         /** \sa GetAutoFormat For reading   \sa SetAutoFormat For writing */
Tz3DRenderAutoFormat AutoFormat; 

 };







/*==============================================================================*/ 
/*== Cube texture interface                                                   ==*/ 
/*==============================================================================*/ 
/*== Basic cube texture implementation                                        ==*/ 
/*==============================================================================*/ 

   class Iz3DCubeTexture : public Iz3DBaseTexture
{
public:
['{5AE5261D-6217-4E04-8DA5-17068EC2A933}']
      
IDirect3DCubeTexture9 GetD3DCubeTexture ();
 ;
        
Iz3DSurface GetSurface (const TD3DCubemapFaces AFace 
);
 ;
       
Fill (const Iz3DFloat4 AColor 
);
 ;
         -     -               
SetCubeParams (const Integer ASize = 1 ,
const Integer ALevels = 1 ,
const TD3DFormat AFormat = D3DFMT_UNKNOWN ,
const TD3DPool APool = D3DPOOL_MANAGED 
);
 ;

       /** \sa GetD3DCubeTexture For reading*/
IDirect3DCubeTexture9 D3DCubeTexture; 

 };






/*==============================================================================*/ 
/*== Cube render texture interface                                            ==*/ 
/*==============================================================================*/ 
/*== Cube texture that can be used as a render target                         ==*/ 
/*==============================================================================*/ 

   class Iz3DCubeRenderTexture : public Iz3DCubeTexture
{
public:
['{39F771B1-CEBC-403A-83AA-204D1AA81D8A}']
              
SetRenderTarget (const TD3DCubemapFaces AFace = D3DCUBEMAP_FACE_POSITIVE_X ,
const Boolean ASave = False 
);
 ;
     
RestoreRenderTarget ();
 ;
 };







/*==============================================================================*/ 
/*== Material texture interface                                               ==*/ 
/*==============================================================================*/ 
/*== Extension of the texture interface that stores or generates a normal map ==*/ 
/*==============================================================================*/ 

   class Iz3DMaterialTexture : public Iz3DTexture
{
public:
['{90967713-4355-4E8A-8DB9-19EC663C609C}']
      
Boolean GetAutoGenerateNormalMap ();
 ;
       
SetAutoGenerateNormalMap (const Boolean Value 
);
 ;
      
Boolean GetEnableNormalMap ();
 ;
      
Single GetNormalMapFactor ();
 ;
      
Iz3DTexture GetNormalMapTexture ();
 ;
       
SetEnableNormalMap (const Boolean Value 
);
 ;
       
SetNormalMapFactor (const Single Value 
);
 ;

     
GenerateNormalMap ();
 ;

       /** \sa GetNormalMapTexture For reading*/
Iz3DTexture NormalMapTexture; 

         /** \sa GetEnableNormalMap For reading   \sa SetEnableNormalMap For writing */
Boolean EnableNormalMap; 

         /** \sa GetAutoGenerateNormalMap For reading   \sa SetAutoGenerateNormalMap For writing */
Boolean AutoGenerateNormalMap; 

         /** \sa GetNormalMapFactor For reading   \sa SetNormalMapFactor For writing */
Single NormalMapFactor; 

 };







/*==============================================================================*/ 
/*== Surface interface                                                        ==*/ 
/*==============================================================================*/ 
/*== Implementation of all kinds of surfaces                                  ==*/ 
/*==============================================================================*/ 

   class Iz3DSurface : public Iz3DLinked
{
public:
['{A44A32D6-4959-483A-B02F-BBD3499350B2}']
      
Integer GetHeight ();
 ;
      
Integer GetWidth ();
 ;
      
IDirect3DSurface9 GetD3DSurface ();
 ;
       
SetD3DSurface (const IDirect3DSurface9 Value 
);
 ;
              
SetRenderTarget (const Integer AIndex = 0 ,
const Boolean ASave = False 
);
 ;
     
RestoreRenderTarget ();
 ;
        
Iz3DSurface From (const IDirect3DSurface9 ASurface 
);
 ; ;
        
Iz3DSurface From (const Iz3DSurface ASurface 
);
 ; ;
        
Iz3DSurface From (const Iz3DTexture ATexture 
);
 ; ;
         
BeginDraw (const Cardinal AFlags = 0 
);
 ;
     
EndDraw ();
 ;
         
Iz3DFloat4 GetPixel (const Integer AX ,
const Integer AY 
);
 ;
           
SetPixel (const Integer AX ,
const Integer AY ,
const Iz3DFloat3 AColor 
);
 ; ;
           
SetPixel (const Integer AX ,
const Integer AY ,
const Iz3DFloat4 AColor 
);
 ; ;

         /** \sa GetD3DSurface For reading   \sa SetD3DSurface For writing */
IDirect3DSurface9 D3DSurface; 

       /** \sa GetWidth For reading*/
Integer Width; 

       /** \sa GetHeight For reading*/
Integer Height; 

 };







/*==============================================================================*/ 
/*== Depth/stencil buffer interface                                           ==*/ 
/*==============================================================================*/ 
/*== Implementation of depth stencil surfaces for rendering                   ==*/ 
/*==============================================================================*/ 

   class Iz3DDepthBuffer : public Iz3DSurface
{
public:
['{273C8EBD-F429-4119-8DD9-5D1153FD9835}']
      
Tz3DBaseCallbackEvent GetOnCreate ();
 ;
       
SetOnCreate (const Tz3DBaseCallbackEvent Value 
);
 ;
      
Boolean GetDiscard ();
 ;
      
DWORD GetMSQuality ();
 ;
      
TD3DMultiSampleType GetMultiSample ();
 ;
       
SetDiscard (const Boolean Value 
);
 ;
       
SetMSQuality (const DWORD Value 
);
 ;
       
SetMultiSample (const TD3DMultiSampleType Value 
);
 ;
      
TD3DFormat GetFormat ();
 ;
      
Integer GetHeight ();
 ;
      
Integer GetWidth ();
 ;
       
SetFormat (const TD3DFormat Value 
);
 ;
       
SetHeight (const Integer Value 
);
 ;
       
SetWidth (const Integer Value 
);
 ;
         -     -                       
SetParams (const Integer AWidth = 1 ,
const Integer AHeight = 1 ,
const TD3DFormat AFormat = D3DFMT_UNKNOWN ,
const TD3DMultiSampleType AMultiSample = D3DMULTISAMPLE_NONE ,
const DWORD AMSQuality = 0 ,
const Boolean ADiscard = True 
);
 ;

         /** \sa GetWidth For reading   \sa SetWidth For writing */
Integer Width; 

         /** \sa GetHeight For reading   \sa SetHeight For writing */
Integer Height; 

         /** \sa GetFormat For reading   \sa SetFormat For writing */
TD3DFormat Format; 

         /** \sa GetMultiSample For reading   \sa SetMultiSample For writing */
TD3DMultiSampleType MultiSample; 

         /** \sa GetMSQuality For reading   \sa SetMSQuality For writing */
DWORD MSQuality; 

         /** \sa GetDiscard For reading   \sa SetDiscard For writing */
Boolean Discard; 


         /** \sa GetOnCreate For reading   \sa SetOnCreate For writing */
Tz3DBaseCallbackEvent OnCreate; 

 };







/*==============================================================================*/ 
/*== Vertex format interface                                                  ==*/ 
/*==============================================================================*/ 
/*== Stores a specific vertex format to be used with shaders                  ==*/ 
/*==============================================================================*/ 

   typedef interface Iz3DVertexFormat;

   enum Tz3DVertexElementFormat
{
z3dvefFloat, 
z3dvefFloat2, 
z3dvefFloat3, 
z3dvefFloat4, 
z3dvefColor, 
z3dvefUByte4, 
z3dvefShort2, 
z3dvefShort4, 
z3dvefUByte4N, 
z3dvefUByte2N, 
z3dvefShort2N, 
z3dvefShort4N, 
z3dvefUDec3, 
z3dvefDec3N, 
z3dvefFloat16_2, 
z3dvefFloat16_4, 
z3dvefUnused 
};


   enum Tz3DVertexElementMethod
{
z3dvemDefault, 
z3dvemPartialU, 
z3dvemPartialV, 
z3dvemCrossUV, 
z3dvemUV, 
z3dvemLookup, 
z3dvemLookupPresampled 
};


   enum Tz3DVertexElementUsage
{
z3dveuPosition, 
z3dveuBlendWeight, 
z3dveuBlendIndices, 
z3dveuNormal, 
z3dveuPSize, 
z3dveuTexCoord, 
z3dveuTangent, 
z3dveuBinormal, 
z3dveuTessFactor, 
z3dveuTransformedPosition, 
z3dveuColor, 
z3dveuFog, 
z3dveuDepth, 
z3dveuSample 
};


   class Iz3DVertexElement : public Iz3DBase
{
public:
['{EB3FC990-4240-4A43-AB36-AB446238A563}']
      
Tz3DVertexElementFormat GetFormat ();
 ;
      
Tz3DVertexElementMethod GetMethod ();
 ;
      
Integer GetStream ();
 ;
      
Tz3DVertexElementUsage GetUsage ();
 ;
      
Integer GetUsageIndex ();
 ;
       
SetFormat (const Tz3DVertexElementFormat Value 
);
 ;
       
SetMethod (const Tz3DVertexElementMethod Value 
);
 ;
       
SetStream (const Integer Value 
);
 ;
       
SetUsage (const Tz3DVertexElementUsage Value 
);
 ;
       
SetUsageIndex (const Integer Value 
);
 ;

         /** \sa GetStream For reading   \sa SetStream For writing */
Integer Stream; 

         /** \sa GetFormat For reading   \sa SetFormat For writing */
Tz3DVertexElementFormat Format; 

         /** \sa GetMethod For reading   \sa SetMethod For writing */
Tz3DVertexElementMethod Method; 

         /** \sa GetUsage For reading   \sa SetUsage For writing */
Tz3DVertexElementUsage Usage; 

         /** \sa GetUsageIndex For reading   \sa SetUsageIndex For writing */
Integer UsageIndex; 

 };


     typedef array<TD3DVertexElement9> TD3DVertexElement9Array;

   class Iz3DVertexFormat : public Iz3DLinked
{
public:
['{0E0D2431-9FC5-4E36-8160-84CB977F7A68}']
      
Tz3DBaseCallbackEvent GetOnCreate ();
 ;
       
SetOnCreate (const Tz3DBaseCallbackEvent Value 
);
 ;
      
Tz3DBaseObjectEvent GetOnChange ();
 ;
       
SetOnChange (const Tz3DBaseObjectEvent Value 
);
 ;
      
Integer GetVertexSize ();
 ;
      
Boolean GetUpdating ();
 ;
        
Iz3DVertexElement GetElement (const Integer AIndex 
);
 ;
      
Integer GetElementCount ();
 ;
          
SetElement (const Integer AIndex ,
const Iz3DVertexElement Value 
);
 ;

      
Iz3DVertexElement CreateElement ();
 ;
                                        
Iz3DVertexElement AddElement (const Integer AStream = 0 ,
const Tz3DVertexElementFormat AFormat = z3dvefFloat4 ,
const Tz3DVertexElementMethod AMethod = z3dvemDefault ,
const Tz3DVertexElementUsage AUsage = z3dveuPosition ,
const Integer AUsageIndex = 0 
);
 ;
       
RemoveElement (const Iz3DVertexElement AElement 
);
 ;
     
ClearElements ();
 ;
     
Apply ();
 ;
         
CreateD3DFormat (const Boolean AForce = False 
);
 ;
     
BeginUpdate ();
 ;
     
EndUpdate ();
 ;
      
PD3DVertexElement9 GetDeclaration ();
 ;

    /*[const AIndex: Integer]*/     /** \sa GetElement For reading   \sa SetElement For writing */
Iz3DVertexElement Elements; 

       /** \sa GetElementCount For reading*/
Integer ElementCount; 

       /** \sa GetUpdating For reading*/
Boolean Updating; 

       /** \sa GetVertexSize For reading*/
Integer VertexSize; 


         /** \sa GetOnCreate For reading   \sa SetOnCreate For writing */
Tz3DBaseCallbackEvent OnCreate; 

         /** \sa GetOnChange For reading   \sa SetOnChange For writing */
Tz3DBaseObjectEvent OnChange; 

 };







/*==============================================================================*/ 
/*== Vertex buffer interface                                                  ==*/ 
/*==============================================================================*/ 
/*== Manages an array of vertices with a specific format                      ==*/ 
/*==============================================================================*/ 

   enum Tz3DPrimitiveKind
{
z3dpkReserved, 
z3dpkPointList, 
z3dpkLineList, 
z3dpkLineStrip, 
z3dpkTriangleList, 
z3dpkTriangleStrip, 
z3dpkTriangleFan 
};



   class Iz3DVertexBuffer : public Iz3DLinked
{
public:
['{16B7E530-1117-4317-9E48-421BA30E8160}']
      
IDirect3DVertexBuffer9 GetD3DBuffer ();
 ;
      
Tz3DBaseCallbackEvent GetOnCreate ();
 ;
       
SetOnCreate (const Tz3DBaseCallbackEvent Value 
);
 ;
      
Integer GetPrimitiveCount ();
 ;
      
Tz3DPrimitiveKind GetPrimitiveKind ();
 ;
       
SetPrimitiveKind (const Tz3DPrimitiveKind Value 
);
 ;
      
Boolean GetUpdating ();
 ;
      
Iz3DVertexFormat GetFormat ();
 ;
      
TD3DPool GetPool ();
 ;
      
DWord GetUsage ();
 ;
      
Integer GetVertexCount ();
 ;
       
SetPool (const TD3DPool Value 
);
 ;
       
SetUsage (const DWord Value 
);
 ;
       
SetVertexCount (const Integer Value 
);
 ;

     
BeginUpdate ();
 ;
     
EndUpdate ();
 ;
          
Pointer Lock (const DWORD AFlags = 0 
);
 ;
     
Unlock ();
 ;
                      
SetParams (const Integer AVertexCount ,
const DWord AUsage = D3DUSAGE_WRITEONLY ,
const TD3DPool APool = D3DPOOL_MANAGED 
);
 ;
         
CreateD3DBuffer (const Boolean AForce = False 
);
 ;
     
Prepare ();
 ;
             -
Render (const Integer AStart = 0 ,
Integer ACount = 1 
);
 ; ;
                -
Render (const Iz3DEffect AEffect ,
const Integer AStart = 0 ,
Integer ACount = 1 
);
 ; ;

       /** \sa GetFormat For reading*/
Iz3DVertexFormat Format; 

         /** \sa GetUsage For reading   \sa SetUsage For writing */
DWord Usage; 

         /** \sa GetPool For reading   \sa SetPool For writing */
TD3DPool Pool; 

         /** \sa GetVertexCount For reading   \sa SetVertexCount For writing */
Integer VertexCount; 

       /** \sa GetPrimitiveCount For reading*/
Integer PrimitiveCount; 

       /** \sa GetUpdating For reading*/
Boolean Updating; 

         /** \sa GetPrimitiveKind For reading   \sa SetPrimitiveKind For writing */
Tz3DPrimitiveKind PrimitiveKind; 

       /** \sa GetD3DBuffer For reading*/
IDirect3DVertexBuffer9 D3DBuffer; 


         /** \sa GetOnCreate For reading   \sa SetOnCreate For writing */
Tz3DBaseCallbackEvent OnCreate; 

 };









    Integer Tz3DVertexElementFormatOffsets[999]= {4, 8, 12,
    16, 16, 0, 4, 8, 0, 0, 4, 8, 0, 0, 32, 64, 0}; /*!< [999] */




// finished

