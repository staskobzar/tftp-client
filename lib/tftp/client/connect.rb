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
        @sock = UDPSocket.new
      end

      def get(file, dest=nil)
        #TFTP::Lib::Request
        #sock.send(host, port)
      end
    end
  end
end
