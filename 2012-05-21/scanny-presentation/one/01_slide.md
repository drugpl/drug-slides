!SLIDE 
# Scanny #
## Security scanner for RoR
### Piotr Niełacny

!SLIDE incremental bullets
# Scanny is... #
# not ready for production #

!SLIDE
# Thats why is part of
# GSoC 2012

!SLIDE center
# Organization
![open-suse-logo.png](open-suse-logo.png)

!SLIDE
# Mentor
![dm.jpg](dm.jpg)
## David Majda
## @dmajda

!SLIDE
# ror-sec-scanner
## Thomas Biege
### http://gitorious.org/code-scanner/ror-sec-scanner/

!SLIDE
# We have code
# So we need parser

!SLIDE bullets
# Create new one!

!SLIDE center
# parse_tree 
## 1.9? LOL
![lol.jpg](lol.jpg)

!SLIDE center
# ruby_parser
## sometimes reports wrong line numbers
![dont.jpg](dont.jpg)

!SLIDE center
# ruby2ruby
## use ruby_parser
![inc.png](inc.png)

!SLIDE
# Ripper
## usable but the generated AST is too low level

!SLIDE center
# Rubinius
![obv.jpg](obv.jpg)

!SLIDE small
# Rubinius
## String

      @@@ruby
        "string".to_ast

              Rubinius::AST::Send:0x1494 
              @line=1 
              @receiver=#<Rubinius::AST::Self:0x1498 @line=1> 
              @privately=true @check_for_local=false 
              @vcall_style=true 
              @name=:string 
              @block=nil> 

!SLIDE small
# Rubinius
## Fixnum

      @@@ruby
        '10'.to_ast

              Rubinius::AST::FixnumLiteral:0x1530 
              @line=1 
              @value=10

!SLIDE smaller
# Rubinius
## Method

      @@@ ruby
        "def method; end".to_ast 

        Rubinius::AST::Define:0x1594 
         @line=1 
         @body=#<Rubinius::AST::Block:0x1598 
          @line=1 
          @array=[
            Rubinius::AST::NilLiteral:0x15a0 @line=1>
          ] 
          @locals=nil> 
        @name=:method 
        @arguments=#<Rubinius::AST::FormalArguments:0x15ac 
          @line=1 
          @splat=nil 
          @defaults=nil 
          @required=[] 
          @block_arg=nil @
          names=[] 
          @optional=[]>> 

!SLIDE center
# Cool, but
![one.jpg](one.jpg)

!SLIDE center
# Scanny use **Machete**
![mach.jpg](mach.jpg)

!SLIDE center
# Scanny use **Machete**
![badass.png](badass.png)

!SLIDE
# Machete
## Machete is a simple tool for matching Rubinius AST nodes against patterns.
### https://github.com/openSUSE/machete

!SLIDE smaller
# How to use it?

      @@@ ruby
      'foo.bar'.to_ast

        Rubinius::AST::Send:0x1644 # bang
        @line=1 
        @receiver= # bang 
          #<Rubinius::AST::Send:0x1648 # bang
          @line=1 
          @receiver=
            #<Rubinius::AST::Self:0x164c  # bang
            @line=1> 
          @privately=true 
          @check_for_local=false 
          @vcall_style=true 
          @name=:foo # bang
          @block=nil> 
        @privately=false 
        @check_for_local=false 
        @vcall_style=false 
        @name=:bar # bang
        @block=nil> 

      Machete.matches?('foo.bar'.to_ast, 
      'Send<receiver = Send<receiver = Self, name = :foo>, name = :bar>')
      
      # => true

!SLIDE smaller 
# *.find* method
       @@@ ruby
        Machete.find('42 + 43 + 44'.to_ast, 'FixnumLiteral')
        # => [
        #      #<Rubinius::AST::FixnumLiteral:0x10b0 @value=44 @line=1>,
        #      #<Rubinius::AST::FixnumLiteral:0x10b8 @value=43 @line=1>,
        #      #<Rubinius::AST::FixnumLiteral:0x10c0 @value=42 @line=1>
        #    ]

!SLIDE
# Flow

1. Parse ruby code
2. Create Rubinius AST
3. Parse Machete language
4. Match patterns in Rubinius AST

!SLIDE center
![patt.jpg](patt.jpg)

!SLIDE smaller
# Scanny and new check

      @@@ruby
    class MyCheck < Check
     def pattern
      'Send<name = :boo | :moo> | SendWithArguments<name = :boo | :moo>'
     end

     def check(node)
      issue, :high,  "Problem with \"#{node.name}\"",
             :cwe => 999
     end
    end

!SLIDE
# CWE
## CVE Identifiers (also called "CVE names," "CVE numbers," "CVE-IDs," and "CVEs") are unique, common identifiers for publicly known information security vulnerabilities

!SLIDE bullets
* 79 Failure to Preserve Web Page Structure ('Cross-site Scripting')
* 362 Race Condition
* 764 Multiple Locks of a Critical Resource
* 685 Function Call With Incorrect Number of Arguments

!SLIDE bullets
# GSoC 2012 goals

* port perl scanner checks
* integrate with CI (travis, jenkins)
* pretty output
* any ideas?

!SLIDE
# Q & A
