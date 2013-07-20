require 'spec_helper'

module TFTP
  module Client
    describe Connect do
      let(:host){"127.0.0.1"}
      let(:port){69}
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
          pending "IPSocket.getaddress"
        end

        it "setup address family ( AF_INET || AF_INET6 )" do
          pending "IPAddr#ipv6?"
        end

      end

      describe "#get" do
        it "sends read request to TFTP server" do
          #expect{UDPSocket.stub(:new)}.to receive(:send).with(kind_of(String), kind_of(Integer)).once
          subject.get "file.txt"
        end
      end
    end
  end
end
