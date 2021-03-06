require_relative '../../test_init'

context "Publisher, Build Method" do
  address1 = Controls::Address.example
  address2 = Controls::Address::Other.example

  publish = Messaging::Publish.build address1, address2

  test "Each specified address is registered with publisher" do
    assert publish.registered?(address1)
    assert publish.registered?(address2)
  end
end
