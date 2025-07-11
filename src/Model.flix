mod Model {
    pub enum RollingMethod {
        case Total, KeepHigh(Int32), KeepLow(Int32)
    }

    pub enum DiceSize {
        case Constant(Int32), Enumeration(List[Int32]), Range(Int32, Int32)
    }

    mod DiceSize {
        pub def length(ds: DiceSize): Int32 = match ds {
            case Constant(n) => n
            case Range(a, b) => (b - a) + 1
            case Enumeration(ns) => List.length(ns)
        }
    }

    pub enum Dice({count = Int32, method = RollingMethod, size = DiceSize})

    pub enum Value with ToString {
        case Dice(Dice), Flat(Int32)
    }

    pub enum Operator {
        case Add, Subtract
    }

    pub enum Expression({
        first = Value,
        rest = List[(Operator, Value)]
    })

    instance ToString[RollingMethod] {
        pub def toString(x: RollingMethod): String = match x {
            case RollingMethod.Total => ""
            case RollingMethod.KeepHigh(n) => "KH${n}"
            case RollingMethod.KeepLow(n) => "KL${n}"
        }    
    }
    
    instance ToString[DiceSize] {
        pub def toString(x: DiceSize): String = match x {
            case DiceSize.Constant(n) => Int32.toString(n)
            case DiceSize.Range(a, b) => "[${a}..${b}]"
            case DiceSize.Enumeration(ns) => region rc {
                let ans = ns |> List.map (Int32.toString) |> List.toArray(rc);
                let sb = StringBuilder.empty(rc);

                StringBuilder.append("[", sb);
                StringBuilder.intercalate(",", ans, sb);
                StringBuilder.append("]", sb);

                StringBuilder.toString(sb)
            }
        }
    }
    
    instance ToString[Dice] {
        pub def toString(x: Dice): String = 
            let Dice.Dice(d) = x;
            "${d#count}d${d#size}${d#method}"
    }

    instance ToString[Operator] {
        pub def toString(x: Operator): String = match x {
            case Operator.Add => "+"
            case Operator.Subtract => "-"
        }
    }

    instance ToString[Expression] {
        pub def toString(x: Expression): String = 
            let Expression.Expression({first, rest}) = x;
            let f: (String, (Operator, Value)) -> String = (acc, pair) -> "${acc} ${fst(pair)} ${snd(pair)}";
            List.foldLeft(f, ToString.toString(first), rest)
    }    
}