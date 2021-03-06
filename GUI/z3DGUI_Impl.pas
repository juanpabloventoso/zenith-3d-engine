unit z3DGUI_Impl;

interface

uses
  Windows, Messages, Classes, imm, usp10, DXTypes, Direct3D9, D3DX9, dxerr9,
  z3DClasses_Impl, z3DGUI_Intf, z3DMath_Intf, z3DComponents_Intf,
  z3DClasses_Intf, z3DCore_Intf;

type

  Tz3DGUIController = class;
  Tz3DDesktop = class;
  Tz3DDialog = class;
  Tz3DControl = class;
  Tz3DButton = class;
  Tz3DLabel = class;
  Tz3DCheckBox = class;
  Tz3DRadioButton = class;
  Tz3DComboBox = class;
  Tz3DTrackBar = class;
  Tz3DEdit = class;
  Tz3DIMEEditBox = class;
  Tz3DListBox = class;
  Tz3DScrollBar = class;
  Tz3DDisplay = class;

  Tz3DBlendColor = class(Tz3DBase, Iz3DBlendColor)
  private
    FStates: Tz3DBlendColorStates;
    FCurrent: TD3DXColor;
  protected
    procedure SetCurrent(const Value: TD3DXColor); stdcall;
    function GetStates: Pz3DBlendColorStates; stdcall;
    procedure SetStates(const Value: Pz3DBlendColorStates); stdcall;
    function GetCurrent: TD3DXColor; stdcall;
  public
    procedure SetColors(defaultColor: TD3DColor; disabledColor: TD3DColor = $C8808080; hiddenColor: TD3DColor = 0); stdcall;
    procedure Blend(iState: Tz3DControlState; fRate: Single = 0.7); stdcall;
  public
    property Current: TD3DXColor read GetCurrent write SetCurrent;
    property States: Pz3DBlendColorStates read GetStates write SetStates;
  end;

  Tz3DGUIController = class(Tz3DBase, Iz3DGUIController)
  private
    FModalMode: Boolean;
    FTextureCache: array of Pz3DTextureNode;
    FFontCache: array of Pz3DFontNode;
    FStateBlock: IDirect3DStateBlock9;
    FSprite: ID3DXSprite;
    FDialogs: IInterfaceList;
    FDesktop: Iz3DDesktop;
  protected
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
    procedure CreateScenarioObjects(const AResetDevice: Boolean); stdcall;
    procedure DestroyScenarioObjects(const ALostDevice: Boolean); stdcall;
    procedure Message(const AWnd: HWND; const AMsg: Cardinal;
      const AwParam: Integer; const AlParam: Integer;
      var ADefault: Boolean; var AResult: Integer); stdcall;
    procedure BringToFront(const ADialog: Iz3DDialog); stdcall;
    procedure GUIRender; stdcall;
  public
    constructor Create(const ADesktop: Iz3DDesktop); reintroduce;
    destructor Destroy; override;
    function AddFont(strFaceName: PWideChar; height, weight: Longint): Integer; stdcall;
    function CreateTexture(iTexture: LongWord): HRESULT;
    function AddTexture(strFilename: PWideChar): Integer; overload; stdcall;
    function AddTexture(strResourceName: PWideChar; hResourceModule: HMODULE): Integer; overload; stdcall;
    function RegisterDialog(pDialog: Iz3DDialog): Boolean; stdcall;
    function IndexOf(const ADialog: Iz3DDialog): Integer; stdcall;
    procedure UnregisterDialog(pDialog: Iz3DDialog); stdcall;
    procedure EnableKeyboardInputForAllDialogs; stdcall;
    function GetStateBlock: IDirect3DStateBlock9; stdcall;
  public
    property ModalMode: Boolean read GetModalMode write SetModalMode;
    property Desktop: Iz3DDesktop read GetDesktop;
    property Fonts[I: Integer]: Pz3DFontNode read GetFonts;
    property FontsCount: Integer read GetFontsCount;
    property TextureNode[i: Integer]: Pz3DTextureNode read GetTextureNode;
    property TextureNodeCount: Integer read GetTextureNodeCount;
    property Sprite: ID3DXSprite read GetSprite;
    property DialogCount: Integer read GetDialogCount;
    property Dialogs[const I: Integer]: Iz3DDialog read GetDialogs;
  end;

  Tz3DGUIFont = class(Tz3DBase, Iz3DGUIFont)
  private
    FColor: Iz3DFloat4;
    FFormat: DWORD;
    FName: array[0..255] of WideChar;
    FShadow: Boolean;
    FSize: Integer;
  protected
    function GetColor: Iz3DFloat4; stdcall;
    function GetFormat: DWORD; stdcall;
    function GetName: PWideChar; stdcall;
    function GetShadow: Boolean; stdcall;
    function GetSize: Integer; stdcall;
    procedure SetFormat(const Value: DWORD); stdcall;
    procedure SetShadow(const Value: Boolean); stdcall;
    procedure SetSize(const Value: Integer); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property Name: PWideChar read GetName;
    property Size: Integer read GetSize write SetSize;
    property Color: Iz3DFloat4 read GetColor;
    property Shadow: Boolean read GetShadow write SetShadow;
    property Format: DWORD read GetFormat write SetFormat;
  end;

  Tz3DDesktopThemeSettings = class(Tz3DBase, Iz3DDesktopThemeSettings)
  private
    FCheckBoxFont: Iz3DGUIFont;
    FDefaultFont: Iz3DGUIFont;
    FRadioButtonFont: Iz3DGUIFont;
    FDialogColorBL: Iz3DFloat4;
    FDialogColorBR: Iz3DFloat4;
    FDialogColorTL: Iz3DFloat4;
    FDialogColorTR: Iz3DFloat4;
    FCaptionHeight: Integer;
  protected
    function GetCaptionHeight: Integer; stdcall;
    procedure SetCaptionHeight(const Value: Integer); stdcall;
    function GetCheckBoxFont: Iz3DGUIFont; stdcall;
    function GetDefaultFont: Iz3DGUIFont;  stdcall;
    function GetDialogColorBL: Iz3DFloat4; stdcall;
    function GetDialogColorBR: Iz3DFloat4; stdcall;
    function GetDialogColorTL: Iz3DFloat4; stdcall;
    function GetDialogColorTR: Iz3DFloat4; stdcall;
    function GetRadioButtonFont: Iz3DGUIFont; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property DialogColorTL: Iz3DFloat4 read GetDialogColorTL;
    property DialogColorTR: Iz3DFloat4 read GetDialogColorTR;
    property DialogColorBL: Iz3DFloat4 read GetDialogColorBL;
    property DialogColorBR: Iz3DFloat4 read GetDialogColorBR;
    property CaptionHeight: Integer read GetCaptionHeight write SetCaptionHeight;
    property DefaultFont: Iz3DGUIFont read GetDefaultFont;
    property CheckBoxFont: Iz3DGUIFont read GetCheckBoxFont;
    property RadioButtonFont: Iz3DGUIFont read GetRadioButtonFont;
  end;

  Tz3DDesktop = class(Tz3DLinked, Iz3DDesktop)
  private
    FVisible: Boolean;
    FProgress: Iz3DProgressDialog;
    FMainMenu: Iz3DMainMenuDialog;
    FConsole: Iz3DConsoleDialog;
    FWallpaper: Iz3DTexture;
    FLogo: Iz3DTexture;
    FBlurWallpaperTemp: Iz3DRenderTexture;
    FBlurWallpaperFinal: Iz3DRenderTexture;
    FFirstRender: Boolean;
    FBlurWallpaper: Boolean;
    FGUIController: Iz3DGUIController;
    FThemeSettings: Iz3DDesktopThemeSettings;
  protected
    function GetConsole: Iz3DConsoleDialog; stdcall;
    function GetVisible: Boolean; stdcall;
    procedure SetVisible(const Value: Boolean); stdcall;
    function GetProgressDialog: Iz3DProgressDialog; stdcall;
    function GetThemeSettings: Iz3DDesktopThemeSettings; stdcall;
    function GetGUIController: Iz3DGUIController; stdcall;
    procedure RenderEngineLogo; stdcall;
    function GetBlurWallpaper: Boolean; stdcall;
    procedure SetBlurWallpaper(const Value: Boolean); stdcall;
    function GetWallpaper: Iz3DTexture; stdcall;
    procedure z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller); override; stdcall;
    procedure z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller); override; stdcall;
    procedure z3DMessage(const AWnd: HWND; const AMsg: Cardinal;
      const AwParam: Integer; const AlParam: Integer;
      var ADefault: Boolean; var AResult: Integer); override; stdcall;
    procedure z3DGUIRender; override; stdcall;
  public
    procedure StartScenario; stdcall;

    procedure BringToFront(const ADialog: Iz3DDialog); stdcall;
    function ShowMessage(const AMessage: PWideChar; const AKind:
      Tz3DMessageDialogKind = z3dmdkInformation): Tz3DDialogModalResult; stdcall;

    function CreateDialog: Iz3DDialog; stdcall;
    function CreateProgressDialog: Iz3DProgressDialog; stdcall;
    function CreateMainMenuDialog: Iz3DMainMenuDialog; stdcall;
    function CreateConsoleDialog: Iz3DConsoleDialog; stdcall;
    function CreateEngineSettingsDialog: Iz3DEngineSettingsDialog; stdcall;

    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    property Visible: Boolean read GetVisible write SetVisible;
    property ProgressDialog: Iz3DProgressDialog read GetProgressDialog;
    property Console: Iz3DConsoleDialog read GetConsole;
    property Wallpaper: Iz3DTexture read GetWallpaper;
    property BlurWallpaper: Boolean read GetBlurWallpaper write SetBlurWallpaper;
    property Controller: Iz3DGUIController read GetGUIController;
    property ThemeSettings: Iz3DDesktopThemeSettings read GetThemeSettings;
  end;

  Tz3DTextHelper = class(Tz3DBase, Iz3DTextHelper)
  private
    FFont: ID3DXFont;
    FSprite: ID3DXSprite;
    FClr: TD3DXColor;
    FPt: TPoint;
    FLineHeight: Integer;
  public
    constructor Create(pFont: ID3DXFont; pSprite: ID3DXSprite; nLineHeight: Integer);
    destructor Destroy; override;
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
  Tz3DDisplay = class(Tz3DBase, Iz3DDisplay)
  private
    iTexture: LongWord;      // Index of the texture for this Display
    iFont: LongWord;         // Index of the font for this Display
    dwTextFormat: DWORD;     // The format argument to DrawText
    rcTexture: TRect;        // Bounding rect of this element on the composite texture
    FTextureColor: Iz3DBlendColor;
    FFontColor: Iz3DBlendColor;
  protected
    function GetTexture: LongWord; stdcall;
    function GetTextureRect: TRect; stdcall;
    function GetFontColor: Iz3DBlendColor; stdcall;
    function GetTextureColor: Iz3DBlendColor; stdcall;
    procedure SetFontColor(const Value: Iz3DBlendColor); stdcall;
    procedure SetTextureColor(const Value: Iz3DBlendColor); stdcall;
    procedure SetTextFormat(const Value: DWORD); stdcall;
    function GetFont: LongWord; stdcall;
    procedure SetFont(const Value: LongWord); stdcall;
    function GetTextFormat: DWORD; stdcall;
    procedure AssignTo(Dest: Iz3DBase); stdcall;
    procedure Assign(Source: Iz3DBase); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;
    procedure SetTexture(iTexture: LongWord; prcTexture: PRect; defaultTextureColor: TD3DColor = $FFFFFFFF); stdcall;
    procedure SetFontParams(iFont: LongWord; defaultFontColor: TD3DColor = $FF000000;
      dwTextFormat: DWORD = DT_CENTER or DT_VCENTER); stdcall;
    procedure Refresh; stdcall;
  public
    property TextFormat: DWORD read GetTextFormat write SetTextFormat;
    property Font: LongWord read GetFont write SetFont;
    property FontColor: Iz3DBlendColor read GetFontColor write SetFontColor;
    property TextureColor: Iz3DBlendColor read GetTextureColor write SetTextureColor;
    property TextureRect: TRect read GetTextureRect;
    property Texture: LongWord read GetTexture;
  end;

  // Dialog class
  Tz3DDialog = class(Tz3DLinked, Iz3DDialog)
  private
    FModalResult: Tz3DDialogModalResult;
    FModalMode: Boolean;
    FMousePoint: TPoint;
    FMousePointO: TPoint;
    FVisible: Boolean;
    FCaption: Boolean;
    FDrag: Boolean;
    FCaptionStr: array[0..255] of WideChar;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
    m_colorTopLeft: TD3DColor;
    m_colorTopRight: TD3DColor;
    m_colorBottomLeft: TD3DColor;
    m_colorBottomRight: TD3DColor;
    FManager: Iz3DGUIController;
    FCallbackEvent: PCallbackz3DGUIEvent;
    FCallbackEventUserContext: Pointer;
    m_Textures: array of Integer;
    m_Fonts: array of Integer;   
    m_Controls: IInterfacelist;
    m_DefaultDisplays: array of Pz3DDisplayHolder;
    m_CapDisplay: Iz3DDisplay;
    FNextDialog: Iz3DDialog;
    FPrevDialog: Iz3DDialog;
    FNonUserEvents: Boolean;
    FKeyboardInput: Boolean;
    FMouseInput: Boolean;
    FDefaultControlID: Integer;
    m_fTimeLastRefresh: Double;
    FControlMouseOver: Iz3DControl;
    FEnableBackground: Boolean;
    FEnableBorder: Boolean;
    FDesktopOnly: Boolean;
  protected
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
    function GetModalResult: Tz3DDialogModalResult; stdcall;
    procedure SetModalResult(const Value: Tz3DDialogModalResult); stdcall;
    function GetModalMode: Boolean; stdcall;
    function GetControlIndex(AIndex: Integer): Iz3DControl; stdcall;
    function GetVisible: Boolean; stdcall;
    procedure SetVisible(const Value: Boolean); virtual; stdcall; 
    function GetControlCount: Integer; stdcall;
    function GetEnableCaption: Boolean; stdcall;
    function GetHeight: Integer; stdcall;
    function GetKeyboardInput: Boolean; stdcall;
    function GetManager: Iz3DGUIController; stdcall;
    function GetWidth: Integer; stdcall;
    procedure SetEnableCaption(const Value: Boolean); stdcall;
    procedure SetHeight(const Value: Integer); stdcall;
    procedure SetWidth(const Value: Integer); stdcall;
    // Initialize default Displays
    procedure InitDefaultDisplays; stdcall;
    // Windows message handlers
    procedure OnMouseMove(pt: TPoint); stdcall;
    {$HINTS OFF}
    procedure OnMouseUp(pt: TPoint); stdcall;
    {$HINTS ON}
    procedure SetNextDialog(pNextDialog: Iz3DDialog); stdcall;
    function GetNextDialog: Iz3DDialog; stdcall;
    procedure SetPrevDialog(pNextDialog: Iz3DDialog); stdcall;
    function GetPrevDialog: Iz3DDialog; stdcall;
    function OnCycleFocus(bForward: Boolean): Boolean; stdcall;
    procedure Render; virtual; stdcall;
    procedure Message(const AWnd: HWND; const AMsg: Cardinal; const AwParam: Integer; const AlParam: Integer;
      var AHandled: Boolean); stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    destructor Destroy; override;
    // Need to call this now
    procedure InitDialog(pManager: Iz3DGUIController; bRegisterDialog: Boolean = True); overload; stdcall;
    procedure InitDialog(pManager: Iz3DGUIController; bRegisterDialog: Boolean; const pszControlTextureFilename: PWideChar); overload; stdcall;
    procedure InitDefaultDialog(pManager: Iz3DGUIController); stdcall;
    procedure InitDialog(pManager: Iz3DGUIController; bRegisterDialog: Boolean; szControlTextureResourceName: PWideChar; hControlTextureResourceModule: HMODULE); overload; stdcall;
    // Control creation
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
    // Control retrieval
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
    // Access the default display Displays used when adding new controls
    function SetDefaultDisplay(nControlType: Tz3DControlType; iDisplay: LongWord; const pDisplay: Iz3DDisplay): HRESULT; stdcall;
    function GetDefaultDisplay(nControlType: Tz3DControlType; iDisplay: LongWord): Iz3DDisplay; stdcall;
    // Methods called by controls
    procedure SendEvent(const AEvent: Tz3DControlEvent; bTriggeredByUser: Boolean; pControl: Iz3DControl); stdcall;
    procedure RequestFocus(pControl: Iz3DControl); stdcall;
    // Render helpers
    function DrawRect(const pRect: TRect; color: TD3DColor): HRESULT; stdcall;
    function DrawPolyLine(apPoints: PPoint; nNumPoints: LongWord; color: TD3DColor): HRESULT; stdcall;
    function DrawSprite(pDisplay: Iz3DDisplay; const prcDest: TRect): HRESULT; stdcall;
    function CalcTextRect(strText: PWideChar; pDisplay: Iz3DDisplay; prcDest: PRect; nCount: Integer = -1): HRESULT; stdcall;
    function DrawText(strText: PWideChar; pDisplay: Iz3DDisplay; const rcDest: TRect; bShadow: Boolean = False; nCount: Integer = -1): HRESULT; stdcall;
    // Attributes
    procedure SetBackgroundColors(colorAllCorners: TD3DColor); overload; stdcall;
    procedure SetBackgroundColors(colorTopLeft, colorTopRight, colorBottomLeft, colorBottomRight: TD3DColor); overload; stdcall;
    procedure SetCaption(const pwszText: PWideChar); stdcall;
    procedure GetLocation(out Pt: TPoint); stdcall;
    procedure SetLocation(x, y: Integer); stdcall;
    procedure SetSize(width, height: Integer); stdcall;
    procedure SetRefreshTime(fTime: Single); { s_fTimeRefresh = fTime; } stdcall;
    function GetNextControl(pControl: Iz3DControl): Iz3DControl; stdcall;
    function GetPrevControl(pControl: Iz3DControl): Iz3DControl; stdcall;
    procedure ClearFocus; stdcall;
    procedure RemoveControl(ID: Integer); stdcall;
    procedure RemoveAllControls; stdcall;
    // Sets the callback used to notify the app of control events
    procedure SetCallback(pCallback: PCallbackz3DguiEvent; pUserContext: Pointer = nil); stdcall;
    procedure EnableNonUserEvents(bEnable: Boolean); stdcall;
    procedure EnableKeyboardInput(bEnable: Boolean); stdcall;
    procedure EnableMouseInput(bEnable: Boolean); stdcall;
    // Device state notification
    procedure Refresh; stdcall;
    // Shared resource access. Indexed fonts and textures are shared among
    // all the controls.
    function SetFont(index: LongWord; strFaceName: PWideChar; height, weight: Longint): HRESULT; stdcall;
    function GetFont(index: LongWord): Pz3DFontNode; stdcall;
    function SetTexture(index: LongWord; strFilename: PWideChar): HRESULT; overload; stdcall;
    function SetTexture(index: LongWord; strResourceName: PWideChar; hResourceModule: HMODULE): HRESULT; overload; stdcall;
    function GetTexture(index: LongWord): Pz3DTextureNode; stdcall;
    function HasFocus: Boolean; stdcall;
    procedure SetFocus; stdcall;
    procedure FocusDefaultControl; stdcall;
    procedure ShowModal; stdcall;
    procedure Show; stdcall;
    procedure Hide; stdcall;
  public
    property ModalResult: Tz3DDialogModalResult read GetModalResult write SetModalResult;
    property ModalMode: Boolean read GetModalMode;
    property Caption: PWideChar read GetCaption write SetCaption;
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

  Tz3DMessageDialog = class(Tz3DDialog, Iz3DMessageDialog)
  private
    FMessageLabel: Iz3DLabel;
    FButton1: Iz3DButton;
    FButton2: Iz3DButton;
    FButton3: Iz3DButton;
    FKind: Tz3DMessageDialogKind;
  protected
    function GetKind: Tz3DMessageDialogKind; stdcall;
    procedure SetKind(const Value: Tz3DMessageDialogKind); stdcall;
    function ShowMessage(const ADesktop: Iz3DDesktop; const AMessage: PWideChar;
      const AKind: Tz3DMessageDialogKind): Tz3DDialogModalResult; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    class function New(const ADesktop: Iz3DDesktop; const AMessage: PWideChar;
      const AKind: Tz3DMessageDialogKind = z3dmdkInformation): Tz3DDialogModalResult;
  public
    property Kind: Tz3DMessageDialogKind read GetKind write SetKind;
  end;

  Tz3DMainMenuDialog = class(Tz3DDialog, Iz3DMainMenuDialog)
  private
    FStartButton: Iz3DButton;
    FSettingsButton: Iz3DButton;
    FQuitButton: Iz3DButton;
    FStartHint: Iz3DLabel;
    FSettingsHint: Iz3DLabel;
    FQuitHint: Iz3DLabel;
  protected
    procedure z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller); override; stdcall;
    procedure z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller); override; stdcall;
    procedure z3DStartScenario(const AStage: Tz3DStartScenarioStage); override; stdcall;
    procedure z3DStopScenario; override; stdcall;
  public
    class function New(const ADesktop: Iz3DDesktop): Iz3DMainMenuDialog;
    constructor Create(const AOwner: Iz3DBase = nil); override;
    procedure Render; override;
  public
  end;

  Tz3DProgressDialog = class(Tz3DDialog, Iz3DProgressDialog)
  private
    FProgress: Iz3DProgressBar;
    FLabel: Iz3DLabel;
    FCancelButton: Iz3DButton;
  public
    class function New(const ADesktop: Iz3DDesktop): Iz3DProgressDialog;
    constructor Create(const AOwner: Iz3DBase = nil); override;
  public
    function GetStatus: PWideChar; stdcall;
    procedure SetStatus(const AStatus: PWideChar); stdcall;
    procedure SetProgress(const APosition: Integer); stdcall;
  public
    property Status: PWideChar read GetStatus write SetStatus;
  end;

  Tz3DConsoleDialog = class(Tz3DDialog, Iz3DConsoleDialog)
  private
    FFirstReset: Boolean;
    FInput: Iz3DEdit;
    FLog: Iz3DTraceListBox;
    FSend: Iz3DButton;
    FClear: Iz3DButton;
  protected
    procedure z3DResetDevice; override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
    procedure AddTrace(const AMessage: PWideChar; const AKind: Tz3DTraceKind); stdcall;
  public
  end;


  
{==============================================================================}
{== Engine configuration dialog                                              ==}
{==============================================================================}
{== Allows to change the engine settings, post process configuration or      ==}
{== select the quality renderization                                         ==}
{==============================================================================}

  Tz3DLightingSettingsDialog = class(Tz3DDialog)
  protected
    procedure CreateControls;
    procedure ApplySettings;
    procedure RefreshSettings;
  public
    procedure SetVisible(const Value: Boolean); override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  end;

  Tz3DRendererSettingsDialog = class(Tz3DDialog)
  protected
    procedure CreateControls;
    procedure ApplySettings;
    procedure RefreshSettings;
  public
    procedure SetVisible(const Value: Boolean); override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  end;

  Tz3DEngineSettingsDialog = class(Tz3DDialog, Iz3DEngineSettingsDialog)
  private
    FLightingSettings: Tz3DLightingSettingsDialog;
    FRendererSettings: Tz3DRendererSettingsDialog;
  protected
    procedure CreateControls;
    procedure ApplyDeviceSettings;
    function GetCurrentAdapterInfo: Iz3DEnumAdapterInfo;
    function GetCurrentDeviceInfo: Iz3DEnumDeviceInfo;
    function GetCurrentDeviceSettingsCombo: PD3DDeviceSettingsCombinations;
    procedure AddAdapter(const ADescription: PWideChar; const AAdapter: LongWord);
    function GetSelectedAdapter: LongWord;
    procedure SetWindowed(const AWindowed: Boolean);
    function IsWindowed: Boolean;
    procedure AddResolution(const AWidth, AHeight: DWORD);
    procedure GetSelectedResolution(out AWidth, AHeight: DWORD);
    function OnAdapterChanged: HRESULT;
    function OnWindowedFullScreenChanged: HRESULT;
    function OnResolutionChanged: HRESULT;
    function OnAdapterFormatChanged: HRESULT;

    procedure RefreshDeviceSettings;
  public
    procedure SetVisible(const Value: Boolean); override; stdcall;
  public
    constructor Create(const AOwner: Iz3DBase = nil); override;
  end;

  Tz3DControlClass = class of Tz3DControl;

  Tz3DControl = class(Tz3DBase, Iz3DControl)
  private
    FLeft, FTop: Integer;
    FWidth, FHeight: Integer;
    FDialog: Iz3DDialog;
    m_Index: LongWord;
    m_ID:  Integer;
    m_Type: Tz3DControlType;
    FHotkey: LongWord;
    FUserData: Pointer;
    FEnabled: Boolean;
    FVisible: Boolean;
    FBoundingBox: TRect;
    FMouseOver: Boolean;
    FHasFocus: Boolean;
    FIsDefault: Boolean;
    m_Displays: array of Iz3DDisplay;
  protected
    function GetHeight: Integer; stdcall;
    function GetLeft: Integer; stdcall;
    function GetTop: Integer; stdcall;
    function GetWidth: Integer; stdcall;
    procedure SetHeight(const Value: Integer); stdcall;
    procedure SetLeft(const Value: Integer); stdcall;
    procedure SetTop(const Value: Integer); stdcall;
    procedure SetWidth(const Value: Integer); stdcall;
    procedure SetDialog(const Value: Iz3DDialog); virtual; stdcall;
    function GetDialog: Iz3DDialog; stdcall;
    function GetIndex: LongWord; stdcall;
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
    procedure UpdateRects; virtual; stdcall;
    procedure SetEnabled(bEnabled: Boolean); virtual; stdcall;
    function GetEnabled: Boolean; virtual; stdcall;
    procedure SetVisible(bVisible: Boolean); virtual; stdcall;
    procedure SetTextColor(Color: TD3DColor); virtual; stdcall;
    function GetDisplay(iDisplay: LongWord): Iz3DDisplay; stdcall;
    procedure SetDisplay(iDisplay: LongWord; const pDisplay: Iz3DDisplay); stdcall;
  public
    constructor Create(const pDialog: Iz3DDialog = nil); virtual;
    destructor Destroy; override;
    function OnInit: HRESULT; virtual; stdcall;
    procedure Refresh; virtual; stdcall;
    procedure Render; virtual;  stdcall;
    // Windows message handler
    function MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; virtual; stdcall;
    function HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; virtual; stdcall;
    function HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; virtual; stdcall;
    function CanHaveFocus: Boolean; virtual; stdcall;
    procedure OnFocusIn; virtual; stdcall;
    procedure OnFocusOut; virtual; stdcall;
    procedure OnMouseEnter; virtual; stdcall;
    procedure OnMouseLeave; virtual; stdcall;
    procedure OnHotkey; virtual;  stdcall;
    function ContainsPoint(pt: TPoint): LongBool; virtual; stdcall;
    procedure SetLocation(x, y: Integer); stdcall;
    procedure SetSize(width, height: Integer); stdcall;
  public
    property Display[i: LongWord]: Iz3DDisplay read GetDisplay write SetDisplay;
    property UserData: Pointer read GetUserData write SetUserData;
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Dialog: Iz3DDialog read GetDialog write SetDialog;
    property ControlType: Tz3DControlType read GetType;
    property ID: Integer read GetID write SetID;
    property Index: LongWord read GetIndex write SetIndex;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Visible: Boolean read GetVisible write SetVisible;
    property Default: Boolean read GetIsDefault write SetIsDefault;
    property Hotkey: LongWord read GetHotkey write SetHotkey;
    property TextColor: TD3DColor write SetTextColor;
  end;

  // Static label control
  Tz3DLabel = class(Tz3DControl, Iz3DLabel)
  private
    m_strText: array[0..MAX_PATH-1] of WideChar;
  protected
    function GetText: PWideChar; stdcall;
    procedure SetText(strText: PWideChar); stdcall;
  public
    constructor Create(const pDialog: Iz3DDialog = nil); override;
    procedure Render; override;
    function ContainsPoint(pt: TPoint): LongBool; override; stdcall;
    function GetTextCopy(strDest: PWideChar; bufferCount: LongWord): HRESULT; stdcall;
  public
    property Text: PWideChar read GetText write SetText;
  end;

  Tz3DButton = class(Tz3DLabel, Iz3DButton)
  private
    FPressed: Boolean;
    FEnableBackground: Boolean;
  protected
    function GetEnableBackground: Boolean; stdcall;
    procedure SetEnableBackground(const Value: Boolean); stdcall;
    function GetPressed: Boolean; stdcall;
  public
    constructor Create(const pDialog: Iz3DDialog = nil); override;
    function HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    function HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    procedure OnHotkey; override; stdcall;
    function ContainsPoint(pt: TPoint): LongBool; override; stdcall;
    function CanHaveFocus: Boolean; override; stdcall;
    procedure Render; override; stdcall;
  public
    property Pressed: Boolean read GetPressed;
    property EnableBackground: Boolean read GetEnableBackground write SetEnableBackground;
  end;

  Tz3DCheckBox = class(Tz3DButton, Iz3DCheckBox)
  private
    FChecked: Boolean;
    FButton: TRect;
    FText: TRect;
  protected
    function GetChecked: Boolean; virtual; stdcall;
    procedure SetChecked(bChecked: Boolean); virtual; stdcall;
    procedure SetCheckedInternal(bChecked, bFromInput: Boolean); virtual; stdcall;
  public
    constructor Create(const pDialog: Iz3DDialog = nil); override;
    function HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    function HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    procedure OnHotkey; override; stdcall;
    function ContainsPoint(pt: TPoint): LongBool; override; stdcall;
    procedure UpdateRects; override; stdcall;
    procedure Render; override; stdcall;
  public
    property Checked: Boolean read GetChecked write SetChecked;
  end;

  // RadioButton control
  Tz3DRadioButton = class(Tz3DCheckBox, Iz3DRadioButton)
  private
    FButtonGroup: LongWord;
  protected
    procedure SetChecked(bChecked: Boolean); overload; override; stdcall;
    function GetButtonGroup: LongWord; stdcall;
    procedure SetButtonGroup(const Value: LongWord); stdcall;
    procedure SetCheckedInternal(bChecked, bClearGroup, bFromInput: Boolean); reintroduce; virtual; stdcall;
  public
    constructor Create(const pDialog: Iz3DDialog = nil); override;
    function HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    function HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    procedure OnHotkey; override; stdcall;
    procedure SetChecked(bChecked: Boolean; bClearGroup: Boolean = True); reintroduce; overload; stdcall;
  public
    property ButtonGroup: LongWord read GetButtonGroup write SetButtonGroup;
  end;

  // ARROWSTATE indicates the state of the arrow buttons.
  // CLEAR            No arrow is down.
  // CLICKED_UP       Up arrow is clicked.
  // CLICKED_DOWN     Down arrow is clicked.
  // HELD_UP          Up arrow is held down for sustained period.
  // HELD_DOWN        Down arrow is held down for sustained period.
  Tz3DScrollBar_ArrayState = (CLEAR, CLICKED_UP, CLICKED_DOWN, HELD_UP, HELD_DOWN);

  Tz3DScrollBar = class(Tz3DControl, Iz3DScrollBar)
  private
    FShowThumb: Boolean;
    FDrag: Boolean;
    FUpButton: TRect;
    FDownButton: TRect;
    FTrack: TRect;
    FThumb: TRect;
    FPosition: Integer;
    FPageSize: Integer;
    FStart: Integer;
    FEnd: Integer;
    m_LastMouse: TPoint;
    m_Arrow: Tz3DScrollBar_ArrayState;
    m_dArrowTS: Double;
  protected
    function GetPageSize: Integer; stdcall;
    function GetPosition: Integer; stdcall;
    procedure UpdateThumbRect; stdcall;
    procedure Cap; stdcall;
    procedure SetTrackPos(nPosition: Integer); stdcall;
    procedure SetPageSize(nPageSize: Integer); stdcall;
  public
    constructor Create(const pDialog: Iz3DDialog = nil); override;
    function HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    function HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    function MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    procedure Render; override; stdcall;
    procedure UpdateRects; override; stdcall;
    procedure SetTrackRange(nStart, nEnd: Integer); stdcall;
    procedure Scroll(nDelta: Integer); stdcall;
    procedure ShowItem(nIndex: Integer); stdcall;
  public
    property TrackPos: Integer read GetPosition write SetTrackPos;
    property PageSize: Integer read GetPageSize write SetPageSize;
  end;

  // ListBox control
  Tz3DListBox = class(Tz3DControl, Iz3DListBox)
  private
    FText: TRect;
    FSelection: TRect;
    m_ScrollBar: Iz3DScrollBar;
    FSBWidth: Integer;
    FBorder: Integer;
    FMargin: Integer;
    FTextHeight: Integer;
    FStyle: Tz3DListBoxStyle;
    FSelected: Integer;
    FSelStart: Integer;
    FDrag: Boolean;
    m_Items: TList;
  protected
    function GetSBWidth: Integer; stdcall;
    function GetSelected: Integer; stdcall;
    function GetStyle: Tz3DListBoxStyle; stdcall;
    function GetSize: Integer; stdcall;
    procedure SetStyle(dwStyle: Tz3DListBoxStyle); stdcall;
    procedure SetScrollBarWidth(nWidth: Integer); stdcall;
    procedure SetDialog(const Value: Iz3DDialog); override; stdcall;
  public
    constructor Create(const pDialog: Iz3DDialog = nil); override;
    destructor Destroy; override;
    function OnInit: HRESULT; override; stdcall;
    function CanHaveFocus: Boolean; override; stdcall;
    function HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    function HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    function MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    procedure Render; override; stdcall;
    procedure UpdateRects; override; stdcall;
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
  public
    property Items[Index: Integer]: Pz3DListBoxItem read GetItem;
    property ItemIndex: Integer read GetSelected write SelectItem;
    property SelectedIndex: Integer read GetSelected write SelectItem;
    property ScrollBarWidth: Integer read GetSBWidth write SetScrollBarWidth;
    property Style: Tz3DListBoxStyle read GetStyle write SetStyle;
    property Size: Integer read GetSize;
  end;

  Tz3DTraceListBox = class(Tz3DListBox, Iz3DTraceListBox)
  private
  protected
  public
    procedure Render; override; stdcall;
  public
  end;

  // ComboBox control
  Tz3DComboBox = class(Tz3DButton, Iz3DComboBox)
  private
    m_iSelected: Integer;
    m_iFocused: Integer;
    FDropHeight: Integer;
    m_ScrollBar: Iz3DScrollBar;
    FSBWidth: Integer;
    FOpened: Boolean;
    FText: TRect;
    FButton: TRect;
    FDropdown: TRect;
    FDropdownText: TRect;
    m_Items: array of Pz3DComboBoxItem;
  protected
    function GetItemIndex: Integer; stdcall;
    procedure SetTextColor(Color: TD3DColor); override; stdcall;
    function GetSBWidth: Integer; stdcall;
    function GetNumItems: LongWord; stdcall;
    function GetItem(index: LongWord): Pz3DComboBoxItem; stdcall;
  public
    constructor Create(const pDialog: Iz3DDialog = nil); override; 
    destructor Destroy; override; 
    function OnInit: HRESULT; override; stdcall;
    function HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    function HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    procedure OnHotkey; override; stdcall;
    function CanHaveFocus: Boolean; override; stdcall;
    procedure OnFocusOut; override; stdcall;
    procedure Render; override; stdcall;
    procedure UpdateRects; override; stdcall;
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
    procedure SetDialog(const Value: Iz3DDialog); override; stdcall;
  public
    property Item[index: LongWord]: Pz3DComboBoxItem read GetItem;
    property NumItems: LongWord read GetNumItems;
    property ScrollBarWidth: Integer read GetSBWidth write SetScrollBarWidth;
    property ItemIndex: Integer read GetItemIndex;
  end;

  Tz3DTrackBar = class(Tz3DControl, Iz3DTrackBar)
  private
    FValue: Integer;
    FMin: Integer;
    FMax: Integer;
    FDragX: Integer;
    FDragOffset: Integer;
    FButtonX: Integer;
    FPressed: Boolean;
    FButton: TRect;
  protected
    function GetValue: Integer; stdcall;
    procedure SetValueInternal(nValue: Integer; bFromInput: Boolean); stdcall;
    function ValueFromPos(x: Integer): Integer; stdcall;
    procedure SetValue(nValue: Integer); stdcall;
  public
    constructor Create(const pDialog: Iz3DDialog = nil); override;
    function ContainsPoint(pt: TPoint): LongBool; override; stdcall;
    function CanHaveFocus: Boolean; override; stdcall;
    function HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    function HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    procedure UpdateRects; override; stdcall;
    procedure Render; override; stdcall;
    procedure GetRange(out nMin, nMax: Integer); stdcall;
    procedure SetRange(nMin, nMax: Integer); stdcall;
  public
    property Value: Integer read GetValue write SetValue;
  end;

  Tz3DProgressBar = class(Tz3DControl, Iz3DProgressBar)
  private
    FValue: Integer;
    FMin: Integer;
    FMax: Integer;
    FProgress: TRect;
  protected
    function GetValue: Integer; stdcall;
    procedure SetValueInternal(nValue: Integer; bFromInput: Boolean); stdcall;
    function ValueFromPos(x: Integer): Integer; stdcall;
    procedure SetValue(nValue: Integer); stdcall;
  public
    constructor Create(const pDialog: Iz3DDialog = nil); override;
    function ContainsPoint(pt: TPoint): LongBool; override; stdcall;
    function CanHaveFocus: Boolean; override; stdcall;
    function HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    function HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    procedure UpdateRects; override; stdcall;
    procedure Render; override; stdcall;
    procedure GetRange(out nMin, nMax: Integer); stdcall;
    procedure SetRange(nMin, nMax: Integer); stdcall;
  public
    property Value: Integer read GetValue write SetValue;
  end;

  Tz3DUniBuffer = class(Tz3DBase, Iz3DUniBuffer)
  private
    FwszBuffer:  PWideChar;
    FBufferSize: Integer;
    FFontNode: Pz3DFontNode;
    FAnalyseRequired: Boolean;
    m_Analysis: TScriptStringAnalysis;
  public
    function GetBufferSize: Integer; stdcall;
    function GetFontNode: Pz3DFontNode; stdcall;
    function GetwszBuffer: PWideChar; stdcall;
    procedure SetFontNode(const Value: Pz3DFontNode); stdcall;
    function Analyse: HRESULT; stdcall;
    constructor Create(nInitialSize: Integer = 1); 
    destructor Destroy; override; 
    class procedure Initialize;
    class procedure Uninitialize;
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
  public
    property BufferSize: Integer read GetBufferSize;
    property Buffer: PWideChar read GetwszBuffer;
    property Chars[i: Integer]: WideChar read GetChar write SetChar; default;
    property FontNode: Pz3DFontNode read GetFontNode write SetFontNode;
    property TextSize: Integer read GetTextSize;
  end;

  Tz3DEdit = class(Tz3DControl, Iz3DEdit)
  private
    m_Buffer: Tz3DUniBuffer;
    FBorder: Integer;
    FSpacing: Integer;
    FText: TRect;
    FRender: array[0..8] of TRect;
    m_dfBlink:Double;
    m_dfLastBlink: Double;
    FCaretOn: Boolean;
    FCaret: Integer;
    FInsertMode: Boolean;
    FSelStart: Integer;
    FFirstVisible: Integer;
    m_TextColor: TD3DColor;
    m_SelTextColor: TD3DColor;
    m_SelBkColor: TD3DColor;
    m_CaretColor: TD3DColor;
    FMouseDrag: Boolean;
  protected
    procedure SetCaretColor(const Value: TD3DColor); stdcall;
    function GetBorder: Integer; stdcall;
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
    procedure SetTextColor(Color: TD3DColor); override; stdcall;
    function GetText: PWideChar; stdcall;
    procedure SetText_p(wszText: PWideChar);{$IFDEF SUPPORTS_INLINE} inline;{$ENDIF} stdcall;
    function GetTextLength: Integer; stdcall;
    procedure SetBorderWidth(nBorder: Integer); stdcall;
    procedure SetSpacing(nSpacing: Integer); stdcall;
  public
    constructor Create(const pDialog: Iz3DDialog = nil); override;
    destructor Destroy; override;
    function HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    function HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    function MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    procedure UpdateRects; override; stdcall;
    function CanHaveFocus: Boolean; override; stdcall;
    procedure Render; override; stdcall;
    procedure OnFocusIn; override; stdcall;
    procedure SetText(wszText: PWideChar; bSelected: Boolean = False); stdcall;
    function GetTextCopy(strDest: PWideChar; bufferCount: LongWord): HRESULT; stdcall;
    procedure ClearText; stdcall;
    procedure ParseFloatArray(pNumbers: PSingle; nCount: Integer); stdcall;
    procedure SetTextFloatArray(pNumbers: PSingle; nCount: Integer); stdcall;
  public
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
  Tz3DIMEEditBox = class(Tz3DEdit, Iz3DIMEEditBox)
  private
    m_ReadingColor:        TD3DColor;
    m_ReadingWinColor:     TD3DColor;
    m_ReadingSelColor:     TD3DColor;
    m_ReadingSelBkColor:   TD3DColor;
    m_CandidateColor:      TD3DColor;
    m_CandidateWinColor:   TD3DColor;
    m_CandidateSelColor:   TD3DColor;
    m_CandidateSelBkColor: TD3DColor;
    m_CompColor:           TD3DColor;
    m_CompWinColor:        TD3DColor;
    m_CompCaretColor:      TD3DColor;
    m_CompTargetColor:     TD3DColor;
    m_CompTargetBkColor:   TD3DColor;
    m_CompTargetNonColor:  TD3DColor;
    m_CompTargetNonBkColor:TD3DColor;
    m_IndicatorImeColor:   TD3DColor;
    m_IndicatorEngColor:   TD3DColor;
    m_IndicatorBkColor:    TD3DColor;
    FIndicatorWidth:       Integer;
    FIndicator:            TRect;
  protected
    class function GetLanguage: Word;
    class function GetPrimaryLanguage: Word;
    class function GetSubLanguage: Word;
    class procedure SendKey(nVirtKey: Byte);
    class function GetImeId(uIndex: LongWord = 0): DWORD;
    class procedure CheckInputLocale();
    class procedure CheckToggleState;
    class procedure SetupImeApi;
    class procedure ResetCompositionString;
    procedure TruncateCompString(bUseBackSpace: Boolean = True; iNewStrLen: Integer = 0); stdcall;
    procedure FinalizeString(bSend: Boolean); stdcall;
    class procedure GetReadingWindowOrientation(dwId: DWORD);
    class procedure GetPrivateReadingString;
    procedure SendCompString; stdcall;
  public
    constructor Create(const pDialog: Iz3DDialog = nil); override;
    destructor Destroy; override;
    class procedure Initialize;
    class procedure Uninitialize;
    class function StaticOnCreateDevice: HRESULT;
    class function StaticMsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): BOOL;
    class procedure EnableImeSystem(bEnable: Boolean);
    procedure Render; override; stdcall;
    function MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    function HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean; override; stdcall;
    procedure UpdateRects; override; stdcall;
    procedure OnFocusIn; override; stdcall;
    procedure OnFocusOut; override; stdcall;
    procedure PumpMessage; stdcall;
    procedure RenderCandidateReadingWindow(bReading: Boolean); virtual; stdcall;
    procedure RenderComposition; virtual; stdcall;
    procedure RenderIndicator; virtual; stdcall;
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

function GetAPIFormat(const AFormats: Tz3DFontFormats): Cardinal; stdcall; 

function z3DCreateDesktop: Iz3DDesktop; stdcall;
function z3DDesktop: Iz3DDesktop; stdcall;
procedure z3DSetCustomDesktop(const ADesktop: Iz3DDesktop); stdcall;

function z3DCreateTextHelper(const AFont: ID3DXFont; const ASprite: ID3DXSprite;
  const ALineHeight: Integer): Iz3DTextHelper; stdcall;


implementation

uses Math, z3DCore_Func, StrSafe, z3DFileSystem_Intf, z3DFileSystem_Func,
  z3DEngine_Func, SysUtils, z3DFunctions, z3DComponents_Func, z3DStrings,
  z3DMath_Func, z3DEngine_Intf, z3DLighting_Func, z3DLighting_Intf;

const
  UnitName = 'z3DGUI.pas';

const
  // Minimum scroll bar thumb size
  SCROLLBAR_MINTHUMBSIZE = 8;

  // Delay and repeat period when clicking on the scroll bar arrows
  SCROLLBAR_ARROWCLICK_DELAY  = 0.33;
  SCROLLBAR_ARROWCLICK_REPEAT = 0.05;

  UNISCRIBE_DLLNAME = '\usp10.dll';


  // z3D_MAX_EDITBOXLENGTH is the maximum string length allowed in edit boxes,
  // including the NULL terminator.
  //
  // Uniscribe does not support strings having bigger-than-16-bits length.
  // This means that the string must be less than 65536 characters long,
  // including the NULL terminator.
  z3D_MAX_EDITBOXLENGTH = $FFFF;


var
  s_fTimeRefresh: Double = 0.0;            // static Tz3DDialog::s_fTimeRefresh
  s_pControlFocus: Iz3DControl     = nil; // static Tz3DDialog::s_pControlFocus // The control which has focus
  s_pControlPressed: Iz3DControl   = nil; // static Tz3DDialog::s_pControlPressed // The control currently pressed

  GDesktop: Iz3DDesktop;

type
  Tz3DScreenVertex = record
    x, y, z, h: Single;
    color: TD3DColor;
    tu, tv: Single;
  end;
const
  Tz3DScreenVertex_FVF = D3DFVF_XYZRHW or D3DFVF_DIFFUSE or D3DFVF_TEX1;


function z3DCreateDesktop: Iz3DDesktop; stdcall;
begin
  z3DTrace('z3DCreateDesktopr: Creating desktop object...', z3DtkInformation);
  GDesktop:= Tz3DDesktop.Create;
  Result:= GDesktop;
end;

function z3DDesktop: Iz3DDesktop; stdcall;
begin
  Result:= GDesktop;
end;

procedure z3DSetCustomDesktop(const ADesktop: Iz3DDesktop); stdcall;
begin
  GDesktop:= ADesktop;
end;

function z3DCreateTextHelper(const AFont: ID3DXFont; const ASprite: ID3DXSprite;
  const ALineHeight: Integer): Iz3DTextHelper; stdcall;
begin
  Result:= Tz3DTextHelper.Create(AFont, ASprite, ALineHeight);
end;

function z3DScreenVertex(x, y, z, h: Single; color: TD3DColor; tu, tv: Single): Tz3DScreenVertex;
begin
  Result.x:= x; Result.y:= y; Result.z:= z; Result.h:= h;
  Result.color:= color;
  Result.tu:= tu; Result.tv:= tv;
end;

type
  Tz3DScreenVertexUntex = record
    x, y, z, h: Single;
    color: TD3DColor;
  end;
const
  Tz3DScreenVertexUntex_FVF = D3DFVF_XYZRHW or D3DFVF_DIFFUSE;

function z3DScreenVertexUntex(x, y, z, h: Single; color: TD3DColor): Tz3DScreenVertexUntex;
begin
  Result.x:= x; Result.y:= y; Result.z:= z; Result.h:= h;
  Result.color:= color;
end;

function GetAPIFormat(const AFormats: Tz3DFontFormats): Cardinal; 
begin
  Result:= 0;
  if z3dffBottom in AFormats then Result:= Result or DT_BOTTOM;
  if z3dffCenter in AFormats then Result:= Result or DT_CENTER;
  if z3dffEndEllipsis in AFormats then Result:= Result or DT_END_ELLIPSIS;
  if z3dffPathEllipsis in AFormats then Result:= Result or DT_PATH_ELLIPSIS;
  if z3dffExpandTabs in AFormats then Result:= Result or DT_EXPANDTABS;
  if z3dffExternalLeading in AFormats then Result:= Result or DT_EXTERNALLEADING;
  if z3dffLeft in AFormats then Result:= Result or DT_LEFT;
  if z3dffModifyString in AFormats then Result:= Result or DT_MODIFYSTRING;
  if z3dffNoClip in AFormats then Result:= Result or DT_NOCLIP;
  if z3dffNoPrefix in AFormats then Result:= Result or DT_NOPREFIX;
  if z3dffRight in AFormats then Result:= Result or DT_RIGHT;
  if z3dffRTLReading in AFormats then Result:= Result or DT_RTLREADING;
  if z3dffSingleLine in AFormats then Result:= Result or DT_SINGLELINE;
  if z3dffTabStop in AFormats then Result:= Result or DT_TABSTOP;
  if z3dffTop in AFormats then Result:= Result or DT_TOP;
  if z3dffVerticalCenter in AFormats then Result:= Result or DT_VCENTER;
  if z3dffWordBreak in AFormats then Result:= Result or DT_WORDBREAK;
end;

function RectWidth(const prc: TRect): Integer; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF} begin Result:= prc.right - prc.left; end;
function RectHeight(const prc: TRect): Integer;{$IFDEF SUPPORTS_INLINE}inline;{$ENDIF} begin Result:= prc.bottom - prc.top; end;

procedure Tz3DBlendColor.SetColors(defaultColor: TD3DColor; disabledColor: TD3DColor = $C8808080; hiddenColor: TD3DColor = 0);
var
  i: Tz3DControlState;
begin
  for i:= Low(Tz3DControlState) to High(Tz3DControlState) do States[i]:= defaultColor;
  States[z3dcsDisabled] := disabledColor;
  States[z3dcsHidden] := hiddenColor;
  Current:= D3DXColorFromDWord(hiddenColor);
end;

procedure Tz3DBlendColor.Blend(iState: Tz3DControlState; fRate: Single = 0.7);
var
  destColor: TD3DXColor;
begin
  destColor:= D3DXColorFromDWord(States[iState]);
  if fRate = -1 then FCurrent:= destColor else
  D3DXColorLerp(FCurrent, FCurrent, destColor, 1.0 - Power(fRate, 30 * z3DCore_GetElapsedTime));
end;

{$IFDEF DEBUG}
var
  Tz3DTextHelper_InstanceCount: Integer = 0;

{$ENDIF}
constructor Tz3DTextHelper.Create(pFont: ID3DXFont; pSprite: ID3DXSprite; nLineHeight: Integer);
begin
  FFont := pFont;
  FSprite := pSprite;
  FClr := D3DXColor(1,1,1,1);
  FPt.x := 0;
  FPt.y := 0;
  FLineHeight := nLineHeight;
end;

destructor Tz3DTextHelper.Destroy;
begin
  inherited;
end;

procedure Tz3DTextHelper.SetInsertionPos(x, y: Integer);
begin
  FPt.x := x;
  FPt.y := y;
end;

procedure Tz3DTextHelper.SetForegroundColor(clr: TD3DXColor);
begin
  FClr := clr;
end;

function Tz3DTextHelper.DrawFormattedTextLine(const strMsg: PWideChar; args: array of const): HRESULT;
var
  strBuffer: array[0..511] of WideChar;
begin
  // WideFormatBuf(strBuffer, 512, strMsg, Length(strMsg), args);
  StringCchFormat(strBuffer, 512, strMsg, args);
  strBuffer[511] := #0;
  Result:= DrawTextLine(strBuffer);
end;

{$IFNDEF FPC}

function Tz3DTextHelper.DrawFormattedTextLine(const strMsg: WideString; args: array of const): HRESULT;
begin
  Result := DrawFormattedTextLine(PWideChar(strMsg), args);
end;

{$ENDIF}

function Tz3DTextHelper.DrawTextLine(const strMsg: PWideChar): HRESULT;
var
  rc: TRect;
begin
  if (nil = FFont) then
  begin
    Result:= z3DError('DrawTextLine', E_INVALIDARG);
    Exit;
  end;
  SetRect(rc, FPt.x, FPt.y, 0, 0 );
  Result := FFont.DrawTextW(FSprite, strMsg, -1, @rc, DT_NOCLIP, D3DXColorToDWord(FClr));
  if FAILED(Result) then
  begin
    Result:= DXTRACE_ERR_MSGBOX('DrawText', Result);
    Exit;
  end;
  Inc(FPt.y, FLineHeight);
  Result:= S_OK;
end;

{$IFNDEF FPC}

function Tz3DTextHelper.DrawTextLine(const strMsg: PAnsiChar): HRESULT;
var
  rc: TRect;
begin
  if (nil = FFont) then
  begin
    Result:= z3DError('DrawTextLine', E_INVALIDARG);
    Exit;
  end;

  SetRect(rc, FPt.x, Fpt.y, 0, 0 );
  Result := FFont.DrawTextA(FSprite, strMsg, -1, @rc, DT_NOCLIP, D3DXColorToDWord(FClr));
  if FAILED(Result) then
  begin
    Result:= DXTRACE_ERR_MSGBOX('DrawText', Result);
    Exit;
  end;
  Inc(FPt.y, FLineHeight);
  Result:= S_OK;
end;
{$ENDIF}

{$IFDEF BORLAND}{$IFNDEF COMPILER6_UP}
function Tz3DTextHelper.DrawTextLine(const strMsg: String): HRESULT;
begin
  Result:= DrawTextLine(PAnsiChar(strMsg));
end;

{$ENDIF}{$ENDIF}

function Tz3DTextHelper.DrawFormattedTextLine(const rc: TRect; dwFlags: DWORD; const strMsg: PWideChar; args: array of const): HRESULT;
var
  strBuffer: array[0..511] of WideChar;
begin
  StringCchFormat(strBuffer, 512, strMsg, args);
  Result:= DrawTextLine(rc, dwFlags, strBuffer);
end;


function Tz3DTextHelper.DrawTextLine(const rc: TRect; dwFlags: DWORD; const strMsg: PWideChar): HRESULT;
begin
  if (nil = FFont) then
  begin
    Result:= z3DError('DrawTextLine', E_INVALIDARG);
    Exit;
  end;
  Result := FFont.DrawTextW(FSprite, strMsg, -1, @rc, dwFlags, D3DXColorToDWord(FClr));
  if FAILED(Result) then
  begin
    Result:= DXTRACE_ERR_MSGBOX('DrawText', Result);
    Exit;
  end;
  Inc(FPt.y, FLineHeight);
  Result:= S_OK;
end;

procedure Tz3DTextHelper.BeginRender;
begin
  if (FSprite <> nil) then FSprite._Begin(D3DXSPRITE_ALPHABLEND or D3DXSPRITE_SORT_TEXTURE);
end;

procedure Tz3DTextHelper.EndRender;
begin
  if (FSprite <> nil) then FSprite._End;
end;

{ Tz3DBlendColor }

function Tz3DBlendColor.GetCurrent: TD3DXColor;
begin
  Result:= FCurrent;
end;

function Tz3DBlendColor.GetStates: Pz3DBlendColorStates;
begin
  Result:= @FStates;
end;

procedure Tz3DBlendColor.SetStates(const Value: Pz3DBlendColorStates);
begin
  FStates:= Value^;
end;

procedure Tz3DBlendColor.SetCurrent(const Value: TD3DXColor);
begin
  FCurrent:= Value;
end;

{ Tz3DDisplay }

constructor Tz3DDisplay.Create;
begin
  FTextureColor:= Tz3DBlendColor.Create;
  FFontColor:= Tz3DBlendColor.Create;
end;

destructor Tz3DDisplay.Destroy;
begin
  inherited;
end;

function Tz3DDisplay.GetTextFormat: DWORD;
begin
  Result:= dwTextFormat;
end;

procedure Tz3DDisplay.SetTextFormat(const Value: DWORD);
begin
  dwTextFormat:= Value;
end;

function Tz3DDisplay.GetFont: LongWord;
begin
  Result:= iFont;
end;

procedure Tz3DDisplay.SetFont(const Value: LongWord);
begin
  iFont:= value;
end;

function Tz3DDisplay.GetFontColor: Iz3DBlendColor;
begin
  Result:= FFontColor;
end;

function Tz3DDisplay.GetTextureColor: Iz3DBlendColor;
begin
  Result:= FTextureColor;
end;

procedure Tz3DDisplay.SetFontColor(const Value: Iz3DBlendColor);
begin
  FFontColor:= Value;
end;

procedure Tz3DDisplay.SetTextureColor(const Value: Iz3DBlendColor);
begin
  FTextureColor:= Value;
end;

function Tz3DDisplay.GetTextureRect: TRect;
begin
  Result:= rcTexture;
end;

function Tz3DDisplay.GetTexture: LongWord;
begin
  Result:= iTexture;
end;

procedure Tz3DDisplay.AssignTo(Dest: Iz3DBase);
begin
  if z3DSupports(Dest, Iz3DDisplay) then
  begin
    with Dest as Iz3DDisplay do
    begin
      iTexture:= Self.iTexture;
      iFont:= Self.iFont;
      dwTextFormat:= Self.dwTextFormat;
      rcTexture:= Self.rcTexture;
      TextureColor.Current:= Self.TextureColor.Current;
      TextureColor.States:= Self.TextureColor.States;
      FontColor.Current:= Self.FontColor.Current;
      FontColor.States:= Self.FontColor.States;
    end;
  end;
end;

procedure Tz3DDisplay.Assign(Source: Iz3DBase);
begin
  if z3DSupports(Source, Iz3DDisplay) then
  begin
    with Source as Iz3DDisplay do
    begin
      Self.iTexture:= Texture;
      Self.iFont:= Font;
      Self.dwTextFormat:= TextFormat;
      Self.rcTexture:= TextureRect;
      Self.TextureColor.Current:= TextureColor.Current;
      Self.TextureColor.States:= TextureColor.States;
      Self.FontColor.Current:= FontColor.Current;
      Self.FontColor.States:= FontColor.States;
    end;
  end;
end;

procedure Tz3DDisplay.SetTexture(iTexture: LongWord; prcTexture: PRect; defaultTextureColor: TD3DColor = $FFFFFFFF);
begin
  Self.iTexture := iTexture;
  if (prcTexture <> nil) then rcTexture := prcTexture^
  else SetRectEmpty(rcTexture);
  TextureColor.SetColors(defaultTextureColor);
end;

procedure Tz3DDisplay.SetFontParams(iFont: LongWord; defaultFontColor: TD3DColor = $FF000000; dwTextFormat: DWORD = DT_CENTER or DT_VCENTER);
begin
  Self.iFont := iFont;
  Self.dwTextFormat := dwTextFormat;
  FontColor.SetColors(defaultFontColor);
end;

procedure Tz3DDisplay.Refresh;
begin
  TextureColor.Current := D3DXColorFromDWord(TextureColor.States[z3dcsHidden]);
  FontColor.Current := D3DXColorFromDWord(FontColor.States[z3dcsHidden]);
end;

{ Tz3DDialog }

constructor Tz3DDialog.Create;
begin
  inherited;
  ScenarioLevel:= False;
  FDesktopOnly:= True;
  FEnableBorder:= True;
  FEnableBackground:= True;
  FModalResult:= z3dmdrNone;
  m_Controls:= TInterfaceList.Create;
  FLeft := 100;
  FTop := 100;
  FWidth := 100;
  FHeight := 100;
  FVisible := True;
  FCaption := True;
  FDrag := False;
  FCaptionStr[0] := #0;
  m_colorTopLeft := 0;
  m_colorTopRight := 0;
  m_colorBottomLeft := 0;
  m_colorBottomRight := 0;
  m_fTimeLastRefresh := 0;
  FNextDialog := Self;
  FPrevDialog := Self;
  FDefaultControlID := $ffff;
  FNonUserEvents := False;
  FKeyboardInput := False;
  FMouseInput := True;
  m_CapDisplay:= Tz3DDisplay.Create;
end;

destructor Tz3DDialog.Destroy;
begin
  RemoveAllControls;
  FreeAndNil(m_CapDisplay);
  inherited;
end;

{$IFDEF FPC}
type
  MakeIntResourceW = PWideChar;
{$ENDIF FPC}


function Tz3DDialog.GetModalResult: Tz3DDialogModalResult;
begin
  Result:= FModalResult;
end;

procedure Tz3DDialog.SetModalResult(const Value: Tz3DDialogModalResult);
begin
  FModalResult:= Value;
end;

procedure Tz3DDialog.InitDialog(pManager: Iz3DGUIController; bRegisterDialog: Boolean = True);
begin
  FManager := pManager;
  if bRegisterDialog then pManager.RegisterDialog(Self);
  SetTexture(0, MakeIntResourceW($FFFF), HMODULE($FFFF));
  InitDefaultDisplays;
end;

procedure Tz3DDialog.InitDialog(pManager: Iz3DGUIController; bRegisterDialog: Boolean; const pszControlTextureFilename: PWideChar);
begin
  FManager := pManager;
  if bRegisterDialog then pManager.RegisterDialog(Self);
  SetTexture(0, pszControlTextureFilename);
  InitDefaultDisplays;
end;

procedure Tz3DDialog.InitDefaultDialog(pManager: Iz3DGUIController);
var strFileName: PWideChar;
begin
  FManager := pManager;
  pManager.RegisterDialog(Self);
  z3DFileSystemController.DecryptF(fsEngineCoreResFile, fsCoreResFile_z3DGUI);
  GetMem(strFileName, 255);
  try
    StringToWideChar(WideCharToString(z3DFileSystemController.GetFullPath(fsBufferPath)) + fsPathDiv + fsCoreResFile_z3DGUI, strFileName, 255);
    SetTexture(0, strFileName);
  finally
    FreeMem(strFileName);
  end;
  InitDefaultDisplays;
end;

procedure Tz3DDialog.InitDialog(pManager: Iz3DGUIController; bRegisterDialog: Boolean; szControlTextureResourceName: PWideChar; hControlTextureResourceModule: HMODULE);
begin
  FManager := pManager;
  if bRegisterDialog then pManager.RegisterDialog(Self);
  SetTexture(0, szControlTextureResourceName, hControlTextureResourceModule);
  InitDefaultDisplays;
end;

function Tz3DDialog.GetControlCount: Integer;
begin
  Result:= m_Controls.Count;
end;

function Tz3DDialog.GetNextDialog: Iz3DDialog;
begin
  Result:= FNextDialog;
end;

function Tz3DDialog.GetPrevDialog: Iz3DDialog;
begin
  Result:= FPrevDialog;
end;

procedure Tz3DDialog.SetPrevDialog(pNextDialog: Iz3DDialog);
begin
  FPrevDialog:= pNextDialog;
end;

function Tz3DDialog.GetEnableCaption: Boolean;
begin
  Result:= FCaption;
end;

function Tz3DDialog.GetHeight: Integer;
begin
  Result:= FHeight;
end;

function Tz3DDialog.GetKeyboardInput: Boolean;
begin
  Result:= FKeyboardInput;
end;

function Tz3DDialog.GetManager: Iz3DGUIController;
begin
  Result:= FManager;
end;

function Tz3DDialog.GetWidth: Integer;
begin
  Result:= FWidth;
end;

procedure Tz3DDialog.SetEnableCaption(const Value: Boolean);
begin
  FCaption:= Value;
end;

procedure Tz3DDialog.SetHeight(const Value: Integer);
begin
  FHeight:= Value;
end;

procedure Tz3DDialog.SetWidth(const Value: Integer);
begin
  FWidth:= Value;
end;

procedure Tz3DDialog.Render;
var
  pd3dDevice: IDirect3DDevice9;
  pTextureNode: Pz3DTextureNode;
  rc: TRect;
  wszOutput: array[0..255] of WideChar;
  pControl: Iz3DControl;
  i: Integer;
  bBackgroundIsVisible: Boolean;
  vertices: array[0..3] of Tz3DScreenVertexUntex;
begin
  if FDesktopOnly and not Manager.Desktop.Visible then Exit;

  inherited;

  if (m_fTimeLastRefresh < s_fTimeRefresh) then
  begin
    m_fTimeLastRefresh := z3DCore_GetTime;
    Refresh;
  end;
  if not FVisible then Exit;
  pd3dDevice := z3DCore_GetD3DDevice;
  bBackgroundIsVisible := FEnableBackground and (((m_colorTopLeft or m_colorTopRight or m_colorBottomRight or m_colorBottomLeft) and $FF000000) <> 0);
  if bBackgroundIsVisible then
  begin
    // Draw window
    vertices[0]:= z3DScreenVertexUntex(FLeft,          FTop,           0.5, 1.0, m_colorTopLeft);
    vertices[1]:= z3DScreenVertexUntex(FLeft + FWidth, FTop,           0.5, 1.0, m_colorTopRight);
    vertices[2]:= z3DScreenVertexUntex(FLeft + FWidth, FTop + FHeight, 0.5, 1.0, m_colorBottomRight);
    vertices[3]:= z3DScreenVertexUntex(FLeft,          FTop + FHeight, 0.5, 1.0, m_colorBottomLeft);
    pd3dDevice.SetRenderState(D3DRS_ZENABLE, iFalse);
    pd3dDevice.SetFVF(Tz3DScreenVertexUntex_FVF);
    pd3dDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, 2, vertices, SizeOf(Tz3DScreenVertexUntex));
    if FCaption then
    begin
      // Draw title bar
      vertices[0]:= z3DScreenVertexUntex(FLeft+4, FTop+4,                           0.45, 1.0, D3DCOLOR_ARGB(255, 140, 180, 225));
      vertices[1]:= z3DScreenVertexUntex(FLeft-4 + FWidth, FTop+4,                  0.45, 1.0, D3DCOLOR_ARGB(255, 100, 130, 180));
      vertices[2]:= z3DScreenVertexUntex(FLeft-4 + FWidth, FTop+4 + Manager.Desktop.ThemeSettings.CaptionHeight, 0.45, 1.0, D3DCOLOR_ARGB(255, 30, 50, 100));
      vertices[3]:= z3DScreenVertexUntex(FLeft+4, FTop+4 + Manager.Desktop.ThemeSettings.CaptionHeight,          0.45, 1.0, D3DCOLOR_ARGB(255, 40, 60, 120));
      pd3dDevice.SetFVF(Tz3DScreenVertexUntex_FVF);
      pd3dDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, 2, vertices, SizeOf(Tz3DScreenVertexUntex));
    end;
    if FEnableBorder then
    begin
      // Draw edge 1
      vertices[0]:= z3DScreenVertexUntex(FLeft, FTop,            0.4, 1.0, D3DCOLOR_ARGB(255, 255, 255, 255));
      vertices[1]:= z3DScreenVertexUntex(FLeft+2, FTop,          0.4, 1.0, D3DCOLOR_ARGB(255, 255, 255, 255));
      vertices[2]:= z3DScreenVertexUntex(FLeft+2, FTop+FHeight, 0.4, 1.0, D3DCOLOR_ARGB(255, 255, 255, 255));
      vertices[3]:= z3DScreenVertexUntex(FLeft, FTop+FHeight,   0.4, 1.0, D3DCOLOR_ARGB(255, 255, 255, 255));
      pd3dDevice.SetFVF(Tz3DScreenVertexUntex_FVF);
      pd3dDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, 2, vertices, SizeOf(Tz3DScreenVertexUntex));
      // Draw edge 2
      vertices[0]:= z3DScreenVertexUntex(FLeft, FTop,           0.4, 1.0, D3DCOLOR_ARGB(255, 255, 255, 255));
      vertices[1]:= z3DScreenVertexUntex(FLeft+FWidth, FTop,   0.4, 1.0, D3DCOLOR_ARGB(255, 255, 255, 255));
      vertices[2]:= z3DScreenVertexUntex(FLeft+FWidth, FTop+2, 0.4, 1.0, D3DCOLOR_ARGB(255, 255, 255, 255));
      vertices[3]:= z3DScreenVertexUntex(FLeft, FTop+2,         0.4, 1.0, D3DCOLOR_ARGB(255, 255, 255, 255));
      pd3dDevice.SetFVF(Tz3DScreenVertexUntex_FVF);
      pd3dDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, 2, vertices, SizeOf(Tz3DScreenVertexUntex));
      // Draw edge 3
      vertices[0]:= z3DScreenVertexUntex(FLeft+FWidth-2, FTop,          0.4, 1.0, D3DCOLOR_ARGB(255, 0, 0, 0));
      vertices[1]:= z3DScreenVertexUntex(FLeft+FWidth, FTop,            0.4, 1.0, D3DCOLOR_ARGB(255, 0, 0, 0));
      vertices[2]:= z3DScreenVertexUntex(FLeft+FWidth, FTop+FHeight,   0.4, 1.0, D3DCOLOR_ARGB(255, 0, 0, 0));
      vertices[3]:= z3DScreenVertexUntex(FLeft+FWidth-2, FTop+FHeight, 0.4, 1.0, D3DCOLOR_ARGB(255, 0, 0, 0));
      pd3dDevice.SetFVF(Tz3DScreenVertexUntex_FVF);
      pd3dDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, 2, vertices, SizeOf(Tz3DScreenVertexUntex));
      // Draw edge 4
      vertices[0]:= z3DScreenVertexUntex(FLeft, FTop+FHeight-2,         0.4, 1.0, D3DCOLOR_ARGB(255, 0, 0, 0));
      vertices[1]:= z3DScreenVertexUntex(FLeft+FWidth, FTop+FHeight-2, 0.4, 1.0, D3DCOLOR_ARGB(255, 0, 0, 0));
      vertices[2]:= z3DScreenVertexUntex(FLeft+FWidth, FTop+FHeight,   0.4, 1.0, D3DCOLOR_ARGB(255, 0, 0, 0));
      vertices[3]:= z3DScreenVertexUntex(FLeft, FTop+FHeight,           0.4, 1.0, D3DCOLOR_ARGB(255, 0, 0, 0));
      pd3dDevice.SetFVF(Tz3DScreenVertexUntex_FVF);
      pd3dDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, 2, vertices, SizeOf(Tz3DScreenVertexUntex));
    end;
  end;
  pd3dDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
  pd3dDevice.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
  pd3dDevice.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);
  pd3dDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
  pd3dDevice.SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
  pd3dDevice.SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);
  pd3dDevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
  pd3dDevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
  pTextureNode := GetTexture(0);
  pd3dDevice.SetTexture(0, pTextureNode.Texture);
  Manager.Sprite._Begin(D3DXSPRITE_DONOTSAVESTATE);
  if FCaption then
  begin
    rc := Rect(10, {-Manager.Desktop.ThemeSettings.CaptionHeight}+5, FWidth-10, Manager.Desktop.ThemeSettings.CaptionHeight);
    StringCchCopy(wszOutput, 256, FCaptionStr);
    DrawText(wszOutput, m_CapDisplay, rc, True);
  end;
  for i:= 0 to ControlCount - 1 do
  begin
    pControl := m_Controls[i] as Iz3DControl;
    if (pControl = s_pControlFocus) then Continue;
    pControl.Render;
  end;
  if (s_pControlFocus <> nil) and (s_pControlFocus.Dialog = Self as Iz3DDialog)
  then s_pControlFocus.Render;
  Manager.Sprite._End;
  pd3dDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_SELECTARG2);
  pd3dDevice.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);
  pd3dDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_SELECTARG1);
  pd3dDevice.SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_DIFFUSE);
  pd3dDevice.SetTextureStageState(0, D3DTSS_RESULTARG, D3DTA_CURRENT);
  pd3dDevice.SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
  pd3dDevice.SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);
end;

procedure Tz3DDialog.Message(const AWnd: HWND; const AMsg: Cardinal;
  const AwParam, AlParam: Integer; var AHandled: Boolean);
var
  i: Integer;
  pControl: Iz3DControl;
  bShiftDown: Boolean;
begin
  if FDesktopOnly and not Manager.Desktop.Visible then Exit;
  inherited;
  AHandled:= False;
  // For invisible dialog, do not handle anything.
  if not FVisible then Exit;

  // If automation command-line switch is on, enable this dialog's keyboard input
  // upon any key press or mouse click.
  if z3DCore_GetAutomation and
    ((WM_LBUTTONDOWN = AMsg) or (WM_LBUTTONDBLCLK = AMsg) or (WM_KEYDOWN = AMsg)) then
    FManager.EnableKeyboardInputForAllDialogs;

  if (AMsg = WM_LBUTTONDOWN) or (AMsg = WM_LBUTTONDBLCLK) then
  begin
    FMousePoint := Point(short(LOWORD(DWORD(AlParam))), short(HIWORD(DWORD(AlParam))));

    if (FMousePoint.x >= FLeft) and (FMousePoint.x < FLeft + FWidth) and
       (FMousePoint.y >= FTop) and (FMousePoint.y < FTop + FHeight) then
    begin
      AHandled:= True;
      if FCaption and (FMousePoint.y < FTop + Manager.Desktop.ThemeSettings.CaptionHeight) then
      begin
        FDrag := True;
        FMousePointO := Point(short(LOWORD(DWORD(AlParam))), short(HIWORD(DWORD(AlParam))));
        Dec(FMousePointO.x, FLeft);
        Dec(FMousePointO.y, FTop);
        SetCapture(z3DCore_GetHWND);
      end;
      if not FManager.ModalMode and not z3DSupports(Self, Iz3DMainMenuDialog) then SetFocus;
    end;
  end else
  if (AMsg = WM_LBUTTONUP) and FDrag then
  begin
    FMousePoint := Point(short(LOWORD(DWORD(AlParam))), short(HIWORD(DWORD(AlParam))));

    if (FMousePoint.x >= FLeft) and (FMousePoint.x < FLeft + FWidth) and
       (FMousePoint.y >= FTop) and (FMousePoint.y < FTop + Manager.Desktop.ThemeSettings.CaptionHeight) then
    begin
      ReleaseCapture;
      FDrag := False;
      AHandled:= True;
      Exit;
    end;
  end;

  // If a control is in focus, it belongs to this dialog, and it's enabled, then give
  // it the first chance at handling the message.
  if (s_pControlFocus <> nil) and
     (s_pControlFocus.Dialog = Self as Iz3DDialog) and
     (s_pControlFocus.Enabled) then
  begin
    // If the control MsgProc handles it, then we don't.
    if (s_pControlFocus.MsgProc(AMsg, AwParam, AlParam)) then
    begin
      AHandled:= True;
      Exit;
    end;
  end;

  case AMsg of
    WM_SIZE,
    WM_MOVE:
    begin
      // Handle sizing and moving messages so that in case the mouse cursor is moved out
      // of an UI control because of the window adjustment, we can properly
      // unhighlight the highlighted control.
      if HasFocus then OnMouseMove(Point(-1, -1));
    end;

    WM_ACTIVATEAPP:
    begin
      // Call OnFocusIn()/OnFocusOut() of the control that currently has the focus
      // as the application is activated/deactivated.  This matches the Windows
      // behavior.
      if (s_pControlFocus <> nil) and
         (s_pControlFocus.Dialog = Self as Iz3DDialog) and
         (s_pControlFocus.GetEnabled) then
      begin
        if (AwParam <> 0)
        then s_pControlFocus.OnFocusIn
        else s_pControlFocus.OnFocusOut;
      end;
    end;

    // Keyboard messages
    WM_KEYDOWN,
    WM_SYSKEYDOWN,
    WM_KEYUP,
    WM_SYSKEYUP:
    begin
      // If a control is in focus, it belongs to this dialog, and it's enabled, then give
      // it the first chance at handling the message.
      if (s_pControlFocus <> nil) and
         (s_pControlFocus.Dialog = Self as Iz3DDialog) and
         (s_pControlFocus.GetEnabled) then
      begin
        if (s_pControlFocus.HandleKeyboard(AMsg, AwParam, AlParam)) then
        begin
          AHandled:= True;
          Exit;
        end;
      end;

      // Not yet handled, see if this matches a control's hotkey
      // Activate the hotkey if the focus doesn't belong to an
      // edit box.
      if (AMsg = WM_KEYDOWN) and
         (
           (s_pControlFocus = nil) or
           not (s_pControlFocus.GetType in [z3dctEdit, z3dctIMEEdit])
         ) then
      begin
        for i:= 0 to ControlCount - 1 do
        begin
          pControl := m_Controls[i] as Iz3DControl;
          if (pControl.Hotkey = Cardinal(AwParam)) then
          begin
            pControl.OnHotkey;
            AHandled:= True;
            Exit;
          end;
        end;
      end;

      // Not yet handled, check for focus messages
      if (AMsg = WM_KEYDOWN) then
      begin
        // If keyboard input is not enabled, this message should be ignored
        if (not FKeyboardInput) then Exit;

        case AwParam of
          VK_RIGHT,
          VK_DOWN:
            if (s_pControlFocus <> nil) then
            begin
              AHandled:= OnCycleFocus(True);
              Exit;
            end;

          VK_LEFT,
          VK_UP:
            if (s_pControlFocus <> nil) then
            begin
              AHandled:= OnCycleFocus(False);
              Exit;
            end;

          VK_TAB:
          begin
            bShiftDown := ((GetKeyState(VK_SHIFT) and $8000) <> 0);
            AHandled:= OnCycleFocus(not bShiftDown);
            Exit;
          end;
        end;
      end;
    end;


    // Mouse messages
    WM_MOUSEMOVE,
    WM_LBUTTONDOWN,
    WM_LBUTTONUP,
    WM_MBUTTONDOWN,
    WM_MBUTTONUP,
    WM_RBUTTONDOWN,
    WM_RBUTTONUP,
    WM_XBUTTONDOWN,
    WM_XBUTTONUP,
    WM_LBUTTONDBLCLK,
    WM_MBUTTONDBLCLK,
    WM_RBUTTONDBLCLK,
    WM_XBUTTONDBLCLK,
    WM_MOUSEWHEEL:
    begin
      // If not accepting mouse input, return false to indicate the message should still
      // be handled by the application (usually to move the camera).
      if (not FMouseInput) then Exit;

      FMousePoint := Point(short(LOWORD(DWORD(AlParam))), short(HIWORD(DWORD(AlParam))));
      Dec(FMousePoint.x, FLeft);
      Dec(FMousePoint.y, FTop);

      // If caption is enabled, offset the Y coordinate by the negative of its height.
//      if (FCaption) then Dec(FMousePoint.y, Manager.Desktop.ThemeSettings.CaptionHeight);

      // If a control is in focus, it belongs to this dialog, and it's enabled, then give
      // it the first chance at handling the message.
      if (s_pControlFocus <> nil) and
         (s_pControlFocus.Dialog = Self as Iz3DDialog) and
         (s_pControlFocus.GetEnabled) then
      begin
        if s_pControlFocus.HandleMouse(AMsg, FMousePoint, AwParam, AlParam) then
        begin
          AHandled:= True;
          Exit;
        end;
      end;

      // Not yet handled, see if the mouse is over any controls
      pControl := GetControlAtPoint(FMousePoint);
      if (pControl <> nil) and pControl.Enabled then
      begin
        AHandled := pControl.HandleMouse(AMsg, FMousePoint, AwParam, AlParam);
      end else
      begin
        // Mouse not over any controls in this dialog, if there was a control
        // which had focus it just lost it
        if (AMsg = WM_LBUTTONDOWN) and
           (s_pControlFocus <> nil) and
           (s_pControlFocus.Dialog = Self as Iz3DDialog) then
        begin
          s_pControlFocus.OnFocusOut;
          s_pControlFocus := nil;
        end;
      end;

      // Still not handled, hand this off to the dialog. Return false to indicate the
      // message should still be handled by the application (usually to move the camera).
      case AMsg of
        WM_MOUSEMOVE:
        begin
          OnMouseMove(FMousePoint);
          if FDrag then SetLocation(short(LOWORD(DWORD(AlParam)))-FMousePointO.X,
          short(HIWORD(DWORD(AlParam)))-FMousePointO.Y);
          AHandled:= True;
          Exit;
        end;
      end;
    end;

    WM_CAPTURECHANGED:
    begin
      // The application has lost mouse capture.
      // The dialog object may not have received
      // a WM_MOUSEUP when capture changed. Reset
      // FDrag so that the dialog does not mistakenly
      // think the mouse button is still held down.
      if (THandle(AlParam) <> AWnd) then FDrag := False;
    end;
  end;
end;

function Tz3DDialog.GetVisible: Boolean;
begin
  Result:= FVisible;
end;

procedure Tz3DDialog.SetVisible(const Value: Boolean);
begin
  FVisible:= Value;
end;

procedure Tz3DDialog.SetCallback(pCallback: PCallbackz3DguiEvent; pUserContext: Pointer = nil);
begin
  // If this assert triggers, you need to call Tz3DDialog::Init() first.  This change
  // was made so that the z3D's GUI could become seperate and optional from z3D's core.  The
  // creation and interfacing with Iz3DGUIController is now the responsibility
  // of the application if it wishes to use z3D's GUI.
  Assert((FManager <> nil), 'To fix call Tz3DDialog.Init(Default) first.  See comments for details.');

  FCallbackEvent := pCallback;
  FCallbackEventUserContext := pUserContext;
end;

procedure Tz3DDialog.RemoveControl(ID: Integer);
var
  i: Integer;
  pControl: Iz3DControl;
begin
  for i:= 0 to ControlCount - 1 do
  begin
    pControl := m_Controls[i] as Iz3DControl;
    if (pControl.ID = ID) then
    begin
      // Clean focus first
      ClearFocus;

      // Clear references to this control
      if (s_pControlFocus = pControl) then s_pControlFocus := nil;
      if (s_pControlPressed = pControl) then s_pControlPressed := nil;
      if (FControlMouseOver = pControl) then FControlMouseOver := nil;

      m_Controls.Remove(pControl);
      pControl:= nil;
      Exit;
    end;
  end;
end;

procedure Tz3DDialog.Refresh;
var
  i: Integer;
begin
  if (s_pControlFocus <> nil) then s_pControlFocus.OnFocusOut;

  if (FControlMouseOver <> nil) then FControlMouseOver.OnMouseLeave;

  s_pControlFocus := nil;
  s_pControlPressed := nil;
  FControlMouseOver := nil;

  for i:= 0 to ControlCount - 1 do
    (m_Controls[i] as Iz3DControl).Refresh;

  if FKeyboardInput then FocusDefaultControl;
end;

procedure Tz3DDialog.SendEvent(const AEvent: Tz3DControlEvent; bTriggeredByUser: Boolean; pControl: Iz3DControl);
begin
  // If no callback has been registered there's nowhere to send the event to
  if (@FCallbackEvent = nil) then Exit;
// TODAVIA NO SE PUEDE: TODO JP  if not HasFocus then Exit;

  // Discard events triggered programatically if these types of events haven't been
  // enabled
  if (not bTriggeredByUser and not FNonUserEvents) then Exit;

  FCallbackEvent(AEvent, pControl.ID, pControl, FCallbackEventUserContext);
end;

procedure Tz3DDialog.RemoveAllControls;
var
  i: Integer;
  pControl: Iz3DControl;
begin
  if (s_pControlFocus<>nil) and (s_pControlFocus.Dialog = Self as Iz3DDialog) then s_pControlFocus := nil;
  if (s_pControlPressed<>nil) and (s_pControlPressed.Dialog = Self as Iz3DDialog) then s_pControlPressed := nil;
  FControlMouseOver := nil;

  for i:= 0 to ControlCount - 1 do
  begin
    pControl := m_Controls[i] as Iz3DControl;
    pControl:= nil;
  end;

  m_Controls := nil; // RemoveAll;
end;

procedure Tz3DDialog.EnableNonUserEvents(bEnable: Boolean);
begin FNonUserEvents := bEnable; end;

procedure Tz3DDialog.EnableKeyboardInput(bEnable: Boolean);
begin FKeyboardInput := bEnable; end;

procedure Tz3DDialog.EnableMouseInput(bEnable: Boolean);
begin FMouseInput := bEnable; end;

function Tz3DDialog.GetLeft: Integer;
begin
  Result:= FLeft;
end;

function Tz3DDialog.GetTop: Integer;
begin
  Result:= FTop;
end;

procedure Tz3DDialog.SetLeft(const Value: Integer);
begin
  FLeft:= Value;
end;

procedure Tz3DDialog.SetTop(const Value: Integer);
begin
  FTop:= Value;
end;

function Tz3DDialog.GetCaption: PWideChar;
begin
  Result:= FCaptionStr;
end;

{ Tz3DGUIController }

constructor Tz3DGUIController.Create(const ADesktop: Iz3DDesktop);
begin
  inherited Create;
  FDialogs:= TInterfaceList.Create;
  FDesktop:= ADesktop;
end;

function Tz3DGUIController.GetModalMode: Boolean;
begin
  Result:= FModalMode;
end;

procedure Tz3DGUIController.SetModalMode(const Value: Boolean);
begin
  FModalMode:= Value;
end;

procedure Tz3DGUIController.BringToFront(const ADialog: Iz3DDialog);
begin
  FDialogs.Remove(ADialog);
  FDialogs.Add(ADialog);
end;

procedure Tz3DGUIController.GUIRender;
var I: Integer;
    FDevice: IDirect3DDevice9;
begin
  inherited;
  if FDialogs.Count = 0 then Exit;
  
  FDevice := z3DCore_GetD3DDevice;
  GetStateBlock.Capture;
  FDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);
  FDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
  FDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
  FDevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
  FDevice.SetRenderState(D3DRS_SHADEMODE, D3DSHADE_GOURAUD);
  FDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_SELECTARG2);
  FDevice.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);
  FDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_SELECTARG1);
  FDevice.SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_DIFFUSE);
  FDevice.SetTextureStageState(0, D3DTSS_RESULTARG, D3DTA_CURRENT);
  FDevice.SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
  FDevice.SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);
  FDevice.SetVertexShader(nil);
  FDevice.SetPixelShader(nil);

  // Render the dialogs iterating trought the z-order
  for I:= 0 to FDialogs.Count-1 do (FDialogs[I] as Iz3DDialog).Render;

  GetStateBlock.Apply;
end;

function Tz3DGUIController.GetDesktop: Iz3DDesktop;
begin
  Result:= FDesktop;
end;

destructor Tz3DGUIController.Destroy;
begin
  Tz3DUniBuffer.Uninitialize;
  Tz3DIMEEditBox.Uninitialize;
end;

function Tz3DGUIController.GetStateBlock: IDirect3DStateBlock9;
begin
  Result:= FStateBlock;
end;

procedure Tz3DGUIController.CreateScenarioObjects(const AResetDevice: Boolean);
var I: Integer;
    pFontNode: Pz3DFontNode;
begin
  inherited;
  if AResetDevice then
  begin
    for i:= 0 to Length(FFontCache) - 1 do
    begin
      pFontNode := FFontCache[i];
      if (pFontNode.Font <> nil) then pFontNode.Font.OnResetDevice;
    end;
    if (FSprite <> nil) then FSprite.OnResetDevice;
    z3DCore_GetD3DDevice.CreateStateBlock(D3DSBT_ALL, FStateBlock);
  end else
  begin
    for i:= 0 to Length(FFontCache) - 1 do CreateFont(i);
    for i:= 0 to Length(FTextureCache) - 1 do CreateTexture(i);
    D3DXCreateSprite(z3DCore_GetD3DDevice, FSprite);
    Tz3DIMEEditBox.StaticOnCreateDevice;
  end;
end;

procedure Tz3DGUIController.DestroyScenarioObjects(const ALostDevice: Boolean);
var i: Integer;
    pFontNode: Pz3DFontNode;
    pTextureNode: Pz3DTextureNode;
begin
  inherited;
  if ALostDevice then
  begin
    for i:= 0 to Length(FFontCache) - 1 do
    begin
      pFontNode := FFontCache[i];
      if (pFontNode.Font <> nil) then pFontNode.Font.OnLostDevice;
    end;
    if (FSprite <> nil) then FSprite.OnLostDevice;
    FStateBlock := nil;
  end else
  begin
    for i:= 0 to Length(FFontCache) - 1 do
    begin
      pFontNode := FFontCache[i];
      pFontNode.Font := nil;
    end;
    if (FSprite <> nil) then FSprite.OnLostDevice;
    for i:= 0 to Length(FTextureCache) - 1 do
    begin
      pTextureNode := FTextureCache[i];
      pTextureNode.Texture := nil;
    end;
    FSprite := nil;
  end;
end;

procedure Tz3DGUIController.Message(const AWnd: HWND; const AMsg: Cardinal; const AwParam, AlParam: Integer;
  var ADefault: Boolean; var AResult: Integer);
var I: Integer;
    FHandled: Boolean;
begin
  inherited;
  AResult:= Integer(Tz3DIMEEditBox.StaticMsgProc(AMsg, AwParam, AlParam));
  for I:= FDialogs.Count-1 downto 0 do
  begin
    if (not FModalMode or (FDialogs[I] as Iz3DDialog).ModalMode) and
    (not FHandled or z3DSupports(FDialogs[I], Iz3DMainMenuDialog)) then
    (FDialogs[I] as Iz3DDialog).Message(AWnd, AMsg, AwParam, AlParam, FHandled);
  end;
end;

function Tz3DGUIController.GetSprite: ID3DXSprite;
begin
  Result:= FSprite;
end;

function Tz3DGUIController.GetDialogCount: Integer;
begin
  Result:= FDialogs.Count;
end;

function Tz3DGUIController.GetDialogs(const I: Integer): Iz3DDialog;
begin
  Result:= FDialogs[I] as Iz3DDialog;
end;

function Tz3DGUIController.IndexOf(const ADialog: Iz3DDialog): Integer;
begin
  Result:= FDialogs.IndexOf(ADialog);
end;

function Tz3DGUIController.GetFonts(iIndex: Integer): Pz3DFontNode;
begin Result:= FFontCache[iIndex]; end;

function Tz3DGUIController.GetTextureNode(iIndex: Integer): Pz3DTextureNode;
begin
  Result:= FTextureCache[iIndex];
end;

function Tz3DGUIController.RegisterDialog(pDialog: Iz3DDialog): Boolean;
var
  i: Integer;
begin
  Result:= True;

  // Check that the dialog isn't already registered.
  for i := 0 to FDialogs.Count - 1 do
    if (FDialogs[i] = pDialog) then Exit;

  // Add to the list.
  try
    FDialogs.Add(pDialog);
  except
    Result:= False;
    Exit;
  end;

  // Set up next and prev pointers.
  if (FDialogs.Count > 1)
  then (FDialogs[FDialogs.Count - 2] as Iz3DDialog).SetNextDialog(pDialog);
  (FDialogs[FDialogs.Count - 1] as Iz3DDialog).SetNextDialog(FDialogs[0] as Iz3DDialog);
end;

procedure Tz3DGUIController.UnregisterDialog(pDialog: Iz3DDialog);
var
  i: Integer;
  l, r: Integer;
begin
  if pDialog.ModalMode then FModalMode:= False;
  // Search for the dialog in the list.
  for i := 0 to FDialogs.Count - 1 do
    if (FDialogs[i] = pDialog) then
    begin
      FDialogs.Delete(i);
      
      if (FDialogs.Count > 0) then
      begin
        if (i = 0)
        then l := FDialogs.Count - 1
        else l := i - 1;

        if (FDialogs.Count = i)
        then r := 0
        else r := i;

        (FDialogs[l] as Iz3DDialog).SetNextDialog(FDialogs[r] as Iz3DDialog);
      end;
      Break;
    end;
end;

procedure Tz3DGUIController.EnableKeyboardInputForAllDialogs;
var
  i: Integer;
begin
  // Enable keyboard input for all registered dialogs
  for i := 0 to FDialogs.Count - 1 do
    (FDialogs[i] as Iz3DDialog).EnableKeyboardInput(True);
end;

function Tz3DGUIController.AddFont(strFaceName: PWideChar; height, weight: Longint): Integer;
var
  i: Integer;
  pFontNode: Pz3DFontNode;
  pNewFontNode: Pz3DFontNode;
  iFont: Integer;
  // nLen: size_t;
begin
  // See if this font already exists
  for i:= 0 to Length(FFontCache) - 1 do
  begin
    pFontNode := FFontCache[i];
    // StringCchLength(strFaceName, MAX_PATH, nLen);
    if (0 = lstrcmpiW(pFontNode.Name, strFaceName{, nLen})) and
       (pFontNode.Height = height) and
       (pFontNode.Weight = weight) then
    begin
      Result:= i;
      Exit;
    end;
  end;

  // Add a new font and try to create it
  try
    New(pNewFontNode);
  except
    Result:= -1;
    Exit;
  end;

  ZeroMemory(pNewFontNode, SizeOf(Tz3DFontNode));
  StringCchCopy(pNewFontNode.Name, MAX_PATH, strFaceName);
  pNewFontNode.Height := height;
  pNewFontNode.Weight := weight;

  // FFontCache.Add(pNewFontNode);
  iFont := Length(FFontCache);
  SetLength(FFontCache, iFont+1);
  FFontCache[iFont]:= pNewFontNode;

  // If a device is available, try to create immediately
  if (z3DCore_GetD3DDevice <> nil) then CreateFont(iFont);

  Result:= iFont;
end;

function Tz3DDialog.SetFont(index: LongWord; strFaceName: PWideChar; height, weight: Longint): HRESULT;
var
  i, l, iFont: Integer;
begin
  // If this assert triggers, you need to call Tz3DDialog::Init() first.  This change
  // was made so that the z3D's GUI could become seperate and optional from z3D's core.  The
  // creation and interfacing with Tz3DGUIController is now the responsibility
  // of the application if it wishes to use z3D's GUI.
  Assert(Assigned(Manager), 'To fix call Tz3DDialog.Init(Default) first. See comments for details.');

  // Make sure the list is at least as large as the index being set
  l:= Length(m_Fonts);
  if l <= Integer(index) then
  begin
    SetLength(m_Fonts, index+1);
    for i:= l to index do m_Fonts[i]:= -1;
  end;

  iFont := Manager.AddFont(strFaceName, height, weight);
  m_Fonts[index]:= iFont;

  Result:= S_OK;
end;

function Tz3DDialog.GetFont(index: LongWord): Pz3DFontNode;
begin
  if (Manager = nil) then
  begin
    Result:= nil;
    Exit;
  end;
  Result:= Manager.Fonts[m_Fonts[index]];
end;

function Tz3DGUIController.AddTexture(strFilename: PWideChar): Integer;
var
  i: Integer;
  pTextureNode, pNewTextureNode: Pz3DTextureNode;
  iTexture: Integer;
  nLen: size_t;
begin
  // See if this texture already exists
  for i:= 0 to Length(FTextureCache) - 1 do
  begin
    pTextureNode := FTextureCache[i];
    StringCchLength(strFilename, MAX_PATH, nLen);
    if pTextureNode.FileSource and // Sources must match
       // (0 = _wcsnicmp(pTextureNode.strFilename, strFilename, nLen)) then
       (0 =  lstrcmpiW(pTextureNode.Filename, strFilename)) then
    begin
      Result:= i;
      Exit;
    end;
  end;

  // Add a new texture and try to create it
  try
    New(pNewTextureNode);
  except
    Result:= -1;
    Exit;
  end;

  ZeroMemory(pNewTextureNode, SizeOf(Tz3DTextureNode));
  pNewTextureNode.FileSource := True;
  StringCchCopy(pNewTextureNode.Filename, MAX_PATH, strFilename);

  //FTextureCache.Add(pNewTextureNode);
  iTexture := Length(FTextureCache);
  SetLength(FTextureCache, iTexture+1);
  FTextureCache[iTexture]:= pNewTextureNode;

  // If a device is available, try to create immediately
  if (z3DCore_GetD3DDevice <> nil) then CreateTexture(iTexture);

  Result:= iTexture;
end;

function Tz3DGUIController.CreateTexture(iTexture: LongWord): HRESULT;
var
  pTextureNode: Pz3DTextureNode;
  info: TD3DXImageInfo;
  pID: PWideChar;
begin
  pTextureNode := FTextureCache[iTexture];

  if not pTextureNode.FileSource then
  begin
    if (pTextureNode.ResourceID <> 0)
    then pID := PWideChar(size_t(pTextureNode.ResourceID))
    else pID := pTextureNode.Filename;

    // Create texture from resource
    Result :=  D3DXCreateTextureFromResourceExW(z3DCore_GetD3DDevice,
                   pTextureNode.ResourceModule, pID, D3DX_DEFAULT, D3DX_DEFAULT,
                   1, 0, D3DFMT_UNKNOWN, D3DPOOL_MANAGED,
                   D3DX_DEFAULT, D3DX_DEFAULT, 0,
                   @info, nil, pTextureNode.Texture);
    if FAILED(Result) then
    begin
      Result:= DXTRACE_ERR('D3DXCreateTextureFromResourceEx', Result);
      Exit;
    end;
  end else
  begin
    // Make sure there's a texture to create
    if (pTextureNode.Filename[0] = #0) then
    begin
      Result:= S_OK;
      Exit;
    end;

    // Create texture from file
    Result :=  D3DXCreateTextureFromFileExW(z3DCore_GetD3DDevice, pTextureNode.Filename, D3DX_DEFAULT, D3DX_DEFAULT,
                   1, 0, D3DFMT_UNKNOWN, D3DPOOL_MANAGED,
                   D3DX_DEFAULT, D3DX_DEFAULT, 0,
                   @info, nil, pTextureNode.Texture);
    if FAILED(Result) then
    begin
      Result:= DXTRACE_ERR('D3DXCreateTextureFromFileEx', Result);
      Exit;
    end;
  end;

  // Store dimensions
  pTextureNode.Width := info.Width;
  pTextureNode.Height := info.Height;

  Result:= S_OK;
end;

function IS_INTRESOURCE(_r: Pointer): Boolean;
begin
  Result:= ((ULONG_PTR(_r) shr 16) = 0);
end;

function Tz3DGUIController.AddTexture(strResourceName: PWideChar; hResourceModule: HMODULE): Integer;
var
  i: Integer;
  pTextureNode, pNewTextureNode: Pz3DTextureNode;
  iTexture: Integer;
  nLen: size_t;
begin
  // See if this texture already exists
  for i:= 0 to Length(FTextureCache) - 1 do
  begin
    pTextureNode := FTextureCache[i];
    if not pTextureNode.FileSource and      // Sources must match
       (pTextureNode.ResourceModule = hResourceModule) then // Module handles must match
    begin
      if IS_INTRESOURCE(strResourceName) then
      begin
        // Integer-based ID
        if (INT_PTR(strResourceName) = pTextureNode.ResourceID) then
        begin
          Result:= i;
          Exit;
        end;
      end else
      begin
        // String-based ID
        StringCchLength(strResourceName, MAX_PATH, nLen);
        // if (0 = _wcsnicmp(pTextureNode.strFilename, strResourceName, nLen)) then
        if (0 = lstrcmpiW(pTextureNode.Filename, strResourceName{, nLen})) then
        begin
          Result:= i;
          Exit;
        end;
      end;
    end;
  end;

  // Add a new texture and try to create it
  try
    New(pNewTextureNode);
  except
    Result:= -1;
    Exit;
  end;

  ZeroMemory(pNewTextureNode, SizeOf(Tz3DTextureNode));
  pNewTextureNode.ResourceModule := hResourceModule;
  if IS_INTRESOURCE(strResourceName)
  then pNewTextureNode.ResourceID := Integer(size_t(strResourceName))
  else
  begin
    pNewTextureNode.ResourceID := 0;
    StringCchCopy(pNewTextureNode.Filename, MAX_PATH, strResourceName);
  end;

  //FTextureCache.Add(pNewTextureNode);
  iTexture := Length(FTextureCache);
  SetLength(FTextureCache, iTexture+1);
  FTextureCache[iTexture]:= pNewTextureNode;

  // If a device is available, try to create immediately
  if (z3DCore_GetD3DDevice <> nil) then CreateTexture(iTexture);

  Result:= iTexture;
end;

function Tz3DDialog.SetTexture(index: LongWord; strFilename: PWideChar): HRESULT;
var
  i, l, iTexture: Integer;
begin
  // If this assert triggers, you need to call Tz3DDialog::Init() first.  This change
  // was made so that the z3D's GUI could become seperate and optional from z3D's core.  The
  // creation and interfacing with Tz3DGUIController is now the responsibility
  // of the application if it wishes to use z3D's GUI.
  Assert(Assigned(Manager), 'To fix this, call Tz3DDialog::Init() first. See comments for details.');

  // Make sure the list is at least as large as the index being set
  l:= Length(m_Textures);
  if l <= Integer(index) then
  begin
    SetLength(m_Textures, index+1);
    for i:= l to index do m_Textures[i]:= -1;
  end;

  iTexture := Manager.AddTexture(strFilename);

  m_Textures[index]:= iTexture;
  Result:= S_OK;
end;

function Tz3DDialog.SetTexture(index: LongWord; strResourceName: PWideChar; hResourceModule: HMODULE): HRESULT;
var
  i, L: LongWord;
  iTexture: Integer;
begin
  // If this assert triggers, you need to call Tz3DDialog::Init() first.  This change
  // was made so that the z3D's GUI could become seperate and optional from z3D's core.  The
  // creation and interfacing with Tz3DGUIController is now the responsibility
  // of the application if it wishes to use z3D's GUI.
  Assert(Assigned(Manager), 'To fix this, call Tz3DDialog::Init() first.  See comments for details.');

  // Make sure the list is at least as large as the index being set
  L:= Length(m_Textures);
  if (L >= index) then
  begin
    SetLength(m_Textures, index+1);
    for i:= L to index do m_Textures[i]:= -1;
  end;

  iTexture := FManager.AddTexture(strResourceName, hResourceModule);

  m_Textures[index] := iTexture;
  Result:= S_OK;
end;

function Tz3DDialog.GetTexture(index: LongWord): Pz3DTextureNode;
begin
  if (Manager = nil) then
  begin
    Result:= nil;
    Exit;
  end;

  Result:= Manager.GetTextureNode(m_Textures[index]);
end;

function Tz3DDialog.GetControlAtPoint(pt: TPoint): Iz3DControl;
var
  i: Integer;
  pControl: Iz3DControl;
begin
  // Search through all child controls for the first one which
  // contains the mouse point
  for i:= 0 to ControlCount - 1 do
  begin
    pControl := m_Controls[i] as Iz3DControl;
    if (pControl = nil) then Continue;
    // We only return the current control if it is visible
    // and enabled.  Because GetControlAtPoint() is used to do mouse
    // hittest, it makes sense to perform this filtering.
    if pControl.ContainsPoint(pt) and pControl.Enabled and pControl.Visible then
    begin
      Result:= pControl;
      Exit;
    end;
  end;
  Result:= nil;
end;

function Tz3DDialog.GetControlEnabled(ID: Integer): Boolean;
var
  pControl: Iz3DControl;
begin
  pControl := GetControl(ID);
  if (pControl = nil) then Result:= False
  else Result:= pControl.Enabled;
end;

procedure Tz3DDialog.SetControlEnabled(ID: Integer; bEnabled: Boolean);
var
  pControl: Iz3DControl;
begin
  pControl := GetControl(ID);
  if (pControl <> nil) then pControl.Enabled:= bEnabled;
end;

procedure Tz3DDialog.OnMouseUp(pt: TPoint);
begin
  s_pControlPressed := nil;
  FControlMouseOver := nil;
end;

procedure Tz3DDialog.OnMouseMove(pt: TPoint);
var
  pControl: Iz3DControl;
begin
  // Figure out which control the mouse is over now
  pControl := GetControlAtPoint(pt);

  // If the mouse is still over the same control, nothing needs to be done
  if (pControl = FControlMouseOver) then Exit;

  // Handle mouse leaving the old control
  if (FControlMouseOver <> nil) then FControlMouseOver.OnMouseLeave;

  // Handle mouse entering the new control
  FControlMouseOver := pControl;
  if (pControl <> nil) then FControlMouseOver.OnMouseEnter;
end;

function Tz3DDialog.SetDefaultDisplay(nControlType: Tz3DControlType; iDisplay: LongWord; const pDisplay: Iz3DDisplay): HRESULT;
var
  i, l: Integer;
  pDisplayHolder: Pz3DDisplayHolder;
  pNewHolder: Pz3DDisplayHolder;
begin
  // If this Display type already exist in the list, simply update the stored Display
  for i:= 0 to Length(m_DefaultDisplays) - 1 do
  begin
    pDisplayHolder := m_DefaultDisplays[i];

    if (pDisplayHolder.ControlType = nControlType) and
       (pDisplayHolder.DisplayIndex = iDisplay) then
    begin
      pDisplayHolder.Display.Assign(pDisplay);
      Result:= S_OK;
      Exit;
    end;
  end;

  // Otherwise, add a new entry
  try
    New(pNewHolder);
    pNewHolder.Display:= Tz3DDisplay.Create;
  except
    Result:= E_OUTOFMEMORY;
    Exit;
  end;

  pNewHolder.ControlType := nControlType;
  pNewHolder.DisplayIndex := iDisplay;
  pNewHolder.Display.Assign(pDisplay);

  // m_DefaultDisplays.Add(pNewHolder);
  l:= Length(m_DefaultDisplays);
  SetLength(m_DefaultDisplays, l+1);
  m_DefaultDisplays[l]:= pNewHolder;

  Result:= S_OK;
end;

function Tz3DDialog.GetDefaultDisplay(nControlType: Tz3DControlType; iDisplay: LongWord): Iz3DDisplay;
var
  i: Integer;
  pDisplayHolder: Pz3DDisplayHolder;
begin
  for i:= 0 to Length(m_DefaultDisplays) - 1 do
  begin
    pDisplayHolder := m_DefaultDisplays[i];
    if (pDisplayHolder.ControlType = nControlType) and
    (pDisplayHolder.DisplayIndex = iDisplay) then
    begin
      Result:= pDisplayHolder.Display;
      Exit;
    end;
  end;
  Result:= nil;
end;

function Tz3DDialog.AddLabel(ID: Integer; strText: PWideChar; x, y, width, height: Integer; bIsDefault: Boolean = False; ppCreated: PIz3DLabel = nil): HRESULT;
var
  FLabel: Iz3DLabel;
begin
  try
    FLabel := Tz3DLabel.Create(Self);
  except
    Result:= E_OUTOFMEMORY;
    Exit;
  end;
  if (ppCreated <> nil) then ppCreated^ := FLabel;

  Result := AddControl(FLabel);
  if FAILED(Result) then Exit;

  // Set the ID and list index
  FLabel.ID := ID;
  FLabel.Text:= strText;
  FLabel.SetLocation(x, y);
  FLabel.SetSize(width, height);
  FLabel.Default:= bIsDefault;
  Result:= S_OK;
end;

function Tz3DDialog.AddButton(ID: Integer; strText: PWideChar; x, y, width, height: Integer; nHotkey: LongWord = 0; bIsDefault: Boolean = False; ppCreated: PIz3DButton = nil): HRESULT;
var
  pButton: Iz3DButton;
begin
  try
    pButton := Tz3DButton.Create(Self);
  except
    Result:= E_OUTOFMEMORY;
    Exit;
  end;
  if (ppCreated <> nil) then ppCreated^ := pButton;

  Result := AddControl(pButton);
  if FAILED(Result) then Exit;

  // Set the ID and list index
  pButton.ID:= ID;
  pButton.Text:= strText;
  pButton.SetLocation(x, y);
  pButton.SetSize(width, height);
  pButton.Hotkey:= nHotkey;
  pButton.Default:= bIsDefault;

  Result:= S_OK;
end;

function Tz3DDialog.AddCheckBox(ID: Integer; strText: PWideChar; x, y, width, height: Integer; bChecked: Boolean = False; nHotkey: LongWord = 0; bIsDefault: Boolean = False; ppCreated: PIz3DCheckBox = nil): HRESULT;
var
  pCheckBox: Iz3DCheckBox;
begin
  try
    pCheckBox := Tz3DCheckBox.Create(Self);
  except
    Result:= E_OUTOFMEMORY;
    Exit;
  end;
  if (ppCreated <> nil) then ppCreated^ := pCheckBox;

  Result := AddControl(pCheckBox);
  if FAILED(Result) then Exit;

  // Set the ID and list index
  pCheckBox.ID:= ID;
  pCheckBox.Text:= strText;
  pCheckBox.SetLocation(x, y);
  pCheckBox.SetSize(width, height);
  pCheckBox.Hotkey:= nHotkey;
  pCheckBox.Default:= bIsDefault;
  pCheckBox.Checked:= bChecked;

  Result:= S_OK;
end;

function Tz3DDialog.AddRadioButton(ID: Integer; nButtonGroup: LongWord; strText: PWideChar; x, y, width, height: Integer; bChecked: Boolean = False; nHotkey: LongWord = 0; bIsDefault: Boolean = False; ppCreated: PIz3DRadioButton = nil): HRESULT;
var
  pRadioButton: Iz3DRadioButton;
begin
  try
    pRadioButton := Tz3DRadioButton.Create(Self);
    if (ppCreated <> nil) then ppCreated^ := pRadioButton;
  except
    Result:= E_OUTOFMEMORY;
    Exit;
  end;

  Result := AddControl(pRadioButton);
  if FAILED(Result) then Exit;

  // Set the ID and list index
  pRadioButton.ID:= ID;
  pRadioButton.Text:= strText;
  pRadioButton.ButtonGroup:= nButtonGroup;
  pRadioButton.SetLocation(x, y);
  pRadioButton.SetSize(width, height);
  pRadioButton.Hotkey:= nHotkey;
  pRadioButton.Checked:= bChecked; // <-- look HERE
  pRadioButton.Default:= bIsDefault;
  pRadioButton.Checked:= bChecked; //todo: look above - validate what is't really needed

  Result:= S_OK;
end;

function Tz3DDialog.AddComboBox(ID: Integer; x, y, width, height: Integer; nHotKey: LongWord = 0; bIsDefault: Boolean = False; ppCreated: PIz3DComboBox = nil): HRESULT;
var
  pComboBox: Iz3DComboBox;
begin
  try
    pComboBox := Tz3DComboBox.Create(Self);
    if (ppCreated <> nil) then ppCreated^ := pComboBox;
  except
    Result:= E_OUTOFMEMORY;
    Exit;
  end;

  Result := AddControl(pComboBox);
  if FAILED(Result) then Exit;

  // Set the ID and list index
  pComboBox.ID:= ID;
  pComboBox.SetLocation(x, y);
  pComboBox.SetSize(width, height);
  pComboBox.Hotkey:= nHotkey;
  pComboBox.Default := bIsDefault;

  Result:= S_OK;
end;

function Tz3DDialog.AddTrackBar(ID: Integer; x, y, width, height: Integer; min: Integer = 0; max: Integer = 100; value: Integer = 50; bIsDefault: Boolean = False; ppCreated: PIz3DTrackBar = nil): HRESULT;
var
  FTrackBar: Iz3DTrackBar;
begin
  try
    FTrackBar := Tz3DTrackBar.Create(Self);

    if (ppCreated <> nil) then ppCreated^ := FTrackBar;
  except
    on EOutOfMemory do
    begin
      Result:= E_OUTOFMEMORY;
      Exit;
    end;
  end;

  Result := AddControl(FTrackBar);
  if FAILED(Result) then Exit;

  // Set the ID and list index
  FTrackBar.ID:= ID;
  FTrackBar.SetLocation(x, y);
  FTrackBar.SetSize(width, height);
  FTrackBar.Default := bIsDefault;
  FTrackBar.SetRange(min, max);
  FTrackBar.SetValue(value);
  FTrackBar.UpdateRects;

  Result:= S_OK;
end;

function Tz3DDialog.AddEditBox(ID: Integer; strText: PWideChar; x, y, width, height: Integer; bIsDefault: Boolean = False; ppCreated: PIz3DEdit = nil): HRESULT;
var
  pEditBox: Iz3DEdit;
begin
  try
    pEditBox := Tz3DEdit.Create(Self);

    if (ppCreated <> nil) then ppCreated^:= pEditBox;
  except
    on EOutOfMemory do
    begin
      Result:= E_OUTOFMEMORY;
      Exit;
    end;
  end;

  Result := AddControl(pEditBox);
  if FAILED(Result) then Exit;

  // Set the ID and position
  pEditBox.ID := ID;
  pEditBox.SetLocation(x, y);
  pEditBox.SetSize(width, height);
  pEditBox.Default := bIsDefault;

  if (strText <> nil) then pEditBox.SetText(strText);

  Result:= S_OK;
end;

function Tz3DDialog.AddIMEEditBox(ID: Integer; strText: PWideChar; x, y, width, height: Integer; bIsDefault: Boolean = False; ppCreated: PIz3DIMEEditBox = nil): HRESULT;
var
  pEditBox: Iz3DIMEEditBox;
begin
  try
    pEditBox := Tz3DIMEEditBox.Create(Self);

    if (ppCreated <> nil) then ppCreated^:= pEditBox;
  except
    on EOutOfMemory do
    begin
      Result:= E_OUTOFMEMORY;
      Exit;
    end;
  end;

  Result := AddControl(pEditBox);
  if FAILED(Result) then Exit;

  // Set the ID and position
  pEditBox.ID := ID;
  pEditBox.SetLocation(x, y);
  pEditBox.SetSize(width, height);
  pEditBox.Default := bIsDefault;

  if (strText <> nil) then pEditBox.SetText(strText);

  Result:= S_OK;
end;

function Tz3DDialog.AddListBox(ID: Integer; x, y, width, height: Integer; dwStyle: Tz3DListBoxStyle = z3dlbsNormal; ppCreated: PIz3DListBox = nil): HRESULT;
var
  pListBox: Iz3DListBox;
begin
  try
    pListBox := Tz3DListBox.Create(Self);
    if (ppCreated <> nil) then ppCreated^:= pListBox;
  except
    Result:= E_OUTOFMEMORY;
    Exit;
  end;

  Result := AddControl(pListBox);
  if FAILED(Result) then Exit;

  // Set the ID and position
  pListBox.ID:= ID;
  pListBox.SetLocation(x, y);
  pListBox.SetSize(width, height);
  pListBox.Style:= dwStyle;

  Result:= S_OK;
end;

function Tz3DDialog.InitControl(const pControl: Iz3DControl): HRESULT;
var
  i: Integer;
  pDisplayHolder: Pz3DDisplayHolder;
begin
  if (pControl = nil) then
  begin
    Result:= E_INVALIDARG;
    Exit;
  end;

  pControl.Index := ControlCount;
    
  // Look for a default Display entries
  for i:= 0 to Length(m_DefaultDisplays) - 1 do
  begin
    pDisplayHolder := m_DefaultDisplays[i];
    if (pDisplayHolder.ControlType = pControl.GetType)
    then pControl.SetDisplay(pDisplayHolder.DisplayIndex, pDisplayHolder.Display);
  end;

  Result:= pControl.OnInit;
  if z3DFailedTrace(Result) then Exit;

  Result:= S_OK;
end;

function Tz3DDialog.AddControl(const pControl: Iz3DControl): HRESULT;
begin
  Result := InitControl(pControl);
  if FAILED(Result) then
  begin
    Result:= DXTRACE_ERR('Cz3DDialog.InitControl', Result);
    Exit;
  end;
  m_Controls.Add(pControl);
  Result:= S_OK;
end;

function Tz3DDialog.GetLabel(ID: Integer): Iz3DLabel;
begin
  Result:= GetControl(ID, z3dctLabel) as Iz3DLabel;
end;

function Tz3DDialog.GetButton(ID: Integer): Iz3DButton;
begin
  Result:= GetControl(ID, z3dctButton) as Iz3DButton;
end;

function Tz3DDialog.GetCheckBox(ID: Integer): Iz3DCheckBox;
begin
  Result:= GetControl(ID, z3dctCheckBox) as Iz3DCheckBox;
end;

function Tz3DDialog.GetRadioButton(ID: Integer): Iz3DRadioButton;
begin
  Result:= GetControl(ID, z3dctRadioButton) as Iz3DRadioButton;
end;

function Tz3DDialog.GetComboBox(ID: Integer): Iz3DComboBox;
begin
  Result:= GetControl(ID, z3dctComboBox) as Iz3DComboBox;
end;

function Tz3DDialog.GetTrackBar(ID: Integer): Iz3DTrackBar;
begin
  Result:= Tz3DTrackBar(GetControl(ID, z3dctTrackBar));
end;

function Tz3DDialog.GetEditBox(ID: Integer): Iz3DEdit;
begin
  Result:= GetControl(ID, z3dctEdit) as Iz3DEdit;
end;

function Tz3DDialog.GetIMEEditBox(ID: Integer): Iz3DIMEEditBox;
begin
  Result:= GetControl(ID, z3dctIMEEdit) as Iz3DIMEEditBox;
end;

function Tz3DDialog.GetListBox(ID: Integer): Iz3DListBox;
begin
  Result:= GetControl(ID, z3dctListBox) as Iz3DListBox;
end;

function Tz3DDialog.GetControl(ID: Integer): Iz3DControl;
var
  i: Integer;
  pControl: Iz3DControl;
begin
  // Try to find the control with the given ID
  for i:= 0 to ControlCount - 1 do
  begin
    pControl := m_Controls[i] as Iz3DControl;

    if (pControl.ID = ID) then
    begin
      Result:= pControl;
      Exit;
    end;
  end;

  // Not found
  Result:= nil;
end;

function Tz3DDialog.GetControlProp(ID: Integer): Iz3DControl;
begin
  Result := GetControl(ID);
end;

function Tz3DDialog.GetControl(ID: Integer; nControlType: Tz3DControlType): Iz3DControl;
var
  i: Integer;
  pControl: Iz3DControl;
begin
  // Try to find the control with the given ID
  for i:= 0 to ControlCount - 1 do
  begin
    pControl := m_Controls[i] as Iz3DControl;

    if (pControl.ID = ID) and (pControl.GetType = nControlType) then
    begin
      Result:= pControl;
      Exit;
    end;
  end;

  // Not found
  Result:= nil;
end;

function Tz3DDialog.GetNextControl(pControl: Iz3DControl): Iz3DControl;
var
  index: Integer;
  pDialog: Iz3DDialog;
begin
  index := pControl.Index + 1;
  pDialog := pControl.Dialog;

  // Cycle through dialogs in the loop to find the next control. Note
  // that if only one control exists in all looped dialogs it will
  // be the returned 'next' control.
  while (index >= pDialog.ControlCount) do
  begin
    pDialog := pDialog.GetNextDialog;
    index := 0;
  end;

  Result:= pDialog.ControlIndex[index];
end;

function Tz3DDialog.GetPrevControl(pControl: Iz3DControl): Iz3DControl;
var
  index: Integer;
  pDialog: Iz3DDialog;
begin
  index := pControl.Index - 1;

  pDialog := pControl.Dialog;

  // Cycle through dialogs in the loop to find the next control. Note
  // that if only one control exists in all looped dialogs it will
  // be the returned 'previous' control.
  while (index < 0) do
  begin
    pDialog := pDialog.GetPrevDialog;
    if (pDialog = nil) then pDialog := pControl.Dialog;

    index := pDialog.ControlCount - 1;
  end;

  Result:= pDialog.ControlIndex[index];
end;

procedure Tz3DDialog.ClearRadioButtonGroup(nGroup: LongWord);
var
  i: Integer;
  pControl: Iz3DControl;
  pRadioButton: Iz3DRadioButton;
begin
  // Find all radio buttons with the given group number
  for i:= 0 to ControlCount - 1 do
  begin
    pControl := m_Controls[i] as Iz3DControl;

    if (pControl.GetType = z3dctRadioButton) then
    begin
      pRadioButton := pControl as Iz3DRadioButton;

      if (pRadioButton.ButtonGroup = nGroup)
      then pRadioButton.SetChecked(False, False);
    end;
  end;
end;

procedure Tz3DDialog.ClearComboBox(ID: Integer);
var
  pComboBox: Iz3DComboBox;
begin
  pComboBox := GetComboBox(ID);
  if (pComboBox = nil) then Exit;

  pComboBox.RemoveAllItems;
end;

procedure Tz3DDialog.RequestFocus(pControl: Iz3DControl);
begin
  if (s_pControlFocus = pControl) then Exit;

  if (not pControl.CanHaveFocus) then Exit;

  if (s_pControlFocus <> nil) then s_pControlFocus.OnFocusOut;

  pControl.OnFocusIn;
  s_pControlFocus := pControl;
end;

function Tz3DDialog.DrawRect(const pRect: TRect; color: TD3DColor): HRESULT;
var
  rcScreen: TRect;
  vertices: array[0..3] of Tz3DScreenVertex;
  pd3dDevice: IDirect3DDevice9;
  pDecl: IDirect3DVertexDeclaration9;
begin
  rcScreen := pRect;
  OffsetRect(rcScreen, FLeft, FTop);

  // If caption is enabled, offset the Y position by its height.
//  if FCaption then OffsetRect(rcScreen, 0, Manager.Desktop.ThemeSettings.CaptionHeight);

  vertices[0]:= z3DScreenVertex(rcScreen.left  -0.5, rcScreen.top -0.5,    0.5, 1.0, color, 0, 0);
  vertices[1]:= z3DScreenVertex(rcScreen.right -0.5, rcScreen.top -0.5,    0.5, 1.0, color, 0, 0);
  vertices[2]:= z3DScreenVertex(rcScreen.right -0.5, rcScreen.bottom -0.5, 0.5, 1.0, color, 0, 0);
  vertices[3]:= z3DScreenVertex(rcScreen.left  -0.5, rcScreen.bottom -0.5, 0.5, 1.0, color, 0, 0);

  pd3dDevice := z3DCore_GetD3DDevice;

  // Since we're doing our own drawing here we need to flush the sprites
  Manager.Sprite.Flush;
  pd3dDevice.GetVertexDeclaration(pDecl);  // Preserve the sprite's current vertex decl
  pd3dDevice.SetFVF(Tz3DScreenVertex_FVF);

  pd3dDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_SELECTARG2);
  pd3dDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_SELECTARG2);

  pd3dDevice.DrawPrimitiveUP(D3DPT_TRIANGLEFAN, 2, vertices, SizeOf(Tz3DScreenVertex));

  pd3dDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
  pd3dDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);

  // Restore the vertex decl
  pd3dDevice.SetVertexDeclaration(pDecl);
  pDecl:= nil;

  Result:= S_OK;
end;

function Tz3DDialog.DrawPolyLine(apPoints: PPoint; nNumPoints: LongWord; color: TD3DColor): HRESULT;
begin
//todo: Don't forget convert this to Pascal
(*  z3D_SCREEN_VERTEX* vertices = new z3D_SCREEN_VERTEX[ nNumPoints ];
  if( vertices == NULL )
      return E_OUTOFMEMORY;

  z3D_SCREEN_VERTEX* pVertex = vertices;
  POINT* pt = apPoints;
  for( UINT i=0; i < nNumPoints; i++ )
  {
      pVertex->x = FLeft + (float) pt->x;
      pVertex->y = FTop + (float) pt->y;
      pVertex->z = 0.5f;
      pVertex->h = 1.0f;
      pVertex->color = color;
      pVertex->tu = 0.0f;
      pVertex->tv = 0.0f;

      pVertex++;
      pt++;
  }

  IDirect3DDevice9* pd3dDevice = Manager.GetD3DDevice();

  // Since we're doing our own drawing here we need to flush the sprites
  Manager.FSprite->Flush();
  IDirect3DVertexDeclaration9 *pDecl = NULL;
  pd3dDevice->GetVertexDeclaration( &pDecl );  // Preserve the sprite's current vertex decl
  pd3dDevice->SetFVF( z3D_SCREEN_VERTEX::FVF );

  pd3dDevice->SetTextureStageState( 0, D3DTSS_COLOROP, D3DTOP_SELECTARG2 );
  pd3dDevice->SetTextureStageState( 0, D3DTSS_ALPHAOP, D3DTOP_SELECTARG2 );

  pd3dDevice->DrawPrimitiveUP( D3DPT_LINESTRIP, nNumPoints - 1, vertices, sizeof(z3D_SCREEN_VERTEX) );

  pd3dDevice->SetTextureStageState( 0, D3DTSS_COLOROP, D3DTOP_MODULATE );
  pd3dDevice->SetTextureStageState( 0, D3DTSS_ALPHAOP, D3DTOP_MODULATE );

  // Restore the vertex decl
  pd3dDevice->SetVertexDeclaration( pDecl );
  pDecl->Release();

  SAFE_DELETE_ARRAY( vertices ); *)
  Result:= S_OK;
end;

function Tz3DDialog.DrawSprite(pDisplay: Iz3DDisplay; const prcDest: TRect): HRESULT;
var
  rcTexture, rcScreen: TRect;
  pTextureNode: Pz3DTextureNode;
  fScaleX, fScaleY: Single;
  matTransform: TD3DXMatrixA16;
  vPos: TD3DXVector3;
begin
  Result:= S_OK;

  // No need to draw fully transparent layers
  if (pDisplay.TextureColor.Current.a = 0) then Exit;
  // No need to draw ZERO square sprite
  if (RectWidth(prcDest) = 0) or (RectHeight(prcDest) = 0) then Exit;

  rcTexture := pDisplay.TextureRect;

  rcScreen := prcDest;
  OffsetRect(rcScreen, FLeft, FTop);

  // If caption is enabled, offset the Y position by its height.
//  if FCaption then OffsetRect(rcScreen, 0, Manager.Desktop.ThemeSettings.CaptionHeight);

  pTextureNode := GetTexture(pDisplay.GetTexture);
  if (pTextureNode = nil) then
  begin
    Result:= E_FAIL;
    Exit;
  end;

  fScaleX := RectWidth(rcScreen) / RectWidth(rcTexture);
  fScaleY := RectHeight(rcScreen) / RectHeight(rcTexture);

  D3DXMatrixScaling(matTransform, fScaleX, fScaleY, 1.0);

  Manager.Sprite.SetTransform(matTransform);

  vPos:= D3DXVector3(rcScreen.left, rcScreen.top, 0.0);

  vPos.x := vPos.x / fScaleX;
  vPos.y := vPos.y / fScaleY;

  Result:= Manager.Sprite.Draw(pTextureNode.Texture, @rcTexture, nil, @vPos, D3DXColorToDWord(pDisplay.TextureColor.Current));
end;

function Tz3DDialog.CalcTextRect(strText: PWideChar; pDisplay: Iz3DDisplay; prcDest: PRect; nCount: Integer = -1): HRESULT;
var
  pFontNode: Pz3DFontNode;
  dwTextFormat: DWORD;
begin
  pFontNode := GetFont(pDisplay.Font);
  if (pFontNode = nil) then
  begin
    Result:= E_FAIL;
    Exit;
  end;
  
  dwTextFormat := pDisplay.TextFormat or DT_CALCRECT;
  // Since we are only computing the rectangle, we don't need a sprite.
  Result := pFontNode.Font.DrawTextW(nil, strText, nCount, prcDest, dwTextFormat, D3DXColorToDWord(pDisplay.FontColor.Current));
  if FAILED(Result) then Exit;

  Result:= S_OK;
end;

function Tz3DDialog.DrawText(strText: PWideChar; pDisplay: Iz3DDisplay; const rcDest: TRect; bShadow: Boolean = False; nCount: Integer = -1): HRESULT;
var
  rcScreen, rcShadow: TRect;
  matTransform: TD3DXMatrixA16;
  pFontNode: Pz3DFontNode;
  FShadowValue: Byte;
begin
  // No need to draw fully transparent layers
  if (pDisplay.FontColor.Current.a = 0) then
  begin
    Result:= S_OK;
    Exit;
  end;

  rcScreen := rcDest;
  OffsetRect(rcScreen, FLeft, FTop);

  // If caption is enabled, offset the Y position by its height.
//  if FCaption then OffsetRect(rcScreen, 0, Manager.Desktop.ThemeSettings.CaptionHeight);

  //debug
  //DrawRect(rcScreen, D3DCOLOR_ARGB(100, 255, 0, 0));

  D3DXMatrixIdentity(matTransform);
  Manager.Sprite.SetTransform(matTransform);

  pFontNode := GetFont(pDisplay.Font);

{  if ((pDisplay.FontColor.Current.r+pDisplay.FontColor.Current.g+pDisplay.FontColor.Current.b) / 3) > 0.5 then}
  FShadowValue:= 0{ else FShadowValue:= 255};
  if (bShadow) then
  begin
    rcShadow := rcScreen;
    OffsetRect(rcShadow, 1, 1);
    Result := pFontNode.Font.DrawTextW(Manager.Sprite, strText, nCount, @rcShadow, pDisplay.TextFormat, D3DCOLOR_ARGB(Trunc(pDisplay.FontColor.Current.a * 255), FShadowValue, FShadowValue, FShadowValue));
    if FAILED(Result) then Exit;
    rcShadow := rcScreen;
    OffsetRect(rcShadow, -1, -1);
    Result := pFontNode.Font.DrawTextW(Manager.Sprite, strText, nCount, @rcShadow, pDisplay.TextFormat, D3DCOLOR_ARGB(Trunc(pDisplay.FontColor.Current.a * 255), FShadowValue, FShadowValue, FShadowValue));
    if FAILED(Result) then Exit;
    rcShadow := rcScreen;
    OffsetRect(rcShadow, -1, 1);
    Result := pFontNode.Font.DrawTextW(Manager.Sprite, strText, nCount, @rcShadow, pDisplay.TextFormat, D3DCOLOR_ARGB(Trunc(pDisplay.FontColor.Current.a * 255), FShadowValue, FShadowValue, FShadowValue));
    if FAILED(Result) then Exit;
    rcShadow := rcScreen;
    OffsetRect(rcShadow, 1, -1);
    Result := pFontNode.Font.DrawTextW(Manager.Sprite, strText, nCount, @rcShadow, pDisplay.TextFormat, D3DCOLOR_ARGB(Trunc(pDisplay.FontColor.Current.a * 255), FShadowValue, FShadowValue, FShadowValue));
    if FAILED(Result) then Exit;
  end;

  Result := pFontNode.Font.DrawTextW(Manager.Sprite, strText, nCount, @rcScreen, pDisplay.TextFormat, D3DXColorToDWord(pDisplay.FontColor.Current));
  if FAILED(Result) then Exit;

  Result:= S_OK;
end;

procedure Tz3DDialog.SetBackgroundColors(colorAllCorners: TD3DColor);
begin
  SetBackgroundColors(colorAllCorners, colorAllCorners, colorAllCorners, colorAllCorners);
end;

procedure Tz3DDialog.SetBackgroundColors(colorTopLeft, colorTopRight, colorBottomLeft, colorBottomRight: TD3DColor);
begin
  m_colorTopLeft := colorTopLeft;
  m_colorTopRight := colorTopRight;
  m_colorBottomLeft := colorBottomLeft;
  m_colorBottomRight := colorBottomRight;
end;

procedure Tz3DDialog.SetCaption(const pwszText: PWideChar);
begin
  StringCchCopy(FCaptionStr, SizeOf(FCaptionStr) div SizeOf(FCaptionStr[0]), pwszText);
end;

procedure Tz3DDialog.GetLocation(out Pt: TPoint);
begin
  Pt.x := FLeft; Pt.y := FTop;
end;

procedure Tz3DDialog.SetLocation(x, y: Integer);
begin
  FLeft := x; FTop := y;
end;

procedure Tz3DDialog.SetSize(width, height: Integer);
begin
  FWidth := width; FHeight := height;
end;

procedure Tz3DDialog.SetNextDialog(pNextDialog: Iz3DDialog);
begin
  if (pNextDialog = nil) then pNextDialog := Self;

  FNextDialog := pNextDialog;
  if Assigned(pNextDialog) then FNextDialog.SetPrevDialog(Self);
end;

procedure Tz3DDialog.SetRefreshTime(fTime: Single);
begin
  s_fTimeRefresh := fTime;
end;

procedure Tz3DDialog.ClearFocus;
begin
  if (s_pControlFocus <> nil) then
  begin
    s_pControlFocus.OnFocusOut;
    s_pControlFocus := nil;
  end;

  ReleaseCapture;
end;

procedure Tz3DDialog.FocusDefaultControl;
var
  i: Integer;
  pControl: Iz3DControl;
begin
  // Check for default control in this dialog
  for i:= 0 to ControlCount - 1 do
  begin
    pControl := m_Controls[i] as Iz3DControl;
    if (pControl.Default) then
    begin
      // Remove focus from the current control
      ClearFocus;

      // Give focus to the default control
      s_pControlFocus := pControl;
      s_pControlFocus.OnFocusIn;
      Exit;
    end;
  end;
end;

function Tz3DDialog.OnCycleFocus(bForward: Boolean): Boolean;
var
  pControl: Iz3DControl;
  pDialog: Iz3DDialog;      // pDialog and pLastDialog are used to track wrapping of
  pLastDialog: Iz3DDialog;  // focus from first control to last or vice versa.

  i: Integer;
  d: Integer;
  nLastDialogIndex: Integer;
  nDialogIndex: Integer;
begin
  Result:= True;

  pControl := nil;
  pDialog := nil;
  pLastDialog := nil;

  if (s_pControlFocus = nil) then
  begin
    // If s_pControlFocus is NULL, we focus the first control of first dialog in
    // the case that bForward is true, and focus the last control of last dialog when
    // bForward is false.
    //
    if bForward then
    begin
      // Search for the first control from the start of the dialog
      // array.
      for d := 0 to FManager.DialogCount - 1 do
      begin
        pDialog := FManager.Dialogs[d];
        pLastDialog := FManager.Dialogs[d];
        if Assigned(pDialog) and (pDialog.ControlCount > 0) then
        begin
          pControl := pDialog.ControlIndex[0];
          Break;
        end;
      end;

      if not (Assigned(pDialog) and Assigned(pControl)) then
      begin
        // No dialog has been registered yet or no controls have been
        // added to the dialogs. Cannot proceed.
        Exit;
      end;
    end
    else
    begin
      // Search for the first control from the end of the dialog
      // array.
      for d := FManager.DialogCount - 1 downto 0 do
      begin
        pDialog := FManager.Dialogs[d];
        pLastDialog := FManager.Dialogs[d];
        if Assigned(pDialog) and (ControlCount > 0) then
        begin
          pControl := pDialog.ControlIndex[pDialog.ControlCount - 1];
          Break;
        end;
      end;

      if not (Assigned(pDialog) and Assigned(pControl)) then
      begin
        // No dialog has been registered yet or no controls have been
        // added to the dialogs. Cannot proceed.
        Exit;
      end;
    end;
  end
  else
  if (s_pControlFocus.Dialog <> Self as Iz3DDialog) then
  begin
    // If a control belonging to another dialog has focus, let that other
    // dialog handle this event by returning false.
    //
    Result:= False;
    Exit;
  end
  else
  begin
    // Focused control belongs to this dialog. Cycle to the
    // next/previous control.
    pLastDialog := s_pControlFocus.Dialog;
    if bForward
    then pControl := GetNextControl(s_pControlFocus)
    else pControl := GetPrevControl(s_pControlFocus);
    pDialog := pControl.Dialog;
  end;

  for i := 0 to $ffff - 1 do
  begin
    // If we just wrapped from last control to first or vice versa,
    // set the focused control to NULL. This state, where no control
    // has focus, allows the camera to work.

    nLastDialogIndex := FManager.IndexOf(pLastDialog);
    nDialogIndex := FManager.IndexOf(pDialog);

    if (not bForward and (nLastDialogIndex < nDialogIndex)) or
       (bForward and (nDialogIndex < nLastDialogIndex)) then
    begin
      if Assigned(s_pControlFocus) then s_pControlFocus.OnFocusOut;
      s_pControlFocus := nil;
      Exit;
    end;

    // If we've gone in a full circle then focus doesn't change
    if (pControl = s_pControlFocus) then Exit;

    // If the dialog accepts keybord input and the control can have focus then
    // move focus
    if (pControl.Dialog.IsKeyboardInputEnabled and pControl.CanHaveFocus) then
    begin
      if Assigned(s_pControlFocus) then s_pControlFocus.OnFocusOut;
      s_pControlFocus := pControl;
      s_pControlFocus.OnFocusIn;
      Exit;
    end;

    pLastDialog := pDialog;
    if bForward
    then pControl := GetNextControl(pControl)
    else pControl := GetPrevControl(pControl);
    pDialog := pControl.Dialog;
  end;

  // If we reached this point, the chain of dialogs didn't form a complete loop
  DXTRACE_ERR('Cz3DDialog: Multiple dialogs are improperly chained together', E_FAIL);
  Result:= False;
end;

function Tz3DGUIController.CreateFont(index: LongWord): HRESULT; // ( UINT iFont )
var
  pFontNode: Pz3DFontNode;
begin
  pFontNode := FFontCache[index];

  SafeRelease(pFontNode.Font);

  Result:= D3DXCreateFontW(z3DCore_GetD3DDevice, pFontNode.Height, 0, pFontNode.Weight, 1, False, DEFAULT_CHARSET,
                           OUT_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE,
                           pFontNode.Name, pFontNode.Font);
  if z3DFailedTrace(Result) then Exit;

  Result:= S_OK;
end;

procedure Tz3DDialog.InitDefaultDisplays;
var
  Display: Iz3DDisplay;
  rcTexture: TRect;
  nScrollBarStartX: Integer;
  nScrollBarStartY: Integer;
begin

  m_colorTopLeft := Manager.Desktop.ThemeSettings.DialogColorTL.D3DColor;
  m_colorTopRight := Manager.Desktop.ThemeSettings.DialogColorTR.D3DColor;
  m_colorBottomLeft := Manager.Desktop.ThemeSettings.DialogColorBL.D3DColor;
  m_colorBottomRight := Manager.Desktop.ThemeSettings.DialogColorBR.D3DColor;
  m_fTimeLastRefresh := 0;

  SetFont(0, Manager.Desktop.ThemeSettings.DefaultFont.Name, z3DFontHeight(Manager.Desktop.ThemeSettings.DefaultFont.Size), Manager.Desktop.ThemeSettings.DefaultFont.Format);
  SetFont(127, Manager.Desktop.ThemeSettings.DefaultFont.Name, z3DFontHeight(Manager.Desktop.ThemeSettings.DefaultFont.Size), Manager.Desktop.ThemeSettings.DefaultFont.Format or FW_BOLD);
  Display:= Tz3DDisplay.Create;

  //-------------------------------------
  // Display for the caption
  //-------------------------------------
  SetRect(rcTexture, 17, 269, 241, 287);
  m_CapDisplay.SetTexture(0, @rcTexture);
  m_CapDisplay.TextureColor.States[ z3dcsNormal ] := D3DCOLOR_ARGB(255, 255, 255, 255);
  m_CapDisplay.FontColor.States[ z3dcsNormal ] := D3DCOLOR_ARGB(255, 255, 255, 255);
  m_CapDisplay.SetFontParams(127, D3DCOLOR_ARGB(255, 255, 255, 255), DT_LEFT or DT_VCENTER);
  // Pre-blend as we don't need to transition the state
  m_CapDisplay.TextureColor.Blend(z3dcsNormal, -1);
  m_CapDisplay.FontColor.Blend(z3dcsNormal, -1);

  //-------------------------------------
  // Tz3DLabel
  //-------------------------------------
  Display.SetFontParams(0, z3DD3DColor(Manager.Desktop.ThemeSettings.DefaultFont.Color), Manager.Desktop.ThemeSettings.DefaultFont.Format);
  Display.FontColor.States[ z3dcsDisabled ] := D3DCOLOR_ARGB(200, 200, 200, 200);

  // Assign the Display
  SetDefaultDisplay(z3dctLabel, 0, Display);


  //-------------------------------------
  // Tz3DButton - Button
  //-------------------------------------
  SetRect(rcTexture, 0, 0, 136, 54);
  Display.SetTexture(0, @rcTexture);
  Display.SetFontParams(0, z3DD3DColor(Manager.Desktop.ThemeSettings.DefaultFont.Color), Manager.Desktop.ThemeSettings.DefaultFont.Format or DT_CENTER);
  Display.TextureColor.States[ z3dcsNormal ] := D3DCOLOR_ARGB(150, 255, 255, 255);
  Display.TextureColor.States[ z3dcsPressed ] := D3DCOLOR_ARGB(200, 255, 255, 255);
  Display.FontColor.States[ z3dcsMouseOver ] := D3DCOLOR_ARGB(255, 0, 0, 0);
    
  // Assign the Display
  SetDefaultDisplay(z3dctButton, 0, Display);
    

  //-------------------------------------
  // Tz3DButton - Fill layer
  //-------------------------------------
  SetRect(rcTexture, 136, 0, 252, 54);
  Display.SetTexture(0, @rcTexture, D3DCOLOR_ARGB(0, 255, 255, 255));
  Display.TextureColor.States[ z3dcsMouseOver ] := D3DCOLOR_ARGB(160, 255, 255, 255);
  Display.TextureColor.States[ z3dcsPressed ] := D3DCOLOR_ARGB(60, 0, 0, 0);
  Display.TextureColor.States[ z3dcsFocus ] := D3DCOLOR_ARGB(30, 255, 255, 255);
    
    
  // Assign the Display
  SetDefaultDisplay(z3dctButton, 1, Display);



  //-------------------------------------
  // Tz3DCheckBox - Box
  //-------------------------------------
  SetRect(rcTexture, 0, 54, 27, 81);
  Display.SetTexture(0, @rcTexture);
  Display.SetFontParams(0, z3DD3DColor(Manager.Desktop.ThemeSettings.CheckBoxFont.Color), Manager.Desktop.ThemeSettings.CheckBoxFont.Format);
  Display.FontColor.States[ z3dcsDisabled ] := D3DCOLOR_ARGB( 200, 200, 200, 200);
  Display.TextureColor.States[ z3dcsNormal ] := D3DCOLOR_ARGB(150, 255, 255, 255);
  Display.TextureColor.States[ z3dcsFocus ] := D3DCOLOR_ARGB(200, 255, 255, 255);
  Display.TextureColor.States[ z3dcsPressed ] := D3DCOLOR_ARGB(255, 255, 255, 255);

  // Assign the Display
  SetDefaultDisplay(z3dctCheckBox, 0, Display);


  //-------------------------------------
  // Tz3DCheckBox - Check
  //-------------------------------------
  SetRect(rcTexture, 27, 54, 54, 81);
  Display.SetTexture(0, @rcTexture);
    
  // Assign the Display
  SetDefaultDisplay(z3dctCheckBox, 1, Display );


  //-------------------------------------
  // Tz3DRadioButton - Box
  //-------------------------------------
  SetRect(rcTexture, 54, 54, 81, 81 );
  Display.SetTexture(0, @rcTexture);
  Display.SetFontParams(0, z3DD3DColor(Manager.Desktop.ThemeSettings.RadioButtonFont.Color), Manager.Desktop.ThemeSettings.RadioButtonFont.Format);
  Display.FontColor.States[ z3dcsDisabled ] := D3DCOLOR_ARGB( 200, 200, 200, 200);
  Display.TextureColor.States[ z3dcsNormal ] := D3DCOLOR_ARGB(150, 255, 255, 255);
  Display.TextureColor.States[ z3dcsFocus ] := D3DCOLOR_ARGB(200, 255, 255, 255);
  Display.TextureColor.States[ z3dcsPressed ] := D3DCOLOR_ARGB(255, 255, 255, 255);

  // Assign the Display
  SetDefaultDisplay(z3dctRadioButton, 0, Display);


  //-------------------------------------
  // Tz3DRadioButton - Check
  //-------------------------------------
  SetRect(rcTexture, 81, 54, 108, 81);
  Display.SetTexture(0, @rcTexture);

  // Assign the Display
  SetDefaultDisplay(z3dctRadioButton, 1, Display);


  //-------------------------------------
  // Tz3DComboBox - Main
  //-------------------------------------
  SetRect(rcTexture, 7, 81, 247, 123);
  Display.SetTexture(0, @rcTexture);
  Display.SetFontParams(0, z3DD3DColor(Manager.Desktop.ThemeSettings.DefaultFont.Color), Manager.Desktop.ThemeSettings.DefaultFont.Format);
  Display.TextureColor.States[ z3dcsNormal ] := D3DCOLOR_ARGB(150, 200, 200, 200);
  Display.TextureColor.States[ z3dcsFocus ] := D3DCOLOR_ARGB(170, 230, 230, 230);
  Display.TextureColor.States[ z3dcsDisabled ] := D3DCOLOR_ARGB(70, 200, 200, 200);
  Display.FontColor.States[ z3dcsMouseOver ] := D3DCOLOR_ARGB(255, 0, 0, 0);
  Display.FontColor.States[ z3dcsPressed ] := D3DCOLOR_ARGB(255, 0, 0, 0);
  Display.FontColor.States[ z3dcsDisabled ] := D3DCOLOR_ARGB(200, 200, 200, 200);

  // Assign the Display
  SetDefaultDisplay(z3dctComboBox, 0, Display);


  //-------------------------------------
  // Tz3DComboBox - Button
  //-------------------------------------
  SetRect(rcTexture, 98, 189, 151, 238);
  Display.SetTexture(0, @rcTexture);
  Display.TextureColor.States[ z3dcsNormal ] := D3DCOLOR_ARGB(150, 255, 255, 255);
  Display.TextureColor.States[ z3dcsPressed ] := D3DCOLOR_ARGB(255, 150, 150, 150);
  Display.TextureColor.States[ z3dcsFocus ] := D3DCOLOR_ARGB(200, 255, 255, 255);
  Display.TextureColor.States[ z3dcsDisabled ] := D3DCOLOR_ARGB(70, 255, 255, 255);

  // Assign the Display
  SetDefaultDisplay(z3dctComboBox, 1, Display);


  //-------------------------------------
  // Tz3DComboBox - Dropdown
  //-------------------------------------
  SetRect(rcTexture, 13, 123, 241, 160);
  Display.SetTexture(0, @rcTexture);
  Display.SetFontParams(0, D3DCOLOR_ARGB(255, 0, 0, 0), DT_LEFT or DT_TOP);

  // Assign the Display
  SetDefaultDisplay(z3dctComboBox, 2, Display);


  //-------------------------------------
  // Tz3DComboBox - Selection
  //-------------------------------------
  SetRect(rcTexture, 12, 163, 239, 183);
  Display.SetTexture(0, @rcTexture);
  Display.SetFontParams(0, D3DCOLOR_ARGB(255, 255, 255, 255), DT_LEFT or DT_TOP);

  // Assign the Display
  SetDefaultDisplay(z3dctComboBox, 3, Display);


  //-------------------------------------
  // Tz3DTrackBar - Track
  //-------------------------------------
  SetRect(rcTexture, 1, 187, 93, 228);
  Display.SetTexture(0, @rcTexture);
  Display.TextureColor.States[ z3dcsNormal ] := D3DCOLOR_ARGB(150, 255, 255, 255);
  Display.TextureColor.States[ z3dcsFocus ] := D3DCOLOR_ARGB(200, 255, 255, 255);
  Display.TextureColor.States[ z3dcsDisabled ] := D3DCOLOR_ARGB(70, 255, 255, 255);

  // Assign the Display
  SetDefaultDisplay(z3dctTrackBar, 0, Display);

  //-------------------------------------
  // Tz3DTrackBar - Button
  //-------------------------------------
  SetRect(rcTexture, 151, 193, 192, 234);
  Display.SetTexture(0, @rcTexture);

  // Assign the Display
  SetDefaultDisplay(z3dctTrackBar, 1, Display);

  //-------------------------------------
  // Tz3DScrollBar - Track
  //-------------------------------------
  nScrollBarStartX := 196;
  nScrollBarStartY := 191;
  SetRect(rcTexture, nScrollBarStartX + 0, nScrollBarStartY + 21, nScrollBarStartX + 22, nScrollBarStartY + 32);
  Display.SetTexture(0, @rcTexture);
  Display.TextureColor.States[ z3dcsDisabled ] := D3DCOLOR_ARGB(255, 200, 200, 200);

  // Assign the Display
  SetDefaultDisplay(z3dctScrollBar, 0, Display);

  //-------------------------------------
  // Tz3DScrollBar - Up Arrow
  //-------------------------------------
  SetRect(rcTexture, nScrollBarStartX + 0, nScrollBarStartY + 1, nScrollBarStartX + 22, nScrollBarStartY + 21);
  Display.SetTexture(0, @rcTexture);
  Display.TextureColor.States[ z3dcsDisabled ] := D3DCOLOR_ARGB(255, 200, 200, 200);

  // Assign the Display
  SetDefaultDisplay(z3dctScrollBar, 1, Display);


  //-------------------------------------
  // Tz3DScrollBar - Down Arrow
  //-------------------------------------
  SetRect(rcTexture, nScrollBarStartX + 0, nScrollBarStartY + 32, nScrollBarStartX + 22, nScrollBarStartY + 53);
  Display.SetTexture(0, @rcTexture);
  Display.TextureColor.States[ z3dcsDisabled ] := D3DCOLOR_ARGB(255, 200, 200, 200);

  // Assign the Display
  SetDefaultDisplay(z3dctScrollBar, 2, Display);

  //-------------------------------------
  // Tz3DScrollBar - Button
  //-------------------------------------
  SetRect(rcTexture, 220, 192, 238, 234);
  Display.SetTexture(0, @rcTexture);

  // Assign the Display
  SetDefaultDisplay(z3dctScrollBar, 3, Display);


  //-------------------------------------
  // Tz3DProgressBar - Background
  //-------------------------------------

  SetRect(rcTexture, 8, 82, 248, 121);
  Display.SetTexture(0, @rcTexture);

  // Assign the Display
  SetDefaultDisplay(z3dctProgressBar, 0, Display);

  //-------------------------------------
  // Tz3DProgressBar - Progress
  //-------------------------------------

  SetRect(rcTexture, 12, 163, 239, 183);
  Display.SetTexture(0, @rcTexture);
  Display.SetFontParams(0, D3DCOLOR_ARGB(255, 255, 255, 255), DT_LEFT or DT_TOP);

  // Assign the Display
  SetDefaultDisplay(z3dctProgressBar, 1, Display);


  //-------------------------------------
  // Tz3DEdit
  //-------------------------------------
  // Display assignment:
  //   0 - text area
  //   1 - top left border
  //   2 - top border
  //   3 - top right border
  //   4 - left border
  //   5 - right border
  //   6 - lower left border
  //   7 - lower border
  //   8 - lower right border

  Display.SetFontParams(0, D3DCOLOR_ARGB(255, 0, 0, 0 ), DT_LEFT or DT_TOP);

  // Assign the style
  SetRect(rcTexture, 14, 90, 241, 113);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctEdit, 0, Display);
  SetRect(rcTexture, 8, 82, 14, 90);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctEdit, 1, Display);
  SetRect(rcTexture, 14, 82, 241, 90);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctEdit, 2, Display);
  SetRect(rcTexture, 241, 82, 246, 90);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctEdit, 3, Display);
  SetRect(rcTexture, 8, 90, 14, 113);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctEdit, 4, Display);
  SetRect(rcTexture, 241, 90, 246, 113);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctEdit, 5, Display);
  SetRect(rcTexture, 8, 113, 14, 121);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctEdit, 6, Display);
  SetRect(rcTexture, 14, 113, 241, 121);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctEdit, 7, Display);
  SetRect(rcTexture, 241, 113, 246, 121);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctEdit, 8, Display);


  //-------------------------------------
  // Tz3DIMEEditBox
  //-------------------------------------

  Display.SetFontParams(0, D3DCOLOR_ARGB(255, 0, 0, 0), DT_LEFT or DT_TOP);

  // Assign the style
  SetRect(rcTexture, 14, 90, 241, 113);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctIMEEdit, 0, Display);
  SetRect(rcTexture, 8, 82, 14, 90);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctIMEEdit, 1, Display);
  SetRect(rcTexture, 14, 82, 241, 90);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctIMEEdit, 2, Display);
  SetRect(rcTexture, 241, 82, 246, 90);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctIMEEdit, 3, Display);
  SetRect(rcTexture, 8, 90, 14, 113);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctIMEEdit, 4, Display);
  SetRect(rcTexture, 241, 90, 246, 113);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctIMEEdit, 5, Display);
  SetRect(rcTexture, 8, 113, 14, 121);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctIMEEdit, 6, Display);
  SetRect(rcTexture, 14, 113, 241, 121);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctIMEEdit, 7, Display);
  SetRect(rcTexture, 241, 113, 246, 121);
  Display.SetTexture(0, @rcTexture);
  SetDefaultDisplay(z3dctIMEEdit, 8, Display);
  // Display 9 for IME text, and indicator button
  SetRect(rcTexture, 0, 0, 136, 54);
  Display.SetTexture(0, @rcTexture);
  Display.SetFontParams(0, D3DCOLOR_ARGB(255, 0, 0, 0), DT_CENTER or DT_VCENTER );
  SetDefaultDisplay(z3dctIMEEdit, 9, Display);

  //-------------------------------------
  // Tz3DListBox - Main
  //-------------------------------------

  SetRect(rcTexture, 13, 123, 241, 160);
  Display.SetTexture(0, @rcTexture);
  Display.SetFontParams(0, D3DCOLOR_ARGB(255, 0, 0, 0), DT_LEFT or DT_TOP);

  // Assign the Display
  SetDefaultDisplay(z3dctListBox, 0, Display);

  //-------------------------------------
  // Tz3DListBox - Selection
  //-------------------------------------

  SetRect(rcTexture, 16, 166, 240, 183);
  Display.SetTexture(0, @rcTexture);
  Display.SetFontParams(0, D3DCOLOR_ARGB(255, 255, 255, 255), DT_LEFT or DT_TOP);

  // Assign the Display
  SetDefaultDisplay(z3dctListBox, 1, Display);
end;

function Tz3DGUIController.GetFontsCount: Integer;
begin
  Result:= Length(FFontCache);
end;

function Tz3DGUIController.GetTextureNodeCount: Integer;
begin
  Result:= Length(FTextureCache);
end;

{ Tz3DControl }

constructor Tz3DControl.Create(const pDialog: Iz3DDialog = nil);
begin
  inherited Create;

  m_Type := z3dctButton;
  FDialog := pDialog;
  m_ID := 0;
  m_Index := 0;
  FUserData := nil;

  FEnabled := True;
  FVisible := True;
  FMouseOver := False;
  FHasFocus := False;
  FIsDefault := False;

  FDialog := nil;
  SetLength(m_Displays, 0);

  FLeft := 0;
  FTop := 0;
  FWidth := 0;
  FHeight := 0;

  ZeroMemory(@FBoundingBox, SizeOf(FBoundingBox));
end;

destructor Tz3DControl.Destroy;
begin
  inherited;
end;

function Tz3DControl.OnInit: HRESULT;
begin
  Result:= S_OK;
end;

function Tz3DControl.GetHotkey: LongWord;
begin
  Result:= FHotkey;
end;

function Tz3DControl.GetID: Integer;
begin
  Result:= m_ID;
end;

function Tz3DControl.GetIndex: LongWord;
begin
  Result:= m_Index;
end;

procedure Tz3DControl.SetIndex(const Value: LongWord);
begin
  m_Index:= Value;
end;

function Tz3DControl.GetDialog: Iz3DDialog;
begin
  Result:= FDialog;
end;

function Tz3DControl.GetIsDefault: Boolean;
begin
  Result:= FIsDefault;
end;

function Tz3DControl.GetType: Tz3DControlType;
begin
  Result:= m_Type;
end;

function Tz3DControl.GetVisible: Boolean;
begin
  Result:= FVisible;
end;

procedure Tz3DControl.SetHotkey(const Value: LongWord);
begin
  FHotKey:= Value;
end;

procedure Tz3DControl.SetID(const Value: Integer);
begin
  m_ID:= value;
end;

procedure Tz3DControl.SetIsDefault(const Value: Boolean);
begin
  FIsDefault:= Value;
end;

function Tz3DControl.GetUserData: Pointer;
begin
  Result:= FUserData;
end;

procedure Tz3DControl.SetUserData(const Value: Pointer);
begin
  FUserData:= value;
end;

function Tz3DControl.MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  Result:= False;
end;

function Tz3DControl.HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  Result:= False;
end;

function Tz3DControl.HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  Result:= False;
end;

function Tz3DControl.CanHaveFocus: Boolean;
begin
  Result:= False;
end;

procedure Tz3DControl.OnFocusIn;
begin
  FHasFocus := True;
end;

procedure Tz3DControl.OnFocusOut;
begin
  FHasFocus := False;
end;

procedure Tz3DControl.OnMouseEnter;
begin
  FMouseOver := True;
end;

procedure Tz3DControl.OnMouseLeave;
begin
  FMouseOver := False;
end;

function Tz3DControl.ContainsPoint(pt: TPoint): LongBool;
begin
  Result:= PtInRect(FBoundingBox, pt);
end;

procedure Tz3DControl.SetLocation(x, y: Integer);
begin
  FLeft := x; FTop := y;
  UpdateRects;
end;

procedure Tz3DControl.SetSize(width, height: Integer);
begin
  FWidth := width; FHeight := height;
  UpdateRects;
end;

procedure Tz3DControl.SetTextColor(Color: TD3DColor);
var
  pDisplay: Iz3DDisplay;
begin
  pDisplay := m_Displays[0];

  if (pDisplay <> nil) then
    pDisplay.FontColor.States[z3dcsNormal] := Color;
end;

procedure Tz3DControl.SetDisplay(iDisplay: LongWord; const pDisplay: Iz3DDisplay);
var i: Integer;
    pCurDisplay: Iz3DDisplay;
begin
  // Make certain the array is this large
  for i:= Length(m_Displays) to iDisplay do
  begin
    SetLength(m_Displays, i+1);
    m_Displays[i]:= Tz3DDisplay.Create;
  end;
  // Update the data
  pCurDisplay := m_Displays[iDisplay];
  pCurDisplay.Assign(pDisplay);
end;

procedure Tz3DControl.Refresh;
var
  i: Integer;
begin
  FMouseOver := False;
  FHasFocus := False;

  for i:= 0 to Length(m_Displays) - 1 do
    m_Displays[i].Refresh;
end;

procedure Tz3DControl.UpdateRects;
begin
  SetRect(FBoundingBox, FLeft, FTop, FLeft + FWidth, FTop + FHeight);
end;

procedure Tz3DControl.SetEnabled(bEnabled: Boolean);
begin FEnabled := bEnabled; end;

function Tz3DControl.GetEnabled: Boolean;
begin Result:= FEnabled; end;

procedure Tz3DControl.SetVisible(bVisible: Boolean);
begin FVisible := bVisible; end;

function Tz3DControl.GetDisplay(iDisplay: LongWord): Iz3DDisplay;
begin
  Result:= m_Displays[iDisplay];
end;

function Tz3DControl.GetHeight: Integer;
begin
  Result:= FHeight;
end;

function Tz3DControl.GetLeft: Integer;
begin
  Result:= FLeft;
end;

function Tz3DControl.GetTop: Integer;
begin
  Result:= FTop;
end;

function Tz3DControl.GetWidth: Integer;
begin
  Result:= FWidth;
end;

procedure Tz3DControl.SetHeight(const Value: Integer);
begin
  FHeight:= Value;
  UpdateRects;
end;

procedure Tz3DControl.SetLeft(const Value: Integer);
begin
  FLeft:= Value;
  UpdateRects;
end;

procedure Tz3DControl.SetTop(const Value: Integer);
begin
  FTop:= Value;
  UpdateRects;
end;

procedure Tz3DControl.SetWidth(const Value: Integer);
begin
  FWidth:= Value;
  UpdateRects;
end;

procedure Tz3DControl.OnHotkey;
begin
  // Abstract method //
end;

procedure Tz3DControl.Render;
begin
  // Abstract method //
end;

{ Tz3DLabel }

constructor Tz3DLabel.Create(const pDialog: Iz3DDialog = nil);
begin
  inherited;
  m_Type := z3dctLabel;
  FDialog := pDialog;
  ZeroMemory(@m_strText, SizeOf(m_strText));
end;

procedure Tz3DLabel.Render;
var
  iState: Tz3DControlState;
  pDisplay: Iz3DDisplay;
begin
  if not Visible then Exit;

  iState := z3dcsNormal;
  if not Enabled then iState := z3dcsDisabled;

  pDisplay := m_Displays[0];

  pDisplay.FontColor.Blend(iState);

  FDialog.DrawText(m_strText, pDisplay, FBoundingBox, Dialog.Manager.Desktop.ThemeSettings.DefaultFont.Shadow);
end;

function Tz3DLabel.ContainsPoint(pt: TPoint): LongBool;
begin
  Result:= False;
end;

function Tz3DLabel.GetTextCopy(strDest: PWideChar; bufferCount: LongWord): HRESULT;
begin
  // Validate incoming parameters
  if (strDest = nil) or (bufferCount = 0) then
  begin
    Result:= E_INVALIDARG;
    Exit;
  end;

  // Copy the window text
  StringCchCopy(strDest, bufferCount, m_strText);

  Result:= S_OK;
end;

function Tz3DLabel.GetText: PWideChar;
begin
  Result:= m_strText;
end;

procedure Tz3DLabel.SetText(strText: PWideChar);
begin
  if (strText = nil)
  then m_strText[0] := #0
  else StringCchCopy(m_strText, MAX_PATH, strText);
end;

{ Tz3DButton }

constructor Tz3DButton.Create(const pDialog: Iz3DDialog = nil);
begin
  inherited;
  FEnableBackground:= True;
  m_Type := z3dctButton;
  FDialog := pDialog;
  FPressed := False;
  FHotkey := 0;
end;

function Tz3DButton.GetEnableBackground: Boolean;
begin
  Result:= FEnableBackground;
end;

procedure Tz3DButton.SetEnableBackground(const Value: Boolean);
begin
  FEnableBackground:= Value;
end;

function Tz3DButton.HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  if not Enabled or not Visible then
  begin
    Result:= False;
    Exit;
  end;

  Result:= True;

  case uMsg of
    WM_KEYDOWN:
    begin
      case wParam of
        VK_SPACE:
        begin
          FPressed := True;
          Exit;
        end;
      end;
    end;

    WM_KEYUP:
    begin
      case wParam of
        VK_SPACE:
        begin
          if (FPressed) then
          begin
            FPressed := False;
            FDialog.SendEvent(z3dceButtonClick, True, Self);
          end;
          Exit;
        end;
      end;
    end;

  end; {case}
  Result:= False;
end;

function Tz3DButton.HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  if not Enabled or not Visible then
  begin
    Result:= False;
    Exit;
  end;

  Result:= True;

  case uMsg of
    WM_LBUTTONDOWN,
    WM_LBUTTONDBLCLK:
    begin
      if ContainsPoint(pt) then
      begin
        // Pressed while inside the control
        FPressed := True;
        SetCapture(z3DCore_GetHWND);

        if (not FHasFocus) then FDialog.RequestFocus(Self);

        Exit;
      end;
    end;

    WM_LBUTTONUP:
    begin
      if (FPressed) then
      begin
        FPressed := False;
        ReleaseCapture;

        if (not FDialog.IsKeyboardInputEnabled) then FDialog.ClearFocus;

        // Button click
        if ContainsPoint(pt) then
          FDialog.SendEvent(z3dceButtonClick, True, Self);

        Exit;
      end;
    end;
  end;

  Result:= False;
end;

function Tz3DButton.GetPressed: Boolean;
begin
  Result:= FPressed;
end;

procedure Tz3DButton.OnHotkey;
begin
  if FDialog.IsKeyboardInputEnabled then FDialog.RequestFocus(Self);
  FDialog.SendEvent(z3dceButtonClick, True, Self);
end;

function Tz3DButton.ContainsPoint(pt: TPoint): LongBool;
begin
  Result:= PtInRect(FBoundingBox, pt);
end;

function Tz3DButton.CanHaveFocus: Boolean;
begin
  Result:= Visible and Enabled;
end;

procedure Tz3DButton.Render;
var
//  nOffsetX, nOffsetY: Integer;
  iState: Tz3DControlState;
  pDisplay: Iz3DDisplay;
  fBlendRate: Single;
  rcWindow: TRect;
begin
//  nOffsetX := 0;
//  nOffsetY := 0;
  if not Visible then Exit;

  iState := z3dcsNormal;

  if not Visible then iState := z3dcsHidden else
  if not Enabled then iState := z3dcsDisabled else
  if Pressed then
  begin
    iState := z3dcsPressed;

//    nOffsetX := 1;
//    nOffsetY := 2;
  end
  else if (FMouseOver) then
  begin
    iState := z3dcsMouseOver;

//    nOffsetX := -1;
//    nOffsetY := -2;
  end
  else if (FHasFocus) then
  begin
    iState := z3dcsFocus;
  end;

  pDisplay := m_Displays[0];

  fBlendRate := IfThen((iState = z3dcsPressed), 0.0, 0.8);

  rcWindow := FBoundingBox;


  // Blend current color
  pDisplay.TextureColor.Blend(iState, fBlendRate);
  pDisplay.FontColor.Blend(iState, fBlendRate);

  if FEnableBackground then
  FDialog.DrawSprite(pDisplay, rcWindow);
  FDialog.DrawText(m_strText, pDisplay, rcWindow, Dialog.Manager.Desktop.ThemeSettings.DefaultFont.Shadow);

  // Main button
  pDisplay := m_Displays[1];


  // Blend current color
  pDisplay.TextureColor.Blend(iState, fBlendRate);
  pDisplay.FontColor.Blend(iState, fBlendRate);

  if FEnableBackground then
  FDialog.DrawSprite(pDisplay, rcWindow);
  FDialog.DrawText(m_strText, pDisplay, rcWindow, Dialog.Manager.Desktop.ThemeSettings.DefaultFont.Shadow);
end;

{ Tz3DCheckBox }

constructor Tz3DCheckBox.Create(const pDialog: Iz3DDialog = nil);
begin
  inherited;
  m_Type := z3dctCheckBox;
  FDialog := pDialog;

  FChecked := False;
end;

function Tz3DCheckBox.HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  if not Enabled or not Visible then
  begin
    Result:= False;
    Exit;
  end;

  Result:= True;

  case uMsg of
    WM_KEYDOWN:
    begin
      case wParam of
        VK_SPACE:
        begin
          FPressed := True;
          Exit;
        end;
      end;
    end;

    WM_KEYUP:
    begin
      case wParam of
        VK_SPACE:
        begin
          if Pressed then
          begin
            FPressed := false;
            SetCheckedInternal(not Checked, True);
          end;
          Exit;
        end;
      end;
    end;
  end;
  Result:= False;
end;

function Tz3DCheckBox.HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  if not Enabled or not Visible then
  begin
    Result:= False;
    Exit;
  end;

  Result:= True;

  case uMsg of
    WM_LBUTTONDOWN,
    WM_LBUTTONDBLCLK:
    begin
      if ContainsPoint(pt) then
      begin
        // Pressed while inside the control
        FPressed := True;
        SetCapture(z3DCore_GetHWND);

        if (not FHasFocus) then FDialog.RequestFocus(Self);

        Exit;
      end;
    end;

    WM_LBUTTONUP:
    begin
      if Pressed then
      begin
        FPressed := false;
        ReleaseCapture;

        // Button click
        if ContainsPoint(pt) then SetCheckedInternal(not Checked, True);

        Exit;
      end;
    end;
  end;

  Result:= False;
end;

procedure Tz3DCheckBox.OnHotkey;
begin
  if FDialog.IsKeyboardInputEnabled then FDialog.RequestFocus(Self);
  SetCheckedInternal(not FChecked, True);
end;

function Tz3DCheckBox.GetChecked: Boolean;
begin
  Result:= FChecked;
end;

procedure Tz3DCheckBox.SetChecked(bChecked: Boolean);
begin
  SetCheckedInternal(bChecked, False);
end;

procedure Tz3DCheckBox.SetCheckedInternal(bChecked, bFromInput: Boolean);
begin
  FChecked := bChecked;

  FDialog.SendEvent(z3dcrCheckBoxChange, bFromInput, Self);
end;

function Tz3DCheckBox.ContainsPoint(pt: TPoint): LongBool;
begin
  Result:= PtInRect(FBoundingBox, pt) or
           PtInRect(FButton, pt);
end;

procedure Tz3DCheckBox.UpdateRects;
begin
  inherited;

  FButton := FBoundingBox;
  FButton.right := FButton.left + RectHeight(FButton);

  FText := FBoundingBox;
  Inc(FText.left, Trunc(1.25 * RectWidth(FButton)));
end;

procedure Tz3DCheckBox.Render;
var
  iState: Tz3DControlState;
  pDisplay: Iz3DDisplay;
  fBlendRate: Single;
begin
  if not Visible then Exit;

  iState := z3dcsNormal;

  if not Visible then iState := z3dcsHidden else
  if not Enabled then iState := z3dcsDisabled else
  if Pressed then iState := z3dcsPressed else
  if FMouseOver then iState := z3dcsMouseOver else
  if FHasFocus then iState := z3dcsFocus;

  pDisplay := m_Displays[0];

  fBlendRate := IfThen((iState = z3dcsPressed), 0.0, 0.8);

  pDisplay.TextureColor.Blend(iState, fBlendRate);
  pDisplay.FontColor.Blend(iState, fBlendRate);

  FDialog.DrawSprite(pDisplay, FButton);
  FDialog.DrawText(m_strText, pDisplay, FText, Dialog.Manager.Desktop.ThemeSettings.CheckBoxFont.Shadow);

  if not Checked then iState := z3dcsHidden;

  pDisplay := m_Displays[1];

  pDisplay.TextureColor.Blend(iState, fBlendRate);
  FDialog.DrawSprite(pDisplay, FButton);
end;

{ Tz3DRadioButton }

constructor Tz3DRadioButton.Create(const pDialog: Iz3DDialog = nil);
begin
  inherited;
  m_Type := z3dctRadioButton;
  FDialog := pDialog;
end;

function Tz3DRadioButton.GetButtonGroup: LongWord;
begin
  Result:= FButtonGroup;
end;

function Tz3DRadioButton.HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  if not Enabled or not Visible then
  begin
    Result:= False;
    Exit;
  end;

  Result:= True;
  
  case uMsg of
    WM_KEYDOWN:
    begin
      case wParam of
        VK_SPACE:
        begin
          FPressed := True;
          Exit;
        end;

        WM_KEYUP:
        begin
          case wParam of
            VK_SPACE:
            begin
              if Pressed then
              begin
                FPressed := False;

                FDialog.ClearRadioButtonGroup(FButtonGroup);
                FChecked := not FChecked;

                FDialog.SendEvent(z3dceRadioButtonChange, True, Self);
              end;
              Exit;
            end;
          end;
        end;
      end;
    end;
  end;
  Result:= False;
end;

function Tz3DRadioButton.HandleMouse(uMsg: LongWord; pt: TPoint; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  if not Enabled or not Visible then
  begin
    Result:= False;
    Exit;
  end;

  Result:= True;

  case uMsg of
    WM_LBUTTONDOWN,
    WM_LBUTTONDBLCLK:
    begin
      if ContainsPoint(pt) then
      begin
        // Pressed while inside the control
        FPressed := true;
        SetCapture(z3DCore_GetHWND);

        if (not FHasFocus) then FDialog.RequestFocus(Self);
        Exit;
      end;
    end;

    WM_LBUTTONUP:
    begin
      if Pressed then
      begin
        FPressed := False;
        ReleaseCapture;

        // Button click
        if ContainsPoint(pt) then
        begin
          FDialog.ClearRadioButtonGroup(FButtonGroup);
          FChecked := not FChecked;

          FDialog.SendEvent(z3dceRadioButtonChange, True, Self);
        end;
        Exit;
      end;
    end;
  end;

  Result:= false;
end;

procedure Tz3DRadioButton.OnHotkey;
begin
  if FDialog.IsKeyboardInputEnabled then FDialog.RequestFocus(Self);
  SetCheckedInternal(True, True, True);
end;

procedure Tz3DRadioButton.SetChecked(bChecked: Boolean);
begin
  SetCheckedInternal(bChecked, True, False);
end;

procedure Tz3DRadioButton.SetButtonGroup(const Value: LongWord);
begin
  FButtonGroup:= Value;
end;

procedure Tz3DRadioButton.SetChecked(bChecked: Boolean; bClearGroup: Boolean = True);
begin
  SetCheckedInternal(bChecked, bClearGroup, False);
end;

procedure Tz3DRadioButton.SetCheckedInternal(bChecked, bClearGroup, bFromInput: Boolean);
begin
  if (bChecked and bClearGroup) then FDialog.ClearRadioButtonGroup(FButtonGroup);
  FChecked := bChecked;
  FDialog.SendEvent(z3dceRadioButtonChange, bFromInput, Self);
end;

function Tz3DDialog.GetControlIndex(AIndex: Integer): Iz3DControl;
begin
  Result:= m_Controls[AIndex] as Iz3DControl;
end;

function Tz3DDialog.HasFocus: Boolean;
begin
  Result:= Manager.IndexOf(Self) = Manager.DialogCount-1;
end;

procedure Tz3DDialog.SetFocus;
begin
  if HasFocus then Exit;
  Manager.BringToFront(Self);
end;

procedure Tz3DDialog.Hide;
begin
  FVisible:= False;
  FManager.ModalMode:= False;
end;

procedure Tz3DDialog.Show;
begin
  FVisible:= True;
end;

procedure Tz3DDialog.ShowModal;
begin
  ModalResult:= z3dmdrNone;
  FManager.ModalMode:= True;
  Visible:= True;
  FModalMode:= True;
  SetFocus;
  while ModalResult = z3dmdrNone do z3DCore_ProcessMessages;
end;

function Tz3DDialog.GetModalMode: Boolean;
begin
  Result:= FModalMode;
end;

function Tz3DDialog.GetEnableBackground: Boolean;
begin
  Result:= FEnableBackground;
end;

procedure Tz3DDialog.SetEnableBackground(const Value: Boolean);
begin
  FEnableBackground:= Value;
end;

function Tz3DDialog.GetEnableBorder: Boolean;
begin
  Result:= FEnableBorder;
end;

procedure Tz3DDialog.SetEnableBorder(const Value: Boolean);
begin
  FEnableBorder:= Value;
end;

function Tz3DDialog.GetDesktopOnly: Boolean;
begin
  Result:= FDesktopOnly;
end;

procedure Tz3DDialog.SetDesktopOnly(const Value: Boolean);
begin
  FDesktopOnly:= Value;
end;

{ Tz3DScrollBar }

constructor Tz3DScrollBar.Create(const pDialog: Iz3DDialog);
begin
  inherited;
  m_Type := z3dctScrollBar;
  FDialog := pDialog;

  FShowThumb := True;
  FDrag := False;

  SetRect(FUpButton, 0, 0, 0, 0);
  SetRect(FDownButton, 0, 0, 0, 0);
  SetRect(FTrack, 0, 0, 0, 0);
  SetRect(FThumb, 0, 0, 0, 0);
  FPosition := 0;
  FPageSize := 1;
  FStart := 0;
  FEnd := 1;
  m_Arrow := CLEAR;
  m_dArrowTS := 0.0;
end;

procedure Tz3DScrollBar.UpdateRects;
begin
  inherited;

  SetRect(FUpButton, FBoundingBox.left, FBoundingBox.top,
                        FBoundingBox.right, FBoundingBox.top + RectWidth(FBoundingBox));
  SetRect(FDownButton, FBoundingBox.left, FBoundingBox.bottom - RectWidth(FBoundingBox),
                          FBoundingBox.right, FBoundingBox.bottom);
  SetRect(FTrack, FUpButton.left, FUpButton.bottom,
                     FDownButton.right, FDownButton.top);
  FThumb.left := FUpButton.left;
  FThumb.right := FUpButton.right;

  UpdateThumbRect;
end;

// Compute the dimension of the scroll thumb
procedure Tz3DScrollBar.UpdateThumbRect;
var
  nThumbHeight: Integer;
  nMaxPosition: Integer;
begin
  if (FEnd - FStart > FPageSize) then
  begin
    nThumbHeight := Max(RectHeight(FTrack) * FPageSize div (FEnd - FStart), SCROLLBAR_MINTHUMBSIZE);
    nMaxPosition := FEnd - FStart - FPageSize;
    FThumb.top := FTrack.top + (FPosition - FStart) * (RectHeight(FTrack) - nThumbHeight) div nMaxPosition;
    FThumb.bottom := FThumb.top + nThumbHeight;
    FShowThumb := True;
  end else
  begin
    // No content to scroll
    FThumb.bottom := FThumb.top;
    FShowThumb := False;
  end;
end;

function Tz3DScrollBar.GetPageSize: Integer;
begin
  Result:= FPageSize;
end;

function Tz3DScrollBar.GetPosition: Integer;
begin
  Result:= FPosition;
end;

procedure Tz3DScrollBar.Scroll(nDelta: Integer);
begin
  Inc(FPosition, nDelta);
  Cap;
  UpdateThumbRect;
end;

procedure Tz3DScrollBar.ShowItem(nIndex: Integer);
begin
  // Cap the index
  if (nIndex < 0) then nIndex := 0;
  if (nIndex >= FEnd) then nIndex := FEnd - 1;

  // Adjust position
  if (FPosition > nIndex) then FPosition := nIndex else
  if (FPosition + FPageSize <= nIndex) then FPosition := nIndex - FPageSize + 1;

  UpdateThumbRect;
end;

function Tz3DScrollBar.HandleKeyboard(uMsg: LongWord; wParam: WPARAM;
  lParam: LPARAM): Boolean;
begin
  Result:= False;
end;

var
  ThumbOffsetY: Integer = 0;

function Tz3DScrollBar.HandleMouse(uMsg: LongWord; pt: TPoint;
  wParam: WPARAM; lParam: LPARAM): Boolean;
var
  nMaxFirstItem: Integer;
  nMaxThumb: Integer;
begin
  Result:= True;

  m_LastMouse := pt;
  case uMsg of
    WM_LBUTTONDOWN,
    WM_LBUTTONDBLCLK:
    begin
      // Check for click on up button
      if PtInRect(FUpButton, pt) then
      begin
        SetCapture(z3DCore_GetHWND);
        if (FPosition > FStart) then Dec(FPosition);
        UpdateThumbRect;
        m_Arrow := CLICKED_UP;
        m_dArrowTS := z3DCore_GetTime;
        Exit;
      end;

      // Check for click on down button
      if PtInRect(FDownButton, pt) then
      begin
        SetCapture(z3DCore_GetHWND);
        if (FPosition + FPageSize < FEnd) then Inc(FPosition);
        UpdateThumbRect;
        m_Arrow := CLICKED_DOWN;
        m_dArrowTS := z3DCore_GetTime;
        Exit;
      end;

      // Check for click on thumb
      if PtInRect(FThumb, pt) then
      begin
        SetCapture(z3DCore_GetHWND);
        FDrag := True;
        ThumbOffsetY := pt.y - FThumb.top;
        Exit;
      end;

      // Check for click on track
      if (FThumb.left <= pt.x) and (FThumb.right > pt.x) then
      begin
        SetCapture(z3DCore_GetHWND);
        if (FThumb.top > pt.y) and
           (FTrack.top <= pt.y) then
        begin
          Scroll(-(FPageSize - 1));
          Exit;
        end else
        if (FThumb.bottom <= pt.y) and
           (FTrack.bottom > pt.y) then
        begin
          Scroll(FPageSize - 1);
          Exit;
        end;
      end;
    end;

    WM_LBUTTONUP:
    begin
      FDrag := False;
      ReleaseCapture;
      UpdateThumbRect;
      m_Arrow := CLEAR;
    end;

    WM_MOUSEMOVE:
    begin
      if FDrag then
      begin
        Inc(FThumb.bottom, pt.y - ThumbOffsetY - FThumb.top);
        FThumb.top := pt.y - ThumbOffsetY;
        if (FThumb.top < FTrack.top) then OffsetRect(FThumb, 0, FTrack.top - FThumb.top) else
        if (FThumb.bottom > FTrack.bottom) then OffsetRect(FThumb, 0, FTrack.bottom - FThumb.bottom);

        // Compute first item index based on thumb position
        nMaxFirstItem := FEnd - FStart - FPageSize;  // Largest possible index for first item
        nMaxThumb := RectHeight(FTrack) - RectHeight(FThumb);  // Largest possible thumb position from the top

        FPosition := FStart +
                      ( FThumb.top - FTrack.top +
                        nMaxThumb div (nMaxFirstItem * 2) ) * // Shift by half a row to avoid last row covered by only one pixel
                      nMaxFirstItem  div nMaxThumb;

        Exit;
      end;
    end;
  end;

  Result:= False;
end;

function Tz3DScrollBar.MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  if (WM_CAPTURECHANGED = uMsg) then
  begin
    // The application just lost mouse capture. We may not have gotten
    // the WM_MOUSEUP message, so reset FDrag here.
    if (THandle(lParam) <> z3DCore_GetHWND) then FDrag := False;
  end;

  Result:= False;
end;

procedure Tz3DScrollBar.Render;
var
  dCurrTime: Double;
  iState: Tz3DControlState;
  fBlendRate: Single;
  pDisplay: Iz3DDisplay;
begin
  inherited;
  if not Visible then Exit;

  // Check if the arrow button has been held for a while.
  // If so, update the thumb position to simulate repeated
  // scroll.
  if (m_Arrow <> CLEAR) then
  begin
    dCurrTime := z3DCore_GetTime;
    if PtInRect(FUpButton, m_LastMouse) then
    begin
      case m_Arrow of
        CLICKED_UP:
          if (SCROLLBAR_ARROWCLICK_DELAY < dCurrTime - m_dArrowTS) then
          begin
            Scroll(-1);
            m_Arrow := HELD_UP;
            m_dArrowTS := dCurrTime;
          end;

        HELD_UP:
          if (SCROLLBAR_ARROWCLICK_REPEAT < dCurrTime - m_dArrowTS) then
          begin
            Scroll(-1);
            m_dArrowTS := dCurrTime;
          end;
      end; 
    end else
    if PtInRect(FDownButton, m_LastMouse) then
    begin
      case m_Arrow of
        CLICKED_DOWN:
          if (SCROLLBAR_ARROWCLICK_DELAY < dCurrTime - m_dArrowTS) then
          begin
            Scroll(1);
            m_Arrow := HELD_DOWN;
            m_dArrowTS := dCurrTime;
          end;

        HELD_DOWN:
          if (SCROLLBAR_ARROWCLICK_REPEAT < dCurrTime - m_dArrowTS) then
          begin
            Scroll(1);
            m_dArrowTS := dCurrTime;
          end;
      end;
    end;
  end;

  iState := z3dcsNormal;

  if not FVisible then iState := z3dcsHidden
  else if (not FEnabled or not FShowThumb) then iState := z3dcsDisabled
  else if FMouseOver then iState := z3dcsMouseOver
  else if FHasFocus  then iState := z3dcsFocus;

  fBlendRate := IfThen(iState = z3dcsPressed, 0.0, 0.8);

  // Background track layer
  pDisplay := m_Displays[0];

  // Blend current color
  pDisplay.TextureColor.Blend(iState, fBlendRate);
  FDialog.DrawSprite(pDisplay, FTrack);

  // Up Arrow
  pDisplay := m_Displays[1];

  // Blend current color
  pDisplay.TextureColor.Blend(iState, fBlendRate);
  FDialog.DrawSprite(pDisplay, FUpButton);

  // Down Arrow
  pDisplay := m_Displays[2];

  // Blend current color
  pDisplay.TextureColor.Blend(iState, fBlendRate);
  FDialog.DrawSprite(pDisplay, FDownButton);

  // Thumb button
  pDisplay := m_Displays[3];

  // Blend current color
  pDisplay.TextureColor.Blend(iState, fBlendRate);
  FDialog.DrawSprite(pDisplay, FThumb);
end;


procedure Tz3DScrollBar.SetTrackRange(nStart, nEnd: Integer);
begin
  FStart := nStart;
  FEnd := nEnd;
  Cap;
  UpdateThumbRect;
end;

procedure Tz3DScrollBar.Cap;
begin
  if (FPosition < FStart) or
     (FEnd - FStart <= FPageSize) then
  begin
    FPosition := FStart;
  end else
  if (FPosition + FPageSize > FEnd)
  then FPosition := FEnd - FPageSize;
end;

procedure Tz3DScrollBar.SetPageSize(nPageSize: Integer);
begin
  FPageSize := nPageSize;
  Cap;
  UpdateThumbRect;
end;


procedure Tz3DScrollBar.SetTrackPos(nPosition: Integer);
begin
  FPosition := nPosition;
  Cap;
  UpdateThumbRect;
end;

{ Tz3DListBox }

constructor Tz3DListBox.Create(const pDialog: Iz3DDialog);
begin
  inherited;
  m_ScrollBar:= Tz3DScrollBar.Create(pDialog);
  m_Items:= TList.Create;
  m_Type := z3dctListBox;
  FDialog := pDialog;
  FStyle := z3dlbsNormal;
  FSBWidth := 16;
  FSelected := -1;
  FSelStart := 0;
  FDrag := false;
  FBorder := 6;
  FMargin := 5;
  FTextHeight := 0;
end;

destructor Tz3DListBox.Destroy;
begin
  RemoveAllItems;
  FreeAndNil(m_Items);
  FreeAndNil(m_ScrollBar);
  inherited;
end;

procedure Tz3DListBox.UpdateRects;
var
  pFontNode: Pz3DFontNode;
begin
  inherited;

  FSelection := FBoundingBox;
  Dec(FSelection.right, FSBWidth);
  InflateRect(FSelection, -FBorder, -FBorder);
  FText := FSelection;
  InflateRect(FText, -FMargin, 0);

  // Update the scrollbar's rects
  m_ScrollBar.SetLocation(FBoundingBox.right - FSBWidth, FBoundingBox.top);
  m_ScrollBar.SetSize(FSBWidth, FHeight);
  pFontNode := FDialog.Manager.Fonts[m_Displays[0].Font];
  if (pFontNode <> nil) and (pFontNode.Height <> 0) then
  begin
    m_ScrollBar.SetPageSize(RectHeight(FText) div pFontNode.Height);

    // The selected item may have been scrolled off the page.
    // Ensure that it is in page again.
    m_ScrollBar.ShowItem(FSelected);
  end;
end;

function Tz3DListBox.AddItem(const wszText: PWideChar; pData: Pointer): HRESULT;
var
  pNewItem: Pz3DListBoxItem;
begin
  Result:= S_OK;
  try
    New(pNewItem);

    StringCchCopy(pNewItem.strText, 256, wszText);
    pNewItem.pData := pData;
    SetRect(pNewItem.rcActive, 0, 0, 0, 0);
    pNewItem.bSelected := False;

    m_Items.Add(pNewItem);
    m_ScrollBar.SetTrackRange(0, m_Items.Count);
  except
    Dispose(pNewItem);
    Result:= E_OUTOFMEMORY;
    Exit;
  end;
end;

function Tz3DListBox.InsertItem(nIndex: Integer; const wszText: PWideChar;
  pData: Pointer): HRESULT;
var
  pNewItem: Pz3DListBoxItem;
begin
  Result:= S_OK;
  try
    New(pNewItem);

    StringCchCopy(pNewItem.strText, 256, wszText);
    pNewItem.pData := pData;
    SetRect(pNewItem.rcActive, 0, 0, 0, 0);
    pNewItem.bSelected := False;

    m_Items.Insert(nIndex, pNewItem);
    m_ScrollBar.SetTrackRange(0, m_Items.Count);
  except
    Dispose(pNewItem);
    Result:= E_OUTOFMEMORY;
    Exit;
  end;
end;

procedure Tz3DListBox.RemoveItem(nIndex: Integer);
var
  pItem: Pz3DListBoxItem;
begin
  if (nIndex < 0) or (nIndex >= m_Items.Count) then Exit;

  pItem := Pz3DListBoxItem(m_Items[nIndex]);
  Dispose(pItem);
  m_Items.Delete(nIndex); // Remove(nIndex);

  m_ScrollBar.SetTrackRange(0, m_Items.Count);
  if (FSelected >= m_Items.Count) then FSelected := m_Items.Count - 1;

  FDialog.SendEvent(z3dceListBoxBeginSelect, True, Self);
end;

procedure Tz3DListBox.RemoveItemByText(wszText: PWideChar);
begin
end;

procedure Tz3DListBox.RemoveItemByData(pData: Pointer);
begin
end;

procedure Tz3DListBox.RemoveAllItems;
var
  i: Integer;
  pItem: Pz3DListBoxItem;
begin
  for i := 0 to m_Items.Count - 1 do
  begin
    pItem := Pz3DListBoxItem(m_Items[i]);
    Dispose(pItem);
  end;

  m_Items.Clear; // RemoveAll;
  m_ScrollBar.SetTrackRange(0, 1);
end;

function Tz3DListBox.GetItem(nIndex: Integer): Pz3DListBoxItem;
begin
  Result:= nil;
  if (nIndex < 0) or (nIndex >= m_Items.Count) then Exit;
  Result:= m_Items[nIndex];
end;

// For single-selection listbox, returns the index of the selected item.
// For multi-selection, returns the first selected item after the nPreviousSelected position.
// To search for the first selected item, the app passes -1 for nPreviousSelected.  For
// subsequent searches, the app passes the returned index back to GetSelectedIndex as.
// nPreviousSelected.
// Returns -1 on error or if no item is selected.
function Tz3DListBox.GetSelectedIndex(nPreviousSelected: Integer): Integer;
var
  i: Integer;
  pItem: Pz3DListBoxItem;
begin
  Result:= -1;
  if (nPreviousSelected < -1) then Exit;

  if (FStyle = z3dlbsMultiSelect) then
  begin
    // Multiple selection enabled. Search for the next item with the selected flag.
    for i := nPreviousSelected + 1 to m_Items.Count - 1 do
    begin
      pItem := Pz3DListBoxItem(m_Items[i]);

      if (pItem.bSelected) then
      begin
        Result:= i;
        Exit;
      end;
    end;

    Result:= -1;
  end else
  begin
    // Single selection
    Result:= FSelected;
  end;
end;

procedure Tz3DListBox.SelectItem(nNewIndex: Integer);
var
  nOldSelected: Integer;
begin
  // If no item exists, do nothing.
  if (m_Items.Count = 0) then Exit;

  nOldSelected := FSelected;

  // Adjust FSelected
  FSelected := nNewIndex;

  // Perform capping
  if (FSelected < 0) then FSelected := 0;
  if (FSelected >= m_Items.Count) then FSelected := m_Items.Count - 1;

  if (nOldSelected <> FSelected) then
  begin
    if (FStyle = z3dlbsMultiSelect) then
    begin
      Pz3DListBoxItem(m_Items[FSelected])^.bSelected := True;
    end;

    // Update selection start
    FSelStart := FSelected;

    // Adjust scroll bar
    m_ScrollBar.ShowItem(FSelected);
  end;

  FDialog.SendEvent(z3dceListBoxBeginSelect, True, Self);
end;

function Tz3DListBox.HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
var
  nOldSelected: Integer;
  i, n: Integer;
  nEnd: Integer;
begin
  Result:= True;
  if (not FEnabled or not FVisible) then
  begin
    Result:= False;
    Exit;
  end;

  // Let the scroll bar have a chance to handle it first
  if m_ScrollBar.HandleKeyboard(uMsg, wParam, lParam) then Exit;

  case uMsg of
    WM_KEYDOWN:
    begin
      case wParam of
        VK_UP, VK_DOWN,
        VK_NEXT, VK_PRIOR,
        VK_HOME, VK_END:
        begin
          // If no item exists, do nothing.
          if (m_Items.Count = 0) then Exit;
          nOldSelected := FSelected;

          // Adjust FSelected
          case wParam of
            VK_UP:    Dec(FSelected);
            VK_DOWN:  Inc(FSelected);
            VK_NEXT:  Inc(FSelected, m_ScrollBar.PageSize - 1);
            VK_PRIOR: Dec(FSelected, m_ScrollBar.PageSize - 1);
            VK_HOME:  FSelected := 0;
            VK_END:   FSelected := m_Items.Count - 1;
          end;

          // Perform capping
          if (FSelected < 0) then FSelected := 0;
          if (FSelected >= m_Items.Count) then FSelected := m_Items.Count - 1;

          if (nOldSelected <> FSelected) then
          begin
            if (FStyle = z3dlbsMultiSelect) then
            begin
              // Multiple selection

              // Clear all selection
              for i := 0 to m_Items.Count - 1 do
              begin
                Pz3DListBoxItem(m_Items[i]).bSelected := False;
              end;

              if (GetKeyState(VK_SHIFT) < 0) then
              begin
                // Select all items from FSelStart to
                // FSelected
                nEnd := Max(FSelStart, FSelected);

                for n := Min(FSelStart, FSelected) to nEnd - 1 do
                  Pz3DListBoxItem(m_Items[n]).bSelected := true;
              end else
              begin
                Pz3DListBoxItem(m_Items[FSelected]).bSelected := True;

                // Update selection start
                FSelStart := FSelected;
              end;
            end else
              FSelStart := FSelected;

            // Adjust scroll bar
            m_ScrollBar.ShowItem(FSelected);

            // Send notification
            FDialog.SendEvent(z3dceListBoxBeginSelect, True, Self);
          end;
          Exit;
        end;

        // Space is the hotkey for double-clicking an item.
        //
        VK_SPACE:
        begin
          FDialog.SendEvent(z3dceListBoxDblClick, True, Self);
          Exit;
        end;
      end;
    end;
  end;

  Result:= False;
end;

function Tz3DListBox.HandleMouse(uMsg: LongWord; pt: TPoint;
  wParam: WPARAM; lParam: LPARAM): Boolean;
var
  nClicked: Integer;
  pSelItem: Pz3DListBoxItem;
  nBegin, nEnd: Integer;
  i, n: Integer;
  bLastSelected: Boolean;
  nItem: Integer;
  uLines: LongWord;
  nScrollAmount: Integer;  
begin
  Result:= True;
  if (not FEnabled or not FVisible) then
  begin
    Result:= False;
    Exit;
  end;

  // First acquire focus
  if (WM_LBUTTONDOWN = uMsg) and (not FHasFocus)
  then FDialog.RequestFocus(Self);

  // Let the scroll bar handle it first.
  if m_ScrollBar.HandleMouse( uMsg, pt, wParam, lParam) then Exit;

  case uMsg of
    WM_LBUTTONDOWN,
    WM_LBUTTONDBLCLK:
    begin
      // Check for clicks in the text area
      if (m_Items.Count > 0) and PtInRect(FSelection, pt) then
      begin
        // Compute the index of the clicked item

        if (FTextHeight <> 0)
        then nClicked := m_ScrollBar.TrackPos + (pt.y - FText.top) div FTextHeight
        else nClicked := -1;

        // Only proceed if the click falls on top of an item.

        if (nClicked >= m_ScrollBar.TrackPos) and
           (nClicked < m_Items.Count) and
           (nClicked < m_ScrollBar.TrackPos + m_ScrollBar.PageSize) then
        begin
          SetCapture(z3DCore_GetHWND);
          FDrag := True;

          // If this is a double click, fire off an event and exit
          // since the first click would have taken care of the selection
          // updating.
          if (uMsg = WM_LBUTTONDBLCLK) then
          begin
            FDialog.SendEvent(z3dceListBoxDblClick, True, Self);
            Exit;
          end;

          FSelected := nClicked;
          if (wParam and MK_SHIFT = 0) then FSelStart := FSelected;

          // If this is a multi-selection listbox, update per-item
          // selection data.
          if (FStyle = z3dlbsMultiSelect) then
          begin
            pSelItem := Pz3DListBoxItem(m_Items[FSelected]);

            // Determine behavior based on the state of Shift and Ctrl
            if (wParam and (MK_SHIFT or MK_CONTROL) = MK_CONTROL) then
            begin
              // Control click. Reverse the selection of this item.
              pSelItem.bSelected := not pSelItem.bSelected;
            end else
            if (wParam and (MK_SHIFT or MK_CONTROL) = MK_SHIFT) then
            begin
              // Shift click. Set the selection for all items
              // from last selected item to the current item.
              // Clear everything else.

              nBegin := Min(FSelStart, FSelected);
              nEnd := Max(FSelStart, FSelected);

              for i := 0 to nBegin - 1 do
                Pz3DListBoxItem(m_Items[i]).bSelected := False;

              for i := nEnd + 1 to m_Items.Count - 1 do
                Pz3DListBoxItem(m_Items[i]).bSelected := False;

              for i := nBegin to nEnd do
                Pz3DListBoxItem(m_Items[i]).bSelected := True;

            end else
            if (wParam and (MK_SHIFT or MK_CONTROL) = (MK_SHIFT or MK_CONTROL)) then
            begin
              // Control-Shift-click.

              // The behavior is:
              //   Set all items from FSelStart to FSelected to
              //     the same state as FSelStart, not including FSelected.
              //   Set FSelected to selected.

              nBegin := Min(FSelStart, FSelected);
              nEnd := Max(FSelStart, FSelected);

              // The two ends do not need to be set here.

              bLastSelected := Pz3DListBoxItem(m_Items[FSelStart]).bSelected;
              for i := nBegin + 1 to nEnd - 1 do
                Pz3DListBoxItem(m_Items[i]).bSelected := bLastSelected;

              pSelItem.bSelected := True;

              // Restore FSelected to the previous value
              // This matches the Windows behavior

              FSelected := FSelStart;
            end else
            begin
              // Simple click.  Clear all items and select the clicked
              // item.

              for i := 0 to m_Items.Count - 1 do
                Pz3DListBoxItem(m_Items[i]).bSelected := False;

              pSelItem.bSelected := True;
            end;
          end;  // End of multi-selection case

          FDialog.SendEvent(z3dceListBoxBeginSelect, True, Self);
        end;

        Exit;
      end;
    end;

    WM_LBUTTONUP:
    begin
      ReleaseCapture;
      FDrag := False;

      if (FSelected <> -1) then
      begin
        // Set all items between FSelStart and FSelected to
        // the same state as FSelStart
        nEnd := Max(FSelStart, FSelected);

        for n := Min(FSelStart, FSelected) + 1 to nEnd - 1 do
          Pz3DListBoxItem(m_Items[n]).bSelected := Pz3DListBoxItem(m_Items[FSelStart]).bSelected;
        Pz3DListBoxItem(m_Items[FSelected]).bSelected := Pz3DListBoxItem(m_Items[FSelStart]).bSelected;

        // If FSelStart and FSelected are not the same,
        // the user has dragged the mouse to make a selection.
        // Notify the application of this.
        if (FSelStart <> FSelected)
        then FDialog.SendEvent(z3dceListBoxBeginSelect, True, Self);

        FDialog.SendEvent(z3dceListBoxEndSelect, True, Self);
      end;
      Result:= False;
      Exit;
    end;

    WM_MOUSEMOVE:
    if FDrag then
    begin
      // Compute the index of the item below cursor

      if (FTextHeight <> 0) 
      then nItem := m_ScrollBar.TrackPos + (pt.y - FText.top) div FTextHeight
      else nItem := -1;

      // Only proceed if the cursor is on top of an item.

      if (nItem >= m_ScrollBar.TrackPos) and
         (nItem < m_Items.Count) and
         (nItem < m_ScrollBar.TrackPos + m_ScrollBar.PageSize) then
      begin
        FSelected := nItem;
        FDialog.SendEvent(z3dceListBoxBeginSelect, True, Self);
      end else
      if (nItem < m_ScrollBar.TrackPos) then
      begin
        // User drags the mouse above window top
        m_ScrollBar.Scroll(-1);
        FSelected := m_ScrollBar.TrackPos;
        FDialog.SendEvent(z3dceListBoxBeginSelect, True, Self);
      end else
      if (nItem >= m_ScrollBar.TrackPos + m_ScrollBar.PageSize) then
      begin
        // User drags the mouse below window bottom
        m_ScrollBar.Scroll(1);
        FSelected := Min(m_Items.Count, m_ScrollBar.TrackPos + m_ScrollBar.PageSize ) - 1;
        FDialog.SendEvent(z3dceListBoxBeginSelect, True, Self);
      end;
    end;

    WM_MOUSEWHEEL:
    begin
      SystemParametersInfo(SPI_GETWHEELSCROLLLINES, 0, @uLines, 0);
      nScrollAmount := Integer(ShortInt(HIWORD(wParam))) div WHEEL_DELTA * Integer(uLines);
      m_ScrollBar.Scroll( -nScrollAmount);
      Result:= true;
      Exit;
    end;
  end;

  Result:= False;
end;

function Tz3DListBox.MsgProc(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  if (WM_CAPTURECHANGED = uMsg) then
  begin
    // The application just lost mouse capture. We may not have gotten
    // the WM_MOUSEUP message, so reset FDrag here.
    if (THandle(lParam) <> z3DCore_GetHWND) then FDrag := False;
  end;

  Result:= False;
end;

var bSBInit: Boolean = False;

procedure Tz3DListBox.Render;
var
  pDisplay: Iz3DDisplay;
  pSelDisplay: Iz3DDisplay;
  rc, rcSel: TRect;
  i: Integer;
  pItem: Pz3DListBoxItem;
  bSelectedStyle: Boolean;
begin
  if not Visible then Exit;

  pDisplay := m_Displays[0];
  pDisplay.TextureColor.Blend(z3dcsNormal);
  pDisplay.FontColor.Blend(z3dcsNormal);

  pSelDisplay := m_Displays[1];
  pSelDisplay.TextureColor.Blend(z3dcsNormal);
  pSelDisplay.FontColor.Blend(z3dcsNormal);

  FDialog.DrawSprite(pDisplay, FBoundingBox);

  // Render the text
  if (m_Items.Count > 0) then
  begin
    // Find out the height of a single line of text
    rc := FText;
    rcSel := FSelection;
    rc.bottom := rc.top + FDialog.Manager.Fonts[pDisplay.Font].Height;

    // Update the line height formation
    FTextHeight := rc.bottom - rc.top;

    if not bSBInit then
    begin
      // Update the page size of the scroll bar
      if (FTextHeight <> 0)
      then m_ScrollBar.SetPageSize(RectHeight(FText) div FTextHeight)
      else m_ScrollBar.SetPageSize(RectHeight(FText));
      bSBInit := True;
    end;

    rc.right := FText.right;
    for i := m_ScrollBar.TrackPos to m_Items.Count - 1 do
    begin
      if (rc.bottom > FText.bottom) then Break;

      pItem := Pz3DListBoxItem(m_Items[i]);

      // Determine if we need to render this item with the
      // selected element.
      bSelectedStyle := False;

      if (FStyle <> z3dlbsMultiSelect) and (i = FSelected)
      then bSelectedStyle := True
      else if (FStyle = z3dlbsMultiSelect) then
      begin
        if FDrag and
           ( (i >= FSelected) and (i < FSelStart) or
             (i <= FSelected) and (i > FSelStart) )
        then bSelectedStyle := Pz3DListBoxItem(m_Items[FSelStart]).bSelected
        else if pItem.bSelected then
          bSelectedStyle := True;
      end;

      if bSelectedStyle then
      begin
        rcSel.top := rc.top;
        rcSel.bottom := rc.bottom;
        FDialog.DrawSprite(pSelDisplay, rcSel);
        FDialog.DrawText(pItem.strText, pSelDisplay, rc);
      end else
        FDialog.DrawText(pItem.strText, pDisplay, rc);

      OffsetRect(rc, 0, FTextHeight);
    end;
  end;

  // Render the scroll bar
  m_ScrollBar.Render;
end;

function Tz3DListBox.GetSBWidth: Integer;
begin
 Result:= FSBWidth;
end;

function Tz3DListBox.GetSelected: Integer;
begin
  Result:= FSelected;
end;

function Tz3DListBox.GetStyle: Tz3DListBoxStyle;
begin
  Result:= FStyle;
end;

function Tz3DListBox.CanHaveFocus: Boolean;
begin
  Result:= FVisible and FEnabled;
end;

function Tz3DListBox.GetSelectedItem(nPreviousSelected: Integer): Pz3DListBoxItem;
begin
  Result:= GetItem(GetSelectedIndex(nPreviousSelected));
end;

function Tz3DListBox.OnInit: HRESULT;
begin
  inherited OnInit;
  if FDialog <> nil then Result:= FDialog.InitControl(m_ScrollBar);
end;

procedure Tz3DListBox.SetBorder(nBorder, nMargin: Integer);
begin
  FBorder := nBorder;
  FMargin := nMargin;
end;

procedure Tz3DListBox.SetScrollBarWidth(nWidth: Integer);
begin
  FSBWidth := nWidth;
  UpdateRects;
end;

procedure Tz3DListBox.SetStyle(dwStyle: Tz3DListBoxStyle);
begin
  FStyle := dwStyle;
end;

function Tz3DListBox.GetSize: Integer;
begin
  Result:= m_Items.Count;
end;

procedure Tz3DListBox.SetDialog(const Value: Iz3DDialog);
begin
  inherited;
  if FDialog <> nil then FDialog.InitControl(m_ScrollBar);
  m_ScrollBar.Dialog:= FDialog;
end;

{ Tz3DComboBox }

constructor Tz3DComboBox.Create(const pDialog: Iz3DDialog);
begin
  inherited;
  m_ScrollBar:= Tz3DScrollBar.Create(pDialog);
  m_Type := z3dctComboBox;
  FDialog := pDialog;
  FDropHeight := 64;
  FSBWidth := 16;
  FOpened := False;
  m_iSelected := -1;
  m_iFocused := -1;
end;

destructor Tz3DComboBox.Destroy;
begin
  RemoveAllItems;
  FreeAndNil(m_ScrollBar);
  inherited;
end;

procedure Tz3DComboBox.SetTextColor(Color: TD3DColor);
var
  pDisplay: Iz3DDisplay;
begin
  pDisplay := m_Displays[0];

  if (pDisplay <> nil) then
    pDisplay.FontColor.States[z3dcsNormal] := Color;

  pDisplay := m_Displays[2];

  if (pDisplay <> nil) then
    pDisplay.FontColor.States[z3dcsNormal] := Color;
end;

function Tz3DComboBox.GetSBWidth: Integer;
begin
  Result:= FSBWidth;
end;

procedure Tz3DComboBox.UpdateRects;
var
  pFontNode: Pz3DFontNode;
begin
  inherited;

  FButton := FBoundingBox;
  FButton.left := FButton.right - RectHeight(FButton);

  FText := FBoundingBox;
  FText.right := FButton.left;

  FDropdown := FText;
  OffsetRect(FDropdown, 0, Trunc(0.9 * RectHeight(FText)));
  Inc(FDropdown.bottom,  FDropHeight);
  Dec(FDropdown.right, FSBWidth);

  FDropdownText := FDropdown;
  Inc(FDropdownText.left,   Trunc(0.1 * RectWidth(FDropdown)));
  Dec(FDropdownText.right,  Trunc(0.1 * RectWidth(FDropdown)));
  Inc(FDropdownText.top,    Trunc(0.1 * RectHeight(FDropdown)));
  Dec(FDropdownText.bottom, Trunc(0.1 * RectHeight(FDropdown)));

  // Update the scrollbar's rects
  m_ScrollBar.SetLocation(FDropdown.right, FDropdown.top+2);
  m_ScrollBar.SetSize(FSBWidth, RectHeight(FDropdown)-2);
  pFontNode := FDialog.Manager.Fonts[m_Displays[2].Font];
  if (pFontNode <> nil) and (pFontNode.Height <> 0) then
  begin
    m_ScrollBar.SetPageSize(RectHeight(FDropdownText) div pFontNode.Height);

    // The selected item may have been scrolled off the page.
    // Ensure that it is in page again.
    m_ScrollBar.ShowItem(m_iSelected);
  end;
end;

procedure Tz3DComboBox.OnFocusOut;
begin
  inherited;
  FOpened := False;
end;

function Tz3DComboBox.HandleKeyboard(uMsg: LongWord; wParam: WPARAM;
  lParam: LPARAM): Boolean;
const
  REPEAT_MASK = $40000000;
begin
  Result:= True;
  if (not FEnabled or not FVisible) then
  begin
    Result:= False;
    Exit;
  end;

  // Let the scroll bar have a chance to handle it first
  if m_ScrollBar.HandleKeyboard(uMsg, wParam, lParam) then Exit;

  case uMsg of
    WM_KEYDOWN:
    case wParam of
      VK_RETURN:
      if FOpened then
      begin
        if (m_iSelected <> m_iFocused) then
        begin
          m_iSelected := m_iFocused;
          FDialog.SendEvent(z3dceComboBoxChange, True, Self);
        end;
        FOpened := False;

        if not FDialog.IsKeyboardInputEnabled then FDialog.ClearFocus;
        
        Exit;
      end;

      VK_F4:
      begin
        // Filter out auto-repeats
        if (lParam and REPEAT_MASK <> 0) then Exit;

        FOpened := not FOpened;

        if not FOpened then
        begin
          FDialog.SendEvent(z3dceComboBoxChange, True, Self);
          if not FDialog.IsKeyboardInputEnabled then FDialog.ClearFocus;
        end;
        
        Exit;
      end;

      VK_LEFT, VK_UP:
      begin
        if (m_iFocused > 0) then
        begin
          Dec(m_iFocused);
          m_iSelected := m_iFocused;

          if not FOpened then
            FDialog.SendEvent(z3dceComboBoxChange, True, Self);
        end;
        Exit;
      end;

      VK_RIGHT, VK_DOWN:
      begin
        if (m_iFocused+1 < Integer(GetNumItems)) then
        begin
          Inc(m_iFocused);
          m_iSelected := m_iFocused;

          if not FOpened then
            FDialog.SendEvent(z3dceComboBoxChange, True, Self);
        end;
        Exit;
      end;
    end;
  end;

  Result:= False;
end;

function Tz3DComboBox.HandleMouse(uMsg: LongWord; pt: TPoint;
  wParam: WPARAM; lParam: LPARAM): Boolean;
var
  i: Integer;
  pItem: Pz3DComboBoxItem;
  zDelta: Integer;
  uLines: LongWord;
begin
  Result:= True;
  if (not FEnabled or not FVisible) then
  begin
    Result:= False;
    Exit;
  end;

  // Let the scroll bar handle it first.
  if m_ScrollBar.HandleMouse(uMsg, pt, wParam, lParam) then Exit;

  case uMsg of
    WM_MOUSEMOVE:
    begin
      if FOpened and PtInRect(FDropdown, pt) then
      begin
        // Determine which item has been selected
        for i:= 0 to Length(m_Items) - 1 do
        begin
          pItem := m_Items[i];
          if pItem.bVisible and PtInRect(pItem.rcActive, pt)
          then m_iFocused := i;
        end;
        Exit;
      end;
    end;

    WM_LBUTTONDOWN,
    WM_LBUTTONDBLCLK:
    begin
      if ContainsPoint(pt) then
      begin
        // Pressed while inside the control
        FPressed := True;
        SetCapture(z3DCore_GetHWND);

        if not FHasFocus then FDialog.RequestFocus(Self);

        // Toggle dropdown
        if FHasFocus then
        begin
          FOpened := not FOpened;

          if not FOpened then
            if not FDialog.IsKeyboardInputEnabled then FDialog.ClearFocus;
        end;
        Exit;
      end;

      // Perhaps this click is within the dropdown
      if FOpened and PtInRect(FDropdown, pt) then
      begin
        // Determine which item has been selected
        for i:= m_ScrollBar.TrackPos to Length(m_Items) - 1 do
        begin
          pItem := m_Items[i];
          if pItem.bVisible and PtInRect(pItem.rcActive, pt) then
          begin
            m_iSelected := i;
            m_iFocused := i;
            FDialog.SendEvent(z3dceComboBoxChange, True, Self);
            FOpened := False;

            if not FDialog.IsKeyboardInputEnabled then FDialog.ClearFocus;
            Break;
          end;
        end;

        Exit;
      end;

      // Mouse click not on main control or in dropdown, fire an event if needed
      if FOpened then
      begin
        m_iFocused := m_iSelected;

        FDialog.SendEvent(z3dceComboBoxChange, True, Self);
        FOpened := False;
      end;

      // Make sure the control is no longer in a pressed state
      FPressed := False;

      // Release focus if appropriate
      if not FDialog.IsKeyboardInputEnabled then FDialog.ClearFocus;
    end;

    WM_LBUTTONUP:
    begin
      if FPressed and ContainsPoint(pt) then
      begin
        // Button click
        FPressed := False;
        ReleaseCapture;
        Exit;
      end;
    end;

    WM_MOUSEWHEEL:
    begin
      zDelta := HIWORD(wParam) div WHEEL_DELTA;
      if FOpened then 
      begin
        SystemParametersInfo(SPI_GETWHEELSCROLLLINES, 0, @uLines, 0);
        m_ScrollBar.Scroll(-zDelta * Integer(uLines));
      end else
      begin
        if (zDelta > 0) then
        begin
          if (m_iFocused > 0) then
          begin
            Dec(m_iFocused);
            m_iSelected := m_iFocused;

            if not FOpened then
              FDialog.SendEvent(z3dceComboBoxChange, True, Self);
          end;
        end else
        begin
          if (m_iFocused + 1 < Integer(GetNumItems)) then
          begin
            Inc(m_iFocused);
            m_iSelected := m_iFocused;

            if not FOpened then
              FDialog.SendEvent(z3dceComboBoxChange, True, Self);
          end;
        end;
      end;
      Exit;
    end;
  end;
  Result:= False;
end;

procedure Tz3DComboBox.OnHotkey;
begin
  if FOpened then Exit;
  if (m_iSelected = -1) then Exit;

  if FDialog.IsKeyboardInputEnabled then FDialog.RequestFocus(Self);

  Inc(m_iSelected);
  if (m_iSelected >= Length(m_Items)) then m_iSelected := 0;

  m_iFocused := m_iSelected;
  FDialog.SendEvent(z3dceComboBoxChange, True, Self);
end;

procedure Tz3DComboBox.Render;
var
  iState: Tz3DControlState;
  pDisplay: Iz3DDisplay;
  pSelectionDisplay: Iz3DDisplay;
  pFont: Pz3DFontNode;
  curY: Integer;
  nRemainingHeight: Integer;
  i: Integer;
  pItem: Pz3DComboBoxItem;
  rc: TRect;
//  nOffsetX: Integer;
//  nOffsetY: Integer;
  fBlendRate: Single;
  rcWindow: TRect;
begin
  if not Visible then Exit;

  iState := z3dcsNormal;

  if not FOpened then iState := z3dcsHidden;

  // Dropdown box
  pDisplay := m_Displays[2];

  // If we have not initialized the scroll bar page size,
  // do that now.
  if not bSBInit then
  begin
    // Update the page size of the scroll bar
    if (FDialog.Manager.Fonts[pDisplay.Font].Height <> 0)
    then m_ScrollBar.SetPageSize(RectHeight(FDropdownText) div FDialog.Manager.Fonts[pDisplay.Font].Height)
    else m_ScrollBar.SetPageSize(RectHeight(FDropdownText));
    bSBInit := true;
  end;

  // Scroll bar
  if FOpened then
    m_ScrollBar.Render;

  // Blend current color
  pDisplay.TextureColor.Blend(iState);
  pDisplay.FontColor.Blend(iState);

  FDialog.DrawSprite(pDisplay, FDropdown);

  // Selection outline
  pSelectionDisplay := m_Displays[3];
  pSelectionDisplay.TextureColor.Current := pDisplay.TextureColor.Current;
  pSelectionDisplay.FontColor.Current := D3DXColorFromDWord(pSelectionDisplay.FontColor.States[z3dcsNormal]);

  pFont := FDialog.GetFont(pDisplay.Font);
  if Assigned(pFont) then
  begin
    curY := FDropdownText.top;
    nRemainingHeight := RectHeight(FDropdownText);

    for i := m_ScrollBar.TrackPos to Length(m_Items) - 1 do
    begin
      pItem := m_Items[i];

      // Make sure there's room left in the dropdown
      Dec(nRemainingHeight, pFont.Height);
      if (nRemainingHeight < 0) then
      begin
        pItem.bVisible := False;
        Continue;
      end;

      SetRect(pItem.rcActive, FDropdownText.left, curY, FDropdownText.right, curY + pFont.Height);
      Inc(curY, pFont.Height);
      pItem.bVisible := True;
      if FOpened then
      begin
        if (i = m_iFocused) then
        begin
          SetRect(rc, FDropdown.left, pItem.rcActive.top-2, FDropdown.right, pItem.rcActive.bottom+2);
          FDialog.DrawSprite(pSelectionDisplay, rc);
          FDialog.DrawText(pItem.strText, pSelectionDisplay, pItem.rcActive);
        end else
        FDialog.DrawText(pItem.strText, pDisplay, pItem.rcActive);
      end;
    end;
  end;

//  nOffsetX := 0;
//  nOffsetY := 0;

  iState := z3dcsNormal;

  if not FVisible then iState := z3dcsHidden
  else if not FEnabled then iState := z3dcsDisabled
  else if FPressed  then
  begin
    iState := z3dcsPressed;

//    nOffsetX := 1;
//    nOffsetY := 2;
  end
  else if FMouseOver then
  begin
    iState := z3dcsMouseOver;

//    nOffsetX := -1;
//    nOffsetY := -2;
  end
  else if FHasFocus then
    iState := z3dcsFocus;

  fBlendRate := IfThen(iState = z3dcsPressed, 0.0, 0.8);

  // Button
  pDisplay := m_Displays[1];

  // Blend current color
  pDisplay.TextureColor.Blend(iState, fBlendRate);

  rcWindow := FButton;
//  OffsetRect(rcWindow, nOffsetX, nOffsetY);
  FDialog.DrawSprite(pDisplay, rcWindow);

  if FOpened then iState := z3dcsPressed;
  pDisplay := m_Displays[0];

  // Blend current color
  pDisplay.TextureColor.Blend(iState, fBlendRate);
  pDisplay.FontColor.Blend(iState, fBlendRate);

  FDialog.DrawSprite(pDisplay, FText);

  if (m_iSelected >= 0) and (m_iSelected < Length(m_Items)) then
  begin
    pItem := m_Items[m_iSelected];
    if (pItem <> nil) then FDialog.DrawText(pItem.strText, pDisplay,
    Rect(FText.Left+10, FText.Top, FText.Right, FText.Bottom), Dialog.Manager.Desktop.ThemeSettings.DefaultFont.Shadow);
  end;
end;

function Tz3DComboBox.AddItem(const strText: PWideChar; pData: Pointer): HRESULT;
var
  pItem: Pz3DComboBoxItem;
  l: Integer;
begin
  // Validate parameters
  if (strText = nil) then
  begin
    Result:= E_INVALIDARG;
    Exit;
  end;

  // Create a new item and set the data
  try
    New(pItem);
  except
    Result:= DXTRACE_ERR_MSGBOX('new', E_OUTOFMEMORY);
    Exit;
  end;

  ZeroMemory(pItem, SizeOf(Tz3DComboBoxItem));
  StringCchCopy(pItem.strText, 256, strText);
  pItem.pData := pData;

  // m_Items.Add(pItem);
  l:= Length(m_Items);
  SetLength(m_Items, l+1);
  m_Items[l]:= pItem;

  // Update the scroll bar with new range
  m_ScrollBar.SetTrackRange(0, Length(m_Items));

  // If this is the only item in the list, it's selected
  if (GetNumItems = 1) then
  begin
    m_iSelected := 0;
    m_iFocused := 0;
    FDialog.SendEvent(z3dceComboBoxChange, False, Self);
  end;

  Result:= S_OK;
end;

procedure Tz3DComboBox.RemoveItem(index: LongWord);
var
  pItem: Pz3DComboBoxItem;
begin
  pItem := m_Items[index];
  Dispose(pItem);
  // m_Items.Remove(index);
  Move(m_Items[index+1], m_Items[index], (Length(m_Items)-Integer(index)-1)*SizeOf(Pz3DComboBoxItem));
  SetLength(m_Items, Length(m_Items)-1);

  m_ScrollBar.SetTrackRange(0, Length(m_Items));
  if (m_iSelected >= Length(m_Items)) then m_iSelected := Length(m_Items) - 1;
end;

procedure Tz3DComboBox.RemoveAllItems;
var
  i: Integer;
  pItem: Pz3DComboBoxItem;
begin
  for i:= 0 to Length(m_Items) - 1 do
  begin
    pItem := Pz3DComboBoxItem(m_Items[i]);
    Dispose(pItem);
  end;

  m_Items:= nil; // RemoveAll;
  m_ScrollBar.SetTrackRange(0, 1);
  m_iSelected := -1;
  m_iFocused := -1;
end;

function Tz3DComboBox.ContainsItem(const strText: PWideChar; iStart: LongWord = 0): Boolean;
begin
  Result:= (-1 <> FindItem(strText));
end;

function Tz3DComboBox.FindItem(const strText: PWideChar; iStart: LongWord = 0): Integer;
var
  i: Integer;
begin
  Result:= -1;
  if (strText = nil) then Exit;

  for i:= iStart to Length(m_Items) - 1 do
  begin
    if (lstrcmpW(m_Items[i].strText, strText) = 0) then
    begin
      Result:= i;
      Exit;
    end;
  end;
end;

function Tz3DComboBox.GetSelectedData: Pointer;
begin
  if (m_iSelected < 0) then Result:= nil
  else Result:= m_Items[m_iSelected].pData;
end;

function Tz3DComboBox.GetSelectedItem: Pz3DComboBoxItem;
begin
  if (m_iSelected < 0) then Result:= nil
  else Result:= m_Items[m_iSelected];
end;

function Tz3DComboBox.GetItemData(const strText: PWideChar): Pointer;
var
  index: Integer;
  pItem: Pz3DComboBoxItem;
begin
  Result:= nil;
  index := FindItem(strText);
  if (index = -1) then Exit;

  pItem := m_Items[index];
  if (pItem = nil) then
  begin
    DXTRACE_ERR('GetItemData', E_FAIL);
    Exit;
  end;

  Result:= pItem.pData;
end;

function Tz3DComboBox.GetItemData(nIndex: Integer): Pointer;
begin
  Result:= nil;
  if (nIndex < 0) or (nIndex >= Length(m_Items)) then Exit;

  Result:= m_Items[nIndex].pData;
end;

function Tz3DComboBox.SetSelectedByIndex(index: LongWord): HRESULT;
begin
  if (index >= GetNumItems) then
  begin
    Result:= E_INVALIDARG;
    Exit;
  end;

  m_iSelected := index;
  m_iFocused := index;
  FDialog.SendEvent(z3dceComboBoxChange, False, Self);

  Result:= S_OK;
end;

function Tz3DComboBox.SetSelectedByText(const strText: PWideChar): HRESULT;
var
  index: Integer;
begin
  if (strText = nil) then
  begin
    Result:= E_INVALIDARG;
    Exit;
  end;

  index := FindItem( strText);
  if (index = -1) then
  begin
    Result:= E_FAIL;
    Exit;
  end;

  m_iSelected := index;
  m_iFocused := index;
  FDialog.SendEvent(z3dceComboBoxChange, False, Self);

  Result:= S_OK;
end;

function Tz3DComboBox.SetSelectedByData(pData: Pointer): HRESULT;
var
  i: Integer;
begin
  for i:= 0 to Length(m_Items) - 1 do
  begin
    if (m_Items[i].pData = pData) then
    begin
      m_iSelected := i;
      m_iFocused := i;
      FDialog.SendEvent(z3dceComboBoxChange, False, Self);
      Result:= S_OK;
      Exit;
    end;
  end;

  Result:= E_FAIL;
end;

function Tz3DComboBox.CanHaveFocus: Boolean;
begin
  Result:= FVisible and FEnabled;
end;

function Tz3DComboBox.GetItem(index: LongWord): Pz3DComboBoxItem;
begin
  Result:= m_Items[index];
end;

function Tz3DComboBox.GetNumItems: LongWord;
begin
  Result:= Length(m_Items);
end;

function Tz3DComboBox.OnInit: HRESULT;
begin
  inherited OnInit;
  if FDialog <> nil then Result:= FDialog.InitControl(m_ScrollBar);
end;

procedure Tz3DComboBox.SetDropHeight(nHeight: LongWord);
begin
  FDropHeight := nHeight;
  UpdateRects;
end;

procedure Tz3DComboBox.SetScrollBarWidth(nWidth: Integer);
begin
  FSBWidth := nWidth;
  UpdateRects;
end;

procedure Tz3DComboBox.SetDialog(const Value: Iz3DDialog);
begin
  inherited;
  if FDialog <> nil then FDialog.InitControl(m_ScrollBar);
  m_ScrollBar.Dialog:= FDialog;
end;

function Tz3DComboBox.GetItemIndex: Integer;
begin
  Result:= m_iSelected;
end;

{ Tz3DTrackBar }

constructor Tz3DTrackBar.Create(const pDialog: Iz3DDialog);
begin
  inherited;
  m_Type := z3dctTrackBar;
  FDialog := pDialog;

  FMin := 0;
  FMax := 100;
  FValue := 50;

  FPressed := False;
end;

function Tz3DTrackBar.GetValue: Integer;
begin
  Result:= FValue;
end;

function Tz3DTrackBar.ContainsPoint(pt: TPoint): LongBool;
begin
  Result:= PtInRect(FBoundingBox, pt) or
           PtInRect(FButton, pt);
end;

procedure Tz3DTrackBar.UpdateRects;
begin
  inherited;

  FButton := FBoundingBox;
  FButton.right := FButton.left + RectHeight(FButton);
  OffsetRect(FButton, -RectWidth(FButton) div 2, 0);

  if (FMax - FMin) <> 0 then
  begin
    FButtonX := Trunc(((FValue - FMin) * RectWidth(FBoundingBox) / (FMax - FMin)));
    OffsetRect(FButton, FButtonX, 0);
  end;
end;

function Tz3DTrackBar.ValueFromPos(x: Integer): Integer;
var
  fValuePerPixel: Single;
begin
  fValuePerPixel := (FMax - FMin) / RectWidth(FBoundingBox);
  Result:= Trunc((0.5 + FMin + fValuePerPixel * (x - FBoundingBox.left)));
end;

function Tz3DTrackBar.HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  Result:= False;
  if not FEnabled or not FVisible then Exit;

  case uMsg of
    WM_KEYDOWN:
    begin
      Result:= True;
      case wParam of
        VK_HOME:          SetValueInternal(FMin, True);
        VK_END:           SetValueInternal(FMax, True);
        VK_LEFT, VK_DOWN: SetValueInternal(FValue - 1, True);
        VK_RIGHT, VK_UP:  SetValueInternal(FValue + 1, True);
        VK_NEXT:          SetValueInternal(FValue - IfThen(10 > (FMax - FMin) div 10, 10, (FMax - FMin) div 10), True);
        VK_PRIOR:         SetValueInternal(FValue + IfThen(10 > (FMax - FMin) div 10, 10, (FMax - FMin) div 10), True);
       else
        Result:= False;
      end;
      Exit;
    end;
  end;
end;

function Tz3DTrackBar.HandleMouse(uMsg: LongWord; pt: TPoint;
  wParam: WPARAM; lParam: LPARAM): Boolean;
var
  nScrollAmount: Integer;
begin
  if not FEnabled or not FVisible then
  begin
    Result:= False;
    Exit;
  end;

  Result:= True;

  case uMsg of
    WM_LBUTTONDOWN,
    WM_LBUTTONDBLCLK:
    begin
      if PtInRect(FButton, pt) then
      begin
        // Pressed while inside the control
        FPressed := True;
        SetCapture(z3DCore_GetHWND);

        FDragX := pt.x;
        //FDragY = pt.y;
        FDragOffset := FButtonX - FDragX;

        //FDragValue = FValue;

        if not FHasFocus then FDialog.RequestFocus(Self);
        Exit;
      end;

      if PtInRect(FBoundingBox, pt) then
      begin
        FDragX := pt.x;
        FDragOffset := 0;
        FPressed := True;

        if not FHasFocus then FDialog.RequestFocus(Self);

        if not FHasFocus then FDialog.RequestFocus(Self);

        if (pt.x > FButtonX + FLeft) then
        begin
          SetValueInternal(FValue + 1, True);
          Exit;
        end;

        if (pt.x < FButtonX + FLeft) then
        begin
          SetValueInternal(FValue - 1, True);
          Exit;
        end;
      end;
    end;

    WM_LBUTTONUP:
    begin
      if FPressed then
      begin
        FPressed := False;
        ReleaseCapture;
        FDialog.SendEvent(z3dceTrackBarChange, True, Self);
        Exit;
      end;
    end;

    WM_MOUSEMOVE:
    begin
      if FPressed then
      begin
        SetValueInternal(ValueFromPos(FLeft + pt.x + FDragOffset), True);
        Exit;
      end;
    end;

    WM_MOUSEWHEEL:
    begin
      nScrollAmount := Integer(ShortInt(HIWORD(wParam))) div WHEEL_DELTA;
      SetValueInternal(FValue - nScrollAmount, True);
      Exit;
    end;
  end;

  Result:= False;
end;

procedure Tz3DTrackBar.GetRange(out nMin, nMax: Integer);
begin
  nMin := FMin;
  nMax := FMax;
end;

procedure Tz3DTrackBar.SetRange(nMin, nMax: Integer);
begin
  FMin := nMin;
  FMax := nMax;
  SetValueInternal(FValue, False);
end;

procedure Tz3DTrackBar.SetValueInternal(nValue: Integer; bFromInput: Boolean);
begin
  // Clamp to range
  nValue := Max(FMin, nValue);
  nValue := Min(FMax, nValue);

  if (nValue = FValue) then Exit;

  FValue := nValue;
  UpdateRects;

  FDialog.SendEvent(z3dceTrackBarChange, bFromInput, Self);
end;

procedure Tz3DTrackBar.Render;
var
//  nOffsetX, nOffsetY: Integer;
  iState: Tz3DControlState;
  fBlendRate: Single;
  pDisplay: Iz3DDisplay;
begin
  if not Visible then Exit;

  // nOffsetX := 0; // - never used
  // nOffsetY := 0; // - never used

  iState := z3dcsNormal;

  if not FVisible then iState := z3dcsHidden
  else if not FEnabled then iState := z3dcsDisabled
  else if FPressed then
  begin
    iState := z3dcsPressed;
    // nOffsetX := 1; // - never used
    //nOffsetY := 2; // - never used
  end else if FMouseOver then
  begin
    iState := z3dcsMouseOver;

    // nOffsetX := -1; // - never used
    // nOffsetY := -2; // - never used
  end else if FHasFocus then
  begin
    iState := z3dcsFocus;
  end;

  fBlendRate := IfThen(iState = z3dcsPressed, 0.0, 0.8);

  pDisplay := m_Displays[0];

  // Blend current color
  pDisplay.TextureColor.Blend(iState, fBlendRate);
  FDialog.DrawSprite(pDisplay, FBoundingBox);

  //TODO: remove magic numbers
  pDisplay := m_Displays[1];

  // Blend current color
  pDisplay.TextureColor.Blend(iState, fBlendRate);
  FDialog.DrawSprite(pDisplay, FButton);
end;

function Tz3DTrackBar.CanHaveFocus: Boolean;
begin
  Result:= True;
end;

procedure Tz3DTrackBar.SetValue(nValue: Integer);
begin
  SetValueInternal(nValue, False);
end;

{ Tz3DProgressBar }

constructor Tz3DProgressBar.Create(const pDialog: Iz3DDialog);
begin
  inherited;
  m_Type := z3dctProgressBar;
  FDialog := pDialog;
  FMin := 0;
  FMax := 100;
  FValue := 50;
end;

function Tz3DProgressBar.GetValue: Integer;
begin
  Result:= FValue;
end;

function Tz3DProgressBar.ContainsPoint(pt: TPoint): LongBool;
begin
  Result:= PtInRect(FBoundingBox, pt);
end;

procedure Tz3DProgressBar.UpdateRects;
begin
  inherited;
  FProgress := FBoundingBox;
  InflateRect(FProgress, -2, -2);
  if (FMax - FMin) <> 0 then
  FProgress.Right:= FProgress.Left + Trunc(((FValue - FMin) * (RectWidth(FBoundingBox)-4) / (FMax - FMin))) else
  FProgress.Right:= FProgress.Left;
end;

function Tz3DProgressBar.ValueFromPos(x: Integer): Integer;
var
  fValuePerPixel: Single;
begin
  fValuePerPixel := (FMax - FMin) / RectWidth(FBoundingBox);
  Result:= Trunc((0.5 + FMin + fValuePerPixel * (x - FBoundingBox.left)));
end;

function Tz3DProgressBar.HandleKeyboard(uMsg: LongWord; wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  Result:= False;
end;

function Tz3DProgressBar.HandleMouse(uMsg: LongWord; pt: TPoint;
  wParam: WPARAM; lParam: LPARAM): Boolean;
begin
  Result:= False;
end;

procedure Tz3DProgressBar.GetRange(out nMin, nMax: Integer);
begin
  nMin := FMin;
  nMax := FMax;
end;

procedure Tz3DProgressBar.SetRange(nMin, nMax: Integer);
begin
  FMin := nMin;
  FMax := nMax;
  SetValueInternal(FValue, False);
end;

procedure Tz3DProgressBar.SetValueInternal(nValue: Integer; bFromInput: Boolean);
begin
  // Clamp to range
  nValue := Max(FMin, nValue);
  nValue := Min(FMax, nValue);
  if (nValue = FValue) then Exit;
  FValue := nValue;
  UpdateRects;
end;

procedure Tz3DProgressBar.Render;
var
//  nOffsetX, nOffsetY: Integer;
  iState: Tz3DControlState;
  fBlendRate: Single;
  pDisplay: Iz3DDisplay;
begin
  if not Visible then Exit;

  // nOffsetX := 0; // - never used
  // nOffsetY := 0; // - never used

  iState := z3dcsNormal;

  if not FVisible then iState := z3dcsHidden
  else if not FEnabled then iState := z3dcsDisabled
  else if FHasFocus then
  begin
    iState := z3dcsFocus;
  end;

  fBlendRate := IfThen(iState = z3dcsPressed, 0.0, 0.8);

  pDisplay := m_Displays[0];

  // Blend current color
  pDisplay.TextureColor.Blend(iState, fBlendRate);
  FDialog.DrawSprite(pDisplay, FBoundingBox);

  //TODO: remove magic numbers
  pDisplay := m_Displays[1];

  // Blend current color
  pDisplay.TextureColor.Blend(iState, fBlendRate);
  FDialog.DrawSprite(pDisplay, FProgress);
end;

function Tz3DProgressBar.CanHaveFocus: Boolean;
begin
  Result:= True;
end;

procedure Tz3DProgressBar.SetValue(nValue: Integer);
begin
  SetValueInternal(nValue, False);
end;

var
  s_bHideCaret: Boolean; // If true, we don't render the caret.


{ Tz3DUniBuffer }

type
  TUSP_ScriptApplyDigitSubstitution = function (
    const psds: PScriptDigitSubstitute;   // In   Digit substitution settings
    psc: PScriptControl;                  // Out  Script control structure
    pss: PScriptState                     // Out  Script state structure
    ): HRESULT; stdcall;

  TUSP_ScriptStringAnalyse = function (
    hdc: HDC;                  //In  Device context (required)
    const pString: Pointer;    //In  String in 8 or 16 bit characters
    cString: Integer;          //In  Length in characters (Must be at least 1)
    cGlyphs: Integer;          //In  Required glyph buffer size (default cString*1.5 + 16)
    iCharset: Integer;         //In  Charset if an ANSI string, -1 for a Unicode string
    dwFlags: DWORD;            //In  Analysis required
    iReqWidth: Integer;        //In  Required width for fit and/or clip
    psControl: PScriptControl; //In  Analysis control (optional)
    psState: PScriptState;     //In  Analysis initial state (optional)
    const piDx: PInteger;      //In  Requested logical dx array
    pTabdef: PScriptTabDef;    //In  Tab positions (optional)
    const pbInClass: PByte;    //In  Legacy GetCharacterPlacement character classifications (deprecated)

    pssa:  PScriptStringAnalysis //Out Analysis of string
    ): HRESULT; stdcall;

  TUSP_ScriptStringCPtoX = function (
    ssa: TScriptStringAnalysis;        //In  String analysis
    icp: Integer;                      //In  Caret character position
    fTrailing: BOOL;                   //In  Which edge of icp
    out pX: Integer                    //Out Corresponding x offset
    ): HRESULT; stdcall;

  TUSP_ScriptStringXtoCP = function (
    ssa: TScriptStringAnalysis;        // In
    iX: Integer;                       // In
    piCh: PInteger;                    // Out
    piTrailing: PInteger               // Out
    ): HRESULT; stdcall;

  TUSP_ScriptStringFree = function (
    pssa: PScriptStringAnalysis  //InOut Address of pointer to analysis
    ): HRESULT; stdcall;

  TUSP_ScriptString_pLogAttr = function (
    ssa: TScriptStringAnalysis
    ): {const} PScriptLogAttr; stdcall;

  TUSP_ScriptString_pcOutChars = function (
    ssa: TScriptStringAnalysis
    ): {const} PInteger; stdcall; 


// Empty implementation of the Uniscribe API
function Dummy_ScriptApplyDigitSubstitution(
    const psds: PScriptDigitSubstitute;   // In   Digit substitution settings
    psc: PScriptControl;                  // Out  Script control structure
    pss: PScriptState                     // Out  Script state structure
    ): HRESULT; stdcall;
begin Result:= E_NOTIMPL; end;

function Dummy_ScriptStringAnalyse(
    hdc: HDC;                  //In  Device context (required)
    const pString: Pointer;    //In  String in 8 or 16 bit characters
    cString: Integer;          //In  Length in characters (Must be at least 1)
    cGlyphs: Integer;          //In  Required glyph buffer size (default cString*1.5 + 16)
    iCharset: Integer;         //In  Charset if an ANSI string, -1 for a Unicode string
    dwFlags: DWORD;            //In  Analysis required
    iReqWidth: Integer;        //In  Required width for fit and/or clip
    psControl: PScriptControl; //In  Analysis control (optional)
    psState: PScriptState;     //In  Analysis initial state (optional)
    const piDx: PInteger;      //In  Requested logical dx array
    pTabdef: PScriptTabDef;    //In  Tab positions (optional)
    const pbInClass: PByte;    //In  Legacy GetCharacterPlacement character classifications (deprecated)

    pssa:  PScriptStringAnalysis //Out Analysis of string
    ): HRESULT; stdcall;
begin Result:= E_NOTIMPL; end;

function Dummy_ScriptStringCPtoX(
    ssa: TScriptStringAnalysis;        //In  String analysis
    icp: Integer;                      //In  Caret character position
    fTrailing: BOOL;                   //In  Which edge of icp
    out pX: Integer                    //Out Corresponding x offset
    ): HRESULT; stdcall;
begin Result:= E_NOTIMPL; end;

function Dummy_ScriptStringXtoCP(
    ssa: TScriptStringAnalysis;        // In
    iX: Integer;                       // In
    piCh: PInteger;                    // Out
    piTrailing: PInteger               // Out
    ): HRESULT; stdcall;
begin Result:= E_NOTIMPL; end;

function Dummy_ScriptStringFree(
    pssa: PScriptStringAnalysis  //InOut Address of pointer to analysis
    ): HRESULT; stdcall; 
begin Result:= E_NOTIMPL; end;

function Dummy_ScriptString_pLogAttr(
    ssa: TScriptStringAnalysis
    ): {const} PScriptLogAttr; stdcall;
begin Result:= nil; end;

function Dummy_ScriptString_pcOutChars(
    ssa: TScriptStringAnalysis
    ): {const} PInteger; stdcall;
begin Result:= nil; end;

var
  // Function pointers
  _ScriptApplyDigitSubstitution: TUSP_ScriptApplyDigitSubstitution = Dummy_ScriptApplyDigitSubstitution;
  _ScriptStringAnalyse: TUSP_ScriptStringAnalyse = Dummy_ScriptStringAnalyse;
  _ScriptStringCPtoX: TUSP_ScriptStringCPtoX = Dummy_ScriptStringCPtoX;
  _ScriptStringXtoCP: TUSP_ScriptStringXtoCP = Dummy_ScriptStringXtoCP;
  _ScriptStringFree: TUSP_ScriptStringFree = Dummy_ScriptStringFree;
  _ScriptString_pLogAttr: TUSP_ScriptString_pLogAttr = Dummy_ScriptString_pLogAttr;
  _ScriptString_pcOutChars: TUSP_ScriptString_pcOutChars = Dummy_ScriptString_pcOutChars;

  s_hDll: THandle {HINSTANCE} = 0; // Uniscribe DLL handle

{ Tz3DUniBuffer }

constructor Tz3DUniBuffer.Create(nInitialSize: Integer);
begin
  Tz3DUniBuffer.Initialize;
  FBufferSize := 0;
  FwszBuffer := nil;
  FAnalyseRequired := True;
  m_Analysis := nil;
  FFontNode := nil;
  if (nInitialSize > 0) then SetBufferSize(nInitialSize);
end;

destructor Tz3DUniBuffer.Destroy;
begin
  FreeMem(FwszBuffer);
  if (m_Analysis <> nil) then _ScriptStringFree(@m_Analysis);
  inherited;
end;

function Tz3DUniBuffer.GetBufferSize: Integer;
begin
  Result:= FBufferSize;
end;

function Tz3DUniBuffer.GetFontNode: Pz3DFontNode;
begin
  Result:= FFontNode;
end;

function Tz3DUniBuffer.GetwszBuffer: PWideChar;
begin
  Result:= FwszBuffer;
end;

procedure Tz3DUniBuffer.SetFontNode(const Value: Pz3DFontNode);
begin
  FFontNode:= Value;
end;

class procedure Tz3DUniBuffer.Initialize;
var
  wszPath: array[0..MAX_PATH] of WideChar;
  len1, len2: Integer;
  temp: FARPROC;
begin
  if (s_hDll <> 0) then Exit; // Only need to do once

  if (GetSystemDirectoryW(wszPath, MAX_PATH+1) = 0) then Exit;

  // Verify whether it is safe to concatenate these strings
  len1 := lstrlenW(wszPath);
  len2 := lstrlenW(UNISCRIBE_DLLNAME);
  if (len1 + len2 > MAX_PATH) then Exit;

  // We have verified that the concatenated string will fit into wszPath,
  // so it is safe to concatenate them.
  StringCchCat(wszPath, MAX_PATH, UNISCRIBE_DLLNAME);

  s_hDll := LoadLibraryW(wszPath);
  if (s_hDll <> 0) then
  begin
    temp:= GetProcAddress(s_hDll, 'ScriptApplyDigitSubstitution'); if (temp<>nil) then _ScriptApplyDigitSubstitution:= temp;
    temp:= GetProcAddress(s_hDll, 'ScriptStringAnalyse'); if (temp<>nil) then _ScriptStringAnalyse:= temp;
    temp:= GetProcAddress(s_hDll, 'ScriptStringCPtoX'); if (temp<>nil) then _ScriptStringCPtoX:= temp;
    temp:= GetProcAddress(s_hDll, 'ScriptStringXtoCP'); if (temp<>nil) then _ScriptStringXtoCP:= temp;
    temp:= GetProcAddress(s_hDll, 'ScriptStringFree'); if (temp<>nil) then _ScriptStringFree:= temp;
    temp:= GetProcAddress(s_hDll, 'ScriptString_pLogAttr'); if (temp<>nil) then _ScriptString_pLogAttr:= temp;
    temp:= GetProcAddress(s_hDll, 'ScriptString_pcOutChars'); if (temp<>nil) then _ScriptString_pcOutChars:= temp;
  end;
end;

class procedure Tz3DUniBuffer.Uninitialize;
begin
  if (s_hDll <> 0) then
  begin
    _ScriptApplyDigitSubstitution := Dummy_ScriptApplyDigitSubstitution;
    _ScriptStringAnalyse := Dummy_ScriptStringAnalyse;
    _ScriptStringCPtoX := Dummy_ScriptStringCPtoX;
    _ScriptStringXtoCP := Dummy_ScriptStringXtoCP;
    _ScriptStringFree := Dummy_ScriptStringFree;
    _ScriptString_pLogAttr := Dummy_ScriptString_pLogAttr;
    _ScriptString_pcOutChars:= Dummy_ScriptString_pcOutChars;

    FreeLibrary(s_hDll);
    s_hDll := 0;
  end;
end;

function Tz3DUniBuffer.SetBufferSize(nNewSize: Integer): Boolean;
var
  nAllocateSize: Integer;
  pTempBuffer: PWideChar;
begin
  // If the current size is already the maximum allowed,
  // we can't possibly allocate more.
  if (FBufferSize = z3D_MAX_EDITBOXLENGTH) then
  begin
    Result:= False;
    Exit;
  end;

  nAllocateSize := IfThen((nNewSize = -1) or (nNewSize < FBufferSize * 2),
                     IfThen((FBufferSize <> 0), FBufferSize * 2, 256), nNewSize * 2);

  // Cap the buffer size at the maximum allowed.
  if (nAllocateSize > z3D_MAX_EDITBOXLENGTH) then
    nAllocateSize := z3D_MAX_EDITBOXLENGTH;

  try
    GetMem(pTempBuffer, SizeOf(WideChar) * nAllocateSize);
  except
    Result:= False;
    Exit;
  end;

  if (FwszBuffer <> nil) then
  begin
    CopyMemory(pTempBuffer, FwszBuffer, (lstrlenW(FwszBuffer) + 1) * SizeOf(WideChar));
    FreeMem(FwszBuffer);
  end else
    ZeroMemory(pTempBuffer, SizeOf(WideChar) * nAllocateSize);

  FwszBuffer := pTempBuffer;
  FBufferSize := nAllocateSize;
  Result:= True;
end;

// Uniscribe -- Analyse() analyses the string in the buffer

function Tz3DUniBuffer.Analyse: HRESULT;
var
  ScriptControl: TScriptControl; // For uniscribe
  ScriptState:   TScriptState;   // For uniscribe
begin
  if (m_Analysis <> nil) then _ScriptStringFree(@m_Analysis);

  ZeroMemory(@ScriptControl, SizeOf(ScriptControl));
  ZeroMemory(@ScriptState, SizeOf(ScriptState));
  _ScriptApplyDigitSubstitution(nil, @ScriptControl, @ScriptState);

  if (FFontNode = nil) then
  begin
    Result:= E_FAIL;
    Exit;
  end;

  Result := _ScriptStringAnalyse(IfThen(Assigned(FFontNode.Font), FFontNode.Font.GetDC, 0),
                                 FwszBuffer,
                                 lstrlenW(FwszBuffer) + 1,  // nil is also analyzed.
                                 lstrlenW(FwszBuffer) * 3 div 2 + 16,
                                 -1,
                                 SSA_BREAK or SSA_GLYPHS or SSA_FALLBACK or SSA_LINK,
                                 0,
                                 @ScriptControl,
                                 @ScriptState,
                                 nil,
                                 nil,
                                 nil,
                                 @m_Analysis);
  if SUCCEEDED(Result) then FAnalyseRequired := False;  // Analysis is up-to-date
end;

function Tz3DUniBuffer.GetTextSize: Integer; { return lstrlenW( FwszBuffer ); }
begin
  Result:= lstrlenW(FwszBuffer);
end;

function Tz3DUniBuffer.GetChar(i: Integer): WideChar; // No param checking
begin
  Result:= FwszBuffer[i];
end;

procedure Tz3DUniBuffer.SetChar(i: Integer; ch: WideChar);
begin
  // This version of operator[] is called only
  // if we are asking for write access, so
  // re-analysis is required.
  FAnalyseRequired := True;
  FwszBuffer[i]:= ch;
end;

procedure Tz3DUniBuffer.Clear;
begin
  FwszBuffer^ := #0;
  FAnalyseRequired := True;
end;

// Inserts the char at specified index.
// If nIndex == -1, insert to the end.

function Tz3DUniBuffer.InsertChar(nIndex: Integer; wChar: WideChar): Boolean;
var
  dest, stop, src: PWideChar;
begin
  Assert(nIndex >= 0);
  Result:= False;

  if (nIndex < 0) or (nIndex > lstrlenW(FwszBuffer)) then Exit;  // invalid index

  // Check for maximum length allowed
  if (TextSize + 1 >= z3D_MAX_EDITBOXLENGTH) then Exit;

  if (lstrlenW(FwszBuffer) + 1 >= FBufferSize) then
  begin
    if not SetBufferSize(-1) then Exit;  // out of memory
  end;

  Assert(FBufferSize >= 2);

//  MoveMemory(FwszBuffer + nIndex + 1, FwszBuffer + nIndex, SizeOf(WideChar) * (lstrlenW(FwszBuffer) - nIndex + 1));
  // Shift the characters after the index, start by copying the null terminator
  dest := FwszBuffer + lstrlenW(FwszBuffer)+1;
  //todo: new! replace lstrlenW
  stop := FwszBuffer + nIndex;
  src := dest - 1;

  while (dest > stop) do
  begin
    dest^ := src^;
    Dec(dest); Dec(src);
  end;

  // Set new character
  FwszBuffer[nIndex] := wChar;
  FAnalyseRequired := True;

  Result:= True;
end;

// Removes the char at specified index.
// If nIndex == -1, remove the last char.

function Tz3DUniBuffer.RemoveChar(nIndex: Integer): Boolean;
begin
  if (lstrlenW(FwszBuffer)=0) or (nIndex < 0) or (nIndex >= lstrlenW(FwszBuffer)) then
  begin
    Result:= False;  // Invalid index
    Exit;
  end;

  MoveMemory(FwszBuffer + nIndex, FwszBuffer + nIndex + 1, SizeOf(WideChar) * (lstrlenW(FwszBuffer) - nIndex));
  FAnalyseRequired := True;
  Result:= True;
end;

// Inserts the first nCount characters of the string pStr at specified index.
// If nCount == -1, the entire string is inserted.
// If nIndex == -1, insert to the end.

function Tz3DUniBuffer.InsertString(nIndex: Integer; const pStr: PWideChar; nCount: Integer = -1): Boolean;
begin
  Assert(nIndex >= 0);
  Result:= False;

  if (nIndex > lstrlenW(FwszBuffer)) then Exit; // invalid index

  if (-1 = nCount) then nCount := lstrlenW(pStr);

  // Check for maximum length allowed
  if (TextSize + nCount >= z3D_MAX_EDITBOXLENGTH) then Exit;

  if (lstrlenW(FwszBuffer) + nCount >= FBufferSize) then 
  begin
    if not SetBufferSize(lstrlenW(FwszBuffer) + nCount + 1) then Exit; // out of memory
  end;

  MoveMemory(FwszBuffer + nIndex + nCount, FwszBuffer + nIndex, SizeOf(WideChar) * (lstrlenW(FwszBuffer) - nIndex + 1));
  CopyMemory(FwszBuffer + nIndex, pStr, nCount * SizeOf(WideChar));
  FAnalyseRequired := True;

  Result:= True;
end;

procedure Tz3DUniBuffer.SetText(wszText: PWideChar);
var
  nRequired: Integer;
begin
  Assert(wszText <> nil);

  nRequired := lstrlenW(wszText) + 1;

  // Check for maximum length allowed
  if (nRequired >= z3D_MAX_EDITBOXLENGTH) then
    raise EOutOfMemory.Create('Tz3DUniBuffer.SetText - max length reached'); // Result:= False;
  {begin
    Result:= False;
    Exit;
  end;}

  while (BufferSize < nRequired) do
    if not SetBufferSize(-1) then Break;
  // Check again in case out of memory occurred inside while loop.
  if (BufferSize >= nRequired) then
  begin
    StringCchCopy(FwszBuffer, BufferSize, wszText);
    FAnalyseRequired := True;
    // Result:= True;
  end else
    raise EOutOfMemory.Create('Tz3DUniBuffer.Grow'); // Result:= False;
end;

function Tz3DUniBuffer.CPtoX(nCP: Integer; bTrail: BOOL;
  out pX: Integer): HRESULT;
begin
  // Assert(pX <> nil);
  pX := 0;  // Default

  Result := S_OK;
  if FAnalyseRequired then Result := Analyse;

  if SUCCEEDED(Result) then
    Result := _ScriptStringCPtoX(m_Analysis, nCP, bTrail, pX);
end;

function Tz3DUniBuffer.XtoCP(nX: Integer; out pCP: Integer; out pnTrail: LongBool): HRESULT;
begin
  // assert( pCP && pnTrail );
  pCP := 0; pnTrail := False;  // Default

  Result := S_OK;
  if FAnalyseRequired then Result := Analyse;

  if SUCCEEDED(Result) then
    Result := _ScriptStringXtoCP(m_Analysis, nX, @pCP, @pnTrail);

  // If the coordinate falls outside the text region, we
  // can get character positions that don't exist.  We must
  // filter them here and convert them to those that do exist.
  if (pCP = -1) and (pnTrail = TRUE) then
  begin
    pCP := 0; pnTrail := False;
  end else
  if (pCP > lstrlenW(FwszBuffer)) and (pnTrail = False) then
  begin
    pCP := lstrlenW(FwszBuffer); pnTrail := True;
  end;
end;

type
  TScriptLogAttrArray = array[0..MaxInt div SizeOf(TScriptLogAttr)-1] of TScriptLogAttr;
  PScriptLogAttrArray = ^TScriptLogAttrArray;

procedure Tz3DUniBuffer.GetPriorItemPos(nCP: Integer; out pPrior: Integer);
var
  pLogAttr: PScriptLogAttrArray;
  nInitial: Integer;
  i: Integer;
begin
  pPrior := nCP;  // Default is the char itself

  if FAnalyseRequired then
    if FAILED(Analyse) then Exit;

  pLogAttr := PScriptLogAttrArray(_ScriptString_pLogAttr(m_Analysis));
  if (pLogAttr = nil) then Exit;

  if (_ScriptString_pcOutChars(m_Analysis) = nil) then Exit;

  nInitial := _ScriptString_pcOutChars(m_Analysis)^;
  if (nCP - 1 < nInitial) then nInitial := nCP - 1;

  for i := nInitial downto 1 do
    if (fWordStop in pLogAttr[i]) or   // Either the fWordStop flag is set
       (fWhiteSpace in pLogAttr[i]) or  // Or the previous char is whitespace but this isn't.
       (fWhiteSpace in pLogAttr[i-1]) then
    begin
      pPrior := i;
      Exit;
    end;
  // We have reached index 0.  0 is always a break point, so simply return it.
  pPrior := 0;
end;

procedure Tz3DUniBuffer.GetNextItemPos(nCP: Integer; out pPrior: Integer);
var
  pLogAttr: PScriptLogAttrArray;
  nInitial: Integer;
  i: Integer;
begin
  pPrior := nCP;  // Default is the char itself

  if FAnalyseRequired then
    if FAILED(Analyse) then Exit;

  pLogAttr := PScriptLogAttrArray(_ScriptString_pLogAttr(m_Analysis));
  if (pLogAttr = nil) then Exit;

  if (_ScriptString_pcOutChars(m_Analysis) = nil) then Exit;

  nInitial := _ScriptString_pcOutChars(m_Analysis)^;
  if (nCP + 1 < nInitial) then nInitial := nCP + 1;

  for i := nInitial to _ScriptString_pcOutChars(m_Analysis)^ - 2 do
  begin
    if (fWordStop in pLogAttr[i]) then      // Either the fWordStop flag is set
    begin
      pPrior := i;
      Exit;
    end
    else
    if (fWhiteSpace in pLogAttr[i]) and // Or this whitespace but the next char isn't.
       (fWhiteSpace in pLogAttr[i+1]) then
    begin
      pPrior := i+1;  // The next char is a word stop
      Exit;
    end;
  end;
  // We have reached the end. It's always a word stop, so simply return it.
  pPrior := _ScriptString_pcOutChars(m_Analysis)^ - 1;
end;

{ Tz3DEdit }

constructor Tz3DEdit.Create(const pDialog: Iz3DDialog);
begin
  inherited;
  m_Buffer:= Tz3DUniBuffer.Create;

  m_Type := z3dctEdit;
  FDialog := pDialog;

  FBorder := 4;  // Default border width
  FSpacing := 0;  // Default spacing

  FCaretOn := True;
  m_dfBlink := GetCaretBlinkTime * 0.001;
  m_dfLastBlink := z3DCore_GetGlobalTimer.AbsoluteTime;
  s_bHideCaret := False;
  FFirstVisible := 0;
  m_TextColor := D3DCOLOR_ARGB(255, 16, 16, 16);
  m_SelTextColor := D3DCOLOR_ARGB(255, 255, 255, 255);
  m_SelBkColor := D3DCOLOR_ARGB(255, 40, 50, 92);
  m_CaretColor := D3DCOLOR_ARGB(255, 0, 0, 0);
  FSelStart := 0;
  FCaret := 0;
  FInsertMode := True;

  FMouseDrag := False;
end;

destructor Tz3DEdit.Destroy;
begin
  FreeAndNil(m_Buffer);
  inherited;
end;

function Tz3DEdit.GetBorder: Integer;
begin
  Result:= FBorder;
end;

function Tz3DEdit.GetCaretColor: TD3DColor;
begin
  Result:= m_CaretColor;
end;

function Tz3DEdit.GetSelBkColor: TD3DColor;
begin
  Result:= m_SelBkColor;
end;

function Tz3DEdit.GetSelTextColor: TD3DColor;
begin
  Result:= m_SelTextColor;
end;

function Tz3DEdit.GetSpacing: Integer;
begin
  Result:= FSpacing;
end;

function Tz3DEdit.GetTextColor: TD3DColor;
begin
  Result:= m_TextColor;
end;

procedure Tz3DEdit.SetSelBkColor(const Value: TD3DColor);
begin
  m_SelBkColor:= Value;
end;

procedure Tz3DEdit.SetSelTextColor(const Value: TD3DColor);
begin
  m_SelTextColor:= Value;
end;

procedure Tz3DEdit.SetCaretColor(const Value: TD3DColor);
begin
  m_CaretColor:= Value;
end;

procedure Tz3DEdit.PlaceCaret(nCP: Integer);
var
  nX1st, nX, nX2: Integer;
  nXNewLeft: Integer;
  nCPNew1st: Integer;
  nNewTrail: LongBool;
  nXNew1st: Integer;
begin
  Assert((nCP >= 0) and (nCP <= m_Buffer.TextSize));
  FCaret := nCP;

  // Obtain the X offset of the character.
  m_Buffer.CPtoX(FFirstVisible, False, nX1st);  // 1st visible char
  m_Buffer.CPtoX(nCP, False, nX);  // LEAD
  // If nCP is the NULL terminator, get the leading edge instead of trailing.
  if (nCP = m_Buffer.TextSize) then nX2 := nX
  else m_Buffer.CPtoX(nCP, True, nX2);  // TRAIL

  // If the left edge of the char is smaller than the left edge of the 1st visible char,
  // we need to scroll left until this char is visible.
  if (nX < nX1st) then
  begin
    // Simply make the first visible character the char at the new caret position.
    FFirstVisible := nCP;
  end else
  // If the right of the character is bigger than the offset of the control's
  // right edge, we need to scroll right to this character.
  if (nX2 > nX1st + RectWidth(FText)) then
  begin
    // Compute the X of the new left-most pixel
    nXNewLeft := nX2 - RectWidth(FText);

    // Compute the char position of this character
    m_Buffer.XtoCP(nXNewLeft, nCPNew1st, nNewTrail);

    // If this coordinate is not on a character border,
    // start from the next character so that the caret
    // position does not fall outside the text rectangle.
    m_Buffer.CPtoX(nCPNew1st, False, nXNew1st);
    if (nXNew1st < nXNewLeft) then Inc(nCPNew1st);

    FFirstVisible := nCPNew1st;
  end;
end;

procedure Tz3DEdit.ClearText;
begin
  m_Buffer.Clear;
  FFirstVisible := 0;
  PlaceCaret(0);
  FSelStart := 0;
end;

procedure Tz3DEdit.SetText(wszText: PWideChar; bSelected: Boolean);
begin
  Assert(wszText <> nil);

  m_Buffer.SetText(wszText);
  FFirstVisible := 0;
  // Move the caret to the end of the text
  PlaceCaret(m_Buffer.TextSize);
  FSelStart := IfThen(bSelected, 0, FCaret);
end;

function Tz3DEdit.GetTextCopy(strDest: PWideChar; bufferCount: LongWord): HRESULT;
begin
  Assert(Assigned(strDest));
  StringCchCopy(strDest, bufferCount, m_Buffer.Buffer);
  Result:= S_OK;
end;

procedure Tz3DEdit.DeleteSelectionText;
var
  nFirst, nLast: Integer;
  i: Integer;
begin
  nFirst := Min(FCaret, FSelStart);
  nLast := Max(FCaret, FSelStart);
  // Update caret and selection
  PlaceCaret(nFirst);
  FSelStart := FCaret;
  // Remove the characters
  for i := nFirst to nLast - 1 do m_Buffer.RemoveChar(nFirst);
end;

procedure Tz3DEdit.UpdateRects;
begin
  inherited;

  // Update the text rectangle
  FText := FBoundingBox;
  // First inflate by FBorder to compute render rects
  InflateRect(FText, -FBorder, -FBorder);

  // Update the render rectangles
  FRender[0] := FText;
  SetRect(FRender[1], FBoundingBox.left, FBoundingBox.top, FText.left, FText.top);
  SetRect(FRender[2], FText.left, FBoundingBox.top, FText.right, FText.top);
  SetRect(FRender[3], FText.right, FBoundingBox.top, FBoundingBox.right, FText.top);
  SetRect(FRender[4], FBoundingBox.left, FText.top, FText.left, FText.bottom);
  SetRect(FRender[5], FText.right, FText.top, FBoundingBox.right, FText.bottom);
  SetRect(FRender[6], FBoundingBox.left, FText.bottom, FText.left, FBoundingBox.bottom);
  SetRect(FRender[7], FText.left, FText.bottom, FText.right, FBoundingBox.bottom);
  SetRect(FRender[8], FText.right, FText.bottom, FBoundingBox.right, FBoundingBox.bottom);

  // Inflate further by FSpacing
  InflateRect(FText, -FSpacing, -FSpacing);
end;

procedure Tz3DEdit.CopyToClipboard;
var
  hBlock: HGLOBAL;
  pwszText: PWideChar;
  nFirst, nLast: Integer;
begin
  // Copy the selection text to the clipboard
  if (FCaret <> FSelStart) and OpenClipboard(0) then
  begin
    EmptyClipboard;

    hBlock := GlobalAlloc(GMEM_MOVEABLE, SizeOf(WideChar) * (m_Buffer.TextSize + 1));
    if (hBlock <> 0) then
    begin
      pwszText := GlobalLock(hBlock);
      if (pwszText <> nil) then
      begin
        nFirst := Min(FCaret, FSelStart);
        nLast := Max(FCaret, FSelStart);
        if (nLast - nFirst > 0) then
          CopyMemory(pwszText, m_Buffer.Buffer + nFirst, (nLast - nFirst) * SizeOf(WideChar));
        pwszText[nLast - nFirst] := #0;  // Terminate it
        GlobalUnlock(hBlock);
      end;
      SetClipboardData(CF_UNICODETEXT, hBlock);
    end;
    CloseClipboard;
    // We must not free the object until CloseClipboard is called.
    if (hBlock <> 0) then GlobalFree(hBlock);
  end;
end;

procedure Tz3DEdit.PasteFromClipboard;
var
  handle: THandle;
  pwszText: PWideChar;
begin
  DeleteSelectionText;

  if OpenClipboard(0) then
  begin
    handle := GetClipboardData( CF_UNICODETEXT);
    if (handle <> 0) then
    begin
      // Convert the ANSI string to Unicode, then
      // insert to our buffer.
      pwszText := GlobalLock(handle);
      if (pwszText <> nil) then
      begin
        // Copy all characters up to null.
        if m_Buffer.InsertString(FCaret, pwszText) then
          PlaceCaret(FCaret + lstrlenW(pwszText));
        FSelStart := FCaret;
        GlobalUnlock(handle);
      end;
    end;
    CloseClipboard;
  end;
end;

function Tz3DEdit.HandleKeyboard(uMsg: LongWord; wParam: WPARAM;
  lParam: LPARAM): Boolean;
var
  bHandled: Boolean;
begin
  Result:= False;
  if (not FEnabled or not FVisible) then Exit;

  bHandled := False;

  case uMsg of
    WM_KEYDOWN:
    begin
      case wParam of
        VK_TAB: ;
          // We don't process Tab in case keyboard input is enabled and the user
          // wishes to Tab to other controls.
        //todo: is it as designed?

        VK_HOME:
        begin
          PlaceCaret(0);
          if (GetKeyState(VK_SHIFT) >= 0) then
          begin
            // Shift is not down. Update selection
            // start along with the caret.
            FSelStart := FCaret;
          end;
          ResetCaretBlink;
          bHandled := True;
        end;

        VK_END:
        begin
          PlaceCaret(m_Buffer.TextSize);
          if (GetKeyState(VK_SHIFT) >= 0) then
              // Shift is not down. Update selection
              // start along with the caret.
              FSelStart := FCaret;
          ResetCaretBlink;
          bHandled := True;
        end;

        VK_INSERT:
        begin
          if (GetKeyState(VK_CONTROL) < 0) then
          begin
            // Control Insert. Copy to clipboard
            CopyToClipboard;
          end else
          if (GetKeyState(VK_SHIFT) < 0) then 
          begin
            // Shift Insert. Paste from clipboard
            PasteFromClipboard();
          end else
          begin
            // Toggle caret insert mode
            FInsertMode := not FInsertMode;
          end;
        end;

        VK_DELETE:
        begin
          // Check if there is a text selection.
          if (FCaret <> FSelStart) then
          begin
            DeleteSelectionText;
            FDialog.SendEvent(z3dceEditChange, True, Self);
          end else
          begin
            // Deleting one character
            if (m_Buffer.RemoveChar(FCaret)) then
              FDialog.SendEvent(z3dceEditChange, True, Self);
          end;
          ResetCaretBlink;
          bHandled := True;
        end;

        VK_LEFT:
        begin
          if (GetKeyState(VK_CONTROL) < 0) then
          begin
            // Control is down. Move the caret to a new item
            // instead of a character.
            m_Buffer.GetPriorItemPos(FCaret, FCaret);
            PlaceCaret(FCaret);
          end else
          if (FCaret > 0) then PlaceCaret( FCaret - 1);
          if (GetKeyState(VK_SHIFT) >= 0) then
            // Shift is not down. Update selection
            // start along with the caret.
            FSelStart := FCaret;
          ResetCaretBlink;
          bHandled := True;
        end;

        VK_RIGHT:
        begin
          if (GetKeyState(VK_CONTROL) < 0) then
          begin
            // Control is down. Move the caret to a new item
            // instead of a character.
            m_Buffer.GetNextItemPos(FCaret, FCaret);
            PlaceCaret(FCaret);
          end else
          if (FCaret < m_Buffer.TextSize) then PlaceCaret(FCaret + 1);
          if (GetKeyState( VK_SHIFT ) >= 0) then
            // Shift is not down. Update selection
            // start along with the caret.
            FSelStart := FCaret;
          ResetCaretBlink;
          bHandled := True;
        end;

      VK_UP, VK_DOWN:
        // Trap up and down arrows so that the dialog
        // does not switch focus to another control.
        bHandled := true;

      else
        bHandled := wParam <> VK_ESCAPE;  // Let the application handle Esc.
      end;
    end;
  end;
  Result:= bHandled;
end;

function Tz3DEdit.HandleMouse(uMsg: LongWord; pt: TPoint;
  wParam: WPARAM; lParam: LPARAM): Boolean;
var
  nCP, nX1st: Integer;
  nTrail: LongBool;
begin
  Result:= True;
  if (not FEnabled or not FVisible) then
  begin
    Result:= False;
    Exit;
  end;

  case uMsg of
    WM_LBUTTONDOWN,
    WM_LBUTTONDBLCLK:
    begin
      if (not FHasFocus) then FDialog.RequestFocus(Self);

      if not ContainsPoint(pt) then
      begin
        Result:= False;
        Exit;
      end;

      FMouseDrag := True;
      SetCapture(z3DCore_GetHWND);
      // Determine the character corresponding to the coordinates.
      m_Buffer.CPtoX(FFirstVisible, False, nX1st);  // X offset of the 1st visible char
      if SUCCEEDED(m_Buffer.XtoCP(pt.x - FText.left + nX1st, nCP, nTrail)) then
      begin
        // Cap at the NULL character.
        if nTrail and (nCP < m_Buffer.TextSize)
          then PlaceCaret(nCP + 1)
          else PlaceCaret(nCP);
        FSelStart := FCaret;
        ResetCaretBlink;
      end;
      // Result:= True;
      Exit;
    end;

    WM_LBUTTONUP:
    begin
      ReleaseCapture;
      FMouseDrag := False;
    end;

    WM_MOUSEMOVE:
      if (FMouseDrag) then
      begin
        // Determine the character corresponding to the coordinates.
        m_Buffer.CPtoX(FFirstVisible, False, nX1st);  // X offset of the 1st visible char
        if SUCCEEDED(m_Buffer.XtoCP(pt.x - FText.left + nX1st, nCP, nTrail)) then
        begin
          // Cap at the NULL character.
          if nTrail and (nCP < m_Buffer.TextSize)
          then PlaceCaret(nCP + 1)
          else PlaceCaret(nCP);
        end;
      end;
  end;

  Result:= false;
end;

procedure Tz3DEdit.OnFocusIn;
begin
  inherited;
  ResetCaretBlink;
end;

function Tz3DEdit.MsgProc(uMsg: LongWord; wParam: WPARAM;
  lParam: LPARAM): Boolean;
begin
  if (not FEnabled or not FVisible) then
  begin
    Result:= False;
    Exit;
  end;

  case uMsg of
    // Make sure that while editing, the keyup and keydown messages associated with
    // WM_CHAR messages don't go to any non-focused controls or cameras
    WM_KEYUP,
    WM_KEYDOWN:
    begin
      Result:= True;
      Exit;
    end;

    WM_CHAR:
    begin
      case (wParam) of
        // Backspace
        VK_BACK:
        begin
          // If there's a selection, treat this
          // like a delete key.
          if (FCaret <> FSelStart) then
          begin
            DeleteSelectionText;
            FDialog.SendEvent(z3dceEditChange, True, Self);
          end else
          if (FCaret > 0) then
          begin
            // Move the caret, then delete the char.
            PlaceCaret(FCaret - 1);
            FSelStart := FCaret;
            m_Buffer.RemoveChar(FCaret);
            FDialog.SendEvent(z3dceEditChange, True, Self);
          end;
          ResetCaretBlink;
        end;

        24,        // Ctrl-X Cut
        VK_CANCEL: // Ctrl-C Copy
        begin
          CopyToClipboard;

          // If the key is Ctrl-X, delete the selection too.
          if (wParam = 24) then
          begin
            DeleteSelectionText;
            FDialog.SendEvent(z3dceEditChange, True, Self);
          end;
        end;

        // Ctrl-V Paste
        22:
        begin
          PasteFromClipboard;
          FDialog.SendEvent(z3dceEditChange, True, Self);
        end;

        // Ctrl-A Select All
        1:
        begin
          if (FSelStart = FCaret) then
          begin
            FSelStart := 0;
            PlaceCaret(m_Buffer.TextSize);
          end;
        end;

        VK_RETURN:
          // Invoke the callback when the user presses Enter.
          FDialog.SendEvent(z3dceEditString, True, Self);

        // Junk characters we don't want in the string
        26,  // Ctrl Z
        2,   // Ctrl B
        14,  // Ctrl N
        19,  // Ctrl S
        4,   // Ctrl D
        6,   // Ctrl F
        7,   // Ctrl G
        10,  // Ctrl J
        11,  // Ctrl K
        12,  // Ctrl L
        17,  // Ctrl Q
        23,  // Ctrl W
        5,   // Ctrl E
        18,  // Ctrl R
        20,  // Ctrl T
        25,  // Ctrl Y
        21,  // Ctrl U
        9,   // Ctrl I
        15,  // Ctrl O
        16,  // Ctrl P
        27,  // Ctrl [
        29,  // Ctrl ]
        28:  // Ctrl \
          {Do Nothing};

      else {case}
        // If there's a selection and the user
        // starts to type, the selection should
        // be deleted.
        if (FCaret <> FSelStart) then DeleteSelectionText;

        // If we are in overwrite mode and there is already
        // a char at the caret's position, simply replace it.
        // Otherwise, we insert the char as normal.
        if not FInsertMode and (FCaret < m_Buffer.TextSize) then
        begin
          m_Buffer[FCaret] := WideChar(wParam);
          PlaceCaret(FCaret + 1);
          FSelStart := FCaret;
        end else
        begin
          // Insert the char
          if m_Buffer.InsertChar(FCaret, WideChar(wParam)) then
          begin
            PlaceCaret(FCaret + 1);
            FSelStart := FCaret;
          end;
        end;
        ResetCaretBlink;
        FDialog.SendEvent(z3dceEditChange, True, Self);
      end;
      Result:= True;
      Exit;
    end;
  end;
  Result:= False;
end;

procedure Tz3DEdit.Render;
var
  nSelStartX, nCaretX: Integer ;  // Left and right X cordinates of the selection region
  pDisplay: Iz3DDisplay;
  e: Integer;
  nXFirst: Integer;
  rcSelection: TRect;  // Make this available for rendering selected text
  nSelLeftX, nSelRightX: Integer;
  nTemp: Integer;
  nFirstToRender: Integer;
  nNumChatToRender: Integer;
  rcCaret: TRect;
  nRightEdgeX: Integer;
begin
  if not Visible then Exit;

  nSelStartX := 0; nCaretX := 0;  // Left and right X cordinates of the selection region

  pDisplay := GetDisplay(0);
  if (pDisplay <> nil) then
  begin
    m_Buffer.FontNode := FDialog.GetFont(pDisplay.Font);
    PlaceCaret(FCaret);  // Call PlaceCaret now that we have the font info (node),
                           // so that scrolling can be handled.
  end;

  // Render the control graphics
  for e := 0 to 8 do
  begin
    pDisplay := m_Displays[e];
    pDisplay.TextureColor.Blend(z3dcsNormal);

    FDialog.DrawSprite(pDisplay, FRender[e]);
  end;

  //
  // Compute the X coordinates of the first visible character.
  //
  m_Buffer.CPtoX(FFirstVisible, FALSE, nXFirst );

  //
  // Compute the X coordinates of the selection rectangle
  //
  {hr := }m_Buffer.CPtoX(FCaret, False, nCaretX);
  if (FCaret <> FSelStart)
  then {hr := }m_Buffer.CPtoX(FSelStart, False, nSelStartX)
  else nSelStartX := nCaretX;

  //
  // Render the selection rectangle
  //
  if (FCaret <> FSelStart) then
  begin
    nSelLeftX := nCaretX; nSelRightX := nSelStartX;
    // Swap if left is bigger than right
    if (nSelLeftX > nSelRightX) then
    begin
      nTemp := nSelLeftX;
      nSelLeftX := nSelRightX;
      nSelRightX := nTemp;
    end;

    SetRect(rcSelection, nSelLeftX, FText.top, nSelRightX, FText.bottom);
    OffsetRect(rcSelection, FText.left - nXFirst, 0);
    IntersectRect(rcSelection, FText, rcSelection);
    FDialog.DrawRect(rcSelection, m_SelBkColor);
  end;

  //
  // Render the text
  //
  // Display 0 for text
  m_Displays[0].FontColor.Current := D3DXColorFromDWord(m_TextColor);
  FDialog.DrawText(m_Buffer.Buffer + FFirstVisible, m_Displays[0], FText);

  // Render the selected text
  if (FCaret <> FSelStart) then
  begin
    nFirstToRender := Max(FFirstVisible, Min( FSelStart, FCaret));
    nNumChatToRender := Max(FSelStart, FCaret) - nFirstToRender;
    m_Displays[0].FontColor.Current := D3DXColorFromDWord(m_SelTextColor);
    FDialog.DrawText(m_Buffer.Buffer + nFirstToRender,
                       m_Displays[0], rcSelection, False, nNumChatToRender);
  end;

  //
  // Blink the caret
  //
  if (z3DCore_GetGlobalTimer.AbsoluteTime - m_dfLastBlink >= m_dfBlink) then
  begin
    FCaretOn := not FCaretOn;
    m_dfLastBlink := z3DCore_GetGlobalTimer.AbsoluteTime;
  end;

  //
  // Render the caret if this control has the focus
  //
  if (FHasFocus and FCaretOn and not s_bHideCaret) then
  begin
    // Start the rectangle with insert mode caret
    rcCaret := Rect(FText.left - nXFirst + nCaretX - 1, FText.top,
                    FText.left - nXFirst + nCaretX + 1, FText.bottom);

    // If we are in overwrite mode, adjust the caret rectangle
    // to fill the entire character.
    if (not FInsertMode) then
    begin
      // Obtain the right edge X coord of the current character
      m_Buffer.CPtoX(FCaret, True, nRightEdgeX);
      rcCaret.right := FText.left - nXFirst + nRightEdgeX;
    end;

    FDialog.DrawRect(rcCaret, m_CaretColor);
  end;
end;

function IN_FLOAT_CHARSET(c: WideChar): Boolean;
begin
  Result:= (c = '-') or (c = '.') or (c >= '0') or (c <= '9');
end;

procedure Tz3DEdit.ParseFloatArray(pNumbers: PSingle; nCount: Integer);
{$IFDEF FPC}
begin // this function is not used anyway
end;
{$ELSE}
var
  nWritten: Integer;  // Number of floats written
  {const }pToken, pEnd: PWideChar;
  wszToken: array [0..59] of WideChar;
  nTokenLen: Integer;

begin
  nWritten := 0;  // Number of floats written

  pToken := m_Buffer.Buffer;
  while (nWritten < nCount) and (pToken^ <> #0) do
  begin
    // Skip leading spaces
    while (pToken^ = ' ') do Inc(pToken);

    if (pToken^ = #0) then Break;

    // Locate the end of number
    pEnd := pToken;
    while IN_FLOAT_CHARSET(pEnd^) do Inc(pEnd);

    // Copy the token to our buffer
    nTokenLen := Min(SizeOf(wszToken) div SizeOf(wszToken[0]) - 1, Integer(pEnd - pToken));
    StringCchCopy(wszToken, nTokenLen, pToken);
    {$IFDEF COMPILER6_UP}
    pNumbers^ := StrToFloatDef(wszToken, 0);
    {$ELSE}
    try
      pNumbers^ := StrToFloat(wszToken);
    except
      pNumbers^ := 0;
    end;
    {$ENDIF}
    Inc(nWritten);
    Inc(pNumbers);
    pToken := pEnd;
  end;
end;
{$ENDIF}

procedure Tz3DEdit.SetTextFloatArray(pNumbers: PSingle; nCount: Integer);
var
  wszBuffer: array[0..511] of WideChar{ = 0};
  wszTmp:array[0..63] of WideChar;
  i: Integer;
begin
  if (pNumbers = nil) then Exit;

  for i := 0 to nCount - 1 do
  begin
    //StringCchFormat(wszTmp, 64, '%.4f ', [pNumbers[i]]);
    StringCchFormat(wszTmp, 64, PWideChar(WideString('%.4f ')), [pNumbers^]); Inc(pNumbers);
    StringCchCat(wszBuffer, 512, wszTmp);
  end;

  // Don't want the last space
  if (nCount > 0) and (lstrlenW(wszBuffer) > 0)
  then wszBuffer[lstrlenW(wszBuffer)-1] := #0;

  SetText(wszBuffer);
end;

function Tz3DEdit.CanHaveFocus: Boolean;
begin
  Result:= (FVisible and FEnabled);
end;


function Tz3DEdit.GetText: PWideChar;
begin
  Result:= m_Buffer.Buffer;
end;

function Tz3DEdit.GetTextLength: Integer;
begin
  Result:= m_Buffer.TextSize; // Returns text length in chars excluding nil.
end;

procedure Tz3DEdit.ResetCaretBlink;
begin
  FCaretOn := True;
  m_dfLastBlink := z3DCore_GetGlobalTimer.AbsoluteTime;
end;


// Text color
procedure Tz3DEdit.SetTextColor(Color: TD3DColor);
begin
  m_TextColor := Color;
end;

procedure Tz3DEdit.SetBorderWidth(nBorder: Integer);
begin
  FBorder := nBorder;
  UpdateRects; // Border of the window
end;


procedure Tz3DEdit.SetSpacing(nSpacing: Integer);
begin
  FSpacing := nSpacing;
  UpdateRects;
end;

procedure Tz3DEdit.SetText_p(wszText: PWideChar);
begin
  SetText(wszText, False);
end;

var
  s_hDllImm32: THandle;  // IMM32 DLL handle
  s_hDllVer: THandle;    // Version DLL handle
  s_hImcDef: HIMC;       // Default input context

// Empty implementation of the IMM32 API
type
  HIMCC = HIMC;
  
  // tagINPUTCONTEXT - from Windows 98/Me: Windows DDK
  tagINPUTCONTEXT = record
    hWnd:   HWND;
    fOpen:   BOOL;
    ptStatusWndPos:  TPOINT;
    ptSoftKbdPos:  TPOINT;
    fdwConversion:  DWORD;
    fdwSentence:  DWORD;
    (* union {
        LOGFONTA  A;
        LOGFONTW  W;
    } lfFont; *)
    W: TLogFontW;
    cfCompForm: COMPOSITIONFORM;
    cfCandForm: array[0..3] of CANDIDATEFORM;
    hCompStr:  HIMCC;
    hCandInfo:  HIMCC;
    hGuideLine:  HIMCC;
    hPrivate:  HIMCC;
    dwNumMsgBuf: DWORD;
    hMsgBuf:  HIMCC;
    fdwInit:  DWORD;
    dwReserve: array[0..2] of DWORD;
  end;
  {$EXTERNALSYM tagINPUTCONTEXT}
  TInputContext = tagINPUTCONTEXT;
  PInputContext = ^TInputContext;

  
function Dummy_ImmLockIMC(imc: HIMC): PINPUTCONTEXT; stdcall;  begin Result:= nil; end;
function Dummy_ImmUnlockIMC(imc: HIMC): BOOL; stdcall;         begin Result:= FALSE; end;
function Dummy_ImmLockIMCC(imcc: HIMCC): Pointer; stdcall;     begin Result:= nil; end;
function Dummy_ImmUnlockIMCC(imcc: HIMCC): BOOL; stdcall;      begin Result:= FALSE; end;
function Dummy_ImmDisableTextFrameService(d: DWORD): BOOL; stdcall; begin Result:= TRUE; end;
function Dummy_ImmGetCompositionStringW(hImc: HIMC; dWord1: DWORD; lpBuf: pointer; dwBufLen: DWORD): Longint; stdcall; begin Result:= IMM_ERROR_GENERAL; end;
function Dummy_ImmGetCandidateListW(hImc: HIMC; deIndex: DWORD; lpCandidateList: PCandidateList; dwBufLen: DWORD): DWORD; stdcall; begin Result:= 0; end;
function Dummy_ImmGetContext(hWnd: HWND): HIMC; stdcall; begin Result:= 0; end;
function Dummy_ImmReleaseContext(hWnd: HWND; hImc: HIMC): Boolean; stdcall; begin Result:= FALSE; end;
function Dummy_ImmAssociateContext(hWnd: HWND; hImc: HIMC): HIMC; stdcall; begin Result:= 0; end;
function Dummy_ImmGetOpenStatus(hImc: HIMC): Boolean; stdcall; begin Result:= False; end;
function Dummy_ImmSetOpenStatus(hImc: HIMC; fOpen: Boolean): Boolean; stdcall; begin Result:= False; end;
function Dummy_ImmGetConversionStatus(hImc: HIMC; var Conversion, Sentence: DWORD): Boolean; stdcall; begin Result:= False; end;
function Dummy_ImmGetDefaultIMEWnd(hWnd: HWND): HWND; stdcall; begin Result:= 0; end;
function Dummy_ImmGetIMEFileNameA(hKl: HKL; PAnsiChar: PAnsiChar; uBufLen: UINT): UINT; stdcall; begin Result:= 0; end;
function Dummy_ImmGetVirtualKey(hWnd: HWND): UINT; stdcall; begin Result:= 0; end;
function Dummy_ImmNotifyIME(hImc: HIMC; dwAction, dwIndex, dwValue: DWORD): Boolean; stdcall; begin Result:= FALSE; end;
function Dummy_ImmSetConversionStatus(hImc: HIMC; Conversion, Sentence: DWORD): Boolean; stdcall; begin Result:= FALSE; end;
function Dummy_ImmSimulateHotKey(hWnd: HWND; dWord: DWORD): Boolean; stdcall; begin Result:= FALSE; end;
function Dummy_ImmIsIME(hKl: HKL): Boolean; stdcall;begin Result:= FALSE; end;

// Traditional Chinese IME
function Dummy_GetReadingString(himc: HIMC; u: UINT; w: PWideChar; i: PInteger; b: PBOOL; pu: PUINT): LongWord; begin Result:= 0; end;
function Dummy_ShowReadingWindow(imc: HIMC; b: BOOL): BOOL; begin Result:= FALSE; end;

// Verion library imports
function Dummy_VerQueryValueA(const p: Pointer; s: PAnsiChar; pp: PPointer; i: PUINT): BOOL; stdcall; begin Result:= False; end;
function Dummy_GetFileVersionInfoA(s: PChar; d1, d2: DWORD; p: Pointer): DWORD; stdcall; begin Result:= iFalse; end;
function Dummy_GetFileVersionInfoSizeA(s: PChar; var d: DWORD): DWORD; stdcall; begin Result:= 0; end;

var
  // Function pointers: IMM32
  _ImmLockIMC: function (imc: HIMC): PINPUTCONTEXT; stdcall = Dummy_ImmLockIMC;
  _ImmUnlockIMC: function (imc: HIMC): BOOL; stdcall = Dummy_ImmUnlockIMC;
  _ImmLockIMCC: function (imcc: HIMCC): Pointer; stdcall = Dummy_ImmLockIMCC;
  _ImmUnlockIMCC: function (imcc: HIMCC): BOOL; stdcall = Dummy_ImmUnlockIMCC;
  _ImmDisableTextFrameService: function (d: DWORD): BOOL; stdcall = Dummy_ImmDisableTextFrameService;
  _ImmGetCompositionStringW: function (hImc: HIMC; dWord1: DWORD; lpBuf: pointer; dwBufLen: DWORD): Longint; stdcall = Dummy_ImmGetCompositionStringW;
  _ImmGetCandidateListW: function (hImc: HIMC; deIndex: DWORD; lpCandidateList: PCandidateList; dwBufLen: DWORD): DWORD; stdcall = Dummy_ImmGetCandidateListW;
  _ImmGetContext: function (hWnd: HWND): HIMC; stdcall = Dummy_ImmGetContext;
  _ImmReleaseContext: function (hWnd: HWND; hImc: HIMC): Boolean; stdcall = Dummy_ImmReleaseContext;
  _ImmAssociateContext: function (hWnd: HWND; hImc: HIMC): HIMC; stdcall = Dummy_ImmAssociateContext;
  _ImmGetOpenStatus: function (hImc: HIMC): Boolean; stdcall = Dummy_ImmGetOpenStatus;
  _ImmSetOpenStatus: function (hImc: HIMC; fOpen: Boolean): Boolean; stdcall = Dummy_ImmSetOpenStatus;
  _ImmGetConversionStatus: function (hImc: HIMC; var Conversion, Sentence: DWORD): Boolean; stdcall = Dummy_ImmGetConversionStatus;
  _ImmGetDefaultIMEWnd: function (hWnd: HWND): HWND; stdcall = Dummy_ImmGetDefaultIMEWnd;
  _ImmGetIMEFileNameA: function (hKl: HKL; PAnsiChar: PAnsiChar; uBufLen: UINT): UINT; stdcall = Dummy_ImmGetIMEFileNameA;
  _ImmGetVirtualKey: function (hWnd: HWND): UINT; stdcall = Dummy_ImmGetVirtualKey;
  _ImmNotifyIME: function (hImc: HIMC; dwAction, dwIndex, dwValue: DWORD): Boolean; stdcall = Dummy_ImmNotifyIME;
  _ImmSetConversionStatus: function (hImc: HIMC; Conversion, Sentence: DWORD): Boolean; stdcall = Dummy_ImmSetConversionStatus;
  _ImmSimulateHotKey: function (hWnd: HWND; dWord: DWORD): Boolean; stdcall = Dummy_ImmSimulateHotKey;
  _ImmIsIME: function (hKl: HKL): Boolean; stdcall = Dummy_ImmIsIME;

  // Function pointers: Traditional Chinese IME
  _GetReadingString: function (himc: HIMC; u: UINT; w: PWideChar; i: PInteger; b: PBOOL; pu: PUINT): LongWord = Dummy_GetReadingString;
  _ShowReadingWindow: function (imc: HIMC; b: BOOL): BOOL = Dummy_ShowReadingWindow;

  // Function pointers: Verion library imports
  _VerQueryValueA: function (const p: Pointer; s: PAnsiChar; pp: PPointer; i: PUINT): BOOL; stdcall = Dummy_VerQueryValueA;
  _GetFileVersionInfoA: function (s: PChar; d1, d2: DWORD; p: Pointer): DWORD; stdcall = Dummy_GetFileVersionInfoA;
  _GetFileVersionInfoSizeA: function (s: PChar; var d: DWORD): DWORD; stdcall = Dummy_GetFileVersionInfoSizeA;

var
  // Application-wide data
  s_hklCurrent: HKL;             // Current keyboard layout of the process
  s_bVerticalCand: Boolean;      // Indicates that the candidates are listed vertically
  s_aszIndicator: array[Low(TIndicatorEnum)..High(TIndicatorEnum), 0..2] of WideChar = (
    ('E','n', #0),
    (#$7B80, #0, #0),
    (#$7E41, #0, #0),
    (#$AC00, #0, #0),
    (#$3042, #0, #0)); // String to draw to indicate current input locale
  {$IFDEF FPC}
  s_wszCurrIndicator: PWideChar;
  {$ELSE}
  s_wszCurrIndicator: PWideChar = @s_aszIndicator[Low(TIndicatorEnum)]; // Points to an indicator string that corresponds to current input locale
  {$ENDIF}
  s_bInsertOnType: Boolean;      // Insert the character as soon as a key is pressed (Korean behavior)
  s_hDllIme: THandle{HINSTANCE}; // Instance handle of the current IME module
  s_ImeState: TImeState;         // IME global state
  s_bEnableImeSystem: Boolean;   // Whether the IME system is active
  s_ptCompString: TPoint;        // Composition string position. Updated every frame.
  s_nCompCaret: Integer;         // Caret position of the composition string
  s_nFirstTargetConv: Integer;   // Index of the first target converted char in comp string.  If none, -1.
  s_CompString: Iz3DUniBuffer;      // Buffer to hold the composition string (we fix its length)
  s_abCompStringAttr: array[0..MAX_COMPSTRING_SIZE-1] of Byte;
  s_adwCompStringClause: array[0..MAX_COMPSTRING_SIZE-1] of DWORD;
  s_wszReadingString: array[0..31] of WideChar; // Used only with horizontal reading window (why?)
  s_CandList: TCandList;  // Data relevant to the candidate list
  s_bShowReadingWindow: Boolean; // Indicates whether reading window is visible
  s_bHorizontalReading: Boolean; // Indicates whether the reading window is vertical or horizontal
  s_bChineseIME: BOOL;
  s_Locale: array of TInputLocale; // Array of loaded keyboard layout on system
{$IFDEF DEBUG}
  FIMEStaticMsgProcCalled: Boolean = False;
{$ENDIF}


const
  // IME constants
  CHT_IMEFILENAME1    = 'TINTLGNT.IME'; // New Phonetic
  CHT_IMEFILENAME2    = 'CINTLGNT.IME'; // New Chang Jie
  CHT_IMEFILENAME3    = 'MSTCIPHA.IME'; // Phonetic 5.1
  CHS_IMEFILENAME1    = 'PINTLGNT.IME'; // MSPY1.5/2/3
  CHS_IMEFILENAME2    = 'MSSCIPYA.IME'; // MSPY3 for OfficeXP

  LANG_CHT            = (SUBLANG_CHINESE_TRADITIONAL shl 10) or LANG_CHINESE; // MAKELANGID(LANG_CHINESE, SUBLANG_CHINESE_TRADITIONAL);
  LANG_CHS            = (SUBLANG_CHINESE_SIMPLIFIED  shl 10) or LANG_CHINESE; // MAKELANGID(LANG_CHINESE, SUBLANG_CHINESE_SIMPLIFIED);
  _CHT_HKL            = HKL($E0080404); // New Phonetic
  _CHT_HKL2           = HKL($E0090404); // New Chang Jie
  _CHS_HKL            = HKL($E00E0804); // MSPY

{#define MAKEIMEVERSION( major, minor ) \
    ( (DWORD)( ( (BYTE)( major ) << 24 ) | ( (BYTE)( minor ) << 16 ) ) )}
function MAKEIMEVERSION(major, minor: Byte): DWORD;
begin
  Result:= (major shl 24) or (minor shl 16);
end;

const
  IMEID_CHT_VER42 = LANG_CHT or (4 shl 24 or 2 shl 16); // 4, 2 ) )	// New(Phonetic/ChanJie)IME98  : 4.2.x.x // Win98
  IMEID_CHT_VER43 = LANG_CHT or (4 shl 24 or 3 shl 16); // 4, 3 ) )	// New(Phonetic/ChanJie)IME98a : 4.3.x.x // Win2k
  IMEID_CHT_VER44 = LANG_CHT or (4 shl 24 or 4 shl 16); // 4, 4 ) )	// New ChanJie IME98b          : 4.4.x.x // WinXP
  IMEID_CHT_VER50 = LANG_CHT or (5 shl 24 or 0 shl 16); // 5, 0 ) )	// New(Phonetic/ChanJie)IME5.0 : 5.0.x.x // WinME
  IMEID_CHT_VER51 = LANG_CHT or (5 shl 24 or 1 shl 16); // 5, 1 ) )	// New(Phonetic/ChanJie)IME5.1 : 5.1.x.x // IME2002(w/OfficeXP)
  IMEID_CHT_VER52 = LANG_CHT or (5 shl 24 or 2 shl 16); // 5, 2 ) )	// New(Phonetic/ChanJie)IME5.2 : 5.2.x.x // IME2002a(w/Whistler)
  IMEID_CHT_VER60 = LANG_CHT or (6 shl 24 or 0 shl 16); // 6, 0 ) )	// New(Phonetic/ChanJie)IME6.0 : 6.0.x.x // IME XP(w/WinXP SP1)
  IMEID_CHS_VER41	= LANG_CHS or (4 shl 24 or 1 shl 16); // 4, 1 ) )	// MSPY1.5	// SCIME97 or MSPY1.5 (w/Win98, Office97)
  IMEID_CHS_VER42	= LANG_CHS or (4 shl 24 or 2 shl 16); // 4, 2 ) )	// MSPY2	// Win2k/WinME
  IMEID_CHS_VER53	= LANG_CHS or (5 shl 24 or 3 shl 16); // 5, 3 ) )	// MSPY3	// WinXP


{ Tz3DIMEEditBox }


constructor Tz3DIMEEditBox.Create(const pDialog: Iz3DDialog);
begin
  inherited;
  Tz3DIMEEditBox.Initialize; // ensure static vars are properly init'ed first
  _ImmDisableTextFrameService(DWORD(-1));  // Disable TSF for the current process

  m_Type := z3dctIMEEdit;
  FDialog := pDialog;

  s_bEnableImeSystem := True;
  FIndicatorWidth := 0;
  m_ReadingColor := D3DCOLOR_ARGB(188, 255, 255, 255);
  m_ReadingWinColor := D3DCOLOR_ARGB(128, 0, 0, 0);
  m_ReadingSelColor := D3DCOLOR_ARGB(255, 255, 0, 0);
  m_ReadingSelBkColor := D3DCOLOR_ARGB(128, 80, 80, 80);
  m_CandidateColor := D3DCOLOR_ARGB(255, 200, 200, 200);
  m_CandidateWinColor := D3DCOLOR_ARGB(128, 0, 0, 0);
  m_CandidateSelColor := D3DCOLOR_ARGB(255, 255, 255, 255);
  m_CandidateSelBkColor := D3DCOLOR_ARGB(128, 158, 158, 158);
  m_CompColor := D3DCOLOR_ARGB(255, 200, 200, 255);
  m_CompWinColor := D3DCOLOR_ARGB(198, 0, 0, 0);
  m_CompCaretColor := D3DCOLOR_ARGB(255, 255, 255, 255);
  m_CompTargetColor := D3DCOLOR_ARGB(255, 255, 255, 255);
  m_CompTargetBkColor := D3DCOLOR_ARGB(255, 150, 150, 150);
  m_CompTargetNonColor := D3DCOLOR_ARGB(255, 255, 255, 0);
  m_CompTargetNonBkColor := D3DCOLOR_ARGB(255, 150, 150, 150);
  m_IndicatorImeColor := D3DCOLOR_ARGB(255, 255, 255, 255);
  m_IndicatorEngColor := D3DCOLOR_ARGB(255, 0, 0, 0);
  m_IndicatorBkColor := D3DCOLOR_ARGB(255, 128, 128, 128);
end;

destructor Tz3DIMEEditBox.Destroy;
begin
  inherited;
end;

class procedure Tz3DIMEEditBox.SendKey(nVirtKey: Byte);
begin
  keybd_event(nVirtKey, 0, 0,               0);
  keybd_event(nVirtKey, 0, KEYEVENTF_KEYUP, 0);
end;

class function Tz3DIMEEditBox.StaticOnCreateDevice: HRESULT;
begin
  s_hImcDef := _ImmGetContext(z3DCore_GetHWND);
  _ImmReleaseContext(z3DCore_GetHWND, s_hImcDef);

  Result:= S_OK;
end;

procedure Tz3DIMEEditBox.UpdateRects;
var
  nWidth: Integer;
begin
  nWidth := FWidth;
  Dec(FWidth, FIndicatorWidth + FBorder * 2); // Make room for the indicator button
  inherited;
  FWidth := nWidth;  // Restore

  // Compute the indicator button rectangle
  SetRect(FIndicator, FBoundingBox.right, FBoundingBox.top, FLeft + FWidth, FBoundingBox.bottom);
// InflateRect( &FIndicator, -FBorder, -FBorder );
  FBoundingBox.right := FBoundingBox.left + FWidth;
end;

//    MAKELCID            - construct the locale id from a language id and a sort id.
//#define MAKELCID(lgid, srtid)  ((DWORD)((((DWORD)((WORD  )(srtid))) << 16) |  \
//                                         ((DWORD)((WORD  )(lgid)))))
function MAKELCID(lgid, srtid: Word): DWORD;
begin
  Result:= (srtid shl 16) or lgid;
end;

//    MAKELANGID    - construct language id from a primary language id and
//                    a sublanguage id.
//#define MAKELANGID(p, s)       ((((WORD  )(s)) << 10) | (WORD  )(p))
function MAKELANGID(p, s: Word): Word;
begin
  Result:= (s shl 10) or p;
end;

const
  NORM_IGNORECASE      			= $00000001;     {* ignore case *}
//  NORM_IGNORENONSPACE  			= $00000002;     {* ignore diacritics *}
//  NORM_IGNORESYMBOLS   			= $00000004;     {* ignore symbols *}


//	GetImeId( UINT uIndex )
//		returns
//	returned value:
//	0: In the following cases
//		- Non Chinese IME input locale
//		- Older Chinese IME
//		- Other error cases
//
//	Othewise:
//      When uIndex is 0 (default)
//			bit 31-24:	Major version
//			bit 23-16:	Minor version
//			bit 15-0:	Language ID
//		When uIndex is 1
//			pVerFixedInfo->dwFileVersionLS
//
//	Use IMEID_VER and IMEID_LANG macro to extract version and language information.
//	

// We define the locale-invariant ID ourselves since it doesn't exist prior to WinXP
// For more information, see the CompareString() reference.
const
  // LCID_INVARIANT = MAKELCID(MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_US), SORT_DEFAULT)
  LCID_INVARIANT = (SORT_DEFAULT shl 16) or (SUBLANG_ENGLISH_US shl 10) or LANG_ENGLISH;

var
  GetImeId_hklPrev: HKL = 0;
  dwID: array[0..1] of DWORD = (0, 0);

class function Tz3DIMEEditBox.GetImeId(uIndex: LongWord): DWORD;
var
  dwVerSize: DWORD;
  dwVerHandle: DWORD;
  lpVerBuffer: Pointer;
  lpVerData: Pointer;
  cbVerData: LongWord;
  szTmp: array[0..1023] of Char;
  dwVer: DWORD;
begin
  if (uIndex >= SizeOf(dwID) div SizeOf(dwID[0])) then
  begin
    Result:= 0;
    Exit;
  end;

  if (GetImeId_hklPrev = s_hklCurrent) then
  begin
    Result:= dwID[uIndex];
    Exit;
  end;

  GetImeId_hklPrev := s_hklCurrent;  // Save for the next invocation

  // Check if we are using an older Chinese IME
  if not ( (s_hklCurrent = _CHT_HKL) or (s_hklCurrent = _CHT_HKL2) or (s_hklCurrent = _CHS_HKL) ) then
  begin
    dwID[1] := 0;
    dwID[0] := 0;
    Result:= dwID[uIndex];
    Exit;
  end;

  // Obtain the IME file name
  if _ImmGetIMEFileNameA(s_hklCurrent, szTmp, (SizeOf(szTmp) div SizeOf(szTmp[0])) - 1 ) = 0 then
  begin
    dwID[1] := 0;
    dwID[0] := 0;
    Result:= dwID[uIndex];
    Exit;
  end;

  // Check for IME that doesn't implement reading string API
  if (@_GetReadingString = nil) then
  begin
    if (CompareStringA(LCID_INVARIANT, NORM_IGNORECASE, szTmp, -1, CHT_IMEFILENAME1, -1) <> CSTR_EQUAL) and
       (CompareStringA(LCID_INVARIANT, NORM_IGNORECASE, szTmp, -1, CHT_IMEFILENAME2, -1) <> CSTR_EQUAL) and
       (CompareStringA(LCID_INVARIANT, NORM_IGNORECASE, szTmp, -1, CHT_IMEFILENAME3, -1) <> CSTR_EQUAL) and
       (CompareStringA(LCID_INVARIANT, NORM_IGNORECASE, szTmp, -1, CHS_IMEFILENAME1, -1) <> CSTR_EQUAL) and
       (CompareStringA(LCID_INVARIANT, NORM_IGNORECASE, szTmp, -1, CHS_IMEFILENAME2, -1) <> CSTR_EQUAL) then
    begin
      dwID[1] := 0;
      dwID[0] := 0;
      Result:= dwID[uIndex];
      Exit;
    end;
  end;

  dwVerSize := _GetFileVersionInfoSizeA(szTmp, dwVerHandle);
  if (dwVerSize <> 0) then
  begin
    lpVerBuffer := HeapAlloc(GetProcessHeap, 0, dwVerSize);
    if (lpVerBuffer <> nil) then
    begin
      if _GetFileVersionInfoA(szTmp, dwVerHandle, dwVerSize, lpVerBuffer) <> 0 then
      begin
        if _VerQueryValueA(lpVerBuffer, '\', @lpVerData, @cbVerData) then
        begin
          dwVer := PVSFixedFileInfo(lpVerData).dwFileVersionMS;
          dwVer := (dwVer and $00ff0000) shl 8 or (dwVer and $000000ff) shl 16;
          if (@_GetReadingString <> nil)
              or
             ((GetLanguage = LANG_CHT) and
               ((dwVer = MAKEIMEVERSION(4, 2)) or
                (dwVer = MAKEIMEVERSION(4, 3)) or
                (dwVer = MAKEIMEVERSION(4, 4)) or
                (dwVer = MAKEIMEVERSION(5, 0)) or
                (dwVer = MAKEIMEVERSION(5, 1)) or
                (dwVer = MAKEIMEVERSION(5, 2)) or
                (dwVer = MAKEIMEVERSION(6, 0))))
              or
             ((GetLanguage = LANG_CHS) and
              ((dwVer = MAKEIMEVERSION(4, 1)) or
               (dwVer = MAKEIMEVERSION(4, 2)) or
               (dwVer = MAKEIMEVERSION(5, 3))))
            then
          begin
            dwID[0] := dwVer or GetLanguage;
            dwID[1] := PVSFixedFileInfo(lpVerData).dwFileVersionLS;
          end;
        end;
      end;
      HeapFree(GetProcessHeap, 0, lpVerBuffer);
    end;
  end;

  Result:= dwID[uIndex];
end;


{*---------------------------------------------------------------------*
Name            _ltowlower - translates wide-characters to lower-case
Usage           wchar_t _ltowlower(wchar_t c);
Prototype in    _ltowlower is a function that converts a wide-character c
                to its lower-case value according to the current locale
Return value    returns the converted value of c, on success, and
                nothing on failure.
*---------------------------------------------------------------------*}
function towlower(ch: WideChar): WideChar;
begin
  CharLowerBuffW(@ch, 1);
  Result:= ch;
  // LCMapString(locale->handle, LCMAP_LOWERCASE, (LPCSTR) &ch, 1, (LPTSTR)&result, sizeof(result));
end;

var
  CheckInputLocale_hklPrev: HKL = 0;
class procedure Tz3DIMEEditBox.CheckInputLocale;
var
  wszLang: array[0..4] of WideChar;
begin
  // static HKL hklPrev = 0;
  s_hklCurrent := GetKeyboardLayout(0);
  if (CheckInputLocale_hklPrev = s_hklCurrent) then Exit;

  CheckInputLocale_hklPrev := s_hklCurrent;
  case GetPrimaryLanguage of
    // Simplified Chinese
    LANG_CHINESE:
    begin
      s_bVerticalCand := True;
      case GetSubLanguage of
        SUBLANG_CHINESE_SIMPLIFIED:
        begin
          s_wszCurrIndicator := s_aszIndicator[INDICATOR_CHS];
          s_bVerticalCand := (GetImeId = 0);
        end;
        SUBLANG_CHINESE_TRADITIONAL:
          s_wszCurrIndicator := s_aszIndicator[INDICATOR_CHT];
      else {case}
        // unsupported sub-language
        s_wszCurrIndicator := s_aszIndicator[INDICATOR_NON_IME];
      end;
    end;

    // Korean
    LANG_KOREAN:
    begin
      s_wszCurrIndicator := s_aszIndicator[INDICATOR_KOREAN];
      s_bVerticalCand := False;
    end;

    // Japanese
    LANG_JAPANESE:
    begin
      s_wszCurrIndicator := s_aszIndicator[INDICATOR_JAPANESE];
      s_bVerticalCand := True;
    end;

  else {case GetPrimaryLanguage}
    // A non-IME language.  Obtain the language abbreviation
    // and store it for rendering the indicator later.
    s_wszCurrIndicator := s_aszIndicator[INDICATOR_NON_IME];
  end;

  // If non-IME, use the language abbreviation.
  if (s_wszCurrIndicator = @s_aszIndicator[INDICATOR_NON_IME]) then
  begin
    GetLocaleInfoW(MAKELCID(LOWORD(s_hklCurrent), SORT_DEFAULT), LOCALE_SABBREVLANGNAME, wszLang, 5);
    s_wszCurrIndicator[0] := wszLang[0];
    s_wszCurrIndicator[1] := towlower(wszLang[1]);
  end;
end;

class procedure Tz3DIMEEditBox.CheckToggleState;
var
  bIme: Boolean;
  hImc: Imm.HIMC;
  dwConvMode, dwSentMode: DWORD;
begin
  CheckInputLocale;
  bIme := _ImmIsIME(s_hklCurrent);
  s_bChineseIME := (GetPrimaryLanguage = LANG_CHINESE) and bIme;

  hImc := _ImmGetContext(z3DCore_GetHWND);
  if (0 <> hImc) then
  begin
    if (s_bChineseIME) then
    begin
      _ImmGetConversionStatus(hImc, dwConvMode, dwSentMode);
      if (dwConvMode and IME_CMODE_NATIVE <> 0)
        then s_ImeState := IMEUI_STATE_ON
        else s_ImeState := IMEUI_STATE_ENGLISH;
    end else
    begin
      if (bIme and _ImmGetOpenStatus(hImc))
        then s_ImeState := IMEUI_STATE_ON
        else s_ImeState := IMEUI_STATE_OFF;
    end;
    _ImmReleaseContext(z3DCore_GetHWND, hImc);
  end
  else
    s_ImeState := IMEUI_STATE_OFF;
end;

// Enable/disable the entire IME system.  When disabled, the default IME handling
// kicks in.
class procedure Tz3DIMEEditBox.EnableImeSystem(bEnable: Boolean);
begin
  s_bEnableImeSystem := bEnable;
end;

// Sets up IME-specific APIs for the IME edit controls.  This is called every time
// the input locale changes.
class procedure Tz3DIMEEditBox.SetupImeApi;
var
  szImeFile: array[0..MAX_PATH] of Char;
begin
  _GetReadingString := nil;
  _ShowReadingWindow := nil;
  if (_ImmGetIMEFileNameA(s_hklCurrent, szImeFile, SizeOf(szImeFile) div SizeOf(szImeFile[0]) - 1) = 0)
  then Exit;

  if (s_hDllIme <> 0) then FreeLibrary(s_hDllIme);
  s_hDllIme := LoadLibraryA(szImeFile);
  if (s_hDllIme = 0) then Exit;

  _GetReadingString := GetProcAddress(s_hDllIme, 'GetReadingString');
  _ShowReadingWindow := GetProcAddress(s_hDllIme, 'ShowReadingWindow');
end;

// Resets the composition string.
class procedure Tz3DIMEEditBox.ResetCompositionString;
begin
  s_nCompCaret := 0;
  s_CompString.SetText('');
  ZeroMemory(@s_abCompStringAttr, SizeOf(s_abCompStringAttr));
end;

// Truncate composition string by sending keystrokes to the window.
procedure Tz3DIMEEditBox.TruncateCompString(bUseBackSpace: Boolean;
  iNewStrLen: Integer);
var
  cc: Integer;
  i: Integer;
begin
  if not s_bInsertOnType then Exit;

  cc := lstrlenW(s_CompString.Buffer);
  Assert((iNewStrLen = 0) or (iNewStrLen >= cc));
  
  // Send right arrow keystrokes to move the caret
  //   to the end of the composition string.
  for i := 0 to (cc - s_nCompCaret) - 1 do
    SendMessage(z3DCore_GetHWND, WM_KEYDOWN, VK_RIGHT, 0);
  SendMessage(z3DCore_GetHWND, WM_KEYUP, VK_RIGHT, 0);

  if (bUseBackSpace or FInsertMode) then iNewStrLen := 0;

  // The caller sets bUseBackSpace to false if there's possibility of sending
  // new composition string to the app right after this function call.
  //
  // If the app is in overwriting mode and new comp string is
  // shorter than current one, delete previous comp string
  // till it's same long as the new one. Then move caret to the beginning of comp string.
  // New comp string will overwrite old one.
  if (iNewStrLen < cc) then
  begin
    for i := 0 to (cc - iNewStrLen) - 1 do 
    begin
      SendMessage(z3DCore_GetHWND, WM_KEYDOWN, VK_BACK, 0);  // Backspace character
      SendMessageW(z3DCore_GetHWND, WM_CHAR, VK_BACK, 0);
    end;
    SendMessage(z3DCore_GetHWND, WM_KEYUP, VK_BACK, 0);
  end else
    iNewStrLen := cc;

  // Move the caret to the beginning by sending left keystrokes
  for i := 0 to iNewStrLen - 1 do
    SendMessage(z3DCore_GetHWND, WM_KEYDOWN, VK_LEFT, 0);
  SendMessage(z3DCore_GetHWND, WM_KEYUP, VK_LEFT, 0);
end;

// Sends the current composition string to the application by sending keystroke
// messages.
procedure Tz3DIMEEditBox.SendCompString;
var
  i: Integer;
begin
  for i := 0 to lstrlenW(s_CompString.Buffer) - 1 do
    MsgProc(WM_CHAR, WPARAM(s_CompString[i]), 0);
end;

// Outputs current composition string then cleans up the composition task.
var
  bProcessing: Boolean = False;

procedure Tz3DIMEEditBox.FinalizeString(bSend: Boolean);
var
  hImc: Imm.HIMC;
  lLength: Longint;
begin
  hImc := _ImmGetContext(z3DCore_GetHWND);
  if (hImc = 0) then Exit;

  if bProcessing then    // avoid infinite recursion
  begin
    z3DTraceDX(UnitName, $FFFF, 0, 'Cz3DIMEEditBox::FinalizeString: Reentrant detected!'#10, False);
    _ImmReleaseContext(z3DCore_GetHWND, hImc);
    Exit;
  end;
  bProcessing := True;

  if not s_bInsertOnType and bSend then
  begin
    // Send composition string to app.
    lLength := lstrlenW(s_CompString.Buffer);
    // In case of CHT IME, don't send the trailing double byte space, if it exists.
    if (GetLanguage = LANG_CHT)
       and (s_CompString[lLength - 1] = #$3000) then
    begin
      s_CompString[lLength - 1] := #0;
    end;
    SendCompString;
  end;

  ResetCompositionString;
  // Clear composition string in IME
  _ImmNotifyIME(hImc, NI_COMPOSITIONSTR, CPS_CANCEL, 0);
  // the following line is necessary as Korean IME doesn't close cand list
  // when comp string is cancelled.
  _ImmNotifyIME(hImc, NI_CLOSECANDIDATE, 0, 0);
  _ImmReleaseContext(z3DCore_GetHWND, hImc);
  bProcessing := False;
end;

// Determine whether the reading window should be vertical or horizontal.
class procedure Tz3DIMEEditBox.GetReadingWindowOrientation(dwId: DWORD);
var
  wszRegPath: array[0..MAX_PATH-1] of WideChar;
  hKey: Windows.HKEY;
  dwVer: DWORD;
  lRc: Longint;
  dwSize, dwMapping, dwType: DWORD;
begin
  s_bHorizontalReading := (s_hklCurrent = _CHS_HKL) or (s_hklCurrent = _CHT_HKL2) or (dwId = 0);
  if not s_bHorizontalReading and ((dwId and $0000FFFF) = LANG_CHT) then
  begin
    dwVer := dwId and $FFFF0000;
    StringCchCopy(wszRegPath, MAX_PATH, 'software\microsoft\windows\currentversion\');
    if (dwVer >= MAKEIMEVERSION(5, 1))
      then StringCchCat(wszRegPath, MAX_PATH, 'MSTCIPH')
      else StringCchCat(wszRegPath, MAX_PATH, 'TINTLGNT');
    lRc := RegOpenKeyExW(HKEY_CURRENT_USER, wszRegPath, 0, KEY_READ, hKey);
    if (lRc = ERROR_SUCCESS) then
    begin
      dwSize := SizeOf(DWORD);
      lRc := RegQueryValueExW(hKey, 'Keyboard Mapping', nil, @dwType, @dwMapping, @dwSize);
      if (lRc = ERROR_SUCCESS) then
      begin
        if ( (dwVer <= MAKEIMEVERSION(5, 0)) and ( (dwMapping = $22) or (dwMapping = $23) ) )
             or
           ( ( (dwVer = MAKEIMEVERSION(5, 1)) or (dwVer = MAKEIMEVERSION(5, 2) ) and
             ( (dwMapping >= $22) and (dwMapping <= $24) ) ) )
          then
        begin
          s_bHorizontalReading := True;
        end;
      end;
      RegCloseKey(hKey);
    end;
  end;
end;

// Obtain the reading string upon WM_IME_NOTIFY/INM_PRIVATE notification.
class procedure Tz3DIMEEditBox.GetPrivateReadingString;
var
  dwId: DWORD;
  hImc: Imm.HIMC;
  dwReadingStrLen: DWORD;
  dwErr: Integer;
  pwszReadingStringBuffer: PWideChar;  // Buffer for when the IME supports GetReadingString()
  wstr: PWideChar;
  bUnicodeIme: Boolean;  // Whether the IME context component is Unicode.
  lpIC: PInputContext;
  uMaxUiLen: LongWord;
  bVertical: BOOL;
  p: PByte;
  nOffset: Integer;
  osi: TOSVersionInfoW;
  nTcharSize: Integer;
  i: Integer;
  pch: PChar;
  j: DWORD;
  wszCodePage: array[0..7] of WideChar;
  uCodePage: LongWord;  // Default code page
begin
  dwId := GetImeId;
  if (dwId = 0) then
  begin
    s_bShowReadingWindow := False;
    Exit;
  end;

  hImc := _ImmGetContext(z3DCore_GetHWND);
  if (hImc = 0) then
  begin
    s_bShowReadingWindow := False;
    Exit;
  end;


  dwReadingStrLen := 0;
  dwErr := 0;
  pwszReadingStringBuffer := nil;  // Buffer for when the IME supports GetReadingString()
  wstr := nil;
  bUnicodeIme := False;  // Whether the IME context component is Unicode.
  lpIC := nil;

  if (@_GetReadingString <> nil) then
  begin            
    // Obtain the reading string size
    dwReadingStrLen := _GetReadingString(hImc, 0, nil, @dwErr, @bVertical, @uMaxUiLen);
    if (dwReadingStrLen <> 0) then
    begin
      pwszReadingStringBuffer := HeapAlloc(GetProcessHeap, 0, SizeOf(WideChar) * dwReadingStrLen);
      wstr := pwszReadingStringBuffer;
      if (pwszReadingStringBuffer = nil) then
      begin
        // Out of memory. Exit.
        _ImmReleaseContext(z3DCore_GetHWND, hImc);
        Exit;
      end;

      // Obtain the reading string
      dwReadingStrLen := _GetReadingString(hImc, dwReadingStrLen, wstr, @dwErr, @bVertical, @uMaxUiLen);
    end;

    s_bHorizontalReading := not bVertical;
    bUnicodeIme := True;
  end else
  begin
    // IMEs that doesn't implement Reading String API

    lpIC := _ImmLockIMC(hImc);

    // p := nil; // - never used
    case dwId of
      IMEID_CHT_VER42, // New(Phonetic/ChanJie)IME98  : 4.2.x.x // Win98
      IMEID_CHT_VER43, // New(Phonetic/ChanJie)IME98a : 4.3.x.x // WinMe, Win2k
      IMEID_CHT_VER44: // New ChanJie IME98b          : 4.4.x.x // WinXP
      begin
        // p = *(LPBYTE *)((LPBYTE)_ImmLockIMCC( lpIC->hPrivate ) + 24 );
        p:= PByte(PPointer(Longword(_ImmLockIMCC(lpIC^.hPrivate)) + 24)^);
        if (p <> nil) then
        begin
          dwReadingStrLen := PDWORD(Longword(p) + 7 * 4 + 32 * 4)^;
          dwErr := PDWORD(Longword(p) + 8 * 4 + 32 * 4)^;
          wstr := PWideChar(Longword(p) + 56);
          bUnicodeIme := True;
        end;
      end;

      IMEID_CHT_VER50: // 5.0.x.x // WinME
      begin
        // p = *(LPBYTE *)( (LPBYTE)_ImmLockIMCC( lpIC->hPrivate ) + 3 * 4 );
        p:= PByte(PPointer(Longword(_ImmLockIMCC(lpIC^.hPrivate)) + 3 * 4)^);
        if (p <> nil) then
        begin
          p := PByte(PPointer(Longword(p) + 1*4 + 5*4 + 4*2)^);
          if (p <> nil) then
          begin
            dwReadingStrLen := PDWORD(Longword(p) + 1*4 + (16*2+2*4) + 5*4 + 16)^;
            dwErr := PDWORD(Longword(p) + 1*4 + (16*2+2*4) + 5*4 + 16 + 1*4)^;
            wstr := PWideChar(Longword(p) + 1*4 + (16*2+2*4) + 5*4);
            bUnicodeIme := False;
          end;
        end;
      end;

      IMEID_CHT_VER51, // 5.1.x.x // IME2002(w/OfficeXP)
      IMEID_CHT_VER52, // 5.2.x.x // (w/whistler)
      IMEID_CHS_VER53: // 5.3.x.x // SCIME2k or MSPY3 (w/OfficeXP and Whistler)
      begin
        // p = *(LPBYTE *)( (LPBYTE)_ImmLockIMCC( lpIC->hPrivate ) + 4 );
        p:= PByte(PPointer(Longword(_ImmLockIMCC(lpIC^.hPrivate)) + 4)^);
        if (p <> nil) then
        begin
          p := PByte(PPointer(Longword(p) + 1*4 + 5*4)^);
          if (p <> nil) then
          begin                               
            dwReadingStrLen := PDWORD(Longword(p) + 1*4 + (16*2+2*4) + 5*4 + 16 * 2)^;
            dwErr := PDWORD(Longword(p) + 1*4 + (16*2+2*4) + 5*4 + 16 * 2 + 1*4)^;
            wstr := PWideChar(Longword(p) + 1*4 + (16*2+2*4) + 5*4);
            bUnicodeIme := True;
          end;
        end;
      end;

      // the code tested only with Win 98 SE (MSPY 1.5/ ver 4.1.0.21)
      IMEID_CHS_VER41:
      begin
        nOffset := IfThen((GetImeId(1) >= $00000002), 8, 7);
        // p = *(LPBYTE *)( (LPBYTE)_ImmLockIMCC( lpIC->hPrivate ) + nOffset * 4 );
        p:= PByte(PPointer(Integer(_ImmLockIMCC(lpIC^.hPrivate)) + nOffset * 4)^);
        if (p <> nil) then
        begin
          dwReadingStrLen := PDWORD(Longword(p) + 7*4 + 16*2*4)^;
          dwErr := PDWORD(Longword(p) + 8*4 + 16*2*4)^;
          dwErr := Min(dwErr, Integer(dwReadingStrLen));
          wstr := PWideChar(Longword(p) + 6*4 + 16*2*1);
          bUnicodeIme := True;
        end;
      end;

      IMEID_CHS_VER42: // 4.2.x.x // SCIME98 or MSPY2 (w/Office2k, Win2k, WinME, etc)
      begin
        osi.dwOSVersionInfoSize := SizeOf(TOSVersionInfoW);
        {$IFDEF FPC}
        GetVersionExW(osi);
        {$ELSE}
        GetVersionExW(POSVersionInfo(@osi)^); //todo: Bug in all Delphi versions
        {$ENDIF}

        nTcharSize := IfThen((osi.dwPlatformId = VER_PLATFORM_WIN32_NT), SizeOf(WideChar), SizeOf(Char));
        // p = *(LPBYTE *)((LPBYTE)_ImmLockIMCC( lpIC->hPrivate ) + 1*4 + 1*4 + 6*4);
        p:= PByte(PPointer(Longword(_ImmLockIMCC(lpIC^.hPrivate)) + 1*4 + 1*4 + 6*4)^);
        if (p <> nil) then
        begin
          dwReadingStrLen := PDWORD(Integer(p) + 1*4 + (16*2+2*4) + 5*4 + 16 * nTcharSize)^;
          dwErr := PDWORD(Integer(p) + 1*4 + (16*2+2*4) + 5*4 + 16 * nTcharSize + 1*4)^;
          wstr := PWideChar(Longword(p) + 1*4 + (16*2+2*4) + 5*4);
          bUnicodeIme := (osi.dwPlatformId = VER_PLATFORM_WIN32_NT);
        end;
      end;
    end; // case
  end;

  // Copy the reading string to the candidate list first
  s_CandList.awszCandidate[0][0] := #0;
  s_CandList.awszCandidate[1][0] := #0;
  s_CandList.awszCandidate[2][0] := #0;
  s_CandList.awszCandidate[3][0] := #0;
  s_CandList.dwCount := dwReadingStrLen;
  s_CandList.dwSelection := DWORD(-1); // do not select any char
  if bUnicodeIme then
  begin
    for i := 0 to dwReadingStrLen - 1 do // dwlen > 0, if known IME
    begin
      if (dwErr <= i) and (s_CandList.dwSelection = DWORD(-1)) then 
      begin
        // select error char
        s_CandList.dwSelection := i;
      end;

      s_CandList.awszCandidate[i][0] := wstr[i];
      s_CandList.awszCandidate[i][1] := #0;
    end;
    s_CandList.awszCandidate[dwReadingStrLen][0] := #0; //todo: check if this conversion is correct [dwReadingStrLen]==[i]
  end else
  begin
    pch := PChar(wstr);
    i := 0;
    // for i = 0, j = 0; i < dwReadingStrLen; ++i, ++j ) // dwlen > 0, if known IME
    for j := 0 to dwReadingStrLen - 1 do // dwlen > 0, if known IME
    begin
      if (dwErr <= i) and (s_CandList.dwSelection = DWORD(-1)) then
      begin
        s_CandList.dwSelection := j;
      end;
      // Obtain the current code page
      uCodePage := CP_ACP;  // Default code page
      if (GetLocaleInfoW(MAKELCID(GetLanguage, SORT_DEFAULT ),
                         LOCALE_IDEFAULTANSICODEPAGE,
                         wszCodePage,
                         SizeOf(wszCodePage) div SizeOf(wszCodePage[0])) <> 0) then
      begin
        {$IFDEF FPC}
        uCodePage := StrToInt(WideCharToString(wszCodePage)); // wcstoul(wszCodePage, nil, 0);
        {$ELSE}
        uCodePage := StrToInt(wszCodePage); // wcstoul(wszCodePage, nil, 0);
        {$ENDIF}
      end;
      MultiByteToWideChar(uCodePage, 0, pch + i,
                          IfThen(Boolean(IsDBCSLeadByteEx(uCodePage, Byte(pch[i]))), 2, 1),
                          s_CandList.awszCandidate[j], 1);
      if IsDBCSLeadByteEx(uCodePage, Byte(pch[i])) then Inc(i);
      Inc(i);
    end;
    s_CandList.awszCandidate[dwReadingStrLen][0] := #0;  //todo: check if this conversion is correct [dwReadingStrLen]==[j]
    s_CandList.dwCount := dwReadingStrLen;
  end;
  if (@_GetReadingString = nil) then
  begin
    _ImmUnlockIMCC(lpIC.hPrivate);
    _ImmUnlockIMC(hImc);
    GetReadingWindowOrientation(dwId);
  end;
  _ImmReleaseContext(z3DCore_GetHWND, hImc);

  if (pwszReadingStringBuffer <> nil) then
    HeapFree(GetProcessHeap, 0, pwszReadingStringBuffer);

  // Copy the string to the reading string buffer
  s_bShowReadingWindow := (s_CandList.dwCount > 0);
  if (s_bHorizontalReading) then
  begin
    s_CandList.nReadingError := -1;
    s_wszReadingString[0] := #0;
    for i := 0 to s_CandList.dwCount - 1 do
    begin
      if (s_CandList.dwSelection = DWORD(i)) then
        s_CandList.nReadingError := lstrlenW(s_wszReadingString);
      StringCchCat(s_wszReadingString, 32, s_CandList.awszCandidate[i]);
    end;
  end;

  s_CandList.dwPageSize := MAX_CANDLIST;
end;

// This function is used only briefly in CHT IME handling,
// so accelerator isn't processed.
procedure Tz3DIMEEditBox.PumpMessage;
var
  msg: TMSG;
begin
  while PeekMessageW(msg, 0, 0, 0, PM_NOREMOVE) do
  begin
    if (not GetMessageW(msg, 0, 0, 0)) then
    begin
      PostQuitMessage(msg.wParam);
      Exit;
    end;
    TranslateMessage(msg);
    DispatchMessageA(msg);
  end;
end;

procedure Tz3DIMEEditBox.OnFocusIn;
var
  hImc: Imm.HIMC;
begin
  inherited; // Tz3DEdit::OnFocusIn();

  if s_bEnableImeSystem then
  begin
    _ImmAssociateContext(z3DCore_GetHWND, s_hImcDef);
    CheckToggleState;
  end else
    _ImmAssociateContext(z3DCore_GetHWND, 0);

  //
  // Set up the IME global state according to the current instance state
  //
  hImc := _ImmGetContext(z3DCore_GetHWND);
  if (hImc <> 0) then
  begin
    if not s_bEnableImeSystem then s_ImeState := IMEUI_STATE_OFF;

    _ImmReleaseContext(z3DCore_GetHWND, hImc);
    CheckToggleState;
  end;
end;

procedure Tz3DIMEEditBox.OnFocusOut;
begin
  inherited; // Tz3DEdit::OnFocusOut();

  FinalizeString(False);  // Don't send the comp string as to match RichEdit behavior

  _ImmAssociateContext(z3DCore_GetHWND, 0);
end;

//Clootie: Delphi7 bug in Windows.pas
function GetKeyboardLayoutList(nBuff: Integer; List: Pointer): UINT; stdcall; external user32 name 'GetKeyboardLayoutList';

//#define PRIMARYLANGID(lgid)    ((WORD  )(lgid) & 0x3ff)
function PRIMARYLANGID(lgid: DWORD): Word;
begin
  Result:= (lgid and $3ff);
end;

//#define SUBLANGID(lgid)        ((WORD  )(lgid) >> 10)
function SUBLANGID(lgid: DWORD): Word;
begin
  Result:= (lgid shr 10);
end;

const
  WM_INPUTLANGCHANGE              = $0051;

class function Tz3DIMEEditBox.StaticMsgProc(uMsg: LongWord;
  wParam: WPARAM; lParam: LPARAM): BOOL;
type
  PHKLarray = ^THKLarray;
  THKLarray = array[0..MaxInt div SizeOf(Windows.HKL)-1] of Windows.HKL;
var
  hImc: Imm.HIMC;
  cKL: LongWord;
  phKL: PHKLarray; // ^Windows.HKL;
  i: LongWord;
  Locale: TInputLocale;
  bBreak: Boolean;
  e, l: Integer;
  wszDesc: array[0..127] of WideChar;
  uLang: LongWord;
begin
  Result:= False;
  if not s_bEnableImeSystem then Exit;

{$IFDEF DEBUG}
  FIMEStaticMsgProcCalled := True;
{$ENDIF}

  case uMsg of
    WM_ACTIVATEAPP:
      if (wParam <> 0) then
      begin
        // Populate s_Locale with the list of keyboard layouts.
        cKL := GetKeyboardLayoutList(0, nil);
        s_Locale:= nil; // RemoveAll;
        GetMem(phKL, SizeOf(HKL)*cKL);
        if (phKL <> nil) then //Clootie: This is aloways TRUE in Delphi (overwise exception will be raized)
        begin
          GetKeyboardLayoutList(cKL, phKL);
          for i := 0 to cKL-1 do
          begin
            // Filter out East Asian languages that are not IME.
            if ( (PRIMARYLANGID(LOWORD(phKL[i])) = LANG_CHINESE) or
                 (PRIMARYLANGID(LOWORD(phKL[i])) = LANG_JAPANESE) or
                 (PRIMARYLANGID(LOWORD(phKL[i])) = LANG_KOREAN)
                ) and
               not _ImmIsIME(phKL[i])
            then Continue;

            // If this language is already in the list, don't add it again.
            bBreak := False;
            for e := 0 to Length(s_Locale) - 1 do
              if (LOWORD(s_Locale[e].m_hKL) = LOWORD(phKL[i])) then
              begin
                bBreak := True;
                Break;
              end;

            if not bBreak then
            begin
              Locale.m_hKL := phKL[i];
              wszDesc[0] := #0;
              case PRIMARYLANGID(LOWORD(phKL[i])) of
                // Simplified Chinese
                LANG_CHINESE:
                  case SUBLANGID(LOWORD(phKL[i])) of
                    SUBLANG_CHINESE_SIMPLIFIED:  StringCchCopy(Locale.FLangAbb, 3, s_aszIndicator[INDICATOR_CHS]);
                    SUBLANG_CHINESE_TRADITIONAL: StringCchCopy(Locale.FLangAbb, 3, s_aszIndicator[INDICATOR_CHT]);
                  else // unsupported sub-language
                    GetLocaleInfoW(MAKELCID(LOWORD(phKL[i]), SORT_DEFAULT), LOCALE_SABBREVLANGNAME, wszDesc, 128);
                    Locale.FLangAbb[0] := wszDesc[0];
                    Locale.FLangAbb[1] := towlower(wszDesc[1]);
                    Locale.FLangAbb[2] := #0;
                  end;

                // Korean
                LANG_KOREAN: StringCchCopy(Locale.FLangAbb, 3, s_aszIndicator[INDICATOR_KOREAN]);

                // Japanese
                LANG_JAPANESE: StringCchCopy(Locale.FLangAbb, 3, s_aszIndicator[INDICATOR_JAPANESE]);

              else
                // A non-IME language.  Obtain the language abbreviation
                // and store it for rendering the indicator later.
                GetLocaleInfoW(MAKELCID(LOWORD(phKL[i]), SORT_DEFAULT), LOCALE_SABBREVLANGNAME, wszDesc, 128);
                Locale.FLangAbb[0] := wszDesc[0];
                Locale.FLangAbb[1] := towlower(wszDesc[1]);
                Locale.FLangAbb[2] := #0;
              end;

              GetLocaleInfoW(MAKELCID(LOWORD(phKL[i]), SORT_DEFAULT), LOCALE_SLANGUAGE, wszDesc, 128);
              StringCchCopy(Locale.FLang, 64, wszDesc);
              Locale.FLang[SizeOf(Locale.FLang) div SizeOf(Locale.FLang[0]) - 1] := #0;

              // s_Locale.Add(Locale);
              l:= Length(s_Locale);
              SetLength(s_Locale, l+1);
              s_Locale[l]:= Locale;
            end;
          end;
          FreeMem(phKL);
        end;
      end;

    WM_INPUTLANGCHANGE:
    begin
      z3DTraceDX(UnitName, $FFFF, 0, 'WM_INPUTLANGCHANGE'#10, False);
      begin
        uLang := GetPrimaryLanguage;
        CheckToggleState;
        if (uLang <> GetPrimaryLanguage) then
        begin
          // Korean IME always inserts on keystroke.  Other IMEs do not.
          s_bInsertOnType := (GetPrimaryLanguage = LANG_KOREAN);
        end;

        // IME changed.  Setup the new IME.
        SetupImeApi;
        if (@_ShowReadingWindow <> nil) then
        begin
          hImc := _ImmGetContext(z3DCore_GetHWND);
          if (hImc <> 0) then
          begin
            _ShowReadingWindow(hImc, False);
            _ImmReleaseContext(z3DCore_GetHWND, hImc);
          end;
        end;
      end;
      Result:= True;
      Exit;
    end;

    WM_IME_SETCONTEXT:
    begin
      z3DTraceDX(UnitName, $FFFF, 0, 'WM_IME_SETCONTEXT'#10, False);
      //
      // We don't want anything to display, so we have to clear this
      //
      // lParam := 0; // - never used
      Result:= False;
      Exit;
    end;

      // Handle WM_IME_STARTCOMPOSITION here since
      // we do not want the default IME handler to see
      // this when our fullscreen app is running.
    WM_IME_STARTCOMPOSITION:
    begin
      z3DTraceDX(UnitName, $FFFF, 0, 'WM_IME_STARTCOMPOSITION'#10, False);
      ResetCompositionString;
      // Since the composition string has its own caret, we don't render
      // the edit control's own caret to avoid double carets on screen.
      s_bHideCaret := True;
      Result:= True;
      Exit;
    end;

    WM_IME_COMPOSITION:
    begin
      z3DTraceDX(UnitName, $FFFF, 0, 'WM_IME_COMPOSITION'#10, False);
      Result:= False;
      Exit;
    end;
  end;

  Result:= False;
end;

function Tz3DIMEEditBox.HandleMouse(uMsg: LongWord; pt: TPoint;
  wParam: WPARAM; lParam: LPARAM): Boolean;
var
  pFont: Pz3DFontNode;
  nCompStrWidth: Integer;
  nCharBodyHit, nCharHit: Integer;
  nTrail: LongBool;
  hImc: Imm.HIMC;
  nClauseClicked: Integer;
  nClauseSelected: Integer;
  nVirtKey: Byte;
  nSendCount: Integer;
  nRow: Integer;
  nNumToHit: Integer;
  nStrike: Integer;
  nCandidate: Integer;
  nEntryStart: Integer;
  i: LongWord;
label
  label_LANG_CHINESE;
begin
  Result:= True;
  if (not FEnabled or not FVisible) then
  begin
    Result:= False;
    Exit;
  end;

  case uMsg of
    WM_LBUTTONDOWN,
    WM_LBUTTONDBLCLK:
    begin
      pFont := FDialog.GetFont(m_Displays[9].Font);

      // Check if this click is on top of the composition string
      s_CompString.CPtoX(s_CompString.TextSize, False, nCompStrWidth);

      if (s_ptCompString.x <= pt.x) and
         (s_ptCompString.y <= pt.y) and
         (s_ptCompString.x + nCompStrWidth > pt.x) and
         (s_ptCompString.y + pFont.Height > pt.y) then
      begin
        // Determine the character clicked on.
        s_CompString.XtoCP(pt.x - s_ptCompString.x, nCharBodyHit, nTrail);
        if nTrail and (nCharBodyHit < s_CompString.TextSize)
        then nCharHit := nCharBodyHit + 1
        else nCharHit := nCharBodyHit;

        // Now generate keypress events to move the comp string cursor
        // to the click point.  First, if the candidate window is displayed,
        // send Esc to close it.
        hImc := _ImmGetContext(z3DCore_GetHWND);
        if (hImc = 0) then Exit;

        _ImmNotifyIME(hImc, NI_CLOSECANDIDATE, 0, 0);
        _ImmReleaseContext(z3DCore_GetHWND, hImc);

        if (GetPrimaryLanguage = LANG_JAPANESE) then
        begin
          // For Japanese, there are two cases.  If s_nFirstTargetConv is
          // -1, the comp string hasn't been converted yet, and we use
          // s_nCompCaret.  For any other value of s_nFirstTargetConv,
          // the string has been converted, so we use clause information.

          if (s_nFirstTargetConv <> -1) then
          begin
            nClauseClicked := 0;
            while (s_adwCompStringClause[nClauseClicked + 1] <= LongWord(nCharBodyHit))
            do Inc(nClauseClicked);

            nClauseSelected := 0;
            while (s_adwCompStringClause[nClauseSelected + 1] <= LongWord(s_nFirstTargetConv))
            do Inc(nClauseSelected);

            nVirtKey := Byte(IfThen(nClauseClicked > nClauseSelected, VK_RIGHT, VK_LEFT));
            nSendCount := Abs(nClauseClicked - nClauseSelected);
            // while ( nSendCount-- > 0 )
            while (nSendCount > 0 ) do
            begin
              Dec(nSendCount);
              SendKey(nVirtKey);
            end;
            Exit;
          end;

          // Not converted case. Fall thru to Chinese case.
          goto label_LANG_CHINESE; //Clootie: this is due to awfull usage of switch statement in C++
        end else
        if (GetPrimaryLanguage = LANG_CHINESE) then
        begin
          label_LANG_CHINESE:

          // For Chinese, use s_nCompCaret.
          nVirtKey := Byte(IfThen(nCharHit > s_nCompCaret, VK_RIGHT, VK_LEFT));
          nSendCount := Abs(nCharHit - s_nCompCaret);
          while (nSendCount > 0) do
          begin
            Dec(nSendCount);
            SendKey(nVirtKey);
          end;
        end;

        Exit;
      end;

      // Check if the click is on top of the candidate window
      if (s_CandList.bShowWindow and PtInRect(s_CandList.rcCandidate, pt)) then
      begin
        if (s_bVerticalCand) then
        begin
          // Vertical candidate window

          // Compute the row the click is on
          nRow := (pt.y - s_CandList.rcCandidate.top) div pFont.Height;

          if (LongWord(nRow) < s_CandList.dwCount) then
          begin
            // nRow is a valid entry.
            // Now emulate keystrokes to select the candidate at this row.
            case GetPrimaryLanguage of
              LANG_CHINESE,
              LANG_KOREAN:
                // For Chinese and Korean, simply send the number keystroke.
                SendKey(Ord('0') + nRow + 1);

              LANG_JAPANESE:
              begin
                // For Japanese, move the selection to the target row,
                // then send Right, then send Left.

                if (LongWord(nRow) > s_CandList.dwSelection)
                  then nVirtKey := VK_DOWN
                  else nVirtKey := VK_UP;

                nNumToHit := Abs(nRow - Integer(s_CandList.dwSelection));
                for nStrike := 0 to nNumToHit - 1 do SendKey(nVirtKey);

                // Do this to close the candidate window without ending composition.
                SendKey(VK_RIGHT);
                SendKey(VK_LEFT);
              end;
            end; {case}
          end
        end else
        begin
          // Horizontal candidate window

          // Determine which the character the click has hit.
          s_CandList.HoriCand.XtoCP(pt.x - s_CandList.rcCandidate.left, nCharHit, nTrail);

          // Determine which candidate string the character belongs to.
          nCandidate := s_CandList.dwCount - 1;

          nEntryStart := 0;
          for i := 0 to s_CandList.dwCount - 1 do
          begin
            if (nCharHit >= nEntryStart) then
            begin
              // Haven't found it.
              Inc(nEntryStart, lstrlenW(s_CandList.awszCandidate[i] ) + 1);  // plus space separator
            end else
            begin
              // Found it.  This entry starts at the right side of the click point,
              // so the char belongs to the previous entry.
              nCandidate := i - 1;
              Break;
            end;
          end;

          // Now emulate keystrokes to select the candidate entry.
          case GetPrimaryLanguage of
            LANG_CHINESE,
            LANG_KOREAN:
              // For Chinese and Korean, simply send the number keystroke.
              SendKey(Ord('0') + nCandidate + 1);
          end;
        end;

        Exit;
      end;
    end;
  end;

  // If we didn't care for the msg, let the parent process it.
  Result:= inherited {Cz3DEdit::}HandleMouse(uMsg, pt, wParam, lParam);
end;

var
  lAlt:   DWORD = $80000000;
  lCtrl:  DWORD = $80000000;
  lShift: DWORD = $80000000;

function Tz3DIMEEditBox.MsgProc(uMsg: LongWord; wParam: WPARAM;
  lParam: LPARAM): Boolean;
var
  trappedData: Boolean;
  trapped: {$IFDEF FPC}System.{$ENDIF}PBoolean;
  hImc: Imm.HIMC;
  lRet: Longint;  // Returned count in CHARACTERS
  wszCompStr: array[0..MAX_COMPSTRING_SIZE-1] of WideChar;
  i, j: Integer;
  nCount: Integer;
  lpCandList: PCandidateList;
  dwLenRequired: DWORD;
  nPageTopIndex: Integer;
  pwsz: PWideChar;
  pwszNewCand: PWideChar;
  wszCand: array[0..255] of WideChar;
  wszEntry: array[0..31] of WideChar;
  dwId: DWORD;
begin
  // Result:= True; // - never used
  if (not FEnabled or not FVisible) then
  begin
    Result:= False;
    Exit;
  end;

{$IFDEF DEBUG}
  Assert(FIMEStaticMsgProcCalled, 'To fix, call Tz3DGUIController.MsgProc() first');
{$ENDIF}

  trapped := @trappedData;

  trapped^ := False;
  if (not s_bEnableImeSystem) then
  begin
    Result:= inherited {Cz3DEdit::}MsgProc(uMsg, wParam, lParam);
    Exit;
  end;

  case uMsg of
    //
    //  IME Handling
    //
    WM_IME_COMPOSITION:
    begin
      z3DTraceDX(UnitName, $FFFF, 0, 'WM_IME_COMPOSITION'#10, False);

      trapped^ := True;
      hImc := _ImmGetContext(z3DCore_GetHWND);
      if (0 <> hImc) then
      begin
        // Get the caret position in composition string
        if (lParam and GCS_CURSORPOS <> 0) then
        begin
          s_nCompCaret := _ImmGetCompositionStringW(hImc, GCS_CURSORPOS, nil, 0);
          if (s_nCompCaret < 0) then s_nCompCaret := 0; // On error, set caret to pos 0.
        end;

        // ResultStr must be processed before composition string.
        //
        // This is because for some IMEs, such as CHT, pressing Enter
        // to complete the composition sends WM_IME_COMPOSITION with both
        // GCS_RESULTSTR and GCS_COMPSTR.  Retrieving the result string
        // gives the correct string, while retrieving the comp string
        // (GCS_COMPSTR) gives empty string.  GCS_RESULTSTR should be
        // handled first so that the application receives the string.  Then
        // GCS_COMPSTR can be handled to clear the comp string buffer.

        if (lParam and GCS_RESULTSTR <> 0) then
        begin
          z3DTraceDX(UnitName, $FFFF, 0, '  GCS_RESULTSTR'#10, False);
          lRet := _ImmGetCompositionStringW(hImc, GCS_RESULTSTR, @wszCompStr, SizeOf(wszCompStr));
          if (lRet > 0) then
          begin
            lRet:= lRet div SizeOf(WideChar);
            wszCompStr[lRet] := #0;  // Force terminate
            TruncateCompString(False, lstrlenW(wszCompStr));
            s_CompString.SetText(wszCompStr);
            SendCompString;
            ResetCompositionString;
          end;
        end;

        //
        // Reads in the composition string.
        //
        if (lParam and GCS_COMPSTR <> 0) then
        begin
          z3DTraceDX(UnitName, $FFFF, 0, '  GCS_COMPSTR'#10, False);
          //////////////////////////////////////////////////////
          // Retrieve the latest user-selected IME candidates
          lRet := _ImmGetCompositionStringW(hImc, GCS_COMPSTR, @wszCompStr, SizeOf(wszCompStr));
          if (lRet > 0) then
          begin
            lRet:= lRet div SizeOf(WideChar);  // Convert size in byte to size in char
            wszCompStr[lRet] := #0;  // Force terminate
            //
            // Remove the whole of the string
            //
            TruncateCompString(False, lstrlenW(wszCompStr));

            s_CompString.SetText(wszCompStr);

            // Older CHT IME uses composition string for reading string
            if (GetLanguage = LANG_CHT) and not (GetImeId <> 0) then
            begin
              if lstrlenW(s_CompString.Buffer) <> 0 then
              begin
                s_CandList.dwCount := 4;             // Maximum possible length for reading string is 4
                s_CandList.dwSelection := DWORD(-1); // don't select any candidate

                // Copy the reading string to the candidate list
                for i := 3 downto 0 do
                begin
                  if (i > lstrlenW(s_CompString.Buffer) - 1) then
                    s_CandList.awszCandidate[i][0] := #0  // Doesn't exist
                  else
                  begin
                    s_CandList.awszCandidate[i][0] := s_CompString[i];
                    s_CandList.awszCandidate[i][1] := #0;
                  end;
                end;
                s_CandList.dwPageSize := MAX_CANDLIST;
                // Clear comp string after we are done copying
                ZeroMemory(s_CompString.Buffer, 4 * SizeOf(WideChar));
                s_bShowReadingWindow := True;
                GetReadingWindowOrientation(0);
                if (s_bHorizontalReading) then
                begin
                  s_CandList.nReadingError := -1;  // Clear error

                  // Create a string that consists of the current
                  // reading string.  Since horizontal reading window
                  // is used, we take advantage of this by rendering
                  // one string instead of several.
                  //
                  // Copy the reading string from the candidate list
                  // to the reading string buffer.
                  s_wszReadingString[0] := #0;
                  for i := 0 to s_CandList.dwCount - 1 do
                  begin
                    if (s_CandList.dwSelection = DWORD(i)) then
                      s_CandList.nReadingError := lstrlenW(s_wszReadingString);
                    StringCchCat(s_wszReadingString, 32, s_CandList.awszCandidate[i]);
                  end;
                end;
              end else
              begin
                s_CandList.dwCount := 0;
                s_bShowReadingWindow := False;
              end;
            end;

            if (s_bInsertOnType) then
            begin
              // Send composition string to the edit control
              SendCompString;
              // Restore the caret to the correct location.
              // It's at the end right now, so compute the number
              // of times left arrow should be pressed to
              // send it to the original position.
              nCount := lstrlenW(s_CompString.Buffer + s_nCompCaret);
              // Send left keystrokes
              for i := 0 to nCount - 1 do
                SendMessage(z3DCore_GetHWND, WM_KEYDOWN, VK_LEFT, 0);
              SendMessage(z3DCore_GetHWND, WM_KEYUP, VK_LEFT, 0);
            end;
          end;

          ResetCaretBlink;
        end;

        // Retrieve comp string attributes
        if (lParam and GCS_COMPATTR <> 0) then
        begin
          lRet := _ImmGetCompositionStringW(hImc, GCS_COMPATTR, @s_abCompStringAttr, SizeOf(s_abCompStringAttr));
          if (lRet > 0) then s_abCompStringAttr[lRet] := 0;  // ??? Is this needed for attributes?
        end;

        // Retrieve clause information
        if (lParam and GCS_COMPCLAUSE <> 0) then
        begin
          lRet := _ImmGetCompositionStringW(hImc, GCS_COMPCLAUSE, @s_adwCompStringClause, SizeOf(s_adwCompStringClause));
          s_adwCompStringClause[lRet div SizeOf(DWORD)] := 0;  // Terminate
        end;

        _ImmReleaseContext(z3DCore_GetHWND, hImc);
      end;
    end; {:WM_IME_COMPOSITION:}

    WM_IME_ENDCOMPOSITION:
    begin
      z3DTraceDX(UnitName, $FFFF, 0, 'WM_IME_ENDCOMPOSITION'#10, False);
      TruncateCompString;
      ResetCompositionString;
      // We can show the edit control's caret again.
      s_bHideCaret := False;
      // Hide reading window
      s_bShowReadingWindow := False;
    end;

    WM_IME_NOTIFY:
    begin
      z3DTraceDX(UnitName, $FFFF, 0, PWideChar(WideString('WM_IME_NOTIFY ') + IntToStr(wParam) + #10), False);

      case wParam of
        IMN_SETCONVERSIONMODE,
        IMN_SETOPENSTATUS:
        begin
          if (wParam = IMN_SETCONVERSIONMODE)
          then z3DTraceDX(UnitName, $FFFF, 0, '  IMN_SETCONVERSIONMODE'#10, False)
          else z3DTraceDX(UnitName, $FFFF, 0, '  IMN_SETOPENSTATUS'#10, False);
          CheckToggleState;
        end;

        IMN_OPENCANDIDATE,
        IMN_CHANGECANDIDATE:
        begin
          if (wParam = IMN_CHANGECANDIDATE)
          then z3DTraceDX(UnitName, $FFFF, 0, '  IMN_CHANGECANDIDATE'#10, False)
          else z3DTraceDX(UnitName, $FFFF, 0, '  IMN_OPENCANDIDATE'#10, False);

          s_CandList.bShowWindow := True;
          trapped^ := True;
          hImc := _ImmGetContext(z3DCore_GetHWND);
          if (hImc <> 0) then
          begin
            lpCandList := nil;

            s_bShowReadingWindow := False;
            // Retrieve the candidate list
            dwLenRequired := _ImmGetCandidateListW(hImc, 0, nil, 0);
            if (dwLenRequired <> 0) then
            begin
              lpCandList := PCandidateList(HeapAlloc(GetProcessHeap, 0, dwLenRequired));
              {dwLenRequired := }_ImmGetCandidateListW(hImc, 0, lpCandList, dwLenRequired);
            end;

            if (lpCandList <> nil) then
            begin
              // Update candidate list data
              s_CandList.dwSelection := lpCandList.dwSelection;
              s_CandList.dwCount := lpCandList.dwCount;

              // nPageTopIndex := 0; // - never used
              s_CandList.dwPageSize := DWORD(Min(lpCandList.dwPageSize, MAX_CANDLIST));
              if (GetPrimaryLanguage = LANG_JAPANESE) then
              begin
                // Japanese IME organizes its candidate list a little
                // differently from the other IMEs.
                nPageTopIndex := (s_CandList.dwSelection div s_CandList.dwPageSize) * s_CandList.dwPageSize;
              end
              else
                nPageTopIndex := lpCandList.dwPageStart;

              // Make selection index relative to first entry of page
              s_CandList.dwSelection := IfThen((GetLanguage = LANG_CHS) and (GetImeId = 0),
                                          -1, Integer(s_CandList.dwSelection) - nPageTopIndex);

              ZeroMemory(@s_CandList.awszCandidate, SizeOf(s_CandList.awszCandidate));
              {for i := nPageTopIndex, j := 0;
                  (DWORD)i < lpCandList->dwCount && j < s_CandList.dwPageSize;
                  i++, j++ )}
              i := nPageTopIndex; j := 0;
              while (i < Integer(lpCandList.dwCount)) and (j < Integer(s_CandList.dwPageSize)) do
              begin
                // Initialize the candidate list strings
                pwsz := s_CandList.awszCandidate[j];
                // For every candidate string entry,
                // write [index] + Space + [String] if vertical,
                // write [index] + [String] + Space if horizontal.
                pwsz^:= WideChar(Ord('0') + ( (j + 1) mod 10)); Inc(pwsz); // Index displayed is 1 based

                if (s_bVerticalCand) then
                begin
                  pwsz^ := ' ';
                  Inc(pwsz);
                end;

                pwszNewCand := PWideChar(PChar{PByte}(lpCandList) + lpCandList.dwOffset[i]);
                while (pwszNewCand^ <> #0) do
                begin
                  pwsz^ := pwszNewCand^;
                  Inc(pwsz);
                  Inc(pwszNewCand);
                end;

                if (not s_bVerticalCand) then
                begin
                  pwsz^ := ' ';
                  Inc(pwsz);
                end;
                pwsz^ := #0;  // Terminate

                Inc(i); Inc(j);
              end;

              // Make dwCount in s_CandList be number of valid entries in the page.
              s_CandList.dwCount := lpCandList.dwCount - lpCandList.dwPageStart;
              if (s_CandList.dwCount > lpCandList.dwPageSize)
              then s_CandList.dwCount := lpCandList.dwPageSize;

              HeapFree(GetProcessHeap, 0, lpCandList);
              _ImmReleaseContext(z3DCore_GetHWND, hImc);

              // Korean and old Chinese IME can't have selection.
              // User must use the number hotkey or Enter to select
              // a candidate.
              if (GetPrimaryLanguage = LANG_KOREAN) or
                 (GetLanguage = LANG_CHT) and (GetImeId = 0) then
              begin
                s_CandList.dwSelection := DWORD(-1);
              end;

              // Initialize s_CandList.HoriCand if we have a
              // horizontal candidate window.
              if (not s_bVerticalCand) then
              begin
                ZeroMemory(@wszCand, SizeOf(wszCand));

                s_CandList.nFirstSelected := 0;
                s_CandList.nHoriSelectedLen := 0;
                for i := 0 to MAX_CANDLIST - 1 do
                begin
                  if (s_CandList.awszCandidate[i][0] = #0) then Break;

                  StringCchFormat(wszEntry, 32, '%s ', [s_CandList.awszCandidate[i]]);
                  // If this is the selected entry, mark its char position.
                  if (Integer(s_CandList.dwSelection) = i) then
                  begin
                    s_CandList.nFirstSelected := lstrlenW(wszCand);
                    s_CandList.nHoriSelectedLen := lstrlenW(wszEntry) - 1;  // Minus space
                  end;
                  StringCchCat(wszCand, 256, wszEntry);
                end;
                wszCand[lstrlenW(wszCand) - 1] := #0;  // Remove the last space
                s_CandList.HoriCand.SetText(wszCand);
              end;
            end;
          end;
        end;

        IMN_CLOSECANDIDATE:
        begin
          z3DTraceDX(UnitName, $FFFF, 0, '  IMN_CLOSECANDIDATE'#10, False);
          s_CandList.bShowWindow := False;
          if not s_bShowReadingWindow then
          begin
            s_CandList.dwCount := 0;
            ZeroMemory(@s_CandList.awszCandidate, SizeOf(s_CandList.awszCandidate));
          end;
          trapped^ := True;
        end;

        IMN_PRIVATE:
        begin
          z3DTraceDX(UnitName, $FFFF, 0, '  IMN_PRIVATE'#10, False);
          if not s_CandList.bShowWindow then GetPrivateReadingString;

          // Trap some messages to hide reading window
          dwId := GetImeId;
          case dwId of
            IMEID_CHT_VER42,
            IMEID_CHT_VER43,
            IMEID_CHT_VER44,
            IMEID_CHS_VER41,
            IMEID_CHS_VER42:
              if (lParam = 1) or (lParam = 2) then
              begin
                trapped^ := True;
              end;

            IMEID_CHT_VER50,
            IMEID_CHT_VER51,
            IMEID_CHT_VER52,
            IMEID_CHT_VER60,
            IMEID_CHS_VER53:
              if (lParam = 16) or (lParam = 17) or (lParam = 26) or (lParam = 27) or (lParam = 28) then
              begin
                trapped^ := True;
              end;
          end;
        end;

      else {case}
          trapped^ := True;
      end;
    end;

    // fix for #15386 - When Text Service Framework is installed in Win2K, Alt+Shift and Ctrl+Shift combination (to switch
    // input locale / keyboard layout) doesn't send WM_KEYUP message for the key that is released first. We need to check
    // if these keys are actually up whenever we receive key up message for other keys.
    WM_KEYUP,
    WM_SYSKEYUP,
    WM_KEYDOWN,
    WM_SYSKEYDOWN:
    begin
      if (uMsg = WM_KEYUP) or (uMsg = WM_SYSKEYUP) then
      begin
        // if ( !( lAlt & 0x80000000 ) && wParam != VK_MENU && ( GetAsyncKeyState( VK_MENU ) & 0x8000 ) == 0 )
        if (lAlt and $80000000 = 0) and (wParam <> VK_MENU) and (GetAsyncKeyState(VK_MENU) and $8000 = 0) then
        begin
          PostMessageW(GetFocus, WM_KEYUP, VK_MENU, (lAlt and $01ff0000) or $C0000001);
        end
        // else if ( !( lCtrl & 0x80000000 ) && wParam != VK_CONTROL && ( GetAsyncKeyState( VK_CONTROL ) & 0x8000 ) == 0 )
        else if (lCtrl and $80000000 = 0) and (wParam <> VK_CONTROL) and (GetAsyncKeyState(VK_CONTROL) and $8000 = 0) then
        begin
          PostMessageW(GetFocus, WM_KEYUP, VK_CONTROL, (lCtrl and $01ff0000 ) or $C0000001);
        end
        // else if ( !( lShift & 0x80000000 ) && wParam != VK_SHIFT && ( GetAsyncKeyState( VK_SHIFT ) & 0x8000 ) == 0 )
        else if (lShift and $80000000 = 0) and (wParam <> VK_SHIFT) and (GetAsyncKeyState(VK_SHIFT) and $8000 = 0) then
        begin
          PostMessageW(GetFocus, WM_KEYUP, VK_SHIFT, (lShift and $01ff0000) or $C0000001);
        end;
      end;
    // fall through WM_KEYDOWN / WM_SYSKEYDOWN
   {WM_KEYDOWN, WM_SYSKEYDOWN:}
      case wParam of
        VK_MENU:    lAlt := lParam;
        VK_SHIFT:   lShift := lParam;
        VK_CONTROL: lCtrl := lParam;
      end;
      //break;
      // Fall through to default case
      // so we invoke the parent.
      Result:= inherited {Cz3DEdit::}MsgProc(uMsg, wParam, lParam);
      Exit;
    end;

    else
      // Let the parent handle the message that we
      // don't handle.
      Result:= inherited {Cz3DEdit::}MsgProc(uMsg, wParam, lParam);
      Exit;
  end; // case

  Result:= trapped^;
end;

procedure Tz3DIMEEditBox.RenderCandidateReadingWindow(bReading: Boolean);
var
  rc: TRect;
  nNumEntries: LongWord;
  TextColor, TextBkColor, SelTextColor, SelBkColor: TD3DColor;
  nX, nXFirst, nXComp: Integer;
  nWidthRequired: Integer;
  nHeightRequired: Integer;
  nSingleLineHeight: Integer;
  i: LongWord;
  bHasPosition: Boolean;
  nXCompTrail: Integer;
  nXLeft, nXRight: Integer;
begin
  nNumEntries := IfThen(bReading, 4, MAX_CANDLIST);
  m_Buffer.CPtoX(FCaret, False, nX);
  m_Buffer.CPtoX(FFirstVisible, False, nXFirst);

  if bReading then
  begin
    TextColor := m_ReadingColor;
    TextBkColor := m_ReadingWinColor;
    SelTextColor := m_ReadingSelColor;
    SelBkColor := m_ReadingSelBkColor;
  end else
  begin
    TextColor := m_CandidateColor;
    TextBkColor := m_CandidateWinColor;
    SelTextColor := m_CandidateSelColor;
    SelBkColor := m_CandidateSelBkColor;
  end;

  // For Japanese IME, align the window with the first target converted character.
  // For all other IMEs, align with the caret.  This is because the caret
  // does not move for Japanese IME.
  if (GetLanguage = LANG_CHT) and (GetImeId = 0) then nXComp := 0
  else
  if (GetPrimaryLanguage = LANG_JAPANESE) then
    s_CompString.CPtoX(s_nFirstTargetConv, False, nXComp)
  else
    s_CompString.CPtoX(s_nCompCaret, False, nXComp);

  // Compute the size of the candidate window
  nWidthRequired := 0;
  // nHeightRequired := 0; // - never used
  nSingleLineHeight := 0;

  if (s_bVerticalCand and not bReading) or
     (not s_bHorizontalReading and bReading) then
  begin
    // Vertical window
    for i := 0 to nNumEntries - 1 do
    begin
      if (s_CandList.awszCandidate[i][0] = #0) then Break;

      SetRect(rc, 0, 0, 0, 0);
      FDialog.CalcTextRect(s_CandList.awszCandidate[i], m_Displays[1], @rc);
      nWidthRequired := Max(nWidthRequired, rc.right - rc.left);
      nSingleLineHeight := Max(nSingleLineHeight, rc.bottom - rc.top);
    end;
    nHeightRequired := nSingleLineHeight * Integer(nNumEntries);
  end else
  begin
    // Horizontal window
    SetRect(rc, 0, 0, 0, 0);
    if (bReading) then
      FDialog.CalcTextRect(s_wszReadingString, m_Displays[1], @rc)
    else
      FDialog.CalcTextRect(s_CandList.HoriCand.Buffer, m_Displays[1], @rc);
    nWidthRequired := rc.right - rc.left;
    nHeightRequired := rc.bottom - rc.top;
    nSingleLineHeight := nHeightRequired;
  end;

  // Now that we have the dimension, calculate the location for the candidate window.
  // We attempt to fit the window in this order:
  // bottom, top, right, left.

  bHasPosition := False;

  // Bottom
  SetRect(rc, s_ptCompString.x + nXComp, s_ptCompString.y + FText.bottom - FText.top,
              s_ptCompString.x + nXComp + nWidthRequired, s_ptCompString.y + FText.bottom - FText.top + nHeightRequired);
  // if the right edge is cut off, move it left.
  if (rc.right > FDialog.Width) then
  begin
    Dec(rc.left, rc.right - FDialog.Width);
    rc.right := FDialog.Width;
  end;
  if (rc.bottom <= FDialog.Height) then bHasPosition := True;

  // Top
  if not bHasPosition then
  begin
    SetRect(rc, s_ptCompString.x + nXComp, s_ptCompString.y - nHeightRequired,
                s_ptCompString.x + nXComp + nWidthRequired, s_ptCompString.y);
    // if the right edge is cut off, move it left.
    if (rc.right > FDialog.Width) then
    begin
      Dec(rc.left, rc.right - FDialog.Width);
      rc.right := FDialog.Width;
    end;
    if (rc.top >= 0) then bHasPosition := True;
  end;

  // Right
  if not bHasPosition then
  begin
    s_CompString.CPtoX(s_nCompCaret, True, nXCompTrail);
    SetRect(rc, s_ptCompString.x + nXCompTrail, 0,
                s_ptCompString.x + nXCompTrail + nWidthRequired, nHeightRequired);
    if (rc.right <= FDialog.Width) then bHasPosition := True;
  end;

  // Left
  if not bHasPosition then
  begin
    SetRect(rc, s_ptCompString.x + nXComp - nWidthRequired, 0,
                s_ptCompString.x + nXComp, nHeightRequired);
    if (rc.right >= 0) then bHasPosition := True;
  end;

  if not bHasPosition then
  begin
    // The dialog is too small for the candidate window.
    // Fall back to render at 0, 0.  Some part of the window
    // will be cut off.
    rc.left := 0;
    rc.right := nWidthRequired;
  end;

  // If we are rendering the candidate window, save the position
  // so that mouse clicks are checked properly.
  if not bReading then s_CandList.rcCandidate := rc;

  // Render the elements
  FDialog.DrawRect(rc, TextBkColor);
  if (s_bVerticalCand and not bReading) or
     (not s_bHorizontalReading and bReading) then
  begin
    // Vertical candidate window
    for i := 0 to nNumEntries - 1 do
    begin
      // Here we are rendering one line at a time
      rc.bottom := rc.top + nSingleLineHeight;
      // Use a different color for the selected string
      if (s_CandList.dwSelection = i) then
      begin
        FDialog.DrawRect(rc, SelBkColor);
        m_Displays[1].FontColor.Current := D3DXColorFromDWord(SelTextColor);
      end else
        m_Displays[1].FontColor.Current := D3DXColorFromDWord(TextColor);

      FDialog.DrawText(s_CandList.awszCandidate[i], m_Displays[1], rc);

      Inc(rc.top, nSingleLineHeight);
    end;
  end else
  begin
    // Horizontal candidate window
    m_Displays[1].FontColor.Current := D3DXColorFromDWord(TextColor);
    if bReading then
      FDialog.DrawText(s_wszReadingString, m_Displays[1], rc)
    else
      FDialog.DrawText(s_CandList.HoriCand.Buffer, m_Displays[1], rc);

    // Render the selected entry differently
    if not bReading then
    begin
      s_CandList.HoriCand.CPtoX(s_CandList.nFirstSelected, False, nXLeft);
      s_CandList.HoriCand.CPtoX(s_CandList.nFirstSelected + s_CandList.nHoriSelectedLen, False, nXRight);

      rc.right := rc.left + nXRight;
      Inc(rc.left, nXLeft);
      FDialog.DrawRect(rc, SelBkColor);
      m_Displays[1].FontColor.Current := D3DXColorFromDWord(SelTextColor);
      FDialog.DrawText(s_CandList.HoriCand.Buffer + s_CandList.nFirstSelected,
                         m_Displays[1], rc, False, s_CandList.nHoriSelectedLen);
    end;
  end;
end;

procedure Tz3DIMEEditBox.RenderComposition();
var
  rcCaret, rcFirst: TRect;
  nX, nXFirst: Integer;
  pDisplay: Iz3DDisplay;
  rc: TRect;
  TextColor: TD3DColor;
  pwszComp: PWideChar;
  nCharLeft: Integer;
  nLastInLine: Integer;
  bTrail: LongBool;
  nNumCharToDraw: Integer;
  nCharFirst: Integer;
  pAttr: PByte;
  pcComp: PWideChar;
  bkColor: TD3DColor;
  nXLeft, nXRight: Integer;
  rcTarget: TRect;
begin
  rcCaret := Rect(0, 0, 0, 0);
  m_Buffer.CPtoX(FCaret, False, nX);
  m_Buffer.CPtoX(FFirstVisible, False, nXFirst);
  pDisplay := m_Displays[1];

  // Get the required width
  rc := Rect(FText.left + nX - nXFirst, FText.top,
             FText.left + nX - nXFirst, FText.bottom);
  FDialog.CalcTextRect(s_CompString.Buffer, pDisplay, @rc);

  // If the composition string is too long to fit within
  // the text area, move it to below the current line.
  // This matches the behavior of the default IME.
  if (rc.right > FText.right) then
    OffsetRect(rc, FText.left - rc.left, rc.bottom - rc.top);

  // Save the rectangle position for processing highlighted text.
  rcFirst := rc;

  // Update s_ptCompString for RenderCandidateReadingWindow().
  s_ptCompString.x := rc.left; s_ptCompString.y := rc.top;

  TextColor := m_CompColor;
  // Render the window and string.
  // If the string is too long, we must wrap the line.
  pDisplay.FontColor.Current := D3DXColorFromDWord(TextColor);
  pwszComp := s_CompString.Buffer;
  nCharLeft := s_CompString.TextSize;
  while True do
  begin
    // Find the last character that can be drawn on the same line.
    s_CompString.XtoCP(FText.right - rc.left, nLastInLine, bTrail);
    nNumCharToDraw := Min(nCharLeft, nLastInLine);
    FDialog.CalcTextRect(pwszComp, pDisplay, @rc, nNumCharToDraw);

    // Draw the background
    // For Korean IME, blink the composition window background as if it
    // is a cursor.
    if (GetPrimaryLanguage = LANG_KOREAN) then
    begin
      if FCaretOn then
      begin
        FDialog.DrawRect(rc, m_CompWinColor);
      end else
      begin
        // Not drawing composition string background. We
        // use the editbox's text color for composition
        // string text.
        TextColor := m_Displays[0].FontColor.States[z3dcsNormal];
      end;
    end else
    begin
      // Non-Korean IME. Always draw composition background.
      FDialog.DrawRect(rc, m_CompWinColor);
    end;

    // Draw the text
    pDisplay.FontColor.Current := D3DXColorFromDWord(TextColor);
    FDialog.DrawText(pwszComp, pDisplay, rc, False, nNumCharToDraw);

    // Advance pointer and counter
    Dec(nCharLeft, nNumCharToDraw);
    Inc(pwszComp, nNumCharToDraw);
    if (nCharLeft <= 0) then Break;

    // Advance rectangle coordinates to beginning of next line
    OffsetRect(rc, FText.left - rc.left, rc.bottom - rc.top);
  end;

  // Load the rect for the first line again.
  rc := rcFirst;

  // Inspect each character in the comp string.
  // For target-converted and target-non-converted characters,
  // we display a different background color so they appear highlighted.
  //nCharFirst := 0;
  nXFirst := 0;
  s_nFirstTargetConv := -1;
//  for pcComp := s_CompString.GetBuffer, pAttr := s_abCompStringAttr;
//        *pcComp != L'\0'; ++pcComp, ++pAttr )
  pcComp := s_CompString.Buffer;
  pAttr := @s_abCompStringAttr;
  bkColor:= 0;
  while (pcComp^ <> #0) do
  begin
    // Render a different background for this character
    s_CompString.CPtoX(Integer(pcComp - s_CompString.Buffer), False, nXLeft);
    s_CompString.CPtoX(Integer(pcComp - s_CompString.Buffer), True, nXRight);

    // Check if this character is off the right edge and should
    // be wrapped to the next line.
    if (nXRight - nXFirst > FText.right - rc.left) then
    begin
      // Advance rectangle coordinates to beginning of next line
      OffsetRect(rc, FText.left - rc.left, rc.bottom - rc.top);

      // Update the line's first character information
      nCharFirst := Integer(pcComp - s_CompString.Buffer);
      s_CompString.CPtoX(nCharFirst, False, nXFirst);
    end;

    // If the caret is on this character, save the coordinates
    // for drawing the caret later.
    if (s_nCompCaret = Integer(pcComp - s_CompString.Buffer)) then
    begin
      rcCaret := rc;
      Inc(rcCaret.left, nXLeft - nXFirst - 1);
      rcCaret.right := rcCaret.left + 2;
    end;

    // Set up color based on the character attribute
    if (pAttr^ = ATTR_TARGET_CONVERTED) then
    begin
      pDisplay.FontColor.Current := D3DXColorFromDWord(m_CompTargetColor);
      bkColor := m_CompTargetBkColor;
    end else
    if (pAttr^ = ATTR_TARGET_NOTCONVERTED) then
    begin
      pDisplay.FontColor.Current := D3DXColorFromDWord(m_CompTargetNonColor);
      bkColor := m_CompTargetNonBkColor;
    end else
    begin
      Inc(pcComp); Inc(pAttr);
      Continue;
    end;

    rcTarget := Rect(rc.left + nXLeft - nXFirst, rc.top, rc.left + nXRight - nXFirst, rc.bottom);
    FDialog.DrawRect(rcTarget, bkColor);
    FDialog.DrawText(pcComp, pDisplay, rcTarget, False, 1);

    // Record the first target converted character's index
    if (-1 = s_nFirstTargetConv) then
      s_nFirstTargetConv := Integer(pAttr) - Integer(@s_abCompStringAttr);

    Inc(pcComp); Inc(pAttr);
  end;

  // Render the composition caret
  if FCaretOn then
  begin
    // If the caret is at the very end, its position would not have
    // been computed in the above loop.  We compute it here.
    if (s_nCompCaret = s_CompString.TextSize) then
    begin
      s_CompString.CPtoX(s_nCompCaret, False, nX);
      rcCaret := rc;
      Inc(rcCaret.left, nX - nXFirst - 1);
      rcCaret.right := rcCaret.left + 2;
    end;

    FDialog.DrawRect(rcCaret, m_CompCaretColor);
  end;
end;

procedure Tz3DIMEEditBox.RenderIndicator;
var
  pDisplay: Iz3DDisplay;
  rc: TRect;
  rcCalc: TRect;
  pwszIndicator: PWideChar;
begin
  pDisplay := m_Displays[9];
  pDisplay.TextureColor.Blend(z3dcsNormal);

  FDialog.DrawSprite(pDisplay, FIndicator);
  rc := FIndicator;
  InflateRect(rc, -FSpacing, -FSpacing);
  if (s_ImeState = IMEUI_STATE_ON) and s_bEnableImeSystem
    then pDisplay.FontColor.Current := D3DXColorFromDWord(m_IndicatorImeColor)
    else pDisplay.FontColor.Current := D3DXColorFromDWord(m_IndicatorEngColor);
  rcCalc := Rect(0, 0, 0, 0);
  // If IME system is off, draw English indicator.
  if s_bEnableImeSystem
  then pwszIndicator := s_wszCurrIndicator
  else pwszIndicator := s_aszIndicator[Low(TIndicatorEnum)];

  FDialog.CalcTextRect(pwszIndicator, pDisplay, @rcCalc);
  FDialog.DrawText(pwszIndicator, pDisplay, rc);
end;

procedure Tz3DIMEEditBox.Render;
var
  i: TIndicatorEnum;
  rc: TRect;
  pDisplay: Iz3DDisplay;
begin
  if not FVisible then Exit;

  // If we have not computed the indicator symbol width,
  // do it.
  if (FIndicatorWidth = 0) then
  begin
    for i := INDICATOR_NON_IME to INDICATOR_JAPANESE do
    begin
      rc := Rect(0, 0, 0, 0);
      FDialog.CalcTextRect(@s_aszIndicator[i], m_Displays[9], @rc);
      FIndicatorWidth := Max(FIndicatorWidth, rc.right - rc.left);
    end;
    // Update the rectangles now that we have the indicator's width
    UpdateRects;
  end;

  // Let the parent render first (edit control)
  inherited {Cz3DEdit::}Render;

  pDisplay := GetDisplay(1);
  if (pDisplay <> nil) then
  begin
    s_CompString.FontNode := FDialog.GetFont(pDisplay.Font);
    s_CandList.HoriCand.FontNode := FDialog.GetFont(pDisplay.Font);
  end;

  //
  // Now render the IME elements
  //
  if FHasFocus then
  begin
    // Render the input locale indicator
    RenderIndicator;

    // Display the composition string.
    // This method should also update s_ptCompString
    // for RenderCandidateReadingWindow.
    RenderComposition;

    // Display the reading/candidate window. RenderCandidateReadingWindow()
    // uses s_ptCompString to position itself.  s_ptCompString must have
    // been filled in by RenderComposition().
    if s_bShowReadingWindow then
      // Reading window
      RenderCandidateReadingWindow(True)
    else
    if s_CandList.bShowWindow then
      // Candidate list window
      RenderCandidateReadingWindow(False);
  end;
end;

class procedure Tz3DIMEEditBox.Initialize;
var
  wszPath: array[0..MAX_PATH] of WideChar;
  temp: FARPROC;
begin
  if (s_hDllImm32 <> 0) then Exit; // Only need to do once
  
  s_CompString.SetBufferSize(MAX_COMPSTRING_SIZE);

  if (GetSystemDirectoryW(wszPath, MAX_PATH+1) = 0) then Exit;
  StringCchCat(wszPath, MAX_PATH, IMM32_DLLNAME);
  s_hDllImm32 := LoadLibraryW(wszPath);
  if (s_hDllImm32 <> 0) then
  begin
    temp:= GetProcAddress(s_hDllImm32, 'ImmLockIMC'); if (temp<>nil) then _ImmLockIMC:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmUnlockIMC'); if (temp<>nil) then _ImmUnlockIMC:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmLockIMCC'); if (temp<>nil) then _ImmLockIMCC:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmUnlockIMCC'); if (temp<>nil) then _ImmUnlockIMCC:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmDisableTextFrameService'); if (temp<>nil) then _ImmDisableTextFrameService:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmGetCompositionStringW'); if (temp<>nil) then _ImmGetCompositionStringW:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmGetCandidateListW'); if (temp<>nil) then _ImmGetCandidateListW:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmGetContext'); if (temp<>nil) then _ImmGetContext:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmReleaseContext'); if (temp<>nil) then _ImmReleaseContext:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmAssociateContext'); if (temp<>nil) then _ImmAssociateContext:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmGetOpenStatus'); if (temp<>nil) then _ImmGetOpenStatus:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmSetOpenStatus'); if (temp<>nil) then _ImmSetOpenStatus:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmGetConversionStatus'); if (temp<>nil) then _ImmGetConversionStatus:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmGetDefaultIMEWnd'); if (temp<>nil) then _ImmGetDefaultIMEWnd:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmGetIMEFileNameA'); if (temp<>nil) then _ImmGetIMEFileNameA:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmGetVirtualKey'); if (temp<>nil) then _ImmGetVirtualKey:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmNotifyIME'); if (temp<>nil) then _ImmNotifyIME:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmSetConversionStatus'); if (temp<>nil) then _ImmSetConversionStatus:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmSimulateHotKey'); if (temp<>nil) then _ImmSimulateHotKey:= temp;
    temp:= GetProcAddress(s_hDllImm32, 'ImmIsIME'); if (temp<>nil) then _ImmIsIME:= temp;
  end;

  if (GetSystemDirectoryW(wszPath, MAX_PATH+1) = 0) then Exit;
  StringCchCat(wszPath, MAX_PATH, VER_DLLNAME);
  s_hDllVer := LoadLibraryW(wszPath);
  if (s_hDllVer <> 0) then
  begin
    temp:= GetProcAddress(s_hDllVer, 'VerQueryValueA'); if (temp<>nil) then _VerQueryValueA:= temp;
    temp:= GetProcAddress(s_hDllVer, 'GetFileVersionInfoA'); if (temp<>nil) then _GetFileVersionInfoA:= temp;
    temp:= GetProcAddress(s_hDllVer, 'GetFileVersionInfoSizeA'); if (temp<>nil) then _GetFileVersionInfoSizeA:= temp;
  end;
end;

class procedure Tz3DIMEEditBox.Uninitialize;
begin
  if (s_hDllImm32 <> 0) then
  begin
    _ImmLockIMC := Dummy_ImmLockIMC;
    _ImmUnlockIMC := Dummy_ImmUnlockIMC;
    _ImmLockIMCC := Dummy_ImmLockIMCC;
    _ImmUnlockIMCC := Dummy_ImmUnlockIMCC;
    _ImmDisableTextFrameService := Dummy_ImmDisableTextFrameService;
    _ImmGetCompositionStringW := Dummy_ImmGetCompositionStringW;
    _ImmGetCandidateListW := Dummy_ImmGetCandidateListW;
    _ImmGetContext := Dummy_ImmGetContext;
    _ImmReleaseContext := Dummy_ImmReleaseContext;
    _ImmAssociateContext := Dummy_ImmAssociateContext;
    _ImmGetOpenStatus := Dummy_ImmGetOpenStatus;
    _ImmSetOpenStatus := Dummy_ImmSetOpenStatus;
    _ImmGetConversionStatus := Dummy_ImmGetConversionStatus;
    _ImmGetDefaultIMEWnd := Dummy_ImmGetDefaultIMEWnd;
    _ImmGetIMEFileNameA := Dummy_ImmGetIMEFileNameA;
    _ImmGetVirtualKey := Dummy_ImmGetVirtualKey;
    _ImmNotifyIME := Dummy_ImmNotifyIME;
    _ImmSetConversionStatus := Dummy_ImmSetConversionStatus;
    _ImmSimulateHotKey := Dummy_ImmSimulateHotKey;
    _ImmIsIME := Dummy_ImmIsIME;

    FreeLibrary(s_hDllImm32);
    s_hDllImm32 := 0;
  end;

  if (s_hDllIme <> 0) then
  begin
    _GetReadingString := Dummy_GetReadingString;
    _ShowReadingWindow := Dummy_ShowReadingWindow;

    FreeLibrary(s_hDllIme);
    s_hDllIme := 0;
  end;

  if (s_hDllVer <> 0) then
  begin
    _VerQueryValueA := Dummy_VerQueryValueA;
    _GetFileVersionInfoA := Dummy_GetFileVersionInfoA;
    _GetFileVersionInfoSizeA := Dummy_GetFileVersionInfoSizeA;

    FreeLibrary(s_hDllVer);
    s_hDllVer := 0;
  end;
end;

class function Tz3DIMEEditBox.GetLanguage: Word;
begin
  Result:= LOWORD(s_hklCurrent);
end;

class function Tz3DIMEEditBox.GetPrimaryLanguage: Word;
begin
  Result:= PRIMARYLANGID(LOWORD(s_hklCurrent));
end;

class function Tz3DIMEEditBox.GetSubLanguage: Word;
begin
  Result:= SUBLANGID(LOWORD(s_hklCurrent));
end;

{ Tz3DDesktop }

procedure Tz3DDesktop.BringToFront(const ADialog: Iz3DDialog);
begin
  FGUIController.BringToFront(ADialog);
end;

constructor Tz3DDesktop.Create;
begin
  inherited;

  // Link this object to the desired events generated by the z3D Engine
  Notifications:= [z3dlnDevice, z3dlnGUIRender, z3dlnMessages];
  ScenarioLevel:= False;

  FVisible:= True;
  FLogo:= z3DCreateTexture;
  FLogo.Source:= z3dtsFileName;
  FLogo.ScenarioLevel:= False;
  FLogo.Enabled:= False;
  FLogo.AutoGenerateMipMaps:= False;
  FWallpaper:= z3DCreateTexture;
  FWallpaper.Enabled:= False;
  FWallpaper.Source:= z3dtsFileName;
  FWallpaper.ScenarioLevel:= False;
  FWallpaper.SamplerState.Filter:= z3dsfBilinear;
  FWallpaper.AutoGenerateMipMaps:= False;
  FBlurWallpaper:= False;
  FBlurWallpaperTemp:= z3DCreateRenderTexture;
  FBlurWallpaperTemp.ScenarioLevel:= False;
  FBlurWallpaperTemp.AutoWidthFactor:= 0.125;
  FBlurWallpaperTemp.AutoHeightFactor:= 0.125;
  FBlurWallpaperTemp.Format:= D3DFMT_A8R8G8B8;
  FBlurWallpaperTemp.SamplerState.Filter:= z3dsfBilinear;
  FBlurWallpaperTemp.Enabled:= False;
  FBlurWallpaperFinal:= z3DCreateRenderTexture;
  FBlurWallpaperFinal.ScenarioLevel:= False;
  FBlurWallpaperFinal.AutoWidthFactor:= 0.125;
  FBlurWallpaperFinal.AutoHeightFactor:= 0.125;
  FBlurWallpaperFinal.Format:= D3DFMT_A8R8G8B8;
  FBlurWallpaperFinal.SamplerState.Filter:= z3dsfBilinear;
  FBlurWallpaperFinal.Enabled:= False;
  FThemeSettings:= Tz3DDesktopThemeSettings.Create;
  FGUIController:= Tz3DGUIController.Create(Self);
  FMainMenu:= CreateMainMenuDialog;
  FConsole:= CreateConsoleDialog;
end;

function Tz3DDesktop.GetBlurWallpaper: Boolean;
begin
  Result:= FBlurWallpaper;
end;

function Tz3DDesktop.GetGUIController: Iz3DGUIController;
begin
  Result:= FGUIController;
end;

function Tz3DDesktop.GetProgressDialog: Iz3DProgressDialog;
begin
  Result:= FProgress;
end;

function Tz3DDesktop.GetThemeSettings: Iz3DDesktopThemeSettings;
begin
  Result:= FThemeSettings;
end;

function Tz3DDesktop.GetVisible: Boolean;
begin
  Result:= FVisible;
end;

function Tz3DDesktop.GetWallpaper: Iz3DTexture;
begin
  if BlurWallpaper then Result:= FBlurWallpaperFinal else Result:= FWallpaper;
end;

procedure Tz3DDesktop.SetBlurWallpaper(const Value: Boolean);
begin
  FBlurWallpaper:= Value;
end;

procedure Tz3DDesktop.SetVisible(const Value: Boolean);
begin
  FVisible:= Value;
end;

function Tz3DDesktop.ShowMessage(const AMessage: PWideChar; const AKind: Tz3DMessageDialogKind): Tz3DDialogModalResult;
begin
  Result:= Tz3DMessageDialog.New(Self, AMessage, AKind);
end;

procedure Tz3DDesktop.StartScenario;
var I: Integer;
begin
  if z3DEngine.Scenario.Enabled then
  begin
    Visible:= False;
    Exit;
  end;
  FProgress:= Tz3DProgressDialog.New(Self);
  StringToWideChar(z3DPROGRESS_INITIALIZING, FProgress.Status, 255);
  for I:= 0 to 100 do z3DCore_ProcessMessages;
  z3DEngine.Scenario.Enabled:= True;
  Visible:= False;
  Controller.UnregisterDialog(FProgress as Iz3DDialog);
  FProgress:= nil;
end;

procedure Tz3DDesktop.z3DGUIRender;
begin
  inherited;

  // Blur the wallpaper using the GPU
  if FFirstRender and BlurWallpaper then
  begin
    z3DRenderGaussBlur(FWallpaper, FBlurWallpaperTemp);
    z3DRenderGaussBlur(FBlurWallpaperTemp, FBlurWallpaperFinal);
    z3DRenderGaussBlur(FBlurWallpaperFinal, FBlurWallpaperTemp);
  end;
  FFirstRender:= False;

  // Render the wallpaper if the scenario is not enabled
  if Visible and not z3DEngine.Scenario.Enabled then
  begin
    if BlurWallpaper then z3DEngine.Renderer.Blend([FBlurWallpaperFinal]) else
    z3DEngine.Renderer.Blend([FWallpaper]);
  end;
  FGUIController.GUIRender;
end;

procedure Tz3DDesktop.RenderEngineLogo;
begin
  if Visible then
  z3DEngine.Renderer.AutoBlend(FLogo, 60, 0, nil, 0.99);
end;

procedure Tz3DDesktop.z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller);
var FFileName: PWideChar;
begin
  inherited;

  // Load the current app logo if exists.
  // If not, then load the default z3D logo
  FFileName:= z3DFileSystemController.GetFullPath(z3DCore_GetState.CurrentApp);
  StringToWideChar(WideCharToString(FFileName) + fsPathDiv + fsAppLogoFile, FFileName, 255);
  if FileExists(FFileName) then FLogo.FileName:= FFileName else
  begin
    z3DFileSystemController.DecryptF(fsEngineCoreResFile, fsCoreResFile_z3DLogo);
    StringToWideChar(WideCharToString(z3DFileSystemController.GetFullPath(fsBufferPath)) + fsPathDiv + fsCoreResFile_z3DLogo, FFileName, 255);
    FLogo.FileName:= FFileName;
  end;
  FLogo.Enabled:= True;

  // Load the current app wallpaper if exists.
  // If not, then load the default z3D wallpaper
  FFileName:= z3DFileSystemController.GetFullPath(z3DCore_GetState.CurrentApp);
  StringToWideChar(WideCharToString(FFileName) + fsPathDiv + fsAppWallpaperFile, FFileName, 255);
  if FileExists(FFileName) then FWallpaper.FileName:= FFileName else
  begin
    z3DFileSystemController.DecryptF(fsEngineCoreResFile, fsCoreResFile_z3DWallpaper);
    StringToWideChar(WideCharToString(z3DFileSystemController.GetFullPath(fsBufferPath)) + fsPathDiv + fsCoreResFile_z3DWallpaper, FFileName, 255);
    FWallpaper.FileName:= FFileName;
  end;
  FWallpaper.Enabled:= True;

  FGUIController.CreateScenarioObjects(ACaller = z3dcocResetDevice);
  FBlurWallpaperTemp.Enabled:= BlurWallpaper;
  FBlurWallpaperFinal.Enabled:= BlurWallpaper;
  FFirstRender:= True;
end;

procedure Tz3DDesktop.z3DMessage(const AWnd: HWND; const AMsg: Cardinal;
  const AwParam, AlParam: Integer; var ADefault: Boolean;
  var AResult: Integer);
begin
  inherited;
  FGUIController.Message(AWnd, AMsg, AwParam, AlParam, ADefault, AResult);
end;

procedure Tz3DDesktop.z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller);
begin
  inherited;
  FGUIController.DestroyScenarioObjects(ACaller = z3ddocLostDevice);
end;

function Tz3DDesktop.CreateConsoleDialog: Iz3DConsoleDialog;
begin
  Result:= Tz3DConsoleDialog.Create(Self);
end;

function Tz3DDesktop.CreateDialog: Iz3DDialog;
begin
  Result:= Tz3DDialog.Create;
  Result.InitDefaultDialog(FGUIController);
end;

function Tz3DDesktop.CreateMainMenuDialog: Iz3DMainMenuDialog;
begin
  Result:= Tz3DMainMenuDialog.New(Self);
end;

function Tz3DDesktop.CreateProgressDialog: Iz3DProgressDialog;
begin
  Result:= Tz3DProgressDialog.Create;
  Result.InitDefaultDialog(FGUIController);
end;

function Tz3DDesktop.GetConsole: Iz3DConsoleDialog;
begin
  Result:= FConsole;
end;

function Tz3DDesktop.CreateEngineSettingsDialog: Iz3DEngineSettingsDialog;
begin
  Result:= Tz3DEngineSettingsDialog.Create(Self);
end;

{ Tz3DGUIFont }

constructor Tz3DGUIFont.Create;
begin
  inherited;
  FColor:= z3DFloat4(0, 0, 0, 1);
  FFormat:= DT_LEFT or DT_VCENTER;
  StringToWideChar('Tahoma', FName, 255);
  FShadow:= False;
  FSize:= 8;
end;

function Tz3DGUIFont.GetColor: Iz3DFloat4;
begin
  Result:= FColor;
end;

function Tz3DGUIFont.GetFormat: DWORD;
begin
  Result:= FFormat;
end;

function Tz3DGUIFont.GetName: PWideChar;
begin
  Result:= FName;
end;

function Tz3DGUIFont.GetShadow: Boolean;
begin
  Result:= FShadow;
end;

function Tz3DGUIFont.GetSize: Integer;
begin
  Result:= FSize;
end;

procedure Tz3DGUIFont.SetFormat(const Value: DWORD);
begin
  FFormat:= Value;
end;

procedure Tz3DGUIFont.SetShadow(const Value: Boolean);
begin
  FShadow:= Value;
end;

procedure Tz3DGUIFont.SetSize(const Value: Integer);
begin
  FSize:= Value;
end;

{ Tz3DDesktopThemeSettings }

constructor Tz3DDesktopThemeSettings.Create;
begin
  inherited;
  FCheckBoxFont:= Tz3DGUIFont.Create;
  FDefaultFont:= Tz3DGUIFont.Create;
  FRadioButtonFont:= Tz3DGUIFont.Create;
  FCaptionHeight:= 21;
  FDialogColorTL:= z3DFloat4(0.89, 0.83, 0.78, 1);
  FDialogColorTR:= z3DFloat4(0.94, 0.92, 0.88, 1);
  FDialogColorBL:= z3DFloat4(0.75, 0.64, 0.52, 1);
  FDialogColorBR:= z3DFloat4(0.69, 0.55, 0.46, 1);
end;

function Tz3DDesktopThemeSettings.GetCaptionHeight: Integer;
begin
  Result:= FCaptionHeight;
end;

function Tz3DDesktopThemeSettings.GetCheckBoxFont: Iz3DGUIFont;
begin
  Result:= FCheckBoxFont;
end;

function Tz3DDesktopThemeSettings.GetDefaultFont: Iz3DGUIFont;
begin
  Result:= FDefaultFont;
end;

function Tz3DDesktopThemeSettings.GetDialogColorBL: Iz3DFloat4;
begin
  Result:= FDialogColorBL;
end;

function Tz3DDesktopThemeSettings.GetDialogColorBR: Iz3DFloat4;
begin
  Result:= FDialogColorBR;
end;

function Tz3DDesktopThemeSettings.GetDialogColorTL: Iz3DFloat4;
begin
  Result:= FDialogColorTL;
end;

function Tz3DDesktopThemeSettings.GetDialogColorTR: Iz3DFloat4;
begin
  Result:= FDialogColorTR;
end;

function Tz3DDesktopThemeSettings.GetRadioButtonFont: Iz3DGUIFont;
begin
  Result:= FRadioButtonFont;
end;

procedure Tz3DControl.SetDialog(const Value: Iz3DDialog);
begin
  FDialog:= Value;
end;

procedure Tz3DDesktopThemeSettings.SetCaptionHeight(const Value: Integer);
begin
  FCaptionHeight:= Value;
end;

{ Tz3DMessageDialog }

procedure GMessageDialogGUIEvent(const AEvent: Tz3DControlEvent; const AControlID: Integer; const AControl: Iz3DControl;
    const AUserContext: Pointer); stdcall;
begin
  if AEvent <> z3dceButtonClick then Exit;
  case AControlID of
    1:
    begin
      if Tz3DMessageDialog(AUserContext).Kind in [z3dmdkConfirmation, z3dmdkConfirmationCancel] then
      Tz3DMessageDialog(AUserContext).ModalResult:= z3dmdrYes else
      Tz3DMessageDialog(AUserContext).ModalResult:= z3dmdrOk;
    end;
    2: Tz3DMessageDialog(AUserContext).ModalResult:= z3dmdrNo;
    3: Tz3DMessageDialog(AUserContext).ModalResult:= z3dmdrCancel;
  end;
end;

constructor Tz3DMessageDialog.Create;
begin
  inherited;
  FMessageLabel:= Tz3DLabel.Create(Self);
end;

function Tz3DMessageDialog.GetKind: Tz3DMessageDialogKind;
begin
  Result:= FKind;
end;

class function Tz3DMessageDialog.New(const ADesktop: Iz3DDesktop;
  const AMessage: PWideChar; const AKind: Tz3DMessageDialogKind): Tz3DDialogModalResult;
var FDialog: Iz3DMessageDialog;
begin
  FDialog:= Tz3DMessageDialog.Create;
  FDialog.Visible:= False;
  Result:= FDialog.ShowMessage(ADesktop, AMessage, AKind);
end;

procedure Tz3DMessageDialog.SetKind(const Value: Tz3DMessageDialogKind);
begin
  FKind:= Value;
end;

function Tz3DMessageDialog.ShowMessage(const ADesktop: Iz3DDesktop; const AMessage: PWideChar;
  const AKind: Tz3DMessageDialogKind): Tz3DDialogModalResult;
var FWidth, FHeight, FFinalWidth: Integer;
begin
  FKind:= AKind;
  FWidth:= Length(AMessage) * 3;
  FHeight:= 120;
  FFinalWidth:= 300;
  if FWidth > FFinalWidth then
  FFinalWidth:= Max(FFinalWidth, z3DCore_GetState.BackBufferSurfaceDesc.Width div 2);
  while FWidth > FFinalWidth do
  begin
    FWidth:= Max(FFinalWidth, FWidth - z3DCore_GetState.BackBufferSurfaceDesc.Width div 2);
    FHeight:= FHeight + 24;
  end;
  FWidth:= FFinalWidth;
  SetSize(FWidth, FHeight);
  SetLocation(z3DCore_GetState.BackBufferSurfaceDesc.Width div 2 - FWidth div 2,
  z3DCore_GetState.BackBufferSurfaceDesc.Height div 2 - FHeight div 2);
  InitDefaultDialog(ADesktop.Controller);
  SetCallback(GMessageDialogGUIEvent, Pointer(Self));
  FButton1:= Tz3DButton.Create(Self);
  FMessageLabel.Text:= AMessage;
  FMessageLabel.SetLocation(60, ADesktop.ThemeSettings.CaptionHeight+15);
  FMessageLabel.SetSize(FWidth-80, FHeight-30);
  case AKind of
    z3dmdkInformation:
    begin
      StringToWideChar(z3DDIALOG_INFORMATION, Caption, 255);
      StringToWideChar(z3DDIALOG_OK, FButton1.Text, 255);
      FButton1.SetSize(78, 26);
      FButton1.SetLocation(FFinalWidth div 2 - 39, FHeight - 42);
    end;
    z3dmdkWarning:
    begin
      StringToWideChar(z3DDIALOG_WARNING, Caption, 255);
      StringToWideChar(z3DDIALOG_OK, FButton1.Text, 255);
      FButton1.SetSize(78, 26);
      FButton1.SetLocation(FFinalWidth div 2 - 39, FHeight - 42);
    end;
    z3dmdkError:
    begin
      StringToWideChar(z3DDIALOG_ERROR, Caption, 255);
      StringToWideChar(z3DDIALOG_OK, FButton1.Text, 255);
      FButton1.SetSize(78, 26);
      FButton1.SetLocation(FFinalWidth div 2 - 39, FHeight - 42);
    end;
    z3dmdkConfirmation:
    begin
      StringToWideChar(z3DDIALOG_CONFIRMATION, Caption, 255);
      FButton2:= Tz3DButton.Create(Self);
      FButton1.SetSize(78, 26);
      FButton2.SetSize(78, 26);
      FButton1.SetLocation(FFinalWidth div 2 - 39*2 - 5, FHeight - 42);
      FButton2.SetLocation(FFinalWidth div 2 + 5, FHeight - 42);
      StringToWideChar(z3DDIALOG_YES, FButton1.Text, 255);
      StringToWideChar(z3DDIALOG_NO, FButton2.Text, 255);
      AddControl(FButton2);
      FButton2.ID:= 2;
    end;
    z3dmdkConfirmationCancel:
    begin
      StringToWideChar(z3DDIALOG_CONFIRMATION, Caption, 255);
      FButton2:= Tz3DButton.Create(Self);
      FButton3:= Tz3DButton.Create(Self);
      FButton1.SetSize(78, 26);
      FButton2.SetSize(78, 26);
      FButton3.SetSize(78, 26);
      FButton1.SetLocation(FFinalWidth div 2 - 39*3 - 5*2, FHeight - 42);
      FButton2.SetLocation(FFinalWidth div 2 - 39, FHeight - 42);
      FButton3.SetLocation(FFinalWidth div 2 + 39 + 5*2, FHeight - 42);
      StringToWideChar(z3DDIALOG_YES, FButton1.Text, 255);
      StringToWideChar(z3DDIALOG_NO, FButton2.Text, 255);
      StringToWideChar(z3DDIALOG_CANCEL, FButton3.Text, 255);
      AddControl(FButton2);
      AddControl(FButton3);
      FButton2.ID:= 2;
      FButton3.ID:= 3;
    end;
  end;
  FButton1.ID:= 1;
  AddControl(FMessageLabel);
  AddControl(FButton1);
  FMessageLabel.Display[0].TextFormat:= DT_LEFT or DT_TOP or DT_WORDBREAK;
  ShowModal;
  Result:= ModalResult;
  ADesktop.Controller.UnregisterDialog(Self);
end;

{ Tz3DMainMenuDialog }

procedure GMainMenuDialogGUIEvent(const AEvent: Tz3DControlEvent; const AControlID: Integer; const AControl: Iz3DControl;
    const AUserContext: Pointer); stdcall;
var FMsg: PWideChar;
begin
  if AEvent <> z3dceButtonClick then Exit;
  case AControlID of
    1: Tz3DMainMenuDialog(AUserContext).Manager.Desktop.StartScenario;
    99: z3DEngine.ShowSettingsDialog;
    100:
    begin
      GetMem(FMsg, 255);
      StringToWideChar(z3DDIALOG_EXITCONFIRMATION, FMsg, 255);
      try
        if Tz3DMainMenuDialog(AUserContext).Manager.Desktop.ShowMessage(FMsg,
        z3dmdkConfirmation) = z3dmdrYes then
        begin
          z3DCore_Shutdown;
          Exit;
        end;
      finally
        FreeMem(FMsg);
      end;
    end;
  end;
end;

constructor Tz3DMainMenuDialog.Create;
begin
  inherited;

  // Link this object to the desired events generated by the z3D Engine
  Notifications:= [z3dlnDevice];
  ScenarioStage:= z3dssCreatingLightingSystem;

  EnableCaption:= False;
  EnableBorder:= False;
  FStartButton:= Tz3DButton.Create(Self);
  FSettingsButton:= Tz3DButton.Create(Self);
  FQuitButton:= Tz3DButton.Create(Self);
  FStartHint:= Tz3DLabel.Create(Self);
  FSettingsHint:= Tz3DLabel.Create(Self);
  FQuitHint:= Tz3DLabel.Create(Self);
  FStartButton.SetSize(120, 44);
  StringToWideChar(Z3DMAINMENU_START, FStartButton.Text, 255);
  FStartButton.ID:= 1;
  FStartButton.EnableBackground:= False;
  FSettingsButton.SetSize(130, 44);
  StringToWideChar(Z3DMAINMENU_SETTINGS, FSettingsButton.Text, 255);
  FSettingsButton.EnableBackground:= False;
  FSettingsButton.ID:= 99;
  FQuitButton.SetSize(80, 44);
  StringToWideChar(Z3DMAINMENU_QUIT, FQuitButton.Text, 255);
  FQuitButton.EnableBackground:= False;
  FQuitButton.ID:= 100;

  FStartHint.SetSize(400, 24);
  StringToWideChar(Z3DMAINMENU_STARTHINT, FStartHint.Text, 255);
  FSettingsHint.SetSize(400, 24);
  StringToWideChar(Z3DMAINMENU_SETTINGSHINT, FSettingsHint.Text, 255);
  FQuitHint.SetSize(400, 24);
  StringToWideChar(Z3DMAINMENU_QUITHINT, FQuitHint.Text, 255);

end;

class function Tz3DMainMenuDialog.New(const ADesktop: Iz3DDesktop): Iz3DMainMenuDialog;
var FDialog: Tz3DMainMenuDialog;
begin
  FDialog:= Tz3DMainMenuDialog.Create;
  FDialog.InitDefaultDialog(ADesktop.Controller);
  FDialog.SetCallback(GMainMenuDialogGUIEvent, Pointer(FDialog));
  FDialog.SetBackgroundColors(z3DD3DColor(z3DFloat4(0, 0, 0, 0.5)));
  FDialog.SetFont(0, 'Lucida Sans Typewriter', 28, FW_BOLD);
  FDialog.SetFont(1, 'Lucida Sans Typewriter', 16, FW_BOLD);

  FDialog.AddControl(FDialog.FStartButton);
  FDialog.FStartButton.Display[1].FontColor.SetColors(z3DD3DColor(z3DFloat3(0.7, 0.8, 0.9)));
  FDialog.FStartButton.Display[1].FontColor.States[z3dcsMouseOver]:= z3DD3DColor(z3DFloat3(1, 1, 1));
  FDialog.FStartButton.Display[0].TextFormat:= DT_LEFT or DT_VCENTER or DT_SINGLELINE;
  FDialog.FStartButton.Display[1].TextFormat:= DT_LEFT or DT_VCENTER or DT_SINGLELINE;
  FDialog.AddControl(FDialog.FSettingsButton);
  FDialog.FSettingsButton.Display[1].FontColor.SetColors(z3DD3DColor(z3DFloat3(0.7, 0.8, 0.9)));
  FDialog.FSettingsButton.Display[1].FontColor.States[z3dcsMouseOver]:= z3DD3DColor(z3DFloat3(1, 1, 1));
  FDialog.FSettingsButton.Display[0].TextFormat:= DT_LEFT or DT_VCENTER or DT_SINGLELINE;
  FDialog.FSettingsButton.Display[1].TextFormat:= DT_LEFT or DT_VCENTER or DT_SINGLELINE;
  FDialog.AddControl(FDialog.FQuitButton);
  FDialog.FQuitButton.Display[1].FontColor.SetColors(z3DD3DColor(z3DFloat3(0.7, 0.8, 0.9)));
  FDialog.FQuitButton.Display[1].FontColor.States[z3dcsMouseOver]:= z3DD3DColor(z3DFloat3(1, 1, 1));
  FDialog.FQuitButton.Display[0].TextFormat:= DT_LEFT or DT_VCENTER or DT_SINGLELINE;
  FDialog.FQuitButton.Display[1].TextFormat:= DT_LEFT or DT_VCENTER or DT_SINGLELINE;

  FDialog.AddControl(FDialog.FStartHint);
  FDialog.FStartHint.Display[0].Font:= 1;
  FDialog.FStartHint.Display[0].FontColor.SetColors(z3DD3DColor(z3DFloat3(0.5, 0.5, 0.5)));
  FDialog.FStartHint.Display[0].TextFormat:= DT_LEFT or DT_VCENTER or DT_SINGLELINE;
  FDialog.AddControl(FDialog.FSettingsHint);
  FDialog.FSettingsHint.Display[0].Font:= 1;
  FDialog.FSettingsHint.Display[0].FontColor.SetColors(z3DD3DColor(z3DFloat3(0.5, 0.5, 0.5)));
  FDialog.FSettingsHint.Display[0].TextFormat:= DT_LEFT or DT_VCENTER or DT_SINGLELINE;
  FDialog.AddControl(FDialog.FQuitHint);
  FDialog.FQuitHint.Display[0].Font:= 1;
  FDialog.FQuitHint.Display[0].FontColor.SetColors(z3DD3DColor(z3DFloat3(0.5, 0.5, 0.5)));
  FDialog.FQuitHint.Display[0].TextFormat:= DT_LEFT or DT_VCENTER or DT_SINGLELINE;

  FDialog.Show;
  Result:= FDialog;
end;

procedure Tz3DMainMenuDialog.Render;
var FShadow: Boolean;
begin
  if not Visible or not Manager.Desktop.Visible then Exit;

  FShadow:= z3DEngine.Desktop.ThemeSettings.DefaultFont.Shadow;
  z3DEngine.Desktop.ThemeSettings.DefaultFont.Shadow:= True;
  try
    inherited;

    // Render current logo
    Manager.Desktop.RenderEngineLogo;
  finally
    z3DEngine.Desktop.ThemeSettings.DefaultFont.Shadow:= FShadow;
  end;
end;

procedure Tz3DMainMenuDialog.z3DDestroyScenarioObjects(const ACaller: Tz3DDestroyObjectCaller);
begin
  inherited;
  StringToWideChar(z3DMAINMENU_START, FStartButton.Text, 255);
  StringToWideChar(z3DMAINMENU_STARTHINT, FStartHint.Text, 255);
end;

procedure Tz3DMainMenuDialog.z3DCreateScenarioObjects(const ACaller: Tz3DCreateObjectCaller);
begin
  inherited;
  if ACaller = z3dcocResetDevice then
  begin
    // Set dialog location (entire window)
    SetLocation(0, 0);
    SetSize(z3DCore_GetBackBufferSurfaceDesc.Width, z3DCore_GetBackBufferSurfaceDesc.Height);

    // Set buttons location
    FStartButton.SetLocation(80, z3DCore_GetState.BackBufferSurfaceDesc.Height-340);
    FSettingsButton.SetLocation(80, z3DCore_GetState.BackBufferSurfaceDesc.Height-260);
    FQuitButton.SetLocation(80, z3DCore_GetState.BackBufferSurfaceDesc.Height-120);

    // Set hints location
    FStartHint.SetLocation(80, z3DCore_GetState.BackBufferSurfaceDesc.Height-300);
    FSettingsHint.SetLocation(80, z3DCore_GetState.BackBufferSurfaceDesc.Height-220);
    FQuitHint.SetLocation(80, z3DCore_GetState.BackBufferSurfaceDesc.Height-80);
  end;
end;

procedure Tz3DMainMenuDialog.z3DStartScenario(const AStage: Tz3DStartScenarioStage);
begin
  inherited;
  if AStage = z3dssCreatingLightingSystem then
  begin
    StringToWideChar(z3DMAINMENU_RESUME, FStartButton.Text, 255);
    StringToWideChar(z3DMAINMENU_RESUMEHINT, FStartHint.Text, 255);
  end;
end;

procedure Tz3DMainMenuDialog.z3DStopScenario;
begin
  inherited;
  StringToWideChar(z3DMAINMENU_START, FStartButton.Text, 255);
  StringToWideChar(z3DMAINMENU_STARTHINT, FStartHint.Text, 255);
end;

{ Tz3DProgressDialog }

constructor Tz3DProgressDialog.Create;
begin
  inherited;
  EnableCaption:= False;
  FLabel:= Tz3DLabel.Create(Self);
  FLabel.SetLocation(10, 8);
  FLabel.SetSize(280, 22);
  FProgress:= Tz3DProgressBar.Create(Self);
  FProgress.SetLocation(10, 30);
  FProgress.SetSize(280, 18);
  FProgress.Value:= 0;
  FCancelButton:= Tz3DButton.Create(Self);
  FCancelButton.SetLocation(208, 60);
  FCancelButton.SetSize(78, 26);
  StringToWideChar(z3DDIALOG_CANCEL, FCancelButton.Text, 255);
  FCancelButton.ID:= 1;
end;

function Tz3DProgressDialog.GetStatus: PWideChar;
begin
  Result:= FLabel.Text;
end;

class function Tz3DProgressDialog.New(const ADesktop: Iz3DDesktop): Iz3DProgressDialog;
var FDialog: Tz3DProgressDialog;
begin
  FDialog:= Tz3DProgressDialog.Create;
  FDialog.InitDefaultDialog(ADesktop.Controller);
  FDialog.AddControl(FDialog.FProgress);
  FDialog.AddControl(FDialog.FLabel);
  FDialog.AddControl(FDialog.FCancelButton);
  FDialog.SetSize(300, 100);
  FDialog.SetLocation(z3DCore_GetState.BackBufferSurfaceDesc.Width div 2 - FDialog.Width div 2,
  z3DCore_GetState.BackBufferSurfaceDesc.Height div 2 - FDialog.Height div 2);
  FDialog.Show;
  Result:= FDialog;
end;

procedure Tz3DProgressDialog.SetProgress(const APosition: Integer);
begin
  if FProgress.Value = APosition then Exit;
  FProgress.Value:= APosition;
  z3DCore_ProcessMessages;
end;

procedure Tz3DProgressDialog.SetStatus(const AStatus: PWideChar);
begin
  if WideCompareStr(FLabel.Text, AStatus) = 0 then Exit;
  FLabel.Text:= AStatus;
  z3DCore_ProcessMessages;
end;

{ Tz3DConsoleDialog }

const z3dConsole_InformationPrefix = '[Information]';
      z3dConsole_WarningPrefix = '[Warning]';
      z3dConsole_ErrorPrefix = '[Error]';

procedure Tz3DConsoleDialog.AddTrace(const AMessage: PWideChar;
  const AKind: Tz3DTraceKind);
var FMessage: PWideChar;
begin
  GetMem(FMessage, 255);
  try
    case AKind of
      z3dtkInformation: StringToWideChar(z3dConsole_InformationPrefix+'   '+WideCharToString(AMessage), FMessage, 255);
      z3dtkWarning: StringToWideChar(z3dConsole_WarningPrefix+'   '+WideCharToString(AMessage), FMessage, 255);
      z3dtkError: StringToWideChar(z3dConsole_ErrorPrefix+'   '+WideCharToString(AMessage), FMessage, 255);
    end;
    FLog.AddItem(FMessage, nil);
  finally
    FreeMem(FMessage);
  end;
end;

procedure GConsoleDialogGUIEvent(const AEvent: Tz3DControlEvent; const AControlID: Integer; const AControl: Iz3DControl;
    const AUserContext: Pointer); stdcall;
begin
  if AEvent <> z3dceButtonClick then Exit;
  case AControlID of
    1: Tz3DConsoleDialog(AUserContext).FLog.RemoveAllItems;
    // TODO JP: COMANDO DE LA CONSOLA
    2: Tz3DConsoleDialog(AUserContext).FInput.ClearText;
  end;
end;

constructor Tz3DConsoleDialog.Create(const AOwner: Iz3DBase);
begin
  inherited;
  Notifications:= [z3dlnDevice];
  Caption:= 'Console';
  Width:= 350;
  Height:= 350;
  FFirstReset:= True;
  InitDefaultDialog((AOwner as Iz3DDesktop).Controller);
  FClear:= Tz3DButton.Create(Self);
  AddControl(FClear);
  FClear.SetSize(32, 21);
  FClear.SetLocation(Width-FClear.Width-10, Height-FClear.Height-10);
  FClear.ID:= 1;
  FClear.Text:= 'Clear';
  FSend:= Tz3DButton.Create(Self);
  AddControl(FSend);
  FSend.SetSize(32, 21);
  FSend.SetLocation(Width-FSend.Width-FClear.Width-12, Height-FClear.Height-10);
  FSend.Text:= 'Send';
  FSend.ID:= 2;
  FInput:= Tz3DEdit.Create(Self);
  AddControl(FInput);
  FInput.SetSize(Width-FSend.Width-FClear.Width-28, 21);
  FInput.BorderWidth:= 2;
  FInput.Spacing:= 2;
  FInput.SetLocation(10, Height-FInput.Height-10);
  FInput.Display[0].Font:= 0;
  FLog:= Tz3DTraceListBox.Create(Self);
  AddControl(FLog);
  FLog.Left:= 10;
  FLog.Top:= 38;
  FLog.Width:= Width-20;
  FLog.Height:= Height-FInput.Height-60;
  SetCallback(GConsoleDialogGUIEvent, Pointer(Self));
  Show;
end;

procedure Tz3DConsoleDialog.z3DResetDevice;
begin
  inherited;
  if FFirstReset then
  begin
    Left:= z3DCore_GetBackBufferSurfaceDesc.Width-Width-10;
    Top:= z3DCore_GetBackBufferSurfaceDesc.Height-Height-10;
  end;
end;

const
  z3DSETTINGSDLG_OK                      = 1;
  z3DSETTINGSDLG_CANCEL                  = 2;


const FMultiSamples: array[_D3DMULTISAMPLE_TYPE] of string = ('Off', 'Off', '2x', '3x', '4x', '5x', '6x',
  '7x', '8x', '9x', '10x', '11x', '12x', '13x', '14x', '15x', '16x');

const FMultiSamplesX: array[_D3DMULTISAMPLE_TYPE] of Integer = (0, 0, 2, 3, 4, 5, 6, 7, 8, 9, 10,
  11, 12, 13, 14, 15, 16);

type

  Tz3DLightingSettings = packed record
    ApplyNeeded: Boolean;

    ShadowQuality: Tz3DShadowQuality;
    UseHWShadows: Boolean;
    SSAOEnabled: Boolean;
    SSAOQuality: Tz3DSSAOQuality;
    SSAOSampleFactor: Single;
  end;

  Tz3DRendererSettings = packed record
    ApplyNeeded: Boolean;

    HDRMode: Boolean;
    EnableMSAA: Boolean;
    MSAASamples: Integer;
    Filter: Tz3DSamplerFilter;
    AnisotropyLevel: Integer;
  end;

  Tz3DEngineSettings = packed record
    Renderer: Tz3DRendererSettings;
    Lighting: Tz3DLightingSettings;
  end;

var GDeviceSettings: Tz3DDeviceSettings;
    GEngineSettings: Tz3DEngineSettings;

{ Tz3DLightingSettingsDialog }

const
  z3DSETTINGSDLG_SHADOWS     = 3;
  z3DSETTINGSDLG_HW_SHADOWS  = 4;
  z3DSETTINGSDLG_SSAO        = 5;
  z3DSETTINGSDLG_SSAO_FACTOR = 6;

procedure GLightingSettingsGUIEvent(const AEvent: Tz3DControlEvent; const AControlID: Integer; const AControl: Iz3DControl;
    const AUserContext: Pointer); stdcall;
var FClient: TRect;
    FWindowWidth, FWindowHeight: DWORD;
begin
  case AControlID of
    z3DSETTINGSDLG_OK:
    begin
      Tz3DLightingSettingsDialog(AUserContext).ApplySettings;
      Tz3DLightingSettingsDialog(AUserContext).Hide;
    end;

    z3DSETTINGSDLG_CANCEL:
      Tz3DLightingSettingsDialog(AUserContext).Hide;
  end;
end;

procedure Tz3DLightingSettingsDialog.ApplySettings;
var FCombo: Iz3DComboBox;
    FCheckBox: Iz3DCheckBox;
    FEdit: Iz3DEdit;
begin
  FCombo:= GetComboBox(z3DSETTINGSDLG_SHADOWS);
//  GEngineSettings.Lighting.EnableShadows:= FCombo.ItemIndex <> 0; TODO JP
// if GEngineSettings.Lighting.EnableShadows then TODO JP
  GEngineSettings.Lighting.ShadowQuality:= Tz3DShadowQuality(FCombo.ItemIndex-1);
  FCheckBox:= GetCheckBox(z3DSETTINGSDLG_HW_SHADOWS);
  if not FCheckBox.Enabled then GEngineSettings.Lighting.UseHWShadows:= False else
  GEngineSettings.Lighting.UseHWShadows:= FCheckBox.Checked;

  FCombo:= GetComboBox(z3DSETTINGSDLG_SSAO);
  GEngineSettings.Lighting.SSAOEnabled:= FCombo.ItemIndex <> 0;
  if GEngineSettings.Lighting.SSAOEnabled then
  GEngineSettings.Lighting.SSAOQuality:= Tz3DSSAOQuality(FCombo.ItemIndex-1);
  FEdit:= GetEditBox(z3DSETTINGSDLG_SSAO_FACTOR);
  GEngineSettings.Lighting.SSAOSampleFactor:= StrToFloat(WideCharToString(FEdit.Text));
  GEngineSettings.Lighting.ApplyNeeded:= True;
end;

constructor Tz3DLightingSettingsDialog.Create(const AOwner: Iz3DBase);
begin
  inherited;
  Width:= 400;
  Height:= 170;
  SetCaption('Lighting settings');
  InitDefaultDialog((AOwner as Iz3DDesktop).Controller);
  CreateControls;
  SetCallback(GLightingSettingsGUIEvent, Self);
end;

procedure Tz3DLightingSettingsDialog.CreateControls;
var FCombo: Iz3DComboBox;
begin

  // Shadows
  AddLabel(0, 'Shadows:', 20, 40, 66, 20);
  AddComboBox(z3DSETTINGSDLG_SHADOWS, 78, 40, 100, 20, 0, False, @FCombo);
  FCombo.AddItem('Off', nil);
  FCombo.AddItem('Low', nil);
  FCombo.AddItem('High', nil);
  AddCheckBox(z3DSETTINGSDLG_HW_SHADOWS, 'Use hardware acceleration', 20, 75, 180, 16);

  // SSAO
  AddLabel(0, 'SSAO:', 210, 40, 60, 20);
  AddComboBox(z3DSETTINGSDLG_SSAO, 248, 40, 120, 20, 0, False, @FCombo);
  FCombo.AddItem('Off', Pointer(0));
  FCombo.AddItem('Low', Pointer(0));
  FCombo.AddItem('High', Pointer(0));
  FCombo.AddItem('Very high', Pointer(0));
  AddLabel(0, 'Sample factor:', 210, 75, 120, 20);
  AddEditBox(z3DSETTINGSDLG_SSAO_FACTOR, '', 290, 75, 60, 21);

  // Dialog buttons
  AddButton(z3DSETTINGSDLG_OK, 'OK', Width-176, Height-43, 73, 28);
  AddButton(z3DSETTINGSDLG_CANCEL, 'Cancel', Width-88, Height-43, 73, 28, 0, True);

end;

procedure Tz3DLightingSettingsDialog.RefreshSettings;
var FCombo: Iz3DComboBox;
    FCheckBox: Iz3DCheckBox;
    FEdit: Iz3DEdit;
begin
  // Save the current settings
  GEngineSettings.Lighting.ShadowQuality:= z3DLightingController.ShadowQuality;
  GEngineSettings.Lighting.UseHWShadows:= z3DLightingController.UseHWShadows;
  GEngineSettings.Lighting.SSAOEnabled:= z3DLightingController.SSAO.Enabled;
  GEngineSettings.Lighting.SSAOQuality:= z3DLightingController.SSAO.Quality;
  GEngineSettings.Lighting.SSAOSampleFactor:= z3DLightingController.SSAO.SampleFactor;

  FCombo:= GetComboBox(z3DSETTINGSDLG_SHADOWS);
//  if not GEngineSettings.Lighting.EnableShadows then FCombo.ItemIndex := 0 else TODO JP
  FCombo.SetSelectedByIndex(Integer(GEngineSettings.Lighting.ShadowQuality)+1);
  FCheckBox:= GetCheckBox(z3DSETTINGSDLG_HW_SHADOWS);
  FCheckBox.Enabled:= z3DEngine.Device.EngineCaps.ShadowMapHWSupport;
  if not FCheckBox.Enabled then FCheckBox.Checked:= False else
  FCheckBox.Checked:= GEngineSettings.Lighting.UseHWShadows;

  FCombo:= GetComboBox(z3DSETTINGSDLG_SSAO);
  if not GEngineSettings.Lighting.SSAOEnabled then
  FCombo.SetSelectedByIndex(0) else
  FCombo.SetSelectedByIndex(Integer(GEngineSettings.Lighting.SSAOQuality)+1);
  FEdit:= GetEditBox(z3DSETTINGSDLG_SSAO_FACTOR);
  StringToWideChar(FormatFloat('0.00', GEngineSettings.Lighting.SSAOSampleFactor), z3DWideBuffer, 255);
  FEdit.SetText(z3DWideBuffer);
end;

procedure Tz3DLightingSettingsDialog.SetVisible(const Value: Boolean);
begin
  inherited;
  if Value then
  begin
    RefreshSettings;
    Left:= (z3DCore_GetBackBufferSurfaceDesc.Width - Width) div 2;
    Top:= (z3DCore_GetBackBufferSurfaceDesc.Height - Height) div 2;
  end;
end;

{ Tz3DRendererSettingsDialog }

const
  z3DSETTINGSDLG_HDR_MODE = 3;
  z3DSETTINGSDLG_MSAA     = 4;
  z3DSETTINGSDLG_FILTER   = 5;

procedure GRendererSettingsGUIEvent(const AEvent: Tz3DControlEvent; const AControlID: Integer; const AControl: Iz3DControl;
    const AUserContext: Pointer); stdcall;
var FClient: TRect;
    FWindowWidth, FWindowHeight: DWORD;
begin
  case AControlID of
    z3DSETTINGSDLG_OK:
    begin
      Tz3DRendererSettingsDialog(AUserContext).ApplySettings;
      Tz3DRendererSettingsDialog(AUserContext).Hide;
    end;

    z3DSETTINGSDLG_CANCEL:
      Tz3DRendererSettingsDialog(AUserContext).Hide;
  end;
end;

procedure Tz3DRendererSettingsDialog.ApplySettings;
var FCombo: Iz3DComboBox;
begin
  FCombo:= GetComboBox(z3DSETTINGSDLG_HDR_MODE);
  GEngineSettings.Renderer.HDRMode:= FCombo.ItemIndex <> 0;
  FCombo:= GetComboBox(z3DSETTINGSDLG_MSAA);
  GEngineSettings.Renderer.EnableMSAA:= FCombo.ItemIndex <> 0;
  if GEngineSettings.Renderer.EnableMSAA then
  GEngineSettings.Renderer.MSAASamples:= Integer(FCombo.GetSelectedItem.pData);
  GEngineSettings.Renderer.ApplyNeeded:= True;
  FCombo:= GetComboBox(z3DSETTINGSDLG_FILTER);
  case FCombo.ItemIndex of
    0: GEngineSettings.Renderer.Filter:= z3dsfLinear;
    1: GEngineSettings.Renderer.Filter:= z3dsfBilinear;
    2: GEngineSettings.Renderer.Filter:= z3dsfTrilinear;
    3:
    begin
      GEngineSettings.Renderer.Filter:= z3dsfAnisotropic;
      GEngineSettings.Renderer.AnisotropyLevel:= 1;
    end;
    4:
    begin
      GEngineSettings.Renderer.Filter:= z3dsfAnisotropic;
      GEngineSettings.Renderer.AnisotropyLevel:= 2;
    end;
    5:
    begin
      GEngineSettings.Renderer.Filter:= z3dsfAnisotropic;
      GEngineSettings.Renderer.AnisotropyLevel:= 4;
    end;
    6:
    begin
      GEngineSettings.Renderer.Filter:= z3dsfAnisotropic;
      GEngineSettings.Renderer.AnisotropyLevel:= 8;
    end;
    7:
    begin
      GEngineSettings.Renderer.Filter:= z3dsfAnisotropic;
      GEngineSettings.Renderer.AnisotropyLevel:= 16;
    end;
  end;
end;

constructor Tz3DRendererSettingsDialog.Create(const AOwner: Iz3DBase);
begin
  inherited;
  Width:= 280;
  Height:= 220;
  SetCaption('Renderer settings');
  InitDefaultDialog((AOwner as Iz3DDesktop).Controller);
  CreateControls;
  SetCallback(GRendererSettingsGUIEvent, Self);
end;

procedure Tz3DRendererSettingsDialog.CreateControls;
var FCombo: Iz3DComboBox;
    I: Integer;
begin
  // HDR Option
  AddLabel(0, 'Dynamic range:', 20, 40, 76, 20);
  AddComboBox(z3DSETTINGSDLG_HDR_MODE, 102, 40, 140, 20, 0, False, @FCombo);
  FCombo.AddItem('Low', nil);
  FCombo.AddItem('High', nil);

  // Antialias
  AddLabel(0, 'Antialias:', 20, 80, 60, 20);
  AddComboBox(z3DSETTINGSDLG_MSAA, 74, 80, 140, 20, 0, False, @FCombo);
  FCombo.AddItem('Off', Pointer(0));

  // Filtering
  AddLabel(0, 'Filter:', 20, 120, 46, 20);
  AddComboBox(z3DSETTINGSDLG_FILTER, 60, 120, 140, 20, 0, False, @FCombo);
  // TODO JP: HARDCODED
  FCombo.AddItem('Linear', nil);
  FCombo.AddItem('Bilinear', nil);
  FCombo.AddItem('Trilinear', nil);
  for I:= 1 to 16 do
  if I in [1, 2, 4, 8, 16] then
  begin
    StringToWideChar(Format('Anisotropic %dx', [I]), z3DWideBuffer, 255);
    FCombo.AddItem(z3DWideBuffer, nil);
  end;

  // Dialog buttons
  AddButton(z3DSETTINGSDLG_OK, 'OK', Width-176, Height-43, 73, 28);
  AddButton(z3DSETTINGSDLG_CANCEL, 'Cancel', Width-88, Height-43, 73, 28, 0, True);

end;

procedure Tz3DRendererSettingsDialog.RefreshSettings;
var FCombo: Iz3DComboBox;
    FCombinations: PD3DDeviceSettingsCombinations;
    I: Integer;
begin
  // Save the current settings
  GEngineSettings.Renderer.HDRMode:= z3DEngine.Renderer.HDRMode;
  GEngineSettings.Renderer.EnableMSAA:= z3DEngine.Renderer.EnableMSAA;
  GEngineSettings.Renderer.MSAASamples:= z3DEngine.Renderer.MSAASamples;
  GEngineSettings.Renderer.Filter:= z3DEngine.Renderer.TextureFilter;
  GEngineSettings.Renderer.AnisotropyLevel:= z3DEngine.Renderer.AnisotropyLevel;

  // Show the settings on the UI
  FCombo:= GetComboBox(z3DSETTINGSDLG_HDR_MODE);
  FCombo.SetSelectedByIndex(Integer(GEngineSettings.Renderer.HDRMode));
  FCombo:= GetComboBox(z3DSETTINGSDLG_MSAA);

  // Fill the list with the possible multisample types
  FCombinations:= z3DCore_GetDeviceList.GetCurrentDeviceSettingsCombo;
  FCombo.RemoveAllItems;
  for I:= 0 to High(FCombinations.MultiSampleTypeList) do
  begin
    StringToWideChar(FMultiSamples[FCombinations.MultiSampleTypeList[I]], z3DWideBuffer, 255);
    if not FCombo.ContainsItem(z3DWideBuffer) then FCombo.AddItem(z3DWideBuffer,
    Pointer(FMultiSamplesX[FCombinations.MultiSampleTypeList[I]]));
  end;
  if not GEngineSettings.Renderer.EnableMSAA then FCombo.SetSelectedByIndex(0) else
  FCombo.SetSelectedByData(Pointer(GEngineSettings.Renderer.MSAASamples));
  FCombo:= GetComboBox(z3DSETTINGSDLG_FILTER);
  case GEngineSettings.Renderer.Filter of
    z3dsfLinear: FCombo.SetSelectedByIndex(0);
    z3dsfBilinear: FCombo.SetSelectedByIndex(1);
    z3dsfTrilinear: FCombo.SetSelectedByIndex(2);
    z3dsfAnisotropic:
    begin
      case GEngineSettings.Renderer.AnisotropyLevel of
        1: FCombo.SetSelectedByIndex(3);
        2..3: FCombo.SetSelectedByIndex(4);
        4..7: FCombo.SetSelectedByIndex(5);
        8..15: FCombo.SetSelectedByIndex(6);
        16..100: FCombo.SetSelectedByIndex(7);
      end;
    end;
  end;
end;

procedure Tz3DRendererSettingsDialog.SetVisible(const Value: Boolean);
begin
  inherited;
  if Value then
  begin
    RefreshSettings;
    Left:= (z3DCore_GetBackBufferSurfaceDesc.Width - Width) div 2;
    Top:= (z3DCore_GetBackBufferSurfaceDesc.Height - Height) div 2;
  end;
end;

{ Tz3DEngineSettingsDialog }

const

  z3DSETTINGSDLG_ADAPTER                 = 3;
  z3DSETTINGSDLG_DEVICE_TYPE             = 4;
  z3DSETTINGSDLG_DISPLAY_MODE            = 5;
  z3DSETTINGSDLG_FULLSCREEN              = 6;
  z3DSETTINGSDLG_ADAPTER_FORMAT          = 7;
  z3DSETTINGSDLG_ADAPTER_FORMAT_LABEL    = 8;
  z3DSETTINGSDLG_RESOLUTION              = 9;
  z3DSETTINGSDLG_RESOLUTION_LABEL        = 10;
  z3DSETTINGSDLG_REFRESH_RATE            = 11;
  z3DSETTINGSDLG_REFRESH_RATE_LABEL      = 12;
  z3DSETTINGSDLG_BACK_BUFFER_FORMAT      = 13;
  z3DSETTINGSDLG_DEPTH_STENCIL           = 14;
  z3DSETTINGSDLG_MULTISAMPLE_TYPE        = 15;
  z3DSETTINGSDLG_MULTISAMPLE_QUALITY     = 16;
  z3DSETTINGSDLG_VERTEX_PROCESSING       = 17;
  z3DSETTINGSDLG_PRESENT_INTERVAL        = 18;
  z3DSETTINGSDLG_DEVICECLIP              = 19;
  z3DSETTINGSDLG_RESOLUTION_SHOW_ALL     = 20;

  z3DSETTINGSDLG_RENDERER_SETTINGS       = 30;
  z3DSETTINGSDLG_POSTPROCESS_SETTINGS    = 31;
  z3DSETTINGSDLG_LIGHTING_SETTINGS       = 32;
  z3DSETTINGSDLG_SCENARIO_SETTINGS       = 33;

  z3DSETTINGSDLG_DX_LEVEL_HW             = 34;

  z3DSETTINGSDLG_WINDOWED_GROUP          = $0100;


procedure GEngineSettingsGUIEvent(const AEvent: Tz3DControlEvent; const AControlID: Integer; const AControl: Iz3DControl;
    const AUserContext: Pointer); stdcall;
var FClient: TRect;
    FWindowWidth, FWindowHeight: DWORD;
begin
  case AControlID of
    z3DSETTINGSDLG_ADAPTER:               Tz3DEngineSettingsDialog(AUserContext).OnAdapterChanged;
    z3DSETTINGSDLG_DISPLAY_MODE:          Tz3DEngineSettingsDialog(AUserContext).OnWindowedFullScreenChanged;
    z3DSETTINGSDLG_RESOLUTION_SHOW_ALL:   Tz3DEngineSettingsDialog(AUserContext).OnAdapterFormatChanged;
    z3DSETTINGSDLG_RESOLUTION:            Tz3DEngineSettingsDialog(AUserContext).OnResolutionChanged;

    z3DSETTINGSDLG_RENDERER_SETTINGS:     Tz3DEngineSettingsDialog(AUserContext).FRendererSettings.ShowModal;
    z3DSETTINGSDLG_POSTPROCESS_SETTINGS:  ;
    z3DSETTINGSDLG_LIGHTING_SETTINGS:     Tz3DEngineSettingsDialog(AUserContext).FLIghtingSettings.ShowModal;
    z3DSETTINGSDLG_SCENARIO_SETTINGS:     ;

    z3DSETTINGSDLG_OK:
    begin
      if GEngineSettings.Renderer.ApplyNeeded then
      begin
        z3DEngine.Renderer.BeginSettingsChange;
        z3DEngine.Renderer.HDRMode:= GEngineSettings.Renderer.HDRMode;
        z3DEngine.Renderer.MSAASamples:= GEngineSettings.Renderer.MSAASamples;
        z3DEngine.Renderer.EnableMSAA:= GEngineSettings.Renderer.EnableMSAA;
        z3DEngine.Renderer.TextureFilter:= GEngineSettings.Renderer.Filter;
        z3DEngine.Renderer.AnisotropyLevel:= GEngineSettings.Renderer.AnisotropyLevel;
        z3DEngine.Renderer.EndSettingsChange;
      end;
      if GEngineSettings.Lighting.ApplyNeeded then
      begin
        z3DLightingController.ShadowQuality:= GEngineSettings.Lighting.ShadowQuality;
        z3DLightingController.UseHWShadows:= GEngineSettings.Lighting.UseHWShadows;
        z3DLightingController.SSAO.Enabled:= GEngineSettings.Lighting.SSAOEnabled;
        z3DLightingController.SSAO.Quality:= GEngineSettings.Lighting.SSAOQuality;
        z3DLightingController.SSAO.SampleFactor:= GEngineSettings.Lighting.SSAOSampleFactor;
      end;
      z3DCore_CreateDeviceFromSettings(@GDeviceSettings);
      Tz3DEngineSettingsDialog(AUserContext).Hide;
    end;

    z3DSETTINGSDLG_CANCEL:
      Tz3DEngineSettingsDialog(AUserContext).Hide;
  end;
end;

function Tz3DEngineSettingsDialog.OnAdapterFormatChanged: HRESULT;
var
  FAdapterFormat: TD3DFormat;
  FResolutionComboBox: Iz3DComboBox;
  FAdapterInfo: Iz3DEnumAdapterInfo;
  I: Integer;
  FDisplayMode: TD3DDisplayMode;
  FCurResolution: DWORD;
  FShowAll: Boolean;
  FDesktop: TD3DDisplayMode;
  FDesktopAspectRatio: Single;
  FAspect: Single;
begin
  // z3DSETTINGSDLG_ADAPTER_FORMAT
  FAdapterFormat:= GDeviceSettings.AdapterFormat;

  // z3DSETTINGSDLG_RESOLUTION
  FResolutionComboBox:= GetComboBox(z3DSETTINGSDLG_RESOLUTION);
  FResolutionComboBox.RemoveAllItems;

  FAdapterInfo:= GetCurrentAdapterInfo;
  if (FAdapterInfo = nil) then
  begin
    Result:= E_FAIL;
    Exit;
  end;

  FShowAll:= GetCheckBox(z3DSETTINGSDLG_RESOLUTION_SHOW_ALL).Checked;

  // Get the desktop aspect ratio
  z3DCore_GetDesktopResolution(GDeviceSettings.AdapterOrdinal, FDesktop.Width, FDesktop.Height);
  FDesktopAspectRatio:= FDesktop.Width / FDesktop.Height;

  for I:= 0 to Length(FAdapterInfo.DisplayModeList^) - 1 do
  begin
    FDisplayMode:= FAdapterInfo.DisplayModeList^[I];
    FAspect:= FDisplayMode.Width / FDisplayMode.Height;

    if (FDisplayMode.Format = FAdapterFormat) then
    begin
      // If "Show All" is not checked, then hide all resolutions
      // that don't match the aspect ratio of the desktop resolution
      if FShowAll or (not FShowAll and (Abs(FDesktopAspectRatio - FAspect) < 0.05))
      then AddResolution(FDisplayMode.Width, FDisplayMode.Height);
    end;
  end;

  FCurResolution:= MAKELONG(GDeviceSettings.PresentParams.BackBufferWidth,
  GDeviceSettings.PresentParams.BackBufferHeight);

  FResolutionComboBox.SetSelectedByData(ULongToPtr(FCurResolution));

  Result := OnResolutionChanged;
  if FAILED(Result) then Exit;

  Result:= S_OK;
end;

procedure Tz3DEngineSettingsDialog.AddAdapter(const ADescription: PWideChar; const AAdapter: LongWord);
var FComboBox: Iz3DComboBox;
begin
  FComboBox:= GetComboBox(z3DSETTINGSDLG_ADAPTER);
  if not FComboBox.ContainsItem(ADescription) then
    FComboBox.AddItem(ADescription, ULongToPtr(AAdapter));
end;

procedure Tz3DEngineSettingsDialog.AddResolution(const AWidth, AHeight: DWORD);
var FComboBox: Iz3DComboBox;
    FResolutionData: DWORD;
    FResolution: array[0..49] of WideChar;
begin
  FComboBox:= GetComboBox(z3DSETTINGSDLG_RESOLUTION);
  FResolutionData := MAKELONG(AWidth, AHeight);
  StringCchFormat(FResolution, 50, '%dx%d'#0, [AWidth, AHeight]);
  if not FComboBox.ContainsItem(FResolution) then
    FComboBox.AddItem(FResolution, ULongToPtr(FResolutionData));
end;

procedure Tz3DEngineSettingsDialog.ApplyDeviceSettings;
var FComboBox: Iz3DComboBox;
    FResolution: DWORD;
begin
  // z3DSETTINGSDLG_WINDOWED
  FComboBox:= GetComboBox(z3DSETTINGSDLG_DISPLAY_MODE);
  GDeviceSettings.PresentParams.Windowed:= FComboBox.ItemIndex = 1;

  // z3DSETTINGSDLG_RESOLUTION
  FComboBox:= GetComboBox(z3DSETTINGSDLG_RESOLUTION);
  FResolution:= PtrToUlong(FComboBox.GetSelectedData);
  GDeviceSettings.PresentParams.BackBufferWidth:= HIWORD(FResolution);
  GDeviceSettings.PresentParams.BackBufferHeight:= LOWORD(FResolution);
end;

constructor Tz3DEngineSettingsDialog.Create(const AOwner: Iz3DBase);
begin
  inherited;
  Width:= 500;
  Height:= 300;
  SetCaption('Zenith Engine settings');
  InitDefaultDialog((AOwner as Iz3DDesktop).Controller);
  CreateControls;
  FRendererSettings:= Tz3DRendererSettingsDialog.Create(AOwner);
  FRendererSettings.Hide;
  FLightingSettings:= Tz3DLightingSettingsDialog.Create(AOwner);
  FLightingSettings.Hide;
  SetCallback(GEngineSettingsGUIEvent, Self);
end;

procedure Tz3DEngineSettingsDialog.CreateControls;
var FCombo: Iz3DComboBox;
begin
  AddLabel(0, 'Adapter:', 20, 40, 60, 20);
  AddComboBox(z3DSETTINGSDLG_ADAPTER, 72, 40, 240, 20, 0, False, @FCombo);
  AddLabel(0, 'Resolution:', 20, 80, 60, 20);
  AddComboBox(z3DSETTINGSDLG_RESOLUTION, 80, 80, 120, 20, 0, False, @FCombo);
  GetComboBox(z3DSETTINGSDLG_RESOLUTION).SetDropHeight(145);
  AddCheckBox(z3DSETTINGSDLG_RESOLUTION_SHOW_ALL, 'Show all resolutions', 20, 112, 140, 16, True);
  AddLabel(0, 'Display mode:', 260, 80, 80, 20);
  AddComboBox(z3DSETTINGSDLG_DISPLAY_MODE, 336, 80, 120, 20, 0, False, @FCombo);
  FCombo.AddItem('Full screen', nil);
  FCombo.AddItem('Window', nil);

  AddLabel(0, 'Advanced settings:', 20, 150, 120, 20);
  AddButton(z3DSETTINGSDLG_RENDERER_SETTINGS, 'Renderer...', 19, 175, 100, 28);
  AddButton(z3DSETTINGSDLG_POSTPROCESS_SETTINGS, 'Post process...', 141, 175, 100, 28);
  AddButton(z3DSETTINGSDLG_LIGHTING_SETTINGS, 'Lighting...', 263, 175, 100, 28);
  AddButton(z3DSETTINGSDLG_SCENARIO_SETTINGS, 'Scenario...', 385, 175, 100, 28);

  AddLabel(0, 'Current hardware level:', 20, 220, 115, 20);
  AddLabel(z3DSETTINGSDLG_DX_LEVEL_HW, 'Unknown', 140, 220, 120, 20);

  // Dialog buttons
  AddButton(z3DSETTINGSDLG_OK, 'OK', Width-176, Height-43, 73, 28);
  AddButton(z3DSETTINGSDLG_CANCEL, 'Cancel', Width-88, Height-43, 73, 28, 0, True);
end;

function Tz3DEngineSettingsDialog.GetCurrentAdapterInfo: Iz3DEnumAdapterInfo;
begin
  Result:= z3DCore_GetDeviceList.GetAdapterInfo(GDeviceSettings.AdapterOrdinal);
end;

function Tz3DEngineSettingsDialog.GetCurrentDeviceInfo: Iz3DEnumDeviceInfo;
begin
  Result:= z3DCore_GetDeviceList.GetDeviceInfo(GDeviceSettings.AdapterOrdinal,
  GDeviceSettings.DeviceType);
end;

function Tz3DEngineSettingsDialog.GetCurrentDeviceSettingsCombo: PD3DDeviceSettingsCombinations;
begin
  Result:= z3DCore_GetDeviceList.GetDeviceSettingsCombo(GDeviceSettings.AdapterOrdinal,
  GDeviceSettings.DeviceType, GDeviceSettings.AdapterFormat,
  GDeviceSettings.PresentParams.BackBufferFormat,
  GDeviceSettings.PresentParams.Windowed);
end;

function Tz3DEngineSettingsDialog.GetSelectedAdapter: LongWord;
begin
  Result:= PtrToUlong(GetComboBox(z3DSETTINGSDLG_ADAPTER).GetSelectedData);
end;

procedure Tz3DEngineSettingsDialog.GetSelectedResolution(out AWidth, AHeight: DWORD);
var FComboBox: Iz3DComboBox;
    FResolution: DWORD;
begin
  FComboBox:= GetComboBox(z3DSETTINGSDLG_RESOLUTION);
  FResolution:= PtrToUlong(FComboBox.GetSelectedData);
  AWidth:= LOWORD(FResolution);
  AHeight:= HIWORD(FResolution);
end;

function Tz3DEngineSettingsDialog.IsWindowed: Boolean;
var FComboBox: Iz3DComboBox;
begin
  FComboBox:= GetComboBox(z3DSETTINGSDLG_DISPLAY_MODE);
  Result:= FComboBox.ItemIndex = 1;
end;

function Tz3DEngineSettingsDialog.OnAdapterChanged: HRESULT;
begin
  // Store the adapter index
  GDeviceSettings.AdapterOrdinal:= GetSelectedAdapter;
  Result := OnWindowedFullScreenChanged;
  if FAILED(Result) then Exit;
end;

function Tz3DEngineSettingsDialog.OnResolutionChanged: HRESULT;
var FAdapterInfo: Iz3DEnumAdapterInfo;
    FResWidth, FResHeight: DWORD;
begin
  FAdapterInfo := GetCurrentAdapterInfo;

  if (FAdapterInfo = nil) then
  begin
    Result:= E_FAIL;
    Exit;
  end;

  // Set resolution
  GetSelectedResolution(FResWidth, FResHeight);
  GDeviceSettings.PresentParams.BackBufferWidth:= FResWidth;
  GDeviceSettings.PresentParams.BackBufferHeight:= FResHeight;

  Result:= S_OK;
end;

function Tz3DEngineSettingsDialog.OnWindowedFullScreenChanged: HRESULT;
var FWindowed: Boolean;
    FD3D: IDirect3D9;
    FMode: TD3DDisplayMode;
    FResWidth, FResHeight: DWORD;
    FResolutionComboBox: Iz3DComboBox;
    FRC: TRect;
begin
  FWindowed := IsWindowed;
  GDeviceSettings.PresentParams.Windowed := FWindowed;

  FResWidth := GDeviceSettings.PresentParams.BackBufferWidth;
  FResHeight := GDeviceSettings.PresentParams.BackBufferHeight;

  Result := OnAdapterFormatChanged;
  if FAILED(Result) then Exit;

  // z3DSETTINGSDLG_RESOLUTION
  FResolutionComboBox:= GetComboBox(z3DSETTINGSDLG_RESOLUTION);
  FResolutionComboBox.SetSelectedByData(ULongToPtr(MAKELONG(FResWidth, FResHeight)));

  Result := OnResolutionChanged;
  if FAILED(Result) then Exit;

  Result:= S_OK;
end;

procedure Tz3DEngineSettingsDialog.SetWindowed(const AWindowed: Boolean);
begin
  GetComboBox(z3DSETTINGSDLG_DISPLAY_MODE).SetSelectedByIndex(Integer(AWindowed));
end;

const
  FDDirectXLevel: array[Tz3DDirectXLevel] of string = ('DirectX 7', 'DirectX 8',
    'DirectX 8.1', 'DirectX 9', 'DirectX 9+', 'DirectX 9++');


procedure Tz3DEngineSettingsDialog.RefreshDeviceSettings;
var FD3DEnum: Iz3DDeviceList;
    FBestDeviceSettingsCombo: PD3DDeviceSettingsCombinations;
    FAdapterInfoList: Tz3DEnumAdapterInfoArray;
    FAdapterCombo: Iz3DComboBox;
    I: Integer;
    FAdapterInfo: Iz3DEnumAdapterInfo;
    FLabel: Iz3DLabel;
begin
  FAdapterInfoList:= nil;
  GEngineSettings.Lighting.ApplyNeeded:= False;
  GEngineSettings.Renderer.ApplyNeeded:= False;
  FD3DEnum:= z3DCore_GetDeviceList;
  GDeviceSettings:= z3DCore_GetDeviceSettings;
  SetWindowed(GDeviceSettings.PresentParams.Windowed);
  AddResolution(GDeviceSettings.PresentParams.BackBufferWidth, GDeviceSettings.PresentParams.BackBufferHeight);
  FBestDeviceSettingsCombo:= FD3DEnum.GetDeviceSettingsCombo(GDeviceSettings.AdapterOrdinal,
  GDeviceSettings.DeviceType, GDeviceSettings.AdapterFormat, GDeviceSettings.PresentParams.BackBufferFormat,
  GDeviceSettings.PresentParams.Windowed);
  if FBestDeviceSettingsCombo = nil then Exit;
  FAdapterInfoList:= FD3DEnum.GetAdapterInfoList;
  if Length(FAdapterInfoList) = 0 then Exit;

  FAdapterCombo:= GetComboBox(z3DSETTINGSDLG_ADAPTER);
  FAdapterCombo.RemoveAllItems;
  for I:= 0 to Length(FAdapterInfoList) - 1 do
  begin
    FAdapterInfo:= FAdapterInfoList[I];
    AddAdapter(PWideChar(FAdapterInfo.UniqueDescription), FAdapterInfo.AdapterOrdinal);
  end;
  FAdapterCombo.SetSelectedByData(ULongToPtr(GDeviceSettings.AdapterOrdinal));
  OnAdapterChanged;
  FLabel:= GetLabel(z3DSETTINGSDLG_DX_LEVEL_HW);
  StringToWideChar(FDDirectXLevel[z3DEngine.Device.EngineCaps.DirectXLevel], z3DWideBuffer, 255);
  FLabel.Text:= z3DWideBuffer;
end;

procedure Tz3DEngineSettingsDialog.SetVisible(const Value: Boolean);
begin
  inherited;
  if Value then
  begin
    RefreshDeviceSettings;
    Left:= (z3DCore_GetBackBufferSurfaceDesc.Width - Width) div 2;
    Top:= (z3DCore_GetBackBufferSurfaceDesc.Height - Height) div 2;
  end;
end;

{ Tz3DTraceListBox }

procedure Tz3DTraceListBox.Render;
var
  pDisplay: Iz3DDisplay;
  pSelDisplay: Iz3DDisplay;
  rc, rcSel: TRect;
  i: Integer;
  pItem: Pz3DListBoxItem;
  bSelectedStyle: Boolean;
begin
  if not Visible then Exit;

  pDisplay := m_Displays[0];
  pDisplay.TextureColor.Blend(z3dcsNormal);
  pDisplay.FontColor.Blend(z3dcsNormal);
  pDisplay.TextFormat:= DT_LEFT or DT_WORDBREAK;

  pSelDisplay := m_Displays[1];
  pSelDisplay.TextureColor.Blend(z3dcsNormal);
  pSelDisplay.FontColor.Blend(z3dcsNormal);
  pSelDisplay.TextFormat:= DT_LEFT or DT_WORDBREAK;

  FDialog.DrawSprite(pDisplay, FBoundingBox);

  // Render the text
  if (m_Items.Count > 0) then
  begin
    // Find out the height of a single line of text
    rc := FText;
    rcSel := FSelection;
    rc.bottom := rc.top + FDialog.Manager.Fonts[pDisplay.Font].Height * 2;

    // Update the line height formation
    FTextHeight := rc.bottom - rc.top;

    if not bSBInit then
    begin
      // Update the page size of the scroll bar
      if (FTextHeight <> 0)
      then m_ScrollBar.SetPageSize(RectHeight(FText) div FTextHeight)
      else m_ScrollBar.SetPageSize(RectHeight(FText));
      bSBInit := True;
    end;

    rc.right := FText.right;
    for i := m_ScrollBar.TrackPos to m_Items.Count - 1 do
    begin
      if (rc.bottom > FText.bottom) then Break;

      pItem := Pz3DListBoxItem(m_Items[i]);

      // Determine if we need to render this item with the
      // selected element.
      bSelectedStyle := False;

      if (FStyle <> z3dlbsMultiSelect) and (i = FSelected)
      then bSelectedStyle := True
      else if (FStyle = z3dlbsMultiSelect) then
      begin
        if FDrag and
           ( (i >= FSelected) and (i < FSelStart) or
             (i <= FSelected) and (i > FSelStart) )
        then bSelectedStyle := Pz3DListBoxItem(m_Items[FSelStart]).bSelected
        else if pItem.bSelected then
          bSelectedStyle := True;
      end;

      if bSelectedStyle then
      begin
        rcSel.top := rc.top;
        rcSel.bottom := rc.bottom;
        FDialog.DrawSprite(pSelDisplay, rcSel);
        FDialog.DrawText(pItem.strText, pSelDisplay, rc);
      end else
      begin
        if Pos(z3dConsole_WarningPrefix, pItem.strText) > 0 then
        begin
          pDisplay.FontColor.States[z3dcsNormal]:= D3DCOLOR_ARGB(255, 108, 80, 10);
          pDisplay.FontColor.Blend(z3dcsNormal, -1);
        end else
        if Pos(z3dConsole_ErrorPrefix, pItem.strText) > 0 then
        begin
          pDisplay.FontColor.States[z3dcsNormal]:= D3DCOLOR_ARGB(255, 158, 10, 10);
          pDisplay.FontColor.Blend(z3dcsNormal, -1);
        end else
        if Pos(z3dConsole_InformationPrefix, pItem.strText) > 0 then
        begin
          pDisplay.FontColor.States[z3dcsNormal]:= D3DCOLOR_ARGB(255, 10, 128, 10);
          pDisplay.FontColor.Blend(z3dcsNormal, -1);
        end else
        begin
          pDisplay.FontColor.States[z3dcsNormal]:= D3DCOLOR_ARGB(255, 0, 0, 0);
          pDisplay.FontColor.Blend(z3dcsNormal, -1);
        end;
        FDialog.DrawText(pItem.strText, pDisplay, rc);
      end;

      OffsetRect(rc, 0, FTextHeight);
    end;
  end;

  // Render the scroll bar
  m_ScrollBar.Render;
end;

initialization
  {$IFDEF FPC}
  s_wszCurrIndicator:= @s_aszIndicator[Low(TIndicatorEnum)];
  {$ENDIF}
  s_CompString:= Tz3DUniBuffer.Create(0);
  s_CandList.HoriCand:= Tz3DUniBuffer.Create;

finalization
  FreeAndNil(s_CandList.HoriCand);
  FreeAndNil(s_CompString);

end.
