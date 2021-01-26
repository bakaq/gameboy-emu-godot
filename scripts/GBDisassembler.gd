extends Control

func _ready():
	# TODO: Load file to disassemble
	var data = load_file("ROMs/boot.gb")
	
	# TODO: Disassemble
	var code_txt = ""
	var i = 0
	while i < len(data):
		var ret = read_instruction(data, i)
		code_txt += ("%04X" % (i)) + ": " + ret[0] + "\n"
		i += ret[1]
		
	$Panel/MarginContainer/Code.text = code_txt 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_file(name):
	var file = File.new()
	file.open(name, File.READ)
	var data = file.get_buffer(file.get_len())
	file.close()
	return data

# Reads the next instruction and returns how much to advance
func read_instruction(data, i):
	var advance = 1
	var instr = ""
	
	match data[i]:
		0x04:
			instr = "INC B"
		0x05:
			instr = "DEC B"
		0x06:
			instr = "LD B, 0x%02X" % data[i+1]
			advance = 2
		0x0C:
			instr = "INC C"
		0x0D:
			instr = "DEC C"
		0x0E:
			instr = "LD C, 0x%02X" % data[i+1]
			advance = 2
		0x11:
			instr = "LD DE, 0x%02X%02X" % [data[i+2], data[i+1]]
			advance = 3
		0x13:
			instr = "INC DE"
		0x15:
			instr = "DEC D"
		0x16:
			instr = "LD D, 0x%02X" % data[i+1]
			advance = 2
		0x17:
			instr = "RLA"
		0x18:
			instr = "JR 0x%02X" % data[i+1]
			advance = 2
		0x1A:
			instr = "LD A, (DE)"
		0x1D:
			instr = "DEC E"
		0x1E:
			instr = "LD E, 0x%02X" % data[i+1]
			advance = 2
		0x20:
			instr = "JR NZ, 0x%02X" % data[i+1]
			advance = 2
		0x21:
			instr = "LD HL, 0x%02X%02X" % [data[i+2], data[i+1]]
			advance = 3
		0x22:
			instr = "LD (HL+), A"
		0x23:
			instr = "INC HL"
		0x24:
			instr = "INC H"
		0x2E:
			instr = "LD L, 0x%02X" % data[i+1]
			advance = 2
		0x28:
			instr = "JR Z, 0x%02X" % data[i+1]
			advance = 2
		0x31:
			instr = "LD SP, 0x%02X%02X" % [data[i+2], data[i+1]]
			advance = 3
		0x32:
			instr = "LD (HL-), A"
		0x3D:
			instr = "DEC A"
		0x3E:
			instr = "LD A, 0x%02X" % data[i+1]
			advance = 2
		0x4F:
			instr = "LD C, A"
		0x57:
			instr = "LD D, A"
		0x66:
			instr = "LD H, (HL)"
		0x67:
			instr = "LD H, A"
		0x77:
			instr = "LD (HL), A"
		0x78:
			instr = "LD A, B"
		0x7B:
			instr = "LD A, E"
		0x7C:
			instr = "LD A, H"
		0x7D:
			instr = "LD A, L"
		0x86:
			instr = "ADD (HL)"
		0x90:
			instr = "SUB B"
		0x9F:
			instr = "SBC A, A"
		0xAF:
			instr = "XOR A"
		0xBE:
			instr = "CP (HL)"
		0xC1:
			instr = "POP BC"
		0xC5:
			instr = "PUSH BC"
		0xC9:
			instr = "RET"
		0xCB:
			instr = cb_instr(data[i+1])
			advance = 2
		0xCD:
			instr = "CALL 0x%02X%02X" % [data[i+2], data[i+1]]
			advance = 3
		0xCE:
			instr = "ADC E, 0x%02X" % data[i+1]
			advance = 2
		0xE0:
			instr = "LD (0xFF00 + 0x%02X), A" % data[i+1]
			advance = 2
		0xE2:
			instr = "LD (0xFF00 + C), A"
		0xEA:
			instr = "LD (0x%02X%02X), A" % [data[i+2], data[i+1]]
			advance = 3
		0xF0:
			instr = "LS A, (0xFF00 + 0x%02X)" % data[i+1]
			advance = 2
		0xFE:
			instr = "CP 0x%02X" % data[i+1]
			advance = 2
		_:
			instr = "Unknown - 0x%02X" % data[i]
	
	return [instr, advance]

func cb_instr(op):
	match op:
		0x11:
			return "RL C"
		0x7C:
			return "BIT 7, H"
		_:
			return "Unknown - 0xCB%02X" % op
