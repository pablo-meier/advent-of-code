
BUILD=build

run: build
	java -cp $(BUILD) Main


build: prepare
	javac -d $(BUILD) src/Main.java

clean:
	rm -rf $(BUILD)

prepare:
	[ -d $(BUILD) ] || mkdir $(BUILD)
