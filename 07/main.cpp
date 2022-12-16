#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <regex>
#include <map>


std::vector<std::string> read_lines(std::string filename) {
    std::vector<std::string> lines;
    std::ifstream file(filename);
    std::string line;
    while (std::getline(file, line)) {
        lines.push_back(line);
    }
    return lines;
}

std::string join_path(std::vector<std::string> cwd) {
    std::string result;
    for (const auto& path : cwd) {
        result += path + "/";
    }
    return result.substr(1);
}

auto process_lines(const std::vector<std::string>&& lines) {

    const std::regex file_regex(R"--(^(\d+) (.+)$)--");

    std::vector<std::string> cwd;
    std::map<std::string, uint64_t> files;
    std::string current_ls_path;

    for (const auto line : lines) {
        if (line.size() >= 1 && line[0] == '$') {
            if (line.substr(0, 4) == "$ cd") {
                current_ls_path = "";
                const auto path = line.substr(5);
                if (path == "..") {
                    cwd.pop_back();
                } else {
                    cwd.push_back(path);
                }
            } else if (line.substr(0, 4) == "$ ls") {
                current_ls_path = join_path(cwd);
            }
        } else {
            if (current_ls_path.size() > 0) {
                std::smatch match;
                if (std::regex_match(line, match, file_regex)) {
                    const auto size = std::stoi(match[1]);
                    const auto name = match[2].str();
                    files.emplace(current_ls_path + name, size);
                }
            }
        }
    }

    return files;
}

auto get_parent_dir(const std::string& path) {
    auto pos = path.find_last_of('/');
    if (pos != std::string::npos) {
        return path.substr(0, pos);
    }

    return std::string("");
}

auto group_into_dirs(const std::map<std::string, uint64_t>&& files) {
    std::map<std::string, uint64_t> dirs;
    for (const auto& file : files) {
        const auto& path = file.first;
        const auto& size = file.second;

        auto pp = get_parent_dir(path);
        dirs[pp] =  dirs[pp] + size;

        while (pp != "") {
            pp = get_parent_dir(pp);
            dirs[pp] =  dirs[pp] + size;
        }

    }

    return dirs;
}

int main(int argc, char** argv) {
    auto lines = read_lines(argv[1]);

    auto files = process_lines(std::move(lines));
    auto dirs = group_into_dirs(std::move(files));

    std::cout << "part1: ";
    uint64_t sum = 0;
    for (const auto& dir : dirs) {
        if (dir.second > 100000u) {
            continue;
        }
        sum += dir.second;
    }
    std::cout << sum << std::endl;

    std::cout << "part2: ";
    const auto total = 70000000;
    const auto update = 30000000;
    const auto free = total - dirs[""];
    const auto needed = update - free;

    std::vector<uint64_t> candidates;
    for (const auto& dir : dirs) {
        if (dir.second >= needed) {
            candidates.push_back(dir.second);
        }
    }
    std::cout << *std::min_element(candidates.begin(), candidates.end()) << std::endl;

    return 0;
}
