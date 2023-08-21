use std::ffi::OsString;
use std::os::windows::prelude::*;

use arboard::Clipboard;
use image::{ImageBuffer,RgbaImage, DynamicImage};

#[no_mangle]
pub extern "C" fn GetCBImage(file: *const u16) {
    let mut clipboard = Clipboard::new().unwrap();
    if let Ok(image) = clipboard.get_image(){
        let image: RgbaImage = ImageBuffer::from_raw(
            image.width.try_into().unwrap(),
            image.height.try_into().unwrap(),
            image.bytes.into_owned(),
        ).unwrap();

        let string = unsafe { u16_ptr_to_string(file) };

        match DynamicImage::ImageRgba8(image).save(string) {
            Ok(_) => (),
            Err(_) => eprintln!("{}", -1),
        }
    }
}

// https://stackoverflow.com/a/48587463
unsafe fn u16_ptr_to_string(ptr: *const u16) -> OsString {
    let len = (0..).take_while(|&i| *ptr.offset(i) != 0).count();
    let slice = std::slice::from_raw_parts(ptr, len);

    OsString::from_wide(slice)
}