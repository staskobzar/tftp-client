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
        self.host = host
        self.port = port
      end

      def get(file, dest=nil)
        File.open(dest || file, ?w) do |file_dest|
          read(file) do |response|
            file_dest.write response.data
          end
        end
      end

      private
        def read(file)
          sock = UDPSocket.new
          tftp = TFTP::Lib::Request.new
          sock.send tftp.read(file), 0, host, port
          msg, addrinfo = sock.recvfrom(TFTP::Lib::Packet::SEGSIZE)
          self.port = addrinfo[1]
          response = TFTP::Lib::Response.new(msg)
          raise response.errmsg if response.opcode.eql? TFTP::Lib::Packet::ERROR
          sock.send tftp.acknowlege, 0, host, port
          yield response
          while response.data.bytesize.eql? TFTP::Lib::Packet::SEGSIZE
            msg, addrinfo = sock.recvfrom(TFTP::Lib::Packet::SEGSIZE)
            response = TFTP::Lib::Response.new(msg)
            tftp.block = response.block
            sock.send tftp.acknowlege, 0, host, port
            raise response.errmsg if response.opcode.eql? TFTP::Lib::Packet::ERROR
            yield response
          end

        end

    end
  end
end
