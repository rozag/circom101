pragma circom 2.1.6;

// block93: |":1239,"follower| ->
//          [34 58 49 50 51 57 44 34 102 111 108 108 111 119 101 114]
// block94: |s_count":66,"fri| ->
//          [115 95 99 111 117 110 116 34 58 54 54 44 34 102 114 105]

// NOTE: Symbol mapping:
//   " -> 34
//   : -> 58
//   1 -> 49
//   2 -> 50
//   3 -> 51
//   9 -> 57
//   , -> 44
//   f -> 102
//   o -> 111
//   l -> 108
//   w -> 119
//   e -> 101
//   r -> 114
//   s -> 115
//   _ -> 95
//   c -> 99
//   u -> 117
//   n -> 110
//   t -> 116
//   6 -> 54
//   i -> 105

template AtLeastFollowersCnt() {

  var blockSizeBytes = 16;
  var blocksCnt = 2;

  var dataSizeBytes = blockSizeBytes * blocksCnt;

  signal input targetCnt;  // Number, need to have at least that many followers
  signal input bytes[dataSizeBytes]; // 2 blocks of 16 bytes each

  signal output hasAtLeastFollowersCnt; // 1 if has >= targetCnt, 0 otherwise

  // NOTE: ./circomlib/comparators.circom/LessThan:
  //       signal input in[2]; // 2 numbers
  //       signal output out;  // 1 if in[0] < in[1], 0 otherwise

  // TODO: implement
}

component main = AtLeastFollowersCnt();
