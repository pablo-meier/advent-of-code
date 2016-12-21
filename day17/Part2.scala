import java.security.MessageDigest
import scala.collection.mutable.Queue
import scala.collection.mutable.ListBuffer

case class State(turn: Int, location: Int, key: String)

object Part2 {

  val hasher = MessageDigest.getInstance("MD5")

  def isOpenDoor(c: Char): Boolean = {
    c == 'b' || c == 'c' || c == 'd' || c == 'e' || c == 'f'
  }

  def adjacents(s: State, locks: String): List[State] = {
    val adjacents = new ListBuffer[State]()
    val newTurn = s.turn + 1

    val canGoUp = (s.location > 3) && isOpenDoor(locks(0))
    if (canGoUp) {
      adjacents += State(newTurn, s.location - 4, s.key + "U")
    }

    val canGoDown = (s.location < 12) && isOpenDoor(locks(1))
    if (canGoDown) {
      adjacents += State(newTurn, s.location + 4, s.key + "D")
    }

    val canGoLeft = ((s.location % 4) != 0) && isOpenDoor(locks(2))
    if (canGoLeft) {
      adjacents += State(newTurn, s.location - 1, s.key + "L")
    }

    val canGoRight = (s.location != 3 && s.location != 7 && s.location != 11) && isOpenDoor(locks(3))
    if (canGoRight) {
      adjacents += State(newTurn, s.location + 1, s.key + "R")
    }

    adjacents.toList
  }


  def hashFor(s: String) : String = {
    hasher.digest(s.getBytes).map("%02x".format(_)).mkString
  }


  def solve(q: Queue[State], base: String): Int = {
    var longestSoFar = 0
    while (q.nonEmpty) {
      val currState = q.dequeue()
      if (currState.location == 15) {
        longestSoFar = currState.key.length
        // lol Scala has no 'continue'!
      } else {
        val locks = hashFor(base + currState.key)
        adjacents(currState, locks).foreach(x => q.enqueue(x))
      }
    }
    longestSoFar
  }

  def main(args: Array[String]): Unit = {
    val base = "bwnlcvfs"

    val queue = new Queue[State]()
    val initState = State(0, 0, "")
    queue.enqueue(initState)
    val solution = solve(queue, base)
    println("Part 2")
    println(solution)
  }
}
