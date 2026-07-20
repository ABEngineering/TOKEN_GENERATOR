!ifndef BUILD_UNINSTALLER
!include "nsDialogs.nsh"

Var DesktopShortcutCheckbox
Var DesktopShortcutState

; Extra page shown after choosing the install directory, with a checkbox
; to decide whether to create the Desktop shortcut.
!macro customPageAfterChangeDir
  Page custom DesktopShortcutPageCreate DesktopShortcutPageLeave
!macroend

Function DesktopShortcutPageCreate
  nsDialogs::Create 1018
  Pop $0
  ${If} $0 == error
    Abort
  ${EndIf}

  ${NSD_CreateLabel} 0 0 100% 24u "Choose whether to create a Desktop shortcut"
  Pop $1

  ${NSD_CreateCheckbox} 0 32u 100% 12u "Create a Desktop shortcut"
  Pop $DesktopShortcutCheckbox
  ${NSD_Check} $DesktopShortcutCheckbox

  nsDialogs::Show
FunctionEnd

Function DesktopShortcutPageLeave
  ${NSD_GetState} $DesktopShortcutCheckbox $DesktopShortcutState
FunctionEnd

; electron-builder's base script always creates the shortcut
; (createDesktopShortcut setting); here we remove it again if the user
; unchecked the box on the custom page.
;
; Silent installs (auto-updates run by electron-updater) never show custom
; pages, so $DesktopShortcutState would stay empty and this would delete the
; user's existing Desktop shortcut/icon on every automatic update. Only act
; on it for interactive installs.
!macro customInstall
  ${IfNot} ${Silent}
    ${If} $DesktopShortcutState != ${BST_CHECKED}
      Delete "$newDesktopLink"
    ${EndIf}
  ${EndIf}
!macroend
!endif
