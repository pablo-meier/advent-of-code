use std::env;

enum RegisterLabel { A, B, C, D }

enum Instruction {
    CpyInt(i32, RegisterLabel),
    CpyRegister(RegisterLabel, RegisterLabel),
    Inc(RegisterLabel),
    Dec(RegisterLabel),
    JumpNotZeroRegister(RegisterLabel, i32),
    JumpNotZeroInt(i32, i32)
}

fn register_label_to_index(r : &RegisterLabel) -> usize {
    return match *r {
        RegisterLabel::A => 0,
        RegisterLabel::B => 1,
        RegisterLabel::C => 2,
        RegisterLabel::D => 3
    }
}

fn run_program(instructions : &Vec<Instruction>, is_part_two: bool) -> i32 {
    let mut pc = 0;
    let mut registers = vec!(0, 0, 0, 0);

    if is_part_two {
        registers[register_label_to_index(&RegisterLabel::C)] = 1;
    }

    loop {
        if pc as usize >= instructions.len() {
            break;
        }
        let mut should_increment = true;
        
        match instructions[pc as usize] {
            Instruction::CpyInt(val, ref label) => registers[register_label_to_index(label)] = val,
            Instruction::CpyRegister(ref from_label, ref to_label) =>
                registers[register_label_to_index(to_label)] = registers[register_label_to_index(from_label)],
            Instruction::Inc(ref label) => registers[register_label_to_index(label)] += 1,
            Instruction::Dec(ref label) => registers[register_label_to_index(label)] -= 1,
            Instruction::JumpNotZeroRegister(ref label, offset) => {
                if registers[register_label_to_index(label)] != 0 {
                    should_increment = false;
                    pc += offset;
                }
            },
            Instruction::JumpNotZeroInt(val, offset) => {
                if val != 0 {
                    should_increment = false;
                    pc += offset;
                }
            }
        }

        if should_increment {
            pc += 1;
        }
    }
    return registers[register_label_to_index(&RegisterLabel::A)];
}

fn main() {
    let instrs = vec![
        Instruction::CpyInt(1, RegisterLabel::A),
        Instruction::CpyInt(1, RegisterLabel::B),
        Instruction::CpyInt(26, RegisterLabel::D),
        Instruction::JumpNotZeroRegister(RegisterLabel::C, 2),
        Instruction::JumpNotZeroInt(1, 5),
        Instruction::CpyInt(7, RegisterLabel::C),
        Instruction::Inc(RegisterLabel::D),
        Instruction::Dec(RegisterLabel::C),
        Instruction::JumpNotZeroRegister(RegisterLabel::C, -2),
        Instruction::CpyRegister(RegisterLabel::A, RegisterLabel::C),
        Instruction::Inc(RegisterLabel::A),
        Instruction::Dec(RegisterLabel::B),
        Instruction::JumpNotZeroRegister(RegisterLabel::B, -2),
        Instruction::CpyRegister(RegisterLabel::C, RegisterLabel::B),
        Instruction::Dec(RegisterLabel::D),
        Instruction::JumpNotZeroRegister(RegisterLabel::D, -6),
        Instruction::CpyInt(14, RegisterLabel::C),
        Instruction::CpyInt(14, RegisterLabel::D),
        Instruction::Inc(RegisterLabel::A),
        Instruction::Dec(RegisterLabel::D),
        Instruction::JumpNotZeroRegister(RegisterLabel::D, -2),
        Instruction::Dec(RegisterLabel::C),
        Instruction::JumpNotZeroRegister(RegisterLabel::C, -5)
    ];

    let args : Vec<String> = env::args().collect();
    let mut is_part_two = false;

    if args.len() > 1 {
        let flag : &str = args[1].as_ref();
        if flag == "--part2" {
            is_part_two = true;
        }
    }

    let a_register_value = run_program(&instrs, is_part_two);
    println!("Final A register: {}", a_register_value);
}
