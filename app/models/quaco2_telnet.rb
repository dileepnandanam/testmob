class Quaco2Telnet
  require 'net/telnet'
  @@connection = nil
  @@result = nil

  def self.connect
    @@connection = Net::Telnet::new('Host' => AppConfig.where(name: 'host').first.value,
                          'Port' => AppConfig.where(name: 'port').first.value.to_i,
                          'Telnetmode' => false, "Timeout" => 100)
  end

  def self.disconnect
    @@connection.close
  end

  def self.connection
    @@connection
  end

  def self.closed?
    @@connection.try(:sock).try(:closed?)
  end

  def self.execute(user_id, line)
    output = []
    self.connection.cmd(line) do |data| 
      output << data
      break if data[-2..-1] == "\n\n" || data[-2..-1] == "1\n"
    end
    OutputSender.perform_later(user_id, line, output.join('').gsub("\n", "<br />"))
  end

  def self.execute_now(line)
    @@result = []
    self.connection.cmd(line) do |data| 
      @@result << data
      break if data[-2..-1] == "\n\n"
    end
    @@result.join('').gsub("\n","<br />")
  end
end
