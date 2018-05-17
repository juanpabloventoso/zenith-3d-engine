unit z3DPhysics_Intf;

interface

uses z3DScenario_Intf, z3DClasses_Intf;

type

  Iz3DPhysicsEngine = interface(Iz3DLinked)['{AE915254-3A45-4D61-AF82-F4704BC706F2}']
    function GetFPS: Integer; stdcall;
    procedure SetFPS(const Value: Integer); stdcall;
    function GetEnabled: Boolean; stdcall;
    procedure SetEnabled(const Value: Boolean); stdcall;

    procedure SyncronizeScenarioPhysics; stdcall;
    procedure PerformWorldsPhysics(const AObject: Iz3DScenarioDynamicObject); stdcall;
    function PerformCollisionPhysics(const AObject: Iz3DScenarioDynamicObject): Boolean; stdcall;
    procedure ApplyPhysics(const AObject: Iz3DScenarioDynamicObject); stdcall;

    function CheckCollision(const AObjectA: Iz3DScenarioDynamicObject;
      const AObjectB: Iz3DScenarioObject): Boolean; stdcall;
    function BoundIntersectionTest(const AObjectA: Iz3DScenarioDynamicObject;
      const AObjectB: Iz3DScenarioObject): Boolean; stdcall;

    function BSvsBSCollisionTest(const AObjectA: Iz3DScenarioDynamicObject;
      const AObjectB: Iz3DScenarioObject): Boolean; stdcall;
    function AABBvsAABBCollisionTest(const AObjectA: Iz3DScenarioDynamicObject;
      const AObjectB: Iz3DScenarioObject): Boolean; stdcall;

    function TriangleCollisionTest(const AObjectA: Iz3DScenarioDynamicObject;
      const AObjectB: Iz3DScenarioObject): Boolean; stdcall;

    function BSvsBSCollisionResponse(const AObjectA: Iz3DScenarioDynamicObject;
      const AObjectB: Iz3DScenarioObject): Boolean; stdcall;

    property Enabled: Boolean read GetEnabled write SetEnabled;
    property FPS: Integer read GetFPS write SetFPS;
  end;

implementation

end.
