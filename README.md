A simple attempt to solve the "toy robot" exercise keeping complexity and dependencies to a minumum.

The only thing that need to be installed is rspec:

```
bundle install
```

.. after which you can run the tests:

```
bundle exec rspec
```

Pipe some test commands to the robot:

```
cat simple/commands.txt | ruby simple/robot.rb
```

