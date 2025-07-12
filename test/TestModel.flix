use Model.Dice.Dice
use Model.{RollingMethod, DiceSize}

// RollingMethod
@Test
def rollingMethodToStringTotal(): Bool =
    Assert.eq("", ToString.toString(RollingMethod.Total))

@Test
def rollingMethodToStringKeepHigh(): Bool =
    Assert.eq("KH12", ToString.toString(RollingMethod.KeepHigh(12)))
    
@Test
def rollingMethodToStringKeepLow(): Bool =
    Assert.eq("KL1234", ToString.toString(RollingMethod.KeepLow(1234)))

// DiceSize
@Test
def diceSizeToStringConstant(): Bool = 
    Assert.eq("123", ToString.toString(DiceSize.Constant(123)))

@Test
def diceSizeToStringRange(): Bool =
    Assert.eq("[1..10]", ToString.toString(DiceSize.Range(1, 10)))

@Test
def diceSizeToStringEnumeration(): Bool =
    Assert.eq("[1,3,5]", ToString.toString(DiceSize.Enumeration(List#{1, 3, 5})))

@Test
def diceSizeLengthConstant(): Bool =
    Assert.eq(12, DiceSize.length(DiceSize.Constant(12)))
    
@Test
def diceSizeLengthRange(): Bool = 
    // `DiceSize.Range` is inclusive
    Assert.eq(12, DiceSize.length(DiceSize.Range(11, 22)))

@Test
def diceSizeLengthEnumeration(): Bool =
    Assert.eq(12, DiceSize.length(DiceSize.Enumeration(List#{1,1,1,1,2,2,2,3,3,4,5,6})))
    
@Test
def diceToStringTotal(): Bool =
    Assert.eq("1d20", ToString.toString(
        Dice({ 
            count = 1, 
            method = RollingMethod.Total, 
            size = DiceSize.Constant(20)
        })
    ))

@Test
def diceToStringRange(): Bool =
    Assert.eq("4d[1..20]KH2", ToString.toString(
        Dice({
            count = 4,
            method = RollingMethod.KeepHigh(2),
            size = DiceSize.Range(1, 20)
        })
    ))

@Test
def diceToStringEnumeration(): Bool =
    Assert.eq("4d[1,3,5]KH2", ToString.toString(
        Dice({
            count = 4,
            method = RollingMethod.KeepHigh(2),
            size = DiceSize.Enumeration(List#{1,3,5})
        })
    ))
