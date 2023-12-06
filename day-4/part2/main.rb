File.open(ARGV[0], "r") do |file|
    copies = []
    line_index = 0
    
    file.each_line do |line|
        if copies[line_index] == nil
            copies[line_index] = 0
        end
        copies[line_index] += 1
        numbers = line.split(':')[1]
        parts = numbers.split('|')
        winning_numbers = parts[0].strip.split(' ')
        hand_numbers = parts[1].strip.split(' ')
        
        winning_hand_numbers = hand_numbers.select { |number| winning_numbers.include?(number) }
        
        for i in 0...winning_hand_numbers.length do
            if copies[line_index + 1 + i] == nil
                copies[line_index + 1 + i] = 0
            end
            copies[line_index + 1 + i] += copies[line_index]
        end
        
        line_index += 1
    end
    
    puts copies.sum
end