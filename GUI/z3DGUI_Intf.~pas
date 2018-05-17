unit z3DGUI_Intf;

interface

uses
  Windows, Direct3D9, D3DX9, z3DMath_Intf, z3DComponents_Intf, z3DClasses_Intf,
  z3DCore_Intf;

{$IFNDEF FPC}
type
  // BUG in Borland's translation
  PCandidateList = ^TCandidateList;
  {$EXTERNALSYM tagCANDIDATELIST}
  tagCANDIDATELIST = record
    dwSize: DWORD;
    dwStyle: DWORD;
    dwCount: DWORD;
    dwSelection: DWORD;
    dwPageStart: DWORD;
    dwPageSize: DWORD;
    dwOffset: array[0..0] of DWORD;
  end;
  TCandidateList = tagCANDIDATELIST;
  {$EXTERNALSYM CANDIDATELIST}
  CANDIDATELIST = tagCANDIDATELIST;

{$ENDIF}

const

  // IME composition
  IMM32_DLLNAME = '\imm32.dll';
  VER_DLLNAME   = '\version.dll';
  MAX_CANDLIST  = 10;
  MAX_COMPSTRING_SIZE = 256;

{$IFDEF FPC}
  SPI_GETWHEELSCROLLLINES = 104;

{$ENDIF}

var
  GTimeRefresh: Double = 0;

type

  Iz3DProgressDialog = interface;
  Iz3DMainMenuDialog = interface;
  Iz3DGUIController = interface;
  Iz3DDesktop = interface;
  Iz3DDialog = interface;
  Iz3DControl = interface;
  Iz3DButton = interface;
  Iz3DLabel = interface;
  Iz3DCheckBox = interface;
  Iz3DRadioButton = interface;
  Iz3DComboBox = interface;
  Iz3DTrackBar = interface;
  Iz3DEdit = interface;
  Iz3DIMEEditBox = interface;
  Iz3DListBox = interface;
  Iz3DScrollBar = interface;
  Iz3DProgressBar = interface;
  Iz3DDisplay = interface;
  Iz3DConsoleDialog = interface;
  Iz3DEngineSettingsDialog = interface;

  PIz3DControl = ^Iz3DControl;
  PIz3DButton = ^Iz3DButton;
  PIz3DLabel = ^Iz3DLabel;
  PIz3DCheckBox = ^Iz3DCheckBox;
  PIz3DRadioButton = ^Iz3DRadioButton;
  PIz3DComboBox = ^Iz3DComboBox;
  PIz3DListBox = ^Iz3DListBox;
  PIz3DTrackBar = ^Iz3DTrackBar;
  PIz3DEdit = ^Iz3DEdit;
  PIz3DIMEEditBox = ^Iz3DIMEEditBox;
  PIz3DDisplay = ^Iz3DDisplay;

  // Control types
  Tz3DControlType = (z3dctButton, z3dctLabel, z3dctCheckBox, z3dctRadioButton,
    z3dctComboBox, z3dctTrackBar, z3dctEdit, z3dctIMEEdit, z3dctListBox,
    z3dctScrollBar, z3dctProgressBar);

  Tz3DControlEvent = (z3dceButtonClick, z3dceComboBoxChange, z3dceRadioButtonChange,
    z3dcrCheckBoxChange, z3dceTrackBarChange, z3dceEditString, z3dceEditChange,
    z3dceListBoxDblClick, z3dceListBoxBeginSelect, z3dceListBoxEndSelect);

  PCallbackz3DGUIEvent = procedure(const AEvent: Tz3DControlEvent; const AControlID: Integer; const AControl: Iz3DControl;
    const AUserContext: Pointer); stdcall;

  // Control states
  Tz3DControlState = (z3dcsNormal, z3dcsDisabled, z3dcsHidden, z3dcsFocus,
    z3dcsMouseOver, z3dcsPressed);

  Pz3DBlendColorStates = ^Tz3DBlendColorStates;
  Tz3DBlendColorStates = array[Low(Tz3DControlState)..High(Tz3DControlState)] of TD3DColor;

  Tz3DDialogModalResult = (z3dmdrNone, z3dmdrOk, z3dmdrYes, z3dmdrNo, z3dmdrCancel);

  Iz3DBlendColor = interface(Iz3DBase)['{1908CA94-BA3E-4E94-9FD3-9B9F43FB7844}']
    procedure SetCurrent(const Value: TD3DXColor); stdcall;
    function GetStates: Pz3DBlendColorStates; stdcall;
    procedure SetStates(const Value: Pz3DBlendColorStates); stdcall;
    function GetCurrent: TD3DXColor; stdcall;
    procedure SetColors(defaultColor: TD3DColor; disabledColor: TD3DColor = $C8808080; hiddenColor: TD3DColor = 0); stdcall;
    procedure Blend(iState: Tz3DControlState; fRate: Single = 0.7); stdcall;
    
    property Current: TD3DXColor read GetCurrent write SetCurrent;
    property States: Pz3DBlendColorStates read GetStates write SetStates;
  end;

  // Shared resources information
  Pz3DTextureNode = ^Tz3DTextureNode;
  Tz3DTextureNode = record
    FileSource: Boolean;
    ResourceModule: HMODULE;
    ResourceID: Integer;
    FileName: array[0..MAX_PATH-1] of WideChar;
    Texture: IDirect3DTexture9;
    Width: DWORD;
    Height: DWORD;
  end;

  Pz3DFontNode = ^Tz3DFontNode;
  Tz3DFontNode = record
    Name: array[0..MAX_PATH-1] of WideChar;
    Font: ID3DXFont;
    Height: Longint;
    Weight: Longint;
  end;

  // Display information for a control
  Pz3DDisplayHolder = ^Tz3DDisplayHolder;
  Tz3DDisplayHolder = record
    ControlType: Tz3DControlType;
    DisplayIndex: LongWord;
    Display: Iz3DDisplay;
  end;

  Tz3DFontFormat = (z3dffBottom, z3dffCenter, z3dffEndEllipsis, z3dffPathEllipsis,
    z3dffExpandTabs, z3dffExternalLeading, z3dffLeft, z3dffModifyString, z3dffNoClip,
    z3dffNoPrefix, z3dffRight, z3dffRTLReading, z3dffSingleLine, z3dffTabStop,
    z3dffTop, z3dffVerticalCenter, z3dffWordBreak);

  Tz3DFontFormats = set of Tz3DFontFormat;

  Iz3DGUIController = interface(Iz3DBase)['{650E7A3D-3C4F-4A29-8394-4FB89AD80C2B}']
    function GetTextureNodeCount: Integer; stdcall;
    function GetFontsCount: Integer; stdcall;
    function GetModalMode: Boolean; stdcall;
    procedure SetModalMode(const Value: Boolean); stdcall;
    function GetDesktop: Iz3DDesktop; stdcall;
    function GetDialogs(const I: Integer): Iz3DDialog; stdcall;
    function GetDialogCount: Integer; stdcall;
    function GetSprite: ID3DXSprite; stdcall;
    function GetFonts(iIndex: Integer): Pz3DFontNode; stdcall;
    function GetTextureNode(iIndex: Integer): Pz3DTextureNode; stdcall;
    function CreateFont(index: LongWord): HRESULT; stdcall;
    function AddFont(strFaceName: PWideChar; height, weight: Longint): Integer; stdcall;
    function AddTexture(strFilename: PWideChar): Integer; overload; stdcall;
    function GetStateBlock: IDirect3DStateBlock9; stdcall;
    function AddTexture(strResourceName: PWideChar; hResourceModule: HMODULE): Integer; overload; stdcall;
    function RegisterDialog(pDialog: Iz3DDialog): Boolean; stdcall;
    function IndexOf(const ADialog: Iz3DDialog): Integer; stdcall;
    procedure BringToFront(const ADialog: Iz3DDialog); stdcall;
    procedure UnregisterDialog(pDialog: Iz3DDialog); stdcall;
    procedure EnableKeyboardInputForAllDialogs; stdcall;
    procedure CreateScenarioObjects(const AResetDevice: Boolean); stdcall;
    procedure DestroyScenarioObjects(const ALostDevice: Boolean); stdcall;
    procedure Message(const AWnd: HWND; const AMsg: Cardinal;
      const AwParam: Integer; const AlParam: Integer;
      var ADefault: Boolean; var AResult: Integer); stdcall;
    procedure GUIRender; stdcall;

    property ModalMode: Boolean read GetModalMode write SetModalMode;
    property Fonts[i: Integer]: Pz3DFontNode read GetFonts;
    property FontsCount: Integer read GetFontsCount;
    property TextureNode[i: Integer]: Pz3DTextureNode read GetTextureNode;
    property TextureNodeCount: Integer read GetTextureNodeCount;
    property Sprite: ID3DXSprite read GetSprite;
    property DialogCount: Integer read GetDialogCount;
    property Dialogs[const I: Integer]: Iz3DDialog read GetDialogs;
    property Desktop: Iz3DDesktop read GetDesktop;
  end;

  Iz3DGUIFont = interface(Iz3DBase)['{C32C8C8D-2938-4E46-8DB0-1BB6B90C50EF}']
    function GetColor: Iz3DFloat4; stdcall;
    function GetFormat: DWORD; stdcall;
    function GetName: PWideChar; stdcall;
    function GetShadow: Boolean; stdcall;
    function GetSize: Integer; stdcall;
    procedure SetFormat(const Value: DWORD); stdcall;
    procedure SetShadow(const Value: Boolean); stdcall;
    procedure SetSize(const Value: Integer); stdcall;
    
    property Name: PWideChar read GetName;
    property Size: Integer read GetSize write SetSize;
    property Color: Iz3DFloat4 read GetColor;
    property Shadow: Boolean read GetShadow write SetShadow;
    property Format: DWORD read GetFormat write SetFormat;
  end;

  Iz3DDesktopThemeSettings = interface(Iz3DBase)['{BE9799CB-5FAE-481B-814C-B94F99001C15}']
    function GetCaptionHeight: Integer; stdcall;
    procedure SetCaptionHeight(const Value: Integer); stdcall;
    function GetCheckBoxFont: Iz3DGUIFont; stdcall;
    function GetDefaultFont: Iz3DGUIFont; stdcall;
    function GetDialogColorBL: Iz3DFloat4; stdcall;
    function GetDialogColorBR: Iz3DFloat4; stdcall;
    function GetDialogColorTL: Iz3DFloat4; stdcall;
    function GetDialogColorTR: Iz3DFloat4; stdcall;
    function GetRadioButtonFont: Iz3DGUIFont; stdcall;
    
    property DialogColorTL: Iz3DFloat4 read GetDialogColorTL;
    property DialogColorTR: Iz3DFloat4 read GetDialogColorTR;
    property DialogColorBL: Iz3DFloat4 read GetDialogColorBL;
    property DialogColorBR: Iz3DFloat4 read GetDialogColorBR;
    property CaptionHeight: Integer read GetCaptionHeight write SetCaptionHeight;
    property DefaultFont: Iz3DGUIFont read GetDefaultFont;
    property CheckBoxFont: Iz3DGUIFont read GetCheckBoxFont;
    property RadioButtonFont: Iz3DGUIFont read GetRadioButtonFont;
  end;

  Tz3DMessageDialogKind = (z3dmdkInformation, z3dmdkWarning, z3dmdkError,
    z3dmdkConfirmation, z3dmdkConfirmationCancel);


  Iz3DDesktop = interface(Iz3DBase)['{2429E2CF-1264-4038-8F41-55C4D1A9FF5C}']
    function GetConsole: Iz3DConsoleDialog; stdcall;
    function GetVisible: Boolean; stdcall;
    procedure SetVisible(const Value: Boolean); stdcall;
    function GetProgressDialog: Iz3DProgressDialog; stdcall;
    function GetThemeSettings: Iz3DDesktopThemeSettings; stdcall;
    function GetGUIController: Iz3DGUIController; stdcall;
    function GetBlurWallpaper: Boolean; stdcall;
    procedure SetBlurWallpaper(const Value: Boolean); stdcall;
    function GetWallpaper: Iz3DTexture; stdcall;
    procedure RenderEngineLogo; stdcall;
    procedure BringToFront(const ADialog: Iz3DDialog); stdcall;
    function ShowMessage(const AMessage: PWideChar; const AKind:
      Tz3DMessageDialogKind = z3dmdkInformation): Tz3DDialogModalResult; stdcall;
    procedure StartScenario; stdcall;
    
    function CreateDialog: Iz3DDialog; stdcall;
    function CreateProgressDialog: Iz3DProgressDialog; stdcall;
    function CreateMainMenuDialog: Iz3DMainMenuDialog; stdcall;
    function CreateConsoleDialog: Iz3DConsoleDialog; stdcall;
    function CreateEngineSettingsDialog: Iz3DEngineSettingsDialog; stdcall;

    property Visible: Boolean read GetVisible write SetVisible;
    property Wallpaper: Iz3DTexture read GetWallpaper;
    property BlurWallpaper: Boolean read GetBlurWallpaper write SetBlurWallpaper;
    property ProgressDialog: Iz3DProgressDialog read GetProgressDialog;
    property Console: Iz3DConsoleDialog read GetConsole;
    property Controller: Iz3DGUIController read GetGUIController;
    property ThemeSettings: Iz3DDesktopThemeSettings read GetThemeSettings;
  end;

  Iz3DTextHelper = interface(Iz3DBase)['{94A80185-A2E5-4E2B-8EC7-9C3C93595909}']
    procedure SetInsertionPos(x, y: Integer); stdcall;
    procedure SetForegroundColor(clr: TD3DXColor); stdcall;
    procedure BeginRender; stdcall;
    function DrawFormattedTextLine(const strMsg: PWideChar; args: array of const): HRESULT; overload; stdcall;
    {$IFNDEF FPC}
    function DrawFormattedTextLine(const strMsg: WideString; args: array of const): HRESULT; overload; stdcall;
    {$ENDIF}
    {$IFNDEF FPC}
    function DrawTextLine(const strMsg: PAnsiChar): HRESULT; overload; stdcall;
    {$ENDIF}
    function DrawTextLine(const strMsg: PWideChar): HRESULT; overload; stdcall;
    {$IFDEF BORLAND}{$IFNDEF COMPILER6_UP}
    function DrawTextLine(const strMsg: String): HRESULT; overload; stdcall;
    {$ENDIF}{$ENDIF}
    function DrawFormattedTextLine(const rc: TRect; dwFlags: DWORD;
      const strMsg: PWideChar; args: array of const): HRESULT; overload; stdcall;
    function DrawTextLine(const rc: TRect; dwFlags: DWORD; const strMsg: PWideChar): HRESULT; overload; stdcall;
    procedure EndRender; stdcall;
  end;

  // Display properties for subcontrols
  Iz3DDisplay = interface(Iz3DBase)['{61E20156-962D-48BC-B01A-EE81C72CCEB7}']
    function GetTexture: LongWord; stdcall;
    function GetFontColor: Iz3DBlendColor; stdcall;
    function GetTextureRect: TRect; stdcall;
    function GetTextureColor: Iz3DBlendColor; stdcall;
    procedure SetFontColor(const Value: Iz3DBlendColor); stdcall;
    procedure SetTextureColor(const Value: Iz3DBlendColor); stdcall;
    procedure SetTextFormat(const Value: DWORD); stdcall;
    function GetFont: LongWord; stdcall;
    procedure SetFont(const Value: LongWord); stdcall;
    function GetTextFormat: DWORD; stdcall;
    procedure AssignTo(Dest: Iz3DBase); stdcall;
    procedure Assign(Source: Iz3DBase); stdcall;
    procedure SetTexture(iTexture: LongWord; prcTexture: PRect; defaultTextureColor: TD3DColor = $FFFFFFFF); stdcall;
    procedure SetFontParams(iFont: LongWord; defaultFontColor: TD3DColor = $FF000000;
      dwTextFormat: DWORD = DT_CENTER or DT_VCENTER); stdcall;
    procedure Refresh; stdcall;
    
    property TextFormat: DWORD read GetTextFormat write SetTextFormat;
    property Font: LongWord read GetFont write SetFont;
    property FontColor: Iz3DBlendColor read GetFontColor write SetFontColor;
    property TextureColor: Iz3DBlendColor read GetTextureColor write SetTextureColor;
    property Texture: LongWord read GetTexture;
    property TextureRect: TRect read GetTextureRect;
  end;

  // List style
  Tz3DListBoxStyle = (z3dlbsNormal, z3dlbsMultiSelect);

  // Dialog class
  Iz3DDialog = interface(Iz3DBase)['{F5CF23DF-50CB-4FB8-9630-48FE510A3751}']
    function GetCaption: PWideChar; stdcall;
    function GetLeft: Integer; stdcall;
    function GetTop: Integer; stdcall;
    procedure SetLeft(const Value: Integer); stdcall;
    procedure SetTop(const Value: Integer); stdcall;
    function GetDesktopOnly: Boolean; stdcall;
    procedure SetDesktopOnly(const Value: Boolean); stdcall;
    function GetEnableBorder: Boolean; stdcall;
    procedure SetEnableBorder(const Value: Boolean); stdcall;
    function GetEnableBackground: Boolean; stdcall;
    procedure SetEnableBackground(const Value: Boolean); stdcall;
    function GetControlIndex(AIndex: Integer): Iz3DControl; stdcall;
    function GetEnableCaption: Boolean; stdcall;
    function GetHeight: Integer; stdcall;
    function GetModalMode: Boolean; stdcall;
    function GetControlCount: Integer; stdcall;
    function GetKeyboardInput: Boolean; stdcall;
    function GetManager: Iz3DGUIController; stdcall;
    function GetWidth: Integer; stdcall;
    procedure SetEnableCaption(const Value: Boolean); stdcall;
    procedure SetHeight(const Value: Integer); stdcall;
    procedure SetWidth(const Value: Integer); stdcall;
    procedure InitDefaultDisplays; stdcall;
    procedure OnMouseMove(pt: TPoint); stdcall;
    procedure OnMouseUp(pt: TPoint); stdcall;
    procedure SetNextDialog(pNextDialog: Iz3DDialog); stdcall;
    function OnCycleFocus(bForward: Boolean): Boolean; stdcall;
    procedure InitDialog(pManager: Iz3DGUIController; bRegisterDialog: Boolean = True); overload; stdcall;
    procedure InitDialog(pManager: Iz3DGUIController; bRegisterDialog: Boolean;
      const pszControlTextureFilename: PWideChar); overload; stdcall;
    procedure InitDefaultDialog(pManager: Iz3DGUIController); stdcall;
    procedure InitDialog(pManager: Iz3DGUIController; bRegisterDialog: Boolean;
      szControlTextureResourceName: PWideChar; hControlTextureResourceModule: HMODULE); overload; stdcall;
    function AddLabel(ID: Integer; strText: PWideChar; x, y, width, height: Integer; bIsDefault: Boolean = False; ppCreated: PIz3DLabel = nil): HRESULT; stdcall;
    function AddButton(ID: Integer; strText: PWideChar; x, y, width, height: Integer; nHotkey: LongWord = 0; bIsDefault: Boolean = False; ppCreated: PIz3DButton = nil): HRESULT; stdcall;
    function AddCheckBox(ID: Integer; strText: PWideChar; x, y, width, height: Integer; bChecked: Boolean = False; nHotkey: LongWord = 0; bIsDefault: Boolean = False; ppCreated: PIz3DCheckBox = nil): HRESULT; stdcall;
    function AddRadioButton(ID: Integer; nButtonGroup: LongWord; strText: PWideChar; x, y, width, height: Integer; bChecked: Boolean = False; nHotkey: LongWord = 0; bIsDefault: Boolean = False; ppCreated: PIz3DRadioButton = nil): HRESULT; stdcall;
    function AddComboBox(ID: Integer; x, y, width, height: Integer; nHotKey: LongWord = 0; bIsDefault: Boolean = False; ppCreated: PIz3DComboBox = nil): HRESULT; stdcall;
    function AddTrackBar(ID: Integer; x, y, width, height: Integer; min: Integer = 0; max: Integer = 100; value: Integer = 50; bIsDefault: Boolean = False; ppCreated: PIz3DTrackBar = nil): HRESULT; stdcall;
    function AddEditBox(ID: Integer; strText: PWideChar; x, y, width, height: Integer; bIsDefault: Boolean = False; ppCreated: PIz3DEdit = nil): HRESULT; stdcall;
    function AddIMEEditBox(ID: Integer; strText: PWideChar; x, y, width, height: Integer; bIsDefault: Boolean = False; ppCreated: PIz3DIMEEditBox = nil): HRESULT; stdcall;
    function AddListBox(ID: Integer; x, y, width, height: Integer; dwStyle: Tz3DListBoxStyle = z3dlbsNormal; ppCreated: PIz3DListBox = nil): HRESULT; stdcall;
    function AddControl(const pControl: Iz3DControl): HRESULT; stdcall;
    function InitControl(const pControl: Iz3DControl): HRESULT; stdcall;
    function GetLabel(ID: Integer): Iz3DLabel;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
    function GetButton(ID: Integer): Iz3DButton;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
    function GetCheckBox(ID: Integer): Iz3DCheckBox;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
    function GetRadioButton(ID: Integer): Iz3DRadioButton;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
    function GetComboBox(ID: Integer): Iz3DComboBox;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
    function GetTrackBar(ID: Integer): Iz3DTrackBar;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
    function GetEditBox(ID: Integer): Iz3DEdit;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
    function GetIMEEditBox(ID: Integer): Iz3DIMEEditBox;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
    function GetListBox(ID: Integer): Iz3DListBox;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
    function GetControl(ID: Integer): Iz3DControl; overload; stdcall;
    function GetControlProp(ID: Integer): Iz3DControl;{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
    function GetControl(ID: Integer; nControlType: Tz3DControlType): Iz3DControl; overload; stdcall;
    function GetControlAtPoint(pt: TPoint): Iz3DControl; stdcall;
    function GetControlEnabled(ID: Integer): Boolean; stdcall;
    procedure SetControlEnabled(ID: Integer; bEnabled: Boolean); stdcall;
    procedure ClearRadioButtonGroup(nGroup: LongWord); stdcall;
    procedure ClearComboBox(ID: Integer); stdcall;
    function GetVisible: Boolean; stdcall;
    procedure SetVisible(const Value: Boolean); stdcall;
    function SetDefaultDisplay(nControlType: Tz3DControlType; iDisplay: LongWord; const pDisplay: Iz3DDisplay): HRESULT; stdcall;
    procedure SetRefreshTime(fTime: Single); { s_fTimeRefresh = fTime; } stdcall;
    function GetNextControl(pControl: Iz3DControl): Iz3DControl; stdcall;
    function GetPrevControl(pControl: Iz3DControl): Iz3DControl; stdcall;
    procedure ClearFocus; stdcall;
    function GetDefaultDisplay(nControlType: Tz3DControlType; iDisplay: LongWord): Iz3DDisplay; stdcall;
    procedure SendEvent(const AEvent: Tz3DControlEvent; bTriggeredByUser: Boolean; pControl: Iz3DControl); stdcall;
    procedure RequestFocus(pControl: Iz3DControl); stdcall;
    function DrawRect(const pRect: TRect; color: TD3DColor): HRESULT; stdcall;
    function DrawPolyLine(apPoints: PPoint; nNumPoints: LongWord; color: TD3DColor): HRESULT; stdcall;
    function DrawSprite(pDisplay: Iz3DDisplay; const prcDest: TRect): HRESULT; stdcall;
    function CalcTextRect(strText: PWideChar; pDisplay: Iz3DDisplay; prcDest: PRect; nCount: Integer = -1): HRESULT; stdcall;
    function DrawText(strText: PWideChar; pDisplay: Iz3DDisplay; const rcDest: TRect; bShadow: Boolean = False; nCount: Integer = -1): HRESULT; stdcall;
    procedure SetBackgroundColors(colorAllCorners: TD3DColor); overload; stdcall;
    procedure SetBackgroundColors(colorTopLeft, colorTopRight, colorBottomLeft, colorBottomRight: TD3DColor); overload; stdcall;
    procedure SetCaption(const pwszText: PWideChar); stdcall;
    procedure GetLocation(out Pt: TPoint); stdcall;
    function GetNextDialog: Iz3DDialog; stdcall;
    procedure SetLocation(x, y: Integer); stdcall;
    procedure SetSize(width, height: Integer); stdcall;
    function HasFocus: Boolean; stdcall;
    procedure SetFocus; stdcall;
    procedure SetPrevDialog(pNextDialog: Iz3DDialog); stdcall;
    function GetPrevDialog: Iz3DDialog; stdcall;
    procedure RemoveControl(ID: Integer); stdcall;
    procedure ShowModal; stdcall;
    procedure Show; stdcall;
    procedure Hide; stdcall;
    procedure Render; stdcall;
    procedure Message(const AWnd: HWND; const AMsg: Cardinal; const AwParam: Integer; const AlParam: Integer;
      var AHandled: Boolean); stdcall;
    procedure RemoveAllControls; stdcall;
    procedure SetCallback(pCallback: PCallbackz3DguiEvent; pUserContext: Pointer = nil); stdcall;
    procedure EnableNonUserEvents(bEnable: Boolean); stdcall;
    procedure EnableKeyboardInput(bEnable: Boolean); stdcall;
    procedure EnableMouseInput(bEnable: Boolean); stdcall;
    procedure Refresh; stdcall;
    function SetFont(index: LongWord; strFaceName: PWideChar; height, weight: Longint): HRESULT; stdcall;
    function GetFont(index: LongWord): Pz3DFontNode; stdcall;
    function SetTexture(index: LongWord; strFilename: PWideChar): HRESULT; overload; stdcall;
    function SetTexture(index: LongWord; strResourceName: PWideChar; hResourceModule: HMODULE): HRESULT; overload; stdcall;
    function GetTexture(index: LongWord): Pz3DTextureNode; stdcall;
    procedure FocusDefaultControl; stdcall;
    
    property Caption: PWideChar read GetCaption write SetCaption;
    property ModalMode: Boolean read GetModalMode;
    property Manager: Iz3DGUIController read GetManager;
    property Labels[ID: Integer]: Iz3DLabel read GetLabel;
    property Buttons[ID: Integer]: Iz3DButton read GetButton;
    property CheckBoxes[ID: Integer]: Iz3DCheckBox read GetCheckBox;
    property RadioButtons[ID: Integer]: Iz3DRadioButton read GetRadioButton;
    property ComboBoxes[ID: Integer]: Iz3DComboBox read GetComboBox;
    property TrackBars[ID: Integer]: Iz3DTrackBar read GetTrackBar;
    property Edits[ID: Integer]: Iz3DEdit read GetEditBox;
    property IMEEdits[ID: Integer]: Iz3DIMEEditBox read GetIMEEditBox;
    property ListBoxes[ID: Integer]: Iz3DListBox read GetListBox;
    property Controls[ID: Integer]: Iz3DControl read GetControlProp;
    property ControlIndex[AIndex: Integer]: Iz3DControl read GetControlIndex;
    property ControlCount: Integer read GetControlCount;
    property IsKeyboardInputEnabled: Boolean read GetKeyboardInput;
    property EnableCaption: Boolean read GetEnableCaption write SetEnableCaption;
    property EnableBackground: Boolean read GetEnableBackground write SetEnableBackground;
    property EnableBorder: Boolean read GetEnableBorder write SetEnableBorder;
    property DesktopOnly: Boolean read GetDesktopOnly write SetDesktopOnly;
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Visible: Boolean read GetVisible write SetVisible;
  end;

  // Message dialog type

  Iz3DMessageDialog = interface(Iz3DDialog)['{507F21FF-324F-44EC-BCDE-2FCC03A6E46A}']
    function GetKind: Tz3DMessageDialogKind; stdcall;
    procedure SetKind(const Value: Tz3DMessageDialogKind); stdcall;
    function ShowMessage(const ADesktop: Iz3DDesktop; const AMessage: PWideChar;
      const AKind: Tz3DMessageDialogKind): Tz3DDialogModalResult; stdcall;

    property Kind: Tz3DMessageDialogKind read GetKind write SetKind;
  end;

  Iz3DMainMenuDialog = interface(Iz3DDialog)['{A077351D-E880-4454-92BC-A3C78D25EED6}']
  end;

  Iz3DProgressDialog = interface(Iz3DDialog)['{6454B743-2264-4F44-81EF-04E3B05A4104}']
    function GetStatus: PWideChar; stdcall;
    procedure SetStatus(const AStatus: PWideChar); stdcall;
    procedure SetProgress(const APosition: Integer); stdcall;
    
    property Status: PWideChar read GetStatus write SetStatus;
  end;

  Iz3DConsoleDialog = interface(Iz3DDialog)['{CB92FB85-F900-4A76-B377-6B7DBBE94F1E}']
    procedure AddTrace(const AMessage: PWideChar; const AKind: Tz3DTraceKind); stdcall;
  end;

  Iz3DEngineSettingsDialog = interface(Iz3DDialog)['{F3B12C3A-4AC5-4EF9-B4DC-F6543991A343}']
  end;

  Iz3DControl = interface(Iz3DBase)['{B2987EF0-7BA7-4A4C-9517-D4E318A7B886}']
    function GetHeight: Integer; stdcall;
    function GetLeft: Integer; stdcall;
    function GetTop: Integer; stdcall;
    function GetWidth: Integer; stdcall;
    procedure SetHeight(const Value: Integer); stdcall;
    procedure SetLeft(const Value: Integer); stdcall;
    procedure SetTop(const Value: Integer); stdcall;
    procedure SetWidth(const Value: Integer); stdcall;
    procedure SetDialog(const Value: Iz3DDialog); stdcall;
    function GetIndex: LongWord; stdcall;
    function GetDialog: Iz3DDialog; stdcall;
    procedure SetIndex(const Value: LongWord); stdcall;
    function GetUserData: Pointer; stdcall;
    procedure SetUserData(const Value: Pointer); stdcall;
    function GetHotkey: LongWord; stdcall;
    function GetID: Integer; stdcall;
    function GetIsDefault: Boolean; stdcall;
    function GetType: Tz3DControlType; stdcall;
    function GetVisible: Boolean; stdcall;
    procedure SetHotkey(const Value: LongWord); stdcall;
    procedure SetID(const Value: Integer); stdcall;
    procedure SetIsDefault(const Value: Boolean); stdcall;
    procedure UpdateRects; stdcall;
    procedure SetEnabled(bEnabled: Boolean); stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure SetVisible(bVisible: Boolean); stdcall;
    procedure SetTextColor(Color: TD3DColor); stdcall;
    function GetDisplay(iDisplay: LongWord): Iz3DDisplay; stdcall;
    procedure SetDisplay(iDisplay: LongWord; const pDisplay: Iz3DDisplay); stdcall;
    function OnInit: HRESULT; stdcall;
    procedure Refresh; stdcall;
    procedure Render; stdcall;
    function MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; stdcall;
    function HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; stdcall;
    function HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; stdcall;
    function CanHaveFocus: Boolean; stdcall;
    procedure OnFocusIn; stdcall;
    procedure OnFocusOut; stdcall;
    procedure OnMouseEnter; stdcall;
    procedure OnMouseLeave; stdcall;
    procedure OnHotkey; stdcall;
    function ContainsPoint(pt: TPoint): LongBool; stdcall;
    procedure SetLocation(x, y: Integer); stdcall;
    procedure SetSize(width, height: Integer); stdcall;
    
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Display[i: LongWord]: Iz3DDisplay read GetDisplay write SetDisplay;
    property UserData: Pointer read GetUserData write SetUserData;
    property Dialog: Iz3DDialog read GetDialog write SetDialog;
    property ControlType: Tz3DControlType read GetType;
    property ID: Integer read GetID write SetID;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Visible: Boolean read GetVisible write SetVisible;
    property Default: Boolean read GetIsDefault write SetIsDefault;
    property Index: LongWord read GetIndex write SetIndex;
    property Hotkey: LongWord read GetHotkey write SetHotkey;
    property TextColor: TD3DColor write SetTextColor;
  end;

  // Static label control
  Iz3DLabel = interface(Iz3DControl)['{790F32E5-29C3-442C-8303-8789E56C7036}']
    function GetText: PWideChar; stdcall;
    procedure SetText(strText: PWideChar); stdcall;
    function GetTextCopy(strDest: PWideChar; bufferCount: LongWord): HRESULT; stdcall;
    
    property Text: PWideChar read GetText write SetText;
  end;

  Iz3DButton = interface(Iz3DLabel)['{931D35CB-2F31-4252-B999-200D427AA9DA}']
    function GetEnableBackground: Boolean; stdcall;
    procedure SetEnableBackground(const Value: Boolean); stdcall;
    function GetPressed: Boolean; stdcall;
    
    property Pressed: Boolean read GetPressed;
    property EnableBackground: Boolean read GetEnableBackground write SetEnableBackground;
  end;

  Iz3DCheckBox = interface(Iz3DButton)['{EDDCD52E-E946-4D60-9F8D-E20F48B7FE54}']
    function GetChecked: Boolean; stdcall;
    procedure SetChecked(bChecked: Boolean); stdcall;
    
    property Checked: Boolean read GetChecked write SetChecked;
  end;

  // RadioButton control
  Iz3DRadioButton = interface(Iz3DCheckBox)['{73753CE2-5EE7-45AF-A102-CA3C1B862555}']
    function GetButtonGroup: LongWord; stdcall;
    procedure SetButtonGroup(const Value: LongWord); stdcall;
    procedure SetChecked(bChecked: Boolean); overload; stdcall;
    procedure SetChecked(bChecked: Boolean; bClearGroup: Boolean = True); overload; stdcall;
    
    property ButtonGroup: LongWord read GetButtonGroup write SetButtonGroup;
  end;

  // ARROWSTATE indicates the state of the arrow buttons.
  // CLEAR            No arrow is down.
  // CLICKED_UP       Up arrow is clicked.
  // CLICKED_DOWN     Down arrow is clicked.
  // HELD_UP          Up arrow is held down for sustained period.
  // HELD_DOWN        Down arrow is held down for sustained period.
  Tz3DScrollBar_ArrayState = (CLEAR, CLICKED_UP, CLICKED_DOWN, HELD_UP, HELD_DOWN);

  Iz3DScrollBar = interface(Iz3DControl)['{376A2CD8-5FDF-4577-BF83-7362B0D593EE}']
    function GetPageSize: Integer; stdcall;
    function GetPosition: Integer; stdcall;
    procedure UpdateThumbRect; stdcall;
    procedure Cap; stdcall;
    procedure SetTrackPos(nPosition: Integer); stdcall;
    procedure SetPageSize(nPageSize: Integer); stdcall;
    procedure SetTrackRange(nStart, nEnd: Integer); stdcall;
    procedure Scroll(nDelta: Integer); stdcall;
    procedure ShowItem(nIndex: Integer); stdcall;
    
    property TrackPos: Integer read GetPosition write SetTrackPos;
    property PageSize: Integer read GetPageSize write SetPageSize;
  end;

  // ListBox control
  Pz3DListBoxItem = ^Tz3DListBoxItem;
  Tz3DListBoxItem = record
    strText: array[0..255] of WideChar;
    pData: Pointer;
    rcActive:  TRect;
    bSelected: Boolean;
  end;

  Iz3DListBox = interface(Iz3DControl)['{091AB4EE-25F6-4D8D-BA51-191B4768D09F}']
    function GetSBWidth: Integer; stdcall;
    function GetSelected: Integer; stdcall;
    function GetStyle: Tz3DListBoxStyle; stdcall;
    function GetSize: Integer; stdcall;
    procedure SetStyle(dwStyle: Tz3DListBoxStyle); stdcall;
    procedure SetScrollBarWidth(nWidth: Integer); stdcall;
    procedure SetBorder(nBorder, nMargin: Integer); stdcall;
    function AddItem(const wszText: PWideChar; pData: Pointer): HRESULT; stdcall;
    function InsertItem(nIndex: Integer; const wszText: PWideChar; pData: Pointer): HRESULT; stdcall;
    procedure RemoveItem(nIndex: Integer); stdcall;
    procedure RemoveItemByText(wszText: PWideChar); stdcall;
    procedure RemoveItemByData(pData: Pointer); stdcall;
    procedure RemoveAllItems; stdcall;
    function GetItem(nIndex: Integer): Pz3DListBoxItem; stdcall;
    function GetSelectedIndex(nPreviousSelected: Integer = -1): Integer; stdcall;
    function GetSelectedItem(nPreviousSelected: Integer = -1): Pz3DListBoxItem; stdcall;
    procedure SelectItem(nNewIndex: Integer); stdcall;
    
    property Items[Index: Integer]: Pz3DListBoxItem read GetItem;
    property ItemIndex: Integer read GetSelected write SelectItem;
    property SelectedIndex: Integer read GetSelected write SelectItem;
    property ScrollBarWidth: Integer read GetSBWidth write SetScrollBarWidth;
    property Style: Tz3DListBoxStyle read GetStyle write SetStyle;
    property Size: Integer read GetSize;
  end;

  Iz3DTraceListBox = interface(Iz3DListBox)['{81A79218-AE02-412E-B4AC-85E7B424E92E}']
  end;

  // ComboBox control
  Pz3DComboBoxItem = ^Tz3DComboBoxItem;
  Tz3DComboBoxItem = record
    strText: array[0..255] of WideChar;
    pData: Pointer;
    rcActive: TRect;
    bVisible: Boolean;
  end;

  Iz3DComboBox = interface(Iz3DButton)['{06CE6E19-3713-469B-BB53-93D4A48C397D}']
    function GetItemIndex: Integer; stdcall;
    function GetSBWidth: Integer; stdcall;
    function GetNumItems: LongWord; stdcall;
    function GetItem(index: LongWord): Pz3DComboBoxItem; stdcall;
    function AddItem(const strText: PWideChar; pData: Pointer): HRESULT; stdcall;
    procedure RemoveAllItems; stdcall;
    procedure RemoveItem(index: LongWord); stdcall;
    function ContainsItem(const strText: PWideChar; iStart: LongWord = 0): Boolean; stdcall;
    function FindItem(const strText: PWideChar; iStart: LongWord = 0): Integer; stdcall;
    function GetItemData(const strText: PWideChar): Pointer; overload; stdcall;
    function GetItemData(nIndex: Integer): Pointer; overload; stdcall;
    procedure SetDropHeight(nHeight: LongWord); stdcall;
    procedure SetScrollBarWidth(nWidth: Integer); stdcall;
    function GetSelectedData: Pointer; stdcall;
    function GetSelectedItem: Pz3DComboBoxItem; stdcall;
    function SetSelectedByIndex(index: LongWord): HRESULT; stdcall;
    function SetSelectedByText(const strText: PWideChar): HRESULT; stdcall;
    function SetSelectedByData(pData: Pointer): HRESULT; stdcall;
    
    property Item[index: LongWord]: Pz3DComboBoxItem read GetItem;
    property NumItems: LongWord read GetNumItems;
    property ScrollBarWidth: Integer read GetSBWidth write SetScrollBarWidth;
    property ItemIndex: Integer read GetItemIndex;
  end;

  Iz3DTrackBar = interface(Iz3DControl)['{FA8005DD-8E20-4647-A1A4-61FCC83A9B75}']
    function GetValue: Integer; stdcall;
    procedure SetValueInternal(nValue: Integer; bFromInput: Boolean); stdcall;
    function ValueFromPos(x: Integer): Integer; stdcall;
    procedure SetValue(nValue: Integer); stdcall;
    procedure GetRange(out nMin, nMax: Integer); stdcall;
    procedure SetRange(nMin, nMax: Integer); stdcall;
    
    property Value: Integer read GetValue write SetValue;
  end;

  Iz3DProgressBar = interface(Iz3DControl)['{FA8005DD-8E20-4647-A1A4-61FCC83A9B75}']
    function GetValue: Integer; stdcall;
    procedure SetValueInternal(nValue: Integer; bFromInput: Boolean); stdcall;
    function ValueFromPos(x: Integer): Integer; stdcall;
    procedure SetValue(nValue: Integer); stdcall;
    procedure GetRange(out nMin, nMax: Integer); stdcall;
    procedure SetRange(nMin, nMax: Integer); stdcall;
    
    property Value: Integer read GetValue write SetValue;
  end;

  Iz3DUniBuffer = interface(Iz3DBase)['{3941C071-12B8-4133-99C2-CB82B7F6D086}']
    function GetBufferSize: Integer; stdcall;
    function GetFontNode: Pz3DFontNode; stdcall;
    function GetwszBuffer: PWideChar; stdcall;
    procedure SetFontNode(const Value: Pz3DFontNode); stdcall;
    function Analyse: HRESULT; stdcall;
    function SetBufferSize(nNewSize: Integer): Boolean; stdcall;
    function GetTextSize: Integer; stdcall;
    function GetChar(i: Integer): WideChar; stdcall;
    procedure SetChar(i: Integer; ch: WideChar); stdcall;
    procedure Clear; stdcall;
    function InsertChar(nIndex: Integer; wChar: WideChar): Boolean; stdcall;
    function RemoveChar(nIndex: Integer): Boolean; stdcall;
    function InsertString(nIndex: Integer; const pStr: PWideChar; nCount: Integer = -1): Boolean; stdcall;
    procedure SetText(wszText: PWideChar); stdcall;
    function CPtoX(nCP: Integer; bTrail: BOOL; out pX: Integer): HRESULT; stdcall;
    function XtoCP(nX: Integer; out pCP: Integer; out pnTrail: LongBool): HRESULT; stdcall;
    procedure GetPriorItemPos(nCP: Integer; out pPrior: Integer); stdcall;
    procedure GetNextItemPos(nCP: Integer; out pPrior: Integer); stdcall;
    
    property BufferSize: Integer read GetBufferSize;
    property Buffer: PWideChar read GetwszBuffer;
    property Chars[i: Integer]: WideChar read GetChar write SetChar; default;
    property FontNode: Pz3DFontNode read GetFontNode write SetFontNode;
    property TextSize: Integer read GetTextSize;
  end;

  Iz3DEdit = interface(Iz3DControl)['{2B0E7EB4-84C5-4FF8-A9AF-59B85234F676}']
    function GetBorder: Integer; stdcall;
    procedure SetCaretColor(const Value: TD3DColor); stdcall;
    function GetCaretColor: TD3DColor; stdcall;
    function GetSelBkColor: TD3DColor; stdcall;
    function GetSelTextColor: TD3DColor; stdcall;
    function GetSpacing: Integer; stdcall;
    function GetTextColor: TD3DColor; stdcall;
    procedure SetSelBkColor(const Value: TD3DColor); stdcall;
    procedure SetSelTextColor(const Value: TD3DColor); stdcall;
    procedure PlaceCaret(nCP: Integer); stdcall;
    procedure DeleteSelectionText; stdcall;
    procedure ResetCaretBlink; stdcall;
    procedure CopyToClipboard; stdcall;
    procedure PasteFromClipboard; stdcall;
    function GetText: PWideChar; stdcall;
    procedure SetText_p(wszText: PWideChar);{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
    function GetTextLength: Integer; stdcall;
    procedure SetBorderWidth(nBorder: Integer); stdcall;
    procedure SetSpacing(nSpacing: Integer); stdcall;
    procedure SetText(wszText: PWideChar; bSelected: Boolean = False); stdcall;
    function GetTextCopy(strDest: PWideChar; bufferCount: LongWord): HRESULT; stdcall;
    procedure ClearText; stdcall;
    procedure ParseFloatArray(pNumbers: PSingle; nCount: Integer); stdcall;
    procedure SetTextFloatArray(pNumbers: PSingle; nCount: Integer); stdcall;
    
    property Text: PWideChar read GetText write SetText_p;
    property TextColor: TD3DColor read GetTextColor write SetTextColor;
    property TextLength: Integer read GetTextLength;
    property SelectedTextColor: TD3DColor read GetSelTextColor write SetSelTextColor;
    property SelectedBackColor: TD3DColor read GetSelBkColor write SetSelBkColor;
    property CaretColor: TD3DColor read GetCaretColor write SetCaretColor;
    property BorderWidth: Integer read GetBorder write SetBorderWidth;
    property Spacing: Integer read GetSpacing write SetSpacing;
  end;

  //-----------------------------------------------------------------------------
  // IME-enabled EditBox control
  //-----------------------------------------------------------------------------

  TIndicatorEnum = (INDICATOR_NON_IME, INDICATOR_CHS, INDICATOR_CHT, INDICATOR_KOREAN, INDICATOR_JAPANESE);
  TImeState = (IMEUI_STATE_OFF, IMEUI_STATE_ON, IMEUI_STATE_ENGLISH);

  TCandList = record
    awszCandidate: array[0..MAX_CANDLIST-1, 0..255] of WideChar;
    HoriCand: Iz3DUniBuffer;   // Candidate list string (for horizontal candidate window)
    nFirstSelected: Integer;   // First character position of the selected string in HoriCand
    nHoriSelectedLen: Integer; // Length of the selected string in HoriCand
    dwCount: DWORD;            // Number of valid entries in the candidate list
    dwSelection: DWORD;        // Currently selected candidate entry relative to page top
    dwPageSize: DWORD;
    nReadingError: Integer;    // Index of the error character
    bShowWindow:  BOOL;        // Whether the candidate list window is visible
    rcCandidate:  TRect;       // Candidate rectangle computed and filled each time before rendered
  end;

  TInputLocale = record
    m_hKL: HKL;            // Keyboard layout
    FLangAbb: array[0..2] of WideChar;  // Language abbreviation
    FLang: array[0..63] of WideChar;    // Localized language name
  end;

  Iz3DIMEEditBox = interface(Iz3DEdit)['{2A6A8D11-39BD-4EF8-8ED6-1038FC348A5A}']
    procedure TruncateCompString(bUseBackSpace: Boolean = True; iNewStrLen: Integer = 0); stdcall;
    procedure FinalizeString(bSend: Boolean); stdcall;
    procedure SendCompString; stdcall;
    procedure PumpMessage; stdcall;
    procedure RenderCandidateReadingWindow(bReading: Boolean); stdcall;
    procedure RenderComposition; stdcall;
    procedure RenderIndicator; stdcall;
  end;

const
  MAX_CONTROL_STATES = Ord(High(Tz3DControlState))+1;

const
  WM_XBUTTONDOWN   = $020B; // (not always defined)
  WM_XBUTTONUP     = $020C; // (not always defined)
  WM_XBUTTONDBLCLK = $020D;
  WM_MOUSEWHEEL    = $020A; // (not always defined)
  WHEEL_DELTA      = 120;   // (not always defined)

  MK_XBUTTON1         = $0020;
  MK_XBUTTON2         = $0040;

implementation

end.
