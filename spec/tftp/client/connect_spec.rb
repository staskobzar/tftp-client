require 'spec_helper'

module TFTP
  module Client
    describe Connect do
      let(:host){"127.0.0.1"}
      let(:port){69}
      let(:file){"file.txt"}

      subject{Connect.new host, port}
      describe "#new" do
        it "initiates connection to TFTP server" do
          subject.should be_an_instance_of Connect
        end

        it "set server host" do
          subject.host.should eql host
        end

        it "set server port" do
          subject.port.should eql port
        end

        it "set default port to 69 if only one argument given" do
          Connect.new(host).port.should eql 69
        end

        it "converts hostname to IP address" do
          con = Connect.new "localhost", 69
          con.host.should == "127.0.0.1"
        end

      end

      describe "#get" do

        it "opens file for writing with the same name as get file" do
          File.should_receive(:open).with(file, 'w')
          subject.get file
        end

        it "opens file for writing with path/name as second argument if given" do
          file_dest = "/path/to/file.get.txt"
          File.should_receive(:open).with(file_dest, 'w')
          subject.get file, file_dest
        end

      end

      describe "read socket" do
        include FakeFS::SpecHelpers
        it "set conncestion for IPv6 nets" do
          sock = double(UDPSocket)
          sock.stub(:send)
          sock.should_receive(:recvfrom).with(512).and_return([[3,2,"B"*12].pack("n2Z*"), ["AF_INET",54521,"127.0.0.1","127.0.0.1"]])
          expect(UDPSocket).to receive(:new).with(Socket::AF_INET6).and_return(sock)
          con = Connect.new "::1", 69
          con.get(file) 
        end

        it "esteblish connection and read responses" do
          tid = 42863
          sock = double(UDPSocket)
          # initial read request send
          sock.should_receive(:send).with([1,file,"netascii"].pack("nZ*Z*"),0,host,port)
          # first data block recieve
          sock.should_receive(:recvfrom).with(512).and_return([[3,1,"A"*512].pack("n2Z*"), ["AF_INET",tid,"127.0.0.1","127.0.0.1"]])
          # acknowlagment send
          sock.should_receive(:send).with([4,1].pack("n2"),0,host,tid)
          # second data block receive
          sock.should_receive(:recvfrom).with(512).and_return([[3,2,"B"*12].pack("n2Z*"), ["AF_INET",tid,"127.0.0.1","127.0.0.1"]])
          # acknowlagment send
          sock.should_receive(:send).with([4,2].pack("n2"),0,host,tid)
          
          expect(UDPSocket).to receive(:new).and_return(sock)
          subject.get(file) 
        end
      end

    end
  end
end
