OPERATORS = %i[+ * c]

sum = 0
max_permutation_size = 0

equations = File.readlines("day7/input.txt", chomp: true).map do |line|
  answer, operands = line.split(":")
  operands = operands.strip.split(" ").map(&:to_i)
  max_permutation_size = [max_permutation_size, operands.size - 1].max

  [answer.to_i, operands]
end
permutation_hash = {}

(1..max_permutation_size).each do |size|
  permutation_hash[size] = OPERATORS.repeated_permutation(size).to_a
end

equations.each do |answer, operands|
  permutation_hash[operands.size - 1].each do |permutation|
    equation = operands.zip(permutation).flatten.compact
    result = equation[0]

    (1..equation.size - 1).step(2) do |index|
      operator = equation[index]
      operand = equation[index + 1]

      if operator == :c
        result = (result.to_s + operand.to_s).to_i
      else
        result = result.send(operator, operand)
      end
    end

    break sum += result if result == answer
  end
end

puts sum
