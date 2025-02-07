# option
 Option type for D

```D
void main() {
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


```


I stole this from rust.

![wat](https://media1.tenor.com/m/EF-qPwkqZgEAAAAC/evil-laugh-muahaha.gif)