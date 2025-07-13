mod Random {
    use Random.randomInt32Between
    pub def randomInt32Between(a: Int32, b: Int32): Int32 \ Random =
        let diff = b - a;
        let sample = 
            Float32.tryToInt32(Random.randomFloat32() * (Int32.toFloat32(diff))) |>
            Option.ap(Some(x -> x + a));

        match sample {
            case None => 0
            case Some(v) => v
        }

    pub def shuffleArray(xs: Array[a, r]): Unit \ {Random, r} with PartialOrder[a] = region rc {
        let iterations = Array.range(rc, 1, Array.length(xs));
        Array.reverse(iterations);

        foreach(i <- iterations)
            let j = randomInt32Between(0, i-1);
            Array.swap(i, j, xs);

        ()
    }
}