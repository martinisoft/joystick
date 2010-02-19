require 'socket'
require 'logger'

# Joystick - a Game Server query tool

# Login Sequence
# 
# Setup Class
# server = Joystick::Source.new("ip", port)
# Connect the socket
# server.connect
# Authenticate
# server.auth("password")
# Fire off a command
# server.rcon("command")

require 'joystick/version'

module Joystick
  class Source
    # execution command
    COMMAND_EXEC = 2
    # auth command
    COMMAND_AUTH = 3
    # auth response
    RESPONSE_AUTH = 2
    # normal response
    RESPONSE_NORM = 0
    # packet trailer
    NULLBYTE = "\x00"

    def initialize
      @host, @port, @socket = nil
      @request_id = 0
      # @log = Logger.new(STDOUT)
      # @log.level = Logger::DEBUG
      # @log.datetime_format = "%H:%M:%S"
      # @log.info("Loaded HLDS Class")
    end

    def connect(host, port)
      @host ||= host
      @port ||= port
      # @log.info("Connecting to #{@host}:#{@port}")
      begin
        @socket = TCPSocket.new(@host, @port)
      rescue Exception => e
        # @log.debug("Exception raised: " + e.message)
        # @log.error("Could not connect to host")
        return false
      end
      # @log.info("Connected")
    end

    def auth(password)
      request_id = rconwrite(COMMAND_AUTH, password)
      # @log.debug("Auth request id = #{request_id}")
      # @log.debug("Reading first trash packet")
      trash = rconread
      # @log.debug("Reading second packet")
      response = rconread
      # @log.debug("Second Packet Response: #{response.inspect}")
      return @authed = (response[:command] == RESPONSE_AUTH && response[:request_id] != -1)
    end

    def rconwrite(command, str1, str2="")
      if authed?
        @request_id += 1
        packet = str1 + NULLBYTE + str2 + NULLBYTE
        packet = [@request_id, command].pack("VV") + packet
        packet = [packet.length].pack("V") + packet
        # @log.debug("Sending packet: [#{packet.inspect}]")
        @socket.print packet
        return @request_id
      else
        raise "Not connected or authenticated"
      end
    end

    def rconread
      string1 = ""
      string2 = ""
      expected = true
      while(expected)
        # @log.debug("Reading size")
        # read 4 bytes from packet
        rawsize = @socket.recv(4)
        # get packet size
        psize = rawsize.unpack("V").shift
        # @log.debug("psize = #{psize.inspect}")
        # read the rest of the packet
        raw = @socket.recv(psize)
        # @log.debug("Received (size: #{psize}):\n#{raw.inspect}")
        # VVAA - request, command, string, string
        request_id, command, str1, str2 = raw.unpack("VVA*A*")
        string1 += str1.chomp
        string2 += str2.chomp
        # if the size was bigger than 4096, look for another packet
        expected = false unless (psize >= 4096)
        # @log.debug("Multiple packets: #{expected}")
      end
      return {:request_id => request_id, :command => command, :string1 => string1, :string2 => string2}
    end

    def rcon(command)
      return unless authed?
      # @log.info("Authenticated, executing command")
      if !rconwrite(COMMAND_EXEC, command)
        # @log.error("rconwrite unsuccessful")
        return false;
      end
      result = rconread
      if result[:command] != RESPONSE_NORM
      # @log.error("Command did not succeed")
      else
        return result[:string1]
      end
    end

    def disconnect
      @socket.close
      @socket = nil
    # @log.info("Disconnected")
    end

    def authed?
      @authed ||= false
    end
  end
end