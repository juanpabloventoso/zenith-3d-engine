



   


        typedef DWORD (*TXInputGetState)(DWORD dwUserIndex ,
/* out */ TXInputState &pState 
);
 ;
        typedef DWORD (*TXInputSetState)(DWORD dwUserIndex ,
const TXInputVibration pVibration 
);
 ;
          typedef DWORD (*TXInputGetCapabilities)(DWORD dwUserIndex ,
DWORD dwFlags ,
/* out */ TXInputCapabilities &pCapabilities 
);
 ;
     typedef void (*TXInputEnable)(BOOL bEnable 
);
 ;

   typedef Tz3DGamePad* Pz3DGamePad;

   struct Tz3DGamePad
{

      Word wButtons; 

      Byte bLeftTrigger; 

      Byte bRightTrigger; 

      Smallint sThumbLX; 

      Smallint sThumbLY; 

      Smallint sThumbRX; 

      Smallint sThumbRY; 

      XINPUT_CAPABILITIES caps; 

      Boolean bConnected; 

      Boolean bInserted; 

      Boolean bRemoved; 

      Single fThumbRX; 

      Single fThumbRY; 

      Single fThumbLX; 

      Single fThumbLY; 

      Word wPressedButtons; 

      Boolean bPressedLeftTrigger; 

      Boolean bPressedRightTrigger; 

      Word wLastButtons; 

      Boolean bLastLeftTrigger; 

      Boolean bLastRightTrigger; 

 };



  // Global engine constants
                    const  INPUT_MAX_CONTROLLERS =  4;
          const  INPUT_GAMEPAD_TRIGGER_THRESHOLD =  30;
                           const  INPUT_DEADZONE =  (0.24 * $7FFF);



// finished

