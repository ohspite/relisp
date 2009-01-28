# Code Generated by ZenTest v. 3.11.1

require 'test/unit' unless defined? $ZENTEST and $ZENTEST

$:.unshift File.dirname(__FILE__) + "/../lib" 
require 'relisp'


module TestRelisp
  class TestProxy < Test::Unit::TestCase
    def setup
      @emacs = Relisp::ElispSlave.new
    end
  
    def test_class_from_elisp
      test_buffer_name = "*relisp-test-buffer*"
      buffer = @emacs.elisp_eval( "(create-file-buffer \"#{test_buffer_name}\") " )
      assert_kind_of Relisp::Buffer, buffer
      buffer_names = @emacs.elisp_eval( '(buffer-list)' ).map { |buffer| buffer.name } 
      assert buffer_names.include?(test_buffer_name)
    end

    # This is really tested in all of the other classes.
    def test_initialize
      new_buffer = Relisp::Buffer.new("new-buffer")
      assert_kind_of Relisp::Buffer, new_buffer
      assert_equal "new-buffer", new_buffer.name
    end

    def test_to_elisp
      test_buffer_name = "*relisp-test-buffer*"
      buffer = @emacs.elisp_eval( "(create-file-buffer \"#{test_buffer_name}\") " )
      assert_equal :buffer, @emacs.elisp_eval("(type-of #{buffer.to_elisp})")
    end
  end


  class TestBuffer < Test::Unit::TestCase
    def setup
      @emacs = Relisp::ElispSlave.new
    end
  
    def test_class_from_elisp
      test_buffer_name = "*relisp-test-buffer*"
      buffer = @emacs.elisp_eval( "(create-file-buffer \"#{test_buffer_name}\") " )
      assert_kind_of Relisp::Buffer, buffer
      buffer_names = @emacs.elisp_eval( '(buffer-list)' ).map { |buffer| buffer.name } 
      assert buffer_names.include?(test_buffer_name)
    end

    def test_initialize
      new_buffer = Relisp::Buffer.new("new-buffer")
      assert_kind_of Relisp::Buffer, new_buffer
      assert_equal "new-buffer", new_buffer.name
      found_buffer = @emacs.get_buffer(new_buffer.name)
      assert_kind_of Relisp::Buffer, found_buffer
    end

    def test_to_elisp
      test_buffer_name = "*relisp-test-buffer*"
      buffer = @emacs.elisp_eval( "(create-file-buffer \"#{test_buffer_name}\") " )
      assert_equal :buffer, @emacs.elisp_eval("(type-of #{buffer.to_elisp})")
    end

    def test_name
      test_buffer_name = "*relisp-test-buffer*"
      buffer = @emacs.elisp_eval( "(create-file-buffer \"#{test_buffer_name}\") " )
      assert_equal test_buffer_name, buffer.name
    end
  end

  class TestMarker < Test::Unit::TestCase
    def setup
      @emacs = Relisp::ElispSlave.new
    end

    def test_class_from_elisp
      assert_kind_of Relisp::Marker, @emacs.point_marker
      assert @emacs.elisp_eval( "(equal #{@emacs.point_marker.to_elisp} (point-marker))" )
      assert_kind_of Relisp::Marker, Relisp::Marker.new
    end

    def test_class_make
      assert_kind_of Relisp::Marker, Relisp::Marker.make
    end

    def test_to_elisp
      assert_equal :marker, @emacs.elisp_eval( "(type-of #{@emacs.point_marker.to_elisp})" )
    end
  end

  class TestWindow < Test::Unit::TestCase
    def setup
      @emacs = Relisp::ElispSlave.new
    end

    def test_class_from_elisp
      assert_kind_of Relisp::Window, @emacs.selected_window
    end
  end

  class TestFrame < Test::Unit::TestCase
    def setup
      @emacs = Relisp::ElispSlave.new
    end

    def test_class_from_elisp
      assert_kind_of Relisp::Frame, @emacs.selected_frame
    end
    
    def test_initialize
      new_frame = Relisp::Frame.new
      assert_kind_of Relisp::Frame, new_frame
      assert_equal :frame,  @emacs.elisp_eval( "(type-of #{new_frame.to_elisp})")
      new_frame = Relisp::Frame.new({:width => 30, :height => 20})
      assert_kind_of Relisp::Frame, new_frame
      assert_equal :frame,  @emacs.elisp_eval( "(type-of #{new_frame.to_elisp})")
    end
  end

  class TestWindowConfiguration < Test::Unit::TestCase
    def setup
      @emacs = Relisp::ElispSlave.new
    end

    def test_class_from_elisp
      assert_kind_of Relisp::WindowConfiguration, @emacs.current_window_configuration
    end
  end

  class TestFrameConfiguration < Test::Unit::TestCase
    def setup
      @emacs = Relisp::ElispSlave.new
    end

    def test_class_from_elisp
#       @emacs.debugging do
#       assert_kind_of Relisp::WindowConfiguration, @emacs.current_frame_configuration
#       end
    end
  end

end

