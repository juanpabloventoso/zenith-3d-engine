




       

#ifndef  FPC


  // BUG in Borland's translation
   typedef TCandidateList* PCandidateList;

  
   struct tagCANDIDATELIST
{

      DWORD dwSize; 

      DWORD dwStyle; 

      DWORD dwCount; 

      DWORD dwSelection; 

      DWORD dwPageStart; 

      DWORD dwPageSize; 

     DWORD dwOffset[0]; /*!< [0..0] */

 };

   typedef tagCANDIDATELIST TCandidateList;
  
   typedef tagCANDIDATELIST CANDIDATELIST;

#endif




  // IME composition
   const  IMM32_DLLNAME =  "\imm32.dll";
     const  VER_DLLNAME =  "\version.dll";
    const  MAX_CANDLIST =  10;
   const  MAX_COMPSTRING_SIZE =  256;

#ifdef  FPC

   const  SPI_GETWHEELSCROLLLINES =  104;

#endif



     const Double GTimeRefresh = 0; 



   typedef interface Iz3DProgressDialog;
   typedef interface Iz3DMainMenuDialog;
   typedef interface Iz3DGUIController;
   typedef interface Iz3DDesktop;
   typedef interface Iz3DDialog;
   typedef interface Iz3DControl;
   typedef interface Iz3DButton;
   typedef interface Iz3DLabel;
   typedef interface Iz3DCheckBox;
   typedef interface Iz3DRadioButton;
   typedef interface Iz3DComboBox;
   typedef interface Iz3DTrackBar;
   typedef interface Iz3DEdit;
   typedef interface Iz3DIMEEditBox;
   typedef interface Iz3DListBox;
   typedef interface Iz3DScrollBar;
   typedef interface Iz3DProgressBar;
   typedef interface Iz3DDisplay;
   typedef interface Iz3DConsoleDialog;

   typedef Iz3DControl* PIz3DControl;

   typedef Iz3DButton* PIz3DButton;

   typedef Iz3DLabel* PIz3DLabel;

   typedef Iz3DCheckBox* PIz3DCheckBox;

   typedef Iz3DRadioButton* PIz3DRadioButton;

   typedef Iz3DComboBox* PIz3DComboBox;

   typedef Iz3DListBox* PIz3DListBox;

   typedef Iz3DTrackBar* PIz3DTrackBar;

   typedef Iz3DEdit* PIz3DEdit;

   typedef Iz3DIMEEditBox* PIz3DIMEEditBox;

   typedef Iz3DDisplay* PIz3DDisplay;


  // Control types
   enum Tz3DControlType
{
z3dctButton, 
z3dctLabel, 
z3dctCheckBox, 
z3dctRadioButton, 
z3dctComboBox, 
z3dctTrackBar, 
z3dctEdit, 
z3dctIMEEdit, 
z3dctListBox, 
z3dctScrollBar, 
z3dctProgressBar 
};


   enum Tz3DControlEvent
{
z3dceButtonClick, 
z3dceComboBoxChange, 
z3dceRadioButtonChange, 
z3dcrCheckBoxChange, 
z3dceTrackBarChange, 
z3dceEditString, 
z3dceEditChange, 
z3dceListBoxDblClick, 
z3dceListBoxBeginSelect, 
z3dceListBoxEndSelect 
};


                 typedef void (*PCallbackz3DGUIEvent)(const Tz3DControlEvent AEvent ,
const Integer AControlID ,
const Iz3DControl AControl ,
const Pointer AUserContext 
);
 ;

  // Control states
   enum Tz3DControlState
{
z3dcsNormal, 
z3dcsDisabled, 
z3dcsHidden, 
z3dcsFocus, 
z3dcsMouseOver, 
z3dcsPressed 
};


   typedef Tz3DBlendColorStates* Pz3DBlendColorStates;

   ()() TD3DColor Tz3DBlendColorStates[999]; /*!< [999..999..999..999] */


   enum Tz3DDialogModalResult
{
z3dmdkNone, 
z3dmdkOk, 
z3dmdkYes, 
z3dmdkNo, 
z3dmdkCancel 
};


   class Iz3DBlendColor : public Iz3DBase
{
public:
['{1908CA94-BA3E-4E94-9FD3-9B9F43FB7844}']
       
SetCurrent (const TD3DXColor Value 
);
 ;
      
Pz3DBlendColorStates GetStates ();
 ;
       
SetStates (const Pz3DBlendColorStates Value 
);
 ;
      
TD3DXColor GetCurrent ();
 ;
          $    
SetColors (TD3DColor defaultColor ,
TD3DColor disabledColor = C8808080 ,
TD3DColor hiddenColor = 0 
);
 ;
          .7
Blend (Tz3DControlState iState ,
Single fRate = 0 
);
 ;
    
         /** \sa GetCurrent For reading   \sa SetCurrent For writing */
TD3DXColor Current; 

         /** \sa GetStates For reading   \sa SetStates For writing */
Pz3DBlendColorStates States; 

 };


  // Shared resources information
   typedef Tz3DTextureNode* Pz3DTextureNode;

   struct Tz3DTextureNode
{

      Boolean FileSource; 

      HMODULE ResourceModule; 

      Integer ResourceID; 

     WideChar FileName[-1]; /*!< [0..999..-1] */

      IDirect3DTexture9 Texture; 

      DWORD Width; 

      DWORD Height; 

 };


   typedef Tz3DFontNode* Pz3DFontNode;

   struct Tz3DFontNode
{

     WideChar Name[-1]; /*!< [0..999..-1] */

      ID3DXFont Font; 

      Longint Height; 

      Longint Weight; 

 };


  // Display information for a control
   typedef Tz3DDisplayHolder* Pz3DDisplayHolder;

   struct Tz3DDisplayHolder
{

      Tz3DControlType ControlType; 

      LongWord DisplayIndex; 

      Iz3DDisplay Display; 

 };


   enum Tz3DFontFormat
{
z3dffBottom, 
z3dffCenter, 
z3dffEndEllipsis, 
z3dffPathEllipsis, 
z3dffExpandTabs, 
z3dffExternalLeading, 
z3dffLeft, 
z3dffModifyString, 
z3dffNoClip, 
z3dffNoPrefix, 
z3dffRight, 
z3dffRTLReading, 
z3dffSingleLine, 
z3dffTabStop, 
z3dffTop, 
z3dffVerticalCenter, 
z3dffWordBreak 
};


     typedef set<Tz3DFontFormat> Tz3DFontFormats;

   class Iz3DGUIController : public Iz3DBase
{
public:
['{650E7A3D-3C4F-4A29-8394-4FB89AD80C2B}']
      
Integer GetTextureNodeCount ();
 ;
      
Integer GetFontsCount ();
 ;
      
Boolean GetModalMode ();
 ;
       
SetModalMode (const Boolean Value 
);
 ;
      
Iz3DDesktop GetDesktop ();
 ;
        
Iz3DDialog GetDialogs (const Integer I 
);
 ;
      
Integer GetDialogCount ();
 ;
      
ID3DXSprite GetSprite ();
 ;
       
Pz3DFontNode GetFonts (Integer iIndex 
);
 ;
       
Pz3DTextureNode GetTextureNode (Integer iIndex 
);
 ;
       
HRESULT CreateFont (LongWord index 
);
 ;
          
Integer AddFont (PWideChar strFaceName ,
Longint height ,
Longint weight 
);
 ;
       
Integer AddTexture (PWideChar strFilename 
);
 ; ;
      
IDirect3DStateBlock9 GetStateBlock ();
 ;
         
Integer AddTexture (PWideChar strResourceName ,
HMODULE hResourceModule 
);
 ; ;
       
Boolean RegisterDialog (Iz3DDialog pDialog 
);
 ;
        
Integer IndexOf (const Iz3DDialog ADialog 
);
 ;
       
BringToFront (const Iz3DDialog ADialog 
);
 ;
      
UnregisterDialog (Iz3DDialog pDialog 
);
 ;
     
EnableKeyboardInputForAllDialogs ();
 ;
       
CreateScenarioObjects (const Boolean AResetDevice 
);
 ;
       
DestroyScenarioObjects (const Boolean ALostDevice 
);
 ;
                                
Message (const HWND AWnd ,
const Cardinal AMsg ,
const Integer AwParam ,
const Integer AlParam ,
Boolean &ADefault ,
Integer &AResult 
);
 ;
     
GUIRender ();
 ;

         /** \sa GetModalMode For reading   \sa SetModalMode For writing */
Boolean ModalMode; 

    /*[i: Integer]*/   /** \sa GetFonts For reading*/
Pz3DFontNode Fonts; 

       /** \sa GetFontsCount For reading*/
Integer FontsCount; 

    /*[i: Integer]*/   /** \sa GetTextureNode For reading*/
Pz3DTextureNode TextureNode; 

       /** \sa GetTextureNodeCount For reading*/
Integer TextureNodeCount; 

       /** \sa GetSprite For reading*/
ID3DXSprite Sprite; 

       /** \sa GetDialogCount For reading*/
Integer DialogCount; 

    /*[const I: Integer]*/   /** \sa GetDialogs For reading*/
Iz3DDialog Dialogs; 

       /** \sa GetDesktop For reading*/
Iz3DDesktop Desktop; 

 };


   class Iz3DGUIFont : public Iz3DBase
{
public:
['{C32C8C8D-2938-4E46-8DB0-1BB6B90C50EF}']
      
Iz3DFloat4 GetColor ();
 ;
      
DWORD GetFormat ();
 ;
      
PWideChar GetName ();
 ;
      
Boolean GetShadow ();
 ;
      
Integer GetSize ();
 ;
       
SetFormat (const DWORD Value 
);
 ;
       
SetShadow (const Boolean Value 
);
 ;
       
SetSize (const Integer Value 
);
 ;
    
       /** \sa GetName For reading*/
PWideChar Name; 

         /** \sa GetSize For reading   \sa SetSize For writing */
Integer Size; 

       /** \sa GetColor For reading*/
Iz3DFloat4 Color; 

         /** \sa GetShadow For reading   \sa SetShadow For writing */
Boolean Shadow; 

         /** \sa GetFormat For reading   \sa SetFormat For writing */
DWORD Format; 

 };


   class Iz3DDesktopThemeSettings : public Iz3DBase
{
public:
['{BE9799CB-5FAE-481B-814C-B94F99001C15}']
      
Integer GetCaptionHeight ();
 ;
       
SetCaptionHeight (const Integer Value 
);
 ;
      
Iz3DGUIFont GetCheckBoxFont ();
 ;
      
Iz3DGUIFont GetDefaultFont ();
 ;
      
Iz3DFloat4 GetDialogColorBL ();
 ;
      
Iz3DFloat4 GetDialogColorBR ();
 ;
      
Iz3DFloat4 GetDialogColorTL ();
 ;
      
Iz3DFloat4 GetDialogColorTR ();
 ;
      
Iz3DGUIFont GetRadioButtonFont ();
 ;
    
       /** \sa GetDialogColorTL For reading*/
Iz3DFloat4 DialogColorTL; 

       /** \sa GetDialogColorTR For reading*/
Iz3DFloat4 DialogColorTR; 

       /** \sa GetDialogColorBL For reading*/
Iz3DFloat4 DialogColorBL; 

       /** \sa GetDialogColorBR For reading*/
Iz3DFloat4 DialogColorBR; 

         /** \sa GetCaptionHeight For reading   \sa SetCaptionHeight For writing */
Integer CaptionHeight; 

       /** \sa GetDefaultFont For reading*/
Iz3DGUIFont DefaultFont; 

       /** \sa GetCheckBoxFont For reading*/
Iz3DGUIFont CheckBoxFont; 

       /** \sa GetRadioButtonFont For reading*/
Iz3DGUIFont RadioButtonFont; 

 };


   enum Tz3DMessageDialogKind
{
z3dmdkInformation, 
z3dmdkWarning, 
z3dmdkError, 
z3dmdkConfirmation, 
z3dmdkConfirmationCancel 
};



   class Iz3DDesktop : public Iz3DBase
{
public:
['{2429E2CF-1264-4038-8F41-55C4D1A9FF5C}']
      
Boolean GetVisible ();
 ;
       
SetVisible (const Boolean Value 
);
 ;
      
Iz3DProgressDialog GetProgressDialog ();
 ;
      
Iz3DDesktopThemeSettings GetThemeSettings ();
 ;
      
Iz3DGUIController GetGUIController ();
 ;
      
Boolean GetBlurWallpaper ();
 ;
       
SetBlurWallpaper (const Boolean Value 
);
 ;
      
Iz3DTexture GetWallpaper ();
 ;
     
RenderEngineLogo ();
 ;
       
BringToFront (const Iz3DDialog ADialog 
);
 ;
         
         
Tz3DDialogModalResult ShowMessage (const PWideChar AMessage ,
const Tz3DMessageDialogKind AKind = z3dmdkInformation 
);
 ;
     
StartScenario ();
 ;
    
      
Iz3DDialog CreateDialog ();
 ;
      
Iz3DProgressDialog CreateProgressDialog ();
 ;
      
Iz3DMainMenuDialog CreateMainMenuDialog ();
 ;
      
Iz3DConsoleDialog CreateConsoleDialog ();
 ;

         /** \sa GetVisible For reading   \sa SetVisible For writing */
Boolean Visible; 

       /** \sa GetWallpaper For reading*/
Iz3DTexture Wallpaper; 

         /** \sa GetBlurWallpaper For reading   \sa SetBlurWallpaper For writing */
Boolean BlurWallpaper; 

       /** \sa GetProgressDialog For reading*/
Iz3DProgressDialog ProgressDialog; 

       /** \sa GetGUIController For reading*/
Iz3DGUIController Controller; 

       /** \sa GetThemeSettings For reading*/
Iz3DDesktopThemeSettings ThemeSettings; 

 };


   class Iz3DTextHelper : public Iz3DBase
{
public:
['{94A80185-A2E5-4E2B-8EC7-9C3C93595909}']
       
SetInsertionPos (Integer x ,
Integer y 
);
 ;
      
SetForegroundColor (TD3DXColor clr 
);
 ;
     
BeginRender ();
 ;
           
HRESULT DrawFormattedTextLine (const PWideChar strMsg ,
const *args 
);
 ; ;
    #ifndef  FPC

           
HRESULT DrawFormattedTextLine (const WideString strMsg ,
const *args 
);
 ; ;
    #endif

    #ifndef  FPC

        
HRESULT DrawTextLine (const PAnsiChar strMsg 
);
 ; ;
    #endif

        
HRESULT DrawTextLine (const PWideChar strMsg 
);
 ; ;
    #ifdef  BORLAND
#ifndef  COMPILER6_UP

        
HRESULT DrawTextLine (const String strMsg 
);
 ; ;
    #endif
#endif

                     
HRESULT DrawFormattedTextLine (const TRect rc ,
DWORD dwFlags ,
const PWideChar strMsg ,
const *args 
);
 ; ;
             
HRESULT DrawTextLine (const TRect rc ,
DWORD dwFlags ,
const PWideChar strMsg 
);
 ; ;
     
EndRender ();
 ;
 };


  // Display properties for subcontrols
   class Iz3DDisplay : public Iz3DBase
{
public:
['{61E20156-962D-48BC-B01A-EE81C72CCEB7}']
      
LongWord GetTexture ();
 ;
      
Iz3DBlendColor GetFontColor ();
 ;
      
TRect GetTextureRect ();
 ;
      
Iz3DBlendColor GetTextureColor ();
 ;
       
SetFontColor (const Iz3DBlendColor Value 
);
 ;
       
SetTextureColor (const Iz3DBlendColor Value 
);
 ;
       
SetTextFormat (const DWORD Value 
);
 ;
      
LongWord GetFont ();
 ;
       
SetFont (const LongWord Value 
);
 ;
      
DWORD GetTextFormat ();
 ;
      
AssignTo (Iz3DBase Dest 
);
 ;
      
Assign (Iz3DBase Source 
);
 ;
            $
SetTexture (LongWord iTexture ,
PRect prcTexture ,
TD3DColor defaultTextureColor = FFFFFFFF 
);
 ;
          $           
SetFontParams (LongWord iFont ,
TD3DColor defaultFontColor = FF000000 ,
DWORD dwTextFormat = DT_CENTER ,
 or ,
 DT_VCENTER 
);
 ;
     
Refresh ();
 ;
    
         /** \sa GetTextFormat For reading   \sa SetTextFormat For writing */
DWORD TextFormat; 

         /** \sa GetFont For reading   \sa SetFont For writing */
LongWord Font; 

         /** \sa GetFontColor For reading   \sa SetFontColor For writing */
Iz3DBlendColor FontColor; 

         /** \sa GetTextureColor For reading   \sa SetTextureColor For writing */
Iz3DBlendColor TextureColor; 

       /** \sa GetTexture For reading*/
LongWord Texture; 

       /** \sa GetTextureRect For reading*/
TRect TextureRect; 

 };


  // List style
   enum Tz3DListBoxStyle
{
z3dlbsNormal, 
z3dlbsMultiSelect 
};


  // Dialog class
   class Iz3DDialog : public Iz3DBase
{
public:
['{F5CF23DF-50CB-4FB8-9630-48FE510A3751}']
      
PWideChar GetCaption ();
 ;
      
Integer GetLeft ();
 ;
      
Integer GetTop ();
 ;
       
SetLeft (const Integer Value 
);
 ;
       
SetTop (const Integer Value 
);
 ;
      
Boolean GetDesktopOnly ();
 ;
       
SetDesktopOnly (const Boolean Value 
);
 ;
      
Boolean GetEnableBorder ();
 ;
       
SetEnableBorder (const Boolean Value 
);
 ;
      
Boolean GetEnableBackground ();
 ;
       
SetEnableBackground (const Boolean Value 
);
 ;
       
Iz3DControl GetControlIndex (Integer AIndex 
);
 ;
      
Boolean GetEnableCaption ();
 ;
      
Integer GetHeight ();
 ;
      
Boolean GetModalMode ();
 ;
      
Integer GetControlCount ();
 ;
      
Boolean GetKeyboardInput ();
 ;
      
Iz3DGUIController GetManager ();
 ;
      
Integer GetWidth ();
 ;
       
SetEnableCaption (const Boolean Value 
);
 ;
       
SetHeight (const Integer Value 
);
 ;
       
SetWidth (const Integer Value 
);
 ;
     
InitDefaultDisplays ();
 ;
      
OnMouseMove (TPoint pt 
);
 ;
      
OnMouseUp (TPoint pt 
);
 ;
      
SetNextDialog (Iz3DDialog pNextDialog 
);
 ;
       
Boolean OnCycleFocus (Boolean bForward 
);
 ;
          
InitDialog (Iz3DGUIController pManager ,
Boolean bRegisterDialog = True 
);
 ; ;
                
InitDialog (Iz3DGUIController pManager ,
Boolean bRegisterDialog ,
const PWideChar pszControlTextureFilename 
);
 ; ;
      
InitDefaultDialog (Iz3DGUIController pManager 
);
 ;
                 
InitDialog (Iz3DGUIController pManager ,
Boolean bRegisterDialog ,
PWideChar szControlTextureResourceName ,
HMODULE hControlTextureResourceModule 
);
 ; ;
                      
HRESULT AddLabel (Integer ID ,
PWideChar strText ,
Integer x ,
Integer y ,
Integer width ,
Integer height ,
Boolean bIsDefault = False ,
PIz3DLabel ppCreated = nil 
);
 ;
                          
HRESULT AddButton (Integer ID ,
PWideChar strText ,
Integer x ,
Integer y ,
Integer width ,
Integer height ,
LongWord nHotkey = 0 ,
Boolean bIsDefault = False ,
PIz3DButton ppCreated = nil 
);
 ;
                              
HRESULT AddCheckBox (Integer ID ,
PWideChar strText ,
Integer x ,
Integer y ,
Integer width ,
Integer height ,
Boolean bChecked = False ,
LongWord nHotkey = 0 ,
Boolean bIsDefault = False ,
PIz3DCheckBox ppCreated = nil 
);
 ;
                                
HRESULT AddRadioButton (Integer ID ,
LongWord nButtonGroup ,
PWideChar strText ,
Integer x ,
Integer y ,
Integer width ,
Integer height ,
Boolean bChecked = False ,
LongWord nHotkey = 0 ,
Boolean bIsDefault = False ,
PIz3DRadioButton ppCreated = nil 
);
 ;
                        
HRESULT AddComboBox (Integer ID ,
Integer x ,
Integer y ,
Integer width ,
Integer height ,
LongWord nHotKey = 0 ,
Boolean bIsDefault = False ,
PIz3DComboBox ppCreated = nil 
);
 ;
                                
HRESULT AddTrackBar (Integer ID ,
Integer x ,
Integer y ,
Integer width ,
Integer height ,
Integer min = 0 ,
Integer max = 100 ,
Integer value = 50 ,
Boolean bIsDefault = False ,
PIz3DTrackBar ppCreated = nil 
);
 ;
                      
HRESULT AddEditBox (Integer ID ,
PWideChar strText ,
Integer x ,
Integer y ,
Integer width ,
Integer height ,
Boolean bIsDefault = False ,
PIz3DEdit ppCreated = nil 
);
 ;
                      
HRESULT AddIMEEditBox (Integer ID ,
PWideChar strText ,
Integer x ,
Integer y ,
Integer width ,
Integer height ,
Boolean bIsDefault = False ,
PIz3DIMEEditBox ppCreated = nil 
);
 ;
                    
HRESULT AddListBox (Integer ID ,
Integer x ,
Integer y ,
Integer width ,
Integer height ,
Tz3DListBoxStyle dwStyle = z3dlbsNormal ,
PIz3DListBox ppCreated = nil 
);
 ;
        
HRESULT AddControl (const Iz3DControl pControl 
);
 ;
        
HRESULT InitControl (const Iz3DControl pControl 
);
 ;
       
Iz3DLabel GetLabel (Integer ID 
);
#ifdef  SUPPORTS_INLINE
 #endif
 ;
       
Iz3DButton GetButton (Integer ID 
);
#ifdef  SUPPORTS_INLINE
 #endif
 ;
       
Iz3DCheckBox GetCheckBox (Integer ID 
);
#ifdef  SUPPORTS_INLINE
 #endif
 ;
       
Iz3DRadioButton GetRadioButton (Integer ID 
);
#ifdef  SUPPORTS_INLINE
 #endif
 ;
       
Iz3DComboBox GetComboBox (Integer ID 
);
#ifdef  SUPPORTS_INLINE
 #endif
 ;
       
Iz3DTrackBar GetTrackBar (Integer ID 
);
#ifdef  SUPPORTS_INLINE
 #endif
 ;
       
Iz3DEdit GetEditBox (Integer ID 
);
#ifdef  SUPPORTS_INLINE
 #endif
 ;
       
Iz3DIMEEditBox GetIMEEditBox (Integer ID 
);
#ifdef  SUPPORTS_INLINE
 #endif
 ;
       
Iz3DListBox GetListBox (Integer ID 
);
#ifdef  SUPPORTS_INLINE
 #endif
 ;
       
Iz3DControl GetControl (Integer ID 
);
 ; ;
       
Iz3DControl GetControlProp (Integer ID 
);
#ifdef  SUPPORTS_INLINE
 #endif
 ;
         
Iz3DControl GetControl (Integer ID ,
Tz3DControlType nControlType 
);
 ; ;
       
Iz3DControl GetControlAtPoint (TPoint pt 
);
 ;
       
Boolean GetControlEnabled (Integer ID 
);
 ;
        
SetControlEnabled (Integer ID ,
Boolean bEnabled 
);
 ;
      
ClearRadioButtonGroup (LongWord nGroup 
);
 ;
      
ClearComboBox (Integer ID 
);
 ;
      
Boolean GetVisible ();
 ;
       
SetVisible (const Boolean Value 
);
 ;
            
HRESULT SetDefaultDisplay (Tz3DControlType nControlType ,
LongWord iDisplay ,
const Iz3DDisplay pDisplay 
);
 ;
      
SetRefreshTime (Single fTime 
);
 /* s_fTimeRefresh = fTime; */  ;
       
Iz3DControl GetNextControl (Iz3DControl pControl 
);
 ;
       
Iz3DControl GetPrevControl (Iz3DControl pControl 
);
 ;
     
ClearFocus ();
 ;
         
Iz3DDisplay GetDefaultDisplay (Tz3DControlType nControlType ,
LongWord iDisplay 
);
 ;
           
SendEvent (const Tz3DControlEvent AEvent ,
Boolean bTriggeredByUser ,
Iz3DControl pControl 
);
 ;
      
RequestFocus (Iz3DControl pControl 
);
 ;
          
HRESULT DrawRect (const TRect pRect ,
TD3DColor color 
);
 ;
           
HRESULT DrawPolyLine (PPoint apPoints ,
LongWord nNumPoints ,
TD3DColor color 
);
 ;
          
HRESULT DrawSprite (Iz3DDisplay pDisplay ,
const TRect prcDest 
);
 ;
              - 
HRESULT CalcTextRect (PWideChar strText ,
Iz3DDisplay pDisplay ,
PRect prcDest ,
Integer nCount = 1 
);
 ;
                   - 
HRESULT DrawText (PWideChar strText ,
Iz3DDisplay pDisplay ,
const TRect rcDest ,
Boolean bShadow = False ,
Integer nCount = 1 
);
 ;
      
SetBackgroundColors (TD3DColor colorAllCorners 
);
 ; ;
         
SetBackgroundColors (TD3DColor colorTopLeft ,
TD3DColor colorTopRight ,
TD3DColor colorBottomLeft ,
TD3DColor colorBottomRight 
);
 ; ;
       
SetCaption (const PWideChar pwszText 
);
 ;
       
GetLocation (/* out */ TPoint &Pt 
);
 ;
      
Iz3DDialog GetNextDialog ();
 ;
       
SetLocation (Integer x ,
Integer y 
);
 ;
       
SetSize (Integer width ,
Integer height 
);
 ;
      
Boolean HasFocus ();
 ;
     
SetFocus ();
 ;
      
SetPrevDialog (Iz3DDialog pNextDialog 
);
 ;
      
Iz3DDialog GetPrevDialog ();
 ;
      
RemoveControl (Integer ID 
);
 ;
     
ShowModal ();
 ;
     
Show ();
 ;
     
Hide ();
 ;
     
Render ();
 ;
                        
Message (const HWND AWnd ,
const Cardinal AMsg ,
const Integer AwParam ,
const Integer AlParam ,
Boolean &AHandled 
);
 ;
     
RemoveAllControls ();
 ;
          
SetCallback (PCallbackz3DguiEvent pCallback ,
Pointer pUserContext = nil 
);
 ;
      
EnableNonUserEvents (Boolean bEnable 
);
 ;
      
EnableKeyboardInput (Boolean bEnable 
);
 ;
      
EnableMouseInput (Boolean bEnable 
);
 ;
     
Refresh ();
 ;
            
HRESULT SetFont (LongWord index ,
PWideChar strFaceName ,
Longint height ,
Longint weight 
);
 ;
       
Pz3DFontNode GetFont (LongWord index 
);
 ;
         
HRESULT SetTexture (LongWord index ,
PWideChar strFilename 
);
 ; ;
           
HRESULT SetTexture (LongWord index ,
PWideChar strResourceName ,
HMODULE hResourceModule 
);
 ; ;
       
Pz3DTextureNode GetTexture (LongWord index 
);
 ;
     
FocusDefaultControl ();
 ;
    
         /** \sa GetCaption For reading   \sa SetCaption For writing */
PWideChar Caption; 

       /** \sa GetModalMode For reading*/
Boolean ModalMode; 

       /** \sa GetManager For reading*/
Iz3DGUIController Manager; 

    /*[ID: Integer]*/   /** \sa GetLabel For reading*/
Iz3DLabel Labels; 

    /*[ID: Integer]*/   /** \sa GetButton For reading*/
Iz3DButton Buttons; 

    /*[ID: Integer]*/   /** \sa GetCheckBox For reading*/
Iz3DCheckBox CheckBoxes; 

    /*[ID: Integer]*/   /** \sa GetRadioButton For reading*/
Iz3DRadioButton RadioButtons; 

    /*[ID: Integer]*/   /** \sa GetComboBox For reading*/
Iz3DComboBox ComboBoxes; 

    /*[ID: Integer]*/   /** \sa GetTrackBar For reading*/
Iz3DTrackBar TrackBars; 

    /*[ID: Integer]*/   /** \sa GetEditBox For reading*/
Iz3DEdit Edits; 

    /*[ID: Integer]*/   /** \sa GetIMEEditBox For reading*/
Iz3DIMEEditBox IMEEdits; 

    /*[ID: Integer]*/   /** \sa GetListBox For reading*/
Iz3DListBox ListBoxes; 

    /*[ID: Integer]*/   /** \sa GetControlProp For reading*/
Iz3DControl Controls; 

    /*[AIndex: Integer]*/   /** \sa GetControlIndex For reading*/
Iz3DControl ControlIndex; 

       /** \sa GetControlCount For reading*/
Integer ControlCount; 

       /** \sa GetKeyboardInput For reading*/
Boolean IsKeyboardInputEnabled; 

         /** \sa GetEnableCaption For reading   \sa SetEnableCaption For writing */
Boolean EnableCaption; 

         /** \sa GetEnableBackground For reading   \sa SetEnableBackground For writing */
Boolean EnableBackground; 

         /** \sa GetEnableBorder For reading   \sa SetEnableBorder For writing */
Boolean EnableBorder; 

         /** \sa GetDesktopOnly For reading   \sa SetDesktopOnly For writing */
Boolean DesktopOnly; 

         /** \sa GetLeft For reading   \sa SetLeft For writing */
Integer Left; 

         /** \sa GetTop For reading   \sa SetTop For writing */
Integer Top; 

         /** \sa GetWidth For reading   \sa SetWidth For writing */
Integer Width; 

         /** \sa GetHeight For reading   \sa SetHeight For writing */
Integer Height; 

         /** \sa GetVisible For reading   \sa SetVisible For writing */
Boolean Visible; 

 };


  // Message dialog type

   class Iz3DMessageDialog : public Iz3DDialog
{
public:
['{507F21FF-324F-44EC-BCDE-2FCC03A6E46A}']
      
Tz3DMessageDialogKind GetKind ();
 ;
       
SetKind (const Tz3DMessageDialogKind Value 
);
 ;
                   
Tz3DDialogModalResult ShowMessage (const Iz3DDesktop ADesktop ,
const PWideChar AMessage ,
const Tz3DMessageDialogKind AKind 
);
 ;

         /** \sa GetKind For reading   \sa SetKind For writing */
Tz3DMessageDialogKind Kind; 

 };


   class Iz3DMainMenuDialog : public Iz3DDialog
{
public:
['{A077351D-E880-4454-92BC-A3C78D25EED6}']
 };


   class Iz3DProgressDialog : public Iz3DDialog
{
public:
['{6454B743-2264-4F44-81EF-04E3B05A4104}']
      
PWideChar GetStatus ();
 ;
       
SetStatus (const PWideChar AStatus 
);
 ;
       
SetProgress (const Integer APosition 
);
 ;
    
         /** \sa GetStatus For reading   \sa SetStatus For writing */
PWideChar Status; 

 };


   class Iz3DConsoleDialog : public Iz3DDialog
{
public:
['{CB92FB85-F900-4A76-B377-6B7DBBE94F1E}']
 };


   class Iz3DControl : public Iz3DBase
{
public:
['{B2987EF0-7BA7-4A4C-9517-D4E318A7B886}']
      
Integer GetHeight ();
 ;
      
Integer GetLeft ();
 ;
      
Integer GetTop ();
 ;
      
Integer GetWidth ();
 ;
       
SetHeight (const Integer Value 
);
 ;
       
SetLeft (const Integer Value 
);
 ;
       
SetTop (const Integer Value 
);
 ;
       
SetWidth (const Integer Value 
);
 ;
       
SetDialog (const Iz3DDialog Value 
);
 ;
      
LongWord GetIndex ();
 ;
      
Iz3DDialog GetDialog ();
 ;
       
SetIndex (const LongWord Value 
);
 ;
      
Pointer GetUserData ();
 ;
       
SetUserData (const Pointer Value 
);
 ;
      
LongWord GetHotkey ();
 ;
      
Integer GetID ();
 ;
      
Boolean GetIsDefault ();
 ;
      
Tz3DControlType GetType ();
 ;
      
Boolean GetVisible ();
 ;
       
SetHotkey (const LongWord Value 
);
 ;
       
SetID (const Integer Value 
);
 ;
       
SetIsDefault (const Boolean Value 
);
 ;
     
UpdateRects ();
 ;
      
SetEnabled (Boolean bEnabled 
);
 ;
      
Boolean GetEnabled ();
 ;
      
SetVisible (Boolean bVisible 
);
 ;
      
SetTextColor (TD3DColor Color 
);
 ;
       
Iz3DDisplay GetDisplay (LongWord iDisplay 
);
 ;
         
SetDisplay (LongWord iDisplay ,
const Iz3DDisplay pDisplay 
);
 ;
      
HRESULT OnInit ();
 ;
     
Refresh ();
 ;
     
Render ();
 ;
           
Boolean MsgProc (LongWord uMsg ,
WPARAM wParam ,
LPARAM lParam 
);
 ;
           
Boolean HandleKeyboard (LongWord uMsg ,
WPARAM wParam ,
LPARAM lParam 
);
 ;
             
Boolean HandleMouse (LongWord uMsg ,
TPoint pt ,
WPARAM wParam ,
LPARAM lParam 
);
 ;
      
Boolean CanHaveFocus ();
 ;
     
OnFocusIn ();
 ;
     
OnFocusOut ();
 ;
     
OnMouseEnter ();
 ;
     
OnMouseLeave ();
 ;
     
OnHotkey ();
 ;
       
LongBool ContainsPoint (TPoint pt 
);
 ;
       
SetLocation (Integer x ,
Integer y 
);
 ;
       
SetSize (Integer width ,
Integer height 
);
 ;
    
         /** \sa GetLeft For reading   \sa SetLeft For writing */
Integer Left; 

         /** \sa GetTop For reading   \sa SetTop For writing */
Integer Top; 

         /** \sa GetWidth For reading   \sa SetWidth For writing */
Integer Width; 

         /** \sa GetHeight For reading   \sa SetHeight For writing */
Integer Height; 

    /*[i: LongWord]*/     /** \sa GetDisplay For reading   \sa SetDisplay For writing */
Iz3DDisplay Display; 

         /** \sa GetUserData For reading   \sa SetUserData For writing */
Pointer UserData; 

         /** \sa GetDialog For reading   \sa SetDialog For writing */
Iz3DDialog Dialog; 

       /** \sa GetType For reading*/
Tz3DControlType ControlType; 

         /** \sa GetID For reading   \sa SetID For writing */
Integer ID; 

         /** \sa GetEnabled For reading   \sa SetEnabled For writing */
Boolean Enabled; 

         /** \sa GetVisible For reading   \sa SetVisible For writing */
Boolean Visible; 

         /** \sa GetIsDefault For reading   \sa SetIsDefault For writing */
Boolean Default; 

         /** \sa GetIndex For reading   \sa SetIndex For writing */
LongWord Index; 

         /** \sa GetHotkey For reading   \sa SetHotkey For writing */
LongWord Hotkey; 

       /** \sa SetTextColor For writing*/
TD3DColor TextColor; 

 };


  // Static label control
   class Iz3DLabel : public Iz3DControl
{
public:
['{790F32E5-29C3-442C-8303-8789E56C7036}']
      
PWideChar GetText ();
 ;
      
SetText (PWideChar strText 
);
 ;
         
HRESULT GetTextCopy (PWideChar strDest ,
LongWord bufferCount 
);
 ;
    
         /** \sa GetText For reading   \sa SetText For writing */
PWideChar Text; 

 };


   class Iz3DButton : public Iz3DLabel
{
public:
['{931D35CB-2F31-4252-B999-200D427AA9DA}']
      
Boolean GetEnableBackground ();
 ;
       
SetEnableBackground (const Boolean Value 
);
 ;
      
Boolean GetPressed ();
 ;
    
       /** \sa GetPressed For reading*/
Boolean Pressed; 

         /** \sa GetEnableBackground For reading   \sa SetEnableBackground For writing */
Boolean EnableBackground; 

 };


   class Iz3DCheckBox : public Iz3DButton
{
public:
['{EDDCD52E-E946-4D60-9F8D-E20F48B7FE54}']
      
Boolean GetChecked ();
 ;
      
SetChecked (Boolean bChecked 
);
 ;
    
         /** \sa GetChecked For reading   \sa SetChecked For writing */
Boolean Checked; 

 };


  // RadioButton control
   class Iz3DRadioButton : public Iz3DCheckBox
{
public:
['{73753CE2-5EE7-45AF-A102-CA3C1B862555}']
      
LongWord GetButtonGroup ();
 ;
       
SetButtonGroup (const LongWord Value 
);
 ;
      
SetChecked (Boolean bChecked 
);
 ; ;
          
SetChecked (Boolean bChecked ,
Boolean bClearGroup = True 
);
 ; ;
    
         /** \sa GetButtonGroup For reading   \sa SetButtonGroup For writing */
LongWord ButtonGroup; 

 };


  // ARROWSTATE indicates the state of the arrow buttons.
  // CLEAR            No arrow is down.
  // CLICKED_UP       Up arrow is clicked.
  // CLICKED_DOWN     Down arrow is clicked.
  // HELD_UP          Up arrow is held down for sustained period.
  // HELD_DOWN        Down arrow is held down for sustained period.
   enum Tz3DScrollBar_ArrayState
{
CLEAR, 
CLICKED_UP, 
CLICKED_DOWN, 
HELD_UP, 
HELD_DOWN 
};


   class Iz3DScrollBar : public Iz3DControl
{
public:
['{376A2CD8-5FDF-4577-BF83-7362B0D593EE}']
      
Integer GetPageSize ();
 ;
      
Integer GetPosition ();
 ;
     
UpdateThumbRect ();
 ;
     
Cap ();
 ;
      
SetTrackPos (Integer nPosition 
);
 ;
      
SetPageSize (Integer nPageSize 
);
 ;
       
SetTrackRange (Integer nStart ,
Integer nEnd 
);
 ;
      
Scroll (Integer nDelta 
);
 ;
      
ShowItem (Integer nIndex 
);
 ;
    
         /** \sa GetPosition For reading   \sa SetTrackPos For writing */
Integer TrackPos; 

         /** \sa GetPageSize For reading   \sa SetPageSize For writing */
Integer PageSize; 

 };


  // ListBox control
   typedef Tz3DListBoxItem* Pz3DListBoxItem;

   struct Tz3DListBoxItem
{

     WideChar strText[255]; /*!< [0..255] */

      Pointer pData; 

       TRect rcActive; 

      Boolean bSelected; 

 };


   class Iz3DListBox : public Iz3DControl
{
public:
['{091AB4EE-25F6-4D8D-BA51-191B4768D09F}']
      
Integer GetSBWidth ();
 ;
      
Integer GetSelected ();
 ;
      
Tz3DListBoxStyle GetStyle ();
 ;
      
Integer GetSize ();
 ;
      
SetStyle (Tz3DListBoxStyle dwStyle 
);
 ;
      
SetScrollBarWidth (Integer nWidth 
);
 ;
       
SetBorder (Integer nBorder ,
Integer nMargin 
);
 ;
          
HRESULT AddItem (const PWideChar wszText ,
Pointer pData 
);
 ;
            
HRESULT InsertItem (Integer nIndex ,
const PWideChar wszText ,
Pointer pData 
);
 ;
      
RemoveItem (Integer nIndex 
);
 ;
      
RemoveItemByText (PWideChar wszText 
);
 ;
      
RemoveItemByData (Pointer pData 
);
 ;
     
RemoveAllItems ();
 ;
       
Pz3DListBoxItem GetItem (Integer nIndex 
);
 ;
        - 
Integer GetSelectedIndex (Integer nPreviousSelected = 1 
);
 ;
        - 
Pz3DListBoxItem GetSelectedItem (Integer nPreviousSelected = 1 
);
 ;
      
SelectItem (Integer nNewIndex 
);
 ;
    
    /*[Index: Integer]*/   /** \sa GetItem For reading*/
Pz3DListBoxItem Items; 

         /** \sa GetSelected For reading   \sa SelectItem For writing */
Integer ItemIndex; 

         /** \sa GetSelected For reading   \sa SelectItem For writing */
Integer SelectedIndex; 

         /** \sa GetSBWidth For reading   \sa SetScrollBarWidth For writing */
Integer ScrollBarWidth; 

         /** \sa GetStyle For reading   \sa SetStyle For writing */
Tz3DListBoxStyle Style; 

       /** \sa GetSize For reading*/
Integer Size; 

 };


  // ComboBox control
   typedef Tz3DComboBoxItem* Pz3DComboBoxItem;

   struct Tz3DComboBoxItem
{

     WideChar strText[255]; /*!< [0..255] */

      Pointer pData; 

      TRect rcActive; 

      Boolean bVisible; 

 };


   class Iz3DComboBox : public Iz3DButton
{
public:
['{06CE6E19-3713-469B-BB53-93D4A48C397D}']
      
Integer GetSBWidth ();
 ;
      
LongWord GetNumItems ();
 ;
       
Pz3DComboBoxItem GetItem (LongWord index 
);
 ;
          
HRESULT AddItem (const PWideChar strText ,
Pointer pData 
);
 ;
     
RemoveAllItems ();
 ;
      
RemoveItem (LongWord index 
);
 ;
            
Boolean ContainsItem (const PWideChar strText ,
LongWord iStart = 0 
);
 ;
            
Integer FindItem (const PWideChar strText ,
LongWord iStart = 0 
);
 ;
        
Pointer GetItemData (const PWideChar strText 
);
 ; ;
       
Pointer GetItemData (Integer nIndex 
);
 ; ;
      
SetDropHeight (LongWord nHeight 
);
 ;
      
SetScrollBarWidth (Integer nWidth 
);
 ;
      
Pointer GetSelectedData ();
 ;
      
Pz3DComboBoxItem GetSelectedItem ();
 ;
       
HRESULT SetSelectedByIndex (LongWord index 
);
 ;
        
HRESULT SetSelectedByText (const PWideChar strText 
);
 ;
       
HRESULT SetSelectedByData (Pointer pData 
);
 ;
    
    /*[index: LongWord]*/   /** \sa GetItem For reading*/
Pz3DComboBoxItem Item; 

       /** \sa GetNumItems For reading*/
LongWord NumItems; 

         /** \sa GetSBWidth For reading   \sa SetScrollBarWidth For writing */
Integer ScrollBarWidth; 

 };


   class Iz3DTrackBar : public Iz3DControl
{
public:
['{FA8005DD-8E20-4647-A1A4-61FCC83A9B75}']
      
Integer GetValue ();
 ;
        
SetValueInternal (Integer nValue ,
Boolean bFromInput 
);
 ;
       
Integer ValueFromPos (Integer x 
);
 ;
      
SetValue (Integer nValue 
);
 ;
        
GetRange (/* out */ Integer &nMin ,
/* out */ Integer &nMax 
);
 ;
       
SetRange (Integer nMin ,
Integer nMax 
);
 ;
    
         /** \sa GetValue For reading   \sa SetValue For writing */
Integer Value; 

 };


   class Iz3DProgressBar : public Iz3DControl
{
public:
['{FA8005DD-8E20-4647-A1A4-61FCC83A9B75}']
      
Integer GetValue ();
 ;
        
SetValueInternal (Integer nValue ,
Boolean bFromInput 
);
 ;
       
Integer ValueFromPos (Integer x 
);
 ;
      
SetValue (Integer nValue 
);
 ;
        
GetRange (/* out */ Integer &nMin ,
/* out */ Integer &nMax 
);
 ;
       
SetRange (Integer nMin ,
Integer nMax 
);
 ;
    
         /** \sa GetValue For reading   \sa SetValue For writing */
Integer Value; 

 };


   class Iz3DUniBuffer : public Iz3DBase
{
public:
['{3941C071-12B8-4133-99C2-CB82B7F6D086}']
      
Integer GetBufferSize ();
 ;
      
Pz3DFontNode GetFontNode ();
 ;
      
PWideChar GetwszBuffer ();
 ;
       
SetFontNode (const Pz3DFontNode Value 
);
 ;
      
HRESULT Analyse ();
 ;
       
Boolean SetBufferSize (Integer nNewSize 
);
 ;
      
Integer GetTextSize ();
 ;
       
WideChar GetChar (Integer i 
);
 ;
        
SetChar (Integer i ,
WideChar ch 
);
 ;
     
Clear ();
 ;
         
Boolean InsertChar (Integer nIndex ,
WideChar wChar 
);
 ;
       
Boolean RemoveChar (Integer nIndex 
);
 ;
             - 
Boolean InsertString (Integer nIndex ,
const PWideChar pStr ,
Integer nCount = 1 
);
 ;
      
SetText (PWideChar wszText 
);
 ;
            
HRESULT CPtoX (Integer nCP ,
BOOL bTrail ,
/* out */ Integer &pX 
);
 ;
             
HRESULT XtoCP (Integer nX ,
/* out */ Integer &pCP ,
/* out */ LongBool &pnTrail 
);
 ;
         
GetPriorItemPos (Integer nCP ,
/* out */ Integer &pPrior 
);
 ;
         
GetNextItemPos (Integer nCP ,
/* out */ Integer &pPrior 
);
 ;
    
       /** \sa GetBufferSize For reading*/
Integer BufferSize; 

       /** \sa GetwszBuffer For reading*/
PWideChar Buffer; 

    /*[i: Integer]*/     /** \sa GetChar For reading   \sa SetChar For writing */
WideChar Chars; 
 
         /** \sa GetFontNode For reading   \sa SetFontNode For writing */
Pz3DFontNode FontNode; 

       /** \sa GetTextSize For reading*/
Integer TextSize; 

 };


   class Iz3DEdit : public Iz3DControl
{
public:
['{2B0E7EB4-84C5-4FF8-A9AF-59B85234F676}']
      
Integer GetBorder ();
 ;
       
SetCaretColor (const TD3DColor Value 
);
 ;
      
TD3DColor GetCaretColor ();
 ;
      
TD3DColor GetSelBkColor ();
 ;
      
TD3DColor GetSelTextColor ();
 ;
      
Integer GetSpacing ();
 ;
      
TD3DColor GetTextColor ();
 ;
       
SetSelBkColor (const TD3DColor Value 
);
 ;
       
SetSelTextColor (const TD3DColor Value 
);
 ;
      
PlaceCaret (Integer nCP 
);
 ;
     
DeleteSelectionText ();
 ;
     
ResetCaretBlink ();
 ;
     
CopyToClipboard ();
 ;
     
PasteFromClipboard ();
 ;
      
PWideChar GetText ();
 ;
      
SetText_p (PWideChar wszText 
);
#ifdef  SUPPORTS_INLINE
 #endif
 ;
      
Integer GetTextLength ();
 ;
      
SetBorderWidth (Integer nBorder 
);
 ;
      
SetSpacing (Integer nSpacing 
);
 ;
          
SetText (PWideChar wszText ,
Boolean bSelected = False 
);
 ;
         
HRESULT GetTextCopy (PWideChar strDest ,
LongWord bufferCount 
);
 ;
     
ClearText ();
 ;
        
ParseFloatArray (PSingle pNumbers ,
Integer nCount 
);
 ;
        
SetTextFloatArray (PSingle pNumbers ,
Integer nCount 
);
 ;
    
         /** \sa GetText For reading   \sa SetText_p For writing */
PWideChar Text; 

         /** \sa GetTextColor For reading   \sa SetTextColor For writing */
TD3DColor TextColor; 

       /** \sa GetTextLength For reading*/
Integer TextLength; 

         /** \sa GetSelTextColor For reading   \sa SetSelTextColor For writing */
TD3DColor SelectedTextColor; 

         /** \sa GetSelBkColor For reading   \sa SetSelBkColor For writing */
TD3DColor SelectedBackColor; 

         /** \sa GetCaretColor For reading   \sa SetCaretColor For writing */
TD3DColor CaretColor; 

         /** \sa GetBorder For reading   \sa SetBorderWidth For writing */
Integer BorderWidth; 

         /** \sa GetSpacing For reading   \sa SetSpacing For writing */
Integer Spacing; 

 };


  //-----------------------------------------------------------------------------
  // IME-enabled EditBox control
  //-----------------------------------------------------------------------------

   enum TIndicatorEnum
{
INDICATOR_NON_IME, 
INDICATOR_CHS, 
INDICATOR_CHT, 
INDICATOR_KOREAN, 
INDICATOR_JAPANESE 
};

   enum TImeState
{
IMEUI_STATE_OFF, 
IMEUI_STATE_ON, 
IMEUI_STATE_ENGLISH 
};


   struct TCandList
{

      WideChar awszCandidate[255]; /*!< [0..999..-1..0..255] */

      Iz3DUniBuffer HoriCand; 
   // Candidate list string (for horizontal candidate window)
      Integer nFirstSelected; 
   // First character position of the selected string in HoriCand
      Integer nHoriSelectedLen; 
 // Length of the selected string in HoriCand
      DWORD dwCount; 
            // Number of valid entries in the candidate list
      DWORD dwSelection; 
        // Currently selected candidate entry relative to page top
      DWORD dwPageSize; 

      Integer nReadingError; 
    // Index of the error character
       BOOL bShowWindow; 
        // Whether the candidate list window is visible
       TRect rcCandidate; 
       // Candidate rectangle computed and filled each time before rendered
 };


   struct TInputLocale
{

      HKL m_hKL; 
            // Keyboard layout
     WideChar FLangAbb[2]; /*!< [0..2] */
  // Language abbreviation
     WideChar FLang[63]; /*!< [0..63] */
    // Localized language name
 };


   class Iz3DIMEEditBox : public Iz3DEdit
{
public:
['{2A6A8D11-39BD-4EF8-8ED6-1038FC348A5A}']
            
TruncateCompString (Boolean bUseBackSpace = True ,
Integer iNewStrLen = 0 
);
 ;
      
FinalizeString (Boolean bSend 
);
 ;
     
SendCompString ();
 ;
     
PumpMessage ();
 ;
      
RenderCandidateReadingWindow (Boolean bReading 
);
 ;
     
RenderComposition ();
 ;
     
RenderIndicator ();
 ;
 };



   const  MAX_CONTROL_STATES =  Ord(High(Tz3DControlState))+1;


     const  WM_XBUTTONDOWN =  $020B; // (not always defined)
       const  WM_XBUTTONUP =  $020C; // (not always defined)
   const  WM_XBUTTONDBLCLK =  $020D;
      const  WM_MOUSEWHEEL =  $020A; // (not always defined)
        const  WHEEL_DELTA =  120;   // (not always defined)

           const  MK_XBUTTON1 =  $0020;
           const  MK_XBUTTON2 =  $0040;



// finished

