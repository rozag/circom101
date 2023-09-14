pragma circom 2.1.6;

template Multiplier(n) {

  signal input a;
  signal input b;

  signal output c;

  signal int[n];

  int[0] <== a * a + b;
  for (var i = 1; i < n; i++) {
    int[i] <== int[i - 1] * int[i - 1] + b;
  }

  c <== int[n - 1];

  log("a:", a);
  log("b:", b);
  log("c:", c);
}

// component main = Multiplier(1000);
component main { public [ b ] } = Multiplier(1000);
