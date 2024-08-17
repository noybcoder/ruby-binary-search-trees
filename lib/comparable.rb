# frozen_string_literal: true

# Module: Comparable
# Provides a method for comparing two values, enabling the use of custom comparison logic.
module Comparable
  # Public: Compares two values using the spaceship operator (`<=>`).
  #
  # target - The value to be compared.
  # reference - The value to compare against.
  #
  # Returns -1 if target is less than reference, 0 if they are equal, and 1 if target is greater than reference.
  def compare(target, reference)
    target <=> reference
  end
end
