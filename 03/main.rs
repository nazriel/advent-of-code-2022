use std::env::args as cli_args;
use std::path::Path;

fn get_lines(filename: &Path) -> Vec<String> {
    vec![""]
}

fn main() {
    let args: Vec<String> = cli_args().collect();
    if args.len() != 2 {
        panic!("input file not provided. usage: {:?} input_file.txt", args[0])
    }

    let input_file = Path::new(&args[1]);
    if !input_file.exists() {
        panic!("provided input file doesn't exist: {:?}", input_file.to_str().unwrap());
    }

    let lines = get_lines(input_file);
    println!("total: {:?}", lines.len())
}
