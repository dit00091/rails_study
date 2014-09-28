module Concurrency
  def run_in_parallel(*procs)
    ActiveRecord::Base.connection.disconnect!

    pids = []
    procs.each_with_index do |proc, index|
      pids << Process.fork do
        ActiveRecord::Base.establish_connection
        Rails.logger.info("Concurrency [#{index}] START")
        begin
          proc.call
        rescue Exception => e
          Rails.logger.info("Concurrency [#{index}] Exception Raised: #{e.to_s}")
          exit 1
        end
        Rails.logger.info("Concurrency [#{index}] END")
      end
    end

    ActiveRecord::Base.establish_connection

    pids.each do |pid|
      Process.wait(pid)
      raise unless $?.exitstatus.zero?
    end
  end
end
