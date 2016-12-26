
run: build
	psql -f part1.sql

build:
	psql -f base.sql
	./make_inserts.sh
	psql -f inserts.sql

clean:
	psql -f clean.sql
	rm -f inserts.sql
