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
    self.connection.cmd(line) do |data| 
      OutputSender.perform_later(user_id, line, data)
      break
    end
  end

  def self.execute_now(line)
    if self.connection.nil? || self.closed?
      return 'disconnected'
    end
    @@result = nil
    self.connection.cmd(line) do |data| 
      @@result = data
      break
    end
    @@result
  end
end
