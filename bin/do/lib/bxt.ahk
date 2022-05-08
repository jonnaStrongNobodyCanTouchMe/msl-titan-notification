#Include Gdip\gdip-simplifier.ahk

; update just status
Bxt_updateStatus(_ctrlObj, statusText) {
    _ctrlObj.Gui['EDT_status'].Text := statusText
}

; update status when searching image with counts
Bxt_updateStatusSearching(statusObj, imgFileName, cntStr:="") {
    statusObj.Text := "searching for: " . imgFileName . " .. " . cntStr
}

; update status when found or not
Bxt_updateStatusFound(statusObj, found, imgFileName) {
    foundOrNotStr := (found) ? "Found" : "NotFound"
    statusObj.Text := foundOrNotStr . ": " . imgFileName
}

Bxt_hasImg(_ctrlObj, imgFileName, cnt:=1, updateSearchingStatus:=true, updateFoundStatus:=true) {
    dir := A_ScriptDir . "\bin\img\" . imgFileName . ".bmp"
    noxTitle := _ctrlObj.Gui['DDL_titles'].Text
    statusObj := _ctrlObj.Gui['EDT_status']

    Loop cnt {
        if (cnt > 1 && updateSearchingStatus) {
            Bxt_updateStatusSearching(statusObj, imgFileName, "(" . A_Index . " / " . cnt . ")")
        }

        ; search image 5 times per a cnt
        Loop 5 {
            found := Gdip_simp(noxTitle, dir, true)
            if (found) {
                break
            }
            Sleep(200)
        }

        if (found) {
            break
        }
    }

    ; update status
    if (updateFoundStatus) {
        Bxt_updateStatusFound(statusObj, found, imgFileName)
    }
    return found
}