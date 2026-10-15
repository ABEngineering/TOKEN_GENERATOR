!ifndef BUILD_UNINSTALLER

; Desktop shortcut choice lives on the Finish page (end of the wizard,
; right before the user closes it) instead of a separate page earlier in
; the flow. createDesktopShortcut is set to false in package.json so the
; base script never auto-creates the shortcut - this file is the only
; place that does, keeping a single source of truth.
;
; Checked by default so interactive installs keep the old always-on
; behavior unless the user opts out.
;
; Silent installs (auto-updates run by electron-updater) never show the
; Finish page, so CreateDesktopShortcutFunc below would never run for
; them - which is what we want for an update (existing shortcut/icon is
; left exactly as it was). A genuine fresh silent install (plain /S, not
; an update) still gets a shortcut via customInstall below, since there
; is no Finish page to ask on.
!macro customFinishPage
  Function CreateDesktopShortcutFunc
    CreateShortCut "$DESKTOP\${SHORTCUT_NAME}.lnk" "$appExe" "" "$appExe" 0 "" "" "${APP_DESCRIPTION}"
  FunctionEnd

  Function LaunchAppFunc
    ${if} ${isUpdated}
      StrCpy $0 "--updated"
    ${else}
      StrCpy $0 ""
    ${endif}
    ${StdUtils.ExecShellAsUser} $1 "$launchLink" "open" "$0"
  FunctionEnd

  !define MUI_FINISHPAGE_RUN
  !define MUI_FINISHPAGE_RUN_FUNCTION "LaunchAppFunc"

  !define MUI_FINISHPAGE_SHOWREADME ""
  !define MUI_FINISHPAGE_SHOWREADME_TEXT "Create a Desktop shortcut"
  !define MUI_FINISHPAGE_SHOWREADME_FUNCTION "CreateDesktopShortcutFunc"

  !insertmacro MUI_PAGE_FINISH
!macroend

!macro customInstall
  ${If} ${Silent}
  ${AndIfNot} ${isUpdated}
    CreateShortCut "$DESKTOP\${SHORTCUT_NAME}.lnk" "$appExe" "" "$appExe" 0 "" "" "${APP_DESCRIPTION}"
  ${EndIf}
!macroend
!endif
