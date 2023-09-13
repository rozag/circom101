compile:
	rm -rfv .build/* || true

	circom \
	 --verbose \
	 --inspect \
	 --prime bn128 \
	 --O2 \
	 --r1cs \
	 --sym \
	 --wasm \
	 --json \
	 --output .build \
	 circuit.circom

	snarkjs r1cs info .build/circuit.r1cs
	snarkjs r1cs export json .build/circuit.r1cs .build/circuit.r1cs.json

witness:
	node .build/circuit_js/generate_witness.js \
	 .build/circuit_js/circuit.wasm \
	 input.json \
	 .build/witness.wtns
	snarkjs wtns check \
	 .build/circuit.r1cs \
	 .build/witness.wtns

