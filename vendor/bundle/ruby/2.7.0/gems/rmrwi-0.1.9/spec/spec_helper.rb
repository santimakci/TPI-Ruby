################## SEGMENT (rack-1.4.1) ##################

require 'rack/protection'
require 'rack/test'
require 'rack'
require 'forwardable'
require 'stringio'

if defined? Gem.loaded_specs and Gem.loaded_specs.include? 'rack'
  version = Gem.loaded_specs['rack'].version.to_s
else
  version = Rack.release + '.0'
end

if version == "1.3"
  Rack::Session::Abstract::ID.class_eval do
    private
    def prepare_session(env)
      session_was                  = env[ENV_SESSION_KEY]
      env[ENV_SESSION_KEY]         = SessionHash.new(self, env)
      env[ENV_SESSION_OPTIONS_KEY] = OptionsHash.new(self, env, @default_options)
      env[ENV_SESSION_KEY].merge! session_was if session_was
    end
  end
end

unless Rack::MockResponse.method_defined? :header
  Rack::MockResponse.send(:alias_method, :header, :headers)
end

module DummyApp
  def self.call(env)
    Thread.current[:last_env] = env
    body = (env['REQUEST_METHOD'] == 'HEAD' ? '' : 'ok')
    [200, {'Content-Type' => env['wants'] || 'text/plain'}, [body]]
  end
end

module TestHelpers
  extend Forwardable
  def_delegators :last_response, :body, :headers, :status, :errors
  def_delegators :current_session, :env_for
  attr_writer :app

  def app
    @app || mock_app(DummyApp)
  end

  def mock_app(app = nil, &block)
    app = block if app.nil? and block.arity == 1
    if app
      klass = described_class
      mock_app do
        use Rack::Head
        use(Rack::Config) { |e| e['rack.session'] ||= {}}
        use klass
        run app
      end
    else
      @app = Rack::Lint.new Rack::Builder.new(&block).to_app
    end
  end

  def with_headers(headers)
    proc { [200, {'Content-Type' => 'text/plain'}.merge(headers), ['ok']] }
  end

  def env
    Thread.current[:last_env]
  end
end

# see http://blog.101ideas.cz/posts/pending-examples-via-not-implemented-error-in-rspec.html
module NotImplementedAsPending
  def self.included(base)
    base.class_eval do
      alias_method :__finish__, :finish
      remove_method :finish
    end
  end

  def finish(reporter)
    if @exception.is_a?(NotImplementedError)
      from = @exception.backtrace[0]
      message = "#{@exception.message} (from #{from})"
      @pending_declared_in_example = message
      metadata[:pending] = true
      @exception = nil
    end

    __finish__(reporter)
  end

  RSpec::Core::Example.send :include, self
end

RSpec.configure do |config|
  config.expect_with :rspec, :stdlib
  config.include Rack::Test::Methods
  config.include TestHelpers
end

shared_examples_for 'any rack application' do
  it "should not interfere with normal get requests" do
    get('/').should be_ok
    body.should == 'ok'
  end

  it "should not interfere with normal head requests" do
    head('/').should be_ok
  end

  it 'should not leak changes to env' do
    klass    = described_class
    detector = Struct.new(:app)

    detector.send(:define_method, :call) do |env|
      was = env.dup
      res = app.call(env)
      was.each do |k,v|
        next if env[k] == v
        fail "env[#{k.inspect}] changed from #{v.inspect} to #{env[k].inspect}"
      end
      res
    end

    mock_app do
      use Rack::Head
      use(Rack::Config) { |e| e['rack.session'] ||= {}}
      use detector
      use klass
      run DummyApp
    end

    get('/..', :foo => '<bar>').should be_ok
  end

  it 'allows passing on values in env' do
    klass    = described_class
    detector = Struct.new(:app)
    changer  = Struct.new(:app)

    detector.send(:define_method, :call) do |env|
      res = app.call(env)
      env['foo.bar'].should == 42
      res
    end

    changer.send(:define_method, :call) do |env|
      env['foo.bar'] = 42
      app.call(env)
    end

    mock_app do
      use Rack::Head
      use(Rack::Config) { |e| e['rack.session'] ||= {}}
      use detector
      use klass
      use changer
      run DummyApp
    end

    get('/').should be_ok
  end
end

################## SEGMENT (rack-test-0.6.2) ##################

require "rubygems"
require "bundler/setup"

require "rack"
require "rspec"

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

require "rack/test"
require File.dirname(__FILE__) + "/fixtures/fake_app"

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods

  def app
    Rack::Lint.new(Rack::Test::FakeApp.new)
  end

  def check(*args)
  end

end

shared_examples_for "any #verb methods" do
  it "requests the URL using VERB" do
    send(verb, "/")

    check last_request.env["REQUEST_METHOD"].should == verb.upcase
    last_response.should be_ok
  end

  it "uses the provided env" do
    send(verb, "/", {}, { "HTTP_USER_AGENT" => "Rack::Test" })
    last_request.env["HTTP_USER_AGENT"].should == "Rack::Test"
  end

  it "yields the response to a given block" do
    yielded = false

    send(verb, "/") do |response|
      response.should be_ok
      yielded = true
    end

    yielded.should be_true
  end

  it "sets the HTTP_HOST header with port" do
    send(verb, "http://example.org:8080/uri")
    last_request.env["HTTP_HOST"].should == "example.org:8080"
  end

  it "sets the HTTP_HOST header without port" do
    send(verb, "/uri")
    last_request.env["HTTP_HOST"].should == "example.org"
  end

  context "for a XHR" do
    it "sends XMLHttpRequest for the X-Requested-With header" do
      send(verb, "/", {}, { :xhr => true })
      last_request.env["HTTP_X_REQUESTED_WITH"].should == "XMLHttpRequest"
      last_request.should be_xhr
    end
  end
end

################## ################## ##################
