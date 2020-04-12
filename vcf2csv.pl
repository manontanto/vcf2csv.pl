#!/usr/bin/perl
#
# vcf2csv.pl | nkf -s > out.csv
# manontanto
#
$sourcefile = "vCard.vcf";
$seiyomi = $renmei = $memo = "";
$sei = $mei = $seimei = $pc = $jusho = "";

open(FILE, $sourcefile) || die "No data file(vCard.vcf).\n";
while(<FILE>) {
      s/\r\n/\n/g;      # CrLf->Lf
      s/\\n/ /g;        # Delete line feed in MemoField
      s/\\,/，/g;       # Delete comma in AddressField
      $seiyomi = $1 if /^X-PHONETIC-LAST-NAME:(.*)/;
      $renmei = $1 if /^item.\.X-ABRELATEDNAMES;type=pref:(.*)$/;
      $memo = $1 if /^NOTE:(.*)$/;
      if (/^N:(.*?);(.*?);;;.*?$/) {
            $sei = $1;
            $mei = $2;
            $seimei = "$1 $2";
      } elsif (/ADR;type=HOME.*?:;(.*?);(.*?);(.*?);(.*?);(.*?);.*$/) {
#        ADR;type=HOME;type=pref:;;;小金井市関野町2-2-7-105;;184-0001;
#  item1.ADR;type=HOME;type=pref:;サンフィールド;205貝沢町925-1;高崎市;;370-0042;
            $pc = $5;
            $jusho = "$4$3$2$1";
      } elsif (/^END:VCARD$/) {
            print "$seiyomi,$sei,$mei,$seimei,$pc,$jusho,$renmei,$memo\n";
            $seiyomi = $renmei = $memo = "";
            $sei = $mei = $seimei = $pc = $jusho = "";
      }
}
close(FILE);
