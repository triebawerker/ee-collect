#Pfad in der EEAP
#REPORT_BASIS_PFAD = "O:/EEAP/REPORTING/Test - DISTRIBUTORS"

#Testpfad Uckermark
REPORT_BASIS_PFAD = "E:/Test - DISTRIBUTORS"

LICENSEE_TO_ILDA_DISTRIBUTOR_AUSNAHMEN = {
  "BudFilm" => "Budapest Film",
}

FILM_TITLE_TO_ILDA_STIRNG_AUSNAHMEN = {
  "Knallhart" => "Tough enough",
  "1/2 Ritter" => "1/2 Knights",
  "Emmas Glück" => "Emma's Bliss",
  "7 Zwerge" => "Seven Dwarfs",
  "Barfuss" => "Barefoot",
  "Rouge Assasin" => "War",
  "Leatherface (TCM III)" => "LEATHERFACE: THE TEXAS CHAINSAW MASSACRE III",
  "Goodnight and Goodluck" => "GOOD NIGHT, AND GOOD LUCK",

}

FILMSHEET_NAMEN_ERKENNUNGSZEICHEN = {
  "licensor_share_total" => {
    :zeile => [/(Licensor|EEAP) (Share|Final) (Total|HE)/mi],
    :spalte => /Total\s+Licensor/mi
  },
  "currency" => {
    :zeile =>  /(^|[tT]otal.*)in ...$/m,
    :spalte => /Total\s+Licensor/mi
  },
  "title"    => {
    :zeile  => 0,
    :spalte => 0
  },
  "minimum_guarantee" => [{
    :zeile  => /^MG$/,
    :spalte => /Total\s+Licensor/mi,
  },{
    :zeile  => /^MG$/,
    :spalte => /\ATotal\Z/mi,
  }]
}

DISTRIBUTOR_KURZ_LANG =
  {
    :ACME => "ACME",
    :Palace => "Palace Cinemas Czech sro.",
    :Cinemania => "Cinemania druzba za filmsko tehnologijo d.o.o",
  }
