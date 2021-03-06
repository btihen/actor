require_relative '../../test_init'

context "Send Substitute" do
  address = Controls::Address.example

  context "Sent predicate" do
    context "No message has been sent" do
      substitute = Messaging::Send::Substitute.new

      test "Predicate returns false even if no constraints are specified" do
        refute substitute.sent?
      end
    end

    context "Message has been sent" do
      context "Message constraint" do
        substitute = Messaging::Send::Substitute.new
        substitute.(:some_message, address)

        test "Predicate returns true if specified message matches sent message" do
          assert substitute.sent?(:some_message)
        end

        test "Predicate returns fals if specified message does not match sent message" do
          refute substitute.sent?(:other_message)
        end
      end

      context "Address constraint" do
        substitute = Messaging::Send::Substitute.new
        substitute.(:some_message, address)

        test "Predicate returns true if specified address matches address of send operation" do
          assert substitute.sent?(address: address)
        end

        test "Predicate returns false if specified address does not match address of send operation" do
          other_address = Controls::Address.example

          refute substitute.sent?(address: other_address)
        end
      end

      context "Wait constraint" do
        [["Wait was not specified at callsite", nil], ["Wait was disabled at callsite", false]].each do |prose, wait|
          context "Wait was not specified at callsite" do
            substitute = Messaging::Send::Substitute.new
            substitute.(:some_message, address, wait: wait)

            test "Predicate returns true if specified wait value is false" do
              assert substitute.sent?(wait: false)
            end

            test "Predicate returns true if specified wait value is true" do
              refute substitute.sent?(wait: true)
            end
          end
        end

        context "Wait is enabled at callsite" do
          substitute = Messaging::Send::Substitute.new
          substitute.(:some_message, address, wait: true)

          test "Predicate returns true if specified wait value is true" do
            assert substitute.sent?(wait: true)
          end

          test "Predicate returns false if specified wait value is false" do
            refute substitute.sent?(wait: false)
          end
        end
      end
    end
  end

  context "Module that includes Message is sent" do
    message = Controls::Message::ModuleMessage
    substitute = Messaging::Send::Substitute.new

    substitute.(message, address)

    test "Predicate returns true if module is specified" do
      assert substitute.sent?(message)
    end

    test "Predicate returns true if message name is specified" do
      assert substitute.sent?(:module_message)
    end
  end
end
