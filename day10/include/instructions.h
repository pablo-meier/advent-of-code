#ifndef __INSTRUCTION_H__
#define __INSTRUCTION_H__
#include <cstdint>

enum class TargetType {
    bot, output
};

class Target {
    public:
        Target(TargetType type, uint16_t value);
        ~Target();
        TargetType getType();
        uint16_t getValue();
    private:
        TargetType type;
        uint16_t value;
};

class GiveInstruction {

    public:
        GiveInstruction(uint16_t bot, Target low, Target high);
        ~GiveInstruction();
        Target getHighTarget();
        Target getLowTarget();
        uint16_t getBot();
    private:
        uint16_t bot;
        Target low;
        Target high;
};


class GetInstruction {

    public:
        GetInstruction(uint16_t bot, uint16_t value);
        ~GetInstruction();
        uint16_t getBot();
        uint16_t getValue();
    private:
        uint16_t bot;
        uint16_t value;
};
#endif
