pragma circom 2.1.6;

include "./circomlib/comparators.circom";

// block93: |":1239,"follower| ->
//          [34 58 49 50 51 57 44 34 102 111 108 108 111 119 101 114]
// block94: |s_count":66,"fri| ->
//          [115 95 99 111 117 110 116 34 58 54 54 44 34 102 114 105]

template LimitValueFromTop() {

  signal input max;
  signal input val;

  signal output out;

  component gt = GreaterThan(8);
  gt.in[0] <== val;
  gt.in[1] <== max;

  signal out0 <== gt.out * max;
  signal out1 <== (1 - gt.out) * val;
  out <== out0 + out1;
}

template ValueStartIndex(dataSize, keySize) {

  signal input data[dataSize];
  signal input key[keySize];

  signal output valueStartIndex;

  signal tmpKeyIdxOnIter[dataSize+1];
  tmpKeyIdxOnIter[0] <== 0;

  signal keyIdxOnIter[dataSize+1];
  keyIdxOnIter[0] <== 0;

  signal targetIdxOnIter[dataSize];
  targetIdxOnIter[0] <== -1;

  component eq[dataSize];
  component lim[dataSize];

  for (var i = 0; i < dataSize; i++) {
    eq[i] = IsEqual();
    eq[i].in[0] <== data[i];
    eq[i].in[1] <-- key[keyIdxOnIter[i]];
    tmpKeyIdxOnIter[i+1] <== eq[i].out * (keyIdxOnIter[i] + 1);

    lim[i] = LimitValueFromTop();
    lim[i].max <== keySize;
    lim[i].val <== tmpKeyIdxOnIter[i+1];
    keyIdxOnIter[i+1] <== lim[i].out;

    // TODO:
  }

  log("keyIdxOnIter:", keyIdxOnIter[0], keyIdxOnIter[1], keyIdxOnIter[2],
    keyIdxOnIter[3], keyIdxOnIter[4], keyIdxOnIter[5], keyIdxOnIter[6],
    keyIdxOnIter[7], keyIdxOnIter[8], keyIdxOnIter[9], keyIdxOnIter[10],
    keyIdxOnIter[11], keyIdxOnIter[12], keyIdxOnIter[13], keyIdxOnIter[14],
    keyIdxOnIter[15], keyIdxOnIter[16], keyIdxOnIter[17], keyIdxOnIter[18],
    keyIdxOnIter[19], keyIdxOnIter[20], keyIdxOnIter[21], keyIdxOnIter[22],
    keyIdxOnIter[23], keyIdxOnIter[24], keyIdxOnIter[25], keyIdxOnIter[26],
    keyIdxOnIter[27], keyIdxOnIter[28], keyIdxOnIter[29], keyIdxOnIter[30],
    keyIdxOnIter[31], keyIdxOnIter[32]);

  // func circuitJSONValueStartIdx(blocks []byte) int {
  // 	key := []byte("followers_count\":")
  // 	keyIdx := 0
  // 	for i, b := range blocks {
  // 		if b != key[keyIdx] {
  // 			keyIdx = 0
  // 			continue
  // 		}
  //
  // 		keyIdx++
  // 		if keyIdx == len(key) {
  // 			return i + 1
  // 		}
  // 	}
  //
  // 	return -1
  // }

}

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

  // followers_count":
  var keySizeBytes = 17;
  signal key[keySizeBytes];
  key[0] <== charF;          // f
  key[1] <== charO;          // o
  key[2] <== charL;          // l
  key[3] <== charL;          // l
  key[4] <== charO;          // o
  key[5] <== charW;          // w
  key[6] <== charE;          // e
  key[7] <== charR;          // r
  key[8] <== charS;          // s
  key[9] <== charUnderscore; // _
  key[10] <== charC;         // c
  key[11] <== charO;         // o
  key[12] <== charU;         // u
  key[13] <== charN;         // n
  key[14] <== charT;         // t
  key[15] <== charQuotes;    // "
  key[16] <== charColon;     // :

  signal valueStartIndex <==
    ValueStartIndex(dataSizeBytes, keySizeBytes)(data, key);
}

component main = AtLeastFollowersCnt();
