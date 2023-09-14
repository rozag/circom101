pragma circom 2.1.6;

// block93: |":1239,"follower| ->
//          [34 58 49 50 51 57 44 34 102 111 108 108 111 119 101 114]
// block94: |s_count":66,"fri| ->
//          [115 95 99 111 117 110 116 34 58 54 54 44 34 102 114 105]

template ValueStartIndex(dataSize, keySize) {

  signal input data[dataSize];
  signal input key[keySize];

  signal output valueStartIndex;

  signal keyIdxOnIter[dataSize];
  keyIdxOnIter[0] = 0;

  for (var i = 0; i < dataSize; i++) {

  }

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
  var keySize = 17;
  signal key[keySize];
  key[0] = charF;          // f
  key[1] = charO;          // o
  key[2] = charL;          // l
  key[3] = charL;          // l
  key[4] = charO;          // o
  key[5] = charW;          // w
  key[6] = charE;          // e
  key[7] = charR;          // r
  key[8] = charS;          // s
  key[9] = charUnderscore; // _
  key[10] = charC;         // c
  key[11] = charO;         // o
  key[12] = charU;         // u
  key[13] = charN;         // n
  key[14] = charT;         // t
  key[15] = charQuotes;    // "
  key[16] = charColon;     // :

  // NOTE: Check out ./circomlib/comparators.circom
  //   For example, LessThan:
  //     signal input in[2]; // 2 numbers
  //     signal output out;  // 1 if in[0] < in[1], 0 otherwise

  // TODO: implement
}

component main = AtLeastFollowersCnt();
