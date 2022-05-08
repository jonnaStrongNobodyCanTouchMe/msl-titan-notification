#Include form_push.ahk
global CURRENT_VERSION := "0.1.0"
global NOX_CLASS_NAME := "Qt5QWindowIcon"
global MENU_ICON_DIR := A_ScriptDir . "\bin\gui\icon.ico"
global WIN_TITLE_ARR := _getWindowTitles()


; Set Icon
TraySetIcon(MENU_ICON_DIR, 1, true)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Create GUI
global form := GuiCreate()
form.SetFont(, "consolas")
form.Title := "MSL Notifier Rip v" . CURRENT_VERSION
form.OnEvent("Close", (*) => ExitApp())
; Create Log Text
form.Add("Edit", "x5 y130 w308 h20 vEDT_status", "Hi!").SetFont("s8","consolas")
; Create Form Buttons
form.Add("Button", "x255 y3 w50 h20 vBTN_reload", "RELOAD").SetFont("s8")
form['BTN_reload'].OnEvent("Click", "_onClick_reload")
form.Add("Button", "x200 y3 w50 h20 vBTN_pause", "PAUSE").SetFont("s8")
form['BTN_pause'].OnEvent("Click", "_onClick_pause")
form.Add("Button", "x145 y3 w50 h20 vBTN_test", "TEST").SetFont("s8")
form['BTN_test'].OnEvent("Click", "_onClick_test")
; Create Tabs
TAB := form.Add("Tab3", "x5 y5 w310 h122 vVAL_currentTab", ["Settings", "Clan"])
; General Settings
TAB.UseTab("Settings", false)
form.Add("Text", "x15 y35 w200 h20", "Select Nox Player")
form.Add("DropDownList", "x14 y52 w150 h20 R5 vDDL_titles", WIN_TITLE_ARR)
form['DDL_titles'].OnEvent("Change", "_onChange_selectTitle")
form['DDL_titles'].OnEvent("Focus", "_onFocus_refreshTitle")
form['DDL_titles'].Focus()
form.Add("Text", "x175 y56 w80 h20 vTXT_noxcheck cRed", "..").SetFont("s8")
form.Add("Checkbox", "x100 y82 w80 h15 vCB_playsound", "play sound").SetFont("s8")
ControlSetChecked IniRead("settings.ini", "Notification", "ENABLE_SOUND"), form['CB_playsound']
form['CB_playsound'].OnEvent("Click", "_onClick_togglePlaySound")
form.Add("Checkbox", "x205 y82 w95 h15 vCB_alwaysOnTop", "Always on Top").SetFont("s8")
form.Add("Checkbox", "x100 y102 w200 h15 vCB_push" , "receive notificaition from App").SetFont("s8")
ControlSetChecked IniRead("settings.ini", "Notification", "ENABLE_PUSH"), form['CB_push']
form['CB_push'].OnEvent("Click", "_onClick_togglePush")
form.Add("Button", "x13 y80 w80 h40 vBTN_qpush", "Push Settings").SetFont("s8")
form['BTN_qpush'].OnEvent("Click", "_onClick_openQpushSettings")
form['CB_alwaysOnTop'].OnEvent("Click", (*) => WinSetAlwaysOnTop(-1))
; Clan
TAB.UseTab("Clan", false)
form.Add("Button", "x15 y35 w70 h25 vBTN_clanSet Disabled", "Set")
form['BTN_clanSet'].OnEvent("Click", "_onClick_startClanAlarm")
form.Add("Text", "x95 y41 w85 h14 vTXT_titan", "Titan Element:").SetFont("s8")
form.Add("DropDownList", "x185 y37 h90 w55 R5 vDDL_titanElement", "Dark|Water|Wood|Light|Fire").SetFont("s8")
form['DDL_titanElement'].OnEvent("Change", "_onChange_selectTitan")
form.Add("Checkbox", "x16 y70 w113 h15 vCB_popmsgbox", "pop message when").SetFont("s8")
form['CB_popmsgbox'].OnEvent("Click", "_onClick_checkboxPop")
form.Add("Edit", "x135 y68 w40 h20 vEDT_time", "").SetFont("s8","consolas")
form.Add("Text", "x190 y70 w120 h20", "eg. 1310 <- 13:10").SetFont("s8")
; Gui END
if (ENV = "Production") {
    ControlHide form['BTN_test']
}
form.Show("x521 y355 h155 w320")


_getWindowTitles() {
    idsArr := WinGetList(,, "Program Manager")
    res := Array()

    for currentID in idsArr {
        currentTitle := WinGetTitle(currentID)
        if (currentTitle) {
            res.Push(currentTitle)
        }
    }
    return res
}