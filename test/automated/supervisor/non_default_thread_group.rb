require_relative '../../test_init'

context "Supervisor is Constructed Within a Non-Default Thread Group" do
  supervisor = nil

  thread_group = ThreadGroup.new

  supervisor = Fixtures::ExecuteWithinThread.() do
    thread_group.add Thread.current
    Build.(Supervisor)
  end

  test "Thread group is set to that of thread in which supervisor is built" do
    assert supervisor.thread_group == thread_group
  end

  test "Supervisor address is registered with thread group" do
    supervisor_address = Supervisor::Address::Get.(thread_group)

    assert supervisor_address == supervisor.address
  end
end
