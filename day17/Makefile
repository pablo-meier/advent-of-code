
BUILD=build


run: build
	scala -cp $(BUILD) Part1

build: prepare
	scalac -d $(BUILD) Part1.scala

prepare:
	[ -d $(BUILD) ] || mkdir $(BUILD)

clean:
	rm -rf $(BUILD)
