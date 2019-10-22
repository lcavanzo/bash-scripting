!(/Nunca ha accedido/ || /^Nombre/ || /^root/) {
    cnt++
    print $0;
}
END {
    print "========================"
    print "Total Number of Users Processed: ", cnt
}
