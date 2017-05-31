Fragment-rules ::=
{
   name "peptide-reagent-preparation",
   grow-directions {
      {
         name "forward",
                res-num-treatment increment,
         connectivities {
            {
               connect {from {"rpc1"}, to {"rpc2"}},
               new-bond {from {"rpc1"}, to {"rpc2"}},
            }
         },
         torsion-groups {
            {
               name "Joining_Geometry:",
               torsion-names {
                  {
                     name "omega",
                     torsion-atoms {
                        atom1 {which-fragment old, atom {""}},
                        atom2 {which-fragment old, atom {""}},
                        atom3 {which-fragment new, atom {""}},
                        atom4 {which-fragment new, atom {""}}
                     }
                  },
               },
               conformations {
                  {
                     name "anti",
                     torsion-values {
                     }
                  }
               }
            }
         }
      }
   },
   fragment-file "peptide-reagent-preparation.bld"
}
