#Pfad in der EEAP
#REPORT_BASIS_PFAD = "O:/EEAP/REPORTING/Test - DISTRIBUTORS"

#Testpfad Uckermark
REPORT_BASIS_PFAD = "E:/Test - DISTRIBUTORS"


FILMSHEET_NAMEN_ERKENNUNGSZEICHEN = {
  "licensor_share_total" => {
    :zeile => [/Licensor Share Total/mi, /Licensor Final HE/mi],
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
