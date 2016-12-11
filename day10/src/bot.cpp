#include "bot.h"

#include "instructions.h"

Bot::Bot(uint16_t id) :
    id(id), chip1(0), chip2(0)
{ }

Bot::~Bot() {}

uint16_t
Bot::getId() {
    return this->id;
}

bool
Bot::hasTwoChips() {
    return this->chip1 != 0 && this->chip2 != 0;
}

void
Bot::accept(uint16_t value) {
    if (this->chip1 == 0) {
        this->chip1 = value;
    } else if (this->chip2 == 0) {
        this->chip2 = value;
    }
}

void
Bot::give(shared_ptr<Bot> high, shared_ptr<Bot> low) {
    high->accept(this->getHigh());
    low->accept(this->getLow());
    this->reset();
}

void
Bot::give(shared_ptr<Bot> high, vector<uint16_t>* low, uint16_t low_index) {
    high->accept(this->getHigh());
    safeSet(low, low_index, this->getLow());
    this->reset();
}

void
Bot::give(vector<uint16_t>* high, uint16_t high_index, shared_ptr<Bot> low) {
    safeSet(high, high_index, this->getHigh());
    low->accept(this->getLow());
    this->reset();
}

void
Bot::give(vector<uint16_t>* vec, uint16_t high_index, uint16_t low_index) {
    safeSet(vec, high_index, this->getHigh());
    safeSet(vec, low_index, this->getLow());
    this->reset();
}

void
Bot::reset() {
    this->chip1 = 0;
    this->chip2 = 0;
}

bool
Bot::checkWinCondition() {
    auto has61 = this->getHigh() == 61;
    auto has17 = this->getLow() == 17;
    return has61 && has17;
}

void
Bot::safeSet(vector<uint16_t>* vec, uint16_t index, uint16_t value) {
    if (index > vec->size()) {
        vec->resize(index + 1);
    }
    (*vec)[index] = value;
}

uint16_t
Bot::getHigh() {
    if (this->chip1 > this->chip2) return this->chip1;
    else return this->chip2;
}

uint16_t
Bot::getLow() {
    if (this->chip1 < this->chip2) return this->chip1;
    else return this->chip2;
}
