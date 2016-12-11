#include "instructions.h"

Target::Target(TargetType type, uint16_t value) :
    type(type), value(value) { }

Target::~Target() { }

TargetType
Target::getType() {
    return this->type;
}

uint16_t
Target::getValue() {
    return this->value;
}


GiveInstruction::GiveInstruction(uint16_t bot, Target low, Target high) :
    bot(bot), low(low), high(high)
{ }

GiveInstruction::~GiveInstruction() { }

Target GiveInstruction::getLowTarget() {
    return this->low;
}

Target GiveInstruction::getHighTarget() {
    return this->high;
}

uint16_t GiveInstruction::getBot() {
    return this->bot;
}


GetInstruction::GetInstruction(uint16_t bot, uint16_t value) :
    bot(bot), value(value) { }

GetInstruction::~GetInstruction() { }

uint16_t
GetInstruction::getBot() {
    return this->bot;
}

uint16_t
GetInstruction::getValue() {
    return this->value;
}
