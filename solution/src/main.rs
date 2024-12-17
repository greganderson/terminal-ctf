use clap::Parser;
use clap_derive::Parser;
use std::collections::HashMap;

mod users;
mod utils;

#[derive(Parser)]
struct Cli {
    /// The task number to check
    #[arg(short, long)]
    task: String,
}

type Solution = fn() -> Result<bool, std::io::Error>;

struct Task {
    checker: Solution,
    success: &'static str,
    failure: &'static str,
}

fn main() {
    println!("Hello, world!");

    let mut task_map: HashMap<&str, Task> = HashMap::new();
    task_map.insert(
        "1",
        Task {
            checker: users::check_user_creation,
            success: "You created the user correctly!",
            failure: "You did not create the user correctly.",
        },
    );

    task_map.insert(
        "2",
        Task {
            checker: users::check_passwd,
            success: "You successfully changed the password!",
            failure: "You did not change the password correctly.",
        },
    );

    let args = Cli::parse();

    if let Some(task) = task_map.get(args.task.as_str()) {
        match (task.checker)() {
            Ok(true) => println!("{}", task.success),
            Ok(false) => println!("{}", task.failure),
            Err(e) => println!("There was an error: {}", e),
        };
    } else {
        println!("Invalid flag: {}", args.task);
    }
}
