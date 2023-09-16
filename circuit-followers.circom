pragma circom 2.1.6;

include "./circomlib/comparators.circom";
include "./circomlib/gates.circom";

// block93: |":1239,"follower| ->
//          [34 58 49 50 51 57 44 34 102 111 108 108 111 119 101 114]
// block94: |s_count":78,"fri| ->
//          [115 95 99 111 117 110 116 34 58 55 56 44 34 102 114 105]

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
