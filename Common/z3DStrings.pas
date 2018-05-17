{==============================================================================}
{== Visual Direct3D VCL library BETA 1                                       ==}
{== Author: Juan Pablo Ventoso.                                              ==}
{==============================================================================}
{== Unit: z3DStrings. Language: ENGLISH (United States)                      ==}
{==============================================================================}

unit z3DStrings;

interface

resourcestring

  // Error messages
  z3DERRM_INVALID_HANDLE                 =
  'The environment could not start because a valid viewport window has not been set.';
  z3DERRM_Z3DCOMPONENT_ALREADY_EXISTS    =
  'The application already has an active z3DDirect3D component. Creation of the new '+
  'component has been suspended.';
  z3DERRM_DIALOG_MANAGER_LOST            =
  'A z3D dialog has not been linked to a manager properly. (property Tz3DDialog.Manager '+
  '[Tz3DDialogManager])';
  z3DERRM_INVALID_ALPHA_BLEND_VALUE      =
  'The alpha blending value must be between 0 (transparent) and 255 (opaque).';
  z3DERRM_INVALID_ELEMENT_COUNT          =
  'The estimated amount of control elements does not match the real amount. It is possible '+
  'that you have installed a newer version of DXUT. Try updating z3D.';
  z3DERRM_NO_z3D_MAIN_COMPONENT          =
  'The main z3DDirect3D component was not created or initialized. Note that the z3DDirect3D '+
  'component must be first in the main form''s creation order.';
  z3DERRM_INVALID_FILENAME               =
  'Could not find the specified file %s. Please make sure that the file exists.';
  z3DERRM_REQUIRED_PARAM_IS_NULL         =
  'A required parameter is empty or invalid. The associated method will not continue.';
  z3DERRM_REQUIRED_EVENT_IS_NULL         =
  'A required event is not assigned or is invalid. The associated method will not continue.';
  z3DERRM_OBJECT_CREATION_FAILED         =
  'The object could not be created. The z3D engine might become unstable.';
  z3DERRM_INDEX_OUT_OF_RANGE             =
  'The index is out of range. Check the current bounds of the list.';
  z3DERRM_INVALID_SKYBOX_TEXTURE         =
  'Could not load Skybox texture. Please make sure that the file exists and is a valid cube texture.';
  z3DERRM_NO_COMPATIBLE_DEVICES          =
  'Could not find any Direct3D compatible devices. Please make sure that your hardware supports the '+
  'requirements to run this program.';
  z3DERRM_UNKNOWN                        =
  'z3D failed to get the sucess description. To obtain additional information, start this '+
  'application with the -DEBUG directive.';

  // Warning messages
  z3DWARM_PROPCHANGE_IGNORED             =
  'The change made to this property will be ignored because it is not valid in this context.';
  z3DWARM_OBJECT_NOT_CREATED             =
  'The object was not created as expected. The z3D engine might become unstable.';

  // General messages
  z3DSTR_SWITCHTOREF                     =
  'The z3D engine will render on the reference rasterizer, a device that implements the '+
  'entire Direct3D set, but runs very slowly. Read your hardware''s manual for more '+
  'information. ¿Do you want to continue?';

  // Common dialog strings
  z3DDIALOG_OK                               = 'OK';
  z3DDIALOG_CANCEL                           = 'Cancel';
  z3DDIALOG_YES                              = 'Yes';
  z3DDIALOG_NO                               = 'No';
  z3DDIALOG_CONFIRMATION                     = 'Confirmation';
  z3DDIALOG_INFORMATION                      = 'Information';
  z3DDIALOG_WARNING                          = 'Warning';
  z3DDIALOG_ERROR                            = 'Error';
  z3DDIALOG_EXITCONFIRMATION                 = 'Are you sure you want to quit?';

  // Progress dialog strings
  z3DPROGRESS_INITIALIZING                   = 'Initializing...';

  // Main menu strings
  z3DMAINMENU_START                          = 'START';
  z3DMAINMENU_RESUME                         = 'RESUME';
  z3DMAINMENU_SETTINGS                       = 'SETTINGS';
  z3DMAINMENU_QUIT                           = 'QUIT';

  z3DMAINMENU_STARTHINT                      = 'BEGIN THE SCENE';
  z3DMAINMENU_RESUMEHINT                     = 'RESUME CURRENT SCENE';
  z3DMAINMENU_SETTINGSHINT                   = 'CHANGE CURRENT SETTINGS';
  z3DMAINMENU_QUITHINT                       = 'CLOSE THE APPLICATION';

  // Settings dialog texts
  z3DSETTINGSDLGTEXT_STATIC                  = 'Direct3D Settings';
  z3DSETTINGSDLGTEXT_OK                      = 'OK';
  z3DSETTINGSDLGTEXT_CANCEL                  = 'Cancel';
  z3DSETTINGSDLGTEXT_ADAPTER                 = 'Adapter';
  z3DSETTINGSDLGTEXT_DEVICE_TYPE             = 'Device';
  z3DSETTINGSDLGTEXT_WINDOWED                = 'Window mode';
  z3DSETTINGSDLGTEXT_FULLSCREEN              = 'Fullscreen mode';
  z3DSETTINGSDLGTEXT_ADAPTER_FORMAT_LABEL    = 'Format';
  z3DSETTINGSDLGTEXT_RESOLUTION_LABEL        = 'Resolution';
  z3DSETTINGSDLGTEXT_REFRESH_RATE_LABEL      = 'Refresh rate';
  z3DSETTINGSDLGTEXT_BACK_BUFFER_FORMAT      = 'Back buffer format';
  z3DSETTINGSDLGTEXT_DEPTH_STENCIL           = 'Stencil depth format';
  z3DSETTINGSDLGTEXT_MULTISAMPLE_TYPE        = 'Multisample mode';
  z3DSETTINGSDLGTEXT_MULTISAMPLE_QUALITY     = 'Multisample quality';
  z3DSETTINGSDLGTEXT_VERTEX_PROCESSING       = 'Vertex process mode';
  z3DSETTINGSDLGTEXT_PRESENT_INTERVAL        = 'Vertical sync';
  z3DSETTINGSDLGTEXT_DEVICECLIP              = 'Clip to device when window uses many monitors';
  z3DSETTINGSDLGTEXT_RESOLUTION_SHOW_ALL     = 'Show all aspect ratios';

  // z3D Controls's default caption
  z3DCONTROL_DIALOG_DEFAULT_CAPTION          = 'z3D Dialog';
  z3DCONTROL_LABEL_DEFAULT_CAPTION           = 'z3D Label';
  z3DCONTROL_BUTTON_DEFAULT_CAPTION          = 'z3D Button';
  z3DCONTROL_CHECKBOX_DEFAULT_CAPTION        = 'z3D Checkbox';
  z3DCONTROL_RADIOGROUP_DEFAULT_CAPTION      = 'z3D RadioButton';
  z3DCONTROL_EDIT_DEFAULT_CAPTION            = 'z3D Edit';

  // MessageBoxes
  z3DMESSAGE_CONFIRMATION                    = 'Confirmation';
  z3DMESSAGE_INFORMATION                     = 'Information';
  z3DMESSAGE_ERROR                           = 'Error';
  z3DMESSAGE_WARNING                         = 'Warning';

  // Encoded MessageBoxes
  z3DMESSAGE_INIT1                           = #168#208#210#230#64#210#230#64#194#64#232+
                                               #202#230#232#64#236#202#228#230#210#222+
                                               #220#64#222#204#64#236#102#136#64#138#220#206+
                                               #210#220#202#92#64#160#216#202#194#230#202#64+
                                               #236#210#230#210#232#64#208#232#232#224#116+
                                               #94#94#238#238#238#92#236#102#200#90#236#198+
                                               #216#92#198#222#218#92#194#228#64#204#222#228+
                                               #64#200#202#232#194#210#216#230#92;

  z3DMESSAGE_INIT1_CAPTION                   = #236#102#136#64#138#220#206#210#220#202;

  // Encoded 2D Text
  z3DMESSAGE_2DTEXT                          = #236#102#136#64#138#220#206#210#220#202+
                                               #64#232#202#230#232#64#236#202#228#230+
                                               #210#222#220;

  // Encoded encriptation text (2y2son44y2son6)
  z3DSTRINGS_CRYPTEDTEXT                     = #100#242#100#230#222#220#104#104#242#100+
                                               #230#222#220#108;

  // z3D dialogs
  z3DOPTION_YES                              = 'Yes';
  z3DOPTION_NO                               = 'No';
  z3DOPTION_END                              = 'End';
  z3DOPTION_IGNORE                           = 'Ignore';
  z3DOPTION_IGNOREALL                        = 'Ignore all';
  z3DOPTION_SENDREPORT                       = 'Send report';

  z3DFRMQUESTION_CBXDONTSHOW_TEXT            = 'Don''t ask me again';
  z3DFRMASSERTERROR_TEXT                     = 'z3D engine error';

  z3DFRMASSERTERROR_LBLDESCRIPTION_TEXT      = 'A problem was detected during the '+
  'execution of the z3D engine.';
  z3DFRMASSERTERROR_LBLTYPETITLE_TEXT        = 'Error code:';
  z3DFRMASSERTERROR_LBLERRORTITLE_TEXT       = 'Problem description:';

  z3DFRMAPPSTART_TITLE                       = 'Zenith Engine application start';
  z3DFRMAPPSTART_LBLTITLE_TEXT               = 'Welcome to Zenith Engine.';
  z3DFRMAPPSTART_APP_NOT_FOUND               = 'The requested application was not found by the system.';
  z3DFRMAPPSTART_LBLSUBTITLE_TEXT            = 'Please select the application you want to run from the list below.';
  z3DFRMAPPSTART_LBLAPPS_TEXT                = 'Detected applications:';
  z3DFRMAPPSTART_BTNLAUNCH_TEXT              = 'Run';
  z3DFRMAPPSTART_BTNEXIT_TEXT                = 'Exit';

  // Log information
  z3DLOGKIND_EXCEPTION                    = 'Exception';
  z3DLOGKIND_WARNING                      = 'Warning';
  z3DLOGKIND_INFORMATION                  = 'Information';
  z3DLOGKIND_DEBUG                        = 'Debug event';
  z3DLOGKIND_INTERNAL                     = 'Internal event';

  // Resources
  z3DRES_LIGHTING_EFFECT                  = 'C:\JP\Direct3D\z3D\z3DLighting.fxo';
  z3DRES_SKIES_EFFECT                     = 'C:\JP\Direct3D\z3D\z3DSkies.fxo';
  z3DRES_BLOOM_EFFECT                     = 'C:\JP\Direct3D\z3D\z3DBloom.fxo';
  z3DRES_CORE_EFFECT                      = 'C:\JP\Direct3D\z3D\z3DCore.fxo';
  z3DRES_TONEMAPPING_EFFECT               = 'C:\JP\Direct3D\z3D\z3DToneMapping.fxo';
  z3DRES_COLORCORRECTION_EFFECT           = 'C:\JP\Direct3D\z3D\z3DColorCorrection.fxo';
  z3DRES_MOTIONBLUR_EFFECT                = 'C:\JP\Direct3D\z3D\z3DMotionBlur.fxo';
  z3DRES_DEPTHOFFIELD_EFFECT              = 'C:\JP\Direct3D\z3D\z3DDepthOfField.fxo';

function z3DDS(const A: string): string; stdcall;

implementation

function z3DDS(const A: string): string; stdcall;
var I: Integer;
begin
  SetLength(Result, Length(A));
  for I:= 0 to Length(A) do Result[I]:= Chr(Ord(A[I]) div 2);
end;

end.

