@Test
def randInt32between0and0(): Bool \ {IO, NonDet} =
    run {
        Assert.eq(0, Random.randomInt32Between(0, 0))
    } with Random.runWithIO

@Test
def randInt32between0and1(): Bool \ {IO, NonDet} =
    run {
        Assert.eq(0,Random.randomInt32Between(0, 1))
    } with Random.runWithIO

@Test
def randInt32IsBetweenRange(): Bool \ {IO, NonDet} =
    run {
        let x = Random.randomInt32Between(1, 10);
        if (x < 1 or x >= 10) false else true
    } with Random.runWithIO

@Test
def shuffleSortReturnsSameArray(): Bool \ {IO, NonDet} =
    run {
        region rc {
            let x = Array.range(rc, 0, 100);
            let y = Array.range(rc, 0, 100);

            Random.shuffleArray(y);
            Array.sort(y);

            let xl = Array.toList(x);
            let yl = Array.toList(y);

            Assert.eq(xl, yl)
        }
    } with Random.runWithIO

@Test
def shuffleWithManualSeed(): Bool =
    run {
        region rc {
            let x = Array.range(rc, 0, 5);

            Random.shuffleArray(x);

            Assert.eq(List#{4,2,3,0,1}, x |> Array.toList)
        }
    } with Random.runWithSeed(1234i64)