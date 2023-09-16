pragma circom 2.1.6;

include "./circomlib/comparators.circom";
include "./circomlib/gates.circom";

// block93: |":1239,"follower| ->
//          [34 58 49 50 51 57 44 34 102 111 108 108 111 119 101 114]
// block94: |s_count":78,"fri| ->
//          [115 95 99 111 117 110 116 34 58 55 56 44 34 102 114 105]

// NOTE: hint 1: `if` alternative (you might need this one):
//
//   template LimitValueFromTop() {
//
//     signal input max;
//     signal input val;
//
//     signal output out;
//
//     component gt = GreaterThan(8);
//     gt.in[0] <== val;
//     gt.in[1] <== max;
//
//     signal out0 <== gt.out * max;
//     signal out1 <== (1 - gt.out) * val;
//     out <== out0 + out1;
//   }

// NOTE: hint 2: working with write-once signals (you might need some modified
// version of this or just the idea itself):
//
// Source: github.com/privacy-scaling-explorations/maci/blob/v1/circuits/...
//           ...circom/trees/incrementalQuinTree.circom#L29
//
//   template QuinSelector(choices) {
//       signal input in[choices];
//       signal input index;
//       signal output out;
//
//       // Ensure that index < choices
//       component lessThan = LessThan(3);
//       lessThan.in[0] <== index;
//       lessThan.in[1] <== choices;
//       lessThan.out === 1;
//
//       component calcTotal = CalculateTotal(choices);
//       component eqs[choices];
//
//       // For each item, check whether its index equals the input index.
//       for (var i = 0; i < choices; i ++) {
//           eqs[i] = IsEqual();
//           eqs[i].in[0] <== i;
//           eqs[i].in[1] <== index;
//
//           // eqs[i].out is 1 if the index matches. As such, at most one
//           // input to calcTotal is not 0.
//           calcTotal.nums[i] <== eqs[i].out * in[i];
//       }
//
//       // Returns 0 + 0 + ... + item
//       out <== calcTotal.sum;
//   }

template AtLeastFollowersCnt() {

  var charQuotes =     34; // "
  var charComma =      44; // ,
  var charColon =      58; // :
  var charUnderscore = 95; // _

  var char0 = 48; // 0
  var char9 = 57; // 9

  var charC =  99; // c
  var charE = 101; // e
  var charF = 102; // f
  var charL = 108; // l
  var charN = 110; // n
  var charO = 111; // o
  var charR = 114; // r
  var charS = 115; // s
  var charT = 116; // t
  var charU = 117; // u
  var charW = 119; // w

  var blockSizeBytes = 16;
  var blocksCnt = 2;

  var dataSizeBytes = blockSizeBytes * blocksCnt;

  signal input targetCnt;  // Number, need to have at least that many followers
  signal input data[dataSizeBytes]; // 2 blocks of 16 bytes each

  signal output hasAtLeastFollowersCnt; // 1 if has >= targetCnt, 0 otherwise

  // NOTE: Check out ./circomlib/comparators.circom
  //   For example, LessThan:
  //     signal input in[2]; // 2 numbers
  //     signal output out;  // 1 if in[0] < in[1], 0 otherwise

  // TODO: implement
}

component main { public [ targetCnt ] } = AtLeastFollowersCnt();
