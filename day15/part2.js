
var TIME_LAPSES = {
    '0': [
        {'positions': 13, 'position': 11},
        {'positions': 5, 'position': 0},
        {'positions': 17, 'position': 11},
        {'positions': 3, 'position': 0},
        {'positions': 7, 'position': 2},
        {'positions': 19, 'position': 17},
        {'positions': 11, 'position': 0},
    ]
};

function runThrough(startTime, capsuleIndex) {
    if (!TIME_LAPSES.hasOwnProperty(startTime.toString())) {
        var previous = TIME_LAPSES[(startTime - 1).toString()];
        var lapsed = previous.map(function(elem) {
            elem.position = (elem.position + 1) % elem.positions;
            return elem;
        });
        TIME_LAPSES[startTime.toString()] = lapsed;
    }

    var currState = TIME_LAPSES[startTime.toString()];
    if (capsuleIndex === currState.length) return true;
    var currDisc = currState[capsuleIndex];
    if (currDisc.position !== 0) return false;
    return runThrough(startTime + 1, capsuleIndex + 1);
}

function solve() {
    var startTime = 0;
    while (true) {
        if (runThrough(startTime, 0)) break;
        ++startTime;
    }
    return startTime - 1;
}

console.log(solve());
