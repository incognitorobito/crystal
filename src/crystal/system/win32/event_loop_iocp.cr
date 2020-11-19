require "c/iocp"
require "crystal/system/print_error"

module Crystal::EventLoop
  @@queue = Deque(Crystal::Event).new
  @@already_slept = Time::Span.new(nanoseconds: 0)

  # Runs the event loop.
  def self.run_once : Nil
    next_event = @@queue.min_by? { |e| e.wake_in }

    if next_event
      next_fiber = next_event.overlapped.resumable.unsafe_as(Fiber)
      next_event.wake_in -= @@already_slept

      if next_event.wake_in > Time::Span::ZERO
        sleepy_time = next_event.wake_in.total_milliseconds.to_i
        io_entry = Slice.new(1, LibC::OVERLAPPED_ENTRY.new)

        if LibC.GetQueuedCompletionStatusEx(Thread.current.iocp, io_entry, 1, out removed, sleepy_time, false)
          overlapped = io_entry.first.lpOverlapped
          if overlapped
            next_fiber = overlapped.value.resumable.unsafe_as(Fiber)
          end
        else
          raise RuntimeError.from_winerror("Error getting i/o completion status")
        end

      else
        next_fiber = Thread.current.main_fiber
      end

      @@already_slept += next_event.wake_in
      self.dequeue next_event
      Crystal::Scheduler.enqueue next_fiber
    else
      Crystal::System.print_error "Warning: No runnables in scheduler. Exiting program.\n"
      ::exit
    end
  end

  # Reinitializes the event loop after a fork.
  def self.after_fork : Nil
  end

  def self.enqueue(event : Crystal::Event)
    unless @@queue.includes?(event)
      @@queue << event
    end
  end

  def self.dequeue(event : Crystal::Event)
    @@queue.delete(event)
  end

  # Create a new resume event for a fiber.
  def self.create_resume_event(fiber : Fiber) : Crystal::Event
    Crystal::Event.new(fiber)
  end

  # Creates a write event for a file descriptor.
  def self.create_fd_write_event(io : IO::Evented, edge_triggered : Bool = false) : Crystal::Event
    # TODO Set event's wake_in to write timeout.
    Crystal::Event.new(Fiber.current)
  end

  # Creates a read event for a file descriptor.
  def self.create_fd_read_event(io : IO::Evented, edge_triggered : Bool = false) : Crystal::Event
    # TODO Set event's wake_in to read timeout.
    Crystal::Event.new(Fiber.current)
  end
end

struct Crystal::Event
  property overlapped : LibC::WSAOVERLAPPED
  property wake_in : Time::Span

  def initialize(fiber : Fiber)
    @overlapped = LibC::WSAOVERLAPPED.new
    @overlapped.resumable = fiber.unsafe_as(Pointer(Void))
    @wake_in = Time::Span::MAX
  end

  # Frees the event
  def free : Nil
    # TODO PostQueuedCompletionStatus?
    Crystal::EventLoop.dequeue(self)
  end

  def add(time_span : Time::Span) : Nil
    @wake_in = time_span
    Crystal::EventLoop.enqueue(self)
  end
  
  def to_unsafe
    @overlapped
  end

end
