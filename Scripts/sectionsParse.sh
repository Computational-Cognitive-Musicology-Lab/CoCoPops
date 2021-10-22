

for i in ../Humdrum/CompleteTranscriptions/*hum


do
echo "Working on "$(basename $i)

# When the melodic and harmonic transcriptions are merged, the completed transcription doesn't have *>section interpretaions correctly
# copied to every spine (because they aren't in the melodic files).
# This first awek command copies the first *>xxx token in any record onto all the earlier (Empty) ones.

awk '{
      if ($0 ~ /^\*/ && $0 ~ /\*>/) {
	      section = ""
	      i = 1
	      while (section == "") { 
		      if ($i ~ /\*>/) {
			      section = $i
		      }
		      i++
	      }

	      for (j = 1; j <= NF; j++) {
		      if ($j ~ /\*>/) {printf $j} else {printf section}
                      if (j != NF) printf("\t")
	      }
	      printf ORS
      }
      else {
	      print $0
      }
      }' $i > tmp.hum

awk '{
	if ($0 ~ /^\*>[A-K][^ea]/) {
                split($1, parts, "_")
		if (length(parts[1]) > 2) {
			for (i=1; i<=NF; i++) {
				printf("*>Letter>"substr(parts[1], 3))
				if (i != NF) printf("\t")
			}
		printf("\n")
		}
		if (length(parts[2]) > 0) {
			for (i=1; i<=NF; i++) {
				printf("*>Label>"toupper(substr(parts[2], 1, 1))substr(parts[2], 2))
				if (i != NF) printf("\t")
			}
		printf("\n")
		}

	}  else if($0 ~ /^\*>_/) {
		split($1, parts, "_")
		for (i = 1; i<=NF; i++) {
			printf("*>Label>>"toupper(substr(parts[2], 1, 1))substr(parts[2], 2))
			if (i != NF) printf("\t")
		}
		printf("\n")

	} else if($1 == "*>interlude") {
		for (i = 1; i<=NF; i++) {
			printf("*>Label>>Interlude")
			if (i != NF) printf("\t")
		}
		printf("\n")
		
	} else {
	print $0
	}	

	}' tmp.hum > ../Humdrum/CompleteTranscriptions/Tmp/$(basename $i)
done

rm tmp.hum
