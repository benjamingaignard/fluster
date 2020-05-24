PY_FILES=fluxion decoders scripts fluxion.py

install_deps:
	python3 -m pip install -r requirements.txt

check:
	echo "Checking style with autopep8..."
	autopep8 --exit-code --diff -r $(PY_FILES)
	echo "Running pylint..."
	PYTHONPATH=. pylint $(PY_FILES) --fail-under=10
	echo "Running dummy test..."
	./fluxion.py list -ts
	./fluxion.py list -d
	./fluxion.py download dummy
	./fluxion.py run -ts dummy -d H.264Dummy

format:
	autopep8 -j4 -i -r $(PY_FILES)

lint:
	PYTHONPATH=. pylint $(PY_FILES)

h265_reference_decoder:
	git clone https://vcgit.hhi.fraunhofer.de/jct-vc/HM.git | true
	cd HM && git stash && git pull && git stash apply
	cd HM && cmake . -DCMAKE_BUILD_TYPE=Release
	cd HM %% make TAppDecoder -j
	find HM/bin/* -name 'TAppDecoder' -exec cp "{}" HM/bin/  \;

h264_reference_decoder:
	git clone https://vcgit.hhi.fraunhofer.de/jct-vc/JM.git | true
	cd JM && git stash && git pull && git stash apply
	cd JM && cmake . -DCMAKE_BUILD_TYPE=Release
	cd JM %% make ldecod -j
	find JM/bin/* -name 'ldecod' -exec cp "{}" JM/bin/  \;