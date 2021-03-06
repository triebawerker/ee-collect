
require 'konfiguration'

class Regexp
  def Regexp.licensee_matcher(licensee)
    distributor_string = licensee
    if LICENSEE_TO_ILDA_DISTRIBUTOR_AUSNAHMEN.has_key? distributor_string
      distributor_string = LICENSEE_TO_ILDA_DISTRIBUTOR_AUSNAHMEN[distributor_string]
    end
    new( escape(distributor_string), IGNORECASE)
  end
  def Regexp.title_matcher(title_string)
    if FILM_TITLE_TO_ILDA_STIRNG_AUSNAHMEN.has_key? title_string
      title_string = FILM_TITLE_TO_ILDA_STIRNG_AUSNAHMEN[title_string]
    end
    match_string = escape(title_string.strip.gsub(/[.,]/,""))
    matcher_liste = %w[III|3 II|2 IV|4 VI|6 VII|7 V|5 vs|versus &|and ou|o ss|ß]+['(\\\\ |\\s)+']
    match_string = matcher_liste.inject(match_string) do |match_string, matcher|
      match_string.gsub(/#{matcher}/, "(#{matcher})")
    end
    new( "^\\s*#{match_string}\\s*$", IGNORECASE)
  end
end


def alle_licensees(basis_pfad)
  Dir.entries(basis_pfad).select {|dir_name| dir_name !~ /^(\.|ZZZ)/ and dir_name !~ /\.xls.+$/}
end