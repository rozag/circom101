pragma circom 2.1.6;

include "./circomlib/comparators.circom";
include "./circomlib/gates.circom";

// block93: |":1239,"follower| ->
//          [34 58 49 50 51 57 44 34 102 111 108 108 111 119 101 114]
// block94: |s_count":78,"fri| ->
//          [115 95 99 111 117 110 116 34 58 55 56 44 34 102 114 105]

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

template RememberDesiredValue() {

  signal input desiredVal;
  signal input val;
  signal input rememberVal;
  signal input forgetVal;

  signal output out;

  component eq = IsEqual();
  eq.in[0] <== desiredVal;
  eq.in[1] <== val;

  signal out0 <== eq.out * rememberVal;
  signal out1 <== (1 - eq.out) * forgetVal;
  out <== out0 + out1;
}

template Min() {

  signal input a;
  signal input b;

  signal output out;

  component lt = LessThan(9); // 8 + 1 to allow 256 (not found marker)
  lt.in[0] <== a;
  lt.in[1] <== b;

  signal out0 <== lt.out * a;
  signal out1 <== (1 - lt.out) * b;
  out <== out0 + out1;
}

template ValueStartIndex(dataSize, keySize) {

  signal input data[dataSize];
  signal input key[keySize];

  signal output valueStartIndex;

  signal tmp0KeyIdxOnIter[dataSize+1];
  tmp0KeyIdxOnIter[0] <== 0;

  signal tmp1KeyIdxOnIter[dataSize+1];
  tmp1KeyIdxOnIter[0] <== 0;

  signal keyIdxOnIter[dataSize+1];
  keyIdxOnIter[0] <== 0;

  signal targetIdxOnIter[dataSize+1];
  var notFound = 256;
  targetIdxOnIter[0] <== notFound;

  component eq[dataSize];
  component lim[dataSize];
  component memKey[dataSize];
  component memTarget[dataSize];
  component min[dataSize];

  for (var i = 0; i < dataSize; i++) {
    eq[i] = IsEqual();
    eq[i].in[0] <== data[i];
    eq[i].in[1] <-- key[keyIdxOnIter[i]];
    tmp0KeyIdxOnIter[i+1] <== eq[i].out * (keyIdxOnIter[i] + 1);

    lim[i] = LimitValueFromTop();
    lim[i].max <== keySize;
    lim[i].val <== tmp0KeyIdxOnIter[i+1];
    tmp1KeyIdxOnIter[i+1] <== lim[i].out;

    memKey[i] = RememberDesiredValue();
    memKey[i].desiredVal <== keySize;
    memKey[i].val <== keyIdxOnIter[i];
    memKey[i].rememberVal <== keySize;
    memKey[i].forgetVal <== tmp1KeyIdxOnIter[i+1];
    keyIdxOnIter[i+1] <== memKey[i].out;

    min[i] = Min();
    min[i].a <== targetIdxOnIter[i];
    min[i].b <== i + 1;

    memTarget[i] = RememberDesiredValue();
    memTarget[i].desiredVal <== keySize;
    memTarget[i].val <== keyIdxOnIter[i+1];
    memTarget[i].rememberVal <== min[i].out;
    memTarget[i].forgetVal <== targetIdxOnIter[i];
    targetIdxOnIter[i+1] <== memTarget[i].out;
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
  log("targetIdxOnIter:", targetIdxOnIter[0], targetIdxOnIter[1],
    targetIdxOnIter[2], targetIdxOnIter[3], targetIdxOnIter[4],
    targetIdxOnIter[5], targetIdxOnIter[6], targetIdxOnIter[7],
    targetIdxOnIter[8], targetIdxOnIter[9], targetIdxOnIter[10],
    targetIdxOnIter[11], targetIdxOnIter[12], targetIdxOnIter[13],
    targetIdxOnIter[14], targetIdxOnIter[15], targetIdxOnIter[16],
    targetIdxOnIter[17], targetIdxOnIter[18], targetIdxOnIter[19],
    targetIdxOnIter[20], targetIdxOnIter[21], targetIdxOnIter[22],
    targetIdxOnIter[23], targetIdxOnIter[24], targetIdxOnIter[25],
    targetIdxOnIter[26], targetIdxOnIter[27], targetIdxOnIter[28],
    targetIdxOnIter[29], targetIdxOnIter[30], targetIdxOnIter[31],
    targetIdxOnIter[32]);

  valueStartIndex <== targetIdxOnIter[dataSize];
}

template InIntervalInclusive() {

  signal input val;
  signal input min;
  signal input max;

  signal output out; // 1 if val is in [min, max], 0 otherwise

  component leqt = LessEqThan(8);
  leqt.in[0] <== val;
  leqt.in[1] <== max;

  component geqt = GreaterEqThan(8);
  geqt.in[0] <== val;
  geqt.in[1] <== min;

  out <== AND()(leqt.out, geqt.out);
}

template ExtractDigitChars() {

  var blockSizeBytes = 16;
  var blocksCnt = 2;

  var dataSizeBytes = blockSizeBytes * blocksCnt;

  signal input data[dataSizeBytes];
  signal input valueStartIndex;

  signal output digitChars[dataSizeBytes];

  var char0 = 48; // 0
  var char9 = 57; // 9

  component geqt[dataSizeBytes];
  component inInterval[dataSizeBytes];
  component and[dataSizeBytes];
  for (var i = 0; i < dataSizeBytes; i++) {
    // Index is not byte size actually, but we only have 32 bytes, so default
    // 8 bits is good enough for now.
    geqt[i] = GreaterEqThan(8);
    geqt[i].in[0] <== i;
    geqt[i].in[1] <== valueStartIndex;

    inInterval[i] = InIntervalInclusive();
    inInterval[i].val <== data[i];
    inInterval[i].min <== char0;
    inInterval[i].max <== char9;

    and[i] = AND();
    and[i].a <== geqt[i].out;
    and[i].b <== inInterval[i].out;

    digitChars[i] <== and[i].out * data[i];
  }

  log("digitChars:", digitChars[0], digitChars[1], digitChars[2], digitChars[3],
    digitChars[4], digitChars[5], digitChars[6], digitChars[7], digitChars[8],
    digitChars[9], digitChars[10], digitChars[11], digitChars[12],
    digitChars[13], digitChars[14], digitChars[15], digitChars[16],
    digitChars[17], digitChars[18], digitChars[19], digitChars[20],
    digitChars[21], digitChars[22], digitChars[23], digitChars[24],
    digitChars[25], digitChars[26], digitChars[27], digitChars[28],
    digitChars[29], digitChars[30], digitChars[31]);
}

template NumberFromDigitChars() {

  var blockSizeBytes = 16;
  var blocksCnt = 2;

  var dataSizeBytes = blockSizeBytes * blocksCnt;

  signal input digitChars[dataSizeBytes];

  signal output out;

  signal tmpOut0[dataSizeBytes + 1];
  tmpOut0[0] <== 0;
  signal tmpOut1[dataSizeBytes + 1];
  tmpOut1[0] <== 0;
  signal tmpOut[dataSizeBytes + 1];
  tmpOut[0] <== 0;

  var char0 = 48; // 0

  component eq[dataSizeBytes];
  for (var i = 0; i < dataSizeBytes; i++) {
    eq[i] = IsEqual();
    eq[i].in[0] <== digitChars[i];
    eq[i].in[1] <== 0;

    tmpOut0[i+1] <== eq[i].out * tmpOut[i];
    tmpOut1[i+1] <==
      (1 - eq[i].out) * (10 * tmpOut[i] + (digitChars[i] - char0));
    tmpOut[i+1] <== tmpOut0[i+1] + tmpOut1[i+1];
  }

  log("tmpOut:", tmpOut[0], tmpOut[1], tmpOut[2], tmpOut[3], tmpOut[4],
    tmpOut[5], tmpOut[6], tmpOut[7], tmpOut[8], tmpOut[9], tmpOut[10],
    tmpOut[11], tmpOut[12], tmpOut[13], tmpOut[14], tmpOut[15], tmpOut[16],
    tmpOut[17], tmpOut[18], tmpOut[19], tmpOut[20], tmpOut[21], tmpOut[22],
    tmpOut[23], tmpOut[24], tmpOut[25], tmpOut[26], tmpOut[27], tmpOut[28],
    tmpOut[29], tmpOut[30], tmpOut[31]);

  out <== tmpOut[dataSizeBytes];
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
  log("valueStartIndex:", valueStartIndex);

  // Checking that valueStartIndex is not 256 (not found marker)
  var notFound = 256;
  component lt = LessThan(9); // 8 + 1 to allow 256 (not found marker)
  lt.in[0] <== valueStartIndex;
  lt.in[1] <== notFound;
  1 === lt.out;

  // Extract digit characters, if our target number is 78, digitChars will hold
  // something like [0, 0, ..., 0, byte('7'), byte('8'), 0, 0, ..., 0]
  signal digitChars[dataSizeBytes] <==
    ExtractDigitChars()(data, valueStartIndex);

  // Parse number from digit chars
  signal num <== NumberFromDigitChars()(digitChars);
  log("num:", num);

  // Final answer
  component geqt = GreaterEqThan(252);
  geqt.in[0] <== num;
  geqt.in[1] <== targetCnt;
  hasAtLeastFollowersCnt <== geqt.out;
  log("hasAtLeastFollowersCnt:", hasAtLeastFollowersCnt);

  hasAtLeastFollowersCnt === 1;
}

component main { public [ targetCnt ] } = AtLeastFollowersCnt();
