;;; change the path
save_image_from_clipboard_dll := A_SCRIPTDIR  "\lib\cbimg.dll"

dst_img_file := "/.../___.png" ; support ["png", "jpeg", "ico", "gif", "webp", "bmp"]

;;; dll
mod_4_free := DllCall("LoadLibrary", "Str", save_image_from_clipboard_dll, "Ptr")
err := DllCall("cbimg\GetCBImage", "Str", dst_img_file)

;;; check or notify if need
; if !Integer(err)
;     msgbox("saved into: " dst_img_file)

;;; conserve memory if need
; DllCall("FreeLibrary", "Ptr", mod_4_free)