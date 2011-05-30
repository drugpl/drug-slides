require 'yaml'

cypher = ["UB", "YL", "FC", "TV", "FC", "CU", "FK", "FS", "TV", "EB", "ZO", "TQ", "FC", "AQ", "YU", "ZO", "CF", "BM", "TP", "PV", "ZH", "KW", "FC", "HN", "VX", "MB", "DC", "LB", "FK", "IK", "BM", "OE", "UG", "OE", "VT", "RN", "NV", "PQ", "QB", "CD", "CU", "YD", "AZ", "WE", "KW", "FC", "HN", "BR", "BY", "HP", "PU", "AI", "FC", "CU", "HQ", "YW", "FE", "BD", "RS", "DB", "LD", "VZ", "DQ", "CZ", "KG", "SK", "DR", "CE", "CP", "YK", "WM", "HA", "LB", "HM", "ES", "PV", "CD", "OP", "YC", "FC", "CU", "QL", "GX", "MB", "UC", "AH", "BD", "MT", "PV", "DB", "MY", "NH", "BE", "NP", "VC", "PG", "FM", "ZT", "ID", "HP", "OZ", "UQ", "CS", "BE", "DT", "CN", "BM", "FU", "EO", "PV", "ZO", "FC", "FP", "MC", "BE", "WU", "TP", "RP", "QP", "DA", "CV", "TE", "BP", "CQ", "BY", "YK", "DA", "MZ", "HN", "YC", "EC", "PG", "CV", "UB", "YL", "CT", "BM", "IP", "UQ", "EV", "FC", "YH", "ZR", "VC", "FZ", "YP", "DR", "YN", "BM", "FU", "EO", "FW", "VN", "TP", "CD", "DB", "RP", "TX", "FC", "IP", "CS", "UB", "YL", "ZG", "RW", "HD", "RQ", "EV", "PV", "DV", "DH", "DZ", "NW", "CD", "FC", "AP", "VQ", "YH", "CV", "KY", "MV", "FC", "YW", "MV", "VZ", "IP", "ZL", "EZ", "KW", "KY", "MV", "IP", "DH", "WU", "TP", "CI", "IH", "UB", "NY", "CU", "XG", "PV", "PG", "FK", "YW", "PV", "TV", "CH", "CD", "CI", "IV", "OZ", "PY", "FC", "FX", "CU", "AI", "PF", "EV", "VZ", "AI", "TX", "HC", "VZ", "MB", "CA", "VE", "BD", "AI", "HQ", "MG", "FE", "ZM", "IC", "GP", "CI", "IV", "CW", "DR", "PG", "PO", "CI", "IO", "VA", "UE", "ZF", "KW"]

def start_end_statistic(file)
	
	result = {}

	file = File.new(file, "r")
	file.each_line do |line|
		if((line.size >= 4) and (line[0...2] == line[-3...-1].reverse))
			result[line[0...2]] ||= 1
			result[line[0...2]] += 1
		end
	end

	file_yaml =	File.open("stat", "w")
	file_yaml.puts result.sort_by{ |k,v| v }.to_yaml
	file_yaml.close

  result
end

def statistic(file)

	result = []
#	result.default = 0
	
	file = File.new(file, "r")
	file.each_line do |line|
		line.chomp!
#		(line.size - 1).times do |time|
#			result[line[time].chr] += 1
		result << line
	#	end
	end
#	file_yaml =	File.open("stat_full", "w")
#	file_yaml.puts result.to_yaml
#	file_yaml.close

	result
end

def order(stat)
  stat.sort_by{ |k,v| -v }.map{ |s| s[0] }
end

def create_swap_table(dic_stat, cypher_stat)
  dic_stat = order(dic_stat)
  cypher_stat = order(cypher_stat).shuffle

  swap = {}
  swap.default = "[?]"

  cypher_stat.each_with_index do |item, index|
    swap[dic_stat[index]] = item
  end

  swap
end

def swap(cypher, swap_table)
  result = []
  cypher.split(//).each do |letter|
    result << swap_table[letter]
  end

  result.join
end
