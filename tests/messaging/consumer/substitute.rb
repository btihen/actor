require_relative '../../test_init'

context "Consumer substitute" do
  context "Consuming" do
    context "Message has not been added" do
      substitute = Messaging::Consumer::Substitute.new

      context "Wait is not requested (default)" do
        message = substitute.next

        test "Nothing is returned" do
          assert message.nil?
        end
      end

      context "Wait is requested" do
        test "Error is raised" do
          assert proc { substitute.next wait: true } do
            raises_error? Messaging::Consumer::Substitute::Wait
          end
        end
      end
    end

    context "Message has been added" do
      context "Wait is not specified (default)" do
        substitute = Messaging::Consumer::Substitute.new
        substitute.add_message 'some-message'

        message = substitute.next

        test "Message is returned" do
          assert message == 'some-message'
        end
      end

      context "Wait is specified" do
        substitute = Messaging::Consumer::Substitute.new
        substitute.add_message 'some-message'

        message = substitute.next wait: true

        test "Message is returned" do
          assert message == 'some-message'
        end
      end
    end
  end

  context "Stopped predicate" do
    substitute = Messaging::Consumer::Substitute.new

    context "Substitute has not been stopped" do
      test "False is returned" do
        refute substitute.stopped?
      end
    end

    context "Substitute has been stopped" do
      substitute.stop

      test "True is returned" do
        assert substitute.stopped?
      end
    end
  end
end
