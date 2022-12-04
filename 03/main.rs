use std::collections::HashSet;
use std::fs::File;
use std::io::{ BufReader, prelude::* };
use std::env::args as cli_args;
use std::path::Path;

fn get_lines(filename: &Path) -> Vec<String> {
    let fp = File::open(filename).expect("file has to be readable");
    let buf = BufReader::new(fp);
    buf.lines()
        .map(|line| line.unwrap())
        .collect()
}

fn split_backpack(equipment: &str) -> [&str; 2] {
    let middle = equipment.len() / 2;
    [&equipment[..middle], &equipment[middle..]]
}

fn find_mixed_items(left: &str, right: &str) -> Vec<char> {
    let mut mixed: HashSet<char> = HashSet::new();

    for ch in left.chars() {
        if right.find(ch) != None {
            mixed.insert(ch);
        }
    }

    let mut res: Vec<char> = mixed.into_iter().collect();
    res.sort();
    res
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_get_lines() {
        let expected = vec![
            "vJrwpWtwJgWrhcsFMMfFFhFp", "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL", "PmmdzqPrVvPwwTWBwg", "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
            "ttgJtRGJQctTZtZT", "CrZsJsPPZsGzwwsLwLmpwMDw"
        ];
        assert_eq!(get_lines(Path::new("test_input.txt")), expected);
    }

    #[test]
    fn test_split_backpack() {
        assert_eq!(split_backpack(""), ["", ""]);
        assert_eq!(split_backpack("a"), ["", "a"]);
        assert_eq!(split_backpack("vJ"), ["v", "J"]);
        assert_eq!(split_backpack("vJa"), ["v", "Ja"]);
        assert_eq!(split_backpack("vJrwpWtwJgWrhcsFMMfFFhFp"), ["vJrwpWtwJgWr", "hcsFMMfFFhFp"]);

    }

    #[test]
    fn test_find_mixed_items() {
        assert_eq!(find_mixed_items("", ""), []);
        assert_eq!(find_mixed_items("abc", "def"), []);
        assert_eq!(find_mixed_items("abc", "abc"), ['a', 'b', 'c']);
        assert_eq!(find_mixed_items("abccdefg", "ihjlac"), ['a', 'c']);
    }
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
    for line in lines {
        let [left, right] = split_backpack(&line);
        let _ = find_mixed_items(left, right);
    }
    println!("total: {:?}", 0)
}
