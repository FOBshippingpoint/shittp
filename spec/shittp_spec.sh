Include "./shittp"

Describe "msg()"

  It "print new line when no message is given"
    When call msg

    The output should equal ''
  End

  Context "when one message is given"
    Describe
      Parameters
        ''                                 ''
        'hello world'                      'hello world'
        '!"$%&()*+,-./:;<=>?@[\]^_`{|}~'   '!"$%&()*+,-./:;<=>?@[\]^_`{|}~'
      End

      It "print message"
        When call msg "$1"
        The output should equal "$2"
      End
    End
  End

  It "concat messages with whitespace and print"
    When call msg 'The' 'world' 'is' 'beautiful'
    The output should equal 'The world is beautiful'  
  End

  It "concat messages that contains whitespace and print"
    When call msg 'I have whitespaces' 'and so did you' 
    The output should equal 'I have whitespaces and so did you'
  End

End

Describe "die()"

  It "silently exit with status code 1"
    When run die
    The status should equal 1
  End
  Context "when message is given"
    Describe
      Parameters
        'abort'
        'unknown error'
      End

      It "prints message and exit with 1"
        When run die "$1"
        The output should equal "$1"
        The status should equal 1
      End
    End
  End

  Context "when message and exit code is given"
    Describe
      Parameters
        'General error'      '1'
        'Command not found'  '127'
        'Terminated'         '130'
      End

      It "prints message and exit with the code"
        When run die "$1" "$2"
        The output should equal "$1"
        The status should equal "$2"
      End
    End
  End

End

Describe "require()"

  Context "when dependency is given"
    Describe
      Parameters
        'sh'    success
        'find'  success
        'test'  success
      End

      It "checks command existence"
        When call require "$1"
        The status should be "$2"
      End
    End

    It "prints required command that does not exists"
      When call require 'nil'
      The status should be failure
      The output should include 'nil'
    End
  End

  Context "when multiple dependencies is given"
    It "checks all commands exist"
      When call require 'sh' 'find' 'test'
      The status should be success
    End

    It "prints required commands that does not exists"
      When call require 'sh' 'nil_1' 'test' 'nil_2'
      The status should be failure
      The line 1 of stdout should include 'nil_1' 
      The line 2 of stdout should include 'nil_2' 
    End
  End

End

Describe "quote()"

  Context "when variable name and value given"
    Describe
      Parameters
        'apple'      "A simple value"                               "'A simple value'"
        'banana'     '!"$%&()*+,-./:;<=>?@[\]^_`{|}~'               \''!"$%&()*+,-./:;<=>?@[\]^_`{|}~'\'
        'coconut'    "$(printf '%s\n%s' 'A multi-' 'line value')"   "$(printf "'%s\n%s'" 'A multi-' 'line value')"
        'dewberry'   'Single quote: '\''; Double quote: "'          \''Single quote: '\''\'\'\''; Double quote: "'\' 
      End

      It "assign well-quoted value to a parameter for eval"
        When call quote "$1" "$2"
        The variable "$1" should equal "$3"
        eval "result=\$$1"
        eval "result=$result"
        The variable result should equal "$2"
      End
    End
  End

End

Describe "dir_to_b64()"

  It "convert directory to gzipped Base64 string"
    When call dir_to_b64 "$SHELLSPEC_HELPERDIR/sample_dir"
    expected='H4sIAAAAAAAAA+3UQQrCMBCF4Vl7ipygzTRNc56kTVdCoer9bQVBBe0qFvH/NgNJYAYek6qW4uwieL9WDd4+1jtRr+qbYF1wy3lw1onx5UcTuZzOcTZG+v748d3W/Y+q6nGaCvdYA+7a9n3+2jznr8tZI8YWnuvmz/Pv45hNiikf9p4Ee6jqFOfCPbb3X1///9Cx/18x5DiknEfWHwAAAAAAAAAAAACA33UFGBsVOQAoAAA='
    The output should equal "$expected"
    tmpdir=$(mktemp -d)
    base64 -d <<EOF | tar zxf - -C "$tmpdir"
$expected
EOF
    The contents of file "$tmpdir/foo" should equal "$(cat "$SHELLSPEC_HELPERDIR/sample_dir/foo")"
    The contents of file "$tmpdir/bar" should equal "$(cat "$SHELLSPEC_HELPERDIR/sample_dir/bar")"
  End

End
