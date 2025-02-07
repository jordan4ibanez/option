module option;

import std.exception;
import std.meta;
import std.stdio;

struct Option(T) {
protected:

    T data;
    bool isSome = true;

public:

    this(T newData) {
        enforce((is(typeof(newData) == Option!T)), "Do not instantiate Option with Option. Use Some or None.");

        static if (is(typeof(newData) == None)) {
            isSome = false;
        } else static if (is(typeof(newData) == Some!T)) {
            isSome = true;
            data = newData.data;
        }

        this.data = newData;
    }

    auto opAssign(T)(T value) {
        static if (is(typeof(value) == None)) {
            isSome = false;
        } else {
            data = value.data;
        }

        return this;
    }

    // I dunno how to automate this so, here you go.
    void match(void function(int data) @safe someMatch,
        void function() @safe noneMatch) {
        final switch (isSome) {
        case true: {
                someMatch(data);
            }
            break;
        case false: {
                noneMatch();
            }
        }
    }

}

struct Some(T) {
    Option!T some;
    alias some this;

    this(T newData) {
        this.data = newData;
    }
}

struct None {
}

unittest {

    import std.stdio;
    import std.conv;

    Option!int result;

    if (1) {
        result = Some!int(1);
    }

    result.match(
        (int data) { 
            writeln("noice " ~ to!string(result.unwrap())); 
            

            },
        () => throw new Error("uh oh")
    );

    result = None();

    result.match(
        (int data) => writeln("hi"),
        () => writeln("bye")
    );

    

}
