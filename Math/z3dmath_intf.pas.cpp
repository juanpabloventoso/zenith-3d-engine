



   



  z3DPI:        const  Single =  3.141592654;


    typedef interface Iz3DMatrix;

   typedef interface Iz3DFloat2;
   typedef interface Iz3DFloat3;
   typedef interface Iz3DFloat4;

   class Iz3DMatrix : public Iz3DBase
{
public:
['{226F08EA-006F-4133-AA95-7E9E01BC171F}']
      
PD3DXMatrix GetPD3DMatrix ();
 ;
      
Single Get11 ();
 ;
      
Single Get12 ();
 ;
      
Single Get13 ();
 ;
      
Single Get14 ();
 ;
      
Single Get21 ();
 ;
      
Single Get22 ();
 ;
      
Single Get23 ();
 ;
      
Single Get24 ();
 ;
      
Single Get31 ();
 ;
      
Single Get32 ();
 ;
      
Single Get33 ();
 ;
      
Single Get34 ();
 ;
      
Single Get41 ();
 ;
      
Single Get42 ();
 ;
      
Single Get43 ();
 ;
      
Single Get44 ();
 ;
       
Set11 (const Single Value 
);
 ;
       
Set12 (const Single Value 
);
 ;
       
Set13 (const Single Value 
);
 ;
       
Set14 (const Single Value 
);
 ;
       
Set21 (const Single Value 
);
 ;
       
Set22 (const Single Value 
);
 ;
       
Set23 (const Single Value 
);
 ;
       
Set24 (const Single Value 
);
 ;
       
Set31 (const Single Value 
);
 ;
       
Set32 (const Single Value 
);
 ;
       
Set33 (const Single Value 
);
 ;
       
Set34 (const Single Value 
);
 ;
       
Set41 (const Single Value 
);
 ;
       
Set42 (const Single Value 
);
 ;
       
Set43 (const Single Value 
);
 ;
       
Set44 (const Single Value 
);
 ;
      
Tz3DBaseObjectEvent GetOnChange ();
 ;
       
SetOnChange (const Tz3DBaseObjectEvent Value 
);
 ;
      
TD3DXMatrix GetD3DMatrix ();
 ;
        
Iz3DMatrix Scale (const Iz3DFloat3 AScale 
);
 ;
       
SetD3DMatrix (const TD3DXMatrix Value 
);
 ;
        
Iz3DMatrix From (const Iz3DMatrix AMatrix 
);
 ; ;
        
Iz3DMatrix From (const TD3DXMatrix AMatrix 
);
 ; ;
         
Iz3DMatrix LookAt (const Iz3DFloat3 APosition ,
const Iz3DFloat3 ALookAt 
);
 ; ; ;
          
Iz3DMatrix LookAt (const Iz3DFloat3 APosition ,
const Iz3DFloat3 ALookAt ,
const Iz3DFloat3 AUp 
);
 ; ; ;
                       .01      
Iz3DMatrix PerspectiveFOV (const Single AAngle ,
const Single AAspect = 1 ,
const Single ANear = 0 ,
const Single AFar = 1000 
);
 ;
             .01           
Iz3DMatrix Ortho (const Single AWidth ,
const Single AHeight ,
const Single ANear = 0 ,
const Single AFar = 1000 
);
 ;
        
Iz3DMatrix Multiply (const Iz3DMatrix AMatrix 
);
 ; ; ;
        
Iz3DMatrix Multiply (const TD3DXMatrix AMatrix 
);
 ; ; ;
      
Iz3DMatrix Inverse ();
 ; ; ;
      
Iz3DMatrix Identity ();
 ;
        
Iz3DMatrix Inverse (const Iz3DMatrix AMatrix 
);
 ; ; ;
        
Iz3DMatrix Inverse (const TD3DXMatrix AMatrix 
);
 ; ; ;
          
Iz3DMatrix Translation (const Single AX ,
const Single AY ,
const Single AZ 
);
 ;
          
Iz3DMatrix RotateYPR (const Single AYaw ,
const Single APitch ,
const Single ARoll 
);
 ;
        
Iz3DMatrix RotateQuat (const TD3DXQuaternion AQuat 
);
 ;
        
Iz3DMatrix RotateX (const Single AAngle 
);
 ;
        
Iz3DMatrix RotateY (const Single AAngle 
);
 ;
        
Iz3DMatrix RotateZ (const Single AAngle 
);
 ;
    
         /** \sa GetOnChange For reading   \sa SetOnChange For writing */
Tz3DBaseObjectEvent OnChange; 

         /** \sa GetD3DMatrix For reading   \sa SetD3DMatrix For writing */
TD3DXMatrix D3DMatrix; 

       /** \sa GetPD3DMatrix For reading*/
PD3DXMatrix PD3DMatrix; 

         /** \sa Get11 For reading   \sa Set11 For writing */
Single e11; 

         /** \sa Get12 For reading   \sa Set12 For writing */
Single e12; 

         /** \sa Get13 For reading   \sa Set13 For writing */
Single e13; 

         /** \sa Get14 For reading   \sa Set14 For writing */
Single e14; 

         /** \sa Get21 For reading   \sa Set21 For writing */
Single e21; 

         /** \sa Get22 For reading   \sa Set22 For writing */
Single e22; 

         /** \sa Get23 For reading   \sa Set23 For writing */
Single e23; 

         /** \sa Get24 For reading   \sa Set24 For writing */
Single e24; 

         /** \sa Get31 For reading   \sa Set31 For writing */
Single e31; 

         /** \sa Get32 For reading   \sa Set32 For writing */
Single e32; 

         /** \sa Get33 For reading   \sa Set33 For writing */
Single e33; 

         /** \sa Get34 For reading   \sa Set34 For writing */
Single e34; 

         /** \sa Get41 For reading   \sa Set41 For writing */
Single e41; 

         /** \sa Get42 For reading   \sa Set42 For writing */
Single e42; 

         /** \sa Get43 For reading   \sa Set43 For writing */
Single e43; 

         /** \sa Get44 For reading   \sa Set44 For writing */
Single e44; 

 };





   class Iz3DFloat2 : public Iz3DBase
{
public:
['{95FE8DA8-6D8F-477F-A04F-C2A72B647301}']
      
Tz3DBaseObjectEvent GetOnChange ();
 ;
       
SetOnChange (const Tz3DBaseObjectEvent Value 
);
 ;
      
TD3DXVector2 GetXY ();
 ;
       
SetXY (const TD3DXVector2 Value 
);
 ;
      
Single GetX ();
 ;
      
Single GetY ();
 ;
       
SetX (const Single Value 
);
 ;
       
SetY (const Single Value 
);
 ;
        
Iz3DFloat2 From (const Iz3DFloat2 AVector 
);
 ; ;
        
Iz3DFloat2 From (const TD3DXVector2 AVector 
);
 ; ;
        
Iz3DFloat2 Add (const Iz3DFloat2 AVector 
);
 ; ;
        
Iz3DFloat2 Add (const TD3DXVector2 AVector 
);
 ; ;
        
Iz3DFloat2 Subtract (const Iz3DFloat2 AVector 
);
 ; ;
        
Iz3DFloat2 Subtract (const TD3DXVector2 AVector 
);
 ; ;
        
Iz3DFloat2 Scale (const Single AScale 
);
 ;
      
Iz3DFloat2 Negate ();
 ;
      
Iz3DFloat2 Saturate ();
 ;
      
Single Length ();
 ;
      
Single LengthSq ();
 ;
      
Iz3DFloat2 Normalize ();
 ;

         /** \sa GetOnChange For reading   \sa SetOnChange For writing */
Tz3DBaseObjectEvent OnChange; 

         /** \sa GetX For reading   \sa SetX For writing */
Single X; 

         /** \sa GetY For reading   \sa SetY For writing */
Single Y; 

         /** \sa GetXY For reading   \sa SetXY For writing */
TD3DXVector2 XY; 

         /** \sa GetX For reading   \sa SetX For writing */
Single R; 

         /** \sa GetY For reading   \sa SetY For writing */
Single G; 

         /** \sa GetXY For reading   \sa SetXY For writing */
TD3DXVector2 RG; 

 };





   class Iz3DFloat3 : public Iz3DBase
{
public:
['{A96DBC16-431E-4F9D-8746-645082C56EAC}']
      
TD3DColor GetD3DColor ();
 ;
      
TD3DColorValue GetD3DColorValue ();
 ;
      
Tz3DBaseObjectEvent GetOnChange ();
 ;
       
SetOnChange (const Tz3DBaseObjectEvent Value 
);
 ;
      
TD3DXVector2 GetXY ();
 ;
      
TD3DXVector2 GetXZ ();
 ;
      
TD3DXVector2 GetYZ ();
 ;
       
SetXY (const TD3DXVector2 Value 
);
 ;
       
SetXZ (const TD3DXVector2 Value 
);
 ;
      
Iz3DFloat3 Identity ();
 ;
       
SetYZ (const TD3DXVector2 Value 
);
 ;
      
Single GetX ();
 ;
      
TD3DXVector3 GetXYZ ();
 ;
      
Single GetY ();
 ;
      
Single GetZ ();
 ;
      
TD3DXVector4 GetRGBA ();
 ;
       
SetX (const Single Value 
);
 ;
       
SetXYZ (const TD3DXVector3 Value 
);
 ;
       
SetY (const Single Value 
);
 ;
       
SetZ (const Single Value 
);
 ;
      
Single Length ();
 ;
      
Single LengthSq ();
 ;
        
Iz3DFloat3 Add (const Iz3DFloat3 AVector 
);
 ; ;
        
Iz3DFloat3 Add (const TD3DXVector3 AVector 
);
 ; ;
        
Single Dot (const Iz3DFloat3 AVector 
);
 ;
        
Iz3DFloat3 Cross (const Iz3DFloat3 AVector 
);
 ;
        
Iz3DFloat3 Subtract (const Iz3DFloat3 AVector 
);
 ; ;
        
Iz3DFloat3 Subtract (const TD3DXVector3 AVector 
);
 ; ;
        
Iz3DFloat3 Scale (const Single AScale 
);
 ;
      
Iz3DFloat3 Negate ();
 ;
      
Iz3DFloat3 Saturate ();
 ;
        
Iz3DFloat3 TransformC (const Iz3DMatrix AMatrix 
);
 ;
        
Iz3DFloat3 TransformN (const Iz3DMatrix AMatrix 
);
 ;
      
Iz3DFloat3 Normalize ();
 ;
        
Iz3DFloat3 From (const Iz3DFloat3 AVector 
);
 ; ;
        
Iz3DFloat3 From (const TD3DXVector3 AVector 
);
 ; ;
        
Iz3DFloat3 From (const TD3DColorValue AColor 
);
 ; ;
     
BeginInternalChange ();
 ;
     
EndInternalChange ();
 ;

         /** \sa GetOnChange For reading   \sa SetOnChange For writing */
Tz3DBaseObjectEvent OnChange; 

       /** \sa GetD3DColor For reading*/
TD3DColor D3DColor; 

       /** \sa GetD3DColorValue For reading*/
TD3DColorValue D3DColorValue; 

         /** \sa GetX For reading   \sa SetX For writing */
Single X; 

         /** \sa GetY For reading   \sa SetY For writing */
Single Y; 

         /** \sa GetZ For reading   \sa SetZ For writing */
Single Z; 

         /** \sa GetXY For reading   \sa SetXY For writing */
TD3DXVector2 XY; 

         /** \sa GetXZ For reading   \sa SetXZ For writing */
TD3DXVector2 XZ; 

         /** \sa GetYZ For reading   \sa SetYZ For writing */
TD3DXVector2 YZ; 

         /** \sa GetXYZ For reading   \sa SetXYZ For writing */
TD3DXVector3 XYZ; 

         /** \sa GetX For reading   \sa SetX For writing */
Single R; 

         /** \sa GetY For reading   \sa SetY For writing */
Single G; 

         /** \sa GetZ For reading   \sa SetZ For writing */
Single B; 

         /** \sa GetXY For reading   \sa SetXY For writing */
TD3DXVector2 RG; 

         /** \sa GetXZ For reading   \sa SetXZ For writing */
TD3DXVector2 RB; 

         /** \sa GetYZ For reading   \sa SetYZ For writing */
TD3DXVector2 GB; 

         /** \sa GetXYZ For reading   \sa SetXYZ For writing */
TD3DXVector3 RGB; 

       /** \sa GetRGBA For reading*/
TD3DXVector4 RGBA; 

 };






   class Iz3DFloat4 : public Iz3DBase
{
public:
['{68C10FDF-C4B7-4662-8B09-392DB58F41D4}']
      
TD3DColor GetD3DColor ();
 ;
      
TD3DColorValue GetD3DColorValue ();
 ;
      
Tz3DBaseObjectEvent GetOnChange ();
 ;
       
SetOnChange (const Tz3DBaseObjectEvent Value 
);
 ;
      
TD3DXQuaternion GetD3DQuat ();
 ;
       
SetD3DQuat (const TD3DXQuaternion Value 
);
 ;
      
Single GetW ();
 ;
      
TD3DXVector3 GetXYW ();
 ;
      
TD3DXVector4 GetXYZW ();
 ;
      
TD3DXVector3 GetXZW ();
 ;
      
TD3DXVector3 GetYZW ();
 ;
       
SetW (const Single Value 
);
 ;
       
SetXYW (const TD3DXVector3 Value 
);
 ;
       
SetXYZW (const TD3DXVector4 Value 
);
 ;
       
SetXZW (const TD3DXVector3 Value 
);
 ;
       
SetYZW (const TD3DXVector3 Value 
);
 ;
      
TD3DXVector2 GetXY ();
 ;
      
TD3DXVector2 GetXZ ();
 ;
      
TD3DXVector2 GetYZ ();
 ;
       
SetXY (const TD3DXVector2 Value 
);
 ;
       
SetXZ (const TD3DXVector2 Value 
);
 ;
       
SetYZ (const TD3DXVector2 Value 
);
 ;
      
Single GetX ();
 ;
      
TD3DXVector3 GetXYZ ();
 ;
      
Single GetY ();
 ;
      
Single GetZ ();
 ;
       
SetX (const Single Value 
);
 ;
       
SetXYZ (const TD3DXVector3 Value 
);
 ;
       
SetY (const Single Value 
);
 ;
       
SetZ (const Single Value 
);
 ;
        
Iz3DFloat4 Add (const Iz3DFloat4 AVector 
);
 ; ;
        
Iz3DFloat4 Add (const TD3DXVector4 AVector 
);
 ; ;
        
Iz3DFloat4 Subtract (const Iz3DFloat4 AVector 
);
 ; ;
        
Iz3DFloat4 Multiply (const Iz3DFloat4 AVector 
);
 ;
        
Iz3DFloat4 Subtract (const TD3DXVector4 AVector 
);
 ; ;
        
Iz3DFloat4 Scale (const Single AScale 
);
 ;
      
Iz3DFloat4 Negate ();
 ;
      
Iz3DFloat4 Saturate ();
 ;
        
Iz3DFloat4 Transform (const Iz3DMatrix AMatrix 
);
 ;
      
Iz3DFloat4 Identity ();
 ;
        
Iz3DFloat4 RotationMatrix (const Iz3DMatrix AMatrix 
);
 ;
      
Iz3DFloat4 Normalize ();
 ;
        
Iz3DFloat4 From (const Iz3DFloat4 AVector 
);
 ; ;
        
Iz3DFloat4 From (const TD3DXVector4 AVector 
);
 ; ;
        
Iz3DFloat4 From (const TD3DColorValue AColor 
);
 ; ;
      
Single Length ();
 ;
      
Single LengthSq ();
 ;

         /** \sa GetD3DQuat For reading   \sa SetD3DQuat For writing */
TD3DXQuaternion D3DQuat; 

       /** \sa GetD3DColor For reading*/
TD3DColor D3DColor; 

       /** \sa GetD3DColorValue For reading*/
TD3DColorValue D3DColorValue; 

         /** \sa GetOnChange For reading   \sa SetOnChange For writing */
Tz3DBaseObjectEvent OnChange; 

         /** \sa GetX For reading   \sa SetX For writing */
Single X; 

         /** \sa GetY For reading   \sa SetY For writing */
Single Y; 

         /** \sa GetZ For reading   \sa SetZ For writing */
Single Z; 

         /** \sa GetW For reading   \sa SetW For writing */
Single W; 

         /** \sa GetXY For reading   \sa SetXY For writing */
TD3DXVector2 XY; 

         /** \sa GetXZ For reading   \sa SetXZ For writing */
TD3DXVector2 XZ; 

         /** \sa GetYZ For reading   \sa SetYZ For writing */
TD3DXVector2 YZ; 

         /** \sa GetXYZ For reading   \sa SetXYZ For writing */
TD3DXVector3 XYZ; 

         /** \sa GetXYW For reading   \sa SetXYW For writing */
TD3DXVector3 XYW; 

         /** \sa GetXZW For reading   \sa SetXZW For writing */
TD3DXVector3 XZW; 

         /** \sa GetYZW For reading   \sa SetYZW For writing */
TD3DXVector3 YZW; 

         /** \sa GetXYZW For reading   \sa SetXYZW For writing */
TD3DXVector4 XYZW; 

         /** \sa GetX For reading   \sa SetX For writing */
Single R; 

         /** \sa GetY For reading   \sa SetY For writing */
Single G; 

         /** \sa GetZ For reading   \sa SetZ For writing */
Single B; 

         /** \sa GetW For reading   \sa SetW For writing */
Single A; 

         /** \sa GetXY For reading   \sa SetXY For writing */
TD3DXVector2 RG; 

         /** \sa GetXZ For reading   \sa SetXZ For writing */
TD3DXVector2 RB; 

         /** \sa GetYZ For reading   \sa SetYZ For writing */
TD3DXVector2 GB; 

         /** \sa GetXYZ For reading   \sa SetXYZ For writing */
TD3DXVector3 RGB; 

         /** \sa GetXYZW For reading   \sa SetXYZW For writing */
TD3DXVector4 RGBA; 

         /** \sa GetXYW For reading   \sa SetXYW For writing */
TD3DXVector3 RGA; 

         /** \sa GetXZW For reading   \sa SetXZW For writing */
TD3DXVector3 RBA; 

         /** \sa GetYZW For reading   \sa SetYZW For writing */
TD3DXVector3 GBA; 

 };







   class Iz3DPlane : public Iz3DBase
{
public:
['{6D62675F-6538-48C5-9F61-2CD0FEA79FC0}']
      
Tz3DBaseObjectEvent GetOnChange ();
 ;
       
SetOnChange (const Tz3DBaseObjectEvent Value 
);
 ;
      
Single GetA ();
 ;
      
Single GetB ();
 ;
      
Single GetC ();
 ;
      
Single GetD ();
 ;
      
TD3DXPlane GetABCD ();
 ;
       
SetABCD (const TD3DXPlane Value 
);
 ;
       
SetA (const Single Value 
);
 ;
       
SetB (const Single Value 
);
 ;
       
SetC (const Single Value 
);
 ;
       
SetD (const Single Value 
);
 ;

        
Boolean Intersects (const Iz3DPlane APlane 
);

        
Boolean Included (const Iz3DPlane APlane 
);


         /** \sa GetOnChange For reading   \sa SetOnChange For writing */
Tz3DBaseObjectEvent OnChange; 

         /** \sa GetA For reading   \sa SetA For writing */
Single A; 

         /** \sa GetB For reading   \sa SetB For writing */
Single B; 

         /** \sa GetC For reading   \sa SetC For writing */
Single C; 

         /** \sa GetD For reading   \sa SetD For writing */
Single D; 

         /** \sa GetABCD For reading   \sa SetABCD For writing */
TD3DXPlane ABCD; 

 };




  
   typedef interface Iz3DBoundingSphere;

   class Iz3DBoundingBox : public Iz3DBase
{
public:
['{AE5A1947-DE52-4C85-AC97-3CEF5B60CB05}']
      
Iz3DFloat3 GetLowerLeft ();
 ;
      
Iz3DFloat3 GetUpperRight ();
 ;
      
Iz3DFloat3 GetDimensions ();
 ;
      
Iz3DFloat3 GetCenter ();
 ;

       
ComputeFromMesh (const ID3DXMesh AMesh 
);
 ;
        
Boolean Intersects (const Iz3DBoundingBox ABox 
);
 ; ;
        
Boolean Intersects (const Iz3DBoundingSphere ASphere 
);
 ; ;

       /** \sa GetCenter For reading*/
Iz3DFloat3 Center; 

       /** \sa GetLowerLeft For reading*/
Iz3DFloat3 LowerLeft; 

       /** \sa GetUpperRight For reading*/
Iz3DFloat3 UpperRight; 

       /** \sa GetDimensions For reading*/
Iz3DFloat3 Dimensions; 

 };





   class Iz3DBoundingSphere : public Iz3DBase
{
public:
['{8E182B3F-709B-4F24-A44D-A1C70DB65897}']
      
Iz3DFloat3 GetCenter ();
 ;
      
Single GetRadius ();
 ;
       
SetRadius (const Single Value 
);
 ;

       
ComputeFromMesh (const ID3DXMesh AMesh 
);
 ;
        
Boolean Intersects (const Iz3DBoundingBox ABox 
);
 ; ;
        
Boolean Intersects (const Iz3DBoundingSphere ASphere 
);
 ; ;

       /** \sa GetCenter For reading*/
Iz3DFloat3 Center; 

         /** \sa GetRadius For reading   \sa SetRadius For writing */
Single Radius; 

 };





// finished

