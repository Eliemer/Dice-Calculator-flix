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

        let Evaluator.EvaluatorReport.EvaluatorReport(report) = Evaluator.evaluate(expr);
        println("${report#expression} = ${report#total}\n\n${List.map(r -> r#diceRolls,report#result)}\n\n${List.map(r -> r#diceResult, report#result)}")
    } with Random.runWithIO
