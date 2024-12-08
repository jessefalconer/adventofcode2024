sum = 0

File.readlines("day7/input.txt", chomp: true).each do |line|
  answer, operand = line.split(":")
  answer = answer.to_i
  operands = operand.strip.split.map(&:to_i)
  result = [operands.shift]

  operands.each do |operand|
    permutation_results = []

    result.each do |viable_number|
      current_sum = viable_number + operand
      current_product = viable_number * operand

      permutation_results << current_sum unless current_sum > answer
      permutation_results << current_product unless current_product > answer
    end

    result = permutation_results
  end

  sum += answer if result.include?(answer)
end

puts sum
