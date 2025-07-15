def main(): Unit \ {IO, NonDet} =
    
    run {
        let expr = Model.Expression.Expression({
            first = Model.Value.Dice(Model.Dice.Dice({
                count = 4,
                method = Model.RollingMethod.KeepHigh(2),
                size = Model.DiceSize.Constant(20)
            })),
            rest = List.point((
                Model.Operator.Add,
                Model.Value.Flat(10)
            ))
        });

        let report = Evaluator.evaluate(expr);
        Console.printReport(report)

    } with Random.runWithIO
      with Console.runWithIO
