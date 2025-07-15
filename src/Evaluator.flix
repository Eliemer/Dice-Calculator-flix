mod Evaluator {

    type alias RollReport = { 
        diceExpression = String,
        diceResult = List[Int32],
        diceRolls = List[Int32]
    }

    pub enum EvaluatorReport({
        expression = String,
        total = Int32,
        result = List[RollReport]
    })

    def roll(val: Model.Value): RollReport \ Random =
        match val {
            case Model.Value.Flat(n) => 
                {
                    diceExpression = ToString.toString(val),
                    diceResult = List.point(n),
                    diceRolls = List.point(n)
                } |> eidentity
            case Model.Value.Dice(Model.Dice.Dice(d)) => 
                let rolls: List[Int32] = 
                    match d#size {
                        case Model.DiceSize.Constant(n) =>
                            List.range(0, d#count) |>
                            List.map (_x -> Random.randomInt32Between(1, n))
                        case Model.DiceSize.Range(a, b) =>
                            List.range(0, d#count) |>
                            List.map (_x -> Random.randomInt32Between(a, b))
                        case Model.DiceSize.Enumeration(ns) =>
                            match ns {
                                case Nil => List.empty()
                                case x :: xs => region rc {
                                    let tmp = List.toArray(rc, (x::xs));
                                    Random.shuffleArray(tmp);
                                    Array.toList(tmp)
                                }
                            }
                    };
                
                let result: List[Int32] = 
                    match d#method {
                        case Model.RollingMethod.Total => rolls
                        case Model.RollingMethod.KeepLow(n) => region rc {
                            let sorted = 
                                List.toArray(rc, rolls);
                            Array.sort(sorted);
                            Array.take(rc, n, sorted) |> 
                            Array.toList
                        }
                        case Model.RollingMethod.KeepHigh(n) => region rc {
                            let sorted = List.toArray(rc, rolls);
                            Array.sort(sorted);

                            let l = Array.length(sorted);
                            Array.drop(rc, l - n, sorted) |>
                            Array.toList
                        }
                    };

                {
                    diceExpression = ToString.toString(Model.Dice.Dice(d)),
                    diceResult = result,
                    diceRolls = rolls
                }
        }

    def folder (acc: EvaluatorReport, rest: (Model.Operator, Model.Value)): EvaluatorReport \ Random =
        let EvaluatorReport.EvaluatorReport(eReport) = acc;
        let (op, vexpr) = rest;
        let report = roll(vexpr);

        {
            result = report :: eReport#result,
            total = match op {
                case Model.Operator.Add => eReport#total + List.sum(report#diceResult)
                case Model.Operator.Subtract => eReport#total - List.sum(report#diceResult)
            },
            expression = "${eReport#expression} ${op} ${report#diceExpression}"
        } |> EvaluatorReport.EvaluatorReport

    pub def evaluate (expr: Model.Expression): EvaluatorReport \ Random =
        let Model.Expression.Expression(e) = expr;

        let init: EvaluatorReport = {
            let report: RollReport = roll(e#first);
            let evalReport = EvaluatorReport.EvaluatorReport({ 
                result = List.point(report), 
                total = List.sum (report#diceResult),
                expression = "${report#diceExpression}"
            });
            
            evalReport
        };
        
        List.foldLeft(folder, init, e#rest)
}