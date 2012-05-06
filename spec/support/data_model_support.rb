def save_as_csv_file(file_path,values)
   File.open(file_path,'w') do |file|
     values.each do |row|
       file.puts "#{row[0]},#{row[1]},#{row[2]}"
     end
   end
end