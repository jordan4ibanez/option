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

        static if (is(typeof(newData) == Some!T)) {
            isSome = true;
            data = newData.data;
        }

        this.data = newData;
    }

    this(None!T none) {
    }

    auto opAssign(T)(T value) {
        static if (is(typeof(value) == None)) {
            isSome = false;
        } else {
            data = value.data;
        }

        return this;
    }

    void match(void delegate(T data) @safe someMatch,
        void delegate() @safe noneMatch) {
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

    T unwrap() {
        if (!isSome) {
            throw new Error("Unwrapped none.");
        }

        return data;
    }

    T expect(string customMessage) {
        if (!isSome) {
            throw new Error(customMessage);
        }

        return data;
    }

    T unwrapOr(T defaultValue) {
        if (!isSome) {
            return defaultValue;
        }

        return data;
    }

    T unwrapOrElse(T delegate() @safe alternativeToRun) {
        if (!isSome) {
            return alternativeToRun();
        }

        return data;
    }

}

struct Some(T) {
    Option!T option;
    alias option this;

    this(T newData) {
        this.data = newData;
    }
}

struct None(T) {
    Option!T option;
    alias option this;
}

unittest {

    import std.conv;
    import std.stdio;

    Option!int result;

    if (1) {
        result = Some!int(1);
    }

    result.match(
        (int data) { writeln("noice " ~ to!string(result.unwrap())); },
        () => throw new Error("uh oh")
    );

    result = None();

    result.match(
        (int data) => throw new Error("this should be none ahhh"),
        () => writeln("bye")
    );

    int testing = result.unwrapOrElse(
        () => 10);

    writeln(testing);

    Option!string ohNo() {
        import std.random;

        Option!string myCoolResult;

        auto rnd = Random(unpredictableSeed());
        if (uniform(0.0, 1.0, rnd) > 0.5) {
            myCoolResult = Some!string("I am a cool string. 8)");
        } else {
            myCoolResult = None();
        }

        return myCoolResult;
    }

    writeln(ohNo().unwrapOrElse(() {
            writeln("You blew it up ahhh.");
            return "I am a default string.";
        }));

}
