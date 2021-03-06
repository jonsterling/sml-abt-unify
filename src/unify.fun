functor AbtUnify(Abt : ABT_UTIL) :>
        UNIFY
          where type t = Abt.t
          where type var = Abt.Variable.t =
struct
  type t = Abt.t
  type var = Abt.Variable.t

  structure MetaAbt = MetaAbt(Abt)
  open MetaAbt

  structure U = AbtUnifyOperators(structure A = AbtUtil(Meta)
                                  structure O = MetaOperator)

  exception Mismatch of A.t * A.t

  fun unify (l, r) =
    List.map (fn (v, e) => (v, unconvert e))
             (U.unify (convertFree l, convertFree r))
      handle U.Mismatch (l, r) => raise Mismatch (unconvert l, unconvert r)
  fun matches (l, r) =
    U.matches (convertFree l, convertFree r)
      handle U.Mismatch (l, r) => raise Mismatch (unconvert l, unconvert r)
end
