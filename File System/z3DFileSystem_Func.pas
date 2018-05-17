unit z3DFileSystem_Func;

interface

uses z3DFileSystem_Intf;

const
  z3DFileSystemDLL = 'z3DFileSystem.dll';

function z3DFileSystemController: Iz3DFileSystemController; stdcall; external z3DFileSystemDLL;
function z3DCreateFileSystemController: Iz3DFileSystemController; stdcall; external z3DFileSystemDLL;
procedure z3DSetCustomFileSystemController(const AController: Iz3DFileSystemController); stdcall; external z3DFileSystemDLL;

implementation

end.
