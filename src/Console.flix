mod Console {
    use Model.Value
    use Model.Expression.Expression
    use Model.Value;
    use Model.Expression;
    use Model.Operator;
    use Model.Dice;
    use Model.DiceSize;
    use Model.RollingMethod;

    use Evaluator.EvaluatorReport

    // def printRollingMethod(rm: RollingMethod): String = match rm {
    //     case RollingMethod.Total => "Total"
    //     case RollingMethod.KeepHigh(n) => "KeepHigh(${n})"
    //     case RollingMethod.KeepLow(n) => "KeepLow(${n})"
    // }

    // def printDiceSize(ds: DiceSize): String = match ds {
    //     case DiceSize.Constant(n) => "Constant(${n})"
    //     case DiceSize.Enumeration(ns) => "Enumeration(${ns})"
    //     case DiceSize.Range(a, b) => "Range(${a}, ${b})"
    // }

    // def printDice(dice: Dice): String =
    //     let Dice.Dice(d) = dice;
    //     "count: ${d#count}, method: ${printRollingMethod(d#method)}, size: ${printDiceSize(d#size)}"
    
    // def printValue(value: Value): String = match value {
    //     case Value.Flat(n) => "Flat(${n})"
    //     case Value.Dice(d) => printDice(d)
    // }

    // pub def printModel (expr: Expression) : Unit \ Console = region rc {
    //     let Expression(model) = expr;
    //     let sb = StringBuilder.empty(rc);
    //     let indent = "  ";

    //     StringBuilder.appendLines(Array#{
    //         "====",
    //         "Model Expression: ${expr}",
    //         "Expression:",
    //         indent + "first:",
    //         indent + indent + printValue(model#first)
    //     } @ rc, sb);

    //     Console.println(StringBuilder.toString(sb))
    // }

    pub def printReport (er: EvaluatorReport) : Unit \ Console = region rc {
        let EvaluatorReport.EvaluatorReport(report) = er;
        let sb = StringBuilder.empty(rc);
        let indent = "  ";
        
        // Summary
        StringBuilder.appendLines(Array#{
            "====",
            "Total: ${report#total}",
            "Input Expression: ${report#expression}",
            "Breakdown:"
        } @ rc, sb);

        // Breakdown per roll
        foreach (roll <- report#result) {
            let expr: String = indent + "'${roll#diceExpression}':";
            let total: String = indent + indent + "Total: ${roll#diceResult |> List.sum}";
            let diceRolls: String = {
                roll#diceRolls |>
                List.map(ToString.toString) |>
                String.intercalate(", ")
            };
            let diceResults: String = {
                roll#diceResult |>
                List.map(ToString.toString) |>
                String.intercalate(", ")
            };

            StringBuilder.appendLine(expr, sb);
            StringBuilder.appendLine(total, sb);

            StringBuilder.appendLine(indent + indent + "All rolls: [${diceRolls}]", sb);
            StringBuilder.appendLine(indent + indent + "Selected rolls: [${diceResults}]", sb);

            ()
        };

        StringBuilder.appendLine("====", sb);
        Console.println(StringBuilder.toString(sb))
    }
}