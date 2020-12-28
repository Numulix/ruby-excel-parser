require 'roo'
require './excelcol'

class ExcelParser
    include Enumerable

    def initialize(path)
        @table = Roo::Spreadsheet.open(path, {:expand_merged_ranges => true})
        @columns = Hash.new
        @table.row(1).each_with_index { |header, i| @columns[header.downcase.gsub(' ', '_')] = i+1 }
    end

    def method_missing(header)
        Col.new(@table.column(@columns[header.to_s]).drop(1), @table, @columns[header.to_s])
    end

    def [](key)
        return @table.column(@columns[key.to_s.downcase.gsub(' ','_')]).drop(1)
    end

    def row(num)
        return @table.row(num)
    end

    def each
        yield @table.parse
    end

    def to_s
        @table.parse
    end
end