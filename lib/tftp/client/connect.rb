module TFTP
  module Client

    # Setup TFTP server and port,
    # reads and writes files to TFTP server
    class Connect

      # TFTP server hostname or IP address
      attr_accessor :host

      # TFTP server port
      attr_accessor :port

      # Inititalize client. Sets TFTP host and port
      def initialize(host, port=69)
        self.host = IPSocket.getaddress(host)
        self.port = port
      end

      def get(file, dest=nil)
        File.open(dest || file, ?w) do |file_dest|
          read(file) do
            file_dest.write response.data
          end
        end
      end

      private
        def read(file)
          send request.read(file)
          begin
            receive
            acknowlege
            yield
          end while response.data.bytesize.eql? TFTP::Lib::Packet::SEGSIZE
        end

        def send(packet)
          sock.send packet, 0, host, port
        end

        def receive
          msg, addrinfo = sock.recvfrom(TFTP::Lib::Packet::SEGSIZE)
          self.response = msg
          self.port = addrinfo[1]
          request.block = response.block
        end

        def acknowlege
          send request.acknowlege
        end

        def sock
          family = IPAddr.new(host).ipv6? ? Socket::AF_INET6 : Socket::AF_INET
          @sock ||= UDPSocket.new family
        end

        def request
          @request ||= TFTP::Lib::Request.new
        end

        def response=(msg)
          @response = TFTP::Lib::Response.new(msg)
          # from RFC1350: An error is signalled by sending an error packet.
          # This packet is not **acknowledged**, and not retransmitted
          raise @response.errmsg if @response.opcode.eql? TFTP::Lib::Packet::ERROR
        end

        def response
          @response
        end

    end
  end
end
