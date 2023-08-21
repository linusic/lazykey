import ctypes

dst_img_file = "/.../___.png" # support ["png", "jpeg", "ico", "gif", "webp", "bmp"]
# dst_img_file = ctypes.create_string_buffer(b"...")

dll_path = ...
dll = ctypes.WinDLL(dll_path)

print(dll.GetCBImage(dst_img_file))