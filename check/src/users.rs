// Functions to check for different user account tasks

use super::utils;

pub fn check_user_creation() -> Result<bool, std::io::Error> {
    let user = "alice";
    let lines = utils::read_lines("/etc/shadow")?;

    let usernames: Vec<String> = lines
        .iter()
        .map(|line| line.split(':').next().unwrap_or("").to_string())
        .collect();

    for name in usernames {
        if name == user {
            return Ok(true);
        }
    }

    Ok(false)
}

pub fn check_passwd() -> Result<bool, std::io::Error> {
    let passwd = "donthackme";
    let user = "alice";
    let lines = utils::read_lines("./shadow.txt")?;

    let users: Vec<Vec<String>> = lines
        .iter()
        .map(|line| line.split(':').map(|part| part.to_string()).collect())
        .collect();

    let default = String::from("none");
    let shadow_passwd = users
        .iter()
        .find(|vec| vec.get(0) == Some(&user.to_string()))
        .and_then(|vec| vec.get(1))
        .unwrap_or(&default);

    let decrypted = utils::decrypt_xor(shadow_passwd, 0xAA)?;

    if decrypted == passwd {
        return Ok(true);
    }

    Ok(false)
}
