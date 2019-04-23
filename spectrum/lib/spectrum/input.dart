// keyboard.dart -- keyboard input for ZX Spectrum

// See http://www.worldofspectrum.org/ZXBasicManual/zxmanchap23.html

// There are 65,536 ports, each of which can read or write an 8-bit value.
// The keyboard ports are listed below, along with a bitmap.

// Reading the port on the left side (e.g. 0xFEFE) will return an 8-bit value
// of which the least significant five bits represent a bitmap of the value,
// so for example: if the 'V' key is held down, the value nnn10000 can be read
// from port 0xFEFE.
final keyMap = <int, List<String>>{
  0xFEFE: ['*', 'Z', 'X', 'C', 'V'],
  0xFDFE: ['A', 'S', 'D', 'F', 'G'],
  0xFBFE: ['Q', 'W', 'E', 'R', 'T'],
  0xF7FE: ['1', '2', '3', '4', '5'],
  0xEFFE: ['0', '9', '8', '7', '6'],
  0xDFFE: ['P', 'O', 'I', 'U', 'Y'],
  0xBFFE: ['*', 'L', 'K', 'J', 'H'],
  0x7FFE: [' ', '*', 'M', 'N', 'B']
};
