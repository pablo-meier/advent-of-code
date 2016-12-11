#include <iostream>
#include <list>
#include <map>
#include <cstdint>

#include "bot.h"
#include "instructions.h"
#include "fileparser.h"

using namespace std;

void attempt_to_give_out_chips(list<shared_ptr<GetInstruction>>*,
                               map<uint16_t, shared_ptr<Bot>>*);

bool attempt_bot_instructions(list<shared_ptr<GiveInstruction>>*,
                              map<uint16_t, shared_ptr<Bot>>*,
                              vector<uint16_t>*,
                              bool,
                              bool);

shared_ptr<Bot> get_bot(uint16_t,
                        map<uint16_t,
                        shared_ptr<Bot>>*);

bool checkAlternateWinCondition(vector<uint16_t>*);


/**
 * Parse/read all the instructions into vectors:
 * * One for all the "Goes to...".
 * * One for the "Give..."
 *
 * Iterate through all the "Goes to" and hand chips to any bot who's eligible,
 * doesn't have two.
 *
 * Then, for all the "Gives to...":
 *
 * See if it can be achieved (bot needs two values).
 *   If so:
 *     * Pop off the instruction.
 *     * Execute it.
 *     * Check win condition on receiving bots. If so, print bot number.
 *  Else:
 *    Continue.
 */
int
main(int argc, char** argv) {
    auto give_instructions = list<shared_ptr<GiveInstruction>>();
    auto get_instructions = list<shared_ptr<GetInstruction>>();
    FileParser::parseFile("input.txt", &give_instructions, &get_instructions);

    auto bots = map<uint16_t, shared_ptr<Bot>>();
    auto outputs = vector<uint16_t>();

    bool isPart1 = false;
    bool isPart2 = false;
    if (strcmp(argv[1], "--part1") == 0) {
        isPart1 = true;
    } else if (strcmp(argv[1], "--part2") == 0) {
        isPart2 = true;
    } else {
        cerr << "Must supply --part1 or --part2!" << endl;
        exit(-1);
    }
    
    while (true) {
        attempt_to_give_out_chips(&get_instructions, &bots);
        bool isFinished = attempt_bot_instructions(&give_instructions, &bots, &outputs, isPart1, isPart2);
        if (isFinished) break;
    }
}


/**
 * Cycles through the "goes to" instructions. If a bot is in a position to receive it
 * (they don't have their hands full), we give it to them and pop the item off
 * the list.
 */
void
attempt_to_give_out_chips(list<shared_ptr<GetInstruction>>* gets, map<uint16_t, shared_ptr<Bot>>* bots) {
    for (auto curr_instruction : *gets) {
        auto bot = get_bot(curr_instruction->getBot(), bots);
        if (!bot->hasTwoChips()) {
            bot->accept(curr_instruction->getValue());
        }
    }
}


/**
 * Cycles through the GiveInstructions. If a bot is in a position to perform one (they
 * have chips in both hands), we checks the win condition. If we win, return true. Else,
 * return false.
 */
bool
attempt_bot_instructions(
        list<shared_ptr<GiveInstruction>>* gives,
        map<uint16_t, shared_ptr<Bot>>* bots,
        vector<uint16_t>* outputs,
        bool isPart1,
        bool isPart2) {

    if (gives->empty()) {
        cout << "We are out of instructions!" << endl;
        return true;
    }
    
    bool stuckState = false;
    while (!stuckState) {
        stuckState = true;
        for (auto curr_instruction : *gives) {
            auto bot = get_bot(curr_instruction->getBot(), bots);
            if (bot->hasTwoChips()) {
                stuckState = false;
                if (bot->checkWinCondition() && isPart1) {
                    cout << "Part 1: " << bot->getId() << endl;
                    return true;
                }

                Target t1 = curr_instruction->getHighTarget();
                Target t2 = curr_instruction->getLowTarget();
                switch (t1.getType()) {
                    case TargetType::bot:
                        if (t2.getType() == TargetType::output) {
                            bot->give(get_bot(t1.getValue(), bots), outputs, t2.getValue());
                        } else {
                            bot->give(get_bot(t1.getValue(), bots), get_bot(t2.getValue(), bots));
                        }
                        break;
                    case TargetType::output:
                        if (t2.getType() == TargetType::output) {
                            bot->give(outputs, t1.getValue(), t2.getValue());
                        } else {
                            bot->give(outputs, t1.getValue(), get_bot(t2.getValue(), bots));
                        }
                        break;
                }
                if (checkAlternateWinCondition(outputs) && isPart2) {
                    return true;    
                }
            }
        }
    }
    return false;
}


/**
 * Fetches the bot, or creates one if we haven't done anything with it yet.
 */
shared_ptr<Bot>
get_bot(uint16_t botId, map<uint16_t, shared_ptr<Bot>>* bots) {
    auto maybe_bot = bots->find(botId);
    if (maybe_bot == bots->end()) {
        shared_ptr<Bot> new_bot(new Bot(botId));
        bots->insert(pair<uint16_t, shared_ptr<Bot>>(botId, new_bot));
        return new_bot;
    }
    return get<1>(*maybe_bot);
}

bool
checkAlternateWinCondition(vector<uint16_t>* outputs) {
    if (outputs->size() < 3) return false;
    uint16_t first = outputs->at(0);
    uint16_t second = outputs->at(1);
    uint16_t third = outputs->at(2);
    if (first != 0 && second != 0 & third != 0) {
        cout << "Part 2: " << (first * second * third) << endl;
        return true;
    }
    return false;
}
