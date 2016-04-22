all:
	rebar compile
	erl -pa ebin -con_path config -s data_app start

clean:
	rm -rf ebin/*.beam
	rm -rf *.beam
