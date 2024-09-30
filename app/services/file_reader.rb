# frozen_string_literal: true

class FileReader
  # File path pointing to the file the application will read lines from
  FILE_PATH = Rails.root.join("file.txt").freeze
  # Call system command to extract the total number of lines of the given file
  FILE_TOTAL_LINES = %x(wc -l #{FILE_PATH}).split.first.to_i

  # Cache common requested lines to speed up reading
  @@cached_lines = {}

  # Error to be raised if the line requested doesn't exist - This helps with error management on the API side
  class LineOutOfRangeError < StandardError; end

  # Method used to read a specific line from the file
  # @param line_number [string] line number to be read
  #
  # @raise [LineOutOfRangeError] When the requested line doesn't exist on the file
  #
  # @return [String] content of the read line
  def get(line_number:)
    number = line_number.to_i
    # returns nil in case the requested line is zero or invalid
    return if number.zero?
    return unless line_number.to_s.scan(/\D/).empty?

    # validates and that te line exists in the file
    validate_line_exists!(line_number: number)

    # reads the line either from memory cache or the file itself
    @@cached_lines[number].presence || read_line_from_file(number:)
  end

  private

  # Validates that the given line exists on the file
  # @param line_number [integer] line number to be read
  #
  # @raise [LineOutOfRangeError] When the requested line doesn't exist on the file
  def validate_line_exists!(line_number:)
    raise LineOutOfRangeError if line_number > FILE_TOTAL_LINES
  end

  # Reads lines of a file until it reaches the requested line
  # @param line_number [string] line number to be read
  #
  # @return [String] content of the read line
  def read_line_from_file(number:)
    # Uses the system SED command to read the requested line
    text = %x(sed -n '#{number}{p;q}' #{FILE_PATH}).chomp
    @@cached_lines[number] = text

    text
  end
end
