input = '1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,1,19,10,23,2,13,23,27,1,5,27,31,2,6,31,35,1,6,35,39,2,39,9,43,1,5,43,47,1,13,47,51,1,10,51,55,2,55,10,59,2,10,59,63,1,9,63,67,2,67,13,71,1,71,6,75,2,6,75,79,1,5,79,83,2,83,9,87,1,6,87,91,2,91,6,95,1,95,6,99,2,99,13,103,1,6,103,107,1,2,107,111,1,111,9,0,99,2,14,0,0'

0.upto(100) do |v1|
  0.upto(100) do |v2|
    data = input.split(',').map(&:to_i)
    pc = 0

    data[1] = v1
    data[2] = v2

    loop do
      opcode = data[pc]
      addr1 = data[pc + 1]
      addr2 = data[pc + 2]
      addr3 = data[pc + 3]
      pc += 4
      case opcode
      when 1
        data[addr3] = data[addr1] + data[addr2]
      when 2
        data[addr3] = data[addr1] * data[addr2]
      else
        break
      end
    end

    puts v1 * 100 + v2 if data[0] == 19_690_720
  end
end
