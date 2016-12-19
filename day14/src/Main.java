import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Main {

    private static final int NUM_KEYS = 64;
    private static final long BULK_SIZE = 2000;
    private static final long THREE_FIVES_INTERVAL = 1000;

    private NavigableSet<Long> keys;
    private long currChecking;

    private long maxConsidered;
    private Map<Long, String> threeDigitRepeats;
    private Map<String, List<Long>> fiveDigitRepeats;
    private String base;

    private MessageDigest hasher;
    private Pattern fiveDigits;
    private Pattern threeDigits;

    private Main(String base) {
        this.keys = new TreeSet<>();
        this.currChecking = 0;
        this.threeDigitRepeats = new HashMap<>();
        this.fiveDigitRepeats = new HashMap<>();
        this.maxConsidered = 0;
        this.base = base;

        fiveDigitRepeats.put("A", new ArrayList<>());
        fiveDigitRepeats.put("B", new ArrayList<>());
        fiveDigitRepeats.put("C", new ArrayList<>());
        fiveDigitRepeats.put("D", new ArrayList<>());
        fiveDigitRepeats.put("E", new ArrayList<>());
        fiveDigitRepeats.put("F", new ArrayList<>());
        fiveDigitRepeats.put("0", new ArrayList<>());
        fiveDigitRepeats.put("9", new ArrayList<>());
        fiveDigitRepeats.put("8", new ArrayList<>());
        fiveDigitRepeats.put("7", new ArrayList<>());
        fiveDigitRepeats.put("6", new ArrayList<>());
        fiveDigitRepeats.put("5", new ArrayList<>());
        fiveDigitRepeats.put("4", new ArrayList<>());
        fiveDigitRepeats.put("3", new ArrayList<>());
        fiveDigitRepeats.put("2", new ArrayList<>());
        fiveDigitRepeats.put("1", new ArrayList<>());

        try {
            this.hasher = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {
            // Java can be silly.
        }

        this.fiveDigits = Pattern.compile("(\\w)\\1{4}");
        this.threeDigits = Pattern.compile(".*?(\\w)\\1{2}.*");
    }

    private String hashFor(long considered) {
        try {
            byte[] bytesOfInput = (this.base + considered).getBytes("US-ASCII");
            byte[] digest = this.hasher.digest(bytesOfInput);
            return toHex(digest);
        } catch (UnsupportedEncodingException e) {
            // Never thrown.
            System.err.println("This platform does not support UTF-8 encoding... somehow.");
            System.exit(-1);
            return "";
        }
    }

    private static String toHex(byte[] bytes) {
        BigInteger bi = new BigInteger(1, bytes);
        return String.format("%0" + (bytes.length << 1) + "X", bi);
    }

    private Optional<List<String>> fiveDigitMatches(String s) {
        Matcher fiveDigitsMatches = this.fiveDigits.matcher(s);
        ArrayList<String> chars = new ArrayList<>();
        while (fiveDigitsMatches.find()) {
            String thisChar = fiveDigitsMatches.group(1);
            chars.add(thisChar);
        }
        return chars.isEmpty() ? Optional.empty() : Optional.of(chars);
    }

    private Optional<String> threeDigitMatches(String s) {
        Matcher threeDigitsMatches = this.threeDigits.matcher(s);
        boolean threeDigitMatches = threeDigitsMatches.matches();
        if (threeDigitMatches) return Optional.of(threeDigitsMatches.group(1));
        return Optional.empty();
    }


    private long solve() {
        while (keys.size() < NUM_KEYS) {
            if ((maxConsidered - currChecking) <= BULK_SIZE) {
                considerInBulk(BULK_SIZE);
            }

            String repeatedDigit = threeDigitRepeats.get(currChecking);
            if (repeatedDigit != null) {
                List<Long> forDigit = fiveDigitRepeats.get(repeatedDigit);
                for (long repeater : forDigit) {
                    if (repeater < currChecking) continue;
                    if (repeater != currChecking && repeater < (currChecking + THREE_FIVES_INTERVAL)) {
                        keys.add(currChecking);
                        break;
                    }
                }
            }

            ++currChecking;
        }
        return keys.last();
    }

    private void considerInBulk(long bulk) {
        for (long j = maxConsidered; j < (maxConsidered + bulk); ++j) {
            String thisHash = hashFor(j);
            Optional<List<String>> fiveDigitMatches = fiveDigitMatches(thisHash);
            Optional<String> threeDigitMatches = threeDigitMatches(thisHash);
            if (fiveDigitMatches.isPresent()) {
                for (String c : fiveDigitMatches.get()) {
                    List<Long> forDigit = this.fiveDigitRepeats.get(c);
                    forDigit.add(j);
                }
            }
            if (threeDigitMatches.isPresent()) {
                this.threeDigitRepeats.put(j, threeDigitMatches.get());
            }
        }
        this.maxConsidered += bulk;
    }


    public static void main(String[] args) {
        String puzzleInput = "ngcjuoqr";
//        String puzzleInput = "abc";
        Main main = new Main(puzzleInput);
        long lastKey = main.solve();
        System.out.println(lastKey);
    }
}
