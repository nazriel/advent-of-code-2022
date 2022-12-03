import std.algorithm: map, maxIndex, maxElement, topN, sum;
import std.array: array, empty;
import std.conv: to;
import std.exception: assertThrown, assertNotThrown, enforce;
import std.file: exists;
import std.range: back;
import std.regex: ctRegex, matchFirst;
import std.stdio: File, writeln, stdin;

/// Checks whenever given line contains valid calories values or empty line.
string validator(string line)
{
    auto rExpr = ctRegex!"^[0-9]*$";
    enforce(matchFirst(line, rExpr).length > 0, "not valid calories data: " ~ line);
    return line;
}

///
unittest
{
    assertNotThrown(validator(""));
    assertNotThrown(validator("1234"));
    assertThrown(validator("a"));
    assertThrown(validator("."));
}

/// Extracts lines with calories from either filename or stdin
string[] getLines(string fname)
{
    File handle = (() => !fname.empty() && fname.exists() ? File(fname, "r") : stdin)();
    return handle.byLineCopy()
        .map!validator()
        .array();
}

///
unittest
{
    assert(getLines("test_input.txt").length == 14);
}

/// Parse lines and extracts
uint[] extractElvesCalories(string[] data)
{
    uint[] caloriesPerElf;
    uint caloriesSoFar = 0;
    foreach (line; data)
    {
        if (line.empty())
        {
            caloriesPerElf ~= caloriesSoFar;
            caloriesSoFar = 0;
        }
        else
        {
            caloriesSoFar += line.to!uint();
        }
    }

    if (!data.empty() && !data.back.empty())
    {
        caloriesPerElf ~= caloriesSoFar;
    }

    return caloriesPerElf;
}

unittest
{
    assert(extractElvesCalories([]) == []);

    assert(extractElvesCalories(["1", "2"]) == [3]);
    assert(extractElvesCalories(["1", "2", ""]) == [3]);

    assert(extractElvesCalories(["1", "2", "", "4"]) == [3, 4]);
    assert(extractElvesCalories(["1", "2", "", "4", ""]) == [3, 4]);
}

size_t findMostJuicedElf(uint[] calories)
{
    return calories.maxIndex() + 1;
}

unittest
{
    assert(findMostJuicedElf([]) == 0);
    assert(findMostJuicedElf([0]) == 1);
    assert(findMostJuicedElf([100]) == 1);
    assert(findMostJuicedElf([100, 1000, 500]) == 2);
}

uint findMostCalories(uint[] calories)
{
    return !calories.empty() ? calories.maxElement() : 0;
}

unittest
{
    assert(findMostCalories([]) == 0);
    assert(findMostCalories([0]) == 0);
    assert(findMostCalories([100]) == 100);
    assert(findMostCalories([100, 1000, 500]) == 1000);
}

void main(string[] args)
{
    string[] lines = getLines(args.length > 1 ? args[1] : "");
    uint[] calories = extractElvesCalories(lines);
    writeln("most calories: ", findMostCalories(calories));
}

unittest
{
    string[] lines = getLines("test_input.txt");
    assert(lines.length == 14);

    uint[] calories = extractElvesCalories(lines);
    assert(calories.length == 5);

    assert(findMostJuicedElf(calories) == 4);

    assert(findMostCalories(calories) == 24_000);
}
