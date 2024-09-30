# frozen_string_literal: true

require "test_helper"

class FileReaderTest < ActiveSupport::TestCase
  FIXTURE_FILE_PATH = "test/fixtures/text_file.txt"
  FIXTURE_FILE_TOTAL_LINES = 100

  test ".get properly returns requested line" do
    stub_const(FileReader, :FILE_PATH, FIXTURE_FILE_PATH) do
      stub_const(FileReader, :FILE_TOTAL_LINES, FIXTURE_FILE_TOTAL_LINES) do
        reader = FileReader.new

        assert_equal "line1", reader.get(line_number: "1")
        assert_equal "line2", reader.get(line_number: "2")
        assert_equal "line3", reader.get(line_number: "3")
        assert_equal "line4", reader.get(line_number: "4")
        assert_equal "line5", reader.get(line_number: "5")
      end
    end
  end

  test ".get returns nil if invalid line number is provided" do
    stub_const(FileReader, :FILE_PATH, FIXTURE_FILE_PATH) do
      stub_const(FileReader, :FILE_TOTAL_LINES, FIXTURE_FILE_TOTAL_LINES) do
        reader = FileReader.new

        assert_nil reader.get(line_number: "asdf")
        assert_nil reader.get(line_number: "asdf123123")
        assert_nil reader.get(line_number: "123123asdf")
        assert_nil reader.get(line_number: "123asdf123")
        assert_nil reader.get(line_number: nil)
      end
    end
  end

  test ".get raises LineOutOfRangeError if provided line is too large" do
    stub_const(FileReader, :FILE_PATH, FIXTURE_FILE_PATH) do
      stub_const(FileReader, :FILE_TOTAL_LINES, FIXTURE_FILE_TOTAL_LINES) do
        assert_raises FileReader::LineOutOfRangeError do
          reader = FileReader.new
          reader.get(line_number: 1_000_000)
        end
      end
    end
  end
end
