; 
#include Gdip_All.ahk
#include Gdip_ImageSearch.ahk

Gdip_simp(_title, _fileDir, _searchOnly:=false, _variation:=10, _sX:=0, _sY:=0, _eX:=0, _eY:=0) {
    pToken := Gdip_Startup()
    pHaystack := Gdip_BitmapFromHwnd(WinExist(_title))
    pNeedle := Gdip_CreateBitmapFromFile(_fileDir)

    result := Gdip_ImageSearch(pHaystack, pNeedle, outputVar, _sX, _sY, _eX, _eY, _variation)

    Gdip_DisposeImage(pHaystack)
    Gdip_DisposeImage(pNeedle)
    Gdip_Shutdown(pToken)

    Switch result {
        Case 1: 
            if (_searchOnly) {
                return result
            }
            strArr := StrSplit(outputVar, ",")
            posObj := {}
            posObj.x := strArr[1]
            posObj.y := strArr[2]
            return posObj
        Case 0: return result
        Case -1001: 
            MsgBox("result:-1001`ninvalid haystack and/or needle bitmap pointer", "error", "Iconx")
            return result
        Case -1002: 
            MsgBox("result:-1002`ninvalid variation value", "error", "Iconx")
            return result
        Case -1003: 
            MsgBox("result:-1003`nX1 and Y1 cannot be negative", "error", "Iconx")
            return result
        Case -1004: 
            MsgBox("result:-1004`nunable to lock haystack bitmap bits", "error", "Iconx")
            return result
        Case -1005: 
            MsgBox("result:-1005`nunable to lock needle bitmap bits", "error", "Iconx")
            return result
        Default: 
            MsgBox("result:" . result . "`nunexpected result", "error", "Iconx")
            return result
    }
}