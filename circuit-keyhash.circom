pragma circom 2.1.6;

include "./circomlib/bitify.circom";
include "./circomlib/mimc.circom";

// LEBits2BEBytes converts little-endian bits to big-endian bytes.
template LEBits2BEBytes(bitsCnt, bytesCnt) {

  signal input {binary} in[bitsCnt];
  signal output {byte} out[bytesCnt];

  signal {binary} binZero <== 0;

  component bits2Num[bytesCnt];
  for (var i = bytesCnt - 1; i >= 0; i--) {
    bits2Num[i] = Bits2Num(8);
    for (var j = 0; j < 8; j++) {
      var idx = (bytesCnt - 1 - i) * 8 + j;
      if (idx < bitsCnt) {
        bits2Num[i].in[j] <== in[idx];
      } else {
        bits2Num[i].in[j] <== binZero;
      }
    }
    out[i] <== bits2Num[i].out;
  }
}

// NOTE: expected key hash bytes:
//       30  141 11 139 151 72  229 28
//       192 19  81 219 235 3   87  238
//       64  6   43 173 110 126 242 143
//       80  62  35 136 36  102 171 171

// KeyHash computes MiMC7 hash of the key.
template KeyHash() {

  var keySizeBytes = 16;
  var keySize = keySizeBytes * 8;

  var hashSizeBytes = 32;

  signal input key[keySize];
  signal output {byte} keyHashBytes[hashSizeBytes];

  // Divide 128-bit key into bytes
  signal {binary} keyBytes[keySizeBytes][8];
  for (var i = 0; i < keySizeBytes; i++) {
    for (var j = 0; j < 8; j++) {
      keyBytes[i][j] <== key[i * 8 + j];
    }
  }

  // Convert key bytes to little-endian
  signal {binary} keyBytesLE[keySizeBytes][8];
  for (var i = 0; i < keySizeBytes; i++) {
    for (var j = 0; j < 8; j++) {
      keyBytesLE[i][j] <== keyBytes[i][8 - 1 - j];
    }
  }

  // Convert key to number
  var curveNumBitSize = 254;
  signal {binary} keyLE[curveNumBitSize];
  for (var i = 0; i < keySizeBytes; i++) {
    for (var j = 0; j < 8; j++) {
      keyLE[i * 8 + j] <== keyBytesLE[i][j];
    }
  }
  for (var i = keySize; i < curveNumBitSize; i++) {
    keyLE[i] <== 0;
  }
  signal keyNum <== Bits2Num_strict()(keyLE);

  // MiMC7 of the key number
  var numInputs = 1;
  var numRounds = 91;
  component hash = MultiMiMC7(numInputs, numRounds);
  hash.in[0] <== keyNum;
  hash.k <== 0; // hash key
  signal keyHashNum <== hash.out;

  // Convert key hash number to bits
  signal {binary} keyHash[curveNumBitSize] <== Num2Bits_strict()(keyHashNum);

  // Convert key hash bits to bytes
  keyHashBytes <== LEBits2BEBytes(curveNumBitSize, hashSizeBytes)(keyHash);

  log("key hash bytes:", keyHashBytes[0], keyHashBytes[1], keyHashBytes[2],
    keyHashBytes[3], keyHashBytes[4], keyHashBytes[5], keyHashBytes[6],
    keyHashBytes[7], keyHashBytes[8], keyHashBytes[9], keyHashBytes[10],
    keyHashBytes[11], keyHashBytes[12], keyHashBytes[13], keyHashBytes[14],
    keyHashBytes[15], keyHashBytes[16], keyHashBytes[17], keyHashBytes[18],
    keyHashBytes[19], keyHashBytes[20], keyHashBytes[21], keyHashBytes[22],
    keyHashBytes[23], keyHashBytes[24], keyHashBytes[25], keyHashBytes[26],
    keyHashBytes[27], keyHashBytes[28], keyHashBytes[29], keyHashBytes[30],
    keyHashBytes[31]);
}

component main = KeyHash();
