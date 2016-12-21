
BUILD=build


run: build
	scala -cp $(BUILD) Part1
	scala -cp $(BUILD) Part2

build: prepare
	scalac -d $(BUILD) Part1.scala
	scalac -d $(BUILD) Part2.scala

prepare:
	[ -d $(BUILD) ] || mkdir $(BUILD)

clean:
	rm -rf $(BUILD)
