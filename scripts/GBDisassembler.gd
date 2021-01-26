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
		0x20:
			instr = "JR NZ, 0x%02X" % data[i+1]
			advance = 2
		0x21:
			instr = "LD HL, 0x%02X%02X" % [data[i+2], data[i+1]]
			advance = 3
		0x31:
			instr = "LD SP, 0x%02X%02X" % [data[i+2], data[i+1]]
			advance = 3
		0x32:
			instr = "LD (HL-), A"
		0x66:
			instr = "LD H, (HL)"
		0x9F:
			instr = "SBC A, A"
		0xAF:
			instr = "XOR A"
		0xCB:
			instr = cb_instr(data[i+1])
			advance = 2
		0xCE:
			instr = "ADC E, 0x%02X" % data[i+1]
			advance = 2
		_:
			instr = "Unknown - 0x%02X" % data[i]
	
	return [instr, advance]

func cb_instr(op):
	match op:
		0x7C:
			return "BIT 7, H"
		_:
			return "Unknown - 0xCB%02X" % op
