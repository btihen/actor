require_relative '../test_init'

context "Thread is spawned when actor is started" do
  actor = Controls::Actor::Stops.new

  address = Address.build
  Messaging::Read.configure actor, address

  start = Start.new
  Messaging::Write.configure start

  thread = start.(actor, address)

  thread.join

  test "Run loop is executed by thread" do
    assert actor.stopped?
  end
end