#include "fileparser.h"
#include "instructions.h"

#include <iostream>
#include <list>
#include <regex>
#include <fstream>

using namespace std;

FileParser::FileParser(){
}

FileParser::~FileParser(){}


/**
 * Populates the vectors with instructions from the file.
 */
void
FileParser::parseFile(string filename,
                      list<shared_ptr<GiveInstruction>>* gives,
                      list<shared_ptr<GetInstruction>>* gets) {

    regex giveInstr("bot ([0-9]+) gives low to (bot|output) ([0-9]+) and high to (bot|output) ([0-9]+)");
    regex getInstr("value ([0-9]+) goes to bot ([0-9]+)");
    smatch matches;

    ifstream ifs(filename);
    for (string line; getline(ifs, line); ) {
        if (regex_search(line, matches, giveInstr)) {
            auto deliver_bot = stoi(matches[1]);
            auto low_target = targetTypeFromString(matches[2]);
            auto low_value = stoi(matches[3]);
            auto high_target = targetTypeFromString(matches[4]);
            auto high_value = stoi(matches[5]);
            shared_ptr<GiveInstruction> newInstr(new GiveInstruction(deliver_bot,
                        Target(low_target, low_value),
                        Target(high_target, high_value)));
            gives->push_back(newInstr);
        } else if (regex_search(line, matches, getInstr)) {
            auto value = stoi(matches[1]);
            auto bot_target = stoi(matches[2]);
            shared_ptr<GetInstruction> newInstr(new GetInstruction(bot_target, value));
            gets->push_back(newInstr);
        } else {
            cerr << "No regex matches! Line:" << line << endl;
        }
    }
}

TargetType
FileParser::targetTypeFromString(string input) {
    if (input.compare("bot") == 0) {
        return TargetType::bot;
    } else if (input.compare("output") == 0) {
        return TargetType::output;
    } else {
        cerr << "Bad output spec!" << endl;
        return TargetType::bot;
    }
}
