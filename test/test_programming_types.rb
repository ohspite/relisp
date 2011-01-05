# Code Generated by ZenTest v. 3.11.1

require 'test/unit' unless defined? $ZENTEST and $ZENTEST

$:.unshift File.dirname(__FILE__) + "/../lib" 
require 'relisp'

# when this elisp line:
### (eval (read (trim-trailing-whitespace relisp-ruby-return)))))
# was this (i.e., without the eval:
###       (read (trim-trailing-whitespace relisp-ruby-return))))
# this would return :hash-table':
### @emacs.elisp_eval( "(type-of #{hash.to_elisp})" )
# while this would return :cons':
### @emacs.elisp_eval( '(type-of (ruby-eval "hash"))' )
# So the second way needs to be included in testing.

EMACS = Relisp::ElispSlave.new unless defined? EMACS

class TestArray < Test::Unit::TestCase
  def setup
    @emacs = EMACS
#    @emacs = Relisp::ElispSlave.new
  end

  def test_class_from_elisp
    assert "if from_elisp works for Vector and List, then this works"
  end

  def test_class_default_elisp_type_equals
    assert_raise ArgumentError do
      Array.default_elisp_type = Fixnum
    end
    Array.default_elisp_type = Relisp::Vector    
    assert_equal Relisp::Vector, Array.default_elisp_type
    Array.default_elisp_type = Relisp::List
    assert_equal Relisp::List, Array.default_elisp_type
  end

  def test_to_elisp
    Array.default_elisp_type = Relisp::List
    assert_equal :cons, @emacs.elisp_eval( "(type-of #{[1, 2, 3].to_elisp})" )
    Array.default_elisp_type = Relisp::Vector
    assert_equal :vector, @emacs.elisp_eval( "(type-of #{[1, 2, 3].to_elisp})" )
  end

  def test_elisp_type
    array = [1, 2, 3]
    assert_equal Array.default_elisp_type, array.elisp_type
    assert_raise ArgumentError do
      array.elisp_type = Fixnum
    end
    array.elisp_type = Relisp::Vector
    assert_equal Relisp::Vector, array.elisp_type    
  end

  def test_elisp_type_equals
    Array.default_elisp_type = Relisp::List
    array = [1, 2, 3]
    assert_equal :cons, @emacs.elisp_eval( "(type-of #{array.to_elisp})" )
    array.elisp_type = Relisp::Vector
    assert_equal :vector, @emacs.elisp_eval( "(type-of #{array.to_elisp})" )
  end
end

class TestClass < Test::Unit::TestCase
  def test_to_elisp
    @emacs = EMACS
    assert_equal :Array, @emacs.elisp_eval('(ruby-eval "[1, 2].class")')
  end
end

class TestFalseClass < Test::Unit::TestCase
  def setup
    @emacs = Relisp::ElispSlave.new
  end

  def test_to_elisp
    assert @emacs.elisp_eval("(equal (equal 1 2) #{false.to_elisp})")
    assert @emacs.elisp_eval("(equal (equal 1 2) (ruby-eval \"false\"))")
  end
end

class TestNilClass < Test::Unit::TestCase
  def setup
    @emacs = EMACS
  end

  def test_class_from_elisp
    assert_nil @emacs.elisp_eval("(equal 1 2)")
  end

  def test_to_elisp
    assert @emacs.elisp_eval("(null #{nil.to_elisp})")
    assert @emacs.elisp_eval("(null (ruby-eval \"nil\"))")
  end
end

class TestObject < Test::Unit::TestCase
  def setup
    @emacs = EMACS
  end

  def test_class_from_elisp
    assert_nothing_raised { IO.from_elisp("blah", 2345) }
  end

  def test_to_elisp
    assert_nothing_raised { binding.to_elisp }
  end
end

class TestTrueClass < Test::Unit::TestCase
  def setup
    @emacs = EMACS
  end

  def test_to_elisp
    assert @emacs.elisp_eval( '(ruby-eval "true")' )
  end
end

module TestRelisp
  class TestCons < Test::Unit::TestCase
    def setup
      @emacs = EMACS
#      @emacs = Relisp::ElispSlave.new
    end

     def test_initialize
       new_cons = Relisp::Cons.new(4, 5, @emacs)
       assert_equal :cons, @emacs.type_of(new_cons)
       assert_equal 4, new_cons.car
       assert_equal 5, new_cons.cdr
     end

    def test_car
      result = @emacs.elisp_eval( "'(1 2 3)" )
      assert_equal 1, result.car
    end

    def test_car_equals
      result = @emacs.elisp_eval( "'(1 2 3)" )
      result.car = 2
      assert_equal 2, result.car
    end

    def test_cdr
      result = @emacs.elisp_eval( "'(1 2 3)" )
      assert_equal @emacs.elisp_eval( "'(2 3)" ).to_list, result.cdr.to_list
    end

    def test_cdr_equals
      result = @emacs.elisp_eval( "'(1 2 3)" )
      list = @emacs.elisp_eval( "'(2 3 4 5)" )
      result.cdr=list
      new_result = @emacs.elisp_eval( "'(1 2 3 4 5)" )
      assert_equal new_result.to_list, result.to_list
    end

    def test_list_eh
      result = @emacs.elisp_eval( "'(1 2 3)" )
      assert result.list?
      result = @emacs.elisp_eval( "'(1 . 2)" )      
      assert ! result.list?
    end

    def test_to_list
      result = @emacs.elisp_eval( "'(1 2 3)" ).to_list
      assert_equal [1, 2, 3], result
      result = @emacs.elisp_eval( "'(1 . 2)" )      
      assert_raise(RuntimeError) { result.to_list }
    end
  end

  class TestList < Test::Unit::TestCase
    def setup
      @emacs = EMACS
    end

    def test_class_from_elisp
      Array.default_elisp_type = Relisp::List
      result = @emacs.elisp_eval( "'(1 \"string\" 3 [4 5] )" ).to_list
      assert_kind_of Array, result
      assert_equal Relisp::List, result.class
      assert_equal "string", result[1]
      assert_equal [4, 5], result[3]
    end

    def test_to_elisp
      list = [1,2,'a',[4,5]]
      list.elisp_type = Relisp::List
      assert @emacs.elisp_eval( "(equal (list 1 2 \"a\" (list 4 5)) #{list.to_elisp})" )
      assert @emacs.elisp_eval( "(equal (list 1 2 \"a\" (list 4 5)) (ruby-eval \"[1, 2, 'a', [4, 5]]\"))" )
      assert_equal 1, @emacs.elisp_eval( "(car #{list.to_elisp})" )
    end
  end

  class TestFloat < Test::Unit::TestCase
    def setup
      @emacs = EMACS
    end

    def test_class_from_elisp
      assert_equal 2.5, @emacs.elisp_eval( "(/ 5.0 2)" )
    end

    def test_to_elisp
      assert @emacs.elisp_eval( "(equal -7.5 (* 3 #{-2.5.to_elisp}))" )
      assert @emacs.elisp_eval( '(equal -7.5 (* 3 (ruby-eval "-2.5")))' )
    end
  end

  class TestHashTable < Test::Unit::TestCase
    def setup
      @emacs = EMACS
      @emacs.elisp_exec( '(setq ht (make-hash-table))' )
      @emacs.elisp_exec( '(puthash "first" "john" ht)' )
      @emacs.elisp_exec( '(puthash \'last "doe" ht)' )
      @emacs.elisp_exec( '(setq subht (make-hash-table))' )
      @emacs.elisp_exec( '(puthash "first" "john" subht)' )
      @emacs.elisp_exec( '(puthash \'last "doe" subht)' )
      @emacs.elisp_exec( '(puthash \'sub subht ht)' )
    end

    def test_class_from_elisp
      hash = @emacs.elisp_eval( 'ht' )
      ruby_hash = Hash.new
      ruby_hash["first"] = 'john'
      ruby_hash[:last] = 'doe'
      copy = ruby_hash.dup
      ruby_hash[:sub] = copy
      assert_equal ruby_hash, hash
    end

    def test_to_elisp
      hash = @emacs.elisp_eval( 'ht' )
      ruby_hash = Hash.new
      ruby_hash["first"] = 'john'
      ruby_hash[:last] = 'doe'
      copy = ruby_hash.dup
      ruby_hash[:sub] = copy
      assert_equal hash, @emacs.elisp_eval( hash.to_elisp )
      @emacs.provide(:hash, binding)
      @emacs.elisp_eval( '(type-of (ruby-eval "hash"))' )
    end
  end

  class TestInteger < Test::Unit::TestCase
    def setup
      @emacs = EMACS
    end

    def test_class_from_elisp
      assert_equal 3, @emacs.elisp_eval( "(+ 1 2)" )
    end

    def test_to_elisp
      assert @emacs.elisp_eval( "(equal -2 (+ 1 #{-3.to_elisp}))"  )
      assert @emacs.elisp_eval( '(equal -2 (+ 1 (ruby-eval "-3")))'  )
    end
  end

  class TestString < Test::Unit::TestCase
    def setup
      @emacs = EMACS
    end

    def test_class_from_elisp
      assert_equal "String test", @emacs.elisp_eval( '(concat "String " "test")')
    end

    def test_to_elisp
      str = "a string\nwith two lines"
      assert @emacs.elisp_eval( "(equal \"a string\\nwith two lines\" #{str.to_elisp}  )" )
      @emacs.provide(:str, binding)
      assert @emacs.elisp_eval( "(equal \"a string\\nwith two lines\" (ruby-eval \"str\")  )" )
    end
  end

  class TestSymbol < Test::Unit::TestCase
    def setup
      @emacs = EMACS
    end

    def test_class_from_elisp
      assert_equal :+, @emacs.elisp_eval( "'+" )
      assert_nil @emacs.elisp_eval( 'nil' )
      assert_equal true, @emacs.elisp_eval( '(equal 1 1)' )
    end

    def test_to_elisp
      assert_equal 3, @emacs.elisp_eval( "(funcall #{:+.to_elisp} 1 2)" )
      assert_equal 3, @emacs.elisp_eval( "(#{:+} 1 2)" )
      assert @emacs.elisp_eval( "(equal '+ #{:+.to_elisp})" )
      assert @emacs.elisp_eval( "(equal '+ (ruby-eval \":+\"))" )
      assert @emacs.elisp_eval( "(null #{nil.to_elisp})" )
      assert @emacs.elisp_eval( "(null (ruby-eval \"nil\"))" )
      assert @emacs.elisp_eval( "(equal #{true.to_elisp} (equal 1 1))" )
      assert @emacs.elisp_eval( "(equal (ruby-eval \"true\") (equal 1 1))" )
    end
  end

  class TestVector < Test::Unit::TestCase
    def setup
      @emacs = EMACS
    end

    def test_class_from_elisp
      result = @emacs.elisp_eval( "[1 \"string\" 3 [\"sub\" \"array\" 5] ]" )
      assert result.kind_of?(Array) 
      assert_equal Relisp::Vector, result.class
      assert_equal "string", result[1]
      assert_equal ["sub", "array", 5], result[3]
    end

    def test_to_elisp
      vect = [1,2,'a',[4,5]]
      vect.elisp_type=Relisp::Vector
      assert @emacs.elisp_eval( "(equal [1 2 \"a\" (list 4 5)] #{vect.to_elisp})" )
      Array.default_elisp_type=Relisp::Vector
      assert @emacs.elisp_eval( "(equal [1 2 \"a\" [4 5]] #{vect.to_elisp})" )
      vect = (1..100).to_a
      assert_equal vect, @emacs.elisp_eval( vect.to_elisp )
      assert_equal vect, @emacs.elisp_eval( "(ruby-eval \"(1..100).to_a \")" )
    end
  end
end

