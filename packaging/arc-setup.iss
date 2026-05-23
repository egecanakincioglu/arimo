#define AppName "Arimo"
#define AppVersion "1.0"
#define AppPublisher "Egecan Akıncıoğlu"
#define AppURL "https://github.com/egecanakincioglu/arimo"
#define AppExeName "arc.exe"

[Setup]
AppId={{8A3F2E1C-4B7D-4E9A-B2C3-D5E6F7A8B9C0}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}/releases
DefaultDirName={autopf}\arimo
DefaultGroupName={#AppName}
AllowNoIcons=yes
LicenseFile=..\LICENSE
OutputDir=..\dist
OutputBaseFilename=arimo-v{#AppVersion}-windows-x64-setup
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
ArchitecturesAllowed=x64
ChangesEnvironment=yes
UninstallDisplayIcon={app}\arc.exe

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "addtopath"; Description: "Add arc to PATH (recommended)"; GroupDescription: "Environment:"; Flags: checked

[Files]
Source: "..\arc.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\stdlib\*"; DestDir: "{app}\stdlib"; Flags: ignoreversion recursesubdirs createallsubdirs

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; \
    ValueType: expandsz; ValueName: "Path"; \
    ValueData: "{olddata};{app}"; \
    Check: NeedsAddPath(ExpandConstant('{app}')); \
    Tasks: addtopath

[Code]
function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  Result := Pos(';' + Param + ';', ';' + OrigPath + ';') = 0;
end;

[Icons]
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"

[Run]
Filename: "{cmd}"; Parameters: "/C setx PATH ""%PATH%;{app}"""; \
    Flags: runhidden; Tasks: addtopath

[UninstallDelete]
Type: filesandordirs; Name: "{app}"
