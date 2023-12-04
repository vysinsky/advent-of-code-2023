File.open(ARGV[0], "r") do |file|
    total = 0
    file.each_line do |line|
        numbers = line.split(':')[1]
        parts = numbers.split('|')
        winning_numbers = parts[0].strip.split(' ')
        hand_numbers = parts[1].strip.split(' ')
        
        winning_hand_numbers = hand_numbers.select { |number| winning_numbers.include?(number) }
        if winning_hand_numbers.length > 0
            card_value = 2 ** (winning_hand_numbers.length - 1)
            total += card_value
        end
    end
    puts total
end