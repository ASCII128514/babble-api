a = [1,2,3,4,5,6,7,8,9,10]
a.each do |x|
    a.each do |y|
        break 
        p x
        a -= [9]
    end
    puts "break"
end