require_relative '../../test_init'

context "Reading an address whose queue is not empty" do
  address = Messaging::Address.build
  reader = Messaging::Reader.build address

  address.queue.write 'some-message'

  test "Message is returned" do
    assert reader.() == 'some-message'
  end
end
