# Code Generated by ZenTest v. 3.11.1

require 'test/unit' unless defined? $ZENTEST and $ZENTEST

$:.unshift File.dirname(__FILE__) + "/../lib" 
require 'relisp'
require 'tempfile'

class Tempfile
  def self.new_path(name = 'tempfile')
    file = Tempfile.new(name)
    file.close
    return file.path
  end
end

EMACS = Relisp::ElispSlave.new unless defined? EMACS

module TestRelisp
  class TestProxy < Test::Unit::TestCase
    def setup
      @emacs = EMACS
    end
  
    def test_class_from_elisp
      test_buffer_name = "*relisp-test-buffer*"
      buffer = @emacs.elisp_eval( "(create-file-buffer \"#{test_buffer_name}\") " )
      assert_kind_of Relisp::Buffer, buffer
      buffer_names = @emacs.elisp_eval( '(buffer-list)' ).to_list.map { |buffer| buffer.name } 
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
      @buffer = Relisp::Buffer.new "*relisp-setup-test-buffer*"
    end

    def test_class_from_elisp
      test_buffer_name = "*relisp-test-buffer*"
      buffer = @emacs.elisp_eval( "(create-file-buffer \"#{test_buffer_name}\") " )
      assert_kind_of Relisp::Buffer, buffer
      buffer_names = @emacs.elisp_eval( '(buffer-list)' ).to_list.map { |buffer| buffer.name } 
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

    def test_set
      b1_name = "*relisp-test-buffer1*"
      b2_name = "*relisp-test-buffer2*"
      b1 = Relisp::Buffer.new b1_name
      b2 = Relisp::Buffer.new b2_name
      
      b1.set
      assert_equal b1_name, @emacs.buffer_name
      b2.set
      assert_equal b2_name, @emacs.buffer_name
    end

    def test_name
      test_buffer_name = "*relisp-test-buffer*"
      buffer = @emacs.elisp_eval( "(create-file-buffer \"#{test_buffer_name}\") " )
      assert_equal test_buffer_name, buffer.name
    end

    def test_rename
      b = Relisp::Buffer.new "*relisp-test-buffer*"
      assert_equal b.name, "*relisp-test-buffer*"
      b.insert "this text should stay here"
      text = b.to_s
      b.rename "*same-relisp-buffer*"
      assert_equal b.name, "*same-relisp-buffer*"
      assert_equal text, b.to_s
    end

    def test_filename
      file = Tempfile.new_path
      assert_nil @buffer.filename
      @buffer.filename = file
      assert_equal file, @buffer.filename
    end

    def test_filename_equals
      # test_filename
    end

    def test_modified_eh
      file = Tempfile.new_path
      assert ! @buffer.modified?
      @buffer.insert "some text"
      assert @buffer.modified?
      @buffer.filename = file
      @buffer.save
      assert ! @buffer.modified?
    end

    def test_set_modified
      file = Tempfile.new_path
      assert ! @buffer.modified?
      @buffer.set_modified
      assert @buffer.modified?
      @buffer.filename = file
      @buffer.save
      assert ! @buffer.modified?
      @buffer.insert "some text"
      @buffer.set_modified(false)
      assert ! @buffer.modified?
    end

    def test_modified_equals
      file = Tempfile.new_path
      assert ! @buffer.modified?
      @buffer.modified = true
      assert @buffer.modified?
      @buffer.filename = file
      @buffer.save
      assert ! @buffer.modified?
      @buffer.insert "some text"
      @buffer.modified = false
      assert ! @buffer.modified?
    end

    def test_buffer_modified_tick
      @buffer.insert "arokfv "
      assert_equal 2, @buffer.modified_tick
    end

    def test_chars_modified_tick
      @buffer.insert "arokfv "
      assert_equal 2, @buffer.chars_modified_tick
    end

    def test_read_only_eh
      assert ! @buffer.read_only?
      @buffer.read_only=true
      assert @buffer.read_only?
    end

    def test_read_only_equals
      assert ! @buffer.read_only?
      @buffer.read_only=true
      assert @buffer.read_only?
      assert_raise Relisp::ElispError do
        @buffer.insert "A"
      end
      @buffer.read_only=false
      assert ! @buffer.read_only?
    end

    def test_kill
      assert @emacs.buffer_list.to_list.map {|b| b.name}.include?(@buffer.name)
      @buffer.insert "a"
      assert_raise RuntimeError do
        @buffer.kill
      end
      @buffer.modified=false
      @buffer.kill
      assert ! @emacs.buffer_list.to_list.map {|b| b.name}.include?(@buffer.name)
    end

    def test_kill_bang
      assert @emacs.buffer_list.to_list.map {|b| b.name}.include?(@buffer.name)
      @buffer.insert "a"
      assert @buffer.modified?
      assert_nothing_raised do
        @buffer.kill!
      end
    end

    def alive_eh?
      assert @buffer.alive
      @buffer.kill!
      assert ! @buffer.alive
    end

    def test_save
      string = "text to write to file"
      @buffer << string
      assert_raises RuntimeError do
        @buffer.save
      end
      file = Tempfile.new_path
      @buffer.filename = file
      @buffer.save
    end

    def test_write
      file = Tempfile.new_path
      string = "text to write to file"
      @buffer.insert string
      @buffer.write(file)
      assert ! @buffer.modified?
      assert_equal file, @buffer.filename
    end

    def test_size
      assert_equal 0, @buffer.size
      @buffer.insert "12345"
      assert_equal 5, @buffer.size
    end

    def test_substring
      
    end

    def test_substring_no_properties
      
    end

    def test_to_s
      assert_equal "", @buffer.to_s
      @buffer.insert "Some text"
      @buffer.insert "another line"
      assert_equal @buffer.to_s, "Some textanother line"
    end


  end

  class TestMarker < Test::Unit::TestCase
    def setup
      @emacs = EMACS
#      @emacs = Relisp::ElispSlave.new
    end

    def test_class_from_elisp
      assert_kind_of Relisp::Marker, @emacs.point_marker
      assert @emacs.elisp_eval( "(equal #{@emacs.point_marker.to_elisp} (point-marker))" )
      assert_kind_of Relisp::Marker, Relisp::Marker.new
    end

    def test_to_elisp
      assert_equal :marker, @emacs.elisp_eval( "(type-of #{@emacs.point_marker.to_elisp})" )
    end
  end

  class TestWindow < Test::Unit::TestCase
    @@emacs = EMACS

    def setup
      @emacs = @@emacs
#      @emacs = Relisp::ElispSlave.new
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
      @emacs = EMACS
    end

    def test_class_from_elisp
      assert_kind_of Relisp::WindowConfiguration, @emacs.current_window_configuration
    end
  end

  class TestProcess < Test::Unit::TestCase
    def setup
      @emacs = EMACS
    end
    
    def test_class_from_elisp
      assert_kind_of Relisp::Process, @emacs.start_process("test", "test", "ls")
    end

  end

  class TestOverlay < Test::Unit::TestCase
    def setup
      @emacs = Relisp::ElispSlave.new
    end
    
    def test_class_from_elisp
      @emacs.insert("sometext")
      assert_kind_of Relisp::Overlay,  @emacs.elisp_eval( "(make-overlay 1 3)")
    end

    def test_initialize
      @emacs.insert("sometext")
      new_overlay = Relisp::Overlay.new(1, 3)
      assert_kind_of Relisp::Overlay, new_overlay
      assert_equal :overlay,  @emacs.elisp_eval( "(type-of #{new_overlay.to_elisp})")
    end

  end

end

