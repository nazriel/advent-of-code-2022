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

fn item_prio(item: char) -> u32 {
    if item >= 'a' && item <= 'z' {
        item as u32 - 96
    } else if item >= 'A' && item <= 'Z' {
        item as u32 - 38
    } else {
        0
    }
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

fn backpack_duplicates_weight(mixed_items: &Vec<char>) -> u32 {
    mixed_items
        .iter()
        .map(| item | item_prio(*item))
        .sum()
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
    fn test_item_prio() {
        assert_eq!(item_prio(' '), 0);
        assert_eq!(item_prio('9'), 0);
        assert_eq!(item_prio('a'), 1);
        assert_eq!(item_prio('A'), 27);
        assert_eq!(item_prio('p'), 16);
        assert_eq!(item_prio('P'), 42);
        assert_eq!(item_prio('L'), 38);
        assert_eq!(item_prio('z'), 26);
        assert_eq!(item_prio('Z'), 52);
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

    #[test]
    fn test_backpack_duplicates_weight() {
        assert_eq!(backpack_duplicates_weight(&vec![]), 0);
        assert_eq!(backpack_duplicates_weight(&vec!['1']), 0);
        assert_eq!(backpack_duplicates_weight(&vec!['?']), 0);
        assert_eq!(backpack_duplicates_weight(&vec!['a']), 1);
        assert_eq!(backpack_duplicates_weight(&vec!['a', 'b', 'c']), 6);
        assert_eq!(backpack_duplicates_weight(&vec!['A', 'Z']), 27 + 52);
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
        let mixed_items = find_mixed_items(left, right);
        let _: u32 = backpack_duplicates_weight(&mixed_items);
    }
    println!("total: {:?}", 0)
}
