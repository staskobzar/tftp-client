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
            file_dest.write convert(response.data)
          end
        end
        self.tid = nil # reset Transaction ID for future requests
      end

      # tftp request mode set delegator
      def mode=(mode)
        request.mode = mode
      end

      # tftp request mode return delegator
      def mode
        request.mode
      end

      private
        def read(file)
          send request.read(file)
          begin
            receive
            acknowlege
            yield
          end while response.data.bytesize.eql?(TFTP::Lib::Packet::SEGSIZE)
        end

        def send(packet)
          sock.send packet, 0, host, (tid || port)
        end

        def receive
          msg, addrinfo = sock.recvfrom(TFTP::Lib::Packet::SEGSIZE + 4) # DATA size + 4 bytes of opcode and block
          self.response = msg
          self.tid = addrinfo[1]
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

        def tid=(port)
          @tid = port
        end

        def tid
          @tid
        end

        # converting netascii
        # CR, NUL -> CR and CR, LF -> LF
        def convert(string)
          pp request.mode
          # RFC1350: any combination of upper
          # and lower case, such as "NETASCII", NetAscii", etc.
          return string unless request.mode.casecmp("netascii").eql?(0)
          string.gsub(/\r\n/,"\n")
        end
    end
  end
end
