; Inno Setup Script for Dev PowerShell Utility
; Installer for the Dev command-line tool

#define MyAppName "Dev PowerShell Utility"
#define MyAppVersion "1.2.1"
#define MyAppPublisher "SzaBee13"
#define MyAppURL "https://github.com/SzaBee13/dev-tools-ps"
#define MyAppExeName "dev.ps1"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
AppId={{A7B8C9D0-E1F2-4A5B-8C7D-9E0F1A2B3C4D}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=..\LICENSE.md
; Uncomment the following line to run in non administrative install mode (install for current user only.)
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputBaseFilename=dev-tools-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SetupIconFile=compiler:SetupClassicIcon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; Install the main PowerShell script and modules
Source: "..\src\dev.ps1"; DestDir: "{app}\src"; Flags: ignoreversion
Source: "..\src\core\*"; DestDir: "{app}\src\core"; Flags: ignoreversion recursesubdirs
Source: "..\src\commands\*"; DestDir: "{app}\src\commands"; Flags: ignoreversion recursesubdirs
; Install supporting files
Source: "..\README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\licenses.json"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Dirs]
; Create the appdata directory structure
Name: "{userappdata}\SzaBee13\dev"; Permissions: users-full

[Icons]
Name: "{group}\{#MyAppName} README"; Filename: "{app}\README.md"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Code]
var
  ProfilePathPage: TInputFileWizardPage;
  AddToProfileCheckBox: TNewCheckBox;

procedure InitializeWizard;
var
  DefaultProfilePath: String;
begin
  // Create a custom page for PowerShell profile selection
  ProfilePathPage := CreateInputFilePage(wpSelectDir,
    'PowerShell Profile Location', 'Select your PowerShell profile',
    'Please specify the location of your PowerShell profile, then click Next.');
  
  // Determine default PowerShell profile path
  DefaultProfilePath := ExpandConstant('{userdocs}\PowerShell\Microsoft.PowerShell_profile.ps1');
  
  // If the default path doesn't exist, try Windows PowerShell path
  if not FileExists(DefaultProfilePath) then
    DefaultProfilePath := ExpandConstant('{userdocs}\WindowsPowerShell\Microsoft.PowerShell_profile.ps1');
  
  ProfilePathPage.Add('PowerShell Profile:', 'PowerShell script files|*.ps1|All files|*.*', '.ps1');
  ProfilePathPage.Values[0] := DefaultProfilePath;
  
  // Create checkbox for adding to profile
  AddToProfileCheckBox := TNewCheckBox.Create(WizardForm);
  AddToProfileCheckBox.Parent := ProfilePathPage.Surface;
  AddToProfileCheckBox.Caption := 'Add dev function to PowerShell profile';
  AddToProfileCheckBox.Top := ProfilePathPage.Edits[0].Top + ProfilePathPage.Edits[0].Height + 30;
  AddToProfileCheckBox.Width := ProfilePathPage.Surface.Width;
  AddToProfileCheckBox.Checked := True;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  // Skip the profile page if user doesn't want to modify profile
  Result := False;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ProfilePath: String;
  ProfileDir: String;
  ProfileContent: AnsiString;
  ScriptPath: String;
  DotSourceLine: AnsiString;
begin
  if CurStep = ssPostInstall then
  begin
    if AddToProfileCheckBox.Checked then
    begin
      ProfilePath := ProfilePathPage.Values[0];
      ProfileDir := ExtractFileDir(ProfilePath);
      ScriptPath := ExpandConstant('{app}\src\dev.ps1');
      
      // Create profile directory if it doesn't exist
      if not DirExists(ProfileDir) then
      begin
        if not ForceDirectories(ProfileDir) then
        begin
          MsgBox('Failed to create PowerShell profile directory: ' + ProfileDir, mbError, MB_OK);
          Exit;
        end;
      end;
      
      // Prepare the line to add to the profile
      DotSourceLine := #13#10 + #13#10 + '# Dev PowerShell Utility' + #13#10 + '. "' + ScriptPath + '"' + #13#10;
      
      // Read existing profile content if file exists
      ProfileContent := '';
      if FileExists(ProfilePath) then
      begin
        try
          if LoadStringFromFile(ProfilePath, ProfileContent) then
          begin
            // Check if dev.ps1 is already sourced
            if Pos(ScriptPath, ProfileContent) > 0 then
            begin
              MsgBox('Dev utility is already added to your PowerShell profile.', mbInformation, MB_OK);
              Exit;
            end;
          end
          else
          begin
            MsgBox('Failed to read PowerShell profile: ' + ProfilePath, mbError, MB_OK);
            Exit;
          end;
        except
          MsgBox('Error reading PowerShell profile: ' + ProfilePath, mbError, MB_OK);
          Exit;
        end;
      end;
      
      // Append the dot-source line to the profile
      ProfileContent := ProfileContent + DotSourceLine;
      
      // Save the updated profile
      if not SaveStringToFile(ProfilePath, ProfileContent, False) then
      begin
        MsgBox('Failed to update PowerShell profile: ' + ProfilePath + #13#10#13#10 + 
               'You can manually add this line to your profile:' + #13#10 + 
               '. "' + ScriptPath + '"', mbError, MB_OK);
      end
      else
      begin
        MsgBox('Dev utility has been added to your PowerShell profile!' + #13#10#13#10 + 
               'Please restart PowerShell or run: . $PROFILE', mbInformation, MB_OK);
      end;
    end;
    
    // Copy licenses.json to appdata if it doesn't exist there
    if not FileExists(ExpandConstant('{userappdata}\SzaBee13\dev\licenses.json')) then
    begin
      FileCopy(ExpandConstant('{app}\licenses.json'), 
               ExpandConstant('{userappdata}\SzaBee13\dev\licenses.json'), False);
    end;
    
    // Create empty config files if they don't exist
    if not FileExists(ExpandConstant('{userappdata}\SzaBee13\dev\config.json')) then
    begin
      SaveStringToFile(ExpandConstant('{userappdata}\SzaBee13\dev\config.json'), 
                       '{"code":true,"explorer":true}', False);
    end;
    
    if not FileExists(ExpandConstant('{userappdata}\SzaBee13\dev\roots.json')) then
    begin
      SaveStringToFile(ExpandConstant('{userappdata}\SzaBee13\dev\roots.json'), 
                       '{}', False);
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  ProfilePath: String;
  ProfileContent: AnsiString;
  ScriptPath: String;
  StartPos, EndPos: Integer;
begin
  if CurUninstallStep = usPostUninstall then
  begin
    // Ask user if they want to remove the dev function from their profile
    if MsgBox('Do you want to remove the dev function from your PowerShell profile?', 
              mbConfirmation, MB_YESNO) = IDYES then
    begin
      ProfilePath := ExpandConstant('{userdocs}\PowerShell\Microsoft.PowerShell_profile.ps1');
      if not FileExists(ProfilePath) then
        ProfilePath := ExpandConstant('{userdocs}\WindowsPowerShell\Microsoft.PowerShell_profile.ps1');
      
      if FileExists(ProfilePath) then
      begin
        try
          if LoadStringFromFile(ProfilePath, ProfileContent) then
          begin
            ScriptPath := ExpandConstant('{app}\src\dev.ps1');
            
            // Find and remove the dev utility section
            StartPos := Pos('# Dev PowerShell Utility', ProfileContent);
            if StartPos > 0 then
            begin
              // Find the dot-source line - look for the closing quote and newline
              EndPos := StartPos;
              while (EndPos <= Length(ProfileContent)) and (ProfileContent[EndPos] <> #10) do
                EndPos := EndPos + 1;
              // Skip to end of the dot-source line
              if EndPos < Length(ProfileContent) then
              begin
                EndPos := EndPos + 1;
                while (EndPos <= Length(ProfileContent)) and (ProfileContent[EndPos] <> #10) do
                  EndPos := EndPos + 1;
                if EndPos <= Length(ProfileContent) then
                begin
                  Delete(ProfileContent, StartPos, EndPos - StartPos + 1);
                  SaveStringToFile(ProfilePath, ProfileContent, False);
                  MsgBox('Dev utility has been removed from your PowerShell profile.', 
                         mbInformation, MB_OK);
                end;
              end;
            end;
          end;
        except
          MsgBox('Error modifying PowerShell profile.', mbError, MB_OK);
        end;
      end;
    end;
    
    // Ask if user wants to remove appdata configuration
    if MsgBox('Do you want to remove your dev utility configuration files?' + #13#10 + 
              '(This will delete your saved roots and preferences)', 
              mbConfirmation, MB_YESNO) = IDYES then
    begin
      DelTree(ExpandConstant('{userappdata}\SzaBee13\dev'), True, True, True);
    end;
  end;
end;
