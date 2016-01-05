# include thrift-generated code
$:.push('./gen-rb')

require 'thrift'
require 'calculator'

begin
	print "Enter Operation: "
	op = gets.chomp
	print "Enter A: "
	a = gets.chomp
	print "Enter B: "
	b = gets.chomp

	port = ARGV[0] || 9090

	transport = Thrift::BufferedTransport.new(Thrift::Socket.new('localhost'))
	protocol = Thrift::BinaryProtocol.new(transport)
	client = Calculator::Client.new(protocol)

	transport.open()

	ar = ArithmeticOperation.new()
	ar.op = op.to_i
	ar.lh_term = a.to_f
	ar.rh_term = b.to_f
	
	# Run a remote calculation
	result = client.calc(ar)  #it accessing the ruby server program method calc via thrift service
	puts result.inspect
	
	#Run a Async call
	client.run_task()
	
	transport.close()
rescue
	puts $!
end
