use std::fs::File;
use std::io::{self, BufRead, BufReader, Error, ErrorKind};
use std::path::Path;

pub fn read_lines<P>(filename: P) -> io::Result<Vec<String>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    let reader = BufReader::new(file);

    reader.lines().collect()
}

pub fn decrypt_xor<S>(hex: S, key: u8) -> io::Result<String>
where
    S: Into<String>,
{
    let hex = hex.into();

    if hex.len() % 2 != 0 {
        return Err(Error::new(
            ErrorKind::InvalidInput,
            "Hex string must be even number length",
        ));
    }

    let mut bytes = Vec::with_capacity(hex.len() / 2);
    for i in (0..hex.len()).step_by(2) {
        let pair = &hex[i..i + 2];
        let byte = u8::from_str_radix(pair, 16)
            .map_err(|e| Error::new(ErrorKind::InvalidInput, format!("Invalid hex: {}", e)))?;
        bytes.push(byte);
    }

    for byte in &mut bytes {
        *byte ^= key;
    }

    let ascii = bytes.iter().map(|&b| b as char).collect();

    Ok(ascii)
}
