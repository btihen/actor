require_relative '../../test_init'

context "Actor Module, Handle Macro Pattern (Message is Matched by Symbol)" do
  cls = Controls::Actor.define do 
    attr_accessor :handler_actuated

    handle :some_message do
      self.handler_actuated = true
    end
  end

  context "Actor handles an instance whose class name matches symbol" do
    message = Controls::Message::SomeMessage.new

    actor = cls.new
    actor.handle message

    test "Handler is actuated" do
      assert actor.handler_actuated
    end
  end

  context "Actor handles an instance whose class name does not match symbol" do
    other_class = Class.new do
      def self.name
        "OtherMessage"
      end
    end

    message = other_class.new

    actor = cls.new
    actor.handle message

    test "Handler is not actuated" do
      refute actor.handler_actuated
    end
  end

  context "Actor handles symbol specified as pattern" do
    actor = cls.new
    actor.handle :some_message

    test "Handler is actuated" do
      assert actor.handler_actuated
    end
  end

  context "Actor handles symbol other than the symbol specified as pattern" do
    actor = cls.new
    actor.handle :other_message

    test "Handler not actuated" do
      refute actor.handler_actuated
    end
  end
end
