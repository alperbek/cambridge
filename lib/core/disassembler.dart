import 'utility.dart';

class Instruction {
  int length;
  String byteCode;
  String? disassembly;

  Instruction(this.length, this.byteCode, this.disassembly);
}

class Disassembler {
  static const z80Opcodes = {
    '00': 'NOP',
    '01': 'LD BC, **',
    '02': 'LD (BC), A',
    '03': 'INC BC',
    '04': 'INC B',
    '05': 'DEC B',
    '06': 'LD B, *',
    '07': 'RLCA',
    '08': "EX AF, AF'",
    '09': 'ADD HL, BC',
    '0a': 'LD A, (BC)',
    '0b': 'DEC BC',
    '0c': 'INC C',
    '0d': 'DEC C',
    '0e': 'LD C, *',
    '0f': 'RRCA',
    '10': 'DJNZ *',
    '11': 'LD DE, **',
    '12': 'LD (DE), A',
    '13': 'INC DE',
    '14': 'INC D',
    '15': 'DEC D',
    '16': 'LD D, *',
    '17': 'RLA',
    '18': 'JR *',
    '19': 'ADD HL, DE',
    '1a': 'LD A, (DE)',
    '1b': 'DEC DE',
    '1c': 'INC E',
    '1d': 'DEC E',
    '1e': 'LD E, *',
    '1f': 'RRA',
    '20': 'JR NZ, *',
    '21': 'LD HL, **',
    '22': 'LD (**), HL',
    '23': 'INC HL',
    '24': 'INC H',
    '25': 'DEC H',
    '26': 'LD H, *',
    '27': 'DAA',
    '28': 'JR Z, *',
    '29': 'ADD HL, HL',
    '2a': 'LD HL, (**)',
    '2b': 'DEC HL',
    '2c': 'INC L',
    '2d': 'DEC L',
    '2e': 'LD L, *',
    '2f': 'CPL',
    '30': 'JR NC, *',
    '31': 'LD SP, **',
    '32': 'LD (**), A',
    '33': 'INC SP',
    '34': 'INC (HL)',
    '35': 'DEC (HL)',
    '36': 'LD (HL), *',
    '37': 'SCF',
    '38': 'JR C, *',
    '39': 'ADD HL, SP',
    '3a': 'LD A, (**)',
    '3b': 'DEC SP',
    '3c': 'INC A',
    '3d': 'DEC A',
    '3e': 'LD A, *',
    '3f': 'CCF',
    '40': 'LD B, B',
    '41': 'LD B, C',
    '42': 'LD B, D',
    '43': 'LD B, E',
    '44': 'LD B, H',
    '45': 'LD B, L',
    '46': 'LD B, (HL)',
    '47': 'LD B, A',
    '48': 'LD C, B',
    '49': 'LD C, C',
    '4a': 'LD C, D',
    '4b': 'LD C, E',
    '4c': 'LD C, H',
    '4d': 'LD C, L',
    '4e': 'LD C, (HL)',
    '4f': 'LD C, A',
    '50': 'LD D, B',
    '51': 'LD D, C',
    '52': 'LD D, D',
    '53': 'LD D, E',
    '54': 'LD D, H',
    '55': 'LD D, L',
    '56': 'LD D, (HL)',
    '57': 'LD D, A',
    '58': 'LD E, B',
    '59': 'LD E, C',
    '5a': 'LD E, D',
    '5b': 'LD E, E',
    '5c': 'LD E, H',
    '5d': 'LD E, L',
    '5e': 'LD E, (HL)',
    '5f': 'LD E, A',
    '60': 'LD H, B',
    '61': 'LD H, C',
    '62': 'LD H, D',
    '63': 'LD H, E',
    '64': 'LD H, H',
    '65': 'LD H, L',
    '66': 'LD H, (HL)',
    '67': 'LD H, A',
    '68': 'LD L, B',
    '69': 'LD L, C',
    '6a': 'LD L, D',
    '6b': 'LD L, E',
    '6c': 'LD L, H',
    '6d': 'LD L, L',
    '6e': 'LD L, (HL)',
    '6f': 'LD L, A',
    '70': 'LD (HL), B',
    '71': 'LD (HL), C',
    '72': 'LD (HL), D',
    '73': 'LD (HL), E',
    '74': 'LD (HL), H',
    '75': 'LD (HL), L',
    '76': 'HALT',
    '77': 'LD (HL), A',
    '78': 'LD A, B',
    '79': 'LD A, C',
    '7a': 'LD A, D',
    '7b': 'LD A, E',
    '7c': 'LD A, H',
    '7d': 'LD A, L',
    '7e': 'LD A, (HL)',
    '7f': 'LD A, A',
    '80': 'ADD A, B',
    '81': 'ADD A, C',
    '82': 'ADD A, D',
    '83': 'ADD A, E',
    '84': 'ADD A, H',
    '85': 'ADD A, L',
    '86': 'ADD A, (HL)',
    '87': 'ADD A, A',
    '88': 'ADC A, B',
    '89': 'ADC A, C',
    '8a': 'ADC A, D',
    '8b': 'ADC A, E',
    '8c': 'ADC A, H',
    '8d': 'ADC A, L',
    '8e': 'ADC A, (HL)',
    '8f': 'ADC A, A',
    '90': 'SUB B',
    '91': 'SUB C',
    '92': 'SUB D',
    '93': 'SUB E',
    '94': 'SUB H',
    '95': 'SUB L',
    '96': 'SUB (HL)',
    '97': 'SUB A',
    '98': 'SBC B',
    '99': 'SBC C',
    '9a': 'SBC D',
    '9b': 'SBC E',
    '9c': 'SBC H',
    '9d': 'SBC L',
    '9e': 'SBC (HL)',
    '9f': 'SBC A, A',
    'a0': 'AND B',
    'a1': 'AND C',
    'a2': 'AND D',
    'a3': 'AND E',
    'a4': 'AND H',
    'a5': 'AND L',
    'a6': 'AND (HL)',
    'a7': 'AND A',
    'a8': 'XOR B',
    'a9': 'XOR C',
    'aa': 'XOR D',
    'ab': 'XOR E',
    'ac': 'XOR H',
    'ad': 'XOR L',
    'ae': 'XOR (HL)',
    'af': 'XOR A',
    'b0': 'OR B',
    'b1': 'OR C',
    'b2': 'OR D',
    'b3': 'OR E',
    'b4': 'OR H',
    'b5': 'OR L',
    'b6': 'OR (HL)',
    'b7': 'OR A',
    'b8': 'CP B',
    'b9': 'CP C',
    'ba': 'CP D',
    'bb': 'CP E',
    'bc': 'CP H',
    'bd': 'CP L',
    'be': 'CP (HL)',
    'bf': 'CP A',
    'c0': 'RET NZ',
    'c1': 'POP BC',
    'c2': 'JP NZ, **',
    'c3': 'JP **',
    'c4': 'CALL NZ, **',
    'c5': 'PUSH BC',
    'c6': 'ADD A, *',
    'c7': 'RST 0',
    'c8': 'RET Z',
    'c9': 'RET',
    'ca': 'JP Z, **',
    'cb00': 'RLC B',
    'cb01': 'RLC C',
    'cb02': 'RLC D',
    'cb03': 'RLC E',
    'cb04': 'RLC H',
    'cb05': 'RLC L',
    'cb06': 'RLC (HL)',
    'cb07': 'RLC A',
    'cb08': 'RRC B',
    'cb09': 'RRC C',
    'cb0a': 'RRC D',
    'cb0b': 'RRC E',
    'cb0c': 'RRC H',
    'cb0d': 'RRC L',
    'cb0e': 'RRC (HL)',
    'cb0f': 'RRC A',
    'cb10': 'RL B',
    'cb11': 'RL C',
    'cb12': 'RL D',
    'cb13': 'RL E',
    'cb14': 'RL H',
    'cb15': 'RL L',
    'cb16': 'RL (HL)',
    'cb17': 'RL A',
    'cb18': 'RR B',
    'cb19': 'RR C',
    'cb1a': 'RR D',
    'cb1b': 'RR E',
    'cb1c': 'RR H',
    'cb1d': 'RR L',
    'cb1e': 'RR (HL)',
    'cb1f': 'RR A',
    'cb20': 'SLA B',
    'cb21': 'SLA C',
    'cb22': 'SLA D',
    'cb23': 'SLA E',
    'cb24': 'SLA H',
    'cb25': 'SLA L',
    'cb26': 'SLA (HL)',
    'cb27': 'SLA A',
    'cb28': 'SRA B',
    'cb29': 'SRA C',
    'cb2a': 'SRA D',
    'cb2b': 'SRA E',
    'cb2c': 'SRA H',
    'cb2d': 'SRA L',
    'cb2e': 'SRA (HL)',
    'cb2f': 'SRA A',
    'cb30': 'SLL B',
    'cb31': 'SLL C',
    'cb32': 'SLL D',
    'cb33': 'SLL E',
    'cb34': 'SLL H',
    'cb35': 'SLL L',
    'cb36': 'SLL (HL)',
    'cb37': 'SLL A',
    'cb38': 'SRL B',
    'cb39': 'SRL C',
    'cb3a': 'SRL D',
    'cb3b': 'SRL E',
    'cb3c': 'SRL H',
    'cb3d': 'SRL L',
    'cb3e': 'SRL (HL)',
    'cb3f': 'SRL A',
    'cb40': 'BIT 0, B',
    'cb41': 'BIT 0, C',
    'cb42': 'BIT 0, D',
    'cb43': 'BIT 0, E',
    'cb44': 'BIT 0, H',
    'cb45': 'BIT 0, L',
    'cb46': 'BIT 0, (HL)',
    'cb47': 'BIT 0, A',
    'cb48': 'BIT 1, B',
    'cb49': 'BIT 1, C',
    'cb4a': 'BIT 1, D',
    'cb4b': 'BIT 1, E',
    'cb4c': 'BIT 1, H',
    'cb4d': 'BIT 1, L',
    'cb4e': 'BIT 1, (HL)',
    'cb4f': 'BIT 1, A',
    'cb50': 'BIT 2, B',
    'cb51': 'BIT 2, C',
    'cb52': 'BIT 2, D',
    'cb53': 'BIT 2, E',
    'cb54': 'BIT 2, H',
    'cb55': 'BIT 2, L',
    'cb56': 'BIT 2, (HL)',
    'cb57': 'BIT 2, A',
    'cb58': 'BIT 3, B',
    'cb59': 'BIT 3, C',
    'cb5a': 'BIT 3, D',
    'cb5b': 'BIT 3, E',
    'cb5c': 'BIT 3, H',
    'cb5d': 'BIT 3, L',
    'cb5e': 'BIT 3, (HL)',
    'cb5f': 'BIT 3, A',
    'cb60': 'BIT 4, B',
    'cb61': 'BIT 4, C',
    'cb62': 'BIT 4, D',
    'cb63': 'BIT 4, E',
    'cb64': 'BIT 4, H',
    'cb65': 'BIT 4, L',
    'cb66': 'BIT 4, (HL)',
    'cb67': 'BIT 4, A',
    'cb68': 'BIT 5, B',
    'cb69': 'BIT 5, C',
    'cb6a': 'BIT 5, D',
    'cb6b': 'BIT 5, E',
    'cb6c': 'BIT 5, H',
    'cb6d': 'BIT 5, L',
    'cb6e': 'BIT 5, (HL)',
    'cb6f': 'BIT 5, A',
    'cb70': 'BIT 6, B',
    'cb71': 'BIT 6, C',
    'cb72': 'BIT 6, D',
    'cb73': 'BIT 6, E',
    'cb74': 'BIT 6, H',
    'cb75': 'BIT 6, L',
    'cb76': 'BIT 6, (HL)',
    'cb77': 'BIT 6, A',
    'cb78': 'BIT 7, B',
    'cb79': 'BIT 7, C',
    'cb7a': 'BIT 7, D',
    'cb7b': 'BIT 7, E',
    'cb7c': 'BIT 7, H',
    'cb7d': 'BIT 7, L',
    'cb7e': 'BIT 7, (HL)',
    'cb7f': 'BIT 7, A',
    'cb80': 'RES 0, B',
    'cb81': 'RES 0, C',
    'cb82': 'RES 0, D',
    'cb83': 'RES 0, E',
    'cb84': 'RES 0, H',
    'cb85': 'RES 0, L',
    'cb86': 'RES 0, (HL)',
    'cb87': 'RES 0, A',
    'cb88': 'RES 1, B',
    'cb89': 'RES 1, C',
    'cb8a': 'RES 1, D',
    'cb8b': 'RES 1, E',
    'cb8c': 'RES 1, H',
    'cb8d': 'RES 1, L',
    'cb8e': 'RES 1, (HL)',
    'cb8f': 'RES 1, A',
    'cb90': 'RES 2, B',
    'cb91': 'RES 2, C',
    'cb92': 'RES 2, D',
    'cb93': 'RES 2, E',
    'cb94': 'RES 2, H',
    'cb95': 'RES 2, L',
    'cb96': 'RES 2, (HL)',
    'cb97': 'RES 2, A',
    'cb98': 'RES 3, B',
    'cb99': 'RES 3, C',
    'cb9a': 'RES 3, D',
    'cb9b': 'RES 3, E',
    'cb9c': 'RES 3, H',
    'cb9d': 'RES 3, L',
    'cb9e': 'RES 3, (HL)',
    'cb9f': 'RES 3, A',
    'cba0': 'RES 4, B',
    'cba1': 'RES 4, C',
    'cba2': 'RES 4, D',
    'cba3': 'RES 4, E',
    'cba4': 'RES 4, H',
    'cba5': 'RES 4, L',
    'cba6': 'RES 4, (HL)',
    'cba7': 'RES 4, A',
    'cba8': 'RES 5, B',
    'cba9': 'RES 5, C',
    'cbaa': 'RES 5, D',
    'cbab': 'RES 5, E',
    'cbac': 'RES 5, H',
    'cbad': 'RES 5, L',
    'cbae': 'RES 5, (HL)',
    'cbaf': 'RES 5, A',
    'cbb0': 'RES 6, B',
    'cbb1': 'RES 6, C',
    'cbb2': 'RES 6, D',
    'cbb3': 'RES 6, E',
    'cbb4': 'RES 6, H',
    'cbb5': 'RES 6, L',
    'cbb6': 'RES 6, (HL)',
    'cbb7': 'RES 6, A',
    'cbb8': 'RES 7, B',
    'cbb9': 'RES 7, C',
    'cbba': 'RES 7, D',
    'cbbb': 'RES 7, E',
    'cbbc': 'RES 7, H',
    'cbbd': 'RES 7, L',
    'cbbe': 'RES 7, (HL)',
    'cbbf': 'RES 7, A',
    'cbc0': 'SET 0, B',
    'cbc1': 'SET 0, C',
    'cbc2': 'SET 0, D',
    'cbc3': 'SET 0, E',
    'cbc4': 'SET 0, H',
    'cbc5': 'SET 0, L',
    'cbc6': 'SET 0, (HL)',
    'cbc7': 'SET 0, A',
    'cbc8': 'SET 1, B',
    'cbc9': 'SET 1, C',
    'cbca': 'SET 1, D',
    'cbcb': 'SET 1, E',
    'cbcc': 'SET 1, H',
    'cbcd': 'SET 1, L',
    'cbce': 'SET 1, (HL)',
    'cbcf': 'SET 1, A',
    'cbd0': 'SET 2, B',
    'cbd1': 'SET 2, C',
    'cbd2': 'SET 2, D',
    'cbd3': 'SET 2, E',
    'cbd4': 'SET 2, H',
    'cbd5': 'SET 2, L',
    'cbd6': 'SET 2, (HL)',
    'cbd7': 'SET 2, A',
    'cbd8': 'SET 3, B',
    'cbd9': 'SET 3, C',
    'cbda': 'SET 3, D',
    'cbdb': 'SET 3, E',
    'cbdc': 'SET 3, H',
    'cbdd': 'SET 3, L',
    'cbde': 'SET 3, (HL)',
    'cbdf': 'SET 3, A',
    'cbe0': 'SET 4, B',
    'cbe1': 'SET 4, C',
    'cbe2': 'SET 4, D',
    'cbe3': 'SET 4, E',
    'cbe4': 'SET 4, H',
    'cbe5': 'SET 4, L',
    'cbe6': 'SET 4, (HL)',
    'cbe7': 'SET 4, A',
    'cbe8': 'SET 5, B',
    'cbe9': 'SET 5, C',
    'cbea': 'SET 5, D',
    'cbeb': 'SET 5, E',
    'cbec': 'SET 5, H',
    'cbed': 'SET 5, L',
    'cbee': 'SET 5, (HL)',
    'cbef': 'SET 5, A',
    'cbf0': 'SET 6, B',
    'cbf1': 'SET 6, C',
    'cbf2': 'SET 6, D',
    'cbf3': 'SET 6, E',
    'cbf4': 'SET 6, H',
    'cbf5': 'SET 6, L',
    'cbf6': 'SET 6, (HL)',
    'cbf7': 'SET 6, A',
    'cbf8': 'SET 7, B',
    'cbf9': 'SET 7, C',
    'cbfa': 'SET 7, D',
    'cbfb': 'SET 7, E',
    'cbfc': 'SET 7, H',
    'cbfd': 'SET 7, L',
    'cbfe': 'SET 7, (HL)',
    'cbff': 'SET 7, A',
    'cc': 'CALL Z, **',
    'cd': 'CALL **',
    'ce': 'ADC A, *',
    'cf': 'RST 8h',
    'd0': 'RET NC',
    'd1': 'POP DE',
    'd2': 'JP NC, **',
    'd3': 'OUT (*), A',
    'd4': 'CALL NC, **',
    'd5': 'PUSH DE',
    'd6': 'SUB *',
    'd7': 'RST 10h',
    'd8': 'RET C',
    'd9': 'EXX',
    'da': 'JP C, **',
    'db': 'IN A, (*)',
    'dc': 'CALL C, **',
    'dd09': 'ADD IX, BC',
    'dd19': 'ADD IX, DE',
    'dd21': 'LD IX, **',
    'dd22': 'LD (**), IX',
    'dd23': 'INC IX',
    'dd24': 'INC IXH',
    'dd26': 'LD IXH, *',
    'dd29': 'ADD IX, IX',
    'dd2a': 'LD IX, (**)',
    'dd2b': 'DEC IX',
    'dd2c': 'INC IXL',
    'dd34': 'INC (IX+*)',
    'dd35': 'DEC (IX+*)',
    'dd36': 'LD (IX+*), *',
    'dd39': 'ADD IX, SP',
    'dd44': 'LD B, IXH',
    'dd45': 'LD B, IXL',
    'dd46': 'LD B, (IX+*)',
    'dd4c': 'LD C, IXH',
    'dd4d': 'LD C, IXL',
    'dd4e': 'LD C, (IX+*)',
    'dd54': 'LD D, IXH',
    'dd55': 'LD D, IXL',
    'dd56': 'LD D, (IX+*)',
    'dd5c': 'LD E, IXH',
    'dd5d': 'LD E, IXL',
    'dd5e': 'LD E, (IX+*)',
    'dd60': 'LD IXH, B',
    'dd61': 'LD IXH, C',
    'dd62': 'LD IXH, D',
    'dd63': 'LD IXH, E',
    'dd64': 'LD IXH, H',
    'dd65': 'LD IXH, L',
    'dd66': 'LD H, (IX+*)',
    'dd67': 'LD IXH, A',
    'dd68': 'LD IXL, B',
    'dd69': 'LD IXL, C',
    'dd6a': 'LD IXL, D',
    'dd6b': 'LD IXL, E',
    'dd6c': 'LD IXL, H',
    'dd6d': 'LD IXL, L',
    'dd6e': 'LD L, (IX+*)',
    'dd6f': 'LD IXL, A',
    'dd70': 'LD (IX+*), B',
    'dd71': 'LD (IX+*), C',
    'dd72': 'LD (IX+*), D',
    'dd73': 'LD (IX+*), E',
    'dd74': 'LD (IX+*), H',
    'dd75': 'LD (IX+*), L',
    'dd77': 'LD (IX+*), A',
    'dd7c': 'LD A, IXH',
    'dd7d': 'LD A, IXL',
    'dd7e': 'LD A, (IX+*)',
    'dd84': 'ADD A, IXH',
    'dd85': 'ADD A, IXL',
    'dd86': 'ADD A, (IX+*)',
    'dd8c': 'ADC A, IXH',
    'dd8d': 'ADC A, IXL',
    'dd8e': 'ADC A, (IX+*)',
    'dd94': 'SUB IXH',
    'dd95': 'SUB IXL',
    'dd96': 'SUB (IX+*)',
    'dd9c': 'SBC IXH',
    'dd9d': 'SBC IXL',
    'dd9e': 'SBC A, (IX+*)',
    'dda4': 'AND IXH',
    'dda5': 'AND IXL',
    'dda6': 'AND (IX+*)',
    'ddac': 'XOR IXH',
    'ddad': 'XOR IXL',
    'ddae': 'XOR (IX+*)',
    'ddb4': 'OR IXH',
    'ddb5': 'OR IXL',
    'ddb6': 'OR (IX+*)',
    'ddbc': 'CP IXH',
    'ddbd': 'CP IXL',
    'ddbe': 'CP (IX+*)',
    'ddcb00': 'RLC (IX+*), B',
    'ddcb01': 'RLC (IX+*), C',
    'ddcb02': 'RLC (IX+*), D',
    'ddcb03': 'RLC (IX+*), E',
    'ddcb04': 'RLC (IX+*), H',
    'ddcb05': 'RLC (IX+*), L',
    'ddcb06': 'RLC (IX+*)',
    'ddcb07': 'RLC (IX+*), A',
    'ddcb08': 'RRC (IX+*), B',
    'ddcb09': 'RRC (IX+*), C',
    'ddcb0a': 'RRC (IX+*), D',
    'ddcb0b': 'RRC (IX+*), E',
    'ddcb0c': 'RRC (IX+*), H',
    'ddcb0d': 'RRC (IX+*), L',
    'ddcb0e': 'RRC (IX+*)',
    'ddcb0f': 'RRC (IX+*), A',
    'ddcb10': 'RL (IX+*), B',
    'ddcb11': 'RL (IX+*), C',
    'ddcb12': 'RL (IX+*), D',
    'ddcb13': 'RL (IX+*), E',
    'ddcb14': 'RL (IX+*), H',
    'ddcb15': 'RL (IX+*), L',
    'ddcb16': 'RL (IX+*)',
    'ddcb17': 'RL (IX+*), A',
    'ddcb18': 'RR (IX+*), B',
    'ddcb19': 'RR (IX+*), C',
    'ddcb1a': 'RR (IX+*), D',
    'ddcb1b': 'RR (IX+*), E',
    'ddcb1c': 'RR (IX+*), H',
    'ddcb1d': 'RR (IX+*), L',
    'ddcb1e': 'RR (IX+*)',
    'ddcb1f': 'RR (IX+*), A',
    'ddcb20': 'SLA (IX+*), B',
    'ddcb21': 'SLA (IX+*), C',
    'ddcb22': 'SLA (IX+*), D',
    'ddcb23': 'SLA (IX+*), E',
    'ddcb24': 'SLA (IX+*), H',
    'ddcb25': 'SLA (IX+*), L',
    'ddcb26': 'SLA (IX+*)',
    'ddcb27': 'SLA (IX+*), A',
    'ddcb28': 'SRA (IX+*), B',
    'ddcb29': 'SRA (IX+*), C',
    'ddcb2a': 'SRA (IX+*), D',
    'ddcb2b': 'SRA (IX+*), E',
    'ddcb2c': 'SRA (IX+*), H',
    'ddcb2d': 'SRA (IX+*), L',
    'ddcb2e': 'SRA (IX+*)',
    'ddcb2f': 'SRA (IX+*), A',
    'ddcb30': 'SLL (IX+*), B',
    'ddcb31': 'SLL (IX+*), C',
    'ddcb32': 'SLL (IX+*), D',
    'ddcb33': 'SLL (IX+*), E',
    'ddcb34': 'SLL (IX+*), H',
    'ddcb35': 'SLL (IX+*), L',
    'ddcb36': 'SLL (IX+*)',
    'ddcb37': 'SLL (IX+*), A',
    'ddcb38': 'SRL (IX+*), B',
    'ddcb39': 'SRL (IX+*), C',
    'ddcb3a': 'SRL (IX+*), D',
    'ddcb3b': 'SRL (IX+*), E',
    'ddcb3c': 'SRL (IX+*), H',
    'ddcb3d': 'SRL (IX+*), L',
    'ddcb3e': 'SRL (IX+*)',
    'ddcb3f': 'SRL (IX+*), A',
    'ddcb40': 'BIT 0, (IX+*)',
    'ddcb41': 'BIT 0, (IX+*)',
    'ddcb42': 'BIT 0, (IX+*)',
    'ddcb43': 'BIT 0, (IX+*)',
    'ddcb44': 'BIT 0, (IX+*)',
    'ddcb45': 'BIT 0, (IX+*)',
    'ddcb46': 'BIT 0, (IX+*)',
    'ddcb47': 'BIT 0, (IX+*)',
    'ddcb48': 'BIT 1, (IX+*)',
    'ddcb49': 'BIT 1, (IX+*)',
    'ddcb4a': 'BIT 1, (IX+*)',
    'ddcb4b': 'BIT 1, (IX+*)',
    'ddcb4c': 'BIT 1, (IX+*)',
    'ddcb4d': 'BIT 1, (IX+*)',
    'ddcb4e': 'BIT 1, (IX+*)',
    'ddcb4f': 'BIT 1, (IX+*)',
    'ddcb50': 'BIT 2, (IX+*)',
    'ddcb51': 'BIT 2, (IX+*)',
    'ddcb52': 'BIT 2, (IX+*)',
    'ddcb53': 'BIT 2, (IX+*)',
    'ddcb54': 'BIT 2, (IX+*)',
    'ddcb55': 'BIT 2, (IX+*)',
    'ddcb56': 'BIT 2, (IX+*)',
    'ddcb57': 'BIT 2, (IX+*)',
    'ddcb58': 'BIT 3, (IX+*)',
    'ddcb59': 'BIT 3, (IX+*)',
    'ddcb5a': 'BIT 3, (IX+*)',
    'ddcb5b': 'BIT 3, (IX+*)',
    'ddcb5c': 'BIT 3, (IX+*)',
    'ddcb5d': 'BIT 3, (IX+*)',
    'ddcb5e': 'BIT 3, (IX+*)',
    'ddcb5f': 'BIT 3, (IX+*)',
    'ddcb60': 'BIT 4, (IX+*)',
    'ddcb61': 'BIT 4, (IX+*)',
    'ddcb62': 'BIT 4, (IX+*)',
    'ddcb63': 'BIT 4, (IX+*)',
    'ddcb64': 'BIT 4, (IX+*)',
    'ddcb65': 'BIT 4, (IX+*)',
    'ddcb66': 'BIT 4, (IX+*)',
    'ddcb67': 'BIT 4, (IX+*)',
    'ddcb68': 'BIT 5, (IX+*)',
    'ddcb69': 'BIT 5, (IX+*)',
    'ddcb6a': 'BIT 5, (IX+*)',
    'ddcb6b': 'BIT 5, (IX+*)',
    'ddcb6c': 'BIT 5, (IX+*)',
    'ddcb6d': 'BIT 5, (IX+*)',
    'ddcb6e': 'BIT 5, (IX+*)',
    'ddcb6f': 'BIT 5, (IX+*)',
    'ddcb70': 'BIT 6, (IX+*)',
    'ddcb71': 'BIT 6, (IX+*)',
    'ddcb72': 'BIT 6, (IX+*)',
    'ddcb73': 'BIT 6, (IX+*)',
    'ddcb74': 'BIT 6, (IX+*)',
    'ddcb75': 'BIT 6, (IX+*)',
    'ddcb76': 'BIT 6, (IX+*)',
    'ddcb77': 'BIT 6, (IX+*)',
    'ddcb78': 'BIT 7, (IX+*)',
    'ddcb79': 'BIT 7, (IX+*)',
    'ddcb7a': 'BIT 7, (IX+*)',
    'ddcb7b': 'BIT 7, (IX+*)',
    'ddcb7c': 'BIT 7, (IX+*)',
    'ddcb7d': 'BIT 7, (IX+*)',
    'ddcb7e': 'BIT 7, (IX+*)',
    'ddcb7f': 'BIT 7, (IX+*)',
    'ddcb80': 'RES 0, (IX+*)',
    'ddcb81': 'RES 0, (IX+*)',
    'ddcb82': 'RES 0, (IX+*)',
    'ddcb83': 'RES 0, (IX+*)',
    'ddcb84': 'RES 0, (IX+*)',
    'ddcb85': 'RES 0, (IX+*)',
    'ddcb86': 'RES 0, (IX+*)',
    'ddcb87': 'RES 0, (IX+*)',
    'ddcb88': 'RES 1, (IX+*)',
    'ddcb89': 'RES 1, (IX+*)',
    'ddcb8a': 'RES 1, (IX+*)',
    'ddcb8b': 'RES 1, (IX+*)',
    'ddcb8c': 'RES 1, (IX+*)',
    'ddcb8d': 'RES 1, (IX+*)',
    'ddcb8e': 'RES 1, (IX+*)',
    'ddcb8f': 'RES 1, (IX+*)',
    'ddcb90': 'RES 2, (IX+*)',
    'ddcb91': 'RES 2, (IX+*)',
    'ddcb92': 'RES 2, (IX+*)',
    'ddcb93': 'RES 2, (IX+*)',
    'ddcb94': 'RES 2, (IX+*)',
    'ddcb95': 'RES 2, (IX+*)',
    'ddcb96': 'RES 2, (IX+*)',
    'ddcb97': 'RES 2, (IX+*)',
    'ddcb98': 'RES 3, (IX+*)',
    'ddcb99': 'RES 3, (IX+*)',
    'ddcb9a': 'RES 3, (IX+*)',
    'ddcb9b': 'RES 3, (IX+*)',
    'ddcb9c': 'RES 3, (IX+*)',
    'ddcb9d': 'RES 3, (IX+*)',
    'ddcb9e': 'RES 3, (IX+*)',
    'ddcb9f': 'RES 3, (IX+*)',
    'ddcba0': 'RES 4, (IX+*)',
    'ddcba1': 'RES 4, (IX+*)',
    'ddcba2': 'RES 4, (IX+*)',
    'ddcba3': 'RES 4, (IX+*)',
    'ddcba4': 'RES 4, (IX+*)',
    'ddcba5': 'RES 4, (IX+*)',
    'ddcba6': 'RES 4, (IX+*)',
    'ddcba7': 'RES 4, (IX+*)',
    'ddcba8': 'RES 5, (IX+*)',
    'ddcba9': 'RES 5, (IX+*)',
    'ddcbaa': 'RES 5, (IX+*)',
    'ddcbab': 'RES 5, (IX+*)',
    'ddcbac': 'RES 5, (IX+*)',
    'ddcbad': 'RES 5, (IX+*)',
    'ddcbae': 'RES 5, (IX+*)',
    'ddcbaf': 'RES 5, (IX+*)',
    'ddcbb0': 'RES 6, (IX+*)',
    'ddcbb1': 'RES 6, (IX+*)',
    'ddcbb2': 'RES 6, (IX+*)',
    'ddcbb3': 'RES 6, (IX+*)',
    'ddcbb4': 'RES 6, (IX+*)',
    'ddcbb5': 'RES 6, (IX+*)',
    'ddcbb6': 'RES 6, (IX+*)',
    'ddcbb7': 'RES 6, (IX+*)',
    'ddcbb8': 'RES 7, (IX+*)',
    'ddcbb9': 'RES 7, (IX+*)',
    'ddcbba': 'RES 7, (IX+*)',
    'ddcbbb': 'RES 7, (IX+*)',
    'ddcbbc': 'RES 7, (IX+*)',
    'ddcbbd': 'RES 7, (IX+*)',
    'ddcbbe': 'RES 7, (IX+*)',
    'ddcbbf': 'RES 7, (IX+*)',
    'ddcbc0': 'SET 0, (IX+*)',
    'ddcbc1': 'SET 0, (IX+*)',
    'ddcbc2': 'SET 0, (IX+*)',
    'ddcbc3': 'SET 0, (IX+*)',
    'ddcbc4': 'SET 0, (IX+*)',
    'ddcbc5': 'SET 0, (IX+*)',
    'ddcbc6': 'SET 0, (IX+*)',
    'ddcbc7': 'SET 0, (IX+*)',
    'ddcbc8': 'SET 1, (IX+*)',
    'ddcbc9': 'SET 1, (IX+*)',
    'ddcbca': 'SET 1, (IX+*)',
    'ddcbcb': 'SET 1, (IX+*)',
    'ddcbcc': 'SET 1, (IX+*)',
    'ddcbcd': 'SET 1, (IX+*)',
    'ddcbce': 'SET 1, (IX+*)',
    'ddcbcf': 'SET 1, (IX+*)',
    'ddcbd0': 'SET 2, (IX+*)',
    'ddcbd1': 'SET 2, (IX+*)',
    'ddcbd2': 'SET 2, (IX+*)',
    'ddcbd3': 'SET 2, (IX+*)',
    'ddcbd4': 'SET 2, (IX+*)',
    'ddcbd5': 'SET 2, (IX+*)',
    'ddcbd6': 'SET 2, (IX+*)',
    'ddcbd7': 'SET 2, (IX+*)',
    'ddcbd8': 'SET 3, (IX+*)',
    'ddcbd9': 'SET 3, (IX+*)',
    'ddcbda': 'SET 3, (IX+*)',
    'ddcbdb': 'SET 3, (IX+*)',
    'ddcbdc': 'SET 3, (IX+*)',
    'ddcbdd': 'SET 3, (IX+*)',
    'ddcbde': 'SET 3, (IX+*)',
    'ddcbdf': 'SET 3, (IX+*)',
    'ddcbe0': 'SET 4, (IX+*)',
    'ddcbe1': 'SET 4, (IX+*)',
    'ddcbe2': 'SET 4, (IX+*)',
    'ddcbe3': 'SET 4, (IX+*)',
    'ddcbe4': 'SET 4, (IX+*)',
    'ddcbe5': 'SET 4, (IX+*)',
    'ddcbe6': 'SET 4, (IX+*)',
    'ddcbe7': 'SET 4, (IX+*)',
    'ddcbe8': 'SET 5, (IX+*)',
    'ddcbe9': 'SET 5, (IX+*)',
    'ddcbea': 'SET 5, (IX+*)',
    'ddcbeb': 'SET 5, (IX+*)',
    'ddcbec': 'SET 5, (IX+*)',
    'ddcbed': 'SET 5, (IX+*)',
    'ddcbee': 'SET 5, (IX+*)',
    'ddcbef': 'SET 5, (IX+*)',
    'ddcbf0': 'SET 6, (IX+*)',
    'ddcbf1': 'SET 6, (IX+*)',
    'ddcbf2': 'SET 6, (IX+*)',
    'ddcbf3': 'SET 6, (IX+*)',
    'ddcbf4': 'SET 6, (IX+*)',
    'ddcbf5': 'SET 6, (IX+*)',
    'ddcbf6': 'SET 6, (IX+*)',
    'ddcbf7': 'SET 6, (IX+*)',
    'ddcbf8': 'SET 7, (IX+*)',
    'ddcbf9': 'SET 7, (IX+*)',
    'ddcbfa': 'SET 7, (IX+*)',
    'ddcbfb': 'SET 7, (IX+*)',
    'ddcbfc': 'SET 7, (IX+*)',
    'ddcbfd': 'SET 7, (IX+*)',
    'ddcbfe': 'SET 7, (IX+*)',
    'ddcbff': 'SET 7, (IX+*)',
    'dde1': 'POP IX',
    'dde3': 'EX (SP), IX',
    'dde5': 'PUSH IX',
    'dde9': 'JP (IX)',
    'ddf9': 'LD SP, IX',
    'de': 'SBC A, *',
    'df': 'RST 18h',
    'e0': 'RET PO',
    'e1': 'POP HL',
    'e2': 'JP PO, **',
    'e3': 'EX (SP), HL',
    'e4': 'CALL PO, **',
    'e5': 'PUSH HL',
    'e6': 'AND *',
    'e7': 'RST 20h',
    'e8': 'RET PE',
    'e9': 'JP (HL)',
    'ea': 'JP PE, **',
    'eb': 'EX DE, HL',
    'ec': 'CALL PE, **',
    'ed40': 'IN B, (C)',
    'ed41': 'OUT (C), B',
    'ed42': 'SBC HL, BC',
    'ed43': 'LD (**), BC',
    'ed44': 'NEG',
    'ed45': 'RETN',
    'ed46': 'IM 0',
    'ed47': 'LD I, A',
    'ed48': 'IN C, (C)',
    'ed49': 'OUT (C), C',
    'ed4a': 'ADC HL, BC',
    'ed4b': 'LD BC, (**)',
    'ed4d': 'RETI',
    'ed4f': 'LD R, A',
    'ed50': 'IN D, (C)',
    'ed51': 'OUT (C), D',
    'ed52': 'SBC HL, DE',
    'ed53': 'LD (**), DE',
    'ed55': 'RETN',
    'ed56': 'IM 1',
    'ed57': 'LD A, I',
    'ed58': 'IN E, (C)',
    'ed59': 'OUT (C), E',
    'ed5a': 'ADC HL, DE',
    'ed5b': 'LD DE, (**)',
    'ed5d': 'RETN',
    'ed5e': 'IM 2',
    'ed5f': 'LD A, R',
    'ed60': 'IN H, (C)',
    'ed61': 'OUT (C), H',
    'ed62': 'SBC HL, HL',
    'ed65': 'RETN',
    'ed67': 'RRD',
    'ed68': 'IN L, (C)',
    'ed69': 'OUT (C), L',
    'ed6a': 'ADC HL, HL',
    'ed6d': 'RETI',
    'ed6f': 'RLD',
    'ed70': 'IN (C)',
    'ed71': 'OUT (C), 0',
    'ed72': 'SBC HL, SP',
    'ed73': 'LD (**), SP',
    'ed75': 'RETN',
    'ed78': 'IN A, (C)',
    'ed79': 'OUT (C), A',
    'ed7a': 'ADC HL, SP',
    'ed7b': 'LD SP, (**)',
    'ed7d': 'RETN',
    'eda0': 'LDI',
    'eda1': 'CPI',
    'eda2': 'INI',
    'eda3': 'OUTI',
    'eda8': 'LDD',
    'eda9': 'CPD',
    'edaa': 'IND',
    'edab': 'OUTD',
    'edb0': 'LDIR',
    'edb1': 'CPIR',
    'edb2': 'INIR',
    'edb3': 'OTIR',
    'edb8': 'LDDR',
    'edb9': 'CPDR',
    'edba': 'INDR',
    'edbb': 'OTDR',
    'ee': 'XOR *',
    'ef': 'RST 28h',
    'f0': 'RET P',
    'f1': 'POP AF',
    'f2': 'JP P, **',
    'f3': 'DI',
    'f4': 'CALL P, **',
    'f5': 'PUSH AF',
    'f6': 'OR *',
    'f7': 'RST 30h',
    'f8': 'RET M',
    'f9': 'LD SP, HL',
    'fa': 'JP M, **',
    'fb': 'EI',
    'fc': 'CALL M, **',
    'fd09': 'ADD IY, BC',
    'fd19': 'ADD IY, DE',
    'fd21': 'LD IY, **',
    'fd22': 'LD (**), IY',
    'fd23': 'INC IY',
    'fd24': 'INC IYH',
    'fd26': 'LD IYH, *',
    'fd29': 'ADD IY, IY',
    'fd2a': 'LD IY, (**)',
    'fd2b': 'DEC IY',
    'fd2c': 'INC IYL',
    'fd2e': 'LD IXL, *',
    'fd34': 'INC (IY+*)',
    'fd35': 'DEC (IY+*)',
    'fd36': 'LD (IY+*), *',
    'fd39': 'ADD IY, SP',
    'fd44': 'LD B, IYH',
    'fd45': 'LD B, IYL',
    'fd46': 'LD B, (IY+*)',
    'fd4c': 'LD C, IYH',
    'fd4d': 'LD C, IYL',
    'fd4e': 'LD C, (IY+*)',
    'fd54': 'LD D, IYH',
    'fd55': 'LD D, IYL',
    'fd56': 'LD D, (IY+*)',
    'fd5c': 'LD E, IYH',
    'fd5d': 'LD E, IYL',
    'fd5e': 'LD E, (IY+*)',
    'fd60': 'LD IYH, B',
    'fd61': 'LD IYH, C',
    'fd62': 'LD IYH, D',
    'fd63': 'LD IYH, E',
    'fd64': 'LD IYH, H',
    'fd65': 'LD IYH, L',
    'fd66': 'LD H, (IY+*)',
    'fd67': 'LD IYH, A',
    'fd68': 'LD IYL, B',
    'fd69': 'LD IYL, C',
    'fd6a': 'LD IYL, D',
    'fd6b': 'LD IYL, E',
    'fd6c': 'LD IYL, H',
    'fd6d': 'LD IYL, L',
    'fd6e': 'LD L, (IY+*)',
    'fd6f': 'LD IYL, A',
    'fd70': 'LD (IY+*), B',
    'fd71': 'LD (IY+*), C',
    'fd72': 'LD (IY+*), D',
    'fd73': 'LD (IY+*), E',
    'fd74': 'LD (IY+*), H',
    'fd75': 'LD (IY+*), L',
    'fd77': 'LD (IY+*), A',
    'fd7c': 'LD A, IYH',
    'fd7d': 'LD A, IYL',
    'fd7e': 'LD A, (IY+*)',
    'fd84': 'ADD A, IYH',
    'fd85': 'ADD A, IYL',
    'fd86': 'ADD A, (IY+*)',
    'fd8c': 'ADC A, IYH',
    'fd8d': 'ADC A, IYL',
    'fd8e': 'ADC A, (IY+*)',
    'fd94': 'SUB IYH',
    'fd95': 'SUB IYL',
    'fd96': 'SUB (IY+*)',
    'fd9c': 'SBC IYH',
    'fd9d': 'SBC IYL',
    'fd9e': 'SBC A, (IY+*)',
    'fda4': 'AND IYH',
    'fda5': 'AND IYL',
    'fda6': 'AND (IY+*)',
    'fdac': 'XOR IYH',
    'fdad': 'XOR IYL',
    'fdae': 'XOR (IY+*)',
    'fdb4': 'OR IYH',
    'fdb5': 'OR IYL',
    'fdb6': 'OR (IY+*)',
    'fdbc': 'CP IYH',
    'fdbd': 'CP IYL',
    'fdbe': 'CP (IY+*)',
    'fdcb00': 'RLC (IY+*), B',
    'fdcb01': 'RLC (IY+*), C',
    'fdcb02': 'RLC (IY+*), D',
    'fdcb03': 'RLC (IY+*), E',
    'fdcb04': 'RLC (IY+*), H',
    'fdcb05': 'RLC (IY+*), L',
    'fdcb06': 'RLC (IY+*)',
    'fdcb07': 'RLC (IY+*), A',
    'fdcb08': 'RRC (IY+*), B',
    'fdcb09': 'RRC (IY+*), C',
    'fdcb0a': 'RRC (IY+*), D',
    'fdcb0b': 'RRC (IY+*), E',
    'fdcb0c': 'RRC (IY+*), H',
    'fdcb0d': 'RRC (IY+*), L',
    'fdcb0e': 'RRC (IY+*)',
    'fdcb0f': 'RRC (IY+*), A',
    'fdcb10': 'RL (IY+*), B',
    'fdcb11': 'RL (IY+*), C',
    'fdcb12': 'RL (IY+*), D',
    'fdcb13': 'RL (IY+*), E',
    'fdcb14': 'RL (IY+*), H',
    'fdcb15': 'RL (IY+*), L',
    'fdcb16': 'RL (IY+*)',
    'fdcb17': 'RL (IY+*), A',
    'fdcb18': 'RR (IY+*), B',
    'fdcb19': 'RR (IY+*), C',
    'fdcb1a': 'RR (IY+*), D',
    'fdcb1b': 'RR (IY+*), E',
    'fdcb1c': 'RR (IY+*), H',
    'fdcb1d': 'RR (IY+*), L',
    'fdcb1e': 'RR (IY+*)',
    'fdcb1f': 'RR (IY+*), A',
    'fdcb20': 'SLA (IY+*), B',
    'fdcb21': 'SLA (IY+*), C',
    'fdcb22': 'SLA (IY+*), D',
    'fdcb23': 'SLA (IY+*), E',
    'fdcb24': 'SLA (IY+*), H',
    'fdcb25': 'SLA (IY+*), L',
    'fdcb26': 'SLA (IY+*)',
    'fdcb27': 'SLA (IY+*), A',
    'fdcb28': 'SRA (IY+*), B',
    'fdcb29': 'SRA (IY+*), C',
    'fdcb2a': 'SRA (IY+*), D',
    'fdcb2b': 'SRA (IY+*), E',
    'fdcb2c': 'SRA (IY+*), H',
    'fdcb2d': 'SRA (IY+*), L',
    'fdcb2e': 'SRA (IY+*)',
    'fdcb2f': 'SRA (IY+*), A',
    'fdcb30': 'SLL (IY+*), B',
    'fdcb31': 'SLL (IY+*), C',
    'fdcb32': 'SLL (IY+*), D',
    'fdcb33': 'SLL (IY+*), E',
    'fdcb34': 'SLL (IY+*), H',
    'fdcb35': 'SLL (IY+*), L',
    'fdcb36': 'SLL (IY+*)',
    'fdcb37': 'SLL (IY+*), A',
    'fdcb38': 'SRL (IY+*), B',
    'fdcb39': 'SRL (IY+*), C',
    'fdcb3a': 'SRL (IY+*), D',
    'fdcb3b': 'SRL (IY+*), E',
    'fdcb3c': 'SRL (IY+*), H',
    'fdcb3d': 'SRL (IY+*), L',
    'fdcb3e': 'SRL (IY+*)',
    'fdcb3f': 'SRL (IY+*), A',
    'fdcb40': 'BIT 0, (IY+*)',
    'fdcb41': 'BIT 0, (IY+*)',
    'fdcb42': 'BIT 0, (IY+*)',
    'fdcb43': 'BIT 0, (IY+*)',
    'fdcb44': 'BIT 0, (IY+*)',
    'fdcb45': 'BIT 0, (IY+*)',
    'fdcb46': 'BIT 0, (IY+*)',
    'fdcb47': 'BIT 0, (IY+*)',
    'fdcb48': 'BIT 1, (IY+*)',
    'fdcb49': 'BIT 1, (IY+*)',
    'fdcb4a': 'BIT 1, (IY+*)',
    'fdcb4b': 'BIT 1, (IY+*)',
    'fdcb4c': 'BIT 1, (IY+*)',
    'fdcb4d': 'BIT 1, (IY+*)',
    'fdcb4e': 'BIT 1, (IY+*)',
    'fdcb4f': 'BIT 1, (IY+*)',
    'fdcb50': 'BIT 2, (IY+*)',
    'fdcb51': 'BIT 2, (IY+*)',
    'fdcb52': 'BIT 2, (IY+*)',
    'fdcb53': 'BIT 2, (IY+*)',
    'fdcb54': 'BIT 2, (IY+*)',
    'fdcb55': 'BIT 2, (IY+*)',
    'fdcb56': 'BIT 2, (IY+*)',
    'fdcb57': 'BIT 2, (IY+*)',
    'fdcb58': 'BIT 3, (IY+*)',
    'fdcb59': 'BIT 3, (IY+*)',
    'fdcb5a': 'BIT 3, (IY+*)',
    'fdcb5b': 'BIT 3, (IY+*)',
    'fdcb5c': 'BIT 3, (IY+*)',
    'fdcb5d': 'BIT 3, (IY+*)',
    'fdcb5e': 'BIT 3, (IY+*)',
    'fdcb5f': 'BIT 3, (IY+*)',
    'fdcb60': 'BIT 4, (IY+*)',
    'fdcb61': 'BIT 4, (IY+*)',
    'fdcb62': 'BIT 4, (IY+*)',
    'fdcb63': 'BIT 4, (IY+*)',
    'fdcb64': 'BIT 4, (IY+*)',
    'fdcb65': 'BIT 4, (IY+*)',
    'fdcb66': 'BIT 4, (IY+*)',
    'fdcb67': 'BIT 4, (IY+*)',
    'fdcb68': 'BIT 5, (IY+*)',
    'fdcb69': 'BIT 5, (IY+*)',
    'fdcb6a': 'BIT 5, (IY+*)',
    'fdcb6b': 'BIT 5, (IY+*)',
    'fdcb6c': 'BIT 5, (IY+*)',
    'fdcb6d': 'BIT 5, (IY+*)',
    'fdcb6e': 'BIT 5, (IY+*)',
    'fdcb6f': 'BIT 5, (IY+*)',
    'fdcb70': 'BIT 6, (IY+*)',
    'fdcb71': 'BIT 6, (IY+*)',
    'fdcb72': 'BIT 6, (IY+*)',
    'fdcb73': 'BIT 6, (IY+*)',
    'fdcb74': 'BIT 6, (IY+*)',
    'fdcb75': 'BIT 6, (IY+*)',
    'fdcb76': 'BIT 6, (IY+*)',
    'fdcb77': 'BIT 6, (IY+*)',
    'fdcb78': 'BIT 7, (IY+*)',
    'fdcb79': 'BIT 7, (IY+*)',
    'fdcb7a': 'BIT 7, (IY+*)',
    'fdcb7b': 'BIT 7, (IY+*)',
    'fdcb7c': 'BIT 7, (IY+*)',
    'fdcb7d': 'BIT 7, (IY+*)',
    'fdcb7e': 'BIT 7, (IY+*)',
    'fdcb7f': 'BIT 7, (IY+*)',
    'fdcb80': 'RES 0, (IY+*)',
    'fdcb81': 'RES 0, (IY+*)',
    'fdcb82': 'RES 0, (IY+*)',
    'fdcb83': 'RES 0, (IY+*)',
    'fdcb84': 'RES 0, (IY+*)',
    'fdcb85': 'RES 0, (IY+*)',
    'fdcb86': 'RES 0, (IY+*)',
    'fdcb87': 'RES 0, (IY+*)',
    'fdcb88': 'RES 1, (IY+*)',
    'fdcb89': 'RES 1, (IY+*)',
    'fdcb8a': 'RES 1, (IY+*)',
    'fdcb8b': 'RES 1, (IY+*)',
    'fdcb8c': 'RES 1, (IY+*)',
    'fdcb8d': 'RES 1, (IY+*)',
    'fdcb8e': 'RES 1, (IY+*)',
    'fdcb8f': 'RES 1, (IY+*)',
    'fdcb90': 'RES 2, (IY+*)',
    'fdcb91': 'RES 2, (IY+*)',
    'fdcb92': 'RES 2, (IY+*)',
    'fdcb93': 'RES 2, (IY+*)',
    'fdcb94': 'RES 2, (IY+*)',
    'fdcb95': 'RES 2, (IY+*)',
    'fdcb96': 'RES 2, (IY+*)',
    'fdcb97': 'RES 2, (IY+*)',
    'fdcb98': 'RES 3, (IY+*)',
    'fdcb99': 'RES 3, (IY+*)',
    'fdcb9a': 'RES 3, (IY+*)',
    'fdcb9b': 'RES 3, (IY+*)',
    'fdcb9c': 'RES 3, (IY+*)',
    'fdcb9d': 'RES 3, (IY+*)',
    'fdcb9e': 'RES 3, (IY+*)',
    'fdcb9f': 'RES 3, (IY+*)',
    'fdcba0': 'RES 4, (IY+*)',
    'fdcba1': 'RES 4, (IY+*)',
    'fdcba2': 'RES 4, (IY+*)',
    'fdcba3': 'RES 4, (IY+*)',
    'fdcba4': 'RES 4, (IY+*)',
    'fdcba5': 'RES 4, (IY+*)',
    'fdcba6': 'RES 4, (IY+*)',
    'fdcba7': 'RES 4, (IY+*)',
    'fdcba8': 'RES 5, (IY+*)',
    'fdcba9': 'RES 5, (IY+*)',
    'fdcbaa': 'RES 5, (IY+*)',
    'fdcbab': 'RES 5, (IY+*)',
    'fdcbac': 'RES 5, (IY+*)',
    'fdcbad': 'RES 5, (IY+*)',
    'fdcbae': 'RES 5, (IY+*)',
    'fdcbaf': 'RES 5, (IY+*)',
    'fdcbb0': 'RES 6, (IY+*)',
    'fdcbb1': 'RES 6, (IY+*)',
    'fdcbb2': 'RES 6, (IY+*)',
    'fdcbb3': 'RES 6, (IY+*)',
    'fdcbb4': 'RES 6, (IY+*)',
    'fdcbb5': 'RES 6, (IY+*)',
    'fdcbb6': 'RES 6, (IY+*)',
    'fdcbb7': 'RES 6, (IY+*)',
    'fdcbb8': 'RES 7, (IY+*)',
    'fdcbb9': 'RES 7, (IY+*)',
    'fdcbba': 'RES 7, (IY+*)',
    'fdcbbb': 'RES 7, (IY+*)',
    'fdcbbc': 'RES 7, (IY+*)',
    'fdcbbd': 'RES 7, (IY+*)',
    'fdcbbe': 'RES 7, (IY+*)',
    'fdcbbf': 'RES 7, (IY+*)',
    'fdcbc0': 'SET 0, (IY+*)',
    'fdcbc1': 'SET 0, (IY+*)',
    'fdcbc2': 'SET 0, (IY+*)',
    'fdcbc3': 'SET 0, (IY+*)',
    'fdcbc4': 'SET 0, (IY+*)',
    'fdcbc5': 'SET 0, (IY+*)',
    'fdcbc6': 'SET 0, (IY+*)',
    'fdcbc7': 'SET 0, (IY+*)',
    'fdcbc8': 'SET 1, (IY+*)',
    'fdcbc9': 'SET 1, (IY+*)',
    'fdcbca': 'SET 1, (IY+*)',
    'fdcbcb': 'SET 1, (IY+*)',
    'fdcbcc': 'SET 1, (IY+*)',
    'fdcbcd': 'SET 1, (IY+*)',
    'fdcbce': 'SET 1, (IY+*)',
    'fdcbcf': 'SET 1, (IY+*)',
    'fdcbd0': 'SET 2, (IY+*)',
    'fdcbd1': 'SET 2, (IY+*)',
    'fdcbd2': 'SET 2, (IY+*)',
    'fdcbd3': 'SET 2, (IY+*)',
    'fdcbd4': 'SET 2, (IY+*)',
    'fdcbd5': 'SET 2, (IY+*)',
    'fdcbd6': 'SET 2, (IY+*)',
    'fdcbd7': 'SET 2, (IY+*)',
    'fdcbd8': 'SET 3, (IY+*)',
    'fdcbd9': 'SET 3, (IY+*)',
    'fdcbda': 'SET 3, (IY+*)',
    'fdcbdb': 'SET 3, (IY+*)',
    'fdcbdc': 'SET 3, (IY+*)',
    'fdcbdd': 'SET 3, (IY+*)',
    'fdcbde': 'SET 3, (IY+*)',
    'fdcbdf': 'SET 3, (IY+*)',
    'fdcbe0': 'SET 4, (IY+*)',
    'fdcbe1': 'SET 4, (IY+*)',
    'fdcbe2': 'SET 4, (IY+*)',
    'fdcbe3': 'SET 4, (IY+*)',
    'fdcbe4': 'SET 4, (IY+*)',
    'fdcbe5': 'SET 4, (IY+*)',
    'fdcbe6': 'SET 4, (IY+*)',
    'fdcbe7': 'SET 4, (IY+*)',
    'fdcbe8': 'SET 5, (IY+*)',
    'fdcbe9': 'SET 5, (IY+*)',
    'fdcbea': 'SET 5, (IY+*)',
    'fdcbeb': 'SET 5, (IY+*)',
    'fdcbec': 'SET 5, (IY+*)',
    'fdcbed': 'SET 5, (IY+*)',
    'fdcbee': 'SET 5, (IY+*)',
    'fdcbef': 'SET 5, (IY+*)',
    'fdcbf0': 'SET 6, (IY+*)',
    'fdcbf1': 'SET 6, (IY+*)',
    'fdcbf2': 'SET 6, (IY+*)',
    'fdcbf3': 'SET 6, (IY+*)',
    'fdcbf4': 'SET 6, (IY+*)',
    'fdcbf5': 'SET 6, (IY+*)',
    'fdcbf6': 'SET 6, (IY+*)',
    'fdcbf7': 'SET 6, (IY+*)',
    'fdcbf8': 'SET 7, (IY+*)',
    'fdcbf9': 'SET 7, (IY+*)',
    'fdcbfa': 'SET 7, (IY+*)',
    'fdcbfb': 'SET 7, (IY+*)',
    'fdcbfc': 'SET 7, (IY+*)',
    'fdcbfd': 'SET 7, (IY+*)',
    'fdcbfe': 'SET 7, (IY+*)',
    'fdcbff': 'SET 7, (IY+*)',
    'fde1': 'POP IY',
    'fde3': 'EX (SP), IY',
    'fde5': 'PUSH IY',
    'fde9': 'JP (IY)',
    'fdf9': 'LD SP, IY',
    'fe': 'CP *',
    'ff': 'RST 38h',
  };

  // This method swaps out displacement or address placeholders for the
  // actual operand.
  static String replaceOperand(String instruction, int byte, int highByte) {
    if (instruction.contains('**')) {
      final word = createWord(byte, highByte);
      return instruction.replaceFirst('**', '${toHex32(word).toUpperCase()}h');
    } else if (instruction.contains('*')) {
      return instruction.replaceFirst('*', '${toHex16(byte).toUpperCase()}h');
    } else {
      return instruction;
    }
  }

  // Z80 instructions are never more than four bytes, including displacements.
  // This method uses the decode table above to translate instructions into
  // strings for debugging purposes.
  static String decodeInstruction(int inst1, int inst2, int inst3, int inst4) {
    const unknownOpcode = '<UNKNOWN>';

    switch (inst1) {
      case 0xED: // extended instructions
        final opcode = toHex16(inst1) + toHex16(inst2);
        if (!z80Opcodes.containsKey(opcode)) {
          print('Opcode $opcode missing.');
          return unknownOpcode;
        } else {
          return replaceOperand(z80Opcodes[opcode]!, inst3, inst4);
        }
      case 0xCB: // bit instructions
        // none of these have displacement values, so don't bother to escape
        // with replaceOperand()
        final opcode = toHex16(inst1) + toHex16(inst2);

        return z80Opcodes[opcode] ?? unknownOpcode;

      case 0xDD:
      case 0xFD:
        // IX or IY instructions
        if (inst2 == 0xCB) // IX or IY bit instructions
        {
          // IX and IY bit instructions are formatted DDCB**XX,
          // where ** is the displacement and XX is the opcode that determines
          // which instruction type. We map these as DDCBXX, so we skip
          // inst3 when searching the map.
          final opcode = toHex16(inst1) + toHex16(inst2) + toHex16(inst4);
          if (!z80Opcodes.containsKey(opcode)) {
            print('Opcode $opcode missing.');
            return unknownOpcode;
          } else {
            return replaceOperand(z80Opcodes[opcode]!, inst3, 0);
          }
        }
        if (inst2 == 0x36) // LD (IX+*), *
        {
          final opcode = toHex16(inst1) + toHex16(inst2);

          if (!z80Opcodes.containsKey(opcode)) {
            print('Opcode $opcode missing.');
            return unknownOpcode;
          } else {
            // This is a unique opcode which takes two operands, so we call
            // replaceOperand twice, rather than special-casing code elsewhere.
            return replaceOperand(
                replaceOperand(z80Opcodes[opcode]!, inst3, 0), inst4, 0);
          }
        }

        // Just a regular DDxx or FDxx instruction
        final opcode = toHex16(inst1) + toHex16(inst2);

        if (!z80Opcodes.containsKey(opcode)) {
          print('Opcode $opcode missing.');
          return unknownOpcode;
        } else {
          return replaceOperand(z80Opcodes[opcode]!, inst3, inst4);
        }
      default:
        // Just a regular single byte opcode
        final opcode = toHex16(inst1);
        if (!z80Opcodes.containsKey(opcode)) {
          print('Opcode $opcode missing.');
          return unknownOpcode;
        } else {
          return replaceOperand(z80Opcodes[opcode]!, inst2, inst3);
        }
    }
  }

  // This helper method identifies the opcode length for a given instruction
  // that is one to four bytes long and begins with inst1.
  static int calculateInstructionLength(
      int inst1, int inst2, int inst3, int inst4) {
    switch (inst1) {
      case 0xED: // extended instructions
        if ([
          // word-length parameter, e.g. LD (**), BC
          0x43, 0x53, 0x63, 0x73, 0xB4,
          0x4B, 0x5B, 0x6B, 0x7B
        ].contains(inst2)) {
          return 4;
        }
        return 2;

      case 0xCB: // bit instructions
        // none of these have displacement values
        return 2;

      case 0xDD: // IX instructions
      case 0xFD: // IY instructions
        if (inst2 == 0xCB) {
          // IX or IY bit instructions, e.g. BIT 0, (IX+*)
          return 4;
        }

        if ([
          // word-length parameter, e.g. LD IX, **
          0x21, 0x22, 0x2A, 0x36,
        ].contains(inst2)) {
          return 4;
        }

        if ([
          // byte-length displacement, e.g. LD (IX+*), B
          0x70, 0x71, 0x72, 0x73, 0x34, 0x74, 0x35, 0x75, 0x26,
          0x46, 0x56, 0x66, 0x86, 0x96, 0xA6, 0xB6, 0x77, 0x2E, 0x4E,
          0x5E, 0x6E, 0x76, 0x8E, 0x9E, 0xAE, 0xBE
        ].contains(inst2)) {
          return 3;
        }

        return 2;

      default: // main instructions
        if ([
          // word-length parameter, e.g. LD BC, **
          0x01, 0x11, 0x21, 0x31, 0x22, 0x32, 0xC2, 0xD2, 0xE2, 0xF2,
          0xC3, 0xC4, 0xD4, 0xE4, 0xF4, 0x2A, 0x3A, 0xCA, 0xDA, 0xEA,
          0xFA, 0xCC, 0xDC, 0xEC, 0xFC, 0xCD
        ].contains(inst1)) {
          return 3;
        }

        if ([
          // byte-length displacement, e.g. DJNZ *
          0x10, 0x20, 0x30, 0xD3, 0x06, 0x16, 0x26, 0x36, 0xC6, 0xD6,
          0xE6, 0xF6, 0x18, 0x28, 0x38, 0xDB, 0x0E, 0x1E, 0x2E, 0x3E,
          0xCE, 0xDE, 0xEE, 0xFE
        ].contains(inst1)) {
          return 2;
        }

        // simple instruction, e.g. AND B
        return 1;
    }
  }

  static Instruction disassembleInstruction(List<int> instruction) {
    if (instruction.length < 4) {
      // We expect a four-byte instruction, but if not we buffer as necessary;
      // doesn't matter if there are more than four items in the list.
      instruction.addAll([0, 0, 0, 0]);
    }

    // This is the actual instruction length, based on opcode decoding
    final length = calculateInstructionLength(
        instruction[0], instruction[1], instruction[2], instruction[3]);
    final disassembly = decodeInstruction(
        instruction[0], instruction[1], instruction[2], instruction[3]);

    var byteCode = '';
    for (var i = 0; i < 4; i++) {
      if (i < length) {
        byteCode += '${toHex16(instruction[i])} ';
      } else {
        byteCode += '   ';
      }
    }

    return Instruction(length, byteCode, disassembly);
  }

  static String disassembleMultipleInstructions(
      List<int> instructions, int count, int pc) {
    final result = StringBuffer();
    var idx = 0;

    for (var i = 0; i < count; i++) {
      final instr = disassembleInstruction(instructions.sublist(idx));
      result.write(
          '[${toHex32(pc + idx)}]  ${instr.byteCode}  ${instr.disassembly}\n');
      idx += instr.length;
    }

    return result.toString();
  }
}
