#ifndef __BOT_H__
#define __BOT_H__

#include <cstdint>
#include <vector>

using namespace std;

class GiveInstruction;
class GetInstruction;

class Bot {

    public:
        Bot(uint16_t id);
        ~Bot();
        uint16_t getId();
        bool hasTwoChips();

        void give(shared_ptr<Bot>, shared_ptr<Bot>);
        void give(shared_ptr<Bot>, vector<uint16_t>*, uint16_t);
        void give(vector<uint16_t>*, uint16_t, shared_ptr<Bot>);
        void give(vector<uint16_t>*, uint16_t, uint16_t);

        void accept(uint16_t value);
        bool checkWinCondition();

    private:
        uint16_t getHigh();
        uint16_t getLow();
        void safeSet(vector<uint16_t>*, uint16_t, uint16_t);
        void reset();

        uint16_t id;
        uint16_t chip1;
        uint16_t chip2;
};
#endif
