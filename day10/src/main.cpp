#include <iostream>
#include <list>
#include <map>
#include <cstdint>

#include "bot.h"
#include "instructions.h"
#include "fileparser.h"

using namespace std;

void attempt_to_give_out_chips(list<shared_ptr<GetInstruction>>*, map<uint16_t, shared_ptr<Bot>>*);
bool attempt_bot_instructions(list<shared_ptr<GiveInstruction>>*, map<uint16_t, shared_ptr<Bot>>*, vector<uint16_t>*);
shared_ptr<Bot> get_bot(uint16_t, map<uint16_t, shared_ptr<Bot>>*);
bool check_output_chips(vector<uint16_t>*);


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
    
    while (true) {
        attempt_to_give_out_chips(&get_instructions, &bots);
        bool isFinished = attempt_bot_instructions(&give_instructions, &bots, &outputs);
        if (isFinished) break;
    }

    cout << "Part 2: " << (outputs.at(0) * outputs.at(1) * outputs.at(2)) << endl;
}


/**
 * Cycles through the "goes to" instructions. If a bot is in a position to receive it
 * (they don't have their hands full), we give it to them and pop the item off
 * the list.
 */
void
attempt_to_give_out_chips(list<shared_ptr<GetInstruction>>* gets, map<uint16_t, shared_ptr<Bot>>* bots) {
    auto iter = gets->begin();
    while (iter != gets->end()) {
        auto curr_instruction = *iter;
        auto bot = get_bot(curr_instruction->getBot(), bots);
        if (!bot->hasTwoChips()) {
            bot->accept(curr_instruction->getValue());
            iter = gets->erase(iter);
        } else {
            ++iter;
        }
    }
}


/**
 * Cycles through the GiveInstructions. If a bot is in a position to perform one (they
 * have chips in both hands), we checks the win condition. If we win, return true. Else,
 * return false.
 */
bool
attempt_bot_instructions(list<shared_ptr<GiveInstruction>>* gives, map<uint16_t, shared_ptr<Bot>>* bots, vector<uint16_t>* outputs) {
    if (gives->empty()) {
        cout << "We are out of instructions!" << endl;
        return true;
    }
    
    auto iter = gives->begin();
    while (iter != gives->end()) {
        auto curr_instruction = *iter;
        auto bot = get_bot(curr_instruction->getBot(), bots);
        if (bot->hasTwoChips()) {
            if (bot->checkWinCondition()) {
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
            iter = gives->erase(iter);
        } else {
            ++iter;
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

