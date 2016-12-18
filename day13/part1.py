import heapq

PUZZLE_INPUT = 1358


class Location(object):
    def __init__(self, x, y, goal, path):
        self.x = x
        self.y = y
        self.priority = abs(goal[0] - x) + abs(goal[1] - y)
        self.path = path

    def heap_entry_from(self):
        return (self.priority, self)

    def __str__(self):
        return "({}, {}) - Priority {}, path length {}".format(self.x, self.y, self.priority, len(self.path))

    def __hash__(self):
        return hash((self.x, self.y))

    def __eq__(self, other):
        return hash(self) and hash(other)

    def __lt__(self, other):
        """
        So this is cute… we can't use dicts raw in a Priority Queue because if
        they have equal keys, it moves on to look at the second element of the
        tuple, which will be dicts, which Python 3 can't compare. So instead of
        using dicts, I'm wrapping in a class and breaking the tie here.
        """
        return self.x < other.x


def is_open(x, y):
    base = (x * x) + (3 * x) + (2 * y * x) + y + (y * y) + PUZZLE_INPUT
    return (bin(base)[2:].count('1')) % 2 == 0


def next_from(node, goal):
    """
    Returns adjacent non-wall nodes
    """
    adjacents = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    for offsets in adjacents:
        new_x = node.x + offsets[0]
        new_y = node.y + offsets[1]
        if new_x < 0 or new_y < 0:
            continue
        if is_open(new_x, new_y):
            yield Location(new_x, new_y, goal, node.path + [node])


def search(goal):
    initial = Location(1, 1, goal, [])

    unvisiteds = []
    heapq.heappush(unvisiteds, initial.heap_entry_from())
    visiteds = set()
    visiteds.add(initial)

    while len(unvisiteds):
        curr_node = heapq.heappop(unvisiteds)[1]
        visiteds.add(curr_node)
        if curr_node.x == goal[0] and curr_node.y == goal[1]:
            print(len(curr_node.path))
            break
        for item in next_from(curr_node, goal):
            if item not in visiteds:
                heapq.heappush(unvisiteds, item.heap_entry_from())

search((31, 39))
