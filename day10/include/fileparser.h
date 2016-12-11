#ifndef __FILEPARSER_H__
#define __FILEPARSER_H__

#include <list>

enum class TargetType;
class GiveInstruction;
class GetInstruction;

class FileParser {
    public:
        FileParser();
        ~FileParser();
        static void parseFile(std::string,
                              std::list<std::shared_ptr<GiveInstruction>>*,
                              std::list<std::shared_ptr<GetInstruction>>*);
    private:
        static TargetType targetTypeFromString(std::string);
};

#endif
