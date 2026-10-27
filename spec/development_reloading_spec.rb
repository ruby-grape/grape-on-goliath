require 'spec_helper'
require 'fileutils'
require 'net/http'
require 'rbconfig'
require 'socket'
require 'tmpdir'
require 'timeout'

describe 'Development reloading' do
  def wait_for_response(port, path, body)
    Timeout.timeout(30) do
      loop do
        begin
          response = Net::HTTP.start('127.0.0.1', port, open_timeout: 1, read_timeout: 1) { |http| http.get(path) }
          return response if response.code == '200' && response.body == body
        rescue Errno::ECONNREFUSED, Errno::ECONNRESET, EOFError, Net::ReadTimeout
          # A restart briefly closes the listening socket and existing connections.
        end
        sleep 0.1
      end
    end
  end

  it 'replaces mounted routes and responses after an API file changes' do
    Dir.mktmpdir('grape-on-goliath-reloading') do |directory|
      root = File.expand_path('..', __dir__)
      FileUtils.cp_r(%w[api app config app.rb .rerun].map { |path| File.join(root, path) }, directory)
      socket = TCPServer.new('127.0.0.1', 0)
      port = socket.addr[1]
      socket.close

      File.open(File.join(directory, 'server.log'), 'w+') do |log|
        pid = Process.spawn(
          RbConfig.ruby, '-e', '$stdout.sync = true; load Gem.bin_path("rerun", "rerun")', '--',
          '--background', '--no-notify', '--force-polling', '--',
          RbConfig.ruby, 'app.rb', '-sv', '-e', 'development', '-p', port.to_s,
          chdir: directory, pgroup: true, out: log, err: %i[child out]
        )
        begin
          expect(wait_for_response(port, '/api/ping', '{"ping":"pong"}').code).to eq('200')
          Timeout.timeout(30) do
            sleep 0.1 until File.read(log.path).include?('[rerun] Watching ')
          end

          path = File.join(directory, 'api/ping.rb')
          File.write(path, File.read(path).sub("get '/ping'", "get '/updated'").sub("'pong'", "'updated'"))

          expect(wait_for_response(port, '/api/updated', '{"ping":"updated"}').code).to eq('200')
          expect(Net::HTTP.get_response(URI("http://127.0.0.1:#{port}/api/ping")).code).to eq('404')
        rescue Timeout::Error
          log.rewind
          raise "Development server did not return the expected response:\n#{log.read}"
        ensure
          Process.kill('TERM', -pid)
          begin
            Timeout.timeout(10) { Process.wait(pid) }
          rescue Timeout::Error
            Process.kill('KILL', -pid)
            Process.wait(pid)
          end
        end
      end
    end
  end
end
