module Actor
  class Start
    include Messaging::Send::Dependency

    attr_reader :actor
    attr_accessor :supervisor_address

    def initialize actor
      @actor = actor
    end

    def self.call actor_class, *arguments, &block
      actor = Build.(actor_class, *arguments, &block)

      instance = new actor
      instance.send = Messaging::Send.new
      instance.supervisor_address = Supervisor::Address::Get.()
      instance.()
    end

    def call
      send.(Messages::Start, address)

      thread = Thread.new do
        Thread.current.report_on_exception = false

        actor_started

        begin
          actor.run_loop
          actor_stopped
        rescue => error
          actor_crashed error
        end
      end

      return actor, thread
    end

    def actor_crashed error
      actor_crashed = Messages::ActorCrashed.new error, actor
      send.(actor_crashed, supervisor_address)
    end

    def actor_started
      actor_started = Messages::ActorStarted.new address, actor
      send.(actor_started, supervisor_address)
    end

    def actor_stopped
      actor_stopped = Messages::ActorStopped.new address, actor
      send.(actor_stopped, supervisor_address)
    end

    def address
      actor.address
    end
  end
end
