# nip2 nullsoft installer script
#
# compile with
#    makensis -DVERSION=7.20.7 nip2.nsi

  !include "MUI2.nsh"

;--------------------------------
;General

  ;Name and file
  Name "nip2-${VERSION}"
  OutFile "nip2-${VERSION}-setup.exe"
  SetCompressor LZMA

  ;Default installation folder
  InstallDir "$LOCALAPPDATA\VIPS"

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\VIPS" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel user

  Var StartMenuFolder

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "nip2.bmp"
  !define MUI_HEADERIMAGE_UNBITMAP "nip2.bmp"
  !define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"
  !define MUI_UNWELCOMEFINISHPAGE_BITMAP "welcome.bmp"
  !define MUI_ICON "nip2-icon.ico"
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall-nsis.ico"

;--------------------------------
;Pages

  !define MUI_WELCOMEPAGE_TITLE "Welcome to nip2-${VERSION}"
  !define MUI_WELCOMEPAGE_TEXT \
"nip2 is a GUI for the VIPS image processing library. \
It is rather like a cross between a spreadsheet and a paint \
program.$\n$\n\
This installer will copy the necessary files to your hard drive \
and add an item to your Start Menu."
  !insertmacro MUI_PAGE_WELCOME

  !insertmacro MUI_PAGE_LICENSE "COPYING"

  !insertmacro MUI_PAGE_DIRECTORY

  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\VIPS" 
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
  !insertmacro MUI_PAGE_STARTMENU Application "$StartMenuFolder"

  !insertmacro MUI_PAGE_INSTFILES

  !define MUI_FINISHPAGE_TEXT \
"nip2 has been successfully installed."
  !define MUI_FINISHPAGE_RUN "$INSTDIR\nip2-${VERSION}\bin\nip2.exe"
  !define MUI_FINISHPAGE_RUN_TEXT "Run nip2 now"
  !define MUI_FINISHPAGE_LINK "Visit the VIPS website"
  !define MUI_FINISHPAGE_LINK_LOCATION "http://www.vips.ecs.soton.ac.uk"
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME

  !insertmacro MUI_UNPAGE_CONFIRM

  !insertmacro MUI_UNPAGE_INSTFILES

  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "Dummy Section" SecDummy
  SetOutPath $INSTDIR

  File /r nip2-${VERSION}

  WriteRegStr HKCU "Software\VIPS" "" $INSTDIR

  WriteUninstaller "$INSTDIR\Uninstall.exe"

  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application

    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\nip2-${VERSION}.lnk" "$INSTDIR\nip2-${VERSION}\bin\nip2.exe"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall nip2-${VERSION}.lnk" "$INSTDIR\Uninstall.exe"

  !insertmacro MUI_STARTMENU_WRITE_END
sectionend

;--------------------------------
;Uninstaller Section
;
Section "Uninstall"
  RMDir /r "$INSTDIR\nip2-${VERSION}"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir "$INSTDIR"

  !insertmacro MUI_STARTMENU_GETFOLDER Application "$StartMenuFolder"
  Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall nip2-${VERSION}.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\nip2-${VERSION}.lnk"
  RMDir "$SMPROGRAMS\$StartMenuFolder"
  DeleteRegKey /ifempty HKCU "Software\VIPS"
SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecDummy ${LANG_ENGLISH} "A test section."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
