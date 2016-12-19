
BUILD=build

run: build
	java -cp $(BUILD) Main
	java -cp $(BUILD) Part2


build: prepare
	javac -d $(BUILD) src/Main.java
	javac -d $(BUILD) src/Part2.java

clean:
	rm -rf $(BUILD)

prepare:
	[ -d $(BUILD) ] || mkdir $(BUILD)
